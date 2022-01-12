Param (
    [string] $SettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json",
    [Parameter(ParameterSetName = "ProfileName")]
    [string[]] $ProfileName,
    [Parameter(ParameterSetName = "Default")]
    [switch] $ActivateForAllProfiles
)

begin {
    $settings = Get-Content $SettingsPath | ConvertFrom-Json
    $dracula = Get-Content "$PSScriptRoot\dracula.json" | ConvertFrom-Json
}
process {
    if ($settings.schemes.name -notcontains "Dracula") {
        $settings.schemes += $dracula
    }
    if ($ActivateForAllProfiles) {
        foreach ($profile in $settings.profiles.list) {            
            if ($profile.colorScheme) {
                $profile.colorScheme = "Dracula"
            }
            else {
                Add-Member -InputObject $profile -MemberType NoteProperty -Name colorScheme -Value "Dracula"
            }
        }
    }
    if ($ProfileName) {
        $profile = $settings.profiles.list | Where-Object {$_.name -eq $ProfileName}         
        if ($profile.colorScheme) {
            $profile.colorScheme = "Dracula"
        }
        else {
            Add-Member -InputObject $profile -MemberType NoteProperty -Name colorScheme -Value "Dracula"
        }
    }
}
end {
    $settings | ConvertTo-Json -Depth 10 | Out-File -FilePath $SettingsPath -Encoding utf8
}
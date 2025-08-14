# GetAll-FEVersions.ps1 (Modified to output a string)

try {
    Write-Host "🔎 Fetching all versions from the Fiddler Everywhere release history..."
    $url = "https://www.telerik.com/support/whats-new/fiddler-everywhere/release-history"
    $htmlContent = Invoke-RestMethod -Uri $url -Method Get
    $pattern = 'Fiddler Everywhere v(\d+\.\d+\.\d+)'
    $matches = [regex]::Matches($htmlContent, $pattern)

    if ($matches.Count -gt 0) {
        $allVersions = $matches.Groups[1].Value
        Write-Host "✅ Found $($allVersions.Count) versions."

        # --- THIS IS THE NEW PART ---
        # 1. Join the array of versions into a single comma-separated string.
        $versionsString = $allVersions -join ','

        # 2. If running in GitHub Actions, set the string as an output variable.
        if ($env:GITHUB_OUTPUT) {
            echo "versions_string=$versionsString" >> $env:GITHUB_OUTPUT
            Write-Host "🚀 Set versions_string output."
        } else {
            # If running locally, just display the versions.
            $allVersions
        }
    }
    else {
        throw "Could not find any version patterns in the page's HTML."
    }
}
catch {
    Write-Error $_.Exception.Message
    exit 1
}

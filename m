Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab0LHMeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 07:34:18 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:46742 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab0LHMeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 07:34:16 -0500
Date: Wed, 8 Dec 2010 13:34:14 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "Moore, Robert" <robert.moore@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Calvin Walton <calvin.walton@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Regression] 2.6.37-rc1: Lenovo T61 mute button does not work
Message-ID: <20101208123414.GA6902@ics.muni.cz>
References: <20101130185303.GI10354@ics.muni.cz>
 <1291172324.14274.33.camel@nayuki>
 <20101203141358.GA6936@ics.muni.cz>
 <1291599424.3688.0.camel@minggr.sh.intel.com>
 <20101206093158.GA15702@ics.muni.cz>
 <1291691967.3678.2.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1291691967.3678.2.camel@minggr.sh.intel.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 08 Dec 2010 13:34:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 11:19:27AM +0800, Lin Ming wrote:
> Would you please try below patch?

yes, the patch fixed my problem with the mute button. Thanks.
 
> Thanks.
> 
> ---
>  drivers/acpi/osl.c |   55 ++++++++++++++++++++++++++++++---------------------
>  1 files changed, 32 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 966fedd..f620689 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -152,8 +152,7 @@ static struct osi_linux {
>  	unsigned int	enable:1;
>  	unsigned int	dmi:1;
>  	unsigned int	cmdline:1;
> -	unsigned int	known:1;
> -} osi_linux = { 0, 0, 0, 0};
> +} osi_linux = {0, 0, 0};
>  
>  static u32 acpi_osi_handler(acpi_string interface, u32 supported)
>  {
> @@ -1055,18 +1054,25 @@ static int __init acpi_os_name_setup(char *str)
>  
>  __setup("acpi_os_name=", acpi_os_name_setup);
>  
> +static void __init osi_setup(char *str)
> +{
> +	if (str == NULL || *str == '\0') {
> +		printk(KERN_INFO PREFIX "_OSI method disabled\n");
> +		acpi_gbl_create_osi_method = FALSE;
> +	} else {
> +		strncpy(osi_setup_string, str, OSI_STRING_LENGTH_MAX);
> +	}
> +}
> +
>  static void __init set_osi_linux(unsigned int enable)
>  {
> -	if (osi_linux.enable != enable) {
> +	if (osi_linux.enable != enable)
>  		osi_linux.enable = enable;
> -		printk(KERN_NOTICE PREFIX "%sed _OSI(Linux)\n",
> -			enable ? "Add": "Delet");
> -	}
>  
>  	if (osi_linux.enable)
> -		acpi_osi_setup("Linux");
> +		osi_setup("Linux");
>  	else
> -		acpi_osi_setup("!Linux");
> +		osi_setup("!Linux");
>  
>  	return;
>  }
> @@ -1088,8 +1094,6 @@ void __init acpi_dmi_osi_linux(int enable, const struct dmi_system_id *d)
>  	if (enable == -1)
>  		return;
>  
> -	osi_linux.known = 1;	/* DMI knows which OSI(Linux) default needed */
> -
>  	set_osi_linux(enable);
>  
>  	return;
> @@ -1105,31 +1109,36 @@ void __init acpi_dmi_osi_linux(int enable, const struct dmi_system_id *d)
>  static void __init acpi_osi_setup_late(void)
>  {
>  	char *str = osi_setup_string;
> +	acpi_status status;
>  
>  	if (*str == '\0')
>  		return;
>  
> -	if (!strcmp("!Linux", str)) {
> -		acpi_cmdline_osi_linux(0);	/* !enable */
> -	} else if (*str == '!') {
> -		if (acpi_remove_interface(++str) == AE_OK)
> +	if (*str == '!') {
> +		status = acpi_remove_interface(++str);
> +
> +		if (ACPI_SUCCESS(status))
>  			printk(KERN_INFO PREFIX "Deleted _OSI(%s)\n", str);
> -	} else if (!strcmp("Linux", str)) {
> -		acpi_cmdline_osi_linux(1);	/* enable */
>  	} else {
> -		if (acpi_install_interface(str) == AE_OK)
> +		status = acpi_install_interface(str);
> +
> +		if (ACPI_SUCCESS(status))
>  			printk(KERN_INFO PREFIX "Added _OSI(%s)\n", str);
>  	}
>  }
>  
>  int __init acpi_osi_setup(char *str)
>  {
> -	if (str == NULL || *str == '\0') {
> -		printk(KERN_INFO PREFIX "_OSI method disabled\n");
> -		acpi_gbl_create_osi_method = FALSE;
> -	} else {
> -		strncpy(osi_setup_string, str, OSI_STRING_LENGTH_MAX);
> -	}
> +	/* kernel command line overrides DMI */
> +	osi_linux.dmi = 0;
> +	osi_linux.enable = 0;
> +
> +	if (str && !strcmp("Linux", str))
> +		acpi_cmdline_osi_linux(1);
> +	else if (str && !strcmp("!Linux", str))
> +		acpi_cmdline_osi_linux(0);
> +	else
> +		osi_setup(str);
>  
>  	return 1;
>  }
> 

-- 
Luká¹ Hejtmánek

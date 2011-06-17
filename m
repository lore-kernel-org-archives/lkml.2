Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378Ab1FQPmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 11:42:10 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:60318 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759299Ab1FQPmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 11:42:05 -0400
Date: Fri, 17 Jun 2011 17:41:43 +0200
From: Borislav Petkov <bp@amd64.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH 4/8] x86, mce: rename bootparam parser
Message-ID: <20110617154143.GC20010@aftab>
References: <4DFB1242.90404@jp.fujitsu.com>
 <4DFB13E2.4080909@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFB13E2.4080909@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 04:44:18AM -0400, Hidetoshi Seto wrote:
> Rename them with comprehensible prefix mcheck_setup.

The relocation is causing unneeded churn for no apparent reason.

> (at least it looks better than current misleading name)
> And relocate to put together setup codes.
> 
> 	Before:			After:
> 	 mcheck_enable		 mcheck_setup

Nah, let's call it mcheck_parse_boot_param...

> 	 mcheck_disable		 mcheck_setup_old

and leave this like this. "nomce" is the same as "mce=off" and frankly,
I'd like to remove this redundancy, thus no need to do the code
relocation. In addition, I don't think there are lots of systems running
with "nomce" so I really think we should drop it.

So Ingo, hpa, what is the proper way to remove early setup params? Maybe
through Documentation/feature-removal-schedule.txt?

> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   91 +++++++++++++++++++-------------------
>  1 files changed, 45 insertions(+), 46 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index c3dad64..ad0e9fb 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1662,50 +1662,6 @@ static struct miscdevice mce_chrdev_device = {
>  	&mce_chrdev_ops,
>  };
>  
> -/*
> - * mce=off Disables machine check
> - * mce=no_cmci Disables CMCI
> - * mce=dont_log_ce Clears corrected events silently, no log created for CEs.
> - * mce=ignore_ce Disables polling and CMCI, corrected events are not cleared.
> - * mce=TOLERANCELEVEL[,monarchtimeout] (number, see above)
> - *	monarchtimeout is how long to wait for other CPUs on machine
> - *	check, or 0 to not wait
> - * mce=bootlog Log MCEs from before booting. Disabled by default on AMD.

Please remove "Disabled by default on AMD." while you're at it, since
this is not true anymore.

> - * mce=nobootlog Don't log MCEs from before booting.
> - */
> -static int __init mcheck_enable(char *str)
> -{
> -	if (*str == 0) {
> -		enable_p5_mce();
> -		return 1;
> -	}
> -	if (*str == '=')
> -		str++;
> -	if (!strcmp(str, "off"))
> -		mce_disabled = 1;
> -	else if (!strcmp(str, "no_cmci"))
> -		mce_cmci_disabled = 1;
> -	else if (!strcmp(str, "dont_log_ce"))
> -		mce_dont_log_ce = 1;
> -	else if (!strcmp(str, "ignore_ce"))
> -		mce_ignore_ce = 1;
> -	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
> -		mce_bootlog = (str[0] == 'b');
> -	else if (isdigit(str[0])) {
> -		get_option(&str, &tolerant);
> -		if (*str == ',') {
> -			++str;
> -			get_option(&str, &monarch_timeout);
> -		}
> -	} else {
> -		printk(KERN_INFO "mce argument %s ignored. Please use /sys\n",
> -		       str);
> -		return 0;
> -	}
> -	return 1;
> -}
> -__setup("mce", mcheck_enable);
> -
>  int __init mcheck_init(void)
>  {
>  	mcheck_intel_therm_init();
> @@ -2120,14 +2076,57 @@ static __init int mcheck_init_device(void)
>  device_initcall(mcheck_init_device);
>  
>  /*
> + * mce=off Disables machine check
> + * mce=no_cmci Disables CMCI
> + * mce=dont_log_ce Clears corrected events silently, no log created for CEs.
> + * mce=ignore_ce Disables polling and CMCI, corrected events are not cleared.
> + * mce=TOLERANCELEVEL[,monarchtimeout] (number, see above)
> + *	monarchtimeout is how long to wait for other CPUs on machine
> + *	check, or 0 to not wait
> + * mce=bootlog Log MCEs from before booting. Disabled by default on AMD.
> + * mce=nobootlog Don't log MCEs from before booting.
> + */
> +static int __init mcheck_setup(char *str)
> +{
> +	if (*str == 0) {
> +		enable_p5_mce();
> +		return 1;
> +	}
> +	if (*str == '=')
> +		str++;
> +	if (!strcmp(str, "off"))
> +		mce_disabled = 1;
> +	else if (!strcmp(str, "no_cmci"))
> +		mce_cmci_disabled = 1;
> +	else if (!strcmp(str, "dont_log_ce"))
> +		mce_dont_log_ce = 1;
> +	else if (!strcmp(str, "ignore_ce"))
> +		mce_ignore_ce = 1;
> +	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
> +		mce_bootlog = (str[0] == 'b');
> +	else if (isdigit(str[0])) {
> +		get_option(&str, &tolerant);
> +		if (*str == ',') {
> +			++str;
> +			get_option(&str, &monarch_timeout);
> +		}
> +	} else {
> +		pr_info("mce argument %s ignored. Please use /sys\n", str);
> +		return 0;
> +	}
> +	return 1;
> +}
> +__setup("mce", mcheck_setup);
> +
> +/*
>   * Old style boot options parsing. Only for compatibility.
>   */
> -static int __init mcheck_disable(char *str)
> +static int __init mcheck_setup_old(char *str)
>  {
>  	mce_disabled = 1;
>  	return 1;
>  }
> -__setup("nomce", mcheck_disable);
> +__setup("nomce", mcheck_setup_old);
>  
>  #ifdef CONFIG_DEBUG_FS
>  struct dentry *mce_get_debugfs_dir(void)
> -- 
> 1.7.1
> 
> 
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

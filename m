Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab1LENSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:18:30 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:53915 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198Ab1LENS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:18:29 -0500
Date: Mon, 5 Dec 2011 14:18:25 +0100
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, H Peter Anvin <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <len.brown@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH] x86/mcheck/therm_throt.c: Don't log power limit and
 package level thermal throttle event in mce log
Message-ID: <20111205131825.GA31275@gere.osrc.amd.com>
References: <1321305082-31310-1-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321305082-31310-1-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks like a sane improvement, Tony I'm assuming you're handling this?

On Mon, Nov 14, 2011 at 01:11:22PM -0800, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Because of BIOS issues, some platforms report mce errors after power limit and
> thermal throttle events. Customers are concerned about the mce errors. Although
> BIOS need to fix the issues eventually, the events should not be viewed as mce
> errors in the first place.
> 
> This patch doesn't log power limit and package level thermal throttle events
> in mce log. When the events happen, only count them in respective counters in
> sysfs.
> 
> For legacy reason, core level thermal throttle is still logged in mce log and
> counted in counter in sysfs.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |   29 +++++++----------------------
>  1 files changed, 7 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> index 787e06c..ce04b58 100644
> --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> @@ -323,17 +323,6 @@ device_initcall(thermal_throttle_init_device);
>  
>  #endif /* CONFIG_SYSFS */
>  
> -/*
> - * Set up the most two significant bit to notify mce log that this thermal
> - * event type.
> - * This is a temp solution. May be changed in the future with mce log
> - * infrasture.
> - */
> -#define CORE_THROTTLED		(0)
> -#define CORE_POWER_LIMIT	((__u64)1 << 62)
> -#define PACKAGE_THROTTLED	((__u64)2 << 62)
> -#define PACKAGE_POWER_LIMIT	((__u64)3 << 62)
> -
>  static void notify_thresholds(__u64 msr_val)
>  {
>  	/* check whether the interrupt handler is defined;
> @@ -363,27 +352,23 @@ static void intel_thermal_interrupt(void)
>  	if (therm_throt_process(msr_val & THERM_STATUS_PROCHOT,
>  				THERMAL_THROTTLING_EVENT,
>  				CORE_LEVEL) != 0)
> -		mce_log_therm_throt_event(CORE_THROTTLED | msr_val);
> +		mce_log_therm_throt_event(msr_val);
>  
>  	if (this_cpu_has(X86_FEATURE_PLN))
> -		if (therm_throt_process(msr_val & THERM_STATUS_POWER_LIMIT,
> +		therm_throt_process(msr_val & THERM_STATUS_POWER_LIMIT,
>  					POWER_LIMIT_EVENT,
> -					CORE_LEVEL) != 0)
> -			mce_log_therm_throt_event(CORE_POWER_LIMIT | msr_val);
> +					CORE_LEVEL);
>  
>  	if (this_cpu_has(X86_FEATURE_PTS)) {
>  		rdmsrl(MSR_IA32_PACKAGE_THERM_STATUS, msr_val);
> -		if (therm_throt_process(msr_val & PACKAGE_THERM_STATUS_PROCHOT,
> +		therm_throt_process(msr_val & PACKAGE_THERM_STATUS_PROCHOT,
>  					THERMAL_THROTTLING_EVENT,
> -					PACKAGE_LEVEL) != 0)
> -			mce_log_therm_throt_event(PACKAGE_THROTTLED | msr_val);
> +					PACKAGE_LEVEL);
>  		if (this_cpu_has(X86_FEATURE_PLN))
> -			if (therm_throt_process(msr_val &
> +			therm_throt_process(msr_val &
>  					PACKAGE_THERM_STATUS_POWER_LIMIT,
>  					POWER_LIMIT_EVENT,
> -					PACKAGE_LEVEL) != 0)
> -				mce_log_therm_throt_event(PACKAGE_POWER_LIMIT
> -							  | msr_val);
> +					PACKAGE_LEVEL);
>  	}
>  }
>  
> -- 
> 1.6.0.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

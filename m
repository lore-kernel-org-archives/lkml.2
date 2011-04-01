Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab1DAGkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 02:40:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39712 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499Ab1DAGj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 02:39:59 -0400
Date: Fri, 1 Apr 2011 08:39:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2.6.39 & -stable] x86 intel power: Initialize
 MSR_IA32_ENERGY_PERF_BIAS
Message-ID: <20110401063952.GB7594@elte.hu>
References: <alpine.LFD.2.02.1104010156570.2797@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1104010156570.2797@x980>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> From: Len Brown <len.brown@intel.com>
> 
> Since 2.6.36 (23016bf0d25), Linux prints the existence of "epb" in /proc/cpuinfo,
> Since 2.6.38 (d5532ee7b40), the x86_energy_perf_policy(8) utility has
> been available in-tree to update MSR_IA32_ENERGY_PERF_BIAS.
> 
> However, the typical BIOS fails to initialize the MSR, presumably
> because this is handled by high-volume shrink-wrap operating systems...
> 
> Linux distros, on the other hand, do not yet invoke x86_energy_perf_policy(8).
> As a result, WSM-EP, SNB, and later hardware from Intel will run in its
> default hardware power-on state (performance), which assumes that users
> care for performance at all costs and not for energy efficiency.
> While that is fine for performance benchmarks, the hardware's intended default
> operating point is "normal" mode...
> 
> Initialize the MSR to the "normal" by default during kernel boot.
> 
> x86_energy_perf_policy(8) is available to change the default after boot,
> should the user have a different preference.
> 
> cc: stable@kernel.org
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  arch/x86/include/asm/msr-index.h |    3 +++
>  arch/x86/kernel/cpu/intel.c      |   14 ++++++++++++++
>  2 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 43a18c7..91fedd9 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -250,6 +250,9 @@
>  #define MSR_IA32_TEMPERATURE_TARGET	0x000001a2
>  
>  #define MSR_IA32_ENERGY_PERF_BIAS	0x000001b0
> +#define ENERGY_PERF_BIAS_PERFORMANCE	0
> +#define ENERGY_PERF_BIAS_NORMAL		6
> +#define ENERGY_PERF_BIAS_POWERSWAVE	15
>  
>  #define MSR_IA32_PACKAGE_THERM_STATUS		0x000001b1
>  
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index d16c2c5..48cca4a 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -448,6 +448,20 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
>  
>  	if (cpu_has(c, X86_FEATURE_VMX))
>  		detect_vmx_virtcap(c);
> +
> +	/*
> +	 * Initialize MSR_IA32_ENERGY_PERF_BIAS if BIOS did not.
> +	 * x86_energy_perf_policy(8) is available to change it at run-time
> +	 */
> +	if (cpu_has(c, X86_FEATURE_EPB)) {
> +		u64 epb;

This should be moved into a helper inline function, why complicate init_intel() 
with an open-coded workaround for a BIOS bug?

> +
> +		rdmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
> +		if ((epb & 0xF) == 0) {
> +			epb = (epb & ~0xF) | ENERGY_PERF_BIAS_NORMAL;

So we first check that the 0xf portion of ebp is zero, then when we mask out 
the 0xf portion - why? Something like this should be equivalent:

			epb |= ENERGY_PERF_BIAS_NORMAL;

> +			wrmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
> +		}
> +	}

Also, at minimum the kernel should printk a warning that the powersaving mode 
has been reduced from 'performance' (BIOS programmed default) to 'normal' 
(Intel intended default), and the message should also mention the specific 
utility that can be used to set it back to 'performance'.

We risk here people reporting performance regressions to us and they will have 
absolutely no chance to see what happened - the v2.6.39 kernel will just 
silently be slower for them.

Also, do distributions package tools/power/x86/x86_energy_perf_policy/ for easy 
access to developers? What if a user sets the BIOS to 'performance' explicitly 
(is this possible?) and *expects* Linux to boot up in fast mode?

Also, will BIOSes be fixed eventually?

Thanks,

	Ingo

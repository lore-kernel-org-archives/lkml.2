Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab1GNTe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 15:34:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54499 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412Ab1GNTeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 15:34:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH v2] x86 intel power: Initialize MSR_IA32_ENERGY_PERF_BIAS
Date: Thu, 14 Jul 2011 21:35:37 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>
References: <alpine.LFD.2.02.1103301819250.31342@x980> <4E1E106E.4060408@zytor.com> <alpine.LFD.2.02.1107140051020.18606@x980>
In-Reply-To: <alpine.LFD.2.02.1107140051020.18606@x980>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107142135.37330.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 14, 2011, Len Brown wrote:
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

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  arch/x86/include/asm/msr-index.h |    3 +++
>  arch/x86/kernel/cpu/intel.c      |   18 ++++++++++++++++++
>  2 files changed, 21 insertions(+), 0 deletions(-)
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
> index d16c2c5..7c1ca07 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -448,6 +448,24 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
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
> +
> +		rdmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
> +		if ((epb & 0xF) == 0) {
> +			printk_once(KERN_WARNING, "x86: updated energy_perf_bias"
> +				" to 'normal' from 'performance'\n"
> +				"You can view and update epb via utility,"
> +				" such as x86_energy_perf_policy(8)\n");
> +			epb = (epb & ~0xF) | ENERGY_PERF_BIAS_NORMAL;
> +			wrmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
> +		}
> +	}
>  }
>  
>  #ifdef CONFIG_X86_32
> 


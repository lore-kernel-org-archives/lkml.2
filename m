Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab0EKOg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:36:56 -0400
Received: from www.tglx.de ([62.245.132.106]:59435 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab0EKOgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:36:54 -0400
Date: Tue, 11 May 2010 16:36:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Alek Du <alek.du@intel.com>, Arjan van de Ven <arjan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Jacob Pan <jacob.jun.pan@intel.com>
Subject: Re: [PATCH 4/8] x86/mrst: change clock selection logic to support
 medfield
In-Reply-To: <1273254108-3234-5-git-send-email-jacob.jun.pan@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1005111546260.3401@localhost.localdomain>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com> <1273254108-3234-5-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 May 2010, Jacob Pan wrote:

> From: Jacob Pan <jacob.jun.pan@intel.com>
> 
> Penwell has added always on lapic timers and tsc, we want to treat
> it as a variant of moorestown so that one binary kernel can boot on both.
> this patch added clock selction logic so that platform code can set up the
> optimal configuration for both moorestown and medfield.
> 
> This patch will also mark Penwell TSC reliable, thus no need for
> watchdog clocksource to monitor it.
> 
> Signed-off-by: Alek Du <alek.du@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  arch/x86/include/asm/mrst.h |   30 +++++++++++
>  arch/x86/kernel/mrst.c      |  119 ++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 137 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
> index 451d30e..3054407 100644
> --- a/arch/x86/include/asm/mrst.h
> +++ b/arch/x86/include/asm/mrst.h
> @@ -11,7 +11,37 @@
>  #ifndef _ASM_X86_MRST_H
>  #define _ASM_X86_MRST_H
>  extern int pci_mrst_init(void);
> +extern unsigned int calibration_result;

Yuck, why is this in a mrst specific header ?

> +
> +#define MRST_TIMER_DEFAULT	0
> +#define MRST_TIMER_APBT_ONLY	1
> +#define MRST_TIMER_LAPIC_APBT	2

enum please, also 

> +/**
> + * the clockevent devices on Moorestown/Medfield can be APBT or LAPIC clock,
> + * cmdline option x86_mrst_timer can be used to override the configuration
> + * to prefer one or the other.
> + * at runtime, there are basically three timer configurations:
> + * 1. per cpu apbt clock only
> + * 2. per cpu always-on lapic clocks only, this is Penwell/Medfield only
> + * 3. per cpu lapic clock (C3STOP) and one apbt clock, with broadcast.
> + *
> + * by default (without cmdline option), platform code first detects cpu type
> + * to see if we are on lincroft or penwell, then set up both lapic or apbt
> + * clocks accordingly.
> + * i.e. by default, medfield uses configuration #2, moorestown uses #1.
> + * config #3 is supported but not recommended on medfield.
> + *
> + * rating and feature summary:
> + * lapic (with C3STOP) --------- 100
> + * apbt (always-on) ------------ 110

 apbt sucks performance wise, so why do you consider it a better
 choice than lapic + broadcast ?

> + * lapic (always-on,ARAT) ------ 150
> + */
> +
> +int mrst_timer_options __cpuinitdata;
> +
>  static u32 sfi_mtimer_usage[SFI_MTMR_MAX_NUM];
>  static struct sfi_timer_table_entry sfi_mtimer_array[SFI_MTMR_MAX_NUM];
> +static u32 mrst_cpu_chip;
>  int sfi_mtimer_num;
>  
>  struct sfi_rtc_table_entry sfi_mrtc_array[SFI_MRTC_MAX];
> @@ -167,15 +191,16 @@ int __init sfi_parse_mrtc(struct sfi_table_header *table)
>  	return 0;
>  }
>  
> -/*
> - * the secondary clock in Moorestown can be APBT or LAPIC clock, default to
> - * APBT but cmdline option can also override it.
> - */
>  static void __cpuinit mrst_setup_secondary_clock(void)
>  {
> -	/* restore default lapic clock if disabled by cmdline */
> -	if (disable_apbt_percpu)
> -		return setup_secondary_APIC_clock();
> +	if ((mrst_timer_options == MRST_TIMER_APBT_ONLY))
> +		return apbt_setup_secondary_clock();
> +	if (cpu_has(&current_cpu_data, X86_FEATURE_ARAT)
> +		||  (mrst_timer_options == MRST_TIMER_LAPIC_APBT)) {
> +		pr_info("using lapic timers for secondary clock\n");
> +		setup_secondary_APIC_clock();
> +		return;

  The logic is confusing. 

> +	}
>  	apbt_setup_secondary_clock();
>  }
>  
> @@ -183,9 +208,45 @@ static unsigned long __init mrst_calibrate_tsc(void)
>  {
>  	unsigned long flags, fast_calibrate;
>  
> -	local_irq_save(flags);
> -	fast_calibrate = apbt_quick_calibrate();
> -	local_irq_restore(flags);
> +	if (mrst_cpu_chip == MRST_CPU_CHIP_PENWELL) {
> +		u32 lo, hi, ratio, fsb;
> +
> +		rdmsr(MSR_IA32_PERF_STATUS, lo, hi);
> +		pr_debug("IA32 perf status is 0x%x, 0x%0x\n", lo, hi);
> +		ratio = (hi >> 8) & 0x1f;
> +		pr_debug("ratio is %d\n", ratio);
> +		if (!ratio) {
> +			pr_err("read a zero ratio, should be incorrect!\n");
> +			pr_err("force tsc ratio to 16 ...\n");
> +			ratio = 16;
> +		}

 This is not Penwell specific at all. The ratio can be read out on all
 Core based CPUs either from MSR_PLATFORM_ID[12:8] or
 MSR_PERF_STAT[44:40] depending on XE operation enabled
 (MSR_PERF_STAT[31] == 1)

 This should be made general available and not burried into the mrst
 code.

> +		rdmsr(MSR_FSB_FREQ, lo, hi);
> +		if ((lo & 0x7) == 0x7)
> +			fsb = PENWELL_FSB_FREQ_83SKU;
> +		else
> +			fsb = PENWELL_FSB_FREQ_100SKU;

 I guess the 111 is Penwell/MRST specific, right ?

 According to SDM we have anyway different results for the various CPU
 families, but we should utilize this in a generic way and have the
 translation tables for the various CPUs in one place.

> +		fast_calibrate = ratio * fsb;
> +		pr_debug("read penwell tsc %lu khz\n", fast_calibrate);
> +		calibration_result = fsb * 1000 / HZ;
> +		/* mark tsc clocksource as reliable */
> +		set_cpu_cap(&boot_cpu_data, X86_FEATURE_TSC_RELIABLE);
> +	} else {
> +		/**
> +		 * TODO: calibrate lapic timer with apbt, if we use apbt only,
> +		 * there is no need to calibrate lapic timer, since they are
> +		 * not used.
> +		 * if we use lapic timers and apbt, the default calibration
> +		 * should work, since we have the global clockevent setup.
> +		 * but it would be more efficient if we combine the lapic timer
> +		 * with tsc calibration.
> +		 */
> +		local_irq_save(flags);
> +		fast_calibrate = apbt_quick_calibrate();
> +		local_irq_restore(flags);
> +	}
> +
> +	pr_info("tsc lapic calibration results %lu %d\n",
> +			fast_calibrate, calibration_result);
>  
>  	if (fast_calibrate)
>  		return fast_calibrate;
> @@ -195,6 +256,11 @@ static unsigned long __init mrst_calibrate_tsc(void)
>  
>  void __init mrst_time_init(void)
>  {
> +	/* if cpu is penwell, lapic timer will be used by default */
> +	if ((mrst_cpu_chip == MRST_CPU_CHIP_PENWELL) &&
> +		(mrst_timer_options == MRST_TIMER_DEFAULT))
> +		return;
> +
>  	sfi_table_parse(SFI_SIG_MTMR, NULL, NULL, sfi_parse_mtmr);
>  	pre_init_apic_IRQ0();
>  	apbt_time_init();
> @@ -211,11 +277,38 @@ void __init mrst_rtc_init(void)
>   */
>  static void __init mrst_setup_boot_clock(void)
>  {
> -	pr_info("%s: per cpu apbt flag %d \n", __func__, disable_apbt_percpu);
> -	if (disable_apbt_percpu)
> +	if (mrst_timer_options == MRST_TIMER_APBT_ONLY)
> +		return;
> +	if ((mrst_timer_options == MRST_TIMER_LAPIC_APBT)
> +		|| (mrst_cpu_chip == MRST_CPU_CHIP_PENWELL))
>  		setup_boot_APIC_clock();
>  };
>  
> +enum cpuid_regs {
> +	CR_EAX = 0,
> +	CR_ECX,
> +	CR_EDX,
> +	CR_EBX
> +};
> +
> +int mrst_identify_cpu(void)
> +{
> +	u32 regs[4];
> +
> +	cpuid(1, &regs[CR_EAX], &regs[CR_EBX], &regs[CR_ECX], &regs[CR_EDX]);

  Yikes. From which Intel cookbook is this ?

  Aside of that we have that info in boot_cpu_info already, don't we ?
  So there is neither a requirement for the extra cpuid call nor for
  the extra mrst_cpu_chip id magic.

> +	if ((regs[CR_EAX] & PENWELL_FAMILY) == PENWELL_FAMILY)
> +		mrst_cpu_chip = MRST_CPU_CHIP_PENWELL;
> +	else
> +		mrst_cpu_chip = MRST_CPU_CHIP_LINCROFT;


> +	pr_debug("cpuid result %x\n", regs[CR_EAX]);
> +	pr_info("Moorestown CPU %s identified\n",
> +		(mrst_cpu_chip == MRST_CPU_CHIP_LINCROFT) ?
> +		"Lincroft" : "Penwell");

  Are we going to add one of those for each new family ? This is
  really redundant bloat with no value.

> +	return mrst_cpu_chip;
> +}
> +
>  /*
>   * Moorestown specific x86_init function overrides and early setup
>   * calls.
> @@ -237,4 +330,6 @@ void __init x86_mrst_early_setup(void)
>  	x86_init.pci.fixup_irqs = x86_init_noop;
>  
>  	legacy_pic = &null_legacy_pic;
> +
> +	mrst_identify_cpu();
>  }
> -- 
> 1.6.3.3
> 

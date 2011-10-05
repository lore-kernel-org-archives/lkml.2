Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934730Ab1JETNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:13:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:34342 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934227Ab1JETNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:13:41 -0400
Date: Wed, 5 Oct 2011 21:13:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fenghua Yu <fenghua.yu@intel.com>
cc: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <lenb@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] x86, common.c, smpboot.c: Init BSP during BSP online
 and don't offline BSP if irq is bound to it
In-Reply-To: <1317832759-10223-6-git-send-email-fenghua.yu@intel.com>
Message-ID: <alpine.LFD.2.02.1110052054040.18778@ionos>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com> <1317832759-10223-6-git-send-email-fenghua.yu@intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Oct 2011, Fenghua Yu wrote:

> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> During BSP online, enable x2apic and initialize BSP. Don't offline BSP if
> any irq is bound to it.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/include/asm/processor.h |    1 +
>  arch/x86/kernel/cpu/common.c     |   13 ++++++++++---
>  arch/x86/kernel/smpboot.c        |   38 +++++++++++++++++++++++++++++++-------
>  3 files changed, 42 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index 0d1171c..d648cae 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -161,6 +161,7 @@ extern struct pt_regs *idle_regs(struct pt_regs *);
>  
>  extern void early_cpu_init(void);
>  extern void identify_boot_cpu(void);
> +extern void identify_boot_cpu_online(void);
>  extern void identify_secondary_cpu(struct cpuinfo_x86 *);
>  extern void print_cpu_info(struct cpuinfo_x86 *);
>  extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 6218439..2ceefb9 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -911,6 +911,14 @@ void __init identify_boot_cpu(void)
>  #endif
>  }
>  
> +void __cpuinit identify_boot_cpu_online(void)
> +{
> +	numa_add_cpu(smp_processor_id());
> +#ifdef CONFIG_X86_32
> +	enable_sep_cpu();
> +#endif

Why this change? This has nothing to do with the changelog. And we
have 3 other call sites for enable_sep_cpu().

> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 9f548cb..cdfa425 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -50,6 +50,7 @@
>  #include <linux/tboot.h>
>  #include <linux/stackprotector.h>
>  #include <linux/gfp.h>
> +#include <linux/kernel_stat.h>

What is this include for?
  
>  #include <asm/acpi.h>
>  #include <asm/desc.h>
> @@ -136,8 +137,8 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
>  atomic_t init_deasserted;
>  
>  /*
> - * Report back to the Boot Processor.
> - * Running on AP.
> + * Report back to the Boot Processor during boot time or to the caller processor
> + * during CPU online.
>   */
>  static void __cpuinit smp_callin(void)
>  {
> @@ -224,6 +225,13 @@ static void __cpuinit smp_callin(void)
>  	smp_store_cpu_info(cpuid);
>  
>  	/*
> +	 * This function won't run on the BSP during boot time. It run
> +	 * on BSP only when BSP is offlined and onlined again.
> +	 */
> +	if (cpuid == 0)
> +		identify_boot_cpu_online();

Again, what's the point? numa_add_cpu() is called in identify_cpu()
already and you just added that crap here because you failed to fix
smp_store_cpu_info(). That whole patch set is just a sloppy hack which
leaves tons of cpu0 assumptions all over the place instead of cleaning
them up completely.

> +	if (cpu == 0) {
> +		int i;
> +		for (i = 0; i < NR_IRQS; i++) {
> +			struct irq_desc *desc = irq_to_desc(i);
> +
> +			if (!desc)
> +				continue;
> +
> +			if (irqd_irq_disabled(&desc->irq_data))
> +				continue;
> +
> +			if (!irq_can_set_affinity(i)) {
> +				pr_debug("irq%d can't move out of BSP\n", i);
> +				return -EBUSY;
> +			}

This is just disgusting.

Have you ever looked at other code which iterates over the interrupt
descriptors and if yes have you noticed that all that code uses
iterator functions for a fcking good reason? Hint SPARSE_IRQ

What gives you the guarantee that the interrupt is not going to be
enabled right after you offlined the cpu? Do you really think that
chekcing whether the interrupt is disabled is sufficient ????

Is there any guarantee, that an interrupt which is currently not
assigned is going to be requested after you offlined cpu0 ?

We know upfront whether we are using interrupt chips which are not
capable of irq affinity settings. So why the hell do you want to poke
in the interrupt descriptors?

Thanks,

	tglx

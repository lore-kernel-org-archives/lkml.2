Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab0LHPWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 10:22:07 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42612 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab0LHPWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 10:22:06 -0500
Date: Wed, 8 Dec 2010 15:21:42 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jeff Ohlstein <johlstei@codeaurora.org>
Cc: Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Steve Muckle <smuckle@codeaurora.org>
Subject: Re: [PATCH v2 6/6] msm: add SMP support for msm
Message-ID: <20101208152142.GH9777@n2100.arm.linux.org.uk>
References: <1291782501-3909-1-git-send-email-johlstei@codeaurora.org> <1291782501-3909-7-git-send-email-johlstei@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291782501-3909-7-git-send-email-johlstei@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 08:28:21PM -0800, Jeff Ohlstein wrote:
> Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
> ---
>  arch/arm/mach-msm/Kconfig            |    1 +
>  arch/arm/mach-msm/Makefile           |    1 +
>  arch/arm/mach-msm/headsmp.S          |   43 ++++++++++
>  arch/arm/mach-msm/include/mach/smp.h |    2 +
>  arch/arm/mach-msm/platsmp.c          |  146 ++++++++++++++++++++++++++++++++++
>  5 files changed, 193 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-msm/headsmp.S
>  create mode 100644 arch/arm/mach-msm/platsmp.c
> 
> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> index ab5338f..8c57425 100644
> --- a/arch/arm/mach-msm/Kconfig
> +++ b/arch/arm/mach-msm/Kconfig
> @@ -40,6 +40,7 @@ config ARCH_MSM8X60
>  	bool "MSM8X60"
>  	select MACH_MSM8X60_SURF if (!MACH_MSM8X60_RUMI3 && !MACH_MSM8X60_SIM \
>  				  && !MACH_MSM8X60_FFA)
> +	select ARCH_MSM_SCORPIONMP
>  	select ARM_GIC
>  	select CPU_V7
>  	select MSM_V2_TLMM
> diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
> index 7a11b4a..1945f9c 100644
> --- a/arch/arm/mach-msm/Makefile
> +++ b/arch/arm/mach-msm/Makefile
> @@ -21,6 +21,7 @@ obj-$(CONFIG_MSM_SMD) += last_radio_log.o
>  obj-$(CONFIG_MSM_SCM) += scm.o scm-boot.o
>  
>  obj-$(CONFIG_HOTPLUG_CPU) += hotplug.o
> +obj-$(CONFIG_SMP) += headsmp.o platsmp.o
>  
>  obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o devices-msm7x00.o
>  obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o devices-msm7x00.o
> diff --git a/arch/arm/mach-msm/headsmp.S b/arch/arm/mach-msm/headsmp.S
> new file mode 100644
> index 0000000..438cfeb
> --- /dev/null
> +++ b/arch/arm/mach-msm/headsmp.S
> @@ -0,0 +1,43 @@
> +/*
> + *  Copyright (c) 2003 ARM Limited
> + *  All Rights Reserved
> + *  Copyright (c) 2010, Code Aurora Forum. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#include <linux/linkage.h>
> +#include <linux/init.h>
> +
> +/*
> + * MSM specific entry point for secondary CPUs.  This provides
> + * a "holding pen" into which all secondary cores are held until we're
> + * ready for them to initialise.
> + *
> + * This is executing in physical space with cache's off.
> + */
> +ENTRY(msm_secondary_startup)
> +	mrc	p15, 0, r0, c0, c0, 5 	@ MPIDR
> +	and	r0, r0, #15		@ What CPU am I
> +	adr	r4, 1f			@ address of
> +	ldmia	r4, {r5, r6}		@ load curr addr and pen_rel addr
> +	sub	r4, r4, r5		@ determine virtual/phys offsets
> +	add	r6, r6, r4		@ apply
> +pen:
> +	wfe
> +	dsb				@ ensure subsequent access is
> +					@ after event
> +
> +	ldr	r7, [r6]		@ pen_rel has cpu to remove from reset
> +	cmp	r7, r0			@ are we lucky?
> +	bne	pen
> +
> +	/*
> +	 * we've been released from the holding pen: secondary_stack
> +	 * should now contain the SVC stack for this core
> +	 */
> +	b	secondary_startup
> +
> +1:	.long	.
> +	.long	pen_release
> diff --git a/arch/arm/mach-msm/include/mach/smp.h b/arch/arm/mach-msm/include/mach/smp.h
> index 3ff7bf5..79f94b0 100644
> --- a/arch/arm/mach-msm/include/mach/smp.h
> +++ b/arch/arm/mach-msm/include/mach/smp.h
> @@ -36,4 +36,6 @@ static inline void smp_cross_call(const struct cpumask *mask)
>  	gic_raise_softirq(mask, 1);
>  }
>  
> +extern int pen_release;
> +extern void msm_secondary_startup(void);
>  #endif
> diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
> new file mode 100644
> index 0000000..0ab2bba
> --- /dev/null
> +++ b/arch/arm/mach-msm/platsmp.c
> @@ -0,0 +1,146 @@
> +/*
> + *  Copyright (C) 2002 ARM Ltd.
> + *  All Rights Reserved
> + *  Copyright (c) 2010, Code Aurora Forum. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/cpumask.h>
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +
> +#include <asm/hardware/gic.h>
> +#include <asm/cacheflush.h>
> +#include <asm/mach-types.h>
> +
> +#include <mach/smp.h>
> +#include <mach/msm_iomap.h>
> +
> +#include "scm-boot.h"
> +
> +#define SECONDARY_CPU_WAIT_MS 10
> +
> +#define VDD_SC1_ARRAY_CLAMP_GFS_CTL 0x15A0
> +#define SCSS_CPU1CORE_RESET 0xD80
> +#define SCSS_DBG_STATUS_CORE_PWRDUP 0xE64
> +
> +int pen_release = -1;
> +
> +int get_core_count(void)
> +{
> +#ifdef CONFIG_NR_CPUS
> +	return CONFIG_NR_CPUS;
> +#else
> +	return 1;
> +#endif

When would CONFIG_NR_CPUS not be set when SMP is available?

Note that linux/threads.h defines this to 1 if it's not already defined
anyway.  Does this really need to be a separate function?

> +}
> +
> +/* Initialize the present map (set_cpu_present(i, true)). */
> +void smp_prepare_cpus(unsigned int max_cpus)
> +{
> +	int i;
> +	unsigned int cpu = smp_processor_id();
> +
> +	smp_store_cpu_info(cpu);
> +
> +	for (i = 0; i < max_cpus; i++)
> +		set_cpu_present(i, true);
> +}
> +
> +void smp_init_cpus(void)
> +{
> +	unsigned int i, ncores = get_core_count();
> +
> +	for (i = 0; i < ncores; i++)
> +		set_cpu_possible(i, true);
> +}
> +
> +static void prepare_cold_cpu(unsigned int cpu)
> +{
> +	int ret;
> +	ret = scm_set_boot_addr((void *)
> +				virt_to_phys(msm_secondary_startup),
> +				SCM_FLAG_COLDBOOT_CPU1);
> +	if (ret == 0) {
> +		void *sc1_base_ptr;
> +		sc1_base_ptr = ioremap_nocache(0x00902000, SZ_4K*2);
> +		if (sc1_base_ptr) {
> +			writel(0, sc1_base_ptr + VDD_SC1_ARRAY_CLAMP_GFS_CTL);
> +			writel(0, sc1_base_ptr + SCSS_CPU1CORE_RESET);
> +			writel(3, sc1_base_ptr + SCSS_DBG_STATUS_CORE_PWRDUP);
> +			iounmap(sc1_base_ptr);
> +		}
> +	} else
> +		printk(KERN_DEBUG "Failed to set secondary core boot "
> +				  "address\n");
> +}
> +
> +/* Executed by primary CPU, brings other CPUs out of reset. Called at boot
> +   as well as when a CPU is coming out of shutdown induced by echo 0 >
> +   /sys/devices/.../cpuX.
> +*/
> +int boot_secondary(unsigned int cpu, struct task_struct *idle)
> +{
> +	static int cold_boot_done;
> +	int cnt = 0;
> +	printk(KERN_DEBUG "Starting secondary CPU %d\n", cpu);
> +
> +	if (cold_boot_done == false) {
> +		prepare_cold_cpu(cpu);
> +		cold_boot_done = true;
> +	}
> +
> +	pen_release = cpu;
> +	dmac_flush_range((void *)&pen_release,
> +			 (void *)(&pen_release + sizeof(pen_release)));

Abuse of the DMA API.  See how other platforms deal with this.

> +	__asm__("sev");
> +	dsb();
> +
> +	/* Use smp_cross_call() to send a soft interrupt to wake up
> +	 * the other core.
> +	 */
> +	smp_cross_call(cpumask_of(cpu));
> +
> +	while (pen_release != 0xFFFFFFFF) {

Why 0xFFFFFFFF rather than -1 like everyone else does?

> +		smp_rmb();
> +		msleep_interruptible(1);
> +		if (cnt++ >= SECONDARY_CPU_WAIT_MS)
> +			break;
> +	}

And why not use the same loop as everyone else does?

        timeout = jiffies + (1 * HZ);
        while (time_before(jiffies, timeout)) {
                smp_rmb();
                if (pen_release == -1)
                        break;

                udelay(10);
        }

IOW, what's the point of being different when you're trying to do the
same task?

> +
> +	return 0;
> +}
> +
> +/* Mask for edge trigger PPIs except AVS_SVICINT and AVS_SVICINTSWDONE */
> +#define GIC_PPI_EDGE_MASK 0xFFFFD7FF
> +
> +/* Initialization routine for secondary CPUs after they are brought out of
> + * reset.
> +*/
> +void platform_secondary_init(unsigned int cpu)
> +{
> +	printk(KERN_DEBUG "%s: cpu:%d\n", __func__, cpu);
> +
> +	trace_hardirqs_off();

This has been moved into the generic SMP code.

> +
> +	writel(GIC_PPI_EDGE_MASK, MSM_QGIC_DIST_BASE + GIC_DIST_CONFIG + 4);
> +
> +	/* RUMI does not adhere to GIC spec by enabling STIs by default.
> +	 * Enable/clear is supposed to be RO for STIs, but is RW on RUMI.
> +	 */
> +	if (!machine_is_msm8x60_sim())
> +		writel(0x0000FFFF, MSM_QGIC_DIST_BASE + GIC_DIST_ENABLE_SET);

The gic secondary CPU initialization now takes care of this in my tree.

> +
> +	/*
> +	 * setup GIC (GIC number NOT CPU number and the base address of the
> +	 * GIC CPU interface
> +	 */
> +	gic_cpu_init(0, MSM_QGIC_CPU_BASE);

This has been renamed to gic_secondary_init() for 2.6.38.

> +	pen_release = -1;
> +	smp_wmb();
> +}

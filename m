Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab0K3Rj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:39:56 -0500
Received: from imap.ru.mvista.com ([213.79.90.228]:12523 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753864Ab0K3Ria (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:38:30 -0500
Date: Tue, 30 Nov 2010 20:17:09 +0300
From: Anton Vorontsov <avorontsov@mvista.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Colin Cross <ccross@android.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Jamie Iles <jamie.iles@picochip.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH 6/8] ARM: ux500: Switch to generic SCU routines
Message-ID: <20101130171709.GF24034@oksana.dev.rtsoft.ru>
References: <20101130171626.GA6165@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101130171626.GA6165@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This shrinks platform-specific code quite a bit.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
---
 arch/arm/mach-ux500/Makefile           |    2 +-
 arch/arm/mach-ux500/headsmp.S          |   38 -----------
 arch/arm/mach-ux500/hotplug.c          |    5 +-
 arch/arm/mach-ux500/include/mach/smp.h |    3 -
 arch/arm/mach-ux500/platsmp.c          |  115 ++------------------------------
 5 files changed, 10 insertions(+), 153 deletions(-)
 delete mode 100644 arch/arm/mach-ux500/headsmp.S

diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
index 9e27a84..90fa03c 100644
--- a/arch/arm/mach-ux500/Makefile
+++ b/arch/arm/mach-ux500/Makefile
@@ -7,7 +7,7 @@ obj-$(CONFIG_UX500_SOC_DB5500)	+= cpu-db5500.o devices-db5500.o
 obj-$(CONFIG_UX500_SOC_DB8500)	+= cpu-db8500.o devices-db8500.o prcmu.o
 obj-$(CONFIG_MACH_U8500_MOP)	+= board-mop500.o board-mop500-sdi.o
 obj-$(CONFIG_MACH_U5500)	+= board-u5500.o
-obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
+obj-$(CONFIG_SMP)		+= platsmp.o
 obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug.o
 obj-$(CONFIG_LOCAL_TIMERS)	+= localtimer.o
 obj-$(CONFIG_REGULATOR_AB8500)	+= board-mop500-regulators.o
diff --git a/arch/arm/mach-ux500/headsmp.S b/arch/arm/mach-ux500/headsmp.S
deleted file mode 100644
index a6be2cd..0000000
--- a/arch/arm/mach-ux500/headsmp.S
+++ /dev/null
@@ -1,38 +0,0 @@
-/*
- *  Copyright (c) 2009 ST-Ericsson
- *	This file is based  ARM Realview platform
- *  Copyright (c) 2003 ARM Limited
- *  All Rights Reserved
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <linux/linkage.h>
-#include <linux/init.h>
-
-	__INIT
-
-/*
- * U8500 specific entry point for secondary CPUs.
- */
-ENTRY(u8500_secondary_startup)
-	mrc	p15, 0, r0, c0, c0, 5
-	and	r0, r0, #15
-	adr	r4, 1f
-	ldmia	r4, {r5, r6}
-	sub	r4, r4, r5
-	add	r6, r6, r4
-	dsb
-pen:	ldr	r7, [r6]
-	cmp	r7, r0
-	bne	pen
-
-	/*
-	 * we've been released from the holding pen: secondary_stack
-	 * should now contain the SVC stack for this core
-	 */
-	b	secondary_startup
-
-1:	.long	.
-	.long	pen_release
diff --git a/arch/arm/mach-ux500/hotplug.c b/arch/arm/mach-ux500/hotplug.c
index dd8037e..38f4e1b 100644
--- a/arch/arm/mach-ux500/hotplug.c
+++ b/arch/arm/mach-ux500/hotplug.c
@@ -12,10 +12,9 @@
 #include <linux/errno.h>
 #include <linux/smp.h>
 
+#include <asm/smp_scu.h>
 #include <asm/cacheflush.h>
 
-extern volatile int pen_release;
-
 static inline void platform_do_lowpower(unsigned int cpu)
 {
 	flush_cache_all();
@@ -24,7 +23,7 @@ static inline void platform_do_lowpower(unsigned int cpu)
 	for (;;) {
 		__asm__ __volatile__("dsb\n\t" "wfi\n\t"
 				: : : "memory");
-		if (pen_release == cpu) {
+		if (scu_pen_release == cpu) {
 			/*
 			 * OK, proper wakeup, we're done
 			 */
diff --git a/arch/arm/mach-ux500/include/mach/smp.h b/arch/arm/mach-ux500/include/mach/smp.h
index bd57c50..646cea7 100644
--- a/arch/arm/mach-ux500/include/mach/smp.h
+++ b/arch/arm/mach-ux500/include/mach/smp.h
@@ -12,9 +12,6 @@
 #include <asm/hardware/gic.h>
 #include <asm/smp_mpidr.h>
 
-/* This is required to wakeup the secondary core */
-extern void u8500_secondary_startup(void);
-
 /*
  * We use IRQ1 as the IPI
  */
diff --git a/arch/arm/mach-ux500/platsmp.c b/arch/arm/mach-ux500/platsmp.c
index b8987bd..0e195a2 100644
--- a/arch/arm/mach-ux500/platsmp.c
+++ b/arch/arm/mach-ux500/platsmp.c
@@ -11,30 +11,12 @@
  * published by the Free Software Foundation.
  */
 #include <linux/init.h>
-#include <linux/errno.h>
-#include <linux/delay.h>
-#include <linux/device.h>
 #include <linux/smp.h>
 #include <linux/io.h>
 
-#include <asm/cacheflush.h>
-#include <asm/localtimer.h>
 #include <asm/smp_scu.h>
 #include <mach/hardware.h>
 
-/*
- * control for which core is the next to come out of the secondary
- * boot "holding pen"
- */
-volatile int __cpuinitdata pen_release = -1;
-
-static unsigned int __init get_core_count(void)
-{
-	return scu_get_core_count(__io_address(UX500_SCU_BASE));
-}
-
-static DEFINE_SPINLOCK(boot_lock);
-
 void __cpuinit platform_secondary_init(unsigned int cpu)
 {
 	trace_hardirqs_off();
@@ -46,59 +28,18 @@ void __cpuinit platform_secondary_init(unsigned int cpu)
 	 */
 	gic_cpu_init(0, __io_address(UX500_GIC_CPU_BASE));
 
-	/*
-	 * let the primary processor know we're out of the
-	 * pen, then head off into the C entry point
-	 */
-	pen_release = -1;
-
-	/*
-	 * Synchronise with the boot thread.
-	 */
-	spin_lock(&boot_lock);
-	spin_unlock(&boot_lock);
+	scu_secondary_init(cpu);
 }
 
 int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
-	unsigned long timeout;
-
-	/*
-	 * set synchronisation state between this boot processor
-	 * and the secondary one
-	 */
-	spin_lock(&boot_lock);
-
-	/*
-	 * The secondary processor is waiting to be released from
-	 * the holding pen - release it, then wait for it to flag
-	 * that it has been released by resetting pen_release.
-	 */
-	pen_release = cpu;
-	__cpuc_flush_dcache_area((void *)&pen_release, sizeof(pen_release));
-	outer_clean_range(__pa(&pen_release), __pa(&pen_release) + 1);
-
-	smp_cross_call(cpumask_of(cpu), 1);
-
-	timeout = jiffies + (1 * HZ);
-	while (time_before(jiffies, timeout)) {
-		if (pen_release == -1)
-			break;
-	}
-
-	/*
-	 * now the secondary core is starting up let it run its
-	 * calibrations, then wait for it to finish
-	 */
-	spin_unlock(&boot_lock);
-
-	return pen_release != -1 ? -ENOSYS : 0;
+	return scu_boot_secondary(cpu, idle);
 }
 
 static void __init wakeup_secondary(void)
 {
 	/* nobody is to be released from the pen yet */
-	pen_release = -1;
+	scu_pen_release = -1;
 
 	/*
 	 * write the address of secondary startup into the backup ram register
@@ -107,7 +48,7 @@ static void __init wakeup_secondary(void)
 	 * is waiting for. This would wake up the secondary core from WFE
 	 */
 #define U8500_CPU1_JUMPADDR_OFFSET 0x1FF4
-	__raw_writel(virt_to_phys(u8500_secondary_startup),
+	__raw_writel(virt_to_phys(scu_secondary_startup),
 		__io_address(UX500_BACKUPRAM0_BASE) +
 		U8500_CPU1_JUMPADDR_OFFSET);
 
@@ -126,55 +67,13 @@ static void __init wakeup_secondary(void)
  */
 void __init smp_init_cpus(void)
 {
-	unsigned int i, ncores = get_core_count();
-
-	for (i = 0; i < ncores; i++)
-		set_cpu_possible(i, true);
+	scu_init_cpus(__io_address(UX500_SCU_BASE));
 }
 
 void __init smp_prepare_cpus(unsigned int max_cpus)
 {
-	unsigned int ncores = get_core_count();
-	unsigned int cpu = smp_processor_id();
-	int i;
-
-	/* sanity check */
-	if (ncores == 0) {
-		printk(KERN_ERR
-		       "U8500: strange CM count of 0? Default to 1\n");
-		ncores = 1;
-	}
-
-	if (ncores > num_possible_cpus())	{
-		printk(KERN_WARNING
-		       "U8500: no. of cores (%d) greater than configured "
-		       "maximum of %d - clipping\n",
-		       ncores, num_possible_cpus());
-		ncores = num_possible_cpus();
-	}
-
-	smp_store_cpu_info(cpu);
-
-	/*
-	 * are we trying to boot more cores than exist?
-	 */
-	if (max_cpus > ncores)
-		max_cpus = ncores;
-
-	/*
-	 * Initialise the present map, which describes the set of CPUs
-	 * actually populated at the present time.
-	 */
-	for (i = 0; i < max_cpus; i++)
-		set_cpu_present(i, true);
+	scu_prepare_cpus(__io_address(UX500_SCU_BASE), max_cpus);
 
-	if (max_cpus > 1) {
-		/*
-		 * Enable the local timer or broadcast device for the
-		 * boot CPU, but only if we have more than one CPU.
-		 */
-		percpu_timer_setup();
-		scu_enable(__io_address(UX500_SCU_BASE));
+	if (max_cpus > 1)
 		wakeup_secondary();
-	}
 }
-- 
1.7.0.5


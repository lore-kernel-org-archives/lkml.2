Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab0K3Rih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:38:37 -0500
Received: from imap.ru.mvista.com ([213.79.90.228]:12508 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752578Ab0K3Ri1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:38:27 -0500
Date: Tue, 30 Nov 2010 20:17:03 +0300
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
Subject: [PATCH 4/8] ARM: RealView: Switch to generic SCU routines
Message-ID: <20101130171703.GD24034@oksana.dev.rtsoft.ru>
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
 arch/arm/mach-realview/Makefile  |    2 +-
 arch/arm/mach-realview/headsmp.S |   39 ---------
 arch/arm/mach-realview/hotplug.c |    5 +-
 arch/arm/mach-realview/platsmp.c |  161 +++-----------------------------------
 4 files changed, 14 insertions(+), 193 deletions(-)
 delete mode 100644 arch/arm/mach-realview/headsmp.S

diff --git a/arch/arm/mach-realview/Makefile b/arch/arm/mach-realview/Makefile
index a01b76b..d456163 100644
--- a/arch/arm/mach-realview/Makefile
+++ b/arch/arm/mach-realview/Makefile
@@ -8,6 +8,6 @@ obj-$(CONFIG_MACH_REALVIEW_PB11MP)	+= realview_pb11mp.o
 obj-$(CONFIG_MACH_REALVIEW_PB1176)	+= realview_pb1176.o
 obj-$(CONFIG_MACH_REALVIEW_PBA8)	+= realview_pba8.o
 obj-$(CONFIG_MACH_REALVIEW_PBX)		+= realview_pbx.o
-obj-$(CONFIG_SMP)			+= platsmp.o headsmp.o
+obj-$(CONFIG_SMP)			+= platsmp.o
 obj-$(CONFIG_HOTPLUG_CPU)		+= hotplug.o
 obj-$(CONFIG_LOCAL_TIMERS)		+= localtimer.o
diff --git a/arch/arm/mach-realview/headsmp.S b/arch/arm/mach-realview/headsmp.S
deleted file mode 100644
index 4075473..0000000
--- a/arch/arm/mach-realview/headsmp.S
+++ /dev/null
@@ -1,39 +0,0 @@
-/*
- *  linux/arch/arm/mach-realview/headsmp.S
- *
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
- * Realview specific entry point for secondary CPUs.  This provides
- * a "holding pen" into which all secondary cores are held until we're
- * ready for them to initialise.
- */
-ENTRY(realview_secondary_startup)
-	mrc	p15, 0, r0, c0, c0, 5
-	and	r0, r0, #15
-	adr	r4, 1f
-	ldmia	r4, {r5, r6}
-	sub	r4, r4, r5
-	add	r6, r6, r4
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
diff --git a/arch/arm/mach-realview/hotplug.c b/arch/arm/mach-realview/hotplug.c
index e06572e..0261785 100644
--- a/arch/arm/mach-realview/hotplug.c
+++ b/arch/arm/mach-realview/hotplug.c
@@ -12,10 +12,9 @@
 #include <linux/errno.h>
 #include <linux/smp.h>
 
+#include <asm/smp_scu.h>
 #include <asm/cacheflush.h>
 
-extern volatile int pen_release;
-
 static inline void cpu_enter_lowpower(void)
 {
 	unsigned int v;
@@ -69,7 +68,7 @@ static inline void platform_do_lowpower(unsigned int cpu)
 		    :
 		    : "memory", "cc");
 
-		if (pen_release == cpu) {
+		if (scu_pen_release == cpu) {
 			/*
 			 * OK, proper wakeup, we're done
 			 */
diff --git a/arch/arm/mach-realview/platsmp.c b/arch/arm/mach-realview/platsmp.c
index af3d909..3c1000b 100644
--- a/arch/arm/mach-realview/platsmp.c
+++ b/arch/arm/mach-realview/platsmp.c
@@ -9,17 +9,11 @@
  * published by the Free Software Foundation.
  */
 #include <linux/init.h>
-#include <linux/errno.h>
-#include <linux/delay.h>
-#include <linux/device.h>
-#include <linux/jiffies.h>
 #include <linux/smp.h>
 #include <linux/io.h>
 
-#include <asm/cacheflush.h>
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
-#include <asm/localtimer.h>
 #include <asm/unified.h>
 
 #include <mach/board-eb.h>
@@ -29,14 +23,6 @@
 
 #include "core.h"
 
-extern void realview_secondary_startup(void);
-
-/*
- * control for which core is the next to come out of the secondary
- * boot "holding pen"
- */
-volatile int __cpuinitdata pen_release = -1;
-
 static void __iomem *scu_base_addr(void)
 {
 	if (machine_is_realview_eb_mp())
@@ -50,16 +36,6 @@ static void __iomem *scu_base_addr(void)
 		return (void __iomem *)0;
 }
 
-static inline unsigned int get_core_count(void)
-{
-	void __iomem *scu_base = scu_base_addr();
-	if (scu_base)
-		return scu_get_core_count(scu_base);
-	return 1;
-}
-
-static DEFINE_SPINLOCK(boot_lock);
-
 void __cpuinit platform_secondary_init(unsigned int cpu)
 {
 	trace_hardirqs_off();
@@ -71,151 +47,36 @@ void __cpuinit platform_secondary_init(unsigned int cpu)
 	 */
 	gic_cpu_init(0, gic_cpu_base_addr);
 
-	/*
-	 * let the primary processor know we're out of the
-	 * pen, then head off into the C entry point
-	 */
-	pen_release = -1;
-	smp_wmb();
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
-	 *
-	 * Note that "pen_release" is the hardware CPU ID, whereas
-	 * "cpu" is Linux's internal ID.
-	 */
-	pen_release = cpu;
-	flush_cache_all();
-
-	/*
-	 * XXX
-	 *
-	 * This is a later addition to the booting protocol: the
-	 * bootMonitor now puts secondary cores into WFI, so
-	 * poke_milo() no longer gets the cores moving; we need
-	 * to send a soft interrupt to wake the secondary core.
-	 * Use smp_cross_call() for this, since there's little
-	 * point duplicating the code here
-	 */
-	smp_cross_call(cpumask_of(cpu), 1);
-
-	timeout = jiffies + (1 * HZ);
-	while (time_before(jiffies, timeout)) {
-		smp_rmb();
-		if (pen_release == -1)
-			break;
-
-		udelay(10);
-	}
-
-	/*
-	 * now the secondary core is starting up let it run its
-	 * calibrations, then wait for it to finish
-	 */
-	spin_unlock(&boot_lock);
+	return scu_boot_secondary(cpu, idle);
+}
 
-	return pen_release != -1 ? -ENOSYS : 0;
+void __init smp_init_cpus(void)
+{
+	scu_init_cpus(scu_base_addr());
 }
 
 static void __init poke_milo(void)
 {
-	/* nobody is to be released from the pen yet */
-	pen_release = -1;
-
+	if (num_present_cpus() <= 1)
+		return;
 	/*
 	 * Write the address of secondary startup into the system-wide flags
 	 * register. The BootMonitor waits for this register to become
 	 * non-zero.
 	 */
-	__raw_writel(BSYM(virt_to_phys(realview_secondary_startup)),
+	__raw_writel(BSYM(virt_to_phys(scu_secondary_startup)),
 		     __io_address(REALVIEW_SYS_FLAGSSET));
 
 	mb();
 }
 
-/*
- * Initialise the CPU possible map early - this describes the CPUs
- * which may be present or become present in the system.
- */
-void __init smp_init_cpus(void)
-{
-	unsigned int i, ncores = get_core_count();
-
-	for (i = 0; i < ncores; i++)
-		set_cpu_possible(i, true);
-}
-
 void __init smp_prepare_cpus(unsigned int max_cpus)
 {
-	unsigned int ncores = get_core_count();
-	unsigned int cpu = smp_processor_id();
-	int i;
-
-	/* sanity check */
-	if (ncores == 0) {
-		printk(KERN_ERR
-		       "Realview: strange CM count of 0? Default to 1\n");
-
-		ncores = 1;
-	}
-
-	if (ncores > NR_CPUS) {
-		printk(KERN_WARNING
-		       "Realview: no. of cores (%d) greater than configured "
-		       "maximum of %d - clipping\n",
-		       ncores, NR_CPUS);
-		ncores = NR_CPUS;
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
-
-	/*
-	 * Initialise the SCU if there are more than one CPU and let
-	 * them know where to start. Note that, on modern versions of
-	 * MILO, the "poke" doesn't actually do anything until each
-	 * individual core is sent a soft interrupt to get it out of
-	 * WFI
-	 */
-	if (max_cpus > 1) {
-		/*
-		 * Enable the local timer or broadcast device for the
-		 * boot CPU, but only if we have more than one CPU.
-		 */
-		percpu_timer_setup();
-
-		scu_enable(scu_base_addr());
-		poke_milo();
-	}
+	scu_prepare_cpus(scu_base_addr(), max_cpus);
+	poke_milo();
 }
-- 
1.7.0.5


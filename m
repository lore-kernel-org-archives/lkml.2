Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab0K3Rid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:38:33 -0500
Received: from imap.ru.mvista.com ([213.79.90.228]:12500 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752246Ab0K3Ri1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:38:27 -0500
Date: Tue, 30 Nov 2010 20:17:05 +0300
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
Subject: [PATCH 5/8] ARM: S5PV310: Switch to generic SCU routines
Message-ID: <20101130171705.GE24034@oksana.dev.rtsoft.ru>
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
 arch/arm/mach-s5pv310/Makefile  |    2 +-
 arch/arm/mach-s5pv310/headsmp.S |   41 -------------
 arch/arm/mach-s5pv310/hotplug.c |    5 +-
 arch/arm/mach-s5pv310/platsmp.c |  125 ++-------------------------------------
 4 files changed, 9 insertions(+), 164 deletions(-)
 delete mode 100644 arch/arm/mach-s5pv310/headsmp.S

diff --git a/arch/arm/mach-s5pv310/Makefile b/arch/arm/mach-s5pv310/Makefile
index 84afc64..b72abd2 100644
--- a/arch/arm/mach-s5pv310/Makefile
+++ b/arch/arm/mach-s5pv310/Makefile
@@ -15,7 +15,7 @@ obj-				:=
 obj-$(CONFIG_CPU_S5PV310)	+= cpu.o init.o clock.o irq-combiner.o
 obj-$(CONFIG_CPU_S5PV310)	+= setup-i2c0.o time.o gpiolib.o irq-eint.o
 
-obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
+obj-$(CONFIG_SMP)		+= platsmp.o
 obj-$(CONFIG_LOCAL_TIMERS)	+= localtimer.o
 obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug.o
 
diff --git a/arch/arm/mach-s5pv310/headsmp.S b/arch/arm/mach-s5pv310/headsmp.S
deleted file mode 100644
index 164b7b0..0000000
--- a/arch/arm/mach-s5pv310/headsmp.S
+++ /dev/null
@@ -1,41 +0,0 @@
-/*
- *  linux/arch/arm/mach-s5pv310/headsmp.S
- *
- *  Cloned from linux/arch/arm/mach-realview/headsmp.S
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
- * s5pv310 specific entry point for secondary CPUs.  This provides
- * a "holding pen" into which all secondary cores are held until we're
- * ready for them to initialise.
- */
-ENTRY(s5pv310_secondary_startup)
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
diff --git a/arch/arm/mach-s5pv310/hotplug.c b/arch/arm/mach-s5pv310/hotplug.c
index ea951ef..ff1bc05 100644
--- a/arch/arm/mach-s5pv310/hotplug.c
+++ b/arch/arm/mach-s5pv310/hotplug.c
@@ -14,10 +14,9 @@
 #include <linux/errno.h>
 #include <linux/smp.h>
 
+#include <asm/smp_scu.h>
 #include <asm/cacheflush.h>
 
-extern volatile int pen_release;
-
 static inline void cpu_enter_lowpower(void)
 {
 	unsigned int v;
@@ -72,7 +71,7 @@ static inline void platform_do_lowpower(unsigned int cpu)
 		    :
 		    : "memory", "cc");
 
-		if (pen_release == cpu) {
+		if (scu_pen_release == cpu) {
 			/*
 			 * OK, proper wakeup, we're done
 			 */
diff --git a/arch/arm/mach-s5pv310/platsmp.c b/arch/arm/mach-s5pv310/platsmp.c
index d474426..1a3f681 100644
--- a/arch/arm/mach-s5pv310/platsmp.c
+++ b/arch/arm/mach-s5pv310/platsmp.c
@@ -14,37 +14,25 @@
 */
 
 #include <linux/init.h>
-#include <linux/errno.h>
-#include <linux/delay.h>
-#include <linux/device.h>
-#include <linux/jiffies.h>
 #include <linux/smp.h>
 #include <linux/io.h>
 
-#include <asm/cacheflush.h>
-#include <asm/localtimer.h>
 #include <asm/smp_scu.h>
 #include <asm/unified.h>
 
 #include <mach/hardware.h>
 #include <mach/regs-clock.h>
 
-extern void s5pv310_secondary_startup(void);
-
 /*
  * control for which core is the next to come out of the secondary
  * boot "holding pen"
  */
 
-volatile int __cpuinitdata pen_release = -1;
-
 static void __iomem *scu_base_addr(void)
 {
 	return (void __iomem *)(S5P_VA_SCU);
 }
 
-static DEFINE_SPINLOCK(boot_lock);
-
 void __cpuinit platform_secondary_init(unsigned int cpu)
 {
 	trace_hardirqs_off();
@@ -56,65 +44,12 @@ void __cpuinit platform_secondary_init(unsigned int cpu)
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
-	 * Set synchronisation state between this boot processor
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
-	__cpuc_flush_dcache_area((void *)&pen_release, sizeof(pen_release));
-	outer_clean_range(__pa(&pen_release), __pa(&pen_release + 1));
-
-	/*
-	 * Send the secondary CPU a soft interrupt, thereby causing
-	 * the boot monitor to read the system wide flags register,
-	 * and branch to the address found there.
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
-
-	return pen_release != -1 ? -ENOSYS : 0;
+	return scu_boot_secondary(cpu, idle);
 }
 
 /*
@@ -124,69 +59,21 @@ int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
 
 void __init smp_init_cpus(void)
 {
-	void __iomem *scu_base = scu_base_addr();
-	unsigned int i, ncores;
-
-	ncores = scu_base ? scu_get_core_count(scu_base) : 1;
-
-	/* sanity check */
-	if (ncores == 0) {
-		printk(KERN_ERR
-		       "S5PV310: strange CM count of 0? Default to 1\n");
-
-		ncores = 1;
-	}
-
-	if (ncores > NR_CPUS) {
-		printk(KERN_WARNING
-		       "S5PV310: no. of cores (%d) greater than configured "
-		       "maximum of %d - clipping\n",
-		       ncores, NR_CPUS);
-		ncores = NR_CPUS;
-	}
-
-	for (i = 0; i < ncores; i++)
-		set_cpu_possible(i, true);
+	scu_init_cpus(scu_base_addr());
 }
 
 void __init smp_prepare_cpus(unsigned int max_cpus)
 {
-	unsigned int ncores = num_possible_cpus();
-	unsigned int cpu = smp_processor_id();
-	int i;
-
-	smp_store_cpu_info(cpu);
+	scu_prepare_cpus(scu_base_addr(), max_cpus);
 
-	/* are we trying to boot more cores than exist? */
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
-	 * them know where to start.
-	 */
 	if (max_cpus > 1) {
 		/*
-		 * Enable the local timer or broadcast device for the
-		 * boot CPU, but only if we have more than one CPU.
-		 */
-		percpu_timer_setup();
-
-		scu_enable(scu_base_addr());
-
-		/*
 		 * Write the address of secondary startup into the
 		 * system-wide flags register. The boot monitor waits
 		 * until it receives a soft interrupt, and then the
 		 * secondary CPU branches to this address.
 		 */
-	__raw_writel(BSYM(virt_to_phys(s5pv310_secondary_startup)), S5P_VA_SYSRAM);
+		__raw_writel(BSYM(virt_to_phys(scu_secondary_startup)),
+			     S5P_VA_SYSRAM);
 	}
 }
-- 
1.7.0.5


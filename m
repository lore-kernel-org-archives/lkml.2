Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab0LAA0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 19:26:03 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45954 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab0LAA0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 19:26:00 -0500
Date: Wed, 1 Dec 2010 00:25:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Anton Vorontsov <avorontsov@mvista.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jamie Iles <jamie.iles@picochip.com>, Colin Cross <ccross@android.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-tegra@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/8] ARM: SCU: Add common routines for secondary CPU
	bootup
Message-ID: <20101201002527.GC14383@n2100.arm.linux.org.uk>
References: <20101130171626.GA6165@oksana.dev.rtsoft.ru> <20101130171658.GA24034@oksana.dev.rtsoft.ru> <20101130233204.GB14383@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101130233204.GB14383@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 11:32:04PM +0000, Russell King - ARM Linux wrote:
> Note that I'll go with factoring this out into arch/arm/kernel/smp_scu.c
> for the time being, but I'm not convinced about the other parts yet.

IOW, something like the attached.  I've gone a little further and removed
the now unnecessary scu_enable() and scu_get_core_count() global functions,
making scu_enable() static, and eliminating scu_get_core_count() entirely.

 arch/arm/include/asm/smp_scu.h   |    4 +-
 arch/arm/kernel/smp_scu.c        |   65 +++++++++++++++++++++++++++++++------
 arch/arm/mach-omap2/omap-smp.c   |   61 ++--------------------------------
 arch/arm/mach-realview/platsmp.c |   66 ++------------------------------------
 arch/arm/mach-s5pv310/platsmp.c  |   58 ++-------------------------------
 arch/arm/mach-tegra/platsmp.c    |   37 +--------------------
 arch/arm/mach-ux500/platsmp.c    |   48 ++--------------------------
 arch/arm/mach-vexpress/platsmp.c |   58 ++-------------------------------
 8 files changed, 76 insertions(+), 321 deletions(-)

diff --git a/arch/arm/include/asm/smp_scu.h b/arch/arm/include/asm/smp_scu.h
index 2376835..9807fb4 100644
--- a/arch/arm/include/asm/smp_scu.h
+++ b/arch/arm/include/asm/smp_scu.h
@@ -1,7 +1,7 @@
 #ifndef __ASMARM_ARCH_SCU_H
 #define __ASMARM_ARCH_SCU_H
 
-unsigned int scu_get_core_count(void __iomem *);
-void scu_enable(void __iomem *);
+void scu_init_cpus(void __iomem *);
+void scu_prepare_cpus(void __iomem *, unsigned int);
 
 #endif
diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
diff --git a/arch/arm/kernel/smp_scu.c b/arch/arm/kernel/smp_scu.c
index 9ab4149..6c949b4 100644
--- a/arch/arm/kernel/smp_scu.c
+++ b/arch/arm/kernel/smp_scu.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/io.h>
 
+#include <asm/localtimer.h>
 #include <asm/smp_scu.h>
 #include <asm/cacheflush.h>
 
@@ -21,18 +22,9 @@
 #define SCU_FPGA_REVISION	0x10
 
 /*
- * Get the number of CPU cores from the SCU configuration
- */
-unsigned int __init scu_get_core_count(void __iomem *scu_base)
-{
-	unsigned int ncores = __raw_readl(scu_base + SCU_CONFIG);
-	return (ncores & 0x03) + 1;
-}
-
-/*
  * Enable the SCU
  */
-void __init scu_enable(void __iomem *scu_base)
+static void __init scu_enable(void __iomem *scu_base)
 {
 	u32 scu_ctrl;
 
@@ -50,3 +42,56 @@ void __init scu_enable(void __iomem *scu_base)
 	 */
 	flush_cache_all();
 }
+
+void scu_init_cpus(void __iomem *scu_base)
+{
+	unsigned int i, ncores = 1;
+
+	if (scu_base)
+		ncores += __raw_readl(scu_base + SCU_CONFIG) & 0x03;
+
+	if (ncores > NR_CPUS) {
+		pr_warning("SMP: no. of cores (%d) greater than configured maximum of %d - clipping\n",
+		       ncores, NR_CPUS);
+		ncores = NR_CPUS;
+	}
+
+	for (i = 0; i < ncores; i++)
+		set_cpu_possible(i, true);
+}
+
+void scu_prepare_cpus(void __iomem *scu_base, unsigned int max_cpus)
+{
+	unsigned int ncores = num_possible_cpus();
+	unsigned int cpu = smp_processor_id();
+	int i;
+
+	smp_store_cpu_info(cpu);
+
+	/*
+	 * are we trying to boot more cores than exist?
+	 */
+	if (max_cpus > ncores)
+		max_cpus = ncores;
+
+	/*
+	 * Initialise the present map, which describes the set of CPUs
+	 * actually populated at the present time.
+	 */
+	for (i = 0; i < max_cpus; i++)
+		set_cpu_present(i, true);
+
+	/*
+	 * Initialise the SCU if there are more than one CPU and let
+	 * them know where to start.
+	 */
+	if (max_cpus > 1) {
+		/*
+		 * Enable the local timer or broadcast device for the
+		 * boot CPU, but only if we have more than one CPU.
+		 */
+		percpu_timer_setup();
+
+		scu_enable(scu_base);
+	}
+}
diff --git a/arch/arm/mach-omap2/omap-smp.c b/arch/arm/mach-omap2/omap-smp.c
index 56a8bce..05cc85e 100644
--- a/arch/arm/mach-omap2/omap-smp.c
+++ b/arch/arm/mach-omap2/omap-smp.c
@@ -21,7 +21,6 @@
 #include <linux/io.h>
 
 #include <asm/cacheflush.h>
-#include <asm/localtimer.h>
 #include <asm/smp_scu.h>
 #include <mach/hardware.h>
 #include <mach/omap4-common.h>
@@ -29,16 +28,6 @@
 /* SCU base address */
 static void __iomem *scu_base;
 
-/*
- * Use SCU config register to count number of cores
- */
-static inline unsigned int get_core_count(void)
-{
-	if (scu_base)
-		return scu_get_core_count(scu_base);
-	return 1;
-}
-
 static DEFINE_SPINLOCK(boot_lock);
 
 void __cpuinit platform_secondary_init(unsigned int cpu)
@@ -118,59 +107,17 @@ void __init smp_init_cpus(void)
 	scu_base = ioremap(OMAP44XX_SCU_BASE, SZ_256);
 	BUG_ON(!scu_base);
 
-	ncores = get_core_count();
-
-	for (i = 0; i < ncores; i++)
-		set_cpu_possible(i, true);
+	scu_init_cpus(scu_base);
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
-		       "OMAP4: strange core count of 0? Default to 1\n");
-		ncores = 1;
-	}
-
-	if (ncores > NR_CPUS) {
-		printk(KERN_WARNING
-		       "OMAP4: no. of cores (%d) greater than configured "
-		       "maximum of %d - clipping\n",
-		       ncores, NR_CPUS);
-		ncores = NR_CPUS;
-	}
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
-	if (max_cpus > 1) {
-		/*
-		 * Enable the local timer or broadcast device for the
-		 * boot CPU, but only if we have more than one CPU.
-		 */
-		percpu_timer_setup();
+	scu_prepare_cpus(scu_base, max_cpus);
 
+	if (num_present_cpus() > 1) {
 		/*
-		 * Initialise the SCU and wake up the secondary core using
-		 * wakeup_secondary().
+		 * Wake up the secondary core using wakeup_secondary().
 		 */
-		scu_enable(scu_base);
 		wakeup_secondary();
 	}
 }
diff --git a/arch/arm/mach-realview/platsmp.c b/arch/arm/mach-realview/platsmp.c
index af3d909..43614f2 100644
--- a/arch/arm/mach-realview/platsmp.c
+++ b/arch/arm/mach-realview/platsmp.c
@@ -19,7 +19,6 @@
 #include <asm/cacheflush.h>
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
-#include <asm/localtimer.h>
 #include <asm/unified.h>
 
 #include <mach/board-eb.h>
@@ -50,14 +49,6 @@ static void __iomem *scu_base_addr(void)
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
 static DEFINE_SPINLOCK(boot_lock);
 
 void __cpuinit platform_secondary_init(unsigned int cpu)
@@ -158,64 +149,13 @@ static void __init poke_milo(void)
  */
 void __init smp_init_cpus(void)
 {
-	unsigned int i, ncores = get_core_count();
-
-	for (i = 0; i < ncores; i++)
-		set_cpu_possible(i, true);
+	scu_init_cpus(scu_base_addr());
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
+	scu_prepare_cpus(scu_base_addr(), max_cpus);
 
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
+	if (num_present_cpus() > 1)
 		poke_milo();
-	}
 }
diff --git a/arch/arm/mach-s5pv310/platsmp.c b/arch/arm/mach-s5pv310/platsmp.c
index d474426..4da410a 100644
--- a/arch/arm/mach-s5pv310/platsmp.c
+++ b/arch/arm/mach-s5pv310/platsmp.c
@@ -22,7 +22,6 @@
 #include <linux/io.h>
 
 #include <asm/cacheflush.h>
-#include <asm/localtimer.h>
 #include <asm/smp_scu.h>
 #include <asm/unified.h>
 
@@ -124,69 +123,20 @@ int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
 
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
-
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
-	if (max_cpus > 1) {
-		/*
-		 * Enable the local timer or broadcast device for the
-		 * boot CPU, but only if we have more than one CPU.
-		 */
-		percpu_timer_setup();
-
-		scu_enable(scu_base_addr());
+	scu_prepare_cpus(scu_base_addr(), max_cpus);
 
+	if (num_present_cpus() > 1) {
 		/*
 		 * Write the address of secondary startup into the
 		 * system-wide flags register. The boot monitor waits
 		 * until it receives a soft interrupt, and then the
 		 * secondary CPU branches to this address.
 		 */
-	__raw_writel(BSYM(virt_to_phys(s5pv310_secondary_startup)), S5P_VA_SYSRAM);
+		__raw_writel(BSYM(virt_to_phys(s5pv310_secondary_startup)), S5P_VA_SYSRAM);
 	}
 }
diff --git a/arch/arm/mach-tegra/platsmp.c b/arch/arm/mach-tegra/platsmp.c
index 1c0fd92..3b6bcca 100644
--- a/arch/arm/mach-tegra/platsmp.c
+++ b/arch/arm/mach-tegra/platsmp.c
@@ -22,7 +22,6 @@
 #include <asm/cacheflush.h>
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
-#include <asm/localtimer.h>
 #include <asm/smp_scu.h>
 
 #include <mach/iomap.h>
@@ -115,42 +114,10 @@ int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
  */
 void __init smp_init_cpus(void)
 {
-	unsigned int i, ncores = scu_get_core_count(scu_base);
-
-	for (i = 0; i < ncores; i++)
-		cpu_set(i, cpu_possible_map);
+	scu_init_cpus(scu_base);
 }
 
 void __init smp_prepare_cpus(unsigned int max_cpus)
 {
-	unsigned int ncores = scu_get_core_count(scu_base);
-	unsigned int cpu = smp_processor_id();
-	int i;
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
-		percpu_timer_setup();
-		scu_enable(scu_base);
-	}
+	scu_prepare_cpus(scu_base, max_cpus);
 }
diff --git a/arch/arm/mach-ux500/platsmp.c b/arch/arm/mach-ux500/platsmp.c
index b8987bd..8910c08 100644
--- a/arch/arm/mach-ux500/platsmp.c
+++ b/arch/arm/mach-ux500/platsmp.c
@@ -28,11 +28,6 @@
  */
 volatile int __cpuinitdata pen_release = -1;
 
-static unsigned int __init get_core_count(void)
-{
-	return scu_get_core_count(__io_address(UX500_SCU_BASE));
-}
-
 static DEFINE_SPINLOCK(boot_lock);
 
 void __cpuinit platform_secondary_init(unsigned int cpu)
@@ -126,55 +121,18 @@ static void __init wakeup_secondary(void)
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
+	if (num_present_cpus() > 1) {
 		/*
 		 * Enable the local timer or broadcast device for the
 		 * boot CPU, but only if we have more than one CPU.
 		 */
-		percpu_timer_setup();
-		scu_enable(__io_address(UX500_SCU_BASE));
 		wakeup_secondary();
 	}
 }
diff --git a/arch/arm/mach-vexpress/platsmp.c b/arch/arm/mach-vexpress/platsmp.c
index 276f916..ecedd5a 100644
--- a/arch/arm/mach-vexpress/platsmp.c
+++ b/arch/arm/mach-vexpress/platsmp.c
@@ -17,7 +17,6 @@
 #include <linux/io.h>
 
 #include <asm/cacheflush.h>
-#include <asm/localtimer.h>
 #include <asm/smp_scu.h>
 #include <asm/unified.h>
 
@@ -118,65 +117,14 @@ int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
  */
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
-		       "vexpress: strange CM count of 0? Default to 1\n");
-
-		ncores = 1;
-	}
-
-	if (ncores > NR_CPUS) {
-		printk(KERN_WARNING
-		       "vexpress: no. of cores (%d) greater than configured "
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
-	 * them know where to start.
-	 */
-	if (max_cpus > 1) {
-		/*
-		 * Enable the local timer or broadcast device for the
-		 * boot CPU, but only if we have more than one CPU.
-		 */
-		percpu_timer_setup();
-
-		scu_enable(scu_base_addr());
+	scu_prepare_cpus(scu_base_addr(), max_cpus);
 
+	if (num_present_cpus() > 1) {
 		/*
 		 * Write the address of secondary startup into the
 		 * system-wide flags register. The boot monitor waits


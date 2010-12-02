Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab0LBSC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 13:02:26 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34891 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757481Ab0LBSCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 13:02:25 -0500
Date: Thu, 2 Dec 2010 18:01:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Tony Lindgren <tony@atomide.com>, Jamie Iles <jamie.iles@picochip.com>,
        Anton Vorontsov <avorontsov@mvista.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Colin Cross <ccross@android.com>,
        linux-tegra@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/8] ARM: SCU: Add common routines for secondary CPU
	bootup
Message-ID: <20101202180150.GF10461@n2100.arm.linux.org.uk>
References: <20101130171626.GA6165@oksana.dev.rtsoft.ru> <20101130171658.GA24034@oksana.dev.rtsoft.ru> <20101130233204.GB14383@n2100.arm.linux.org.uk> <20101201002527.GC14383@n2100.arm.linux.org.uk> <AANLkTikpjq-8BVanF5W76j0ZdDBur8DyHWSH8GGgJBQs@mail.gmail.com> <20101202152428.GD10461@n2100.arm.linux.org.uk> <1291307320.11271.51.camel@e102109-lin.cambridge.arm.com> <20101202173824.GE10461@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101202173824.GE10461@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 05:38:24PM +0000, Russell King - ARM Linux wrote:
> What if a platform, for what ever reason, wants to have 3 CPUs,
> numbered 0, 2, 3 ?  That's the reason why the code which sets the
> possible and present maps isn't in the ARM core code - Eg, we don't
> know if a platform wants to keep CPU 1 in AMP mode to run some
> special software on it.
> 
> I don't think it's worth it because I think trying to considate this
> is going to cripple the code structure in the future.

I don't think this is particularly worth it either:

8e511800fe64114d00b6a22c6e37a510b208785e
 arch/arm/include/asm/smp.h       |   14 ++++++-
 arch/arm/kernel/smp.c            |   71 ++++++++++++++++++++++++++++++++------
 arch/arm/kernel/smp_scu.c        |    2 +-
 arch/arm/mach-omap2/omap-smp.c   |   67 +++---------------------------------
 arch/arm/mach-realview/platsmp.c |   71 ++++---------------------------------
 arch/arm/mach-s5pv310/platsmp.c  |   63 ++++-----------------------------
 arch/arm/mach-tegra/platsmp.c    |   39 ++-------------------
 arch/arm/mach-ux500/platsmp.c    |   55 +++--------------------------
 arch/arm/mach-vexpress/platsmp.c |   69 +++++-------------------------------
 9 files changed, 113 insertions(+), 338 deletions(-)

diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index f93d0a6..99dd48b 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -46,9 +46,14 @@ asmlinkage void do_IPI(int ipinr, struct pt_regs *regs);
 extern void smp_init_cpus(void);
 
 /*
- * Move global data into per-processor storage.
+ * Initialize cpu_possible map for 0 .. CPUs.
  */
-extern void smp_store_cpu_info(unsigned int cpuid);
+void smp_init_cpu_possible(unsigned int);
+
+/*
+ * Initialize cpu_present map for 0 .. CPUs.
+ */
+void smp_init_cpu_present(unsigned int);
 
 /*
  * Raise an IPI cross call on CPUs in callmap.
@@ -73,6 +78,11 @@ asmlinkage void secondary_start_kernel(void);
 extern void platform_secondary_init(unsigned int cpu);
 
 /*
+ * Initialize cpu_possible map, and enable coherency
+ */
+extern void platform_smp_prepare_cpus(unsigned int);
+
+/*
  * Initial data for bringing up a secondary CPU.
  */
 struct secondary_data {
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 4c3ed4f..46af08f 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -296,6 +296,17 @@ void __ref cpu_die(void)
 #endif /* CONFIG_HOTPLUG_CPU */
 
 /*
+ * Called by both boot and secondaries to move global data into
+ * per-processor storage.
+ */
+static void __cpuinit smp_store_cpu_info(unsigned int cpuid)
+{
+	struct cpuinfo_arm *cpu_info = &per_cpu(cpu_data, cpuid);
+
+	cpu_info->loops_per_jiffy = loops_per_jiffy;
+}
+
+/*
  * This is the secondary CPU boot entry.  We're using this CPUs
  * idle thread stack, but a set of temporary page tables.
  */
@@ -353,17 +364,6 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
 	cpu_idle();
 }
 
-/*
- * Called by both boot and secondaries to move global data into
- * per-processor storage.
- */
-void __cpuinit smp_store_cpu_info(unsigned int cpuid)
-{
-	struct cpuinfo_arm *cpu_info = &per_cpu(cpu_data, cpuid);
-
-	cpu_info->loops_per_jiffy = loops_per_jiffy;
-}
-
 void __init smp_cpus_done(unsigned int max_cpus)
 {
 	int cpu;
@@ -386,6 +386,55 @@ void __init smp_prepare_boot_cpu(void)
 	per_cpu(cpu_data, cpu).idle = current;
 }
 
+void __init smp_init_cpu_possible(unsigned int ncores)
+{
+	unsigned int i;
+
+	if (ncores > NR_CPUS) {
+		pr_warning("SMP: no. of cores (%u) greater than configured maximum of %u - clipping\n",
+		       ncores, NR_CPUS);
+		ncores = NR_CPUS;
+	}
+
+	for (i = 0; i < ncores; i++)
+		set_cpu_possible(i, true);
+}
+
+void __init smp_init_cpu_present(unsigned int ncores)
+{
+	unsigned int i;
+
+	for (i = 0; i < ncores; i++)
+		set_cpu_present(i, true);
+}
+
+void __init smp_prepare_cpus(unsigned int max_cpus)
+{
+	unsigned int ncores = num_possible_cpus();
+
+	smp_store_cpu_info(smp_processor_id());
+
+	/*
+	 * are we trying to boot more cores than exist?
+	 */
+	if (max_cpus > ncores)
+		max_cpus = ncores;
+
+	if (max_cpus > 1) {
+		/*
+		 * Enable the local timer or broadcast device for the
+		 * boot CPU, but only if we have more than one CPU.
+		 */
+		percpu_timer_setup();
+
+		/*
+		 * Initialise the SCU if there are more than one CPU
+		 * and let them know where to start.
+		 */
+		platform_smp_prepare_cpus(max_cpus);
+	}
+}
+
 static void send_ipi_message(const struct cpumask *mask, enum ipi_msg_type msg)
 {
 	unsigned long flags;
diff --git a/arch/arm/kernel/smp_scu.c b/arch/arm/kernel/smp_scu.c
index 9ab4149..904b77b 100644
--- a/arch/arm/kernel/smp_scu.c
+++ b/arch/arm/kernel/smp_scu.c
@@ -11,8 +11,8 @@
 #include <linux/init.h>
 #include <linux/io.h>
 
-#include <asm/smp_scu.h>
 #include <asm/cacheflush.h>
+#include <asm/smp_scu.h>
 
 #define SCU_CTRL		0x00
 #define SCU_CONFIG		0x04
diff --git a/arch/arm/mach-omap2/omap-smp.c b/arch/arm/mach-omap2/omap-smp.c
index 56a8bce..a123edf 100644
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
@@ -112,65 +101,19 @@ static void __init wakeup_secondary(void)
  */
 void __init smp_init_cpus(void)
 {
-	unsigned int i, ncores;
-
 	/* Never released */
 	scu_base = ioremap(OMAP44XX_SCU_BASE, SZ_256);
 	BUG_ON(!scu_base);
 
-	ncores = get_core_count();
-
-	for (i = 0; i < ncores; i++)
-		set_cpu_possible(i, true);
+	smp_init_cpu_possible(scu_get_core_count(scu_base));
 }
 
-void __init smp_prepare_cpus(unsigned int max_cpus)
+void __init platform_smp_prepare_cpus(unsigned int max_cpus)
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
+	smp_init_cpu_present(max_cpus);
 
 	/*
-	 * Initialise the present map, which describes the set of CPUs
-	 * actually populated at the present time.
+	 * Wake up the secondary core using wakeup_secondary().
 	 */
-	for (i = 0; i < max_cpus; i++)
-		set_cpu_present(i, true);
-
-	if (max_cpus > 1) {
-		/*
-		 * Enable the local timer or broadcast device for the
-		 * boot CPU, but only if we have more than one CPU.
-		 */
-		percpu_timer_setup();
-
-		/*
-		 * Initialise the SCU and wake up the secondary core using
-		 * wakeup_secondary().
-		 */
-		scu_enable(scu_base);
-		wakeup_secondary();
-	}
+	wakeup_secondary();
 }
diff --git a/arch/arm/mach-realview/platsmp.c b/arch/arm/mach-realview/platsmp.c
index af3d909..b9908e4 100644
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
@@ -158,64 +149,18 @@ static void __init poke_milo(void)
  */
 void __init smp_init_cpus(void)
 {
-	unsigned int i, ncores = get_core_count();
+	void __iomem *scu_base = scu_base_addr();
+	unsigned int ncores;
+
+	ncores = scu_base ? scu_get_core_count(scu_base) : 1;
 
-	for (i = 0; i < ncores; i++)
-		set_cpu_possible(i, true);
+	smp_init_cpu_possible(ncores);
 }
 
-void __init smp_prepare_cpus(unsigned int max_cpus)
+void __init platform_smp_prepare_cpus(unsigned int max_cpus)
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
+	smp_init_cpu_present(max_cpus);
 
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
+	if (num_present_cpus() > 1)
 		poke_milo();
-	}
 }
diff --git a/arch/arm/mach-s5pv310/platsmp.c b/arch/arm/mach-s5pv310/platsmp.c
index d474426..407c825 100644
--- a/arch/arm/mach-s5pv310/platsmp.c
+++ b/arch/arm/mach-s5pv310/platsmp.c
@@ -22,7 +22,6 @@
 #include <linux/io.h>
 
 #include <asm/cacheflush.h>
-#include <asm/localtimer.h>
 #include <asm/smp_scu.h>
 #include <asm/unified.h>
 
@@ -125,68 +124,22 @@ int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
 void __init smp_init_cpus(void)
 {
 	void __iomem *scu_base = scu_base_addr();
-	unsigned int i, ncores;
+	unsigned int ncores;
 
 	ncores = scu_base ? scu_get_core_count(scu_base) : 1;
 
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
+	smp_init_cpu_possible(ncores);
 }
 
-void __init smp_prepare_cpus(unsigned int max_cpus)
+void __init platform_smp_prepare_cpus(unsigned int max_cpus)
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
+	smp_init_cpu_present(max_cpus);
 
 	/*
-	 * Initialise the present map, which describes the set of CPUs
-	 * actually populated at the present time.
+	 * Write the address of secondary startup into the
+	 * system-wide flags register. The boot monitor waits
+	 * until it receives a soft interrupt, and then the
+	 * secondary CPU branches to this address.
 	 */
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
-
-		/*
-		 * Write the address of secondary startup into the
-		 * system-wide flags register. The boot monitor waits
-		 * until it receives a soft interrupt, and then the
-		 * secondary CPU branches to this address.
-		 */
 	__raw_writel(BSYM(virt_to_phys(s5pv310_secondary_startup)), S5P_VA_SYSRAM);
-	}
 }
diff --git a/arch/arm/mach-tegra/platsmp.c b/arch/arm/mach-tegra/platsmp.c
index 1c0fd92..abbb97b 100644
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
+	smp_init_cpu_possible(scu_get_core_count(scu_base));
 }
 
-void __init smp_prepare_cpus(unsigned int max_cpus)
+void __init platform_smp_prepare_cpus(unsigned int max_cpus)
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
+	smp_init_cpu_present(max_cpus);
 }
diff --git a/arch/arm/mach-ux500/platsmp.c b/arch/arm/mach-ux500/platsmp.c
index b8987bd..e03a5d0 100644
--- a/arch/arm/mach-ux500/platsmp.c
+++ b/arch/arm/mach-ux500/platsmp.c
@@ -18,7 +18,6 @@
 #include <linux/io.h>
 
 #include <asm/cacheflush.h>
-#include <asm/localtimer.h>
 #include <asm/smp_scu.h>
 #include <mach/hardware.h>
 
@@ -28,11 +27,6 @@
  */
 volatile int __cpuinitdata pen_release = -1;
 
-static unsigned int __init get_core_count(void)
-{
-	return scu_get_core_count(__io_address(UX500_SCU_BASE));
-}
-
 static DEFINE_SPINLOCK(boot_lock);
 
 void __cpuinit platform_secondary_init(unsigned int cpu)
@@ -126,55 +120,18 @@ static void __init wakeup_secondary(void)
  */
 void __init smp_init_cpus(void)
 {
-	unsigned int i, ncores = get_core_count();
+	unsigned int ncores = scu_get_core_count(__io_address(UX500_SCU_BASE));
 
-	for (i = 0; i < ncores; i++)
-		set_cpu_possible(i, true);
+	smp_init_cpu_possible(ncores);
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
+	smp_init_cpu_present(max_cpus);
 
 	/*
-	 * are we trying to boot more cores than exist?
+	 * Enable the local timer or broadcast device for the
+	 * boot CPU, but only if we have more than one CPU.
 	 */
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
-		scu_enable(__io_address(UX500_SCU_BASE));
-		wakeup_secondary();
-	}
+	wakeup_secondary();
 }
diff --git a/arch/arm/mach-vexpress/platsmp.c b/arch/arm/mach-vexpress/platsmp.c
index 276f916..92ef7cb 100644
--- a/arch/arm/mach-vexpress/platsmp.c
+++ b/arch/arm/mach-vexpress/platsmp.c
@@ -17,7 +17,6 @@
 #include <linux/io.h>
 
 #include <asm/cacheflush.h>
-#include <asm/localtimer.h>
 #include <asm/smp_scu.h>
 #include <asm/unified.h>
 
@@ -119,72 +118,24 @@ int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
 void __init smp_init_cpus(void)
 {
 	void __iomem *scu_base = scu_base_addr();
-	unsigned int i, ncores;
+	unsigned int ncores;
 
 	ncores = scu_base ? scu_get_core_count(scu_base) : 1;
 
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
+	smp_init_cpu_possible(ncores);
 }
 
 void __init smp_prepare_cpus(unsigned int max_cpus)
 {
-	unsigned int ncores = num_possible_cpus();
-	unsigned int cpu = smp_processor_id();
-	int i;
-
-	smp_store_cpu_info(cpu);
+	smp_init_cpu_present(max_cpus);
 
 	/*
-	 * are we trying to boot more cores than exist?
+	 * Write the address of secondary startup into the
+	 * system-wide flags register. The boot monitor waits
+	 * until it receives a soft interrupt, and then the
+	 * secondary CPU branches to this address.
 	 */
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
-
-		/*
-		 * Write the address of secondary startup into the
-		 * system-wide flags register. The boot monitor waits
-		 * until it receives a soft interrupt, and then the
-		 * secondary CPU branches to this address.
-		 */
-		writel(~0, MMIO_P2V(V2M_SYS_FLAGSCLR));
-		writel(BSYM(virt_to_phys(vexpress_secondary_startup)),
-			MMIO_P2V(V2M_SYS_FLAGSSET));
-	}
+	writel(~0, MMIO_P2V(V2M_SYS_FLAGSCLR));
+	writel(BSYM(virt_to_phys(vexpress_secondary_startup)),
+		MMIO_P2V(V2M_SYS_FLAGSSET));
 }


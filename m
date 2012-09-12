Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990Ab2ILPAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:00:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51758 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2ILO6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:58:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com
Subject: [PATCH v9 11/13] ARM: SoC: convert spear13xx to SoC descriptor
Date: Wed, 12 Sep 2012 16:58:24 +0200
Message-Id: <1347461906-13527-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347461906-13527-1-git-send-email-arnd@arndb.de>
References: <1347461906-13527-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:g2/dlllt8ryzVLJUXGBOS5Yl7AJXB53r2y+5UODqCIb
 lX1H0L5EEtozI/Qj2boO4eS8hMrGTqK+oqMhETVIvZcu4cCNZa
 NSJI0CnF2CwIO868sLUHeYLGvkss72GqdDfQOuCUmdWNOAi/jE
 S+Ip2DFwa0aT1Pn013+ctdAFhOkoVQXFPj9leAu8qU/3v60vKN
 UkZYUnzkJYdFha3B5qqkbpFTNMSjPf048PAd16wIf5afRT9l7l
 0tblR56z9brMlEcQC/Ku8aGCFwf+vKslXX+t7CDxmxl2c4uA+a
 DyfvrV65WyUZYLCMxULBOa9KY++80TEwhk+4vRIxo8zut5qSK9
 jxircm/BTN+96xJvwkW3jKauymr+8moqtgcUAFbt42XM4Fi/N2
 j1tOBeY/LQv3f1RObfka3n6KSjonlm9r4w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the spear13xx platform to use the SoC descriptor to provide
its SMP and CPU hotplug operations.

Cc: Viresh Kumar <viresh.linux@gmail.com>
Cc: Shiraz Hashim <shiraz.hashim@st.com>
Cc: spear-devel@list.st.com
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-spear13xx/hotplug.c              |   20 +++-----------------
 arch/arm/mach-spear13xx/include/mach/generic.h |    3 +++
 arch/arm/mach-spear13xx/platsmp.c              |   20 +++++++++++++++-----
 arch/arm/mach-spear13xx/spear1310.c            |    1 +
 arch/arm/mach-spear13xx/spear1340.c            |    1 +
 5 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/arch/arm/mach-spear13xx/hotplug.c b/arch/arm/mach-spear13xx/hotplug.c
index 5c6867b..22e99b0 100644
--- a/arch/arm/mach-spear13xx/hotplug.c
+++ b/arch/arm/mach-spear13xx/hotplug.c
@@ -56,7 +56,7 @@ static inline void cpu_leave_lowpower(void)
 	: "cc");
 }
 
-static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
+static inline void spear13xx_do_lowpower(unsigned int cpu, int *spurious)
 {
 	for (;;) {
 		wfi();
@@ -79,17 +79,12 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
 	}
 }
 
-int platform_cpu_kill(unsigned int cpu)
-{
-	return 1;
-}
-
 /*
  * platform-specific code to shutdown a CPU
  *
  * Called with IRQs disabled
  */
-void __cpuinit platform_cpu_die(unsigned int cpu)
+void __cpuinit spear13xx_cpu_die(unsigned int cpu)
 {
 	int spurious = 0;
 
@@ -97,7 +92,7 @@ void __cpuinit platform_cpu_die(unsigned int cpu)
 	 * we're ready for shutdown now, so do it
 	 */
 	cpu_enter_lowpower();
-	platform_do_lowpower(cpu, &spurious);
+	spear13xx_do_lowpower(cpu, &spurious);
 
 	/*
 	 * bring this CPU back into the world of cache
@@ -108,12 +103,3 @@ void __cpuinit platform_cpu_die(unsigned int cpu)
 	if (spurious)
 		pr_warn("CPU%u: %u spurious wakeup calls\n", cpu, spurious);
 }
-
-int platform_cpu_disable(unsigned int cpu)
-{
-	/*
-	 * we don't allow CPU 0 to be shutdown (it is still too special
-	 * e.g. clock tick interrupts)
-	 */
-	return cpu == 0 ? -EPERM : 0;
-}
diff --git a/arch/arm/mach-spear13xx/include/mach/generic.h b/arch/arm/mach-spear13xx/include/mach/generic.h
index dac57fd0c..c33f4d9 100644
--- a/arch/arm/mach-spear13xx/include/mach/generic.h
+++ b/arch/arm/mach-spear13xx/include/mach/generic.h
@@ -33,6 +33,9 @@ void __init spear13xx_l2x0_init(void);
 bool dw_dma_filter(struct dma_chan *chan, void *slave);
 void spear_restart(char, const char *);
 void spear13xx_secondary_startup(void);
+void __cpuinit spear13xx_cpu_die(unsigned int cpu);
+
+extern struct smp_operations spear13xx_smp_ops;
 
 #ifdef CONFIG_MACH_SPEAR1310
 void __init spear1310_clk_init(void);
diff --git a/arch/arm/mach-spear13xx/platsmp.c b/arch/arm/mach-spear13xx/platsmp.c
index f5d07f2..806343c 100644
--- a/arch/arm/mach-spear13xx/platsmp.c
+++ b/arch/arm/mach-spear13xx/platsmp.c
@@ -19,6 +19,7 @@
 #include <asm/hardware/gic.h>
 #include <asm/smp_scu.h>
 #include <mach/spear.h>
+#include <mach/generic.h>
 
 /*
  * control for which core is the next to come out of the secondary
@@ -28,9 +29,8 @@ volatile int __cpuinitdata pen_release = -1;
 static DEFINE_SPINLOCK(boot_lock);
 
 static void __iomem *scu_base = IOMEM(VA_SCU_BASE);
-extern void spear13xx_secondary_startup(void);
 
-void __cpuinit platform_secondary_init(unsigned int cpu)
+static void __cpuinit spear13xx_secondary_init(unsigned int cpu)
 {
 	/*
 	 * if any interrupts are already enabled for the primary
@@ -53,7 +53,7 @@ void __cpuinit platform_secondary_init(unsigned int cpu)
 	spin_unlock(&boot_lock);
 }
 
-int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
+static int __cpuinit spear13xx_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	unsigned long timeout;
 
@@ -97,7 +97,7 @@ int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
  * Initialise the CPU possible map early - this describes the CPUs
  * which may be present or become present in the system.
  */
-void __init smp_init_cpus(void)
+static void __init spear13xx_smp_init_cpus(void)
 {
 	unsigned int i, ncores = scu_get_core_count(scu_base);
 
@@ -113,7 +113,7 @@ void __init smp_init_cpus(void)
 	set_smp_cross_call(gic_raise_softirq);
 }
 
-void __init platform_smp_prepare_cpus(unsigned int max_cpus)
+static void __init spear13xx_smp_prepare_cpus(unsigned int max_cpus)
 {
 
 	scu_enable(scu_base);
@@ -125,3 +125,13 @@ void __init platform_smp_prepare_cpus(unsigned int max_cpus)
 	 */
 	__raw_writel(virt_to_phys(spear13xx_secondary_startup), SYS_LOCATION);
 }
+
+struct smp_operations spear13xx_smp_ops __initdata = {
+       .smp_init_cpus		= spear13xx_smp_init_cpus,
+       .smp_prepare_cpus	= spear13xx_smp_prepare_cpus,
+       .smp_secondary_init	= spear13xx_secondary_init,
+       .smp_boot_secondary	= spear13xx_boot_secondary,
+#ifdef CONFIG_HOTPLUG_CPU
+       .cpu_die			= spear13xx_cpu_die,
+#endif
+};
diff --git a/arch/arm/mach-spear13xx/spear1310.c b/arch/arm/mach-spear13xx/spear1310.c
index 732d29b..9fbbfc5 100644
--- a/arch/arm/mach-spear13xx/spear1310.c
+++ b/arch/arm/mach-spear13xx/spear1310.c
@@ -78,6 +78,7 @@ static void __init spear1310_map_io(void)
 }
 
 DT_MACHINE_START(SPEAR1310_DT, "ST SPEAr1310 SoC with Flattened Device Tree")
+	.smp		=	smp_ops(spear13xx_smp_ops),
 	.map_io		=	spear1310_map_io,
 	.init_irq	=	spear13xx_dt_init_irq,
 	.handle_irq	=	gic_handle_irq,
diff --git a/arch/arm/mach-spear13xx/spear1340.c b/arch/arm/mach-spear13xx/spear1340.c
index 81e4ed7..081014f 100644
--- a/arch/arm/mach-spear13xx/spear1340.c
+++ b/arch/arm/mach-spear13xx/spear1340.c
@@ -182,6 +182,7 @@ static const char * const spear1340_dt_board_compat[] = {
 };
 
 DT_MACHINE_START(SPEAR1340_DT, "ST SPEAr1340 SoC with Flattened Device Tree")
+	.smp		=	smp_ops(spear13xx_smp_ops),
 	.map_io		=	spear13xx_map_io,
 	.init_irq	=	spear13xx_dt_init_irq,
 	.handle_irq	=	gic_handle_irq,
-- 
1.7.10


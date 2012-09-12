Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab2ILO6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:58:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50053 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab2ILO6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:58:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v9 07/13] ARM: SoC: convert ux500 to SoC descriptor
Date: Wed, 12 Sep 2012 16:58:20 +0200
Message-Id: <1347461906-13527-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347461906-13527-1-git-send-email-arnd@arndb.de>
References: <1347461906-13527-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:/3JBjccM3rhndfzZH7xIvDQr92+/RHFQ054V+Q8mq8u
 0WZSxW4/Fk7Meommq4pvdhih4zcBvkkOnJF0zpiOESVP5l5Ejt
 ks0o4uvVtwSYuC2bHS5HLIg9i11SIcfC8v9N+Ev8Vh8gYnleKE
 WjmP+70Ir3K6Elwgx4UiVqChEFpp1m78rTvwGsnJL/KB4kUs4G
 oHmn/0jVTApT7nnN5Rs3amXVGRtJvDC4mNulPTYL+G9mud24Gu
 nPnelkveoInKlZjX914aRGM64U4gXw6+A9G9TFFdqd26wlX2l2
 9OJT+H6t/e4y+uMGKUvKohxFcaKj/bWFa6I8x/9sWSSxjFWUn8
 5Xe92xi9Q2kvR9eTd6D0245f9Hh6d0AzllQdqug6Qz7O+081Ce
 P6dGLVWyn4E4WbzcNTPfi03Oc6GtaRMLE4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

Convert ux500 platforms to use the SoC descriptor to provide
their SMP and CPU hotplug operations.

Cc: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-ux500/board-mop500.c       |    4 ++++
 arch/arm/mach-ux500/hotplug.c            |   36 ++++++++----------------------
 arch/arm/mach-ux500/include/mach/setup.h |    3 +++
 arch/arm/mach-ux500/platsmp.c            |   18 +++++++++++----
 4 files changed, 30 insertions(+), 31 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index a534d88..1c6f74b 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -694,6 +694,7 @@ static void __init hrefv60_init_machine(void)
 MACHINE_START(U8500, "ST-Ericsson MOP500 platform")
 	/* Maintainer: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com> */
 	.atag_offset	= 0x100,
+	.smp		= smp_ops(ux500_smp_ops),
 	.map_io		= u8500_map_io,
 	.init_irq	= ux500_init_irq,
 	/* we re-use nomadik timer here */
@@ -705,6 +706,7 @@ MACHINE_END
 
 MACHINE_START(HREFV60, "ST-Ericsson U8500 Platform HREFv60+")
 	.atag_offset	= 0x100,
+	.smp		= smp_ops(ux500_smp_ops),
 	.map_io		= u8500_map_io,
 	.init_irq	= ux500_init_irq,
 	.timer		= &ux500_timer,
@@ -715,6 +717,7 @@ MACHINE_END
 
 MACHINE_START(SNOWBALL, "Calao Systems Snowball platform")
 	.atag_offset	= 0x100,
+	.smp		= smp_ops(ux500_smp_ops),
 	.map_io		= u8500_map_io,
 	.init_irq	= ux500_init_irq,
 	/* we re-use nomadik timer here */
@@ -844,6 +847,7 @@ static const char * u8500_dt_board_compat[] = {
 
 
 DT_MACHINE_START(U8500_DT, "ST-Ericsson U8500 platform (Device Tree Support)")
+	.smp		= smp_ops(ux500_smp_ops),
 	.map_io		= u8500_map_io,
 	.init_irq	= ux500_init_irq,
 	/* we re-use nomadik timer here */
diff --git a/arch/arm/mach-ux500/hotplug.c b/arch/arm/mach-ux500/hotplug.c
index c76f0f4..17b9a15 100644
--- a/arch/arm/mach-ux500/hotplug.c
+++ b/arch/arm/mach-ux500/hotplug.c
@@ -15,13 +15,20 @@
 #include <asm/cacheflush.h>
 #include <asm/smp_plat.h>
 
+#include <mach/setup.h>
+
 extern volatile int pen_release;
 
-static inline void platform_do_lowpower(unsigned int cpu)
+/*
+ * platform-specific code to shutdown a CPU
+ *
+ * Called with IRQs disabled
+ */
+void ux500_cpu_die(unsigned int cpu)
 {
 	flush_cache_all();
 
-	/* we put the platform to just WFI */
+	/* directly enter low power state, skipping secure registers */
 	for (;;) {
 		__asm__ __volatile__("dsb\n\t" "wfi\n\t"
 				: : : "memory");
@@ -33,28 +40,3 @@ static inline void platform_do_lowpower(unsigned int cpu)
 		}
 	}
 }
-
-int platform_cpu_kill(unsigned int cpu)
-{
-	return 1;
-}
-
-/*
- * platform-specific code to shutdown a CPU
- *
- * Called with IRQs disabled
- */
-void platform_cpu_die(unsigned int cpu)
-{
-	/* directly enter low power state, skipping secure registers */
-	platform_do_lowpower(cpu);
-}
-
-int platform_cpu_disable(unsigned int cpu)
-{
-	/*
-	 * we don't allow CPU 0 to be shutdown (it is still too special
-	 * e.g. clock tick interrupts)
-	 */
-	return cpu == 0 ? -EPERM : 0;
-}
diff --git a/arch/arm/mach-ux500/include/mach/setup.h b/arch/arm/mach-ux500/include/mach/setup.h
index 7914e5e..6be4c4d 100644
--- a/arch/arm/mach-ux500/include/mach/setup.h
+++ b/arch/arm/mach-ux500/include/mach/setup.h
@@ -45,4 +45,7 @@ extern struct sys_timer ux500_timer;
 	.type		= MT_MEMORY,		\
 }
 
+extern struct smp_operations ux500_smp_ops;
+extern void ux500_cpu_die(unsigned int cpu);
+
 #endif /*  __ASM_ARCH_SETUP_H */
diff --git a/arch/arm/mach-ux500/platsmp.c b/arch/arm/mach-ux500/platsmp.c
index da1d5ad..b6f4e0e 100644
--- a/arch/arm/mach-ux500/platsmp.c
+++ b/arch/arm/mach-ux500/platsmp.c
@@ -58,7 +58,7 @@ static void __iomem *scu_base_addr(void)
 
 static DEFINE_SPINLOCK(boot_lock);
 
-void __cpuinit platform_secondary_init(unsigned int cpu)
+static void __cpuinit ux500_secondary_init(unsigned int cpu)
 {
 	/*
 	 * if any interrupts are already enabled for the primary
@@ -80,7 +80,7 @@ void __cpuinit platform_secondary_init(unsigned int cpu)
 	spin_unlock(&boot_lock);
 }
 
-int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
+static int __cpuinit ux500_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	unsigned long timeout;
 
@@ -145,7 +145,7 @@ static void __init wakeup_secondary(void)
  * Initialise the CPU possible map early - this describes the CPUs
  * which may be present or become present in the system.
  */
-void __init smp_init_cpus(void)
+static void __init ux500_smp_init_cpus(void)
 {
 	void __iomem *scu_base = scu_base_addr();
 	unsigned int i, ncores;
@@ -165,9 +165,19 @@ void __init smp_init_cpus(void)
 	set_smp_cross_call(gic_raise_softirq);
 }
 
-void __init platform_smp_prepare_cpus(unsigned int max_cpus)
+static void __init ux500_smp_prepare_cpus(unsigned int max_cpus)
 {
 
 	scu_enable(scu_base_addr());
 	wakeup_secondary();
 }
+
+struct smp_operations ux500_smp_ops __initdata = {
+	.smp_init_cpus		= ux500_smp_init_cpus,
+	.smp_prepare_cpus	= ux500_smp_prepare_cpus,
+	.smp_secondary_init	= ux500_secondary_init,
+	.smp_boot_secondary	= ux500_boot_secondary,
+#ifdef CONFIG_HOTPLUG_CPU
+	.cpu_die		= ux500_cpu_die,
+#endif
+};
-- 
1.7.10


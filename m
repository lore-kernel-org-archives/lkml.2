Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab2ILPB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:01:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57870 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab2ILO6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:58:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v9 05/13] ARM: SoC: convert Exynos4 to SoC descriptor
Date: Wed, 12 Sep 2012 16:58:18 +0200
Message-Id: <1347461906-13527-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347461906-13527-1-git-send-email-arnd@arndb.de>
References: <1347461906-13527-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:sqOi9YOdTh7hNvEgQOz4+YvdD/MWWapKaVXJPKgZeSy
 7yghNdB/SAsKkIHVrtCLsluS+rotKleeetjXwccXJfsNE9vl5r
 +jGgdYNLgpzyWZLd1c5m9IiwShVutSRqe38Q1lWlzEKPwSE6fu
 KDytwIzMQN+qkLBQrUHBcCOpbUgyp7xPll3rZQ5vJ8roB0geP8
 kr3GGEonBEEj16NVir9RFzWsrlxLNwd0tl5m51IfVIq7Lm5+T7
 XNA4nOSR6DOBQgwxtOnr4Z3swz6nn/cihRzfbT1RxlXTgdFchr
 l1ilpOwmY0J3TETijG+WMyXseJQ2JEAI+ofyaL9SD6b82bAytJ
 AwyC0xfGltndhFgnV7KFmtW+Aehr50JWQpMhX953iY19v6RcCh
 mWbknXxmSRM414kKP8C53lAgt00mrENFMg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

Convert Exynos4 to use the SoC descriptor to provide its SMP
and CPU hotplug operations.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Tested-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-exynos/common.h              |    5 +++++
 arch/arm/mach-exynos/hotplug.c             |   18 +++---------------
 arch/arm/mach-exynos/mach-armlex4210.c     |    1 +
 arch/arm/mach-exynos/mach-exynos5-dt.c     |    1 +
 arch/arm/mach-exynos/mach-nuri.c           |    1 +
 arch/arm/mach-exynos/mach-origen.c         |    1 +
 arch/arm/mach-exynos/mach-smdk4x12.c       |    2 ++
 arch/arm/mach-exynos/mach-smdkv310.c       |    2 ++
 arch/arm/mach-exynos/mach-universal_c210.c |    1 +
 arch/arm/mach-exynos/platsmp.c             |   20 ++++++++++++++++----
 10 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index aed2eeb..dac146d 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -14,6 +14,7 @@
 
 extern struct sys_timer exynos4_timer;
 
+struct map_desc;
 void exynos_init_io(struct map_desc *mach_desc, int size);
 void exynos4_init_irq(void);
 void exynos5_init_irq(void);
@@ -59,4 +60,8 @@ void exynos4212_register_clocks(void);
 #define exynos4212_register_clocks()
 #endif
 
+extern struct smp_operations exynos_smp_ops;
+
+extern void exynos_cpu_die(unsigned int cpu);
+
 #endif /* __ARCH_ARM_MACH_EXYNOS_COMMON_H */
diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index 9c17a0a..d0a5a70 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -21,6 +21,8 @@
 
 #include <mach/regs-pmu.h>
 
+#include "common.h"
+
 extern volatile int pen_release;
 
 static inline void cpu_enter_lowpower(void)
@@ -95,17 +97,12 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
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
-void platform_cpu_die(unsigned int cpu)
+void __cpuinit exynos_cpu_die(unsigned int cpu)
 {
 	int spurious = 0;
 
@@ -124,12 +121,3 @@ void platform_cpu_die(unsigned int cpu)
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
diff --git a/arch/arm/mach-exynos/mach-armlex4210.c b/arch/arm/mach-exynos/mach-armlex4210.c
index 5a3daa0..3f37a5e 100644
--- a/arch/arm/mach-exynos/mach-armlex4210.c
+++ b/arch/arm/mach-exynos/mach-armlex4210.c
@@ -199,6 +199,7 @@ static void __init armlex4210_machine_init(void)
 MACHINE_START(ARMLEX4210, "ARMLEX4210")
 	/* Maintainer: Alim Akhtar <alim.akhtar@samsung.com> */
 	.atag_offset	= 0x100,
+	.smp		= smp_ops(exynos_smp_ops),
 	.init_irq	= exynos4_init_irq,
 	.map_io		= armlex4210_map_io,
 	.handle_irq	= gic_handle_irq,
diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
index ef770bc..8833060 100644
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -79,6 +79,7 @@ static char const *exynos5250_dt_compat[] __initdata = {
 DT_MACHINE_START(EXYNOS5_DT, "SAMSUNG EXYNOS5 (Flattened Device Tree)")
 	/* Maintainer: Kukjin Kim <kgene.kim@samsung.com> */
 	.init_irq	= exynos5_init_irq,
+	.smp		= smp_ops(exynos_smp_ops),
 	.map_io		= exynos5250_dt_map_io,
 	.handle_irq	= gic_handle_irq,
 	.init_machine	= exynos5250_dt_machine_init,
diff --git a/arch/arm/mach-exynos/mach-nuri.c b/arch/arm/mach-exynos/mach-nuri.c
index ea785fc..ffaa355 100644
--- a/arch/arm/mach-exynos/mach-nuri.c
+++ b/arch/arm/mach-exynos/mach-nuri.c
@@ -1383,6 +1383,7 @@ static void __init nuri_machine_init(void)
 MACHINE_START(NURI, "NURI")
 	/* Maintainer: Kyungmin Park <kyungmin.park@samsung.com> */
 	.atag_offset	= 0x100,
+	.smp		= smp_ops(exynos_smp_ops),
 	.init_irq	= exynos4_init_irq,
 	.map_io		= nuri_map_io,
 	.handle_irq	= gic_handle_irq,
diff --git a/arch/arm/mach-exynos/mach-origen.c b/arch/arm/mach-exynos/mach-origen.c
index 4e574c2..abd0e60 100644
--- a/arch/arm/mach-exynos/mach-origen.c
+++ b/arch/arm/mach-exynos/mach-origen.c
@@ -806,6 +806,7 @@ static void __init origen_machine_init(void)
 MACHINE_START(ORIGEN, "ORIGEN")
 	/* Maintainer: JeongHyeon Kim <jhkim@insignal.co.kr> */
 	.atag_offset	= 0x100,
+	.smp		= smp_ops(exynos_smp_ops),
 	.init_irq	= exynos4_init_irq,
 	.map_io		= origen_map_io,
 	.handle_irq	= gic_handle_irq,
diff --git a/arch/arm/mach-exynos/mach-smdk4x12.c b/arch/arm/mach-exynos/mach-smdk4x12.c
index b26beb1..964693b 100644
--- a/arch/arm/mach-exynos/mach-smdk4x12.c
+++ b/arch/arm/mach-exynos/mach-smdk4x12.c
@@ -370,6 +370,7 @@ static void __init smdk4x12_machine_init(void)
 MACHINE_START(SMDK4212, "SMDK4212")
 	/* Maintainer: Kukjin Kim <kgene.kim@samsung.com> */
 	.atag_offset	= 0x100,
+	.smp		= smp_ops(exynos_smp_ops),
 	.init_irq	= exynos4_init_irq,
 	.map_io		= smdk4x12_map_io,
 	.handle_irq	= gic_handle_irq,
@@ -383,6 +384,7 @@ MACHINE_START(SMDK4412, "SMDK4412")
 	/* Maintainer: Kukjin Kim <kgene.kim@samsung.com> */
 	/* Maintainer: Changhwan Youn <chaos.youn@samsung.com> */
 	.atag_offset	= 0x100,
+	.smp		= smp_ops(exynos_smp_ops),
 	.init_irq	= exynos4_init_irq,
 	.map_io		= smdk4x12_map_io,
 	.handle_irq	= gic_handle_irq,
diff --git a/arch/arm/mach-exynos/mach-smdkv310.c b/arch/arm/mach-exynos/mach-smdkv310.c
index 73f2bce..69b858c 100644
--- a/arch/arm/mach-exynos/mach-smdkv310.c
+++ b/arch/arm/mach-exynos/mach-smdkv310.c
@@ -417,6 +417,7 @@ MACHINE_START(SMDKV310, "SMDKV310")
 	/* Maintainer: Kukjin Kim <kgene.kim@samsung.com> */
 	/* Maintainer: Changhwan Youn <chaos.youn@samsung.com> */
 	.atag_offset	= 0x100,
+	.smp		= smp_ops(exynos_smp_ops),
 	.init_irq	= exynos4_init_irq,
 	.map_io		= smdkv310_map_io,
 	.handle_irq	= gic_handle_irq,
@@ -429,6 +430,7 @@ MACHINE_END
 MACHINE_START(SMDKC210, "SMDKC210")
 	/* Maintainer: Kukjin Kim <kgene.kim@samsung.com> */
 	.atag_offset	= 0x100,
+	.smp		= smp_ops(exynos_smp_ops),
 	.init_irq	= exynos4_init_irq,
 	.map_io		= smdkv310_map_io,
 	.handle_irq	= gic_handle_irq,
diff --git a/arch/arm/mach-exynos/mach-universal_c210.c b/arch/arm/mach-exynos/mach-universal_c210.c
index 4d1f40d..922ca0f 100644
--- a/arch/arm/mach-exynos/mach-universal_c210.c
+++ b/arch/arm/mach-exynos/mach-universal_c210.c
@@ -1155,6 +1155,7 @@ static void __init universal_machine_init(void)
 MACHINE_START(UNIVERSAL_C210, "UNIVERSAL_C210")
 	/* Maintainer: Kyungmin Park <kyungmin.park@samsung.com> */
 	.atag_offset	= 0x100,
+	.smp		= smp_ops(exynos_smp_ops),
 	.init_irq	= exynos4_init_irq,
 	.map_io		= universal_map_io,
 	.handle_irq	= gic_handle_irq,
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 36c3984..3fad8ad 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -32,6 +32,8 @@
 
 #include <plat/cpu.h>
 
+#include "common.h"
+
 extern void exynos4_secondary_startup(void);
 
 #define CPU1_BOOT_REG		(samsung_rev() == EXYNOS4210_REV_1_1 ? \
@@ -64,7 +66,7 @@ static void __iomem *scu_base_addr(void)
 
 static DEFINE_SPINLOCK(boot_lock);
 
-void __cpuinit platform_secondary_init(unsigned int cpu)
+static void __cpuinit exynos_secondary_init(unsigned int cpu)
 {
 	/*
 	 * if any interrupts are already enabled for the primary
@@ -86,7 +88,7 @@ void __cpuinit platform_secondary_init(unsigned int cpu)
 	spin_unlock(&boot_lock);
 }
 
-int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
+static int __cpuinit exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	unsigned long timeout;
 
@@ -161,7 +163,7 @@ int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
  * which may be present or become present in the system.
  */
 
-void __init smp_init_cpus(void)
+static void __init exynos_smp_init_cpus(void)
 {
 	void __iomem *scu_base = scu_base_addr();
 	unsigned int i, ncores;
@@ -184,7 +186,7 @@ void __init smp_init_cpus(void)
 	set_smp_cross_call(gic_raise_softirq);
 }
 
-void __init platform_smp_prepare_cpus(unsigned int max_cpus)
+static void __init exynos_smp_prepare_cpus(unsigned int max_cpus)
 {
 	if (!soc_is_exynos5250())
 		scu_enable(scu_base_addr());
@@ -198,3 +200,13 @@ void __init platform_smp_prepare_cpus(unsigned int max_cpus)
 	__raw_writel(virt_to_phys(exynos4_secondary_startup),
 			CPU1_BOOT_REG);
 }
+
+struct smp_operations exynos_smp_ops __initdata = {
+	.smp_init_cpus		= exynos_smp_init_cpus,
+	.smp_prepare_cpus	= exynos_smp_prepare_cpus,
+	.smp_secondary_init	= exynos_secondary_init,
+	.smp_boot_secondary	= exynos_boot_secondary,
+#ifdef CONFIG_HOTPLUG_CPU
+	.cpu_die		= exynos_cpu_die,
+#endif
+};
-- 
1.7.10


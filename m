Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab2ILO6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:58:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56175 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab2ILO6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:58:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v9 10/13] ARM: SoC: convert imx6q to SoC descriptor
Date: Wed, 12 Sep 2012 16:58:23 +0200
Message-Id: <1347461906-13527-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347461906-13527-1-git-send-email-arnd@arndb.de>
References: <1347461906-13527-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:s4TvzrSSUYcdZn1VWLbDDKomKdzN99Rul/w3pkyCdLj
 3+TyL77bYhgho17DVJnxc1Rl4FNrO46a9M7K8kUh3RNnEp+S5s
 nXjroioWxm20ixlImQ68TSW6YATeK1W8stziMukIJXPebKLMsp
 NIO5cdXchML5tjIHB8vPX5/uSIRgvi4/73ptxDYPYO8PH1xrgL
 Ryp39Fv1XUCUYGYMvKBusdS6OJgh4q3fPrcI66SFSWCAbsJbBH
 zjJHclQ0693ba0omL/zZJ5IlhaTczM3T6rRGvSWnoxpcl+/SYy
 MJxGSWiWP+3hHDExcAgdof2SfP74aUufvX2lNynNo9Gz8emdoY
 zfU3+LKm8qV32iffpmsWRMhA28ZlIJpjhkVJkWOyQO8R0PpQ15
 c335l6RZi9RbpEkuZBHI4WjcL+L55+PYl4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

Convert the imx6q platform to use the SoC descriptor to provide
its SMP and CPU hotplug operations.

Cc: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-imx/hotplug.c             |   16 +---------------
 arch/arm/mach-imx/mach-imx6q.c          |    1 +
 arch/arm/mach-imx/platsmp.c             |   18 ++++++++++++++----
 arch/arm/plat-mxc/include/mach/common.h |    4 ++++
 4 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-imx/hotplug.c b/arch/arm/mach-imx/hotplug.c
index f8f7437..b07b778 100644
--- a/arch/arm/mach-imx/hotplug.c
+++ b/arch/arm/mach-imx/hotplug.c
@@ -15,11 +15,6 @@
 #include <asm/cp15.h>
 #include <mach/common.h>
 
-int platform_cpu_kill(unsigned int cpu)
-{
-	return 1;
-}
-
 static inline void cpu_enter_lowpower(void)
 {
 	unsigned int v;
@@ -47,7 +42,7 @@ static inline void cpu_enter_lowpower(void)
  *
  * Called with IRQs disabled
  */
-void platform_cpu_die(unsigned int cpu)
+void imx_cpu_die(unsigned int cpu)
 {
 	cpu_enter_lowpower();
 	imx_enable_cpu(cpu, false);
@@ -56,12 +51,3 @@ void platform_cpu_die(unsigned int cpu)
 	while (1)
 		;
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
diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index 045b3f6..ef0b52f 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -226,6 +226,7 @@ static const char *imx6q_dt_compat[] __initdata = {
 };
 
 DT_MACHINE_START(IMX6Q, "Freescale i.MX6 Quad (Device Tree)")
+	.smp		= smp_ops(imx6q_soc_desc),
 	.map_io		= imx6q_map_io,
 	.init_irq	= imx6q_init_irq,
 	.handle_irq	= imx6q_handle_irq,
diff --git a/arch/arm/mach-imx/platsmp.c b/arch/arm/mach-imx/platsmp.c
index ab98c6f..2ac43e1 100644
--- a/arch/arm/mach-imx/platsmp.c
+++ b/arch/arm/mach-imx/platsmp.c
@@ -41,7 +41,7 @@ void __init imx_scu_map_io(void)
 	scu_base = IMX_IO_ADDRESS(base);
 }
 
-void __cpuinit platform_secondary_init(unsigned int cpu)
+static void __cpuinit imx_secondary_init(unsigned int cpu)
 {
 	/*
 	 * if any interrupts are already enabled for the primary
@@ -51,7 +51,7 @@ void __cpuinit platform_secondary_init(unsigned int cpu)
 	gic_secondary_init(0);
 }
 
-int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
+static int __cpuinit imx_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	imx_set_cpu_jump(cpu, v7_secondary_startup);
 	imx_enable_cpu(cpu, true);
@@ -62,7 +62,7 @@ int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
  * Initialise the CPU possible map early - this describes the CPUs
  * which may be present or become present in the system.
  */
-void __init smp_init_cpus(void)
+static void __init imx_smp_init_cpus(void)
 {
 	int i, ncores;
 
@@ -79,7 +79,17 @@ void imx_smp_prepare(void)
 	scu_enable(scu_base);
 }
 
-void __init platform_smp_prepare_cpus(unsigned int max_cpus)
+static void __init imx_smp_prepare_cpus(unsigned int max_cpus)
 {
 	imx_smp_prepare();
 }
+
+struct smp_operations  imx_smp_ops __initdata = {
+	.smp_init_cpus		= imx_smp_init_cpus,
+	.smp_prepare_cpus	= imx_smp_prepare_cpus,
+	.smp_secondary_init	= imx_secondary_init,
+	.smp_boot_secondary	= imx_boot_secondary,
+#ifdef CONFIG_HOTPLUG_CPU
+	.cpu_die		= imx_cpu_die,
+#endif
+};
diff --git a/arch/arm/plat-mxc/include/mach/common.h b/arch/arm/plat-mxc/include/mach/common.h
index 7128e97..e8b5150 100644
--- a/arch/arm/plat-mxc/include/mach/common.h
+++ b/arch/arm/plat-mxc/include/mach/common.h
@@ -145,6 +145,8 @@ extern void imx53_smd_common_init(void);
 extern int imx6q_set_lpm(enum mxc_cpu_pwr_mode mode);
 extern void imx6q_clock_map_io(void);
 
+extern void imx_cpu_die(unsigned int cpu);
+
 #ifdef CONFIG_PM
 extern void imx6q_pm_init(void);
 extern void imx51_pm_init(void);
@@ -161,4 +163,6 @@ extern int mx51_neon_fixup(void);
 static inline int mx51_neon_fixup(void) { return 0; }
 #endif
 
+extern struct smp_operations imx_smp_ops;
+
 #endif
-- 
1.7.10


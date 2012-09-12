Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab2ILXCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:02:13 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12341 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab2ILXCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:02:10 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6833"; a="233698645"
From: David Brown <davidb@codeaurora.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 1/2] ARM: SoC: convert MSM SMP to SoC descriptor
Date: Wed, 12 Sep 2012 16:01:39 -0700
Message-Id: <1347490900-8409-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347461906-13527-7-git-send-email-arnd@arndb.de>
References: <1347461906-13527-7-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

Convert MSM SMP platforms to use the SoC descriptor to provide
their SMP and CPU hotplug operations.

Cc: David Brown <davidb@codeaurora.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
This is an adaptation of this change on top of the msm-for-3.7 tree I
recently sent out a pull request for.  The only real change is to
resolve the conflicts with the simplified board files.

 arch/arm/mach-msm/board-dt-8660.c |  2 ++
 arch/arm/mach-msm/board-dt-8960.c |  2 ++
 arch/arm/mach-msm/core.h          |  2 ++
 arch/arm/mach-msm/hotplug.c       | 18 +++---------------
 arch/arm/mach-msm/platsmp.c       | 19 +++++++++++++++----
 5 files changed, 24 insertions(+), 19 deletions(-)
 create mode 100644 arch/arm/mach-msm/core.h

diff --git a/arch/arm/mach-msm/board-dt-8660.c b/arch/arm/mach-msm/board-dt-8660.c
index f77f57f..e5643f6 100644
--- a/arch/arm/mach-msm/board-dt-8660.c
+++ b/arch/arm/mach-msm/board-dt-8660.c
@@ -20,6 +20,7 @@
 
 #include <mach/board.h>
 #include "common.h"
+#include "core.h"
 
 static const struct of_device_id msm_dt_gic_match[] __initconst = {
 	{ .compatible = "qcom,msm-8660-qgic", .data = gic_of_init },
@@ -53,6 +54,7 @@ static const char *msm8x60_fluid_match[] __initdata = {
 };
 
 DT_MACHINE_START(MSM_DT, "Qualcomm MSM (Flattened Device Tree)")
+	.smp = smp_ops(msm_smp_ops),
 	.map_io = msm_map_msm8x60_io,
 	.init_irq = msm8x60_init_irq,
 	.handle_irq = gic_handle_irq,
diff --git a/arch/arm/mach-msm/board-dt-8960.c b/arch/arm/mach-msm/board-dt-8960.c
index 8df99b8..139d61b 100644
--- a/arch/arm/mach-msm/board-dt-8960.c
+++ b/arch/arm/mach-msm/board-dt-8960.c
@@ -18,6 +18,7 @@
 #include <asm/mach/arch.h>
 
 #include "common.h"
+#include "core.h"
 
 static const struct of_device_id msm_dt_gic_match[] __initconst = {
 	{ .compatible = "qcom,msm-qgic2", .data = gic_of_init },
@@ -40,6 +41,7 @@ static const char * const msm8960_dt_match[] __initconst = {
 };
 
 DT_MACHINE_START(MSM8960_DT, "Qualcomm MSM (Flattened Device Tree)")
+	.smp = smp_ops(msm_smp_ops),
 	.map_io = msm_map_msm8960_io,
 	.init_irq = msm_dt_init_irq,
 	.timer = &msm_dt_timer,
diff --git a/arch/arm/mach-msm/core.h b/arch/arm/mach-msm/core.h
new file mode 100644
index 0000000..a9bab53
--- /dev/null
+++ b/arch/arm/mach-msm/core.h
@@ -0,0 +1,2 @@
+extern struct smp_operations msm_smp_ops;
+extern void msm_cpu_die(unsigned int cpu);
diff --git a/arch/arm/mach-msm/hotplug.c b/arch/arm/mach-msm/hotplug.c
index a446fc1..d0f79e8 100644
--- a/arch/arm/mach-msm/hotplug.c
+++ b/arch/arm/mach-msm/hotplug.c
@@ -13,6 +13,8 @@
 #include <asm/cacheflush.h>
 #include <asm/smp_plat.h>
 
+#include "core.h"
+
 extern volatile int pen_release;
 
 static inline void cpu_enter_lowpower(void)
@@ -57,17 +59,12 @@ static inline void platform_do_lowpower(unsigned int cpu)
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
+void msm_cpu_die(unsigned int cpu)
 {
 	/*
 	 * we're ready for shutdown now, so do it
@@ -81,12 +78,3 @@ void platform_cpu_die(unsigned int cpu)
 	 */
 	cpu_leave_lowpower();
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
diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index b119f99..313bd7d 100644
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-msm/platsmp.c
@@ -23,6 +23,7 @@
 #include <asm/smp_plat.h>
 
 #include "scm-boot.h"
+#include "core.h"
 
 #define VDD_SC1_ARRAY_CLAMP_GFS_CTL 0x15A0
 #define SCSS_CPU1CORE_RESET 0xD80
@@ -43,7 +44,7 @@ static inline int get_core_count(void)
 	return ((read_cpuid_id() >> 4) & 3) + 1;
 }
 
-void __cpuinit platform_secondary_init(unsigned int cpu)
+static void __cpuinit msm_secondary_init(unsigned int cpu)
 {
 	/*
 	 * if any interrupts are already enabled for the primary
@@ -85,7 +86,7 @@ static __cpuinit void prepare_cold_cpu(unsigned int cpu)
 				  "address\n");
 }
 
-int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
+static int __cpuinit msm_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	unsigned long timeout;
 	static int cold_boot_done;
@@ -145,7 +146,7 @@ int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
  * does not support the ARM SCU, so just set the possible cpu mask to
  * NR_CPUS.
  */
-void __init smp_init_cpus(void)
+static void __init msm_smp_init_cpus(void)
 {
 	unsigned int i, ncores = get_core_count();
 
@@ -161,6 +162,16 @@ void __init smp_init_cpus(void)
         set_smp_cross_call(gic_raise_softirq);
 }
 
-void __init platform_smp_prepare_cpus(unsigned int max_cpus)
+static void __init msm_smp_prepare_cpus(unsigned int max_cpus)
 {
 }
+
+struct smp_operations msm_smp_ops __initdata = {
+	.smp_init_cpus		= msm_smp_init_cpus,
+	.smp_prepare_cpus	= msm_smp_prepare_cpus,
+	.smp_secondary_init	= msm_secondary_init,
+	.smp_boot_secondary	= msm_boot_secondary,
+#ifdef CONFIG_HOTPLUG_CPU
+	.cpu_die		= msm_cpu_die,
+#endif
+};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


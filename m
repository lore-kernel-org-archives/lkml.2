Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759178Ab2ILPBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:01:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54290 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab2ILO6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:58:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v9 02/13] ARM: SoC: convert VExpress/RealView to SoC descriptor
Date: Wed, 12 Sep 2012 16:58:15 +0200
Message-Id: <1347461906-13527-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347461906-13527-1-git-send-email-arnd@arndb.de>
References: <1347461906-13527-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:816MGOGb9uRFWfT9D5syZYa+imlgNXcYyMpKie5LpA7
 WL5OHHCSI7RbTIXdrAAKvgM/GSH4xL1e6M6Wy02bhr7RTGHVHc
 N1F07IbXkxyvFpmAS3aZsUvpX3E1A987xSd5hiaPrBfVqVQqYf
 i0dNunTx8atyhyITAupNcnCNj+zr0BE0PJ3OAWRYjbqPri51Mh
 8WwEstyVy3g6S+Uke7osdBm2KS8eQaDcvF2nLWW5ajdUu8KFfQ
 wKgsrbMB7eYzkukNXerO9OkOWaI53uKVaUGzqbE/qWZtHlX75s
 9iOvhCTaD2V0Yo5dq4s6cxJJtqSlYxd+ZV6cQqJZz8J/CZ0uzu
 hswPqcDtfDCyMGrZB7ZuJ6wdEAzl0pAA832Z+S4YyM8bX+Fa90
 +SXGVoWPZMbt5iQepBQ8LUv/mOVq5j61GM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

Convert both Realview and VExpress to use the SoC descriptor to
provide their SMP and CPU hotplug operation.

Cc: Nicolas Pitre <nico@fluxnic.net>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-realview/core.h                  |    3 +++
 arch/arm/mach-realview/hotplug.c               |   16 +---------------
 arch/arm/mach-realview/platsmp.c               |   18 ++++++++++++++----
 arch/arm/mach-realview/realview_pb11mp.c       |    1 +
 arch/arm/mach-realview/realview_pbx.c          |    1 +
 arch/arm/mach-vexpress/core.h                  |    4 ++++
 arch/arm/mach-vexpress/hotplug.c               |   16 +---------------
 arch/arm/mach-vexpress/platsmp.c               |   18 ++++++++++++++----
 arch/arm/mach-vexpress/v2m.c                   |    4 ++++
 arch/arm/plat-versatile/include/plat/platsmp.h |   14 ++++++++++++++
 arch/arm/plat-versatile/platsmp.c              |    4 ++--
 11 files changed, 59 insertions(+), 40 deletions(-)
 create mode 100644 arch/arm/plat-versatile/include/plat/platsmp.h

diff --git a/arch/arm/mach-realview/core.h b/arch/arm/mach-realview/core.h
index f8f2c0a..78cd970 100644
--- a/arch/arm/mach-realview/core.h
+++ b/arch/arm/mach-realview/core.h
@@ -56,4 +56,7 @@ extern void realview_init_early(void);
 extern void realview_fixup(struct tag *tags, char **from,
 			   struct meminfo *meminfo);
 
+extern struct smp_operations realview_smp_ops;
+extern void realview_cpu_die(unsigned int cpu);
+
 #endif
diff --git a/arch/arm/mach-realview/hotplug.c b/arch/arm/mach-realview/hotplug.c
index 57d9efb..81a2a58 100644
--- a/arch/arm/mach-realview/hotplug.c
+++ b/arch/arm/mach-realview/hotplug.c
@@ -89,17 +89,12 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
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
+void realview_cpu_die(unsigned int cpu)
 {
 	int spurious = 0;
 
@@ -118,12 +113,3 @@ void platform_cpu_die(unsigned int cpu)
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
diff --git a/arch/arm/mach-realview/platsmp.c b/arch/arm/mach-realview/platsmp.c
index 17c878d..300f706 100644
--- a/arch/arm/mach-realview/platsmp.c
+++ b/arch/arm/mach-realview/platsmp.c
@@ -22,9 +22,9 @@
 #include <mach/board-pb11mp.h>
 #include <mach/board-pbx.h>
 
-#include "core.h"
+#include <plat/platsmp.h>
 
-extern void versatile_secondary_startup(void);
+#include "core.h"
 
 static void __iomem *scu_base_addr(void)
 {
@@ -43,7 +43,7 @@ static void __iomem *scu_base_addr(void)
  * Initialise the CPU possible map early - this describes the CPUs
  * which may be present or become present in the system.
  */
-void __init smp_init_cpus(void)
+static void __init realview_smp_init_cpus(void)
 {
 	void __iomem *scu_base = scu_base_addr();
 	unsigned int i, ncores;
@@ -63,7 +63,7 @@ void __init smp_init_cpus(void)
 	set_smp_cross_call(gic_raise_softirq);
 }
 
-void __init platform_smp_prepare_cpus(unsigned int max_cpus)
+static void __init realview_smp_prepare_cpus(unsigned int max_cpus)
 {
 
 	scu_enable(scu_base_addr());
@@ -77,3 +77,13 @@ void __init platform_smp_prepare_cpus(unsigned int max_cpus)
 	__raw_writel(virt_to_phys(versatile_secondary_startup),
 		     __io_address(REALVIEW_SYS_FLAGSSET));
 }
+
+struct smp_operations realview_smp_ops __initdata = {
+	.smp_init_cpus		= realview_smp_init_cpus,
+	.smp_prepare_cpus	= realview_smp_prepare_cpus,
+	.smp_secondary_init	= versatile_secondary_init,
+	.smp_boot_secondary	= versatile_boot_secondary,
+#ifdef CONFIG_HOTPLUG_CPU
+	.cpu_die		= realview_cpu_die,
+#endif
+};
diff --git a/arch/arm/mach-realview/realview_pb11mp.c b/arch/arm/mach-realview/realview_pb11mp.c
index a98c536..2eacda1 100644
--- a/arch/arm/mach-realview/realview_pb11mp.c
+++ b/arch/arm/mach-realview/realview_pb11mp.c
@@ -366,6 +366,7 @@ static void __init realview_pb11mp_init(void)
 MACHINE_START(REALVIEW_PB11MP, "ARM-RealView PB11MPCore")
 	/* Maintainer: ARM Ltd/Deep Blue Solutions Ltd */
 	.atag_offset	= 0x100,
+	.smp		= smp_ops(realview_smp_ops),
 	.fixup		= realview_fixup,
 	.map_io		= realview_pb11mp_map_io,
 	.init_early	= realview_init_early,
diff --git a/arch/arm/mach-realview/realview_pbx.c b/arch/arm/mach-realview/realview_pbx.c
index 3f2f605..2cd4f15 100644
--- a/arch/arm/mach-realview/realview_pbx.c
+++ b/arch/arm/mach-realview/realview_pbx.c
@@ -403,6 +403,7 @@ static void __init realview_pbx_init(void)
 MACHINE_START(REALVIEW_PBX, "ARM-RealView PBX")
 	/* Maintainer: ARM Ltd/Deep Blue Solutions Ltd */
 	.atag_offset	= 0x100,
+	.smp		= smp_ops(realview_smp_ops),
 	.fixup		= realview_pbx_fixup,
 	.map_io		= realview_pbx_map_io,
 	.init_early	= realview_init_early,
diff --git a/arch/arm/mach-vexpress/core.h b/arch/arm/mach-vexpress/core.h
index a3a4980..f134cd4 100644
--- a/arch/arm/mach-vexpress/core.h
+++ b/arch/arm/mach-vexpress/core.h
@@ -5,3 +5,7 @@
 #define V2T_PERIPH 0xf8200000
 
 void vexpress_dt_smp_map_io(void);
+
+extern struct smp_operations	vexpress_smp_ops;
+
+extern void vexpress_cpu_die(unsigned int cpu);
diff --git a/arch/arm/mach-vexpress/hotplug.c b/arch/arm/mach-vexpress/hotplug.c
index c504a72..e2a960f 100644
--- a/arch/arm/mach-vexpress/hotplug.c
+++ b/arch/arm/mach-vexpress/hotplug.c
@@ -84,17 +84,12 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
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
+void __cpuinit vexpress_cpu_die(unsigned int cpu)
 {
 	int spurious = 0;
 
@@ -113,12 +108,3 @@ void platform_cpu_die(unsigned int cpu)
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
diff --git a/arch/arm/mach-vexpress/platsmp.c b/arch/arm/mach-vexpress/platsmp.c
index 14ba112..7db27c8 100644
--- a/arch/arm/mach-vexpress/platsmp.c
+++ b/arch/arm/mach-vexpress/platsmp.c
@@ -20,9 +20,9 @@
 
 #include <mach/motherboard.h>
 
-#include "core.h"
+#include <plat/platsmp.h>
 
-extern void versatile_secondary_startup(void);
+#include "core.h"
 
 #if defined(CONFIG_OF)
 
@@ -167,7 +167,7 @@ void __init vexpress_dt_smp_prepare_cpus(unsigned int max_cpus)
  * Initialise the CPU possible map early - this describes the CPUs
  * which may be present or become present in the system.
  */
-void __init smp_init_cpus(void)
+static void __init vexpress_smp_init_cpus(void)
 {
 	if (ct_desc)
 		ct_desc->init_cpu_map();
@@ -176,7 +176,7 @@ void __init smp_init_cpus(void)
 
 }
 
-void __init platform_smp_prepare_cpus(unsigned int max_cpus)
+static void __init vexpress_smp_prepare_cpus(unsigned int max_cpus)
 {
 	/*
 	 * Initialise the present map, which describes the set of CPUs
@@ -195,3 +195,13 @@ void __init platform_smp_prepare_cpus(unsigned int max_cpus)
 	 */
 	v2m_flags_set(virt_to_phys(versatile_secondary_startup));
 }
+
+struct smp_operations __initdata vexpress_smp_ops = {
+	.smp_init_cpus		= vexpress_smp_init_cpus,
+	.smp_prepare_cpus	= vexpress_smp_prepare_cpus,
+	.smp_secondary_init	= versatile_secondary_init,
+	.smp_boot_secondary	= versatile_boot_secondary,
+#ifdef CONFIG_HOTPLUG_CPU
+	.cpu_die		= vexpress_cpu_die,
+#endif
+};
diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
index 37608f2..722ef33 100644
--- a/arch/arm/mach-vexpress/v2m.c
+++ b/arch/arm/mach-vexpress/v2m.c
@@ -5,6 +5,7 @@
 #include <linux/amba/bus.h>
 #include <linux/amba/mmci.h>
 #include <linux/io.h>
+#include <linux/smp.h>
 #include <linux/init.h>
 #include <linux/of_address.h>
 #include <linux/of_fdt.h>
@@ -38,6 +39,7 @@
 #include <mach/motherboard.h>
 
 #include <plat/sched_clock.h>
+#include <plat/platsmp.h>
 
 #include "core.h"
 
@@ -530,6 +532,7 @@ static void __init v2m_init(void)
 
 MACHINE_START(VEXPRESS, "ARM-Versatile Express")
 	.atag_offset	= 0x100,
+	.smp		= smp_ops(vexpress_smp_ops),
 	.map_io		= v2m_map_io,
 	.init_early	= v2m_init_early,
 	.init_irq	= v2m_init_irq,
@@ -663,6 +666,7 @@ const static char *v2m_dt_match[] __initconst = {
 
 DT_MACHINE_START(VEXPRESS_DT, "ARM-Versatile Express")
 	.dt_compat	= v2m_dt_match,
+	.smp		= smp_ops(vexpress_smp_ops),
 	.map_io		= v2m_dt_map_io,
 	.init_early	= v2m_dt_init_early,
 	.init_irq	= v2m_dt_init_irq,
diff --git a/arch/arm/plat-versatile/include/plat/platsmp.h b/arch/arm/plat-versatile/include/plat/platsmp.h
new file mode 100644
index 0000000..50fb830
--- /dev/null
+++ b/arch/arm/plat-versatile/include/plat/platsmp.h
@@ -0,0 +1,14 @@
+/*
+ *  linux/arch/arm/plat-versatile/include/plat/platsmp.h
+ *
+ *  Copyright (C) 2011 ARM Ltd.
+ *  All Rights Reserved
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+extern void versatile_secondary_startup(void);
+extern void versatile_secondary_init(unsigned int cpu);
+extern int  versatile_boot_secondary(unsigned int cpu, struct task_struct *idle);
diff --git a/arch/arm/plat-versatile/platsmp.c b/arch/arm/plat-versatile/platsmp.c
index d7c5c17..39e60ac 100644
--- a/arch/arm/plat-versatile/platsmp.c
+++ b/arch/arm/plat-versatile/platsmp.c
@@ -40,7 +40,7 @@ static void __cpuinit write_pen_release(int val)
 
 static DEFINE_SPINLOCK(boot_lock);
 
-void __cpuinit platform_secondary_init(unsigned int cpu)
+void __cpuinit versatile_secondary_init(unsigned int cpu)
 {
 	/*
 	 * if any interrupts are already enabled for the primary
@@ -62,7 +62,7 @@ void __cpuinit platform_secondary_init(unsigned int cpu)
 	spin_unlock(&boot_lock);
 }
 
-int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
+int __cpuinit versatile_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	unsigned long timeout;
 
-- 
1.7.10


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab2EIHxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 03:53:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42704 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab2EIHxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 03:53:13 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: horms@verge.net.au, linux@arm.linux.org.uk, arnd@arndb.de,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        lethal@linux-sh.org, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>
Date: Wed, 09 May 2012 16:54:07 +0900
Message-Id: <20120509075407.5991.60556.sendpatchset@w520>
Subject: [PATCH] mach-shmobile: Emma Mobile EV2 SMP prototype code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Prototype code that adds SMP support to EMEV2.

At this point only the most basic form of SMP operation
is supported. TWD and CPU Hotplug support is excluded.

Based on V1 of the Emma Mobile EV2 code. Needs to be
reworked to coexist with DT. Work in progress.

Not-yet-signed-off-by: Magnus Damm <damm@opensource.se>
---

  Depends on the following series:
  "[PATCH 00/02] mach-shmobile: Emma Mobile EV2 - first shot"
  And the following patches:
  "[PATCH] serial8250-em: Emma Mobile UART driver V2"
  "[PATCH] clocksource: em_sti: Emma Mobile STI driver"

 arch/arm/mach-shmobile/Makefile              |    1 
 arch/arm/mach-shmobile/include/mach/common.h |    6 +
 arch/arm/mach-shmobile/platsmp.c             |   16 ++++
 arch/arm/mach-shmobile/setup-emev2.c         |    7 +
 arch/arm/mach-shmobile/smp-emev2.c           |   95 ++++++++++++++++++++++++++
 5 files changed, 125 insertions(+)

--- 0012/arch/arm/mach-shmobile/Makefile
+++ work/arch/arm/mach-shmobile/Makefile	2012-05-09 16:43:48.000000000 +0900
@@ -19,6 +19,7 @@ smp-y				:= platsmp.o headsmp.o
 smp-$(CONFIG_HOTPLUG_CPU)	+= hotplug.o
 smp-$(CONFIG_ARCH_SH73A0)	+= smp-sh73a0.o
 smp-$(CONFIG_ARCH_R8A7779)	+= smp-r8a7779.o
+smp-$(CONFIG_ARCH_EMEV2)	+= smp-emev2.o
 
 # Pinmux setup
 pfc-y				:=
--- 0011/arch/arm/mach-shmobile/include/mach/common.h
+++ work/arch/arm/mach-shmobile/include/mach/common.h	2012-05-09 16:43:48.000000000 +0900
@@ -91,4 +91,10 @@ extern void emev2_add_early_devices(void
 extern void emev2_add_standard_devices(void);
 extern void emev2_clock_init(void);
 
+extern unsigned int emev2_get_core_count(void);
+extern int emev2_platform_cpu_kill(unsigned int cpu);
+extern void emev2_secondary_init(unsigned int cpu);
+extern int emev2_boot_secondary(unsigned int cpu);
+extern void emev2_smp_prepare_cpus(void);
+
 #endif /* __ARCH_MACH_COMMON_H */
--- 0001/arch/arm/mach-shmobile/platsmp.c
+++ work/arch/arm/mach-shmobile/platsmp.c	2012-05-09 16:43:48.000000000 +0900
@@ -22,6 +22,7 @@
 
 #define is_sh73a0() (machine_is_ag5evm() || machine_is_kota2())
 #define is_r8a7779() machine_is_marzen()
+#define is_emev2() machine_is_kzm9d()
 
 static unsigned int __init shmobile_smp_get_core_count(void)
 {
@@ -31,6 +32,9 @@ static unsigned int __init shmobile_smp_
 	if (is_r8a7779())
 		return r8a7779_get_core_count();
 
+	if (is_emev2())
+		return emev2_get_core_count();
+
 	return 1;
 }
 
@@ -41,6 +45,9 @@ static void __init shmobile_smp_prepare_
 
 	if (is_r8a7779())
 		r8a7779_smp_prepare_cpus();
+
+	if (is_emev2())
+		emev2_smp_prepare_cpus();
 }
 
 int shmobile_platform_cpu_kill(unsigned int cpu)
@@ -48,6 +55,9 @@ int shmobile_platform_cpu_kill(unsigned
 	if (is_r8a7779())
 		return r8a7779_platform_cpu_kill(cpu);
 
+	if (is_emev2())
+		return emev2_platform_cpu_kill(cpu);
+
 	return 1;
 }
 
@@ -60,6 +70,9 @@ void __cpuinit platform_secondary_init(u
 
 	if (is_r8a7779())
 		r8a7779_secondary_init(cpu);
+
+	if (is_emev2())
+		emev2_secondary_init(cpu);
 }
 
 int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
@@ -70,6 +83,9 @@ int __cpuinit boot_secondary(unsigned in
 	if (is_r8a7779())
 		return r8a7779_boot_secondary(cpu);
 
+	if (is_emev2())
+		return emev2_boot_secondary(cpu);
+
 	return -ENOSYS;
 }
 
--- 0011/arch/arm/mach-shmobile/setup-emev2.c
+++ work/arch/arm/mach-shmobile/setup-emev2.c	2012-05-09 16:43:48.000000000 +0900
@@ -47,6 +47,13 @@ static struct map_desc emev2_io_desc[] _
 		.length		= SZ_128K,
 		.type		= MT_DEVICE
 	},
+	/* 2M mapping for SCU + L2 controller */
+	{
+		.virtual	= 0xf0000000,
+		.pfn		= __phys_to_pfn(0x1e000000),
+		.length		= SZ_2M,
+		.type		= MT_DEVICE
+	},
 };
 
 void __init emev2_map_io(void)
--- /dev/null
+++ work/arch/arm/mach-shmobile/smp-emev2.c	2012-05-09 16:44:26.000000000 +0900
@@ -0,0 +1,95 @@
+/*
+ * SMP support for Emma Mobile EV2
+ *
+ * Copyright (C) 2012  Renesas Solutions Corp.
+ * Copyright (C) 2012  Magnus Damm
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/smp.h>
+#include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <mach/common.h>
+#include <asm/smp_plat.h>
+#include <asm/smp_scu.h>
+#include <asm/hardware/gic.h>
+#include <asm/cacheflush.h>
+
+#define SMU_GENERAL_REG0	IOMEM(0xe01107c0)
+
+static void __iomem *scu_base_addr(void)
+{
+	return IOMEM(0xf0000000);
+}
+
+static DEFINE_SPINLOCK(scu_lock);
+static unsigned long tmp;
+
+static void modify_scu_cpu_psr(unsigned long set, unsigned long clr)
+{
+	void __iomem *scu_base = scu_base_addr();
+
+	spin_lock(&scu_lock);
+	tmp = readl(scu_base + 8);
+	tmp &= ~clr;
+	tmp |= set;
+	spin_unlock(&scu_lock);
+
+	/* disable cache coherency after releasing the lock */
+	writel(tmp, scu_base + 8);
+}
+
+unsigned int __init emev2_get_core_count(void)
+{
+	void __iomem *scu_base = scu_base_addr();
+
+	return scu_get_core_count(scu_base);
+}
+
+int emev2_platform_cpu_kill(unsigned int cpu)
+{
+	return 0; /* not supported yet */
+}
+
+void __cpuinit emev2_secondary_init(unsigned int cpu)
+{
+	gic_secondary_init(0);
+}
+
+int __cpuinit emev2_boot_secondary(unsigned int cpu)
+{
+	cpu = cpu_logical_map(cpu);
+
+	/* enable cache coherency */
+	modify_scu_cpu_psr(0, 3 << (cpu * 8));
+
+	/* Tell ROM loader about our vector (in headsmp.S) */
+	writel(__pa(shmobile_secondary_vector), SMU_GENERAL_REG0);
+
+	gic_raise_softirq(cpumask_of(cpu), 1);
+	return 0;
+}
+
+void __init emev2_smp_prepare_cpus(void)
+{
+	int cpu = cpu_logical_map(0);
+
+	scu_enable(scu_base_addr());
+
+	/* enable cache coherency on CPU0 */
+	modify_scu_cpu_psr(0, 3 << (cpu * 8));
+}

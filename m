Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298Ab2EPGor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:44:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49632 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759231Ab2EPGoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:44:25 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: horms@verge.net.au, linux@arm.linux.org.uk, arnd@arndb.de,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        lethal@linux-sh.org, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>
Date: Wed, 16 May 2012 15:45:25 +0900
Message-Id: <20120516064525.32286.93471.sendpatchset@w520>
In-Reply-To: <20120516064449.32286.77941.sendpatchset@w520>
References: <20120516064449.32286.77941.sendpatchset@w520>
Subject: [PATCH 04/08] mach-shmobile: Emma Mobile EV2 SMP support V3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This is V3 of Emma Mobile EV2 SMP support.

At this point only the most basic form of SMP operation
is supported. TWD and CPU Hotplug support is excluded.

Tied to both the Emma Mobile EV2 and the KZM9D board
due to the need to switch on board in platsmp.c and
the newly introduced need for static mappings.

The static mappings are needed to allow hardware
acces early during boot when SMP is initialized.
This early requirement forces us to also map in
the SMU registers.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Changes since V2:
 - none, just bumped up version to match the V3 series

 Changes since V1:
 - access SMU via separate function
 - rework SCU coherency setting function
 - make use of broken out emev2 header

 arch/arm/mach-shmobile/Makefile             |    1 
 arch/arm/mach-shmobile/board-kzm9d.c        |    1 
 arch/arm/mach-shmobile/clock-emev2.c        |   18 +++++
 arch/arm/mach-shmobile/include/mach/emev2.h |    7 +
 arch/arm/mach-shmobile/platsmp.c            |   17 ++++
 arch/arm/mach-shmobile/setup-emev2.c        |   24 ++++++
 arch/arm/mach-shmobile/smp-emev2.c          |   97 +++++++++++++++++++++++++++
 7 files changed, 165 insertions(+)

--- 0008/arch/arm/mach-shmobile/Makefile
+++ work/arch/arm/mach-shmobile/Makefile	2012-05-12 02:48:35.000000000 +0900
@@ -19,6 +19,7 @@ smp-y				:= platsmp.o headsmp.o
 smp-$(CONFIG_HOTPLUG_CPU)	+= hotplug.o
 smp-$(CONFIG_ARCH_SH73A0)	+= smp-sh73a0.o
 smp-$(CONFIG_ARCH_R8A7779)	+= smp-r8a7779.o
+smp-$(CONFIG_ARCH_EMEV2)	+= smp-emev2.o
 
 # Pinmux setup
 pfc-y				:=
--- 0008/arch/arm/mach-shmobile/board-kzm9d.c
+++ work/arch/arm/mach-shmobile/board-kzm9d.c	2012-05-12 03:23:09.000000000 +0900
@@ -27,6 +27,7 @@
 #include <asm/hardware/gic.h>
 
 MACHINE_START(KZM9D, "kzm9d")
+	.map_io		= emev2_map_io,
 	.init_early	= emev2_add_early_devices,
 	.nr_irqs	= NR_IRQS_LEGACY,
 	.init_irq	= emev2_init_irq,
--- 0007/arch/arm/mach-shmobile/clock-emev2.c
+++ work/arch/arm/mach-shmobile/clock-emev2.c	2012-05-12 03:34:20.000000000 +0900
@@ -40,6 +40,7 @@
 #define USIB2SCLKDIV 0x65c
 #define USIB3SCLKDIV 0x660
 #define STI_CLKSEL 0x688
+#define SMU_GENERAL_REG0 0x7c0
 
 /* not pretty, but hey */
 static void __iomem *smu_base;
@@ -50,6 +51,11 @@ static void emev2_smu_write(unsigned lon
 	iowrite32(value, smu_base + offs);
 }
 
+void emev2_set_boot_vector(unsigned long value)
+{
+	emev2_smu_write(value, SMU_GENERAL_REG0);
+}
+
 static struct clk_mapping smu_mapping = {
 	.phys	= EMEV2_SMU_BASE,
 	.len	= PAGE_SIZE,
@@ -194,6 +200,18 @@ static struct clk_lookup lookups[] = {
 void __init emev2_clock_init(void)
 {
 	int k, ret = 0;
+	static int is_setup;
+
+	/* yuck, this is ugly as hell, but the non-smp case of clocks
+	 * code is now designed to rely on ioremap() instead of static
+	 * entity maps. in the case of smp we need access to the SMU
+	 * register earlier than ioremap() is actually working without
+	 * any static maps. to enable SMP in ugly but with dynamic
+	 * mappings we have to call emev2_clock_init() from different
+	 * places depending on UP and SMP...
+	 */
+	if (is_setup++)
+		return;
 
 	smu_base = ioremap(EMEV2_SMU_BASE, PAGE_SIZE);
 	BUG_ON(!smu_base);
--- 0007/arch/arm/mach-shmobile/include/mach/emev2.h
+++ work/arch/arm/mach-shmobile/include/mach/emev2.h	2012-05-12 02:59:15.000000000 +0900
@@ -1,9 +1,16 @@
 #ifndef __ASM_EMEV2_H__
 #define __ASM_EMEV2_H__
 
+extern void emev2_map_io(void);
 extern void emev2_init_irq(void);
 extern void emev2_add_early_devices(void);
 extern void emev2_add_standard_devices(void);
 extern void emev2_clock_init(void);
+extern void emev2_set_boot_vector(unsigned long value);
+extern unsigned int emev2_get_core_count(void);
+extern int emev2_platform_cpu_kill(unsigned int cpu);
+extern void emev2_secondary_init(unsigned int cpu);
+extern int emev2_boot_secondary(unsigned int cpu);
+extern void emev2_smp_prepare_cpus(void);
 
 #endif /* __ASM_EMEV2_H__ */
--- 0001/arch/arm/mach-shmobile/platsmp.c
+++ work/arch/arm/mach-shmobile/platsmp.c	2012-05-12 03:20:28.000000000 +0900
@@ -19,9 +19,11 @@
 #include <asm/hardware/gic.h>
 #include <asm/mach-types.h>
 #include <mach/common.h>
+#include <mach/emev2.h>
 
 #define is_sh73a0() (machine_is_ag5evm() || machine_is_kota2() || machine_is_kzm9g())
 #define is_r8a7779() machine_is_marzen()
+#define is_emev2() machine_is_kzm9d()
 
 static unsigned int __init shmobile_smp_get_core_count(void)
 {
@@ -31,6 +33,9 @@ static unsigned int __init shmobile_smp_
 	if (is_r8a7779())
 		return r8a7779_get_core_count();
 
+	if (is_emev2())
+		return emev2_get_core_count();
+
 	return 1;
 }
 
@@ -41,6 +46,9 @@ static void __init shmobile_smp_prepare_
 
 	if (is_r8a7779())
 		r8a7779_smp_prepare_cpus();
+
+	if (is_emev2())
+		emev2_smp_prepare_cpus();
 }
 
 int shmobile_platform_cpu_kill(unsigned int cpu)
@@ -48,6 +56,9 @@ int shmobile_platform_cpu_kill(unsigned
 	if (is_r8a7779())
 		return r8a7779_platform_cpu_kill(cpu);
 
+	if (is_emev2())
+		return emev2_platform_cpu_kill(cpu);
+
 	return 1;
 }
 
@@ -60,6 +71,9 @@ void __cpuinit platform_secondary_init(u
 
 	if (is_r8a7779())
 		r8a7779_secondary_init(cpu);
+
+	if (is_emev2())
+		emev2_secondary_init(cpu);
 }
 
 int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
@@ -70,6 +84,9 @@ int __cpuinit boot_secondary(unsigned in
 	if (is_r8a7779())
 		return r8a7779_boot_secondary(cpu);
 
+	if (is_emev2())
+		return emev2_boot_secondary(cpu);
+
 	return -ENOSYS;
 }
 
--- 0007/arch/arm/mach-shmobile/setup-emev2.c
+++ work/arch/arm/mach-shmobile/setup-emev2.c	2012-05-12 03:37:24.000000000 +0900
@@ -34,6 +34,30 @@
 #include <asm/mach/time.h>
 #include <asm/hardware/gic.h>
 
+static struct map_desc emev2_io_desc[] __initdata = {
+#ifdef CONFIG_SMP
+	/* 128K entity map for 0xe0100000 (SMU) */
+	{
+		.virtual	= 0xe0100000,
+		.pfn		= __phys_to_pfn(0xe0100000),
+		.length		= SZ_128K,
+		.type		= MT_DEVICE
+	},
+	/* 2M mapping for SCU + L2 controller */
+	{
+		.virtual	= 0xf0000000,
+		.pfn		= __phys_to_pfn(0x1e000000),
+		.length		= SZ_2M,
+		.type		= MT_DEVICE
+	},
+#endif
+};
+
+void __init emev2_map_io(void)
+{
+	iotable_init(emev2_io_desc, ARRAY_SIZE(emev2_io_desc));
+}
+
 /* UART */
 static struct resource uart0_resources[] = {
 	[0]	= {
--- /dev/null
+++ work/arch/arm/mach-shmobile/smp-emev2.c	2012-05-12 03:38:32.000000000 +0900
@@ -0,0 +1,97 @@
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
+#include <mach/emev2.h>
+#include <asm/smp_plat.h>
+#include <asm/smp_scu.h>
+#include <asm/hardware/gic.h>
+#include <asm/cacheflush.h>
+
+#define EMEV2_SCU_BASE 0x1e000000
+
+static DEFINE_SPINLOCK(scu_lock);
+static void __iomem *scu_base;
+
+static void modify_scu_cpu_psr(unsigned long set, unsigned long clr)
+{
+	unsigned long tmp;
+
+	/* we assume this code is running on a different cpu
+	 * than the one that is changing coherency setting */
+	spin_lock(&scu_lock);
+	tmp = readl(scu_base + 8);
+	tmp &= ~clr;
+	tmp |= set;
+	writel(tmp, scu_base + 8);
+	spin_unlock(&scu_lock);
+
+}
+
+unsigned int __init emev2_get_core_count(void)
+{
+	if (!scu_base) {
+		scu_base = ioremap(EMEV2_SCU_BASE, PAGE_SIZE);
+		emev2_clock_init(); /* need ioremapped SMU */
+	}
+
+	WARN_ON_ONCE(!scu_base);
+
+	return scu_base ? scu_get_core_count(scu_base) : 1;
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
+	emev2_set_boot_vector(__pa(shmobile_secondary_vector));
+
+	gic_raise_softirq(cpumask_of(cpu), 1);
+	return 0;
+}
+
+void __init emev2_smp_prepare_cpus(void)
+{
+	int cpu = cpu_logical_map(0);
+
+	scu_enable(scu_base);
+
+	/* enable cache coherency on CPU0 */
+	modify_scu_cpu_psr(0, 3 << (cpu * 8));
+}

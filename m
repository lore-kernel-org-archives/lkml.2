Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab2ECOqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:46:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36809 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147Ab2ECOqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:46:07 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, arnd@arndb.de, linux-sh@vger.kernel.org,
        lethal@linux-sh.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        horms@verge.net.au, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>
Date: Thu, 03 May 2012 23:46:54 +0900
Message-Id: <20120503144654.6390.56399.sendpatchset@w520>
In-Reply-To: <20120503144645.6390.62303.sendpatchset@w520>
References: <20120503144645.6390.62303.sendpatchset@w520>
Subject: [PATCH 01/02] mach-shmobile: Emma Mobile EV2 SoC base support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add base support for the Emma Mobile EV2 SoC
including UART0, UART1, UART2, UART3 and STI.

No pinmux or GPIO support is in place yet and
SMP needs more work as well.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 arch/arm/mach-shmobile/Kconfig               |    5 
 arch/arm/mach-shmobile/Makefile              |    1 
 arch/arm/mach-shmobile/clock-emev2.c         |  206 ++++++++++++++++++++++++++
 arch/arm/mach-shmobile/include/mach/common.h |    6 
 arch/arm/mach-shmobile/intc-emev2.c          |   36 ++++
 arch/arm/mach-shmobile/setup-emev2.c         |  187 +++++++++++++++++++++++
 6 files changed, 441 insertions(+)

--- 0010/arch/arm/mach-shmobile/Kconfig
+++ work/arch/arm/mach-shmobile/Kconfig	2012-05-03 20:45:56.000000000 +0900
@@ -41,6 +41,11 @@ config ARCH_R8A7779
 	select ARM_GIC
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 
+config ARCH_EMEV2
+	bool "Emma Mobile EV2"
+	select CPU_V7
+	select ARM_GIC
+
 comment "SH-Mobile Board Type"
 
 config MACH_G3EVM
--- 0001/arch/arm/mach-shmobile/Makefile
+++ work/arch/arm/mach-shmobile/Makefile	2012-05-03 20:45:56.000000000 +0900
@@ -12,6 +12,7 @@ obj-$(CONFIG_ARCH_SH7372)	+= setup-sh737
 obj-$(CONFIG_ARCH_SH73A0)	+= setup-sh73a0.o clock-sh73a0.o intc-sh73a0.o
 obj-$(CONFIG_ARCH_R8A7740)	+= setup-r8a7740.o clock-r8a7740.o intc-r8a7740.o
 obj-$(CONFIG_ARCH_R8A7779)	+= setup-r8a7779.o clock-r8a7779.o intc-r8a7779.o
+obj-$(CONFIG_ARCH_EMEV2)	+= setup-emev2.o clock-emev2.o intc-emev2.o
 
 # SMP objects
 smp-y				:= platsmp.o headsmp.o
--- /dev/null
+++ work/arch/arm/mach-shmobile/clock-emev2.c	2012-05-03 20:46:44.000000000 +0900
@@ -0,0 +1,206 @@
+/*
+ * Emma Mobile EV2 clock framework support
+ *
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
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/sh_clk.h>
+#include <linux/clkdev.h>
+#include <mach/common.h>
+
+/* EMEV2 SMU registers */
+#define USIAU0_RSTCTRL 0xe0110094
+#define USIBU1_RSTCTRL 0xe01100ac
+#define USIBU2_RSTCTRL 0xe01100b0
+#define USIBU3_RSTCTRL 0xe01100b4
+#define STI_RSTCTRL 0xe0110124
+#define USIAU0GCLKCTRL 0xe01104a0
+#define USIBU1GCLKCTRL 0xe01104b8
+#define USIBU2GCLKCTRL 0xe01104bc
+#define USIBU3GCLKCTRL 0xe01104c0
+#define STIGCLKCTRL 0xe0110528
+#define USIAU0SCLKDIV 0xe011061c
+#define USIB2SCLKDIV 0xe011065c
+#define USIB3SCLKDIV 0xe0110660
+#define STI_CLKSEL 0xe0110688
+
+/* Fixed 32 KHz root clock from C32K pin */
+static struct clk c32k_clk = {
+	.rate           = 32768,
+};
+
+/* PLL3 multiplies C32K with 7000 */
+static unsigned long pll3_recalc(struct clk *clk)
+{
+	return clk->parent->rate * 7000;
+}
+
+static struct sh_clk_ops pll3_clk_ops = {
+	.recalc		= pll3_recalc,
+};
+
+static struct clk pll3_clk = {
+	.ops		= &pll3_clk_ops,
+	.parent		= &c32k_clk,
+};
+
+static struct clk *main_clks[] = {
+	&c32k_clk,
+	&pll3_clk,
+};
+
+enum { SCLKDIV_USIAU0, SCLKDIV_USIBU2, SCLKDIV_USIBU1, SCLKDIV_USIBU3,
+	SCLKDIV_NR };
+
+#define SCLKDIV(_reg, _shift)			\
+{								\
+	.parent		= &pll3_clk,				\
+	.enable_reg	= (void __iomem *)_reg,			\
+	.enable_bit	= _shift,				\
+}
+
+static struct clk sclkdiv_clks[SCLKDIV_NR] = {
+	[SCLKDIV_USIAU0] = SCLKDIV(USIAU0SCLKDIV, 0),
+	[SCLKDIV_USIBU2] = SCLKDIV(USIB2SCLKDIV, 16),
+	[SCLKDIV_USIBU1] = SCLKDIV(USIB2SCLKDIV, 0),
+	[SCLKDIV_USIBU3] = SCLKDIV(USIB3SCLKDIV, 0),
+};
+
+enum { GCLK_USIAU0_SCLK, GCLK_USIBU1_SCLK, GCLK_USIBU2_SCLK, GCLK_USIBU3_SCLK,
+	GCLK_STI_SCLK,
+	GCLK_NR };
+
+#define GCLK_SCLK(_parent, _reg) \
+{								\
+	.parent		= _parent,				\
+	.enable_reg	= (void __iomem *)_reg,			\
+	.enable_bit	= 1, /* SCLK_GCC */			\
+}
+
+static struct clk gclk_clks[GCLK_NR] = {
+	[GCLK_USIAU0_SCLK] = GCLK_SCLK(&sclkdiv_clks[SCLKDIV_USIAU0],
+				       USIAU0GCLKCTRL),
+	[GCLK_USIBU1_SCLK] = GCLK_SCLK(&sclkdiv_clks[SCLKDIV_USIBU1],
+				       USIBU1GCLKCTRL),
+	[GCLK_USIBU2_SCLK] = GCLK_SCLK(&sclkdiv_clks[SCLKDIV_USIBU2],
+				       USIBU2GCLKCTRL),
+	[GCLK_USIBU3_SCLK] = GCLK_SCLK(&sclkdiv_clks[SCLKDIV_USIBU3],
+				       USIBU3GCLKCTRL),
+	[GCLK_STI_SCLK] = GCLK_SCLK(&c32k_clk, STIGCLKCTRL),
+};
+
+static int emev2_gclk_enable(struct clk *clk)
+{
+	iowrite32(ioread32(clk->mapped_reg) | (1 << clk->enable_bit),
+		  clk->mapped_reg);
+	return 0;
+}
+
+static void emev2_gclk_disable(struct clk *clk)
+{
+	iowrite32(ioread32(clk->mapped_reg) & ~(1 << clk->enable_bit),
+		  clk->mapped_reg);
+}
+
+static struct sh_clk_ops emev2_gclk_clk_ops = {
+	.enable		= emev2_gclk_enable,
+	.disable	= emev2_gclk_disable,
+	.recalc		= followparent_recalc,
+};
+
+static int __init emev2_gclk_register(struct clk *clks, int nr)
+{
+	struct clk *clkp;
+	int ret = 0;
+	int k;
+
+	for (k = 0; !ret && (k < nr); k++) {
+		clkp = clks + k;
+		clkp->ops = &emev2_gclk_clk_ops;
+		ret |= clk_register(clkp);
+	}
+
+	return ret;
+}
+
+static unsigned long emev2_sclkdiv_recalc(struct clk *clk)
+{
+	unsigned int sclk_div;
+
+	sclk_div = (ioread32(clk->mapped_reg) >> clk->enable_bit) & 0xff;
+
+	return clk->parent->rate / (sclk_div + 1);
+}
+
+static struct sh_clk_ops emev2_sclkdiv_clk_ops = {
+	.recalc		= emev2_sclkdiv_recalc,
+};
+
+static int __init emev2_sclkdiv_register(struct clk *clks, int nr)
+{
+	struct clk *clkp;
+	int ret = 0;
+	int k;
+
+	for (k = 0; !ret && (k < nr); k++) {
+		clkp = clks + k;
+		clkp->ops = &emev2_sclkdiv_clk_ops;
+		ret |= clk_register(clkp);
+	}
+
+	return ret;
+}
+
+static struct clk_lookup lookups[] = {
+	CLKDEV_DEV_ID("serial8250-em.0", &gclk_clks[GCLK_USIAU0_SCLK]),
+	CLKDEV_DEV_ID("serial8250-em.1", &gclk_clks[GCLK_USIBU1_SCLK]),
+	CLKDEV_DEV_ID("serial8250-em.2", &gclk_clks[GCLK_USIBU2_SCLK]),
+	CLKDEV_DEV_ID("serial8250-em.3", &gclk_clks[GCLK_USIBU3_SCLK]),
+	CLKDEV_DEV_ID("em_sti.0", &gclk_clks[GCLK_STI_SCLK]),
+};
+
+void __init emev2_clock_init(void)
+{
+	int k, ret = 0;
+
+	/* setup STI timer to run on 37.768 kHz and deassert reset */
+	__raw_writel(0, STI_CLKSEL);
+	__raw_writel(1, STI_RSTCTRL);
+
+	/* deassert reset for UART0->UART3 */
+	__raw_writel(2, USIAU0_RSTCTRL);
+	__raw_writel(2, USIBU1_RSTCTRL);
+	__raw_writel(2, USIBU2_RSTCTRL);
+	__raw_writel(2, USIBU3_RSTCTRL);
+
+	for (k = 0; !ret && (k < ARRAY_SIZE(main_clks)); k++)
+		ret = clk_register(main_clks[k]);
+
+	if (!ret)
+		ret = emev2_sclkdiv_register(sclkdiv_clks, SCLKDIV_NR);
+
+	if (!ret)
+		ret = emev2_gclk_register(gclk_clks, GCLK_NR);
+
+	clkdev_add_table(lookups, ARRAY_SIZE(lookups));
+
+	if (!ret)
+		shmobile_clk_init();
+	else
+		panic("failed to setup emev2 clocks\n");
+}
--- 0003/arch/arm/mach-shmobile/include/mach/common.h
+++ work/arch/arm/mach-shmobile/include/mach/common.h	2012-05-03 20:45:56.000000000 +0900
@@ -85,4 +85,10 @@ extern void r8a7779_secondary_init(unsig
 extern int r8a7779_boot_secondary(unsigned int cpu);
 extern void r8a7779_smp_prepare_cpus(void);
 
+extern void emev2_init_irq(void);
+extern void emev2_map_io(void);
+extern void emev2_add_early_devices(void);
+extern void emev2_add_standard_devices(void);
+extern void emev2_clock_init(void);
+
 #endif /* __ARCH_MACH_COMMON_H */
--- /dev/null
+++ work/arch/arm/mach-shmobile/intc-emev2.c	2012-05-03 20:45:57.000000000 +0900
@@ -0,0 +1,36 @@
+/*
+ * Emma Mobile EV2 processor support - interrupts
+ *
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
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/io.h>
+#include <mach/common.h>
+#include <asm/hardware/gic.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+
+void __init emev2_init_irq(void)
+{
+	void __iomem *gic_dist_base = IOMEM(0xe0028000);
+	void __iomem *gic_cpu_base = IOMEM(0xe0020000);
+
+	/* use GIC to handle interrupts */
+	gic_init(0, 29, gic_dist_base, gic_cpu_base);
+}
--- /dev/null
+++ work/arch/arm/mach-shmobile/setup-emev2.c	2012-05-03 20:45:57.000000000 +0900
@@ -0,0 +1,187 @@
+/*
+ * Emma Mobile EV2 processor support
+ *
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
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/input.h>
+#include <linux/io.h>
+#include <mach/hardware.h>
+#include <mach/common.h>
+#include <mach/irqs.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/time.h>
+
+static struct map_desc emev2_io_desc[] __initdata = {
+	/* 128K entity map for 0xe0020000 (GIC) */
+	{
+		.virtual	= 0xe0020000,
+		.pfn		= __phys_to_pfn(0xe0020000),
+		.length		= SZ_128K,
+		.type		= MT_UNCACHED
+	},
+	/* 128K entity map for 0xe0100000 (SMU) */
+	{
+		.virtual	= 0xe0100000,
+		.pfn		= __phys_to_pfn(0xe0100000),
+		.length		= SZ_128K,
+		.type		= MT_DEVICE
+	},
+};
+
+void __init emev2_map_io(void)
+{
+	iotable_init(emev2_io_desc, ARRAY_SIZE(emev2_io_desc));
+}
+
+/* UART */
+static struct resource uart0_resources[] = {
+	[0]	= {
+		.start	= 0xe1020000,
+		.end	= 0xe1020038 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1]	= {
+		.start	= 40,
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device uart0_device = {
+	.name		= "serial8250-em",
+	.id		= 0,
+	.num_resources	= ARRAY_SIZE(uart0_resources),
+	.resource	= uart0_resources,
+};
+
+static struct resource uart1_resources[] = {
+	[0]	= {
+		.start	= 0xe1030000,
+		.end	= 0xe1030038 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1]	= {
+		.start	= 41,
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device uart1_device = {
+	.name		= "serial8250-em",
+	.id		= 1,
+	.num_resources	= ARRAY_SIZE(uart1_resources),
+	.resource	= uart1_resources,
+};
+
+static struct resource uart2_resources[] = {
+	[0]	= {
+		.start	= 0xe1040000,
+		.end	= 0xe1040038 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1]	= {
+		.start	= 42,
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device uart2_device = {
+	.name		= "serial8250-em",
+	.id		= 2,
+	.num_resources	= ARRAY_SIZE(uart2_resources),
+	.resource	= uart2_resources,
+};
+
+static struct resource uart3_resources[] = {
+	[0]	= {
+		.start	= 0xe1050000,
+		.end	= 0xe1050038 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1]	= {
+		.start	= 43,
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device uart3_device = {
+	.name		= "serial8250-em",
+	.id		= 3,
+	.num_resources	= ARRAY_SIZE(uart3_resources),
+	.resource	= uart3_resources,
+};
+
+/* STI */
+static struct resource sti_resources[] = {
+	[0] = {
+		.name	= "STI",
+		.start	= 0xe0180000,
+		.end	= 0xe0180053,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= 157,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device sti_device = {
+	.name		= "em_sti",
+	.id		= 0,
+	.resource	= sti_resources,
+	.num_resources	= ARRAY_SIZE(sti_resources),
+};
+
+static struct platform_device *emev2_early_devices[] __initdata = {
+	&uart0_device,
+	&uart1_device,
+	&uart2_device,
+	&uart3_device,
+};
+
+static struct platform_device *emev2_late_devices[] __initdata = {
+	&sti_device,
+};
+
+void __init emev2_add_standard_devices(void)
+{
+	emev2_clock_init();
+
+	platform_add_devices(emev2_early_devices,
+			     ARRAY_SIZE(emev2_early_devices));
+
+	platform_add_devices(emev2_late_devices,
+			     ARRAY_SIZE(emev2_late_devices));
+}
+
+void __init emev2_add_early_devices(void)
+{
+	shmobile_setup_delay(533, 1, 3); /* Cortex-A9 @ 533MHz */
+
+	early_platform_add_devices(emev2_early_devices,
+				   ARRAY_SIZE(emev2_early_devices));
+
+	/* setup early console here as well */
+	shmobile_setup_console();
+}
+

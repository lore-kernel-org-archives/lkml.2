Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab1HaV24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:28:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756263Ab1HaV2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:28:47 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, ming.lei@canonical.com,
        stern@rowland.harvard.edu, Mark Salter <msalter@redhat.com>
Subject: [PATCH 21/24] C6X: specific SoC support
Date: Wed, 31 Aug 2011 17:26:56 -0400
Message-Id: <1314826019-22330-22-git-send-email-msalter@redhat.com>
In-Reply-To: <1314826019-22330-1-git-send-email-msalter@redhat.com>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides the code for the four currently supported SoCs. Each SoC
provides a struct soc_ops which contains hooks for miscellaneous functionality
which does not fit well in any drivers. At setup_arch time, the device tree is
probed to find the correct soc_ops struct to use.

Most SoCs provide one or more sets of MMIO registers for various SoC-specific
low-level device setup and control. the device tree is parsed at setup_arch
time to find the base address of these registers.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/platforms/soc-6455.c |  389 +++++++++++++++++++++++++++++++++++++
 arch/c6x/platforms/soc-6457.c |  187 ++++++++++++++++++
 arch/c6x/platforms/soc-6472.c |  428 +++++++++++++++++++++++++++++++++++++++++
 arch/c6x/platforms/soc-6474.c |  244 +++++++++++++++++++++++
 4 files changed, 1248 insertions(+), 0 deletions(-)
 create mode 100644 arch/c6x/platforms/soc-6455.c
 create mode 100644 arch/c6x/platforms/soc-6457.c
 create mode 100644 arch/c6x/platforms/soc-6472.c
 create mode 100644 arch/c6x/platforms/soc-6474.c

diff --git a/arch/c6x/platforms/soc-6455.c b/arch/c6x/platforms/soc-6455.c
new file mode 100644
index 0000000..03fb618
--- /dev/null
+++ b/arch/c6x/platforms/soc-6455.c
@@ -0,0 +1,389 @@
+/*
+ *  Miscellaneous SoC specific code
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2011 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/clkdev.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <asm/clock.h>
+#include <asm/soc.h>
+#include "megamod-pic.h"
+#include "timer64.h"
+
+static struct clk_lookup c6455_clks[] = {
+	CLK(NULL, "pll1", &c6x_soc_pll1.sysclks[0]),
+	CLK(NULL, "pll1_sysclk2", &c6x_soc_pll1.sysclks[2]),
+	CLK(NULL, "pll1_sysclk3", &c6x_soc_pll1.sysclks[3]),
+	CLK(NULL, "pll1_sysclk4", &c6x_soc_pll1.sysclks[4]),
+	CLK(NULL, "pll1_sysclk5", &c6x_soc_pll1.sysclks[5]),
+	CLK(NULL, "core", &c6x_core_clk),
+	CLK("i2c_davinci.1", NULL, &c6x_i2c_clk),
+	CLK("watchdog", NULL, &c6x_watchdog_clk),
+	CLK("2c81800.mdio", NULL, &c6x_mdio_clk),
+	CLK("", NULL, NULL)
+};
+
+
+/* assumptions used for delay loop calculations */
+#define MIN_CLKIN1_KHz 10000
+#define MAX_CORE_KHz   1200000
+#define MIN_PLLOUT_KHz (MIN_CLKIN1_KHz/3)
+
+static void __init __setup_clocks(void)
+{
+	struct pll_data *pll = &c6x_soc_pll1;
+	struct clk *sysclks = pll->sysclks;
+
+	pll->flags = PLL_HAS_PRE | PLL_HAS_MUL;
+
+	pll->bypass_delay = 4 * (MAX_CORE_KHz/MIN_PLLOUT_KHz);
+	pll->reset_delay = 128 * (MAX_CORE_KHz/MIN_CLKIN1_KHz);
+	pll->lock_delay = 2000 * (MAX_CORE_KHz/MIN_CLKIN1_KHz);
+
+	sysclks[2].flags |= FIXED_DIV_PLL;
+	sysclks[2].div = 3;
+	sysclks[3].flags |= FIXED_DIV_PLL;
+	sysclks[3].div = 6;
+	sysclks[4].div = PLLDIV4;
+	sysclks[5].div = PLLDIV5;
+
+	c6x_core_clk.parent = &sysclks[0];
+	c6x_i2c_clk.parent = &sysclks[3];
+	c6x_watchdog_clk.parent = &sysclks[3];
+	c6x_mdio_clk.parent = &sysclks[3];
+
+	c6x_clks_init(c6455_clks);
+}
+
+/*
+ * Chip Level (SoC) Registers
+ */
+#define CHIP_DEVSTAT	0x00
+#define CHIP_PRI_ALLOC	0x04
+#define CHIP_JTAGID	0x08
+
+/*
+ * Device State Controller Registers
+ */
+#define DSCR_PERLOCK	0x04
+#define DSCR_PERCFG0	0x08
+#define DSCR_PERSTAT0	0x14
+#define DSCR_PERSTAT1	0x18
+#define DSCR_EMACCFG	0x20
+#define DSCR_PERCFG1	0x2C
+#define DSCR_EMUBUFPD	0x54
+
+#define DSCR_LOCKVAL	0x0f0a0b00
+
+/* device IDs passed to dscr_enable() and dscr_disable() */
+#define DSCR_TCP	0
+#define DSCR_VCP	1
+#define DSCR_EMAC	2
+#define DSCR_TIMER0	3
+#define DSCR_TIMER1	4
+#define DSCR_GPIO	5
+#define DSCR_I2C	6
+#define DSCR_BSP0	7
+#define DSCR_BSP1	8
+#define DSCR_HPI	9
+#define DSCR_PCI	10
+#define DSCR_UTOPIA	11
+#define DSCR_SRIO	15
+#define DSCR_EMIFA	16
+#define DSCR_DDR2	17
+
+#define PERSTAT_DISABLED	0
+#define PERSTAT_ENABLED		1
+#define PERSTAT_PWRDOWN		3
+#define PERSTAT_INPROGRESS	5
+
+static void __iomem *chip_base;
+static void __iomem *dscr_base;
+
+static inline void dscr_write(int offset, unsigned int val)
+{
+	soc_writel(val, dscr_base + offset);
+}
+
+static inline unsigned int dscr_read(int offset)
+{
+	return soc_readl(dscr_base + offset);
+}
+
+static inline void chip_write(int offset, unsigned int val)
+{
+	soc_writel(val, chip_base + offset);
+}
+
+static inline unsigned int chip_read(int offset)
+{
+	return soc_readl(chip_base + offset);
+}
+
+static inline void __write_percfg0(unsigned int val)
+{
+	void __iomem *_base = dscr_base;
+	int _key = DSCR_LOCKVAL;
+
+	/*
+	 * We need to ensure write to lock register and write to PERCFG0 are
+	 * in same fetch packet and that an interrupt doesn't occur between
+	 * them. The .align makes sure they're in the same packet and putting
+	 * them in the delay slots of the second branch ensures they are not
+	 * interrupted.
+	 */
+	asm volatile ("b	.s2	0f\n"
+		      "nop	5\n"
+		      "    .align 5\n"
+		      "0:\n"
+		      "b	.s2	0f\n"
+		      "stw	.D1T1	%2,*+%1(%4)\n"
+		      "stw	.D1T1	%0,*+%1(%3)\n"
+		      "nop\n"
+		      "nop\n"
+		      "nop\n"
+		      "0:\n"
+		      :
+		      : "a"(val), "a"(_base), "a"(_key),
+		      "Iu5"(DSCR_PERCFG0), "Iu5"(DSCR_PERLOCK)
+		);
+}
+
+/*
+ * Enable a peripheral through PERCFG registers.
+ */
+static void dscr_enable(int id)
+{
+	unsigned int val;
+	int shift;
+
+	if (id < 16) {
+		int status_reg;
+
+		shift = id * 2;
+
+		val = dscr_read(DSCR_PERCFG0);
+		val &= ~(3 << shift);
+		if (id == DSCR_SRIO) {
+			/* SRIO is handled differently than the others */
+			val |= (3 << shift);
+			__write_percfg0(val);
+			return;
+		}
+		val |= (1 << shift);
+		__write_percfg0(val);
+		/* wait for completion */
+		if (id < 10) {
+			status_reg = DSCR_PERSTAT0;
+			shift = id * 3;
+		} else {
+			status_reg = DSCR_PERSTAT1;
+			shift = (id - 10) * 3;
+		}
+		do {
+			val = dscr_read(status_reg);
+			val >>= shift;
+			val &= 7;
+		} while (val != PERSTAT_ENABLED);
+	} else {
+		shift = id - 16;
+		val = dscr_read(DSCR_PERCFG1);
+		dscr_write(DSCR_PERCFG1, val | (1 << shift));
+		__delay(100);
+	}
+}
+
+/*
+ * Disable a peripheral through PERCFG registers.
+ */
+static void dscr_disable(int id)
+{
+	unsigned int val;
+	int shift;
+
+	if (id < 16) {
+		shift = id * 2;
+
+		val = dscr_read(DSCR_PERCFG0);
+		val &= ~(3 << shift);
+		__write_percfg0(val);
+	}
+}
+
+static void __dev_enable(int id, unsigned int index, int enable)
+{
+	switch (id) {
+	case DSCR_TIMER0:
+		if (index == 1)
+			id = DSCR_TIMER1;
+		else if (index)
+			return;
+		break;
+	case DSCR_BSP0:
+		if (index == 1)
+			id = DSCR_BSP1;
+		else if (index)
+			return;
+		break;
+	default:
+		if (index)
+			return;
+		break;
+	}
+	if (enable)
+		dscr_enable(id);
+	else
+		dscr_disable(id);
+}
+
+static void c6455_dev_enable(enum soc_device_id id, int index)
+{
+	__dev_enable(id, index, 1);
+}
+
+static void c6455_dev_disable(enum soc_device_id id, int index)
+{
+	__dev_enable(id, index, 0);
+}
+
+static void __init __setup_dscr(void)
+{
+	struct device_node *node;
+
+	node = of_find_compatible_node(NULL, NULL, "ti,tms320c6455-dscr");
+	if (!node)
+		return;
+
+	dscr_base = of_iomap(node, 0);
+	of_node_put(node);
+	if (!dscr_base)
+		return;
+
+	node = of_find_node_by_type(NULL, "soc");
+	if (node) {
+		chip_base = of_iomap(node, 0);
+		of_node_put(node);
+
+		pr_info("DEVSTAT=%08x  PERCFG0=%08x PERCFG1=%08x\n",
+			 chip_read(CHIP_DEVSTAT), dscr_read(DSCR_PERCFG0),
+			 dscr_read(DSCR_PERCFG1));
+	}
+
+	SOC_DEVCONFIG_SUPPORT(TCP, DSCR_TCP);
+	SOC_DEVCONFIG_SUPPORT(VCP, DSCR_VCP);
+	SOC_DEVCONFIG_SUPPORT(EMAC, DSCR_EMAC);
+	SOC_DEVCONFIG_SUPPORT(TIMER, DSCR_TIMER0);
+	SOC_DEVCONFIG_SUPPORT(GPIO, DSCR_GPIO);
+	SOC_DEVCONFIG_SUPPORT(I2C, DSCR_I2C);
+	SOC_DEVCONFIG_SUPPORT(MCBSP, DSCR_BSP0);
+	SOC_DEVCONFIG_SUPPORT(HPI, DSCR_HPI);
+	SOC_DEVCONFIG_SUPPORT(PCI, DSCR_PCI);
+	SOC_DEVCONFIG_SUPPORT(UTOPIA, DSCR_UTOPIA);
+	SOC_DEVCONFIG_SUPPORT(SRIO, DSCR_SRIO);
+	SOC_DEVCONFIG_SUPPORT(EMIF, DSCR_EMIFA);
+	SOC_DEVCONFIG_SUPPORT(DDR2, DSCR_DDR2);
+
+	c6455_dev_enable(SOC_DEV_TIMER, 0);
+	c6455_dev_enable(SOC_DEV_TIMER, 1);
+
+#ifdef CONFIG_I2C
+	c6455_dev_enable(SOC_DEV_I2C, 0);
+#endif
+#ifdef CONFIG_GENERIC_GPIO
+	c6455_dev_enable(SOC_DEV_GPIO, 0);
+#endif
+#ifdef CONFIG_TMS320C64X_GEMAC
+	c6455_dev_enable(SOC_DEV_EMAC, 0);
+#endif
+}
+
+static unsigned int c6455_silicon_rev(char **strp)
+{
+	u32 jtagid = chip_read(CHIP_JTAGID);
+	u32 silicon_rev = (jtagid >> 28) & 0xf;
+
+	if (strp) {
+		switch (silicon_rev) {
+		case 0:
+			*strp = "1.1";
+			break;
+		case 1:
+			*strp = "2.0";
+			break;
+		case 2:
+			*strp = "2.1";
+			break;
+		case 4:
+			*strp = "3.1";
+			break;
+		default:
+			*strp = "unknown";
+			break;
+		}
+	}
+	return silicon_rev;
+}
+
+static int macsel_ids[] = {
+	[0] = MACSEL_MII,
+	[1] = MACSEL_RMII,
+	[2] = MACSEL_GMII,
+	[3] = MACSEL_RGMII,
+};
+
+static int c6455_macsel(unsigned int index)
+{
+	u32 devstat = chip_read(CHIP_DEVSTAT);
+	if (index > 0)
+		return MACSEL_UNKNOWN;
+
+	return macsel_ids[(devstat >> 9) & 3];
+}
+
+static void c6455_rmii_reset_ctl(int index, int assert)
+{
+	u32 val;
+
+	if (index)
+		return;
+
+	val = dscr_read(DSCR_EMACCFG);
+	if (assert)
+		dscr_write(DSCR_EMACCFG, val | (1 << 18));
+	else
+		dscr_write(DSCR_EMACCFG, val & ~(1 << 18));
+}
+
+static void __init c6455_setup_arch(void)
+{
+	/* so we won't get called twice */
+	soc_ops.setup_arch = NULL;
+
+	c6x_num_cores = 1;
+	__setup_dscr();
+	__setup_clocks();
+}
+
+define_soc(tms320c6455) {
+	.compat		= "ti,tms320c6455",
+	.name		= "TMS320C6455",
+	.setup_arch	= c6455_setup_arch,
+	.silicon_rev	= c6455_silicon_rev,
+	.init_IRQ	= megamod_pic_init,
+	.time_init	= timer64_init,
+	.macsel		= c6455_macsel,
+	.dev_enable	= c6455_dev_enable,
+	.dev_disable	= c6455_dev_disable,
+	.rmii_reset_ctl	= c6455_rmii_reset_ctl,
+};
diff --git a/arch/c6x/platforms/soc-6457.c b/arch/c6x/platforms/soc-6457.c
new file mode 100644
index 0000000..b6b5f7b
--- /dev/null
+++ b/arch/c6x/platforms/soc-6457.c
@@ -0,0 +1,187 @@
+/*
+ *  Miscellaneous SoC specific code
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2011 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/clkdev.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <asm/clock.h>
+#include <asm/soc.h>
+#include "psc.h"
+#include "megamod-pic.h"
+#include "timer64.h"
+
+static struct clk_lookup c6457_clks[] = {
+	CLK(NULL, "pll1", &c6x_soc_pll1.sysclks[0]),
+	CLK(NULL, "pll1_sysclk1", &c6x_soc_pll1.sysclks[1]),
+	CLK(NULL, "pll1_sysclk2", &c6x_soc_pll1.sysclks[2]),
+	CLK(NULL, "pll1_sysclk3", &c6x_soc_pll1.sysclks[3]),
+	CLK(NULL, "pll1_sysclk4", &c6x_soc_pll1.sysclks[4]),
+	CLK(NULL, "pll1_sysclk5", &c6x_soc_pll1.sysclks[5]),
+	CLK(NULL, "core", &c6x_core_clk),
+	CLK("i2c_davinci.1", NULL, &c6x_i2c_clk),
+	CLK("watchdog", NULL, &c6x_watchdog_clk),
+	CLK("2c81800.mdio", NULL, &c6x_mdio_clk),
+	CLK("", NULL, NULL)
+};
+
+/* assumptions used for delay loop calculations */
+#define MIN_CLKIN1_KHz 50000
+#define MAX_CORE_KHz   1200000
+#define MIN_PLLOUT_KHz (MIN_CLKIN1_KHz/3)
+
+static void __init __setup_clocks(void)
+{
+	struct pll_data *pll = &c6x_soc_pll1;
+	struct clk *sysclks = pll->sysclks;
+
+	pll->flags = PLL_HAS_MUL | PLL_HAS_POST;
+
+	pll->bypass_delay = 4 * (MAX_CORE_KHz/MIN_PLLOUT_KHz);
+	pll->reset_delay = 1000 * (MAX_CORE_KHz/MIN_CLKIN1_KHz);
+	pll->lock_delay = 2000 * (MAX_CORE_KHz/MIN_CLKIN1_KHz);
+
+	sysclks[1].flags |= FIXED_DIV_PLL;
+	sysclks[1].div = 1;
+	sysclks[2].flags |= FIXED_DIV_PLL;
+	sysclks[2].div = 3;
+	sysclks[3].flags |= FIXED_DIV_PLL;
+	sysclks[3].div = 6;
+	sysclks[4].div = PLLDIV4;
+	sysclks[5].div = PLLDIV5;
+
+	c6x_core_clk.parent = &sysclks[1];
+	c6x_i2c_clk.parent = &sysclks[3];
+	c6x_watchdog_clk.parent = &sysclks[5];
+	c6x_mdio_clk.parent = &sysclks[5];
+
+	c6x_clks_init(c6457_clks);
+}
+
+#define DSCR_JTAGID	0x018
+#define DSCR_DEVSTAT	0x020
+#define DSCR_KICK0	0x038
+#define DSCR_KICK1	0x03c
+#define DSCR_BOOTADDR	0x040
+#define DSCR_DEVCFG	0x110
+#define DSCR_MACID1	0x114
+#define DSCR_MACID2	0x118
+#define DSCR_PRI_ALLOC	0x11c
+#define DSCR_WDRSTSEL	0x120
+
+#define DSCR_KICK0_KEY		     0x83E70B13
+#define DSCR_KICK1_KEY		     0x95A4F1E0
+
+static void __iomem *dscr_base;
+
+static inline void dscr_write(int offset, unsigned int val)
+{
+	soc_writel(val, dscr_base + offset);
+}
+
+static inline unsigned int dscr_read(int offset)
+{
+	return soc_readl(dscr_base + offset);
+}
+
+static void __init __setup_dscr(void)
+{
+	struct device_node *node;
+
+	node = of_find_compatible_node(NULL, NULL, "ti,tms320c6457-dscr");
+	if (!node)
+		return;
+
+	dscr_base = of_iomap(node, 0);
+	of_node_put(node);
+	if (!dscr_base)
+		return;
+
+	printk(KERN_INFO "DEVSTAT=%08x  DEVCFG=%08x\n",
+	       dscr_read(DSCR_DEVSTAT), dscr_read(DSCR_DEVCFG));
+}
+
+static unsigned int c6457_silicon_rev(char **strp)
+{
+	u32 jtagid = dscr_read(DSCR_JTAGID);
+	u32 silicon_rev = (jtagid >> 28) & 0xf;
+
+	if (strp) {
+		switch (silicon_rev) {
+		case 0:
+			*strp = "1.1";
+			break;
+		case 1:
+			*strp = "1.2";
+			break;
+		case 2:
+			*strp = "1.3";
+			break;
+		case 3:
+			*strp = "1.4";
+			break;
+		default:
+			*strp = "unknown";
+			break;
+		}
+	}
+	return silicon_rev;
+}
+
+static int c6457_macsel(unsigned int index)
+{
+	/* all sgmii, all the time */
+	return MACSEL_SGMII;
+}
+
+static int c6457_mac_addr(unsigned int index, u8 *addr)
+{
+	unsigned int fuse0, fuse1;
+
+	if (index)
+		return 0;
+
+	fuse0 = dscr_read(DSCR_MACID1);
+	fuse1 = dscr_read(DSCR_MACID2);
+
+	addr[0] = fuse1 >> 8;
+	addr[1] = fuse1 >> 0;
+	addr[2] = fuse0 >> 24;
+	addr[3] = fuse0 >> 16;
+	addr[4] = fuse0 >> 8;
+	addr[5] = fuse0 >> 0;
+
+	return 1;
+}
+
+static void __init c6457_setup_arch(void)
+{
+	/* so we won't get called twice */
+	soc_ops.setup_arch = NULL;
+
+	c6x_num_cores = 1;
+	psc_init();
+	__setup_dscr();
+	__setup_clocks();
+}
+
+define_soc(tms320c6457) {
+	.compat		= "ti,tms320c6457",
+	.name		= "TMS320C6457",
+	.setup_arch	= c6457_setup_arch,
+	.silicon_rev	= c6457_silicon_rev,
+	.init_IRQ	= megamod_pic_init,
+	.time_init	= timer64_init,
+	.macsel		= c6457_macsel,
+	.mac_addr	= c6457_mac_addr,
+};
diff --git a/arch/c6x/platforms/soc-6472.c b/arch/c6x/platforms/soc-6472.c
new file mode 100644
index 0000000..0fce934
--- /dev/null
+++ b/arch/c6x/platforms/soc-6472.c
@@ -0,0 +1,428 @@
+/*
+ *  Miscellaneous SoC specific code
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2011 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/clkdev.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/delay.h>
+#include <asm/clock.h>
+#include <asm/soc.h>
+#include "psc.h"
+#include "megamod-pic.h"
+#include "timer64.h"
+
+static struct clk_lookup c6472_clks[] = {
+	CLK(NULL, "pll1", &c6x_soc_pll1.sysclks[0]),
+	CLK(NULL, "pll1_sysclk1", &c6x_soc_pll1.sysclks[1]),
+	CLK(NULL, "pll1_sysclk2", &c6x_soc_pll1.sysclks[2]),
+	CLK(NULL, "pll1_sysclk3", &c6x_soc_pll1.sysclks[3]),
+	CLK(NULL, "pll1_sysclk4", &c6x_soc_pll1.sysclks[4]),
+	CLK(NULL, "pll1_sysclk5", &c6x_soc_pll1.sysclks[5]),
+	CLK(NULL, "pll1_sysclk6", &c6x_soc_pll1.sysclks[6]),
+	CLK(NULL, "pll1_sysclk7", &c6x_soc_pll1.sysclks[7]),
+	CLK(NULL, "pll1_sysclk8", &c6x_soc_pll1.sysclks[8]),
+	CLK(NULL, "pll1_sysclk9", &c6x_soc_pll1.sysclks[9]),
+	CLK(NULL, "pll1_sysclk10", &c6x_soc_pll1.sysclks[10]),
+	CLK(NULL, "core", &c6x_core_clk),
+	CLK("i2c_davinci.1", NULL, &c6x_i2c_clk),
+	CLK("watchdog", NULL, &c6x_watchdog_clk),
+	CLK("2c81800.mdio", NULL, &c6x_mdio_clk),
+	CLK("", NULL, NULL)
+};
+
+/* assumptions used for delay loop calculations */
+#define MIN_CLKIN1_KHz 15625
+#define MAX_CORE_KHz   700000
+#define MIN_PLLOUT_KHz MIN_CLKIN1_KHz
+
+static void __init __setup_clocks(void)
+{
+	struct pll_data *pll = &c6x_soc_pll1;
+	struct clk *sysclks = pll->sysclks;
+	int i;
+
+	pll->flags = PLL_HAS_MUL;
+
+	pll->bypass_delay = 4 * (MAX_CORE_KHz/MIN_PLLOUT_KHz);
+	pll->reset_delay = 256 * (MAX_CORE_KHz/MIN_CLKIN1_KHz);
+	pll->lock_delay = 2000 * (MAX_CORE_KHz/MIN_CLKIN1_KHz);
+
+	for (i = 1; i <= 6; i++) {
+		sysclks[i].flags |= FIXED_DIV_PLL;
+		sysclks[i].div = 1;
+	}
+
+	sysclks[7].flags |= FIXED_DIV_PLL;
+	sysclks[7].div = 3;
+	sysclks[8].flags |= FIXED_DIV_PLL;
+	sysclks[8].div = 6;
+	sysclks[9].flags |= FIXED_DIV_PLL;
+	sysclks[9].div = 2;
+	sysclks[10].div = PLLDIV10;
+
+	c6x_core_clk.parent = &sysclks[get_coreid() + 1];
+	c6x_i2c_clk.parent = &sysclks[8];
+	c6x_watchdog_clk.parent = &sysclks[8];
+	c6x_mdio_clk.parent = &sysclks[5];
+
+	c6x_clks_init(c6472_clks);
+}
+
+#define DSCR_BASE_ADDR	0x2a80000
+#define DSCR_SIZE	0x1000
+
+#define DSCR_DEVSTAT	0x000
+#define DSCR_PRIALLOC	0x004
+#define DSCR_DEVID	0x008
+#define DSCR_DEVCTL	0x200
+#define DSCR_DEVCTL_KEY	0x204
+#define DSCR_RMIIRESET0	0x208
+#define DSCR_RMIIRESET1	0x20c
+
+#define DSCR_HOSTPRIV	0x40c
+#define DSCR_PRIVPERM	0x41c
+#define DSCR_PRIVKEY	0x420
+
+#define DSCR_NMIGR0	0x500
+#define DSCR_NMIGR1	0x504
+#define DSCR_NMIGR2	0x508
+#define DSCR_NMIGR3	0x50c
+#define DSCR_NMIGR4	0x510
+#define DSCR_NMIGR5	0x514
+
+#define DSCR_IPCGR0	0x540
+#define DSCR_IPCGR1	0x544
+#define DSCR_IPCGR2	0x548
+#define DSCR_IPCGR3	0x54c
+#define DSCR_IPCGR4	0x550
+#define DSCR_IPCGR5	0x554
+#define DSCR_IPCGRH	0x57c
+
+#define DSCR_IPCAR0	0x580
+#define DSCR_IPCAR1	0x584
+#define DSCR_IPCAR2	0x588
+#define DSCR_IPCAR3	0x58c
+#define DSCR_IPCAR4	0x590
+#define DSCR_IPCAR5	0x594
+#define DSCR_IPCARH	0x5bc
+
+#define DSCR_EFUSE0	0x700
+#define DSCR_EFUSE1	0x704
+#define DSCR_SILICON_ID	0x70c
+
+#define DSCR_TPMGR	0x714
+
+#define DSCR_RSTMUX0	0x718
+#define DSCR_RSTMUX1	0x71c
+#define DSCR_RSTMUX2	0x720
+#define DSCR_RSTMUX3	0x724
+#define DSCR_RSTMUX4	0x728
+#define DSCR_RSTMUX5	0x72c
+
+#define DSCR_LOCKVAL		     0xa1e183a
+
+/* device IDs (actually bit masks) passed to dscr_enable() and dscr_disable() */
+#define DSCR_HPI	BIT(0)
+#define DSCR_UTOPIA	(BIT(1) | BIT(2))
+#define DSCR_TSIP0	(BIT(3) | BIT(4) | BIT(5))
+#define DSCR_TSIP1	(BIT(6) | BIT(7) | BIT(8))
+#define DSCR_TSIP2	(BIT(9) | BIT(10) | BIT(11))
+#define DSCR_EMAC1	BIT(12)
+
+static void __iomem *dscr_base;
+
+static inline void dscr_write(int offset, unsigned int val)
+{
+	soc_writel(val, dscr_base + offset);
+}
+
+static inline unsigned int dscr_read(int offset)
+{
+	return soc_readl(dscr_base + offset);
+}
+
+static inline void __write_devctl(unsigned int val)
+{
+	int _base = DSCR_BASE_ADDR + DSCR_DEVCTL;
+	int _key = DSCR_LOCKVAL;
+
+	/*
+	 * We need to ensure write to lock register and write to DEVCTL are
+	 * not interrupted. Putting them both in the delay slots of a branch
+	 * ensures they are not interrupted.
+	 */
+	asm volatile ("b	.s2	0f\n"
+		      "stw	.D1T1	%2,*+%1(%3)\n"
+		      "stw	.D1T1	%0,*%1\n"
+		      "nop\n"
+		      "nop\n"
+		      "nop\n"
+		      "0:\n"
+		      :
+		      : "a"(val), "a"(_base), "a"(_key),
+		      "Iu5"(DSCR_DEVCTL_KEY - DSCR_DEVCTL)
+		);
+}
+
+/*
+ * Enable a peripheral through PERCFG registers.
+ */
+void dscr_enable(int mask)
+{
+	unsigned int val;
+
+	val = dscr_read(DSCR_DEVCTL);
+
+	/* only need to enable ones that are currently disabled */
+	mask &= ~val;
+	if (mask == 0)
+		return;
+
+	__write_devctl(val | mask);
+}
+
+/*
+ * Disable a peripheral through PERCFG registers.
+ */
+static void dscr_disable(int mask)
+{
+	u32 val;
+
+	val = dscr_read(DSCR_DEVCTL);
+
+	/* only need to disable ones that are currently enabled */
+	mask &= val;
+	if (mask == 0)
+		return;
+
+	__write_devctl(val & ~mask);
+}
+
+static void __dev_enable(int id, unsigned int index, int enable)
+{
+	switch (id) {
+	case DSCR_EMAC1:
+		if (index != 1)
+			return;
+		break;
+	case DSCR_TSIP0:
+		if (index == 1)
+			id = DSCR_TSIP1;
+		else if (index == 2)
+			id = DSCR_TSIP2;
+		else if (index)
+			return;
+		break;
+	default:
+		if (index)
+			return;
+		break;
+	}
+	if (enable)
+		dscr_enable(id);
+	else
+		dscr_disable(id);
+}
+
+static void c6472_dev_enable(enum soc_device_id id, int index)
+{
+	__dev_enable(id, index, 1);
+}
+
+static void c6472_dev_disable(enum soc_device_id id, int index)
+{
+	__dev_enable(id, index, 0);
+}
+
+static void __init __setup_dscr(void)
+{
+	struct device_node *node;
+
+	node = of_find_compatible_node(NULL, NULL, "ti,tms320c6472-dscr");
+	if (!node)
+		return;
+
+	dscr_base = of_iomap(node, 0);
+	of_node_put(node);
+	if (!dscr_base)
+		return;
+
+	SOC_DEVCONFIG_SUPPORT(HPI, DSCR_HPI);
+	SOC_DEVCONFIG_SUPPORT(UTOPIA, DSCR_UTOPIA);
+	SOC_DEVCONFIG_SUPPORT(EMAC, DSCR_EMAC1);
+	SOC_DEVCONFIG_SUPPORT(TSIP, DSCR_TSIP0);
+
+	pr_info("DEVSTAT=%08x  DEVCTL=%08x\n",
+		dscr_read(DSCR_DEVSTAT), dscr_read(DSCR_DEVCTL));
+
+	/* Do not allow user mode to access SoC device I/O */
+	dscr_write(DSCR_PRIVKEY, 0xbea7);
+	dscr_write(DSCR_PRIVPERM, 0xaaaaaaaa);
+	dscr_write(DSCR_PRIVKEY, 0);
+}
+
+static unsigned int c6472_silicon_rev(char **strp)
+{
+	u32 silicon_rev = dscr_read(DSCR_SILICON_ID);
+	int major, minor;
+	static char __str[6];
+
+	major = (silicon_rev >> 20) & 0xf;
+	minor = (silicon_rev >> 16) & 0xf;
+	if (strp) {
+		sprintf(__str, "%d.%d", major, minor);
+		*strp = __str;
+	}
+	return (major << 4) | minor;
+}
+
+static int macsel0_ids[] = {
+	[0] = MACSEL_MII,
+	[1] = MACSEL_RMII,
+	[2] = MACSEL_GMII,
+	[3] = MACSEL_RGMII,
+	[4] = MACSEL_UNKNOWN,
+	[5] = MACSEL_S3MII,
+	[6] = MACSEL_UNKNOWN,
+	[7] = MACSEL_DISABLED,
+};
+
+static int macsel1_ids[] = {
+	[0] = MACSEL_UNKNOWN,
+	[1] = MACSEL_S3MII,
+	[2] = MACSEL_RGMII,
+	[3] = MACSEL_RMII,
+};
+
+
+#define RESET_STATUS	0x0000
+#define BOOT_COMPLETE	0x0004
+#define BOOT_PROGRESS	0x0008
+
+static void __iomem *boot_base;
+
+static inline void boot_write(int offset, unsigned int val)
+{
+	soc_writel(val, boot_base + offset);
+}
+
+void __setup_boot_control(void)
+{
+	struct device_node *node;
+
+	node = of_find_compatible_node(NULL, NULL,
+				       "ti,tms320c6472-boot-controller");
+	if (!node)
+		return;
+
+	boot_base = of_iomap(node, 0);
+	of_node_put(node);
+}
+
+static int c6472_macsel(unsigned int index)
+{
+	u32 devstat = dscr_read(DSCR_DEVSTAT);
+
+	if (index == 0)
+		return macsel0_ids[(devstat >> 8) & 7];
+	if (index == 1)
+		return macsel1_ids[(devstat >> 22) & 3];
+	return MACSEL_UNKNOWN;
+}
+
+static int c6472_mac_addr(unsigned int index, u8 *addr)
+{
+	unsigned int fuse0, fuse1;
+
+	if (index)
+		return 0;
+
+	fuse0 = dscr_read(DSCR_EFUSE0);
+	fuse1 = dscr_read(DSCR_EFUSE1);
+
+	addr[0] = fuse0 >> 24;
+	addr[1] = fuse0 >> 16;
+	addr[2] = fuse0 >> 8;
+	addr[3] = fuse0 >> 0;
+	addr[4] = fuse1 >> 24;
+	addr[5] = fuse1 >> 16;
+
+	return 1;
+}
+
+static void c6472_boot_core(int corenum)
+{
+	psc_module_reset_release(corenum);
+	boot_write(BOOT_COMPLETE, 0x3f);
+}
+
+static void c6472_reset_core(int corenum)
+{
+	psc_module_reset(corenum);
+}
+
+static void c6472_rmii_reset_ctl(int index, int assert)
+{
+	u32 reg;
+
+	if (index == 0)
+		reg = DSCR_RMIIRESET0;
+	else if (index == 1)
+		reg = DSCR_RMIIRESET1;
+	else
+		return;
+
+	dscr_write(reg, assert ? 1 : 0);
+}
+
+static void __init c6472_setup_arch(void)
+{
+	/* so we won't get called twice */
+	soc_ops.setup_arch = NULL;
+
+	c6x_num_cores = 6;
+	__setup_dscr();
+
+	psc_init();
+
+	/* EMAC 0 */
+	psc_module_reset_release(7);
+	psc_module_on(7);
+
+	/* EMAC 1 */
+	psc_module_reset_release(8);
+	psc_module_on(8);
+
+	psc_transition_domains(1);
+
+	dscr_enable(DSCR_EMAC1);
+
+	__setup_clocks();
+}
+
+define_soc(tms320c6472) {
+	.compat		= "ti,tms320c6472",
+	.name		= "TMS320C6472",
+	.setup_arch	= c6472_setup_arch,
+	.init_IRQ	= megamod_pic_init,
+	.time_init	= timer64_init,
+	.silicon_rev	= c6472_silicon_rev,
+	.macsel		= c6472_macsel,
+	.mac_addr	= c6472_mac_addr,
+	.boot_core	= c6472_boot_core,
+	.reset_core	= c6472_reset_core,
+	.dev_enable	= c6472_dev_enable,
+	.dev_disable	= c6472_dev_disable,
+	.rmii_reset_ctl	= c6472_rmii_reset_ctl,
+};
diff --git a/arch/c6x/platforms/soc-6474.c b/arch/c6x/platforms/soc-6474.c
new file mode 100644
index 0000000..e3d0f9a
--- /dev/null
+++ b/arch/c6x/platforms/soc-6474.c
@@ -0,0 +1,244 @@
+/*
+ *  Miscellaneous SoC specific code
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2011 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/clkdev.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/delay.h>
+#include <asm/clock.h>
+#include <asm/soc.h>
+#include "megamod-pic.h"
+#include "timer64.h"
+#include "psc.h"
+
+static struct clk_lookup c6474_clks[] = {
+	CLK(NULL, "pll1", &c6x_soc_pll1.sysclks[0]),
+	CLK(NULL, "pll1_sysclk7", &c6x_soc_pll1.sysclks[7]),
+	CLK(NULL, "pll1_sysclk9", &c6x_soc_pll1.sysclks[9]),
+	CLK(NULL, "pll1_sysclk10", &c6x_soc_pll1.sysclks[10]),
+	CLK(NULL, "pll1_sysclk11", &c6x_soc_pll1.sysclks[11]),
+	CLK(NULL, "pll1_sysclk12", &c6x_soc_pll1.sysclks[12]),
+	CLK(NULL, "pll1_sysclk13", &c6x_soc_pll1.sysclks[13]),
+	CLK(NULL, "core", &c6x_core_clk),
+	CLK("i2c_davinci.1", NULL, &c6x_i2c_clk),
+	CLK("mcbsp.1", NULL, &c6x_mcbsp1_clk),
+	CLK("mcbsp.2", NULL, &c6x_mcbsp2_clk),
+	CLK("watchdog", NULL, &c6x_watchdog_clk),
+	CLK("2c81800.mdio", NULL, &c6x_mdio_clk),
+	CLK("", NULL, NULL)
+};
+
+/* assumptions used for delay loop calculations */
+#define MIN_CLKIN1_KHz 40000
+#define MAX_CORE_KHz   1200000
+#define MIN_PLLOUT_KHz MIN_CLKIN1_KHz
+
+static void __init __setup_clocks(void)
+{
+	struct pll_data *pll = &c6x_soc_pll1;
+	struct clk *sysclks = pll->sysclks;
+
+	pll->flags = PLL_HAS_MUL;
+
+	pll->bypass_delay = 4 * (MAX_CORE_KHz/MIN_PLLOUT_KHz);
+	pll->reset_delay = 1000 * (MAX_CORE_KHz/MIN_CLKIN1_KHz);
+	pll->lock_delay = 2000 * (MAX_CORE_KHz/MIN_CLKIN1_KHz);
+
+	sysclks[7].flags |= FIXED_DIV_PLL;
+	sysclks[7].div = 1;
+	sysclks[9].flags |= FIXED_DIV_PLL;
+	sysclks[9].div = 3;
+	sysclks[10].flags |= FIXED_DIV_PLL;
+	sysclks[10].div = 6;
+
+	sysclks[11].div = PLLDIV11;
+
+	sysclks[12].flags |= FIXED_DIV_PLL;
+	sysclks[12].div = 2;
+
+	sysclks[13].div = PLLDIV13;
+
+	c6x_core_clk.parent = &sysclks[7];
+	c6x_i2c_clk.parent = &sysclks[10];
+	c6x_watchdog_clk.parent = &sysclks[10];
+	c6x_mcbsp1_clk.parent = &sysclks[10];
+	c6x_mcbsp2_clk.parent = &sysclks[10];
+
+	c6x_clks_init(c6474_clks);
+}
+
+#define DSCR_DEVCFG1	0x000
+#define DSCR_DEVSTAT	0x004
+#define DSCR_BOOTADDR0	0x008
+#define DSCR_BOOTADDR1	0x00c
+#define DSCR_BOOTADDR2	0x010
+#define DSCR_JTAGID	0x014
+#define DSCR_EFUSE0	0x034
+#define DSCR_EFUSE1	0x038
+#define DSCR_PRI_ALLOC	0x03c
+#define DSCR_IPCGR0	0x100
+#define DSCR_IPCGR1	0x104
+#define DSCR_IPCGR2	0x108
+#define DSCR_IPCAR0	0x140
+#define DSCR_IPCAR1	0x144
+#define DSCR_IPCAR2	0x148
+
+static void __iomem *dscr_base;
+
+static inline void dscr_write(int offset, unsigned int val)
+{
+	soc_writel(val, dscr_base + offset);
+}
+
+static inline unsigned int dscr_read(int offset)
+{
+	return soc_readl(dscr_base + offset);
+}
+
+static void __init __setup_dscr(void)
+{
+	struct device_node *node;
+
+	node = of_find_compatible_node(NULL, NULL, "ti,tms320c6474-dscr");
+	if (!node)
+		return;
+
+	dscr_base = of_iomap(node, 0);
+	of_node_put(node);
+	if (!dscr_base)
+		return;
+
+	printk(KERN_INFO "DEVSTAT=%08x  DEVCFG=%08x\n",
+	       dscr_read(DSCR_DEVSTAT), dscr_read(DSCR_DEVCFG1));
+}
+
+static unsigned int c6474_silicon_rev(char **strp)
+{
+	u32   jtagid_val  = dscr_read(DSCR_JTAGID);
+	u32   silicon_rev = (jtagid_val >> 28) & 0xf;
+	char *str;
+
+	if (strp) {
+		switch (silicon_rev) {
+		case 0x1:
+			str = "1.2";
+			break;
+		case 0x2:
+			str = "1.3";
+			break;
+		case 0x3:
+			str = "2.0";
+			break;
+		case 0x4:
+			str = "2.1";
+			break;
+		default:
+			str = "unknown";
+			break;
+		}
+		*strp = str;
+	}
+	return silicon_rev;
+}
+
+static int c6474_macsel(unsigned int index)
+{
+	/* all sgmii, all the time */
+	return MACSEL_SGMII;
+}
+
+static int c6474_mac_addr(unsigned int index, u8 *addr)
+{
+	unsigned int fuse0, fuse1;
+
+	if (index)
+		return 0;
+
+	fuse0 = dscr_read(DSCR_EFUSE0);
+	fuse1 = dscr_read(DSCR_EFUSE1);
+
+	addr[0] = fuse1 >> 8;
+	addr[1] = fuse1 >> 0;
+	addr[2] = fuse0 >> 24;
+	addr[3] = fuse0 >> 16;
+	addr[4] = fuse0 >> 8;
+	addr[5] = fuse0 >> 0;
+
+	return 1;
+}
+
+static void c6474_boot_core(int corenum)
+{
+	static int first_time = 1;
+
+	if (first_time) {
+		soc_assert_event(1 << 4);
+		first_time = 0;
+	}
+	psc_module_reset_release(3 + corenum);
+}
+
+static void c6474_reset_core(int corenum)
+{
+	psc_module_reset(3 + corenum);
+}
+
+static void __init c6474_setup_arch(void)
+{
+	/* so we won't get called twice */
+	soc_ops.setup_arch = NULL;
+
+	c6x_num_cores = 3;
+
+	/* setup power registers */
+	psc_init();
+	__setup_dscr();
+
+	/* AIF */
+	psc_domain_on(1);
+	psc_module_on(6);
+
+	/* SRIO */
+	psc_domain_on(2);
+	psc_module_on(7);
+
+	/* reserved */
+	psc_domain_on(3);
+	psc_module_on(8);
+
+	/* TCP */
+	psc_domain_on(4);
+	psc_module_on(9);
+
+	/* VCP */
+	psc_domain_on(5);
+	psc_module_on(10);
+
+	psc_transition_domains(0x3f);
+
+	__setup_clocks();
+}
+
+define_soc(tms320c6474) {
+	.compat		= "ti,tms320c6474",
+	.name		= "TMS320C6474",
+	.setup_arch	= c6474_setup_arch,
+	.init_IRQ	= megamod_pic_init,
+	.time_init	= timer64_init,
+	.silicon_rev	= c6474_silicon_rev,
+	.macsel		= c6474_macsel,
+	.mac_addr	= c6474_mac_addr,
+	.boot_core	= c6474_boot_core,
+	.reset_core	= c6474_reset_core,
+};
-- 
1.7.6


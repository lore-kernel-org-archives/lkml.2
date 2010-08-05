Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324Ab0HEMeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 08:34:18 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:42973 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933288Ab0HEMeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 08:34:10 -0400
From: Philippe Langlais <philippe.langlais@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <gregkh@suse.de>
Cc: <akpm@linux-foundation.org>, <STEricsson_nomadik_linux@list.st.com>,
        <etienne.carriere@stericsson.com>, <vincent.guittot@stericsson.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
Subject: [PATCH 2/5] U6715 clocks gating management U6 clock generic driver & U6715 cgu clock specific
Date: Thu, 5 Aug 2010 14:28:52 +0200
Message-ID: <1281011335-25761-3-git-send-email-philippe.langlais@stericsson.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1281011335-25761-1-git-send-email-philippe.langlais@stericsson.com>
References: <1281011335-25761-1-git-send-email-philippe.langlais@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philippe Langlais <philippe.langlais@stericsson.com>
---
 arch/arm/Kconfig                          |    1 +
 arch/arm/mach-u67xx/Makefile              |    5 +-
 arch/arm/mach-u67xx/cgu.c                 |  753 +++++++++++++++++++++++++
 arch/arm/mach-u67xx/cgu.h                 |   57 ++
 arch/arm/mach-u67xx/clock_data_u67xx.c    |  864 +++++++++++++++++++++++++++++
 arch/arm/plat-u6xxx/Makefile              |    2 +-
 arch/arm/plat-u6xxx/clock.c               |  621 +++++++++++++++++++++
 arch/arm/plat-u6xxx/include/mach/clkdev.h |   13 +
 arch/arm/plat-u6xxx/include/mach/clock.h  |  378 +++++++++++++
 9 files changed, 2692 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/mach-u67xx/cgu.c
 create mode 100644 arch/arm/mach-u67xx/cgu.h
 create mode 100644 arch/arm/mach-u67xx/clock_data_u67xx.c
 create mode 100644 arch/arm/plat-u6xxx/clock.c
 create mode 100644 arch/arm/plat-u6xxx/include/mach/clkdev.h
 create mode 100644 arch/arm/plat-u6xxx/include/mach/clock.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1ae089c..a250f2e 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -742,6 +742,7 @@ config ARCH_U300
 config PLAT_U6XXX
 	bool "ST-Ericsson U6XXX Series"
 	select CPU_ARM926T
+	select COMMON_CLKDEV
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
 	help
diff --git a/arch/arm/mach-u67xx/Makefile b/arch/arm/mach-u67xx/Makefile
index 38cf624..d4e35a7 100644
--- a/arch/arm/mach-u67xx/Makefile
+++ b/arch/arm/mach-u67xx/Makefile
@@ -5,7 +5,10 @@
 ## Object file lists.
 
 # Common support
-obj-y			:= devices.o
+obj-y			:= devices.o cgu.o
+
+# Specific machine support
+obj-y += clock_data_u67xx.o
 
 # Specific board support
 obj-$(CONFIG_MACH_U67XX_WAVEC_2GB) += board_u67xx_wavex.o
diff --git a/arch/arm/mach-u67xx/cgu.c b/arch/arm/mach-u67xx/cgu.c
new file mode 100644
index 0000000..68401ff
--- /dev/null
+++ b/arch/arm/mach-u67xx/cgu.c
@@ -0,0 +1,753 @@
+/*
+ *  arch/arm/mach-u67xx/cgu.c
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Arnaud Troel <arnaud.troel@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * U67XX Clock Gating Unit basic driver/wrapper
+ * Based on the code from Michel Jaouen
+ */
+
+/*#define DEBUG */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/string.h>
+#include <linux/delay.h>
+#include <asm/clkdev.h>
+#include <mach/hardware.h>
+#include <mach/clock.h>
+#include "cgu.h"
+
+#define MODULE_NAME "U6_CGU"
+#define PKMOD MODULE_NAME ": "
+
+/*
+ * Public U6 platform access clock functions
+ */
+
+/**
+ * @brief Disable a device clock.
+ * @param clk clock description structure
+ */
+void u6_clk_disable(struct clk *clk)
+{
+	/*    BUG_ON(!clk->ref_count); */
+	if ((clk->flags & ALWAYS_ENABLED) == ALWAYS_ENABLED)
+		return;
+
+	if (clk->usecount > 0 && !(--clk->usecount)) {
+		if (clk->disable)
+			clk->disable(clk);
+		else
+			u67xx_cgu_disable_clock(clk);
+
+		if (likely((u32) clk->parent))
+			u6_clk_disable(clk->parent);
+	}
+}
+
+/**
+ * @brief Enable a device clock.
+ * @param clk clock description structure
+ */
+int u6_clk_enable(struct clk *clk)
+{
+	int ret = 0;
+
+	/*   BUG_ON(!clk->ref_count); */
+	if ((clk->flags & ALWAYS_ENABLED) == ALWAYS_ENABLED)
+		return 0;
+
+	if (clk->usecount++ == 0) {
+		if (likely((u32) clk->parent))
+			ret = u6_clk_enable(clk->parent);
+
+		if (unlikely(ret != 0)) {
+			clk->usecount--;
+			return ret;
+		}
+
+		if (clk->enable)
+			ret = clk->enable(clk);
+		else
+			ret = u67xx_cgu_enable_clock(clk);
+
+		if (unlikely(ret != 0) && clk->parent) {
+			u6_clk_disable(clk->parent);
+			clk->usecount--;
+		}
+	}
+	return 0;
+}
+
+/**
+ * HW enable clock function.
+ **/
+
+int u67xx_cgu_enable_fake_clock(struct clk *clk)
+{
+	pr_debug("u67xx_cgu_enable_fake_clock for %s\n", clk->name);
+	return 0;
+}
+
+int u67xx_cgu_enable_hw_clock(struct clk *clk)
+{
+	unsigned long value;
+	pr_debug("u67xx_cgu_enable_hw_clock for %s\n", clk->name);
+
+	if (unlikely(clk->enable_reg == NULL)) {
+		printk(KERN_ERR "Enable for %s without enable register\n",
+		       clk->name);
+		return 0;
+	}
+
+	value = readl(clk->enable_reg);
+	value |= 1 << clk->enable_bit;
+	writel(value, clk->enable_reg);
+
+	return 0;
+}
+
+int u67xx_cgu_enable_tvo_pll_clock(struct clk *clk)
+{
+	unsigned long value;
+
+	pr_debug("u67xx_cgu_enable_tvo_pll_clock for %s\n", clk->name);
+
+	if (unlikely(clk->enable_reg == NULL)) {
+		printk(KERN_ERR "Enable for %s without enable register\n",
+		       clk->name);
+		return 0;
+	}
+
+	value = readl(clk->enable_reg);
+	value |= 1 << clk->enable_bit;
+	writel(value, clk->enable_reg);
+
+	/* wait pll lock */
+	do {
+		value = readl(clk->enable_reg);
+	} while (!(value & (0x1 << 16)));
+
+	return 0;
+}
+
+int u67xx_cgu_enable_shared_clock(struct clk *clk)
+{
+	unsigned long value;
+
+	pr_debug("u67xx_cgu_enable_shared_clock for %s\n", clk->name);
+
+	if (unlikely(clk->enable_reg == NULL)) {
+		printk(KERN_ERR "Enable for %s without enable register\n",
+		       clk->name);
+		return 0;
+	}
+
+	value = readl(clk->enable_reg);
+	value |= 1 << clk->enable_bit;
+	writel(value, clk->enable_reg);
+
+	return 0;
+}
+
+int u67xx_cgu_enable_clock(struct clk *clk)
+{
+	printk(PKMOD "No enable clock method for %s."
+	       " You should use new one !!!\n", clk->name);
+	return 0;
+}
+
+int u67xx_cgu_enable_camout(struct clk *clk)
+{
+	unsigned long value;
+	pr_debug("u67xx_cgu_enable_hw_clock for %s\n", clk->name);
+
+	if (unlikely(clk->enable_reg == NULL)) {
+		printk(KERN_ERR "Enable for %s without enable register\n",
+		       clk->name);
+		return 0;
+	}
+
+	u6_clk_enable(&fix_ck);
+	u6_clk_enable(&plltv_ck);
+
+	value = readl(clk->enable_reg);
+	value |= 1 << clk->enable_bit;
+	writel(value, clk->enable_reg);
+
+	udelay(1);
+
+	u6_clk_disable(&fix_ck);
+	u6_clk_disable(&plltv_ck);
+
+	return 0;
+}
+
+/**
+ * HW disable clock function.
+ **/
+
+void u67xx_cgu_disable_fake_clock(struct clk *clk)
+{
+	pr_debug("u67xx_cgu_disable_fake_clock for %s\n", clk->name);
+}
+
+void u67xx_cgu_disable_hw_clock(struct clk *clk)
+{
+	unsigned long value;
+
+	pr_debug("u67xx_cgu_disable_hw_clock for %s\n", clk->name);
+
+	if (unlikely(clk->enable_reg == NULL)) {
+		printk(KERN_ERR "Disable for %s without enable register\n",
+		       clk->name);
+		return;
+	}
+
+	value = readl(clk->enable_reg);
+	value &= ~(1 << clk->enable_bit);
+	writel(value, clk->enable_reg);
+
+	return;
+}
+
+void u67xx_cgu_disable_shared_clock(struct clk *clk)
+{
+	unsigned long value;
+
+	pr_debug("u67xx_cgu_disable_shared_clock for %s\n", clk->name);
+
+	if (unlikely(clk->enable_reg == NULL)) {
+		printk(KERN_ERR "Disable for %s without enable register\n",
+		       clk->name);
+		return;
+	}
+
+	value = readl(clk->enable_reg);
+	value &= ~(1 << clk->enable_bit);
+	writel(value, clk->enable_reg);
+}
+
+void u67xx_cgu_disable_clock(struct clk *clk)
+{
+	printk(PKMOD
+	       " No disable clock method for %s. You should use one !!!\n",
+	       clk->name);
+}
+
+/**
+ * set rate clock function.
+ **/
+
+int u6_clk_set_rate_fci(struct clk *clk, unsigned long rate)
+{
+	int ret = 0;
+	unsigned long ratio = 0;
+	unsigned long reg;
+
+	if (!rate)
+		ratio = 31;
+	else {
+		if (rate > CLK_FC_CLK_MAX_FREQ)
+			rate = CLK_FC_CLK_MAX_FREQ;
+
+		/* compute diviser ratio */
+		ratio = (clk->parent->rate / rate) - 1;
+		if (ratio < 2)
+			ratio = 2;
+		if (ratio > 31)
+			ratio = 31;
+	}
+	clk->rate = clk->parent->rate / (ratio + 1);
+
+	/* for voltage working point only */
+	/* u67xx_set_freq(FC_CLK, clk->rate/1000 , clk->rate/1000); */
+
+	reg = readl(CGU_FIXCON_REG);
+	reg &= ~(0x1F << 22);
+	reg |= (ratio << 22);
+	writel(reg, CGU_FIXCON_REG);
+
+	reg = readl(CGU_SCCON_REG);
+	writel(reg, CGU_SCCON_REG);
+
+	return ret;
+}
+
+int u6_clk_set_rate_camout(struct clk *clk, unsigned long rate)
+{
+	int ret = 0;
+	unsigned long ratio = 0;
+	unsigned long reg;
+
+	if (!rate)
+		return -EINVAL;
+
+	if (rate > CLK_CAM_CLK_MAX_FREQ)
+		rate = CLK_CAM_CLK_MAX_FREQ;
+
+	/* compute diviser ratio */
+	ratio = (clk->parent->rate / rate) - 1;
+	if (ratio < 1)
+		ratio = 1;
+	if (ratio > 63)
+		ratio = 63;
+
+	clk->rate = clk->parent->rate / (ratio + 1);
+
+	/* for voltage working point only */
+	/* u67xx_set_freq(CAM_CLK, clk->rate/1000 , clk->rate/1000); */
+
+	reg = readl(CGU_CAMCON_REG);
+
+	reg &= ~(0x3F << 0);
+	reg |= (ratio << 0);
+
+	writel(reg, CGU_CAMCON_REG);
+
+	return ret;
+}
+
+/**
+ * set parent clock function.
+ **/
+int u6_clk_set_parent_camout(struct clk *clk, struct clk *parent)
+{
+	int ret = 0;
+	unsigned long srce = 0;
+	unsigned long reg;
+
+	if (!strcmp(parent->name, "TVOPLL"))
+		srce = 0;
+	else if (!strcmp(parent->name, "fix_ck"))
+		srce = 1;
+	else
+		return -EINVAL;
+
+	u6_clk_enable(&fix_ck);
+	u6_clk_enable(&plltv_ck);
+
+	reg = readl(CGU_CAMCON_REG);
+
+	reg &= ~(0x1 << 6);
+	reg |= (srce << 6);
+
+	writel(reg, CGU_CAMCON_REG);
+
+	udelay(1);
+
+	u6_clk_disable(&fix_ck);
+	u6_clk_disable(&plltv_ck);
+
+	clk->parent = parent;
+
+	return ret;
+}
+
+int u6_clk_set_parent_uart(struct clk *clk, struct clk *parent)
+{
+
+	if (!strcmp(parent->name, "pclk2_ck")) {
+		clk->parent = parent;
+		return 0;
+	} else if (!strcmp(parent->name, "clk26m_ck")) {
+		clk->parent = parent;
+		return 0;
+	} else if (!strcmp(parent->name, "clk13m_ck")) {
+		clk->parent = parent;
+		return 0;
+	} else {
+		return -EINVAL;
+	}
+}
+
+/**
+ * HW init clock function.
+ **/
+
+void u6_clk_dflt_init(struct clk *clk)
+{
+	if (clk->usecount == 0)
+		u67xx_cgu_disable_hw_clock(clk);
+	else
+		u67xx_cgu_enable_hw_clock(clk);
+	/* default rate to parent one */
+	clk->rate = clk->parent->rate;
+}
+
+void u6_clk_init_hclk2(struct clk *clk)
+{
+	/* nothing to do */
+}
+
+void u6_clk_init_fci(struct clk *clk)
+{
+	u6_clk_set_rate_fci(clk, clk->rate);
+}
+
+void u6_clk_init_camout(struct clk *clk)
+{
+	u6_clk_set_parent_camout(clk, &fix_ck);
+	u6_clk_set_rate_camout(clk, clk->rate);
+}
+
+/*
+ * Update clock rate
+ */
+void followparent_ivs_recalc(struct clk *clk)
+{
+	clk->rate = clk->parent->rate;
+	propagate_rate(clk);
+}
+
+/*
+ * Private U6 platform access clock functions
+ */
+static long u6_clk_round_rate(struct clk *clk, unsigned long rate)
+{
+	if (clk->round_rate)
+		return clk->round_rate(clk, rate);
+	else
+		return rate;
+}
+
+static int u6_clk_set_rate(struct clk *clk, unsigned long rate)
+{
+	int ret = 0;
+
+	/*   BUG_ON(!clk->ref_count); */
+	if (clk->usecount > 0) {
+		if (clk->disable)
+			clk->disable(clk);
+		else
+			u67xx_cgu_disable_clock(clk);
+	}
+
+	if (clk->set_rate)
+		ret = clk->set_rate(clk, rate);
+	else
+		ret = -EINVAL;
+
+	if (clk->usecount > 0) {
+		if (clk->enable)
+			clk->enable(clk);
+		else
+			u67xx_cgu_enable_clock(clk);
+	}
+
+	/* propagate rate */
+	propagate_rate(clk);
+
+	return ret;
+}
+
+static int u6_clk_set_parent(struct clk *clk, struct clk *parent)
+{
+	int ret = 0;
+	int old_rate;
+
+	if (clk->usecount > 0) {
+		if (clk->disable)
+			clk->disable(clk);
+		else
+			u67xx_cgu_disable_clock(clk);
+
+		if (likely((u32) clk->parent))
+			u6_clk_disable(clk->parent);
+	}
+
+	old_rate = clk->rate;
+
+	if (clk->set_parent)
+		ret = clk->set_parent(clk, parent);
+	else
+		ret = -EINVAL;
+
+	if (clk->round_rate)
+		old_rate = clk->round_rate(clk, old_rate);
+
+	u6_clk_set_rate(clk, old_rate);
+
+	if (clk->usecount > 0) {
+		if (likely((u32) clk->parent))
+			u6_clk_enable(clk->parent);
+
+		if (clk->enable)
+			ret = clk->enable(clk);
+		else
+			ret = u67xx_cgu_enable_clock(clk);
+	}
+
+	/* propagate rate */
+	if (clk->flags & RATE_PROPAGATES)
+		propagate_rate(clk);
+
+	return ret;
+}
+
+static struct clk *u6_clk_get_parent(struct clk *clk)
+{
+	return clk->parent;
+}
+
+/*
+ * U6 platform clock constraint functions
+ */
+
+unsigned long clk_get_hw_constraint(void __iomem *reg_addr)
+{
+	unsigned long reg;
+
+	reg = readl(reg_addr);
+
+	return reg;
+}
+
+ssize_t u6_clk_show_hw_rates(struct kobject *kobj, char *buf)
+{
+	int size = 0;
+	unsigned long reg, rate, msc, psc, mclk;
+
+	size += sprintf(&buf[size], "--HW-- : \n");
+
+	mclk = clk_get_hw_constraint(CGU_FIXCON_REG);
+	mclk = osc_ck.rate / 1000000 / (((mclk & (0x3 << 17)) >> 17) + 1);
+
+	reg = clk_get_hw_constraint(CGU_SCCON_REG);
+
+	msc = (((reg & (0xF << 25)) >> 25) + 1);
+	psc = (((reg & (0x3 << 15)) >> 15) + 1);
+	size += sprintf(&buf[size], "arm_ck is ");
+	if (reg & (1 << 17)) {
+		if (reg & (1 << 18))
+			rate = 312;
+		else
+			rate = 156;
+		rate = rate / msc / psc;
+		size += sprintf(&buf[size], "%lu", rate);
+		size += sprintf(&buf[size], "Mhz fix_ck pll\n");
+	} else {
+		rate = mclk * (((reg & (0xFF << 3)) >> 3) + 1)
+		    / (((reg & (0xF << 11)) >> 11) + 1);
+		rate = rate / msc / psc;
+		size += sprintf(&buf[size], "%lu", rate);
+		size += sprintf(&buf[size], "Mhz sc_ck pll\n");
+	}
+
+	rate = rate / (((reg & (0xF << 21)) >> 21) + 1);
+
+	size += sprintf(&buf[size], "hclk_ck is %luMhz\n", rate);
+
+	reg = clk_get_hw_constraint(CGU_FIXCON_REG);
+
+	rate = 13 * (((reg & (0x3 << 20)) >> 20) + 1);
+
+	size += sprintf(&buf[size], "pclk2_ck is %luMhz\n", rate);
+
+	if (reg & (1 << 31)) {
+		if (reg & (1 << 29))
+			rate = 104;
+		else
+			rate = 78;
+	} else
+		rate = 13 + (13 * ((reg & (0x7 << 29)) >> 29));
+
+	size += sprintf(&buf[size], "hclk2_ck is %luMhz\n", rate);
+
+	reg = clk_get_hw_constraint(CGU_SDMCON_REG);
+
+	msc = (((reg & (0x7 << 0)) >> 0) + 1);
+
+	size += sprintf(&buf[size], "sdm_ck is ");
+	if (reg & (1 << 17)) {
+		if (reg & (1 << 18))
+			rate = 312;
+		else
+			rate = 156;
+		size += sprintf(&buf[size], "%lu", rate / msc);
+		size += sprintf(&buf[size], "Mhz fix_ck pll\n");
+	} else {
+		rate = mclk * 2 * (((reg & (0xFF << 3)) >> 3) + 1)
+		    / (((reg & (0x3F << 11)) >> 11) + 1);
+		size += sprintf(&buf[size], "%lu", rate / msc);
+		size += sprintf(&buf[size], "Mhz sdm pll\n");
+	}
+
+	if (reg & (1 << 23))
+		size += sprintf(&buf[size], "ivs-sdm concentrator is enable\n");
+	else
+		size += sprintf(&buf[size],
+				"ivs-sdm concentrator is disable\n");
+
+	return size;
+}
+
+unsigned char *cgu_name_sc1[32] = {
+	"EBI", "01", "NFI", "SDI", "04", "MSI", "UCC", "JDI",
+	"08", "09", "10", "DMAU", "RFSM1", "IIS", "USBD", "FCI",
+	"USIM", "GEAC", "PWM3", "PWM2", "PWM1", "KBS", "GPIO", "UART2",
+	"UART1", "IIC2", "IIC1", "SPI2", "SPI1", "SCTU", "EXTINT", "INTC"
+};
+
+unsigned char *cgu_name_sc2[32] = {
+	"32", "33", "34", "35", "36", "37", "38", "39",
+	"40", "41", "42", "43", "44", "45", "46", "47",
+	"48", "49", "50", "51", "52", "53", "BBIP", "55",
+	"56", "57", "58", "ETB", "60", "MMTU", "62", "CAE"
+};
+
+ssize_t u6_clk_show_sc_constraints(struct kobject *kobj, char *buf)
+{
+	int i, size = 0;
+	unsigned long reg;
+
+	size += sprintf(&buf[size], "--SC-- : \n");
+
+	reg = clk_get_hw_constraint(CGU_GATESC1_REG);
+
+	for (i = 0; i < 32; i++) {
+		if ((reg >> i) & 0x1)
+			size +=
+			    sprintf(&buf[size], "%s ,", cgu_name_sc1[31 - i]);
+	}
+
+	size += sprintf(&buf[size], "\n");
+
+	reg = clk_get_hw_constraint(CGU_GATESC2_REG);
+
+	for (i = 0; i < 32; i++) {
+		if ((reg >> i) & 0x1)
+			size +=
+			    sprintf(&buf[size], "%s ,", cgu_name_sc2[31 - i]);
+	}
+
+	size += sprintf(&buf[size], "\n");
+
+	return size;
+}
+
+unsigned char *cgu_name_ivs[32] = {
+	"", "", "", "", "", "", "", "",
+	"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",
+	"CAMJPE", "TVO", "JDU", "VDC", "VEC", "IPP", "VDE", "CAM"
+};
+
+ssize_t u6_clk_show_ivs_constraints(struct kobject *kobj, char *buf)
+{
+	int i, size = 0;
+	unsigned long reg;
+
+	size += sprintf(&buf[size], "--IVS-- : \n");
+
+	reg = clk_get_hw_constraint(CGU_GATEIVS_REG);
+
+	for (i = 0; i < 32; i++) {
+		if ((reg >> i) & 0x1)
+			size +=
+			    sprintf(&buf[size], "%s ,", cgu_name_ivs[31 - i]);
+	}
+
+	size += sprintf(&buf[size], "\n");
+
+	return size;
+}
+
+ssize_t u6_clk_show_tvo_constraints(struct kobject *kobj, char *buf)
+{
+	int size = 0;
+	unsigned long reg;
+
+	size += sprintf(&buf[size], "--TVO-- : \n");
+
+	reg = clk_get_hw_constraint(CGU_TVCON_REG);
+
+	if ((reg >> 15) & 0x1)
+		size += sprintf(&buf[size], "tvclk_ck pll enable\n");
+	else
+		size += sprintf(&buf[size], "tvclk_ck pll disable\n");
+
+	if ((reg >> 12) & 0x1)
+		size += sprintf(&buf[size], "TVOPLL enable\n");
+	else
+		size += sprintf(&buf[size], "TVOPLL disable\n");
+
+	return size;
+}
+
+ssize_t u6_clk_show_cam_constraints(struct kobject *kobj, char *buf)
+{
+	int size = 0;
+	unsigned long reg, rate, div;
+
+	size += sprintf(&buf[size], "--CAM-- : \n");
+
+	reg = clk_get_hw_constraint(CGU_CAMCON_REG);
+
+	if ((reg >> 6) & 0x1) {
+		size += sprintf(&buf[size], "fix_clock is source\n");
+		rate = 312;
+	} else {
+		size += sprintf(&buf[size], "TVOPLL is source\n");
+		rate = 216;
+	}
+
+	div = ((reg & (0x3F << 0)) >> 0);
+
+	size += sprintf(&buf[size], "camo_ck is %luMhz\n", rate / (div + 1));
+
+	if ((reg >> 7) & 0x1)
+		size += sprintf(&buf[size], "camo_ck enable\n");
+	else
+		size += sprintf(&buf[size], "camo_ck disable\n");
+
+	return size;
+}
+
+/*
+ * U6 clock reset and init functions
+ */
+
+static struct clk_functions u6_clk_functions = {
+	.clk_enable = u6_clk_enable,
+	.clk_disable = u6_clk_disable,
+	.clk_round_rate = u6_clk_round_rate,
+	.clk_set_rate = u6_clk_set_rate,
+	.clk_set_parent = u6_clk_set_parent,
+	.clk_get_parent = u6_clk_get_parent,
+};
+
+/**
+ * @brief Attempts to connect the primary description structure for DMA case.
+ *
+ * We don't do any initialization since we expect the primary OS to have done
+ * it for us.
+ */
+static int __init u67xx_cgu_init(void)
+{
+	struct clk_lookup *clkp;
+	printk(PKMOD "clk management init\n");
+
+	if (mpurate)
+		sc_ck.rate = mpurate;
+
+	/* init clock function pointer table */
+	clk_init(&u6_clk_functions);
+
+	/* register and init clock elements */
+	for (clkp = onchip_clks; clkp->clk != NULL; clkp++) {
+		clkp->con_id = clkp->clk->name;
+		clkdev_add(clkp);
+		clk_register(clkp->clk);
+	}
+
+	return 0;
+}
+
+arch_initcall(u67xx_cgu_init);
diff --git a/arch/arm/mach-u67xx/cgu.h b/arch/arm/mach-u67xx/cgu.h
new file mode 100644
index 0000000..c029991
--- /dev/null
+++ b/arch/arm/mach-u67xx/cgu.h
@@ -0,0 +1,57 @@
+/*
+ *  arch/arm/mach-u67xx/cgu.h
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Vincent Guittot <vincent.guittot@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef CGU_INC
+#define CGU_INC
+
+extern struct clk arm_ck;
+extern struct clk hclk_ck;
+extern struct clk sdm_ck;
+extern struct clk hclk2_ck;
+extern struct clk pclk2_ck;
+extern struct clk sc_ck;
+extern struct clk fix_ck;
+extern struct clk plltv_ck;
+extern struct clk osc_ck;
+
+extern struct clk_lookup onchip_clks[];
+
+extern void u6_clk_init_hclk2(struct clk *clk);
+extern void u6_clk_init_rtke(struct clk *clk);
+extern void u6_clk_init_fci(struct clk *clk);
+extern void u6_clk_init_camout(struct clk *clk);
+
+extern void followparent_ivs_recalc(struct clk *clk);
+
+extern void u6_clk_rtke_recalc(struct clk *clk);
+
+extern int u67xx_cgu_enable_fake_clock(struct clk *clk);
+extern int u67xx_cgu_enable_hw_clock(struct clk *clk);
+extern int u67xx_cgu_enable_tvo_pll_clock(struct clk *clk);
+extern int u67xx_cgu_enable_rtke_clock(struct clk *clk);
+extern int u67xx_cgu_enable_shared_clock(struct clk *clk);
+extern int u67xx_cgu_enable_clock(struct clk *clk);
+extern int u67xx_cgu_enable_camout(struct clk *clk);
+
+extern void u67xx_cgu_disable_fake_clock(struct clk *clk);
+extern void u67xx_cgu_disable_hw_clock(struct clk *clk);
+extern void u67xx_cgu_disable_rtke_clock(struct clk *clk);
+extern void u67xx_cgu_disable_shared_clock(struct clk *clk);
+extern void u67xx_cgu_disable_clock(struct clk *clk);
+
+extern int u6_clk_set_rate_fci(struct clk *clk, unsigned long rate);
+extern int u6_clk_set_rate_camout(struct clk *clk, unsigned long rate);
+extern int u6_clk_set_rate_rtke(struct clk *clk, unsigned long rate);
+
+extern int u6_clk_set_parent_camout(struct clk *clk, struct clk *parent);
+extern int u6_clk_set_parent_uart(struct clk *clk, struct clk *parent);
+
+extern void u6_clk_dflt_init(struct clk *clk);
+
+#endif   /* ----- #ifndef CGU_INC  ----- */
+
diff --git a/arch/arm/mach-u67xx/clock_data_u67xx.c b/arch/arm/mach-u67xx/clock_data_u67xx.c
new file mode 100644
index 0000000..e3d8156
--- /dev/null
+++ b/arch/arm/mach-u67xx/clock_data_u67xx.c
@@ -0,0 +1,864 @@
+/*
+ *  arch/arm/mach-u67xx/clock_data_u67xx.c
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Vincent Guittot <vincent.guittot@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Based on clocks.h by Tony Lindgren, Gordon McNutt and RidgeRun, Inc
+ */
+#include <linux/device.h>
+#include <asm/clkdev.h>
+#include <mach/hardware.h>
+#include <mach/clock.h>
+#include "cgu.h"
+
+#define MODULE_NAME "U6_CGU"
+#define PKMOD MODULE_NAME ": "
+
+/* used to remove useless clock cells */
+#undef U6_OPTIMIZED_TREE
+
+/*
+ * U6 clock tree.
+ *
+ * NOTE:In many cases here we are assigning a 'default' parent.	In many
+ *	cases the parent is selectable.	The get/set parent calls will also
+ *	switch sources.
+ *
+ *	Many some clocks say always_enabled, but they can be auto idled for
+ *	power savings. They will always be available upon clock request.
+ *
+ *	Several sources are given initial rates which may be wrong, this will
+ *	be fixed up in the init func.
+ *
+ *	Things are broadly separated below by clock domains. It is
+ *	noteworthy that most periferals have dependencies on multiple clock
+ *	domains. Many get their interface clocks from the L4 domain, but get
+ *	functional clocks from fixed sources or other core domain derived
+ *	clock.
+ */
+
+/*** Basic clocks ***/
+
+/* Base external input clocks */
+static struct clk func_32k_ck = {
+	.name = "func_32k_ck",
+	.rate = 32000,
+	.flags = RATE_FIXED | ALWAYS_ENABLED,
+	.usecount = 1,
+};
+
+/* Typical 26MHz in standalone mode */
+struct clk osc_ck = {	/* (*12, *13, 19.2, *26, 38.4)MHz */
+	.name = "osc_ck",
+	.rate = 26000000,	/* fixed up in clock init */
+	.flags = RATE_FIXED | ALWAYS_ENABLED | RATE_PROPAGATES,
+	.usecount = 1,
+};
+
+/* System clock MCLK */
+/* With out modem likely 12MHz, with modem likely 13MHz */
+static struct clk sys_ck = {	/* (*12, *13, 19.2, 26, 38.4)MHz */
+	.name = "sys_ck",	/* ~ ref_clk also */
+	.parent = &osc_ck,
+	.rate = 13000000,
+	.flags = RATE_FIXED | ALWAYS_ENABLED | RATE_PROPAGATES,
+	.usecount = 1,
+};
+
+/*** System PLLs ***/
+
+struct clk sc_ck = {	/* 275-550MHz */
+	.name = "sc_ck",
+	.parent = &sys_ck,
+	.rate = 416000000,
+	.flags = RATE_PROPAGATES,
+	.enable = u67xx_cgu_enable_fake_clock,
+	.disable = u67xx_cgu_disable_fake_clock,
+};
+
+struct clk fix_ck = {	/* 312MHz */
+	.name = "fix_ck",
+	.parent = &sys_ck,
+	.rate = 312000000,
+	.flags = RATE_FIXED,
+	.enable = u67xx_cgu_enable_fake_clock,
+	.disable = u67xx_cgu_disable_fake_clock,
+	.enable_bit = 0,
+};
+
+static struct clk tv_ck = {	/* 216MHz */
+	.name = "tv_ck",
+	.parent = &fix_ck,
+	.rate = 216000000,
+	.flags = RATE_FIXED,
+	.enable = u67xx_cgu_enable_fake_clock,
+	.disable = u67xx_cgu_disable_fake_clock,
+};
+
+#ifndef U6_OPTIMIZED_TREE
+static struct clk dsp2_ck = {	/* 156-320MHz */
+	.name = "dsp2_ck",
+	.parent = &sys_ck,
+	.rate = 208000000,
+	.flags = RATE_PROPAGATES,
+	.enable = u67xx_cgu_enable_fake_clock,
+	.disable = u67xx_cgu_disable_fake_clock,
+	.enable_bit = 8,
+};
+#endif
+
+struct clk sdm_ck = {	/* 275-550MHz */
+	.name = "sdm_ck",
+	.parent = &sys_ck,
+	.rate = 200000000,
+/*      .flags          = RATE_PROPAGATES,*/
+	.enable = u67xx_cgu_enable_fake_clock,
+	.disable = u67xx_cgu_disable_fake_clock,
+	.enable_bit = 3,
+};
+
+/*** Master clock sources ***/
+
+struct clk arm_ck = {
+	.name = "arm_ck",
+	.rate = 416000000,
+	.parent = &sc_ck,
+/*	.flags          = RATE_PROPAGATES,*/
+	.enable = u67xx_cgu_enable_fake_clock,
+	.disable = u67xx_cgu_disable_fake_clock,
+};
+
+struct clk hclk_ck = {
+	.name = "hclk_ck",
+	.rate = 208000000,
+	.parent = &arm_ck,
+	.flags = RATE_PROPAGATES,
+	.enable = u67xx_cgu_enable_fake_clock,
+	.disable = u67xx_cgu_disable_fake_clock,
+	.enable_bit = 1,
+};
+
+struct clk hclk2_ck = {
+	.name = "hclk2_ck",
+/*	.rate           = 104000000,*/
+	.rate = 52000000,
+	.parent = &fix_ck,
+	.flags = RATE_PROPAGATES,
+	.init = u6_clk_init_hclk2,
+	.enable = u67xx_cgu_enable_fake_clock,
+	.disable = u67xx_cgu_disable_fake_clock,
+	.enable_bit = 2,
+};
+
+static struct clk sdm_ivs_ck = {
+	.name = "sdm_ivs_ck",
+	.parent = &hclk2_ck,
+	.rate = 104000000,
+	.flags = RATE_PROPAGATES,
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_ivs_recalc,
+	.enable_reg = CGU_SDMCON_REG,
+	.enable_bit = 23,
+};
+
+static struct clk pclk1_ck = {
+	.name = "pclk1_ck",
+	.rate = 104000000,
+	.parent = &hclk2_ck,
+	.flags = RATE_PROPAGATES,
+	.enable = u67xx_cgu_enable_fake_clock,
+	.disable = u67xx_cgu_disable_fake_clock,
+};
+
+static struct clk tvclk_ck = {
+	.name = "tvclk_ck",
+	.rate = 27000000,
+	.parent = &tv_ck,
+	.flags = RATE_FIXED,
+	.enable = u67xx_cgu_enable_tvo_pll_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.enable_reg = CGU_TVCON_REG,
+	.enable_bit = 15,
+};
+
+struct clk pclk2_ck = {
+	.name = "pclk2_ck",
+	.rate = 52000000,
+	.parent = &fix_ck,
+	.flags = RATE_PROPAGATES,
+	.enable = u67xx_cgu_enable_fake_clock,
+	.disable = u67xx_cgu_disable_fake_clock,
+	.enable_bit = 4,
+};
+
+static struct clk clk24m_ck = {
+	.name = "clk24m_ck",
+	.rate = 24000000,
+	.parent = &fix_ck,
+	.flags = RATE_FIXED,
+	.enable = u67xx_cgu_enable_fake_clock,
+	.disable = u67xx_cgu_disable_fake_clock,
+	.enable_bit = 5,
+};
+
+static struct clk clk26m_ck = {
+	.name = "clk26m_ck",
+	.rate = 26000000,
+	.parent = &fix_ck,
+	.flags = RATE_FIXED,
+	.enable = u67xx_cgu_enable_fake_clock,
+	.disable = u67xx_cgu_disable_fake_clock,
+	.enable_bit = 6,
+};
+
+static struct clk clk13m_ck = {
+	.name = "clk13m_ck",
+	.rate = 13000000,
+	.parent = &fix_ck,
+	.flags = RATE_FIXED,
+	.enable = u67xx_cgu_enable_fake_clock,
+	.disable = u67xx_cgu_disable_fake_clock,
+	.enable_bit = 7,
+};
+
+static struct clk clk4m_ck = {
+	.name = "clk4m_ck",
+	.rate = 4000000,
+	.parent = &fix_ck,
+	.flags = RATE_FIXED | ALWAYS_ENABLED | RATE_PROPAGATES,
+	.enable = u67xx_cgu_enable_fake_clock,
+	.disable = u67xx_cgu_disable_fake_clock,
+};
+
+#ifndef U6_OPTIMIZED_TREE
+static struct clk sioy1clk_ck = {
+	.name = "sioy1clk_ck",
+	.rate = 208000000,
+	.flags = RATE_FIXED | ALWAYS_ENABLED | RATE_PROPAGATES,
+};
+
+static struct clk sioy2clk_ck = {
+	.name = "sioy2clk_ck",
+	.rate = 208000000,
+	.flags = RATE_FIXED | ALWAYS_ENABLED | RATE_PROPAGATES,
+};
+
+static struct clk rfclk_ck = {
+	.name = "rfclk_ck",
+	.rate = 208000000,
+	.flags = RATE_FIXED | ALWAYS_ENABLED | RATE_PROPAGATES,
+};
+#endif
+
+static struct clk fc_ck = {
+	.name = "fc_ck",
+/*	.rate = 104000000,*/
+	.rate = 52000000,
+	.init = u6_clk_init_fci,
+	.enable = u67xx_cgu_enable_fake_clock,
+	.disable = u67xx_cgu_disable_fake_clock,
+	.set_rate = u6_clk_set_rate_fci,
+	.parent = &fix_ck,
+};
+
+static struct clk usb_d_ck = {
+	.name = "usb_d_ck",
+	.rate = 24000000,
+	.parent = &clk24m_ck,
+	.enable = u67xx_cgu_enable_fake_clock,
+	.disable = u67xx_cgu_disable_fake_clock,
+};
+
+static struct clk usb_h_ck = {
+	.name = "usb_h_ck",
+	.rate = 24000000,
+	.parent = &clk24m_ck,
+	.flags = RATE_FIXED,
+	.enable = u67xx_cgu_enable_fake_clock,
+	.disable = u67xx_cgu_disable_fake_clock,
+};
+
+#ifndef U6_OPTIMIZED_TREE
+static struct clk dcclk1_ck = {
+	.name = "dcclk1_ck",
+	.rate = 130000000,
+	.flags = RATE_FIXED | ALWAYS_ENABLED | RATE_PROPAGATES,
+};
+
+static struct clk diclk1_ck = {
+	.name = "diclk1_ck",
+	.rate = 130000000,
+	.flags = RATE_FIXED | ALWAYS_ENABLED | RATE_PROPAGATES,
+};
+
+static struct clk dcclk2_ck = {
+	.name = "dcclk2_ck",
+	.rate = 130000000,
+	.flags = RATE_FIXED | ALWAYS_ENABLED | RATE_PROPAGATES,
+};
+
+static struct clk diclk2_ck = {
+	.name = "dicl2_ck",
+	.rate = 130000000,
+	.flags = RATE_FIXED | ALWAYS_ENABLED | RATE_PROPAGATES,
+};
+#endif
+
+static struct clk camo_ck = {
+	.name = "camo_ck",
+	.rate = 12000000,
+	.parent = &fix_ck,
+	.flags = RATE_PROPAGATES,
+	.init = u6_clk_init_camout,
+	.enable = u67xx_cgu_enable_camout,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.set_rate = u6_clk_set_rate_camout,
+	.set_parent = u6_clk_set_parent_camout,
+	.enable_reg = CGU_CAMCON_REG,
+	.enable_bit = 7,
+};
+
+/*** Peripheral clocks ***/
+
+/* CGUTVCON */
+struct clk plltv_ck = {
+	.name = "TVOPLL",
+	.enable_reg = CGU_TVCON_REG,
+	.enable_bit = 12,
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.parent = &tvclk_ck,
+};
+
+/* CGUGATESC1 */
+#ifndef U6_OPTIMIZED_TREE
+static struct clk intc_ck = {
+	.name = "INTC",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 0,
+	.parent = &hclk2_ck,
+	.usecount = 1,
+};
+
+static struct clk extint_ck = {
+	.name = "EXTINT",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 1,
+	.parent = &pclk2_ck,
+	.usecount = 1,
+};
+
+static struct clk sctu_ck = {
+	.name = "SCTU",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 2,
+	.parent = &clk13m_ck,
+};
+#endif
+
+static struct clk spi1_ck = {
+	.name = "SPI1",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 3,
+	.parent = &pclk1_ck,
+};
+
+static struct clk spi2_ck = {
+	.name = "SPI2",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 4,
+	.parent = &pclk1_ck,
+};
+
+static struct clk iic1_ck = {
+	.name = "IIC1",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 5,
+	.parent = &pclk2_ck,
+};
+
+static struct clk iic2_ck = {
+	.name = "IIC2",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 6,
+	.parent = &pclk2_ck,
+};
+
+static struct clk uart1_ck = {
+	.name = "UART1",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.set_parent = u6_clk_set_parent_uart,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 7,
+	.parent = &clk13m_ck,
+};
+
+static struct clk uart2_ck = {
+	.name = "UART2",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.set_parent = u6_clk_set_parent_uart,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 8,
+	.parent = &clk13m_ck,
+};
+
+#ifndef U6_OPTIMIZED_TREE
+static struct clk gpio_ck = {
+	.name = "GPIO",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 9,
+	.parent = &pclk2_ck,
+	.usecount = 1,
+};
+#endif
+
+static struct clk kbs_ck = {
+	.name = "KBS",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 10,
+	.parent = &func_32k_ck,
+};
+
+static struct clk pwm1_ck = {
+	.name = "PWM1",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 11,
+	.parent = &clk13m_ck,
+};
+
+static struct clk pwm2_ck = {
+	.name = "PWM2",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 12,
+	.parent = &clk13m_ck,
+};
+
+static struct clk pwm3_ck = {
+	.name = "PWM3",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 13,
+	.parent = &clk13m_ck,
+};
+
+static struct clk geac_ck = {
+	.name = "GEAC",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 14,
+	.parent = &pclk1_ck,
+};
+
+#ifndef U6_OPTIMIZED_TREE
+static struct clk usim_ck = {
+	.name = "USIM",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 15,
+	.parent = &pclk2_ck,
+};
+#endif
+
+static struct clk fci_ck = {
+	.name = "FCI",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 16,
+	.parent = &fc_ck,
+};
+
+static struct clk usbd_ck = {
+	.name = "USBD",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 17,
+	.parent = &hclk2_ck,
+};
+
+#ifndef U6_OPTIMIZED_TREE
+static struct clk iis_ck = {
+	.name = "IIS",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 18,
+	.parent = &clk24m_ck,
+};
+
+static struct clk rfsm1_ck = {
+	.name = "RFSM1",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 19,
+	.parent = &pclk1_ck,
+};
+#endif
+
+static struct clk dmau_ck = {
+	.name = "DMAU",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_shared_clock,
+	.disable = u67xx_cgu_disable_shared_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 20,
+	.parent = &hclk2_ck,
+};
+
+static struct clk jdi_ck = {
+	.name = "JDI",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 24,
+	.parent = &pclk2_ck,
+};
+
+#ifndef U6_OPTIMIZED_TREE
+static struct clk ucc_ck = {
+	.name = "UCC",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 25,
+	.parent = &pclk1_ck,
+};
+#endif
+
+static struct clk msi_ck = {
+	.name = "MSI",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 26,
+	.parent = &fc_ck,
+};
+
+static struct clk sdi_ck = {
+	.name = "SDI",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 28,
+	.parent = &hclk2_ck,
+};
+
+static struct clk nfi_ck = {
+	.name = "NFI",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 29,
+	.parent = &hclk2_ck,
+
+};
+
+static struct clk ebi_ck = {
+	.name = "EBI",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATESC1_REG,
+	.enable_bit = 31,
+	.parent = &hclk2_ck,
+
+};
+
+/* CGUGATESC2 */
+static struct clk cae_ck = {
+	.name = "CAE",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.enable_reg = CGU_GATESC2_REG,
+	.enable_bit = 0,
+	.parent = &pclk1_ck,
+};
+
+static struct clk mmtu_ck = {
+	.name = "MMTU",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_shared_clock,
+	.disable = u67xx_cgu_disable_shared_clock,
+	.enable_reg = CGU_GATESC2_REG,
+	.enable_bit = 2,
+	.parent = &clk13m_ck,
+	.usecount = 1,
+};
+
+/* OCL-2008-07-02: how to manage etbclk ? */
+/* static struct clk ETB_ck = */
+/* { */
+/* 	.name = "ETB", */
+/* 	.enable_reg = CGU_GATESC2_REG, */
+/* 	.enable_bit = 4, */
+/* 	.parent = &etbclk_ck, */
+/* }; */
+
+/* CGUGATEIVS */
+static struct clk cam_ck = {
+	.name = "CAM",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATEIVS_REG,
+	.enable_bit = 0,
+	.parent = &sdm_ivs_ck,
+};
+
+static struct clk vde_ck = {
+	.name = "VDE",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATEIVS_REG,
+	.enable_bit = 1,
+	.parent = &hclk2_ck,
+};
+
+static struct clk ipp_ck = {
+	.name = "IPP",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATEIVS_REG,
+	.enable_bit = 2,
+	.parent = &sdm_ivs_ck,
+};
+
+static struct clk vec_ck = {
+	.name = "VEC",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATEIVS_REG,
+	.enable_bit = 3,
+	.parent = &sdm_ivs_ck,
+};
+
+static struct clk vdc_ck = {
+	.name = "VDC",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATEIVS_REG,
+	.enable_bit = 4,
+	.parent = &sdm_ivs_ck,
+};
+
+static struct clk jdu_ck = {
+	.name = "JDU",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATEIVS_REG,
+	.enable_bit = 5,
+	.parent = &sdm_ivs_ck,
+};
+
+static struct clk tvoclk_ck = {
+	.name = "TVO",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATEIVS_REG,
+	.enable_bit = 6,
+	.parent = &sdm_ivs_ck,
+};
+
+static struct clk camjpe_ck = {
+	.name = "CAMJPE",
+	.init = u6_clk_dflt_init,
+	.enable = u67xx_cgu_enable_hw_clock,
+	.disable = u67xx_cgu_disable_hw_clock,
+	.recalc = followparent_recalc,
+	.enable_reg = CGU_GATEIVS_REG,
+	.enable_bit = 7,
+	.parent = &hclk_ck,
+};
+
+#define CLK(pck)	\
+	{			\
+		.dev_id = NULL,	\
+		.con_id = NULL,	\
+		.clk = pck,	\
+	}
+
+struct clk_lookup onchip_clks[] = {
+	/* external root sources */
+	CLK(&func_32k_ck),
+	CLK(&osc_ck),
+	CLK(&sys_ck),
+	CLK(&sc_ck),
+	CLK(&fix_ck),
+	CLK(&tv_ck),
+#ifndef U6_OPTIMIZED_TREE
+	CLK(&dsp2_ck),
+#endif
+	CLK(&sdm_ck),
+	CLK(&arm_ck),
+	CLK(&hclk_ck),
+	CLK(&hclk2_ck),
+	CLK(&pclk1_ck),
+	CLK(&pclk2_ck),
+	CLK(&tvclk_ck),
+	CLK(&clk24m_ck),
+	CLK(&clk26m_ck),
+	CLK(&clk13m_ck),
+	CLK(&clk4m_ck),
+	CLK(&fc_ck),
+#ifndef U6_OPTIMIZED_TREE
+	CLK(&sioy1clk_ck),
+	CLK(&sioy2clk_ck),
+	CLK(&rfclk_ck),
+#endif
+	CLK(&usb_h_ck),
+	CLK(&usb_d_ck),
+#ifndef U6_OPTIMIZED_TREE
+	CLK(&dcclk1_ck),
+	CLK(&diclk1_ck),
+	CLK(&dcclk2_ck),
+	CLK(&diclk2_ck),
+#endif
+	CLK(&camo_ck),
+	CLK(&tvoclk_ck),
+	CLK(&plltv_ck),
+#ifndef U6_OPTIMIZED_TREE
+	CLK(&intc_ck),
+	CLK(&extint_ck),
+	CLK(&sctu_ck),
+#endif
+	CLK(&spi1_ck),
+	CLK(&spi2_ck),
+	CLK(&iic1_ck),
+	CLK(&iic2_ck),
+	CLK(&uart1_ck),
+	CLK(&uart2_ck),
+#ifndef U6_OPTIMIZED_TREE
+	CLK(&gpio_ck),
+#endif
+	CLK(&kbs_ck),
+	CLK(&pwm1_ck),
+	CLK(&pwm2_ck),
+	CLK(&pwm3_ck),
+	CLK(&geac_ck),
+#ifndef U6_OPTIMIZED_TREE
+	CLK(&usim_ck),
+#endif
+	CLK(&fci_ck),
+	CLK(&usbd_ck),
+#ifndef U6_OPTIMIZED_TREE
+	CLK(&iis_ck),
+	CLK(&rfsm1_ck),
+#endif
+	CLK(&dmau_ck),
+	CLK(&jdi_ck),
+#ifndef U6_OPTIMIZED_TREE
+	CLK(&ucc_ck),
+#endif
+	CLK(&msi_ck),
+	CLK(&sdi_ck),
+	CLK(&nfi_ck),
+	CLK(&ebi_ck),
+	CLK(&cae_ck),
+	CLK(&mmtu_ck),
+	CLK(&sdm_ivs_ck),
+	CLK(&cam_ck),
+	CLK(&vde_ck),
+	CLK(&vdc_ck),
+	CLK(&vec_ck),
+	CLK(&ipp_ck),
+	CLK(&jdu_ck),
+	CLK(&camjpe_ck),
+	CLK(NULL)
+};
+
diff --git a/arch/arm/plat-u6xxx/Makefile b/arch/arm/plat-u6xxx/Makefile
index 12c832c..afdf82b 100644
--- a/arch/arm/plat-u6xxx/Makefile
+++ b/arch/arm/plat-u6xxx/Makefile
@@ -3,6 +3,6 @@
 #
 
 # Common support
-obj-y := io.o irq.o
+obj-y := io.o irq.o clock.o
 
 obj-$(CONFIG_U6_MTU_TIMER) += timer.o
diff --git a/arch/arm/plat-u6xxx/clock.c b/arch/arm/plat-u6xxx/clock.c
new file mode 100644
index 0000000..ecff187
--- /dev/null
+++ b/arch/arm/plat-u6xxx/clock.c
@@ -0,0 +1,621 @@
+/*
+ * linux/arch/arm/plat-u6xxx/clock.c
+ *
+ *  Copyright (C) 2004 - 2005 Nokia corporation
+ *  Written by Tuukka Tikkanen <tuukka.tikkanen@elektrobit.com>
+ *  Copyright (C) 2010 ST-Ericsson SA
+ *
+ *  Modified for omap shared clock framework by Tony Lindgren <tony@atomide.com>
+ *
+ *  Modified for u6 shared clock framework by Loic Pallardy @ ST-Ericsson.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/version.h>
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/string.h>
+#include <linux/clk.h>
+#include <linux/mutex.h>
+#include <linux/notifier.h>
+
+#include <linux/io.h>
+
+#include <mach/clock.h>
+
+LIST_HEAD(clocks);
+
+static DEFINE_MUTEX(clocks_mutex);
+DEFINE_SPINLOCK(clockfw_lock);
+
+static struct clk_functions *arch_clock;
+
+/*
+ * Additionnal specific clock functions define in include/mach/clock.h
+ */
+
+/**
+ *	clk_register_notifier - register a driver with clock mngt
+ *	@nb: notifier function to register
+ *  @clk: clock element rate change to be notified
+ *
+ *	Add a driver to one of two lists: either a list of drivers that
+ *      are notified about clock rate changes (once before and once after
+ *      the transition),
+ *	This function may sleep, and has the same return conditions as
+ *	sru_blocking_notifier_chain_register.
+ */
+int clk_register_notifier(struct notifier_block *nb, struct clk *clk)
+{
+	int ret;
+
+	if (clk == ERR_PTR(-ENOENT))
+		return -EINVAL;
+
+	mutex_lock(&clocks_mutex);
+	if (clk->notifier)
+		ret = srcu_notifier_chain_register(clk->notifier, nb);
+	else
+		ret = -EINVAL;
+	mutex_unlock(&clocks_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL(clk_register_notifier);
+
+/**
+ *	clk_unregister_notifier - unregister a driver with clock mngt
+ *	@nb: notifier function to be unregistered
+ *  @clk: clock element rate change to be notified
+ *
+ *	Remove a driver from the clock mngt notifier list.
+ *
+ *	This function may sleep, and has the same return conditions as
+ *	sru_blocking_notifier_chain_unregister.
+ */
+int clk_unregister_notifier(struct notifier_block *nb, struct clk *clk)
+{
+	int ret;
+
+	if (clk == ERR_PTR(-ENOENT))
+		return -EINVAL;
+
+	mutex_lock(&clocks_mutex);
+	if (clk->notifier)
+		ret = srcu_notifier_chain_unregister(clk->notifier, nb);
+	else
+		ret = -EINVAL;
+	mutex_unlock(&clocks_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL(clk_unregister_notifier);
+
+/**
+ * clk_notify_transition - call notifier chain
+ *
+ * This function calls the transition notifiers and the and set rate
+ * It is called twice on all frequency changes that have
+ * external effects.
+ */
+int clk_notify_transition(struct clk *clk, unsigned int state, void *data)
+{
+	BUG_ON(irqs_disabled());
+
+	if (clk == ERR_PTR(-ENOENT))
+		return NOTIFY_BAD;
+
+	switch (state) {
+
+	case CLK_RATE_PRECHANGE:
+	case CLK_RATE_POSTCHANGE:
+/*		printk("notif %u of frequency transition of %s to %lu Hz\n",
+			state, clk->name, (unsigned long)data);
+*/
+		break;
+
+	case CLK_SRCE_PRECHANGE:
+	case CLK_SRCE_POSTCHANGE:
+/*              printk("notif %u of srce transition of %s to %s\n",
+			state, clk->name, ((struct clk *)data)->name);
+*/
+		break;
+	default:
+		printk(KERN_ERR "Unknown notification srce transition\n");
+		return NOTIFY_BAD;
+		break;
+	}
+
+	return srcu_notifier_call_chain(clk->notifier, state, data);
+}
+
+/*
+ * Standard clock functions defined in include/linux/clk.h
+ */
+int clk_enable(struct clk *clk)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	if (clk == ERR_PTR(-ENOENT))
+		return -EINVAL;
+
+	spin_lock_irqsave(&clockfw_lock, flags);
+	if (arch_clock->clk_enable)
+		ret = arch_clock->clk_enable(clk);
+	spin_unlock_irqrestore(&clockfw_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(clk_enable);
+
+void clk_disable(struct clk *clk)
+{
+	unsigned long flags;
+
+	if (clk == ERR_PTR(-ENOENT))
+		return;
+
+	spin_lock_irqsave(&clockfw_lock, flags);
+	if (arch_clock->clk_disable)
+		arch_clock->clk_disable(clk);
+	spin_unlock_irqrestore(&clockfw_lock, flags);
+}
+EXPORT_SYMBOL(clk_disable);
+
+int clk_get_usecount(struct clk *clk)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	if (clk == ERR_PTR(-ENOENT))
+		return -EINVAL;
+
+	spin_lock_irqsave(&clockfw_lock, flags);
+	ret = clk->usecount;
+	spin_unlock_irqrestore(&clockfw_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(clk_get_usecount);
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+	unsigned long flags;
+	unsigned long ret = 0;
+
+	if (clk == ERR_PTR(-ENOENT))
+		return -EINVAL;
+
+	spin_lock_irqsave(&clockfw_lock, flags);
+	ret = clk->rate;
+	spin_unlock_irqrestore(&clockfw_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(clk_get_rate);
+
+/*
+ * Optional clock functions defined in include/linux/clk.h
+ */
+
+long clk_round_rate(struct clk *clk, unsigned long rate)
+{
+	unsigned long flags;
+	long ret = rate;
+
+	if (clk == ERR_PTR(-ENOENT))
+		return -EINVAL;
+
+	spin_lock_irqsave(&clockfw_lock, flags);
+	if (arch_clock->clk_round_rate)
+		ret = arch_clock->clk_round_rate(clk, rate);
+	spin_unlock_irqrestore(&clockfw_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(clk_round_rate);
+
+int clk_set_rate(struct clk *clk, unsigned long rate)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	if (clk == ERR_PTR(-ENOENT))
+		return -EINVAL;
+
+	/* notification pre change */
+	if (clk->notifier)
+		ret = clk_notify_transition(clk,
+					    CLK_RATE_PRECHANGE, (void *)rate);
+
+	if (!(ret & NOTIFY_STOP_MASK)) {
+		spin_lock_irqsave(&clockfw_lock, flags);
+		if (arch_clock->clk_set_rate)
+			ret = arch_clock->clk_set_rate(clk, rate);
+		spin_unlock_irqrestore(&clockfw_lock, flags);
+
+		/* notification post change */
+		if (clk->notifier)
+			clk_notify_transition(clk,
+					      CLK_RATE_POSTCHANGE,
+					      (void *)clk->rate);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(clk_set_rate);
+
+int clk_set_parent(struct clk *clk, struct clk *parent)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	if (clk == ERR_PTR(-ENOENT))
+		return -EINVAL;
+
+	/* notification pre change */
+	if (clk->notifier)
+		ret = clk_notify_transition(clk,
+					    CLK_SRCE_PRECHANGE, (void *)parent);
+
+	if (!(ret & NOTIFY_STOP_MASK)) {
+		spin_lock_irqsave(&clockfw_lock, flags);
+		if (arch_clock->clk_set_parent)
+			ret = arch_clock->clk_set_parent(clk, parent);
+		spin_unlock_irqrestore(&clockfw_lock, flags);
+
+		/* notification post change */
+		if (clk->notifier)
+			clk_notify_transition(clk,
+					      CLK_SRCE_POSTCHANGE,
+					      (void *)clk->parent);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(clk_set_parent);
+
+struct clk *clk_get_parent(struct clk *clk)
+{
+	unsigned long flags;
+	struct clk *ret = ERR_PTR(-ENOENT);
+
+	if (clk == ERR_PTR(-ENOENT))
+		return ret;
+
+	spin_lock_irqsave(&clockfw_lock, flags);
+	if (arch_clock->clk_get_parent)
+		ret = arch_clock->clk_get_parent(clk);
+	spin_unlock_irqrestore(&clockfw_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(clk_get_parent);
+
+/*
+ * Internal clock functions
+ */
+
+unsigned int __initdata mpurate;
+/*
+ * By default we use the rate set by the bootloader.
+ * You can override this with mpurate= cmdline option.
+ */
+static int __init u6_clk_setup(char *str)
+{
+	unsigned int tmp_rate;
+
+	get_option(&str, &tmp_rate);
+
+	if (!tmp_rate)
+		return 1;
+
+	mpurate = tmp_rate;
+
+	return 1;
+}
+
+__setup("mpurate=", u6_clk_setup);
+
+/* Used for clocks that always have same value as the parent clock */
+void followparent_recalc(struct clk *clk)
+{
+	clk->rate = clk->parent->rate;
+}
+
+/* Propagate rate to children */
+void propagate_rate(struct clk *tclk)
+{
+	struct clk *clkp;
+
+	list_for_each_entry(clkp, &clocks, node) {
+		if (likely(clkp->parent != tclk))
+			continue;
+		if (likely((u32) clkp->recalc))
+			clkp->recalc(clkp);
+	}
+}
+
+int clk_register(struct clk *clk)
+{
+	mutex_lock(&clocks_mutex);
+	list_add(&clk->node, &clocks);
+	if (clk->init)
+		clk->init(clk);
+	mutex_unlock(&clocks_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL(clk_register);
+
+void clk_unregister(struct clk *clk)
+{
+	mutex_lock(&clocks_mutex);
+	list_del(&clk->node);
+	mutex_unlock(&clocks_mutex);
+}
+EXPORT_SYMBOL(clk_unregister);
+
+void clk_deny_idle(struct clk *clk)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&clockfw_lock, flags);
+	if (arch_clock->clk_deny_idle)
+		arch_clock->clk_deny_idle(clk);
+	spin_unlock_irqrestore(&clockfw_lock, flags);
+}
+EXPORT_SYMBOL(clk_deny_idle);
+
+void clk_allow_idle(struct clk *clk)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&clockfw_lock, flags);
+	if (arch_clock->clk_allow_idle)
+		arch_clock->clk_allow_idle(clk);
+	spin_unlock_irqrestore(&clockfw_lock, flags);
+}
+EXPORT_SYMBOL(clk_allow_idle);
+
+#ifdef CONFIG_U6_POWER_SYSFS
+/*
+ * SysFs interface
+ */
+
+/*** Clock mngt sysfs interface **/
+static char clk_name[64] = "MMTU";
+
+static ssize_t show_select(struct kobject *kobj, char *buf)
+{
+	return sprintf(buf, "%s \n", clk_name);
+}
+
+static ssize_t store_select(struct kobject *kobj, const char *buf, size_t size)
+{
+	strcpy(clk_name, buf);
+
+	clk_name[strlen(clk_name) - 1] = 0;
+
+	return size;
+}
+
+static ssize_t show_enable(struct kobject *kobj, char *buf)
+{
+	struct clk *clk;
+	clk = clk_get(NULL, clk_name);
+	if (clk == ERR_PTR(-ENOENT))
+		return sprintf(buf, "unable to get clk\n");
+	clk_put(clk);
+	return sprintf(buf, "%d \n", clk_get_usecount(clk));
+}
+
+static ssize_t store_enable(struct kobject *kobj, const char *buf, size_t size)
+{
+	struct clk *clk;
+	clk = clk_get(NULL, clk_name);
+	if (clk == ERR_PTR(-ENOENT))
+		return size;
+	clk_enable(clk);
+	clk_put(clk);
+	return size;
+}
+
+static ssize_t show_disable(struct kobject *kobj, char *buf)
+{
+	struct clk *clk;
+	clk = clk_get(NULL, clk_name);
+	if (clk == ERR_PTR(-ENOENT))
+		return sprintf(buf, "unable to get clk\n");
+	clk_put(clk);
+	return sprintf(buf, "%d \n", clk_get_usecount(clk));
+}
+
+static ssize_t store_disable(struct kobject *kobj, const char *buf, size_t size)
+{
+	struct clk *clk;
+	clk = clk_get(NULL, clk_name);
+	if (clk == ERR_PTR(-ENOENT))
+		return size;
+	clk_disable(clk);
+	clk_put(clk);
+	return size;
+}
+
+static ssize_t show_usecount(struct kobject *kobj, char *buf)
+{
+	struct clk *clk;
+	clk = clk_get(NULL, clk_name);
+	if (clk == ERR_PTR(-ENOENT))
+		return sprintf(buf, "unable to get clk\n");
+	clk_put(clk);
+	return sprintf(buf, "%d \n", clk_get_usecount(clk));
+}
+
+static ssize_t show_rate(struct kobject *kobj, char *buf)
+{
+	struct clk *clk;
+	clk = clk_get(NULL, clk_name);
+	if (clk == ERR_PTR(-ENOENT))
+		return sprintf(buf, "unable to get clk\n");
+	clk_put(clk);
+	return sprintf(buf, "%lu \n", clk_get_rate(clk));
+}
+
+static ssize_t store_rate(struct kobject *kobj, const char *buf, size_t size)
+{
+	struct clk *clk;
+	unsigned long rate;
+	if (strict_strtoul(buf, 10, &rate) == 0) {
+		clk = clk_get(NULL, clk_name);
+		if (clk == ERR_PTR(-ENOENT))
+			return size;
+		clk_set_rate(clk, rate);
+		clk_put(clk);
+	}
+	return size;
+}
+
+static ssize_t show_parent(struct kobject *kobj, char *buf)
+{
+	struct clk *clk, *pclk;
+	clk = clk_get(NULL, clk_name);
+	if (clk == ERR_PTR(-ENOENT))
+		return sprintf(buf, "unable to get clk\n");
+	pclk = clk_get_parent(clk);
+	clk_put(clk);
+	if ((pclk) && (pclk->name))
+		return sprintf(buf, "%s\n", pclk->name);
+	else
+		return sprintf(buf, "root\n");
+}
+
+static ssize_t store_parent(struct kobject *kobj, const char *buf, size_t size)
+{
+	struct clk *clk, *pclk;
+	char parent[32];
+	strcpy(parent, buf);
+	parent[strlen(parent) - 1] = 0;
+
+	clk = clk_get(NULL, clk_name);
+	if (clk == ERR_PTR(-ENOENT))
+		return size;
+
+	pclk = clk_get(NULL, parent);
+	if (pclk == ERR_PTR(-ENOENT)) {
+		clk_put(clk);
+		return size;
+	}
+	clk_put(pclk);
+	clk_set_parent(clk, pclk);
+	clk_put(clk);
+	return size;
+}
+
+static ssize_t show_list(struct kobject *kobj, char *buf)
+{
+	int size = 0;
+
+	struct clk *p;
+
+	list_for_each_entry(p, &clocks, node) {
+		size += sprintf(&buf[size], "%s\n", p->name);
+	}
+	return size;
+}
+
+/*** Clock mngt hw debug ***/
+static ssize_t show_hw_constraints(struct kobject *kobj, char *buf)
+{
+	int size = 0;
+
+	size += u6_clk_show_hw_rates(kobj, &buf[size]);
+
+	size += u6_clk_show_sc_constraints(kobj, &buf[size]);
+
+	size += u6_clk_show_ivs_constraints(kobj, &buf[size]);
+
+	size += u6_clk_show_tvo_constraints(kobj, &buf[size]);
+
+	size += u6_clk_show_cam_constraints(kobj, &buf[size]);
+
+	return size;
+}
+
+static ssize_t show_hw_rates(struct kobject *kobj, char *buf)
+{
+	int size = 0;
+
+	size += u6_clk_show_hw_rates(kobj, buf);
+
+	return size;
+}
+
+define_one_ro(hw_rates);
+define_one_ro(hw_constraints);
+define_one_rw(parent);
+define_one_rw(rate);
+define_one_ro(usecount);
+define_one_rw(disable);
+define_one_rw(enable);
+define_one_rw(select);
+define_one_ro(list);
+
+static struct attribute *dbs_attributes_clock[] = {
+
+	&hw_rates.attr,
+	&hw_constraints.attr,
+	&parent.attr,
+	&rate.attr,
+	&usecount.attr,
+	&disable.attr,
+	&enable.attr,
+	&select.attr,
+	&list.attr,
+	NULL
+};
+
+static struct attribute_group dbs_attr_clock_group = {
+	.attrs = dbs_attributes_clock,
+	.name = "clk_mngt",
+};
+
+#endif
+
+/*
+ * Init functions
+ */
+
+int __init clk_init(struct clk_functions *custom_clocks)
+{
+	if (!custom_clocks) {
+		printk(KERN_ERR "No custom clock functions registered\n");
+		BUG();
+	}
+
+	arch_clock = custom_clocks;
+
+	return 0;
+}
+
+#ifdef CONFIG_U6_POWER_SYSFS
+static int __init u6_clock_init_sysfs(void)
+{
+	if (sysfs_create_group(&u6_power_kobj, &dbs_attr_clock_group))
+		printk(KERN_ERR "Unable to register %s in sysfs\n",
+		       dbs_attr_clock_group.name);
+
+	return 0;
+}
+
+module_init(u6_clock_init_sysfs);
+#endif
+
diff --git a/arch/arm/plat-u6xxx/include/mach/clkdev.h b/arch/arm/plat-u6xxx/include/mach/clkdev.h
new file mode 100644
index 0000000..730c49d
--- /dev/null
+++ b/arch/arm/plat-u6xxx/include/mach/clkdev.h
@@ -0,0 +1,13 @@
+#ifndef __MACH_CLKDEV_H
+#define __MACH_CLKDEV_H
+
+static inline int __clk_get(struct clk *clk)
+{
+	return 1;
+}
+
+static inline void __clk_put(struct clk *clk)
+{
+}
+
+#endif
diff --git a/arch/arm/plat-u6xxx/include/mach/clock.h b/arch/arm/plat-u6xxx/include/mach/clock.h
new file mode 100644
index 0000000..ded9fdd
--- /dev/null
+++ b/arch/arm/plat-u6xxx/include/mach/clock.h
@@ -0,0 +1,378 @@
+/*
+ * linux/arch/arm/plat-u6xxx/include/mach/clock.h
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Loic Pallardy <loic.pallardy@stericsson.com> for ST-Ericsson
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Based on clocks.h by Tony Lindgren, Gordon McNutt and RidgeRun, Inc
+ */
+
+#ifndef __PLAT_CLOCK_H
+#define __PLAT_CLOCK_H
+
+#include <linux/io.h>
+
+struct module;
+
+struct clk {
+	struct list_head	node;
+	struct module		*owner;
+	const char		*name;
+	struct clk		*parent;
+	unsigned long		rate;
+	__u32			flags;
+	void __iomem		*enable_reg;
+	__u8			enable_bit;
+	__u8			rate_offset;
+	__u8			src_offset;
+	__s8			usecount;
+	void			(*recalc)(struct clk *);
+	int			(*set_rate)(struct clk *, unsigned long);
+	long			(*round_rate)(struct clk *, unsigned long);
+	void			(*init)(struct clk *);
+	int			(*enable)(struct clk *);
+	void			(*disable)(struct clk *);
+	int			(*set_parent)(struct clk *, struct clk *);
+	struct srcu_notifier_head *notifier;
+};
+
+struct clk_functions {
+	int		(*clk_enable)(struct clk *clk);
+	void		(*clk_disable)(struct clk *clk);
+	long		(*clk_round_rate)(struct clk *clk, unsigned long rate);
+	int		(*clk_set_rate)(struct clk *clk, unsigned long rate);
+	int		(*clk_set_parent)(struct clk *clk, struct clk *parent);
+	struct clk *	(*clk_get_parent)(struct clk *clk);
+	void		(*clk_allow_idle)(struct clk *clk);
+	void		(*clk_deny_idle)(struct clk *clk);
+};
+
+extern unsigned int mpurate;
+extern struct list_head clocks;
+extern spinlock_t clockfw_lock;
+
+extern int clk_init(struct clk_functions *custom_clocks);
+extern int clk_register(struct clk *clk);
+extern void clk_unregister(struct clk *clk);
+
+extern void propagate_rate(struct clk *clk);
+extern void followparent_recalc(struct clk *clk);
+extern void clk_allow_idle(struct clk *clk);
+extern void clk_deny_idle(struct clk *clk);
+extern int clk_get_usecount(struct clk *clk);
+
+extern ssize_t u6_clk_show_hw_rates(struct kobject *kobj, char *buf);
+extern ssize_t u6_clk_show_sc_constraints(struct kobject *kobj, char *buf);
+extern ssize_t u6_clk_show_usb_constraints(struct kobject *kobj, char *buf);
+extern ssize_t u6_clk_show_ivs_constraints(struct kobject *kobj, char *buf);
+extern ssize_t u6_clk_show_tvo_constraints(struct kobject *kobj, char *buf);
+extern ssize_t u6_clk_show_cam_constraints(struct kobject *kobj, char *buf);
+
+extern unsigned long clk_get_hw_constraint(void __iomem *reg_addr);
+
+
+/* Clock flags */
+#define RATE_CKCTL		(1 << 0)	/* Main fixed ratio clocks */
+#define RATE_FIXED		(1 << 1)	/* Fixed clock rate */
+#define RATE_PROPAGATES		(1 << 2)	/* Program children too */
+#define VIRTUAL_CLOCK		(1 << 3)	/* Composite clock from table */
+#define ALWAYS_ENABLED		(1 << 4)	/* Clock cannot be disabled */
+#define ENABLE_REG_32BIT	(1 << 5)	/* Use 32-bit access */
+#define VIRTUAL_IO_ADDRESS	(1 << 6)	/* Clock in virtual address */
+#define CLOCK_IDLE_CONTROL	(1 << 7)
+#define CLOCK_NO_IDLE_PARENT	(1 << 8)
+#define DELAYED_APP		(1 << 9)	/* Delay application of clock */
+#define CONFIG_PARTICIPANT	(1 << 10)	/* Fundamental clock */
+
+
+#define CLK_HCLK2_MAX_FREQ	104000000
+#define CLK_FC_CLK_MAX_FREQ	104000000
+#define CLK_CAM_CLK_MAX_FREQ	 78000000
+
+/**
+ * clk_register_notifier - register a driver with clock mngt
+ *	@nb: notifier function to register
+ *  @clk: clock element rate change to be notified
+ */
+extern int clk_register_notifier(struct notifier_block *nb, struct clk *clk);
+
+/**
+ * clk_unregister_notifier - unregister a driver with clock mngt
+ *	@nb: notifier function to register
+ *  @clk: clock element rate change to be notified
+ */
+extern int clk_unregister_notifier(struct notifier_block *nb, struct clk *clk);
+
+/**
+ * clk_notify_transition - call notifier chain
+ *
+ * This function calls the transition notifiers and the and set rate
+ * It is called twice on all frequency changes that have
+ * external effects.
+ */
+extern int clk_notify_transition(struct clk *clk,
+		unsigned int state, void *data);
+
+#define CLK_RATE_PRECHANGE 0
+#define CLK_RATE_POSTCHANGE 1
+#define CLK_SRCE_PRECHANGE 2
+#define CLK_SRCE_POSTCHANGE 3
+
+/* Hardware Register Definitions CGU (Clock Gating Unit) */
+
+/* CGU DSP1CON Register (32 bits) */
+#define CGU_DSP1CON_OFFSET             0x0
+#define CGU_DSP1CON_REG                U6_IO_ADDRESS(CGU_BASE + CGU_DSP1CON_OFFSET)
+
+/* CGU SCCON Register (32 bits) */
+#define CGU_SCCON_OFFSET               0x4
+#define CGU_SCCON_REG                  U6_IO_ADDRESS(CGU_BASE + CGU_SCCON_OFFSET)
+
+/* CGU GATESC1 Register (32 bits) */
+#define CGU_GATESC1_OFFSET             0x8
+#define CGU_GATESC1_REG                U6_IO_ADDRESS(CGU_BASE + CGU_GATESC1_OFFSET)
+
+/* CGU SLEEPSC Register (32 bits) */
+#define CGU_SLEEPSC_OFFSET             0xC
+#define CGU_SLEEPSC_REG                U6_IO_ADDRESS(CGU_BASE + CGU_SLEEPSC_OFFSET)
+
+/* CGU FDIV Register (32 bits) */
+#define CGU_FDIV_OFFSET                0x10
+#define CGU_FDIV_REG                   U6_IO_ADDRESS(CGU_BASE + CGU_FDIV_OFFSET)
+
+/* CGU GATEIVS Register (32 bits) */
+#define CGU_GATEIVS_OFFSET             0x14
+#define CGU_GATEIVS_REG                U6_IO_ADDRESS(CGU_BASE + CGU_GATEIVS_OFFSET)
+
+/* CGU DSP2CON Register (32 bits) */
+#define CGU_DSP2CON_OFFSET             0x18
+#define CGU_DSP2CON_REG                U6_IO_ADDRESS(CGU_BASE + CGU_DSP2CON_OFFSET)
+
+/* CGU CAMCON Register (32 bits) */
+#define CGU_CAMCON_OFFSET              0x1C
+#define CGU_CAMCON_REG                 U6_IO_ADDRESS(CGU_BASE + CGU_CAMCON_OFFSET)
+
+/* CGU GATESC2 Register (32 bits) */
+#define CGU_GATESC2_OFFSET             0x20
+#define CGU_GATESC2_REG                U6_IO_ADDRESS(CGU_BASE + CGU_GATESC2_OFFSET)
+
+/* CGU SDMCON Register (32 bits) */
+#define CGU_SDMCON_OFFSET              0x24
+#define CGU_SDMCON_REG                 U6_IO_ADDRESS(CGU_BASE + CGU_SDMCON_OFFSET)
+
+/* CGU TVCON Register (32 bits) */
+#define CGU_TVCON_OFFSET               0x28
+#define CGU_TVCON_REG                  U6_IO_ADDRESS(CGU_BASE + CGU_TVCON_OFFSET)
+
+/* CGU IDLESC Register (32 bits) */
+#define CGU_IDLESC_OFFSET              0x2C
+#define CGU_IDLESC_REG                 U6_IO_ADDRESS(CGU_BASE + CGU_IDLESC_OFFSET)
+
+/* CGU FIXCON Register (32 bits) */
+#define CGU_FIXCON_OFFSET              0x30
+#define CGU_FIXCON_REG                 U6_IO_ADDRESS(CGU_BASE + CGU_FIXCON_OFFSET)
+
+/* CGU CNTCON Register (32 bits) */
+#define CGU_CNTCON_OFFSET              0x38
+#define CGU_CNTCON_REG                 U6_IO_ADDRESS(CGU_BASE + CGU_CNTCON_OFFSET)
+
+/* Register description for GATESC1 */
+
+/* Bits definition for register CGU_GATESC1 */
+#define CGU_EBIEN_SHIFT            31
+#define CGU_EBIEN_FIELD            (0xFFFFFFFF - (0x1UL<<CGU_EBIEN_SHIFT))
+#define CGU_EBIEN_0                (0x0UL<<CGU_EBIEN_SHIFT)
+#define CGU_EBIEN_1                (0x1UL<<CGU_EBIEN_SHIFT)
+#define CGU_EBIEN                  (0x1UL<<CGU_EBIEN_SHIFT)
+#define CGU_NFIEN_SHIFT            29
+#define CGU_NFIEN_FIELD            (0xFFFFFFFF - (0x1UL<<CGU_NFIEN_SHIFT))
+#define CGU_NFIEN_0                (0x0UL<<CGU_NFIEN_SHIFT)
+#define CGU_NFIEN_1                (0x1UL<<CGU_NFIEN_SHIFT)
+#define CGU_NFIEN                  (0x1UL<<CGU_NFIEN_SHIFT)
+#define CGU_SDIEN_SHIFT            28
+#define CGU_SDIEN_FIELD            (0xFFFFFFFF - (0x1UL<<CGU_SDIEN_SHIFT))
+#define CGU_SDIEN_0                (0x0UL<<CGU_SDIEN_SHIFT)
+#define CGU_SDIEN_1                (0x1UL<<CGU_SDIEN_SHIFT)
+#define CGU_SDIEN                  (0x1UL<<CGU_SDIEN_SHIFT)
+#define CGU_MSIEN_SHIFT            26
+#define CGU_MSIEN_FIELD            (0xFFFFFFFF - (0x1UL<<CGU_MSIEN_SHIFT))
+#define CGU_MSIEN_0                (0x0UL<<CGU_MSIEN_SHIFT)
+#define CGU_MSIEN_1                (0x1UL<<CGU_MSIEN_SHIFT)
+#define CGU_MSIEN                  (0x1UL<<CGU_MSIEN_SHIFT)
+#define CGU_UCCEN_SHIFT            25
+#define CGU_UCCEN_FIELD            (0xFFFFFFFF - (0x1UL<<CGU_UCCEN_SHIFT))
+#define CGU_UCCEN_0                (0x0UL<<CGU_UCCEN_SHIFT)
+#define CGU_UCCEN_1                (0x1UL<<CGU_UCCEN_SHIFT)
+#define CGU_UCCEN                  (0x1UL<<CGU_UCCEN_SHIFT)
+#define CGU_JDIEN_SHIFT            24
+#define CGU_JDIEN_FIELD            (0xFFFFFFFF - (0x1UL<<CGU_JDIEN_SHIFT))
+#define CGU_JDIEN_0                (0x0UL<<CGU_JDIEN_SHIFT)
+#define CGU_JDIEN_1                (0x1UL<<CGU_JDIEN_SHIFT)
+#define CGU_JDIEN                  (0x1UL<<CGU_JDIEN_SHIFT)
+#define CGU_DMAUEN_SHIFT           20
+#define CGU_DMAUEN_FIELD           (0xFFFFFFFF - (0x1UL<<CGU_DMAUEN_SHIFT))
+#define CGU_DMAUEN_0               (0x0UL<<CGU_DMAUEN_SHIFT)
+#define CGU_DMAUEN_1               (0x1UL<<CGU_DMAUEN_SHIFT)
+#define CGU_DMAUEN                 (0x1UL<<CGU_DMAUEN_SHIFT)
+#define CGU_RFSM1EN_SHIFT          19
+#define CGU_RFSM1EN_FIELD          (0xFFFFFFFF - (0x1UL<<CGU_RFSM1EN_SHIFT))
+#define CGU_RFSM1EN_0              (0x0UL<<CGU_RFSM1EN_SHIFT)
+#define CGU_RFSM1EN_1              (0x1UL<<CGU_RFSM1EN_SHIFT)
+#define CGU_RFSM1EN                (0x1UL<<CGU_RFSM1EN_SHIFT)
+#define CGU_SIISEN_SHIFT           18
+#define CGU_SIISEN_FIELD           (0xFFFFFFFF - (0x1UL<<CGU_SIISEN_SHIFT))
+#define CGU_SIISEN_0               (0x0UL<<CGU_SIISEN_SHIFT)
+#define CGU_SIISEN_1               (0x1UL<<CGU_SIISEN_SHIFT)
+#define CGU_SIISEN                 (0x1UL<<CGU_SIISEN_SHIFT)
+#define CGU_USBEN_SHIFT            17
+#define CGU_USBEN_FIELD            (0xFFFFFFFF - (0x1UL<<CGU_USBEN_SHIFT))
+#define CGU_USBEN_0                (0x0UL<<CGU_USBEN_SHIFT)
+#define CGU_USBEN_1                (0x1UL<<CGU_USBEN_SHIFT)
+#define CGU_USBEN                  (0x1UL<<CGU_USBEN_SHIFT)
+#define CGU_FCIEN_SHIFT            16
+#define CGU_FCIEN_FIELD            (0xFFFFFFFF - (0x1UL<<CGU_FCIEN_SHIFT))
+#define CGU_FCIEN_0                (0x0UL<<CGU_FCIEN_SHIFT)
+#define CGU_FCIEN_1                (0x1UL<<CGU_FCIEN_SHIFT)
+#define CGU_FCIEN                  (0x1UL<<CGU_FCIEN_SHIFT)
+#define CGU_USIMEN_SHIFT           15
+#define CGU_USIMEN_FIELD           (0xFFFFFFFF - (0x1UL<<CGU_USIMEN_SHIFT))
+#define CGU_USIMEN_0               (0x0UL<<CGU_USIMEN_SHIFT)
+#define CGU_USIMEN_1               (0x1UL<<CGU_USIMEN_SHIFT)
+#define CGU_USIMEN                 (0x1UL<<CGU_USIMEN_SHIFT)
+#define CGU_GEACEN_SHIFT           14
+#define CGU_GEACEN_FIELD           (0xFFFFFFFF - (0x1UL<<CGU_GEACEN_SHIFT))
+#define CGU_GEACEN_0               (0x0UL<<CGU_GEACEN_SHIFT)
+#define CGU_GEACEN_1               (0x1UL<<CGU_GEACEN_SHIFT)
+#define CGU_GEACEN                 (0x1UL<<CGU_GEACEN_SHIFT)
+#define CGU_PWM3EN_SHIFT           13
+#define CGU_PWM3EN_FIELD           (0xFFFFFFFF - (0x1UL<<CGU_PWM3EN_SHIFT))
+#define CGU_PWM3EN_0               (0x0UL<<CGU_PWM3EN_SHIFT)
+#define CGU_PWM3EN_1               (0x1UL<<CGU_PWM3EN_SHIFT)
+#define CGU_PWM3EN                 (0x1UL<<CGU_PWM3EN_SHIFT)
+#define CGU_PWM2EN_SHIFT           12
+#define CGU_PWM2EN_FIELD           (0xFFFFFFFF - (0x1UL<<CGU_PWM2EN_SHIFT))
+#define CGU_PWM2EN_0               (0x0UL<<CGU_PWM2EN_SHIFT)
+#define CGU_PWM2EN_1               (0x1UL<<CGU_PWM2EN_SHIFT)
+#define CGU_PWM2EN                 (0x1UL<<CGU_PWM2EN_SHIFT)
+#define CGU_PWM1EN_SHIFT           11
+#define CGU_PWM1EN_FIELD           (0xFFFFFFFF - (0x1UL<<CGU_PWM1EN_SHIFT))
+#define CGU_PWM1EN_0               (0x0UL<<CGU_PWM1EN_SHIFT)
+#define CGU_PWM1EN_1               (0x1UL<<CGU_PWM1EN_SHIFT)
+#define CGU_PWM1EN                 (0x1UL<<CGU_PWM1EN_SHIFT)
+#define CGU_KBSEN_SHIFT            10
+#define CGU_KBSEN_FIELD            (0xFFFFFFFF - (0x1UL<<CGU_KBSEN_SHIFT))
+#define CGU_KBSEN_0                (0x0UL<<CGU_KBSEN_SHIFT)
+#define CGU_KBSEN_1                (0x1UL<<CGU_KBSEN_SHIFT)
+#define CGU_KBSEN                  (0x1UL<<CGU_KBSEN_SHIFT)
+#define CGU_GPIOEN_SHIFT           9
+#define CGU_GPIOEN_FIELD           (0xFFFFFFFF - (0x1UL<<CGU_GPIOEN_SHIFT))
+#define CGU_GPIOEN_0               (0x0UL<<CGU_GPIOEN_SHIFT)
+#define CGU_GPIOEN_1               (0x1UL<<CGU_GPIOEN_SHIFT)
+#define CGU_GPIOEN                 (0x1UL<<CGU_GPIOEN_SHIFT)
+#define CGU_UART2EN_SHIFT          8
+#define CGU_UART2EN_FIELD          (0xFFFFFFFF - (0x1UL<<CGU_UART2EN_SHIFT))
+#define CGU_UART2EN_0              (0x0UL<<CGU_UART2EN_SHIFT)
+#define CGU_UART2EN_1              (0x1UL<<CGU_UART2EN_SHIFT)
+#define CGU_UART2EN                (0x1UL<<CGU_UART2EN_SHIFT)
+#define CGU_UART1EN_SHIFT          7
+#define CGU_UART1EN_FIELD          (0xFFFFFFFF - (0x1UL<<CGU_UART1EN_SHIFT))
+#define CGU_UART1EN_0              (0x0UL<<CGU_UART1EN_SHIFT)
+#define CGU_UART1EN_1              (0x1UL<<CGU_UART1EN_SHIFT)
+#define CGU_UART1EN                (0x1UL<<CGU_UART1EN_SHIFT)
+#define CGU_IIC2EN_SHIFT           6
+#define CGU_IIC2EN_FIELD           (0xFFFFFFFF - (0x1UL<<CGU_IIC2EN_SHIFT))
+#define CGU_IIC2EN_0               (0x0UL<<CGU_IIC2EN_SHIFT)
+#define CGU_IIC2EN_1               (0x1UL<<CGU_IIC2EN_SHIFT)
+#define CGU_IIC2EN                 (0x1UL<<CGU_IIC2EN_SHIFT)
+#define CGU_IIC1EN_SHIFT           5
+#define CGU_IIC1EN_FIELD           (0xFFFFFFFF - (0x1UL<<CGU_IIC1EN_SHIFT))
+#define CGU_IIC1EN_0               (0x0UL<<CGU_IIC1EN_SHIFT)
+#define CGU_IIC1EN_1               (0x1UL<<CGU_IIC1EN_SHIFT)
+#define CGU_IIC1EN                 (0x1UL<<CGU_IIC1EN_SHIFT)
+#define CGU_SPI2EN_SHIFT           4
+#define CGU_SPI2EN_FIELD           (0xFFFFFFFF - (0x1UL<<CGU_SPI2EN_SHIFT))
+#define CGU_SPI2EN_0               (0x0UL<<CGU_SPI2EN_SHIFT)
+#define CGU_SPI2EN_1               (0x1UL<<CGU_SPI2EN_SHIFT)
+#define CGU_SPI2EN                 (0x1UL<<CGU_SPI2EN_SHIFT)
+#define CGU_SPI1EN_SHIFT           3
+#define CGU_SPI1EN_FIELD           (0xFFFFFFFF - (0x1UL<<CGU_SPI1EN_SHIFT))
+#define CGU_SPI1EN_0               (0x0UL<<CGU_SPI1EN_SHIFT)
+#define CGU_SPI1EN_1               (0x1UL<<CGU_SPI1EN_SHIFT)
+#define CGU_SPI1EN                 (0x1UL<<CGU_SPI1EN_SHIFT)
+#define CGU_SCTUEN_SHIFT           2
+#define CGU_SCTUEN_FIELD           (0xFFFFFFFF - (0x1UL<<CGU_SCTUEN_SHIFT))
+#define CGU_SCTUEN_0               (0x0UL<<CGU_SCTUEN_SHIFT)
+#define CGU_SCTUEN_1               (0x1UL<<CGU_SCTUEN_SHIFT)
+#define CGU_SCTUEN                 (0x1UL<<CGU_SCTUEN_SHIFT)
+#define CGU_EXTINTEN_SHIFT         1
+#define CGU_EXTINTEN_FIELD         (0xFFFFFFFF - (0x1UL<<CGU_EXTINTEN_SHIFT))
+#define CGU_EXTINTEN_0             (0x0UL<<CGU_EXTINTEN_SHIFT)
+#define CGU_EXTINTEN_1             (0x1UL<<CGU_EXTINTEN_SHIFT)
+#define CGU_EXTINTEN               (0x1UL<<CGU_EXTINTEN_SHIFT)
+#define CGU_INTCEN_SHIFT           0
+#define CGU_INTCEN_FIELD           (0xFFFFFFFF - (0x1UL<<CGU_INTCEN_SHIFT))
+#define CGU_INTCEN_0               (0x0UL<<CGU_INTCEN_SHIFT)
+#define CGU_INTCEN_1               (0x1UL<<CGU_INTCEN_SHIFT)
+#define CGU_INTCEN                 (0x1UL<<CGU_INTCEN_SHIFT)
+
+/* Register description for GATESC2 */
+
+/* Bits definition for register CGU_GATESC2 */
+#define CGU_TRAUPCLKEN_SHIFT       15
+#define CGU_TRAUPCLKEN_FIELD       (0xFFFFFFFF - (0x1UL<<CGU_TRAUPCLKEN_SHIFT))
+#define CGU_TRAUPCLKEN_0           (0x0UL<<CGU_TRAUPCLKEN_SHIFT)
+#define CGU_TRAUPCLKEN_1           (0x1UL<<CGU_TRAUPCLKEN_SHIFT)
+#define CGU_TRAUPCLKEN             (0x1UL<<CGU_TRAUPCLKEN_SHIFT)
+#define CGU_AUTRXPCLKEN_SHIFT      12
+#define CGU_AUTRXPCLKEN_FIELD      (0xFFFFFFFF - (0x1UL<<CGU_AUTRXPCLKEN_SHIFT))
+#define CGU_AUTRXPCLKEN_0          (0x0UL<<CGU_AUTRXPCLKEN_SHIFT)
+#define CGU_AUTRXPCLKEN_1          (0x1UL<<CGU_AUTRXPCLKEN_SHIFT)
+#define CGU_AUTRXPCLKEN            (0x1UL<<CGU_AUTRXPCLKEN_SHIFT)
+#define CGU_AUTRXMCLK2EN_SHIFT     11
+#define CGU_AUTRXMCLK2EN_FIELD    (0xFFFFFFFF - (0x1UL<<CGU_AUTRXMCLK2EN_SHIFT))
+#define CGU_AUTRXMCLK2EN_0         (0x0UL<<CGU_AUTRXMCLK2EN_SHIFT)
+#define CGU_AUTRXMCLK2EN_1         (0x1UL<<CGU_AUTRXMCLK2EN_SHIFT)
+#define CGU_AUTRXMCLK2EN           (0x1UL<<CGU_AUTRXMCLK2EN_SHIFT)
+#define CGU_AUTRXMCLK1EN_SHIFT     10
+#define CGU_AUTRXMCLK1EN_FIELD    (0xFFFFFFFF - (0x1UL<<CGU_AUTRXMCLK1EN_SHIFT))
+#define CGU_AUTRXMCLK1EN_0         (0x0UL<<CGU_AUTRXMCLK1EN_SHIFT)
+#define CGU_AUTRXMCLK1EN_1         (0x1UL<<CGU_AUTRXMCLK1EN_SHIFT)
+#define CGU_AUTRXMCLK1EN           (0x1UL<<CGU_AUTRXMCLK1EN_SHIFT)
+#define CGU_BBIPCLKEN_SHIFT        9
+#define CGU_BBIPCLKEN_FIELD        (0xFFFFFFFF - (0x1UL<<CGU_BBIPCLKEN_SHIFT))
+#define CGU_BBIPCLKEN_0            (0x0UL<<CGU_BBIPCLKEN_SHIFT)
+#define CGU_BBIPCLKEN_1            (0x1UL<<CGU_BBIPCLKEN_SHIFT)
+#define CGU_BBIPCLKEN              (0x1UL<<CGU_BBIPCLKEN_SHIFT)
+#define CGU_HSDPAHCLKEN_SHIFT      8
+#define CGU_HSDPAHCLKEN_FIELD      (0xFFFFFFFF - (0x1UL<<CGU_HSDPAHCLKEN_SHIFT))
+#define CGU_HSDPAHCLKEN_0          (0x0UL<<CGU_HSDPAHCLKEN_SHIFT)
+#define CGU_HSDPAHCLKEN_1          (0x1UL<<CGU_HSDPAHCLKEN_SHIFT)
+#define CGU_HSDPAHCLKEN            (0x1UL<<CGU_HSDPAHCLKEN_SHIFT)
+#define CGU_3GMHCLKEN_SHIFT        7
+#define CGU_3GMHCLKEN_FIELD        (0xFFFFFFFF - (0x1UL<<CGU_3GMHCLKEN_SHIFT))
+#define CGU_3GMHCLKEN_0            (0x0UL<<CGU_3GMHCLKEN_SHIFT)
+#define CGU_3GMHCLKEN_1            (0x1UL<<CGU_3GMHCLKEN_SHIFT)
+#define CGU_3GMHCLKEN              (0x1UL<<CGU_3GMHCLKEN_SHIFT)
+#define CGU_3GMMCLKEN_SHIFT        6
+#define CGU_3GMMCLKEN_FIELD        (0xFFFFFFFF - (0x1UL<<CGU_3GMMCLKEN_SHIFT))
+#define CGU_3GMMCLKEN_0            (0x0UL<<CGU_3GMMCLKEN_SHIFT)
+#define CGU_3GMMCLKEN_1            (0x1UL<<CGU_3GMMCLKEN_SHIFT)
+#define CGU_3GMMCLKEN              (0x1UL<<CGU_3GMMCLKEN_SHIFT)
+#define CGU_ETBEN_SHIFT            4
+#define CGU_ETBEN_FIELD            (0xFFFFFFFF - (0x1UL<<CGU_ETBEN_SHIFT))
+#define CGU_ETBEN_0                (0x0UL<<CGU_ETBEN_SHIFT)
+#define CGU_ETBEN_1                (0x1UL<<CGU_ETBEN_SHIFT)
+#define CGU_ETBEN                  (0x1UL<<CGU_ETBEN_SHIFT)
+#define CGU_MMTUEN_SHIFT           2
+#define CGU_MMTUEN_FIELD           (0xFFFFFFFF - (0x1UL<<CGU_MMTUEN_SHIFT))
+#define CGU_MMTUEN_0               (0x0UL<<CGU_MMTUEN_SHIFT)
+#define CGU_MMTUEN_1               (0x1UL<<CGU_MMTUEN_SHIFT)
+#define CGU_MMTUEN                 (0x1UL<<CGU_MMTUEN_SHIFT)
+#define CGU_CAEEN_SHIFT            0
+#define CGU_CAEEN_FIELD            (0xFFFFFFFF - (0x1UL<<CGU_CAEEN_SHIFT))
+#define CGU_CAEEN_0                (0x0UL<<CGU_CAEEN_SHIFT)
+#define CGU_CAEEN_1                (0x1UL<<CGU_CAEEN_SHIFT)
+#define CGU_CAEEN                  (0x1UL<<CGU_CAEEN_SHIFT)
+
+#endif
-- 
1.7.1


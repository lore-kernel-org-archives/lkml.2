Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab2KKMuz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:50:55 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45333 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab2KKMuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:50:52 -0500
From: Jonas Gorski <jonas.gorski@gmail.com>
To: linux-mips@linux-mips.org
Cc: Ralf Baechle <ralf@linux-mips.org>, John Crispin <blogic@openwrt.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <florian@openwrt.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [RFC] MIPS: BCM63XX: switch to common clock and Device Tree
Date: Sun, 11 Nov 2012 13:50:44 +0100
Message-Id: <1352638249-29298-11-git-send-email-jonas.gorski@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch BCM63XX to the common clock framework and use clkdev for
providing clock name lookups for non-DT devices.

Clocks can have a frequency and gate-bit, or none, in case they
are just provided for drivers expecting them to be present.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 .../devicetree/bindings/clock/bcm63xx-clock.txt    |   32 ++
 arch/mips/Kconfig                                  |    3 +-
 arch/mips/bcm63xx/Makefile                         |    7 +-
 arch/mips/bcm63xx/clk.c                            |  331 --------------------
 arch/mips/include/asm/mach-bcm63xx/bcm63xx_clk.h   |   11 -
 drivers/clk/Makefile                               |    1 +
 drivers/clk/clk-bcm63xx.c                          |  241 ++++++++++++++
 7 files changed, 279 insertions(+), 347 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/bcm63xx-clock.txt
 delete mode 100644 arch/mips/bcm63xx/clk.c
 delete mode 100644 arch/mips/include/asm/mach-bcm63xx/bcm63xx_clk.h
 create mode 100644 drivers/clk/clk-bcm63xx.c

diff --git a/Documentation/devicetree/bindings/clock/bcm63xx-clock.txt b/Documentation/devicetree/bindings/clock/bcm63xx-clock.txt
new file mode 100644
index 0000000..467c0c2
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/bcm63xx-clock.txt
@@ -0,0 +1,32 @@
+* Broadcom BCM63XX Clock bindings
+
+This binding uses the common clock binding[1].
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible: one of
+  a) "brcm,bcm63xx-clock"
+  Standard BCM63XX clock.
+  b) "brcm,bcm63xx-sar-clock"
+  SAR/ATM clock, which requires a reset of the SAR/ATM block.
+  c) "brcm,bcm63xx-enetsw-clock"
+  Generic ethernet switch clock, which requires a reset of the block.
+  d) "brcm,bcm6368-enetsw-clock"
+  BCM6368 ethernet switch clock, which requires additional clocks to be
+  enabled during reset.
+
+Optional properties:
+- brcm,gate-bit: gate bit in the clock control register.
+
+- clock-frequency: frequency of this clock.
+
+Example:
+
+	hsspi: clock@9 {
+		compatible = "brcm,bcm63xx-clock";
+		#clock-cells = <0>;
+		clock-output-names = "hsspi";
+		brcm,gate-bit = <9>;
+		clock-frequency = <133333333>;
+	};
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 168b0fc..1203113 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -131,7 +131,8 @@ config BCM63XX
 	select SYS_HAS_EARLY_PRINTK
 	select SWAP_IO_SPACE
 	select ARCH_REQUIRE_GPIOLIB
-	select HAVE_CLK
+	select COMMON_CLK
+	select CLKDEV
 	select USE_OF
 	help
 	 Support for BCM63XX based boards
diff --git a/arch/mips/bcm63xx/Makefile b/arch/mips/bcm63xx/Makefile
index 30971a7..994893c 100644
--- a/arch/mips/bcm63xx/Makefile
+++ b/arch/mips/bcm63xx/Makefile
@@ -1,7 +1,6 @@
-obj-y		+= clk.o cpu.o cs.o gpio.o irq.o nvram.o prom.o reset.o \
-		   setup.o timer.o dev-dsp.o dev-enet.o dev-flash.o \
-		   dev-pcmcia.o dev-rng.o dev-spi.o dev-uart.o dev-wdt.o \
-		   dev-usb-usbd.o
+obj-y		+= cpu.o cs.o gpio.o irq.o nvram.o prom.o reset.o setup.o \
+		   timer.o dev-dsp.o dev-enet.o dev-flash.o dev-pcmcia.o \
+		   dev-rng.o dev-spi.o dev-uart.o dev-wdt.o dev-usb-usbd.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 
 obj-y		+= boards/
diff --git a/arch/mips/bcm63xx/clk.c b/arch/mips/bcm63xx/clk.c
deleted file mode 100644
index b9e948d..0000000
--- a/arch/mips/bcm63xx/clk.c
+++ /dev/null
@@ -1,331 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2008 Maxime Bizon <mbizon@freebox.fr>
- */
-
-#include <linux/module.h>
-#include <linux/mutex.h>
-#include <linux/err.h>
-#include <linux/clk.h>
-#include <linux/delay.h>
-#include <bcm63xx_cpu.h>
-#include <bcm63xx_io.h>
-#include <bcm63xx_regs.h>
-#include <bcm63xx_reset.h>
-#include <bcm63xx_clk.h>
-
-static DEFINE_MUTEX(clocks_mutex);
-
-
-static void clk_enable_unlocked(struct clk *clk)
-{
-	if (clk->set && (clk->usage++) == 0)
-		clk->set(clk, 1);
-}
-
-static void clk_disable_unlocked(struct clk *clk)
-{
-	if (clk->set && (--clk->usage) == 0)
-		clk->set(clk, 0);
-}
-
-static void bcm_hwclock_set(u32 mask, int enable)
-{
-	u32 reg;
-
-	reg = bcm_perf_readl(PERF_CKCTL_REG);
-	if (enable)
-		reg |= mask;
-	else
-		reg &= ~mask;
-	bcm_perf_writel(reg, PERF_CKCTL_REG);
-}
-
-/*
- * Ethernet MAC "misc" clock: dma clocks and main clock on 6348
- */
-static void enet_misc_set(struct clk *clk, int enable)
-{
-	u32 mask;
-
-	if (BCMCPU_IS_6338())
-		mask = CKCTL_6338_ENET_EN;
-	else if (BCMCPU_IS_6345())
-		mask = CKCTL_6345_ENET_EN;
-	else if (BCMCPU_IS_6348())
-		mask = CKCTL_6348_ENET_EN;
-	else
-		/* BCMCPU_IS_6358 */
-		mask = CKCTL_6358_EMUSB_EN;
-	bcm_hwclock_set(mask, enable);
-}
-
-static struct clk clk_enet_misc = {
-	.set	= enet_misc_set,
-};
-
-/*
- * Ethernet MAC clocks: only revelant on 6358, silently enable misc
- * clocks
- */
-static void enetx_set(struct clk *clk, int enable)
-{
-	if (enable)
-		clk_enable_unlocked(&clk_enet_misc);
-	else
-		clk_disable_unlocked(&clk_enet_misc);
-
-	if (BCMCPU_IS_6358()) {
-		u32 mask;
-
-		if (clk->id == 0)
-			mask = CKCTL_6358_ENET0_EN;
-		else
-			mask = CKCTL_6358_ENET1_EN;
-		bcm_hwclock_set(mask, enable);
-	}
-}
-
-static struct clk clk_enet0 = {
-	.id	= 0,
-	.set	= enetx_set,
-};
-
-static struct clk clk_enet1 = {
-	.id	= 1,
-	.set	= enetx_set,
-};
-
-/*
- * Ethernet PHY clock
- */
-static void ephy_set(struct clk *clk, int enable)
-{
-	if (!BCMCPU_IS_6358())
-		return;
-	bcm_hwclock_set(CKCTL_6358_EPHY_EN, enable);
-}
-
-
-static struct clk clk_ephy = {
-	.set	= ephy_set,
-};
-
-/*
- * Ethernet switch clock
- */
-static void enetsw_set(struct clk *clk, int enable)
-{
-	if (!BCMCPU_IS_6368())
-		return;
-	bcm_hwclock_set(CKCTL_6368_ROBOSW_EN |
-			CKCTL_6368_SWPKT_USB_EN |
-			CKCTL_6368_SWPKT_SAR_EN, enable);
-	if (enable) {
-		/* reset switch core afer clock change */
-		bcm63xx_core_set_reset(BCM63XX_RESET_ENETSW, 1);
-		msleep(10);
-		bcm63xx_core_set_reset(BCM63XX_RESET_ENETSW, 0);
-		msleep(10);
-	}
-}
-
-static struct clk clk_enetsw = {
-	.set	= enetsw_set,
-};
-
-/*
- * PCM clock
- */
-static void pcm_set(struct clk *clk, int enable)
-{
-	if (!BCMCPU_IS_6358())
-		return;
-	bcm_hwclock_set(CKCTL_6358_PCM_EN, enable);
-}
-
-static struct clk clk_pcm = {
-	.set	= pcm_set,
-};
-
-/*
- * USB host clock
- */
-static void usbh_set(struct clk *clk, int enable)
-{
-	if (BCMCPU_IS_6328())
-		bcm_hwclock_set(CKCTL_6328_USBH_EN, enable);
-	else if (BCMCPU_IS_6348())
-		bcm_hwclock_set(CKCTL_6348_USBH_EN, enable);
-	else if (BCMCPU_IS_6368())
-		bcm_hwclock_set(CKCTL_6368_USBH_EN, enable);
-}
-
-static struct clk clk_usbh = {
-	.set	= usbh_set,
-};
-
-/*
- * USB device clock
- */
-static void usbd_set(struct clk *clk, int enable)
-{
-	if (BCMCPU_IS_6328())
-		bcm_hwclock_set(CKCTL_6328_USBD_EN, enable);
-	else if (BCMCPU_IS_6368())
-		bcm_hwclock_set(CKCTL_6368_USBD_EN, enable);
-}
-
-static struct clk clk_usbd = {
-	.set	= usbd_set,
-};
-
-/*
- * SPI clock
- */
-static void spi_set(struct clk *clk, int enable)
-{
-	u32 mask;
-
-	if (BCMCPU_IS_6338())
-		mask = CKCTL_6338_SPI_EN;
-	else if (BCMCPU_IS_6348())
-		mask = CKCTL_6348_SPI_EN;
-	else if (BCMCPU_IS_6358())
-		mask = CKCTL_6358_SPI_EN;
-	else
-		/* BCMCPU_IS_6368 */
-		mask = CKCTL_6368_SPI_EN;
-	bcm_hwclock_set(mask, enable);
-}
-
-static struct clk clk_spi = {
-	.set	= spi_set,
-};
-
-/*
- * XTM clock
- */
-static void xtm_set(struct clk *clk, int enable)
-{
-	if (!BCMCPU_IS_6368())
-		return;
-
-	bcm_hwclock_set(CKCTL_6368_SAR_EN |
-			CKCTL_6368_SWPKT_SAR_EN, enable);
-
-	if (enable) {
-		/* reset sar core afer clock change */
-		bcm63xx_core_set_reset(BCM63XX_RESET_SAR, 1);
-		mdelay(1);
-		bcm63xx_core_set_reset(BCM63XX_RESET_SAR, 0);
-		mdelay(1);
-	}
-}
-
-
-static struct clk clk_xtm = {
-	.set	= xtm_set,
-};
-
-/*
- * IPsec clock
- */
-static void ipsec_set(struct clk *clk, int enable)
-{
-	bcm_hwclock_set(CKCTL_6368_IPSEC_EN, enable);
-}
-
-static struct clk clk_ipsec = {
-	.set	= ipsec_set,
-};
-
-/*
- * PCIe clock
- */
-
-static void pcie_set(struct clk *clk, int enable)
-{
-	bcm_hwclock_set(CKCTL_6328_PCIE_EN, enable);
-}
-
-static struct clk clk_pcie = {
-	.set	= pcie_set,
-};
-
-/*
- * Internal peripheral clock
- */
-static struct clk clk_periph = {
-	.rate	= (50 * 1000 * 1000),
-};
-
-
-/*
- * Linux clock API implementation
- */
-int clk_enable(struct clk *clk)
-{
-	mutex_lock(&clocks_mutex);
-	clk_enable_unlocked(clk);
-	mutex_unlock(&clocks_mutex);
-	return 0;
-}
-
-EXPORT_SYMBOL(clk_enable);
-
-void clk_disable(struct clk *clk)
-{
-	mutex_lock(&clocks_mutex);
-	clk_disable_unlocked(clk);
-	mutex_unlock(&clocks_mutex);
-}
-
-EXPORT_SYMBOL(clk_disable);
-
-unsigned long clk_get_rate(struct clk *clk)
-{
-	return clk->rate;
-}
-
-EXPORT_SYMBOL(clk_get_rate);
-
-struct clk *clk_get(struct device *dev, const char *id)
-{
-	if (!strcmp(id, "enet0"))
-		return &clk_enet0;
-	if (!strcmp(id, "enet1"))
-		return &clk_enet1;
-	if (!strcmp(id, "enetsw"))
-		return &clk_enetsw;
-	if (!strcmp(id, "ephy"))
-		return &clk_ephy;
-	if (!strcmp(id, "usbh"))
-		return &clk_usbh;
-	if (!strcmp(id, "usbd"))
-		return &clk_usbd;
-	if (!strcmp(id, "spi"))
-		return &clk_spi;
-	if (!strcmp(id, "xtm"))
-		return &clk_xtm;
-	if (!strcmp(id, "periph"))
-		return &clk_periph;
-	if (BCMCPU_IS_6358() && !strcmp(id, "pcm"))
-		return &clk_pcm;
-	if (BCMCPU_IS_6368() && !strcmp(id, "ipsec"))
-		return &clk_ipsec;
-	if (BCMCPU_IS_6328() && !strcmp(id, "pcie"))
-		return &clk_pcie;
-	return ERR_PTR(-ENOENT);
-}
-
-EXPORT_SYMBOL(clk_get);
-
-void clk_put(struct clk *clk)
-{
-}
-
-EXPORT_SYMBOL(clk_put);
diff --git a/arch/mips/include/asm/mach-bcm63xx/bcm63xx_clk.h b/arch/mips/include/asm/mach-bcm63xx/bcm63xx_clk.h
deleted file mode 100644
index 8fcf8df..0000000
--- a/arch/mips/include/asm/mach-bcm63xx/bcm63xx_clk.h
+++ /dev/null
@@ -1,11 +0,0 @@
-#ifndef BCM63XX_CLK_H_
-#define BCM63XX_CLK_H_
-
-struct clk {
-	void		(*set)(struct clk *, int);
-	unsigned int	rate;
-	unsigned int	usage;
-	int		id;
-};
-
-#endif /* ! BCM63XX_CLK_H_ */
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 71a25b9..c991c8b 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -19,6 +19,7 @@ endif
 obj-$(CONFIG_MACH_LOONGSON1)	+= clk-ls1x.o
 obj-$(CONFIG_ARCH_U8500)	+= ux500/
 obj-$(CONFIG_ARCH_VT8500)	+= clk-vt8500.o
+obj-$(CONFIG_BCM63XX)		+= clk-bcm63xx.o
 
 # Chip specific
 obj-$(CONFIG_COMMON_CLK_WM831X) += clk-wm831x.o
diff --git a/drivers/clk/clk-bcm63xx.c b/drivers/clk/clk-bcm63xx.c
new file mode 100644
index 0000000..571bb71
--- /dev/null
+++ b/drivers/clk/clk-bcm63xx.c
@@ -0,0 +1,241 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
+#include <linux/of.h>
+#include <linux/delay.h>
+
+#include <bcm63xx_cpu.h>
+#include <bcm63xx_io.h>
+#include <bcm63xx_regs.h>
+#include <bcm63xx_reset.h>
+
+DEFINE_SPINLOCK(bcm63xx_clk_lock);
+
+struct bcm63xx_clk {
+	struct clk_hw hw;
+	u32 rate;
+	s8 gate_bit;
+	void (*reset)(void);
+};
+
+#define to_bcm63xx_clk(p) container_of(p, struct bcm63xx_clk, hw)
+
+static void bcm63xx_clk_set(u32 bit, int enable)
+{
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&bcm63xx_clk_lock, flags);
+
+	val = bcm_perf_readl(PERF_CKCTL_REG);
+	if (enable)
+		val |= BIT(bit);
+	else
+		val &= ~BIT(bit);
+
+	bcm_perf_writel(val, PERF_CKCTL_REG);
+
+	spin_unlock_irqrestore(&bcm63xx_clk_lock, flags);
+
+}
+
+static int bcm63xx_clk_enable(struct clk_hw *hw)
+{
+	struct bcm63xx_clk *clk = to_bcm63xx_clk(hw);
+
+	if (clk->gate_bit >= 0)
+		bcm63xx_clk_set(clk->gate_bit, 1);
+
+	if (clk->reset)
+		clk->reset();
+
+	return 0;
+}
+
+static void bcm63xx_clk_disable(struct clk_hw *hw)
+{
+	struct bcm63xx_clk *clk = to_bcm63xx_clk(hw);
+
+	if (clk->gate_bit >= 0)
+		bcm63xx_clk_set(clk->gate_bit, 0);
+}
+
+static int bcm63xx_clk_is_enabled(struct clk_hw *hw)
+{
+	struct bcm63xx_clk *clk = to_bcm63xx_clk(hw);
+
+	if (clk->gate_bit >= 0)
+		return bcm_perf_readl(PERF_CKCTL_REG) & BIT(clk->gate_bit);
+
+	return 1;
+}
+
+static unsigned long bcm63xx_clk_recalc_rate(struct clk_hw *hw,
+					     unsigned long parent_state)
+{
+	return to_bcm63xx_clk(hw)->rate;
+}
+
+static const struct clk_ops bcm63xx_clk_ops = {
+	.enable		= bcm63xx_clk_enable,
+	.disable	= bcm63xx_clk_disable,
+	.is_enabled	= bcm63xx_clk_is_enabled,
+	.recalc_rate	= bcm63xx_clk_recalc_rate,
+};
+
+static void bcm63xx_enetsw_reset(void)
+{
+	bcm63xx_core_set_reset(BCM63XX_RESET_ENETSW, 1);
+	mdelay(100);
+	bcm63xx_core_set_reset(BCM63XX_RESET_ENETSW, 0);
+	mdelay(100);
+}
+
+static void bcm6368_enetsw_reset(void)
+{
+	struct clk *enetsw_sar = clk_get(NULL, "enetsw-sar");
+	struct clk *enetsw_usb = clk_get(NULL, "enetsw-usb");
+
+	/* secondary clocks need to be enabled while resetting the core */
+	clk_prepare_enable(enetsw_sar);
+	clk_prepare_enable(enetsw_usb);
+
+	bcm63xx_enetsw_reset();
+
+	clk_disable_unprepare(enetsw_usb);
+	clk_disable_unprepare(enetsw_sar);
+
+	clk_put(enetsw_sar);
+	clk_put(enetsw_usb);
+}
+
+static void bcm63xx_sar_reset(void)
+{
+	bcm63xx_core_set_reset(BCM63XX_RESET_SAR, 1);
+	mdelay(1);
+	bcm63xx_core_set_reset(BCM63XX_RESET_SAR, 0);
+	mdelay(1);
+}
+
+static void __init bcm63xx_clock_init(struct device_node *node,
+				      void (*reset)(void))
+{
+	u32 gate_bit_dt, rate = 0;
+	s8 gate_bit = -1;
+	struct clk *clk;
+	struct bcm63xx_clk *bcm63xx_clk;
+	const char *clk_name = node->name;
+	const char *parent = NULL;
+	int num_names, i;
+	struct clk_init_data init;
+
+	if (!of_property_read_u32(node, "brcm,gate-bit", &gate_bit_dt) &&
+	    !WARN_ON(gate_bit_dt > 32))
+		gate_bit = gate_bit_dt;
+
+	of_property_read_u32(node, "clock-frequency", &rate);
+
+	num_names = of_property_count_strings(node, "clock-output-names");
+
+	if (!WARN_ON(num_names == 0))
+		of_property_read_string_index(node, "clock-output-names", 0,
+					      &clk_name);
+
+	parent = of_clk_get_parent_name(node, 0);
+
+	bcm63xx_clk = kzalloc(sizeof(*bcm63xx_clk), GFP_KERNEL);
+	if (!bcm63xx_clk)
+		return;
+
+	bcm63xx_clk->rate = rate;
+	bcm63xx_clk->gate_bit = gate_bit;
+	bcm63xx_clk->reset = reset;
+
+	init.name = clk_name;
+	init.ops = &bcm63xx_clk_ops;
+
+	if (parent) {
+		init.flags = 0;
+		init.num_parents = 1;
+		init.parent_names = &parent;
+	} else {
+		init.flags = CLK_IS_ROOT;
+		init.num_parents = 0;
+		init.parent_names = NULL;
+	}
+
+	bcm63xx_clk->hw.init = &init;
+
+	clk = clk_register(NULL, &bcm63xx_clk->hw);
+	if (IS_ERR(clk)) {
+		kfree(bcm63xx_clk);
+		return;
+	}
+
+	of_clk_add_provider(node, of_clk_src_simple_get, clk);
+	clk_register_clkdev(clk, clk_name, NULL);
+
+	/* register aliases */
+	for (i = 1; i < num_names; i++) {
+		of_property_read_string_index(node, "clock-output-names", i,
+					      &clk_name);
+		clk_register_clkdev(clk, clk_name, NULL);
+	}
+}
+
+static void __init bcm63xx_generic_clock_init(struct device_node *node)
+{
+	bcm63xx_clock_init(node, NULL);
+}
+
+static void __init bcm63xx_enetsw_clock_init(struct device_node *node)
+{
+	bcm63xx_clock_init(node, bcm63xx_enetsw_reset);
+}
+
+static void __init bcm6368_enetsw_clock_init(struct device_node *node)
+{
+	bcm63xx_clock_init(node, bcm6368_enetsw_reset);
+}
+
+static void __init bcm63xx_sar_clock_init(struct device_node *node)
+{
+	bcm63xx_clock_init(node, bcm63xx_sar_reset);
+}
+
+static const __initconst struct of_device_id clk_match[] = {
+	{
+		.compatible = "brcm,bcm63xx-clock",
+		.data = bcm63xx_generic_clock_init,
+	},
+	{
+		.compatible = "brcm,bcm63xx-enetsw-clock",
+		.data = bcm63xx_enetsw_clock_init,
+	},
+	{
+		.compatible = "brcm,bcm6368-enetsw-clock",
+		.data = bcm63xx_enetsw_clock_init,
+	},
+	{
+		.compatible = "brcm,bcm63xx-sar-clock",
+		.data = bcm63xx_sar_clock_init,
+	},
+};
+
+int __init bcm63xx_clocks_init(void)
+{
+	of_clk_init(clk_match);
+
+	return 0;
+}
+arch_initcall(bcm63xx_clocks_init);
-- 
1.7.2.5


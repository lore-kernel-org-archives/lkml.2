Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab2A0O3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:29:13 -0500
Received: from mail.work-microwave.de ([62.245.205.51]:59777 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751973Ab2A0O3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:29:11 -0500
X-Greylist: delayed 651 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jan 2012 09:29:11 EST
From: Roland Stigge <stigge@antcom.de>
To: w.sang@pengutronix.de, grant.likely@secretlab.ca, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] Fix LPC32XX's clock.c
Date: Fri, 27 Jan 2012 15:17:48 +0100
Message-Id: <1327673868-19741-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.8.3
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Forward-ported LPC32XX's clock.c from git.lpclinux.com
* Added MLC NAND and ADC clock

Signed-off-by: Roland Stigge <stigge@antcom.de>

diff --git a/arch/arm/mach-lpc32xx/clock.c b/arch/arm/mach-lpc32xx/clock.c
index 1e02751..fabd587 100644
--- a/arch/arm/mach-lpc32xx/clock.c
+++ b/arch/arm/mach-lpc32xx/clock.c
@@ -82,10 +82,13 @@
  *   will also impact the individual peripheral rates.
  */
 
+#include <linux/module.h>
+#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/errno.h>
 #include <linux/device.h>
+#include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/amba/bus.h>
@@ -97,9 +100,12 @@
 #include "clock.h"
 #include "common.h"
 
+static DEFINE_SPINLOCK(global_clkregs_lock);
+
+static int usb_pll_enable, usb_pll_valid;
+
 static struct clk clk_armpll;
 static struct clk clk_usbpll;
-static DEFINE_MUTEX(clkm_lock);
 
 /*
  * Post divider values for PLLs based on selected register value
@@ -127,7 +133,7 @@ static struct clk osc_32KHz = {
 static int local_pll397_enable(struct clk *clk, int enable)
 {
 	u32 reg;
-	unsigned long timeout = 1 + msecs_to_jiffies(10);
+	unsigned long timeout = jiffies + msecs_to_jiffies(10);
 
 	reg = __raw_readl(LPC32XX_CLKPWR_PLL397_CTRL);
 
@@ -156,7 +162,7 @@ static int local_pll397_enable(struct clk *clk, int enable)
 static int local_oscmain_enable(struct clk *clk, int enable)
 {
 	u32 reg;
-	unsigned long timeout = 1 + msecs_to_jiffies(10);
+	unsigned long timeout = jiffies + msecs_to_jiffies(10);
 
 	reg = __raw_readl(LPC32XX_CLKPWR_MAIN_OSC_CTRL);
 
@@ -382,30 +388,62 @@ static u32 local_clk_usbpll_setup(struct clk_pll_setup *pHCLKPllSetup)
 static int local_usbpll_enable(struct clk *clk, int enable)
 {
 	u32 reg;
-	int ret = -ENODEV;
-	unsigned long timeout = 1 + msecs_to_jiffies(10);
+	int ret = 0;
+	unsigned long timeout = jiffies + msecs_to_jiffies(20);
 
 	reg = __raw_readl(LPC32XX_CLKPWR_USB_CTRL);
 
-	if (enable == 0) {
-		reg &= ~(LPC32XX_CLKPWR_USBCTRL_CLK_EN1 |
-			LPC32XX_CLKPWR_USBCTRL_CLK_EN2);
-		__raw_writel(reg, LPC32XX_CLKPWR_USB_CTRL);
-	} else if (reg & LPC32XX_CLKPWR_USBCTRL_PLL_PWRUP) {
+	__raw_writel(reg & ~(LPC32XX_CLKPWR_USBCTRL_CLK_EN2 |
+		LPC32XX_CLKPWR_USBCTRL_PLL_PWRUP),
+		LPC32XX_CLKPWR_USB_CTRL);
+	__raw_writel(reg & ~LPC32XX_CLKPWR_USBCTRL_CLK_EN1,
+		LPC32XX_CLKPWR_USB_CTRL);
+
+	if (enable && usb_pll_valid && usb_pll_enable) {
+		ret = -ENODEV;
+		/*
+		 * If the PLL rate has been previously set, then the rate
+		 * in the PLL register is valid and can be enabled here.
+		 * Otherwise, it needs to be enabled as part of setrate.
+		 */
+
+		/*
+		 * Gate clock into PLL
+		 */
 		reg |= LPC32XX_CLKPWR_USBCTRL_CLK_EN1;
 		__raw_writel(reg, LPC32XX_CLKPWR_USB_CTRL);
 
-		/* Wait for PLL lock */
-		while ((timeout > jiffies) & (ret == -ENODEV)) {
+		/*
+		 * Enable PLL
+		 */
+		reg |= LPC32XX_CLKPWR_USBCTRL_PLL_PWRUP;
+		__raw_writel(reg, LPC32XX_CLKPWR_USB_CTRL);
+
+		/*
+		 * Wait for PLL to lock
+		 */
+		while ((timeout > jiffies) && (ret == -ENODEV)) {
 			reg = __raw_readl(LPC32XX_CLKPWR_USB_CTRL);
 			if (reg & LPC32XX_CLKPWR_USBCTRL_PLL_STS)
 				ret = 0;
+			else
+				udelay(10);
 		}
 
+		/*
+		 * Gate clock from PLL if PLL is locked
+		 */
 		if (ret == 0) {
-			reg |= LPC32XX_CLKPWR_USBCTRL_CLK_EN2;
-			__raw_writel(reg, LPC32XX_CLKPWR_USB_CTRL);
+			__raw_writel(reg | LPC32XX_CLKPWR_USBCTRL_CLK_EN2,
+				LPC32XX_CLKPWR_USB_CTRL);
+		} else {
+			__raw_writel(reg & ~(LPC32XX_CLKPWR_USBCTRL_CLK_EN1 |
+				LPC32XX_CLKPWR_USBCTRL_PLL_PWRUP),
+				LPC32XX_CLKPWR_USB_CTRL);
 		}
+	} else if ((enable == 0) && usb_pll_valid  && usb_pll_enable) {
+		usb_pll_valid = 0;
+		usb_pll_enable = 0;
 	}
 
 	return ret;
@@ -423,7 +461,7 @@ static unsigned long local_usbpll_round_rate(struct clk *clk,
 	 */
 	rate = rate * 1000;
 
-	clkin = clk->parent->rate;
+	clkin = clk->get_rate(clk);
 	usbdiv = (__raw_readl(LPC32XX_CLKPWR_USBCLK_PDIV) &
 		LPC32XX_CLKPWR_USBPDIV_PLL_MASK) + 1;
 	clkin = clkin / usbdiv;
@@ -437,7 +475,8 @@ static unsigned long local_usbpll_round_rate(struct clk *clk,
 
 static int local_usbpll_set_rate(struct clk *clk, unsigned long rate)
 {
-	u32 clkin, reg, usbdiv;
+	int ret = -ENODEV;
+	u32 clkin, usbdiv;
 	struct clk_pll_setup pllsetup;
 
 	/*
@@ -446,7 +485,7 @@ static int local_usbpll_set_rate(struct clk *clk, unsigned long rate)
 	 */
 	rate = rate * 1000;
 
-	clkin = clk->get_rate(clk);
+	clkin = clk->get_rate(clk->parent);
 	usbdiv = (__raw_readl(LPC32XX_CLKPWR_USBCLK_PDIV) &
 		LPC32XX_CLKPWR_USBPDIV_PLL_MASK) + 1;
 	clkin = clkin / usbdiv;
@@ -455,22 +494,25 @@ static int local_usbpll_set_rate(struct clk *clk, unsigned long rate)
 	if (local_clk_find_pll_cfg(clkin, rate, &pllsetup) == 0)
 		return -EINVAL;
 
+	/*
+	 * Disable PLL clocks during PLL change
+	 */
 	local_usbpll_enable(clk, 0);
-
-	reg = __raw_readl(LPC32XX_CLKPWR_USB_CTRL);
-	reg |= LPC32XX_CLKPWR_USBCTRL_CLK_EN1;
-	__raw_writel(reg, LPC32XX_CLKPWR_USB_CTRL);
-
-	pllsetup.analog_on = 1;
+	pllsetup.analog_on = 0;
 	local_clk_usbpll_setup(&pllsetup);
 
-	clk->rate = clk_check_pll_setup(clkin, &pllsetup);
+	/*
+	 * Start USB PLL and check PLL status
+	 */
+
+	usb_pll_valid = 1;
+	usb_pll_enable = 1;
 
-	reg = __raw_readl(LPC32XX_CLKPWR_USB_CTRL);
-	reg |= LPC32XX_CLKPWR_USBCTRL_CLK_EN2;
-	__raw_writel(reg, LPC32XX_CLKPWR_USB_CTRL);
+	ret = local_usbpll_enable(clk, 1);
+	if (ret >= 0)
+		clk->rate = clk_check_pll_setup(clkin, &pllsetup);
 
-	return 0;
+	return ret;
 }
 
 static struct clk clk_usbpll = {
@@ -654,6 +696,14 @@ static struct clk clk_nand = {
 	.get_rate	= local_return_parent_rate,
 };
 
+static struct clk clk_nand_mlc = {
+	.parent		= &clk_hclk,
+	.enable		= local_onoff_enable,
+	.enable_reg	= LPC32XX_CLKPWR_NAND_CLK_CTRL,
+	.enable_mask	= LPC32XX_CLKPWR_NANDCLK_MLCCLK_EN,
+	.get_rate	= local_return_parent_rate,
+};
+
 static struct clk clk_i2s0 = {
 	.parent		= &clk_hclk,
 	.enable		= local_onoff_enable,
@@ -719,6 +769,36 @@ static struct clk clk_tsc = {
 	.get_rate	= local_return_parent_rate,
 };
 
+static int adc_onoff_enable(struct clk *clk, int enable)
+{
+	u32 tmp;
+
+	/* Use PERIPH_CLOCK */
+	tmp = __raw_readl(LPC32XX_CLKPWR_ADC_CLK_CTRL_1);
+	tmp |= LPC32XX_CLKPWR_ADCCTRL1_PCLK_SEL;
+	/*
+	 * Set clock divider so that we have equal to or less than
+	 * 4.5MHz clock at ADC
+	 */
+	tmp |= clk->get_rate(clk) / 4500000 + 1;
+	__raw_writel(tmp, LPC32XX_CLKPWR_ADC_CLK_CTRL_1);
+
+	if (enable == 0)
+		__raw_writel(0, clk->enable_reg);
+	else
+		__raw_writel(clk->enable_mask, clk->enable_reg);
+
+	return 0;
+}
+
+static struct clk clk_adc = {
+	.parent		= &clk_pclk,
+	.enable		= adc_onoff_enable,
+	.enable_reg	= LPC32XX_CLKPWR_ADC_CLK_CTRL,
+	.enable_mask	= LPC32XX_CLKPWR_ADC32CLKCTRL_CLK_EN,
+	.get_rate	= local_return_parent_rate,
+};
+
 static int mmc_onoff_enable(struct clk *clk, int enable)
 {
 	u32 tmp;
@@ -730,6 +810,10 @@ static int mmc_onoff_enable(struct clk *clk, int enable)
 	if (enable != 0)
 		tmp |= LPC32XX_CLKPWR_MSCARD_SDCARD_EN;
 
+	/* Start clock at highest rate */
+	if (!(tmp & LPC32XX_CLKPWR_MSCARD_SDCARD_DIV(0xF)))
+		tmp |= LPC32XX_CLKPWR_MSCARD_SDCARD_DIV(1);
+
 	__raw_writel(tmp, LPC32XX_CLKPWR_MS_CTRL);
 
 	return 0;
@@ -737,14 +821,9 @@ static int mmc_onoff_enable(struct clk *clk, int enable)
 
 static unsigned long mmc_get_rate(struct clk *clk)
 {
-	u32 div, rate, oldclk;
+	u32 div, rate;
 
-	/* The MMC clock must be on when accessing an MMC register */
-	oldclk = __raw_readl(LPC32XX_CLKPWR_MS_CTRL);
-	__raw_writel(oldclk | LPC32XX_CLKPWR_MSCARD_SDCARD_EN,
-		LPC32XX_CLKPWR_MS_CTRL);
 	div = __raw_readl(LPC32XX_CLKPWR_MS_CTRL);
-	__raw_writel(oldclk, LPC32XX_CLKPWR_MS_CTRL);
 
 	/* Get the parent clock rate */
 	rate = clk->parent->get_rate(clk->parent);
@@ -772,12 +851,19 @@ static unsigned long mmc_round_rate(struct clk *clk, unsigned long rate)
 	if (div > 0xf)
 		div = 0xf;
 
+	/*
+	 * The divider is forced to 1 to keep the SD clock granularity
+	 * good. Using a non-0 divider will limit the SD card clock rates
+	 * the SD driver can generate. Remove it if your feeling crazy.
+	 */
+	div = 1;
+
 	return prate / div;
 }
 
 static int mmc_set_rate(struct clk *clk, unsigned long rate)
 {
-	u32 oldclk, tmp;
+	u32 tmp;
 	unsigned long prate, div, crate = mmc_round_rate(clk, rate);
 
 	prate = clk->parent->get_rate(clk->parent);
@@ -785,19 +871,17 @@ static int mmc_set_rate(struct clk *clk, unsigned long rate)
 	div = prate / crate;
 
 	/* The MMC clock must be on when accessing an MMC register */
-	oldclk = __raw_readl(LPC32XX_CLKPWR_MS_CTRL);
-	__raw_writel(oldclk | LPC32XX_CLKPWR_MSCARD_SDCARD_EN,
-		LPC32XX_CLKPWR_MS_CTRL);
 	tmp = __raw_readl(LPC32XX_CLKPWR_MS_CTRL) &
 		~LPC32XX_CLKPWR_MSCARD_SDCARD_DIV(0xf);
 	tmp |= LPC32XX_CLKPWR_MSCARD_SDCARD_DIV(div);
 	__raw_writel(tmp, LPC32XX_CLKPWR_MS_CTRL);
 
-	__raw_writel(oldclk, LPC32XX_CLKPWR_MS_CTRL);
-
 	return 0;
 }
 
+/*
+ * This is the MMC IP clock, not the MMC CLK signal rate!
+ */
 static struct clk clk_mmc = {
 	.parent		= &clk_armpll,
 	.set_rate	= mmc_set_rate,
@@ -891,19 +975,9 @@ static struct clk clk_lcd = {
 	.enable_mask	= LPC32XX_CLKPWR_LCDCTRL_CLK_EN,
 };
 
-static inline void clk_lock(void)
-{
-	mutex_lock(&clkm_lock);
-}
-
-static inline void clk_unlock(void)
-{
-	mutex_unlock(&clkm_lock);
-}
-
 static void local_clk_disable(struct clk *clk)
 {
-	WARN_ON(clk->usecount == 0);
+	/* WARN_ON(clk->usecount == 0); */
 
 	/* Don't attempt to disable clock if it has no users */
 	if (clk->usecount > 0) {
@@ -947,10 +1021,11 @@ static int local_clk_enable(struct clk *clk)
 int clk_enable(struct clk *clk)
 {
 	int ret;
+	unsigned long flags;
 
-	clk_lock();
+	spin_lock_irqsave(&global_clkregs_lock, flags);
 	ret = local_clk_enable(clk);
-	clk_unlock();
+	spin_unlock_irqrestore(&global_clkregs_lock, flags);
 
 	return ret;
 }
@@ -961,9 +1036,11 @@ EXPORT_SYMBOL(clk_enable);
  */
 void clk_disable(struct clk *clk)
 {
-	clk_lock();
+	unsigned long flags;
+
+	spin_lock_irqsave(&global_clkregs_lock, flags);
 	local_clk_disable(clk);
-	clk_unlock();
+	spin_unlock_irqrestore(&global_clkregs_lock, flags);
 }
 EXPORT_SYMBOL(clk_disable);
 
@@ -972,13 +1049,7 @@ EXPORT_SYMBOL(clk_disable);
  */
 unsigned long clk_get_rate(struct clk *clk)
 {
-	unsigned long rate;
-
-	clk_lock();
-	rate = clk->get_rate(clk);
-	clk_unlock();
-
-	return rate;
+	return clk->get_rate(clk);
 }
 EXPORT_SYMBOL(clk_get_rate);
 
@@ -994,11 +1065,8 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	 * the actual rate set as part of the peripheral dividers
 	 * instead of high level clock control
 	 */
-	if (clk->set_rate) {
-		clk_lock();
+	if (clk->set_rate)
 		ret = clk->set_rate(clk, rate);
-		clk_unlock();
-	}
 
 	return ret;
 }
@@ -1009,15 +1077,11 @@ EXPORT_SYMBOL(clk_set_rate);
  */
 long clk_round_rate(struct clk *clk, unsigned long rate)
 {
-	clk_lock();
-
 	if (clk->round_rate)
 		rate = clk->round_rate(clk, rate);
 	else
 		rate = clk->get_rate(clk);
 
-	clk_unlock();
-
 	return rate;
 }
 EXPORT_SYMBOL(clk_round_rate);
@@ -1075,6 +1139,8 @@ static struct clk_lookup lookups[] = {
 	_REGISTER_CLOCK("dev:ssp1", NULL, clk_ssp1)
 	_REGISTER_CLOCK("lpc32xx_keys.0", NULL, clk_kscan)
 	_REGISTER_CLOCK("lpc32xx-nand.0", "nand_ck", clk_nand)
+	_REGISTER_CLOCK("lpc32xx-nand-mlc.0", "nand_ck_mlc", clk_nand_mlc)
+	_REGISTER_CLOCK("lpc32xx-adc", NULL, clk_adc)
 	_REGISTER_CLOCK("tbd", "i2s0_ck", clk_i2s0)
 	_REGISTER_CLOCK("tbd", "i2s1_ck", clk_i2s1)
 	_REGISTER_CLOCK("ts-lpc32xx", NULL, clk_tsc)

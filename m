Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab2A3QD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:03:29 -0500
Received: from mail.work-microwave.de ([62.245.205.51]:49535 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753653Ab2A3QDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:03:17 -0500
From: Roland Stigge <stigge@antcom.de>
To: w.sang@pengutronix.de, bangaragiri.g@nxp.com, srinivas.bakki@nxp.com,
        sundarapandian.andithevar@nxp.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 6/7] LPC32xx: clock.c: USB PLL fix
Date: Mon, 30 Jan 2012 17:02:05 +0100
Message-Id: <1327939327-7799-6-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1327939327-7799-1-git-send-email-stigge@antcom.de>
References: <1327939327-7799-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes and updates the USB PLL handling. With the old driver version,
the USB clock was sometimes not started correctly. The update reflects the
driver changes in this regard from Kevin Wells.

See also git.lpclinux.com

Signed-off-by: Roland Stigge <stigge@antcom.de>

diff --git a/arch/arm/mach-lpc32xx/clock.c b/arch/arm/mach-lpc32xx/clock.c
index f64c9a1..6dd2c30 100644
--- a/arch/arm/mach-lpc32xx/clock.c
+++ b/arch/arm/mach-lpc32xx/clock.c
@@ -87,6 +87,7 @@
 #include <linux/list.h>
 #include <linux/errno.h>
 #include <linux/device.h>
+#include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/amba/bus.h>
@@ -98,6 +99,8 @@
 #include "clock.h"
 #include "common.h"
 
+static int usb_pll_enable, usb_pll_valid;
+
 static struct clk clk_armpll;
 static struct clk clk_usbpll;
 static DEFINE_MUTEX(clkm_lock);
@@ -383,30 +386,62 @@ static u32 local_clk_usbpll_setup(struct clk_pll_setup *pHCLKPllSetup)
 static int local_usbpll_enable(struct clk *clk, int enable)
 {
 	u32 reg;
-	int ret = -ENODEV;
-	unsigned long timeout = jiffies + msecs_to_jiffies(10);
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
+		/*
+		 * Enable PLL
+		 */
+		reg |= LPC32XX_CLKPWR_USBCTRL_PLL_PWRUP;
+		__raw_writel(reg, LPC32XX_CLKPWR_USB_CTRL);
+
+		/*
+		 * Wait for PLL to lock
+		 */
 		while (time_before(jiffies, timeout) && (ret == -ENODEV)) {
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
@@ -424,7 +459,7 @@ static unsigned long local_usbpll_round_rate(struct clk *clk,
 	 */
 	rate = rate * 1000;
 
-	clkin = clk->parent->rate;
+	clkin = clk->get_rate(clk);
 	usbdiv = (__raw_readl(LPC32XX_CLKPWR_USBCLK_PDIV) &
 		LPC32XX_CLKPWR_USBPDIV_PLL_MASK) + 1;
 	clkin = clkin / usbdiv;
@@ -438,7 +473,8 @@ static unsigned long local_usbpll_round_rate(struct clk *clk,
 
 static int local_usbpll_set_rate(struct clk *clk, unsigned long rate)
 {
-	u32 clkin, reg, usbdiv;
+	int ret = -ENODEV;
+	u32 clkin, usbdiv;
 	struct clk_pll_setup pllsetup;
 
 	/*
@@ -447,7 +483,7 @@ static int local_usbpll_set_rate(struct clk *clk, unsigned long rate)
 	 */
 	rate = rate * 1000;
 
-	clkin = clk->get_rate(clk);
+	clkin = clk->get_rate(clk->parent);
 	usbdiv = (__raw_readl(LPC32XX_CLKPWR_USBCLK_PDIV) &
 		LPC32XX_CLKPWR_USBPDIV_PLL_MASK) + 1;
 	clkin = clkin / usbdiv;
@@ -456,22 +492,25 @@ static int local_usbpll_set_rate(struct clk *clk, unsigned long rate)
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
 
-	reg = __raw_readl(LPC32XX_CLKPWR_USB_CTRL);
-	reg |= LPC32XX_CLKPWR_USBCTRL_CLK_EN2;
-	__raw_writel(reg, LPC32XX_CLKPWR_USB_CTRL);
+	usb_pll_valid = 1;
+	usb_pll_enable = 1;
 
-	return 0;
+	ret = local_usbpll_enable(clk, 1);
+	if (ret >= 0)
+		clk->rate = clk_check_pll_setup(clkin, &pllsetup);
+
+	return ret;
 }
 
 static struct clk clk_usbpll = {
@@ -731,6 +770,10 @@ static int mmc_onoff_enable(struct clk *clk, int enable)
 	if (enable != 0)
 		tmp |= LPC32XX_CLKPWR_MSCARD_SDCARD_EN;
 
+	/* Start clock at highest rate */
+	if (!(tmp & LPC32XX_CLKPWR_MSCARD_SDCARD_DIV(0xF)))
+		tmp |= LPC32XX_CLKPWR_MSCARD_SDCARD_DIV(1);
+
 	__raw_writel(tmp, LPC32XX_CLKPWR_MS_CTRL);
 
 	return 0;

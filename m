Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354Ab2BBTUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:20:54 -0500
Received: from mail.work-microwave.de ([62.245.205.51]:33883 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754800Ab2BBTUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:20:52 -0500
From: stigge@antcom.de
To: w.sang@pengutronix.de, bangaragiri.g@nxp.com, srinivas.bakki@nxp.com,
        sundarapandian.andithevar@nxp.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v3 4/7] ARM: LPC32xx: clock.c: jiffies wrapping
Date: Thu,  2 Feb 2012 20:19:45 +0100
Message-Id: <1328210388-21296-4-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1328210388-21296-1-git-send-email-stigge@antcom.de>
References: <1328210388-21296-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the jiffies wrapping bug in clock.c.

It corrects the timeout computation based on jiffies, uses time_before() for
correct wrapping handling and replaces a binary "&" which should really be a
logical "&&" in a truth expression.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Acked-by: Wolfram Sang <w.sang@pengutronix.de> 
Tested-by: Wolfram Sang <w.sang@pengutronix.de>

diff --git a/arch/arm/mach-lpc32xx/clock.c b/arch/arm/mach-lpc32xx/clock.c
index 8e79313..f64c9a1 100644
--- a/arch/arm/mach-lpc32xx/clock.c
+++ b/arch/arm/mach-lpc32xx/clock.c
@@ -128,7 +128,7 @@ static struct clk osc_32KHz = {
 static int local_pll397_enable(struct clk *clk, int enable)
 {
 	u32 reg;
-	unsigned long timeout = 1 + msecs_to_jiffies(10);
+	unsigned long timeout = jiffies + msecs_to_jiffies(10);
 
 	reg = __raw_readl(LPC32XX_CLKPWR_PLL397_CTRL);
 
@@ -143,7 +143,7 @@ static int local_pll397_enable(struct clk *clk, int enable)
 		/* Wait for PLL397 lock */
 		while (((__raw_readl(LPC32XX_CLKPWR_PLL397_CTRL) &
 			LPC32XX_CLKPWR_SYSCTRL_PLL397_STS) == 0) &&
-			(timeout > jiffies))
+			time_before(jiffies, timeout))
 			cpu_relax();
 
 		if ((__raw_readl(LPC32XX_CLKPWR_PLL397_CTRL) &
@@ -157,7 +157,7 @@ static int local_pll397_enable(struct clk *clk, int enable)
 static int local_oscmain_enable(struct clk *clk, int enable)
 {
 	u32 reg;
-	unsigned long timeout = 1 + msecs_to_jiffies(10);
+	unsigned long timeout = jiffies + msecs_to_jiffies(10);
 
 	reg = __raw_readl(LPC32XX_CLKPWR_MAIN_OSC_CTRL);
 
@@ -172,7 +172,7 @@ static int local_oscmain_enable(struct clk *clk, int enable)
 		/* Wait for main oscillator to start */
 		while (((__raw_readl(LPC32XX_CLKPWR_MAIN_OSC_CTRL) &
 			LPC32XX_CLKPWR_MOSC_DISABLE) != 0) &&
-			(timeout > jiffies))
+			time_before(jiffies, timeout))
 			cpu_relax();
 
 		if ((__raw_readl(LPC32XX_CLKPWR_MAIN_OSC_CTRL) &
@@ -384,7 +384,7 @@ static int local_usbpll_enable(struct clk *clk, int enable)
 {
 	u32 reg;
 	int ret = -ENODEV;
-	unsigned long timeout = 1 + msecs_to_jiffies(10);
+	unsigned long timeout = jiffies + msecs_to_jiffies(10);
 
 	reg = __raw_readl(LPC32XX_CLKPWR_USB_CTRL);
 
@@ -397,7 +397,7 @@ static int local_usbpll_enable(struct clk *clk, int enable)
 		__raw_writel(reg, LPC32XX_CLKPWR_USB_CTRL);
 
 		/* Wait for PLL lock */
-		while ((timeout > jiffies) & (ret == -ENODEV)) {
+		while (time_before(jiffies, timeout) && (ret == -ENODEV)) {
 			reg = __raw_readl(LPC32XX_CLKPWR_USB_CTRL);
 			if (reg & LPC32XX_CLKPWR_USBCTRL_PLL_STS)
 				ret = 0;

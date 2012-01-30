Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab2A3QDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:03:45 -0500
Received: from mail.work-microwave.de ([62.245.205.51]:31102 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754081Ab2A3QDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:03:16 -0500
From: Roland Stigge <stigge@antcom.de>
To: w.sang@pengutronix.de, bangaragiri.g@nxp.com, srinivas.bakki@nxp.com,
        sundarapandian.andithevar@nxp.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 4/7] LPC32xx: clock.c: MMC update
Date: Mon, 30 Jan 2012 17:02:03 +0100
Message-Id: <1327939327-7799-4-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1327939327-7799-1-git-send-email-stigge@antcom.de>
References: <1327939327-7799-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates MMC clocking in clock.c:
* No manual MMC clock enable/disable on MMC register access necessary
  (it's the MMC IP clock, not the MMC CLK signal rate)  
* Added comments

Signed-off-by: Roland Stigge <stigge@antcom.de>

diff --git a/arch/arm/mach-lpc32xx/clock.c b/arch/arm/mach-lpc32xx/clock.c
index 17709ca..229bec5 100644
--- a/arch/arm/mach-lpc32xx/clock.c
+++ b/arch/arm/mach-lpc32xx/clock.c
@@ -738,14 +738,9 @@ static int mmc_onoff_enable(struct clk *clk, int enable)
 
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
@@ -773,32 +768,36 @@ static unsigned long mmc_round_rate(struct clk *clk, unsigned long rate)
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
 
 	div = prate / crate;
 
-	/* The MMC clock must be on when accessing an MMC register */
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

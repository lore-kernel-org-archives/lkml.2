Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab2A3QDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:03:46 -0500
Received: from mail.work-microwave.de ([62.245.205.51]:31100 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754079Ab2A3QDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:03:15 -0500
From: Roland Stigge <stigge@antcom.de>
To: w.sang@pengutronix.de, bangaragiri.g@nxp.com, srinivas.bakki@nxp.com,
        sundarapandian.andithevar@nxp.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 7/7] LPC32xx: clock.c: Fix mutex lock issues
Date: Mon, 30 Jan 2012 17:02:06 +0100
Message-Id: <1327939327-7799-7-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1327939327-7799-1-git-send-email-stigge@antcom.de>
References: <1327939327-7799-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the mutex issue in clock.c, as done in Kevin Wells' original
driver update:

In some cases, the clock drivers could grab a mutex twice in an improper
context. This patch changes the mutex mechanism to a simple irq lock/unlock
mechanism and removes un-needed locks from some functions.

(See also git.lpclinux.com)

Signed-off-by: Roland Stigge <stigge@antcom.de>

diff --git a/arch/arm/mach-lpc32xx/clock.c b/arch/arm/mach-lpc32xx/clock.c
index f49638a..aceb88a 100644
--- a/arch/arm/mach-lpc32xx/clock.c
+++ b/arch/arm/mach-lpc32xx/clock.c
@@ -99,11 +99,12 @@
 #include "clock.h"
 #include "common.h"
 
+static DEFINE_SPINLOCK(global_clkregs_lock);
+
 static int usb_pll_enable, usb_pll_valid;
 
 static struct clk clk_armpll;
 static struct clk clk_usbpll;
-static DEFINE_MUTEX(clkm_lock);
 
 /*
  * Post divider values for PLLs based on selected register value
@@ -934,16 +935,6 @@ static struct clk clk_lcd = {
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
 	/* Don't attempt to disable clock if it has no users */
@@ -988,10 +979,11 @@ static int local_clk_enable(struct clk *clk)
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
@@ -1002,9 +994,11 @@ EXPORT_SYMBOL(clk_enable);
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
 
@@ -1013,13 +1007,7 @@ EXPORT_SYMBOL(clk_disable);
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
 
@@ -1035,11 +1023,8 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
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
@@ -1050,15 +1035,11 @@ EXPORT_SYMBOL(clk_set_rate);
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

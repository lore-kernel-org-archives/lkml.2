Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab1GMUZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 16:25:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55533 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1GMUZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 16:25:03 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-watchdog@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wim@iguana.be, tim.bird@am.sony.com,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [RFC 4/6] watchdog: pnx4008: don't use __raw_-accessors
Date: Wed, 13 Jul 2011 22:26:04 +0200
Message-Id: <1310588766-16638-5-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1310588766-16638-1-git-send-email-w.sang@pengutronix.de>
References: <1310588766-16638-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__raw_readl/__raw_writel are not meant for drivers [1].

[1] http://thread.gmane.org/gmane.linux.ports.arm.kernel/117626

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/watchdog/pnx4008_wdt.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index 8e34691..4cc9c27 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -97,22 +97,21 @@ static void wdt_enable(void)
 	spin_lock(&io_lock);
 
 	/* stop counter, initiate counter reset */
-	__raw_writel(RESET_COUNT, WDTIM_CTRL(wdt_base));
+	writel(RESET_COUNT, WDTIM_CTRL(wdt_base));
 	/*wait for reset to complete. 100% guarantee event */
-	while (__raw_readl(WDTIM_COUNTER(wdt_base)))
+	while (readl(WDTIM_COUNTER(wdt_base)))
 		cpu_relax();
 	/* internal and external reset, stop after that */
-	__raw_writel(M_RES2 | STOP_COUNT0 | RESET_COUNT0,
-		WDTIM_MCTRL(wdt_base));
+	writel(M_RES2 | STOP_COUNT0 | RESET_COUNT0, WDTIM_MCTRL(wdt_base));
 	/* configure match output */
-	__raw_writel(MATCH_OUTPUT_HIGH, WDTIM_EMR(wdt_base));
+	writel(MATCH_OUTPUT_HIGH, WDTIM_EMR(wdt_base));
 	/* clear interrupt, just in case */
-	__raw_writel(MATCH_INT, WDTIM_INT(wdt_base));
+	writel(MATCH_INT, WDTIM_INT(wdt_base));
 	/* the longest pulse period 65541/(13*10^6) seconds ~ 5 ms. */
-	__raw_writel(0xFFFF, WDTIM_PULSE(wdt_base));
-	__raw_writel(heartbeat * WDOG_COUNTER_RATE, WDTIM_MATCH0(wdt_base));
+	writel(0xFFFF, WDTIM_PULSE(wdt_base));
+	writel(heartbeat * WDOG_COUNTER_RATE, WDTIM_MATCH0(wdt_base));
 	/*enable counter, stop when debugger active */
-	__raw_writel(COUNT_ENAB | DEBUG_EN, WDTIM_CTRL(wdt_base));
+	writel(COUNT_ENAB | DEBUG_EN, WDTIM_CTRL(wdt_base));
 
 	spin_unlock(&io_lock);
 }
@@ -121,7 +120,7 @@ static void wdt_disable(void)
 {
 	spin_lock(&io_lock);
 
-	__raw_writel(0, WDTIM_CTRL(wdt_base));	/*stop counter */
+	writel(0, WDTIM_CTRL(wdt_base));	/*stop counter */
 
 	spin_unlock(&io_lock);
 }
@@ -293,8 +292,8 @@ static int __devinit pnx4008_wdt_probe(struct platform_device *pdev)
 		goto disable_clk;
 	}
 
-	pnx4008_wdd.bootstatus = (__raw_readl(WDTIM_RES(wdt_base)) &
-		WDOG_RESET) ? WDIOF_CARDRESET : 0;
+	pnx4008_wdd.bootstatus = (readl(WDTIM_RES(wdt_base)) & WDOG_RESET) ?
+				WDIOF_CARDRESET : 0;
 	wdt_disable();		/*disable for now */
 	clk_disable(wdt_clk);
 
-- 
1.7.2.5


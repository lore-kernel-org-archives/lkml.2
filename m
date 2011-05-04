Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab1EDPc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:32:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42847 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab1EDPcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:32:24 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 1/3] rtc: mc13xxx: remove UIE signaling
Date: Wed,  4 May 2011 17:31:26 +0200
Message-Id: <1304523088-17039-2-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1304523088-17039-1-git-send-email-w.sang@pengutronix.de>
References: <1304523088-17039-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RTC core handles it since 6610e08 (RTC: Rework RTC code to use
timerqueue for events). So far, only the callbacks to the RTC core have
been removed, but not the handlers. Do this now.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/rtc/rtc-mc13xxx.c |   23 -----------------------
 1 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
index c5ac037..d4e2078 100644
--- a/drivers/rtc/rtc-mc13xxx.c
+++ b/drivers/rtc/rtc-mc13xxx.c
@@ -268,20 +268,6 @@ static irqreturn_t mc13xxx_rtc_alarm_handler(int irq, void *dev)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t mc13xxx_rtc_update_handler(int irq, void *dev)
-{
-	struct mc13xxx_rtc *priv = dev;
-	struct mc13xxx *mc13xxx = priv->mc13xxx;
-
-	dev_dbg(&priv->rtc->dev, "1HZ\n");
-
-	rtc_update_irq(priv->rtc, 1, RTC_IRQF | RTC_UF);
-
-	mc13xxx_irq_ack(mc13xxx, irq);
-
-	return IRQ_HANDLED;
-}
-
 static int mc13xxx_rtc_alarm_irq_enable(struct device *dev,
 		unsigned int enabled)
 {
@@ -339,11 +325,6 @@ static int __devinit mc13xxx_rtc_probe(struct platform_device *pdev)
 
 	priv->valid = !rtcrst_pending;
 
-	ret = mc13xxx_irq_request_nounmask(mc13xxx, MC13XXX_IRQ_1HZ,
-			mc13xxx_rtc_update_handler, DRIVER_NAME, priv);
-	if (ret)
-		goto err_update_irq_request;
-
 	ret = mc13xxx_irq_request_nounmask(mc13xxx, MC13XXX_IRQ_TODA,
 			mc13xxx_rtc_alarm_handler, DRIVER_NAME, priv);
 	if (ret)
@@ -357,9 +338,6 @@ static int __devinit mc13xxx_rtc_probe(struct platform_device *pdev)
 		mc13xxx_irq_free(mc13xxx, MC13XXX_IRQ_TODA, priv);
 err_alarm_irq_request:
 
-		mc13xxx_irq_free(mc13xxx, MC13XXX_IRQ_1HZ, priv);
-err_update_irq_request:
-
 err_reset_irq_status:
 
 		mc13xxx_irq_free(mc13xxx, MC13XXX_IRQ_RTCRST, priv);
@@ -383,7 +361,6 @@ static int __devexit mc13xxx_rtc_remove(struct platform_device *pdev)
 	rtc_device_unregister(priv->rtc);
 
 	mc13xxx_irq_free(priv->mc13xxx, MC13XXX_IRQ_TODA, priv);
-	mc13xxx_irq_free(priv->mc13xxx, MC13XXX_IRQ_1HZ, priv);
 	mc13xxx_irq_free(priv->mc13xxx, MC13XXX_IRQ_RTCRST, priv);
 
 	mc13xxx_unlock(priv->mc13xxx);
-- 
1.7.2.5


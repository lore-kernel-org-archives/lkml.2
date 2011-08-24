Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab1HXNav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:30:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53689 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab1HXNat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:30:49 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        linux-input@vger.kernel.org
Date: Wed, 24 Aug 2011 15:28:22 +0200
Message-Id: <1314192505-23499-3-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1314192505-23499-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20110824132740.GA28197@pengutronix.de>
 <1314192505-23499-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH 3/6] input/mc13783-ts: convert to mc13xxx API
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first step to also support the touch interface of the mc13892
pmic chip.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/input/touchscreen/mc13783_ts.c |   34 ++++++++++++++++----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/input/touchscreen/mc13783_ts.c b/drivers/input/touchscreen/mc13783_ts.c
index c5bc62d..ede0274 100644
--- a/drivers/input/touchscreen/mc13783_ts.c
+++ b/drivers/input/touchscreen/mc13783_ts.c
@@ -35,7 +35,7 @@ MODULE_PARM_DESC(sample_tolerance,
 
 struct mc13783_ts_priv {
 	struct input_dev *idev;
-	struct mc13783 *mc13783;
+	struct mc13xxx *mc13xxx;
 	struct delayed_work work;
 	struct workqueue_struct *workq;
 	unsigned int sample[4];
@@ -45,7 +45,7 @@ static irqreturn_t mc13783_ts_handler(int irq, void *data)
 {
 	struct mc13783_ts_priv *priv = data;
 
-	mc13783_irq_ack(priv->mc13783, irq);
+	mc13xxx_irq_ack(priv->mc13xxx, irq);
 
 	/*
 	 * Kick off reading coordinates. Note that if work happens already
@@ -121,10 +121,10 @@ static void mc13783_ts_work(struct work_struct *work)
 {
 	struct mc13783_ts_priv *priv =
 		container_of(work, struct mc13783_ts_priv, work.work);
-	unsigned int mode = MC13783_ADC_MODE_TS;
+	unsigned int mode = MC13XXX_ADC_MODE_TS;
 	unsigned int channel = 12;
 
-	if (mc13783_adc_do_conversion(priv->mc13783,
+	if (mc13xxx_adc_do_conversion(priv->mc13xxx,
 				mode, channel, priv->sample) == 0)
 		mc13783_ts_report_sample(priv);
 }
@@ -134,21 +134,21 @@ static int mc13783_ts_open(struct input_dev *dev)
 	struct mc13783_ts_priv *priv = input_get_drvdata(dev);
 	int ret;
 
-	mc13783_lock(priv->mc13783);
+	mc13xxx_lock(priv->mc13xxx);
 
-	mc13783_irq_ack(priv->mc13783, MC13783_IRQ_TS);
+	mc13xxx_irq_ack(priv->mc13xxx, MC13XXX_IRQ_TS);
 
-	ret = mc13783_irq_request(priv->mc13783, MC13783_IRQ_TS,
+	ret = mc13xxx_irq_request(priv->mc13xxx, MC13XXX_IRQ_TS,
 		mc13783_ts_handler, MC13783_TS_NAME, priv);
 	if (ret)
 		goto out;
 
-	ret = mc13783_reg_rmw(priv->mc13783, MC13783_ADC0,
-			MC13783_ADC0_TSMOD_MASK, MC13783_ADC0_TSMOD0);
+	ret = mc13xxx_reg_rmw(priv->mc13xxx, MC13XXX_ADC0,
+			MC13XXX_ADC0_TSMOD_MASK, MC13XXX_ADC0_TSMOD0);
 	if (ret)
-		mc13783_irq_free(priv->mc13783, MC13783_IRQ_TS, priv);
+		mc13xxx_irq_free(priv->mc13xxx, MC13XXX_IRQ_TS, priv);
 out:
-	mc13783_unlock(priv->mc13783);
+	mc13xxx_unlock(priv->mc13xxx);
 	return ret;
 }
 
@@ -156,11 +156,11 @@ static void mc13783_ts_close(struct input_dev *dev)
 {
 	struct mc13783_ts_priv *priv = input_get_drvdata(dev);
 
-	mc13783_lock(priv->mc13783);
-	mc13783_reg_rmw(priv->mc13783, MC13783_ADC0,
-			MC13783_ADC0_TSMOD_MASK, 0);
-	mc13783_irq_free(priv->mc13783, MC13783_IRQ_TS, priv);
-	mc13783_unlock(priv->mc13783);
+	mc13xxx_lock(priv->mc13xxx);
+	mc13xxx_reg_rmw(priv->mc13xxx, MC13XXX_ADC0,
+			MC13XXX_ADC0_TSMOD_MASK, 0);
+	mc13xxx_irq_free(priv->mc13xxx, MC13XXX_IRQ_TS, priv);
+	mc13xxx_unlock(priv->mc13xxx);
 
 	cancel_delayed_work_sync(&priv->work);
 }
@@ -177,7 +177,7 @@ static int __init mc13783_ts_probe(struct platform_device *pdev)
 		goto err_free_mem;
 
 	INIT_DELAYED_WORK(&priv->work, mc13783_ts_work);
-	priv->mc13783 = dev_get_drvdata(pdev->dev.parent);
+	priv->mc13xxx = dev_get_drvdata(pdev->dev.parent);
 	priv->idev = idev;
 
 	/*
-- 
1.7.5.4


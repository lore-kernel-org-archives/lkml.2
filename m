Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937601Ab0CPJPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 05:15:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54762 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932553Ab0CPJPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 05:15:16 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] rtc/mc13783: fix use after free bug
Date: Tue, 16 Mar 2010 10:15:11 +0100
Message-Id: <1268730911-25296-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100307141459.GE6469@bicker>
References: <20100307141459.GE6469@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was introduced by v2.6.34-rc1~38:

	4c014e8 (rtc/mc13783: protect rtc {,un}registration by mc13783 lock)

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reported-by: Dan Carpenter <error27@gmail.com>
---
 drivers/rtc/rtc-mc13783.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/rtc-mc13783.c b/drivers/rtc/rtc-mc13783.c
index d60c81b..1379c7f 100644
--- a/drivers/rtc/rtc-mc13783.c
+++ b/drivers/rtc/rtc-mc13783.c
@@ -319,35 +319,38 @@ static int __devinit mc13783_rtc_probe(struct platform_device *pdev)
 {
 	int ret;
 	struct mc13783_rtc *priv;
+	struct mc13783 *mc13783;
 	int rtcrst_pending;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-	priv->mc13783 = dev_get_drvdata(pdev->dev.parent);
+	mc13783 = dev_get_drvdata(pdev->dev.parent);
+	priv->mc13783 = mc13783;
+
 	platform_set_drvdata(pdev, priv);
 
-	mc13783_lock(priv->mc13783);
+	mc13783_lock(mc13783);
 
-	ret = mc13783_irq_request(priv->mc13783, MC13783_IRQ_RTCRST,
+	ret = mc13783_irq_request(mc13783, MC13783_IRQ_RTCRST,
 			mc13783_rtc_reset_handler, DRIVER_NAME, priv);
 	if (ret)
 		goto err_reset_irq_request;
 
-	ret = mc13783_irq_status(priv->mc13783, MC13783_IRQ_RTCRST,
+	ret = mc13783_irq_status(mc13783, MC13783_IRQ_RTCRST,
 			NULL, &rtcrst_pending);
 	if (ret)
 		goto err_reset_irq_status;
 
 	priv->valid = !rtcrst_pending;
 
-	ret = mc13783_irq_request_nounmask(priv->mc13783, MC13783_IRQ_1HZ,
+	ret = mc13783_irq_request_nounmask(mc13783, MC13783_IRQ_1HZ,
 			mc13783_rtc_update_handler, DRIVER_NAME, priv);
 	if (ret)
 		goto err_update_irq_request;
 
-	ret = mc13783_irq_request_nounmask(priv->mc13783, MC13783_IRQ_TODA,
+	ret = mc13783_irq_request_nounmask(mc13783, MC13783_IRQ_TODA,
 			mc13783_rtc_alarm_handler, DRIVER_NAME, priv);
 	if (ret)
 		goto err_alarm_irq_request;
@@ -357,22 +360,22 @@ static int __devinit mc13783_rtc_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->rtc)) {
 		ret = PTR_ERR(priv->rtc);
 
-		mc13783_irq_free(priv->mc13783, MC13783_IRQ_TODA, priv);
+		mc13783_irq_free(mc13783, MC13783_IRQ_TODA, priv);
 err_alarm_irq_request:
 
-		mc13783_irq_free(priv->mc13783, MC13783_IRQ_1HZ, priv);
+		mc13783_irq_free(mc13783, MC13783_IRQ_1HZ, priv);
 err_update_irq_request:
 
 err_reset_irq_status:
 
-		mc13783_irq_free(priv->mc13783, MC13783_IRQ_RTCRST, priv);
+		mc13783_irq_free(mc13783, MC13783_IRQ_RTCRST, priv);
 err_reset_irq_request:
 
 		platform_set_drvdata(pdev, NULL);
 		kfree(priv);
 	}
 
-	mc13783_unlock(priv->mc13783);
+	mc13783_unlock(mc13783);
 
 	return ret;
 }
-- 
1.7.0


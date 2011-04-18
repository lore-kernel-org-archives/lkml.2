Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab1DROLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:11:19 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:58391 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab1DROJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:09:52 -0400
X-ASG-Debug-ID: 1303135791-082d70310001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        a.zummo@towertech.it, johnpol@2ka.mipt.ru, cbou@mail.ru,
        dwmw2@infradead.org, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
X-ASG-Orig-Subj: [PATCH 10/14] rtc: avoid to use hardcoding irq number in max8925
Subject: [PATCH 10/14] rtc: avoid to use hardcoding irq number in max8925
Date: Mon, 18 Apr 2011 22:04:07 +0800
X-ASG-Orig-Subj: [PATCH 10/14] rtc: avoid to use hardcoding irq number in max8925
Message-Id: <1303135451-26362-11-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <2011041801>
References: <2011041801>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1303135791
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid to use hardcoding irq number in max8925 rtc driver. Use irq number
from resources instead.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
---
 drivers/rtc/rtc-max8925.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-max8925.c b/drivers/rtc/rtc-max8925.c
index 174036d..c460152 100644
--- a/drivers/rtc/rtc-max8925.c
+++ b/drivers/rtc/rtc-max8925.c
@@ -69,6 +69,7 @@ struct max8925_rtc_info {
 	struct max8925_chip	*chip;
 	struct i2c_client	*rtc;
 	struct device		*dev;
+	int			irq;
 };
 
 static irqreturn_t rtc_update_handler(int irq, void *data)
@@ -239,7 +240,7 @@ static int __devinit max8925_rtc_probe(struct platform_device *pdev)
 {
 	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
 	struct max8925_rtc_info *info;
-	int irq, ret;
+	int ret = -EINVAL;
 
 	info = kzalloc(sizeof(struct max8925_rtc_info), GFP_KERNEL);
 	if (!info)
@@ -247,16 +248,22 @@ static int __devinit max8925_rtc_probe(struct platform_device *pdev)
 	info->chip = chip;
 	info->rtc = chip->rtc;
 	info->dev = &pdev->dev;
-	irq = chip->irq_base + MAX8925_IRQ_RTC_ALARM0;
+	info->irq = platform_get_irq(pdev, 0);
+	if (info->irq < 0) {
+		dev_err(chip->dev, "Failed to get IRQ resource\n");
+		goto out_irq;
+	}
 
-	ret = request_threaded_irq(irq, NULL, rtc_update_handler,
+	ret = request_threaded_irq(info->irq, NULL, rtc_update_handler,
 				   IRQF_ONESHOT, "rtc-alarm0", info);
 	if (ret < 0) {
 		dev_err(chip->dev, "Failed to request IRQ: #%d: %d\n",
-			irq, ret);
+			info->irq, ret);
 		goto out_irq;
 	}
 
+	dev_set_drvdata(&pdev->dev, info);
+	platform_set_drvdata(pdev, info);
 	info->rtc_dev = rtc_device_register("max8925-rtc", &pdev->dev,
 					&max8925_rtc_ops, THIS_MODULE);
 	ret = PTR_ERR(info->rtc_dev);
@@ -265,12 +272,9 @@ static int __devinit max8925_rtc_probe(struct platform_device *pdev)
 		goto out_rtc;
 	}
 
-	dev_set_drvdata(&pdev->dev, info);
-	platform_set_drvdata(pdev, info);
-
 	return 0;
 out_rtc:
-	free_irq(chip->irq_base + MAX8925_IRQ_RTC_ALARM0, info);
+	free_irq(info->irq, info);
 out_irq:
 	kfree(info);
 	return ret;
@@ -281,7 +285,7 @@ static int __devexit max8925_rtc_remove(struct platform_device *pdev)
 	struct max8925_rtc_info *info = platform_get_drvdata(pdev);
 
 	if (info) {
-		free_irq(info->chip->irq_base + MAX8925_IRQ_RTC_ALARM0, info);
+		free_irq(info->irq, info);
 		rtc_device_unregister(info->rtc_dev);
 		kfree(info);
 	}
-- 
1.5.6.5


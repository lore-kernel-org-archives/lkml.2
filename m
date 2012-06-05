Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab2FEKJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:09:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55785 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab2FEKJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:09:07 -0400
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: a.zummo@towertech.it, sameo@linux.intel.com, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH] mfd: max8925: transfer rtc irq in resources
Date: Tue,  5 Jun 2012 18:08:50 +0800
Message-Id: <1338890930-24724-1-git-send-email-haojian.zhuang@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX8925 rtc irq is transfered from mfd resources now.

Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
---
 drivers/mfd/max8925-core.c |    8 ++++----
 drivers/rtc/rtc-max8925.c  |   13 +++++++------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/max8925-core.c b/drivers/mfd/max8925-core.c
index ca881ef..825a7f0 100644
--- a/drivers/mfd/max8925-core.c
+++ b/drivers/mfd/max8925-core.c
@@ -75,9 +75,9 @@ static struct mfd_cell power_devs[] = {
 static struct resource rtc_resources[] = {
 	{
 		.name	= "max8925-rtc",
-		.start	= MAX8925_RTC_IRQ,
-		.end	= MAX8925_RTC_IRQ_MASK,
-		.flags	= IORESOURCE_IO,
+		.start	= MAX8925_IRQ_RTC_ALARM0,
+		.end	= MAX8925_IRQ_RTC_ALARM0,
+		.flags	= IORESOURCE_IRQ,
 	},
 };
 
@@ -598,7 +598,7 @@ int __devinit max8925_device_init(struct max8925_chip *chip,
 
 	ret = mfd_add_devices(chip->dev, 0, &rtc_devs[0],
 			      ARRAY_SIZE(rtc_devs),
-			      &rtc_resources[0], 0);
+			      &rtc_resources[0], chip->irq_base);
 	if (ret < 0) {
 		dev_err(chip->dev, "Failed to add rtc subdev\n");
 		goto out;
diff --git a/drivers/rtc/rtc-max8925.c b/drivers/rtc/rtc-max8925.c
index 1459055..34e4349 100644
--- a/drivers/rtc/rtc-max8925.c
+++ b/drivers/rtc/rtc-max8925.c
@@ -69,6 +69,7 @@ struct max8925_rtc_info {
 	struct max8925_chip	*chip;
 	struct i2c_client	*rtc;
 	struct device		*dev;
+	int			irq;
 };
 
 static irqreturn_t rtc_update_handler(int irq, void *data)
@@ -250,7 +251,7 @@ static int __devinit max8925_rtc_probe(struct platform_device *pdev)
 {
 	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
 	struct max8925_rtc_info *info;
-	int irq, ret;
+	int ret;
 
 	info = kzalloc(sizeof(struct max8925_rtc_info), GFP_KERNEL);
 	if (!info)
@@ -258,13 +259,13 @@ static int __devinit max8925_rtc_probe(struct platform_device *pdev)
 	info->chip = chip;
 	info->rtc = chip->rtc;
 	info->dev = &pdev->dev;
-	irq = chip->irq_base + MAX8925_IRQ_RTC_ALARM0;
+	info->irq = platform_get_irq(pdev, 0);
 
-	ret = request_threaded_irq(irq, NULL, rtc_update_handler,
+	ret = request_threaded_irq(info->irq, NULL, rtc_update_handler,
 				   IRQF_ONESHOT, "rtc-alarm0", info);
 	if (ret < 0) {
 		dev_err(chip->dev, "Failed to request IRQ: #%d: %d\n",
-			irq, ret);
+			info->irq, ret);
 		goto out_irq;
 	}
 
@@ -285,7 +286,7 @@ static int __devinit max8925_rtc_probe(struct platform_device *pdev)
 	return 0;
 out_rtc:
 	platform_set_drvdata(pdev, NULL);
-	free_irq(chip->irq_base + MAX8925_IRQ_RTC_ALARM0, info);
+	free_irq(info->irq, info);
 out_irq:
 	kfree(info);
 	return ret;
@@ -296,7 +297,7 @@ static int __devexit max8925_rtc_remove(struct platform_device *pdev)
 	struct max8925_rtc_info *info = platform_get_drvdata(pdev);
 
 	if (info) {
-		free_irq(info->chip->irq_base + MAX8925_IRQ_RTC_ALARM0, info);
+		free_irq(info->irq, info);
 		rtc_device_unregister(info->rtc_dev);
 		kfree(info);
 	}
-- 
1.7.5.4


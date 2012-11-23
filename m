Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab2KWMsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 07:48:13 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47016 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab2KWMsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 07:48:12 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: dwmw2@infradead.org, cbou@mail.ru, patches@linaro.org
Subject: [PATCH] power: 88pm860x_battery: Add a few more devm_* APIs
Date: Fri, 23 Nov 2012 18:11:52 +0530
Message-Id: <1353674512-16119-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devm_* APIs for threaded IRQ.

Also since devres managed objects are removed when the device gets
detached, remove explicit freeing of them.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/power/88pm860x_battery.c |   25 ++++++++-----------------
 1 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/power/88pm860x_battery.c b/drivers/power/88pm860x_battery.c
index beed5ecf..a245aa4 100644
--- a/drivers/power/88pm860x_battery.c
+++ b/drivers/power/88pm860x_battery.c
@@ -915,15 +915,13 @@ static __devinit int pm860x_battery_probe(struct platform_device *pdev)
 	info->irq_cc = platform_get_irq(pdev, 0);
 	if (info->irq_cc <= 0) {
 		dev_err(&pdev->dev, "No IRQ resource!\n");
-		ret = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	info->irq_batt = platform_get_irq(pdev, 1);
 	if (info->irq_batt <= 0) {
 		dev_err(&pdev->dev, "No IRQ resource!\n");
-		ret = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	info->chip = chip;
@@ -957,10 +955,10 @@ static __devinit int pm860x_battery_probe(struct platform_device *pdev)
 
 	ret = power_supply_register(&pdev->dev, &info->battery);
 	if (ret)
-		goto out;
+		return ret;
 	info->battery.dev->parent = &pdev->dev;
 
-	ret = request_threaded_irq(info->irq_cc, NULL,
+	ret = devm_request_threaded_irq(&pdev->dev, info->irq_cc, NULL,
 				pm860x_coulomb_handler, IRQF_ONESHOT,
 				"coulomb", info);
 	if (ret < 0) {
@@ -969,23 +967,19 @@ static __devinit int pm860x_battery_probe(struct platform_device *pdev)
 		goto out_reg;
 	}
 
-	ret = request_threaded_irq(info->irq_batt, NULL, pm860x_batt_handler,
-				IRQF_ONESHOT, "battery", info);
+	ret = devm_request_threaded_irq(&pdev->dev, info->irq_batt, NULL,
+				pm860x_batt_handler, IRQF_ONESHOT,
+				"battery", info);
 	if (ret < 0) {
 		dev_err(chip->dev, "Failed to request IRQ: #%d: %d\n",
 			info->irq_batt, ret);
-		goto out_coulomb;
+		goto out_reg;
 	}
 
-
 	return 0;
 
-out_coulomb:
-	free_irq(info->irq_cc, info);
 out_reg:
 	power_supply_unregister(&info->battery);
-out:
-	kfree(info);
 	return ret;
 }
 
@@ -994,9 +988,6 @@ static int __devexit pm860x_battery_remove(struct platform_device *pdev)
 	struct pm860x_battery_info *info = platform_get_drvdata(pdev);
 
 	power_supply_unregister(&info->battery);
-	free_irq(info->irq_batt, info);
-	free_irq(info->irq_cc, info);
-	kfree(info);
 	platform_set_drvdata(pdev, NULL);
 	return 0;
 }
-- 
1.7.4.1


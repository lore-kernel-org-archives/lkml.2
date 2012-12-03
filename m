Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751098Ab2LCFip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 00:38:45 -0500
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:34644 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750712Ab2LCFio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 00:38:44 -0500
From: Qing Xu <qingx@marvell.com>
To: qingx@marvell.com, zhouqiao@marvell.com, sameo@linux.intel.com,
        cxie4@marvell.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] mfd: 88pm80x: fix regmap not init before used
Date: Mon,  3 Dec 2012 13:38:37 +0800
Message-Id: <1354513117-20464-1-git-send-email-qingx@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 03 Dec 2012 05:38:42.0662 (UTC) FILETIME=[74716060:01CDD118]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

1.put the pm800_page_init before 800_init, otherwise power and
gpadc regmap handle are not inited before being used.
2.remove regmap exit, as it will be called in driver release
3.add lost "return 0" in probe()
4.update driver's name

Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
Signed-off-by: Qing Xu <qingx@marvell.com>
---
 drivers/mfd/88pm800.c |   25 ++++++++++++-------------
 drivers/mfd/88pm805.c |    5 +++--
 drivers/mfd/88pm80x.c |    2 +-
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index ce229ea..73b2c9f 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -401,9 +401,6 @@ static void pm800_pages_exit(struct pm80x_chip *chip)
 {
 	struct pm80x_subchip *subchip;
 
-	regmap_exit(chip->regmap);
-	i2c_unregister_device(chip->client);
-
 	subchip = chip->subchip;
 	if (subchip->power_page) {
 		regmap_exit(subchip->regmap_power);
@@ -413,6 +410,7 @@ static void pm800_pages_exit(struct pm80x_chip *chip)
 		regmap_exit(subchip->regmap_gpadc);
 		i2c_unregister_device(subchip->gpadc_page);
 	}
+	i2c_unregister_device(chip->client);
 }
 
 static int __devinit device_800_init(struct pm80x_chip *chip,
@@ -528,25 +526,26 @@ static int __devinit pm800_probe(struct i2c_client *client,
 	subchip->gpadc_page_addr = pdata->gpadc_page_addr;
 	chip->subchip = subchip;
 
-	ret = device_800_init(chip, pdata);
-	if (ret) {
-		dev_err(chip->dev, "%s id 0x%x failed!\n", __func__, chip->id);
-		goto err_800_init;
-	}
-
 	ret = pm800_pages_init(chip);
 	if (ret) {
 		dev_err(&client->dev, "pm800_pages_init failed!\n");
 		goto err_page_init;
 	}
 
+	ret = device_800_init(chip, pdata);
+	if (ret) {
+		dev_err(chip->dev, "%s id 0x%x failed!\n", __func__, chip->id);
+		goto err_800_init;
+	}
+
 	if (pdata->plat_config)
 		pdata->plat_config(chip, pdata);
 
-err_page_init:
-	mfd_remove_devices(chip->dev);
-	device_irq_exit_800(chip);
+	return 0;
+
 err_800_init:
+	pm800_pages_exit(chip);
+err_page_init:
 	devm_kfree(&client->dev, subchip);
 err_subchip_alloc:
 	pm80x_deinit(client);
@@ -571,7 +570,7 @@ static int __devexit pm800_remove(struct i2c_client *client)
 
 static struct i2c_driver pm800_driver = {
 	.driver = {
-		.name = "88PM80X",
+		.name = "88PM800",
 		.owner = THIS_MODULE,
 		.pm = &pm80x_pm_ops,
 		},
diff --git a/drivers/mfd/88pm805.c b/drivers/mfd/88pm805.c
index c20a311..7878013 100644
--- a/drivers/mfd/88pm805.c
+++ b/drivers/mfd/88pm805.c
@@ -168,7 +168,6 @@ static int __devinit device_irq_init_805(struct pm80x_chip *chip)
 	ret =
 	    regmap_add_irq_chip(chip->regmap, chip->irq, flags, -1,
 				chip->regmap_irq_chip, &chip->irq_data);
-
 out:
 	return ret;
 }
@@ -256,6 +255,8 @@ static int __devinit pm805_probe(struct i2c_client *client,
 	if (pdata->plat_config)
 		pdata->plat_config(chip, pdata);
 
+	return 0;
+
 err_805_init:
 	pm80x_deinit(client);
 out_init:
@@ -276,7 +277,7 @@ static int __devexit pm805_remove(struct i2c_client *client)
 
 static struct i2c_driver pm805_driver = {
 	.driver = {
-		.name = "88PM80X",
+		.name = "88PM805",
 		.owner = THIS_MODULE,
 		.pm = &pm80x_pm_ops,
 		},
diff --git a/drivers/mfd/88pm80x.c b/drivers/mfd/88pm80x.c
index cd0bf52..1adb355 100644
--- a/drivers/mfd/88pm80x.c
+++ b/drivers/mfd/88pm80x.c
@@ -31,7 +31,7 @@ const struct regmap_config pm80x_regmap_config = {
 };
 EXPORT_SYMBOL_GPL(pm80x_regmap_config);
 
-int __devinit pm80x_init(struct i2c_client *client,
+int pm80x_init(struct i2c_client *client,
 				 const struct i2c_device_id *id)
 {
 	struct pm80x_chip *chip;
-- 
1.7.0.4


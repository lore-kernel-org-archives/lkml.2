Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab1HKJKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 05:10:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53634 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752041Ab1HKJKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 05:10:15 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Oritz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Use device ID matching for WM831x SPI driver
Date: Thu, 11 Aug 2011 14:40:18 +0900
Message-Id: <1313041218-18401-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

This collides with the regmap updates so it'd probably be easiest to
merge via the regmap tree.

 drivers/mfd/wm831x-spi.c |  138 ++++++---------------------------------------
 1 files changed, 19 insertions(+), 119 deletions(-)

diff --git a/drivers/mfd/wm831x-spi.c b/drivers/mfd/wm831x-spi.c
index dbe1147..201711b 100644
--- a/drivers/mfd/wm831x-spi.c
+++ b/drivers/mfd/wm831x-spi.c
@@ -23,29 +23,12 @@
 
 static int __devinit wm831x_spi_probe(struct spi_device *spi)
 {
+	const struct spi_device_id *id = spi_get_device_id(spi);
 	struct wm831x *wm831x;
 	enum wm831x_parent type;
 	int ret;
 
-	/* Currently SPI support for ID tables is unmerged, we're faking it */
-	if (strcmp(spi->modalias, "wm8310") == 0)
-		type = WM8310;
-	else if (strcmp(spi->modalias, "wm8311") == 0)
-		type = WM8311;
-	else if (strcmp(spi->modalias, "wm8312") == 0)
-		type = WM8312;
-	else if (strcmp(spi->modalias, "wm8320") == 0)
-		type = WM8320;
-	else if (strcmp(spi->modalias, "wm8321") == 0)
-		type = WM8321;
-	else if (strcmp(spi->modalias, "wm8325") == 0)
-		type = WM8325;
-	else if (strcmp(spi->modalias, "wm8326") == 0)
-		type = WM8326;
-	else {
-		dev_err(&spi->dev, "Unknown device type\n");
-		return -EINVAL;
-	}
+	type = (enum wm831x_parent)id->driver_data;
 
 	wm831x = kzalloc(sizeof(struct wm831x), GFP_KERNEL);
 	if (wm831x == NULL)
@@ -57,7 +40,7 @@ static int __devinit wm831x_spi_probe(struct spi_device *spi)
 	dev_set_drvdata(&spi->dev, wm831x);
 	wm831x->dev = &spi->dev;
 
-	wm831x->regmap = regmap_init_spi(wm831x->dev, &wm831x_regmap_config);
+	wm831x->regmap = regmap_init_spi(spi, &wm831x_regmap_config);
 	if (IS_ERR(wm831x->regmap)) {
 		ret = PTR_ERR(wm831x->regmap);
 		dev_err(wm831x->dev, "Failed to allocate register map: %d\n",
@@ -90,79 +73,26 @@ static const struct dev_pm_ops wm831x_spi_pm = {
 	.suspend = wm831x_spi_suspend,
 };
 
-static struct spi_driver wm8310_spi_driver = {
-	.driver = {
-		.name	= "wm8310",
-		.bus	= &spi_bus_type,
-		.owner	= THIS_MODULE,
-		.pm	= &wm831x_spi_pm,
-	},
-	.probe		= wm831x_spi_probe,
-	.remove		= __devexit_p(wm831x_spi_remove),
-};
-
-static struct spi_driver wm8311_spi_driver = {
-	.driver = {
-		.name	= "wm8311",
-		.bus	= &spi_bus_type,
-		.owner	= THIS_MODULE,
-		.pm	= &wm831x_spi_pm,
-	},
-	.probe		= wm831x_spi_probe,
-	.remove		= __devexit_p(wm831x_spi_remove),
+static const struct spi_device_id wm831x_spi_ids[] = {
+	{ "wm8310", WM8310 },
+	{ "wm8311", WM8311 },
+	{ "wm8312", WM8312 },
+	{ "wm8320", WM8320 },
+	{ "wm8321", WM8321 },
+	{ "wm8325", WM8325 },
+	{ "wm8326", WM8326 },
+	{ 0, 0 },
 };
+MODULE_DEVICE_TABLE(spi, wm831x_spi_id);
 
-static struct spi_driver wm8312_spi_driver = {
+static struct spi_driver wm831x_spi_driver = {
 	.driver = {
-		.name	= "wm8312",
-		.bus	= &spi_bus_type,
-		.owner	= THIS_MODULE,
-		.pm	= &wm831x_spi_pm,
-	},
-	.probe		= wm831x_spi_probe,
-	.remove		= __devexit_p(wm831x_spi_remove),
-};
-
-static struct spi_driver wm8320_spi_driver = {
-	.driver = {
-		.name	= "wm8320",
-		.bus	= &spi_bus_type,
-		.owner	= THIS_MODULE,
-		.pm	= &wm831x_spi_pm,
-	},
-	.probe		= wm831x_spi_probe,
-	.remove		= __devexit_p(wm831x_spi_remove),
-};
-
-static struct spi_driver wm8321_spi_driver = {
-	.driver = {
-		.name	= "wm8321",
-		.bus	= &spi_bus_type,
-		.owner	= THIS_MODULE,
-		.pm	= &wm831x_spi_pm,
-	},
-	.probe		= wm831x_spi_probe,
-	.remove		= __devexit_p(wm831x_spi_remove),
-};
-
-static struct spi_driver wm8325_spi_driver = {
-	.driver = {
-		.name	= "wm8325",
-		.bus	= &spi_bus_type,
-		.owner	= THIS_MODULE,
-		.pm	= &wm831x_spi_pm,
-	},
-	.probe		= wm831x_spi_probe,
-	.remove		= __devexit_p(wm831x_spi_remove),
-};
-
-static struct spi_driver wm8326_spi_driver = {
-	.driver = {
-		.name	= "wm8326",
+		.name	= "wm831x",
 		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 		.pm	= &wm831x_spi_pm,
 	},
+	.id_table	= wm831x_spi_ids,
 	.probe		= wm831x_spi_probe,
 	.remove		= __devexit_p(wm831x_spi_remove),
 };
@@ -171,33 +101,9 @@ static int __init wm831x_spi_init(void)
 {
 	int ret;
 
-	ret = spi_register_driver(&wm8310_spi_driver);
-	if (ret != 0)
-		pr_err("Failed to register WM8310 SPI driver: %d\n", ret);
-
-	ret = spi_register_driver(&wm8311_spi_driver);
-	if (ret != 0)
-		pr_err("Failed to register WM8311 SPI driver: %d\n", ret);
-
-	ret = spi_register_driver(&wm8312_spi_driver);
-	if (ret != 0)
-		pr_err("Failed to register WM8312 SPI driver: %d\n", ret);
-
-	ret = spi_register_driver(&wm8320_spi_driver);
-	if (ret != 0)
-		pr_err("Failed to register WM8320 SPI driver: %d\n", ret);
-
-	ret = spi_register_driver(&wm8321_spi_driver);
-	if (ret != 0)
-		pr_err("Failed to register WM8321 SPI driver: %d\n", ret);
-
-	ret = spi_register_driver(&wm8325_spi_driver);
-	if (ret != 0)
-		pr_err("Failed to register WM8325 SPI driver: %d\n", ret);
-
-	ret = spi_register_driver(&wm8326_spi_driver);
+	ret = spi_register_driver(&wm831x_spi_driver);
 	if (ret != 0)
-		pr_err("Failed to register WM8326 SPI driver: %d\n", ret);
+		pr_err("Failed to register WM831x SPI driver: %d\n", ret);
 
 	return 0;
 }
@@ -205,13 +111,7 @@ subsys_initcall(wm831x_spi_init);
 
 static void __exit wm831x_spi_exit(void)
 {
-	spi_unregister_driver(&wm8326_spi_driver);
-	spi_unregister_driver(&wm8325_spi_driver);
-	spi_unregister_driver(&wm8321_spi_driver);
-	spi_unregister_driver(&wm8320_spi_driver);
-	spi_unregister_driver(&wm8312_spi_driver);
-	spi_unregister_driver(&wm8311_spi_driver);
-	spi_unregister_driver(&wm8310_spi_driver);
+	spi_unregister_driver(&wm831x_spi_driver);
 }
 module_exit(wm831x_spi_exit);
 
-- 
1.7.5.4


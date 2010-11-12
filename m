Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696Ab0KLQs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:48:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48931 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756623Ab0KLQs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:48:57 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Oritz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: Add WM8326 support
Date: Fri, 12 Nov 2010 16:48:54 +0000
Message-Id: <1289580534-18604-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289580534-18604-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1289580534-18604-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM8326 is a high performance variant of the WM832x series with
no software visible differences.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c       |    7 +++++++
 drivers/mfd/wm831x-i2c.c        |    1 +
 drivers/mfd/wm831x-spi.c        |   18 ++++++++++++++++++
 include/linux/mfd/wm831x/core.h |    1 +
 4 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 030da2c..5c9191e 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -1537,6 +1537,12 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 		dev_info(wm831x->dev, "WM8325 revision %c\n", 'A' + rev);
 		break;
 
+	case WM8326:
+		parent = WM8326;
+		wm831x->num_gpio = 12;
+		dev_info(wm831x->dev, "WM8326 revision %c\n", 'A' + rev);
+		break;
+
 	default:
 		dev_err(wm831x->dev, "Unknown WM831x device %04x\n", ret);
 		ret = -EINVAL;
@@ -1608,6 +1614,7 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	case WM8320:
 	case WM8321:
 	case WM8325:
+	case WM8326:
 		ret = mfd_add_devices(wm831x->dev, -1,
 				      wm8320_devs, ARRAY_SIZE(wm8320_devs),
 				      NULL, 0);
diff --git a/drivers/mfd/wm831x-i2c.c b/drivers/mfd/wm831x-i2c.c
index 156b198..38be520 100644
--- a/drivers/mfd/wm831x-i2c.c
+++ b/drivers/mfd/wm831x-i2c.c
@@ -108,6 +108,7 @@ static const struct i2c_device_id wm831x_i2c_id[] = {
 	{ "wm8320", WM8320 },
 	{ "wm8321", WM8321 },
 	{ "wm8325", WM8325 },
+	{ "wm8326", WM8326 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, wm831x_i2c_id);
diff --git a/drivers/mfd/wm831x-spi.c b/drivers/mfd/wm831x-spi.c
index 2789b15..0a8f772 100644
--- a/drivers/mfd/wm831x-spi.c
+++ b/drivers/mfd/wm831x-spi.c
@@ -81,6 +81,8 @@ static int __devinit wm831x_spi_probe(struct spi_device *spi)
 		type = WM8321;
 	else if (strcmp(spi->modalias, "wm8325") == 0)
 		type = WM8325;
+	else if (strcmp(spi->modalias, "wm8326") == 0)
+		type = WM8326;
 	else {
 		dev_err(&spi->dev, "Unknown device type\n");
 		return -EINVAL;
@@ -184,6 +186,17 @@ static struct spi_driver wm8325_spi_driver = {
 	.suspend	= wm831x_spi_suspend,
 };
 
+static struct spi_driver wm8326_spi_driver = {
+	.driver = {
+		.name	= "wm8326",
+		.bus	= &spi_bus_type,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= wm831x_spi_probe,
+	.remove		= __devexit_p(wm831x_spi_remove),
+	.suspend	= wm831x_spi_suspend,
+};
+
 static int __init wm831x_spi_init(void)
 {
 	int ret;
@@ -212,12 +225,17 @@ static int __init wm831x_spi_init(void)
 	if (ret != 0)
 		pr_err("Failed to register WM8325 SPI driver: %d\n", ret);
 
+	ret = spi_register_driver(&wm8326_spi_driver);
+	if (ret != 0)
+		pr_err("Failed to register WM8326 SPI driver: %d\n", ret);
+
 	return 0;
 }
 subsys_initcall(wm831x_spi_init);
 
 static void __exit wm831x_spi_exit(void)
 {
+	spi_unregister_driver(&wm8326_spi_driver);
 	spi_unregister_driver(&wm8325_spi_driver);
 	spi_unregister_driver(&wm8321_spi_driver);
 	spi_unregister_driver(&wm8320_spi_driver);
diff --git a/include/linux/mfd/wm831x/core.h b/include/linux/mfd/wm831x/core.h
index a1239c4..903280d 100644
--- a/include/linux/mfd/wm831x/core.h
+++ b/include/linux/mfd/wm831x/core.h
@@ -245,6 +245,7 @@ enum wm831x_parent {
 	WM8320 = 0x8320,
 	WM8321 = 0x8321,
 	WM8325 = 0x8325,
+	WM8326 = 0x8326,
 };
 
 struct wm831x {
-- 
1.7.1


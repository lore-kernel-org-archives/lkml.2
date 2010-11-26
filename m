Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab0KZRTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:19:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45527 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751902Ab0KZRTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:19:46 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: Implement runtime PM for WM8994 core driver
Date: Fri, 26 Nov 2010 17:19:35 +0000
Message-Id: <1290791975-21160-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290791975-21160-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1290791975-21160-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the WM8994 to completely power off, including disabling the LDOs
if they are software controlled, when it goes idle. The CODEC subdevice
controls activity for the MFD as a whole.

If the GPIOs need to be used while the device is active runtime PM
should be disabled for the device by machine specific code.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c |   46 ++++++++++++++++++++++----------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 8d221ba..41233c7 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -18,6 +18,7 @@
 #include <linux/i2c.h>
 #include <linux/delay.h>
 #include <linux/mfd/core.h>
+#include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
 #include <linux/regulator/machine.h>
 
@@ -169,8 +170,16 @@ out:
 EXPORT_SYMBOL_GPL(wm8994_set_bits);
 
 static struct mfd_cell wm8994_regulator_devs[] = {
-	{ .name = "wm8994-ldo", .id = 1 },
-	{ .name = "wm8994-ldo", .id = 2 },
+	{
+		.name = "wm8994-ldo",
+		.id = 1,
+		.pm_runtime_no_callbacks = true,
+	},
+	{
+		.name = "wm8994-ldo",
+		.id = 2,
+		.pm_runtime_no_callbacks = true,
+	},
 };
 
 static struct resource wm8994_codec_resources[] = {
@@ -200,6 +209,7 @@ static struct mfd_cell wm8994_devs[] = {
 		.name = "wm8994-gpio",
 		.num_resources = ARRAY_SIZE(wm8994_gpio_resources),
 		.resources = wm8994_gpio_resources,
+		.pm_runtime_no_callbacks = true,
 	},
 };
 
@@ -231,7 +241,7 @@ static const char *wm8958_main_supplies[] = {
 };
 
 #ifdef CONFIG_PM
-static int wm8994_device_suspend(struct device *dev)
+static int wm8994_suspend(struct device *dev)
 {
 	struct wm8994 *wm8994 = dev_get_drvdata(dev);
 	int ret;
@@ -261,7 +271,7 @@ static int wm8994_device_suspend(struct device *dev)
 	return 0;
 }
 
-static int wm8994_device_resume(struct device *dev)
+static int wm8994_resume(struct device *dev)
 {
 	struct wm8994 *wm8994 = dev_get_drvdata(dev);
 	int ret;
@@ -471,6 +481,9 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 		goto err_irq;
 	}
 
+	pm_runtime_enable(wm8994->dev);
+	pm_runtime_resume(wm8994->dev);
+
 	return 0;
 
 err_irq:
@@ -490,6 +503,7 @@ err:
 
 static void wm8994_device_exit(struct wm8994 *wm8994)
 {
+	pm_runtime_disable(wm8994->dev);
 	mfd_remove_devices(wm8994->dev);
 	wm8994_irq_exit(wm8994);
 	regulator_bulk_disable(wm8994->num_supplies,
@@ -573,21 +587,6 @@ static int wm8994_i2c_remove(struct i2c_client *i2c)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int wm8994_i2c_suspend(struct i2c_client *i2c, pm_message_t state)
-{
-	return wm8994_device_suspend(&i2c->dev);
-}
-
-static int wm8994_i2c_resume(struct i2c_client *i2c)
-{
-	return wm8994_device_resume(&i2c->dev);
-}
-#else
-#define wm8994_i2c_suspend NULL
-#define wm8994_i2c_resume NULL
-#endif
-
 static const struct i2c_device_id wm8994_i2c_id[] = {
 	{ "wm8994", WM8994 },
 	{ "wm8958", WM8958 },
@@ -595,15 +594,16 @@ static const struct i2c_device_id wm8994_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, wm8994_i2c_id);
 
+UNIVERSAL_DEV_PM_OPS(wm8994_pm_ops, wm8994_suspend, wm8994_resume, NULL);
+
 static struct i2c_driver wm8994_i2c_driver = {
 	.driver = {
-		   .name = "wm8994",
-		   .owner = THIS_MODULE,
+		.name = "wm8994",
+		.owner = THIS_MODULE,
+		.pm = &wm8994_pm_ops,
 	},
 	.probe = wm8994_i2c_probe,
 	.remove = wm8994_i2c_remove,
-	.suspend = wm8994_i2c_suspend,
-	.resume = wm8994_i2c_resume,
 	.id_table = wm8994_i2c_id,
 };
 
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab1K1WpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:45:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60977 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754952Ab1K1WpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:45:03 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 8/8] mfd: Enable register cache for wm8994 devices
Date: Mon, 28 Nov 2011 22:44:34 +0000
Message-Id: <1322520274-13789-8-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322520274-13789-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20111128224017.GA13163@opensource.wolfsonmicro.com>
 <1322520274-13789-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of this we provide information about the registers that exist in
the device to the regmap core, drop the small amount of cache that the
core had been using and let regmap do the sync.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c       |   82 ++++++++++++++------------------------
 include/linux/mfd/wm8994/core.h |    2 -
 2 files changed, 30 insertions(+), 54 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 0167694..aafac5b 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -28,11 +28,7 @@
 #include <linux/mfd/wm8994/pdata.h>
 #include <linux/mfd/wm8994/registers.h>
 
-static int wm8994_read(struct wm8994 *wm8994, unsigned short reg,
-		       int bytes, void *dest)
-{
-	return regmap_raw_read(wm8994->regmap, reg, dest, bytes);
-}
+#include "wm8994.h"
 
 /**
  * wm8994_reg_read: Read a single WM8994 register.
@@ -68,12 +64,6 @@ int wm8994_bulk_read(struct wm8994 *wm8994, unsigned short reg,
 	return regmap_bulk_read(wm8994->regmap, reg, buf, count);
 }
 
-static int wm8994_write(struct wm8994 *wm8994, unsigned short reg,
-			int bytes, const void *src)
-{
-	return regmap_raw_write(wm8994->regmap, reg, src, bytes);
-}
-
 /**
  * wm8994_reg_write: Write a single WM8994 register.
  *
@@ -258,27 +248,14 @@ static int wm8994_suspend(struct device *dev)
 				WM8994_LDO1ENA_PD | WM8994_LDO2ENA_PD,
 				WM8994_LDO1ENA_PD | WM8994_LDO2ENA_PD);
 
-	/* GPIO configuration state is saved here since we may be configuring
-	 * the GPIO alternate functions even if we're not using the gpiolib
-	 * driver for them.
-	 */
-	ret = wm8994_read(wm8994, WM8994_GPIO_1, WM8994_NUM_GPIO_REGS * 2,
-			  &wm8994->gpio_regs);
-	if (ret < 0)
-		dev_err(dev, "Failed to save GPIO registers: %d\n", ret);
-
-	/* For similar reasons we also stash the regulator states */
-	ret = wm8994_read(wm8994, WM8994_LDO_1, WM8994_NUM_LDO_REGS * 2,
-			  &wm8994->ldo_regs);
-	if (ret < 0)
-		dev_err(dev, "Failed to save LDO registers: %d\n", ret);
-
 	/* Explicitly put the device into reset in case regulators
 	 * don't get disabled in order to ensure consistent restart.
 	 */
 	wm8994_reg_write(wm8994, WM8994_SOFTWARE_RESET,
 			 wm8994_reg_read(wm8994, WM8994_SOFTWARE_RESET));
 
+	regcache_mark_dirty(wm8994->regmap);
+
 	wm8994->suspended = true;
 
 	ret = regulator_bulk_disable(wm8994->num_supplies,
@@ -294,7 +271,7 @@ static int wm8994_suspend(struct device *dev)
 static int wm8994_resume(struct device *dev)
 {
 	struct wm8994 *wm8994 = dev_get_drvdata(dev);
-	int ret, i;
+	int ret;
 
 	/* We may have lied to the PM core about suspending */
 	if (!wm8994->suspended)
@@ -307,27 +284,12 @@ static int wm8994_resume(struct device *dev)
 		return ret;
 	}
 
-	/* Write register at a time as we use the cache on the CPU so store
-	 * it in native endian.
-	 */
-	for (i = 0; i < ARRAY_SIZE(wm8994->irq_masks_cur); i++) {
-		ret = wm8994_reg_write(wm8994, WM8994_INTERRUPT_STATUS_1_MASK
-				       + i, wm8994->irq_masks_cur[i]);
-		if (ret < 0)
-			dev_err(dev, "Failed to restore interrupt masks: %d\n",
-				ret);
+	ret = regcache_sync(wm8994->regmap);
+	if (ret != 0) {
+		dev_err(dev, "Failed to restore register map: %d\n", ret);
+		goto err_enable;
 	}
 
-	ret = wm8994_write(wm8994, WM8994_LDO_1, WM8994_NUM_LDO_REGS * 2,
-			   &wm8994->ldo_regs);
-	if (ret < 0)
-		dev_err(dev, "Failed to restore LDO registers: %d\n", ret);
-
-	ret = wm8994_write(wm8994, WM8994_GPIO_1, WM8994_NUM_GPIO_REGS * 2,
-			   &wm8994->gpio_regs);
-	if (ret < 0)
-		dev_err(dev, "Failed to restore GPIO registers: %d\n", ret);
-
 	/* Disable LDO pulldowns while the device is active */
 	wm8994_set_bits(wm8994, WM8994_PULL_CONTROL_2,
 			WM8994_LDO1ENA_PD | WM8994_LDO2ENA_PD,
@@ -336,6 +298,11 @@ static int wm8994_resume(struct device *dev)
 	wm8994->suspended = false;
 
 	return 0;
+
+err_enable:
+	regulator_bulk_disable(wm8994->num_supplies, wm8994->supplies);
+
+	return ret;
 }
 #endif
 
@@ -361,11 +328,6 @@ static int wm8994_ldo_in_use(struct wm8994_pdata *pdata, int ldo)
 }
 #endif
 
-static struct regmap_config wm8994_regmap_config = {
-	.reg_bits = 16,
-	.val_bits = 16,
-};
-
 /*
  * Instantiate the generic non-control parts of the device.
  */
@@ -594,6 +556,7 @@ static int wm8994_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
 	struct wm8994 *wm8994;
+	struct regmap_config *regmap_config;
 	int ret;
 
 	wm8994 = devm_kzalloc(&i2c->dev, sizeof(struct wm8994), GFP_KERNEL);
@@ -605,7 +568,22 @@ static int wm8994_i2c_probe(struct i2c_client *i2c,
 	wm8994->irq = i2c->irq;
 	wm8994->type = id->driver_data;
 
-	wm8994->regmap = regmap_init_i2c(i2c, &wm8994_regmap_config);
+	switch (wm8994->type) {
+	case WM1811:
+		regmap_config = &wm1811_regmap_config;
+		break;
+	case WM8994:
+		regmap_config = &wm8994_regmap_config;
+		break;
+	case WM8958:
+		regmap_config = &wm8958_regmap_config;
+		break;
+	default:
+		dev_err(wm8994->dev, "Unknown device type %d\n", wm8994->type);
+		return -EINVAL;
+	}
+
+	wm8994->regmap = regmap_init_i2c(i2c, regmap_config);
 	if (IS_ERR(wm8994->regmap)) {
 		ret = PTR_ERR(wm8994->regmap);
 		dev_err(wm8994->dev, "Failed to allocate register map: %d\n",
diff --git a/include/linux/mfd/wm8994/core.h b/include/linux/mfd/wm8994/core.h
index f44bdb7..d98593d 100644
--- a/include/linux/mfd/wm8994/core.h
+++ b/include/linux/mfd/wm8994/core.h
@@ -70,8 +70,6 @@ struct wm8994 {
 
 	/* Used over suspend/resume */
 	bool suspended;
-	u16 ldo_regs[WM8994_NUM_LDO_REGS];
-	u16 gpio_regs[WM8994_NUM_GPIO_REGS];
 
 	struct regulator_dev *dbvdd;
 	int num_supplies;
-- 
1.7.7.3


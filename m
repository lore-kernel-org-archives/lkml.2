Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab2F0OMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:12:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34620 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756868Ab2F0OML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:12:11 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/5] regulator: wm8994: Use core GPIO enable support
Date: Wed, 27 Jun 2012 15:12:05 +0100
Message-Id: <1340806326-30525-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340806326-30525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1340806326-30525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm8994-regulator.c |   67 ++--------------------------------
 1 file changed, 4 insertions(+), 63 deletions(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 7a1fd77..f68abd1 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -26,8 +26,6 @@
 #include <linux/mfd/wm8994/pdata.h>
 
 struct wm8994_ldo {
-	int enable;
-	bool is_enabled;
 	struct regulator_dev *regulator;
 	struct wm8994 *wm8994;
 };
@@ -35,46 +33,7 @@ struct wm8994_ldo {
 #define WM8994_LDO1_MAX_SELECTOR 0x7
 #define WM8994_LDO2_MAX_SELECTOR 0x3
 
-static int wm8994_ldo_enable(struct regulator_dev *rdev)
-{
-	struct wm8994_ldo *ldo = rdev_get_drvdata(rdev);
-
-	/* If we have no soft control assume that the LDO is always enabled. */
-	if (!ldo->enable)
-		return 0;
-
-	gpio_set_value_cansleep(ldo->enable, 1);
-	ldo->is_enabled = true;
-
-	return 0;
-}
-
-static int wm8994_ldo_disable(struct regulator_dev *rdev)
-{
-	struct wm8994_ldo *ldo = rdev_get_drvdata(rdev);
-
-	/* If we have no soft control assume that the LDO is always enabled. */
-	if (!ldo->enable)
-		return -EINVAL;
-
-	gpio_set_value_cansleep(ldo->enable, 0);
-	ldo->is_enabled = false;
-
-	return 0;
-}
-
-static int wm8994_ldo_is_enabled(struct regulator_dev *rdev)
-{
-	struct wm8994_ldo *ldo = rdev_get_drvdata(rdev);
-
-	return ldo->is_enabled;
-}
-
 static struct regulator_ops wm8994_ldo1_ops = {
-	.enable = wm8994_ldo_enable,
-	.disable = wm8994_ldo_disable,
-	.is_enabled = wm8994_ldo_is_enabled,
-
 	.list_voltage = regulator_list_voltage_linear,
 	.map_voltage = regulator_map_voltage_linear,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
@@ -108,9 +67,6 @@ static int wm8994_ldo2_list_voltage(struct regulator_dev *rdev,
 }
 
 static struct regulator_ops wm8994_ldo2_ops = {
-	.enable = wm8994_ldo_enable,
-	.disable = wm8994_ldo_disable,
-	.is_enabled = wm8994_ldo_is_enabled,
 	.enable_time = wm8994_ldo_enable_time,
 
 	.list_voltage = wm8994_ldo2_list_voltage,
@@ -164,39 +120,26 @@ static __devinit int wm8994_ldo_probe(struct platform_device *pdev)
 
 	ldo->wm8994 = wm8994;
 
-	if (pdata->ldo[id].enable && gpio_is_valid(pdata->ldo[id].enable)) {
-		ldo->enable = pdata->ldo[id].enable;
-
-		ret = gpio_request_one(ldo->enable, 0, "WM8994 LDO enable");
-		if (ret < 0) {
-			dev_err(&pdev->dev, "Failed to get enable GPIO: %d\n",
-				ret);
-			goto err;
-		}
-	} else
-		ldo->is_enabled = true;
-
 	config.dev = wm8994->dev;
 	config.driver_data = ldo;
 	config.regmap = wm8994->regmap;
-	if (pdata)
+	if (pdata) {
 		config.init_data = pdata->ldo[id].init_data;
+		config.ena_gpio = pdata->ldo[id].enable;
+	}
 
 	ldo->regulator = regulator_register(&wm8994_ldo_desc[id], &config);
 	if (IS_ERR(ldo->regulator)) {
 		ret = PTR_ERR(ldo->regulator);
 		dev_err(wm8994->dev, "Failed to register LDO%d: %d\n",
 			id + 1, ret);
-		goto err_gpio;
+		goto err;
 	}
 
 	platform_set_drvdata(pdev, ldo);
 
 	return 0;
 
-err_gpio:
-	if (gpio_is_valid(ldo->enable))
-		gpio_free(ldo->enable);
 err:
 	return ret;
 }
@@ -208,8 +151,6 @@ static __devexit int wm8994_ldo_remove(struct platform_device *pdev)
 	platform_set_drvdata(pdev, NULL);
 
 	regulator_unregister(ldo->regulator);
-	if (gpio_is_valid(ldo->enable))
-		gpio_free(ldo->enable);
 
 	return 0;
 }
-- 
1.7.10


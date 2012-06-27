Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab2F0ONF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:13:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34622 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757033Ab2F0OML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:12:11 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/5] regulator: fixed: Use core GPIO enable support
Date: Wed, 27 Jun 2012 15:12:04 +0100
Message-Id: <1340806326-30525-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340806326-30525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1340806326-30525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is essentially the code that was factored out into the core when the
feature was implemented.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/fixed.c |   98 ++++-----------------------------------------
 1 file changed, 8 insertions(+), 90 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index f7b2642..4d12b62 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -35,9 +35,6 @@ struct fixed_voltage_data {
 	struct regulator_desc desc;
 	struct regulator_dev *dev;
 	int microvolts;
-	int gpio;
-	bool enable_high;
-	bool is_enabled;
 };
 
 
@@ -95,33 +92,6 @@ of_get_fixed_voltage_config(struct device *dev)
 	return config;
 }
 
-static int fixed_voltage_is_enabled(struct regulator_dev *dev)
-{
-	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
-
-	return data->is_enabled;
-}
-
-static int fixed_voltage_enable(struct regulator_dev *dev)
-{
-	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
-
-	gpio_set_value_cansleep(data->gpio, data->enable_high);
-	data->is_enabled = true;
-
-	return 0;
-}
-
-static int fixed_voltage_disable(struct regulator_dev *dev)
-{
-	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
-
-	gpio_set_value_cansleep(data->gpio, !data->enable_high);
-	data->is_enabled = false;
-
-	return 0;
-}
-
 static int fixed_voltage_get_voltage(struct regulator_dev *dev)
 {
 	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
@@ -143,14 +113,6 @@ static int fixed_voltage_list_voltage(struct regulator_dev *dev,
 	return data->microvolts;
 }
 
-static struct regulator_ops fixed_voltage_gpio_ops = {
-	.is_enabled = fixed_voltage_is_enabled,
-	.enable = fixed_voltage_enable,
-	.disable = fixed_voltage_disable,
-	.get_voltage = fixed_voltage_get_voltage,
-	.list_voltage = fixed_voltage_list_voltage,
-};
-
 static struct regulator_ops fixed_voltage_ops = {
 	.get_voltage = fixed_voltage_get_voltage,
 	.list_voltage = fixed_voltage_list_voltage,
@@ -187,6 +149,7 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 	}
 	drvdata->desc.type = REGULATOR_VOLTAGE;
 	drvdata->desc.owner = THIS_MODULE;
+	drvdata->desc.ops = &fixed_voltage_ops;
 
 	drvdata->desc.enable_time = config->startup_delay;
 
@@ -194,53 +157,13 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 		drvdata->desc.n_voltages = 1;
 
 	drvdata->microvolts = config->microvolts;
-	drvdata->gpio = config->gpio;
-
-	if (gpio_is_valid(config->gpio)) {
-		int gpio_flag;
-		drvdata->enable_high = config->enable_high;
-
-		/* FIXME: Remove below print warning
-		 *
-		 * config->gpio must be set to -EINVAL by platform code if
-		 * GPIO control is not required. However, early adopters
-		 * not requiring GPIO control may forget to initialize
-		 * config->gpio to -EINVAL. This will cause GPIO 0 to be used
-		 * for GPIO control.
-		 *
-		 * This warning will be removed once there are a couple of users
-		 * for this driver.
-		 */
-		if (!config->gpio)
-			dev_warn(&pdev->dev,
-				"using GPIO 0 for regulator enable control\n");
-
-		/*
-		 * set output direction without changing state
-		 * to prevent glitch
-		 */
-		drvdata->is_enabled = config->enabled_at_boot;
-		ret = drvdata->is_enabled ?
-				config->enable_high : !config->enable_high;
-		gpio_flag = ret ? GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW;
-
-		if (config->gpio_is_open_drain)
-			gpio_flag |= GPIOF_OPEN_DRAIN;
-
-		ret = gpio_request_one(config->gpio, gpio_flag,
-						config->supply_name);
-		if (ret) {
-			dev_err(&pdev->dev,
-			   "Could not obtain regulator enable GPIO %d: %d\n",
-							config->gpio, ret);
-			goto err_name;
-		}
-
-		drvdata->desc.ops = &fixed_voltage_gpio_ops;
 
-	} else {
-		drvdata->desc.ops = &fixed_voltage_ops;
-	}
+	cfg.ena_gpio = config->gpio;
+	cfg.ena_gpio_invert = !config->enable_high;
+	if (config->enabled_at_boot)
+		cfg.ena_gpio_flags |= GPIOF_OUT_INIT_HIGH;
+	if (config->gpio_is_open_drain)
+		cfg.ena_gpio_flags |= GPIOF_OPEN_DRAIN;
 
 	cfg.dev = &pdev->dev;
 	cfg.init_data = config->init_data;
@@ -251,7 +174,7 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 	if (IS_ERR(drvdata->dev)) {
 		ret = PTR_ERR(drvdata->dev);
 		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
-		goto err_gpio;
+		goto err_name;
 	}
 
 	platform_set_drvdata(pdev, drvdata);
@@ -261,9 +184,6 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_gpio:
-	if (gpio_is_valid(config->gpio))
-		gpio_free(config->gpio);
 err_name:
 	kfree(drvdata->desc.name);
 err:
@@ -275,8 +195,6 @@ static int __devexit reg_fixed_voltage_remove(struct platform_device *pdev)
 	struct fixed_voltage_data *drvdata = platform_get_drvdata(pdev);
 
 	regulator_unregister(drvdata->dev);
-	if (gpio_is_valid(drvdata->gpio))
-		gpio_free(drvdata->gpio);
 	kfree(drvdata->desc.name);
 
 	return 0;
-- 
1.7.10


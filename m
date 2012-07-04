Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203Ab2GDCUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 22:20:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45018 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab2GDCUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 22:20:52 -0400
Message-ID: <1341368446.10587.6.camel@phoenix>
Subject: [PATCH RFT 2/2] regulator: gpio-regulator: Use core GPIO enable
 support
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Wed, 04 Jul 2012 10:20:46 +0800
In-Reply-To: <1341368386.10587.5.camel@phoenix>
References: <1341368386.10587.5.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/gpio-regulator.c |  103 ++++++------------------------------
 1 file changed, 16 insertions(+), 87 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 3ed8d15..34b67be 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -36,10 +36,6 @@ struct gpio_regulator_data {
 	struct regulator_desc desc;
 	struct regulator_dev *dev;
 
-	int enable_gpio;
-	bool enable_high;
-	bool is_enabled;
-
 	struct gpio *gpios;
 	int nr_gpios;
 
@@ -49,37 +45,6 @@ struct gpio_regulator_data {
 	int state;
 };
 
-static int gpio_regulator_is_enabled(struct regulator_dev *dev)
-{
-	struct gpio_regulator_data *data = rdev_get_drvdata(dev);
-
-	return data->is_enabled;
-}
-
-static int gpio_regulator_enable(struct regulator_dev *dev)
-{
-	struct gpio_regulator_data *data = rdev_get_drvdata(dev);
-
-	if (gpio_is_valid(data->enable_gpio)) {
-		gpio_set_value_cansleep(data->enable_gpio, data->enable_high);
-		data->is_enabled = true;
-	}
-
-	return 0;
-}
-
-static int gpio_regulator_disable(struct regulator_dev *dev)
-{
-	struct gpio_regulator_data *data = rdev_get_drvdata(dev);
-
-	if (gpio_is_valid(data->enable_gpio)) {
-		gpio_set_value_cansleep(data->enable_gpio, !data->enable_high);
-		data->is_enabled = false;
-	}
-
-	return 0;
-}
-
 static int gpio_regulator_get_value(struct regulator_dev *dev)
 {
 	struct gpio_regulator_data *data = rdev_get_drvdata(dev);
@@ -145,18 +110,12 @@ static int gpio_regulator_set_current_limit(struct regulator_dev *dev,
 }
 
 static struct regulator_ops gpio_regulator_voltage_ops = {
-	.is_enabled = gpio_regulator_is_enabled,
-	.enable = gpio_regulator_enable,
-	.disable = gpio_regulator_disable,
 	.get_voltage = gpio_regulator_get_value,
 	.set_voltage = gpio_regulator_set_voltage,
 	.list_voltage = gpio_regulator_list_voltage,
 };
 
 static struct regulator_ops gpio_regulator_current_ops = {
-	.is_enabled = gpio_regulator_is_enabled,
-	.enable = gpio_regulator_enable,
-	.disable = gpio_regulator_disable,
 	.get_current_limit = gpio_regulator_get_value,
 	.set_current_limit = gpio_regulator_set_current_limit,
 };
@@ -223,51 +182,12 @@ static int __devinit gpio_regulator_probe(struct platform_device *pdev)
 		break;
 	}
 
-	drvdata->enable_gpio = config->enable_gpio;
-
-	if (gpio_is_valid(config->enable_gpio)) {
-		drvdata->enable_high = config->enable_high;
-
-		ret = gpio_request(config->enable_gpio, config->supply_name);
-		if (ret) {
-			dev_err(&pdev->dev,
-			   "Could not obtain regulator enable GPIO %d: %d\n",
-						config->enable_gpio, ret);
-			goto err_memstate;
-		}
-
-		/* set output direction without changing state
-		 * to prevent glitch
-		 */
-		if (config->enabled_at_boot) {
-			drvdata->is_enabled = true;
-			ret = gpio_direction_output(config->enable_gpio,
-						    config->enable_high);
-		} else {
-			drvdata->is_enabled = false;
-			ret = gpio_direction_output(config->enable_gpio,
-						    !config->enable_high);
-		}
-
-		if (ret) {
-			dev_err(&pdev->dev,
-			   "Could not configure regulator enable GPIO %d direction: %d\n",
-						config->enable_gpio, ret);
-			goto err_enablegpio;
-		}
-	} else {
-		/* Regulator without GPIO control is considered
-		 * always enabled
-		 */
-		drvdata->is_enabled = true;
-	}
-
 	drvdata->nr_gpios = config->nr_gpios;
 	ret = gpio_request_array(drvdata->gpios, drvdata->nr_gpios);
 	if (ret) {
 		dev_err(&pdev->dev,
 		   "Could not obtain regulator setting GPIOs: %d\n", ret);
-		goto err_enablegpio;
+		goto err_memstate;
 	}
 
 	/* build initial state from gpio init data. */
@@ -282,6 +202,21 @@ static int __devinit gpio_regulator_probe(struct platform_device *pdev)
 	cfg.init_data = config->init_data;
 	cfg.driver_data = drvdata;
 
+	if (config->enable_gpio >= 0)
+		cfg.ena_gpio = config->enable_gpio;
+	cfg.ena_gpio_invert = !config->enable_high;
+	if (config->enabled_at_boot) {
+		if (config->enable_high)
+			cfg.ena_gpio_flags |= GPIOF_OUT_INIT_HIGH;
+		else
+			cfg.ena_gpio_flags |= GPIOF_OUT_INIT_LOW;
+	} else {
+		if (config->enable_high)
+			cfg.ena_gpio_flags |= GPIOF_OUT_INIT_LOW;
+		else
+			cfg.ena_gpio_flags |= GPIOF_OUT_INIT_HIGH;
+	}
+
 	drvdata->dev = regulator_register(&drvdata->desc, &cfg);
 	if (IS_ERR(drvdata->dev)) {
 		ret = PTR_ERR(drvdata->dev);
@@ -295,9 +230,6 @@ static int __devinit gpio_regulator_probe(struct platform_device *pdev)
 
 err_stategpio:
 	gpio_free_array(drvdata->gpios, drvdata->nr_gpios);
-err_enablegpio:
-	if (gpio_is_valid(config->enable_gpio))
-		gpio_free(config->enable_gpio);
 err_memstate:
 	kfree(drvdata->states);
 err_memgpio:
@@ -319,9 +251,6 @@ static int __devexit gpio_regulator_remove(struct platform_device *pdev)
 	kfree(drvdata->states);
 	kfree(drvdata->gpios);
 
-	if (gpio_is_valid(drvdata->enable_gpio))
-		gpio_free(drvdata->enable_gpio);
-
 	kfree(drvdata->desc.name);
 
 	return 0;
-- 
1.7.9.5




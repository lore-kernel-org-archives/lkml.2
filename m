Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab2JONRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 09:17:09 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43018 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2JONRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 09:17:05 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regulator: gpio-regulator: Allow use of GPIO controlled regulators though DT
Date: Mon, 15 Oct 2012 14:16:59 +0100
Message-Id: <1350307020-5910-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we provide the GPIO Regulator driver with Device Tree capability, so
that when a platform is booting with DT instead of platform data we can
still make full use of it.

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/gpio-regulator.c |   94 ++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 8b5944f..e467d0a 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -28,9 +28,12 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/regulator/gpio-regulator.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
 
 struct gpio_regulator_data {
 	struct regulator_desc desc;
@@ -129,6 +132,84 @@ static struct regulator_ops gpio_regulator_voltage_ops = {
 	.list_voltage = gpio_regulator_list_voltage,
 };
 
+struct gpio_regulator_config *
+of_get_gpio_regulator_config(struct device *dev, struct device_node *np)
+{
+	struct gpio_regulator_config *config;
+	struct property *prop;
+	const char *regtype;
+	int proplen, gpio, i;
+
+	config = devm_kzalloc(dev,
+			sizeof(struct gpio_regulator_config),
+			GFP_KERNEL);
+	if (!config)
+		return ERR_PTR(-ENOMEM);
+
+	config->init_data = of_get_regulator_init_data(dev, np);
+	if (!config->init_data)
+		return ERR_PTR(-EINVAL);
+
+	config->supply_name = config->init_data->constraints.name;
+
+	if (of_property_read_bool(np, "enable-active-high"))
+		config->enable_high = true;
+
+	if (of_property_read_bool(np, "enable-at-boot"))
+		config->enabled_at_boot = true;
+
+	of_property_read_u32(np, "startup-delay-us", &config->startup_delay);
+
+	config->enable_gpio = of_get_named_gpio(np, "enable-gpio", 0);
+
+	/* Fetch GPIOs. */
+	for (i = 0; ; i++)
+		if (of_get_named_gpio(np, "gpios", i) < 0)
+			break;
+	config->nr_gpios = i;
+
+	config->gpios = devm_kzalloc(dev,
+				sizeof(struct gpio) * config->nr_gpios,
+				GFP_KERNEL);
+	if (!config->gpios)
+		return ERR_PTR(-ENOMEM);
+
+	for (i = 0; config->nr_gpios; i++) {
+		gpio = of_get_named_gpio(np, "gpios", i);
+		if (gpio < 0)
+			break;
+		config->gpios[i].gpio = gpio;
+	}
+
+	/* Fetch states. */
+	prop = of_find_property(np, "states", NULL);
+	proplen = prop->length / sizeof(int);
+
+	config->states = devm_kzalloc(dev,
+				sizeof(struct gpio_regulator_state)
+				* (proplen / 2),
+				GFP_KERNEL);
+	if (!config->states)
+		return ERR_PTR(-ENOMEM);
+
+	for (i = 0; i < proplen / 2; i++) {
+		config->states[i].value =
+			be32_to_cpup((int *)prop->value + (i * 2));
+		config->states[i].gpios =
+			be32_to_cpup((int *)prop->value + (i * 2 + 1));
+	}
+	config->nr_states = i;
+
+	of_property_read_string(np, "regulator-type", &regtype);
+
+	if (!strncmp("voltage", regtype, 7))
+		config->type = REGULATOR_VOLTAGE;
+	else if (!strncmp("current", regtype, 7))
+		config->type = REGULATOR_CURRENT;
+
+	return config;
+}
+
 static struct regulator_ops gpio_regulator_current_ops = {
 	.get_current_limit = gpio_regulator_get_value,
 	.set_current_limit = gpio_regulator_set_current_limit,
@@ -137,10 +218,17 @@ static struct regulator_ops gpio_regulator_current_ops = {
 static int __devinit gpio_regulator_probe(struct platform_device *pdev)
 {
 	struct gpio_regulator_config *config = pdev->dev.platform_data;
+	struct device_node *np = pdev->dev.of_node;
 	struct gpio_regulator_data *drvdata;
 	struct regulator_config cfg = { };
 	int ptr, ret, state;
 
+	if (np) {
+		config = of_get_gpio_regulator_config(&pdev->dev, np);
+		if (IS_ERR(config))
+			return PTR_ERR(config);
+	}
+
 	drvdata = devm_kzalloc(&pdev->dev, sizeof(struct gpio_regulator_data),
 			       GFP_KERNEL);
 	if (drvdata == NULL) {
@@ -270,12 +358,18 @@ static int __devexit gpio_regulator_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id regulator_gpio_of_match[] __devinitconst = {
+	{ .compatible = "regulator-gpio", },
+	{},
+};
+
 static struct platform_driver gpio_regulator_driver = {
 	.probe		= gpio_regulator_probe,
 	.remove		= __devexit_p(gpio_regulator_remove),
 	.driver		= {
 		.name		= "gpio-regulator",
 		.owner		= THIS_MODULE,
+		.of_match_table = regulator_gpio_of_match,
 	},
 };
 
-- 
1.7.9.5


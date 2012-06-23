Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab2FWM34 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 08:29:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41147 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753201Ab2FWM33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 08:29:29 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] gpiolib: Add support for Wolfson Microelectronics Arizona class devices
Date: Sat, 23 Jun 2012 13:29:25 +0100
Message-Id: <1340454566-7206-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Arizona class devices provide some GPIOs for use in the system. This
driver provides support for these via gpiolib. Currently interrupts are
not supported, normally the GPIOs are outputs only.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/gpio/Kconfig        |    6 ++
 drivers/gpio/Makefile       |    1 +
 drivers/gpio/gpio-arizona.c |  162 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 169 insertions(+)
 create mode 100644 drivers/gpio/gpio-arizona.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index c4067d0..9c713e9 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -253,6 +253,12 @@ config GPIO_GE_FPGA
 
 comment "I2C GPIO expanders:"
 
+config GPIO_ARIZONA
+	tristate "Wolfson Microelectronics Arizona class devices"
+	depends on MFD_ARIZONA
+	help
+	  Support for GPIOs on Wolfson Arizona class devices.
+
 config GPIO_MAX7300
 	tristate "Maxim MAX7300 GPIO expander"
 	depends on I2C
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 0f55662..e173970 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_GPIO_74X164)	+= gpio-74x164.o
 obj-$(CONFIG_GPIO_AB8500)	+= gpio-ab8500.o
 obj-$(CONFIG_GPIO_ADP5520)	+= gpio-adp5520.o
 obj-$(CONFIG_GPIO_ADP5588)	+= gpio-adp5588.o
+obj-$(CONFIG_GPIO_ARIZONA)	+= gpio-arizona.o
 obj-$(CONFIG_GPIO_BT8XX)	+= gpio-bt8xx.o
 obj-$(CONFIG_GPIO_CS5535)	+= gpio-cs5535.o
 obj-$(CONFIG_GPIO_DA9052)	+= gpio-da9052.o
diff --git a/drivers/gpio/gpio-arizona.c b/drivers/gpio/gpio-arizona.c
new file mode 100644
index 0000000..0c1becf
--- /dev/null
+++ b/drivers/gpio/gpio-arizona.c
@@ -0,0 +1,162 @@
+/*
+ * gpiolib support for Wolfson Arizona class devices
+ *
+ * Copyright 2012 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/gpio.h>
+#include <linux/platform_device.h>
+#include <linux/seq_file.h>
+
+#include <linux/mfd/arizona/core.h>
+#include <linux/mfd/arizona/pdata.h>
+#include <linux/mfd/arizona/registers.h>
+
+struct arizona_gpio {
+	struct arizona *arizona;
+	struct gpio_chip gpio_chip;
+};
+
+static inline struct arizona_gpio *to_arizona_gpio(struct gpio_chip *chip)
+{
+	return container_of(chip, struct arizona_gpio, gpio_chip);
+}
+
+static int arizona_gpio_direction_in(struct gpio_chip *chip, unsigned offset)
+{
+	struct arizona_gpio *arizona_gpio = to_arizona_gpio(chip);
+	struct arizona *arizona = arizona_gpio->arizona;
+
+	return regmap_update_bits(arizona->regmap, ARIZONA_GPIO1_CTRL + offset,
+				  ARIZONA_GPN_DIR, ARIZONA_GPN_DIR);
+}
+
+static int arizona_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct arizona_gpio *arizona_gpio = to_arizona_gpio(chip);
+	struct arizona *arizona = arizona_gpio->arizona;
+	unsigned int val;
+	int ret;
+
+	ret = regmap_read(arizona->regmap, ARIZONA_GPIO1_CTRL + offset, &val);
+	if (ret < 0)
+		return ret;
+
+	if (val & ARIZONA_GPN_LVL)
+		return 1;
+	else
+		return 0;
+}
+
+static int arizona_gpio_direction_out(struct gpio_chip *chip,
+				     unsigned offset, int value)
+{
+	struct arizona_gpio *arizona_gpio = to_arizona_gpio(chip);
+	struct arizona *arizona = arizona_gpio->arizona;
+
+	if (value)
+		value = ARIZONA_GPN_LVL;
+
+	return regmap_update_bits(arizona->regmap, ARIZONA_GPIO1_CTRL + offset,
+				  ARIZONA_GPN_DIR | ARIZONA_GPN_LVL, value);
+}
+
+static void arizona_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct arizona_gpio *arizona_gpio = to_arizona_gpio(chip);
+	struct arizona *arizona = arizona_gpio->arizona;
+
+	if (value)
+		value = ARIZONA_GPN_LVL;
+
+	regmap_update_bits(arizona->regmap, ARIZONA_GPIO1_CTRL + offset,
+			   ARIZONA_GPN_LVL, value);
+}
+
+static struct gpio_chip template_chip = {
+	.label			= "arizona",
+	.owner			= THIS_MODULE,
+	.direction_input	= arizona_gpio_direction_in,
+	.get			= arizona_gpio_get,
+	.direction_output	= arizona_gpio_direction_out,
+	.set			= arizona_gpio_set,
+	.can_sleep		= 1,
+};
+
+static int __devinit arizona_gpio_probe(struct platform_device *pdev)
+{
+	struct arizona *arizona = dev_get_drvdata(pdev->dev.parent);
+	struct arizona_pdata *pdata = arizona->dev->platform_data;
+	struct arizona_gpio *arizona_gpio;
+	int ret;
+
+	arizona_gpio = devm_kzalloc(&pdev->dev, sizeof(*arizona_gpio),
+				    GFP_KERNEL);
+	if (arizona_gpio == NULL)
+		return -ENOMEM;
+
+	arizona_gpio->arizona = arizona;
+	arizona_gpio->gpio_chip = template_chip;
+	arizona_gpio->gpio_chip.dev = &pdev->dev;
+
+	switch (arizona->type) {
+	case WM5102:
+		arizona_gpio->gpio_chip.ngpio = 5;
+		break;
+	default:
+		dev_err(&pdev->dev, "Unknown chip variant %d\n",
+			arizona->type);
+		return -EINVAL;
+	}
+
+	if (pdata && pdata->gpio_base)
+		arizona_gpio->gpio_chip.base = pdata->gpio_base;
+	else
+		arizona_gpio->gpio_chip.base = -1;
+
+	ret = gpiochip_add(&arizona_gpio->gpio_chip);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Could not register gpiochip, %d\n",
+			ret);
+		goto err;
+	}
+
+	platform_set_drvdata(pdev, arizona_gpio);
+
+	return ret;
+
+err:
+	return ret;
+}
+
+static int __devexit arizona_gpio_remove(struct platform_device *pdev)
+{
+	struct arizona_gpio *arizona_gpio = platform_get_drvdata(pdev);
+
+	return gpiochip_remove(&arizona_gpio->gpio_chip);
+}
+
+static struct platform_driver arizona_gpio_driver = {
+	.driver.name	= "arizona-gpio",
+	.driver.owner	= THIS_MODULE,
+	.probe		= arizona_gpio_probe,
+	.remove		= __devexit_p(arizona_gpio_remove),
+};
+
+module_platform_driver(arizona_gpio_driver);
+
+MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
+MODULE_DESCRIPTION("GPIO interface for Arizona devices");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:arizona-gpio");
-- 
1.7.10


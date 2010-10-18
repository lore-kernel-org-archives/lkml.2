Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab0JRTdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:33:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55938 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab0JRTdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:33:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-tuid:x-uid:x-length:to
         :reply-to:content-type:content-transfer-encoding:message-id;
        b=KaPm6oqDiTmvc28aClctkQVe7fMwXTlpMP3Tztz2cMlG7ewcefqfJO4aI0iF4C6EOy
         D48hE1mlUemOk1AQ+HaUfRv6+/GtsKuJlboyjaoA2IFGyxu2nv8LAThyVziGccEKvwPF
         7ZEfbrIh2t7Cb/qA34QEPBZtIzY2o4yOvLge8=
From: Florian Fainelli <florian@openwrt.org>
Date: Mon, 18 Oct 2010 21:35:07 +0200
Subject: [PATCH v5] GPIO: add support for 74x164 serial-in/parallel-out 8-bit shift register
MIME-Version: 1.0
X-TUID: b6cdfa41c9a4789e
X-Length: 7641
To: David Brownell <david-b@pacbell.net>, Willy Tarreau <w@1wt.eu>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Miguel Gaio <miguel.gaio@efixo.com>, dbrownell@users.sourceforge.net,
        Juhos Gabor <juhosg@openwrt.org>
Reply-To: Florian Fainelli <florian@openwrt.org>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010182135.09506.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miguel Gaio <miguel.gaio@efixo.com>

This patch adds support for generic 74x164 serial-in/parallel-out 8-bits
shift register. This driver can be used as a GPIO output expander.

Signed-off-by: Miguel Gaio <miguel.gaio@efixo.com>
Signed-off-by: Juhos Gabor <juhosg@openwrt.org>
Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
Changes since v1:
- renamed nxp_ to gen_ since this driver is generic to all 74HC164 chips
- added comment on this driver not handling the 74HC164 daisy-chaining
- renamed misused GPIO expanders to Shift registers

Changes since v2:
- rename 74hc164 to 74x164

Changes since v3:
- support daisy-chaining of 74x164 up to 32 gpios

Changes since v4:
- converted to a SPI device driver

diff --git a/drivers/gpio/74x164.c b/drivers/gpio/74x164.c
new file mode 100644
index 0000000..ebb183f
--- /dev/null
+++ b/drivers/gpio/74x164.c
@@ -0,0 +1,184 @@
+/*
+ *  74Hx164 - Generic serial-in/parallel-out 8-bits shift register GPIO driver
+ *
+ *  Copyright (C) 2010 Gabor Juhos <juhosg@openwrt.org>
+ *  Copyright (C) 2010 Miguel Gaio <miguel.gaio@efixo.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/mutex.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/74x164.h>
+#include <linux/gpio.h>
+#include <linux/slab.h>
+
+#define GEN_74X164_GPIO_COUNT	8
+
+
+struct gen_74x164_chip {
+	struct spi_device	*spi;
+	struct gpio_chip	gpio_chip;
+	struct mutex		lock;
+	u8			port_config;
+};
+
+static void gen_74x164_set_value(struct gpio_chip *, unsigned, int);
+
+static struct gen_74x164_chip *gpio_to_chip(struct gpio_chip *gc)
+{
+	return container_of(gc, struct gen_74x164_chip, gpio_chip);
+}
+
+static int __gen_74x164_write_config(struct gen_74x164_chip *chip)
+{
+	return spi_write(chip->spi,
+			 &chip->port_config, sizeof(chip->port_config));
+}
+
+static int gen_74x164_direction_output(struct gpio_chip *gc,
+		unsigned offset, int val)
+{
+	gen_74x164_set_value(gc, offset, val);
+	return 0;
+}
+
+static int gen_74x164_get_value(struct gpio_chip *gc, unsigned offset)
+{
+	struct gen_74x164_chip *chip = gpio_to_chip(gc);
+	int ret;
+
+	mutex_lock(&chip->lock);
+	ret = (chip->port_config >> offset) & 0x1;
+	mutex_unlock(&chip->lock);
+
+	return ret;
+}
+
+static void gen_74x164_set_value(struct gpio_chip *gc,
+		unsigned offset, int val)
+{
+	struct gen_74x164_chip *chip = gpio_to_chip(gc);
+	bool refresh;
+
+	mutex_lock(&chip->lock);
+	if (val)
+		chip->port_config |= (1 << offset);
+	else
+		chip->port_config &= ~(1 << offset);
+
+	__gen_74x164_write_config(chip);
+	mutex_unlock(&chip->lock);
+}
+
+static int __devinit gen_74x164_probe(struct spi_device *spi)
+{
+	struct gen_74x164_chip *chip;
+	struct gen_74x164_chip_platform_data *pdata;
+	int ret;
+
+	pdata = spi->dev.platform_data;
+	if (!pdata || !pdata->base) {
+		dev_dbg(&spi->dev, "incorrect or missing platform data\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * bits_per_word cannot be configured in platform data
+	 */
+	spi->bits_per_word = 8;
+
+	ret = spi_setup(spi);
+	if (ret < 0)
+		return ret;
+
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	mutex_init(&chip->lock);
+
+	dev_set_drvdata(&spi->dev, chip);
+
+	chip->spi = spi;
+
+	chip->gpio_chip.label = GEN_74X164_DRIVER_NAME,
+		chip->gpio_chip.direction_output = gen_74x164_direction_output;
+	chip->gpio_chip.get = gen_74x164_get_value;
+	chip->gpio_chip.set = gen_74x164_set_value;
+	chip->gpio_chip.base = pdata->base;
+	chip->gpio_chip.ngpio = GEN_74X164_GPIO_COUNT;
+	chip->gpio_chip.can_sleep = 1;
+	chip->gpio_chip.dev = &spi->dev;
+	chip->gpio_chip.owner = THIS_MODULE;
+
+	ret = __gen_74x164_write_config(chip);
+	if (ret) {
+		dev_err(&spi->dev, "Failed writing: %d\n", ret);
+		goto exit_destroy;
+	}
+
+	ret = gpiochip_add(&chip->gpio_chip);
+	if (ret)
+		goto exit_destroy;
+
+	return ret;
+
+exit_destroy:
+	dev_set_drvdata(&spi->dev, NULL);
+	mutex_destroy(&chip->lock);
+	kfree(chip);
+	return ret;
+}
+
+static int gen_74x164_remove(struct spi_device *spi)
+{
+	struct gen_74x164_chip *chip;
+	int ret;
+
+	chip = dev_get_drvdata(&spi->dev);
+	if (chip == NULL)
+		return -ENODEV;
+
+	dev_set_drvdata(&spi->dev, NULL);
+
+	ret = gpiochip_remove(&chip->gpio_chip);
+	if (!ret) {
+		mutex_destroy(&chip->lock);
+		kfree(chip);
+	} else
+		dev_err(&spi->dev, "Failed to remove the GPIO controller: %d\n",
+				ret);
+
+	return ret;
+}
+
+static struct spi_driver gen_74x164_driver = {
+	.driver = {
+		.name		= GEN_74X164_DRIVER_NAME,
+		.owner		= THIS_MODULE,
+	},
+	.probe		= gen_74x164_probe,
+	.remove		= __devexit_p(gen_74x164_remove),
+};
+
+static int __init gen_74x164_init(void)
+{
+	return spi_register_driver(&gen_74x164_driver);
+}
+subsys_initcall(gen_74x164_init);
+
+static void __exit gen_74x164_exit(void)
+{
+	spi_unregister_driver(&gen_74x164_driver);
+}
+module_exit(gen_74x164_exit);
+
+MODULE_AUTHOR("Gabor Juhos <juhosg@openwrt.org>");
+MODULE_AUTHOR("Miguel Gaio <miguel.gaio@efixo.com>");
+MODULE_DESCRIPTION("GPIO expander driver for 74X164 8-bits shift register");
+MODULE_LICENSE("GPL v2");
+
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 510aa20..614965c 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -339,6 +339,14 @@ config GPIO_MC33880
 	  SPI driver for Freescale MC33880 high-side/low-side switch.
 	  This provides GPIO interface supporting inputs and outputs.
 
+config GPIO_74X164
+	tristate "74x164 serial-in/parallel-out 8-bits shift register"
+	depends on SPI_MASTER
+	help
+	  Platform driver for 74x164 compatible serial-in/parallel-out
+	  8-outputs shift registers. This driver can be used to provide access
+	  to more gpio outputs.
+
 comment "AC97 GPIO expanders:"
 
 config GPIO_UCB1400
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index fc6019d..60456a4 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_GPIO_MAX7301)	+= max7301.o
 obj-$(CONFIG_GPIO_MAX732X)	+= max732x.o
 obj-$(CONFIG_GPIO_MC33880)	+= mc33880.o
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
+obj-$(CONFIG_GPIO_74X164)	+= 74x164.o
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
 obj-$(CONFIG_GPIO_PL061)	+= pl061.o
diff --git a/include/linux/spi/74x164.h b/include/linux/spi/74x164.h
new file mode 100644
index 0000000..d85c52f
--- /dev/null
+++ b/include/linux/spi/74x164.h
@@ -0,0 +1,11 @@
+#ifndef LINUX_SPI_74X164_H
+#define LINUX_SPI_74X164_H
+
+#define GEN_74X164_DRIVER_NAME "74x164"
+
+struct gen_74x164_chip_platform_data {
+	/* number assigned to the first GPIO */
+	unsigned	base;
+};
+
+#endif



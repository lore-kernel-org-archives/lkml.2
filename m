Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab1DMLtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 07:49:32 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:1726
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096Ab1DMLtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 07:49:31 -0400
X-SpamScore: 1
X-BigFish: VPS1(zz936eKc8kzz1202hzz8275bh84d07hz32i2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:kcinpunhjhc02.kpit.com;RD:none;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <Dajun.Chen@diasemi.com>
Date: Wed, 13 Apr 2011 17:19:14 +0530
Subject: [PATCHv1 2/11] GPIO: GPIO module of DA9052 PMIC driver
Thread-Topic: [PATCHv1 2/11] GPIO: GPIO module of DA9052 PMIC driver
Thread-Index: Acv50M/ldITI2MAbQQiXIJvbc8E0+A==
Message-ID: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B6196E2@KCINPUNHJCMS01.kpit.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3DBnbOZ011188

Hi Mark,

GPIO Driver for Dialog Semiconductor DA9052 PMICs.

Changes made since last submission:
. Ported the driver to Linux kernel 2.6.38.2

Linux Kernel Version: 2.6.38.2

Signed-off-by: D. Chen <dchen@diasemi.com>
---
diff -Naur linux-2.6.38.2/drivers/gpio/da9052-gpio.c wrk_linux-2.6.38.2/drivers/gpio/da9052-gpio.c
--- linux-2.6.38.2/drivers/gpio/da9052-gpio.c	1970-01-01 05:00:00.000000000 +0500
+++ wrk_linux-2.6.38.2/drivers/gpio/da9052-gpio.c	2011-04-13 11:20:47.000000000 +0500
@@ -0,0 +1,258 @@
+/*
+ * GPIO Driver for Dialog DA9052 PMICs
+ *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * Author: Dajun Chen <dchen@diasemi.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/uaccess.h>
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/syscalls.h>
+#include <linux/seq_file.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/pdata.h>
+#include <linux/mfd/da9052/gpio.h>
+
+struct da9052_gpio {
+	struct da9052 *da9052;
+	struct gpio_chip gp;
+};
+
+static inline struct da9052_gpio *to_da9052_gpio(struct gpio_chip *chip)
+{
+	return container_of(chip, struct da9052_gpio, gp);
+}
+
+static unsigned char da9052_gpio_port_odd(unsigned offset)
+{
+	return offset % 2;
+}
+
+static int da9052_gpio_get(struct gpio_chip *gc, unsigned offset)
+{
+	struct da9052_gpio *gpio = to_da9052_gpio(gc);
+	int ret;
+	int da9052_port_direction = 0;
+
+	ret =  da9052_reg_read(gpio->da9052,
+				DA9052_GPIO_0_1_REG + (offset >> 1));
+	if (ret < 0)
+		return ret;
+
+	if (da9052_gpio_port_odd(offset)) {
+		da9052_port_direction = ret & DA9052_GPIO_ODD_PORT_PIN;
+		da9052_port_direction >>= 4;
+		}
+	else
+		da9052_port_direction = ret & DA9052_GPIO_EVEN_PORT_PIN;
+
+	switch (da9052_port_direction) {
+	case DA9052_INPUT:
+		if (offset < DA9052_GPIO_MAX_PORTS_PER_REGISTER)
+			ret = da9052_reg_read(gpio->da9052,
+							DA9052_STATUS_C_REG);
+		else
+			ret = da9052_reg_read(gpio->da9052,
+							DA9052_STATUS_D_REG);
+		if (ret < 0)
+			return ret;
+		if (ret & (1 << DA9052_GPIO_SHIFT_COUNT(offset)))
+			return 1;
+		else
+			return 0;
+	case DA9052_OUTPUT_PUSHPULL:
+		if (da9052_gpio_port_odd(offset))
+			return ret & DA9052_GPIO_ODD_PORT_MODE;
+		else
+			return ret & DA9052_GPIO_EVEN_PORT_MODE;
+	default:
+		return -EINVAL;
+	}
+
+}
+
+static void da9052_gpio_set(struct gpio_chip *gc, unsigned offset, int value)
+{
+	struct da9052_gpio *gpio = to_da9052_gpio(gc);
+	int ret;
+	unsigned char register_value = 0;
+
+	if (da9052_gpio_port_odd(offset)) {
+		if (value)
+			register_value = DA9052_GPIO_ODD_PORT_MODE;
+			ret = da9052_reg_update(gpio->da9052, (offset >> 1) +
+						DA9052_GPIO_0_1_REG,
+						 DA9052_GPIO_ODD_PORT_MODE,
+						register_value);
+			if (ret != 0)
+				dev_err(gpio->da9052->dev,
+						"Failed to updated gpio odd reg,%d",
+						ret);
+	} else {
+		if (value)
+			register_value = DA9052_GPIO_EVEN_PORT_MODE;
+			ret = da9052_reg_update(gpio->da9052, (offset >> 1) +
+						DA9052_GPIO_0_1_REG,
+						DA9052_GPIO_EVEN_PORT_MODE,
+						register_value);
+			if (ret != 0)
+				dev_err(gpio->da9052->dev,
+				"Failed to updated gpio even reg,%d",
+				ret);
+	}
+}
+
+static int da9052_gpio_direction_input(struct gpio_chip *gc, unsigned offset)
+{
+	struct da9052_gpio *gpio = to_da9052_gpio(gc);
+	unsigned char register_value;
+	int ret;
+
+	/* Format: function - 2 bits type - 1 bit mode - 1 bit */
+	register_value = DA9052_INPUT | DA9052_ACTIVE_LOW << 2 |
+			 DA9052_DEBOUNCING_ON << 3;
+
+	if (da9052_gpio_port_odd(offset))
+		ret = da9052_reg_update(gpio->da9052, (offset >> 1) +
+				DA9052_GPIO_0_1_REG,
+				DA9052_GPIO_MASK_UPPER_NIBBLE,
+				register_value <<
+				DA9052_GPIO_NIBBLE_SHIFT);
+	else
+		ret = da9052_reg_update(gpio->da9052, (offset >> 1) +
+				DA9052_GPIO_0_1_REG,
+				DA9052_GPIO_MASK_LOWER_NIBBLE,
+				register_value);
+
+	return ret;
+}
+
+static int da9052_gpio_direction_output(struct gpio_chip *gc,
+					unsigned offset, int value)
+{
+	struct da9052_gpio *gpio = to_da9052_gpio(gc);
+	unsigned char register_value;
+	int ret;
+
+	/* Format: Function - 2 bits Type - 1 bit Mode - 1 bit */
+	register_value = DA9052_OUTPUT_PUSHPULL | DA9052_SUPPLY_VDD_IO1 << 2 |
+			 value << 3;
+
+	if (da9052_gpio_port_odd(offset))
+		ret = da9052_reg_update(gpio->da9052, (offset >> 1) +
+				DA9052_GPIO_0_1_REG,
+				DA9052_GPIO_MASK_UPPER_NIBBLE,
+				register_value <<
+				DA9052_GPIO_NIBBLE_SHIFT);
+	else
+		ret = da9052_reg_update(gpio->da9052, (offset >> 1) +
+				DA9052_GPIO_0_1_REG,
+				DA9052_GPIO_MASK_LOWER_NIBBLE,
+				register_value);
+
+	return ret;
+}
+
+static int da9052_gpio_to_irq(struct gpio_chip *gc, u32 offset)
+{
+	struct da9052_gpio *gpio;
+	gpio = to_da9052_gpio(gc);
+
+	return gpio->gp.base + offset;
+}
+
+static int __devinit da9052_gpio_probe(struct platform_device *pdev)
+{
+
+	struct da9052_gpio *gpio;
+	struct da9052_pdata *pdata;
+	int ret;
+
+	gpio = kzalloc(sizeof(*gpio), GFP_KERNEL);
+	if (gpio == NULL)
+		return -ENOMEM;
+
+	gpio->da9052 = dev_get_drvdata(pdev->dev.parent);
+	pdata = gpio->da9052->dev->platform_data;
+
+	if (pdata == NULL) {
+		dev_err(&pdev->dev, "failed no platform data for GPIO\n");
+		ret = -ENOMEM;
+		goto err_mem;
+	}
+
+	gpio->da9052			= dev_get_drvdata(pdev->dev.parent);
+	gpio->gp.get			= da9052_gpio_get;
+	gpio->gp.set			= da9052_gpio_set;
+	gpio->gp.base			= pdata->gpio_base;
+	gpio->gp.ngpio			= pdata->num_gpio;
+	gpio->gp.can_sleep		= 1;
+	gpio->gp.to_irq			= da9052_gpio_to_irq;
+	gpio->gp.dev			= &pdev->dev;
+	gpio->gp.owner			= THIS_MODULE;
+	gpio->gp.label			= "da9052-gpio";
+	gpio->gp.direction_input	= da9052_gpio_direction_input;
+	gpio->gp.direction_output	= da9052_gpio_direction_output;
+
+	ret = gpiochip_add(&gpio->gp);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Could not register gpiochip, %d\n",
+				ret);
+		goto err_mem;
+	}
+	platform_set_drvdata(pdev, gpio);
+
+	return 0;
+
+err_mem:
+	kfree(gpio);
+	return ret;
+}
+
+static int __devexit da9052_gpio_remove(struct platform_device *pdev)
+{
+	struct da9052_gpio *gpio = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = gpiochip_remove(&gpio->gp);
+	if (ret == 0)
+		kfree(gpio);
+
+	return ret;
+}
+
+static struct platform_driver da9052_gpio_driver = {
+	.driver.name	= "da9052-gpio",
+	.driver.owner	= THIS_MODULE,
+	.probe		= da9052_gpio_probe,
+	.remove		= __devexit_p(da9052_gpio_remove),
+};
+
+static int __init da9052_gpio_init(void)
+{
+	return platform_driver_register(&da9052_gpio_driver);
+}
+
+static void __exit da9052_gpio_exit(void)
+{
+	return platform_driver_unregister(&da9052_gpio_driver);
+}
+
+module_init(da9052_gpio_init);
+module_exit(da9052_gpio_exit);
+
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_DESCRIPTION("DA9052 GPIO Device Driver");
+MODULE_LICENSE("GPL");
diff -Naur linux-2.6.38.2/drivers/gpio/Kconfig wrk_linux-2.6.38.2/drivers/gpio/Kconfig
--- linux-2.6.38.2/drivers/gpio/Kconfig	2011-03-27 23:37:20.000000000 +0500
+++ wrk_linux-2.6.38.2/drivers/gpio/Kconfig	2011-04-13 11:21:37.000000000 +0500
@@ -64,6 +64,11 @@
 	  exported to userspace; this can be useful when debugging.

 # put expanders in the right section, in alphabetical order
+config GPIO_DA9052
+	bool "Dialog DA9052 GPIO"
+	depends on PMIC_DA9052
+	help
+	  Say Y  to enable the GPIO driver for the DA9052 chip

 config GPIO_MAX730X
 	tristate
diff -Naur linux-2.6.38.2/drivers/gpio/Makefile wrk_linux-2.6.38.2/drivers/gpio/Makefile
--- linux-2.6.38.2/drivers/gpio/Makefile	2011-03-27 23:37:20.000000000 +0500
+++ wrk_linux-2.6.38.2/drivers/gpio/Makefile	2011-04-13 11:21:28.000000000 +0500
@@ -10,6 +10,7 @@

 obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
 obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
+obj-$(CONFIG_GPIO_DA9052)	+= da9052-gpio.o
 obj-$(CONFIG_GPIO_BASIC_MMIO)	+= basic_mmio_gpio.o
 obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
 obj-$(CONFIG_GPIO_MAX730X)	+= max730x.o
@@ -42,3 +43,4 @@
 obj-$(CONFIG_GPIO_SX150X)	+= sx150x.o
 obj-$(CONFIG_GPIO_VX855)	+= vx855_gpio.o
 obj-$(CONFIG_GPIO_ML_IOH)	+= ml_ioh_gpio.o
+obj-$(CONFIG_GPIO_DA9052)	+= da9052-gpio.o
diff -Naur linux-2.6.38.2/include/linux/mfd/da9052/gpio.h wrk_linux-2.6.38.2/include/linux/mfd/da9052/gpio.h
--- linux-2.6.38.2/include/linux/mfd/da9052/gpio.h	1970-01-01 05:00:00.000000000 +0500
+++ wrk_linux-2.6.38.2/include/linux/mfd/da9052/gpio.h	2011-04-13 11:23:18.000000000 +0500
@@ -0,0 +1,47 @@
+/*
+ * include/linux/mfd/da9052/gpio.h -- GPIO for DA9052
+ *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * Author: Dajun Chen <dchen@diasemi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#ifndef __LINUX_MFD_DA9052_GPIO_H
+#define __LINUX_MFD_DA9052_GPIO_H
+
+#define DA9052_INPUT				1
+#define DA9052_OUTPUT_OPENDRAIN		2
+#define DA9052_OUTPUT_PUSHPULL		3
+
+#define DA9052_SUPPLY_VDD_IO1		0
+
+#define DA9052_DEBOUNCING_OFF		0
+#define DA9052_DEBOUNCING_ON			1
+
+#define DA9052_OUTPUT_LOWLEVEL		0
+
+#define DA9052_ACTIVE_LOW			0
+#define DA9052_ACTIVE_HIGH			1
+
+#define DA9052_GPIO_MAX_PORTS_PER_REGISTER	8
+#define DA9052_GPIO_SHIFT_COUNT(no)		(no%8)
+#define DA9052_GPIO_MASK_UPPER_NIBBLE		0xF0
+#define DA9052_GPIO_MASK_LOWER_NIBBLE		0x0F
+#define DA9052_GPIO_NIBBLE_SHIFT			4
+
+#endif

Regards,
Ashish


ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•

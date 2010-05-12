Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab0ELBit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 21:38:49 -0400
Received: from smtp-out-074.synserver.de ([212.40.180.74]:1046 "HELO
	smtp-out-072.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753758Ab0ELBih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 21:38:37 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 7659
From: Lars-Peter Clausen <lars@metafoo.de>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/3] MFD: pcf50633-gpio: Add gpiolib support
Date: Wed, 12 May 2010 03:31:15 +0200
Message-Id: <1273627876-26922-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1273627876-26922-1-git-send-email-lars@metafoo.de>
References: <1273627876-26922-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the custom gpio interface of the pcf50633 gpio driver with
gpiolib. Although the pcf50633 offers more functionality then what can be
exposed through the gpiolib api this functionality is seldomly used. Furthermore
functions providing the additional functionality can be modeld on top of
gpiolib.
By using gpiolib it is possible to use generic drivers for devices connected to
one of the pcf50633 gpios.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/mfd/pcf50633-core.c       |    4 +-
 drivers/mfd/pcf50633-gpio.c       |  159 +++++++++++++++++++++++++++++++------
 include/linux/mfd/pcf50633/core.h |    4 +
 include/linux/mfd/pcf50633/gpio.h |   61 ++++++++-------
 4 files changed, 172 insertions(+), 56 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 704736e..87682c8 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -307,7 +307,8 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 						&pcf->adc_pdev);
 	pcf50633_client_dev_register(pcf, "pcf50633-backlight",
 						&pcf->bl_pdev);
-
+	pcf50633_client_dev_register(pcf, "pcf50633-gpio",
+						&pcf->gpio_pdev);
 
 	for (i = 0; i < PCF50633_NUM_REGULATORS; i++) {
 		struct platform_device *pdev;
@@ -349,6 +350,7 @@ static int __devexit pcf50633_remove(struct i2c_client *client)
 
 	pcf50633_irq_free(pcf);
 
+	platform_device_unregister(pcf->gpio_pdev);
 	platform_device_unregister(pcf->input_pdev);
 	platform_device_unregister(pcf->rtc_pdev);
 	platform_device_unregister(pcf->mbc_pdev);
diff --git a/drivers/mfd/pcf50633-gpio.c b/drivers/mfd/pcf50633-gpio.c
index 9ab19a8..237f53f 100644
--- a/drivers/mfd/pcf50633-gpio.c
+++ b/drivers/mfd/pcf50633-gpio.c
@@ -2,6 +2,7 @@
  *
  * (C) 2006-2008 by Openmoko, Inc.
  * Author: Balaji Rao <balajirrao@openmoko.org>
+ * Copyright 2010, Lars-Peter Clausen <lars@metafoo.de>
  * All rights reserved.
  *
  * Broken down from monstrous PCF50633 driver mainly by
@@ -16,9 +17,15 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
 
 #include <linux/mfd/pcf50633/core.h>
 #include <linux/mfd/pcf50633/gpio.h>
+#include <linux/gpio.h>
+
+#define PCF50633_REG_GPIOCTL	0x13
+#define PCF50633_REG_GPIOCFG(x) (0x14 + (x))
 
 enum pcf50633_regulator_id {
 	PCF50633_REGULATOR_AUTO,
@@ -60,62 +67,162 @@ static const u8 pcf50633_regulator_registers[PCF50633_NUM_REGULATORS] = {
 	[PCF50633_REGULATOR_HCLDO]	= PCF50633_REG_HCLDOOUT,
 };
 
-int pcf50633_gpio_set(struct pcf50633 *pcf, int gpio, u8 val)
+struct pcf50633_gpio {
+	struct pcf50633 *pcf;
+	struct gpio_chip chip;
+};
+
+static inline struct pcf50633 *gpio_chip_to_pcf50633(struct gpio_chip *chip)
+{
+	return dev_to_pcf50633(chip->dev->parent);
+}
+
+static void pcf50633_gpio_set_value(struct gpio_chip *chip, unsigned gpio,
+	int value)
 {
+	struct pcf50633 *pcf = gpio_chip_to_pcf50633(chip);
 	u8 reg;
 
-	reg = gpio - PCF50633_GPIO1 + PCF50633_REG_GPIO1CFG;
+	reg = PCF50633_REG_GPIOCFG(gpio);
 
-	return pcf50633_reg_set_bit_mask(pcf, reg, 0x07, val);
+	pcf50633_reg_set_bit_mask(pcf, reg, 0x07, value ? 0x7 : 0x0);
 }
-EXPORT_SYMBOL_GPL(pcf50633_gpio_set);
 
-u8 pcf50633_gpio_get(struct pcf50633 *pcf, int gpio)
+static int pcf50633_gpio_get_value(struct gpio_chip *chip, unsigned gpio)
 {
-	u8 reg, val;
-
-	reg = gpio - PCF50633_GPIO1 + PCF50633_REG_GPIO1CFG;
-	val = pcf50633_reg_read(pcf, reg) & 0x07;
-
-	return val;
+	struct pcf50633 *pcf = gpio_chip_to_pcf50633(chip);
+	return pcf50633_reg_read(pcf, PCF50633_REG_GPIOCFG(gpio)) >> 3;
 }
-EXPORT_SYMBOL_GPL(pcf50633_gpio_get);
 
-int pcf50633_gpio_invert_set(struct pcf50633 *pcf, int gpio, int invert)
+
+static int pcf50633_gpio_direction_output(struct gpio_chip *chip, unsigned gpio,
+	int value)
 {
-	u8 val, reg;
+	struct pcf50633 *pcf = gpio_chip_to_pcf50633(chip);
+	int ret;
 
-	reg = gpio - PCF50633_GPIO1 + PCF50633_REG_GPIO1CFG;
-	val = !!invert << 3;
+	ret = pcf50633_gpio_set_config(pcf, pcf->pdata->gpio_base + gpio,
+		PCF50633_GPIO_CONFIG_OUTPUT);
+	if (!ret)
+		pcf50633_gpio_set_value(chip, gpio, value);
 
-	return pcf50633_reg_set_bit_mask(pcf, reg, 1 << 3, val);
+	return ret;
 }
-EXPORT_SYMBOL_GPL(pcf50633_gpio_invert_set);
 
-int pcf50633_gpio_invert_get(struct pcf50633 *pcf, int gpio)
+static int pcf50633_gpio_direction_input(struct gpio_chip *chip, unsigned gpio)
 {
-	u8 reg, val;
-
-	reg = gpio - PCF50633_GPIO1 + PCF50633_REG_GPIO1CFG;
-	val = pcf50633_reg_read(pcf, reg);
+	return -ENOSYS;
+}
 
-	return val & (1 << 3);
+int pcf50633_gpio_set_config(struct pcf50633 *pcf, unsigned gpio,
+	enum pcf50633_gpio_config config)
+{
+	u8 reg;
+	u8 direction;
+	int ret = 0;
+
+	gpio -= pcf->pdata->gpio_base;
+
+	if (gpio < 3) {
+		if (config == PCF50633_GPIO_CONFIG_INPUT)
+			direction = (1 << gpio);
+		else
+			direction = 0;
+		ret = pcf50633_reg_set_bit_mask(pcf, PCF50633_REG_GPIOCTL,
+			(1 << gpio), direction);
+	} else if (gpio > 3 || config == PCF50633_GPIO_CONFIG_INPUT) {
+		ret = -EINVAL;
+	}
+
+	if (!ret && config != PCF50633_GPIO_CONFIG_INPUT) {
+		reg = PCF50633_REG_GPIOCFG(gpio);
+		ret = pcf50633_reg_set_bit_mask(pcf, reg, 0x0f, config);
+	}
+
+	return ret;
 }
-EXPORT_SYMBOL_GPL(pcf50633_gpio_invert_get);
+EXPORT_SYMBOL_GPL(pcf50633_gpio_set_config);
 
 int pcf50633_gpio_power_supply_set(struct pcf50633 *pcf,
 					int gpio, int regulator, int on)
 {
 	u8 reg, val, mask;
 
+	gpio -= pcf->pdata->gpio_base;
+
 	/* the *ENA register is always one after the *OUT register */
 	reg = pcf50633_regulator_registers[regulator] + 1;
 
-	val = !!on << (gpio - PCF50633_GPIO1);
+	val = on ? (1 << (gpio - PCF50633_GPIO1)) : 0;
 	mask = 1 << (gpio - PCF50633_GPIO1);
 
 	return pcf50633_reg_set_bit_mask(pcf, reg, mask, val);
 }
 EXPORT_SYMBOL_GPL(pcf50633_gpio_power_supply_set);
 
+
+static int __devinit pcf50633_gpio_probe(struct platform_device *pdev)
+{
+	struct pcf50633 *pcf = dev_to_pcf50633(pdev->dev.parent);
+	struct pcf50633_gpio *pcf_gpio;
+
+	pcf_gpio = kzalloc(sizeof(*pcf_gpio), GFP_KERNEL);
+
+	if (!pcf_gpio)
+		return -ENOMEM;
+
+	pcf_gpio->pcf = pcf;
+
+	pcf_gpio->chip.direction_input = pcf50633_gpio_direction_input;
+	pcf_gpio->chip.direction_output = pcf50633_gpio_direction_output;
+	pcf_gpio->chip.get = pcf50633_gpio_get_value;
+	pcf_gpio->chip.set = pcf50633_gpio_set_value;
+
+	pcf_gpio->chip.base = pcf->pdata->gpio_base;
+	pcf_gpio->chip.ngpio = 4;
+	pcf_gpio->chip.label = dev_name(pcf->dev);
+	pcf_gpio->chip.can_sleep = 1;
+	pcf_gpio->chip.owner = THIS_MODULE;
+	pcf_gpio->chip.dev = &pdev->dev;
+
+	platform_set_drvdata(pdev, pcf_gpio);
+
+	return gpiochip_add(&pcf_gpio->chip);
+}
+
+static int __devexit pcf50633_gpio_remove(struct platform_device *pdev)
+{
+	struct pcf50633_gpio *pcf_gpio = platform_get_drvdata(pdev);
+
+	gpiochip_remove(&pcf_gpio->chip);
+
+	platform_set_drvdata(pdev, NULL);
+	kfree(pcf_gpio);
+
+	return 0;
+}
+
+static struct platform_driver pcf50633_gpio_driver = {
+	.probe = pcf50633_gpio_probe,
+	.remove = __devexit_p(pcf50633_gpio_remove),
+	.driver = {
+		.name = "pcf50633-gpio",
+		.owner = THIS_MODULE,
+	},
+};
+
+int __init pcf50633_gpio_init(void)
+{
+	return platform_driver_register(&pcf50633_gpio_driver);
+}
+module_init(pcf50633_gpio_init);
+
+void __exit pcf50633_gpio_exit(void)
+{
+	platform_driver_unregister(&pcf50633_gpio_driver);
+}
+module_exit(pcf50633_gpio_exit);
+
+MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
+MODULE_DESCRIPTION("GPIO driver for the PCF50633");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/pcf50633/core.h b/include/linux/mfd/pcf50633/core.h
index ad411a7..9953fa1 100644
--- a/include/linux/mfd/pcf50633/core.h
+++ b/include/linux/mfd/pcf50633/core.h
@@ -19,6 +19,7 @@
 #include <linux/regulator/machine.h>
 #include <linux/power_supply.h>
 #include <linux/mfd/pcf50633/backlight.h>
+#include <linux/gpio.h>
 
 struct pcf50633;
 
@@ -46,6 +47,8 @@ struct pcf50633_platform_data {
 	u8 resumers[5];
 
 	struct pcf50633_bl_platform_data *backlight_data;
+
+	int gpio_base;
 };
 
 struct pcf50633_irq {
@@ -151,6 +154,7 @@ struct pcf50633 {
 
 	int onkey1s_held;
 
+	struct platform_device *gpio_pdev;
 	struct platform_device *rtc_pdev;
 	struct platform_device *mbc_pdev;
 	struct platform_device *adc_pdev;
diff --git a/include/linux/mfd/pcf50633/gpio.h b/include/linux/mfd/pcf50633/gpio.h
index a42b845..e430e68 100644
--- a/include/linux/mfd/pcf50633/gpio.h
+++ b/include/linux/mfd/pcf50633/gpio.h
@@ -15,38 +15,41 @@
 
 #include <linux/mfd/pcf50633/core.h>
 
-#define PCF50633_GPIO1		1
-#define PCF50633_GPIO2		2
-#define PCF50633_GPIO3		3
-#define PCF50633_GPO		4
-
-#define PCF50633_REG_GPIO1CFG	0x14
-#define PCF50633_REG_GPIO2CFG	0x15
-#define PCF50633_REG_GPIO3CFG	0x16
-#define PCF50633_REG_GPOCFG 	0x17
-
-#define PCF50633_GPOCFG_GPOSEL_MASK	0x07
-
-enum pcf50633_reg_gpocfg {
-	PCF50633_GPOCFG_GPOSEL_0	= 0x00,
-	PCF50633_GPOCFG_GPOSEL_LED_NFET	= 0x01,
-	PCF50633_GPOCFG_GPOSEL_SYSxOK	= 0x02,
-	PCF50633_GPOCFG_GPOSEL_CLK32K	= 0x03,
-	PCF50633_GPOCFG_GPOSEL_ADAPUSB	= 0x04,
-	PCF50633_GPOCFG_GPOSEL_USBxOK	= 0x05,
-	PCF50633_GPOCFG_GPOSEL_ACTPH4	= 0x06,
-	PCF50633_GPOCFG_GPOSEL_1	= 0x07,
-	PCF50633_GPOCFG_GPOSEL_INVERSE	= 0x08,
+#define PCF50633_GPIO1		0
+#define PCF50633_GPIO2		1
+#define PCF50633_GPIO3		2
+#define PCF50633_GPO		3
+
+#define PCF50633_REG_GPIOCFG(x) (0x14 + (x))
+
+enum pcf50633_gpio_config {
+	PCF50633_GPIO_CONFIG_OUTPUT	= 0x0,
+	PCF50633_GPIO_CONFIG_SYSxOK	= 0x2,
+	PCF50633_GPIO_CONFIG_CHARGING	= 0x3,
+	PCF50633_GPIO_CONFIG_MOBILE_MODE = 0x4,
+	PCF50633_GPIO_CONFIG_USBxOK	= 0x5,
+	PCF50633_GPIO_CONFIG_ACTPH	= 0x6,
+	PCF50633_GPIO_CONFIG_INPUT	= 0x7,
+
+	PCF50633_GPIO_CONFIG_INVERT	= 0x8,
+
+	PCF50633_GPO_CONFIG_OUTPUT	= 0x0,
+	PCF50633_GPO_CONFIG_LED_NFET	= 0x1,
+	PCF50633_GPO_CONFIG_SYSxOK	= 0x2,
+	PCF50633_GPO_CONFIG_CLK32K	= 0x3,
+	PCF50633_GPO_CONFIG_MOBILE_MODE = 0x4,
+	PCF50633_GPO_CONFIG_USBxOK	= 0x5,
+	PCF50633_GPO_CONFIG_ACTPH	= 0x6,
+	PCF50633_GPO_CONFIG_INPUT	= 0x7,
+
+	PCF50633_GPO_CONFIG_INVERT	= 0x8,
 };
 
-int pcf50633_gpio_set(struct pcf50633 *pcf, int gpio, u8 val);
-u8 pcf50633_gpio_get(struct pcf50633 *pcf, int gpio);
+int pcf50633_gpio_set_config(struct pcf50633 *pcf, unsigned gpio,
+	enum pcf50633_gpio_config config);
 
-int pcf50633_gpio_invert_set(struct pcf50633 *, int gpio, int invert);
-int pcf50633_gpio_invert_get(struct pcf50633 *pcf, int gpio);
-
-int pcf50633_gpio_power_supply_set(struct pcf50633 *,
-					int gpio, int regulator, int on);
+int pcf50633_gpio_power_supply_set(struct pcf50633 *pcf,
+	int gpio, int regulator, int on);
 #endif /* __LINUX_MFD_PCF50633_GPIO_H */
 
 
-- 
1.5.6.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab0ELBix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 21:38:53 -0400
Received: from smtp-out-074.synserver.de ([212.40.180.74]:1047 "HELO
	smtp-out-072.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1754205Ab0ELBih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 21:38:37 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 7659
From: Lars-Peter Clausen <lars@metafoo.de>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3/3] MFD: pcf50633: Move pcf50633-gpio driver to the gpio drivers folder
Date: Wed, 12 May 2010 03:31:16 +0200
Message-Id: <1273627876-26922-4-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1273627876-26922-1-git-send-email-lars@metafoo.de>
References: <1273627876-26922-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the driver is implemented using gpiolib it should be moved to the gpio
drivers folder.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/gpio/Kconfig         |    7 ++
 drivers/gpio/Makefile        |    1 +
 drivers/gpio/pcf50633-gpio.c |  228 ++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig          |    7 --
 drivers/mfd/Makefile         |    1 -
 drivers/mfd/pcf50633-gpio.c  |  228 ------------------------------------------
 6 files changed, 236 insertions(+), 236 deletions(-)
 create mode 100644 drivers/gpio/pcf50633-gpio.c
 delete mode 100644 drivers/mfd/pcf50633-gpio.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index bde1bad..905fea4 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -242,6 +242,13 @@ config GPIO_ADP5588
 	  To compile this driver as a module, choose M here: the module will be
 	  called adp5588-gpio.
 
+config GPIO_PCF50633
+	tristate "GPIO support for NXP PCF50633"
+	depends on MFD_PCF50633
+	help
+	 Say yes here if you want to include support GPIO for pins on
+	 the PCF50633 chip.
+
 comment "PCI GPIO expanders:"
 
 config GPIO_CS5535
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 51c3cdd..928aede 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -31,3 +31,4 @@ obj-$(CONFIG_GPIO_WM8994)	+= wm8994-gpio.o
 obj-$(CONFIG_GPIO_SCH)		+= sch_gpio.o
 obj-$(CONFIG_GPIO_RDC321X)	+= rdc321x-gpio.o
 obj-$(CONFIG_GPIO_JANZ_TTL)	+= janz-ttl.o
+obj-$(CONFIG_GPIO_PCF50633)	+= pcf50633-gpio.o
diff --git a/drivers/gpio/pcf50633-gpio.c b/drivers/gpio/pcf50633-gpio.c
new file mode 100644
index 0000000..237f53f
--- /dev/null
+++ b/drivers/gpio/pcf50633-gpio.c
@@ -0,0 +1,228 @@
+/* NXP PCF50633 GPIO Driver
+ *
+ * (C) 2006-2008 by Openmoko, Inc.
+ * Author: Balaji Rao <balajirrao@openmoko.org>
+ * Copyright 2010, Lars-Peter Clausen <lars@metafoo.de>
+ * All rights reserved.
+ *
+ * Broken down from monstrous PCF50633 driver mainly by
+ * Harald Welte, Andy Green and Werner Almesberger
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+
+#include <linux/mfd/pcf50633/core.h>
+#include <linux/mfd/pcf50633/gpio.h>
+#include <linux/gpio.h>
+
+#define PCF50633_REG_GPIOCTL	0x13
+#define PCF50633_REG_GPIOCFG(x) (0x14 + (x))
+
+enum pcf50633_regulator_id {
+	PCF50633_REGULATOR_AUTO,
+	PCF50633_REGULATOR_DOWN1,
+	PCF50633_REGULATOR_DOWN2,
+	PCF50633_REGULATOR_LDO1,
+	PCF50633_REGULATOR_LDO2,
+	PCF50633_REGULATOR_LDO3,
+	PCF50633_REGULATOR_LDO4,
+	PCF50633_REGULATOR_LDO5,
+	PCF50633_REGULATOR_LDO6,
+	PCF50633_REGULATOR_HCLDO,
+	PCF50633_REGULATOR_MEMLDO,
+};
+
+#define PCF50633_REG_AUTOOUT	0x1a
+#define PCF50633_REG_DOWN1OUT	0x1e
+#define PCF50633_REG_DOWN2OUT	0x22
+#define PCF50633_REG_MEMLDOOUT	0x26
+#define PCF50633_REG_LDO1OUT	0x2d
+#define PCF50633_REG_LDO2OUT	0x2f
+#define PCF50633_REG_LDO3OUT	0x31
+#define PCF50633_REG_LDO4OUT	0x33
+#define PCF50633_REG_LDO5OUT	0x35
+#define PCF50633_REG_LDO6OUT	0x37
+#define PCF50633_REG_HCLDOOUT	0x39
+
+static const u8 pcf50633_regulator_registers[PCF50633_NUM_REGULATORS] = {
+	[PCF50633_REGULATOR_AUTO]	= PCF50633_REG_AUTOOUT,
+	[PCF50633_REGULATOR_DOWN1]	= PCF50633_REG_DOWN1OUT,
+	[PCF50633_REGULATOR_DOWN2]	= PCF50633_REG_DOWN2OUT,
+	[PCF50633_REGULATOR_MEMLDO]	= PCF50633_REG_MEMLDOOUT,
+	[PCF50633_REGULATOR_LDO1]	= PCF50633_REG_LDO1OUT,
+	[PCF50633_REGULATOR_LDO2]	= PCF50633_REG_LDO2OUT,
+	[PCF50633_REGULATOR_LDO3]	= PCF50633_REG_LDO3OUT,
+	[PCF50633_REGULATOR_LDO4]	= PCF50633_REG_LDO4OUT,
+	[PCF50633_REGULATOR_LDO5]	= PCF50633_REG_LDO5OUT,
+	[PCF50633_REGULATOR_LDO6]	= PCF50633_REG_LDO6OUT,
+	[PCF50633_REGULATOR_HCLDO]	= PCF50633_REG_HCLDOOUT,
+};
+
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
+{
+	struct pcf50633 *pcf = gpio_chip_to_pcf50633(chip);
+	u8 reg;
+
+	reg = PCF50633_REG_GPIOCFG(gpio);
+
+	pcf50633_reg_set_bit_mask(pcf, reg, 0x07, value ? 0x7 : 0x0);
+}
+
+static int pcf50633_gpio_get_value(struct gpio_chip *chip, unsigned gpio)
+{
+	struct pcf50633 *pcf = gpio_chip_to_pcf50633(chip);
+	return pcf50633_reg_read(pcf, PCF50633_REG_GPIOCFG(gpio)) >> 3;
+}
+
+
+static int pcf50633_gpio_direction_output(struct gpio_chip *chip, unsigned gpio,
+	int value)
+{
+	struct pcf50633 *pcf = gpio_chip_to_pcf50633(chip);
+	int ret;
+
+	ret = pcf50633_gpio_set_config(pcf, pcf->pdata->gpio_base + gpio,
+		PCF50633_GPIO_CONFIG_OUTPUT);
+	if (!ret)
+		pcf50633_gpio_set_value(chip, gpio, value);
+
+	return ret;
+}
+
+static int pcf50633_gpio_direction_input(struct gpio_chip *chip, unsigned gpio)
+{
+	return -ENOSYS;
+}
+
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
+}
+EXPORT_SYMBOL_GPL(pcf50633_gpio_set_config);
+
+int pcf50633_gpio_power_supply_set(struct pcf50633 *pcf,
+					int gpio, int regulator, int on)
+{
+	u8 reg, val, mask;
+
+	gpio -= pcf->pdata->gpio_base;
+
+	/* the *ENA register is always one after the *OUT register */
+	reg = pcf50633_regulator_registers[regulator] + 1;
+
+	val = on ? (1 << (gpio - PCF50633_GPIO1)) : 0;
+	mask = 1 << (gpio - PCF50633_GPIO1);
+
+	return pcf50633_reg_set_bit_mask(pcf, reg, mask, val);
+}
+EXPORT_SYMBOL_GPL(pcf50633_gpio_power_supply_set);
+
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
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index fea62a9..440118e 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -367,13 +367,6 @@ config PCF50633_ADC
 	 Say yes here if you want to include support for ADC in the
 	 NXP PCF50633 chip.
 
-config PCF50633_GPIO
-	tristate "Support for NXP PCF50633 GPIO"
-	depends on MFD_PCF50633
-	help
-	 Say yes here if you want to include support GPIO for pins on
-	 the PCF50633 chip.
-
 config ABX500_CORE
 	bool "ST-Ericsson ABX500 Mixed Signal Circuit register functions"
 	default y if ARCH_U300
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index ca1517e..10fed9d 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -60,7 +60,6 @@ obj-$(CONFIG_MFD_MAX8925)	+= max8925.o
 pcf50633-objs			:= pcf50633-core.o pcf50633-irq.o
 obj-$(CONFIG_MFD_PCF50633)	+= pcf50633.o
 obj-$(CONFIG_PCF50633_ADC)	+= pcf50633-adc.o
-obj-$(CONFIG_PCF50633_GPIO)	+= pcf50633-gpio.o
 obj-$(CONFIG_ABX500_CORE)	+= abx500-core.o
 obj-$(CONFIG_AB3100_CORE)	+= ab3100-core.o
 obj-$(CONFIG_AB3100_OTP)	+= ab3100-otp.o
diff --git a/drivers/mfd/pcf50633-gpio.c b/drivers/mfd/pcf50633-gpio.c
deleted file mode 100644
index 237f53f..0000000
--- a/drivers/mfd/pcf50633-gpio.c
+++ /dev/null
@@ -1,228 +0,0 @@
-/* NXP PCF50633 GPIO Driver
- *
- * (C) 2006-2008 by Openmoko, Inc.
- * Author: Balaji Rao <balajirrao@openmoko.org>
- * Copyright 2010, Lars-Peter Clausen <lars@metafoo.de>
- * All rights reserved.
- *
- * Broken down from monstrous PCF50633 driver mainly by
- * Harald Welte, Andy Green and Werner Almesberger
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/platform_device.h>
-
-#include <linux/mfd/pcf50633/core.h>
-#include <linux/mfd/pcf50633/gpio.h>
-#include <linux/gpio.h>
-
-#define PCF50633_REG_GPIOCTL	0x13
-#define PCF50633_REG_GPIOCFG(x) (0x14 + (x))
-
-enum pcf50633_regulator_id {
-	PCF50633_REGULATOR_AUTO,
-	PCF50633_REGULATOR_DOWN1,
-	PCF50633_REGULATOR_DOWN2,
-	PCF50633_REGULATOR_LDO1,
-	PCF50633_REGULATOR_LDO2,
-	PCF50633_REGULATOR_LDO3,
-	PCF50633_REGULATOR_LDO4,
-	PCF50633_REGULATOR_LDO5,
-	PCF50633_REGULATOR_LDO6,
-	PCF50633_REGULATOR_HCLDO,
-	PCF50633_REGULATOR_MEMLDO,
-};
-
-#define PCF50633_REG_AUTOOUT	0x1a
-#define PCF50633_REG_DOWN1OUT	0x1e
-#define PCF50633_REG_DOWN2OUT	0x22
-#define PCF50633_REG_MEMLDOOUT	0x26
-#define PCF50633_REG_LDO1OUT	0x2d
-#define PCF50633_REG_LDO2OUT	0x2f
-#define PCF50633_REG_LDO3OUT	0x31
-#define PCF50633_REG_LDO4OUT	0x33
-#define PCF50633_REG_LDO5OUT	0x35
-#define PCF50633_REG_LDO6OUT	0x37
-#define PCF50633_REG_HCLDOOUT	0x39
-
-static const u8 pcf50633_regulator_registers[PCF50633_NUM_REGULATORS] = {
-	[PCF50633_REGULATOR_AUTO]	= PCF50633_REG_AUTOOUT,
-	[PCF50633_REGULATOR_DOWN1]	= PCF50633_REG_DOWN1OUT,
-	[PCF50633_REGULATOR_DOWN2]	= PCF50633_REG_DOWN2OUT,
-	[PCF50633_REGULATOR_MEMLDO]	= PCF50633_REG_MEMLDOOUT,
-	[PCF50633_REGULATOR_LDO1]	= PCF50633_REG_LDO1OUT,
-	[PCF50633_REGULATOR_LDO2]	= PCF50633_REG_LDO2OUT,
-	[PCF50633_REGULATOR_LDO3]	= PCF50633_REG_LDO3OUT,
-	[PCF50633_REGULATOR_LDO4]	= PCF50633_REG_LDO4OUT,
-	[PCF50633_REGULATOR_LDO5]	= PCF50633_REG_LDO5OUT,
-	[PCF50633_REGULATOR_LDO6]	= PCF50633_REG_LDO6OUT,
-	[PCF50633_REGULATOR_HCLDO]	= PCF50633_REG_HCLDOOUT,
-};
-
-struct pcf50633_gpio {
-	struct pcf50633 *pcf;
-	struct gpio_chip chip;
-};
-
-static inline struct pcf50633 *gpio_chip_to_pcf50633(struct gpio_chip *chip)
-{
-	return dev_to_pcf50633(chip->dev->parent);
-}
-
-static void pcf50633_gpio_set_value(struct gpio_chip *chip, unsigned gpio,
-	int value)
-{
-	struct pcf50633 *pcf = gpio_chip_to_pcf50633(chip);
-	u8 reg;
-
-	reg = PCF50633_REG_GPIOCFG(gpio);
-
-	pcf50633_reg_set_bit_mask(pcf, reg, 0x07, value ? 0x7 : 0x0);
-}
-
-static int pcf50633_gpio_get_value(struct gpio_chip *chip, unsigned gpio)
-{
-	struct pcf50633 *pcf = gpio_chip_to_pcf50633(chip);
-	return pcf50633_reg_read(pcf, PCF50633_REG_GPIOCFG(gpio)) >> 3;
-}
-
-
-static int pcf50633_gpio_direction_output(struct gpio_chip *chip, unsigned gpio,
-	int value)
-{
-	struct pcf50633 *pcf = gpio_chip_to_pcf50633(chip);
-	int ret;
-
-	ret = pcf50633_gpio_set_config(pcf, pcf->pdata->gpio_base + gpio,
-		PCF50633_GPIO_CONFIG_OUTPUT);
-	if (!ret)
-		pcf50633_gpio_set_value(chip, gpio, value);
-
-	return ret;
-}
-
-static int pcf50633_gpio_direction_input(struct gpio_chip *chip, unsigned gpio)
-{
-	return -ENOSYS;
-}
-
-int pcf50633_gpio_set_config(struct pcf50633 *pcf, unsigned gpio,
-	enum pcf50633_gpio_config config)
-{
-	u8 reg;
-	u8 direction;
-	int ret = 0;
-
-	gpio -= pcf->pdata->gpio_base;
-
-	if (gpio < 3) {
-		if (config == PCF50633_GPIO_CONFIG_INPUT)
-			direction = (1 << gpio);
-		else
-			direction = 0;
-		ret = pcf50633_reg_set_bit_mask(pcf, PCF50633_REG_GPIOCTL,
-			(1 << gpio), direction);
-	} else if (gpio > 3 || config == PCF50633_GPIO_CONFIG_INPUT) {
-		ret = -EINVAL;
-	}
-
-	if (!ret && config != PCF50633_GPIO_CONFIG_INPUT) {
-		reg = PCF50633_REG_GPIOCFG(gpio);
-		ret = pcf50633_reg_set_bit_mask(pcf, reg, 0x0f, config);
-	}
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(pcf50633_gpio_set_config);
-
-int pcf50633_gpio_power_supply_set(struct pcf50633 *pcf,
-					int gpio, int regulator, int on)
-{
-	u8 reg, val, mask;
-
-	gpio -= pcf->pdata->gpio_base;
-
-	/* the *ENA register is always one after the *OUT register */
-	reg = pcf50633_regulator_registers[regulator] + 1;
-
-	val = on ? (1 << (gpio - PCF50633_GPIO1)) : 0;
-	mask = 1 << (gpio - PCF50633_GPIO1);
-
-	return pcf50633_reg_set_bit_mask(pcf, reg, mask, val);
-}
-EXPORT_SYMBOL_GPL(pcf50633_gpio_power_supply_set);
-
-
-static int __devinit pcf50633_gpio_probe(struct platform_device *pdev)
-{
-	struct pcf50633 *pcf = dev_to_pcf50633(pdev->dev.parent);
-	struct pcf50633_gpio *pcf_gpio;
-
-	pcf_gpio = kzalloc(sizeof(*pcf_gpio), GFP_KERNEL);
-
-	if (!pcf_gpio)
-		return -ENOMEM;
-
-	pcf_gpio->pcf = pcf;
-
-	pcf_gpio->chip.direction_input = pcf50633_gpio_direction_input;
-	pcf_gpio->chip.direction_output = pcf50633_gpio_direction_output;
-	pcf_gpio->chip.get = pcf50633_gpio_get_value;
-	pcf_gpio->chip.set = pcf50633_gpio_set_value;
-
-	pcf_gpio->chip.base = pcf->pdata->gpio_base;
-	pcf_gpio->chip.ngpio = 4;
-	pcf_gpio->chip.label = dev_name(pcf->dev);
-	pcf_gpio->chip.can_sleep = 1;
-	pcf_gpio->chip.owner = THIS_MODULE;
-	pcf_gpio->chip.dev = &pdev->dev;
-
-	platform_set_drvdata(pdev, pcf_gpio);
-
-	return gpiochip_add(&pcf_gpio->chip);
-}
-
-static int __devexit pcf50633_gpio_remove(struct platform_device *pdev)
-{
-	struct pcf50633_gpio *pcf_gpio = platform_get_drvdata(pdev);
-
-	gpiochip_remove(&pcf_gpio->chip);
-
-	platform_set_drvdata(pdev, NULL);
-	kfree(pcf_gpio);
-
-	return 0;
-}
-
-static struct platform_driver pcf50633_gpio_driver = {
-	.probe = pcf50633_gpio_probe,
-	.remove = __devexit_p(pcf50633_gpio_remove),
-	.driver = {
-		.name = "pcf50633-gpio",
-		.owner = THIS_MODULE,
-	},
-};
-
-int __init pcf50633_gpio_init(void)
-{
-	return platform_driver_register(&pcf50633_gpio_driver);
-}
-module_init(pcf50633_gpio_init);
-
-void __exit pcf50633_gpio_exit(void)
-{
-	platform_driver_unregister(&pcf50633_gpio_driver);
-}
-module_exit(pcf50633_gpio_exit);
-
-MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
-MODULE_DESCRIPTION("GPIO driver for the PCF50633");
-MODULE_LICENSE("GPL");
-- 
1.5.6.5


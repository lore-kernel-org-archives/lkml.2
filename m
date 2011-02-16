Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab1BPD5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 22:57:52 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:44268 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752294Ab1BPD5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 22:57:49 -0500
From: Bibek Basu <bibek.basu@stericsson.com>
To: <linus.walleij@stericsson.com>, <sameo@linux.intel.com>
Cc: <dbrownell@users.sourceforge.net>, <lee.jones@linaro.org>,
        <linux-kernel@vger.kernel.org>, <bibek.basu@stericsson.com>
Subject: [PATCH] AB8500 GPIO : Driver for 42 AB8500 GPIO pins
Date: Wed, 16 Feb 2011 09:04:43 +0530
Message-ID: <1297827283-22860-2-git-send-email-bibek.basu@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1297827283-22860-1-git-send-email-bibek.basu@stericsson.com>
References: <1297827283-22860-1-git-send-email-bibek.basu@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To get rid of port expanders, the free GPIOs of ab8500
can be used. There are 42 GPIO pins. Out of which 16
are interrupt capable.This patch implements 16 virtual
IRQ mapped to 16 interrupt capable AB8500 GPIOs.

Signed-off-by: Bibek Basu <bibek.basu@stericsson.com>
---
 drivers/gpio/Kconfig                   |    5 +
 drivers/gpio/Makefile                  |    1 +
 drivers/gpio/ab8500-gpio.c             |  521 ++++++++++++++++++++++++++++++++
 drivers/mfd/ab8500-core.c              |   14 +
 drivers/mfd/ab8500-i2c.c               |    2 +-
 include/linux/mfd/ab8500.h             |   41 +++
 include/linux/mfd/ab8500/ab8500-gpio.h |   21 ++
 7 files changed, 604 insertions(+), 1 deletions(-)
 create mode 100644 drivers/gpio/ab8500-gpio.c
 create mode 100644 include/linux/mfd/ab8500/ab8500-gpio.h

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 664660e..5a182f3 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -411,4 +411,9 @@ config GPIO_JANZ_TTL
 	  This driver provides support for driving the pins in output
 	  mode only. Input mode is not supported.
 
+config AB8500_GPIO
+	bool "ST-Ericsson AB8500 Mixed Signal Circuit gpio functions"
+	depends on AB8500_CORE
+	help
+	  Select this to enable the AB8500 IC GPIO driver
 endif
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 3351cf8..becef59 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -42,3 +42,4 @@ obj-$(CONFIG_GPIO_JANZ_TTL)	+= janz-ttl.o
 obj-$(CONFIG_GPIO_SX150X)	+= sx150x.o
 obj-$(CONFIG_GPIO_VX855)	+= vx855_gpio.o
 obj-$(CONFIG_GPIO_ML_IOH)	+= ml_ioh_gpio.o
+obj-$(CONFIG_AB8500_GPIO)       += ab8500-gpio.o
diff --git a/drivers/gpio/ab8500-gpio.c b/drivers/gpio/ab8500-gpio.c
new file mode 100644
index 0000000..8087462
--- /dev/null
+++ b/drivers/gpio/ab8500-gpio.c
@@ -0,0 +1,521 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2011
+ *
+ * Author: BIBEK BASU <bibek.basu@stericsson.com>
+ * License terms: GNU General Public License (GPL) version 2
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/mfd/ab8500.h>
+#include <linux/mfd/abx500.h>
+#include <linux/mfd/ab8500/ab8500-gpio.h>
+
+/*
+ * GPIO registers offset
+ * Bank: 0x10
+ */
+#define AB8500_GPIO_SEL1_REG	0x00
+#define AB8500_GPIO_SEL2_REG	0x01
+#define AB8500_GPIO_SEL3_REG	0x02
+#define AB8500_GPIO_SEL4_REG	0x03
+#define AB8500_GPIO_SEL5_REG	0x04
+#define AB8500_GPIO_SEL6_REG	0x05
+
+#define AB8500_GPIO_DIR1_REG	0x10
+#define AB8500_GPIO_DIR2_REG	0x11
+#define AB8500_GPIO_DIR3_REG	0x12
+#define AB8500_GPIO_DIR4_REG	0x13
+#define AB8500_GPIO_DIR5_REG	0x14
+#define AB8500_GPIO_DIR6_REG	0x15
+
+#define AB8500_GPIO_OUT1_REG	0x20
+#define AB8500_GPIO_OUT2_REG	0x21
+#define AB8500_GPIO_OUT3_REG	0x22
+#define AB8500_GPIO_OUT4_REG	0x23
+#define AB8500_GPIO_OUT5_REG	0x24
+#define AB8500_GPIO_OUT6_REG	0x25
+
+#define AB8500_GPIO_PUD1_REG	0x30
+#define AB8500_GPIO_PUD2_REG	0x31
+#define AB8500_GPIO_PUD3_REG	0x32
+#define AB8500_GPIO_PUD4_REG	0x33
+#define AB8500_GPIO_PUD5_REG	0x34
+#define AB8500_GPIO_PUD6_REG	0x35
+
+#define AB8500_GPIO_IN1_REG	0x40
+#define AB8500_GPIO_IN2_REG	0x41
+#define AB8500_GPIO_IN3_REG	0x42
+#define AB8500_GPIO_IN4_REG	0x43
+#define AB8500_GPIO_IN5_REG	0x44
+#define AB8500_GPIO_IN6_REG	0x45
+#define AB8500_GPIO_ALTFUN_REG	0x45
+#define ALTFUN_REG_INDEX	6
+#define AB8500_NUM_GPIO		42
+#define AB8500_NUM_VIR_GPIO_IRQ	16
+
+enum ab8500_gpio_action {
+	NONE,
+	STARTUP,
+	SHUTDOWN,
+	MASK,
+	UNMASK
+};
+
+struct ab8500_gpio {
+	struct gpio_chip chip;
+	struct ab8500 *parent;
+	struct device *dev;
+	struct mutex lock;
+	u32 irq_base;
+	enum ab8500_gpio_action irq_action;
+	u16 rising;
+	u16 falling;
+};
+/**
+ * to_ab8500_gpio() - get the pointer to ab8500_gpio
+ * @chip:	Member of the structure ab8500_gpio
+ */
+static inline struct ab8500_gpio *to_ab8500_gpio(struct gpio_chip *chip)
+{
+	return container_of(chip, struct ab8500_gpio, chip);
+}
+
+static int ab8500_gpio_set_bits(struct gpio_chip *chip, u8 reg,
+					unsigned offset, int val)
+{
+	struct ab8500_gpio *ab8500_gpio = to_ab8500_gpio(chip);
+	u8 pos = offset % 8;
+	int ret;
+
+	reg = reg + (offset / 8);
+	ret = abx500_mask_and_set_register_interruptible(ab8500_gpio->dev,
+				AB8500_MISC, reg, 1 << pos, val << pos);
+	if (ret < 0)
+		dev_err(ab8500_gpio->dev, "%s write failed\n", __func__);
+	return ret;
+}
+/**
+ * ab8500_gpio_get() - Get the particular GPIO value
+ * @chip: Gpio device
+ * @offset: GPIO number to read
+ */
+static int ab8500_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct ab8500_gpio *ab8500_gpio = to_ab8500_gpio(chip);
+	u8 mask = 1 << (offset % 8);
+	u8 reg = AB8500_GPIO_OUT1_REG + (offset / 8);
+	int ret;
+	u8 data;
+	ret = abx500_get_register_interruptible(ab8500_gpio->dev, AB8500_MISC,
+						reg, &data);
+	if (ret < 0) {
+		dev_err(ab8500_gpio->dev, "%s read failed\n", __func__);
+		return ret;
+	}
+	return (data & mask) >> (offset % 8);
+}
+
+static void ab8500_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
+{
+	struct ab8500_gpio *ab8500_gpio = to_ab8500_gpio(chip);
+	int ret;
+	/* Write the data */
+	ret = ab8500_gpio_set_bits(chip, AB8500_GPIO_OUT1_REG, offset, 1);
+	if (ret < 0)
+		dev_err(ab8500_gpio->dev, "%s write failed\n", __func__);
+}
+
+static int ab8500_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
+					int val)
+{
+	int ret;
+	/* set direction as output */
+	ret = ab8500_gpio_set_bits(chip, AB8500_GPIO_DIR1_REG, offset, 1);
+	if (ret < 0)
+		return ret;
+	/* disable pull down */
+	ret = ab8500_gpio_set_bits(chip, AB8500_GPIO_PUD1_REG, offset, 1);
+	if (ret < 0)
+		return ret;
+	/* set the output as 1 or 0 */
+	return ab8500_gpio_set_bits(chip, AB8500_GPIO_OUT1_REG, offset, val);
+
+}
+
+static int ab8500_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	/* set the register as input */
+	return ab8500_gpio_set_bits(chip, AB8500_GPIO_DIR1_REG, offset, 0);
+}
+
+static int ab8500_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	/*
+	 * Only some GPIOs are interrupt capable, and they are
+	 * organized in discontiguous clusters:
+	 *
+	 * 	GPIO6 to GPIO13
+	 * 	GPIO24 and GPIO25
+	 * 	GPIO36 to GPIO41
+	 */
+	static struct ab8500_gpio_irq_cluster {
+		int start;
+		int end;
+	} clusters[] = {
+		{.start = 6,  .end = 13},
+		{.start = 24, .end = 25},
+		{.start = 36, .end = 41},
+	};
+	struct ab8500_gpio *ab8500_gpio = to_ab8500_gpio(chip);
+	int base = ab8500_gpio->irq_base;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(clusters); i++) {
+		struct ab8500_gpio_irq_cluster *cluster = &clusters[i];
+
+		if (offset >= cluster->start && offset <= cluster->end)
+			return base + offset - cluster->start;
+
+		/* Advance by the number of gpios in this cluster */
+		base += cluster->end - cluster->start + 1;
+	}
+
+	return -EINVAL;
+}
+
+static struct gpio_chip ab8500gpio_chip = {
+	.label			= "ab8500_gpio",
+	.owner			= THIS_MODULE,
+	.direction_input	= ab8500_gpio_direction_input,
+	.get			= ab8500_gpio_get,
+	.direction_output	= ab8500_gpio_direction_output,
+	.set			= ab8500_gpio_set,
+	.to_irq			= ab8500_gpio_to_irq,
+};
+
+static unsigned int irq_to_rising(unsigned int irq)
+{
+	struct ab8500_gpio *ab8500_gpio = get_irq_chip_data(irq);
+	int offset = irq - ab8500_gpio->irq_base;
+	int new_irq = offset +  AB8500_INT_GPIO6R
+			+ ab8500_gpio->parent->irq_base;
+	return new_irq;
+}
+
+static unsigned int irq_to_falling(unsigned int irq)
+{
+	struct ab8500_gpio *ab8500_gpio = get_irq_chip_data(irq);
+	int offset = irq - ab8500_gpio->irq_base;
+	int new_irq = offset +  AB8500_INT_GPIO6F
+			+  ab8500_gpio->parent->irq_base;
+	return new_irq;
+
+}
+
+static unsigned int rising_to_irq(unsigned int irq, void *dev)
+{
+	struct ab8500_gpio *ab8500_gpio = dev;
+	int offset = irq - AB8500_INT_GPIO6R
+			- ab8500_gpio->parent->irq_base ;
+	int new_irq = offset + ab8500_gpio->irq_base;
+	return new_irq;
+}
+
+static unsigned int falling_to_irq(unsigned int irq, void *dev)
+{
+	struct ab8500_gpio *ab8500_gpio = dev;
+	int offset = irq - AB8500_INT_GPIO6F
+			- ab8500_gpio->parent->irq_base ;
+	int new_irq = offset + ab8500_gpio->irq_base;
+	return new_irq;
+
+}
+
+/*
+ * IRQ handler
+ */
+
+static irqreturn_t handle_rising(int irq, void *dev)
+{
+
+	handle_nested_irq(rising_to_irq(irq , dev));
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t handle_falling(int irq, void *dev)
+{
+
+	handle_nested_irq(falling_to_irq(irq, dev));
+	return IRQ_HANDLED;
+}
+
+static void ab8500_gpio_irq_lock(unsigned int irq)
+{
+	struct ab8500_gpio *ab8500_gpio = get_irq_chip_data(irq);
+	mutex_lock(&ab8500_gpio->lock);
+}
+
+static void ab8500_gpio_irq_sync_unlock(unsigned int irq)
+{
+	struct ab8500_gpio *ab8500_gpio = get_irq_chip_data(irq);
+	int offset = irq - ab8500_gpio->irq_base;
+	bool rising = ab8500_gpio->rising & BIT(offset);
+	bool falling = ab8500_gpio->falling & BIT(offset);
+	int ret;
+
+	switch (ab8500_gpio->irq_action)	{
+	case STARTUP:
+		if (rising)
+			ret = request_threaded_irq(irq_to_rising(irq),
+					NULL, handle_rising,
+					IRQF_TRIGGER_RISING,
+					"ab8500-gpio-r", ab8500_gpio);
+		if (falling)
+			ret = request_threaded_irq(irq_to_falling(irq),
+				       NULL, handle_falling,
+				       IRQF_TRIGGER_FALLING,
+				       "ab8500-gpio-f", ab8500_gpio);
+		break;
+	case SHUTDOWN:
+		if (rising)
+			free_irq(irq_to_rising(irq), ab8500_gpio);
+		if (falling)
+			free_irq(irq_to_falling(irq), ab8500_gpio);
+		break;
+	case MASK:
+		if (rising)
+			disable_irq(irq_to_rising(irq));
+		if (falling)
+			disable_irq(irq_to_falling(irq));
+		break;
+	case UNMASK:
+		if (rising)
+			enable_irq(irq_to_rising(irq));
+		if (falling)
+			enable_irq(irq_to_falling(irq));
+		break;
+	case NONE:
+		break;
+	}
+	ab8500_gpio->irq_action = NONE;
+	ab8500_gpio->rising &= ~(BIT(offset));
+	ab8500_gpio->falling &= ~(BIT(offset));
+	mutex_unlock(&ab8500_gpio->lock);
+}
+
+
+static void ab8500_gpio_irq_mask(unsigned int irq)
+{
+	struct ab8500_gpio *ab8500_gpio = get_irq_chip_data(irq);
+	ab8500_gpio->irq_action = MASK;
+}
+
+static void ab8500_gpio_irq_unmask(unsigned int irq)
+{
+	struct ab8500_gpio *ab8500_gpio = get_irq_chip_data(irq);
+	ab8500_gpio->irq_action = UNMASK;
+}
+
+static int ab8500_gpio_irq_set_type(unsigned int irq, unsigned int type)
+{
+	struct ab8500_gpio *ab8500_gpio = get_irq_chip_data(irq);
+	int offset = irq - ab8500_gpio->irq_base;
+
+	if (type == IRQ_TYPE_EDGE_BOTH) {
+		ab8500_gpio->rising =  BIT(offset);
+		ab8500_gpio->falling = BIT(offset);
+	} else if (type == IRQ_TYPE_EDGE_RISING) {
+		ab8500_gpio->rising =  BIT(offset);
+	} else  {
+		ab8500_gpio->falling = BIT(offset);
+	}
+	return 0;
+}
+
+unsigned int ab8500_gpio_irq_startup(unsigned int irq)
+{
+	struct ab8500_gpio *ab8500_gpio = get_irq_chip_data(irq);
+	ab8500_gpio->irq_action = STARTUP;
+	return 0;
+}
+
+void ab8500_gpio_irq_shutdown(unsigned int irq)
+{
+	struct ab8500_gpio *ab8500_gpio = get_irq_chip_data(irq);
+	ab8500_gpio->irq_action = SHUTDOWN;
+}
+
+static struct irq_chip ab8500_gpio_irq_chip = {
+	.name			= "ab8500-gpio",
+	.startup		= ab8500_gpio_irq_startup,
+	.shutdown		= ab8500_gpio_irq_shutdown,
+	.bus_lock		= ab8500_gpio_irq_lock,
+	.bus_sync_unlock	= ab8500_gpio_irq_sync_unlock,
+	.mask			= ab8500_gpio_irq_mask,
+	.unmask			= ab8500_gpio_irq_unmask,
+	.set_type		= ab8500_gpio_irq_set_type,
+};
+
+static int ab8500_gpio_irq_init(struct ab8500_gpio *ab8500_gpio)
+{
+	u32 base = ab8500_gpio->irq_base;
+	int irq;
+
+	for (irq = base; irq < base + AB8500_NUM_VIR_GPIO_IRQ ; irq++) {
+		set_irq_chip_data(irq, ab8500_gpio);
+		set_irq_chip_and_handler(irq, &ab8500_gpio_irq_chip,
+				handle_simple_irq);
+		set_irq_nested_thread(irq, 1);
+#ifdef CONFIG_ARM
+		set_irq_flags(irq, IRQF_VALID);
+#else
+		set_irq_noprobe(irq);
+#endif
+	}
+
+	return 0;
+}
+
+static void ab8500_gpio_irq_remove(struct ab8500_gpio *ab8500_gpio)
+{
+	int base = ab8500_gpio->irq_base;
+	int irq;
+
+	for (irq = base; irq < base + AB8500_NUM_VIR_GPIO_IRQ; irq++) {
+#ifdef CONFIG_ARM
+		set_irq_flags(irq, 0);
+#endif
+		set_irq_chip_and_handler(irq, NULL, NULL);
+		set_irq_chip_data(irq, NULL);
+	}
+}
+
+static int __devinit ab8500_gpio_probe(struct platform_device *pdev)
+{
+	struct ab8500_platform_data *ab8500_pdata =
+				dev_get_platdata(pdev->dev.parent);
+	struct ab8500_gpio_platform_data *pdata;
+	struct ab8500_gpio *ab8500_gpio;
+	int ret;
+	int i;
+
+	pdata = ab8500_pdata->gpio;
+	if (!pdata)	{
+		dev_err(&pdev->dev, "gpio platform data missing\n");
+		return -ENODEV;
+	}
+
+	ab8500_gpio = kzalloc(sizeof(struct ab8500_gpio), GFP_KERNEL);
+	if (ab8500_gpio == NULL) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+	ab8500_gpio->dev = &pdev->dev;
+	ab8500_gpio->parent = dev_get_drvdata(pdev->dev.parent);
+	ab8500_gpio->chip = ab8500gpio_chip;
+	ab8500_gpio->chip.ngpio = AB8500_NUM_GPIO;
+	ab8500_gpio->chip.dev = &pdev->dev;
+	ab8500_gpio->chip.base = pdata->gpio_base;
+	ab8500_gpio->irq_base = MOP500_AB8500_VIR_GPIO_IRQ_BASE;
+	/* initialize the lock */
+	mutex_init(&ab8500_gpio->lock);
+	/*
+	 * AB8500 core will handle and clear the IRQ
+	 * configre GPIO based on config-reg value.
+	 * These values are for selecting the PINs as
+	 * GPIO or alternate function
+	 */
+	for (i = AB8500_GPIO_SEL1_REG; i <= AB8500_GPIO_SEL6_REG; i++)	{
+		ret = abx500_set_register_interruptible(ab8500_gpio->dev,
+				AB8500_MISC, i,
+				pdata->config_reg[i]);
+		if (ret < 0)
+			goto out_free;
+	}
+	ret = abx500_set_register_interruptible(ab8500_gpio->dev, AB8500_MISC,
+				AB8500_GPIO_ALTFUN_REG,
+				pdata->config_reg[ALTFUN_REG_INDEX]);
+	if (ret < 0)
+		goto out_free;
+
+	ret = ab8500_gpio_irq_init(ab8500_gpio);
+	if (ret)
+		goto out_free;
+	ret = gpiochip_add(&ab8500_gpio->chip);
+	if (ret) {
+		dev_err(&pdev->dev, "unable to add gpiochip: %d\n",
+				ret);
+		goto out_rem_irq;
+	}
+	platform_set_drvdata(pdev, ab8500_gpio);
+	return 0;
+
+out_rem_irq:
+	ab8500_gpio_irq_remove(ab8500_gpio);
+out_free:
+	mutex_destroy(&ab8500_gpio->lock);
+	kfree(ab8500_gpio);
+	return ret;
+}
+
+/*
+ * ab8500_gpio_remove() - remove Ab8500-gpio driver
+ * @pdev :	Platform device registered
+ */
+static int __devexit ab8500_gpio_remove(struct platform_device *pdev)
+{
+	struct ab8500_gpio *ab8500_gpio = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = gpiochip_remove(&ab8500_gpio->chip);
+	if (ret < 0) {
+		dev_err(ab8500_gpio->dev, "unable to remove gpiochip:\
+				%d\n", ret);
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, NULL);
+	mutex_destroy(&ab8500_gpio->lock);
+	kfree(ab8500_gpio);
+
+	return 0;
+}
+
+static struct platform_driver ab8500_gpio_driver = {
+	.driver = {
+		.name = "ab8500-gpio",
+		.owner = THIS_MODULE,
+	},
+	.probe = ab8500_gpio_probe,
+	.remove = __devexit_p(ab8500_gpio_remove),
+};
+
+static int __init ab8500_gpio_init(void)
+{
+	return platform_driver_register(&ab8500_gpio_driver);
+}
+arch_initcall(ab8500_gpio_init);
+
+static void __exit ab8500_gpio_exit(void)
+{
+	platform_driver_unregister(&ab8500_gpio_driver);
+}
+module_exit(ab8500_gpio_exit);
+MODULE_AUTHOR("BIBEK BASU <bibek.basu@stericsson.com>");
+MODULE_DESCRIPTION("Driver allows to use AB8500 unused pins\
+			to be used as GPIO");
+MODULE_ALIAS("AB8500 GPIO driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index b688701..56a5592 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -361,6 +361,15 @@ static void ab8500_irq_remove(struct ab8500 *ab8500)
 	}
 }
 
+static struct resource ab8500_gpio_resources[] = {
+	{
+		.name	= "GPIO_INT6",
+		.start	= AB8500_INT_GPIO6R,
+		.end	= AB8500_INT_GPIO41F,
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
 static struct resource ab8500_gpadc_resources[] = {
 	{
 		.name	= "HW_CONV_END",
@@ -595,6 +604,11 @@ static struct mfd_cell ab8500_devs[] = {
 		.name = "ab8500-regulator",
 	},
 	{
+		.name = "ab8500-gpio",
+		.num_resources = ARRAY_SIZE(ab8500_gpio_resources),
+		.resources = ab8500_gpio_resources,
+	},
+	{
 		.name = "ab8500-gpadc",
 		.num_resources = ARRAY_SIZE(ab8500_gpadc_resources),
 		.resources = ab8500_gpadc_resources,
diff --git a/drivers/mfd/ab8500-i2c.c b/drivers/mfd/ab8500-i2c.c
index 6820327..821e6b8 100644
--- a/drivers/mfd/ab8500-i2c.c
+++ b/drivers/mfd/ab8500-i2c.c
@@ -97,7 +97,7 @@ static void __exit ab8500_i2c_exit(void)
 {
 	platform_driver_unregister(&ab8500_i2c_driver);
 }
-subsys_initcall(ab8500_i2c_init);
+arch_initcall(ab8500_i2c_init);
 module_exit(ab8500_i2c_exit);
 
 MODULE_AUTHOR("Mattias WALLIN <mattias.wallin@stericsson.com");
diff --git a/include/linux/mfd/ab8500.h b/include/linux/mfd/ab8500.h
index 37f56b7..5adce48 100644
--- a/include/linux/mfd/ab8500.h
+++ b/include/linux/mfd/ab8500.h
@@ -74,6 +74,45 @@
 #define AB8500_INT_ACC_DETECT_21DB_F	37
 #define AB8500_INT_ACC_DETECT_21DB_R	38
 #define AB8500_INT_GP_SW_ADC_CONV_END	39
+#define AB8500_INT_ACC_DETECT_1DB_F	33
+#define AB8500_INT_ACC_DETECT_1DB_R	34
+#define AB8500_INT_ACC_DETECT_22DB_F	35
+#define AB8500_INT_ACC_DETECT_22DB_R	36
+#define AB8500_INT_ACC_DETECT_21DB_F	37
+#define AB8500_INT_ACC_DETECT_21DB_R	38
+#define AB8500_INT_GP_SW_ADC_CONV_END	39
+#define AB8500_INT_GPIO6R		40
+#define AB8500_INT_GPIO7R		41
+#define AB8500_INT_GPIO8R		42
+#define AB8500_INT_GPIO9R		43
+#define AB8500_INT_GPIO10R		44
+#define AB8500_INT_GPIO11R		45
+#define AB8500_INT_GPIO12R		46
+#define AB8500_INT_GPIO13R		47
+#define AB8500_INT_GPIO24R		48
+#define AB8500_INT_GPIO25R		49
+#define AB8500_INT_GPIO36R		50
+#define AB8500_INT_GPIO37R		51
+#define AB8500_INT_GPIO38R		52
+#define AB8500_INT_GPIO39R		53
+#define AB8500_INT_GPIO40R		54
+#define AB8500_INT_GPIO41R		55
+#define AB8500_INT_GPIO6F		56
+#define AB8500_INT_GPIO7F		57
+#define AB8500_INT_GPIO8F		58
+#define AB8500_INT_GPIO9F		59
+#define AB8500_INT_GPIO10F		60
+#define AB8500_INT_GPIO11F		61
+#define AB8500_INT_GPIO12F		62
+#define AB8500_INT_GPIO13F		63
+#define AB8500_INT_GPIO24F		64
+#define AB8500_INT_GPIO25F		65
+#define AB8500_INT_GPIO36F		66
+#define AB8500_INT_GPIO37F		67
+#define AB8500_INT_GPIO38F		68
+#define AB8500_INT_GPIO39F		69
+#define AB8500_INT_GPIO40F		70
+#define AB8500_INT_GPIO41F		71
 #define AB8500_INT_ADP_SOURCE_ERROR	72
 #define AB8500_INT_ADP_SINK_ERROR	73
 #define AB8500_INT_ADP_PROBE_PLUG	74
@@ -140,6 +179,7 @@ struct ab8500 {
 };
 
 struct regulator_init_data;
+struct ab8500_gpio_platform_data;
 
 /**
  * struct ab8500_platform_data - AB8500 platform data
@@ -152,6 +192,7 @@ struct ab8500_platform_data {
 	void (*init) (struct ab8500 *);
 	int num_regulator;
 	struct regulator_init_data *regulator;
+	struct ab8500_gpio_platform_data *gpio;
 };
 
 extern int __devinit ab8500_init(struct ab8500 *ab8500);
diff --git a/include/linux/mfd/ab8500/ab8500-gpio.h b/include/linux/mfd/ab8500/ab8500-gpio.h
new file mode 100644
index 0000000..ba23873
--- /dev/null
+++ b/include/linux/mfd/ab8500/ab8500-gpio.h
@@ -0,0 +1,21 @@
+/*
+ * Copyright ST-Ericsson 2010.
+ *
+ * Author: Bibek Basu <bibek.basu@stericsson.com>
+ * Licensed under GPLv2.
+ */
+
+#ifndef _AB8500_GPIO_H
+#define _AB8500_GPIO_H
+
+/*
+ * Platform data to register a block: only the initial gpio/irq number.
+ */
+
+struct ab8500_gpio_platform_data {
+	int gpio_base;
+	u8  config_reg[7];
+};
+
+#endif /* _AB8500_GPIO_H */
+
-- 
1.7.2.dirty


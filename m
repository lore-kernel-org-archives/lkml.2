Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab1FITuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:50:25 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:51706 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540Ab1FITuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:50:22 -0400
MIME-Version: 1.0
Date: Thu, 9 Jun 2011 14:50:19 -0500
Message-ID: <BANLkTimo27MrUyqbpPy1WX5ydmDNd1O7HA@mail.gmail.com>
Subject: [PATCHv5 3/4] tps65912: gpio: add gpio driver
From: Margarita Olaya <magi@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: "Girdwood, Liam" <lrg@ti.com>, sameo@linux.intel.com,
        Graeme Gregory <gg@slimlogic.co.uk>, grant.likely@secretlab.ca
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TPS65912 has five GPIOs that can be configured for different
purposes.

Signed-off-by: Margarita Olaya Cabrera <magi@slimlogic.co.uk>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Liam Girdwood <lrg@ti.com>
---
 drivers/gpio/Kconfig         |    6 ++
 drivers/gpio/Makefile        |    1 +
 drivers/gpio/gpio-tps65912.c |  156 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/tps65912.h |    1 +
 4 files changed, 164 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/gpio-tps65912.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 4a7f631..a57867d 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -273,6 +273,12 @@ config GPIO_TC3589X
 	  This enables support for the GPIOs found on the TC3589X
 	  I/O Expander.

+config GPIO_TPS65912
+	tristate "TI TPS65912 GPIO"
+	depends on (MFD_TPS65912_I2C || MFD_TPS65912_SPI)
+	help
+	  This driver supports TPS65912 gpio chip
+
 config GPIO_TWL4030
 	tristate "TWL4030, TWL5030, and TPS659x0 GPIOs"
 	depends on TWL4030_CORE
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index b605f8e..4af9627 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_GPIO_STMPE)	+= stmpe-gpio.o
 obj-$(CONFIG_GPIO_TC3589X)	+= tc3589x-gpio.o
 obj-$(CONFIG_GPIO_TIMBERDALE)	+= timbgpio.o
 obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
+obj-$(CONFIG_GPIO_TPS65912)	+= gpio-tps65912.o
 obj-$(CONFIG_GPIO_UCB1400)	+= ucb1400_gpio.o
 obj-$(CONFIG_GPIO_XILINX)	+= xilinx_gpio.o
 obj-$(CONFIG_GPIO_CS5535)	+= cs5535-gpio.o
diff --git a/drivers/gpio/gpio-tps65912.c b/drivers/gpio/gpio-tps65912.c
new file mode 100644
index 0000000..79e66c0
--- /dev/null
+++ b/drivers/gpio/gpio-tps65912.c
@@ -0,0 +1,156 @@
+/*
+ * Copyright 2011 Texas Instruments Inc.
+ *
+ * Author: Margarita Olaya <magi@slimlogic.co.uk>
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under  the terms of the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the License, or (at your
+ *  option) any later version.
+ *
+ * This driver is based on wm8350 implementation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/gpio.h>
+#include <linux/mfd/core.h>
+#include <linux/platform_device.h>
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+#include <linux/mfd/tps65912.h>
+
+struct tps65912_gpio_data {
+	struct tps65912 *tps65912;
+	struct gpio_chip gpio_chip;
+};
+
+static int tps65912_gpio_get(struct gpio_chip *gc, unsigned offset)
+{
+	struct tps65912 *tps65912 = container_of(gc, struct tps65912, gpio);
+	int val;
+
+	val = tps65912_reg_read(tps65912, TPS65912_GPIO1 + offset);
+
+	if (val & GPIO_STS_MASK)
+		return 1;
+
+	return 0;
+}
+
+static void tps65912_gpio_set(struct gpio_chip *gc, unsigned offset,
+			      int value)
+{
+	struct tps65912 *tps65912 = container_of(gc, struct tps65912, gpio);
+
+	if (value)
+		tps65912_set_bits(tps65912, TPS65912_GPIO1 + offset,
+							GPIO_SET_MASK);
+	else
+		tps65912_clear_bits(tps65912, TPS65912_GPIO1 + offset,
+								GPIO_SET_MASK);
+}
+
+static int tps65912_gpio_output(struct gpio_chip *gc, unsigned offset,
+				int value)
+{
+	struct tps65912 *tps65912 = container_of(gc, struct tps65912, gpio);
+
+	/* Set the initial value */
+	tps65912_gpio_set(gc, offset, value);
+
+	return tps65912_set_bits(tps65912, TPS65912_GPIO1 + offset,
+								GPIO_CFG_MASK);
+}
+
+static int tps65912_gpio_input(struct gpio_chip *gc, unsigned offset)
+{
+	struct tps65912 *tps65912 = container_of(gc, struct tps65912, gpio);
+
+	return tps65912_clear_bits(tps65912, TPS65912_GPIO1 + offset,
+								GPIO_CFG_MASK);
+
+}
+
+static struct gpio_chip template_chip = {
+	.label			= "tps65912",
+	.owner			= THIS_MODULE,
+	.direction_input	= tps65912_gpio_input,
+	.direction_output	= tps65912_gpio_output,
+	.get			= tps65912_gpio_get,
+	.set			= tps65912_gpio_set,
+	.can_sleep		= 1,
+	.ngpio			= 5,
+	.base			= -1,
+};
+
+static int __devinit tps65912_gpio_probe(struct platform_device *pdev)
+{
+	struct tps65912 *tps65912 = dev_get_drvdata(pdev->dev.parent);
+	struct tps65912_board *pdata = tps65912->dev->platform_data;
+	struct tps65912_gpio_data *tps65912_gpio;
+	int ret;
+
+	tps65912_gpio = kzalloc(sizeof(*tps65912_gpio), GFP_KERNEL);
+	if (tps65912_gpio == NULL)
+		return -ENOMEM;
+
+	tps65912_gpio->tps65912 = tps65912;
+	tps65912_gpio->gpio_chip = template_chip;
+	tps65912_gpio->gpio_chip.dev = &pdev->dev;
+	if (pdata && pdata->gpio_base)
+		tps65912_gpio->gpio_chip.base = pdata->gpio_base;
+
+	ret = gpiochip_add(&tps65912_gpio->gpio_chip);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to register gpiochip, %d\n", ret);
+		goto err;
+	}
+
+	platform_set_drvdata(pdev, tps65912_gpio);
+
+	return ret;
+
+err:
+	kfree(tps65912_gpio);
+	return ret;
+}
+
+static int __devexit tps65912_gpio_remove(struct platform_device *pdev)
+{
+	struct tps65912_gpio_data  *tps65912_gpio = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = gpiochip_remove(&tps65912_gpio->gpio_chip);
+	if (ret == 0)
+		kfree(tps65912_gpio);
+
+	return ret;
+}
+
+static struct platform_driver tps65912_gpio_driver = {
+	.driver = {
+		.name = "tps65912-gpio",
+		.owner = THIS_MODULE,
+	},
+	.probe = tps65912_gpio_probe,
+	.remove = __devexit_p(tps65912_gpio_remove),
+};
+
+static int __init tps65912_gpio_init(void)
+{
+	return platform_driver_register(&tps65912_gpio_driver);
+}
+subsys_initcall(tps65912_gpio_init);
+
+static void __exit tps65912_gpio_exit(void)
+{
+	platform_driver_unregister(&tps65912_gpio_driver);
+}
+module_exit(tps65912_gpio_exit);
+
+MODULE_AUTHOR("Margarita Olaya Cabrera <magi@slimlogic.co.uk>");
+MODULE_DESCRIPTION("GPIO interface for TPS65912 PMICs");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:tps65912-gpio");
diff --git a/include/linux/mfd/tps65912.h b/include/linux/mfd/tps65912.h
index be60fb2..aaceab4 100644
--- a/include/linux/mfd/tps65912.h
+++ b/include/linux/mfd/tps65912.h
@@ -275,6 +275,7 @@ struct tps65912_board {
 	int is_dcdc4_avs;
 	int irq;
 	int irq_base;
+	int gpio_base;
 	struct regulator_init_data *tps65912_pmic_init_data;
 };

-- 
1.7.0.4

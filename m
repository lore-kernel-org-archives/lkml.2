Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab0FNKdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 06:33:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53071 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469Ab0FNKdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 06:33:05 -0400
From: Luotao Fu <l.fu@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Luotao Fu <l.fu@pengutronix.de>
Subject: [PATCH 2/3 V2] gpio: add STMPE811 gpio controller support
Date: Mon, 14 Jun 2010 12:32:37 +0200
Message-Id: <1276511558-27121-3-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1276251195-22981-1-git-send-email-l.fu@pengutronix.de>
References: <1276251195-22981-1-git-send-email-l.fu@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one adds a driver for STMPE811 GPIO controller. STMPE811 is a
multifunction device. Hence this driver depends on stmpe811_core
driver for core functionalities. The gpio chip is registered to
gpiolib. Interrupts are currently not supported.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
---
V2 changes:
* include subsystem headers since they are now removed from the mfd
  core header file

 drivers/gpio/Kconfig         |   10 ++
 drivers/gpio/Makefile        |    1 +
 drivers/gpio/stmpe811_gpio.c |  238 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 249 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/stmpe811_gpio.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 724038d..38307e5 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -249,6 +249,16 @@ config GPIO_ADP5588
 	  To compile this driver as a module, choose M here: the module will be
 	  called adp5588-gpio.
 
+config GPIO_STMPE811
+	tristate "STMPE811 I2C MFD GPIO expander"
+	depends on I2C
+	depends on MFD_STMPE811
+	help
+	  This option enables support for 8 GPIOs found
+	  on STMicroelectronics STMPE811 multifunction devices.
+	  To compile this driver as a module, choose M here: the module will be
+	  called stmpe811_gpio.
+
 comment "PCI GPIO expanders:"
 
 config GPIO_CS5535
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 51c3cdd..7b184aa 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -31,3 +31,4 @@ obj-$(CONFIG_GPIO_WM8994)	+= wm8994-gpio.o
 obj-$(CONFIG_GPIO_SCH)		+= sch_gpio.o
 obj-$(CONFIG_GPIO_RDC321X)	+= rdc321x-gpio.o
 obj-$(CONFIG_GPIO_JANZ_TTL)	+= janz-ttl.o
+obj-$(CONFIG_GPIO_STMPE811)	+= stmpe811_gpio.o
diff --git a/drivers/gpio/stmpe811_gpio.c b/drivers/gpio/stmpe811_gpio.c
new file mode 100644
index 0000000..507fb5b
--- /dev/null
+++ b/drivers/gpio/stmpe811_gpio.c
@@ -0,0 +1,238 @@
+/*
+ * stmpe811_gpio.c  --  gpiolib support for STMicroelectronics STMPE811 chip.
+ *
+ * (c)2010 Luotao Fu <l.fu@pengutronix.de>
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
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/platform_device.h>
+#include <linux/i2c.h>
+#include <linux/workqueue.h>
+
+#include <linux/mfd/stmpe811.h>
+
+#define STMPE811_GPIO_NAME	"stmpe811-gpio"
+
+struct stmpe811_gpio {
+	struct stmpe811 *stm;
+	struct gpio_chip gpio;
+};
+
+static inline struct stmpe811_gpio *to_stmpe811_gpio(struct gpio_chip *chip)
+{
+	return container_of(chip, struct stmpe811_gpio, gpio);
+}
+
+static int stmpe811_gpio_direction_in(struct gpio_chip *chip, unsigned offset)
+{
+	struct stmpe811_gpio *stm_gpio = to_stmpe811_gpio(chip);
+
+	return stmpe811_reg_clear_bits(stm_gpio->stm,
+			STMPE811_REG_GPIO_DIR, BIT(offset));
+}
+
+static int stmpe811_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct stmpe811_gpio *stm_gpio = to_stmpe811_gpio(chip);
+	uint8_t gpio_sta;
+	int ret;
+
+	ret = stmpe811_reg_read(stm_gpio->stm,
+			STMPE811_REG_GPIO_MP_STA, &gpio_sta);
+	if (ret)
+		return ret;
+
+	if (gpio_sta & BIT(offset))
+		return 1;
+	else
+		return 0;
+}
+
+static inline int __stmpe811_gpio_set(struct stmpe811 *stm,
+		unsigned offset, int value)
+{
+	int ret;
+
+	if (value)
+		ret = stmpe811_reg_write(stm, STMPE811_REG_GPIO_SET_PIN,
+				BIT(offset));
+	else
+		ret = stmpe811_reg_write(stm, STMPE811_REG_GPIO_CLR_PIN,
+				BIT(offset));
+
+	return ret;
+}
+
+static int stmpe811_gpio_direction_out(struct gpio_chip *chip, unsigned offset,
+				       int value)
+{
+	struct stmpe811_gpio *stm_gpio = to_stmpe811_gpio(chip);
+	struct stmpe811 *stm = stm_gpio->stm;
+	int ret;
+
+	ret = stmpe811_reg_set_bits(stm, STMPE811_REG_GPIO_DIR, BIT(offset));
+	if (ret)
+		goto out;
+
+	ret = __stmpe811_gpio_set(stm, offset, value);
+out:
+	return ret;
+}
+
+static void stmpe811_gpio_set(struct gpio_chip *chip, unsigned offset,
+			      int value)
+{
+	struct stmpe811_gpio *stm_gpio = to_stmpe811_gpio(chip);
+
+	__stmpe811_gpio_set(stm_gpio->stm, offset, value);
+}
+
+static int stmpe811_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	struct stmpe811_gpio *stm_gpio = to_stmpe811_gpio(chip);
+	struct stmpe811 *stm = stm_gpio->stm;
+
+	if (offset > 3 && (stm->active_flag & STMPE811_USE_TS))
+		return 1;
+	else
+		return stmpe811_reg_set_bits(stm, STMPE811_REG_GPIO_AF,
+				BIT(offset));
+}
+
+static struct gpio_chip gpio_chip = {
+	.label = STMPE811_GPIO_NAME,
+	.owner = THIS_MODULE,
+	.direction_input = stmpe811_gpio_direction_in,
+	.get = stmpe811_gpio_get,
+	.direction_output = stmpe811_gpio_direction_out,
+	.set = stmpe811_gpio_set,
+	.request = stmpe811_gpio_request,
+	.can_sleep = 1,
+};
+
+static int __devinit stmpe811_gpio_probe(struct platform_device *pdev)
+{
+	struct stmpe811 *stm = dev_get_drvdata(pdev->dev.parent);
+	struct stmpe811_platform_data *pdata = stm->pdata;
+	struct stmpe811_gpio_platform_data *gpio_pdata = NULL;
+	struct stmpe811_gpio *stm_gpio;
+
+	int ret, tmp;
+
+	stm_gpio = kzalloc(sizeof(*stm_gpio), GFP_KERNEL);
+	if (!stm_gpio)
+		return -ENOMEM;
+
+	stm_gpio->stm = stm;
+	stm_gpio->gpio = gpio_chip;
+	stm_gpio->gpio.ngpio = 8;
+	stm_gpio->gpio.dev = &pdev->dev;
+
+	if (pdata)
+		gpio_pdata = pdata->gpio_pdata;
+
+	if (gpio_pdata && gpio_pdata->gpio_base)
+		stm_gpio->gpio.base = gpio_pdata->gpio_base;
+	else
+		stm_gpio->gpio.base = -1;
+
+	ret = gpiochip_add(&stm_gpio->gpio);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Could not register gpiochip, %d\n", ret);
+		goto err_free_stmgpio;
+	}
+	/* enable clock supply */
+	ret = stmpe811_reg_clear_bits(stm, STMPE811_REG_SYS_CTRL2,
+			STMPE811_SYS_CTRL2_GPIO_OFF);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not enable clock for gpio\n");
+		goto err_free_gpiochip;
+	}
+
+	if (gpio_pdata && gpio_pdata->setup) {
+		ret = gpio_pdata->setup(stm);
+
+		if (ret != 0) {
+			dev_err(&pdev->dev, "setup hook failed, %d\n",
+					ret);
+			goto err_free_gpiochip;
+		}
+	}
+
+	dev_info(&pdev->dev, "registerd gpios %d..%d on a stmpe811\n",
+			stm_gpio->gpio.base,
+			stm_gpio->gpio.base + stm_gpio->gpio.ngpio - 1);
+	platform_set_drvdata(pdev, stm_gpio);
+
+	return ret;
+
+err_free_gpiochip:
+	tmp = gpiochip_remove(&stm_gpio->gpio);
+	if (tmp) {
+		dev_err(&pdev->dev, "Could net remove gpio chip\n");
+		return ret;
+	}
+err_free_stmgpio:
+	kfree(stm_gpio);
+	return ret;
+}
+
+static int __devexit stmpe811_gpio_remove(struct platform_device *pdev)
+{
+	struct stmpe811_gpio *stm_gpio = platform_get_drvdata(pdev);
+	struct stmpe811_platform_data *pdata = stm_gpio->stm->pdata;
+	struct stmpe811_gpio_platform_data *gpio_pdata = NULL;
+	int ret;
+
+	if (pdata)
+		gpio_pdata = pdata->gpio_pdata;
+
+	if (gpio_pdata && gpio_pdata->remove)
+		gpio_pdata->remove(stm_gpio->stm);
+
+	/* disable clock supply */
+	stmpe811_reg_set_bits(stm_gpio->stm, STMPE811_REG_SYS_CTRL2,
+			STMPE811_SYS_CTRL2_GPIO_OFF);
+
+	ret = gpiochip_remove(&stm_gpio->gpio);
+	if (ret == 0)
+		kfree(stm_gpio);
+
+	return ret;
+}
+
+static struct platform_driver stmpe811_gpio_driver = {
+	.driver.name = STMPE811_GPIO_NAME,
+	.driver.owner = THIS_MODULE,
+	.probe = stmpe811_gpio_probe,
+	.remove = __devexit_p(stmpe811_gpio_remove),
+};
+
+static int __init stmpe811_gpio_init(void)
+{
+	return platform_driver_register(&stmpe811_gpio_driver);
+}
+
+subsys_initcall(stmpe811_gpio_init);
+
+static void __exit stmpe811_gpio_exit(void)
+{
+	platform_driver_unregister(&stmpe811_gpio_driver);
+}
+
+module_exit(stmpe811_gpio_exit);
+
+MODULE_AUTHOR("Luotao Fu <l.fu@pengutronix.de>");
+MODULE_DESCRIPTION("GPIO interface for STMicroelectronics STMPE811");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" STMPE811_GPIO_NAME);
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab2BFMtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 07:49:18 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:27862
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754919Ab2BFMtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 07:49:17 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzc8kzz1202hzz8275bh84d07hz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: [PATCH 03/07] LEDS: LED module for DA9052/53 PMIC v1
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: <rpurdie@rpsys.net>, <linux-kernel@vger.kernel.org>,
        David Dajun Chen <Dajun.Chen@diasemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 6 Feb 2012 18:12:37 +0530
Message-ID: <1328532157.30549.75.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LED Driver for Dialog Semiconductor DA9052/53 PMICs.

This patch is functionally tested on Samsung SMDKV6410.

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
 drivers/leds/Kconfig       |    8 ++
 drivers/leds/Makefile      |    1 +
 drivers/leds/leds-da9052.c |  214 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 223 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-da9052.c
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 8c7a75d..ed7b22b 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -258,6 +258,14 @@ config LEDS_DA903X
 	  This option enables support for on-chip LED drivers found
 	  on Dialog Semiconductor DA9030/DA9034 PMICs.
 
+config LEDS_DA9052
+	tristate "Dialog DA9052/DA9053 LEDS"
+	depends on LEDS_CLASS
+	depends on PMIC_DA9052
+	help
+	  This option enables support for on-chip LED drivers found
+	  on Dialog Semiconductor DA9052-BC and DA9053-AA/Bx PMICs.
+
 config LEDS_DAC124S085
 	tristate "LED Support for DAC124S085 SPI DAC"
 	depends on LEDS_CLASS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 6bcf4f6..59a158f 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_LEDS_OT200)		+= leds-ot200.o
 obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
 obj-$(CONFIG_LEDS_PCA955X)		+= leds-pca955x.o
 obj-$(CONFIG_LEDS_DA903X)		+= leds-da903x.o
+obj-$(CONFIG_LEDS_DA9052)		+= leds-da9052.o
 obj-$(CONFIG_LEDS_WM831X_STATUS)	+= leds-wm831x-status.o
 obj-$(CONFIG_LEDS_WM8350)		+= leds-wm8350.o
 obj-$(CONFIG_LEDS_PWM)			+= leds-pwm.o
diff --git a/drivers/leds/leds-da9052.c b/drivers/leds/leds-da9052.c
new file mode 100644
index 0000000..4ca045d
--- /dev/null
+++ b/drivers/leds/leds-da9052.c
@@ -0,0 +1,214 @@
+/*
+ * LED Driver for Dialog DA9052 PMICs.
+ *
+ * Copyright(c) 2012 Dialog Semiconductor Ltd.
+ *
+ * Author: David Dajun Chen <dchen@diasemi.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/leds.h>
+#include <linux/workqueue.h>
+#include <linux/slab.h>
+
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/pdata.h>
+
+#define DA9052_OPENDRAIN_OUTPUT	2
+#define DA9052_MASK_UPPER_NIBBLE	0xF0
+#define DA9052_MASK_LOWER_NIBBLE	0x0F
+#define DA9052_NIBBLE_SHIFT		4
+
+struct da9052_led {
+	struct led_classdev cdev;
+	struct work_struct work;
+	struct da9052 *da9052;
+	unsigned char led_index;
+	unsigned char id;
+	int brightness;
+};
+
+unsigned char led_reg[] = {
+	DA9052_LED_CONT_4_REG,
+	DA9052_LED_CONT_5_REG,
+};
+
+static int da9052_set_led_brightness(struct da9052_led *led)
+{
+	u8 val;
+	int error;
+
+	val = (led->brightness * 0x5f / LED_FULL) & 0x7f;
+	val |= DA9052_LED_CONT_DIM;
+
+	error = da9052_reg_write(led->da9052, led_reg[led->led_index], val);
+	if (error < 0)
+		dev_err(led->da9052->dev, "Failed to set led brightness, %d\n",
+			error);
+	return error;
+}
+
+static void da9052_led_work(struct work_struct *work)
+{
+	struct da9052_led *led = container_of(work, struct da9052_led, work);
+
+	da9052_set_led_brightness(led);
+}
+
+static void da9052_led_set(struct led_classdev *led_cdev,
+			   enum led_brightness value)
+{
+	struct da9052_led *led;
+
+	led = container_of(led_cdev, struct da9052_led, cdev);
+	led->brightness = value;
+	schedule_work(&led->work);
+}
+
+static int da9052_configure_leds(struct da9052_led *led)
+{
+	int error;
+	unsigned char register_value = DA9052_OPENDRAIN_OUTPUT | 1 << 3;
+
+	error = da9052_reg_update(led->da9052, DA9052_GPIO_14_15_REG,
+				  DA9052_MASK_LOWER_NIBBLE,
+				  register_value);
+
+	if (error < 0) {
+		dev_err(led->da9052->dev, "Failed to write GPIO 14-15 reg, %d\n",
+			error);
+		return error;
+	}
+
+	error = da9052_reg_update(led->da9052, DA9052_GPIO_14_15_REG,
+				  DA9052_MASK_UPPER_NIBBLE,
+				  register_value << DA9052_NIBBLE_SHIFT);
+	if (error < 0)
+		dev_err(led->da9052->dev, "Failed to write GPIO 14-15 reg, %d\n",
+			error);
+
+	return error;
+}
+
+static int __devinit da9052_led_probe(struct platform_device *pdev)
+{
+	struct da9052_pdata *pdata;
+	struct da9052 *da9052;
+	struct led_platform_data *pled;
+	struct da9052_led *led = NULL;
+	int error;
+	int i;
+
+	da9052 = dev_get_drvdata(pdev->dev.parent);
+	pdata = da9052->dev->platform_data;
+	if (pdata == NULL) {
+		dev_err(&pdev->dev, "No platform data\n");
+		error = -ENODEV;
+		goto err_mem;
+	}
+
+	pled = pdata->pled;
+	if (pled == NULL) {
+		dev_err(&pdev->dev, "Failed no platform data for LED\n");
+		return -ENOMEM;
+	}
+
+	led = devm_kzalloc(&pdev->dev,
+			   sizeof(struct da9052_led) * pled->num_leds,
+			   GFP_KERNEL);
+	if (led == NULL) {
+		dev_err(&pdev->dev, "Failed to alloc memory\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < pled->num_leds; i++) {
+		led[i].cdev.name = pled->leds[i].name;
+		led[i].cdev.brightness_set = da9052_led_set;
+		led[i].cdev.brightness = LED_OFF;
+		led[i].brightness = LED_OFF;
+		led[i].led_index = pled->leds[i].flags;
+		led[i].da9052 = dev_get_drvdata(pdev->dev.parent);
+		INIT_WORK(&led[i].work, da9052_led_work);
+
+		error = led_classdev_register(pdev->dev.parent, &led[i].cdev);
+		if (error) {
+			dev_err(&pdev->dev, "Failed to register led %d\n",
+				led[i].led_index);
+			goto err_register;
+		}
+
+		error = da9052_set_led_brightness(&led[i]);
+		if (error) {
+			dev_err(&pdev->dev, "Unable to init led %d\n",
+				led[i].led_index);
+			continue;
+		}
+	}
+	error = da9052_configure_leds(led);
+	if (error) {
+		dev_err(&pdev->dev, "Failed to configure GPIO Led,%d\n", error);
+		goto err_register;
+	}
+
+	platform_set_drvdata(pdev, led);
+
+	return 0;
+
+err_register:
+	for (i = i - 1; i >= 0; i--) {
+		led_classdev_unregister(&led[i].cdev);
+		cancel_work_sync(&led[i].work);
+	}
+err_mem:
+	devm_kfree(&pdev->dev, led);
+	return error;
+}
+
+static int __devexit da9052_led_remove(struct platform_device *pdev)
+{
+	struct da9052_led *led = platform_get_drvdata(pdev);
+	struct da9052_pdata *pdata;
+	struct da9052 *da9052;
+	struct led_platform_data *pled;
+	int i;
+
+	da9052 = dev_get_drvdata(pdev->dev.parent);
+	pdata = da9052->dev->platform_data;
+	pled = pdata->pled;
+
+	for (i = 0; i < pled->num_leds; i++) {
+		led[i].brightness = 0;
+		da9052_set_led_brightness(&led[i]);
+		led_classdev_unregister(&led[i].cdev);
+		cancel_work_sync(&led[i].work);
+	}
+
+	devm_kfree(&pdev->dev, led);
+
+	return 0;
+}
+
+static struct platform_driver da9052_led_driver = {
+	.driver		= {
+		.name	= "da9052-leds",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= da9052_led_probe,
+	.remove		= __devexit_p(da9052_led_remove),
+};
+
+module_platform_driver(da9052_led_driver);
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
+MODULE_DESCRIPTION("LED driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL");



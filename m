Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172Ab0GBJ0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:26:33 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:10702 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758130Ab0GBJ0a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:26:30 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [RFC][PATCH 10/11] LEDS: Re-organization of the code & removal of testing framework
Date: Fri, 2 Jul 2010 10:26:26 +0100
Message-ID: <3495EC08FA53E94AAA00CC4743D5BA7E013FA8DE@pandora.diasemi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC][PATCH 10/11] LEDS: Re-organization of the code & removal of testing framework
Thread-Index: AcsZyKUa6fEcf2LSSqqD9lWJ8rS8fA==
From: "David Dajun Chen" <Dajun.Chen@diasemi.com>
To: <rpurdie@rpsys.net>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Jul 2010 09:26:27.0890 (UTC) FILETIME=[A5F8F120:01CB19C8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LED module of the device driver for DA9052 PMIC device from Dialog
Semiconductor.

Linux Kernel Version: 2.6.34

Signed-off-by: D. Chen <dchen@diasemi.com>
---
diff -urpN linux-2.6.34/drivers/leds/Kconfig
linux-2.6.34_test/drivers/leds/Kconfig
--- linux-2.6.34/drivers/leds/Kconfig	2010-05-17 02:17:36.000000000
+0500
+++ linux-2.6.34_test/drivers/leds/Kconfig	2010-07-01
18:16:37.000000000 +0500
@@ -225,6 +225,13 @@ config LEDS_DA903X
 	  This option enables support for on-chip LED drivers found
 	  on Dialog Semiconductor DA9030/DA9034 PMICs.
 
+config LEDS_DA9052
+	tristate "LED Support for DA9052"
+	depends on PMIC_DA9052
+	help
+	  This option enables support for on-chip LED drivers found
+	  on Dialog Semiconductor DA9052 PMICs.
+
 config LEDS_DAC124S085
 	tristate "LED Support for DAC124S085 SPI DAC"
 	depends on SPI
diff -urpN linux-2.6.34/drivers/leds/leds-da9052.c
linux-2.6.34_test/drivers/leds/leds-da9052.c
--- linux-2.6.34/drivers/leds/leds-da9052.c	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34_test/drivers/leds/leds-da9052.c	2010-07-01
18:16:23.000000000 +0500
@@ -0,0 +1,297 @@
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
+#include <linux/mfd/da9052/led.h>
+
+#define DRIVER_NAME		"da9052-leds"
+
+#define DA9052_LED4_PRESENT	1
+#define DA9052_LED5_PRESENT	1
+
+
+struct da9052_led_data {
+	struct led_classdev cdev;
+	struct work_struct work;
+	struct da9052 *da9052;
+	int id;
+	int new_brightness;
+	int is_led4_present;
+	int is_led5_present;
+};
+
+#define GPIO14_PIN		2 /* GPO Open Drain */
+#define GPIO14_TYPE		0 /* VDD_IO1 */
+#define GPIO14_MODE		1 /* Output High */
+
+#define GPIO15_PIN		2 /* GPO Open Drain */
+#define GPIO15_TYPE		0 /* VDD_IO1 */
+#define GPIO15_MODE		1 /* Output High */
+
+#define MAXIMUM_PWM		95
+#define MASK_GPIO14		0x0F
+#define MASK_GPIO15		0xF0
+#define GPIO15_PIN_BIT_POSITION	4
+
+static void da9052_led_work(struct work_struct *work)
+{
+	struct da9052_led_data *led = container_of(work,
+				 struct da9052_led_data, work);
+	int reg = 0;
+	int led_dim_bit = 0;
+	struct da9052_ssc_msg msg;
+	int ret = 0;
+
+	switch (led->id) {
+	case DA9052_LED_4:
+		reg = DA9052_LED4CONT_REG;
+		led_dim_bit = DA9052_LED4CONT_LED4DIM;
+		break;
+	case DA9052_LED_5:
+		reg = DA9052_LED5CONT_REG;
+		led_dim_bit = DA9052_LED5CONT_LED5DIM;
+		break;
+	}
+
+	if (led->new_brightness > MAXIMUM_PWM)
+		led->new_brightness = MAXIMUM_PWM;
+
+	/* Always enable DIM feature
+	 * This feature can be disabled if required
+	 */
+	msg.addr = reg;
+	msg.data = led->new_brightness | led_dim_bit;
+
+	da9052_lock(led->da9052);
+	led->da9052->write(led->da9052, &msg);
+	if (ret) {
+		da9052_unlock(led->da9052);
+		return;
+	}
+	da9052_unlock(led->da9052);
+}
+
+static void da9052_led_set(struct led_classdev *led_cdev,
+			   enum led_brightness value)
+{
+	struct da9052_led_data *led;
+
+	led = container_of(led_cdev, struct da9052_led_data, cdev);
+	led->new_brightness = value;
+	schedule_work(&led->work);
+}
+
+static int __devinit da9052_led_setup(struct da9052_led_data *led)
+{
+	int reg = 0;
+	int ret = 0;
+
+	struct da9052_ssc_msg msg;
+
+	switch (led->id) {
+	case DA9052_LED_4:
+		reg = DA9052_LED4CONT_REG;
+		break;
+	case DA9052_LED_5:
+		reg = DA9052_LED5CONT_REG;
+		break;
+	}
+
+	msg.addr = reg;
+	msg.data = 0;
+
+	da9052_lock(led->da9052);
+	ret = led->da9052->write(led->da9052, &msg);
+	if (ret) {
+		da9052_unlock(led->da9052);
+		return ret;
+	}
+	da9052_unlock(led->da9052);
+	return ret;
+}
+
+static int __devinit da9052_leds_prepare(struct da9052_led_data *led)
+{
+	int ret = 0;
+	struct da9052_ssc_msg msg;
+
+	if (1 == led->is_led4_present) {
+		msg.addr = DA9052_GPIO1415_REG;
+		msg.data = 0;
+
+		da9052_lock(led->da9052);
+		ret = led->da9052->read(led->da9052, &msg);
+		if (ret)
+			goto out;
+		msg.data = msg.data & ~(MASK_GPIO14);
+		msg.data = msg.data | (
+				GPIO14_PIN |
+				(GPIO14_TYPE ?
DA9052_GPIO1415_GPIO14TYPE : 0) |
+				(GPIO14_MODE ?
DA9052_GPIO1415_GPIO14MODE : 0));
+
+		ret = led->da9052->write(led->da9052, &msg);
+		if (ret)
+			goto out;
+	}
+
+	if (1 == led->is_led4_present) {
+		msg.addr = DA9052_GPIO1415_REG;
+		msg.data = 0;
+
+		ret = led->da9052->read(led->da9052, &msg);
+		if (ret)
+			goto out;
+		msg.data = msg.data & ~(MASK_GPIO15);
+		msg.data = msg.data |
+			(((GPIO15_PIN << GPIO15_PIN_BIT_POSITION) |
+				(GPIO15_TYPE ?
DA9052_GPIO1415_GPIO15TYPE : 0) |
+				(GPIO15_MODE ?
DA9052_GPIO1415_GPIO15MODE : 0))
+				);
+		ret = led->da9052->write(led->da9052, &msg);
+		if (ret)
+			goto out;
+	}
+
+	da9052_unlock(led->da9052);
+out:
+	da9052_unlock(led->da9052);
+	return ret;
+}
+
+static int __devinit da9052_led_probe(struct platform_device *pdev)
+{
+	struct da9052_leds_platform_data *pdata =
dev_get_platdata(&pdev->dev);
+	struct da9052_led_platform_data *led_cur;
+	struct da9052_led_data *led, *led_dat;
+	int ret, i;
+	int init_led = 0;
+
+	if (pdata == NULL) {
+		dev_err(&pdev->dev, "missing platform data\n");
+		return -ENODEV;
+	}
+
+	if (pdata->num_leds < 1 || pdata->num_leds > DA9052_LED_MAX) {
+		dev_err(&pdev->dev, "Invalid led count %d\n",
pdata->num_leds);
+		return -EINVAL;
+	}
+
+	led = kzalloc(sizeof(*led) * pdata->num_leds, GFP_KERNEL);
+	if (led == NULL) {
+		dev_err(&pdev->dev, "failed to alloc memory\n");
+		return -ENOMEM;
+	}
+
+	led->is_led4_present = DA9052_LED4_PRESENT;
+	led->is_led5_present = DA9052_LED5_PRESENT;
+
+	ret = da9052_leds_prepare(led);
+	if (ret) {
+		dev_err(&pdev->dev, "unable to init led driver\n");
+		goto err_free;
+	}
+
+	for (i = 0; i < pdata->num_leds; i++) {
+		led_dat = &led[i];
+		led_cur = &pdata->led[i];
+
+		if (led_cur->id > DA9052_LED_MAX || led_cur->id < 0) {
+			dev_err(&pdev->dev, "invalid id %d\n",
led_cur->id);
+			ret = -EINVAL;
+			goto err_register;
+		}
+
+		if (init_led & (1 << led_cur->id)) {
+			dev_err(&pdev->dev, "led %d already
initialized\n",
+					led_cur->id);
+			ret = -EINVAL;
+			goto err_register;
+		}
+
+		init_led |= 1 << led_cur->id;
+		led_dat->cdev.name = led_cur->name;
+		led_dat->cdev.default_trigger =
led_cur->default_trigger;
+		led_dat->cdev.brightness_set = da9052_led_set;
+		led_dat->cdev.brightness = LED_OFF;
+		led_dat->id = led_cur->id;
+		led_dat->da9052 = dev_get_drvdata(pdev->dev.parent);
+
+		INIT_WORK(&led_dat->work, da9052_led_work);
+
+		ret = led_classdev_register(pdev->dev.parent,
&led_dat->cdev);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to register led
%d\n",
+					led_dat->id);
+			goto err_register;
+		}
+
+		ret = da9052_led_setup(led_dat);
+		if (ret) {
+			dev_err(&pdev->dev, "unable to init led %d\n",
+					led_dat->id);
+			i++;
+			goto err_register;
+		}
+	}
+
+	platform_set_drvdata(pdev, led);
+	return 0;
+
+err_register:
+	for (i = i - 1; i >= 0; i--) {
+		led_classdev_unregister(&led[i].cdev);
+		cancel_work_sync(&led[i].work);
+	}
+
+err_free:
+	kfree(led);
+	return ret;
+}
+
+static int __devexit da9052_led_remove(struct platform_device *pdev)
+{
+	struct da9052_leds_platform_data *pdata =
dev_get_platdata(&pdev->dev);
+	struct da9052_led_data *led = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < pdata->num_leds; i++) {
+		da9052_led_setup(&led[i]);
+		led_classdev_unregister(&led[i].cdev);
+		cancel_work_sync(&led[i].work);
+	}
+
+	kfree(led);
+	return 0;
+}
+
+static struct platform_driver da9052_led_driver = {
+	.driver	= {
+		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= da9052_led_probe,
+	.remove		= __devexit_p(da9052_led_remove),
+};
+
+static int __init da9052_led_init(void)
+{
+	return platform_driver_register(&da9052_led_driver);
+}
+module_init(da9052_led_init);
+
+static void __exit da9052_led_exit(void)
+{
+	platform_driver_unregister(&da9052_led_driver);
+}
+module_exit(da9052_led_exit);
+
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>")
+MODULE_DESCRIPTION("LED driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRIVER_NAME);
diff -urpN linux-2.6.34/drivers/leds/Makefile
linux-2.6.34_test/drivers/leds/Makefile
--- linux-2.6.34/drivers/leds/Makefile	2010-05-17 02:17:36.000000000
+0500
+++ linux-2.6.34_test/drivers/leds/Makefile	2010-07-01
18:16:31.000000000 +0500
@@ -27,6 +27,7 @@ obj-$(CONFIG_LEDS_HP6XX)		+= leds-hp6xx.
 obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
 obj-$(CONFIG_LEDS_PCA955X)		+= leds-pca955x.o
 obj-$(CONFIG_LEDS_DA903X)		+= leds-da903x.o
+obj-$(CONFIG_LEDS_DA9052)		+= leds-da9052.o
 obj-$(CONFIG_LEDS_WM831X_STATUS)	+= leds-wm831x-status.o
 obj-$(CONFIG_LEDS_WM8350)		+= leds-wm8350.o
 obj-$(CONFIG_LEDS_PWM)			+= leds-pwm.o
diff -urpN linux-2.6.34/include/linux/mfd/da9052/led.h
linux-2.6.34_test/include/linux/mfd/da9052/led.h
--- linux-2.6.34/include/linux/mfd/da9052/led.h	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34_test/include/linux/mfd/da9052/led.h	2010-07-01
18:17:11.000000000 +0500
@@ -0,0 +1,18 @@
+#ifndef DA9052_LED_H
+#define DA9052_LED_H
+
+struct da9052_led_platform_data {
+#define DA9052_LED_4	4
+#define DA9052_LED_5	5
+#define DA9052_LED_MAX	2
+	int id;
+	const char *name;
+	const char *default_trigger;
+};
+
+struct da9052_leds_platform_data {
+	int num_leds;
+	struct da9052_led_platform_data *led;
+};
+
+#endif /* __LINUX_MFD_DA9052_H */
Legal Disclaimer: This e-mail communication (and any attachment/s) is confidential and contains proprietary information, 
some or all of which may be legally privileged. It is intended solely for the use of the individual or entity to which it
is addressed. Access to this email by anyone else is unauthorized. If you are not the intended recipient, any disclosure, 
copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and may be unlawful.

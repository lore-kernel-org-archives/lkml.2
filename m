Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab0HZHOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 03:14:19 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:44524 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752713Ab0HZHOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 03:14:17 -0400
X-Greylist: delayed 1391 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Aug 2010 03:14:16 EDT
From: Arun Murthy <arun.murthy@stericsson.com>
To: <sameo@linux.intel.com>, <riku.voipio@iki.fi>
Cc: <linux-kernel@vger.kernel.org>, <STEricsson_nomadik_linux@list.st.com>,
        <arun.murthy@stericsson.com>, <linus.walleij@stericsson.com>,
        <srinidhi.kasagar@stericsson.com>
Subject: [PATCH 3/3] leds: ab8500-led: led driver based on ab8500 pwm
Date: Thu, 26 Aug 2010 12:20:32 +0530
Message-ID: <1282805432-28523-4-git-send-email-arun.murthy@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1282805432-28523-1-git-send-email-arun.murthy@stericsson.com>
References: <1282805432-28523-1-git-send-email-arun.murthy@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds led class driver for controlling u8500 leds and
backlight. LED intensity is controlled by by Ananlog Baseband Chip
AB8500 Pulse Width Modulation(pwm).

Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
Acked-by: Mattias Wallin <mattias.wallin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/leds/Kconfig       |    9 ++
 drivers/leds/Makefile      |    1 +
 drivers/leds/leds-ab8500.c |  201 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/ab8500-core.c  |    3 +
 include/linux/mfd/ab8500.h |    1 +
 5 files changed, 215 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-ab8500.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index e411262..8e554af 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -26,6 +26,15 @@ config LEDS_88PM860X
 	  This option enables support for on-chip LED drivers found on Marvell
 	  Semiconductor 88PM8606 PMIC.
 
+config LEDS_AB8500
+	bool "ab8500-pwm: led driver"
+	depends on LEDS_CLASS && AB8500_CORE
+	select AB8500_PWM
+	help
+	  This option enables led class driver support for ab8500 pwm devices.
+	  If in doubt, it's safe to enable this option; it doesn't kick
+	  in unless the board's description says it's wired that way.
+
 config LEDS_ATMEL_PWM
 	tristate "LED Support using Atmel PWM outputs"
 	depends on ATMEL_PWM
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 7d6b958..7ba6448 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_LEDS_ADP5520)		+= leds-adp5520.o
 obj-$(CONFIG_LEDS_DELL_NETBOOKS)	+= dell-led.o
 obj-$(CONFIG_LEDS_MC13783)		+= leds-mc13783.o
 obj-$(CONFIG_LEDS_NS2)			+= leds-ns2.o
+obj-$(CONFIG_LEDS_AB8500)		+= leds-ab8500.o
 
 # LED SPI Drivers
 obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
diff --git a/drivers/leds/leds-ab8500.c b/drivers/leds/leds-ab8500.c
new file mode 100644
index 0000000..9a0a9e9
--- /dev/null
+++ b/drivers/leds/leds-ab8500.c
@@ -0,0 +1,201 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * Author: Dushyanth S R <dushyanth.sr@stericsson.com>
+ * Author: Arun R Murthy <arun.murthy@stericsson.com>
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/leds.h>
+#include <linux/mfd/ab8500.h>
+#include <linux/mfd/abx500/ab8500-pwm.h>
+
+struct ab8500_led {
+	struct led_classdev ab8500_led_cdev;
+	struct ab8500_pwm_pdata *pwm;
+	struct device *dev;
+};
+
+static void ab8500_led_brightness_set(struct led_classdev *led_cdev,
+	enum led_brightness value)
+{
+	struct ab8500_led *led = container_of(led_cdev,
+						struct ab8500_led,
+						ab8500_led_cdev);
+	int cnt;
+
+	if (value > led_cdev->max_brightness)
+		value = led_cdev->max_brightness;
+
+	for (cnt = 0; cnt < MAX_PWM_CTRL; cnt++) {
+		if (!led->pwm->pwm_no[cnt])
+			break;
+		ab8500_pwm_set_int(led->dev,
+				led_cdev->max_brightness,
+				value,
+				led->pwm->pwm_no[cnt]);
+	}
+	led_cdev->brightness = value;
+}
+
+enum led_brightness (ab8500_led_brightness_get)
+				(struct led_classdev *led_cdev)
+{
+	struct ab8500_led *led = container_of(led_cdev,
+						struct ab8500_led,
+						ab8500_led_cdev);
+	int val;
+
+	val = ab8500_pwm_get_int(led->dev,
+				led_cdev->max_brightness,
+				led->pwm->pwm_no[0]);
+	return val;
+}
+
+static int __devinit ab8500_led_probe(struct platform_device *pdev)
+{
+	int ret = 0;
+	int cnt;
+	struct ab8500_led *led, *led_data;
+	struct ab8500_platform_data *plat;
+	struct ab8500_pwm_pdata *cur_led;
+	struct ab8500 *ab8500;
+
+	led_data = kzalloc(sizeof(struct ab8500_led) * TOTAL_NO_PWM,
+								GFP_KERNEL);
+	if (!led_data)
+		return -ENOMEM;
+
+	led = led_data;
+	ab8500 = dev_get_drvdata(pdev->dev.parent);
+	plat = dev_get_platdata(ab8500->dev);
+	if (plat->led == NULL) {
+		kfree(led_data);
+		return -EINVAL;
+	}
+
+	for (cnt = 0; cnt < TOTAL_NO_PWM; cnt++) {
+		cur_led = &plat->led[cnt];
+		if (!cur_led->name)
+			break;
+		led = &led_data[cnt];
+		led->pwm = cur_led;
+		led->dev = &pdev->dev;
+
+		led->ab8500_led_cdev.name = cur_led->name;
+		led->ab8500_led_cdev.max_brightness = cur_led->max_intensity;
+		led->ab8500_led_cdev.brightness_set = ab8500_led_brightness_set;
+		led->ab8500_led_cdev.brightness_get = ab8500_led_brightness_get;
+		ret = led_classdev_register(&pdev->dev,	&led->ab8500_led_cdev);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+					"led device class register failed\n");
+			while (cnt--) {
+				led = &led_data[cnt];
+				led_classdev_unregister(&led->ab8500_led_cdev);
+			}
+			kfree(led);
+			return ret;
+		}
+	}
+	dev_info(&pdev->dev, "led driver probe success\n");
+	return ret;
+}
+
+#ifdef CONFIG_PM
+static int ab8500_led_suspend(struct device *dev)
+{
+	int cnt;
+	struct platform_device *pdev = to_platform_device(dev);
+	struct ab8500_led *led = platform_get_drvdata(pdev);
+	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
+	struct ab8500_platform_data *plat =
+				dev_get_platdata(ab8500->dev);
+	struct ab8500_pwm_pdata *cur_led;
+
+	for (cnt = 0; cnt < TOTAL_NO_PWM; cnt++) {
+		cur_led = &plat->led[cnt];
+		if (!cur_led->name)
+			break;
+		led_classdev_suspend(&led[cnt].ab8500_led_cdev);
+	}
+
+	return 0;
+}
+
+static int ab8500_led_resume(struct device *dev)
+{
+	int cnt;
+	struct platform_device *pdev = to_platform_device(dev);
+	struct ab8500_led *led = platform_get_drvdata(pdev);
+	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
+	struct ab8500_platform_data *plat =
+				dev_get_platdata(ab8500->dev);
+	struct ab8500_pwm_pdata *cur_led;
+
+	for (cnt = 0; cnt < TOTAL_NO_PWM; cnt++) {
+		cur_led = &plat->led[cnt];
+		if (!cur_led->name)
+			break;
+		led_classdev_resume(&led[cnt].ab8500_led_cdev);
+	}
+
+	return 0;
+}
+
+static const struct dev_pm_ops ab8500_led_pm_ops = {
+	.suspend	= ab8500_led_suspend,
+	.resume		= ab8500_led_resume,
+};
+#endif
+
+static int __devexit ab8500_led_remove(struct platform_device *pdev)
+{
+	struct ab8500_led *led = platform_get_drvdata(pdev);
+	struct ab8500_pwm_pdata *cur_led;
+	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
+	struct ab8500_platform_data *plat = dev_get_platdata(ab8500->dev);
+	int cnt;
+
+	for (cnt = 0; cnt < TOTAL_NO_PWM; cnt++) {
+		cur_led = &plat->led[cnt];
+		if (!cur_led->name)
+			break;
+		led_classdev_unregister(&led[cnt].ab8500_led_cdev);
+	}
+	kfree(led);
+
+	return 0;
+}
+
+static struct platform_driver ab8500_led_driver = {
+	.driver		= {
+		.name	= "ab8500-pwm-led",
+		.owner	= THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm	= &ab8500_led_pm_ops,
+#endif
+	},
+	.probe		= ab8500_led_probe,
+	.remove		= __devexit_p(ab8500_led_remove),
+};
+
+static int __init ab8500_led_init(void)
+{
+	return platform_driver_register(&ab8500_led_driver);
+}
+
+static void __exit ab8500_led_exit(void)
+{
+	platform_driver_unregister(&ab8500_led_driver);
+}
+
+module_init(ab8500_led_init);
+module_exit(ab8500_led_exit);
+
+MODULE_AUTHOR("Dushyanth S R, Arun Murthy");
+MODULE_DESCRIPTION("ab8500-pwm: led driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index b193d45..84a84a8 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -397,6 +397,9 @@ static struct mfd_cell ab8500_devs[] = {
 	{
 		.name = "ab8500-pwm-bl",
 	},
+	{
+		.name = "ab8500-pwm-led",
+	},
 	{ .name = "ab8500-charger", },
 	{ .name = "ab8500-audio", },
 	{ .name = "ab8500-usb", },
diff --git a/include/linux/mfd/ab8500.h b/include/linux/mfd/ab8500.h
index cb8328b..b420dbb 100644
--- a/include/linux/mfd/ab8500.h
+++ b/include/linux/mfd/ab8500.h
@@ -150,6 +150,7 @@ struct ab8500_platform_data {
 	void (*init) (struct ab8500 *);
 	struct regulator_init_data *regulator[AB8500_NUM_REGULATORS];
 	struct ab8500_pwm_pdata *pwm;
+	struct ab8500_pwm_pdata *led;
 };
 
 extern int __devinit ab8500_init(struct ab8500 *ab8500);
-- 
1.6.3.3


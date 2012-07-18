Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab2GROeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 10:34:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38836 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab2GROem convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 10:34:42 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>
Subject: [PATCH 6/6] leds: add new lp8788 led driver
Thread-Topic: [PATCH 6/6] leds: add new lp8788 led driver
Thread-Index: Ac1k8l8Zs2t3B0LiRYys7+2pd2SMsA==
Date: Wed, 18 Jul 2012 14:34:02 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FD7DE@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.177.86]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TI LP8788 PMU has the current sink as the keyboard led driver.
The brightness is controlled by the i2c commands.
Configurable parameters can be defined in the platform side.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/Kconfig       |    7 ++
 drivers/leds/Makefile      |    1 +
 drivers/leds/leds-lp8788.c |  178 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 186 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-lp8788.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index f028f03..a498deb 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -200,6 +200,13 @@ config LEDS_LP5523
 	  Driver provides direct control via LED class and interface for
 	  programming the engines.
 
+config LEDS_LP8788
+	tristate "LED support for the TI LP8788 PMIC"
+	depends on LEDS_CLASS
+	depends on MFD_LP8788
+	help
+	  This option enables support for the Keyboard LEDs on the LP8788 PMIC.
+
 config LEDS_CLEVO_MAIL
 	tristate "Mail LED on Clevo notebook"
 	depends on LEDS_CLASS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 5eebd7b..f156193 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_LEDS_GPIO)			+= leds-gpio.o
 obj-$(CONFIG_LEDS_LP3944)		+= leds-lp3944.o
 obj-$(CONFIG_LEDS_LP5521)		+= leds-lp5521.o
 obj-$(CONFIG_LEDS_LP5523)		+= leds-lp5523.o
+obj-$(CONFIG_LEDS_LP8788)		+= leds-lp8788.o
 obj-$(CONFIG_LEDS_TCA6507)		+= leds-tca6507.o
 obj-$(CONFIG_LEDS_CLEVO_MAIL)		+= leds-clevo-mail.o
 obj-$(CONFIG_LEDS_HP6XX)		+= leds-hp6xx.o
diff --git a/drivers/leds/leds-lp8788.c b/drivers/leds/leds-lp8788.c
new file mode 100644
index 0000000..d92625e
--- /dev/null
+++ b/drivers/leds/leds-lp8788.c
@@ -0,0 +1,178 @@
+/*
+ * TI LP8788 MFD - keyled driver
+ *
+ * Copyright 2012 Texas Instruments
+ *
+ * Author: Milo(Woogyom) Kim <milo.kim@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/leds.h>
+#include <linux/mfd/lp8788.h>
+#include <linux/mfd/lp8788-isink.h>
+
+#define MAX_BRIGHTNESS			LP8788_ISINK_MAX_PWM
+#define DEFAULT_LED_NAME		"keyboard-backlight"
+#define DEFAULT_ISINK_SCALE		LP8788_ISINK_SCALE_100mA
+#define DEFAULT_ISINK_NUM		LP8788_ISINK_3
+#define DEFAULT_ISINK_OUT		0
+
+struct lp8788_led {
+	struct lp8788 *lp;
+	struct led_classdev led_dev;
+	enum lp8788_isink_number isink_num;
+	int on;
+};
+
+static int lp8788_led_init_device(struct lp8788_led *led,
+				struct lp8788_led_platform_data *pdata)
+{
+	enum lp8788_isink_scale scale = DEFAULT_ISINK_SCALE;
+	enum lp8788_isink_number num = DEFAULT_ISINK_NUM;
+	int ret, iout = DEFAULT_ISINK_OUT;
+	u8 addr, mask, val;
+
+	if (pdata) {
+		scale = pdata->scale;
+		num = pdata->num;
+		iout = pdata->iout_code;
+	}
+
+	led->isink_num = num;
+
+	/* scale configuration */
+	addr = LP8788_ISINK_CTRL;
+	mask = 1 << (num + LP8788_ISINK_SCALE_OFFSET);
+	val = scale << num;
+	ret = lp8788_update_bits(led->lp, addr, mask, val);
+	if (ret)
+		return ret;
+
+	/* current configuration */
+	addr = lp8788_iout_addr[num];
+	mask = lp8788_iout_mask[num];
+	val = iout;
+
+	return lp8788_update_bits(led->lp, addr, mask, val);
+}
+
+static void lp8788_led_enable(struct lp8788_led *led,
+			enum lp8788_isink_number num, int on)
+{
+	u8 mask = 1 << num;
+	u8 val = on << num;
+
+	if (lp8788_update_bits(led->lp, LP8788_ISINK_CTRL, mask, val))
+		return;
+
+	led->on = on;
+}
+
+static void lp8788_brightness_set(struct led_classdev *led_cdev,
+				enum led_brightness brt_val)
+{
+	struct lp8788_led *led =
+			container_of(led_cdev, struct lp8788_led, led_dev);
+	enum lp8788_isink_number num = led->isink_num;
+	int enable;
+
+	switch (num) {
+	case LP8788_ISINK_1:
+	case LP8788_ISINK_2:
+	case LP8788_ISINK_3:
+		lp8788_write_byte(led->lp, lp8788_pwm_addr[num], brt_val);
+		break;
+	default:
+		return;
+	}
+
+	enable = (brt_val > 0) ? 1 : 0;
+
+	if (enable != led->on)
+		lp8788_led_enable(led, num, enable);
+}
+
+static __devinit int lp8788_led_probe(struct platform_device *pdev)
+{
+	struct lp8788 *lp = dev_get_drvdata(pdev->dev.parent);
+	struct lp8788_led_platform_data *led_pdata;
+	struct lp8788_led *led;
+	int ret;
+
+	led = devm_kzalloc(lp->dev, sizeof(struct lp8788_led), GFP_KERNEL);
+	if (!led)
+		return -ENOMEM;
+
+	led->lp = lp;
+	led->led_dev.max_brightness = MAX_BRIGHTNESS;
+	led->led_dev.brightness_set = lp8788_brightness_set;
+
+	led_pdata = lp->pdata ? lp->pdata->led_pdata : NULL;
+
+	if (!led_pdata || !led_pdata->name)
+		led->led_dev.name = DEFAULT_LED_NAME;
+	else
+		led->led_dev.name = led_pdata->name;
+
+	platform_set_drvdata(pdev, led);
+
+	ret = lp8788_led_init_device(led, led_pdata);
+	if (ret) {
+		dev_err(lp->dev, "led init device err: %d\n", ret);
+		goto err_dev;
+	}
+
+	ret = led_classdev_register(lp->dev, &led->led_dev);
+	if (ret) {
+		dev_err(lp->dev, "led register err: %d\n", ret);
+		goto err_dev;
+	}
+
+	return 0;
+
+err_dev:
+	return ret;
+}
+
+static int __devexit lp8788_led_remove(struct platform_device *pdev)
+{
+	struct lp8788_led *led = platform_get_drvdata(pdev);
+
+	led_classdev_unregister(&led->led_dev);
+	platform_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+static struct platform_driver lp8788_led_driver = {
+	.probe = lp8788_led_probe,
+	.remove = __devexit_p(lp8788_led_remove),
+	.driver = {
+		.name = LP8788_DEV_KEYLED,
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init lp8788_led_init(void)
+{
+	return platform_driver_register(&lp8788_led_driver);
+}
+module_init(lp8788_led_init);
+
+static void __exit lp8788_led_exit(void)
+{
+	platform_driver_unregister(&lp8788_led_driver);
+}
+module_exit(lp8788_led_exit);
+
+MODULE_DESCRIPTION("Texas Instruments LP8788 Keyboard LED Driver");
+MODULE_AUTHOR("Milo Kim");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:lp8788-keyled");
-- 
1.7.2.5


Best Regards,
Milo



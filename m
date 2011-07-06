Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab1GFKml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 06:42:41 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:54706
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752318Ab1GFKmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 06:42:40 -0400
X-SpamScore: 10
X-BigFish: VPS10(zzc8kzz1202h10d2nzz8275bhz32i2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:203.197.93.240;KIP:(null);UIP:(null);IPVD:NLI;H:Kcinpunhjhc01.kpit.com;RD:Kcinpunhjhc01.Kpit.com;EFVD:NLI
Subject: [PATCH 9/11] Backlight: DA9052 Backlight driver v2
From: ashishj3 <ashish.jangam@kpitcummins.com>
Reply-To: <ashish.jangam@kpitcummins.com>
To: <rpurdie@rpsys.net>
CC: <tfransosi@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linaro-dev@lists.linaro.org>, <dchen@diasemi.com>, <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 6 Jul 2011 16:12:15 +0530
Message-ID: <1309948935.4168.17.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DA9052 PMIC has capability to supply power for upto 3 banks of 6 white serial
LEDS. It can also control intensity of independent banks and to drive these
banks boost converter will provide up to 24V and forward current of max. 50mA.

This patch allows to control intensity of the individual WLEDs bank through
DA9052 PMIC.

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
CC: Arnd Bergmann <arnd@arndb.de>
---
Changes since v2:
- Modify driver registrations to single.
---
 drivers/video/backlight/Kconfig     |    6 +
 drivers/video/backlight/Makefile    |    1 +
 drivers/video/backlight/da9052_bl.c |  205 +++++++++++++++++++++++++++++++++++
 3 files changed, 212 insertions(+), 0 deletions(-)
 create mode 100755 drivers/video/backlight/da9052_bl.c
diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 0c9373b..023963f 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -237,6 +237,12 @@ config BACKLIGHT_DA903X
 	  If you have a LCD backlight connected to the WLED output of DA9030
 	  or DA9034 WLED output, say Y here to enable this driver.
 
+config BACKLIGHT_DA9052
+	tristate "Dialog DA9052 WLED"
+	depends on PMIC_DA9052
+	help
+	  Enable the DA9052 Backlight Driver
+
 config BACKLIGHT_MAX8925
 	tristate "Backlight driver for MAX8925"
 	depends on MFD_MAX8925
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index b9ca849..5dd5ac6 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_BACKLIGHT_PROGEAR) += progear_bl.o
 obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) += cr_bllcd.o
 obj-$(CONFIG_BACKLIGHT_PWM)	+= pwm_bl.o
 obj-$(CONFIG_BACKLIGHT_DA903X)	+= da903x_bl.o
+obj-$(CONFIG_BACKLIGHT_DA9052)	+= da9052_bl.o
 obj-$(CONFIG_BACKLIGHT_MAX8925)	+= max8925_bl.o
 obj-$(CONFIG_BACKLIGHT_APPLE)	+= apple_bl.o
 obj-$(CONFIG_BACKLIGHT_TOSA)	+= tosa_bl.o
diff --git a/drivers/video/backlight/da9052_bl.c b/drivers/video/backlight/da9052_bl.c
new file mode 100755
index 0000000..6fcf741
--- /dev/null
+++ b/drivers/video/backlight/da9052_bl.c
@@ -0,0 +1,205 @@
+/*
+ * Backlight Driver for Dialog DA9052 PMICs
+ *
+ * Copyright(c) 2011 Dialog Semiconductor Ltd.
+ *
+ * Author: David Dajun Chen <dchen@diasemi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/backlight.h>
+#include <linux/delay.h>
+#include <linux/fb.h>
+#include <linux/platform_device.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+
+#define DA9052_MAX_BRIGHTNESS		0xFF
+
+enum {
+	DA9052_WLEDS_OFF,
+	DA9052_WLEDS_ON,
+};
+
+enum {
+	DA9052_TYPE_WLED1,
+	DA9052_TYPE_WLED2,
+	DA9052_TYPE_WLED3,
+};
+
+static unsigned char wled_bank[] = {
+	DA9052_LED1_CONF_REG,
+	DA9052_LED2_CONF_REG,
+	DA9052_LED3_CONF_REG,
+};
+
+struct da9052_bl {
+	struct da9052 *da9052;
+	uint brightness;
+	uint state;
+	uint led_reg;
+};
+
+static int da9052_adjust_wled_brightness(struct da9052_bl *wleds)
+{
+	unsigned char boost_en;
+	unsigned char i_sink;
+	int ret;
+
+	boost_en = 0x3F;
+	i_sink = 0xFF;
+	if (wleds->state == DA9052_WLEDS_OFF) {
+		boost_en = 0x00;
+		i_sink = 0x00;
+	}
+
+	ret = da9052_reg_write(wleds->da9052, DA9052_BOOST_REG, boost_en);
+	if (ret < 0) {
+		dev_err(wleds->da9052->dev,
+			"Failed to write boost reg, %d\n", ret);
+		return ret;
+	}
+
+	ret = da9052_reg_write(wleds->da9052, DA9052_LED_CONT_REG, i_sink);
+	if (ret < 0) {
+		dev_err(wleds->da9052->dev,
+			"Failed to write led cont reg, %d\n", ret);
+		return ret;
+	}
+
+	ret = da9052_reg_write(wleds->da9052, wled_bank[wleds->led_reg], 0x0);
+	if (ret < 0) {
+		dev_err(wleds->da9052->dev,
+			"Failed to write led conf reg, %d", ret);
+		return ret;
+	}
+
+	if (wleds->brightness) {
+		msleep(10);
+		ret = da9052_reg_write(wleds->da9052, wled_bank[wleds->led_reg],
+				       wleds->brightness);
+		if (ret < 0) {
+			dev_err(wleds->da9052->dev,
+				"Failed to write led conf reg, %d", ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int da9052_backlight_update_status(struct backlight_device *bl)
+{
+	int brightness = bl->props.brightness;
+	struct da9052_bl *wleds = bl_get_data(bl);
+
+	wleds->brightness = brightness;
+	wleds->state = DA9052_WLEDS_ON;
+
+	return da9052_adjust_wled_brightness(wleds);
+}
+
+static int da9052_backlight_get_brightness(struct backlight_device *bl)
+{
+	struct da9052_bl *wleds = bl_get_data(bl);
+
+	return wleds->brightness;
+}
+
+static const struct backlight_ops da9052_backlight_ops = {
+	.update_status = da9052_backlight_update_status,
+	.get_brightness = da9052_backlight_get_brightness,
+};
+
+static int da9052_backlight_probe(struct platform_device *pdev)
+{
+	struct backlight_device *bl;
+	struct backlight_properties props;
+	static int led_reg_num;
+	struct da9052_bl *wleds;
+
+	wleds = kzalloc(sizeof(struct da9052_bl), GFP_KERNEL);
+	if (!wleds)
+		return -ENOMEM;
+
+	wleds->da9052 = dev_get_drvdata(pdev->dev.parent);
+	wleds->brightness = 0;
+	wleds->led_reg = platform_get_device_id(pdev)->driver_data;
+	wleds->state = DA9052_WLEDS_OFF;
+
+	bl = backlight_device_register(pdev->name, wleds->da9052->dev, wleds,
+				       &da9052_backlight_ops, &props);
+	if (IS_ERR(bl)) {
+		dev_err(&pdev->dev, "Failed to register backlight\n");
+		kfree(wleds);
+		return PTR_ERR(bl);
+	}
+
+	bl->props.max_brightness = DA9052_MAX_BRIGHTNESS;
+	bl->props.brightness = 0;
+	platform_set_drvdata(pdev, bl);
+
+	return da9052_adjust_wled_brightness(wleds);
+}
+
+static int da9052_backlight_remove(struct platform_device *pdev)
+{
+	struct backlight_device *bl = platform_get_drvdata(pdev);
+	struct da9052_bl *wleds = bl_get_data(bl);
+
+	wleds->brightness = 0;
+	wleds->state = DA9052_WLEDS_OFF;
+	da9052_adjust_wled_brightness(wleds);
+	backlight_device_unregister(bl);
+
+	return 0;
+}
+
+static struct platform_device_id da9052_wled_ids[] = {
+	{
+		.name		= "da9052-WLED1",
+		.driver_data	= DA9052_TYPE_WLED1,
+	},
+	{
+		.name		= "da9052-WLED2",
+		.driver_data	= DA9052_TYPE_WLED2,
+	},
+	{
+		.name		= "da9052-WLED3",
+		.driver_data	= DA9052_TYPE_WLED3,
+	},
+	{}
+};
+
+static struct platform_driver da9052_wled_driver = {
+	.probe		= da9052_backlight_probe,
+	.remove		= da9052_backlight_remove,
+	.id_table	= da9052_wled_ids,
+	.driver	= {
+		.name	= "da9052-WLED",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init da9052_backlight_init(void)
+{
+	return platform_driver_register(&da9052_wled_driver);
+}
+module_init(da9052_backlight_init);
+
+static void __exit da9052_backlight_exit(void)
+{
+	platform_driver_unregister(&da9052_wled_driver);
+}
+module_exit(da9052_backlight_exit);
+
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_DESCRIPTION("Backlight driver for DA9052 PMIC");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:da9052-backlight");



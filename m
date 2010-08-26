Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab0HZHOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 03:14:21 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:49930 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752793Ab0HZHOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 03:14:17 -0400
From: Arun Murthy <arun.murthy@stericsson.com>
To: <sameo@linux.intel.com>, <riku.voipio@iki.fi>
Cc: <linux-kernel@vger.kernel.org>, <STEricsson_nomadik_linux@list.st.com>,
        <arun.murthy@stericsson.com>, <linus.walleij@stericsson.com>,
        <srinidhi.kasagar@stericsson.com>
Subject: [PATCH 2/3] backlight: u8500: backlight driver based on ab8500 pwm
Date: Thu, 26 Aug 2010 12:20:31 +0530
Message-ID: <1282805432-28523-3-git-send-email-arun.murthy@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1282805432-28523-1-git-send-email-arun.murthy@stericsson.com>
References: <1282805432-28523-1-git-send-email-arun.murthy@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds backlight driver for u8500 platform.
Backlight intensity is controlled by Analog Baseband Chip AB8500
Pulse Width Modulation(pwm).

Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
Acked-by: Mattias Wallin <mattias.wallin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mfd/ab8500-core.c           |    4 +-
 drivers/video/backlight/Kconfig     |   10 ++
 drivers/video/backlight/Makefile    |    2 +-
 drivers/video/backlight/ab8500_bl.c |  209 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/ab8500.h          |    4 +
 5 files changed, 227 insertions(+), 2 deletions(-)
 create mode 100644 drivers/video/backlight/ab8500_bl.c

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 6548f50..b193d45 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -394,10 +394,12 @@ static struct mfd_cell ab8500_devs[] = {
 		.num_resources = ARRAY_SIZE(ab8500_rtc_resources),
 		.resources = ab8500_rtc_resources,
 	},
+	{
+		.name = "ab8500-pwm-bl",
+	},
 	{ .name = "ab8500-charger", },
 	{ .name = "ab8500-audio", },
 	{ .name = "ab8500-usb", },
-	{ .name = "ab8500-pwm", },
 	{ .name = "ab8500-regulator", },
 };
 
diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index e54a337..61bf6c9 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -126,6 +126,16 @@ config BACKLIGHT_CLASS_DEVICE
 
 if BACKLIGHT_CLASS_DEVICE
 
+config BACKLIGHT_AB8500_LCD
+	bool "ab8500 lcd backlight control"
+	depends on BACKLIGHT_CLASS_DEVICE && AB8500_CORE
+	select AB8500_PWM
+	help
+	  This provides backlight control to U8500 platform primary
+	  and secondary lcd.
+	  If in doubt, it's safe to enable this option; it doesn't kick
+	  in unless the board's description says it's wired that way.
+
 config BACKLIGHT_ATMEL_LCDC
 	bool "Atmel LCDC Contrast-as-Backlight control"
 	depends on FB_ATMEL
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index 44c0f81..a796418 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -35,4 +35,4 @@ obj-$(CONFIG_BACKLIGHT_ADP5520)	+= adp5520_bl.o
 obj-$(CONFIG_BACKLIGHT_ADP8860)	+= adp8860_bl.o
 obj-$(CONFIG_BACKLIGHT_88PM860X) += 88pm860x_bl.o
 obj-$(CONFIG_BACKLIGHT_PCF50633)	+= pcf50633-backlight.o
-
+obj-$(CONFIG_BACKLIGHT_AB8500_LCD)	+= ab8500_bl.o
diff --git a/drivers/video/backlight/ab8500_bl.c b/drivers/video/backlight/ab8500_bl.c
new file mode 100644
index 0000000..dea3f76
--- /dev/null
+++ b/drivers/video/backlight/ab8500_bl.c
@@ -0,0 +1,209 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * Author: Arun R Murthy <arun.murthy@stericsson.com>
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/backlight.h>
+#include <linux/mfd/ab8500.h>
+#include <linux/mfd/abx500/ab8500-pwm.h>
+
+struct ab8500_bl {
+	struct device *dev;
+	struct ab8500_pwm_pdata *pwm;
+	struct backlight_device *ab8500_bklt;
+	struct backlight_properties ab8500_bklt_props;
+};
+
+static int ab8500_bl_update_status(struct backlight_device *bl)
+{
+	struct ab8500_bl *bklt = bl_get_data(bl);
+	int cnt, ret;
+	int value = bl->props.brightness;
+
+	for (cnt = 0; cnt < MAX_PWM_CTRL; cnt++) {
+		if (!bklt->pwm->pwm_no[cnt])
+			break;
+		if (value > bklt->ab8500_bklt_props.max_brightness)
+			value = bklt->ab8500_bklt_props.max_brightness;
+		ret = ab8500_pwm_set_int(bklt->dev,
+				bklt->ab8500_bklt_props.max_brightness,
+				value, bklt->pwm->pwm_no[cnt]);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
+static int ab8500_bl_get_brightness(struct backlight_device *bl)
+{
+	struct ab8500_bl *bklt = bl_get_data(bl);
+	int val = 0;
+
+	val = ab8500_pwm_get_int(bklt->dev,
+				bklt->ab8500_bklt_props.max_brightness,
+				bklt->pwm->pwm_no[0]);
+
+	return val;
+}
+
+static const struct backlight_ops ab8500_bklt_fops = {
+	.update_status = ab8500_bl_update_status,
+	.get_brightness = ab8500_bl_get_brightness,
+};
+
+static int __devinit ab8500_bl_probe(struct platform_device *pdev)
+{
+	int cnt;
+	int ret = 0;
+	struct ab8500_bl *bklt, *bl_data;
+	struct ab8500_platform_data *plat;
+	struct ab8500_pwm_pdata *cur_pwm;
+	struct ab8500 *ab8500;
+
+	bl_data = kzalloc(sizeof(struct ab8500_bl) * TOTAL_NO_PWM, GFP_KERNEL);
+	if (!bl_data)
+		return -ENOMEM;
+
+	ab8500 = dev_get_drvdata(pdev->dev.parent);
+	plat = dev_get_platdata(ab8500->dev);
+	if (plat->pwm == NULL) {
+		kfree(bl_data);
+		return -EINVAL;
+	}
+
+	for (cnt = 0; cnt < TOTAL_NO_PWM; cnt++) {
+		cur_pwm = &plat->pwm[cnt];
+		if (!cur_pwm->name)
+			break;
+		bklt = &bl_data[cnt];
+		bklt->pwm = cur_pwm;
+		bklt->dev = &pdev->dev;
+
+		bklt->ab8500_bklt_props.max_brightness = cur_pwm->max_intensity;
+		bklt->ab8500_bklt = backlight_device_register(
+				cur_pwm->name,
+				&pdev->dev, bklt, &ab8500_bklt_fops,
+				&bklt->ab8500_bklt_props);
+		if (IS_ERR(bklt->ab8500_bklt)) {
+			dev_err(&pdev->dev,
+				"failed registering backlight driver\n");
+			while (cnt--) {
+				bklt = &bl_data[cnt];
+				backlight_device_unregister
+						(bklt->ab8500_bklt);
+			}
+			ret = PTR_ERR(bklt->ab8500_bklt);
+			kfree(bklt);
+			return ret;
+		}
+		bklt->ab8500_bklt->props.brightness =
+			bklt->ab8500_bklt_props.max_brightness;
+		backlight_update_status(bklt->ab8500_bklt);
+	}
+	dev_info(&pdev->dev, "backlight probe successful\n");
+	return ret;
+}
+
+#ifdef CONFIG_PM
+static int ab8500_bl_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
+	struct ab8500_bl *bklt, *bl_data = platform_get_drvdata(pdev);
+	struct ab8500_pwm_pdata *cur_pwm;
+	struct ab8500_platform_data *plat = dev_get_platdata(ab8500->dev);
+	int cnt, ret;
+
+	for (cnt = 0; cnt < TOTAL_NO_PWM; cnt++) {
+		cur_pwm = &plat->pwm[cnt];
+		if (!cur_pwm->name)
+			break;
+		bklt = &bl_data[cnt];
+		ret = ab8500_pwm_set_int(bklt->dev,
+				bklt->ab8500_bklt_props.max_brightness,
+				0, bklt->pwm->pwm_no[cnt]);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int ab8500_bl_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct ab8500_bl *bklt , *bl_data = platform_get_drvdata(pdev);
+	struct ab8500_pwm_pdata *cur_pwm;
+	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
+	struct ab8500_platform_data *plat = dev_get_platdata(ab8500->dev);
+	int cnt;
+
+	for (cnt = 0; cnt < TOTAL_NO_PWM; cnt++) {
+		cur_pwm = &plat->pwm[cnt];
+		if (!cur_pwm->name)
+			break;
+		bklt = &bl_data[cnt];
+		backlight_update_status(bklt->ab8500_bklt);
+	}
+
+	return 0;
+}
+
+static const struct dev_pm_ops ab8500_bl_pm_ops = {
+	.suspend	= ab8500_bl_suspend,
+	.resume		= ab8500_bl_resume,
+};
+#endif
+
+static int __devexit ab8500_bl_remove(struct platform_device *pdev)
+{
+	struct ab8500_bl *bklt = platform_get_drvdata(pdev);
+	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
+	struct ab8500_platform_data *plat = dev_get_platdata(ab8500->dev);
+	struct ab8500_pwm_pdata *cur_pwm;
+	int cnt;
+
+	for (cnt = 0; cnt < TOTAL_NO_PWM; cnt++) {
+		cur_pwm = &plat->pwm[cnt];
+		if (!cur_pwm->name)
+			break;
+		backlight_device_unregister(bklt[cnt].ab8500_bklt);
+	}
+	kfree(bklt);
+
+	return 0;
+}
+
+static struct platform_driver ab8500_bl_driver = {
+	.driver		= {
+		.name	= "ab8500-pwm-bl",
+		.owner	= THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm	= &ab8500_bl_pm_ops,
+#endif
+	},
+	.probe		= ab8500_bl_probe,
+	.remove		= __devexit_p(ab8500_bl_remove),
+};
+
+static int __init ab8500_bl_init(void)
+{
+	return platform_driver_register(&ab8500_bl_driver);
+}
+
+static void __exit ab8500_bl_exit(void)
+{
+	platform_driver_unregister(&ab8500_bl_driver);
+}
+
+module_init(ab8500_bl_init);
+module_exit(ab8500_bl_exit);
+
+MODULE_AUTHOR("Dushyanth S R, Arun Murthy");
+MODULE_DESCRIPTION("ab8500-pwm: lcd backlight");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mfd/ab8500.h b/include/linux/mfd/ab8500.h
index d63b605..cb8328b 100644
--- a/include/linux/mfd/ab8500.h
+++ b/include/linux/mfd/ab8500.h
@@ -136,6 +136,9 @@ struct ab8500 {
 
 struct regulator_init_data;
 
+/* forward declaration */
+struct ab8500_pwm_data;
+
 /**
  * struct ab8500_platform_data - AB8500 platform data
  * @irq_base: start of AB8500 IRQs, AB8500_NR_IRQS will be used
@@ -146,6 +149,7 @@ struct ab8500_platform_data {
 	int irq_base;
 	void (*init) (struct ab8500 *);
 	struct regulator_init_data *regulator[AB8500_NUM_REGULATORS];
+	struct ab8500_pwm_pdata *pwm;
 };
 
 extern int __devinit ab8500_init(struct ab8500 *ab8500);
-- 
1.6.3.3


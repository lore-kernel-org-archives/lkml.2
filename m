Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab2GROeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 10:34:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37405 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab2GROee convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 10:34:34 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, Bryan Wu <bryan.wu@canonical.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>
Subject: [PATCH 5/6] backlight: add new lp8788 backlight driver
Thread-Topic: [PATCH 5/6] backlight: add new lp8788 backlight driver
Thread-Index: Ac1k8lbIp3eYrA7FR6KQONfoZDv2YQ==
Date: Wed, 18 Jul 2012 14:33:47 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FD7D6@DQHE02.ent.ti.com>
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

TI LP8788 PMU has the backlight driver.
The brightness can be controlled by the PWM or the I2C commands.
Configurable parameters can be defined in the platform data.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/video/backlight/Kconfig     |    6 +
 drivers/video/backlight/Makefile    |    1 +
 drivers/video/backlight/lp8788_bl.c |  325 +++++++++++++++++++++++++++++++++++
 3 files changed, 332 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/backlight/lp8788_bl.c

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index cf28276..6fe0231 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -359,6 +359,12 @@ config BACKLIGHT_LP855X
 	  This supports TI LP8550, LP8551, LP8552, LP8553 and LP8556
 	  backlight driver.
 
+config BACKLIGHT_LP8788
+	tristate "Backlight driver for TI LP8788 MFD"
+	depends on BACKLIGHT_CLASS_DEVICE && MFD_LP8788
+	help
+	  This supports TI LP8788 backlight driver.
+
 config BACKLIGHT_OT200
 	tristate "Backlight driver for ot200 visualisation device"
 	depends on BACKLIGHT_CLASS_DEVICE && CS5535_MFGPT && GPIO_CS5535
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index a2ac9cf..f8cc7cb 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_BACKLIGHT_HP680)	+= hp680_bl.o
 obj-$(CONFIG_BACKLIGHT_LM3533)	+= lm3533_bl.o
 obj-$(CONFIG_BACKLIGHT_LOCOMO)	+= locomolcd.o
 obj-$(CONFIG_BACKLIGHT_LP855X)	+= lp855x_bl.o
+obj-$(CONFIG_BACKLIGHT_LP8788)	+= lp8788_bl.o
 obj-$(CONFIG_BACKLIGHT_OMAP1)	+= omap1_bl.o
 obj-$(CONFIG_BACKLIGHT_PANDORA)	+= pandora_bl.o
 obj-$(CONFIG_BACKLIGHT_PROGEAR) += progear_bl.o
diff --git a/drivers/video/backlight/lp8788_bl.c b/drivers/video/backlight/lp8788_bl.c
new file mode 100644
index 0000000..1c803ad
--- /dev/null
+++ b/drivers/video/backlight/lp8788_bl.c
@@ -0,0 +1,325 @@
+/*
+ * TI LP8788 MFD - backlight driver
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
+#include <linux/backlight.h>
+#include <linux/mfd/lp8788.h>
+
+/* register address */
+#define LP8788_BL_CONFIG		0x96
+#define LP8788_BL_BRIGHTNESS		0x97
+#define LP8788_BL_RAMP			0x98
+
+/* mask/shift bits */
+#define LP8788_BL_I2C_EN		BIT(0)	/* Addr 96h */
+#define LP8788_BL_PWM_EN		BIT(5)
+#define LP8788_BL_FULLSCALE_S		2
+#define LP8788_BL_DIM_MODE_S		1
+#define LP8788_BL_PWM_POLARITY_S	6
+#define LP8788_BL_RAMP_RISE_S		4	/* Addr 98h */
+
+#define BUF_SIZE			20
+#define MAX_BRIGHTNESS			127
+#define DEFAULT_BL_NAME			"lcd-backlight"
+
+struct lp8788_bl_config {
+	enum lp8788_bl_ctrl_mode bl_mode;
+	enum lp8788_bl_dim_mode dim_mode;
+	enum lp8788_bl_full_scale_current full_scale;
+	enum lp8788_bl_ramp_step rise_time;
+	enum lp8788_bl_ramp_step fall_time;
+	enum lp8788_bl_pwm_polarity pwm_pol;
+};
+
+struct lp8788_bl {
+	struct lp8788 *lp;
+	struct backlight_device *bl_dev;
+	struct lp8788_backlight_platform_data *pdata;
+	enum lp8788_bl_ctrl_mode mode;
+};
+
+struct lp8788_bl_config default_bl_config = {
+	.bl_mode    = LP8788_BL_REGISTER_ONLY,
+	.dim_mode   = LP8788_DIM_EXPONENTIAL,
+	.full_scale = LP8788_FULLSCALE_1900uA,
+	.rise_time  = LP8788_RAMP_8192us,
+	.fall_time  = LP8788_RAMP_8192us,
+	.pwm_pol    = LP8788_PWM_ACTIVE_HIGH,
+};
+
+static inline bool is_brightness_ctrl_by_pwm(enum lp8788_bl_ctrl_mode mode)
+{
+	return (mode == LP8788_BL_COMB_PWM_BASED);
+}
+
+static inline bool is_brightness_ctrl_by_register(enum lp8788_bl_ctrl_mode mode)
+{
+	return (mode == LP8788_BL_REGISTER_ONLY ||
+		mode == LP8788_BL_COMB_REGISTER_BASED);
+}
+
+static int lp8788_backlight_init_device(struct lp8788_bl *bl)
+{
+	struct lp8788_backlight_platform_data *pdata = bl->pdata;
+	struct lp8788_bl_config *cfg = &default_bl_config;
+	int ret;
+	u8 val;
+
+	/* update if platform data exists */
+	if (pdata) {
+		cfg->bl_mode    = pdata->bl_mode;
+		cfg->dim_mode   = pdata->dim_mode;
+		cfg->full_scale = pdata->full_scale;
+		cfg->rise_time  = pdata->rise_time;
+		cfg->fall_time  = pdata->fall_time;
+		cfg->pwm_pol    = pdata->pwm_pol;
+	}
+
+	val = (cfg->rise_time << LP8788_BL_RAMP_RISE_S) | cfg->fall_time;
+	ret = lp8788_write_byte(bl->lp, LP8788_BL_RAMP, val);
+	if (ret)
+		return ret;
+
+	val = (cfg->full_scale << LP8788_BL_FULLSCALE_S) |
+		(cfg->dim_mode << LP8788_BL_DIM_MODE_S);
+
+	switch (cfg->bl_mode) {
+	case LP8788_BL_REGISTER_ONLY:
+		val |= LP8788_BL_I2C_EN;
+		break;
+	case LP8788_BL_COMB_PWM_BASED:
+	case LP8788_BL_COMB_REGISTER_BASED:
+		val |= LP8788_BL_I2C_EN;
+		val |= LP8788_BL_PWM_EN;
+		val |= cfg->pwm_pol << LP8788_BL_PWM_POLARITY_S;
+		break;
+	default:
+		dev_err(bl->lp->dev, "invalid mode: %d\n", cfg->bl_mode);
+		return -EINVAL;
+	}
+
+	bl->mode = cfg->bl_mode;
+
+	return lp8788_write_byte(bl->lp, LP8788_BL_CONFIG, val);
+}
+
+static int lp8788_bl_update_status(struct backlight_device *bl_dev)
+{
+	struct lp8788_bl *bl = bl_get_data(bl_dev);
+	enum lp8788_bl_ctrl_mode mode = bl->mode;
+
+	if (bl_dev->props.state & BL_CORE_SUSPENDED)
+		bl_dev->props.brightness = 0;
+
+	if (is_brightness_ctrl_by_pwm(mode)) {
+		struct lp8788_bl_pwm_data *pd;
+		int brt = bl_dev->props.brightness;
+		int max = bl_dev->props.max_brightness;
+
+		pd = bl->pdata ? &bl->pdata->pwm_data : NULL;
+		if (pd && pd->pwm_set_intensity)
+			pd->pwm_set_intensity(brt, max);
+	} else if (is_brightness_ctrl_by_register(mode)) {
+		u8 brt = bl_dev->props.brightness;
+
+		lp8788_write_byte(bl->lp, LP8788_BL_BRIGHTNESS, brt);
+	}
+
+	return 0;
+}
+
+static int lp8788_bl_get_brightness(struct backlight_device *bl_dev)
+{
+	struct lp8788_bl *bl = bl_get_data(bl_dev);
+	enum lp8788_bl_ctrl_mode mode = bl->mode;
+
+	if (is_brightness_ctrl_by_pwm(mode)) {
+		struct lp8788_bl_pwm_data *pd;
+		int max = bl_dev->props.max_brightness;
+
+		pd = bl->pdata ? &bl->pdata->pwm_data : NULL;
+		if (pd && pd->pwm_get_intensity)
+			bl_dev->props.brightness = pd->pwm_get_intensity(max);
+	} else if (is_brightness_ctrl_by_register(mode)) {
+		u8 val = 0;
+
+		lp8788_read_byte(bl->lp, LP8788_BL_BRIGHTNESS, &val);
+		bl_dev->props.brightness = val;
+	}
+
+	return bl_dev->props.brightness;
+}
+
+static const struct backlight_ops lp8788_bl_ops = {
+	.options = BL_CORE_SUSPENDRESUME,
+	.update_status = lp8788_bl_update_status,
+	.get_brightness = lp8788_bl_get_brightness,
+};
+
+static int lp8788_backlight_register(struct lp8788_bl *bl)
+{
+	struct backlight_device *bl_dev;
+	struct backlight_properties props;
+	struct lp8788_backlight_platform_data *pdata = bl->pdata;
+	int init_brt = pdata ? pdata->initial_brightness : 0;
+	char *name;
+
+	props.type = BACKLIGHT_PLATFORM;
+	props.max_brightness = MAX_BRIGHTNESS;
+
+	if (init_brt > props.max_brightness)
+		init_brt = props.max_brightness;
+
+	props.brightness = init_brt;
+
+	if (!pdata || !pdata->name)
+		name = DEFAULT_BL_NAME;
+	else
+		name = pdata->name;
+
+	bl_dev = backlight_device_register(name, bl->lp->dev, bl,
+				       &lp8788_bl_ops, &props);
+	if (IS_ERR(bl_dev))
+		return PTR_ERR(bl_dev);
+
+	bl->bl_dev = bl_dev;
+
+	return 0;
+}
+
+static void lp8788_backlight_unregister(struct lp8788_bl *bl)
+{
+	struct backlight_device *bl_dev = bl->bl_dev;
+
+	if (bl_dev)
+		backlight_device_unregister(bl_dev);
+}
+
+static ssize_t lp8788_get_bl_ctl_mode(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct lp8788_bl *bl = dev_get_drvdata(dev);
+	enum lp8788_bl_ctrl_mode mode = bl->mode;
+	char *strmode = NULL;
+
+	switch (mode) {
+	case LP8788_BL_COMB_PWM_BASED:
+		strmode = "pwm based";
+		break;
+	case LP8788_BL_REGISTER_ONLY:
+	case LP8788_BL_COMB_REGISTER_BASED:
+		strmode = "register based";
+		break;
+	default:
+		strmode = "invalid mode";
+		break;
+	}
+
+	return scnprintf(buf, BUF_SIZE, "%s\n", strmode);
+}
+
+static DEVICE_ATTR(bl_ctl_mode, S_IRUGO, lp8788_get_bl_ctl_mode, NULL);
+
+static struct attribute *lp8788_attributes[] = {
+	&dev_attr_bl_ctl_mode.attr,
+	NULL,
+};
+
+static const struct attribute_group lp8788_attr_group = {
+	.attrs = lp8788_attributes,
+};
+
+static __devinit int lp8788_backlight_probe(struct platform_device *pdev)
+{
+	struct lp8788 *lp = dev_get_drvdata(pdev->dev.parent);
+	struct lp8788_bl *bl;
+	int ret;
+
+	bl = devm_kzalloc(lp->dev, sizeof(struct lp8788_bl), GFP_KERNEL);
+	if (!bl)
+		return -ENOMEM;
+
+	bl->lp = lp;
+	bl->pdata = lp->pdata ? lp->pdata->bl_pdata : NULL;
+	platform_set_drvdata(pdev, bl);
+
+	ret = lp8788_backlight_init_device(bl);
+	if (ret) {
+		dev_err(lp->dev, "backlight init device err: %d\n", ret);
+		if (is_brightness_ctrl_by_register(bl->mode))
+			goto err_dev;
+	}
+
+	ret = lp8788_backlight_register(bl);
+	if (ret) {
+		dev_err(lp->dev, "register backlight err: %d\n", ret);
+		goto err_dev;
+	}
+
+	ret = sysfs_create_group(&pdev->dev.kobj, &lp8788_attr_group);
+	if (ret) {
+		dev_err(lp->dev, "register sysfs err: %d\n", ret);
+		goto err_sysfs;
+	}
+
+	backlight_update_status(bl->bl_dev);
+	return 0;
+
+err_sysfs:
+	lp8788_backlight_unregister(bl);
+err_dev:
+	return ret;
+}
+
+static int __devexit lp8788_backlight_remove(struct platform_device *pdev)
+{
+	struct lp8788_bl *bl = platform_get_drvdata(pdev);
+	struct backlight_device *bl_dev = bl->bl_dev;
+
+	bl_dev->props.brightness = 0;
+	backlight_update_status(bl_dev);
+	sysfs_remove_group(&pdev->dev.kobj, &lp8788_attr_group);
+	lp8788_backlight_unregister(bl);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver lp8788_bl_driver = {
+	.probe = lp8788_backlight_probe,
+	.remove = __devexit_p(lp8788_backlight_remove),
+	.driver = {
+		.name = LP8788_DEV_BACKLIGHT,
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init lp8788_backlight_init(void)
+{
+	return platform_driver_register(&lp8788_bl_driver);
+}
+module_init(lp8788_backlight_init);
+
+static void __exit lp8788_backlight_exit(void)
+{
+	platform_driver_unregister(&lp8788_bl_driver);
+}
+module_exit(lp8788_backlight_exit);
+
+MODULE_DESCRIPTION("Texas Instruments LP8788 Backlight Driver");
+MODULE_AUTHOR("Milo Kim");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:lp8788-backlight");
-- 
1.7.2.5


Best Regards,
Milo



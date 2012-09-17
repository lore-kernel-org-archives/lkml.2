Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab2IQEUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 00:20:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60658 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab2IQEUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 00:20:41 -0400
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: sameo@linux.intel.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        rpurdie@rpsys.net, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 7/9] mfd: 88pm860x: support dt
Date: Mon, 17 Sep 2012 12:19:10 +0800
Message-Id: <1347855552-26213-8-git-send-email-haojian.zhuang@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347855552-26213-1-git-send-email-haojian.zhuang@gmail.com>
References: <1347855552-26213-1-git-send-email-haojian.zhuang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
---
 drivers/input/touchscreen/88pm860x-ts.c |   46 +++++++++++++++--------
 drivers/leds/leds-88pm860x.c            |   33 +++++++++++++++-
 drivers/mfd/88pm860x-core.c             |   62 ++++++++++++++++++++++++++-----
 drivers/regulator/88pm8607.c            |   35 ++++++++++++++++-
 drivers/rtc/rtc-88pm860x.c              |   43 ++++++++++++++++-----
 drivers/video/backlight/88pm860x_bl.c   |   39 +++++++++++++++++--
 include/linux/mfd/88pm860x.h            |    4 +-
 7 files changed, 221 insertions(+), 41 deletions(-)

diff --git a/drivers/input/touchscreen/88pm860x-ts.c b/drivers/input/touchscreen/88pm860x-ts.c
index 05f30b7..4f81e6e 100644
--- a/drivers/input/touchscreen/88pm860x-ts.c
+++ b/drivers/input/touchscreen/88pm860x-ts.c
@@ -10,6 +10,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
 #include <linux/input.h>
@@ -113,14 +114,31 @@ static void pm860x_touch_close(struct input_dev *dev)
 	pm860x_set_bits(touch->i2c, MEAS_EN3, data, 0);
 }
 
+#ifdef CONFIG_OF
+static int __devinit pm860x_touch_dt_init(struct platform_device *pdev,
+					  int *res_x)
+{
+	struct device_node *np = pdev->dev.parent->of_node;
+	if (!np)
+		return -ENODEV;
+	np = of_find_node_by_name(np, "touch");
+	if (!np) {
+		dev_err(&pdev->dev, "Can't find touch node\n");
+		return -EINVAL;
+	}
+	of_property_read_u32(np, "marvell,88pm860x-resistor-X", res_x);
+	return 0;
+}
+#else
+#define pm860x_touch_dt_init(x, y)	(-1)
+#endif
+
 static int __devinit pm860x_touch_probe(struct platform_device *pdev)
 {
 	struct pm860x_chip *chip = dev_get_drvdata(pdev->dev.parent);
-	struct pm860x_platform_data *pm860x_pdata =		\
-				pdev->dev.parent->platform_data;
-	struct pm860x_touch_pdata *pdata = NULL;
+	struct pm860x_touch_pdata *pdata = pdev->dev.platform_data;
 	struct pm860x_touch *touch;
-	int irq, ret;
+	int irq, ret, res_x = 0;
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
@@ -128,15 +146,13 @@ static int __devinit pm860x_touch_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	if (!pm860x_pdata) {
-		dev_err(&pdev->dev, "platform data is missing\n");
-		return -EINVAL;
-	}
-
-	pdata = pm860x_pdata->touch;
-	if (!pdata) {
-		dev_err(&pdev->dev, "touchscreen data is missing\n");
-		return -EINVAL;
+	if (pm860x_touch_dt_init(pdev, &res_x)) {
+		if (pdata)
+			res_x = pdata->res_x;
+		else {
+			dev_err(&pdev->dev, "failed to get platform data\n");
+			return -EINVAL;
+		}
 	}
 
 	touch = kzalloc(sizeof(struct pm860x_touch), GFP_KERNEL);
@@ -159,8 +175,8 @@ static int __devinit pm860x_touch_probe(struct platform_device *pdev)
 	touch->idev->close = pm860x_touch_close;
 	touch->chip = chip;
 	touch->i2c = (chip->id == CHIP_PM8607) ? chip->client : chip->companion;
-	touch->irq = irq + chip->irq_base;
-	touch->res_x = pdata->res_x;
+	touch->irq = irq;
+	touch->res_x = res_x;
 	input_set_drvdata(touch->idev, touch);
 
 	ret = request_threaded_irq(touch->irq, NULL, pm860x_touch_handler,
diff --git a/drivers/leds/leds-88pm860x.c b/drivers/leds/leds-88pm860x.c
index 70232b1..b7e8cc0 100644
--- a/drivers/leds/leds-88pm860x.c
+++ b/drivers/leds/leds-88pm860x.c
@@ -12,6 +12,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
 #include <linux/leds.h>
@@ -123,6 +124,33 @@ static void pm860x_led_set(struct led_classdev *cdev,
 	schedule_work(&data->work);
 }
 
+#ifdef CONFIG_OF
+static int pm860x_led_dt_init(struct platform_device *pdev,
+			      struct pm860x_led *data)
+{
+	struct device_node *nproot = pdev->dev.parent->of_node, *np;
+	int iset = 0;
+	if (!nproot)
+		return -ENODEV;
+	nproot = of_find_node_by_name(nproot, "leds");
+	if (!nproot) {
+		dev_err(&pdev->dev, "failed to find leds node\n");
+		return -ENODEV;
+	}
+	for_each_child_of_node(nproot, np) {
+		if (!of_node_cmp(np->name, data->name)) {
+			of_property_read_u32(np, "marvell,88pm860x-iset",
+					     &iset);
+			data->iset = PM8606_LED_CURRENT(iset);
+			break;
+		}
+	}
+	return 0;
+}
+#else
+#define pm860x_led_dt_init(x, y)	(-1)
+#endif
+
 static int pm860x_led_probe(struct platform_device *pdev)
 {
 	struct pm860x_chip *chip = dev_get_drvdata(pdev->dev.parent);
@@ -179,8 +207,9 @@ static int pm860x_led_probe(struct platform_device *pdev)
 	data->chip = chip;
 	data->i2c = (chip->id == CHIP_PM8606) ? chip->client : chip->companion;
 	data->port = pdev->id;
-	if (pdata && pdata->iset)
-		data->iset = pdata->iset;
+	if (pm860x_led_dt_init(pdev, data))
+		if (pdata)
+			data->iset = pdata->iset;
 
 	data->current_brightness = 0;
 	data->cdev.name = data->name;
diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index a09d790..15ded0b 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -16,6 +16,8 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/irqdomain.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
@@ -1112,12 +1114,6 @@ static void __devexit pm860x_device_exit(struct pm860x_chip *chip)
 	mfd_remove_devices(chip->dev);
 }
 
-static const struct i2c_device_id pm860x_id_table[] = {
-	{ "88PM860x", 0 },
-	{}
-};
-MODULE_DEVICE_TABLE(i2c, pm860x_id_table);
-
 static int verify_addr(struct i2c_client *i2c)
 {
 	unsigned short addr_8607[] = {0x30, 0x34};
@@ -1144,21 +1140,52 @@ static struct regmap_config pm860x_regmap_config = {
 	.val_bits = 8,
 };
 
+static int __devinit pm860x_dt_init(struct device_node *np,
+				    struct device *dev,
+				    struct pm860x_platform_data *pdata)
+{
+	int ret;
+
+	if (of_get_property(np, "marvell,88pm860x-irq-read-clr", NULL))
+		pdata->irq_mode = 1;
+	ret = of_property_read_u32(np, "marvell,88pm860x-slave-addr",
+				   &pdata->companion_addr);
+	if (ret) {
+		dev_err(dev, "Not found \"marvell,88pm860x-slave-addr\" "
+			"property\n");
+		pdata->companion_addr = 0;
+	}
+	return 0;
+}
+
 static int __devinit pm860x_probe(struct i2c_client *client,
 				  const struct i2c_device_id *id)
 {
 	struct pm860x_platform_data *pdata = client->dev.platform_data;
+	struct device_node *node = client->dev.of_node;
 	struct pm860x_chip *chip;
 	int ret;
 
-	if (!pdata) {
+	if (node && !pdata) {
+		/* parse DT to get platform data */
+		pdata = devm_kzalloc(&client->dev,
+				     sizeof(struct pm860x_platform_data),
+				     GFP_KERNEL);
+		if (!pdata)
+			return -ENOMEM;
+		ret = pm860x_dt_init(node, &client->dev, pdata);
+		if (ret)
+			goto err;
+	} else if (!pdata) {
 		pr_info("No platform data in %s!\n", __func__);
 		return -EINVAL;
 	}
 
 	chip = kzalloc(sizeof(struct pm860x_chip), GFP_KERNEL);
-	if (chip == NULL)
-		return -ENOMEM;
+	if (chip == NULL) {
+		ret = -ENOMEM;
+		goto err;
+	}
 
 	chip->id = verify_addr(client);
 	chip->regmap = regmap_init_i2c(client, &pm860x_regmap_config);
@@ -1198,6 +1225,10 @@ static int __devinit pm860x_probe(struct i2c_client *client,
 
 	pm860x_device_init(chip, pdata);
 	return 0;
+err:
+	if (node)
+		devm_kfree(&client->dev, pdata);
+	return ret;
 }
 
 static int __devexit pm860x_remove(struct i2c_client *client)
@@ -1238,11 +1269,24 @@ static int pm860x_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(pm860x_pm_ops, pm860x_suspend, pm860x_resume);
 
+static const struct i2c_device_id pm860x_id_table[] = {
+	{ "88PM860x", 0 },
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, pm860x_id_table);
+
+static const struct of_device_id pm860x_dt_ids[] = {
+	{ .compatible = "marvell,88pm860x", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, pm860x_dt_ids);
+
 static struct i2c_driver pm860x_driver = {
 	.driver	= {
 		.name	= "88PM860x",
 		.owner	= THIS_MODULE,
 		.pm     = &pm860x_pm_ops,
+		.of_match_table	= of_match_ptr(pm860x_dt_ids),
 	},
 	.probe		= pm860x_probe,
 	.remove		= __devexit_p(pm860x_remove),
diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index f96fbe3..1c5ab01 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -12,6 +12,8 @@
 #include <linux/init.h>
 #include <linux/err.h>
 #include <linux/i2c.h>
+#include <linux/of.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
@@ -364,6 +366,34 @@ static struct pm8607_regulator_info pm8606_regulator_info[] = {
 	PM8606_PREG(PREREGULATORB, 5),
 };
 
+#ifdef CONFIG_OF
+static int pm8607_regulator_dt_init(struct platform_device *pdev,
+				    struct pm8607_regulator_info *info,
+				    struct regulator_config *config)
+{
+	struct device_node *nproot, *np;
+	nproot = pdev->dev.parent->of_node;
+	if (!nproot)
+		return -ENODEV;
+	nproot = of_find_node_by_name(nproot, "regulators");
+	if (!nproot) {
+		dev_err(&pdev->dev, "failed to find regulators node\n");
+		return -ENODEV;
+	}
+	for_each_child_of_node(nproot, np) {
+		if (!of_node_cmp(np->name, info->desc.name)) {
+			config->init_data =
+				of_get_regulator_init_data(&pdev->dev, np);
+			config->of_node = np;
+			break;
+		}
+	}
+	return 0;
+}
+#else
+#define pm8607_regulator_dt_init(x, y, z)	(-1)
+#endif
+
 static int __devinit pm8607_regulator_probe(struct platform_device *pdev)
 {
 	struct pm860x_chip *chip = dev_get_drvdata(pdev->dev.parent);
@@ -402,9 +432,12 @@ static int __devinit pm8607_regulator_probe(struct platform_device *pdev)
 		info->slope_double = 1;
 
 	config.dev = &pdev->dev;
-	config.init_data = pdata;
 	config.driver_data = info;
 
+	if (pm8607_regulator_dt_init(pdev, info, &config))
+		if (pdata)
+			config.init_data = pdata;
+
 	if (chip->id == CHIP_PM8607)
 		config.regmap = chip->regmap;
 	else
diff --git a/drivers/rtc/rtc-88pm860x.c b/drivers/rtc/rtc-88pm860x.c
index feddefc..de9e854 100644
--- a/drivers/rtc/rtc-88pm860x.c
+++ b/drivers/rtc/rtc-88pm860x.c
@@ -11,6 +11,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
@@ -284,6 +285,28 @@ out:
 }
 #endif
 
+#ifdef CONFIG_OF
+static int __devinit pm860x_rtc_dt_init(struct platform_device *pdev,
+					struct pm860x_rtc_info *info)
+{
+	struct device_node *np = pdev->dev.parent->of_node;
+	int ret;
+	if (!np)
+		return -ENODEV;
+	np = of_find_node_by_name(np, "rtc");
+	if (!np) {
+		dev_err(&pdev->dev, "failed to find rtc node\n");
+		return -ENODEV;
+	}
+	ret = of_property_read_u32(np, "marvell,88pm860x-vrtc", &info->vrtc);
+	if (ret)
+		info->vrtc = 0;
+	return 0;
+}
+#else
+#define pm860x_rtc_dt_init(x, y)	(-1)
+#endif
+
 static int __devinit pm860x_rtc_probe(struct platform_device *pdev)
 {
 	struct pm860x_chip *chip = dev_get_drvdata(pdev->dev.parent);
@@ -294,8 +317,6 @@ static int __devinit pm860x_rtc_probe(struct platform_device *pdev)
 	int ret;
 
 	pdata = pdev->dev.platform_data;
-	if (pdata == NULL)
-		dev_warn(&pdev->dev, "No platform data!\n");
 
 	info = kzalloc(sizeof(struct pm860x_rtc_info), GFP_KERNEL);
 	if (!info)
@@ -345,9 +366,11 @@ static int __devinit pm860x_rtc_probe(struct platform_device *pdev)
 		}
 	}
 	rtc_tm_to_time(&tm, &ticks);
-	if (pdata && pdata->sync) {
-		pdata->sync(ticks);
-		info->sync = pdata->sync;
+	if (pm860x_rtc_dt_init(pdev, info)) {
+		if (pdata && pdata->sync) {
+			pdata->sync(ticks);
+			info->sync = pdata->sync;
+		}
 	}
 
 	info->rtc_dev = rtc_device_register("88pm860x-rtc", &pdev->dev,
@@ -366,10 +389,12 @@ static int __devinit pm860x_rtc_probe(struct platform_device *pdev)
 
 #ifdef VRTC_CALIBRATION
 	/* <00> -- 2.7V, <01> -- 2.9V, <10> -- 3.1V, <11> -- 3.3V */
-	if (pdata && pdata->vrtc)
-		info->vrtc = pdata->vrtc & 0x3;
-	else
-		info->vrtc = 1;
+	if (pm860x_rtc_dt_init(pdev, info)) {
+		if (pdata && pdata->vrtc)
+			info->vrtc = pdata->vrtc & 0x3;
+		else
+			info->vrtc = 1;
+	}
 	pm860x_set_bits(info->i2c, PM8607_MEAS_EN2, MEAS2_VRTC, MEAS2_VRTC);
 
 	/* calibrate VRTC */
diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
index 965161c..b7ec34c 100644
--- a/drivers/video/backlight/88pm860x_bl.c
+++ b/drivers/video/backlight/88pm860x_bl.c
@@ -11,6 +11,7 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/fb.h>
@@ -159,6 +160,36 @@ static const struct backlight_ops pm860x_backlight_ops = {
 	.get_brightness	= pm860x_backlight_get_brightness,
 };
 
+#ifdef CONFIG_OF
+static int pm860x_backlight_dt_init(struct platform_device *pdev,
+				    struct pm860x_backlight_data *data,
+				    char *name)
+{
+	struct device_node *nproot = pdev->dev.parent->of_node, *np;
+	int iset = 0;
+	if (!nproot)
+		return -ENODEV;
+	nproot = of_find_node_by_name(nproot, "backlights");
+	if (!nproot) {
+		dev_err(&pdev->dev, "failed to find backlights node\n");
+		return -ENODEV;
+	}
+	for_each_child_of_node(nproot, np) {
+		if (!of_node_cmp(np->name, name)) {
+			of_property_read_u32(np, "marvell,88pm860x-iset",
+					     &iset);
+			data->iset = PM8606_WLED_CURRENT(iset);
+			of_property_read_u32(np, "marvell,88pm860x-pwm",
+					     &data->pwm);
+			break;
+		}
+	}
+	return 0;
+}
+#else
+#define pm860x_backlight_dt_init(x, y, z)	(-1)
+#endif
+
 static int pm860x_backlight_probe(struct platform_device *pdev)
 {
 	struct pm860x_chip *chip = dev_get_drvdata(pdev->dev.parent);
@@ -203,9 +234,11 @@ static int pm860x_backlight_probe(struct platform_device *pdev)
 	data->i2c = (chip->id == CHIP_PM8606) ? chip->client	\
 			: chip->companion;
 	data->current_brightness = MAX_BRIGHTNESS;
-	if (pdata) {
-		data->pwm = pdata->pwm;
-		data->iset = pdata->iset;
+	if (pm860x_backlight_dt_init(pdev, data, name)) {
+		if (pdata) {
+			data->pwm = pdata->pwm;
+			data->iset = pdata->iset;
+		}
 	}
 
 	memset(&props, 0, sizeof(struct backlight_properties));
diff --git a/include/linux/mfd/88pm860x.h b/include/linux/mfd/88pm860x.h
index d515e5c..ef3e6b7 100644
--- a/include/linux/mfd/88pm860x.h
+++ b/include/linux/mfd/88pm860x.h
@@ -306,7 +306,7 @@ struct pm860x_chip {
 	struct regmap           *regmap_companion;
 
 	int			buck3_double;	/* DVC ramp slope double */
-	unsigned short		companion_addr;
+	int			companion_addr;
 	unsigned short		osc_vote;
 	int			id;
 	int			irq_mode;
@@ -376,7 +376,7 @@ struct pm860x_platform_data {
 	struct regulator_init_data	*ldo_vibrator;
 	struct regulator_init_data	*ldo14;
 
-	unsigned short	companion_addr;	/* I2C address of companion chip */
+	int 		companion_addr;	/* I2C address of companion chip */
 	int		i2c_port;	/* Controlled by GI2C or PI2C */
 	int		irq_mode;	/* Clear interrupt by read/write(0/1) */
 	int		irq_base;	/* IRQ base number of 88pm860x */
-- 
1.7.9.5


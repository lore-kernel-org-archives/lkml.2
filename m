Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab2GMJO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 05:14:26 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38365 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867Ab2GMJOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 05:14:18 -0400
From: "G.Shark Jeong" <gshark.jeong@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: Daniel Jeong <daniel.jeong@ti.com>, <linux-kernel@vger.kernel.org>,
        "G.Shark Jeong" <gshark.jeong@gmail.com>
Subject: [PATCH] leds: Add LED driver for lm3554 chip
Date: Fri, 13 Jul 2012 18:11:41 +0900
Message-Id: <1342170701-12303-2-git-send-email-gshark.jeong@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1342170701-12303-1-git-send-email-gshark.jeong@gmail.com>
References: <1342170701-12303-1-git-send-email-gshark.jeong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "G.Shark Jeong" <gshark.jeong@gmail.com>

LM3554 :
The LM3554 is a 2 MHz fixed-frequency synchronous boost
converter with 1.2A dual high side led drivers.
Datasheet: www.ti.com

Signed-off-by: G.Shark Jeong <gshark.jeong@gmail.com>
---
 drivers/leds/Kconfig                      |    8 +
 drivers/leds/Makefile                     |    1 +
 drivers/leds/leds-lm3554.c                |  324 +++++++++++++++++++++++++++++
 include/linux/platform_data/leds-lm3554.h |   66 ++++++
 4 files changed, 399 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-lm3554.c
 create mode 100644 include/linux/platform_data/leds-lm3554.h

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 12b2b55..ad54bc2 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -415,6 +415,14 @@ config LEDS_MAX8997
 	  This option enables support for on-chip LED drivers on
 	  MAXIM MAX8997 PMIC.
 
+config LEDS_LM3554
+	tristate "LED support for LM3554"
+	depends on LEDS_CLASS && I2C
+	select REGMAP_I2C
+	help
+	  This option enables support for LEDs connected to LM3554.
+	  LM3554 includes Torch, Flash and Indicator functions.
+
 config LEDS_OT200
 	tristate "LED support for the Bachmann OT200"
 	depends on LEDS_CLASS && HAS_IOMEM
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index f8958cd..19903ed 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_LEDS_NETXBIG)		+= leds-netxbig.o
 obj-$(CONFIG_LEDS_ASIC3)		+= leds-asic3.o
 obj-$(CONFIG_LEDS_RENESAS_TPU)		+= leds-renesas-tpu.o
 obj-$(CONFIG_LEDS_MAX8997)		+= leds-max8997.o
+obj-$(CONFIG_LEDS_LM3554)		+= leds-lm3554.o
 
 # LED SPI Drivers
 obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
diff --git a/drivers/leds/leds-lm3554.c b/drivers/leds/leds-lm3554.c
new file mode 100644
index 0000000..4f53086
--- /dev/null
+++ b/drivers/leds/leds-lm3554.c
@@ -0,0 +1,324 @@
+/*
+* Simple driver for Texas Instruments LM3554 LED Flash driver chip
+* Copyright (C) 2012 Texas Instruments
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+*/
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <linux/leds.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/fs.h>
+#include <linux/regmap.h>
+#include <linux/platform_data/leds-lm3554.h>
+
+#define REG_TORCH		(0xA0)
+#define REG_FLASH		(0xB0)
+#define REG_FLASH_TIME		(0xC0)
+#define REG_FLAG		(0xD0)
+#define REG_CONF1		(0xE0)
+#define REG_CONF2		(0xF0)
+#define REG_GPIO		(0x20)
+#define REG_VIN_MON		(0x80)
+#define REG_MAX			REG_VIN_MON
+
+enum lm3554_mode {
+	MODE_SHDN = 0,
+	MODE_INDIC,
+	MODE_TORCH,
+	MODE_FLASH,
+	MODE_VOUT,
+	MODE_VOUT_INDIC,
+	MODE_VOUT_TORCH,
+	MODE_VOUT_FLASH,
+};
+
+struct lm3554_chip_data {
+	struct device *dev;
+
+	struct led_classdev cdev_flash;
+	struct led_classdev cdev_torch;
+	struct led_classdev cdev_indicator;
+
+	struct lm3554_platform_data *pdata;
+
+	struct mutex lock;
+	struct regmap *regmap;
+	unsigned int last_flag;
+};
+
+/* chip initialize */
+static int __devinit lm3554_chip_init(struct lm3554_chip_data *chip)
+{
+	int ret;
+	unsigned int reg_val;
+	struct lm3554_platform_data *pdata = chip->pdata;
+
+	/* input and output pins configuration */
+	reg_val = pdata->pin_strobe | pdata->pin_tx1
+	    | pdata->pin_tx2 | pdata->ledi_pin;
+	ret = regmap_update_bits(chip->regmap, REG_CONF1, 0xAC, reg_val);
+	if (ret < 0)
+		goto out;
+
+	return ret;
+out:
+	dev_err(chip->dev, "%s:i2c access fail to register\n", __func__);
+	return ret;
+}
+
+/* chip control */
+static void lm3554_control(struct lm3554_chip_data *chip,
+			   u8 brightness, enum lm3554_mode opmode)
+{
+	int ret;
+	unsigned int reg_val;
+	struct lm3554_platform_data *pdata = chip->pdata;
+
+	ret = regmap_read(chip->regmap, REG_FLAG, &chip->last_flag);
+	if (ret < 0)
+		goto out;
+	if (chip->last_flag)
+		dev_info(chip->dev, "LM3554 Last FLAG is 0x%x\n",
+			 chip->last_flag);
+	/* brightness 0 means shutdown */
+	if (!brightness)
+		opmode = MODE_SHDN;
+
+	switch (opmode) {
+	case MODE_TORCH:
+		if (pdata->pin_tx1 == LM3554_TX1_HW_TORCH) {
+			ret = regmap_update_bits(chip->regmap,
+						 REG_CONF1, 0x80, 0x80);
+			if (ret < 0)
+				goto out;
+			opmode = MODE_SHDN;
+		}
+		ret = regmap_update_bits(chip->regmap,
+					 REG_TORCH, 0x38,
+					 (brightness - 1) << 3);
+		if (ret < 0)
+			goto out;
+		break;
+
+	case MODE_FLASH:
+		if (pdata->pin_strobe == LM3554_STROBE_EN) {
+			ret = regmap_update_bits(chip->regmap,
+						 REG_CONF1, 0x84, 0x04);
+			if (ret < 0)
+				goto out;
+			opmode = MODE_SHDN;
+		}
+		ret = regmap_update_bits(chip->regmap, REG_FLASH, 0x78,
+					 (brightness - 1) << 3);
+		if (ret < 0)
+			goto out;
+		break;
+
+	case MODE_INDIC:
+		if (pdata->ledi_pin == LM3554_LEDI_INDICATOR) {
+			ret = regmap_update_bits(chip->regmap,
+						 REG_CONF1, 0x08, 0x08);
+			if (ret < 0)
+				goto out;
+			opmode = MODE_SHDN;
+		}
+		ret = regmap_update_bits(chip->regmap, REG_TORCH, 0x38,
+					 (brightness - 1) << 3);
+		if (ret < 0)
+			goto out;
+		break;
+	case MODE_SHDN:
+		break;
+	default:
+		return;
+	}
+
+	/* set voltage out mode */
+	reg_val = opmode | pdata->vout_mode;
+	ret = regmap_update_bits(chip->regmap, REG_TORCH, 0x07, reg_val);
+	if (ret < 0)
+		goto out;
+	return;
+out:
+	dev_err(chip->dev, "%s:i2c access fail to register\n", __func__);
+	return;
+}
+
+/* torch */
+static void lm3554_torch_brightness_set(struct led_classdev *cdev,
+					enum led_brightness brightness)
+{
+	struct lm3554_chip_data *chip =
+	    container_of(cdev, struct lm3554_chip_data, cdev_torch);
+
+	mutex_lock(&chip->lock);
+	lm3554_control(chip, brightness, MODE_TORCH);
+	mutex_unlock(&chip->lock);
+	return;
+}
+
+/* flash */
+static void lm3554_strobe_brightness_set(struct led_classdev *cdev,
+					 enum led_brightness brightness)
+{
+	struct lm3554_chip_data *chip =
+	    container_of(cdev, struct lm3554_chip_data, cdev_flash);
+
+	mutex_lock(&chip->lock);
+	lm3554_control(chip, brightness, MODE_FLASH);
+	mutex_unlock(&chip->lock);
+	return;
+}
+
+/* indicator */
+static void lm3554_indicator_brightness_set(struct led_classdev *cdev,
+					    enum led_brightness brightness)
+{
+	struct lm3554_chip_data *chip =
+	    container_of(cdev, struct lm3554_chip_data, cdev_indicator);
+
+	mutex_lock(&chip->lock);
+	lm3554_control(chip, brightness, MODE_INDIC);
+	mutex_unlock(&chip->lock);
+	return;
+}
+
+static const struct regmap_config lm3554_regmap = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = REG_MAX,
+};
+
+/* module initialize */
+static int __devinit lm3554_probe(struct i2c_client *client,
+				  const struct i2c_device_id *id)
+{
+	int ret;
+	struct lm3554_chip_data *chip;
+	struct lm3554_platform_data *pdata = client->dev.platform_data;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		dev_err(&client->dev, "i2c functionality check fail.\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (pdata == NULL) {
+		dev_err(&client->dev, "Needs Platform Data.\n");
+		return -ENODATA;
+	}
+
+	chip =
+	    devm_kzalloc(&client->dev, sizeof(struct lm3554_chip_data),
+			 GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	chip->dev = &client->dev;
+	chip->pdata = pdata;
+
+	chip->regmap = /*devm_ */ regmap_init_i2c(client, &lm3554_regmap);
+	if (IS_ERR(chip->regmap)) {
+		ret = PTR_ERR(chip->regmap);
+		dev_err(&client->dev,
+			"Failed to allocate register map: %d\n", ret);
+		return ret;
+	}
+
+	mutex_init(&chip->lock);
+	i2c_set_clientdata(client, chip);
+
+	ret = lm3554_chip_init(chip);
+	if (ret < 0)
+		goto err_chip_init;
+
+	/* flash */
+	chip->cdev_flash.name = "flash";
+	chip->cdev_flash.max_brightness = 16;
+	chip->cdev_flash.brightness_set = lm3554_strobe_brightness_set;
+	ret = led_classdev_register((struct device *)
+				    &client->dev, &chip->cdev_flash);
+	if (ret < 0)
+		goto err_chip_init;
+	/* torch */
+	chip->cdev_torch.name = "torch";
+	chip->cdev_torch.max_brightness = 8;
+	chip->cdev_torch.brightness_set = lm3554_torch_brightness_set;
+	ret = led_classdev_register((struct device *)
+				    &client->dev, &chip->cdev_torch);
+	if (ret < 0)
+		goto err_chip_init;
+	/* indicator */
+	chip->cdev_indicator.name = "indicator";
+	chip->cdev_indicator.max_brightness = 4;
+	chip->cdev_indicator.brightness_set = lm3554_indicator_brightness_set;
+	ret = led_classdev_register((struct device *)
+				    &client->dev, &chip->cdev_indicator);
+	if (ret < 0)
+		goto err_chip_init;
+
+	dev_info(chip->dev, "lm3554 initialize OK\n");
+
+	return 0;
+
+err_chip_init:
+	if (&chip->cdev_indicator)
+		led_classdev_unregister(&chip->cdev_indicator);
+	if (&chip->cdev_torch)
+		led_classdev_unregister(&chip->cdev_torch);
+	if (&chip->cdev_flash)
+		led_classdev_unregister(&chip->cdev_flash);
+
+	dev_err(chip->dev, "lm3554 initialize fail\n");
+	return ret;
+}
+
+static int __devexit lm3554_remove(struct i2c_client *client)
+{
+	int ret;
+	struct lm3554_chip_data *chip = i2c_get_clientdata(client);
+
+	if (&chip->cdev_indicator)
+		led_classdev_unregister(&chip->cdev_indicator);
+	if (&chip->cdev_torch)
+		led_classdev_unregister(&chip->cdev_torch);
+	if (&chip->cdev_flash)
+		led_classdev_unregister(&chip->cdev_flash);
+	ret = regmap_write(chip->regmap, REG_TORCH, 0x00);
+	if (ret < 0)
+		dev_err(chip->dev,
+			"%s:i2c access fail to register\n", __func__);
+	dev_info(chip->dev, "lm3554 is removed");
+	return 0;
+}
+
+static const struct i2c_device_id lm3554_id[] = {
+	{LM3554_NAME, 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, lm3554_id);
+
+static struct i2c_driver lm3554_i2c_driver = {
+	.driver = {
+		   .name = LM3554_NAME,
+		   .owner = THIS_MODULE,
+		   .pm = NULL,
+		   },
+	.probe = lm3554_probe,
+	.remove = __devexit_p(lm3554_remove),
+	.id_table = lm3554_id,
+};
+
+module_i2c_driver(lm3554_i2c_driver);
+
+MODULE_DESCRIPTION("Texas Instruments Flash Lighting driver for LM3554");
+MODULE_AUTHOR("Daniel Jeong <daniel.jeong@ti.com>");
+MODULE_AUTHOR("G.Shark Jeong <gshark.jeong@gmail.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/platform_data/leds-lm3554.h b/include/linux/platform_data/leds-lm3554.h
new file mode 100644
index 0000000..883cfbd
--- /dev/null
+++ b/include/linux/platform_data/leds-lm3554.h
@@ -0,0 +1,66 @@
+/*
+ * Copyright (C) 2012 Texas Instruments
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * Simple driver for Texas Instruments LM3554 LED driver chip
+ *
+ * Author: Daniel Jeong <daniel.jeong@gmail.com>
+ *	   G.Shark Jeong <gshark.jeong@gmail.com>
+ */
+
+#ifndef _LINUX_LED_FLASH_LM3554_H__
+#define _LINUX_LED_FLASH_LM3554_H__
+
+#define LM3554_NAME "leds-lm3554"
+
+/* input pin configuration */
+enum lm3554_strobe {
+	LM3554_STROBE_DISABLE = 0x04,
+	LM3554_STROBE_EN = 0x00,
+};
+
+/* input pin configuration */
+enum lm3554_tx1 {
+	LM3554_TX1_FL_INT = 0x00,
+	LM3554_TX1_HW_TORCH = 0x80,
+	LM3554_TX1_GPIO = 0x10,
+};
+
+/* input pin configuration */
+enum lm3554_tx2 {
+	LM3554_TX2_EMVM = 0x00,
+	LM3554_TX2_PAM_SYNC = 0x20,
+	LM3554_TX2_GPIO = 0x10,
+};
+
+/* output pin configuration */
+enum lm3554_ledi {
+	LM3554_LEDI_INDICATOR = 0x00,
+	LM3554_LEDI_THERMAL_COMP = 0x08,
+};
+
+enum lm3554_vout {
+	LM3554_VOUTMODE_DISABLE = 0x00,
+	LM3554_VOUTMODE_ENABLE = 0x04,
+};
+
+/**
+ * struct lm3554_platform_data
+ * @strobe : strobe input enable
+ * @pin_tx1 : input pin tx1/torch/gpio1
+ * @pin_tx2 : input pin envm/tx2/gpio2
+ * @ledi_pin : output pin ledi/ntc
+ * @vout_mode : voltage out mode
+ */
+struct lm3554_platform_data {
+	enum lm3554_strobe pin_strobe;
+
+	enum lm3554_tx1 pin_tx1;
+	enum lm3554_tx2 pin_tx2;
+
+	enum lm3554_ledi ledi_pin;
+	enum lm3554_vout vout_mode;
+};
+
+#endif /* _LINUX_LED_FLASH_LM3554_H__ */
-- 
1.7.5.4


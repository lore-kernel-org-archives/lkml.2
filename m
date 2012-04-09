Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab2DICDu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 22:03:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61853 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab2DICDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 22:03:49 -0400
From: Geon Si Jeong <gshark.jeong@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Daniel Jeong <daniel.jeong@ti.com>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geon Si Jeong <gshark.jeong@gmail.com>
Subject: [PATCH 1/1 v1] leds: Add LED driver for lm3556 chip
Date: Mon,  9 Apr 2012 11:00:55 +0900
Message-Id: <1333936855-8807-2-git-send-email-gshark.jeong@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333936855-8807-1-git-send-email-gshark.jeong@gmail.com>
References: <1333936855-8807-1-git-send-email-gshark.jeong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is a simple driver for LM3556 Chip(Texas Instruments)
LM3556 :
The LM3556 is a 4 MHz fixed-frequency synchronous boost
converter plus 1.5A constant current driver for a high-current white LED.
Datasheet: www.national.com/ds/LM/LM3556.pdf

Tested on OMAP4430

Signed-off-by: Geon Si Jeong <gshark.jeong@gmail.com>
---
 drivers/leds/Kconfig        |    9 +
 drivers/leds/Makefile       |    2 +-
 drivers/leds/leds-lm3556.c  |  471 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/leds-lm3556.h |  242 ++++++++++++++++++++++
 4 files changed, 723 insertions(+), 1 deletions(-)
 create mode 100644 drivers/leds/leds-lm3556.c
 create mode 100644 include/linux/leds-lm3556.h

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 589ba02..8ebdb3f 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -401,6 +401,15 @@ config LEDS_MAX8997
 	  This option enables support for on-chip LED drivers on
 	  MAXIM MAX8997 PMIC.
 
+config LEDS_LM3556
+	tristate "LED Support for TI LM3556 Chip"
+	depends on LEDS_CLASS
+	depends on I2C
+	help
+	  This option enables support for LEDs connected to LM3556.
+	  LM3556 includes Torch, Flash and Indicator functions and
+	  controlled via I2C.
+
 config LEDS_OT200
 	tristate "LED support for the Bachmann OT200"
 	depends on LEDS_CLASS && HAS_IOMEM
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index fa0f428..8ad2a46 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -46,7 +46,7 @@ obj-$(CONFIG_LEDS_NETXBIG)		+= leds-netxbig.o
 obj-$(CONFIG_LEDS_ASIC3)		+= leds-asic3.o
 obj-$(CONFIG_LEDS_RENESAS_TPU)		+= leds-renesas-tpu.o
 obj-$(CONFIG_LEDS_MAX8997)		+= leds-max8997.o
-
+obj-$(CONFIG_LEDS_LM3556)		+= leds-lm3556.o
 # LED SPI Drivers
 obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
 
diff --git a/drivers/leds/leds-lm3556.c b/drivers/leds/leds-lm3556.c
new file mode 100644
index 0000000..1f0045c
--- /dev/null
+++ b/drivers/leds/leds-lm3556.c
@@ -0,0 +1,471 @@
+/*
+ * Simple driver for Texas Instruments LM3556 LED Flash driver chip (Rev0x03)
+ * Copyright (C) 2012 Texas Instruments
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/leds.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/types.h>
+#include <linux/ctype.h>
+#include <linux/fs.h>
+#include <linux/leds-lm3556.h>
+
+#define	REG_FILT_TIME			(0x0)
+#define	REG_IVFM_MODE			(0x1)
+#define	REG_NTC				(0x2)
+#define	REG_INDIC_TIME			(0x3)
+#define	REG_INDIC_BLINK			(0x4)
+#define	REG_INDIC_PERIOD		(0x5)
+#define	REG_TORCH_TIME			(0x6)
+#define	REG_CONF			(0x7)
+#define	REG_FLASH			(0x8)
+#define	REG_I_CTRL			(0x9)
+#define	REG_ENABLE			(0xA)
+#define	REG_FLAG			(0xB)
+#define	REG_MAX				(0xC)
+
+#define	IVFM_FILTER_TIME_SHIFT		(3)
+#define	UVLO_EN_SHIFT			(7)
+#define	HYSTERSIS_SHIFT			(5)
+#define	IVM_D_TH_SHIFT			(2)
+#define	IVFM_ADJ_MODE_SHIFT		(0)
+#define	NTC_EVENT_LVL_SHIFT		(5)
+#define	NTC_TRIP_TH_SHIFT		(2)
+#define	NTC_BIAS_I_LVL_SHIFT		(0)
+#define	INDIC_RAMP_UP_TIME_SHIFT	(3)
+#define	INDIC_RAMP_DN_TIME_SHIFT	(0)
+#define	INDIC_N_BLANK_SHIFT		(4)
+#define	INDIC_PULSE_TIME_SHIFT		(0)
+#define	INDIC_N_PERIOD_SHIFT		(0)
+#define	TORCH_RAMP_UP_TIME_SHIFT	(3)
+#define	TORCH_RAMP_DN_TIME_SHIFT	(0)
+#define	STROBE_USUAGE_SHIFT		(7)
+#define	STROBE_PIN_POLARITY_SHIFT	(6)
+#define	TORCH_PIN_POLARITY_SHIFT	(5)
+#define	TX_PIN_POLARITY_SHIFT		(4)
+#define	TX_EVENT_LVL_SHIFT		(3)
+#define	IVFM_EN_SHIFT			(2)
+#define	NTC_MODE_SHIFT			(1)
+#define	INDIC_MODE_SHIFT		(0)
+#define	INDUCTOR_I_LIMIT_SHIFT		(6)
+#define	FLASH_RAMP_TIME_SHIFT		(3)
+#define	FLASH_TOUT_TIME_SHIFT		(0)
+#define	TORCH_I_SHIFT			(4)
+#define	FLASH_I_SHIFT			(0)
+#define	NTC_EN_SHIFT			(7)
+#define	TX_PIN_EN_SHIFT			(6)
+#define	STROBE_PIN_EN_SHIFT		(5)
+#define	TORCH_PIN_EN_SHIFT		(4)
+#define	PRECHG_MODE_EN_SHIFT		(3)
+#define	PASS_MODE_ONLY_EN_SHIFT		(2)
+#define	MODE_BITS_SHIFT			(0)
+
+#define	IVFM_FILTER_TIME_MASK		(0x3)
+#define	UVLO_EN_MASK			(0x1)
+#define	HYSTERSIS_MASK			(0x3)
+#define	IVM_D_TH_MASK			(0x7)
+#define	IVFM_ADJ_MODE_MASK		(0x3)
+#define	NTC_EVENT_LVL_MASK		(0x1)
+#define	NTC_TRIP_TH_MASK		(0x7)
+#define	NTC_BIAS_I_LVL_MASK		(0x3)
+#define	INDIC_RAMP_UP_TIME_MASK		(0x7)
+#define	INDIC_RAMP_DN_TIME_MASK		(0x7)
+#define	INDIC_N_BLANK_MASK		(0x7)
+#define	INDIC_PULSE_TIME_MASK		(0x7)
+#define	INDIC_N_PERIOD_MASK		(0x7)
+#define	TORCH_RAMP_UP_TIME_MASK		(0x7)
+#define	TORCH_RAMP_DN_TIME_MASK		(0x7)
+#define	STROBE_USUAGE_MASK		(0x1)
+#define	STROBE_PIN_POLARITY_MASK	(0x1)
+#define	TORCH_PIN_POLARITY_MASK		(0x1)
+#define	TX_PIN_POLARITY_MASK		(0x1)
+#define	TX_EVENT_LVL_MASK		(0x1)
+#define	IVFM_EN_MASK			(0x1)
+#define	NTC_MODE_MASK			(0x1)
+#define	INDIC_MODE_MASK			(0x1)
+#define	INDUCTOR_I_LIMIT_MASK		(0x3)
+#define	FLASH_RAMP_TIME_MASK		(0x7)
+#define	FLASH_TOUT_TIME_MASK		(0x7)
+#define	TORCH_I_MASK			(0x7)
+#define	FLASH_I_MASK			(0xF)
+#define	NTC_EN_MASK			(0x1)
+#define	TX_PIN_EN_MASK			(0x1)
+#define	STROBE_PIN_EN_MASK		(0x1)
+#define	TORCH_PIN_EN_MASK		(0x1)
+#define	PRECHG_MODE_EN_MASK		(0x1)
+#define	PASS_MODE_ONLY_EN_MASK		(0x1)
+#define	MODE_BITS_MASK			(0x13)
+#define EX_PIN_CONTROL_MASK		(0xF1)
+#define EX_PIN_ENABLE_MASK		(0x70)
+
+#define INDIC_PATTERN_SIZE 4
+
+struct indicator {
+	u8 blinking;
+	u8 period_cnt;
+};
+
+struct lm3556_chip_data {
+	struct i2c_client *client;
+
+	struct led_classdev cdev_flash;
+	struct led_classdev cdev_torch;
+	struct led_classdev cdev_indicator;
+
+	struct lm3556_platform_data *pdata;
+	struct mutex lock;
+
+	u8 last_flag;
+};
+
+/*Indicator Pattern*/
+static struct indicator indicator_pattern[INDIC_PATTERN_SIZE] = {
+	[0] = {(INDIC_N_BLANK_1 << INDIC_N_BLANK_SHIFT)
+	       | PULSE_TIME_32_MS, INDIC_PERIOD_1},
+	[1] = {(INDIC_N_BLANK_15 << INDIC_N_BLANK_SHIFT)
+	       | PULSE_TIME_32_MS, INDIC_PERIOD_2},
+	[2] = {(INDIC_N_BLANK_10 << INDIC_N_BLANK_SHIFT)
+	       | PULSE_TIME_32_MS, INDIC_PERIOD_4},
+	[3] = {(INDIC_N_BLANK_5 << INDIC_N_BLANK_SHIFT)
+	       | PULSE_TIME_32_MS, INDIC_PERIOD_7},
+};
+
+/* i2c access*/
+static int lm3556_read_reg(struct i2c_client *client, u8 reg, u8 * val)
+{
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(client, reg);
+	if (ret < 0) {
+		dev_err(&client->dev, "i2c reading fail at 0x%02x error %d\n",
+			reg, ret);
+		return ret;
+	}
+	*val = ret & 0xff;
+	return ret;
+}
+
+static int lm3556_write_reg(struct i2c_client *client, u8 reg, u8 val)
+{
+	int ret = 0;
+
+	ret = i2c_smbus_write_byte_data(client, reg, val);
+
+	if (ret < 0)
+		dev_err(&client->dev, "i2c writting fail at 0x%02x\n", reg);
+	return ret;
+}
+
+static int lm3556_write_bits(struct i2c_client *client,
+			     u8 reg, u8 val, u8 mask, u8 shift)
+{
+	int ret;
+	u8 reg_val;
+	struct lm3556_chip_data *chip = i2c_get_clientdata(client);
+
+	mutex_lock(&chip->lock);
+	ret = lm3556_read_reg(client, reg, &reg_val);
+	if (ret < 0)
+		goto out;
+	reg_val &= (~(mask << shift));
+	reg_val |= ((val & mask) << shift);
+	ret = lm3556_write_reg(client, reg, reg_val);
+out:
+	mutex_unlock(&chip->lock);
+	return ret;
+}
+
+/* chip initialize*/
+static int lm3556_chip_init(struct lm3556_chip_data *chip)
+{
+	u8 reg_val;
+	int ret;
+	struct i2c_client *client = chip->client;
+	struct lm3556_platform_data *pdata = chip->pdata;
+
+	/*set config register */
+	ret = lm3556_read_reg(client, REG_CONF, &reg_val);
+	if (ret < 0)
+		goto out;
+	reg_val &= (~EX_PIN_CONTROL_MASK);
+	reg_val |= ((pdata->torch_pin_polarity & 0x01)
+		    << TORCH_PIN_POLARITY_SHIFT);
+	reg_val |= ((pdata->strobe_usuage & 0x01) << STROBE_USUAGE_SHIFT);
+	reg_val |= ((pdata->strobe_pin_polarity & 0x01)
+		    << STROBE_PIN_POLARITY_SHIFT);
+	reg_val |= ((pdata->tx_pin_polarity & 0x01) << TX_PIN_POLARITY_SHIFT);
+	reg_val |= ((pdata->indicator_mode & 0x01) << INDIC_MODE_SHIFT);
+	ret = lm3556_write_reg(client, REG_CONF, reg_val);
+	if (ret < 0)
+		goto out;
+
+	/*set enable register */
+	ret = lm3556_read_reg(client, REG_ENABLE, &reg_val);
+	if (ret < 0)
+		goto out;
+	reg_val &= (~EX_PIN_ENABLE_MASK);
+	reg_val |= ((pdata->torch_pin_en & 0x01) << TORCH_PIN_EN_SHIFT);
+	reg_val |= ((pdata->strobe_pin_en & 0x01) << STROBE_PIN_EN_SHIFT);
+	reg_val |= ((pdata->tx_pin_en & 0x01) << TX_PIN_EN_SHIFT);
+	ret = lm3556_write_reg(client, REG_ENABLE, reg_val);
+
+out:
+	return ret;
+}
+
+/* chip control*/
+static int lm3556_control(struct lm3556_chip_data *chip,
+			  u8 brightness, enum lm3556_mode opmode)
+{
+	int ret;
+	struct i2c_client *client = chip->client;
+	struct lm3556_platform_data *pdata = chip->pdata;
+
+	ret = lm3556_read_reg(client, REG_FLAG, &chip->last_flag);
+	if (ret < 0)
+		goto out;
+	if (chip->last_flag)
+		dev_info(&client->dev, "Last FLAG is 0x%x\n", chip->last_flag);
+
+	/*brightness 0 means off-state */
+	if (!brightness)
+		opmode = MODES_STASNDBY;
+
+	switch (opmode) {
+	case MODES_TORCH:
+		ret = lm3556_write_bits(client, REG_I_CTRL,
+					brightness - 1, TORCH_I_MASK,
+					TORCH_I_SHIFT);
+
+		if (pdata->torch_pin_en)
+			opmode |= (TORCH_PIN_EN_MASK << TORCH_PIN_EN_SHIFT);
+		break;
+
+	case MODES_FLASH:
+		ret = lm3556_write_bits(client, REG_I_CTRL,
+					brightness - 1, FLASH_I_MASK,
+					FLASH_I_SHIFT);
+		break;
+
+	case MODES_INDIC:
+		ret = lm3556_write_bits(client, REG_I_CTRL,
+					brightness - 1, TORCH_I_MASK,
+					TORCH_I_SHIFT);
+		break;
+
+	case MODES_STASNDBY:
+		if (pdata->torch_pin_en)
+			opmode |= (TORCH_PIN_EN_MASK << TORCH_PIN_EN_SHIFT);
+		break;
+
+	default:
+		return ret;
+	}
+	if (ret < 0)
+		goto out;
+	ret = lm3556_write_bits(client, REG_ENABLE,
+				opmode, MODE_BITS_MASK, MODE_BITS_SHIFT);
+out:
+	return ret;
+}
+
+/*torch */
+static void lm3556_torch_brightness_set(struct led_classdev *cdev,
+					enum led_brightness brightness)
+{
+	struct lm3556_chip_data *chip =
+	    container_of(cdev, struct lm3556_chip_data, cdev_torch);
+
+	lm3556_control(chip, brightness, MODES_TORCH);
+	return;
+}
+
+/* flash */
+static void lm3556_strobe_brightness_set(struct led_classdev *cdev,
+					 enum led_brightness brightness)
+{
+	struct lm3556_chip_data *chip =
+	    container_of(cdev, struct lm3556_chip_data, cdev_flash);
+
+	lm3556_control(chip, brightness, MODES_FLASH);
+	return;
+}
+
+/* indicator */
+static void lm3556_indicator_brightness_set(struct led_classdev *cdev,
+					    enum led_brightness brightness)
+{
+	struct lm3556_chip_data *chip =
+	    container_of(cdev, struct lm3556_chip_data, cdev_indicator);
+
+	lm3556_control(chip, brightness, MODES_INDIC);
+	return;
+}
+
+static ssize_t lm3556_indicator_pattern_store(struct device *dev,
+					      struct device_attribute *devAttr,
+					      const char *buf, size_t size)
+{
+	ssize_t ret;
+	struct i2c_client *client = container_of(dev->parent,
+						 struct i2c_client, dev);
+	unsigned int state;
+
+	ret = kstrtouint(buf, 10, &state);
+	if (ret)
+		goto out;
+	if (state > INDIC_PATTERN_SIZE - 1)
+		state = INDIC_PATTERN_SIZE - 1;
+
+	ret = lm3556_write_reg(client, REG_INDIC_BLINK,
+			       indicator_pattern[state].blinking);
+	if (ret < 0)
+		goto out;
+	ret = lm3556_write_reg(client, REG_INDIC_PERIOD,
+			       indicator_pattern[state].period_cnt);
+	if (ret < 0)
+		goto out;
+	return size;
+out:
+	dev_err(&client->dev, "pattern doesn't saved\n");
+	return size;
+}
+
+static DEVICE_ATTR(pattern, 0644, NULL, lm3556_indicator_pattern_store);
+
+/* Module Initialize */
+static int lm3556_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct lm3556_platform_data *pdata = client->dev.platform_data;
+	struct lm3556_chip_data *chip;
+
+	int err;
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
+	    devm_kzalloc(&client->dev, sizeof(struct lm3556_chip_data),
+			 GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	chip->client = client;
+	chip->pdata = pdata;
+
+	mutex_init(&chip->lock);
+	i2c_set_clientdata(client, chip);
+
+	err = lm3556_chip_init(chip);
+	if (err < 0)
+		goto err_chip_init;
+
+	/*flash */
+	chip->cdev_flash.name = "flash";
+	chip->cdev_flash.max_brightness = 16;
+	chip->cdev_flash.brightness_set = lm3556_strobe_brightness_set;
+	err = led_classdev_register((struct device *)
+				    &client->dev, &chip->cdev_flash);
+	if (err < 0)
+		goto err_create_flash_file;
+	/*torch */
+	chip->cdev_torch.name = "torch";
+	chip->cdev_torch.max_brightness = 8;
+	chip->cdev_torch.brightness_set = lm3556_torch_brightness_set;
+	err = led_classdev_register((struct device *)
+				    &client->dev, &chip->cdev_torch);
+	if (err < 0)
+		goto err_create_torch_file;
+	/*indicator */
+	chip->cdev_indicator.name = "indicator";
+	chip->cdev_indicator.max_brightness = 8;
+	chip->cdev_indicator.brightness_set = lm3556_indicator_brightness_set;
+	err = led_classdev_register((struct device *)
+				    &client->dev, &chip->cdev_indicator);
+	if (err < 0)
+		goto err_create_indicator_file;
+
+	err = device_create_file(chip->cdev_indicator.dev, &dev_attr_pattern);
+	if (err < 0)
+		goto err_create_pattern_file;
+
+	return 0;
+
+err_create_pattern_file:
+	led_classdev_unregister(&chip->cdev_indicator);
+err_create_indicator_file:
+	led_classdev_unregister(&chip->cdev_torch);
+err_create_torch_file:
+	led_classdev_unregister(&chip->cdev_flash);
+err_create_flash_file:
+err_chip_init:
+	i2c_set_clientdata(client, NULL);
+	kfree(chip);
+	return err;
+}
+
+static int lm3556_remove(struct i2c_client *client)
+{
+	struct lm3556_chip_data *chip = i2c_get_clientdata(client);
+
+	device_remove_file(chip->cdev_indicator.dev, &dev_attr_pattern);
+	led_classdev_unregister(&chip->cdev_indicator);
+	led_classdev_unregister(&chip->cdev_torch);
+	led_classdev_unregister(&chip->cdev_flash);
+	lm3556_write_reg(client, REG_ENABLE, 0);
+
+	kfree(chip);
+	return 0;
+}
+
+static const struct i2c_device_id lm3556_id[] = {
+	{LM3556_NAME, 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, lm3556_id);
+
+static struct i2c_driver lm3556_i2c_driver = {
+	.driver = {
+		   .name = LM3556_NAME,
+		   .owner = THIS_MODULE,
+		   .pm = NULL,
+		   },
+	.probe = lm3556_probe,
+	.remove = __devexit_p(lm3556_remove),
+	.id_table = lm3556_id,
+};
+
+static int __init lm3556_init(void)
+{
+	return i2c_add_driver(&lm3556_i2c_driver);
+}
+
+static void __exit lm3556_exit(void)
+{
+	i2c_del_driver(&lm3556_i2c_driver);
+}
+
+module_init(lm3556_init);
+module_exit(lm3556_exit);
+
+MODULE_DESCRIPTION("Texas Instruments Flash Lighting driver for LM3556");
+MODULE_AUTHOR
+("Geon Si Jeong <daniel.jeong@ti.com>, Woogyom Kim <milo.kim@ti.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/leds-lm3556.h b/include/linux/leds-lm3556.h
new file mode 100644
index 0000000..115ee65
--- /dev/null
+++ b/include/linux/leds-lm3556.h
@@ -0,0 +1,242 @@
+/*
+ * Simple driver for Texas Instruments LM3556 LED Flash driver chip (Rev0x03)
+ * Copyright (C) 2012 Texas Instruments
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __LINUX_LM3556_H
+#define __LINUX_LM3556_H
+
+#define LM3556_NAME "leds-lm3556"
+
+enum lm3556_ivfm_filter_time {
+	IVFM_FILTER_TIME_HALF_CURRENT_STEP = 0,
+	IVFM_FILTER_TIME_256_USEC,
+	IVFM_FILTER_TIME_512_USEC,
+	IVFM_FILTER_TIME_1024_USEC
+};
+
+enum lm3556_ivfm_adj_mode {
+	IVFM_ADJ_MODE_REPORT = 0,
+	IVFM_ADJ_MODESTOP_HOLD,
+	IVFM_ADJ_MODE_DOWN,
+	IVFM_ADJ_MODE_UP_DOWN,
+};
+
+enum lm3556_ivfm_down_threshold {
+	IVFM_DN_TH_2_7_V = 0,
+	IVFM_DN_TH_2_8_V,
+	IVFM_DN_TH_2_9_V,
+	IVFM_DN_TH_3_0_V,
+	IVFM_DN_TH_3_1_V,
+	IVFM_DN_TH_3_2_V,
+	IVFM_DN_TH_3_3_V,
+	IVFM_DN_TH_3_4_V,
+};
+
+enum lm3556_ivfm_hyst {
+	IVFM_HYST_50_MV = 0,
+	IVFM_HYST_100_MV,
+	IVFM_HYST_150_MV,
+	IVFM_HYST_DIS
+};
+
+enum lm3556_ntc_curr_lvl {
+	NTC_CURR_LVL_25_UA = 0,
+	NTC_CURR_LVL_50_UA,
+	NTC_CURR_LVL_75_UA,
+	NTC_CURR_LVL_100_UA
+};
+
+enum lm3556_ntc_trip_threshold {
+	NTC_TRIP_THRESHOLD_200_MV = 0,
+	NTC_TRIP_THRESHOLD_300_MV,
+	NTC_TRIP_THRESHOLD_400_MV,
+	NTC_TRIP_THRESHOLD_500_MV,
+	NTC_TRIP_THRESHOLD_600_MV,
+	NTC_TRIP_THRESHOLD_700_MV,
+	NTC_TRIP_THRESHOLD_800_MV,
+	NTC_TRIP_THRESHOLD_900_MV
+};
+
+enum lm3556_ntc_event_lvl {
+	NTC_EVENT_LVL_STANDBY = 0,
+	NTC_EVENT_LVL_REDUCE_MIN_TORCH
+};
+
+enum lm3556_torch_indic_ramp_time {
+	TORCH_INDIC_RAMP_TIME_16_MS = 0,
+	TORCH_INDIC_RAMP_TIME_32_MS,
+	TORCH_INDIC_RAMP_TIME_64_MS,
+	TORCH_INDIC_RAMP_TIME_128_MS,
+	TORCH_INDIC_RAMP_TIME_256_MS,
+	TORCH_INDIC_RAMP_TIME_512_MS,
+	TORCH_INDIC_RAMP_TIME_1024_MS,
+	TORCH_INDIC_RAMP_TIME_2048_MS,
+};
+
+enum lm3556_indic_pulse_time {
+	PULSE_TIME_0_MS = 0,
+	PULSE_TIME_32_MS,
+	PULSE_TIME_64_MS,
+	PULSE_TIME_92_MS,
+	PULSE_TIME_128_MS,
+	PULSE_TIME_160_MS,
+	PULSE_TIME_196_MS,
+	PULSE_TIME_224_MS,
+	PULSE_TIME_256_MS,
+	PULSE_TIME_288_MS,
+	PULSE_TIME_320_MS,
+	PULSE_TIME_352_MS,
+	PULSE_TIME_384_MS,
+	PULSE_TIME_416_MS,
+	PULSE_TIME_448_MS,
+	PULSE_TIME_480_MS,
+};
+
+enum lm3556_indic_n_blank {
+	INDIC_N_BLANK_0 = 0,
+	INDIC_N_BLANK_1,
+	INDIC_N_BLANK_2,
+	INDIC_N_BLANK_3,
+	INDIC_N_BLANK_4,
+	INDIC_N_BLANK_5,
+	INDIC_N_BLANK_6,
+	INDIC_N_BLANK_7,
+	INDIC_N_BLANK_8,
+	INDIC_N_BLANK_9,
+	INDIC_N_BLANK_10,
+	INDIC_N_BLANK_11,
+	INDIC_N_BLANK_12,
+	INDIC_N_BLANK_13,
+	INDIC_N_BLANK_14,
+	INDIC_N_BLANK_15,
+};
+
+enum lm3556_indic_period {
+	INDIC_PERIOD_0 = 0,
+	INDIC_PERIOD_1,
+	INDIC_PERIOD_2,
+	INDIC_PERIOD_3,
+	INDIC_PERIOD_4,
+	INDIC_PERIOD_5,
+	INDIC_PERIOD_6,
+	INDIC_PERIOD_7,
+};
+
+enum lm3556_indic_mode {
+	INDIC_MODE_INTERNAL = 0,
+	INDIC_MODE_EXTERNAL,
+};
+
+enum lm3556_flash_timeout {
+	FLASH_TIMEOUT_50_MS = 0,
+	FLASH_TIMEOUT_100_MS,
+	FLASH_TIMEOUT_150_MS,
+	FLASH_TIMEOUT_200_MS,
+	FLASH_TIMEOUT_250_MS,
+	FLASH_TIMEOUT_300_MS,
+	FLASH_TIMEOUT_350_MS,
+	FLASH_TIMEOUT_400_MS,
+};
+
+enum lm3556_flash_ramp_time {
+	FLASH_RAMP_TIME_256_US = 0,
+	FLASH_RAMP_TIME_512_US,
+	FLASH_RAMP_TIME_1024_US,
+	FLASH_RAMP_TIME_2048_US,
+	FLASH_RAMP_TIME_4096_US,
+	FLASH_RAMP_TIME_8192_US,
+	FLASH_RAMP_TIME_16384_US,
+	FLASH_RAMP_TIME_32768_US,
+};
+
+enum lm3556_inductor_current_limit {
+	INDIC_I_LIMIT_1500_MA = 0,
+	INDIC_I_LIMIT_2000_MA,
+	INDIC_I_LIMIT_2500_MA,
+	INDIC_I_LIMIT_3000_MA
+};
+
+enum lm3556_flash_current {
+	FLASH_I_93750_UA = 0,
+	FLASH_I_187500_UA,
+	FLASH_I_281250_UA,
+	FLASH_I_375000_UA,
+	FLASH_I_468750_UA,
+	FLASH_I_562500_UA,
+	FLASH_I_656250_UA,
+	FLASH_I_750000_UA,
+	FLASH_I_843750_UA,
+	FLASH_I_937500_UA,
+	FLASH_I_1031250_UA,
+	FLASH_I_1125000_UA,
+	FLASH_I_1218750_UA,
+	FLASH_I_1312500_UA,
+	FLASH_I_1406250_UA,
+	FLASH_I_1500000_UA,
+
+};
+
+enum lm3556_torch_current {
+	TORCH_I_46880_UA = 0,
+	TORCH_I_93750_UA,
+	TORCH_I_1406300_UA,
+	TORCH_I_187500_UA,
+	TORCH_I_234380_UA,
+	TORCH_I_281250_UA,
+	TORCH_I_328130_UA,
+	TORCH_I_375000_UA,
+};
+
+enum lm3556_mode {
+	MODES_STASNDBY = 0,
+	MODES_INDIC,
+	MODES_TORCH,
+	MODES_FLASH
+};
+
+enum lm3556_pass_mode {
+	PASS_MODE_NORMAL = 0,
+	PASS_MODE_PASS_ONLY
+};
+
+enum lm3556_prechg_mode {
+	PRE_CHARGE_MODE_NORMAL = 0,
+	PRE_CHARGE_MODE_PRE_CHARGE
+};
+
+enum lm3556_pin_polarity {
+	PIN_LOW_ACTIVE = 0,
+	PIN_HIGH_ACTIVE,
+};
+
+enum lm3556_pin_enable {
+	PIN_DISABLED = 0,
+	PIN_ENABLED,
+};
+
+enum lm3556_strobe_usuage {
+	STROBE_EDGE_DETECT = 0,
+	STROBE_LEVEL_DETECT,
+};
+
+struct lm3556_platform_data {
+	enum lm3556_pin_enable torch_pin_en;
+	enum lm3556_pin_polarity torch_pin_polarity;
+
+	enum lm3556_strobe_usuage strobe_usuage;
+	enum lm3556_pin_enable strobe_pin_en;
+	enum lm3556_pin_polarity strobe_pin_polarity;
+
+	enum lm3556_pin_enable tx_pin_en;
+	enum lm3556_pin_polarity tx_pin_polarity;
+
+	enum lm3556_indic_mode indicator_mode;
+};
+
+#endif /* __LINUX_LM3556_H */
-- 
1.7.5.4


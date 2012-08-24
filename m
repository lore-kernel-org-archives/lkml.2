Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab2HXEJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 00:09:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35256 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab2HXEJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 00:09:23 -0400
From: "G.Shark Jeong" <gshark.jeong@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: Daniel Jeong <daniel.jeong@ti.com>, <linux-kernel@vger.kernel.org>,
        "G.Shark Jeong" <gshark.jeong@gmail.com>
Subject: [PATCH 1/1 v1] leds: Add new LED driver for lm355x chips
Date: Fri, 24 Aug 2012 13:06:55 +0900
Message-Id: <1345781215-1497-2-git-send-email-gshark.jeong@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1345781215-1497-1-git-send-email-gshark.jeong@gmail.com>
References: <1345781215-1497-1-git-send-email-gshark.jeong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "G.Shark Jeong" <gshark.jeong@gmail.com>

LM3554 and LM3556 have similar functions but very different register map.
This driver is a general version for LM355x,lm3554 and lm3556,led chips of TI.
lm3556 driver can be replaced by this driver.

LM3554 :
The LM3554 is a 2 MHz fixed-frequency synchronous boost
converter with 1.2A dual high side led drivers.
Datasheet: www.ti.com/lit/ds/symlink/lm3554.pdf

LM3556 :
The LM3556 is a 4 MHz fixed-frequency synchronous boost
converter plus 1.5A constant current driver for a high-current white LED.
Datasheet: www.national.com/ds/LM/LM3556.pdf

Signed-off-by: G.Shark Jeong <gshark.jeong@gmail.com>
---
 drivers/leds/Kconfig                      |    8 +-
 drivers/leds/Makefile                     |    2 +-
 drivers/leds/leds-lm3556.c                |  512 ----------------------------
 drivers/leds/leds-lm355x.c                |  529 +++++++++++++++++++++++++++++
 include/linux/platform_data/leds-lm3556.h |   50 ---
 include/linux/platform_data/leds-lm355x.h |   66 ++++
 6 files changed, 600 insertions(+), 567 deletions(-)
 delete mode 100644 drivers/leds/leds-lm3556.c
 create mode 100644 drivers/leds/leds-lm355x.c
 delete mode 100644 include/linux/platform_data/leds-lm3556.h
 create mode 100644 include/linux/platform_data/leds-lm355x.h

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index c96bbaa..4f6ced2 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -422,13 +422,13 @@ config LEDS_MAX8997
 	  This option enables support for on-chip LED drivers on
 	  MAXIM MAX8997 PMIC.
 
-config LEDS_LM3556
-	tristate "LED support for LM3556 Chip"
+config LEDS_LM355x
+	tristate "LED support for LM355x Chips, LM3554 and LM3556"
 	depends on LEDS_CLASS && I2C
 	select REGMAP_I2C
 	help
-	  This option enables support for LEDs connected to LM3556.
-	  LM3556 includes Torch, Flash and Indicator functions.
+	  This option enables support for LEDs connected to LM355x.
+	  LM355x includes Torch, Flash and Indicator functions.
 
 config LEDS_OT200
 	tristate "LED support for the Bachmann OT200"
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index a4429a9..b57a021 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -48,7 +48,7 @@ obj-$(CONFIG_LEDS_NETXBIG)		+= leds-netxbig.o
 obj-$(CONFIG_LEDS_ASIC3)		+= leds-asic3.o
 obj-$(CONFIG_LEDS_RENESAS_TPU)		+= leds-renesas-tpu.o
 obj-$(CONFIG_LEDS_MAX8997)		+= leds-max8997.o
-obj-$(CONFIG_LEDS_LM3556)		+= leds-lm3556.o
+obj-$(CONFIG_LEDS_LM355x)		+= leds-lm355x.o
 obj-$(CONFIG_LEDS_BLINKM)		+= leds-blinkm.o
 
 # LED SPI Drivers
diff --git a/drivers/leds/leds-lm3556.c b/drivers/leds/leds-lm3556.c
deleted file mode 100644
index 3062abd..0000000
--- a/drivers/leds/leds-lm3556.c
+++ /dev/null
@@ -1,512 +0,0 @@
-/*
- * Simple driver for Texas Instruments LM3556 LED Flash driver chip (Rev0x03)
- * Copyright (C) 2012 Texas Instruments
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Please refer Documentation/leds/leds-lm3556.txt file.
- */
-#include <linux/module.h>
-#include <linux/delay.h>
-#include <linux/i2c.h>
-#include <linux/leds.h>
-#include <linux/slab.h>
-#include <linux/platform_device.h>
-#include <linux/fs.h>
-#include <linux/regmap.h>
-#include <linux/platform_data/leds-lm3556.h>
-
-#define REG_FILT_TIME			(0x0)
-#define REG_IVFM_MODE			(0x1)
-#define REG_NTC				(0x2)
-#define REG_INDIC_TIME			(0x3)
-#define REG_INDIC_BLINK			(0x4)
-#define REG_INDIC_PERIOD		(0x5)
-#define REG_TORCH_TIME			(0x6)
-#define REG_CONF			(0x7)
-#define REG_FLASH			(0x8)
-#define REG_I_CTRL			(0x9)
-#define REG_ENABLE			(0xA)
-#define REG_FLAG			(0xB)
-#define REG_MAX				(0xB)
-
-#define IVFM_FILTER_TIME_SHIFT		(3)
-#define UVLO_EN_SHIFT			(7)
-#define HYSTERSIS_SHIFT			(5)
-#define IVM_D_TH_SHIFT			(2)
-#define IVFM_ADJ_MODE_SHIFT		(0)
-#define NTC_EVENT_LVL_SHIFT		(5)
-#define NTC_TRIP_TH_SHIFT		(2)
-#define NTC_BIAS_I_LVL_SHIFT		(0)
-#define INDIC_RAMP_UP_TIME_SHIFT	(3)
-#define INDIC_RAMP_DN_TIME_SHIFT	(0)
-#define INDIC_N_BLANK_SHIFT		(4)
-#define INDIC_PULSE_TIME_SHIFT		(0)
-#define INDIC_N_PERIOD_SHIFT		(0)
-#define TORCH_RAMP_UP_TIME_SHIFT	(3)
-#define TORCH_RAMP_DN_TIME_SHIFT	(0)
-#define STROBE_USUAGE_SHIFT		(7)
-#define STROBE_PIN_POLARITY_SHIFT	(6)
-#define TORCH_PIN_POLARITY_SHIFT	(5)
-#define TX_PIN_POLARITY_SHIFT		(4)
-#define TX_EVENT_LVL_SHIFT		(3)
-#define IVFM_EN_SHIFT			(2)
-#define NTC_MODE_SHIFT			(1)
-#define INDIC_MODE_SHIFT		(0)
-#define INDUCTOR_I_LIMIT_SHIFT		(6)
-#define FLASH_RAMP_TIME_SHIFT		(3)
-#define FLASH_TOUT_TIME_SHIFT		(0)
-#define TORCH_I_SHIFT			(4)
-#define FLASH_I_SHIFT			(0)
-#define NTC_EN_SHIFT			(7)
-#define TX_PIN_EN_SHIFT			(6)
-#define STROBE_PIN_EN_SHIFT		(5)
-#define TORCH_PIN_EN_SHIFT		(4)
-#define PRECHG_MODE_EN_SHIFT		(3)
-#define PASS_MODE_ONLY_EN_SHIFT		(2)
-#define MODE_BITS_SHIFT			(0)
-
-#define IVFM_FILTER_TIME_MASK		(0x3)
-#define UVLO_EN_MASK			(0x1)
-#define HYSTERSIS_MASK			(0x3)
-#define IVM_D_TH_MASK			(0x7)
-#define IVFM_ADJ_MODE_MASK		(0x3)
-#define NTC_EVENT_LVL_MASK		(0x1)
-#define NTC_TRIP_TH_MASK		(0x7)
-#define NTC_BIAS_I_LVL_MASK		(0x3)
-#define INDIC_RAMP_UP_TIME_MASK		(0x7)
-#define INDIC_RAMP_DN_TIME_MASK		(0x7)
-#define INDIC_N_BLANK_MASK		(0x7)
-#define INDIC_PULSE_TIME_MASK		(0x7)
-#define INDIC_N_PERIOD_MASK		(0x7)
-#define TORCH_RAMP_UP_TIME_MASK		(0x7)
-#define TORCH_RAMP_DN_TIME_MASK		(0x7)
-#define STROBE_USUAGE_MASK		(0x1)
-#define STROBE_PIN_POLARITY_MASK	(0x1)
-#define TORCH_PIN_POLARITY_MASK		(0x1)
-#define TX_PIN_POLARITY_MASK		(0x1)
-#define TX_EVENT_LVL_MASK		(0x1)
-#define IVFM_EN_MASK			(0x1)
-#define NTC_MODE_MASK			(0x1)
-#define INDIC_MODE_MASK			(0x1)
-#define INDUCTOR_I_LIMIT_MASK		(0x3)
-#define FLASH_RAMP_TIME_MASK		(0x7)
-#define FLASH_TOUT_TIME_MASK		(0x7)
-#define TORCH_I_MASK			(0x7)
-#define FLASH_I_MASK			(0xF)
-#define NTC_EN_MASK			(0x1)
-#define TX_PIN_EN_MASK			(0x1)
-#define STROBE_PIN_EN_MASK		(0x1)
-#define TORCH_PIN_EN_MASK		(0x1)
-#define PRECHG_MODE_EN_MASK		(0x1)
-#define PASS_MODE_ONLY_EN_MASK		(0x1)
-#define MODE_BITS_MASK			(0x13)
-#define EX_PIN_CONTROL_MASK		(0xF1)
-#define EX_PIN_ENABLE_MASK		(0x70)
-
-enum lm3556_indic_pulse_time {
-	PULSE_TIME_0_MS = 0,
-	PULSE_TIME_32_MS,
-	PULSE_TIME_64_MS,
-	PULSE_TIME_92_MS,
-	PULSE_TIME_128_MS,
-	PULSE_TIME_160_MS,
-	PULSE_TIME_196_MS,
-	PULSE_TIME_224_MS,
-	PULSE_TIME_256_MS,
-	PULSE_TIME_288_MS,
-	PULSE_TIME_320_MS,
-	PULSE_TIME_352_MS,
-	PULSE_TIME_384_MS,
-	PULSE_TIME_416_MS,
-	PULSE_TIME_448_MS,
-	PULSE_TIME_480_MS,
-};
-
-enum lm3556_indic_n_blank {
-	INDIC_N_BLANK_0 = 0,
-	INDIC_N_BLANK_1,
-	INDIC_N_BLANK_2,
-	INDIC_N_BLANK_3,
-	INDIC_N_BLANK_4,
-	INDIC_N_BLANK_5,
-	INDIC_N_BLANK_6,
-	INDIC_N_BLANK_7,
-	INDIC_N_BLANK_8,
-	INDIC_N_BLANK_9,
-	INDIC_N_BLANK_10,
-	INDIC_N_BLANK_11,
-	INDIC_N_BLANK_12,
-	INDIC_N_BLANK_13,
-	INDIC_N_BLANK_14,
-	INDIC_N_BLANK_15,
-};
-
-enum lm3556_indic_period {
-	INDIC_PERIOD_0 = 0,
-	INDIC_PERIOD_1,
-	INDIC_PERIOD_2,
-	INDIC_PERIOD_3,
-	INDIC_PERIOD_4,
-	INDIC_PERIOD_5,
-	INDIC_PERIOD_6,
-	INDIC_PERIOD_7,
-};
-
-enum lm3556_mode {
-	MODES_STASNDBY = 0,
-	MODES_INDIC,
-	MODES_TORCH,
-	MODES_FLASH
-};
-
-#define INDIC_PATTERN_SIZE 4
-
-struct indicator {
-	u8 blinking;
-	u8 period_cnt;
-};
-
-struct lm3556_chip_data {
-	struct device *dev;
-
-	struct led_classdev cdev_flash;
-	struct led_classdev cdev_torch;
-	struct led_classdev cdev_indicator;
-
-	struct lm3556_platform_data *pdata;
-	struct regmap *regmap;
-	struct mutex lock;
-
-	unsigned int last_flag;
-};
-
-/* indicator pattern */
-static struct indicator indicator_pattern[INDIC_PATTERN_SIZE] = {
-	[0] = {(INDIC_N_BLANK_1 << INDIC_N_BLANK_SHIFT)
-	       | PULSE_TIME_32_MS, INDIC_PERIOD_1},
-	[1] = {(INDIC_N_BLANK_15 << INDIC_N_BLANK_SHIFT)
-	       | PULSE_TIME_32_MS, INDIC_PERIOD_2},
-	[2] = {(INDIC_N_BLANK_10 << INDIC_N_BLANK_SHIFT)
-	       | PULSE_TIME_32_MS, INDIC_PERIOD_4},
-	[3] = {(INDIC_N_BLANK_5 << INDIC_N_BLANK_SHIFT)
-	       | PULSE_TIME_32_MS, INDIC_PERIOD_7},
-};
-
-/* chip initialize */
-static int __devinit lm3556_chip_init(struct lm3556_chip_data *chip)
-{
-	unsigned int reg_val;
-	int ret;
-	struct lm3556_platform_data *pdata = chip->pdata;
-
-	/* set config register */
-	ret = regmap_read(chip->regmap, REG_CONF, &reg_val);
-	if (ret < 0) {
-		dev_err(chip->dev, "Failed to read REG_CONF Register\n");
-		goto out;
-	}
-
-	reg_val &= (~EX_PIN_CONTROL_MASK);
-	reg_val |= ((pdata->torch_pin_polarity & 0x01)
-		    << TORCH_PIN_POLARITY_SHIFT);
-	reg_val |= ((pdata->strobe_usuage & 0x01) << STROBE_USUAGE_SHIFT);
-	reg_val |= ((pdata->strobe_pin_polarity & 0x01)
-		    << STROBE_PIN_POLARITY_SHIFT);
-	reg_val |= ((pdata->tx_pin_polarity & 0x01) << TX_PIN_POLARITY_SHIFT);
-	reg_val |= ((pdata->indicator_mode & 0x01) << INDIC_MODE_SHIFT);
-
-	ret = regmap_write(chip->regmap, REG_CONF, reg_val);
-	if (ret < 0) {
-		dev_err(chip->dev, "Failed to write REG_CONF Regisgter\n");
-		goto out;
-	}
-
-	/* set enable register */
-	ret = regmap_read(chip->regmap, REG_ENABLE, &reg_val);
-	if (ret < 0) {
-		dev_err(chip->dev, "Failed to read REG_ENABLE Register\n");
-		goto out;
-	}
-
-	reg_val &= (~EX_PIN_ENABLE_MASK);
-	reg_val |= ((pdata->torch_pin_en & 0x01) << TORCH_PIN_EN_SHIFT);
-	reg_val |= ((pdata->strobe_pin_en & 0x01) << STROBE_PIN_EN_SHIFT);
-	reg_val |= ((pdata->tx_pin_en & 0x01) << TX_PIN_EN_SHIFT);
-
-	ret = regmap_write(chip->regmap, REG_ENABLE, reg_val);
-	if (ret < 0) {
-		dev_err(chip->dev, "Failed to write REG_ENABLE Regisgter\n");
-		goto out;
-	}
-
-out:
-	return ret;
-}
-
-/* chip control */
-static int lm3556_control(struct lm3556_chip_data *chip,
-			  u8 brightness, enum lm3556_mode opmode)
-{
-	int ret;
-	struct lm3556_platform_data *pdata = chip->pdata;
-
-	ret = regmap_read(chip->regmap, REG_FLAG, &chip->last_flag);
-	if (ret < 0) {
-		dev_err(chip->dev, "Failed to read REG_FLAG Register\n");
-		goto out;
-	}
-
-	if (chip->last_flag)
-		dev_info(chip->dev, "Last FLAG is 0x%x\n", chip->last_flag);
-
-	/* brightness 0 means off-state */
-	if (!brightness)
-		opmode = MODES_STASNDBY;
-
-	switch (opmode) {
-	case MODES_TORCH:
-		ret = regmap_update_bits(chip->regmap, REG_I_CTRL,
-					 TORCH_I_MASK << TORCH_I_SHIFT,
-					 (brightness - 1) << TORCH_I_SHIFT);
-
-		if (pdata->torch_pin_en)
-			opmode |= (TORCH_PIN_EN_MASK << TORCH_PIN_EN_SHIFT);
-		break;
-
-	case MODES_FLASH:
-		ret = regmap_update_bits(chip->regmap, REG_I_CTRL,
-					 FLASH_I_MASK << FLASH_I_SHIFT,
-					 (brightness - 1) << FLASH_I_SHIFT);
-		break;
-
-	case MODES_INDIC:
-		ret = regmap_update_bits(chip->regmap, REG_I_CTRL,
-					 TORCH_I_MASK << TORCH_I_SHIFT,
-					 (brightness - 1) << TORCH_I_SHIFT);
-		break;
-
-	case MODES_STASNDBY:
-		if (pdata->torch_pin_en)
-			opmode |= (TORCH_PIN_EN_MASK << TORCH_PIN_EN_SHIFT);
-		break;
-
-	default:
-		return ret;
-	}
-	if (ret < 0) {
-		dev_err(chip->dev, "Failed to write REG_I_CTRL Register\n");
-		goto out;
-	}
-	ret = regmap_update_bits(chip->regmap, REG_ENABLE,
-				 MODE_BITS_MASK << MODE_BITS_SHIFT,
-				 opmode << MODE_BITS_SHIFT);
-
-out:
-	return ret;
-}
-
-/* torch */
-static void lm3556_torch_brightness_set(struct led_classdev *cdev,
-					enum led_brightness brightness)
-{
-	struct lm3556_chip_data *chip =
-	    container_of(cdev, struct lm3556_chip_data, cdev_torch);
-
-	mutex_lock(&chip->lock);
-	lm3556_control(chip, brightness, MODES_TORCH);
-	mutex_unlock(&chip->lock);
-}
-
-/* flash */
-static void lm3556_strobe_brightness_set(struct led_classdev *cdev,
-					 enum led_brightness brightness)
-{
-	struct lm3556_chip_data *chip =
-	    container_of(cdev, struct lm3556_chip_data, cdev_flash);
-
-	mutex_lock(&chip->lock);
-	lm3556_control(chip, brightness, MODES_FLASH);
-	mutex_unlock(&chip->lock);
-}
-
-/* indicator */
-static void lm3556_indicator_brightness_set(struct led_classdev *cdev,
-					    enum led_brightness brightness)
-{
-	struct lm3556_chip_data *chip =
-	    container_of(cdev, struct lm3556_chip_data, cdev_indicator);
-
-	mutex_lock(&chip->lock);
-	lm3556_control(chip, brightness, MODES_INDIC);
-	mutex_unlock(&chip->lock);
-}
-
-/* indicator pattern */
-static ssize_t lm3556_indicator_pattern_store(struct device *dev,
-					      struct device_attribute *devAttr,
-					      const char *buf, size_t size)
-{
-	ssize_t ret;
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct lm3556_chip_data *chip =
-	    container_of(led_cdev, struct lm3556_chip_data, cdev_indicator);
-	unsigned int state;
-
-	ret = kstrtouint(buf, 10, &state);
-	if (ret)
-		goto out;
-	if (state > INDIC_PATTERN_SIZE - 1)
-		state = INDIC_PATTERN_SIZE - 1;
-
-	ret = regmap_write(chip->regmap, REG_INDIC_BLINK,
-			   indicator_pattern[state].blinking);
-	if (ret < 0) {
-		dev_err(chip->dev, "Failed to write REG_ENABLE Regisgter\n");
-		goto out;
-	}
-
-	ret = regmap_write(chip->regmap, REG_INDIC_PERIOD,
-			   indicator_pattern[state].period_cnt);
-	if (ret < 0) {
-		dev_err(chip->dev, "Failed to write REG_ENABLE Regisgter\n");
-		goto out;
-	}
-
-	return size;
-out:
-	dev_err(chip->dev, "Indicator pattern doesn't saved\n");
-	return size;
-}
-
-static DEVICE_ATTR(pattern, 0666, NULL, lm3556_indicator_pattern_store);
-
-static const struct regmap_config lm3556_regmap = {
-	.reg_bits = 8,
-	.val_bits = 8,
-	.max_register = REG_MAX,
-};
-
-/* module initialize */
-static int __devinit lm3556_probe(struct i2c_client *client,
-				  const struct i2c_device_id *id)
-{
-	struct lm3556_platform_data *pdata = client->dev.platform_data;
-	struct lm3556_chip_data *chip;
-
-	int err;
-
-	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
-		dev_err(&client->dev, "i2c functionality check fail.\n");
-		return -EOPNOTSUPP;
-	}
-
-	if (pdata == NULL) {
-		dev_err(&client->dev, "Needs Platform Data.\n");
-		return -ENODATA;
-	}
-
-	chip =
-	    devm_kzalloc(&client->dev, sizeof(struct lm3556_chip_data),
-			 GFP_KERNEL);
-	if (!chip)
-		return -ENOMEM;
-
-	chip->dev = &client->dev;
-	chip->pdata = pdata;
-
-	chip->regmap = devm_regmap_init_i2c(client, &lm3556_regmap);
-	if (IS_ERR(chip->regmap)) {
-		err = PTR_ERR(chip->regmap);
-		dev_err(&client->dev, "Failed to allocate register map: %d\n",
-			err);
-		return err;
-	}
-
-	mutex_init(&chip->lock);
-	i2c_set_clientdata(client, chip);
-
-	err = lm3556_chip_init(chip);
-	if (err < 0)
-		goto err_out;
-
-	/* flash */
-	chip->cdev_flash.name = "flash";
-	chip->cdev_flash.max_brightness = 16;
-	chip->cdev_flash.brightness_set = lm3556_strobe_brightness_set;
-	err = led_classdev_register((struct device *)
-				    &client->dev, &chip->cdev_flash);
-	if (err < 0)
-		goto err_out;
-	/* torch */
-	chip->cdev_torch.name = "torch";
-	chip->cdev_torch.max_brightness = 8;
-	chip->cdev_torch.brightness_set = lm3556_torch_brightness_set;
-	err = led_classdev_register((struct device *)
-				    &client->dev, &chip->cdev_torch);
-	if (err < 0)
-		goto err_create_torch_file;
-	/* indicator */
-	chip->cdev_indicator.name = "indicator";
-	chip->cdev_indicator.max_brightness = 8;
-	chip->cdev_indicator.brightness_set = lm3556_indicator_brightness_set;
-	err = led_classdev_register((struct device *)
-				    &client->dev, &chip->cdev_indicator);
-	if (err < 0)
-		goto err_create_indicator_file;
-
-	err = device_create_file(chip->cdev_indicator.dev, &dev_attr_pattern);
-	if (err < 0)
-		goto err_create_pattern_file;
-
-	dev_info(&client->dev, "LM3556 is initialized\n");
-	return 0;
-
-err_create_pattern_file:
-	led_classdev_unregister(&chip->cdev_indicator);
-err_create_indicator_file:
-	led_classdev_unregister(&chip->cdev_torch);
-err_create_torch_file:
-	led_classdev_unregister(&chip->cdev_flash);
-err_out:
-	return err;
-}
-
-static int __devexit lm3556_remove(struct i2c_client *client)
-{
-	struct lm3556_chip_data *chip = i2c_get_clientdata(client);
-
-	device_remove_file(chip->cdev_indicator.dev, &dev_attr_pattern);
-	led_classdev_unregister(&chip->cdev_indicator);
-	led_classdev_unregister(&chip->cdev_torch);
-	led_classdev_unregister(&chip->cdev_flash);
-	regmap_write(chip->regmap, REG_ENABLE, 0);
-	return 0;
-}
-
-static const struct i2c_device_id lm3556_id[] = {
-	{LM3556_NAME, 0},
-	{}
-};
-
-MODULE_DEVICE_TABLE(i2c, lm3556_id);
-
-static struct i2c_driver lm3556_i2c_driver = {
-	.driver = {
-		   .name = LM3556_NAME,
-		   .owner = THIS_MODULE,
-		   .pm = NULL,
-		   },
-	.probe = lm3556_probe,
-	.remove = __devexit_p(lm3556_remove),
-	.id_table = lm3556_id,
-};
-
-module_i2c_driver(lm3556_i2c_driver);
-
-MODULE_DESCRIPTION("Texas Instruments Flash Lighting driver for LM3556");
-MODULE_AUTHOR("Daniel Jeong <daniel.jeong@ti.com>");
-MODULE_AUTHOR("G.Shark Jeong <gshark.jeong@gmail.com>");
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/leds/leds-lm355x.c b/drivers/leds/leds-lm355x.c
new file mode 100644
index 0000000..5cdbbb4
--- /dev/null
+++ b/drivers/leds/leds-lm355x.c
@@ -0,0 +1,529 @@
+/*
+* Simple driver for Texas Instruments LM355x LED Flash driver chip
+* Copyright (C) 2012 Texas Instruments
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*/
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <linux/leds.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/fs.h>
+#include <linux/regmap.h>
+#include <linux/platform_data/leds-lm355x.h>
+
+enum lm355x_type {
+	CHIP_LM3554 = 0,
+	CHIP_LM3556,
+};
+
+enum lm355x_regs {
+	REG_FLAG = 0,
+	REG_TORCH_CFG,
+	REG_TORCH_CTRL,
+	REG_STROBE_CFG,
+	REG_FLASH_CTRL,
+	REG_INDI_CFG,
+	REG_INDI_CTRL,
+	REG_OPMODE,
+	REG_MAX,
+};
+
+/* operation mode */
+enum lm355x_mode {
+	MODE_SHDN = 0,
+	MODE_INDIC,
+	MODE_TORCH,
+	MODE_FLASH
+};
+
+/* register map info. */
+struct lm355x_reg_data {
+	u8 regno;
+	u8 mask;
+	u8 shift;
+};
+
+struct lm355x_chip_data {
+	struct device *dev;
+	enum lm355x_type type;
+
+	struct led_classdev cdev_flash;
+	struct led_classdev cdev_torch;
+	struct led_classdev cdev_indicator;
+
+	struct lm355x_platform_data *pdata;
+	struct regmap *regmap;
+	struct mutex lock;
+
+	unsigned int last_flag;
+	struct lm355x_reg_data *regs;
+};
+
+/* specific indicator function for lm3556 */
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
+#define INDIC_PATTERN_SIZE 4
+
+struct indicator {
+	u8 blinking;
+	u8 period_cnt;
+};
+
+/* indicator pattern data only for lm3556 */
+static struct indicator indicator_pattern[INDIC_PATTERN_SIZE] = {
+	[0] = {(INDIC_N_BLANK_1 << 4) | PULSE_TIME_32_MS, INDIC_PERIOD_1},
+	[1] = {(INDIC_N_BLANK_15 << 4) | PULSE_TIME_32_MS, INDIC_PERIOD_2},
+	[2] = {(INDIC_N_BLANK_10 << 4) | PULSE_TIME_32_MS, INDIC_PERIOD_4},
+	[3] = {(INDIC_N_BLANK_5 << 4) | PULSE_TIME_32_MS, INDIC_PERIOD_7},
+};
+
+static struct lm355x_reg_data lm3554_regs[REG_MAX] = {
+	[REG_FLAG] = {0xD0, 0xBF, 0},
+	[REG_TORCH_CFG] = {0xE0, 0x80, 7},
+	[REG_TORCH_CTRL] = {0xA0, 0x38, 3},
+	[REG_STROBE_CFG] = {0xE0, 0x04, 2},
+	[REG_FLASH_CTRL] = {0xB0, 0x78, 3},
+	[REG_INDI_CFG] = {0xE0, 0x08, 3},
+	[REG_INDI_CTRL] = {0xA0, 0xC0, 6},
+	[REG_OPMODE] = {0xA0, 0x03, 0},
+};
+
+static struct lm355x_reg_data lm3556_regs[REG_MAX] = {
+	[REG_FLAG] = {0x0B, 0xFF, 0},
+	[REG_TORCH_CFG] = {0x0A, 0x10, 4},
+	[REG_TORCH_CTRL] = {0x09, 0x70, 4},
+	[REG_STROBE_CFG] = {0x0A, 0x20, 5},
+	[REG_FLASH_CTRL] = {0x09, 0x0F, 0},
+	[REG_INDI_CFG] = {0xFF, 0xFF, 0},
+	[REG_INDI_CTRL] = {0x09, 0x70, 4},
+	[REG_OPMODE] = {0x0A, 0x03, 0},
+};
+
+static char lm355x_name[][I2C_NAME_SIZE] = {
+	[CHIP_LM3554] = LM3554_NAME,
+	[CHIP_LM3556] = LM3556_NAME,
+};
+
+/* chip initialize */
+static int __devinit lm355x_chip_init(struct lm355x_chip_data *chip)
+{
+	int ret;
+	unsigned int reg_val;
+	struct lm355x_platform_data *pdata = chip->pdata;
+
+	/* input and output pins configuration */
+	switch (chip->type) {
+	case CHIP_LM3554:
+		reg_val = pdata->pin_tx2 | pdata->ntc_pin;
+		ret = regmap_update_bits(chip->regmap, 0xE0, 0x28, reg_val);
+		if (ret < 0)
+			goto out;
+		reg_val = pdata->pass_mode;
+		ret = regmap_update_bits(chip->regmap, 0xA0, 0x04, reg_val);
+		if (ret < 0)
+			goto out;
+		break;
+
+	case CHIP_LM3556:
+		reg_val = pdata->pin_tx2 | pdata->ntc_pin | pdata->pass_mode;
+		ret = regmap_update_bits(chip->regmap, 0x0A, 0xC4, reg_val);
+		if (ret < 0)
+			goto out;
+		break;
+	default:
+		return -ENODATA;
+	}
+
+	return ret;
+out:
+	dev_err(chip->dev, "%s:i2c access fail to register\n", __func__);
+	return ret;
+}
+
+/* chip control */
+static void lm355x_control(struct lm355x_chip_data *chip,
+			   u8 brightness, enum lm355x_mode opmode)
+{
+	int ret;
+	unsigned int reg_val;
+	struct lm355x_platform_data *pdata = chip->pdata;
+	struct lm355x_reg_data *preg = chip->regs;
+
+	ret = regmap_read(chip->regmap, preg[REG_FLAG].regno, &chip->last_flag);
+	if (ret < 0)
+		goto out;
+	if (chip->last_flag & preg[REG_FLAG].mask)
+		dev_info(chip->dev, "%s Last FLAG is 0x%x\n",
+			 lm355x_name[chip->type],
+			 chip->last_flag & preg[REG_FLAG].mask);
+	/* brightness 0 means shutdown */
+	if (!brightness)
+		opmode = MODE_SHDN;
+
+	switch (opmode) {
+	case MODE_TORCH:
+		ret =
+		    regmap_update_bits(chip->regmap, preg[REG_TORCH_CTRL].regno,
+				       preg[REG_TORCH_CTRL].mask,
+				       (brightness -
+					1) << preg[REG_TORCH_CTRL].shift);
+		if (ret < 0)
+			goto out;
+
+		if (pdata->pin_tx1 != LM355x_PIN_TORCH_DISABLE) {
+			ret =
+			    regmap_update_bits(chip->regmap,
+					       preg[REG_TORCH_CFG].regno,
+					       preg[REG_TORCH_CFG].mask,
+					       0x01 <<
+					       preg[REG_TORCH_CFG].shift);
+			if (ret < 0)
+				goto out;
+			opmode = MODE_SHDN;
+			dev_info(chip->dev,
+				 "torch brt is set - ext. torch pin mode\n");
+		}
+		break;
+
+	case MODE_FLASH:
+
+		ret =
+		    regmap_update_bits(chip->regmap, preg[REG_FLASH_CTRL].regno,
+				       preg[REG_FLASH_CTRL].mask,
+				       (brightness -
+					1) << preg[REG_FLASH_CTRL].shift);
+		if (ret < 0)
+			goto out;
+
+		if (pdata->pin_strobe != LM355x_PIN_STROBE_DISABLE) {
+			if (chip->type == CHIP_LM3554)
+				reg_val = 0x00;
+			else
+				reg_val = 0x01;
+			ret =
+			    regmap_update_bits(chip->regmap,
+					       preg[REG_STROBE_CFG].regno,
+					       preg[REG_STROBE_CFG].mask,
+					       reg_val <<
+					       preg[REG_STROBE_CFG].shift);
+			if (ret < 0)
+				goto out;
+			opmode = MODE_SHDN;
+			dev_info(chip->dev,
+				 "flash brt is set - ext. strobe pin mode\n");
+		}
+		break;
+
+	case MODE_INDIC:
+		ret =
+		    regmap_update_bits(chip->regmap, preg[REG_INDI_CTRL].regno,
+				       preg[REG_INDI_CTRL].mask,
+				       (brightness - 1)
+				       << preg[REG_INDI_CTRL].shift);
+		if (ret < 0)
+			goto out;
+
+		if (pdata->pin_tx2 != LM355x_PIN_TX_DISABLE) {
+			ret =
+			    regmap_update_bits(chip->regmap,
+					       preg[REG_INDI_CFG].regno,
+					       preg[REG_INDI_CFG].mask,
+					       0x01 <<
+					       preg[REG_INDI_CFG].shift);
+			if (ret < 0)
+				goto out;
+			opmode = MODE_SHDN;
+		}
+		break;
+	case MODE_SHDN:
+		break;
+	default:
+		return;
+	}
+	/* operation mode control */
+	ret = regmap_update_bits(chip->regmap, preg[REG_OPMODE].regno,
+				 preg[REG_OPMODE].mask,
+				 opmode << preg[REG_OPMODE].shift);
+	if (ret < 0)
+		goto out;
+	return;
+out:
+	dev_err(chip->dev, "%s:i2c access fail to register\n", __func__);
+	return;
+}
+
+/* torch */
+static void lm355x_torch_brightness_set(struct led_classdev *cdev,
+					enum led_brightness brightness)
+{
+	struct lm355x_chip_data *chip =
+	    container_of(cdev, struct lm355x_chip_data, cdev_torch);
+
+	mutex_lock(&chip->lock);
+	lm355x_control(chip, brightness, MODE_TORCH);
+	mutex_unlock(&chip->lock);
+}
+
+/* flash */
+static void lm355x_strobe_brightness_set(struct led_classdev *cdev,
+					 enum led_brightness brightness)
+{
+	struct lm355x_chip_data *chip =
+	    container_of(cdev, struct lm355x_chip_data, cdev_flash);
+
+	mutex_lock(&chip->lock);
+	lm355x_control(chip, brightness, MODE_FLASH);
+	mutex_unlock(&chip->lock);
+}
+
+/* indicator */
+static void lm355x_indicator_brightness_set(struct led_classdev *cdev,
+					    enum led_brightness brightness)
+{
+	struct lm355x_chip_data *chip =
+	    container_of(cdev, struct lm355x_chip_data, cdev_indicator);
+
+	mutex_lock(&chip->lock);
+	lm355x_control(chip, brightness, MODE_INDIC);
+	mutex_unlock(&chip->lock);
+}
+
+/* indicator pattern only for lm3556*/
+static ssize_t lm3556_indicator_pattern_store(struct device *dev,
+					      struct device_attribute *devAttr,
+					      const char *buf, size_t size)
+{
+	ssize_t ret;
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lm355x_chip_data *chip =
+	    container_of(led_cdev, struct lm355x_chip_data, cdev_indicator);
+	unsigned int state;
+
+	ret = kstrtouint(buf, 10, &state);
+	if (ret)
+		goto out;
+	if (state > INDIC_PATTERN_SIZE - 1)
+		state = INDIC_PATTERN_SIZE - 1;
+
+	ret = regmap_write(chip->regmap, 0x04,
+			   indicator_pattern[state].blinking);
+	if (ret < 0)
+		goto out;
+
+	ret = regmap_write(chip->regmap, 0x05,
+			   indicator_pattern[state].period_cnt);
+	if (ret < 0)
+		goto out;
+
+	return size;
+out:
+	dev_err(chip->dev, "%s:i2c access fail to register\n", __func__);
+	return size;
+}
+
+static DEVICE_ATTR(pattern, 0666, NULL, lm3556_indicator_pattern_store);
+
+static const struct regmap_config lm355x_regmap = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = 0xFF,
+};
+
+/* module initialize */
+static int __devinit lm355x_probe(struct i2c_client *client,
+				  const struct i2c_device_id *id)
+{
+	struct lm355x_platform_data *pdata = client->dev.platform_data;
+	struct lm355x_chip_data *chip;
+
+	int err;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		dev_err(&client->dev, "i2c functionality check fail.\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (pdata == NULL) {
+		dev_err(&client->dev, "needs Platform Data.\n");
+		return -ENODATA;
+	}
+
+	chip = devm_kzalloc(&client->dev,
+			    sizeof(struct lm355x_chip_data), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	chip->dev = &client->dev;
+	chip->type = id->driver_data;
+	switch (id->driver_data) {
+	case CHIP_LM3554:
+		chip->regs = lm3554_regs;
+		break;
+	case CHIP_LM3556:
+		chip->regs = lm3556_regs;
+		break;
+	default:
+		return -ENOSYS;
+	}
+	chip->pdata = pdata;
+	chip->regmap = devm_regmap_init_i2c(client, &lm355x_regmap);
+	if (IS_ERR(chip->regmap)) {
+		err = PTR_ERR(chip->regmap);
+		dev_err(&client->dev, "Failed to allocate register map: %d\n",
+			err);
+		return err;
+	}
+
+	mutex_init(&chip->lock);
+	i2c_set_clientdata(client, chip);
+
+	err = lm355x_chip_init(chip);
+	if (err < 0)
+		goto err_out;
+
+	/* flash */
+	chip->cdev_flash.name = "flash";
+	chip->cdev_flash.max_brightness = 16;
+	chip->cdev_flash.brightness_set = lm355x_strobe_brightness_set;
+	err = led_classdev_register((struct device *)
+				    &client->dev, &chip->cdev_flash);
+	if (err < 0)
+		goto err_out;
+	/* torch */
+	chip->cdev_torch.name = "torch";
+	chip->cdev_torch.max_brightness = 8;
+	chip->cdev_torch.brightness_set = lm355x_torch_brightness_set;
+	err = led_classdev_register((struct device *)
+				    &client->dev, &chip->cdev_torch);
+	if (err < 0)
+		goto err_create_torch_file;
+	/* indicator */
+	chip->cdev_indicator.name = "indicator";
+	if (id->driver_data == CHIP_LM3554)
+		chip->cdev_indicator.max_brightness = 4;
+	else
+		chip->cdev_indicator.max_brightness = 8;
+	chip->cdev_indicator.brightness_set = lm355x_indicator_brightness_set;
+	err = led_classdev_register((struct device *)
+				    &client->dev, &chip->cdev_indicator);
+	if (err < 0)
+		goto err_create_indicator_file;
+	/* indicator pattern control only for LM3554 */
+	if (id->driver_data == CHIP_LM3556) {
+		err =
+		    device_create_file(chip->cdev_indicator.dev,
+				       &dev_attr_pattern);
+		if (err < 0)
+			goto err_create_pattern_file;
+	}
+
+	dev_info(&client->dev, "%s is initialized\n",
+		 lm355x_name[id->driver_data]);
+	return 0;
+
+err_create_pattern_file:
+	led_classdev_unregister(&chip->cdev_indicator);
+err_create_indicator_file:
+	led_classdev_unregister(&chip->cdev_torch);
+err_create_torch_file:
+	led_classdev_unregister(&chip->cdev_flash);
+err_out:
+	return err;
+}
+
+static int __devexit lm355x_remove(struct i2c_client *client)
+{
+	struct lm355x_chip_data *chip = i2c_get_clientdata(client);
+	struct lm355x_reg_data *preg = chip->regs;
+
+	regmap_write(chip->regmap, preg[REG_OPMODE].regno, 0);
+	if (chip->type == CHIP_LM3556)
+		device_remove_file(chip->cdev_indicator.dev, &dev_attr_pattern);
+	led_classdev_unregister(&chip->cdev_indicator);
+	led_classdev_unregister(&chip->cdev_torch);
+	led_classdev_unregister(&chip->cdev_flash);
+
+	dev_info(&client->dev, "%s is removed\n", lm355x_name[chip->type]);
+
+	return 0;
+}
+
+static const struct i2c_device_id lm355x_id[] = {
+	{LM3554_NAME, CHIP_LM3554},
+	{LM3556_NAME, CHIP_LM3556},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, lm355x_id);
+
+static struct i2c_driver lm355x_i2c_driver = {
+	.driver = {
+		   .name = LM355x_NAME,
+		   .owner = THIS_MODULE,
+		   .pm = NULL,
+		   },
+	.probe = lm355x_probe,
+	.remove = __devexit_p(lm355x_remove),
+	.id_table = lm355x_id,
+};
+
+module_i2c_driver(lm355x_i2c_driver);
+
+MODULE_DESCRIPTION("Texas Instruments Flash Lighting driver for LM355x");
+MODULE_AUTHOR("Daniel Jeong <daniel.jeong@ti.com>");
+MODULE_AUTHOR("G.Shark Jeong <gshark.jeong@gmail.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/platform_data/leds-lm3556.h b/include/linux/platform_data/leds-lm3556.h
deleted file mode 100644
index 4b4e7d6..0000000
--- a/include/linux/platform_data/leds-lm3556.h
+++ /dev/null
@@ -1,50 +0,0 @@
-/*
- * Simple driver for Texas Instruments LM3556 LED Flash driver chip (Rev0x03)
- * Copyright (C) 2012 Texas Instruments
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-#ifndef __LINUX_LM3556_H
-#define __LINUX_LM3556_H
-
-#define LM3556_NAME "leds-lm3556"
-
-enum lm3556_pin_polarity {
-	PIN_LOW_ACTIVE = 0,
-	PIN_HIGH_ACTIVE,
-};
-
-enum lm3556_pin_enable {
-	PIN_DISABLED = 0,
-	PIN_ENABLED,
-};
-
-enum lm3556_strobe_usuage {
-	STROBE_EDGE_DETECT = 0,
-	STROBE_LEVEL_DETECT,
-};
-
-enum lm3556_indic_mode {
-	INDIC_MODE_INTERNAL = 0,
-	INDIC_MODE_EXTERNAL,
-};
-
-struct lm3556_platform_data {
-	enum lm3556_pin_enable torch_pin_en;
-	enum lm3556_pin_polarity torch_pin_polarity;
-
-	enum lm3556_strobe_usuage strobe_usuage;
-	enum lm3556_pin_enable strobe_pin_en;
-	enum lm3556_pin_polarity strobe_pin_polarity;
-
-	enum lm3556_pin_enable tx_pin_en;
-	enum lm3556_pin_polarity tx_pin_polarity;
-
-	enum lm3556_indic_mode indicator_mode;
-};
-
-#endif /* __LINUX_LM3556_H */
diff --git a/include/linux/platform_data/leds-lm355x.h b/include/linux/platform_data/leds-lm355x.h
new file mode 100644
index 0000000..b88724b
--- /dev/null
+++ b/include/linux/platform_data/leds-lm355x.h
@@ -0,0 +1,66 @@
+/*
+ * Copyright (C) 2012 Texas Instruments
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * Simple driver for Texas Instruments LM355x LED driver chip
+ *
+ * Author: G.Shark Jeong <gshark.jeong@gmail.com>
+ *         Daniel Jeong <daniel.jeong@ti.com>
+ */
+
+#define LM355x_NAME "leds-lm355x"
+#define LM3554_NAME "leds-lm3554"
+#define LM3556_NAME "leds-lm3556"
+
+/* lm3554 : strobe def. on */
+enum lm355x_strobe {
+	LM355x_PIN_STROBE_DISABLE = 0x00,
+	LM355x_PIN_STROBE_ENABLE = 0x01,
+};
+
+enum lm355x_torch {
+	LM355x_PIN_TORCH_DISABLE = 0,
+	LM3554_PIN_TORCH_ENABLE = 0x80,
+	LM3556_PIN_TORCH_ENABLE = 0x10,
+};
+
+enum lm355x_tx2 {
+	LM355x_PIN_TX_DISABLE = 0,
+	LM3554_PIN_TX_ENABLE = 0x20,
+	LM3556_PIN_TX_ENABLE = 0x40,
+};
+
+enum lm355x_ntc {
+	LM355x_PIN_NTC_DISABLE = 0,
+	LM3554_PIN_NTC_ENABLE = 0x08,
+	LM3556_PIN_NTC_ENABLE = 0x80,
+};
+
+enum lm355x_pmode {
+	LM355x_PMODE_DISABLE = 0,
+	LM355x_PMODE_ENABLE = 0x04,
+};
+
+/*
+ * struct lm3554_platform_data
+ * @pin_strobe: strobe input
+ * @pin_torch : input pin
+ *              lm3554-tx1/torch/gpio1
+ *              lm3556-torch
+ * @pin_tx2   : input pin
+ *              lm3554-envm/tx2/gpio2
+ *              lm3556-tx pin
+ * @ntc_pin  : output pin
+ *              lm3554-ledi/ntc
+ *              lm3556-temp pin
+ * @pass_mode : pass mode
+ */
+struct lm355x_platform_data {
+	enum lm355x_strobe pin_strobe;
+	enum lm355x_torch pin_tx1;
+	enum lm355x_tx2 pin_tx2;
+	enum lm355x_ntc ntc_pin;
+
+	enum lm355x_pmode pass_mode;
+};
-- 
1.7.5.4


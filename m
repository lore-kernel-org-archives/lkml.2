Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab2A0PKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 10:10:39 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50484 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab2A0PKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 10:10:35 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Lars-Peter Clausen <lars@metafoo.de>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 3/3] ASoC: codecs: add driver for max9768 amplifier
Date: Fri, 27 Jan 2012 16:10:23 +0100
Message-Id: <1327677023-29310-3-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1327677023-29310-1-git-send-email-w.sang@pengutronix.de>
References: <1327677023-29310-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver supporting the volume control and the mute pin. Shdn pin
and DAPM are not taken care of yet.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---

Mark: Still no DAPM support. We don't have PM on this board, and since I
couldn't easily figure what is expected from me here, I'd like to leave this
for people who have real interest in that.

 include/sound/max9768.h    |   24 ++++
 sound/soc/codecs/Kconfig   |    4 +
 sound/soc/codecs/Makefile  |    2 +
 sound/soc/codecs/max9768.c |  253 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 283 insertions(+), 0 deletions(-)
 create mode 100644 include/sound/max9768.h
 create mode 100644 sound/soc/codecs/max9768.c

diff --git a/include/sound/max9768.h b/include/sound/max9768.h
new file mode 100644
index 0000000..0f78b41
--- /dev/null
+++ b/include/sound/max9768.h
@@ -0,0 +1,24 @@
+/*
+ * Platform data for MAX9768
+ * Copyright (C) 2011, 2012 by Wolfram Sang, Pengutronix e.K.
+ * same licence as the driver
+ */
+
+#ifndef __SOUND_MAX9768_PDATA_H__
+#define __SOUND_MAX9768_PDATA_H__
+
+/**
+ * struct max9768_pdata - optional platform specific MAX9768 configuration
+ * @shdn_gpio:	GPIO to SHDN pin. If not valid, pin must be hardwired HIGH
+ * @mute_gpio:	GPIO to MUTE pin. If not valid, control for mute won't be added
+ * @flags: configuration flags, e.g. set classic PWM mode (check datasheet
+ *         regarding "filterless modulation" which is default).
+ */
+struct max9768_pdata {
+	int shdn_gpio;
+	int mute_gpio;
+	unsigned flags;
+#define MAX9768_FLAG_CLASSIC_PWM	(1 << 0)
+};
+
+#endif /* __SOUND_MAX9768_PDATA_H__*/
diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 7c205e7..2587c3b 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -40,6 +40,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_MAX98088 if I2C
 	select SND_SOC_MAX98095 if I2C
 	select SND_SOC_MAX9850 if I2C
+	select SND_SOC_MAX9768 if I2C
 	select SND_SOC_MAX9877 if I2C
 	select SND_SOC_PCM3008
 	select SND_SOC_RT5631 if I2C
@@ -425,6 +426,9 @@ config SND_SOC_WM9713
 config SND_SOC_LM4857
 	tristate
 
+config SND_SOC_MAX9768
+	tristate
+
 config SND_SOC_MAX9877
 	tristate
 
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index de80781..cf3555b 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -25,6 +25,7 @@ snd-soc-dmic-objs := dmic.o
 snd-soc-jz4740-codec-objs := jz4740.o
 snd-soc-l3-objs := l3.o
 snd-soc-lm4857-objs := lm4857.o
+snd-soc-max9768-objs := max9768.o
 snd-soc-max98088-objs := max98088.o
 snd-soc-max98095-objs := max98095.o
 snd-soc-max9850-objs := max9850.o
@@ -129,6 +130,7 @@ obj-$(CONFIG_SND_SOC_DMIC)	+= snd-soc-dmic.o
 obj-$(CONFIG_SND_SOC_L3)	+= snd-soc-l3.o
 obj-$(CONFIG_SND_SOC_LM4857)	+= snd-soc-lm4857.o
 obj-$(CONFIG_SND_SOC_JZ4740_CODEC)	+= snd-soc-jz4740-codec.o
+obj-$(CONFIG_SND_SOC_MAX9768)	+= snd-soc-max9768.o
 obj-$(CONFIG_SND_SOC_MAX98088)	+= snd-soc-max98088.o
 obj-$(CONFIG_SND_SOC_MAX98095)	+= snd-soc-max98095.o
 obj-$(CONFIG_SND_SOC_MAX9850)	+= snd-soc-max9850.o
diff --git a/sound/soc/codecs/max9768.c b/sound/soc/codecs/max9768.c
new file mode 100644
index 0000000..6348995
--- /dev/null
+++ b/sound/soc/codecs/max9768.c
@@ -0,0 +1,253 @@
+/*
+ * MAX9768 AMP driver
+ *
+ * Copyright (C) 2011, 2012 by Wolfram Sang, Pengutronix e.K.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; version 2 of the License.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/regmap.h>
+
+#include <sound/core.h>
+#include <sound/soc.h>
+#include <sound/tlv.h>
+#include <sound/max9768.h>
+
+/* "Registers" */
+#define MAX9768_VOL 0
+#define MAX9768_CTRL 3
+
+/* Commands */
+#define MAX9768_CTRL_PWM 0x15
+#define MAX9768_CTRL_FILTERLESS 0x16
+
+struct max9768 {
+	struct regmap *regmap;
+	int mute_gpio;
+	int shdn_gpio;
+	u32 flags;
+};
+
+static struct reg_default max9768_default_regs[] = {
+	{ 0, 0 },
+	{ 3,  MAX9768_CTRL_FILTERLESS},
+};
+
+static int max9768_get_gpio(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct max9768 *max9768 = snd_soc_codec_get_drvdata(codec);
+	int val = gpio_get_value_cansleep(max9768->mute_gpio);
+
+	ucontrol->value.integer.value[0] = !val;
+
+	return 0;
+}
+
+static int max9768_set_gpio(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct max9768 *max9768 = snd_soc_codec_get_drvdata(codec);
+
+	gpio_set_value_cansleep(max9768->mute_gpio, !ucontrol->value.integer.value[0]);
+
+	return 0;
+}
+
+static const unsigned int volume_tlv[] = {
+	TLV_DB_RANGE_HEAD(43),
+	0, 0, TLV_DB_SCALE_ITEM(-16150, 0, 0),
+	1, 1, TLV_DB_SCALE_ITEM(-9280, 0, 0),
+	2, 2, TLV_DB_SCALE_ITEM(-9030, 0, 0),
+	3, 3, TLV_DB_SCALE_ITEM(-8680, 0, 0),
+	4, 4, TLV_DB_SCALE_ITEM(-8430, 0, 0),
+	5, 5, TLV_DB_SCALE_ITEM(-8080, 0, 0),
+	6, 6, TLV_DB_SCALE_ITEM(-7830, 0, 0),
+	7, 7, TLV_DB_SCALE_ITEM(-7470, 0, 0),
+	8, 8, TLV_DB_SCALE_ITEM(-7220, 0, 0),
+	9, 9, TLV_DB_SCALE_ITEM(-6870, 0, 0),
+	10, 10, TLV_DB_SCALE_ITEM(-6620, 0, 0),
+	11, 11, TLV_DB_SCALE_ITEM(-6270, 0, 0),
+	12, 12, TLV_DB_SCALE_ITEM(-6020, 0, 0),
+	13, 13, TLV_DB_SCALE_ITEM(-5670, 0, 0),
+	14, 14, TLV_DB_SCALE_ITEM(-5420, 0, 0),
+	15, 17, TLV_DB_SCALE_ITEM(-5060, 250, 0),
+	18, 18, TLV_DB_SCALE_ITEM(-4370, 0, 0),
+	19, 19, TLV_DB_SCALE_ITEM(-4210, 0, 0),
+	20, 20, TLV_DB_SCALE_ITEM(-3960, 0, 0),
+	21, 21, TLV_DB_SCALE_ITEM(-3760, 0, 0),
+	22, 22, TLV_DB_SCALE_ITEM(-3600, 0, 0),
+	23, 23, TLV_DB_SCALE_ITEM(-3340, 0, 0),
+	24, 24, TLV_DB_SCALE_ITEM(-3150, 0, 0),
+	25, 25, TLV_DB_SCALE_ITEM(-2980, 0, 0),
+	26, 26, TLV_DB_SCALE_ITEM(-2720, 0, 0),
+	27, 27, TLV_DB_SCALE_ITEM(-2520, 0, 0),
+	28, 30, TLV_DB_SCALE_ITEM(-2350, 190, 0),
+	31, 31, TLV_DB_SCALE_ITEM(-1750, 0, 0),
+	32, 34, TLV_DB_SCALE_ITEM(-1640, 100, 0),
+	35, 37, TLV_DB_SCALE_ITEM(-1310, 110, 0),
+	38, 39, TLV_DB_SCALE_ITEM(-990, 100, 0),
+	40, 40, TLV_DB_SCALE_ITEM(-710, 0, 0),
+	41, 41, TLV_DB_SCALE_ITEM(-600, 0, 0),
+	42, 42, TLV_DB_SCALE_ITEM(-500, 0, 0),
+	43, 43, TLV_DB_SCALE_ITEM(-340, 0, 0),
+	44, 44, TLV_DB_SCALE_ITEM(-190, 0, 0),
+	45, 45, TLV_DB_SCALE_ITEM(-50, 0, 0),
+	46, 46, TLV_DB_SCALE_ITEM(50, 0, 0),
+	47, 50, TLV_DB_SCALE_ITEM(120, 40, 0),
+	51, 57, TLV_DB_SCALE_ITEM(290, 50, 0),
+	58, 58, TLV_DB_SCALE_ITEM(650, 0, 0),
+	59, 62, TLV_DB_SCALE_ITEM(700, 60, 0),
+	63, 63, TLV_DB_SCALE_ITEM(950, 0, 0),
+};
+
+static const struct snd_kcontrol_new max9768_volume[] = {
+	SOC_SINGLE_TLV("Playback Volume", MAX9768_VOL, 0, 63, 0, volume_tlv),
+};
+
+static const struct snd_kcontrol_new max9768_mute[] = {
+	SOC_SINGLE_BOOL_EXT("Mute Switch", 0, max9768_get_gpio, max9768_set_gpio),
+};
+
+static int max9768_probe(struct snd_soc_codec *codec)
+{
+	struct max9768 *max9768 = snd_soc_codec_get_drvdata(codec);
+	int ret;
+
+	codec->control_data = max9768->regmap;
+	ret = snd_soc_codec_set_cache_io(codec, 2, 6, SND_SOC_REGMAP);
+	if (ret)
+		return ret;
+
+	if (max9768->flags & MAX9768_FLAG_CLASSIC_PWM) {
+		ret = snd_soc_write(codec, MAX9768_CTRL, MAX9768_CTRL_PWM);
+		if (ret)
+			return ret;
+	}
+
+	if (gpio_is_valid(max9768->mute_gpio)) {
+		ret = snd_soc_add_controls(codec, max9768_mute,
+				ARRAY_SIZE(max9768_mute));
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static struct snd_soc_codec_driver max9768_codec_driver = {
+	.probe = max9768_probe,
+	.controls = max9768_volume,
+	.num_controls = ARRAY_SIZE(max9768_volume),
+};
+
+static bool max9768_always_false(struct device *dev, unsigned int reg)
+{
+	return false;
+}
+
+static const struct regmap_config max9768_i2c_regmap_config = {
+	.reg_bits = 2,
+	.val_bits = 6,
+	.max_register = 3,
+	.reg_defaults = max9768_default_regs,
+	.num_reg_defaults = ARRAY_SIZE(max9768_default_regs),
+	.volatile_reg = max9768_always_false,
+	.cache_type = REGCACHE_RBTREE,
+};
+
+static int __devinit max9768_i2c_probe(struct i2c_client *client,
+	const struct i2c_device_id *id)
+{
+	struct max9768 *max9768;
+	struct max9768_pdata *pdata = client->dev.platform_data;
+	int err;
+
+	max9768 = devm_kzalloc(&client->dev, sizeof(*max9768), GFP_KERNEL);
+	if (!max9768)
+		return -ENOMEM;
+
+	if (pdata) {
+		/* Mute on powerup to avoid clicks */
+		err = gpio_request_one(pdata->mute_gpio, GPIOF_INIT_HIGH, "MAX9768 Mute");
+		max9768->mute_gpio = err ?: pdata->mute_gpio;
+
+		/* Activate chip by releasing shutdown, enables I2C */
+		err = gpio_request_one(pdata->shdn_gpio, GPIOF_INIT_HIGH, "MAX9768 Shutdown");
+		max9768->shdn_gpio = err ?: pdata->shdn_gpio;
+
+		max9768->flags = pdata->flags;
+	} else {
+		max9768->shdn_gpio = -EINVAL;
+		max9768->mute_gpio = -EINVAL;
+	}
+
+	i2c_set_clientdata(client, max9768);
+
+	max9768->regmap = regmap_init_i2c(client, &max9768_i2c_regmap_config);
+	if (IS_ERR(max9768->regmap)) {
+		err = PTR_ERR(max9768->regmap);
+		goto err_gpio_free;
+	}
+
+	err = snd_soc_register_codec(&client->dev, &max9768_codec_driver, NULL, 0);
+	if (err)
+		goto err_regmap_free;
+
+	return 0;
+
+ err_regmap_free:
+	regmap_exit(max9768->regmap);
+ err_gpio_free:
+	if (gpio_is_valid(max9768->shdn_gpio))
+		gpio_free(max9768->shdn_gpio);
+	if (gpio_is_valid(max9768->mute_gpio))
+		gpio_free(max9768->mute_gpio);
+
+	return err;
+}
+
+static int __devexit max9768_i2c_remove(struct i2c_client *client)
+{
+	struct max9768 *max9768 = i2c_get_clientdata(client);
+
+	snd_soc_unregister_codec(&client->dev);
+	regmap_exit(max9768->regmap);
+
+	if (gpio_is_valid(max9768->shdn_gpio))
+		gpio_free(max9768->shdn_gpio);
+	if (gpio_is_valid(max9768->mute_gpio))
+		gpio_free(max9768->mute_gpio);
+
+	return 0;
+}
+
+static const struct i2c_device_id max9768_i2c_id[] = {
+	{ "max9768", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, max9768_i2c_id);
+
+static struct i2c_driver max9768_i2c_driver = {
+	.driver = {
+		.name = "max9768",
+		.owner = THIS_MODULE,
+	},
+	.probe = max9768_i2c_probe,
+	.remove = __devexit_p(max9768_i2c_remove),
+	.id_table = max9768_i2c_id,
+};
+module_i2c_driver(max9768_i2c_driver);
+
+MODULE_AUTHOR("Wolfram Sang <w.sang@pengutronix.de>");
+MODULE_DESCRIPTION("ASoC MAX9768 amplifier driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.8.3


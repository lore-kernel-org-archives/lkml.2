Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab1CGHEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 02:04:12 -0500
Received: from smtp-out-189.synserver.de ([212.40.185.189]:1039 "HELO
	smtp-out-189.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752255Ab1CGHD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 02:03:59 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 8276
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Jassi Brar <jassi.brar@samsung.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/7] ASoC: neo1973_wm8753: Move lm4857 specefic code to its own module
Date: Mon,  7 Mar 2011 08:04:55 +0100
Message-Id: <1299481500-5481-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299481500-5481-1-git-send-email-lars@metafoo.de>
References: <1299481500-5481-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the code for the lm4857 AMP from the neo1973_wm8753 sound
board driver to its own module.
The lm4857 is a generic AMP IC and not specific to the neo1973.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/codecs/Kconfig           |    3 +
 sound/soc/codecs/Makefile          |    2 +
 sound/soc/codecs/lm4857.c          |  276 ++++++++++++++++++++++++++++++++++++
 sound/soc/samsung/Kconfig          |    1 +
 sound/soc/samsung/lm4857.h         |   32 ----
 sound/soc/samsung/neo1973_wm8753.c |  269 +++++++++--------------------------
 6 files changed, 347 insertions(+), 236 deletions(-)
 create mode 100644 sound/soc/codecs/lm4857.c
 delete mode 100644 sound/soc/samsung/lm4857.h

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 82a4630..37035e6 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -347,6 +347,9 @@ config SND_SOC_WM9713
 	tristate
 
 # Amp
+config SND_SOC_LM4857
+	tristate
+
 config SND_SOC_MAX9877
 	tristate
 
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index b43f9d4..0663d22 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -77,6 +77,7 @@ snd-soc-wm-hubs-objs := wm_hubs.o
 snd-soc-jz4740-codec-objs := jz4740.o
 
 # Amp
+snd-soc-lm4857-objs := lm4857.o
 snd-soc-max9877-objs := max9877.o
 snd-soc-tpa6130a2-objs := tpa6130a2.o
 snd-soc-wm2000-objs := wm2000.o
@@ -161,6 +162,7 @@ obj-$(CONFIG_SND_SOC_WM9713)	+= snd-soc-wm9713.o
 obj-$(CONFIG_SND_SOC_WM_HUBS)	+= snd-soc-wm-hubs.o
 
 # Amp
+obj-$(CONFIG_SND_SOC_LM4857)	+= snd-soc-lm4857.o
 obj-$(CONFIG_SND_SOC_MAX9877)	+= snd-soc-max9877.o
 obj-$(CONFIG_SND_SOC_TPA6130A2)	+= snd-soc-tpa6130a2.o
 obj-$(CONFIG_SND_SOC_WM2000)	+= snd-soc-wm2000.o
diff --git a/sound/soc/codecs/lm4857.c b/sound/soc/codecs/lm4857.c
new file mode 100644
index 0000000..72de47e
--- /dev/null
+++ b/sound/soc/codecs/lm4857.c
@@ -0,0 +1,276 @@
+/*
+ * LM4857 AMP driver
+ *
+ * Copyright 2007 Wolfson Microelectronics PLC.
+ * Author: Graeme Gregory
+ *         graeme.gregory@wolfsonmicro.com or linux@wolfsonmicro.com
+ * Copyright 2011 Lars-Peter Clausen <lars@metafoo.de>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+
+#include <sound/core.h>
+#include <sound/soc.h>
+#include <sound/tlv.h>
+
+struct lm4857 {
+	struct i2c_client *i2c;
+	uint8_t mode;
+};
+
+static const uint8_t lm4857_default_regs[] = {
+	0x00, 0x00, 0x00, 0x00,
+};
+
+/* The register offsets in the cache array */
+#define LM4857_MVOL 0
+#define LM4857_LVOL 1
+#define LM4857_RVOL 2
+#define LM4857_CTRL 3
+
+/* the shifts required to set these bits */
+#define LM4857_3D 5
+#define LM4857_WAKEUP 5
+#define LM4857_EPGAIN 4
+
+static int lm4857_write(struct snd_soc_codec *codec, unsigned int reg,
+		unsigned int value)
+{
+	uint8_t data;
+	int ret;
+
+	ret = snd_soc_cache_write(codec, reg, value);
+	if (ret < 0)
+		return ret;
+
+	data = (reg << 6) | value;
+	ret = i2c_master_send(codec->control_data, &data, 1);
+	if (ret != 1) {
+		dev_err(codec->dev, "Failed to write register: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static unsigned int lm4857_read(struct snd_soc_codec *codec,
+		unsigned int reg)
+{
+	unsigned int val;
+	int ret;
+
+	ret = snd_soc_cache_read(codec, reg, &val);
+	if (ret)
+		return -1;
+
+	return val;
+}
+
+static int lm4857_get_mode(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct lm4857 *lm4857 = snd_soc_codec_get_drvdata(codec);
+
+	ucontrol->value.integer.value[0] = lm4857->mode;
+
+	return 0;
+}
+
+static int lm4857_set_mode(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct lm4857 *lm4857 = snd_soc_codec_get_drvdata(codec);
+	uint8_t value = ucontrol->value.integer.value[0];
+
+	lm4857->mode = value;
+
+	if (codec->dapm.bias_level == SND_SOC_BIAS_ON)
+		snd_soc_update_bits(codec, LM4857_CTRL, 0x0F, value + 6);
+
+	return 1;
+}
+
+static int lm4857_set_bias_level(struct snd_soc_codec *codec,
+				 enum snd_soc_bias_level level)
+{
+	struct lm4857 *lm4857 = snd_soc_codec_get_drvdata(codec);
+
+	switch (level) {
+	case SND_SOC_BIAS_ON:
+		snd_soc_update_bits(codec, LM4857_CTRL, 0x0F, lm4857->mode + 6);
+		break;
+	case SND_SOC_BIAS_STANDBY:
+		snd_soc_update_bits(codec, LM4857_CTRL, 0x0F, 0);
+		break;
+	default:
+		break;
+	}
+
+	codec->dapm.bias_level = level;
+
+	return 0;
+}
+
+static const char *lm4857_mode[] = {
+	"Earpiece",
+	"Loudspeaker",
+	"Loudspeaker + Headphone",
+	"Headphone",
+};
+
+static const struct soc_enum lm4857_mode_enum =
+	SOC_ENUM_SINGLE_EXT(ARRAY_SIZE(lm4857_mode), lm4857_mode);
+
+static const struct snd_soc_dapm_widget lm4857_dapm_widgets[] = {
+	SND_SOC_DAPM_INPUT("IN"),
+
+	SND_SOC_DAPM_OUTPUT("LS"),
+	SND_SOC_DAPM_OUTPUT("HP"),
+	SND_SOC_DAPM_OUTPUT("EP"),
+};
+
+static const DECLARE_TLV_DB_SCALE(stereo_tlv, -4050, 150, 0);
+static const DECLARE_TLV_DB_SCALE(mono_tlv, -3450, 150, 0);
+
+static const struct snd_kcontrol_new lm4857_controls[] = {
+	SOC_SINGLE_TLV("Left Playback Volume", LM4857_LVOL, 0, 31, 0,
+		stereo_tlv),
+	SOC_SINGLE_TLV("Right Playback Volume", LM4857_RVOL, 0, 31, 0,
+		stereo_tlv),
+	SOC_SINGLE_TLV("Mono Playback Volume", LM4857_MVOL, 0, 31, 0,
+		mono_tlv),
+	SOC_SINGLE("Spk 3D Playback Switch", LM4857_LVOL, LM4857_3D, 1, 0),
+	SOC_SINGLE("HP 3D Playback Switch", LM4857_RVOL, LM4857_3D, 1, 0),
+	SOC_SINGLE("Fast Wakeup Playback Switch", LM4857_CTRL,
+		LM4857_WAKEUP, 1, 0),
+	SOC_SINGLE("Earpiece 6dB Playback Switch", LM4857_CTRL,
+		LM4857_EPGAIN, 1, 0),
+
+	SOC_ENUM_EXT("Mode", lm4857_mode_enum,
+		lm4857_get_mode, lm4857_set_mode),
+};
+
+/* There is a demux inbetween the the input signal and the output signals.
+ * Currently there is no easy way to model it in ASoC and since it does not make
+ * much of a difference in practice simply connect the input direclty to the
+ * outputs. */
+static const struct snd_soc_dapm_route lm4857_routes[] = {
+	{"LS", NULL, "IN"},
+	{"HP", NULL, "IN"},
+	{"EP", NULL, "IN"},
+};
+
+static int lm4857_probe(struct snd_soc_codec *codec)
+{
+	struct lm4857 *lm4857 = snd_soc_codec_get_drvdata(codec);
+	struct snd_soc_dapm_context *dapm = &codec->dapm;
+	int ret;
+
+	codec->control_data = lm4857->i2c;
+
+	ret = snd_soc_add_controls(codec, lm4857_controls,
+			ARRAY_SIZE(lm4857_controls));
+	if (ret)
+		return ret;
+
+	ret = snd_soc_dapm_new_controls(dapm, lm4857_dapm_widgets,
+			ARRAY_SIZE(lm4857_dapm_widgets));
+	if (ret)
+		return ret;
+
+	ret = snd_soc_dapm_add_routes(dapm, lm4857_routes,
+			ARRAY_SIZE(lm4857_routes));
+	if (ret)
+		return ret;
+
+	snd_soc_dapm_new_widgets(dapm);
+
+	return 0;
+}
+
+static struct snd_soc_codec_driver soc_codec_dev_lm4857 = {
+	.write = lm4857_write,
+	.read = lm4857_read,
+	.probe = lm4857_probe,
+	.reg_cache_size = ARRAY_SIZE(lm4857_default_regs),
+	.reg_word_size = sizeof(uint8_t),
+	.reg_cache_default = lm4857_default_regs,
+	.set_bias_level = lm4857_set_bias_level,
+};
+
+static int __devinit lm4857_i2c_probe(struct i2c_client *i2c,
+	const struct i2c_device_id *id)
+{
+	struct lm4857 *lm4857;
+	int ret;
+
+	lm4857 = kzalloc(sizeof(*lm4857), GFP_KERNEL);
+	if (!lm4857)
+		return -ENOMEM;
+
+	i2c_set_clientdata(i2c, lm4857);
+
+	lm4857->i2c = i2c;
+
+	ret = snd_soc_register_codec(&i2c->dev, &soc_codec_dev_lm4857, NULL, 0);
+
+	if (ret) {
+		kfree(lm4857);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int __devexit lm4857_i2c_remove(struct i2c_client *i2c)
+{
+	struct lm4857 *lm4857 = i2c_get_clientdata(i2c);
+
+	snd_soc_unregister_codec(&i2c->dev);
+	kfree(lm4857);
+
+	return 0;
+}
+
+static const struct i2c_device_id lm4857_i2c_id[] = {
+	{ "lm4857", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, lm4857_i2c_id);
+
+static struct i2c_driver lm4857_i2c_driver = {
+	.driver = {
+		.name = "lm4857",
+		.owner = THIS_MODULE,
+	},
+	.probe = lm4857_i2c_probe,
+	.remove = __devexit_p(lm4857_i2c_remove),
+	.id_table = lm4857_i2c_id,
+};
+
+static int __init lm4857_init(void)
+{
+	return i2c_add_driver(&lm4857_i2c_driver);
+}
+module_init(lm4857_init);
+
+static void __exit lm4857_exit(void)
+{
+	i2c_del_driver(&lm4857_i2c_driver);
+}
+module_exit(lm4857_exit);
+
+MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
+MODULE_DESCRIPTION("LM4857 amplifier driver");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
index a6a6b5f..ba78e26 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -39,6 +39,7 @@ config SND_SOC_SAMSUNG_NEO1973_WM8753
 	depends on SND_SOC_SAMSUNG && MACH_NEO1973_GTA01
 	select SND_S3C24XX_I2S
 	select SND_SOC_WM8753
+	select SND_SOC_LM4857
 	help
 	  Say Y if you want to add support for SoC audio on smdk2440
 	  with the WM8753.
diff --git a/sound/soc/samsung/lm4857.h b/sound/soc/samsung/lm4857.h
deleted file mode 100644
index 0cf5b70..0000000
--- a/sound/soc/samsung/lm4857.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/*
- * lm4857.h  --  ALSA Soc Audio Layer
- *
- * Copyright 2007 Wolfson Microelectronics PLC.
- * Author: Graeme Gregory
- *         graeme.gregory@wolfsonmicro.com or linux@wolfsonmicro.com
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- *
- *  Revision history
- *    18th Jun 2007   Initial version.
- */
-
-#ifndef LM4857_H_
-#define LM4857_H_
-
-/* The register offsets in the cache array */
-#define LM4857_MVOL 0
-#define LM4857_LVOL 1
-#define LM4857_RVOL 2
-#define LM4857_CTRL 3
-
-/* the shifts required to set these bits */
-#define LM4857_3D 5
-#define LM4857_WAKEUP 5
-#define LM4857_EPGAIN 4
-
-#endif /*LM4857_H_*/
-
diff --git a/sound/soc/samsung/neo1973_wm8753.c b/sound/soc/samsung/neo1973_wm8753.c
index fe92946..7761827 100644
--- a/sound/soc/samsung/neo1973_wm8753.c
+++ b/sound/soc/samsung/neo1973_wm8753.c
@@ -17,11 +17,9 @@
 #include <linux/timer.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
-#include <linux/i2c.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
 
 #include <asm/mach-types.h>
 #include <mach/regs-clock.h>
@@ -33,12 +31,10 @@
 #include <plat/regs-iis.h>
 
 #include "../codecs/wm8753.h"
-#include "lm4857.h"
 #include "dma.h"
 #include "s3c24xx-i2s.h"
 
 static struct snd_soc_card neo1973;
-static struct i2c_client *i2c;
 
 static int neo1973_hifi_hw_params(struct snd_pcm_substream *substream,
 	struct snd_pcm_hw_params *params)
@@ -213,85 +209,7 @@ static struct snd_soc_ops neo1973_voice_ops = {
 	.hw_free = neo1973_voice_hw_free,
 };
 
-static u8 lm4857_regs[4] = {0x00, 0x40, 0x80, 0xC0};
-
-static void lm4857_write_regs(void)
-{
-	pr_debug("Entered %s\n", __func__);
-
-	if (i2c_master_send(i2c, lm4857_regs, 4) != 4)
-		printk(KERN_ERR "lm4857: i2c write failed\n");
-}
-
-static int lm4857_get_reg(struct snd_kcontrol *kcontrol,
-	struct snd_ctl_elem_value *ucontrol)
-{
-	struct soc_mixer_control *mc =
-		(struct soc_mixer_control *)kcontrol->private_value;
-	int reg = mc->reg;
-	int shift = mc->shift;
-	int mask = mc->max;
-
-	pr_debug("Entered %s\n", __func__);
-
-	ucontrol->value.integer.value[0] = (lm4857_regs[reg] >> shift) & mask;
-	return 0;
-}
-
-static int lm4857_set_reg(struct snd_kcontrol *kcontrol,
-	struct snd_ctl_elem_value *ucontrol)
-{
-	struct soc_mixer_control *mc =
-		(struct soc_mixer_control *)kcontrol->private_value;
-	int reg = mc->reg;
-	int shift = mc->shift;
-	int mask = mc->max;
-
-	if (((lm4857_regs[reg] >> shift) & mask) ==
-		ucontrol->value.integer.value[0])
-		return 0;
-
-	lm4857_regs[reg] &= ~(mask << shift);
-	lm4857_regs[reg] |= ucontrol->value.integer.value[0] << shift;
-	lm4857_write_regs();
-	return 1;
-}
-
-static int lm4857_get_mode(struct snd_kcontrol *kcontrol,
-	struct snd_ctl_elem_value *ucontrol)
-{
-	u8 value = lm4857_regs[LM4857_CTRL] & 0x0F;
-
-	pr_debug("Entered %s\n", __func__);
-
-	if (value)
-		value -= 5;
-
-	ucontrol->value.integer.value[0] = value;
-	return 0;
-}
-
-static int lm4857_set_mode(struct snd_kcontrol *kcontrol,
-	struct snd_ctl_elem_value *ucontrol)
-{
-	u8 value = ucontrol->value.integer.value[0];
-
-	pr_debug("Entered %s\n", __func__);
-
-	if (value)
-		value += 5;
-
-	if ((lm4857_regs[LM4857_CTRL] & 0x0F) == value)
-		return 0;
-
-	lm4857_regs[LM4857_CTRL] &= 0xF0;
-	lm4857_regs[LM4857_CTRL] |= value;
-	lm4857_write_regs();
-	return 1;
-}
-
 static const struct snd_soc_dapm_widget wm8753_dapm_widgets[] = {
-	SND_SOC_DAPM_LINE("Audio Out", NULL),
 	SND_SOC_DAPM_LINE("GSM Line Out", NULL),
 	SND_SOC_DAPM_LINE("GSM Line In", NULL),
 	SND_SOC_DAPM_MIC("Headset Mic", NULL),
@@ -299,12 +217,7 @@ static const struct snd_soc_dapm_widget wm8753_dapm_widgets[] = {
 };
 
 
-static const struct snd_soc_dapm_route dapm_routes[] = {
-
-	/* Connections to the lm4857 amp */
-	{"Audio Out", NULL, "LOUT1"},
-	{"Audio Out", NULL, "ROUT1"},
-
+static const struct snd_soc_dapm_route neo1973_wm8753_routes[] = {
 	/* Connections to the GSM Module */
 	{"GSM Line Out", NULL, "MONO1"},
 	{"GSM Line Out", NULL, "MONO2"},
@@ -324,46 +237,14 @@ static const struct snd_soc_dapm_route dapm_routes[] = {
 	{"ACIN", NULL, "ACOP"},
 };
 
-static const char *lm4857_mode[] = {
-	"Off",
-	"Call Speaker",
-	"Stereo Speakers",
-	"Stereo Speakers + Headphones",
-	"Headphones"
-};
-
-static const struct soc_enum lm4857_mode_enum[] = {
-	SOC_ENUM_SINGLE_EXT(ARRAY_SIZE(lm4857_mode), lm4857_mode),
-};
-
-static const DECLARE_TLV_DB_SCALE(stereo_tlv, -4050, 150, 0);
-static const DECLARE_TLV_DB_SCALE(mono_tlv, -3450, 150, 0);
-
-static const struct snd_kcontrol_new wm8753_neo1973_controls[] = {
-	SOC_DAPM_PIN_SWITCH("Audio Out"),
+static const struct snd_kcontrol_new neo1973_wm8753_controls[] = {
 	SOC_DAPM_PIN_SWITCH("GSM Line Out"),
 	SOC_DAPM_PIN_SWITCH("GSM Line In"),
 	SOC_DAPM_PIN_SWITCH("Headset Mic"),
 	SOC_DAPM_PIN_SWITCH("Call Mic"),
-
-	SOC_SINGLE_EXT_TLV("Amp Left Playback Volume", LM4857_LVOL, 0, 31, 0,
-		lm4857_get_reg, lm4857_set_reg, stereo_tlv),
-	SOC_SINGLE_EXT_TLV("Amp Right Playback Volume", LM4857_RVOL, 0, 31, 0,
-		lm4857_get_reg, lm4857_set_reg, stereo_tlv),
-	SOC_SINGLE_EXT_TLV("Amp Mono Playback Volume", LM4857_MVOL, 0, 31, 0,
-		lm4857_get_reg, lm4857_set_reg, mono_tlv),
-	SOC_ENUM_EXT("Amp Mode", lm4857_mode_enum[0],
-		lm4857_get_mode, lm4857_set_mode),
-	SOC_SINGLE_EXT("Amp Spk 3D Playback Switch", LM4857_LVOL, 5, 1, 0,
-		lm4857_get_reg, lm4857_set_reg),
-	SOC_SINGLE_EXT("Amp HP 3d Playback Switch", LM4857_RVOL, 5, 1, 0,
-		lm4857_get_reg, lm4857_set_reg),
-	SOC_SINGLE_EXT("Amp Fast Wakeup Playback Switch", LM4857_CTRL, 5, 1, 0,
-		lm4857_get_reg, lm4857_set_reg),
-	SOC_SINGLE_EXT("Amp Earpiece 6dB Playback Switch", LM4857_CTRL, 4, 1, 0,
-		lm4857_get_reg, lm4857_set_reg),
 };
 
+
 /*
  * This is an example machine initialisation for a wm8753 connected to a
  * neo1973 II. It is missing logic to detect hp/mic insertions and logic
@@ -387,29 +268,66 @@ static int neo1973_wm8753_init(struct snd_soc_pcm_runtime *rtd)
 
 	/* Add neo1973 specific widgets */
 	snd_soc_dapm_new_controls(dapm, wm8753_dapm_widgets,
-				  ARRAY_SIZE(wm8753_dapm_widgets));
+			ARRAY_SIZE(wm8753_dapm_widgets));
 
 	/* set endpoints to default mode */
-	snd_soc_dapm_disable_pin(dapm, "Audio Out");
 	snd_soc_dapm_disable_pin(dapm, "GSM Line Out");
 	snd_soc_dapm_disable_pin(dapm, "GSM Line In");
 	snd_soc_dapm_disable_pin(dapm, "Headset Mic");
 	snd_soc_dapm_disable_pin(dapm, "Call Mic");
 
 	/* add neo1973 specific controls */
-	err = snd_soc_add_controls(codec, wm8753_neo1973_controls,
-				ARRAY_SIZE(8753_neo1973_controls));
+	err = snd_soc_add_controls(codec, neo1973_wm8753_controls,
+				ARRAY_SIZE(neo1973_wm8753_controls));
 	if (err < 0)
 		return err;
 
 	/* set up neo1973 specific audio routes */
-	err = snd_soc_dapm_add_routes(dapm, dapm_routes,
-				      ARRAY_SIZE(dapm_routes));
+	err = snd_soc_dapm_add_routes(dapm, neo1973_wm8753_routes,
+			ARRAY_SIZE(neo1973_wm8753_routes));
 
 	snd_soc_dapm_sync(dapm);
 	return 0;
 }
 
+static const struct snd_soc_dapm_route neo1973_lm4857_routes[] = {
+	{"Amp IN", NULL, "ROUT1"},
+	{"Amp IN", NULL, "LOUT1"},
+
+	{"Handset Spk", NULL, "Amp EP"},
+	{"Stereo Out", NULL, "Amp LS"},
+	{"Headphone", NULL, "Amp HP"},
+};
+
+static const struct snd_soc_dapm_widget neo1973_lm4857_dapm_widgets[] = {
+	SND_SOC_DAPM_SPK("Handset Spk", NULL),
+	SND_SOC_DAPM_SPK("Stereo Out", NULL),
+	SND_SOC_DAPM_HP("Headphone", NULL),
+};
+
+static int neo1973_lm4857_init(struct snd_soc_dapm_context *dapm)
+{
+	int ret;
+
+	ret = snd_soc_dapm_new_controls(dapm, neo1973_lm4857_dapm_widgets,
+			ARRAY_SIZE(neo1973_lm4857_dapm_widgets));
+	if (ret)
+		return ret;
+
+	ret = snd_soc_dapm_add_routes(dapm, neo1973_lm4857_routes,
+			ARRAY_SIZE(neo1973_lm4857_routes));
+	if (ret)
+		return ret;
+
+	snd_soc_dapm_ignore_suspend(dapm, "Stereo Out");
+	snd_soc_dapm_ignore_suspend(dapm, "Handset Spk");
+	snd_soc_dapm_ignore_suspend(dapm, "Headphone");
+
+	snd_soc_dapm_sync(dapm);
+
+	return 0;
+}
+
 /*
  * BT Codec DAI
  */
@@ -449,83 +367,29 @@ static struct snd_soc_dai_link neo1973_dai[] = {
 },
 };
 
-static struct snd_soc_card neo1973 = {
-	.name = "neo1973",
-	.dai_link = neo1973_dai,
-	.num_links = ARRAY_SIZE(neo1973_dai),
+static struct snd_soc_aux_dev neo1973_aux_devs[] = {
+	{
+		.name = "lm4857",
+		.codec_name = "lm4857.0-007c",
+		.init = neo1973_lm4857_init,
+	},
 };
 
-static int lm4857_i2c_probe(struct i2c_client *client,
-			    const struct i2c_device_id *id)
-{
-	pr_debug("Entered %s\n", __func__);
-
-	i2c = client;
-
-	lm4857_write_regs();
-	return 0;
-}
-
-static int lm4857_i2c_remove(struct i2c_client *client)
-{
-	pr_debug("Entered %s\n", __func__);
-
-	i2c = NULL;
-
-	return 0;
-}
-
-static u8 lm4857_state;
-
-static int lm4857_suspend(struct i2c_client *dev, pm_message_t state)
-{
-	pr_debug("Entered %s\n", __func__);
-
-	dev_dbg(&dev->dev, "lm4857_suspend\n");
-	lm4857_state = lm4857_regs[LM4857_CTRL] & 0xf;
-	if (lm4857_state) {
-		lm4857_regs[LM4857_CTRL] &= 0xf0;
-		lm4857_write_regs();
-	}
-	return 0;
-}
-
-static int lm4857_resume(struct i2c_client *dev)
-{
-	pr_debug("Entered %s\n", __func__);
-
-	if (lm4857_state) {
-		lm4857_regs[LM4857_CTRL] |= (lm4857_state & 0x0f);
-		lm4857_write_regs();
-	}
-	return 0;
-}
-
-static void lm4857_shutdown(struct i2c_client *dev)
-{
-	pr_debug("Entered %s\n", __func__);
-
-	dev_dbg(&dev->dev, "lm4857_shutdown\n");
-	lm4857_regs[LM4857_CTRL] &= 0xf0;
-	lm4857_write_regs();
-}
-
-static const struct i2c_device_id lm4857_i2c_id[] = {
-	{ "neo1973_lm4857", 0 },
-	{ }
+static struct snd_soc_codec_conf neo1973_codec_conf[] = {
+	{
+		.dev_name = "lm4857.0-007c",
+		.name_prefix = "Amp",
+	},
 };
 
-static struct i2c_driver lm4857_i2c_driver = {
-	.driver = {
-		.name = "LM4857 I2C Amp",
-		.owner = THIS_MODULE,
-	},
-	.suspend =        lm4857_suspend,
-	.resume	=         lm4857_resume,
-	.shutdown =       lm4857_shutdown,
-	.probe =          lm4857_i2c_probe,
-	.remove =         lm4857_i2c_remove,
-	.id_table =       lm4857_i2c_id,
+static struct snd_soc_card neo1973 = {
+	.name = "neo1973",
+	.dai_link = neo1973_dai,
+	.num_links = ARRAY_SIZE(neo1973_dai),
+	.aux_dev = neo1973_aux_devs,
+	.num_aux_devs = ARRAY_SIZE(neo1973_aux_devs),
+	.codec_conf = neo1973_codec_conf,
+	.num_configs = ARRAY_SIZE(neo1973_codec_conf),
 };
 
 static struct platform_device *neo1973_snd_device;
@@ -554,8 +418,6 @@ static int __init neo1973_init(void)
 		return ret;
 	}
 
-	ret = i2c_add_driver(&lm4857_i2c_driver);
-
 	if (ret != 0)
 		platform_device_unregister(neo1973_snd_device);
 
@@ -566,7 +428,6 @@ static void __exit neo1973_exit(void)
 {
 	pr_debug("Entered %s\n", __func__);
 
-	i2c_del_driver(&lm4857_i2c_driver);
 	platform_device_unregister(neo1973_snd_device);
 }
 
-- 
1.7.2.3


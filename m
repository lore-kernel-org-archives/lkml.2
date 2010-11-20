Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab0KTNDH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 08:03:07 -0500
Received: from fallback4.mail.ru ([94.100.176.42]:45568 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab0KTNDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 08:03:05 -0500
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: alsa-devel@alsa-project.org
Cc: Eric Miao <eric.y.miao@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Philipp Zabel <philipp.zabel@gmail.com>,
        Harald Welte <laforge@gnumonks.org>
Subject: [PATCH 1/3] ASoC: Asahi Kasei AK4641 codec driver
Date: Sat, 20 Nov 2010 15:59:22 +0300
Message-Id: <1290257964-17435-2-git-send-email-mad_soft@inbox.ru>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1290257964-17435-1-git-send-email-mad_soft@inbox.ru>
References: <1290257964-17435-1-git-send-email-mad_soft@inbox.ru>
X-Mras: Ok
X-MR-Warn: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A driver for the AK4641 codec used in iPAQ hx4700 and Glofiish M800
among others.

Signed-off-by: Harald Welte <laforge@gnumonks.org>
Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
---
 include/sound/ak4641.h    |   26 ++
 sound/soc/codecs/Kconfig  |    4 +
 sound/soc/codecs/Makefile |    2 +
 sound/soc/codecs/ak4641.c |  628 +++++++++++++++++++++++++++++++++++++++++++++
 sound/soc/codecs/ak4641.h |   47 ++++
 5 files changed, 707 insertions(+), 0 deletions(-)
 create mode 100644 include/sound/ak4641.h
 create mode 100644 sound/soc/codecs/ak4641.c
 create mode 100644 sound/soc/codecs/ak4641.h

diff --git a/include/sound/ak4641.h b/include/sound/ak4641.h
new file mode 100644
index 0000000..96d1991
--- /dev/null
+++ b/include/sound/ak4641.h
@@ -0,0 +1,26 @@
+/*
+ * AK4641 ALSA SoC Codec driver
+ *
+ * Copyright 2009 Philipp Zabel
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __AK4641_H
+#define __AK4641_H
+
+/**
+ * struct ak4641_platform_data - platform specific AK4641 configuration
+ * @gpio_power:	GPIO to control external power to AK4641
+ * @gpio_npdn:	GPIO connected to AK4641 nPDN pin
+ *
+ * Both GPIO parameters are optional.
+ */
+struct ak4641_platform_data {
+	int gpio_power;
+	int gpio_npdn;
+};
+
+#endif /* __AK4641_H */
diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 6ebd3a6..7c266eb 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -20,6 +20,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_AD73311 if I2C
 	select SND_SOC_AK4104 if SPI_MASTER
 	select SND_SOC_AK4535 if I2C
+	select SND_SOC_AK4641 if I2C
 	select SND_SOC_AK4642 if I2C
 	select SND_SOC_AK4671 if I2C
 	select SND_SOC_ALC5623 if I2C
@@ -126,6 +127,9 @@ config SND_SOC_AK4104
 config SND_SOC_AK4535
 	tristate
 
+config SND_SOC_AK4641
+	tristate
+
 config SND_SOC_AK4642
 	tristate
 
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index 42f185d..e13bd20 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -7,6 +7,7 @@ snd-soc-ad73311-objs := ad73311.o
 snd-soc-ads117x-objs := ads117x.o
 snd-soc-ak4104-objs := ak4104.o
 snd-soc-ak4535-objs := ak4535.o
+snd-soc-ak4641-objs := ak4641.o
 snd-soc-ak4642-objs := ak4642.o
 snd-soc-ak4671-objs := ak4671.o
 snd-soc-cq93vc-objs := cq93vc.o
@@ -83,6 +84,7 @@ obj-$(CONFIG_SND_SOC_AD73311) += snd-soc-ad73311.o
 obj-$(CONFIG_SND_SOC_ADS117X)	+= snd-soc-ads117x.o
 obj-$(CONFIG_SND_SOC_AK4104)	+= snd-soc-ak4104.o
 obj-$(CONFIG_SND_SOC_AK4535)	+= snd-soc-ak4535.o
+obj-$(CONFIG_SND_SOC_AK4641)	+= snd-soc-ak4641.o
 obj-$(CONFIG_SND_SOC_AK4642)	+= snd-soc-ak4642.o
 obj-$(CONFIG_SND_SOC_AK4671)	+= snd-soc-ak4671.o
 obj-$(CONFIG_SND_SOC_CQ0093VC) += snd-soc-cq93vc.o
diff --git a/sound/soc/codecs/ak4641.c b/sound/soc/codecs/ak4641.c
new file mode 100644
index 0000000..d45e144
--- /dev/null
+++ b/sound/soc/codecs/ak4641.c
@@ -0,0 +1,628 @@
+/*
+ * ak4641.c  --  AK4641 ALSA Soc Audio driver
+ *
+ * Copyright (C) 2008 Harald Welte <laforge@gnufiish.org>
+ *
+ * Based on ak4535.c by Richard Purdie
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/pm.h>
+#include <linux/i2c.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+#include <sound/initval.h>
+#include <sound/ak4641.h>
+
+#include "ak4641.h"
+
+/* codec private data */
+struct ak4641_priv {
+	struct snd_soc_codec *codec;
+	u8 reg_cache[AK4641_CACHEREGNUM];
+	unsigned int sysclk;
+};
+
+/*
+ * ak4641 register cache
+ */
+static const u8 ak4641_reg[AK4641_CACHEREGNUM] = {
+	0x00, 0x80, 0x00, 0x80,
+	0x02, 0x00, 0x11, 0x05,
+	0x00, 0x00, 0x36, 0x10,
+	0x00, 0x00, 0x57, 0x00,
+	0x88, 0x88, 0x08, 0x08
+};
+
+
+static int ak4641_sync(struct snd_soc_codec *codec)
+{
+	u8 *cache = codec->reg_cache;
+	int i, r = 0;
+
+	for (i = 0; i < AK4641_CACHEREGNUM; i++)
+		r |= snd_soc_write(codec, i, cache[i]);
+
+	return r;
+};
+
+
+static const char *ak4641_mono_gain[] = {"+6dB", "-17dB"};
+static const char *ak4641_mono_out[] = {"(L + R)/2", "Hi-Z"};
+static const char *ak4641_hp_out[] = {"Stereo", "Mono"};
+static const char *ak4641_deemp[] = {"44.1kHz", "Off", "48kHz", "32kHz"};
+static const char *ak4641_mic_select[] = {"Internal", "External"};
+static const char *ak4641_mic_or_dac[] = {"Microphone", "Voice DAC"};
+
+static const struct soc_enum ak4641_enum[] = {
+	SOC_ENUM_SINGLE(AK4641_SIG1, 7, 2, ak4641_mono_gain),
+	SOC_ENUM_SINGLE(AK4641_SIG1, 6, 2, ak4641_mono_out),
+	SOC_ENUM_SINGLE(AK4641_MODE2, 2, 2, ak4641_hp_out),
+	SOC_ENUM_SINGLE(AK4641_DAC, 0, 4, ak4641_deemp),
+	SOC_ENUM_SINGLE(AK4641_MIC, 1, 2, ak4641_mic_select),
+	SOC_ENUM_SINGLE(AK4641_BTIF, 4, 2, ak4641_mic_or_dac),
+};
+
+static const struct snd_kcontrol_new ak4641_snd_controls[] = {
+	SOC_ENUM("Mono 1 Output", ak4641_enum[1]),
+	SOC_ENUM("Mono 1 Gain", ak4641_enum[0]),
+	SOC_ENUM("Headphone Output", ak4641_enum[2]),
+	SOC_ENUM("Playback Deemphasis", ak4641_enum[3]),
+
+	SOC_SINGLE("Mic Boost (+20dB) Switch", AK4641_MIC, 0, 1, 0),
+
+	SOC_SINGLE("ALC Operation Time", AK4641_TIMER, 0, 3, 0),
+	SOC_SINGLE("ALC Recovery Time", AK4641_TIMER, 2, 3, 0),
+	SOC_SINGLE("ALC ZC Time", AK4641_TIMER, 4, 3, 0),
+
+	SOC_SINGLE("ALC 1 Switch", AK4641_ALC1, 5, 1, 0),
+
+	SOC_SINGLE("ALC Volume", AK4641_ALC2, 0, 127, 0),
+
+	SOC_SINGLE("Capture Volume", AK4641_PGA, 0, 127, 0),
+
+	SOC_DOUBLE_R("Master Playback Volume", AK4641_LATT,
+				AK4641_RATT, 0, 255, 1),
+
+	SOC_SINGLE("AUX In Volume", AK4641_VOL, 0, 15, 0),
+	SOC_SINGLE("Mic In Volume", AK4641_VOL, 4, 7, 0),
+	SOC_SINGLE("Mic In -4dB", AK4641_VOL, 7, 1, 0),
+
+	SOC_SINGLE("Equalizer", AK4641_DAC, 2, 1, 0),
+	SOC_SINGLE("EQ1 100 Hz", AK4641_EQLO, 0, 15, 1),
+	SOC_SINGLE("EQ2 250 Hz", AK4641_EQLO, 4, 15, 1),
+	SOC_SINGLE("EQ3 1 kHz", AK4641_EQMID, 0, 15, 1),
+	SOC_SINGLE("EQ4 3.5 kHz", AK4641_EQMID, 4, 15, 1),
+	SOC_SINGLE("EQ5 10 kHz", AK4641_EQHI, 0, 15, 1),
+};
+
+/* Mono 1 Mixer */
+static const struct snd_kcontrol_new ak4641_mono1_mixer_controls[] = {
+	SOC_DAPM_SINGLE("Mic Mono Sidetone Switch", AK4641_SIG1, 4, 1, 0),
+	SOC_DAPM_SINGLE("Mono Playback Switch", AK4641_SIG1, 5, 1, 0),
+};
+
+/* Stereo Mixer */
+static const struct snd_kcontrol_new ak4641_stereo_mixer_controls[] = {
+	SOC_DAPM_SINGLE("Mic Sidetone Switch", AK4641_SIG2, 4, 1, 0),
+	SOC_DAPM_SINGLE("Playback Switch", AK4641_SIG2, 7, 1, 0),
+	SOC_DAPM_SINGLE("Aux Bypass Switch", AK4641_SIG2, 5, 1, 0),
+};
+
+/* Input Mixer */
+static const struct snd_kcontrol_new ak4641_input_mixer_controls[] = {
+	SOC_DAPM_SINGLE("Mic Capture Switch", AK4641_MIC, 2, 1, 0),
+	SOC_DAPM_SINGLE("Aux Capture Switch", AK4641_MIC, 5, 1, 0),
+};
+
+/* Mic mux */
+static const struct snd_kcontrol_new ak4641_mic_mux_control =
+	SOC_DAPM_ENUM("Mic Select", ak4641_enum[4]);
+
+/* Input mux */
+static const struct snd_kcontrol_new ak4641_input_mux_control =
+	SOC_DAPM_ENUM("Input Select", ak4641_enum[5]);
+
+/* HP L switch */
+static const struct snd_kcontrol_new ak4641_hpl_control =
+	SOC_DAPM_SINGLE("Switch", AK4641_SIG2, 1, 1, 0);
+
+/* HP R switch */
+static const struct snd_kcontrol_new ak4641_hpr_control =
+	SOC_DAPM_SINGLE("Switch", AK4641_SIG2, 0, 1, 0);
+
+/* mono 2 switch */
+static const struct snd_kcontrol_new ak4641_mono2_control =
+	SOC_DAPM_SINGLE("Switch", AK4641_SIG1, 0, 1, 0);
+
+/* ak4641 dapm widgets */
+static const struct snd_soc_dapm_widget ak4641_dapm_widgets[] = {
+	SND_SOC_DAPM_MIXER("Stereo Mixer", SND_SOC_NOPM, 0, 0,
+		&ak4641_stereo_mixer_controls[0],
+		ARRAY_SIZE(ak4641_stereo_mixer_controls)),
+	SND_SOC_DAPM_MIXER("Mono1 Mixer", SND_SOC_NOPM, 0, 0,
+		&ak4641_mono1_mixer_controls[0],
+		ARRAY_SIZE(ak4641_mono1_mixer_controls)),
+	SND_SOC_DAPM_MIXER("Input Mixer", SND_SOC_NOPM, 0, 0,
+		&ak4641_input_mixer_controls[0],
+		ARRAY_SIZE(ak4641_input_mixer_controls)),
+	SND_SOC_DAPM_MUX("Mic Mux", SND_SOC_NOPM, 0, 0,
+		&ak4641_mic_mux_control),
+	SND_SOC_DAPM_MUX("Input Mux", SND_SOC_NOPM, 0, 0,
+		&ak4641_input_mux_control),
+	SND_SOC_DAPM_SWITCH("Mono 2 Enable", SND_SOC_NOPM, 0, 0,
+		&ak4641_mono2_control),
+	/* speaker powersave bit */
+	SND_SOC_DAPM_SWITCH("Left Out Enable", SND_SOC_NOPM, 0, 0,
+		&ak4641_hpl_control),
+	SND_SOC_DAPM_SWITCH("Right Out Enable", SND_SOC_NOPM, 0, 0,
+		&ak4641_hpr_control),
+
+	SND_SOC_DAPM_OUTPUT("LOUT"),
+	SND_SOC_DAPM_OUTPUT("ROUT"),
+	SND_SOC_DAPM_OUTPUT("MOUT1"),
+	SND_SOC_DAPM_OUTPUT("MOUT2"),
+	SND_SOC_DAPM_OUTPUT("MICOUT"),
+
+	SND_SOC_DAPM_ADC("ADC", "HiFi Capture", AK4641_PM1, 0, 0),
+	SND_SOC_DAPM_PGA("Mic", AK4641_PM1, 1, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("AUX In", AK4641_PM1, 2, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("Mono Out", AK4641_PM1, 3, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("Line Out", AK4641_PM1, 4, 0, NULL, 0),
+
+	SND_SOC_DAPM_DAC("DAC", "HiFi Playback", AK4641_PM2, 0, 0),
+	SND_SOC_DAPM_PGA("Mono Out 2", AK4641_PM2, 3, 0, NULL, 0),
+
+	SND_SOC_DAPM_ADC("Voice ADC", "Voice Capture", AK4641_BTIF, 0, 0),
+	SND_SOC_DAPM_ADC("Voice DAC", "Voice Playback", AK4641_BTIF, 1, 0),
+
+	SND_SOC_DAPM_MICBIAS("Mic Int Bias", AK4641_MIC, 3, 0),
+	SND_SOC_DAPM_MICBIAS("Mic Ext Bias", AK4641_MIC, 4, 0),
+
+	SND_SOC_DAPM_INPUT("MICIN"),
+	SND_SOC_DAPM_INPUT("MICEXT"),
+	SND_SOC_DAPM_INPUT("AUX"),
+	SND_SOC_DAPM_INPUT("AIN"),
+};
+
+static const struct snd_soc_dapm_route audio_map[] = {
+	/* Stereo Mixer */
+	{"Stereo Mixer", "Playback Switch", "DAC"},
+	{"Stereo Mixer", "Mic Sidetone Switch", "Input Mux"},
+	{"Stereo Mixer", "Aux Bypass Switch", "AUX In"},
+
+	/* Mono 1 Mixer */
+	{"Mono1 Mixer", "Mic Mono Sidetone Switch", "Input Mux"},
+	{"Mono1 Mixer", "Mono Playback Switch", "DAC"},
+
+	/* Mic */
+	{"Mic", NULL, "AIN"},
+	{"Mic Mux", "Internal", "Mic Int Bias"},
+	{"Mic Mux", "External", "Mic Ext Bias"},
+	{"Mic Int Bias", NULL, "MICIN"},
+	{"Mic Ext Bias", NULL, "MICEXT"},
+	{"MICOUT", NULL, "Mic Mux"},
+
+	/* Input Mux */
+	{"Input Mux", "Microphone", "Mic"},
+	{"Input Mux", "Voice DAC", "Voice DAC"},
+
+	/* Line Out */
+	{"LOUT", NULL, "Left Out Enable"},
+	{"ROUT", NULL, "Right Out Enable"},
+	{"Left Out Enable", "Switch", "Line Out"},
+	{"Right Out Enable", "Switch", "Line Out"},
+	{"Line Out", NULL, "Stereo Mixer"},
+
+	/* Mono 1 Out */
+	{"MOUT1", NULL, "Mono Out"},
+	{"Mono Out", NULL, "Mono1 Mixer"},
+
+	/* Mono 2 Out */
+	{"MOUT2", NULL, "Mono 2 Enable"},
+	{"Mono 2 Enable", "Switch", "Mono Out 2"},
+	{"Mono Out 2", NULL, "Stereo Mixer"},
+
+	{"Voice ADC", NULL, "Mono 2 Enable"},
+
+	/* Aux In */
+	{"AUX In", NULL, "AUX"},
+
+	/* ADC */
+	{"ADC", NULL, "Input Mixer"},
+	{"Input Mixer", "Mic Capture Switch", "Mic"},
+	{"Input Mixer", "Aux Capture Switch", "AUX In"},
+};
+
+static int ak4641_add_widgets(struct snd_soc_codec *codec)
+{
+	struct snd_soc_dapm_context *dapm = &codec->dapm;
+	snd_soc_dapm_new_controls(dapm, ak4641_dapm_widgets,
+				  ARRAY_SIZE(ak4641_dapm_widgets));
+
+	snd_soc_dapm_add_routes(dapm, audio_map, ARRAY_SIZE(audio_map));
+
+	snd_soc_dapm_new_widgets(dapm);
+	return 0;
+}
+
+static int ak4641_set_dai_sysclk(struct snd_soc_dai *codec_dai,
+	int clk_id, unsigned int freq, int dir)
+{
+	struct snd_soc_codec *codec = codec_dai->codec;
+	struct ak4641_priv *ak4641 = snd_soc_codec_get_drvdata(codec);
+
+	ak4641->sysclk = freq;
+	return 0;
+}
+
+static int ak4641_pcm_hw_params(struct snd_pcm_substream *substream,
+				 struct snd_pcm_hw_params *params,
+				 struct snd_soc_dai *dai)
+{
+	/* FIXME */
+
+	return 0;
+}
+
+static int ak4641_i2s_hw_params(struct snd_pcm_substream *substream,
+				 struct snd_pcm_hw_params *params,
+				 struct snd_soc_dai *dai)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_codec *codec = rtd->codec;
+	struct ak4641_priv *ak4641 = snd_soc_codec_get_drvdata(codec);
+	u8 mode2 = snd_soc_read(codec, AK4641_MODE2) & ~(0x3 << 5);
+	int rate = params_rate(params), fs = 256;
+
+	if (rate)
+		fs = ak4641->sysclk / rate;
+
+	/* set fs */
+	switch (fs) {
+	case 1024:
+		mode2 |= (0x2 << 5);
+		break;
+	case 512:
+		mode2 |= (0x1 << 5);
+		break;
+	case 256:
+		break;
+	}
+
+	/* set rate */
+	snd_soc_write(codec, AK4641_MODE2, mode2);
+	return 0;
+}
+
+static int ak4641_pcm_set_dai_fmt(struct snd_soc_dai *codec_dai,
+				  unsigned int fmt)
+{
+	struct snd_soc_codec *codec = codec_dai->codec;
+	u8 btif = snd_soc_read(codec, AK4641_BTIF) & ~(0x3 << 5);
+
+	/* interface format */
+	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_I2S:
+		btif |= (0x3 << 5);
+		break;
+	case SND_SOC_DAIFMT_LEFT_J:
+		btif |= (0x2 << 5);
+		break;
+	case SND_SOC_DAIFMT_DSP_A:	/* MSB after FRM */
+		btif |= (0x0 << 5);
+		break;
+	case SND_SOC_DAIFMT_DSP_B:	/* MSB during FRM */
+		btif |= (0x1 << 5);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	snd_soc_write(codec, AK4641_BTIF, btif);
+	return 0;
+}
+
+static int ak4641_i2s_set_dai_fmt(struct snd_soc_dai *codec_dai,
+		unsigned int fmt)
+{
+	struct snd_soc_codec *codec = codec_dai->codec;
+	u8 mode1 = 0;
+
+	/* interface format */
+	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_I2S:
+		mode1 = 0x0002;
+		break;
+	case SND_SOC_DAIFMT_LEFT_J:
+		mode1 = 0x0001;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	snd_soc_write(codec, AK4641_MODE1, mode1);
+	return 0;
+}
+
+static int ak4641_mute(struct snd_soc_dai *dai, int mute)
+{
+	struct snd_soc_codec *codec = dai->codec;
+	u16 mute_reg = snd_soc_read(codec, AK4641_DAC) & 0xffdf;
+	if (!mute)
+		snd_soc_write(codec, AK4641_DAC, mute_reg);
+	else
+		snd_soc_write(codec, AK4641_DAC, mute_reg | 0x20);
+	return 0;
+}
+
+static int ak4641_set_bias_level(struct snd_soc_codec *codec,
+	enum snd_soc_bias_level level)
+{
+	u16 i, mute_reg;
+
+	switch (level) {
+	case SND_SOC_BIAS_ON:
+		mute_reg = snd_soc_read(codec, AK4641_DAC) & 0xffdf;
+		snd_soc_write(codec, AK4641_DAC, mute_reg);
+		break;
+	case SND_SOC_BIAS_PREPARE:
+		mute_reg = snd_soc_read(codec, AK4641_DAC) & 0xffdf;
+		snd_soc_write(codec, AK4641_DAC, mute_reg | 0x20);
+		break;
+	case SND_SOC_BIAS_STANDBY:
+		i = snd_soc_read(codec, AK4641_PM1);
+		snd_soc_write(codec, AK4641_PM1, i | 0x80);
+		i = snd_soc_read(codec, AK4641_PM2);
+		snd_soc_write(codec, AK4641_PM2, i & (~0x80));
+		break;
+	case SND_SOC_BIAS_OFF:
+		i = snd_soc_read(codec, AK4641_PM1);
+		snd_soc_write(codec, AK4641_PM1, i & (~0x80));
+		break;
+	}
+	codec->dapm.bias_level = level;
+	return 0;
+}
+
+#define AK4641_RATES (SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_11025 |\
+		SNDRV_PCM_RATE_16000 | SNDRV_PCM_RATE_22050 |\
+		SNDRV_PCM_RATE_44100 | SNDRV_PCM_RATE_48000)
+#define AK4641_RATES_BT (SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_11025 |\
+			 SNDRV_PCM_RATE_16000)
+#define AK4641_FORMATS	(SNDRV_PCM_FMTBIT_S16_LE)
+
+static struct snd_soc_dai_ops ak4641_i2s_dai_ops = {
+	.hw_params    = ak4641_i2s_hw_params,
+	.set_fmt      = ak4641_i2s_set_dai_fmt,
+	.digital_mute = ak4641_mute,
+	.set_sysclk   = ak4641_set_dai_sysclk,
+};
+
+static struct snd_soc_dai_ops ak4641_pcm_dai_ops = {
+	.hw_params    = ak4641_pcm_hw_params,
+	.set_fmt      = ak4641_pcm_set_dai_fmt,
+	.digital_mute = ak4641_mute,
+	.set_sysclk   = ak4641_set_dai_sysclk,
+};
+
+struct snd_soc_dai_driver ak4641_dai[] = {
+{
+	.name = "ak4641-hifi",
+	.id = 1,
+	.playback = {
+		.stream_name = "HiFi Playback",
+		.channels_min = 1,
+		.channels_max = 2,
+		.rates = AK4641_RATES,
+		.formats = AK4641_FORMATS,
+	},
+	.capture = {
+		.stream_name = "HiFi Capture",
+		.channels_min = 1,
+		.channels_max = 2,
+		.rates = AK4641_RATES,
+		.formats = AK4641_FORMATS,
+	},
+	.ops = &ak4641_i2s_dai_ops,
+},
+{
+	.name = "ak4641-voice",
+	.id = 1,
+	.playback = {
+		.stream_name = "Voice Playback",
+		.channels_min = 1,
+		.channels_max = 1,
+		.rates = AK4641_RATES_BT,
+		.formats = AK4641_FORMATS,
+	},
+	.capture = {
+		.stream_name = "Voice Capture",
+		.channels_min = 1,
+		.channels_max = 1,
+		.rates = AK4641_RATES_BT,
+		.formats = AK4641_FORMATS,
+	},
+	.ops = &ak4641_pcm_dai_ops,
+},
+};
+
+static int ak4641_suspend(struct snd_soc_codec *codec, pm_message_t state)
+{
+	ak4641_set_bias_level(codec, SND_SOC_BIAS_OFF);
+	return 0;
+}
+
+static int ak4641_resume(struct snd_soc_codec *codec)
+{
+	ak4641_sync(codec);
+	ak4641_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
+	return 0;
+}
+
+
+static int ak4641_probe(struct snd_soc_codec *codec)
+{
+	struct ak4641_platform_data *pdata = codec->dev->platform_data;
+	int ret;
+
+
+	if (pdata) {
+		if (gpio_is_valid(pdata->gpio_power)) {
+			ret = gpio_request(pdata->gpio_power, "ak4641 power");
+			if (ret)
+				goto err_out;
+		}
+		if (gpio_is_valid(pdata->gpio_npdn)) {
+			ret = gpio_request(pdata->gpio_npdn, "ak4641 npdn");
+			if (ret)
+				goto err_gpio;
+		}
+
+		if (gpio_is_valid(pdata->gpio_power))
+			gpio_direction_output(pdata->gpio_power, 1);
+		if (gpio_is_valid(pdata->gpio_npdn)) {
+			gpio_direction_output(pdata->gpio_npdn, 0);
+			udelay(1); /* > 150 ns */
+			gpio_set_value(pdata->gpio_npdn, 1);
+		}
+	}
+
+	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_I2C);
+	if (ret != 0) {
+		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
+		goto err_register;
+	}
+
+	/* power on device */
+	ak4641_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
+	snd_soc_add_controls(codec, ak4641_snd_controls,
+				ARRAY_SIZE(ak4641_snd_controls));
+	ak4641_add_widgets(codec);
+
+	return 0;
+
+err_register:
+	if (pdata) {
+		if (gpio_is_valid(pdata->gpio_power))
+			gpio_set_value(pdata->gpio_power, 0);
+		if (gpio_is_valid(pdata->gpio_npdn))
+			gpio_free(pdata->gpio_npdn);
+	}
+err_gpio:
+	if (pdata && gpio_is_valid(pdata->gpio_power))
+		gpio_free(pdata->gpio_power);
+err_out:
+	return ret;
+}
+
+static int ak4641_remove(struct snd_soc_codec *codec)
+{
+	struct ak4641_platform_data *pdata = codec->dev->platform_data;
+
+	ak4641_set_bias_level(codec, SND_SOC_BIAS_OFF);
+
+	if (pdata) {
+		if (gpio_is_valid(pdata->gpio_power)) {
+			gpio_set_value(pdata->gpio_power, 0);
+			gpio_free(pdata->gpio_power);
+		}
+		if (gpio_is_valid(pdata->gpio_npdn))
+			gpio_free(pdata->gpio_npdn);
+	}
+	return 0;
+}
+
+
+static struct snd_soc_codec_driver soc_codec_dev_ak4641 = {
+	.probe		= ak4641_probe,
+	.remove		= ak4641_remove,
+	.suspend	= ak4641_suspend,
+	.resume		= ak4641_resume,
+	.set_bias_level	= ak4641_set_bias_level,
+	.reg_cache_size	= ARRAY_SIZE(ak4641_reg),
+	.reg_word_size	= sizeof(u8),
+	.reg_cache_default = ak4641_reg,
+	.reg_cache_step	= 1,
+};
+
+
+#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+static int __devinit ak4641_i2c_probe(struct i2c_client *i2c,
+				      const struct i2c_device_id *id)
+{
+	struct ak4641_priv *ak4641;
+	int ret;
+
+	ak4641 = kzalloc(sizeof(struct ak4641_priv), GFP_KERNEL);
+	if (!ak4641)
+		return -ENOMEM;
+
+	i2c_set_clientdata(i2c, ak4641);
+
+	ret = snd_soc_register_codec(&i2c->dev, &soc_codec_dev_ak4641,
+				ak4641_dai, ARRAY_SIZE(ak4641_dai));
+	if (ret < 0)
+		kfree(ak4641);
+
+	return ret;
+}
+
+static int __devexit ak4641_i2c_remove(struct i2c_client *i2c)
+{
+	snd_soc_unregister_codec(&i2c->dev);
+	kfree(i2c_get_clientdata(i2c));
+	return 0;
+}
+
+static const struct i2c_device_id ak4641_i2c_id[] = {
+	{ "ak4641", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, ak4641_i2c_id);
+
+static struct i2c_driver ak4641_i2c_driver = {
+	.driver = {
+		.name = "ak4641-codec",
+		.owner = THIS_MODULE,
+	},
+	.probe =    ak4641_i2c_probe,
+	.remove =   __devexit_p(ak4641_i2c_remove),
+	.id_table = ak4641_i2c_id,
+};
+#endif
+
+static int __init ak4641_modinit(void)
+{
+	int ret;
+#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+	ret = i2c_add_driver(&ak4641_i2c_driver);
+	if (ret != 0)
+		pr_err("Failed to register AK4641 I2C driver: %d\n", ret);
+#endif
+	return ret;
+}
+module_init(ak4641_modinit);
+
+static void __exit ak4641_exit(void)
+{
+#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+	i2c_del_driver(&ak4641_i2c_driver);
+#endif
+}
+module_exit(ak4641_exit);
+
+MODULE_DESCRIPTION("SoC AK4641 driver");
+MODULE_AUTHOR("Harald Welte <laforge@gnufiish.org>");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/codecs/ak4641.h b/sound/soc/codecs/ak4641.h
new file mode 100644
index 0000000..4a26324
--- /dev/null
+++ b/sound/soc/codecs/ak4641.h
@@ -0,0 +1,47 @@
+/*
+ * ak4641.h  --  AK4641 SoC Audio driver
+ *
+ * Copyright 2008 Harald Welte <laforge@gnufiish.org>
+ *
+ * Based on ak4535.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _AK4641_H
+#define _AK4641_H
+
+/* AK4641 register space */
+
+#define AK4641_PM1		0x00
+#define AK4641_PM2		0x01
+#define AK4641_SIG1		0x02
+#define AK4641_SIG2		0x03
+#define AK4641_MODE1		0x04
+#define AK4641_MODE2		0x05
+#define AK4641_DAC		0x06
+#define AK4641_MIC		0x07
+#define AK4641_TIMER		0x08
+#define AK4641_ALC1		0x09
+#define AK4641_ALC2		0x0a
+#define AK4641_PGA		0x0b
+#define AK4641_LATT		0x0c
+#define AK4641_RATT		0x0d
+#define AK4641_VOL		0x0e
+#define AK4641_STATUS		0x0f
+#define AK4641_EQLO		0x10
+#define AK4641_EQMID		0x11
+#define AK4641_EQHI		0x12
+#define AK4641_BTIF		0x13
+
+#define AK4641_CACHEREGNUM	0x14
+
+
+
+#define AK4641_DAI_HIFI		0
+#define AK4641_DAI_VOICE	1
+
+
+#endif
-- 
1.7.0.4


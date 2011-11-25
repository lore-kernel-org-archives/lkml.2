Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1KYMjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 07:39:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38189 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab1KYMjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 07:39:35 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH v2] sound/soc/codecs: add LAPIS Semiconductor ML26124
Date: Fri, 25 Nov 2011 21:39:03 +0900
Message-Id: <1322224743-15671-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ML26124-01HB/ML26124-02GD is 16bit monaural audio CODEC which has high
resistance to voltage noise. On chip regulator realizes power supply rejection
ratio (PSRR) be over 90dB so more than 50dB is improved than ever. ML26124-01HB/
ML26124-02GD can deliver stable audio performance without being affected by noise
from the power supply circuit and peripheral components. The chip also includes
a composite video signal output, which can be applied to various portable device
 requirements. The ML26124 is realized these functions into very small package
the size is only 2.56mm x 2.46mm therefore can be construct high quality sound
system easily.
ML26124-01HB is 25pin WCSP package; ML26124-02GD is 32pin WQFN package.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 sound/soc/codecs/Kconfig   |    4 +
 sound/soc/codecs/Makefile  |    2 +
 sound/soc/codecs/ml26124.c |  532 ++++++++++++++++++++++++++++++++++++++++++++
 sound/soc/codecs/ml26124.h |  123 ++++++++++
 4 files changed, 661 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/codecs/ml26124.c
 create mode 100644 sound/soc/codecs/ml26124.h

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 665d924..ce8e622 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -38,6 +38,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_MAX98095 if I2C
 	select SND_SOC_MAX9850 if I2C
 	select SND_SOC_MAX9877 if I2C
+	select SND_SOC_ML26124 if I2C
 	select SND_SOC_PCM3008
 	select SND_SOC_SGTL5000 if I2C
 	select SND_SOC_SN95031 if INTEL_SCU_IPC
@@ -211,6 +212,9 @@ config SND_SOC_MAX98095
 config SND_SOC_MAX9850
 	tristate
 
+config SND_SOC_ML26124
+	tristate
+
 config SND_SOC_PCM3008
        tristate
 
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index 5119a7e..c1353ff 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -24,6 +24,7 @@ snd-soc-l3-objs := l3.o
 snd-soc-max98088-objs := max98088.o
 snd-soc-max98095-objs := max98095.o
 snd-soc-max9850-objs := max9850.o
+snd-soc-ml26124-objs := ml26124.o
 snd-soc-pcm3008-objs := pcm3008.o
 snd-soc-sgtl5000-objs := sgtl5000.o
 snd-soc-alc5623-objs := alc5623.o
@@ -122,6 +123,7 @@ obj-$(CONFIG_SND_SOC_JZ4740_CODEC)	+= snd-soc-jz4740-codec.o
 obj-$(CONFIG_SND_SOC_MAX98088)	+= snd-soc-max98088.o
 obj-$(CONFIG_SND_SOC_MAX98095)	+= snd-soc-max98095.o
 obj-$(CONFIG_SND_SOC_MAX9850)	+= snd-soc-max9850.o
+obj-$(CONFIG_SND_SOC_ML26124)   += snd-soc-ml26124.o
 obj-$(CONFIG_SND_SOC_PCM3008)	+= snd-soc-pcm3008.o
 obj-$(CONFIG_SND_SOC_SGTL5000)  += snd-soc-sgtl5000.o
 obj-$(CONFIG_SND_SOC_SN95031)	+=snd-soc-sn95031.o
diff --git a/sound/soc/codecs/ml26124.c b/sound/soc/codecs/ml26124.c
new file mode 100644
index 0000000..56160de
--- /dev/null
+++ b/sound/soc/codecs/ml26124.c
@@ -0,0 +1,532 @@
+/*
+ * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/pm.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+#include <sound/soc-dapm.h>
+#include <sound/tlv.h>
+#include <sound/soc-dapm.h>
+
+#include "ml26124.h"
+
+struct ml26124_priv {
+	enum snd_soc_control_type control_type;
+	struct snd_pcm_substream *substream;
+	unsigned int rate;
+	unsigned int ch;
+};
+
+/* ML26124 configuration */
+static const DECLARE_TLV_DB_SCALE(rec_play_digi_vol, -7150, 50, 0);
+static const DECLARE_TLV_DB_SCALE(digi_boost_vol, -1200, 75, 0);
+static const DECLARE_TLV_DB_SCALE(eq_band_gain, -7150, 50, 0);
+static const DECLARE_TLV_DB_SCALE(alclvl, -2250, 150, 0);
+static const DECLARE_TLV_DB_SCALE(alcmingain, -1200, 600, 0);
+static const DECLARE_TLV_DB_SCALE(alcmaxgain, -675, 600, 0);
+static const DECLARE_TLV_DB_SCALE(ngth, -7650, 150, 0);
+static const DECLARE_TLV_DB_SCALE(plilv, -2250, 150, 0);
+static const DECLARE_TLV_DB_SCALE(plmingain, -1200, 600, 0);
+static const DECLARE_TLV_DB_SCALE(plmaxgain, -675, 600, 0);
+static const DECLARE_TLV_DB_SCALE(plvl, -1200, 75, 0);
+
+static const struct snd_kcontrol_new ml26124_snd_controls[] = {
+	SOC_SINGLE_TLV("Capture Digital Volume", ML26124_RECORD_DIG_VOL, 0, 0xff, 1, rec_play_digi_vol),
+	SOC_SINGLE_TLV("Playback Digital Volume", ML26124_PLBAK_DIG_VOL, 0, 0xff, 1, rec_play_digi_vol),
+	SOC_SINGLE_TLV("Digital Boost Volume",  ML26124_DIGI_BOOST_VOL, 0, 0x3f, 0, digi_boost_vol),
+	SOC_SINGLE_TLV("EQ Band0 Input Volume",  ML26124_EQ_GAIN_BRAND0, 0, 0xff, 1, eq_band_gain),
+	SOC_SINGLE_TLV("EQ Band1 Input Volume",  ML26124_EQ_GAIN_BRAND1, 0, 0xff, 1, eq_band_gain),
+	SOC_SINGLE_TLV("EQ Band2 Input Volume",  ML26124_EQ_GAIN_BRAND2, 0, 0xff, 1, eq_band_gain),
+	SOC_SINGLE_TLV("EQ Band3 Input Volume",  ML26124_EQ_GAIN_BRAND3, 0, 0xff, 1, eq_band_gain),
+	SOC_SINGLE_TLV("EQ Band4 Input Volume",  ML26124_EQ_GAIN_BRAND4, 0, 0xff, 1, eq_band_gain),
+	SOC_SINGLE_TLV("ALC Target Level",  ML26124_ALC_TARGET_LEV, 0, 0xf, 1, alclvl),
+	SOC_SINGLE_TLV("ALC Min Input Volume",  ML26124_ALC_MAXMIN_GAIN, 0, 7, 0, alcmingain),
+	SOC_SINGLE_TLV("ALC MAX Input Volume",  ML26124_ALC_MAXMIN_GAIN, 4, 7, 1, alcmaxgain),
+	SOC_SINGLE_TLV("Playback Limitter Min Input Volume",  ML26124_PL_MAXMIN_GAIN, 0, 7, 0, plmingain),
+	SOC_SINGLE_TLV("Playback Limitter Max Input Volume",  ML26124_PL_MAXMIN_GAIN, 4, 7, 1, plmaxgain),
+	SOC_SINGLE_TLV("Playback Boost Volume",  ML26124_PLYBAK_BOST_VOL, 0, 0x3f, 0, plvl),
+	SOC_SINGLE("DC High Pass Filter Switch", ML26124_FILTER_EN, 0, 1, 0),
+	SOC_SINGLE("NOISE High Pass Filter Switch", ML26124_FILTER_EN, 1, 1, 0),
+	SOC_SINGLE("EQ BAND0 Switch", ML26124_FILTER_EN, 2, 1, 0),
+	SOC_SINGLE("EQ BAND1 Switch", ML26124_FILTER_EN, 3, 1, 0),
+	SOC_SINGLE("EQ BAND2 Switch", ML26124_FILTER_EN, 4, 1, 0),
+	SOC_SINGLE("EQ BAND3 Switch", ML26124_FILTER_EN, 5, 1, 0),
+	SOC_SINGLE("EQ BAND4 Switch", ML26124_FILTER_EN, 6, 1, 0),
+
+	SOC_SINGLE("Play Limitter Switch", ML26124_FILTER_EN, 0, 1, 0),
+	SOC_SINGLE("Capture Limitter Switch", ML26124_FILTER_EN, 1, 1, 0),
+	SOC_SINGLE("Digital Volume Fade Switch", ML26124_FILTER_EN, 3, 1, 0),
+	SOC_SINGLE("Digital Volume Switch", ML26124_FILTER_EN, 4, 1, 0),
+};
+
+static const struct snd_kcontrol_new ml26124_output_mixer_controls[] = {
+	SOC_DAPM_SINGLE("DAC Switch", ML26124_SPK_AMP_OUT, 1, 1, 0),
+	SOC_DAPM_SINGLE("Line in Switch", ML26124_SPK_AMP_OUT, 3, 1, 0),
+	SOC_DAPM_SINGLE("PGA Switch", ML26124_SPK_AMP_OUT, 5, 1, 0),
+};
+
+/* Input mux */
+static const char *ml26124_input_select[] = {"Analog MIC in", "Digital MIC in"};
+
+static const struct soc_enum ml26124_insel_enum =
+	SOC_ENUM_SINGLE(ML26124_MIC_IF_CTL, 0, 1, ml26124_input_select);
+
+static const struct snd_kcontrol_new ml26124_input_mux_controls =
+SOC_DAPM_ENUM("Input Select", ml26124_insel_enum);
+
+static const struct snd_kcontrol_new ml26124_line_control =
+        SOC_DAPM_SINGLE("Switch", ML26124_PW_LOUT_PW_MNG, 1, 1, 0);
+
+static const struct snd_soc_dapm_widget ml26124_dapm_widgets[] = {
+	SND_SOC_DAPM_SUPPLY("MCLK", ML26124_CLK_EN, 0, 0, NULL, 0),
+	SND_SOC_DAPM_SUPPLY("PLL", ML26124_CLK_EN, 1, 0, NULL, 0),
+	SND_SOC_DAPM_VMID("VMID"),
+	SND_SOC_DAPM_MICBIAS("MICBIAS", ML26124_PW_REF_PW_MNG, 0, 0),
+
+	SND_SOC_DAPM_MIXER("Output Mixer", ML26124_PW_SPAMP_PW_MNG, 0x1f, 0, 
+			   &ml26124_output_mixer_controls[0],
+			   ARRAY_SIZE(ml26124_output_mixer_controls)),
+	SND_SOC_DAPM_DAC("DAC", "Playback", ML26124_PW_DAC_PW_MNG, 1, 0),
+
+	SND_SOC_DAPM_ADC("ADC", "Capture", ML26124_PW_IN_PW_MNG, 1, 0),
+	SND_SOC_DAPM_PGA("PGA", ML26124_PW_IN_PW_MNG, 3, 0, NULL, 0),
+
+	SND_SOC_DAPM_MUX("Input Mux", SND_SOC_NOPM, 0, 0,
+			  &ml26124_input_mux_controls),
+	SND_SOC_DAPM_SWITCH("Line Out Enable", SND_SOC_NOPM, 0, 0,
+			     &ml26124_line_control),
+	SND_SOC_DAPM_INPUT("VIDEOIN"),
+	SND_SOC_DAPM_INPUT("MDIN"),
+	SND_SOC_DAPM_INPUT("MIN"),
+	SND_SOC_DAPM_INPUT("LIN"),
+	SND_SOC_DAPM_OUTPUT("VIDEOOUT"),
+	SND_SOC_DAPM_OUTPUT("SPOUT"),
+	SND_SOC_DAPM_OUTPUT("LOUT"),
+};
+
+static const struct snd_soc_dapm_route intercon[] = {
+	/* output mixer */
+	{"Output Mixer", "PGA Switch", "PGA"},
+	{"Output Mixer", "DAC Switch", "DAC"},
+	{"Output Mixer", NULL, "Line in Switch"},
+	/* outputs */
+	{"SPOUT", NULL, "Output Mixer"},
+	{"LOUT", NULL, "Output Mixer"},
+	{"SPOUT", NULL, "Output Mixer"},
+
+	/* input mux */
+	{"Input Mux", "Analog MIC in", "MICBIAS"},
+	{"Input Mux", "Digital MIC in", "MICBIAS"},
+	{"ADC", NULL, "Input Mux"},
+
+	/* inputs */
+	{"DAC", NULL, "MDIN"},
+	{"PGA", NULL, "MIN"},
+	{"SPOUT", NULL, "LIN"},
+};
+
+static int ml26124_snd_card_codec_set(int number, struct ml26124_priv *priv,
+				      struct snd_soc_codec *codec)
+{
+	unsigned char data;
+	unsigned int rate = priv->rate;
+	unsigned int channels = priv->ch;
+
+	data = snd_soc_read(codec, ML26124_PW_MICBIAS_VOL);
+	snd_soc_update_bits(codec, ML26124_SW_RST, 0x01, 1);	/* soft reset assert */
+	snd_soc_update_bits(codec, ML26124_SW_RST, 0x01, 0);	/* soft reset negate */
+
+	snd_soc_update_bits(codec, 0x0c, 0x1f, 0);	/* Stop clock  */
+
+	switch (rate) {
+	case 16000:
+		snd_soc_update_bits(codec, ML26124_SMPLING_RATE, 0xf, 3);
+		snd_soc_update_bits(codec, ML26124_PLLNL, 0xff, 0x0c);
+		snd_soc_update_bits(codec, ML26124_PLLNH, 0x1, 0);
+		snd_soc_update_bits(codec, ML26124_PLLML, 0xff, 0x20);
+		snd_soc_update_bits(codec, ML26124_PLLMH, 0x3f, 0x00);
+		snd_soc_update_bits(codec, ML26124_PLLDIV, 0x1f, 0x04);
+		break;
+	case 32000:
+		snd_soc_update_bits(codec, ML26124_SMPLING_RATE, 0xf, 6);
+		snd_soc_update_bits(codec, ML26124_PLLNL, 0xff, 0x0c);
+		snd_soc_update_bits(codec, ML26124_PLLNH, 0x1, 0);
+		snd_soc_update_bits(codec, ML26124_PLLML, 0xff, 0x20);
+		snd_soc_update_bits(codec, ML26124_PLLMH, 0x3f, 0x00);
+		snd_soc_update_bits(codec, ML26124_PLLDIV, 0x1f, 0x04);
+		break;
+	case 48000:
+		snd_soc_update_bits(codec, ML26124_SMPLING_RATE, 0xf, 0x08);
+		snd_soc_update_bits(codec, ML26124_PLLNL, 0xff, 0x0c);
+		snd_soc_update_bits(codec, ML26124_PLLNH, 0x1, 0x00);
+		snd_soc_update_bits(codec, ML26124_PLLML, 0xff, 0x30);
+		snd_soc_update_bits(codec, ML26124_PLLMH, 0x3f, 0x00);
+		snd_soc_update_bits(codec, ML26124_PLLDIV, 0x1f, 0x04);
+		break;
+	default:
+		pr_err("%s:this rate is no support for ml26124\n", __func__);
+		return -EINVAL;
+	}
+
+	snd_soc_update_bits(codec, ML26124_CLK_EN, 0x3, 3); /* Start MCLK and PLL */
+	msleep(20);
+	snd_soc_update_bits(codec, ML26124_CLK_EN, 0x0f, 0xf); /* Clock control: MCLKI use */
+	snd_soc_update_bits(codec, ML26124_CLK_CTL, 0x7, 4);
+
+	if (channels == 1) {
+		snd_soc_update_bits(codec, ML26124_SAI_TRANS_CTL, 0xff, 0x23); /* SAI transmitter control */
+					/* 0x23 : FMTO=1, H=Left L=Right, no-delay*/
+		snd_soc_update_bits(codec, ML26124_SAI_RCV_CTL, 0xff, 0x23);  /* Receive side SAI control */
+	} else {
+		snd_soc_update_bits(codec, ML26124_SAI_TRANS_CTL, 0xff, 0x00);
+		snd_soc_update_bits(codec, ML26124_SAI_RCV_CTL, 0xff, 0x00);
+	}
+
+	snd_soc_update_bits(codec, ML26124_PW_REF_PW_MNG, 0x3, 0x06); /* Analog REference Power Managemet */
+	snd_soc_update_bits(codec, ML26124_PW_IN_PW_MNG, 0xa, 0x0a); /* Analog Input Power Management */
+	snd_soc_update_bits(codec, ML26124_PW_DAC_PW_MNG, 0x2, 0x02); /* DAC power Management */
+
+	snd_soc_update_bits(codec, ML26124_REC_PLYBAK_RUN, 0x17, 0x01); /* Record/Playback Running Control Register */
+	snd_soc_update_bits(codec, ML26124_REC_PLYBAK_RUN, 0x17, 0x03);
+	msleep(20);
+	snd_soc_update_bits(codec, ML26124_FILTER_EN, 0xff, 0x03); /* DSP filter function Enable */
+
+	snd_soc_update_bits(codec, ML26124_PW_SPK_AMP_VOL, 0x3f, 0x27); /* Speaker Amplifier Volume Control */
+	snd_soc_update_bits(codec, ML26124_PW_MIC_IN_VOL, 0x3f, 0x20); /* Mic Input Volume Control */
+
+	return 0;
+}
+
+static int ml26124_hw_params(struct snd_pcm_substream *substream,
+			    struct snd_pcm_hw_params *hw_params,
+			    struct snd_soc_dai *dai)
+{
+	struct snd_soc_codec *codec = dai->codec;
+	struct ml26124_priv *priv = snd_soc_codec_get_drvdata(codec);
+
+	int ret = ml26124_snd_card_codec_set(substream->number, priv, codec);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int ml26124_snd_card_codec_free(int number, struct ml26124_priv *priv,
+				       struct snd_soc_codec *codec)
+{
+	snd_soc_update_bits(codec, ML26124_SW_RST, 0x01, 1);	/* soft reset assert */
+
+	return 0;
+}
+
+static int snd_card_ml7213i2s_hw_free(struct snd_pcm_substream *substream,
+				      struct snd_soc_dai *dai)
+{
+	struct ml26124_priv *priv = substream->runtime->private_data;
+	struct snd_soc_codec *codec = dai->codec;
+
+	if (ml26124_snd_card_codec_free(substream->number, priv, codec))
+			return -1;
+
+	return snd_pcm_lib_free_pages(substream);
+}
+
+static void ml26124_shutdown(struct snd_pcm_substream *substream,
+			    struct snd_soc_dai *dai)
+{
+}
+
+#define DVOL_CTL_DVMUTE_ON		BIT(4)	/* Digital volume MUTE On */
+#define DVOL_CTL_DVMUTE_OFF		0	/* Digital volume MUTE Off */
+
+static int ml26124_mute(struct snd_soc_dai *dai, int mute)
+{
+	struct snd_soc_codec *codec = dai->codec;
+
+	if (mute)
+		snd_soc_update_bits(codec, ML26124_DVOL_CTL, BIT(4),
+					 DVOL_CTL_DVMUTE_ON);
+	else
+		snd_soc_update_bits(codec, ML26124_DVOL_CTL, BIT(4),
+					 DVOL_CTL_DVMUTE_OFF);
+	return 0;
+}
+
+static int ml26124_set_dai_fmt(struct snd_soc_dai *codec_dai,
+		unsigned int fmt)
+{
+	struct snd_soc_codec *codec = codec_dai->codec;
+	unsigned char mode;
+
+	/* set master/slave audio interface */
+	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
+	case SND_SOC_DAIFMT_CBM_CFM:
+		mode = 1;
+		break;
+	case SND_SOC_DAIFMT_CBS_CFS:
+		mode = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+	snd_soc_update_bits(codec, ML26124_SAI_MODE_SEL, BIT(0), mode);
+
+	/* interface format */
+	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_I2S:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* clock inversion */
+	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
+	case SND_SOC_DAIFMT_NB_NF:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+#define REF_PM_MICBEN	BIT(2)	/* MIC BIAS Enable */
+#define REF_PM_LOBIAS	BIT(6)	/* LOUT terminal BIAS Enable (1/2REGOUT) */
+#define REF_PM_VMID_ON	BIT(1)	/* VMID generation circuit ON */
+#define REF_PM_VMID_ON_FAST	BIT(0) /* VMID generation circuit Fast mode ON */
+#define REF_PM_VMID_OFF	0	/* VMID generation circuit OFF */
+
+#define ML26134_CACHESIZE 79
+static const u16 ml26124_reg[ML26134_CACHESIZE] = {
+	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
+	0x0, 0x0, 0x0, 				/* System Control */
+	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,	/* Power Management */
+	0x4,					/* Analog Reference Control */
+	0x10, 0x0, 0x33, 0x0, 0x0,	/* Input/Output Amplifier Control */
+	0x0, 0x0, 0x1,				/* Analog Path Contorl */
+	0x0, 0x0, 0x0,				/* Audio Interface Control */
+	0x1, 0x0, 0x0, 0xff, 0xff, 0x10,	/* DSP Control */
+	0x7, 0x7, 0x7, 0x7, 0x7,		/* DSP Control */
+	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,	/* DSP Control */
+	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,	/* DSP Control */
+	0x0, 0x0, 0x0,
+	0x0, 0x2, 0x3, 0x0, 0xb, 0x70, 0x0, 0x0,	/* ALC Control*/
+	0x4, 0x5, 0xd, 0x70, 0x10, 0x0,		/* Playback Limiter Control */
+	0x1, 0x1, 0x1				/* Video Amplifer Control */
+};
+
+#define ML26124_MICBEN	BIT(2)
+#define ML26124_VMID	BIT(0) | BIT(1)
+
+static int ml26124_set_bias_level(struct snd_soc_codec *codec,
+		enum snd_soc_bias_level level)
+{
+	u8 reg;
+	switch (level) {
+	case SND_SOC_BIAS_ON:
+		/* MICBIAS/VMID ON */
+		reg = snd_soc_read(codec, ML26124_PW_REF_PW_MNG) & 0x47;
+		reg |= ML26124_MICBEN | ML26124_VMID;
+		snd_soc_write(codec, ML26124_PW_REF_PW_MNG, reg);
+	case SND_SOC_BIAS_PREPARE:
+		break;
+	case SND_SOC_BIAS_STANDBY:
+		/* MICBIAS OFF */
+		reg = snd_soc_read(codec, ML26124_PW_REF_PW_MNG) & 0x47;
+		reg &= ~ML26124_MICBEN;
+		snd_soc_write(codec, ML26124_PW_REF_PW_MNG, reg);
+		break;
+	case SND_SOC_BIAS_OFF:
+		/* MICBIAS/VMID OFF */
+		reg = snd_soc_read(codec, ML26124_PW_REF_PW_MNG) & 0x47;
+		reg &= ~(ML26124_MICBEN | ML26124_VMID);
+		snd_soc_write(codec, ML26124_PW_REF_PW_MNG, reg);
+		break;
+	}
+	codec->dapm.bias_level = level;
+	return 0;
+}
+
+#define ML26124_RATES SNDRV_PCM_RATE_8000_96000
+
+#define ML26124_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S20_3LE |\
+	SNDRV_PCM_FMTBIT_S24_LE)
+
+static struct snd_soc_dai_ops ml26124_dai_ops = {
+	.hw_params	= ml26124_hw_params,
+	.hw_free	= snd_card_ml7213i2s_hw_free,
+	.shutdown	= ml26124_shutdown,
+	.digital_mute	= ml26124_mute,
+	.set_fmt	= ml26124_set_dai_fmt,
+};
+
+struct snd_soc_dai_driver ml26124_dai = {
+	.name = "ml26124-hifi",
+	.playback = {
+		.stream_name = "Playback",
+		.channels_min = 1,
+		.channels_max = 2,
+		.rates = ML26124_RATES,
+		.formats = ML26124_FORMATS,},
+	.capture = {
+		.stream_name = "Capture",
+		.channels_min = 1,
+		.channels_max = 2,
+		.rates = ML26124_RATES,
+		.formats = ML26124_FORMATS,},
+	.ops = &ml26124_dai_ops,
+	.symmetric_rates = 1,
+};
+
+#ifdef CONFIG_PM
+static int ml26124_suspend(struct snd_soc_codec *codec, pm_message_t state)
+{
+	ml26124_set_bias_level(codec, SND_SOC_BIAS_OFF);
+
+	return 0;
+}
+
+static int ml26124_resume(struct snd_soc_codec *codec)
+{
+	ml26124_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
+
+	return 0;
+}
+#else
+#define ml26124_suspend NULL
+#define ml26124_resume NULL
+#endif
+
+static int ml26124_probe(struct snd_soc_codec *codec)
+{
+	int ret;
+	struct ml26124_priv *priv = snd_soc_codec_get_drvdata(codec);
+	struct snd_soc_dapm_context *dapm = &codec->dapm;
+
+	ret = snd_soc_codec_set_cache_io(codec, 7, 8, priv->control_type);
+	if (ret < 0) {
+		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
+		return ret;
+	}
+
+	/* Software Reset */
+	snd_soc_update_bits(codec, ML26124_SW_RST, 0x01, 1);
+	snd_soc_update_bits(codec, ML26124_SW_RST, 0x01, 0);
+
+	ml26124_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
+
+	snd_soc_add_controls(codec, ml26124_snd_controls,
+			     ARRAY_SIZE(ml26124_snd_controls));
+
+	snd_soc_dapm_new_controls(dapm, ml26124_dapm_widgets,
+				  ARRAY_SIZE(ml26124_dapm_widgets));
+
+	return 0;
+}
+
+/* power down chip */
+static int ml26124_remove(struct snd_soc_codec *codec)
+{
+	return 0;
+}
+#define REG_CACHE_SIZE		0x79
+static struct snd_soc_codec_driver soc_codec_dev_ml26124 = {
+	.probe =	ml26124_probe,
+	.remove =	ml26124_remove,
+	.suspend =	ml26124_suspend,
+	.resume =	ml26124_resume,
+	.set_bias_level = ml26124_set_bias_level,
+	.reg_cache_size = REG_CACHE_SIZE,
+	.reg_word_size = sizeof(u8),
+	.reg_cache_default = ml26124_reg,
+};
+
+static __devinit int ml26124_i2c_probe(struct i2c_client *i2c,
+				      const struct i2c_device_id *id)
+{
+	struct ml26124_priv *priv;
+	int ret;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (priv == NULL)
+		return -ENOMEM;
+
+	i2c_set_clientdata(i2c, priv);
+	priv->control_type = SND_SOC_I2C;
+
+	ret =  snd_soc_register_codec(&i2c->dev,
+			&soc_codec_dev_ml26124, &ml26124_dai, 1);
+	if (ret < 0)
+		kfree(priv);
+
+	return ret;
+}
+
+static __devexit int ml26124_i2c_remove(struct i2c_client *client)
+{
+	snd_soc_unregister_codec(&client->dev);
+	kfree(i2c_get_clientdata(client));
+	return 0;
+}
+
+static const struct i2c_device_id ml26124_i2c_id[] = {
+	{ "ml26124", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, ml26124_i2c_id);
+
+static struct i2c_driver ml26124_i2c_driver = {
+	.driver = {
+		.name = "ml26124",
+		.owner = THIS_MODULE,
+	},
+	.probe =    ml26124_i2c_probe,
+	.remove =   __devexit_p(ml26124_i2c_remove),
+	.id_table = ml26124_i2c_id,
+};
+
+static int __init ml26124_modinit(void)
+{
+	int ret = 0;
+
+	ret = i2c_add_driver(&ml26124_i2c_driver);
+	if (ret != 0) {
+		pr_err("Failed to register ML26124 I2C driver: %d\n", ret);
+	}
+
+	return ret;
+}
+module_init(ml26124_modinit);
+
+static void __exit ml26124_exit(void)
+{
+	i2c_del_driver(&ml26124_i2c_driver);
+}
+module_exit(ml26124_exit);
+
+MODULE_AUTHOR("Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>");
+MODULE_DESCRIPTION("LAPIS Semiconductor ML26124 ALSA SoC codec driver");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/codecs/ml26124.h b/sound/soc/codecs/ml26124.h
new file mode 100644
index 0000000..f295701
--- /dev/null
+++ b/sound/soc/codecs/ml26124.h
@@ -0,0 +1,123 @@
+/*
+ * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+#ifndef ML26124_H
+#define ML26124_H
+
+/* Clock Control Register */
+#define ML26124_SMPLING_RATE		0x00
+#define ML26124_PLLNL			0x02
+#define ML26124_PLLNH			0x04
+#define ML26124_PLLML			0x06
+#define ML26124_PLLMH			0x08
+#define ML26124_PLLDIV			0x0a
+#define ML26124_CLK_EN			0x0c
+#define ML26124_CLK_CTL			0x0e
+
+/* System Control Register */
+#define ML26124_SW_RST			0x10
+#define ML26124_REC_PLYBAK_RUN		0x12
+#define ML26124_MIC_TIM			0x14
+
+/* Power Mnagement Register */
+#define ML26124_PW_REF_PW_MNG		0x20
+#define ML26124_PW_IN_PW_MNG		0x22
+#define ML26124_PW_DAC_PW_MNG		0x24
+#define ML26124_PW_SPAMP_PW_MNG		0x26
+#define ML26124_PW_LOUT_PW_MNG		0x28
+#define ML26124_PW_VOUT_PW_MNG		0x2a
+#define ML26124_PW_ZCCMP_PW_MNG		0x2e
+
+/* Analog Reference Control Register */
+#define ML26124_PW_MICBIAS_VOL		0x30
+
+/* Input/Output Amplifier Control Register */
+#define ML26124_PW_MIC_IN_VOL		0x32
+#define ML26124_PW_MIC_BOST_VOL		0x38
+#define ML26124_PW_SPK_AMP_VOL		0x3a
+#define ML26124_PW_AMP_VOL_FUNC		0x48
+#define ML26124_PW_AMP_VOL_FADE		0x4a
+
+/* Analog Path Control Register */
+#define ML26124_SPK_AMP_OUT		0x54
+#define ML26124_MIC_IF_CTL		0x5a
+#define ML26124_MIC_SELECT		0xe8
+//#define ML26124_CTL			0x
+
+/* Audio Interface Control Register */
+#define ML26124_SAI_TRANS_CTL		0x60
+#define ML26124_SAI_RCV_CTL		0x62
+#define ML26124_SAI_MODE_SEL		0x64
+
+/* DSP Control Register */
+#define ML26124_FILTER_EN		0x66
+#define ML26124_DVOL_CTL		0x68
+#define ML26124_MIXER_VOL_CTL		0x6a
+#define ML26124_RECORD_DIG_VOL		0x6c
+#define ML26124_PLBAK_DIG_VOL		0x70
+#define ML26124_DIGI_BOOST_VOL		0x72
+#define ML26124_EQ_GAIN_BRAND0		0x74
+#define ML26124_EQ_GAIN_BRAND1		0x76
+#define ML26124_EQ_GAIN_BRAND2		0x78
+#define ML26124_EQ_GAIN_BRAND3		0x7a
+#define ML26124_EQ_GAIN_BRAND4		0x7c
+#define ML26124_HPF2_CUTOFF		0x7e
+#define ML26124_EQBRAND0_F0L		0x80
+#define ML26124_EQBRAND0_F0H		0x82
+#define ML26124_EQBRAND0_F1L		0x84
+#define ML26124_EQBRAND0_F1H		0x86
+#define ML26124_EQBRAND1_F0L		0x88
+#define ML26124_EQBRAND1_F0H		0x8a
+#define ML26124_EQBRAND1_F1L		0x8c
+#define ML26124_EQBRAND1_F1H		0x8e
+#define ML26124_EQBRAND2_F0L		0x90
+#define ML26124_EQBRAND2_F0H		0x92
+#define ML26124_EQBRAND2_F1L		0x94
+#define ML26124_EQBRAND2_F1H		0x96
+#define ML26124_EQBRAND3_F0L		0x98
+#define ML26124_EQBRAND3_F0H		0x9a
+#define ML26124_EQBRAND3_F1L		0x9c
+#define ML26124_EQBRAND3_F1H		0x9e
+#define ML26124_EQBRAND4_F0L		0xa0
+#define ML26124_EQBRAND4_F0H		0xa2
+#define ML26124_EQBRAND4_F1L		0xa4
+#define ML26124_EQBRAND4_F1H		0xa6
+
+/* ALC Control Register */
+#define ML26124_ALC_MODE		0xb0
+#define ML26124_ALC_ATTACK_TIM		0xb2
+#define ML26124_ALC_DECAY_TIM		0xb4
+#define ML26124_ALC_HOLD_TIM		0xb6
+#define ML26124_ALC_TARGET_LEV		0xb8
+#define ML26124_ALC_MAXMIN_GAIN		0xba
+#define ML26124_NOIS_GATE_THRSH		0xbc
+#define ML26124_ALC_ZERO_TIMOUT		0xbe
+
+/* Playback Limiter Control Register */
+#define ML26124_PL_ATTACKTIME		0xc0
+#define ML26124_PL_DECAYTIME		0xc2
+#define ML26124_PL_TARGETTIME		0xc4
+#define ML26124_PL_MAXMIN_GAIN		0xc6
+#define ML26124_PLYBAK_BOST_VOL		0xc8
+#define ML26124_PL_0CROSS_TIMOUT	0xca
+
+/* Video Amplifer Control Register */
+#define ML26124_VIDEO_AMP_GAIN_CTL	0xd0
+#define ML26124_VIDEO_AMP_SETUP1	0xd2
+#define ML26124_VIDEO_AMP_CTL2		0xd4
+
+#endif
-- 
1.7.4.4


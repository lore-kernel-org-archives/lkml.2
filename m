Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab2BWFrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 00:47:40 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55837 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab2BWFri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 00:47:38 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of tomoya.rohm@gmail.com designates 10.68.193.136 as permitted sender) smtp.mail=tomoya.rohm@gmail.com; dkim=pass header.i=tomoya.rohm@gmail.com
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH v6] sound/soc/codecs: add LAPIS Semiconductor ML26124
Date: Thu, 23 Feb 2012 14:46:49 +0900
Message-Id: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ML26124-01HB/ML26124-02GD is 16bit monaural audio CODEC which has high
resistance to voltage noise. On chip regulator realizes power supply rejection
ratio be over 90dB so more than 50dB is improved than ever. ML26124-01HB/
ML26124-02GD can deliver stable audio performance without being affected by noise
from the power supply circuit and peripheral components. The chip also includes
a composite video signal output, which can be applied to various portable device
 requirements. The ML26124 is realized these functions into very small package
the size is only 2.56mm x 2.46mm therefore can be construct high quality sound
system easily.
ML26124-01HB is 25pin WCSP package; ML26124-02GD is 32pin WQFN package.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
V6
 - Add break at "case SND_SOC_BIAS_ON:"
 - Use switch() statement
 - Delete ASoC cache code.
---
 sound/soc/codecs/Kconfig   |    4 +
 sound/soc/codecs/Makefile  |    2 +
 sound/soc/codecs/ml26124.c |  742 ++++++++++++++++++++++++++++++++++++++++++++
 sound/soc/codecs/ml26124.h |  132 ++++++++
 4 files changed, 880 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/codecs/ml26124.c
 create mode 100644 sound/soc/codecs/ml26124.h

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index fa787d4..321ea08 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -39,6 +39,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_MAX98095 if I2C
 	select SND_SOC_MAX9850 if I2C
 	select SND_SOC_MAX9877 if I2C
+	select SND_SOC_ML26124 if I2C
 	select SND_SOC_PCM3008
 	select SND_SOC_RT5631 if I2C
 	select SND_SOC_SGTL5000 if I2C
@@ -411,6 +412,9 @@ config SND_SOC_LM4857
 config SND_SOC_MAX9877
 	tristate
 
+config SND_SOC_ML26124
+	tristate
+
 config SND_SOC_TPA6130A2
 	tristate
 
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index a2c7842..b28f48e 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -25,6 +25,7 @@ snd-soc-l3-objs := l3.o
 snd-soc-max98088-objs := max98088.o
 snd-soc-max98095-objs := max98095.o
 snd-soc-max9850-objs := max9850.o
+snd-soc-ml26124-objs := ml26124.o
 snd-soc-pcm3008-objs := pcm3008.o
 snd-soc-rt5631-objs := rt5631.o
 snd-soc-sgtl5000-objs := sgtl5000.o
@@ -126,6 +127,7 @@ obj-$(CONFIG_SND_SOC_JZ4740_CODEC)	+= snd-soc-jz4740-codec.o
 obj-$(CONFIG_SND_SOC_MAX98088)	+= snd-soc-max98088.o
 obj-$(CONFIG_SND_SOC_MAX98095)	+= snd-soc-max98095.o
 obj-$(CONFIG_SND_SOC_MAX9850)	+= snd-soc-max9850.o
+obj-$(CONFIG_SND_SOC_ML26124)	+= snd-soc-ml26124.o
 obj-$(CONFIG_SND_SOC_PCM3008)	+= snd-soc-pcm3008.o
 obj-$(CONFIG_SND_SOC_RT5631)	+= snd-soc-rt5631.o
 obj-$(CONFIG_SND_SOC_SGTL5000)  += snd-soc-sgtl5000.o
diff --git a/sound/soc/codecs/ml26124.c b/sound/soc/codecs/ml26124.c
new file mode 100644
index 0000000..058b831
--- /dev/null
+++ b/sound/soc/codecs/ml26124.c
@@ -0,0 +1,742 @@
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
+#include <linux/regmap.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+#include <sound/tlv.h>
+#include "ml26124.h"
+
+#define DVOL_CTL_DVMUTE_ON		BIT(4)	/* Digital volume MUTE On */
+#define DVOL_CTL_DVMUTE_OFF		0	/* Digital volume MUTE Off */
+#define ML26124_SAI_NO_DELAY	BIT(1)
+#define ML26124_SAI_FRAME_SYNC	(BIT(5) | BIT(0)) /* For mono (Telecodec) */
+#define ML26134_CACHESIZE 79
+#define ML26124_VMID	BIT(0)
+#define ML26124_RATES (SNDRV_PCM_RATE_16000 | SNDRV_PCM_RATE_32000 |\
+		       SNDRV_PCM_RATE_48000)
+#define ML26124_FORMATS SNDRV_PCM_FMTBIT_S16_LE
+#define ML26124_NUM_REGISTER ML26134_CACHESIZE
+
+struct ml26124_priv {
+	u32 mclk;
+	u32 channels;
+	struct regmap *regmap;
+};
+
+struct clk_coeff {
+	u32 mclk;
+	u32 rate;
+	u8 pllnl;
+	u8 pllnh;
+	u8 pllml;
+	u8 pllmh;
+	u8 plldiv;
+};
+
+/* ML26124 configuration */
+static const DECLARE_TLV_DB_SCALE(digital_tlv, -7150, 50, 0);
+
+static const DECLARE_TLV_DB_SCALE(alclvl, -2250, 150, 0);
+static const DECLARE_TLV_DB_SCALE(mingain, -1200, 600, 0);
+static const DECLARE_TLV_DB_SCALE(maxgain, -675, 600, 0);
+static const DECLARE_TLV_DB_SCALE(boost_vol, -1200, 75, 0);
+static const DECLARE_TLV_DB_SCALE(ngth, -7650, 150, 0);
+
+static const char * const ml26124_companding[] = {"16bit PCM", "u-law",
+						  "A-law"};
+
+static const struct soc_enum ml26124_adc_companding_enum
+	= SOC_ENUM_SINGLE(ML26124_SAI_TRANS_CTL, 6, 3, ml26124_companding);
+
+static const struct soc_enum ml26124_dac_companding_enum
+	= SOC_ENUM_SINGLE(ML26124_SAI_RCV_CTL, 6, 3, ml26124_companding);
+
+static const struct snd_kcontrol_new ml26124_snd_controls[] = {
+	SOC_SINGLE_TLV("Capture Digital Volume", ML26124_RECORD_DIG_VOL, 0,
+			0xff, 1, digital_tlv),
+	SOC_SINGLE_TLV("Playback Digital Volume", ML26124_PLBAK_DIG_VOL, 0,
+			0xff, 1, digital_tlv),
+	SOC_SINGLE_TLV("Digital Boost Volume", ML26124_DIGI_BOOST_VOL, 0,
+			0x3f, 0, boost_vol),
+	SOC_SINGLE_TLV("EQ Band0 Volume", ML26124_EQ_GAIN_BRAND0, 0,
+			0xff, 1, digital_tlv),
+	SOC_SINGLE_TLV("EQ Band1 Volume", ML26124_EQ_GAIN_BRAND1, 0,
+			0xff, 1, digital_tlv),
+	SOC_SINGLE_TLV("EQ Band2 Volume", ML26124_EQ_GAIN_BRAND2, 0,
+			0xff, 1, digital_tlv),
+	SOC_SINGLE_TLV("EQ Band3 Volume", ML26124_EQ_GAIN_BRAND3, 0,
+			0xff, 1, digital_tlv),
+	SOC_SINGLE_TLV("EQ Band4 Volume", ML26124_EQ_GAIN_BRAND4, 0,
+			0xff, 1, digital_tlv),
+	SOC_SINGLE_TLV("ALC Target Level", ML26124_ALC_TARGET_LEV, 0,
+			0xf, 1, alclvl),
+	SOC_SINGLE_TLV("ALC Min Input Volume", ML26124_ALC_MAXMIN_GAIN, 0,
+			7, 0, mingain),
+	SOC_SINGLE_TLV("ALC Max Input Volume", ML26124_ALC_MAXMIN_GAIN, 4,
+			7, 1, maxgain),
+	SOC_SINGLE_TLV("Playback Limitter Min Input Volume",
+			ML26124_PL_MAXMIN_GAIN, 0, 7, 0, mingain),
+	SOC_SINGLE_TLV("Playback Limitter Max Input Volume",
+			ML26124_PL_MAXMIN_GAIN, 4, 7, 1, maxgain),
+	SOC_SINGLE_TLV("Playback Boost Volume", ML26124_PLYBAK_BOST_VOL, 0,
+			0x3f, 0, boost_vol),
+	SOC_SINGLE("DC High Pass Filter Switch", ML26124_FILTER_EN, 0, 1, 0),
+	SOC_SINGLE("Noise High Pass Filter Switch", ML26124_FILTER_EN, 1, 1, 0),
+	SOC_SINGLE("Zero Cross Comparator Switch", ML26124_PW_ZCCMP_PW_MNG, 1,
+		    1, 0),
+	SOC_SINGLE("EQ Band0 Switch", ML26124_FILTER_EN, 2, 1, 0),
+	SOC_SINGLE("EQ Band1 Switch", ML26124_FILTER_EN, 3, 1, 0),
+	SOC_SINGLE("EQ Band2 Switch", ML26124_FILTER_EN, 4, 1, 0),
+	SOC_SINGLE("EQ Band3 Switch", ML26124_FILTER_EN, 5, 1, 0),
+	SOC_SINGLE("EQ Band4 Switch", ML26124_FILTER_EN, 6, 1, 0),
+	SOC_SINGLE("Play Limitter", ML26124_DVOL_CTL, 0, 1, 0),
+	SOC_SINGLE("Capture Limitter", ML26124_DVOL_CTL, 1, 1, 0),
+	SOC_SINGLE("Digital Volume Fade Switch", ML26124_DVOL_CTL, 3, 1, 0),
+	SOC_SINGLE("Digital Switch", ML26124_DVOL_CTL, 4, 1, 0),
+	SOC_ENUM("DAC Companding", ml26124_dac_companding_enum),
+	SOC_ENUM("ADC Companding", ml26124_adc_companding_enum),
+};
+
+static const struct snd_kcontrol_new ml26124_output_mixer_controls[] = {
+	SOC_DAPM_SINGLE("DAC Switch", ML26124_SPK_AMP_OUT, 1, 1, 0),
+	SOC_DAPM_SINGLE("Line in Switch", ML26124_SPK_AMP_OUT, 3, 1, 0),
+	SOC_DAPM_SINGLE("PGA Switch", ML26124_SPK_AMP_OUT, 5, 1, 0),
+};
+
+/* Input mux */
+static const char * const ml26124_input_select[] = {"Analog MIC SingleEnded in",
+						"Analog MIC Differential in",
+						"Digital MIC in"};
+
+static const struct soc_enum ml26124_insel_enum =
+	SOC_ENUM_SINGLE(ML26124_MIC_IF_CTL, 0, 2, ml26124_input_select);
+
+static const struct snd_kcontrol_new ml26124_input_mux_controls =
+	SOC_DAPM_ENUM("Input Select", ml26124_insel_enum);
+
+static const struct snd_kcontrol_new ml26124_line_control =
+	SOC_DAPM_SINGLE("Switch", ML26124_PW_LOUT_PW_MNG, 1, 1, 0);
+
+static const struct snd_soc_dapm_widget ml26124_dapm_widgets[] = {
+	SND_SOC_DAPM_SUPPLY("MCLK", ML26124_CLK_EN, 0, 0, NULL, 0),
+	SND_SOC_DAPM_SUPPLY("PLL", ML26124_CLK_EN, 1, 0, NULL, 0),
+	SND_SOC_DAPM_SUPPLY("MICBIAS", ML26124_PW_REF_PW_MNG, 2, 0, NULL, 0),
+	SND_SOC_DAPM_MIXER("Output Mixer", ML26124_PW_SPAMP_PW_MNG, 0, 0,
+			   &ml26124_output_mixer_controls[0],
+			   ARRAY_SIZE(ml26124_output_mixer_controls)),
+	SND_SOC_DAPM_DAC("DAC", "Playback", ML26124_PW_DAC_PW_MNG, 1, 0),
+	SND_SOC_DAPM_ADC("ADC", "Capture", ML26124_PW_IN_PW_MNG, 1, 0),
+	SND_SOC_DAPM_PGA("PGA", ML26124_PW_IN_PW_MNG, 3, 0, NULL, 0),
+	SND_SOC_DAPM_MUX("Input Mux", SND_SOC_NOPM, 0, 0,
+			  &ml26124_input_mux_controls),
+	SND_SOC_DAPM_SWITCH("Line Out Enable", SND_SOC_NOPM, 0, 0,
+			     &ml26124_line_control),
+	SND_SOC_DAPM_INPUT("MDIN"),
+	SND_SOC_DAPM_INPUT("MIN"),
+	SND_SOC_DAPM_INPUT("LIN"),
+	SND_SOC_DAPM_OUTPUT("SPOUT"),
+	SND_SOC_DAPM_OUTPUT("LOUT"),
+};
+
+static const struct snd_soc_dapm_route ml26124_intercon[] = {
+	/* Supply */
+	{"DAC", NULL, "MCLK"},
+	{"ADC", NULL, "MCLK"},
+	{"DAC", NULL, "PLL"},
+	{"ADC", NULL, "PLL"},
+
+	/* output mixer */
+	{"Output Mixer", "PGA Switch", "PGA"},
+	{"Output Mixer", "DAC Switch", "DAC"},
+	{"Output Mixer", "Line in Switch", "LIN"},
+
+	/* outputs */
+	{"LOUT", NULL, "Output Mixer"},
+	{"SPOUT", NULL, "Output Mixer"},
+
+	/* input */
+	{"Input Mux", "Analog MIC SingleEnded in", "MIN"},
+	{"Input Mux", "Analog MIC Differential in", "MIN"},
+	{"ADC", NULL, "Input Mux"},
+};
+
+/* PLLOutputFreq(Hz) = InputMclkFreq(Hz) * PLLM / (PLLN * PLLDIV) */
+static const struct clk_coeff coeff_div[] = {
+	{12288800, 16000, 0xc, 0x0, 0x20, 0x0, 0x4},
+	{12288800, 32000, 0xc, 0x0, 0x20, 0x0, 0x4},
+	{12288800, 48000, 0xc, 0x0, 0x30, 0x0, 0x4},
+};
+
+static struct reg_default ml26124_reg[] = {
+	/* CLOCK control Register */
+	{0x00, 0x00 },	/* Sampling Rate */
+	{0x02, 0x00},	/* PLL NL */
+	{0x04, 0x00},	/* PLLNH */
+	{0x06, 0x00},	/* PLLML */
+	{0x08, 0x00},	/* MLLMH */
+	{0x0a, 0x00},	/* PLLDIV */
+	{0x0c, 0x00},	/* Clock Enable */
+	{0x0e, 0x00},	/* CLK Input/Output Control */
+
+	/* System Control Register */
+	{0x10, 0x00},	/* Software RESET */
+	{0x12, 0x00},	/* Record/Playback Run */
+	{0x14, 0x00},	/* Mic Input/Output control */
+
+	/* Power Management Register */
+	{0x20, 0x00},	/* Reference Power Management */
+	{0x22, 0x00},	/* Input Power Management */
+	{0x24, 0x00},	/* DAC Power Management */
+	{0x26, 0x00},	/* SP-AMP Power Management */
+	{0x28, 0x00},	/* LINEOUT Power Management */
+	{0x2a, 0x00},	/* VIDEO Power Management */
+	{0x2e, 0x00},	/* AC-CMP Power Management */
+
+	/* Analog reference Control Register */
+	{0x30, 0x04},	/* MICBIAS Voltage Control */
+
+	/* Input/Output Amplifier Control Register */
+	{0x32, 0x10},	/* MIC Input Volume */
+	{0x38, 0x00},	/* Mic Boost Volume */
+	{0x3a, 0x33},	/* Speaker AMP Volume */
+	{0x48, 0x00},	/* AMP Volume Control Function Enable */
+	{0x4a, 0x00},	/* Amplifier Volume Fader Control */
+
+	/* Analog Path Control Register */
+	{0x54, 0x00},	/* Speaker AMP Output Control */
+	{0x5a, 0x00},	/* Mic IF Control */
+	{0xe8, 0x01},	/* Mic Select Control */
+
+	/* Audio Interface Control Register */
+	{0x60, 0x00},	/* SAI-Trans Control */
+	{0x62, 0x00},	/* SAI-Receive Control */
+	{0x64, 0x00},	/* SAI Mode select */
+
+	/* DSP Control Register */
+	{0x66, 0x01},	/* Filter Func Enable */
+	{0x68, 0x00},	/* Volume Control Func Enable */
+	{0x6A, 0x00},	/* Mixer & Volume Control*/
+	{0x6C, 0xff},	/* Record Digital Volume */
+	{0x70, 0xff},	/* Playback Digital Volume */
+	{0x72, 0x10},	/* Digital Boost Volume */
+	{0x74, 0xe7},	/* EQ gain Band0 */
+	{0x76, 0xe7},	/* EQ gain Band1 */
+	{0x78, 0xe7},	/* EQ gain Band2 */
+	{0x7A, 0xe7},	/* EQ gain Band3 */
+	{0x7C, 0xe7},	/* EQ gain Band4 */
+	{0x7E, 0x00},	/* HPF2 CutOff*/
+	{0x80, 0x00},	/* EQ Band0 Coef0L */
+	{0x82, 0x00},	/* EQ Band0 Coef0H */
+	{0x84, 0x00},	/* EQ Band0 Coef0L */
+	{0x86, 0x00},	/* EQ Band0 Coef0H */
+	{0x88, 0x00},	/* EQ Band1 Coef0L */
+	{0x8A, 0x00},	/* EQ Band1 Coef0H */
+	{0x8C, 0x00},	/* EQ Band1 Coef0L */
+	{0x8E, 0x00},	/* EQ Band1 Coef0H */
+	{0x90, 0x00},	/* EQ Band2 Coef0L */
+	{0x92, 0x00},	/* EQ Band2 Coef0H */
+	{0x94, 0x00},	/* EQ Band2 Coef0L */
+	{0x96, 0x00},	/* EQ Band2 Coef0H */
+	{0x98, 0x00},	/* EQ Band3 Coef0L */
+	{0x9A, 0x00},	/* EQ Band3 Coef0H */
+	{0x9C, 0x00},	/* EQ Band3 Coef0L */
+	{0x9E, 0x00},	/* EQ Band3 Coef0H */
+	{0xA0, 0x00},	/* EQ Band4 Coef0L */
+	{0xA2, 0x00},	/* EQ Band4 Coef0H */
+	{0xA4, 0x00},	/* EQ Band4 Coef0L */
+	{0xA6, 0x00},	/* EQ Band4 Coef0H */
+
+	/* ALC Control Register */
+	{0xb0, 0x00},	/* ALC Mode */
+	{0xb2, 0x02},	/* ALC Attack Time */
+	{0xb4, 0x03},	/* ALC Decay Time */
+	{0xb6, 0x00},	/* ALC Hold Time */
+	{0xb8, 0x0b},	/* ALC Target Level */
+	{0xba, 0x70},	/* ALC Max/Min Gain */
+	{0xbc, 0x00},	/* Noise Gate Threshold */
+	{0xbe, 0x00},	/* ALC ZeroCross TimeOut */
+
+	/* Playback Limiter Control Register */
+	{0xc0, 0x04},	/* PL Attack Time */
+	{0xc2, 0x05},	/* PL Decay Time */
+	{0xc4, 0x0d},	/* PL Target Level */
+	{0xc6, 0x70},	/* PL Max/Min Gain */
+	{0xc8, 0x10},	/* Playback Boost Volume */
+	{0xca, 0x00},	/* PL ZeroCross TimeOut */
+
+	/* Video Amplifier Control Register */
+	{0xd0, 0x01},	/* VIDEO AMP Gain Control */
+	{0xd2, 0x01},	/* VIDEO AMP Setup 1 */
+	{0xd4, 0x01},	/* VIDEO AMP Control2 */
+};
+
+static int ml26124_update_bits(struct snd_soc_codec *codec, unsigned short reg,
+				unsigned int mask, unsigned int value)
+{
+	int change;
+	unsigned int old, new;
+	int ret;
+
+	ret = snd_soc_read(codec, reg);
+	if (ret < 0)
+		return ret;
+
+	old = ret;
+	new = (old & ~mask) | (value & mask);
+	change = old != new;
+	if (change) {
+		ret = snd_soc_write(codec, reg + 1, new);
+		if (ret < 0)
+			return ret;
+	}
+
+	return change;
+}
+
+/* Get sampling rate value of sampling rate setting register (0x0) */
+static inline int get_srate(int rate)
+{
+	int srate;
+
+	switch (rate) {
+	case 16000:
+		srate = 3;
+		break;
+	case 32000:
+		srate = 6;
+		break;
+	case 48000:
+		srate = 8;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return srate;
+}
+
+static inline int get_coeff(int mclk, int rate)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(coeff_div); i++) {
+		if (coeff_div[i].rate == rate && coeff_div[i].mclk == mclk)
+			return i;
+	}
+	return -EINVAL;
+}
+
+static int ml26124_hw_params(struct snd_pcm_substream *substream,
+			    struct snd_pcm_hw_params *hw_params,
+			    struct snd_soc_dai *dai)
+{
+	struct snd_soc_codec *codec = dai->codec;
+	struct ml26124_priv *priv = snd_soc_codec_get_drvdata(codec);
+	int i = get_coeff(priv->mclk, params_rate(hw_params));
+
+	priv->channels = params_channels(hw_params);
+
+	switch (params_rate(hw_params)) {
+	case 16000:
+		ml26124_update_bits(codec, ML26124_SMPLING_RATE, 0xf,
+				    get_srate(coeff_div[i].rate));
+		ml26124_update_bits(codec, ML26124_PLLNL, 0xff,
+				    coeff_div[i].pllnl);
+		ml26124_update_bits(codec, ML26124_PLLNH, 0x1,
+				    coeff_div[i].pllnh);
+		ml26124_update_bits(codec, ML26124_PLLML, 0xff,
+				    coeff_div[i].pllml);
+		ml26124_update_bits(codec, ML26124_PLLMH, 0x3f,
+				    coeff_div[i].pllmh);
+		ml26124_update_bits(codec, ML26124_PLLDIV, 0x1f,
+				    coeff_div[i].plldiv);
+		break;
+	case 32000:
+		ml26124_update_bits(codec, ML26124_SMPLING_RATE, 0xf,
+				    get_srate(coeff_div[i].rate));
+		ml26124_update_bits(codec, ML26124_PLLNL, 0xff,
+				    coeff_div[i].pllnl);
+		ml26124_update_bits(codec, ML26124_PLLNH, 0x1,
+				    coeff_div[i].pllnh);
+		ml26124_update_bits(codec, ML26124_PLLML, 0xff,
+				    coeff_div[i].pllml);
+		ml26124_update_bits(codec, ML26124_PLLMH, 0x3f,
+				    coeff_div[i].pllmh);
+		ml26124_update_bits(codec, ML26124_PLLDIV, 0x1f,
+				    coeff_div[i].plldiv);
+		break;
+	case 48000:
+		ml26124_update_bits(codec, ML26124_SMPLING_RATE, 0xf,
+				    get_srate(coeff_div[i].rate));
+		ml26124_update_bits(codec, ML26124_PLLNL, 0xff,
+				    coeff_div[i].pllnl);
+		ml26124_update_bits(codec, ML26124_PLLNH, 0x1,
+				    coeff_div[i].pllnh);
+		ml26124_update_bits(codec, ML26124_PLLML, 0xff,
+				    coeff_div[i].pllml);
+		ml26124_update_bits(codec, ML26124_PLLMH, 0x3f,
+				    coeff_div[i].pllmh);
+		ml26124_update_bits(codec, ML26124_PLLDIV, 0x1f,
+				    coeff_div[i].plldiv);
+		break;
+	default:
+		pr_err("%s:this rate is no support for ml26124\n", __func__);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ml26124_mute(struct snd_soc_dai *dai, int mute)
+{
+	struct snd_soc_codec *codec = dai->codec;
+	if (mute)
+		ml26124_update_bits(codec, ML26124_DVOL_CTL, BIT(4),
+				    DVOL_CTL_DVMUTE_ON);
+	else
+		ml26124_update_bits(codec, ML26124_DVOL_CTL, BIT(4),
+				    DVOL_CTL_DVMUTE_OFF);
+
+	return 0;
+}
+
+static int ml26124_set_dai_fmt(struct snd_soc_dai *codec_dai,
+		unsigned int fmt)
+{
+	unsigned char mode;
+	struct snd_soc_codec *codec = codec_dai->codec;
+	struct ml26124_priv *priv = snd_soc_codec_get_drvdata(codec);
+	unsigned char mask = ML26124_SAI_NO_DELAY | ML26124_SAI_FRAME_SYNC;
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
+	ml26124_update_bits(codec, ML26124_SAI_MODE_SEL, BIT(0), mode);
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
+if (!priv)
+	return -1;
+
+	/* SAI configuration */
+	if (priv->channels == 1) {
+		ml26124_update_bits(codec, ML26124_SAI_TRANS_CTL, mask,
+				ML26124_SAI_NO_DELAY | ML26124_SAI_FRAME_SYNC);
+		ml26124_update_bits(codec, ML26124_SAI_RCV_CTL, mask,
+				ML26124_SAI_NO_DELAY | ML26124_SAI_FRAME_SYNC);
+	} else {
+		ml26124_update_bits(codec, ML26124_SAI_TRANS_CTL, mask,
+				    ML26124_SAI_NO_DELAY);
+		ml26124_update_bits(codec, ML26124_SAI_RCV_CTL, mask,
+				    ML26124_SAI_NO_DELAY);
+	}
+
+
+	return 0;
+}
+
+static int ml26124_set_dai_sysclk(struct snd_soc_dai *codec_dai,
+		int clk_id, unsigned int freq, int dir)
+{
+	struct snd_soc_codec *codec = codec_dai->codec;
+	struct ml26124_priv *priv = snd_soc_codec_get_drvdata(codec);
+
+	switch (clk_id) {
+	case ML26124_USE_PLL:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (freq) {
+	case 12288000:
+		priv->mclk = freq;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int ml26124_set_dai_clkdiv(struct snd_soc_dai *codec_dai,
+				  int div_id, int div)
+{
+	struct snd_soc_codec *codec = codec_dai->codec;
+
+	switch (div_id) {
+	case ML26124_MCLK:
+		ml26124_update_bits(codec, ML26124_CLK_CTL,
+				      BIT(0) | BIT(1), div);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int ml26124_set_bias_level(struct snd_soc_codec *codec,
+		enum snd_soc_bias_level level)
+{
+	struct ml26124_priv *priv = snd_soc_codec_get_drvdata(codec);
+	switch (level) {
+	case SND_SOC_BIAS_ON:
+		pr_debug("%s: level=ON priv=%p\n", __func__, priv);
+		/* VMID ON */
+		ml26124_update_bits(codec, ML26124_PW_REF_PW_MNG,
+				    ML26124_VMID, ML26124_VMID);
+		msleep(500);
+		break;
+	case SND_SOC_BIAS_PREPARE:
+		pr_debug("%s: level=PREPARE\n", __func__);
+		break;
+	case SND_SOC_BIAS_STANDBY:
+		pr_debug("%s: level=STANDBY\n", __func__);
+		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF)
+			regcache_sync(priv->regmap);
+		break;
+	case SND_SOC_BIAS_OFF:
+		pr_debug("%s: level=OFF\n", __func__);
+		/* VMID OFF */
+		ml26124_update_bits(codec, ML26124_PW_REF_PW_MNG,
+				    ML26124_VMID, 0);
+		break;
+	}
+	codec->dapm.bias_level = level;
+	return 0;
+}
+
+static int ml26124_pcm_trigger(struct snd_pcm_substream *substream,
+			      int cmd, struct snd_soc_dai *codec_dai)
+{
+	struct snd_soc_codec *codec = codec_dai->codec;
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_STOP:
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+		ml26124_update_bits(codec, ML26124_REC_PLYBAK_RUN, 0x3,
+				    0);
+		return 0;
+		break;
+	case SNDRV_PCM_TRIGGER_START:
+	case SNDRV_PCM_TRIGGER_RESUME:
+	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE)
+			ml26124_update_bits(codec,
+					ML26124_REC_PLYBAK_RUN, 0x3, 1);
+		else
+			ml26124_update_bits(codec,
+					ML26124_REC_PLYBAK_RUN, 0x3, 2);
+		break;
+	}
+
+	return 0;
+}
+
+static const struct snd_soc_dai_ops ml26124_dai_ops = {
+	.hw_params	= ml26124_hw_params,
+	.digital_mute	= ml26124_mute,
+	.set_fmt	= ml26124_set_dai_fmt,
+	.set_sysclk	= ml26124_set_dai_sysclk,
+	.set_clkdiv	= ml26124_set_dai_clkdiv,
+	.trigger	= ml26124_pcm_trigger,
+};
+
+static struct snd_soc_dai_driver ml26124_dai = {
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
+	struct ml26124_priv *priv = snd_soc_codec_get_drvdata(codec);
+
+	regcache_sync(priv->regmap);
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
+	codec->control_data = priv->regmap;
+
+	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_I2C);
+	if (ret < 0) {
+		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
+		return ret;
+	}
+
+	/* Software Reset */
+	ml26124_update_bits(codec, ML26124_SW_RST, 0x01, 1);
+	ml26124_update_bits(codec, ML26124_SW_RST, 0x01, 0);
+
+	ml26124_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
+
+	return 0;
+}
+
+/* power down chip */
+static struct snd_soc_codec_driver soc_codec_dev_ml26124 = {
+	.probe =	ml26124_probe,
+	.suspend =	ml26124_suspend,
+	.resume =	ml26124_resume,
+	.set_bias_level = ml26124_set_bias_level,
+	.dapm_widgets = ml26124_dapm_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(ml26124_dapm_widgets),
+	.dapm_routes = ml26124_intercon,
+	.num_dapm_routes = ARRAY_SIZE(ml26124_intercon),
+	.controls = ml26124_snd_controls,
+	.num_controls = ARRAY_SIZE(ml26124_snd_controls),
+};
+
+static const struct regmap_config ml26124_i2c_regmap = {
+	.val_bits = 8,
+	.reg_bits = 8,
+	.max_register = ML26124_NUM_REGISTER,
+	.reg_defaults = ml26124_reg,
+	.num_reg_defaults = ARRAY_SIZE(ml26124_reg),
+	.cache_type = REGCACHE_RBTREE,
+};
+
+static __devinit int ml26124_i2c_probe(struct i2c_client *i2c,
+				      const struct i2c_device_id *id)
+{
+	struct ml26124_priv *priv;
+	int ret;
+
+	priv = devm_kzalloc(&i2c->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	i2c_set_clientdata(i2c, priv);
+
+	priv->regmap = regmap_init_i2c(i2c, &ml26124_i2c_regmap);
+	if (IS_ERR(priv->regmap)) {
+		ret = PTR_ERR(priv->regmap);
+		dev_err(&i2c->dev, "regmap_init_i2c() failed: %d\n", ret);
+		return ret;
+	}
+
+	return snd_soc_register_codec(&i2c->dev,
+			&soc_codec_dev_ml26124, &ml26124_dai, 1);
+}
+
+static __devexit int ml26124_i2c_remove(struct i2c_client *client)
+{
+	struct ml26124_priv *priv = i2c_get_clientdata(client);
+
+	snd_soc_unregister_codec(&client->dev);
+	regmap_exit(priv->regmap);
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
+		.name = "ml26124-codec",
+		.owner = THIS_MODULE,
+	},
+	.probe = ml26124_i2c_probe,
+	.remove = __devexit_p(ml26124_i2c_remove),
+	.id_table = ml26124_i2c_id,
+};
+
+static int __init ml26124_modinit(void)
+{
+	int ret;
+
+	ret = i2c_add_driver(&ml26124_i2c_driver);
+	if (ret != 0)
+		pr_err("Failed to register ML26124 I2C driver: %d\n", ret);
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
+MODULE_AUTHOR("Tomoya MORINAGA <tomoya.rohm@gmail.com>");
+MODULE_DESCRIPTION("LAPIS Semiconductor ML26124 ALSA SoC codec driver");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/codecs/ml26124.h b/sound/soc/codecs/ml26124.h
new file mode 100644
index 0000000..d4a8df5
--- /dev/null
+++ b/sound/soc/codecs/ml26124.h
@@ -0,0 +1,132 @@
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
+/* Clock select for machine driver */
+#define ML26124_USE_PLL			0
+#define ML26124_USE_MCLKI_256FS		1
+#define ML26124_USE_MCLKI_512FS		2
+#define ML26124_USE_MCLKI_1024FS	3
+
+enum ml26124_regs {
+	ML26124_MCLK = 0,
+};
+
+#endif
-- 
1.7.7.6


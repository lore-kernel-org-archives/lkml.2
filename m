Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2LKNkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 08:40:13 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36623 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857Ab2LKNkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 08:40:10 -0500
From: Mehar Bajwa <mehar.bajwa@ti.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mehar Bajwa <mehar.bajwa@ti.com>,
        M R Swami Reddy <mr.swami.reddy@ti.com>,
        Rajeev Kumar <rajeev-dlh.kumar@st.com>,
        amoderator list <lsa-devel@alsa-project.org>,
        open list <linux-kernel@vger.kernel.org>,
        Moderator list <devicetree-discuss@lists.ozlabs.org>
CC: Mukund <navada@ti.com>, Hari <harik@ti.com>,
        Mehar Bajwa <mehar.bajwa@ti.com>
Subject: [PATCH 1/2] ASoC: tlv320aic326x: Support for TI TLV320AIC3262 audio driver
Date: Tue, 11 Dec 2012 19:08:29 +0530
Message-ID: <1355233109-14489-1-git-send-email-mehar.bajwa@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TI TLV320AIC3262 is a flexible, low-power, low-voltage stereo audio
codec with digital microphone inputs and programmable outputs. It includes
powertune capabilities, enhanced fully-programmable miniDSP, fixed predefined
and parameterizable signal processing blocks, integrated PLL and flexible digital
interfaces.

Signed-off-by: Mehar Bajwa <mehar.bajwa@ti.com>
---
 sound/soc/codecs/Kconfig         |    4 +
 sound/soc/codecs/Makefile        |    2 +
 sound/soc/codecs/tlv320aic326x.c | 2536 ++++++++++++++++++++++++++++++++++++++
 sound/soc/codecs/tlv320aic326x.h |   70 ++
 4 files changed, 2612 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/codecs/tlv320aic326x.c
 create mode 100644 sound/soc/codecs/tlv320aic326x.h

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 3a84782..73d8cea 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -67,6 +67,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_TLV320AIC32X4 if I2C
 	select SND_SOC_TLV320AIC3X if I2C
 	select SND_SOC_TPA6130A2 if I2C
+	select SND_SOC_TLV320AIC3262 if MFD_AIC3XXX
 	select SND_SOC_TLV320DAC33 if I2C
 	select SND_SOC_TWL4030 if TWL4030_CORE
 	select SND_SOC_TWL6040 if TWL6040_CORE
@@ -328,6 +329,9 @@ config SND_SOC_TLV320AIC32X4
 config SND_SOC_TLV320AIC3X
 	tristate
 
+config SND_SOC_TLV320AIC3262
+	tristate
+
 config SND_SOC_TLV320DAC33
 	tristate
 
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index f6e8e36..a3f8f4f 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -58,6 +58,7 @@ snd-soc-tlv320aic23-objs := tlv320aic23.o
 snd-soc-tlv320aic26-objs := tlv320aic26.o
 snd-soc-tlv320aic3x-objs := tlv320aic3x.o
 snd-soc-tlv320aic32x4-objs := tlv320aic32x4.o
+snd-soc-tlv320aic3262-objs := tlv320aic326x.o
 snd-soc-tlv320dac33-objs := tlv320dac33.o
 snd-soc-twl4030-objs := twl4030.o
 snd-soc-twl6040-objs := twl6040.o
@@ -179,6 +180,7 @@ obj-$(CONFIG_SND_SOC_TLV320AIC23)	+= snd-soc-tlv320aic23.o
 obj-$(CONFIG_SND_SOC_TLV320AIC26)	+= snd-soc-tlv320aic26.o
 obj-$(CONFIG_SND_SOC_TLV320AIC3X)	+= snd-soc-tlv320aic3x.o
 obj-$(CONFIG_SND_SOC_TLV320AIC32X4)     += snd-soc-tlv320aic32x4.o
+obj-$(CONFIG_SND_SOC_TLV320AIC3262)	+= snd-soc-tlv320aic3262.o
 obj-$(CONFIG_SND_SOC_TLV320DAC33)	+= snd-soc-tlv320dac33.o
 obj-$(CONFIG_SND_SOC_TWL4030)	+= snd-soc-twl4030.o
 obj-$(CONFIG_SND_SOC_TWL6040)	+= snd-soc-twl6040.o
diff --git a/sound/soc/codecs/tlv320aic326x.c b/sound/soc/codecs/tlv320aic326x.c
new file mode 100644
index 0000000..df21a39
--- /dev/null
+++ b/sound/soc/codecs/tlv320aic326x.c
@@ -0,0 +1,2536 @@
+/*
+ * linux/sound/soc/codecs/tlv320aic326x.c
+ *
+ * Copyright (C) 2011 Texas Instruments Inc.,
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ * The TLV320AIC3262 is a flexible, low-power, low-voltage stereo audio
+ * codec with digital microphone inputs and programmable outputs.
+ *
+ */
+
+/*
+ *****************************************************************************
+ * INCLUDES
+ *****************************************************************************
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/pm.h>
+#include <linux/i2c.h>
+#include <linux/pm_runtime.h>
+#include <linux/spi/spi.h>
+#include <linux/platform_device.h>
+#include <sound/jack.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/cdev.h>
+#include <linux/slab.h>
+#include <linux/firmware.h>
+#include <linux/input.h>
+
+#include <sound/tlv.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+#include <sound/soc-dapm.h>
+#include <sound/initval.h>
+#include <linux/mfd/tlv320aic3262-registers.h>
+#include <linux/mfd/tlv320aic3xxx-registers.h>
+#include <linux/mfd/tlv320aic3xxx-core.h>
+#include "aic3xxx_cfw_ops.h"
+
+#include "tlv320aic326x.h"
+
+/*****************************************************************************
+			 Macros
+******************************************************************************
+
+******************************************************************************
+		  Function Prototype
+******************************************************************************/
+
+static int aic3262_hw_params(struct snd_pcm_substream *substream,
+			     struct snd_pcm_hw_params *params,
+			     struct snd_soc_dai *dai);
+
+static int aic3262_set_dai_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt);
+
+static int aic3262_dai_set_pll(struct snd_soc_dai *dai, int pll_id, int source,
+				unsigned int Fin, unsigned int Fout);
+
+static int aic3262_set_bias_level(struct snd_soc_codec *codec,
+				  enum snd_soc_bias_level level);
+
+static int aic3262_set_mode_get(struct snd_kcontrol *kcontrol,
+				struct snd_ctl_elem_value *ucontrol);
+static int aic3262_set_mode_put(struct snd_kcontrol *kcontrol,
+				struct snd_ctl_elem_value *ucontrol);
+
+static int aic3262_adc_dsp_event(struct snd_soc_dapm_widget *w,
+				 struct snd_kcontrol *kcontrol, int event);
+static int aic3262_get_runstate(struct snd_soc_codec *codec);
+static int aic3262_dsp_pwrdwn_status(struct snd_soc_codec *codec);
+static int aic3262_dsp_pwrup(struct snd_soc_codec *codec, int state);
+static int aic3262_restart_dsps_sync(struct snd_soc_codec *codec, int rs);
+
+static inline unsigned int dsp_non_sync_mode(unsigned int state)
+			{ return (!((state & 0x03) && (state & 0x30))); }
+
+static const DECLARE_TLV_DB_SCALE(dac_vol_tlv, -6350, 50, 0);
+static const DECLARE_TLV_DB_SCALE(adc_vol_tlv, -1200, 50, 0);
+static const DECLARE_TLV_DB_SCALE(spk_gain_tlv, 600, 600, 0);
+static const DECLARE_TLV_DB_SCALE(output_gain_tlv, -600, 100, 1);
+static const DECLARE_TLV_DB_SCALE(micpga_gain_tlv, 0, 50, 0);
+static const DECLARE_TLV_DB_SCALE(adc_fine_gain_tlv, -40, 10, 0);
+static const DECLARE_TLV_DB_SCALE(beep_gen_volume_tlv, -6300, 100, 0);
+
+/* Chip-level Input and Output CM Mode Controls */
+static const char * const input_common_mode_text[] = {
+	"0.9v", "0.75v"
+};
+
+static const char * const output_common_mode_text[] = {
+	"Input CM", "1.25v", "1.5v", "1.65v"
+};
+
+static const struct soc_enum input_cm_mode =
+SOC_ENUM_SINGLE(AIC3262_CM_REG, 2, 2, input_common_mode_text);
+
+static const struct soc_enum output_cm_mode =
+SOC_ENUM_SINGLE(AIC3262_CM_REG, 0, 4, output_common_mode_text);
+/*
+ *****************************************************************************
+ * Structure Initialization
+ *****************************************************************************
+ */
+static const struct snd_kcontrol_new aic3262_snd_controls[] = {
+	/* Output */
+#ifndef DAC_INDEPENDENT_VOL
+	/* sound new kcontrol for PCM Playback volume control */
+
+	SOC_DOUBLE_R_SX_TLV("PCM Playback Volume",
+				AIC3262_DAC_LVOL, AIC3262_DAC_RVOL, 0,
+				0x81, 0xaf, dac_vol_tlv),
+#endif
+	/*HP Driver Gain Control */
+	SOC_DOUBLE_R_SX_TLV("HeadPhone Driver Amplifier Volume",
+				AIC3262_HPL_VOL, AIC3262_HPR_VOL, 0, 0x39,
+				0x15, output_gain_tlv),
+	/*LO Driver Gain Control */
+	SOC_DOUBLE_TLV("Speaker Amplifier Volume", AIC3262_SPK_AMP_CNTL_R4, 4,
+			0, 5, 0, spk_gain_tlv),
+
+	SOC_DOUBLE_R_SX_TLV("Receiver Amplifier Volume",
+				AIC3262_REC_AMP_CNTL_R5, AIC3262_RAMPR_VOL, 0,
+				0x39, 0x24, output_gain_tlv),
+
+	SOC_DOUBLE_R_SX_TLV("PCM Capture Volume", AIC3262_LADC_VOL,
+				AIC3262_RADC_VOL, 0, 0x68, 0x41,
+				adc_vol_tlv),
+
+	SOC_DOUBLE_R_TLV("MicPGA Volume Control", AIC3262_MICL_PGA,
+			 AIC3262_MICR_PGA, 0, 0x5F, 0, micpga_gain_tlv),
+
+	SOC_DOUBLE_TLV("PCM Capture Fine Gain Volume", AIC3262_ADC_FINE_GAIN,
+			4, 0, 5, 1, adc_fine_gain_tlv),
+
+	SOC_DOUBLE("ADC channel mute", AIC3262_ADC_FINE_GAIN, 7, 3, 1, 0),
+
+	SOC_DOUBLE("DAC MUTE", AIC3262_DAC_MVOL_CONF, 2, 3, 1, 1),
+
+	SOC_SINGLE("RESET", AIC3262_RESET_REG, 0, 1, 0),
+
+	SOC_SINGLE("DAC VOL SOFT STEPPING", AIC3262_DAC_MVOL_CONF, 0, 2, 0),
+
+	SOC_SINGLE("DAC AUTO MUTE CONTROL", AIC3262_DAC_MVOL_CONF, 4, 7, 0),
+
+	SOC_SINGLE("RIGHT MODULATOR SETUP", AIC3262_DAC_MVOL_CONF, 7, 1, 0),
+
+	SOC_SINGLE("ADC Volume soft stepping", AIC3262_ADC_CHANNEL_POW,
+		   0, 3, 0),
+
+	SOC_SINGLE("Mic Bias ext independent enable", AIC3262_MIC_BIAS_CNTL,
+		   7, 1, 0),
+
+	SOC_SINGLE("MICBIAS EXT Power Level", AIC3262_MIC_BIAS_CNTL, 4, 3, 0),
+
+	SOC_SINGLE("MICBIAS INT Power Level", AIC3262_MIC_BIAS_CNTL, 0, 3, 0),
+
+	SOC_SINGLE("BEEP_GEN_EN", AIC3262_BEEP_CNTL_R1, 7, 1, 0),
+
+	SOC_DOUBLE_R("BEEP_VOL_CNTL", AIC3262_BEEP_CNTL_R1,
+		     AIC3262_BEEP_CNTL_R2, 0, 0x0F, 1),
+
+	SOC_SINGLE("BEEP_MAS_VOL", AIC3262_BEEP_CNTL_R2, 6, 3, 0),
+
+	SOC_SINGLE("DAC PRB Selection", AIC3262_DAC_PRB, 0, 26, 0),
+
+	SOC_SINGLE("ADC PRB Selection", AIC3262_ADC_PRB, 0, 18, 0),
+
+	SOC_ENUM("Input CM mode", input_cm_mode),
+
+	SOC_ENUM("Output CM mode", output_cm_mode),
+
+	SOC_SINGLE_EXT("FIRMWARE SET MODE", SND_SOC_NOPM, 0, 0xffff, 0,
+			aic3262_set_mode_get, aic3262_set_mode_put),
+};
+
+/*
+ *----------------------------------------------------------------------------
+ * @struct  snd_soc_codec_dai |
+ *	It is SoC Codec DAI structure which has DAI capabilities viz.,
+ *	playback and capture, DAI runtime information viz. state of DAI
+ *			and pop wait state, and DAI private data.
+ *	The AIC3262 rates ranges from 8k to 192k
+ *	The PCM bit format supported are 16, 20, 24 and 32 bits
+ *----------------------------------------------------------------------------
+ */
+struct snd_soc_dai_ops aic3262_asi1_dai_ops = {
+	.hw_params = aic3262_hw_params,
+	.set_fmt = aic3262_set_dai_fmt,
+	.set_pll = aic3262_dai_set_pll,
+};
+
+struct snd_soc_dai_ops aic3262_asi2_dai_ops = {
+	.hw_params = aic3262_hw_params,
+	.set_fmt = aic3262_set_dai_fmt,
+	.set_pll = aic3262_dai_set_pll,
+};
+
+struct snd_soc_dai_ops aic3262_asi3_dai_ops = {
+	.hw_params = aic3262_hw_params,
+	.set_fmt = aic3262_set_dai_fmt,
+	.set_pll = aic3262_dai_set_pll,
+};
+
+struct snd_soc_dai_driver aic3262_dai_driver[] = {
+	{
+	 .name = "aic3262-asi1",
+	 .playback = {
+		      .stream_name = "ASI1 Playback",
+		      .channels_min = 1,
+		      .channels_max = 8,
+		      .rates = AIC3262_RATES,
+		      .formats = AIC3262_FORMATS,
+		      },
+	 .capture = {
+		     .stream_name = "ASI1 Capture",
+		     .channels_min = 1,
+		     .channels_max = 8,
+		     .rates = AIC3262_RATES,
+		     .formats = AIC3262_FORMATS,
+		     },
+	 .ops = &aic3262_asi1_dai_ops,
+	 },
+	{
+	 .name = "aic3262-asi2",
+	 .playback = {
+		      .stream_name = "ASI2 Playback",
+		      .channels_min = 1,
+		      .channels_max = 2,
+		      .rates = AIC3262_RATES,
+		      .formats = AIC3262_FORMATS,
+		      },
+	 .capture = {
+		     .stream_name = "ASI2 Capture",
+		     .channels_min = 1,
+		     .channels_max = 2,
+		     .rates = AIC3262_RATES,
+		     .formats = AIC3262_FORMATS,
+		     },
+	 .ops = &aic3262_asi2_dai_ops,
+	 },
+	{
+	 .name = "aic3262-asi3",
+	 .playback = {
+		      .stream_name = "ASI3 Playback",
+		      .channels_min = 1,
+		      .channels_max = 2,
+		      .rates = AIC3262_RATES,
+		      .formats = AIC3262_FORMATS,
+		      },
+	 .capture = {
+		     .stream_name = "ASI3 Capture",
+		     .channels_min = 1,
+		     .channels_max = 2,
+		     .rates = AIC3262_RATES,
+		     .formats = AIC3262_FORMATS,
+		     },
+	 .ops = &aic3262_asi3_dai_ops,
+	 },
+
+};
+
+static const unsigned int adc_ma_tlv[] = {
+	TLV_DB_RANGE_HEAD(7),
+	1, 1, TLV_DB_SCALE_ITEM(-3610, 0, 0),
+	2, 2, TLV_DB_SCALE_ITEM(-3010, 0, 0),
+	3, 3, TLV_DB_SCALE_ITEM(-2660, 0, 0),
+	4, 4, TLV_DB_SCALE_ITEM(-2410, 0, 0),
+	5, 7, TLV_DB_SCALE_ITEM(-2210, 1500, 0),
+	8, 11, TLV_DB_SCALE_ITEM(-1810, 1000, 0),
+	12, 41 , TLV_DB_SCALE_ITEM(-1450, 500, 0)
+};
+
+static const DECLARE_TLV_DB_SCALE(lo_hp_tlv, -7830, 50, 0);
+static const struct snd_kcontrol_new mal_pga_mixer_controls[] = {
+	SOC_DAPM_SINGLE("IN1 Left Capture Switch", AIC3262_MA_CNTL, 5, 1, 0),
+	SOC_DAPM_SINGLE_TLV("Left MicPGA Volume", AIC3262_LADC_PGA_MAL_VOL,
+				0, 0x3f, 1, adc_ma_tlv),
+};
+
+static const struct snd_kcontrol_new mar_pga_mixer_controls[] = {
+	SOC_DAPM_SINGLE("IN1 Right Capture Switch", AIC3262_MA_CNTL, 4, 1, 0),
+	SOC_DAPM_SINGLE_TLV("Right MicPGA Volume", AIC3262_RADC_PGA_MAR_VOL,
+				0, 0x3f, 1, adc_ma_tlv),
+};
+
+/* Left HPL Mixer */
+static const struct snd_kcontrol_new hpl_output_mixer_controls[] = {
+	SOC_DAPM_SINGLE("MA Left Playback Switch", AIC3262_HP_AMP_CNTL_R1, 7, 1,
+			0),
+	SOC_DAPM_SINGLE("Left DAC Playback Switch", AIC3262_HP_AMP_CNTL_R1,
+			5, 1, 0),
+	SOC_DAPM_SINGLE_TLV("LO Left-B1 Playback Volume",
+				AIC3262_HP_AMP_CNTL_R2, 0, 0x7f, 1, lo_hp_tlv),
+};
+
+/* Right HPR Mixer */
+static const struct snd_kcontrol_new hpr_output_mixer_controls[] = {
+	SOC_DAPM_SINGLE_TLV("LO Right-B1 Playback Volume",
+				AIC3262_HP_AMP_CNTL_R3, 0, 0x7f, 1, lo_hp_tlv),
+	SOC_DAPM_SINGLE("Left DAC Playback Switch", AIC3262_HP_AMP_CNTL_R1,
+			2, 1, 0),
+	SOC_DAPM_SINGLE("Right DAC Playback Switch", AIC3262_HP_AMP_CNTL_R1,
+			4, 1, 0),
+	SOC_DAPM_SINGLE("MA Right Playback Switch", AIC3262_HP_AMP_CNTL_R1,
+			6, 1, 0),
+};
+
+/* Left LOL Mixer */
+static const struct snd_kcontrol_new lol_output_mixer_controls[] = {
+	SOC_DAPM_SINGLE("MA Left Playback Switch", AIC3262_LINE_AMP_CNTL_R2,
+			7, 1, 0),
+	SOC_DAPM_SINGLE("IN1 Left-B Capture Switch", AIC3262_LINE_AMP_CNTL_R2,
+			3, 1, 0),
+	SOC_DAPM_SINGLE("Left DAC Playback Switch", AIC3262_LINE_AMP_CNTL_R1,
+			7, 1, 0),
+	SOC_DAPM_SINGLE("Right DAC Playback Switch", AIC3262_LINE_AMP_CNTL_R1,
+			5, 1, 0),
+};
+
+/* Right LOR Mixer */
+static const struct snd_kcontrol_new lor_output_mixer_controls[] = {
+	SOC_DAPM_SINGLE("LO Left Playback Switch", AIC3262_LINE_AMP_CNTL_R1,
+			2, 1, 0),
+	SOC_DAPM_SINGLE("Right DAC Playback Switch", AIC3262_LINE_AMP_CNTL_R1,
+			6, 1, 0),
+	SOC_DAPM_SINGLE("MA Right Playback Switch", AIC3262_LINE_AMP_CNTL_R2,
+			6, 1, 0),
+	SOC_DAPM_SINGLE("IN1 Right-B Capture Switch", AIC3262_LINE_AMP_CNTL_R2,
+			0, 1, 0),
+};
+
+/* Left SPKL Mixer */
+static const struct snd_kcontrol_new spkl_output_mixer_controls[] = {
+	SOC_DAPM_SINGLE("MA Left Playback Switch", AIC3262_SPK_AMP_CNTL_R1,
+			7, 1, 0),
+	SOC_DAPM_SINGLE_TLV("LO Left Playback Volume",
+				AIC3262_SPK_AMP_CNTL_R2, 0, 0x7f, 1, lo_hp_tlv),
+	SOC_DAPM_SINGLE("SPR_IN Switch", AIC3262_SPK_AMP_CNTL_R1, 2, 1, 0),
+};
+
+/* Right SPKR Mixer */
+static const struct snd_kcontrol_new spkr_output_mixer_controls[] = {
+	SOC_DAPM_SINGLE_TLV("LO Right Playback Volume",
+				AIC3262_SPK_AMP_CNTL_R3, 0, 0x7f, 1, lo_hp_tlv),
+	SOC_DAPM_SINGLE("MA Right Playback Switch",
+			AIC3262_SPK_AMP_CNTL_R1, 6, 1, 0),
+};
+
+/* REC Mixer */
+static const struct snd_kcontrol_new rec_output_mixer_controls[] = {
+	SOC_DAPM_SINGLE_TLV("LO Left-B2 Playback Volume",
+				AIC3262_RAMP_CNTL_R1, 0, 0x7f, 1, lo_hp_tlv),
+	SOC_DAPM_SINGLE_TLV("IN1 Left Capture Volume",
+				AIC3262_IN1L_SEL_RM, 0, 0x7f, 1, lo_hp_tlv),
+	SOC_DAPM_SINGLE_TLV("IN1 Right Capture Volume",
+				AIC3262_IN1R_SEL_RM, 0, 0x7f, 1, lo_hp_tlv),
+	SOC_DAPM_SINGLE_TLV("LO Right-B2 Playback Volume",
+				AIC3262_RAMP_CNTL_R2, 0, 0x7f, 1, lo_hp_tlv),
+};
+
+/* Left Input Mixer */
+static const struct snd_kcontrol_new left_input_mixer_controls[] = {
+	SOC_DAPM_SINGLE("IN1 Left Capture Switch", AIC3262_LMIC_PGA_PIN,
+			6, 3, 0),
+	SOC_DAPM_SINGLE("IN2 Left Capture Switch", AIC3262_LMIC_PGA_PIN,
+			4, 3, 0),
+	SOC_DAPM_SINGLE("IN3 Left Capture Switch", AIC3262_LMIC_PGA_PIN,
+			2, 3, 0),
+	SOC_DAPM_SINGLE("IN4 Left Capture Switch", AIC3262_LMIC_PGA_PM_IN4,
+			5, 1, 0),
+	SOC_DAPM_SINGLE("IN1 Right Capture Switch", AIC3262_LMIC_PGA_PIN,
+			0, 3, 0),
+	SOC_DAPM_SINGLE("IN2 Right Capture Switch", AIC3262_LMIC_PGA_MIN,
+			4, 3, 0),
+	SOC_DAPM_SINGLE("IN3 Right Capture Switch", AIC3262_LMIC_PGA_MIN,
+			2, 3, 0),
+	SOC_DAPM_SINGLE("IN4 Right Capture Switch", AIC3262_LMIC_PGA_PM_IN4,
+			4, 1, 0),
+	SOC_DAPM_SINGLE("CM2 Left Capture Switch", AIC3262_LMIC_PGA_MIN,
+			0, 3, 0),
+	SOC_DAPM_SINGLE("CM1 Left Capture Switch", AIC3262_LMIC_PGA_MIN,
+			6, 3, 0),
+};
+
+/* Right Input Mixer */
+static const struct snd_kcontrol_new right_input_mixer_controls[] = {
+	SOC_DAPM_SINGLE("IN1 Right Capture Switch", AIC3262_RMIC_PGA_PIN,
+			6, 3, 0),
+	SOC_DAPM_SINGLE("IN2 Right Capture Switch", AIC3262_RMIC_PGA_PIN,
+			4, 3, 0),
+	SOC_DAPM_SINGLE("IN3 Right Capture Switch", AIC3262_RMIC_PGA_PIN,
+			2, 3, 0),
+	SOC_DAPM_SINGLE("IN4 Right Capture Switch", AIC3262_RMIC_PGA_PM_IN4,
+			5, 1, 0),
+	SOC_DAPM_SINGLE("IN2 Left Capture Switch", AIC3262_RMIC_PGA_PIN,
+			0, 3, 0),
+	SOC_DAPM_SINGLE("IN1 Left Capture Switch", AIC3262_RMIC_PGA_MIN,
+			4, 3, 0),
+	SOC_DAPM_SINGLE("IN3 Left Capture Switch", AIC3262_RMIC_PGA_MIN,
+			2, 3, 0),
+	SOC_DAPM_SINGLE("IN4 Left Capture Switch", AIC3262_RMIC_PGA_PM_IN4,
+			4, 1, 0),
+	SOC_DAPM_SINGLE("CM1 Right Capture Switch", AIC3262_RMIC_PGA_MIN,
+			6, 3, 0),
+	SOC_DAPM_SINGLE("CM2 Right Capture Switch", AIC3262_RMIC_PGA_MIN,
+			0, 3, 0),
+};
+
+static const char * const asi1lin_text[] = {
+	"Off", "ASI1 Left In", "ASI1 Right In", "ASI1 MonoMix In"
+};
+
+SOC_ENUM_SINGLE_DECL(asi1lin_enum, AIC3262_ASI1_DAC_OUT_CNTL, 6, asi1lin_text);
+
+static const struct snd_kcontrol_new asi1lin_control =
+SOC_DAPM_ENUM("ASI1LIN Route", asi1lin_enum);
+
+static const char * const asi1rin_text[] = {
+	"Off", "ASI1 Right In", "ASI1 Left In", "ASI1 MonoMix In"
+};
+
+SOC_ENUM_SINGLE_DECL(asi1rin_enum, AIC3262_ASI1_DAC_OUT_CNTL, 4, asi1rin_text);
+
+static const struct snd_kcontrol_new asi1rin_control =
+SOC_DAPM_ENUM("ASI1RIN Route", asi1rin_enum);
+
+static const char * const asi2lin_text[] = {
+	"Off", "ASI2 Left In", "ASI2 Right In", "ASI2 MonoMix In"
+};
+
+SOC_ENUM_SINGLE_DECL(asi2lin_enum, AIC3262_ASI2_DAC_OUT_CNTL, 6, asi2lin_text);
+
+static const struct snd_kcontrol_new asi2lin_control =
+SOC_DAPM_ENUM("ASI2LIN Route", asi2lin_enum);
+
+static const char * const asi2rin_text[] = {
+	"Off", "ASI2 Right In", "ASI2 Left In", "ASI2 MonoMix In"
+};
+
+SOC_ENUM_SINGLE_DECL(asi2rin_enum, AIC3262_ASI2_DAC_OUT_CNTL, 4, asi2rin_text);
+
+static const struct snd_kcontrol_new asi2rin_control =
+SOC_DAPM_ENUM("ASI2RIN Route", asi2rin_enum);
+
+static const char * const asi3lin_text[] = {
+	"Off", "ASI3 Left In", "ASI3 Right In", "ASI3 MonoMix In"
+};
+
+SOC_ENUM_SINGLE_DECL(asi3lin_enum, AIC3262_ASI3_DAC_OUT_CNTL, 6, asi3lin_text);
+
+static const struct snd_kcontrol_new asi3lin_control =
+SOC_DAPM_ENUM("ASI3LIN Route", asi3lin_enum);
+
+static const char * const asi3rin_text[] = {
+	"Off", "ASI3 Right In", "ASI3 Left In", "ASI3 MonoMix In"
+};
+
+SOC_ENUM_SINGLE_DECL(asi3rin_enum, AIC3262_ASI3_DAC_OUT_CNTL, 4, asi3rin_text);
+
+static const struct snd_kcontrol_new asi3rin_control =
+SOC_DAPM_ENUM("ASI3RIN Route", asi3rin_enum);
+
+static const char * const dacminidspin1_text[] = {
+	"ASI1 In", "ASI2 In", "ASI3 In", "ADC MiniDSP Out"
+};
+
+SOC_ENUM_SINGLE_DECL(dacminidspin1_enum, AIC3262_MINIDSP_DATA_PORT_CNTL, 4,
+		     dacminidspin1_text);
+
+static const struct snd_kcontrol_new dacminidspin1_control =
+SOC_DAPM_ENUM("DAC MiniDSP IN1 Route", dacminidspin1_enum);
+
+static const char * const dacminidspin2_text[] = {
+	"ASI1 In", "ASI2 In", "ASI3 In"
+};
+
+SOC_ENUM_SINGLE_DECL(dacminidspin2_enum, AIC3262_MINIDSP_DATA_PORT_CNTL, 2,
+		     dacminidspin2_text);
+
+static const struct snd_kcontrol_new dacminidspin2_control =
+SOC_DAPM_ENUM("DAC MiniDSP IN2 Route", dacminidspin2_enum);
+
+static const char * const dacminidspin3_text[] = {
+	"ASI1 In", "ASI2 In", "ASI3 In"
+};
+
+SOC_ENUM_SINGLE_DECL(dacminidspin3_enum, AIC3262_MINIDSP_DATA_PORT_CNTL, 0,
+		     dacminidspin3_text);
+
+static const struct snd_kcontrol_new dacminidspin3_control =
+SOC_DAPM_ENUM("DAC MiniDSP IN3 Route", dacminidspin3_enum);
+
+static const char * const adcdac_route_text[] = {
+	"Off",
+	"On",
+};
+
+SOC_ENUM_SINGLE_DECL(adcdac_enum, 0, 2, adcdac_route_text);
+
+static const struct snd_kcontrol_new adcdacroute_control =
+SOC_DAPM_ENUM_VIRT("ADC DAC Route", adcdac_enum);
+
+static const char * const dout1_text[] = {
+	"ASI1 Out",
+	"DIN1 Bypass",
+	"DIN2 Bypass",
+	"DIN3 Bypass",
+};
+
+SOC_ENUM_SINGLE_DECL(dout1_enum, AIC3262_ASI1_DOUT_CNTL, 0, dout1_text);
+static const struct snd_kcontrol_new dout1_control =
+SOC_DAPM_ENUM("DOUT1 Route", dout1_enum);
+
+static const char * const dout2_text[] = {
+	"ASI2 Out",
+	"DIN1 Bypass",
+	"DIN2 Bypass",
+	"DIN3 Bypass",
+};
+
+SOC_ENUM_SINGLE_DECL(dout2_enum, AIC3262_ASI2_DOUT_CNTL, 0, dout2_text);
+static const struct snd_kcontrol_new dout2_control =
+SOC_DAPM_ENUM("DOUT2 Route", dout2_enum);
+
+static const char * const dout3_text[] = {
+	"ASI3 Out",
+	"DIN1 Bypass",
+	"DIN2 Bypass",
+	"DIN3 Bypass",
+};
+
+SOC_ENUM_SINGLE_DECL(dout3_enum, AIC3262_ASI3_DOUT_CNTL, 0, dout3_text);
+static const struct snd_kcontrol_new dout3_control =
+SOC_DAPM_ENUM("DOUT3 Route", dout3_enum);
+
+static const char * const asi1out_text[] = {
+	"Off",
+	"ADC MiniDSP Out1",
+	"ASI1In Bypass",
+	"ASI2In Bypass",
+	"ASI3In Bypass",
+};
+
+SOC_ENUM_SINGLE_DECL(asi1out_enum, AIC3262_ASI1_ADC_INPUT_CNTL,
+		     0, asi1out_text);
+static const struct snd_kcontrol_new asi1out_control =
+SOC_DAPM_ENUM("ASI1OUT Route", asi1out_enum);
+
+static const char * const asi2out_text[] = {
+	"Off",
+	"ADC MiniDSP Out1",
+	"ASI1In Bypass",
+	"ASI2In Bypass",
+	"ASI3In Bypass",
+	"ADC MiniDSP Out2",
+};
+
+SOC_ENUM_SINGLE_DECL(asi2out_enum, AIC3262_ASI2_ADC_INPUT_CNTL,
+		     0, asi2out_text);
+static const struct snd_kcontrol_new asi2out_control =
+SOC_DAPM_ENUM("ASI2OUT Route", asi2out_enum);
+static const char * const asi3out_text[] = {
+	"Off",
+	"ADC MiniDSP Out1",
+	"ASI1In Bypass",
+	"ASI2In Bypass",
+	"ASI3In Bypass",
+	"Reserved",
+	"ADC MiniDSP Out3",
+};
+
+SOC_ENUM_SINGLE_DECL(asi3out_enum, AIC3262_ASI3_ADC_INPUT_CNTL,
+		     0, asi3out_text);
+static const struct snd_kcontrol_new asi3out_control =
+SOC_DAPM_ENUM("ASI3OUT Route", asi3out_enum);
+static const char * const asibclk_text[] = {
+	"DAC_CLK",
+	"DAC_MOD_CLK",
+	"ADC_CLK",
+	"ADC_MOD_CLK",
+};
+
+SOC_ENUM_SINGLE_DECL(asi1bclk_enum, AIC3262_ASI1_BCLK_N_CNTL, 0, asibclk_text);
+
+static const char * const adc_mux_text[] = {
+	"Analog",
+	"Digital",
+};
+
+SOC_ENUM_SINGLE_DECL(adcl_enum, AIC3262_ADC_CHANNEL_POW, 4, adc_mux_text);
+SOC_ENUM_SINGLE_DECL(adcr_enum, AIC3262_ADC_CHANNEL_POW, 2, adc_mux_text);
+
+static const struct snd_kcontrol_new adcl_mux =
+SOC_DAPM_ENUM("Left ADC Route", adcl_enum);
+
+static const struct snd_kcontrol_new adcr_mux =
+SOC_DAPM_ENUM("Right ADC Route", adcr_enum);
+
+/**
+ * aic3262_hp_event: - To handle headphone related task before and after
+ *			headphone powrup and power down
+ * @w: pointer variable to dapm_widget
+ * @kcontrol: mixer control
+ * @event: event element information
+ *
+ * Returns 0 for success.
+ */
+static int aic3262_hp_event(struct snd_soc_dapm_widget *w,
+			    struct snd_kcontrol *kcontrol, int event)
+{
+	struct aic3262_priv *aic3262 = snd_soc_codec_get_drvdata(w->codec);
+	int reg_mask = 0;
+	int mute_reg = 0;
+	int ret_wbits = 0;
+	u8 hpl_hpr;
+
+	if (w->shift == 1) {
+		reg_mask = AIC3262_HPL_POWER_STATUS_MASK;
+		mute_reg = AIC3262_HPL_VOL;
+	}
+	if (w->shift == 0) {
+		reg_mask = AIC3262_HPR_POWER_STATUS_MASK;
+		mute_reg = AIC3262_HPR_VOL;
+	}
+	switch (event) {
+	case SND_SOC_DAPM_PRE_PMU:
+			snd_soc_update_bits(w->codec, AIC3262_CHARGE_PUMP_CNTL,
+			AIC3262_DYNAMIC_OFFSET_CALIB_MASK,
+			AIC3262_DYNAMIC_OFFSET_CALIB);
+			snd_soc_write(w->codec, mute_reg, 0x80);
+			snd_soc_update_bits(w->codec, AIC3262_HP_CTL,
+			AIC3262_HP_STAGE_MASK ,
+			AIC3262_HP_STAGE_25 << AIC3262_HP_STAGE_SHIFT);
+		break;
+
+	case SND_SOC_DAPM_POST_PMU:
+		ret_wbits = aic3xxx_wait_bits(aic3262->aic3xxx,
+					      AIC3262_HP_FLAG, reg_mask,
+					      reg_mask, AIC3262_TIME_DELAY,
+					      AIC3262_DELAY_COUNTER);
+		if (!ret_wbits) {
+			dev_err(w->codec->dev, "HP POST_PMU timedout\n");
+			return -1;
+		}
+		snd_soc_update_bits(w->codec, AIC3262_HP_CTL,
+			AIC3262_HP_STAGE_MASK ,
+			AIC3262_HP_STAGE_100 << AIC3262_HP_STAGE_SHIFT);
+		break;
+
+	case SND_SOC_DAPM_PRE_PMD:
+		snd_soc_update_bits(w->codec, AIC3262_HP_CTL,
+				AIC3262_HP_STAGE_MASK ,
+				AIC3262_HP_STAGE_25 << AIC3262_HP_STAGE_SHIFT);
+		hpl_hpr = snd_soc_read(w->codec, AIC3262_HP_AMP_CNTL_R1);
+		if ((hpl_hpr & 0x3) == 0x3) {
+			snd_soc_update_bits(w->codec, AIC3262_HP_AMP_CNTL_R1,
+						AIC3262_HPL_POWER_MASK, 0x0);
+			mdelay(1);
+			snd_soc_update_bits(w->codec, AIC3262_HP_AMP_CNTL_R1,
+						AIC3262_HPR_POWER_MASK, 0x0);
+		}
+		break;
+
+	case SND_SOC_DAPM_POST_PMD:
+		ret_wbits = aic3xxx_wait_bits(aic3262->aic3xxx,
+					      AIC3262_HP_FLAG, reg_mask, 0,
+					      AIC3262_TIME_DELAY,
+					      AIC3262_DELAY_COUNTER);
+		if (!ret_wbits) {
+			dev_err(w->codec->dev, "HP POST_PMD timedout\n");
+			return -1;
+		}
+		snd_soc_write(w->codec, mute_reg, 0xb9);
+		snd_soc_write(w->codec, AIC3262_POWER_CONF,
+				snd_soc_read(w->codec, AIC3262_POWER_CONF));
+		break;
+	default:
+		BUG();
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/**
+ *aic3262_dac_event: Headset popup reduction and powering up dsps together
+ *			when they are in sync mode
+ * @w: pointer variable to dapm_widget
+ * @kcontrol: pointer to sound control
+ * @event: event element information
+ *
+ * Returns 0 for success.
+ */
+static int aic3262_dac_event(struct snd_soc_dapm_widget *w,
+			     struct snd_kcontrol *kcontrol, int event)
+{
+	int reg_mask = 0;
+	int ret_wbits = 0;
+	int run_state_mask;
+	struct aic3262_priv *aic3262 = snd_soc_codec_get_drvdata(w->codec);
+	int sync_needed = 0, non_sync_state = 0;
+	int other_dsp = 0, run_state = 0;
+
+	if (w->shift == 7) {
+		reg_mask = AIC3262_LDAC_POWER_STATUS_MASK;
+		run_state_mask = AIC3XXX_COPS_MDSP_D_L;
+	}
+	if (w->shift == 6) {
+		reg_mask = AIC3262_RDAC_POWER_STATUS_MASK;
+		run_state_mask = AIC3XXX_COPS_MDSP_D_R;
+	}
+	switch (event) {
+	case SND_SOC_DAPM_POST_PMU:
+
+		ret_wbits = aic3xxx_wait_bits(aic3262->aic3xxx,
+					      AIC3262_DAC_FLAG, reg_mask,
+					      reg_mask, AIC3262_TIME_DELAY,
+					      AIC3262_DELAY_COUNTER);
+
+		sync_needed = aic3xxx_reg_read(aic3262->aic3xxx,
+							AIC3262_DAC_PRB);
+		non_sync_state = dsp_non_sync_mode(aic3262->dsp_runstate);
+		other_dsp = aic3262->dsp_runstate & AIC3XXX_COPS_MDSP_A;
+
+		if (sync_needed && non_sync_state && other_dsp) {
+			run_state = aic3262_get_runstate(
+						aic3262->codec);
+			aic3262_dsp_pwrdwn_status(aic3262->codec);
+			aic3262_dsp_pwrup(aic3262->codec, run_state);
+		}
+		aic3262->dsp_runstate |= run_state_mask;
+
+		if (!ret_wbits) {
+			dev_err(w->codec->dev, "DAC POST_PMU timedout\n");
+			return -1;
+		}
+		break;
+	case SND_SOC_DAPM_POST_PMD:
+
+		ret_wbits = aic3xxx_wait_bits(aic3262->aic3xxx,
+					      AIC3262_DAC_FLAG, reg_mask, 0,
+					      AIC3262_TIME_DELAY,
+					      AIC3262_DELAY_COUNTER);
+
+		aic3262->dsp_runstate = (aic3262->dsp_runstate &
+					 ~run_state_mask);
+		if (!ret_wbits) {
+			dev_err(w->codec->dev, "DAC POST_PMD timedout\n");
+			return -1;
+		}
+		break;
+	default:
+		BUG();
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/**
+ * aic3262_spk_event: Speaker related task before and after
+ *			 headphone powrup and power down$
+ * @w: pointer variable to dapm_widget,
+ * @kcontrolr: pointer variable to sound control,
+ * @event:	integer to event,
+ *
+ * Return value: 0 for success
+ */
+static int aic3262_spk_event(struct snd_soc_dapm_widget *w,
+			     struct snd_kcontrol *kcontrol, int event)
+{
+	int reg_mask;
+
+	if (w->shift == 1)
+		reg_mask = AIC3262_SPKL_POWER_STATUS_MASK;
+	if (w->shift == 0)
+		reg_mask = AIC3262_SPKR_POWER_STATUS_MASK;
+	switch (event) {
+	case SND_SOC_DAPM_POST_PMU:
+		mdelay(1);
+		break;
+	case SND_SOC_DAPM_POST_PMD:
+		mdelay(1);
+		break;
+	default:
+		BUG();
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/**$
+ * pll_power_on_event: provide delay after widget  power up
+ * @w:  pointer variable to dapm_widget,
+ * @kcontrolr: pointer variable to sound control,
+ * @event:	integer to event,
+ *
+ * Return value: 0 for success
+ */
+static int pll_power_on_event(struct snd_soc_dapm_widget *w,
+			      struct snd_kcontrol *kcontrol, int event)
+{
+	if (event == SND_SOC_DAPM_POST_PMU)
+		mdelay(10);
+	return 0;
+}
+
+/**
+ * aic3262_set_mode_get: To get different mode of Firmware through tinymix
+ * @kcontrolr: pointer to sound control,
+ * ucontrol: pointer to control element value,
+ *
+ * Return value: 0 for success
+ */
+static int aic3262_set_mode_get(struct snd_kcontrol *kcontrol,
+				struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct aic3262_priv *priv_ds = snd_soc_codec_get_drvdata(codec);
+
+	ucontrol->value.integer.value[0] = ((priv_ds->cfw_p->cur_mode << 8)
+					    | priv_ds->cfw_p->cur_cfg);
+
+	return 0;
+}
+
+/**
+ * aic3262_set_mode_put: To set different mode of Firmware through tinymix
+ * @kcontrolr: pointer to sound control,
+ * ucontrol: pointer to control element value,
+ *
+ * Return value: 0 for success
+ */
+static int aic3262_set_mode_put(struct snd_kcontrol *kcontrol,
+				struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct aic3262_priv *priv_ds = snd_soc_codec_get_drvdata(codec);
+
+	int next_mode = 0, next_cfg = 0;
+	int ret = 0;
+
+	next_mode = (ucontrol->value.integer.value[0] >> 8);
+	next_cfg = (ucontrol->value.integer.value[0]) & 0xFF;
+	if (priv_ds == NULL)
+		dev_err(codec->dev, "failed to load firmware\n");
+	else
+		ret = aic_setmode_cfg(priv_ds->cfw_p,
+					      next_mode, next_cfg);
+	return ret;
+}
+
+/**
+ * aic3262_adc_dsp_event: To get DSP run state to perform synchronization
+ * @w: pointer variable to dapm_widget
+ * @kcontrol: pointer to sound control
+ * @event: event element information
+ *
+ * Returns 0 for success.
+ */
+static int aic3262_adc_dsp_event(struct snd_soc_dapm_widget *w,
+				 struct snd_kcontrol *kcontrol, int event)
+{
+	int run_state = 0;
+	int non_sync_state = 0, sync_needed = 0;
+	int other_dsp = 0;
+	int run_state_mask = 0;
+	struct aic3262_priv *aic3262 = snd_soc_codec_get_drvdata(w->codec);
+	int reg_mask = 0;
+	int ret_wbits = 0;
+
+	if (w->shift == 7) {
+		reg_mask = AIC3262_LADC_POWER_MASK;
+		run_state_mask = AIC3XXX_COPS_MDSP_A_L;
+	}
+	if (w->shift == 6) {
+		reg_mask = AIC3262_RADC_POWER_MASK;
+		run_state_mask = AIC3XXX_COPS_MDSP_A_R;
+	}
+	switch (event) {
+	case SND_SOC_DAPM_POST_PMU:
+		ret_wbits = aic3xxx_wait_bits(aic3262->aic3xxx,
+					      AIC3262_ADC_FLAG, reg_mask,
+					      reg_mask, AIC3262_TIME_DELAY,
+					      AIC3262_DELAY_COUNTER);
+		sync_needed =  aic3xxx_reg_read(aic3262->aic3xxx,
+							AIC3262_DAC_PRB);
+		non_sync_state = dsp_non_sync_mode(aic3262->dsp_runstate);
+		other_dsp = aic3262->dsp_runstate & AIC3XXX_COPS_MDSP_D;
+		if (sync_needed && non_sync_state && other_dsp) {
+			run_state = aic3262_get_runstate(
+						aic3262->codec);
+			aic3262_dsp_pwrdwn_status(aic3262->codec);
+			aic3262_dsp_pwrup(aic3262->codec, run_state);
+		}
+		aic3262->dsp_runstate |= run_state_mask;
+		if (!ret_wbits) {
+			dev_err(w->codec->dev, "ADC POST_PMU timedout\n");
+			return -1;
+		}
+		break;
+	case SND_SOC_DAPM_POST_PMD:
+		ret_wbits = aic3xxx_wait_bits(aic3262->aic3xxx,
+					      AIC3262_ADC_FLAG, reg_mask, 0,
+					      AIC3262_TIME_DELAY,
+					      AIC3262_DELAY_COUNTER);
+		aic3262->dsp_runstate = (aic3262->dsp_runstate &
+					 ~run_state_mask);
+		if (!ret_wbits) {
+			dev_err(w->codec->dev, "ADC POST_PMD timedout\n");
+			return -1;
+		}
+		break;
+	default:
+		BUG();
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static const struct snd_soc_dapm_widget aic3262_dapm_widgets[] = {
+	SND_SOC_DAPM_AIF_IN("DIN1", "ASI1 Playback", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_IN("DIN2", "ASI2 Playback", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_IN("DIN3", "ASI3 Playback", 0, SND_SOC_NOPM, 0, 0),
+
+	SND_SOC_DAPM_DAC_E("Left DAC", NULL, AIC3262_PASI_DAC_DP_SETUP, 7, 0,
+			   aic3262_dac_event, SND_SOC_DAPM_POST_PMU |
+			   SND_SOC_DAPM_POST_PMD),
+	SND_SOC_DAPM_DAC_E("Right DAC", NULL, AIC3262_PASI_DAC_DP_SETUP, 6, 0,
+			   aic3262_dac_event, SND_SOC_DAPM_POST_PMU |
+			   SND_SOC_DAPM_POST_PMD),
+
+	/* dapm widget (path domain) for HPL Output Mixer */
+	SND_SOC_DAPM_MIXER("HP Left Mixer", SND_SOC_NOPM, 0, 0,
+			   &hpl_output_mixer_controls[0],
+			   ARRAY_SIZE(hpl_output_mixer_controls)),
+
+	/* dapm widget (path domain) for HPR Output Mixer */
+	SND_SOC_DAPM_MIXER("HP Right Mixer", SND_SOC_NOPM, 0, 0,
+			   &hpr_output_mixer_controls[0],
+			   ARRAY_SIZE(hpr_output_mixer_controls)),
+
+	SND_SOC_DAPM_PGA_S("HP Left Playback Driver", 5,
+			   AIC3262_HP_AMP_CNTL_R1,
+			   1, 0, aic3262_hp_event,
+			   SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMU |
+			   SND_SOC_DAPM_PRE_PMD | SND_SOC_DAPM_POST_PMD),
+	SND_SOC_DAPM_PGA_S("HP Right Playback Driver", 5,
+			   AIC3262_HP_AMP_CNTL_R1,
+			   0, 0, aic3262_hp_event,
+			   SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMU |
+			   SND_SOC_DAPM_PRE_PMD | SND_SOC_DAPM_POST_PMD),
+
+	/* dapm widget (path domain) for LOL Output Mixer */
+	SND_SOC_DAPM_MIXER("LO Left Mixer", SND_SOC_NOPM, 0, 0,
+			   &lol_output_mixer_controls[0],
+			   ARRAY_SIZE(lol_output_mixer_controls)),
+
+	/* dapm widget (path domain) for LOR Output Mixer mixer */
+	SND_SOC_DAPM_MIXER("LO Right Mixer", SND_SOC_NOPM, 0, 0,
+			   &lor_output_mixer_controls[0],
+			   ARRAY_SIZE(lor_output_mixer_controls)),
+
+	SND_SOC_DAPM_PGA_S("LO Left Playback Driver", 2,
+			 AIC3262_LINE_AMP_CNTL_R1,
+			 1, 0, NULL, 0),
+	SND_SOC_DAPM_PGA_S("LO Right Playback Driver", 2,
+			 AIC3262_LINE_AMP_CNTL_R1,
+			 0, 0, NULL, 0),
+
+	/* dapm widget (path domain) for SPKL Output Mixer */
+	SND_SOC_DAPM_MIXER("SPK Left Mixer", SND_SOC_NOPM, 0, 0,
+			   &spkl_output_mixer_controls[0],
+			   ARRAY_SIZE(spkl_output_mixer_controls)),
+
+	/* dapm widget (path domain) for SPKR Output Mixer */
+	SND_SOC_DAPM_MIXER("SPK Right Mixer", SND_SOC_NOPM, 0, 0,
+			   &spkr_output_mixer_controls[0],
+			   ARRAY_SIZE(spkr_output_mixer_controls)),
+
+	SND_SOC_DAPM_PGA_S("SPK Left Playback Driver", 3,
+			   AIC3262_SPK_AMP_CNTL_R1,
+			   1, 0, aic3262_spk_event,
+			   SND_SOC_DAPM_POST_PMD | SND_SOC_DAPM_POST_PMU),
+	SND_SOC_DAPM_PGA_S("SPK Right Playback Driver", 3,
+			   AIC3262_SPK_AMP_CNTL_R1,
+			   0, 0, aic3262_spk_event,
+			   SND_SOC_DAPM_POST_PMD | SND_SOC_DAPM_POST_PMU),
+
+	/* dapm widget (path domain) for SPKR Output Mixer */
+	SND_SOC_DAPM_MIXER("REC Mixer", SND_SOC_NOPM, 0, 0,
+			   &rec_output_mixer_controls[0],
+			   ARRAY_SIZE(rec_output_mixer_controls)),
+
+	SND_SOC_DAPM_PGA_S("RECP Playback Driver", 3, AIC3262_REC_AMP_CNTL_R5,
+			 7, 0, NULL, 0),
+	SND_SOC_DAPM_PGA_S("RECM Playback Driver", 3, AIC3262_REC_AMP_CNTL_R5,
+			 6, 0, NULL, 0),
+
+	SND_SOC_DAPM_MUX("ASI1LIN Route",
+			 SND_SOC_NOPM, 0, 0, &asi1lin_control),
+	SND_SOC_DAPM_MUX("ASI1RIN Route",
+			 SND_SOC_NOPM, 0, 0, &asi1rin_control),
+	SND_SOC_DAPM_MUX("ASI2LIN Route",
+			 SND_SOC_NOPM, 0, 0, &asi2lin_control),
+	SND_SOC_DAPM_MUX("ASI2RIN Route",
+			 SND_SOC_NOPM, 0, 0, &asi2rin_control),
+	SND_SOC_DAPM_MUX("ASI3LIN Route",
+			 SND_SOC_NOPM, 0, 0, &asi3lin_control),
+	SND_SOC_DAPM_MUX("ASI3RIN Route",
+			 SND_SOC_NOPM, 0, 0, &asi3rin_control),
+
+	SND_SOC_DAPM_PGA("ASI1LIN", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("ASI1RIN", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("ASI2LIN", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("ASI2RIN", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("ASI3LIN", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("ASI3RIN", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("ASI1MonoMixIN", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("ASI2MonoMixIN", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("ASI3MonoMixIN", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("ASI1IN Port", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("ASI2IN Port", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("ASI3IN Port", SND_SOC_NOPM, 0, 0, NULL, 0),
+
+	SND_SOC_DAPM_MUX("DAC MiniDSP IN1 Route",
+			 SND_SOC_NOPM, 0, 0, &dacminidspin1_control),
+	SND_SOC_DAPM_MUX("DAC MiniDSP IN2 Route",
+			 SND_SOC_NOPM, 0, 0, &dacminidspin2_control),
+	SND_SOC_DAPM_MUX("DAC MiniDSP IN3 Route",
+			 SND_SOC_NOPM, 0, 0, &dacminidspin3_control),
+
+	SND_SOC_DAPM_VIRT_MUX("ADC DAC Route",
+			      SND_SOC_NOPM, 0, 0, &adcdacroute_control),
+
+	SND_SOC_DAPM_PGA("CM", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("CM1 Left Capture", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("CM2 Left Capture", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("CM1 Right Capture", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("CM2 Right Capture", SND_SOC_NOPM, 0, 0, NULL, 0),
+
+	SND_SOC_DAPM_AIF_OUT("DOUT1", "ASI1 Capture", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_OUT("DOUT2", "ASI2 Capture", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_OUT("DOUT3", "ASI3 Capture", 0, SND_SOC_NOPM, 0, 0),
+
+	SND_SOC_DAPM_MUX("DOUT1 Route",
+			 SND_SOC_NOPM, 0, 0, &dout1_control),
+	SND_SOC_DAPM_MUX("DOUT2 Route",
+			 SND_SOC_NOPM, 0, 0, &dout2_control),
+	SND_SOC_DAPM_MUX("DOUT3 Route",
+			 SND_SOC_NOPM, 0, 0, &dout3_control),
+
+	SND_SOC_DAPM_PGA("ASI1OUT", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("ASI2OUT", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("ASI3OUT", SND_SOC_NOPM, 0, 0, NULL, 0),
+
+	SND_SOC_DAPM_MUX("ASI1OUT Route",
+			 SND_SOC_NOPM, 0, 0, &asi1out_control),
+	SND_SOC_DAPM_MUX("ASI2OUT Route",
+			 SND_SOC_NOPM, 0, 0, &asi2out_control),
+	SND_SOC_DAPM_MUX("ASI3OUT Route",
+			 SND_SOC_NOPM, 0, 0, &asi3out_control),
+
+	SND_SOC_DAPM_PGA("ADC MiniDSP OUT1", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("ADC MiniDSP OUT2", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("ADC MiniDSP OUT3", SND_SOC_NOPM, 0, 0, NULL, 0),
+
+	SND_SOC_DAPM_MUX("Left ADC Route", SND_SOC_NOPM, 0, 0, &adcl_mux),
+	SND_SOC_DAPM_MUX("Right ADC Route", SND_SOC_NOPM, 0, 0, &adcr_mux),
+
+	SND_SOC_DAPM_ADC_E("Left ADC", NULL, AIC3262_ADC_CHANNEL_POW, 7, 0,
+			   aic3262_adc_dsp_event, SND_SOC_DAPM_POST_PMU |
+			   SND_SOC_DAPM_POST_PMD),
+	SND_SOC_DAPM_ADC_E("Right ADC", NULL, AIC3262_ADC_CHANNEL_POW, 6, 0,
+			   aic3262_adc_dsp_event, SND_SOC_DAPM_POST_PMU |
+			   SND_SOC_DAPM_POST_PMD),
+
+	SND_SOC_DAPM_PGA_S("Left MicPGA", 0, AIC3262_MICL_PGA, 7, 1, NULL, 0),
+	SND_SOC_DAPM_PGA_S("Right MicPGA", 0, AIC3262_MICR_PGA, 7, 1, NULL, 0),
+
+	SND_SOC_DAPM_PGA_S("MA Left Playback PGA", 1, AIC3262_MA_CNTL,
+			 3, 0, NULL, 0),
+	SND_SOC_DAPM_PGA_S("MA Right Playback PGA", 1, AIC3262_MA_CNTL,
+			 2, 0, NULL, 0),
+
+	/* dapm widget for MAL PGA Mixer */
+	SND_SOC_DAPM_MIXER("MA Left PGA Mixer", SND_SOC_NOPM, 0, 0,
+			   &mal_pga_mixer_controls[0],
+			   ARRAY_SIZE(mal_pga_mixer_controls)),
+
+	/* dapm widget for MAR PGA Mixer */
+	SND_SOC_DAPM_MIXER("MA Right PGA Mixer", SND_SOC_NOPM, 0, 0,
+			   &mar_pga_mixer_controls[0],
+			   ARRAY_SIZE(mar_pga_mixer_controls)),
+
+	/* dapm widget for Left Input Mixer */
+	SND_SOC_DAPM_MIXER("Left Input Mixer", SND_SOC_NOPM, 0, 0,
+			   &left_input_mixer_controls[0],
+			   ARRAY_SIZE(left_input_mixer_controls)),
+
+	/* dapm widget for Right Input Mixer */
+	SND_SOC_DAPM_MIXER("Right Input Mixer", SND_SOC_NOPM, 0, 0,
+			   &right_input_mixer_controls[0],
+			   ARRAY_SIZE(right_input_mixer_controls)),
+
+	SND_SOC_DAPM_OUTPUT("HP Left Playback"),
+	SND_SOC_DAPM_OUTPUT("HP Right Playback"),
+	SND_SOC_DAPM_OUTPUT("LO Left Playback"),
+	SND_SOC_DAPM_OUTPUT("LO Right Playback"),
+	SND_SOC_DAPM_OUTPUT("SPK Left Playback"),
+	SND_SOC_DAPM_OUTPUT("SPK Right Playback"),
+	SND_SOC_DAPM_OUTPUT("RECP Playback"),
+	SND_SOC_DAPM_OUTPUT("RECM Playback"),
+
+	SND_SOC_DAPM_INPUT("IN1 Left Capture"),
+	SND_SOC_DAPM_INPUT("IN2 Left Capture"),
+	SND_SOC_DAPM_INPUT("IN3 Left Capture"),
+	SND_SOC_DAPM_INPUT("IN4 Left Capture"),
+	SND_SOC_DAPM_INPUT("IN1 Right Capture"),
+	SND_SOC_DAPM_INPUT("IN2 Right Capture"),
+	SND_SOC_DAPM_INPUT("IN3 Right Capture"),
+	SND_SOC_DAPM_INPUT("IN4 Right Capture"),
+	SND_SOC_DAPM_INPUT("Left DMIC Capture"),
+	SND_SOC_DAPM_INPUT("Right DMIC Capture"),
+
+	SND_SOC_DAPM_MICBIAS("Mic Bias Ext", AIC3262_MIC_BIAS_CNTL, 6, 0),
+	SND_SOC_DAPM_MICBIAS("Mic Bias Int", AIC3262_MIC_BIAS_CNTL, 2, 0),
+
+	SND_SOC_DAPM_SUPPLY_S("PLLCLK", 0, AIC3262_PLL_PR_POW_REG, 7, 0,
+			    pll_power_on_event, SND_SOC_DAPM_POST_PMU),
+	SND_SOC_DAPM_SUPPLY_S("DACCLK", 2, AIC3262_NDAC_DIV_POW_REG,
+			    7, 0, NULL, 0),
+	SND_SOC_DAPM_SUPPLY_S("CODEC_CLK_IN", 1, SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_SUPPLY_S("DAC_MOD_CLK", 3, AIC3262_MDAC_DIV_POW_REG,
+			    7, 0, NULL, 0),
+	SND_SOC_DAPM_SUPPLY_S("ADCCLK", 2, AIC3262_NADC_DIV_POW_REG,
+			    7, 0, NULL, 0),
+	SND_SOC_DAPM_SUPPLY_S("ADC_MOD_CLK", 3, AIC3262_MADC_DIV_POW_REG,
+			    7, 0, NULL, 0),
+};
+
+static const struct snd_soc_dapm_route aic3262_dapm_routes[] = {
+	/* Clock portion */
+	{"CODEC_CLK_IN", NULL, "PLLCLK"},
+	{"DACCLK", NULL, "CODEC_CLK_IN"},
+	{"ADCCLK", NULL, "CODEC_CLK_IN"},
+	{"DAC_MOD_CLK", NULL, "DACCLK"},
+#ifdef AIC3262_SYNC_MODE
+	{"ADC_MOD_CLK", NULL, "DACCLK"},
+#else
+	{"ADC_MOD_CLK", NULL, "ADCCLK"},
+#endif
+
+	{"Left DAC", NULL, "DAC_MOD_CLK"},
+	{"Right DAC", NULL, "DAC_MOD_CLK"},
+	/* When we are master, ASI bclk and wclk are generated by
+	 * DAC_MOD_CLK, so we put them as dependency for ADC too.
+	 */
+	{"Left ADC", NULL, "DAC_MOD_CLK"},
+	{"Right ADC", NULL, "DAC_MOD_CLK"},
+	{"Left ADC", NULL, "ADC_MOD_CLK"},
+	{"Right ADC", NULL, "ADC_MOD_CLK"},
+	/* Playback (DAC) Portion */
+	{"HP Left Mixer", "Left DAC Playback Switch", "Left DAC"},
+	{"HP Left Mixer", "MA Left Playback Switch", "MA Left Playback PGA"},
+	{"HP Left Mixer", "LO Left-B1 Playback Volume", "LO Left Playback"},
+
+	{"HP Right Mixer", "LO Right-B1 Playback Volume", "LO Right Playback"},
+	{"HP Right Mixer", "Left DAC Playback Switch", "Left DAC"},
+	{"HP Right Mixer", "Right DAC Playback Switch", "Right DAC"},
+	{"HP Right Mixer", "MA Right Playback Switch", "MA Right Playback PGA"},
+
+	{"HP Left Playback Driver", NULL, "HP Left Mixer"},
+	{"HP Right Playback Driver", NULL, "HP Right Mixer"},
+
+	{"HP Left Playback", NULL, "HP Left Playback Driver"},
+	{"HP Right Playback", NULL, "HP Right Playback Driver"},
+
+	{"LO Left Mixer", "MA Left Playback Switch", "MA Left Playback PGA"},
+	{"LO Left Mixer", "IN1 Left-B Capture Switch", "IN1 Left Capture"},
+	{"LO Left Mixer", "Left DAC Playback Switch", "Left DAC"},
+	{"LO Left Mixer", "Right DAC Playback Switch", "Right DAC"},
+
+	{"LO Right Mixer", "LO Left Playback Switch", "LO Left Playback"},
+	{"LO Right Mixer", "Right DAC Playback Switch", "Right DAC"},
+	{"LO Right Mixer", "MA Right Playback Switch", "MA Right Playback PGA"},
+	{"LO Right Mixer", "IN1 Right-B Capture Switch", "IN1 Right Capture"},
+
+	{"LO Left Playback Driver", NULL, "LO Left Mixer"},
+	{"LO Right Playback Driver", NULL, "LO Right Mixer"},
+
+	{"LO Left Playback", NULL, "LO Left Playback Driver"},
+	{"LO Right Playback", NULL, "LO Right Playback Driver"},
+
+	{"REC Mixer", "LO Left-B2 Playback Volume", "LO Left Playback"},
+	{"REC Mixer", "IN1 Left Capture Volume", "IN1 Left Capture"},
+	{"REC Mixer", "IN1 Right Capture Volume", "IN1 Right Capture"},
+	{"REC Mixer", "LO Right-B2 Playback Volume", "LO Right Playback"},
+
+	{"RECP Playback Driver", NULL, "REC Mixer"},
+	{"RECM Playback Driver", NULL, "REC Mixer"},
+
+	{"RECP Playback", NULL, "RECP Playback Driver"},
+	{"RECM Playback", NULL, "RECM Playback Driver"},
+
+	{"SPK Left Mixer", "MA Left Playback Switch", "MA Left Playback PGA"},
+	{"SPK Left Mixer", "LO Left Playback Volume", "LO Left Playback"},
+	{"SPK Left Mixer", "SPR_IN Switch", "SPK Right Mixer"},
+
+	{"SPK Right Mixer", "LO Right Playback Volume", "LO Right Playback"},
+	{"SPK Right Mixer", "MA Right Playback Switch",
+	 "MA Right Playback PGA"},
+
+	{"SPK Left Playback Driver", NULL, "SPK Left Mixer"},
+	{"SPK Right Playback Driver", NULL, "SPK Right Mixer"},
+
+	{"SPK Left Playback", NULL, "SPK Left Playback Driver"},
+	{"SPK Right Playback", NULL, "SPK Right Playback Driver"},
+	/* ASI Input routing */
+	{"ASI1LIN", NULL, "DIN1"},
+	{"ASI1RIN", NULL, "DIN1"},
+	{"ASI1MonoMixIN", NULL, "DIN1"},
+	{"ASI2LIN", NULL, "DIN2"},
+	{"ASI2RIN", NULL, "DIN2"},
+	{"ASI2MonoMixIN", NULL, "DIN2"},
+	{"ASI3LIN", NULL, "DIN3"},
+	{"ASI3RIN", NULL, "DIN3"},
+	{"ASI3MonoMixIN", NULL, "DIN3"},
+
+	{"ASI1LIN Route", "ASI1 Left In", "ASI1LIN"},
+	{"ASI1LIN Route", "ASI1 Right In", "ASI1RIN"},
+	{"ASI1LIN Route", "ASI1 MonoMix In", "ASI1MonoMixIN"},
+
+	{"ASI1RIN Route", "ASI1 Right In", "ASI1RIN"},
+	{"ASI1RIN Route", "ASI1 Left In", "ASI1LIN"},
+	{"ASI1RIN Route", "ASI1 MonoMix In", "ASI1MonoMixIN"},
+
+	{"ASI2LIN Route", "ASI2 Left In", "ASI2LIN"},
+	{"ASI2LIN Route", "ASI2 Right In", "ASI2RIN"},
+	{"ASI2LIN Route", "ASI2 MonoMix In", "ASI2MonoMixIN"},
+
+	{"ASI2RIN Route", "ASI2 Right In", "ASI2RIN"},
+	{"ASI2RIN Route", "ASI2 Left In", "ASI2LIN"},
+	{"ASI2RIN Route", "ASI2 MonoMix In", "ASI2MonoMixIN"},
+
+	{"ASI3LIN Route", "ASI3 Left In", "ASI3LIN"},
+	{"ASI3LIN Route", "ASI3 Right In", "ASI3RIN"},
+	{"ASI3LIN Route", "ASI3 MonoMix In", "ASI3MonoMixIN"},
+
+	{"ASI3RIN Route", "ASI3 Right In", "ASI3RIN"},
+	{"ASI3RIN Route", "ASI3 Left In", "ASI3LIN"},
+	{"ASI3RIN Route", "ASI3 MonoMix In", "ASI3MonoMixIN"},
+
+	{"ASI1IN Port", NULL, "ASI1LIN Route"},
+	{"ASI1IN Port", NULL, "ASI1RIN Route"},
+	{"ASI2IN Port", NULL, "ASI2LIN Route"},
+	{"ASI2IN Port", NULL, "ASI2RIN Route"},
+	{"ASI3IN Port", NULL, "ASI3LIN Route"},
+	{"ASI3IN Port", NULL, "ASI3RIN Route"},
+
+	{"DAC MiniDSP IN1 Route", "ASI1 In", "ASI1IN Port"},
+	{"DAC MiniDSP IN1 Route", "ASI2 In", "ASI2IN Port"},
+	{"DAC MiniDSP IN1 Route", "ASI3 In", "ASI3IN Port"},
+	{"DAC MiniDSP IN1 Route", "ADC MiniDSP Out", "ADC MiniDSP OUT1"},
+
+	{"DAC MiniDSP IN2 Route", "ASI1 In", "ASI1IN Port"},
+	{"DAC MiniDSP IN2 Route", "ASI2 In", "ASI2IN Port"},
+	{"DAC MiniDSP IN2 Route", "ASI3 In", "ASI3IN Port"},
+
+	{"DAC MiniDSP IN3 Route", "ASI1 In", "ASI1IN Port"},
+	{"DAC MiniDSP IN3 Route", "ASI2 In", "ASI2IN Port"},
+	{"DAC MiniDSP IN3 Route", "ASI3 In", "ASI3IN Port"},
+
+	{"Left DAC", "NULL", "DAC MiniDSP IN1 Route"},
+	{"Right DAC", "NULL", "DAC MiniDSP IN1 Route"},
+	{"Left DAC", "NULL", "DAC MiniDSP IN2 Route"},
+	{"Right DAC", "NULL", "DAC MiniDSP IN2 Route"},
+	{"Left DAC", "NULL", "DAC MiniDSP IN3 Route"},
+	{"Right DAC", "NULL", "DAC MiniDSP IN3 Route"},
+
+	/* Mixer Amplifier */
+	{"MA Left PGA Mixer", "IN1 Left Capture Switch", "IN1 Left Capture"},
+	{"MA Left PGA Mixer", "Left MicPGA Volume", "Left MicPGA"},
+
+	{"MA Left Playback PGA", NULL, "MA Left PGA Mixer"},
+
+	{"MA Right PGA Mixer", "IN1 Right Capture Switch", "IN1 Right Capture"},
+	{"MA Right PGA Mixer", "Right MicPGA Volume", "Right MicPGA"},
+
+	{"MA Right Playback PGA", NULL, "MA Right PGA Mixer"},
+
+	/* Virtual connection between DAC and ADC for miniDSP IPC */
+	{"ADC DAC Route", "On", "Left ADC"},
+	{"ADC DAC Route", "On", "Right ADC"},
+
+	{"Left DAC", NULL, "ADC DAC Route"},
+	{"Right DAC", NULL, "ADC DAC Route"},
+
+	/* Capture (ADC) portions */
+	/* Left Positive PGA input */
+	{"Left Input Mixer", "IN1 Left Capture Switch", "IN1 Left Capture"},
+	{"Left Input Mixer", "IN2 Left Capture Switch", "IN2 Left Capture"},
+	{"Left Input Mixer", "IN3 Left Capture Switch", "IN3 Left Capture"},
+	{"Left Input Mixer", "IN4 Left Capture Switch", "IN4 Left Capture"},
+	{"Left Input Mixer", "IN1 Right Capture Switch", "IN1 Right Capture"},
+	/* Left Negative PGA input */
+	{"Left Input Mixer", "IN2 Right Capture Switch", "IN2 Right Capture"},
+	{"Left Input Mixer", "IN3 Right Capture Switch", "IN3 Right Capture"},
+	{"Left Input Mixer", "IN4 Right Capture Switch", "IN4 Right Capture"},
+	{"Left Input Mixer", "CM2 Left Capture Switch", "CM2 Left Capture"},
+	{"Left Input Mixer", "CM1 Left Capture Switch", "CM1 Left Capture"},
+
+	/* Right Positive PGA Input */
+	{"Right Input Mixer", "IN1 Right Capture Switch", "IN1 Right Capture"},
+	{"Right Input Mixer", "IN2 Right Capture Switch", "IN2 Right Capture"},
+	{"Right Input Mixer", "IN3 Right Capture Switch", "IN3 Right Capture"},
+	{"Right Input Mixer", "IN4 Right Capture Switch", "IN4 Right Capture"},
+	{"Right Input Mixer", "IN2 Left Capture Switch", "IN2 Left Capture"},
+	/* Right Negative PGA Input */
+	{"Right Input Mixer", "IN1 Left Capture Switch", "IN1 Left Capture"},
+	{"Right Input Mixer", "IN3 Left Capture Switch", "IN3 Left Capture"},
+	{"Right Input Mixer", "IN4 Left Capture Switch", "IN4 Left Capture"},
+	{"Right Input Mixer", "CM1 Right Capture Switch", "CM1 Right Capture"},
+	{"Right Input Mixer", "CM2 Right Capture Switch", "CM2 Right Capture"},
+
+	{"CM1 Left Capture", NULL, "CM"},
+	{"CM2 Left Capture", NULL, "CM"},
+	{"CM1 Right Capture", NULL, "CM"},
+	{"CM2 Right Capture", NULL, "CM"},
+
+	{"Left MicPGA", NULL, "Left Input Mixer"},
+	{"Right MicPGA", NULL, "Right Input Mixer"},
+
+	{"Left ADC Route", "Analog", "Left MicPGA"},
+	{"Left ADC Route", "Digital", "Left DMIC Capture"},
+
+	{"Right ADC Route", "Analog", "Right MicPGA"},
+	{"Right ADC Route", "Digital", "Right DMIC Capture"},
+
+	{"Left ADC", NULL, "Left ADC Route"},
+	{"Right ADC", NULL, "Right ADC Route"},
+
+	/* ASI Output Routing */
+	{"ADC MiniDSP OUT1", NULL, "Left ADC"},
+	{"ADC MiniDSP OUT1", NULL, "Right ADC"},
+	{"ADC MiniDSP OUT2", NULL, "Left ADC"},
+	{"ADC MiniDSP OUT2", NULL, "Right ADC"},
+	{"ADC MiniDSP OUT3", NULL, "Left ADC"},
+	{"ADC MiniDSP OUT3", NULL, "Right ADC"},
+
+	{"ASI1OUT Route", "ADC MiniDSP Out1", "ADC MiniDSP OUT1"},
+	{"ASI1OUT Route", "ASI1In Bypass", "ASI1IN Port"},
+	{"ASI1OUT Route", "ASI2In Bypass", "ASI2IN Port"},
+	{"ASI1OUT Route", "ASI3In Bypass", "ASI3IN Port"},
+
+	{"ASI2OUT Route", "ADC MiniDSP Out1", "ADC MiniDSP OUT1"},
+	{"ASI2OUT Route", "ASI1In Bypass", "ASI1IN Port"},
+	{"ASI2OUT Route", "ASI2In Bypass", "ASI2IN Port"},
+	{"ASI2OUT Route", "ASI3In Bypass", "ASI3IN Port"},
+	{"ASI2OUT Route", "ADC MiniDSP Out2", "ADC MiniDSP OUT2"},
+
+	{"ASI3OUT Route", "ADC MiniDSP Out1", "ADC MiniDSP OUT1"},
+	{"ASI3OUT Route", "ASI1In Bypass", "ASI1IN Port"},
+	{"ASI3OUT Route", "ASI2In Bypass", "ASI2IN Port"},
+	{"ASI3OUT Route", "ASI3In Bypass", "ASI3IN Port"},
+	{"ASI3OUT Route", "ADC MiniDSP Out3", "ADC MiniDSP OUT3"},
+
+	{"ASI1OUT", NULL, "ASI1OUT Route"},
+	{"ASI2OUT", NULL, "ASI2OUT Route"},
+	{"ASI3OUT", NULL, "ASI3OUT Route"},
+
+	{"DOUT1 Route", "ASI1 Out", "ASI1OUT"},
+	{"DOUT1 Route", "DIN1 Bypass", "DIN1"},
+	{"DOUT1 Route", "DIN2 Bypass", "DIN2"},
+	{"DOUT1 Route", "DIN3 Bypass", "DIN3"},
+
+	{"DOUT2 Route", "ASI2 Out", "ASI2OUT"},
+	{"DOUT2 Route", "DIN1 Bypass", "DIN1"},
+	{"DOUT2 Route", "DIN2 Bypass", "DIN2"},
+	{"DOUT2 Route", "DIN3 Bypass", "DIN3"},
+
+	{"DOUT3 Route", "ASI3 Out", "ASI3OUT"},
+	{"DOUT3 Route", "DIN1 Bypass", "DIN1"},
+	{"DOUT3 Route", "DIN2 Bypass", "DIN2"},
+	{"DOUT3 Route", "DIN3 Bypass", "DIN3"},
+
+	{"DOUT1", NULL, "DOUT1 Route"},
+	{"DOUT2", NULL, "DOUT2 Route"},
+	{"DOUT3", NULL, "DOUT3 Route"},
+};
+
+#define AIC3262_DAPM_ROUTE_NUM (ARRAY_SIZE(aic3262_dapm_routes)/ \
+					sizeof(struct snd_soc_dapm_route))
+/* aic3262_firmware_load:   This function is called by the
+ *		request_firmware_nowait function as soon
+ *		as the firmware has been loaded from the file.
+ *		The firmware structure contains the data and$
+ *		the size of the firmware loaded.
+ * @fw: pointer to firmware file to be dowloaded
+ * @context: pointer variable to codec
+ *
+ * Returns 0 for success.
+ */
+static void aic3262_firmware_load(const struct firmware *fw, void *context)
+{
+	struct snd_soc_codec *codec = context;
+	struct aic3262_priv *private_ds = snd_soc_codec_get_drvdata(codec);
+	int ret = 0;
+
+	aic_lock(private_ds->cfw_p, 1);
+	if (private_ds->cur_fw != NULL)
+		release_firmware(private_ds->cur_fw);
+	private_ds->cur_fw = NULL;
+
+	if (fw != NULL) {
+		dev_dbg(codec->dev, "Firmware binary load\n");
+		private_ds->cur_fw = (void *)fw;
+		ret = aic_reload(private_ds->cfw_p, (void *)fw->data,
+			fw->size);
+		if (ret < 0) { /* reload failed */
+			dev_err(codec->dev, "Firmware binary load failed\n");
+			release_firmware(private_ds->cur_fw);
+			private_ds->cur_fw = NULL;
+			fw = NULL;
+		}
+	} else {
+		dev_err(codec->dev, "request_firmware failed\n");
+		ret = -1;
+	}
+
+	aic_lock(private_ds->cfw_p, 0);
+	if (ret >= 0) {
+		/*init function for transition */
+		aic_transition(private_ds->cfw_p, "INIT");
+		/* add firmware modes */
+		aic_add_modes(codec, private_ds->cfw_p);
+		/* add runtime controls */
+		aic_add_controls(codec, private_ds->cfw_p);
+		/* set the default firmware mode */
+		aic_setmode_cfg(private_ds->cfw_p, 0, 0);
+	}
+
+}
+
+/*=========================================================
+
+ headset work and headphone/headset jack interrupt handlers
+
+ ========================================================*/
+
+enum headset_accessory_state {
+	BIT_NO_ACCESSORY = 0,
+	BIT_HEADSET = (1 << 0),
+	BIT_HEADPHONE = (1 << 1),
+};
+
+/**
+ * aic3262_hs_jack_report: Report jack notication to upper layor
+ * @codec: pointer variable to codec having information related to codec
+ * @jack: Pointer variable to snd_soc_jack having information of codec
+ *		 and pin number$
+ * @report: Provides informaton of whether it is headphone or microphone
+ *
+*/
+static void aic3262_hs_jack_report(struct snd_soc_codec *codec,
+				   struct snd_soc_jack *jack, int report)
+{
+	struct aic3262_priv *aic3262 = snd_soc_codec_get_drvdata(codec);
+	int status, state = 0, switch_state = BIT_NO_ACCESSORY;
+
+	mutex_lock(&aic3262->mutex);
+
+	/* Sync status */
+	status = snd_soc_read(codec, AIC3262_DAC_FLAG);
+
+	switch (status & AIC3262_JACK_TYPE_MASK) {
+	case AIC3262_JACK_WITH_MIC:
+		state |= SND_JACK_HEADSET;
+		break;
+	case AIC3262_JACK_WITHOUT_MIC:
+		state |= SND_JACK_HEADPHONE;
+	}
+
+	mutex_unlock(&aic3262->mutex);
+
+	snd_soc_jack_report(jack, state, report);
+
+	if ((state & SND_JACK_HEADSET) == SND_JACK_HEADSET)
+		switch_state |= BIT_HEADSET;
+	else if (state & SND_JACK_HEADPHONE)
+		switch_state |= BIT_HEADPHONE;
+
+}
+
+/**
+ * aic3262_hs_jack_detect: Detect headphone jack during boot time
+ * @codec: pointer variable to codec having information related to codec
+ * @jack: Pointer variable to snd_soc_jack having information of codec
+ *	     and pin number$
+ * @report: Provides informaton of whether it is headphone or microphone
+ *
+*/
+void aic3262_hs_jack_detect(struct snd_soc_codec *codec,
+			    struct snd_soc_jack *jack, int report)
+{
+	struct aic3262_priv *aic3262 = snd_soc_codec_get_drvdata(codec);
+	struct aic3262_jack_data *hs_jack = &aic3262->hs_jack;
+
+	hs_jack->jack = jack;
+	hs_jack->report = report;
+	aic3262_hs_jack_report(codec, hs_jack->jack, hs_jack->report);
+}
+EXPORT_SYMBOL_GPL(aic3262_hs_jack_detect);
+/**
+ * aic3262_accessory_work: Finished bottom half work from headphone jack
+ *		insertion interupt
+ * @work: pionter variable to work_struct which is maintaining work queqe
+ *
+*/
+static void aic3262_accessory_work(struct work_struct *work)
+{
+	struct aic3262_priv *aic3262 = container_of(work,
+						    struct aic3262_priv,
+						    delayed_work.work);
+	struct snd_soc_codec *codec = aic3262->codec;
+	struct aic3262_jack_data *hs_jack = &aic3262->hs_jack;
+	aic3262_hs_jack_report(codec, hs_jack->jack, hs_jack->report);
+}
+
+/**
+ * aic3262_audio_handler: audio interrupt handler called
+ *		when interupt is generated
+ * @irq: provides interupt number which is assigned by aic3xxx_request_irq,
+ * @data having information of data passed by aic3xxx_request_irq last arg,
+ *
+ * Return IRQ_HANDLED(means interupt handeled successfully)
+*/
+static irqreturn_t aic3262_audio_handler(int irq, void *data)
+{
+	struct snd_soc_codec *codec = data;
+	struct aic3262_priv *aic3262 = snd_soc_codec_get_drvdata(codec);
+
+	queue_delayed_work(aic3262->workqueue, &aic3262->delayed_work,
+			   msecs_to_jiffies(200));
+	return IRQ_HANDLED;
+}
+
+/**
+ * Methods for CFW Operations
+ *
+ * Due to incompatibilites between structures used by MFD and CFW
+ * we need to transform the register format before linking to
+ * CFW operations.
+ */
+static inline unsigned int aic3262_ops_cfw2reg(unsigned int reg)
+{
+	union aic_register *c = (union aic_register *) &reg;
+	union aic3xxx_reg_union mreg;
+
+	mreg.aic3xxx_register.offset = c->offset;
+	mreg.aic3xxx_register.page = c->page;
+	mreg.aic3xxx_register.book = c->book;
+	mreg.aic3xxx_register.reserved = 0;
+	return mreg.aic3xxx_register_int;
+}
+static int aic3262_ops_reg_read(struct snd_soc_codec *codec, unsigned int reg)
+{
+	struct aic3262_priv *aic3262 = snd_soc_codec_get_drvdata(codec);
+
+	return aic3xxx_reg_read(aic3262->aic3xxx, aic3262_ops_cfw2reg(reg));
+}
+
+static int aic3262_ops_reg_write(struct snd_soc_codec *codec, unsigned int reg,
+			  unsigned char val)
+{
+	struct aic3262_priv *aic3262 = snd_soc_codec_get_drvdata(codec);
+
+	return aic3xxx_reg_write(aic3262->aic3xxx,
+					aic3262_ops_cfw2reg(reg), val);
+}
+
+static int aic3262_ops_set_bits(struct snd_soc_codec *codec, unsigned int reg,
+				unsigned char mask, unsigned char val)
+{
+	struct aic3262_priv *aic3262 = snd_soc_codec_get_drvdata(codec);
+
+	return aic3xxx_set_bits(aic3262->aic3xxx,
+					aic3262_ops_cfw2reg(reg), mask, val);
+
+}
+
+static int aic3262_ops_bulk_read(struct snd_soc_codec *codec, unsigned int reg,
+				 int count, u8 *buf)
+{
+	struct aic3262_priv *aic3262 = snd_soc_codec_get_drvdata(codec);
+
+	return aic3xxx_bulk_read(aic3262->aic3xxx,
+					aic3262_ops_cfw2reg(reg), count, buf);
+}
+
+static int aic3262_ops_bulk_write(struct snd_soc_codec *codec, unsigned int reg,
+			   int count, const u8 *buf)
+{
+	struct aic3262_priv *aic3262 = snd_soc_codec_get_drvdata(codec);
+
+	return aic3xxx_bulk_write(aic3262->aic3xxx,
+					aic3262_ops_cfw2reg(reg), count, buf);
+}
+
+/**
+ * aic3262_ops_lockk: To Read the run state of the DAC and ADC
+ *			by reading the codec and returning the run state
+ * @codec: pointer argument to the codec
+ *
+ * Run state Bit format
+ *
+ * ------------------------------------------------------
+ * D31|..........| D7 | D6|  D5  |  D4  | D3 | D2 | D1  |   D0  |
+ * R               R    R   LADC   RADC    R    R   LDAC   RDAC
+ * ------------------------------------------------------
+ *
+ * R- Reserved
+ * LDAC- Left DAC
+ * RDAC- Right DAC
+ *
+ * Return value  : Integer
+ */
+static int aic3262_ops_lock(struct snd_soc_codec *codec)
+{
+	mutex_lock(&codec->mutex);
+	/* Reading the run state of adc and dac */
+	return aic3262_get_runstate(codec);
+
+}
+
+/**
+ * aic3262_ops_unlock: To unlock the mutex acqiured for reading
+ *			run state of the codec
+ * @codec: pointer argument to the codec
+ *
+ * Return Value: integer returning 0
+ */
+static int aic3262_ops_unlock(struct snd_soc_codec *codec)
+{
+	/*Releasing the lock of mutex */
+	mutex_unlock(&codec->mutex);
+	return 0;
+}
+
+/**
+ * aic3262_ops_stop:
+ * @codec: pointer Argument to the codec
+ * @mask: tells us the bit format of the codec running state
+ *
+ * Bit Format:
+ * ------------------------------------------------------
+ * D31|..........| D7 | D6| D5 | D4 | D3 | D2 | D1 | D0 |
+ * R               R    R   AL   AR    R    R   DL   DR
+ * ------------------------------------------------------
+ * R  - Reserved
+ * A  - minidsp_A
+ * D  - minidsp_D
+ *
+ * Return: return run state
+ */
+static int aic3262_ops_stop(struct snd_soc_codec *codec, int mask)
+{
+	int run_state = 0;
+	struct aic3262_priv *aic3262 = snd_soc_codec_get_drvdata(codec);
+
+	run_state = aic3262_get_runstate(codec);
+
+	if (mask & AIC3XXX_COPS_MDSP_A)
+		aic3xxx_set_bits(aic3262->aic3xxx,
+				 AIC3262_ADC_DATAPATH_SETUP, 0xC0, 0);
+
+	if (mask & AIC3XXX_COPS_MDSP_D)
+		aic3xxx_set_bits(aic3262->aic3xxx,
+				 AIC3262_DAC_DATAPATH_SETUP, 0xC0, 0);
+
+	if ((mask & AIC3XXX_COPS_MDSP_A) &&
+		!aic3xxx_wait_bits(aic3262->aic3xxx,
+				      AIC3262_ADC_FLAG, AIC3262_ADC_POWER_MASK,
+				      0, AIC3262_TIME_DELAY,
+				      AIC3262_DELAY_COUNTER))
+		goto err;
+
+	if ((mask & AIC3XXX_COPS_MDSP_D) &&
+		!aic3xxx_wait_bits(aic3262->aic3xxx,
+				      AIC3262_DAC_FLAG, AIC3262_DAC_POWER_MASK,
+				      0, AIC3262_TIME_DELAY,
+				      AIC3262_DELAY_COUNTER))
+		goto err;
+
+	return run_state;
+err:
+	dev_err(codec->dev, "Unable to turn off ADCs or DACs at [%s:%d]",
+				__FILE__, __LINE__);
+	return -EINVAL;
+}
+
+/**
+ * aic3262_ops_restore: To unlock the mutex acqiured for reading
+ * @codec: pointer argument to the codec,run_state
+ * @run_state:  run state of the codec and to restore the states of the dsp
+ *
+ * Return Value	: integer returning 0
+ */
+
+static int aic3262_ops_restore(struct snd_soc_codec *codec, int run_state)
+{
+	int sync_state;
+	struct aic3262_priv *aic3262 = snd_soc_codec_get_drvdata(codec);
+
+
+	/* This is for read the sync mode register state  */
+	sync_state = aic3xxx_reg_read(aic3262->aic3xxx, AIC3262_DAC_PRB);
+
+	/*checking whether the sync mode has been set or
+	   not and checking the current state */
+	if (((run_state & 0x30) && (run_state & 0x03)) && (sync_state & 0x80))
+		aic3262_restart_dsps_sync(codec, run_state);
+	else
+		aic3262_dsp_pwrup(codec, run_state);
+
+	return 0;
+}
+
+/**
+ * aic3262_ops_adaptivebuffer_swap: To swap the coefficient buffers
+ *				 of minidsp according to mask
+ * @codec: pointer argument to the codec,
+ * @mask: tells us which dsp has to be chosen for swapping
+ *
+ * Return Value    : returning 0 on success
+ */
+int aic3262_ops_adaptivebuffer_swap(struct snd_soc_codec *codec, int mask)
+{
+	struct aic3262_priv *aic3262 = snd_soc_codec_get_drvdata(codec);
+	const int sbuf[][2] = {
+		{ AIC3XXX_ABUF_MDSP_A, AIC3262_ADC_ADAPTIVE_CRAM_REG },
+		{ AIC3XXX_ABUF_MDSP_D1, AIC3262_DAC_ADAPTIVE_BANK1_REG },
+		{ AIC3XXX_ABUF_MDSP_D2, AIC3262_DAC_ADAPTIVE_BANK2_REG },
+	};
+	int i, ret;
+
+	for (i = 0; i < sizeof(sbuf)/sizeof(sbuf[0]); ++i) {
+		if ((mask & sbuf[i][0])) {
+			aic3xxx_set_bits(aic3262->aic3xxx, sbuf[i][1],
+					0x1, 0x1);
+			ret = aic3xxx_wait_bits(aic3262->aic3xxx, sbuf[i][1],
+					      0x1, 0, 5, 1);
+			if (!ret) {
+				dev_err(codec->dev,
+				"miniDSP buffer swap failure");
+				return -EINVAL;
+			}
+		}
+	}
+		return 0;
+}
+
+/**
+ * aic3262_get_runstate: To read the current state of the dac's and adc's
+ * @codec: pointer argument to the codec
+ *
+ * Return Value	: returning the runstate
+ */
+static int aic3262_get_runstate(struct snd_soc_codec *codec)
+{
+	unsigned int dac, adc;
+	struct aic3262_priv *aic3262 = snd_soc_codec_get_drvdata(codec);
+
+	/* Read the run state */
+	dac = aic3xxx_reg_read(aic3262->aic3xxx, AIC3262_DAC_FLAG);
+	adc = aic3xxx_reg_read(aic3262->aic3xxx, AIC3262_ADC_FLAG);
+
+	return (((adc>>6)&1)<<5)  |
+		(((adc>>2)&1)<<4) |
+		(((dac>>7)&1)<<1) |
+		(((dac>>3)&1)<<0);
+}
+
+/**
+ * aic3262_dsp_pwrdwn_status: To read the status of dsp's
+ * @codec: pointer argument to the codec , cur_state of dac's and adc's
+ *
+ * Return Value	: integer returning 0
+ */
+static int aic3262_dsp_pwrdwn_status(struct snd_soc_codec *codec)
+{
+	struct aic3262_priv *aic3262 = snd_soc_codec_get_drvdata(codec);
+
+	aic3xxx_set_bits(aic3262->aic3xxx,
+			AIC3262_ADC_DATAPATH_SETUP, 0XC0, 0);
+	aic3xxx_set_bits(aic3262->aic3xxx,
+			AIC3262_DAC_DATAPATH_SETUP, 0XC0, 0);
+
+	if (!aic3xxx_wait_bits(aic3262->aic3xxx, AIC3262_ADC_FLAG,
+			      AIC3262_ADC_POWER_MASK, 0, AIC3262_TIME_DELAY,
+			      AIC3262_DELAY_COUNTER))
+		goto err;
+	if (!aic3xxx_wait_bits(aic3262->aic3xxx, AIC3262_DAC_FLAG,
+			AIC3262_DAC_POWER_MASK, 0, AIC3262_TIME_DELAY,
+			AIC3262_DELAY_COUNTER))
+		goto err;
+
+	return 0;
+err:
+	dev_err(codec->dev, "DAC/ADC Power down timedout at [%s:%d]",
+				__FILE__, __LINE__);
+	return -EINVAL;
+}
+static int aic3262_dsp_pwrup(struct snd_soc_codec *codec, int state)
+{
+	struct aic3262_priv *aic3262 = snd_soc_codec_get_drvdata(codec);
+	int adc_reg_mask = 0;
+	int adc_power_mask = 0;
+	int dac_reg_mask = 0;
+	int dac_power_mask = 0;
+	int ret_wbits;
+
+	if (state & AIC3XXX_COPS_MDSP_A_L) {
+		adc_reg_mask |= 0x80;
+		adc_power_mask |= AIC3262_LADC_POWER_MASK;
+	}
+	if (state & AIC3XXX_COPS_MDSP_A_R) {
+		adc_reg_mask |= 0x40;
+		adc_power_mask |= AIC3262_RADC_POWER_MASK;
+	}
+
+	if (state & AIC3XXX_COPS_MDSP_A)
+		aic3xxx_set_bits(aic3262->aic3xxx,
+					AIC3262_ADC_DATAPATH_SETUP, 0XC0,
+					adc_reg_mask);
+
+	if (state & AIC3XXX_COPS_MDSP_D_L) {
+		dac_reg_mask |= 0x80;
+		dac_power_mask |= AIC3262_LDAC_POWER_STATUS_MASK;
+	}
+	if (state & AIC3XXX_COPS_MDSP_D_R) {
+		dac_reg_mask |= 0x40;
+		dac_power_mask |= AIC3262_RDAC_POWER_STATUS_MASK;
+	}
+
+	if (state & AIC3XXX_COPS_MDSP_D)
+		aic3xxx_set_bits(aic3262->aic3xxx,
+					AIC3262_DAC_DATAPATH_SETUP, 0XC0,
+					dac_reg_mask);
+
+	if (state & AIC3XXX_COPS_MDSP_A) {
+		ret_wbits = aic3xxx_wait_bits(aic3262->aic3xxx,
+				AIC3262_ADC_FLAG, AIC3262_ADC_POWER_MASK,
+				adc_power_mask, AIC3262_TIME_DELAY,
+				AIC3262_DELAY_COUNTER);
+		if (!ret_wbits)
+			dev_err(codec->dev, "ADC Power down timedout\n");
+	}
+
+	if (state & AIC3XXX_COPS_MDSP_D) {
+		ret_wbits = aic3xxx_wait_bits(aic3262->aic3xxx,
+				AIC3262_DAC_FLAG, AIC3262_DAC_POWER_MASK,
+				dac_power_mask, AIC3262_TIME_DELAY,
+				AIC3262_DELAY_COUNTER);
+		if (!ret_wbits)
+			dev_err(codec->dev, "ADC Power down timedout\n");
+	}
+
+	return 0;
+}
+
+static int aic3262_restart_dsps_sync(struct snd_soc_codec *codec, int run_state)
+{
+
+	aic3262_dsp_pwrdwn_status(codec);
+	aic3262_dsp_pwrup(codec, run_state);
+
+	return 0;
+}
+
+static const struct aic3xxx_codec_ops aic3262_cfw_codec_ops = {
+	.reg_read  =	aic3262_ops_reg_read,
+	.reg_write =	aic3262_ops_reg_write,
+	.set_bits  =	aic3262_ops_set_bits,
+	.bulk_read =	aic3262_ops_bulk_read,
+	.bulk_write =	aic3262_ops_bulk_write,
+	.lock      =	aic3262_ops_lock,
+	.unlock    =	aic3262_ops_unlock,
+	.stop      =	aic3262_ops_stop,
+	.restore   =	aic3262_ops_restore,
+	.bswap     =	aic3262_ops_adaptivebuffer_swap,
+};
+
+
+/**
+ * aic3262_codec_read: provide read api to read aic3262 registe space
+ * @codec: pointer variable to codec having codec information,
+ * @reg: register address,
+ *
+ * Return: Return value will be value read.
+ */
+unsigned int aic3262_codec_read(struct snd_soc_codec *codec, unsigned int reg)
+{
+
+	u8 value;
+	struct aic3262_priv *aic3262 = snd_soc_codec_get_drvdata(codec);
+	union aic3xxx_reg_union *aic_reg = (union aic3xxx_reg_union *) &reg;
+
+	value = aic3xxx_reg_read(aic3262->aic3xxx, reg);
+	dev_dbg(codec->dev, "p %d , r 30 %x %x\n",
+		aic_reg->aic3xxx_register.page,
+		aic_reg->aic3xxx_register.offset, value);
+	return value;
+}
+
+/**
+ * aic3262_codec_write: provide write api to write at aic3262 registe space
+ * @codec: Pointer variable to codec having codec information,
+ * @reg: Register address,
+ * @value: Value to be written to address space
+ *
+ * Return: Total no of byte written to address space.
+ */
+int aic3262_codec_write(struct snd_soc_codec *codec, unsigned int reg,
+			unsigned int value)
+{
+	union aic3xxx_reg_union *aic_reg = (union aic3xxx_reg_union *) &reg;
+	struct aic3262_priv *aic3262 = snd_soc_codec_get_drvdata(codec);
+
+	dev_dbg(codec->dev, "p %d, w 30 %x %x\n",
+		aic_reg->aic3xxx_register.page,
+		aic_reg->aic3xxx_register.offset, value);
+	return aic3xxx_reg_write(aic3262->aic3xxx, reg, value);
+}
+
+/**
+ * aic3262_set_interface_fmt: Setting interface ASI1/2/3 data format
+ * @dai: ponter to dai holds runtime data for a DAI,
+ * @fmt: asi format info,
+ * @channel: number of channel,
+ *
+ * Return: On success return 0.
+*/
+static int aic3262_set_interface_fmt(struct snd_soc_dai *dai, unsigned int fmt,
+					unsigned int channel)
+{
+	int aif_interface_reg;
+	int aif_bclk_offset_reg;
+	struct snd_soc_codec *codec = dai->codec;
+	u8 iface_val = 0;
+	u8 dsp_a_val = 0;
+
+	switch (dai->id) {
+	case 0:
+		aif_interface_reg = AIC3262_ASI1_BUS_FMT;
+		aif_bclk_offset_reg = AIC3262_ASI1_LCH_OFFSET;
+		break;
+	case 1:
+		aif_interface_reg = AIC3262_ASI2_BUS_FMT;
+		aif_bclk_offset_reg = AIC3262_ASI2_LCH_OFFSET;
+		break;
+	case 2:
+		aif_interface_reg = AIC3262_ASI3_BUS_FMT;
+		aif_bclk_offset_reg = AIC3262_ASI3_LCH_OFFSET;
+		break;
+	default:
+		return -EINVAL;
+
+	}
+	/* interface format */
+	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_I2S:
+		iface_val = 0;
+		break;
+	case SND_SOC_DAIFMT_DSP_A:
+		dsp_a_val = 0x1;	/* Intentionally falling through */
+	case SND_SOC_DAIFMT_DSP_B:
+		if (channel == 1)
+			iface_val = 0x80;	/* Choose mono PCM */
+		else if (channel <= 8)
+			iface_val = 0x20;	/* choose multichannel PCM */
+		else
+			return -EINVAL;
+		break;
+	case SND_SOC_DAIFMT_RIGHT_J:
+		iface_val = 0x40;
+		break;
+	case SND_SOC_DAIFMT_LEFT_J:
+		iface_val = 0x60;
+		break;
+	default:
+		dev_err(codec->dev, "Invalid DAI interface format\n");
+		return -EINVAL;
+	}
+	snd_soc_update_bits(codec, aif_interface_reg,
+					AIC3262_ASI_INTERFACE_MASK, iface_val);
+	snd_soc_update_bits(codec, aif_bclk_offset_reg,
+					AIC3262_BCLK_OFFSET_MASK, dsp_a_val);
+	return 0;
+
+}
+
+/**
+ * aic3262_hw_params: This function is to set the hardware parameters
+ *		for AIC3262.
+ *		The functions set the sample rate and audio serial data word
+ *		length.
+ * @substream: pointer variable to sn_pcm_substream,
+ * @params: pointer to snd_pcm_hw_params structure,
+ * @dai: ponter to dai Holds runtime data for a DAI,
+ *
+ * Return: Return 0 on success.
+ */
+int aic3262_hw_params(struct snd_pcm_substream *substream,
+			struct snd_pcm_hw_params *params,
+			struct snd_soc_dai *dai)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_codec *codec = rtd->codec;
+	struct aic3262_priv *aic3262 = snd_soc_codec_get_drvdata(codec);
+	int asi_reg, ret = 0;
+	u8 data = 0, value = 0, wclk_div = 0, bclk_div = 0;
+	unsigned int channels = params_channels(params);
+
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+		aic3262->stream_status = 1;
+	else
+		aic3262->stream_status = 0;
+
+	switch (dai->id) {
+	case 0:
+		asi_reg = AIC3262_ASI1_BUS_FMT;
+		break;
+	case 1:
+		asi_reg = AIC3262_ASI2_BUS_FMT;
+		break;
+	case 2:
+		asi_reg = AIC3262_ASI3_BUS_FMT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (params_format(params)) {
+	case SNDRV_PCM_FORMAT_S16_LE:
+		data = data | 0x00;
+		break;
+	case SNDRV_PCM_FORMAT_S20_3LE:
+		data |= (0x08);
+		break;
+	case SNDRV_PCM_FORMAT_S24_LE:
+		data |= (0x10);
+		break;
+	case SNDRV_PCM_FORMAT_S32_LE:
+		data |= (0x18);
+		break;
+	}
+
+	/* Configure TDM for multi chennels */
+	switch (channels) {
+	case 4:
+		value = value | 0x40;
+		bclk_div = 0x03;
+		wclk_div = 0x40;
+		break;
+	case 6:
+		bclk_div = 0x02;
+		wclk_div = 0x60;
+		value = value | 0x80;
+		break;
+	case 8:
+		bclk_div = 0x01;
+		wclk_div = 0x00;
+		value = value | 0xC0;
+		break;
+	default:
+		bclk_div = 0x04;
+		wclk_div = 0x20;
+	}
+
+	snd_soc_update_bits(codec, AIC3262_ASI1_CHNL_SETUP,
+				AIC3262_ASI1_CHNL_MASK, value);
+
+	snd_soc_update_bits(codec, AIC3262_ASI1_BCLK_N,
+				AIC3262_ASI1_BCLK_N_MASK, bclk_div);
+
+	snd_soc_update_bits(codec, AIC3262_ASI1_WCLK_N,
+				AIC3262_ASI1_WCLK_N_MASK, wclk_div);
+
+
+	/* configure the respective Registers for the above configuration */
+	snd_soc_update_bits(codec, asi_reg,
+			    AIC3262_ASI_DATA_WORD_LENGTH_MASK, data);
+	ret = aic3262_set_interface_fmt(dai, aic3262->asi_fmt[dai->id],
+					 channels);
+	if (ret < 0) {
+		dev_err(codec->dev, "failed to set hardware param\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * aic3262_set_dai_fmt: This function is to set the DAI format
+ * @codec_dai: ponter to dai Holds runtime data for a DAI,
+ * @fmt: asi format info,
+ *
+ * return: return 0 on success.
+ */
+static int aic3262_set_dai_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
+{
+	struct aic3262_priv *aic3262;
+	struct snd_soc_codec *codec;
+	u8 iface_val, master;
+	int aif_bclk_wclk_reg, asi_bclk_reg, asi_wclk_reg;
+	unsigned int bclk_master = 0, wclk_master = 0;
+
+	codec = codec_dai->codec;
+	aic3262 = snd_soc_codec_get_drvdata(codec);
+	iface_val = 0x00;
+	master = 0x0;
+
+	switch (codec_dai->id) {
+	case 0:
+		aif_bclk_wclk_reg = AIC3262_ASI1_BWCLK_CNTL_REG;
+		asi_bclk_reg = AIC3262_ASI1_BCLK_N;
+		asi_wclk_reg = AIC3262_ASI1_WCLK_N;
+		break;
+	case 1:
+		aif_bclk_wclk_reg = AIC3262_ASI2_BWCLK_CNTL_REG;
+		asi_bclk_reg = AIC3262_ASI2_BCLK_N;
+		asi_wclk_reg = AIC3262_ASI2_WCLK_N;
+		break;
+	case 2:
+		aif_bclk_wclk_reg = AIC3262_ASI3_BWCLK_CNTL_REG;
+		asi_bclk_reg = AIC3262_ASI3_BCLK_N;
+		asi_wclk_reg = AIC3262_ASI3_WCLK_N;
+		break;
+	default:
+		return -EINVAL;
+
+	}
+	aic3262->asi_fmt[codec_dai->id] = fmt;
+	/* set master/slave audio interface */
+	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
+	case SND_SOC_DAIFMT_CBM_CFM:
+		master |= (AIC3262_WCLK_OUT_MASK | AIC3262_BCLK_OUT_MASK);
+		bclk_master = 0x80;
+		wclk_master = 0x80;
+		break;
+	case SND_SOC_DAIFMT_CBS_CFS:
+		break;
+	case SND_SOC_DAIFMT_CBS_CFM:	/* new case..for debug purpose */
+		master |= (AIC3262_WCLK_OUT_MASK);
+		wclk_master = 0x80;
+		break;
+	case SND_SOC_DAIFMT_CBM_CFS:
+		master |= (AIC3262_BCLK_OUT_MASK);
+		bclk_master = 0x80;
+		break;
+
+	default:
+		dev_err(codec->dev, "Invalid DAI master/slave" " interface\n");
+
+		return -EINVAL;
+	}
+	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_DSP_A:
+	case SND_SOC_DAIFMT_DSP_B:
+		switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
+		case SND_SOC_DAIFMT_NB_NF:
+			break;
+		case SND_SOC_DAIFMT_IB_NF:
+			master |= AIC3262_BCLK_INV_MASK;
+			break;
+		default:
+			return -EINVAL;
+		}
+		break;
+	case SND_SOC_DAIFMT_I2S:
+	case SND_SOC_DAIFMT_RIGHT_J:
+	case SND_SOC_DAIFMT_LEFT_J:
+		switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
+		case SND_SOC_DAIFMT_NB_NF:
+			break;
+		case SND_SOC_DAIFMT_IB_NF:
+			master |= AIC3262_BCLK_INV_MASK;
+			break;
+		default:
+			return -EINVAL;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	snd_soc_update_bits(codec, aif_bclk_wclk_reg,
+			    AIC3262_WCLK_BCLK_MASTER_MASK, master);
+	snd_soc_update_bits(codec, asi_bclk_reg,
+			    AIC3262_ASI_BCLK_MASTER_MASK, bclk_master);
+	snd_soc_update_bits(codec, asi_wclk_reg,
+			    AIC3262_ASI_WCLK_MASTER_MASK, wclk_master);
+	return 0;
+}
+
+/**
+ * aic3262_dai_set_pll: This function is to Set pll for aic3262 codec dai
+ * @dai: ponter to dai Holds runtime data for a DAI,$
+ * @pll_id: integer pll_id
+ * @source: DAI specific source for the PLL
+ * @fin: PLL Input clock frequency in Hz,
+ * @fout: Frequency out,
+ *
+ * Return: return 0 on success
+*/
+static int aic3262_dai_set_pll(struct snd_soc_dai *dai, int pll_id, int source,
+				unsigned int Fin, unsigned int Fout)
+{
+	struct snd_soc_codec *codec = dai->codec;
+	struct aic3262_priv *aic3262 = snd_soc_codec_get_drvdata(codec);
+
+	/* select the PLL_CLKIN */
+	snd_soc_update_bits(codec, AIC3262_PLL_CLKIN_REG,
+			    AIC3262_PLL_CLKIN_MASK, source <<
+			    AIC3262_PLL_CLKIN_SHIFT);
+
+	if (aic3262->cfw_p != NULL)
+		aic_set_pll(aic3262->cfw_p, dai->id);
+
+	return 0;
+}
+
+/**
+ *
+ * aic3262_set_bias_level: This function is to get triggered
+ *			 when dapm events occurs.
+ * @codec: pointer variable to codec having informaton related to codec,
+ * @level: Bias level-> ON, PREPARE, STANDBY, OFF.
+ *
+ * Return: Return 0 on success.
+ */
+static int aic3262_set_bias_level(struct snd_soc_codec *codec,
+				  enum snd_soc_bias_level level)
+{
+
+	switch (level) {
+	case SND_SOC_BIAS_ON:
+
+		dev_dbg(codec->dev, "set_bias_on\n");
+		break;
+
+	case SND_SOC_BIAS_PREPARE:
+		dev_dbg(codec->dev, "set_bias_prepare\n");
+		break;
+
+	case SND_SOC_BIAS_STANDBY:
+		/*
+		 * all power is driven by DAPM system,
+		 * so output power is safe if bypass was set
+		 */
+		dev_dbg(codec->dev, "set_bias_stby\n");
+		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF) {
+			pm_runtime_get_sync(codec->dev);
+			snd_soc_update_bits(codec, AIC3262_POWER_CONF,
+					    (AIC3262_AVDD_TO_DVDD_MASK |
+					     AIC3262_EXT_ANALOG_SUPPLY_MASK),
+					    0x0);
+			snd_soc_update_bits(codec, AIC3262_REF_PWR_DLY,
+					    AIC3262_CHIP_REF_PWR_ON_MASK,
+					    AIC3262_CHIP_REF_PWR_ON);
+			mdelay(40);
+
+			snd_soc_update_bits(codec, AIC3262_CHARGE_PUMP_CNTL,
+				AIC3262_DYNAMIC_OFFSET_CALIB_MASK,
+				AIC3262_DYNAMIC_OFFSET_CALIB);
+		}
+		break;
+
+	case SND_SOC_BIAS_OFF:
+		dev_dbg(codec->dev, "set_bias_off\n");
+		/* force all power off */
+		if (codec->dapm.bias_level == SND_SOC_BIAS_STANDBY) {
+			snd_soc_update_bits(codec, AIC3262_REF_PWR_DLY,
+					    AIC3262_CHIP_REF_PWR_ON_MASK, 0x0);
+			snd_soc_update_bits(codec, AIC3262_POWER_CONF,
+					    (AIC3262_AVDD_TO_DVDD_MASK |
+					     AIC3262_EXT_ANALOG_SUPPLY_MASK),
+					    (AIC3262_AVDD_TO_DVDD |
+					     AIC3262_EXT_ANALOG_SUPPLY_OFF));
+			pm_runtime_put(codec->dev);
+		}
+		break;
+	}
+
+	codec->dapm.bias_level = level;
+	return 0;
+}
+
+/**
+ *
+ * aic3262_suspend; This function is to suspend the AIC3262 driver.
+ * @codec: pointer variable to codec having informaton related to codec,
+ *
+ * Return: Return 0 on success.
+ */
+static int aic3262_suspend(struct snd_soc_codec *codec)
+{
+	aic3262_set_bias_level(codec, SND_SOC_BIAS_OFF);
+	return 0;
+}
+
+/**
+ * aic3262_resume: This function is to resume the AIC3262 driver
+ *		 from off state to standby
+ * @codec: pointer variable to codec having informaton related to codec,
+ *
+ * Return: Return 0 on success.
+ */
+static int aic3262_resume(struct snd_soc_codec *codec)
+{
+	aic3262_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
+
+	return 0;
+}
+
+/**
+ * aic3262_probe: This is first driver function called by the SoC core driver.
+ * @codec: pointer variable to codec having informaton related to codec,
+ *
+ * Return: Return 0 on success.
+ */
+static int aic3262_codec_probe(struct snd_soc_codec *codec)
+{
+	int ret = 0, irq_ret = 0;
+	struct aic3262_priv *aic3262 = snd_soc_codec_get_drvdata(codec);
+	struct aic3xxx *aic3xxx = aic3262->aic3xxx;
+	struct aic_state *ps_state;
+	char *file;
+
+	codec->control_data = aic3262->aic3xxx->regmap;
+
+	aic3262->codec = codec;
+	aic3262->cur_fw = NULL;
+	aic3262->cfw_p = devm_kzalloc(aic3xxx->dev, sizeof(struct aic_state),
+					GFP_KERNEL);
+	if (aic3262->cfw_p == NULL) {
+		dev_err(codec->dev, "no memory for firmware\n");
+		return -ENOMEM;
+	}
+
+	aic_init(aic3262->cfw_p, &aic3262_cfw_codec_ops,
+							codec);
+	ps_state = aic3262->cfw_p;
+	ps_state->dev_name = "tlv320aic3262";
+	ps_state->version = 1;
+
+	aic3262->workqueue = create_singlethread_workqueue("aic3262-codec");
+	if (!aic3262->workqueue) {
+		ret = -ENOMEM;
+		goto work_err;
+	}
+	INIT_DELAYED_WORK(&aic3262->delayed_work, aic3262_accessory_work);
+	mutex_init(&aic3262->mutex);
+	mutex_init(&codec->mutex);
+	mutex_init(&aic3262->cfw_mutex);
+	aic3262->dsp_runstate = 0;
+
+	if (aic3xxx->irq) {
+		irq_ret = aic3xxx_request_irq(aic3262->aic3xxx,
+					  AIC3XXX_IRQ_HEADSET_DETECT,
+					  aic3262_audio_handler,
+					  IRQF_NO_SUSPEND,
+					  "aic3262_irq_headset", codec);
+
+		if (irq_ret < 0) {
+			dev_err(codec->dev,
+			"HEADSET detect irq request failed:%d\n", irq_ret);
+		} else {
+			snd_soc_update_bits(codec, AIC3262_HP_DETECT,
+					AIC3XXX_HEADSET_IN_M,
+					AIC3XXX_HEADSET_IN_M);
+		}
+	}
+	/* Keep the reference voltage ON while in
+	   STANDBY mode for fast power up */
+
+	snd_soc_update_bits(codec, AIC3262_REF_PWR_DLY,
+			    AIC3262_CHIP_REF_PWR_ON_MASK,
+			    AIC3262_CHIP_REF_PWR_ON);
+	usleep_range(40 * 1000, 41 * 1000);
+
+	snd_soc_update_bits(codec, AIC3262_CHARGE_PUMP_CNTL,
+				AIC3262_DYNAMIC_OFFSET_CALIB_MASK,
+				AIC3262_DYNAMIC_OFFSET_CALIB);
+
+	aic3262_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
+
+	file = devm_kzalloc(codec->dev, PAGE_SIZE, GFP_KERNEL);
+	if (file == NULL)
+		return -ENOMEM;
+
+	snprintf(file, PAGE_SIZE, "%s_fw_v%d.bin", ps_state->dev_name,
+				ps_state->version);
+	file[PAGE_SIZE - 1] = '\0';
+
+	ret = request_firmware_nowait(THIS_MODULE, FW_ACTION_HOTPLUG,
+				file, codec->dev,
+				GFP_KERNEL, codec, aic3262_firmware_load);
+	if (ret < 0) {
+		dev_err(codec->dev, "Firmware request failed\n");
+		goto firm_err;
+	}
+
+	return 0;
+firm_err:
+	if (irq_ret)
+		aic3xxx_free_irq(aic3xxx,
+				 AIC3XXX_IRQ_HEADSET_DETECT, codec);
+	destroy_workqueue(aic3262->workqueue);
+work_err:
+	kfree(aic3262->cfw_p);
+	return ret;
+}
+
+/*
+ * aic3262_remove: Cleans up and Remove aic3262 soc device
+ * @codec: pointer variable to codec having informaton related to codec,
+ *
+ * Return: Return 0 on success.
+ */
+static int aic3262_codec_remove(struct snd_soc_codec *codec)
+{
+	/* power down chip */
+	struct aic3262_priv *aic3262 = snd_soc_codec_get_drvdata(codec);
+	struct aic3xxx *aic3xxx = aic3262->aic3xxx;
+
+	aic3262_set_bias_level(codec, SND_SOC_BIAS_OFF);
+
+	/* free_irq if any */
+	switch (aic3xxx->type) {
+	case TLV320AIC3262:
+		if (aic3xxx->irq)
+			aic3xxx_free_irq(aic3xxx,
+					 AIC3XXX_IRQ_HEADSET_DETECT, codec);
+		break;
+	default:
+		dev_info(codec->dev, "Coded is not TLV320AIC3262\n");
+	}
+	/* release firmware if any */
+	if (aic3262->cur_fw != NULL)
+		release_firmware(aic3262->cur_fw);
+	/* destroy workqueue for jac dev */
+	destroy_workqueue(aic3262->workqueue);
+
+
+	return 0;
+}
+
+static struct snd_soc_codec_driver soc_codec_driver_aic3262 = {
+	.probe = aic3262_codec_probe,
+	.remove = aic3262_codec_remove,
+	.suspend = aic3262_suspend,
+	.resume = aic3262_resume,
+	.read = aic3262_codec_read,
+	.write = aic3262_codec_write,
+	.controls = aic3262_snd_controls,
+	.num_controls = ARRAY_SIZE(aic3262_snd_controls),
+	.dapm_widgets = aic3262_dapm_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(aic3262_dapm_widgets),
+	.dapm_routes = aic3262_dapm_routes,
+	.num_dapm_routes = ARRAY_SIZE(aic3262_dapm_routes),
+	.set_bias_level = aic3262_set_bias_level,
+};
+
+static int aic3262_probe(struct platform_device *pdev)
+{
+	struct aic3262_priv *aic3262;
+	struct aic3xxx *aic3xxx = dev_get_drvdata(pdev->dev.parent);
+
+	aic3262 = devm_kzalloc(&pdev->dev, sizeof(struct aic3262_priv),
+				GFP_KERNEL);
+	if (aic3262 == NULL)
+		return -ENOMEM;
+	platform_set_drvdata(pdev, aic3262);
+	aic3262->aic3xxx = aic3xxx;
+
+	return snd_soc_register_codec(&pdev->dev, &soc_codec_driver_aic3262,
+				      aic3262_dai_driver,
+				      ARRAY_SIZE(aic3262_dai_driver));
+
+}
+
+static int aic3262_remove(struct platform_device *pdev)
+{
+
+	snd_soc_unregister_codec(&pdev->dev);
+	return 0;
+}
+
+static const struct of_device_id aic3262_of_match[] = {
+		{ .compatible = "ti,aic3262", },
+		{ },
+};
+MODULE_DEVICE_TABLE(of, aic3262_of_match);
+
+
+static struct platform_driver aic3262_codec_driver = {
+	.driver = {
+		.name = "tlv320aic3262-codec",
+		.owner = THIS_MODULE,
+		.of_match_table = aic3262_of_match,
+	},
+	.probe = aic3262_probe,
+	.remove = __devexit_p(aic3262_remove),
+};
+
+module_platform_driver(aic3262_codec_driver);
+
+MODULE_ALIAS("platform:tlv320aic3262-codec");
+MODULE_DESCRIPTION("ASoC TLV320AIC3262 codec driver");
+MODULE_AUTHOR("Mukund Navada K <navada@ti.com>");
+MODULE_AUTHOR("Meher Bajwa <mehar.bajwa@ti.com>");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/codecs/tlv320aic326x.h b/sound/soc/codecs/tlv320aic326x.h
new file mode 100644
index 0000000..046049c
--- /dev/null
+++ b/sound/soc/codecs/tlv320aic326x.h
@@ -0,0 +1,70 @@
+/*
+ * linux/sound/soc/codecs/tlv320aic326x.h
+ *
+ * Copyright (C) 2011 TI Solutions Pvt Ltd.
+ *
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ * The TLV320AIC3262 is a flexible, low-power, low-voltage stereo audio
+ * codec with digital microphone inputs and programmable outputs.
+ *
+ * History:
+ *
+ * Rev 0.1   ASoC driver support    TI         20-01-2011
+ *		The AIC325x ASoC driver is ported for the codec AIC3262.
+ * Rev 0.2   ASoC driver support    TI         21-03-2011
+ *		The AIC326x ASoC driver is updated for linux 2.6.32 Kernel.
+ * Rev 0.3   ASoC driver support    TI         20-04-2011
+ *		The AIC326x ASoC driver is ported to 2.6.35 omap4 kernel
+ */
+
+#ifndef _TLV320AIC3262_H
+#define _TLV320AIC3262_H
+#include "aic3xxx_cfw.h"
+#include "aic3xxx_cfw_ops.h"
+
+/* AIC3262 supported sample rate are 8k to 192k */
+#define AIC3262_RATES	SNDRV_PCM_RATE_8000_192000
+
+/* AIC3262 supports the word formats 16bits, 20bits, 24bits and 32 bits */
+#define AIC3262_FORMATS	(SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S20_3LE \
+			 | SNDRV_PCM_FMTBIT_S24_3LE | SNDRV_PCM_FMTBIT_S32_LE)
+
+#define AIC3262_TIME_DELAY					5000
+#define AIC3262_DELAY_COUNTER					100
+
+struct aic3262_jack_data {
+	struct snd_soc_jack *jack;
+	int report;
+};
+
+struct aic3262_priv {
+	u32 sysclk;
+	s32 master;
+	u8 stream_status;
+	struct aic3262_jack_data hs_jack;
+	struct workqueue_struct *workqueue;
+	struct delayed_work delayed_work;
+	struct snd_soc_codec *codec;
+	struct aic3xxx *aic3xxx;
+	struct mutex mutex;
+	struct mutex cfw_mutex;
+	struct aic_state *cfw_p;
+	int asi_fmt[2];
+	int dsp_runstate;
+	struct firmware *cur_fw;
+	int isdefault_fw;
+};
+
+extern struct snd_soc_dai aic3262_dai;
+void aic3262_hs_jack_detect(struct snd_soc_codec *codec,
+			    struct snd_soc_jack *jack, int report);
+
+#endif /* _TLV320AIC3262_H */
-- 
1.7.0.4


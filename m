Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab1JLO7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:59:22 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:50870
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751988Ab1JLO7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:59:21 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: [alsa-devel] [PATCH 9/9] ASoC: da7210: Add support for DAPM
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        alsa-devel <alsa-devel@alsa-project.org>
CC: David Dajun Chen <david.chen@diasemi.com>,
        <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 20:40:51 +0530
Message-ID: <1318432251.12107.432.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for DAPM covering all inputs and outputs
as well as ADC and DAC.

Tested on Samsung SMDK6410 board with DA7210 evaluation board.

Signed-off-by: Ashish Chavan <ashish.chavan@kpitcummins.com>
Signed-off-by: David Dajun Chen <dchen@diasemi.com>
---
 sound/soc/codecs/da7210.c |  251 +++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 231 insertions(+), 20 deletions(-)

diff --git a/sound/soc/codecs/da7210.c b/sound/soc/codecs/da7210.c
index 2c6e47c..e0c3c5b 100644
--- a/sound/soc/codecs/da7210.c
+++ b/sound/soc/codecs/da7210.c
@@ -29,6 +29,8 @@
 #define DA7210_CONTROL			0x01
 #define DA7210_STATUS			0x02
 #define DA7210_STARTUP1			0x03
+#define DA7210_STARTUP2			0x04
+#define DA7210_STARTUP3			0x05
 #define DA7210_MIC_L			0x07
 #define DA7210_MIC_R			0x08
 #define DA7210_AUX1_L			0x09
@@ -199,6 +201,24 @@
 #define DA7210_HP_L_ZC			(1 << 6)
 #define DA7210_HP_R_ZC			(1 << 7)
 
+/* STARTUP2 bit fields */
+#define DA7210_LOUT1_L_STBY		(1 << 0)
+#define DA7210_LOUT1_R_STBY		(1 << 1)
+#define DA7210_LOUT2_STBY		(1 << 2)
+#define DA7210_HP_L_STBY		(1 << 3)
+#define DA7210_HP_R_STBY		(1 << 4)
+#define DA7210_DAC_L_STBY		(1 << 5)
+#define DA7210_DAC_R_STBY		(1 << 6)
+
+/* STARTUP3 bit fields */
+#define DA7210_MIC_L_STBY		(1 << 0)
+#define DA7210_MIC_R_STBY		(1 << 1)
+#define DA7210_LIN1_L_STBY		(1 << 2)
+#define DA7210_LIN1_R_STBY		(1 << 3)
+#define DA7210_LIN2_STBY		(1 << 4)
+#define DA7210_ADC_L_STBY		(1 << 5)
+#define DA7210_ADC_R_STBY		(1 << 6)
+
 /* Default gain/vol values */
 #define DA7210_DFLT_DAC_GAIN		0x10  /* 0dB */
 #define DA7210_DFLT_OUT1_VOL		0x35  /* 0dB */
@@ -460,6 +480,200 @@ static const struct snd_kcontrol_new da7210_snd_controls[] = {
 	SOC_ENUM("ADC Voice Cutoff", da7210_adc_vf_cutoff),
 };
 
+/*
+ * DAPM Controls
+ */
+/* In Mixer Left */
+static const struct snd_kcontrol_new da7210_dapm_inmixl_controls[] = {
+	SOC_DAPM_SINGLE("Mic Left Switch", DA7210_INMIX_L, 0, 1, 0),
+	SOC_DAPM_SINGLE("Mic Right Switch", DA7210_INMIX_L, 1, 1, 0),
+	SOC_DAPM_SINGLE("Aux1 Left Switch", DA7210_INMIX_L, 2, 1, 0),
+	SOC_DAPM_SINGLE("Aux2 Switch", DA7210_INMIX_L, 3, 1, 0),
+	SOC_DAPM_SINGLE("Outmix Left Switch", DA7210_INMIX_L, 4, 1, 0),
+};
+
+/* In Mixer Right */
+static const struct snd_kcontrol_new da7210_dapm_inmixr_controls[] = {
+	SOC_DAPM_SINGLE("Mic Right Switch", DA7210_INMIX_R, 0, 1, 0),
+	SOC_DAPM_SINGLE("Mic Left Switch", DA7210_INMIX_R, 1, 1, 0),
+	SOC_DAPM_SINGLE("Aux1 Right Switch", DA7210_INMIX_R, 2, 1, 0),
+	SOC_DAPM_SINGLE("Aux2 Switch", DA7210_INMIX_R, 3, 1, 0),
+	SOC_DAPM_SINGLE("Outmix Right Switch", DA7210_INMIX_R, 4, 1, 0),
+};
+
+/* Out Mixer Left */
+static const struct snd_kcontrol_new da7210_dapm_outmixl_controls[] = {
+	SOC_DAPM_SINGLE("Aux1 Left Switch", DA7210_OUTMIX_L, 0, 1, 0),
+	SOC_DAPM_SINGLE("Aux2 Switch", DA7210_OUTMIX_L, 1, 1, 0),
+	SOC_DAPM_SINGLE("INPGA Left Switch", DA7210_OUTMIX_L, 2, 1, 0),
+	SOC_DAPM_SINGLE("INPGA Right Switch", DA7210_OUTMIX_L, 3, 1, 0),
+	SOC_DAPM_SINGLE("DAC Left Switch", DA7210_OUTMIX_L, 4, 1, 0),
+};
+
+/* Out Mixer Right */
+static const struct snd_kcontrol_new da7210_dapm_outmixr_controls[] = {
+	SOC_DAPM_SINGLE("Aux1 Right Switch", DA7210_OUTMIX_R, 0, 1, 0),
+	SOC_DAPM_SINGLE("Aux2 Switch", DA7210_OUTMIX_R, 1, 1, 0),
+	SOC_DAPM_SINGLE("INPGA Left Switch", DA7210_OUTMIX_R, 2, 1, 0),
+	SOC_DAPM_SINGLE("INPGA Right Switch", DA7210_OUTMIX_R, 3, 1, 0),
+	SOC_DAPM_SINGLE("DAC Right Switch", DA7210_OUTMIX_R, 4, 1, 0),
+};
+
+/* Mono Mixer */
+static const struct snd_kcontrol_new da7210_dapm_monomix_controls[] = {
+	SOC_DAPM_SINGLE("INPGA Right Switch", DA7210_OUT2, 3, 1, 0),
+	SOC_DAPM_SINGLE("INPGA Left Switch", DA7210_OUT2, 4, 1, 0),
+	SOC_DAPM_SINGLE("Outmix Right Switch", DA7210_OUT2, 5, 1, 0),
+	SOC_DAPM_SINGLE("Outmix Left Switch", DA7210_OUT2, 6, 1, 0),
+};
+
+/* DAPM widgets */
+static const struct snd_soc_dapm_widget da7210_dapm_widgets[] = {
+	/* Input Side */
+	/* Input Lines */
+	SND_SOC_DAPM_INPUT("MICL"),
+	SND_SOC_DAPM_INPUT("MICR"),
+	SND_SOC_DAPM_INPUT("AUX1L"),
+	SND_SOC_DAPM_INPUT("AUX1R"),
+	SND_SOC_DAPM_INPUT("AUX2"),
+
+	/* Input PGAs */
+	SND_SOC_DAPM_PGA("Mic Left", DA7210_STARTUP3, 0, 1, NULL, 0),
+	SND_SOC_DAPM_PGA("Mic Right", DA7210_STARTUP3, 1, 1, NULL, 0),
+	SND_SOC_DAPM_PGA("Aux1 Left", DA7210_STARTUP3, 2, 1, NULL, 0),
+	SND_SOC_DAPM_PGA("Aux1 Right", DA7210_STARTUP3, 3, 1, NULL, 0),
+	SND_SOC_DAPM_PGA("Aux2 Mono", DA7210_STARTUP3, 4, 1, NULL, 0),
+
+	SND_SOC_DAPM_PGA("INPGA Left", DA7210_INMIX_L, 7, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("INPGA Right", DA7210_INMIX_R, 7, 0, NULL, 0),
+
+	/* MICBIAS */
+	SND_SOC_DAPM_MICBIAS("Mic Bias", DA7210_MIC_L, 6, 0),
+
+	/* Input Mixers */
+	SND_SOC_DAPM_MIXER("In Mixer Left", SND_SOC_NOPM, 0, 0,
+		&da7210_dapm_inmixl_controls[0],
+		ARRAY_SIZE(da7210_dapm_inmixl_controls)),
+
+	SND_SOC_DAPM_MIXER("In Mixer Right", SND_SOC_NOPM, 0, 0,
+		&da7210_dapm_inmixr_controls[0],
+		ARRAY_SIZE(da7210_dapm_inmixr_controls)),
+
+	/* ADCs */
+	SND_SOC_DAPM_ADC("ADC Left", "Capture", DA7210_STARTUP3, 5, 1),
+	SND_SOC_DAPM_ADC("ADC Right", "Capture", DA7210_STARTUP3, 6, 1),
+
+	/* Output Side */
+	/* DACs */
+	SND_SOC_DAPM_DAC("DAC Left", "Playback", DA7210_STARTUP2, 5, 1),
+	SND_SOC_DAPM_DAC("DAC Right", "Playback", DA7210_STARTUP2, 6, 1),
+
+	/* Output Mixers */
+	SND_SOC_DAPM_MIXER("Out Mixer Left", SND_SOC_NOPM, 0, 0,
+		&da7210_dapm_outmixl_controls[0],
+		ARRAY_SIZE(da7210_dapm_outmixl_controls)),
+
+	SND_SOC_DAPM_MIXER("Out Mixer Right", SND_SOC_NOPM, 0, 0,
+		&da7210_dapm_outmixr_controls[0],
+		ARRAY_SIZE(da7210_dapm_outmixr_controls)),
+
+	SND_SOC_DAPM_MIXER("Mono Mixer", SND_SOC_NOPM, 0, 0,
+		&da7210_dapm_monomix_controls[0],
+		ARRAY_SIZE(da7210_dapm_monomix_controls)),
+
+	/* Output PGAs */
+	SND_SOC_DAPM_PGA("OUTPGA Left Enable", DA7210_OUTMIX_L, 7, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("OUTPGA Right Enable", DA7210_OUTMIX_R, 7, 0, NULL, 0),
+
+	SND_SOC_DAPM_PGA("Out1 Left", DA7210_STARTUP2, 0, 1, NULL, 0),
+	SND_SOC_DAPM_PGA("Out1 Right", DA7210_STARTUP2, 1, 1, NULL, 0),
+	SND_SOC_DAPM_PGA("Out2 Mono", DA7210_STARTUP2, 2, 1, NULL, 0),
+	SND_SOC_DAPM_PGA("Headphone Left", DA7210_STARTUP2, 3, 1, NULL, 0),
+	SND_SOC_DAPM_PGA("Headphone Right", DA7210_STARTUP2, 4, 1, NULL, 0),
+
+	/* Output Lines */
+	SND_SOC_DAPM_OUTPUT("OUT1L"),
+	SND_SOC_DAPM_OUTPUT("OUT1R"),
+	SND_SOC_DAPM_OUTPUT("HPL"),
+	SND_SOC_DAPM_OUTPUT("HPR"),
+	SND_SOC_DAPM_OUTPUT("OUT2"),
+};
+
+/* DAPM audio route definition */
+static const struct snd_soc_dapm_route da7210_audio_map[] = {
+	/* Dest       Connecting Widget    source */
+	/* Input path */
+	{"Mic Bias", NULL, "MICR"},
+	{"Mic Bias", NULL, "MICL"},
+
+	{"Mic Left", NULL, "Mic Bias"},
+	{"Mic Right", NULL, "Mic Bias"},
+	{"Aux1 Left", NULL, "AUX1L"},
+	{"Aux1 Right", NULL, "AUX1R"},
+	{"Aux2 Mono", NULL, "AUX2"},
+
+	{"In Mixer Left", "Mic Left Switch", "Mic Left"},
+	{"In Mixer Left", "Aux1 Left Switch", "Aux1 Left"},
+	{"In Mixer Left", "Aux2 Switch", "Aux2 Mono"},
+	{"In Mixer Right", "Mic Right Switch", "Mic Right"},
+	{"In Mixer Right", "Aux1 Right Switch", "Aux1 Right"},
+	{"In Mixer Right", "Aux2 Switch", "Aux2 Mono"},
+
+	{"INPGA Left", NULL, "In Mixer Left"},
+	{"ADC Left", NULL, "INPGA Left"},
+
+	{"INPGA Right", NULL, "In Mixer Right"},
+	{"ADC Right", NULL, "INPGA Right"},
+
+	/* Output path */
+	{"Out Mixer Left", "Aux1 Left Switch", "Aux1 Left"},
+	{"Out Mixer Left", "Aux2 Switch", "Aux2 Mono"},
+	{"Out Mixer Left", "INPGA Left Switch", "INPGA Left"},
+	{"Out Mixer Left", "INPGA Right Switch", "INPGA Right"},
+	{"Out Mixer Left", "DAC Left Switch", "DAC Left"},
+
+	{"Out Mixer Right", "Aux1 Right Switch", "Aux1 Right"},
+	{"Out Mixer Right", "Aux2 Switch", "Aux2 Mono"},
+	{"Out Mixer Right", "INPGA Right Switch", "INPGA Right"},
+	{"Out Mixer Right", "INPGA Left Switch", "INPGA Left"},
+	{"Out Mixer Right", "DAC Right Switch", "DAC Right"},
+
+	{"Mono Mixer", "INPGA Right Switch", "INPGA Right"},
+	{"Mono Mixer", "INPGA Left Switch", "INPGA Left"},
+	{"Mono Mixer", "Outmix Right Switch", "Out Mixer Right"},
+	{"Mono Mixer", "Outmix Left Switch", "Out Mixer Left"},
+
+	{"OUTPGA Left Enable", NULL, "Out Mixer Left"},
+	{"OUTPGA Right Enable", NULL, "Out Mixer Right"},
+
+	{"Out1 Left", NULL, "OUTPGA Left Enable"},
+	{"OUT1L", NULL, "Out1 Left"},
+
+	{"Out1 Right", NULL, "OUTPGA Right Enable"},
+	{"OUT1R", NULL, "Out1 Right"},
+
+	{"Headphone Left", NULL, "OUTPGA Left Enable"},
+	{"HPL", NULL, "Headphone Left"},
+
+	{"Headphone Right", NULL, "OUTPGA Right Enable"},
+	{"HPR", NULL, "Headphone Right"},
+
+	{"Out2 Mono", NULL, "Mono Mixer"},
+	{"OUT2", NULL, "Out2 Mono"},
+};
+
+static int da7210_add_widgets(struct snd_soc_codec *codec)
+{
+	struct snd_soc_dapm_context *dapm = &codec->dapm;
+
+	snd_soc_dapm_new_controls(dapm, da7210_dapm_widgets,
+				  ARRAY_SIZE(da7210_dapm_widgets));
+	snd_soc_dapm_add_routes(dapm, da7210_audio_map,
+				ARRAY_SIZE(da7210_audio_map));
+
+	return 0;
+}
+
 /* Codec private data */
 struct da7210_priv {
 	enum snd_soc_control_type control_type;
@@ -499,25 +713,6 @@ static int da7210_volatile_register(struct snd_soc_codec *codec,
 		return 0;
 	}
 }
-static int da7210_startup(struct snd_pcm_substream *substream,
-			  struct snd_soc_dai *dai)
-{
-	int is_play = substream->stream == SNDRV_PCM_STREAM_PLAYBACK;
-	struct snd_soc_codec *codec = dai->codec;
-
-	if (is_play) {
-		/* Enable Out */
-		snd_soc_update_bits(codec, DA7210_OUTMIX_L, 0x1F, 0x10);
-		snd_soc_update_bits(codec, DA7210_OUTMIX_R, 0x1F, 0x10);
-
-	} else {
-		/* Enable Mic,AUX1 and AUX2 */
-		snd_soc_update_bits(codec, DA7210_INMIX_L, 0x1F, 0xD);
-		snd_soc_update_bits(codec, DA7210_INMIX_R, 0x1F, 0xD);
-	}
-
-	return 0;
-}
 
 /*
  * Set PCM DAI word length.
@@ -675,7 +870,6 @@ static int da7210_set_dai_fmt(struct snd_soc_dai *codec_dai, u32 fmt)
 
 /* DAI operations */
 static struct snd_soc_dai_ops da7210_dai_ops = {
-	.startup	= da7210_startup,
 	.hw_params	= da7210_hw_params,
 	.set_fmt	= da7210_set_dai_fmt,
 };
@@ -748,6 +942,10 @@ static int da7210_probe(struct snd_soc_codec *codec)
 	snd_soc_write(codec, DA7210_INMIX_L, DA7210_IN_L_EN);
 	snd_soc_write(codec, DA7210_INMIX_R, DA7210_IN_R_EN);
 
+	/* In mixer source selection, only MIC is selected by default */
+	snd_soc_write(codec, DA7210_INMIX_L, 0x01);
+	snd_soc_write(codec, DA7210_INMIX_R, 0x01);
+
 	/* Enable Left and Right ADC */
 	snd_soc_write(codec, DA7210_ADC, DA7210_ADC_L_EN | DA7210_ADC_R_EN);
 
@@ -764,6 +962,10 @@ static int da7210_probe(struct snd_soc_codec *codec)
 	snd_soc_write(codec, DA7210_OUTMIX_L, DA7210_OUT_L_EN);
 	snd_soc_write(codec, DA7210_OUTMIX_R, DA7210_OUT_R_EN);
 
+	/* Outmixer source selection, only DAC is selected by default */
+	snd_soc_write(codec, DA7210_OUTMIX_L, 0x10);
+	snd_soc_write(codec, DA7210_OUTMIX_R, 0x10);
+
 	/* Enable Left and Right HeadPhone PGA */
 	snd_soc_write(codec, DA7210_HP_CFG,
 		     DA7210_HP_2CAP_MODE | DA7210_HP_SENSE_EN |
@@ -797,6 +999,14 @@ static int da7210_probe(struct snd_soc_codec *codec)
 	/* Enable ramp mode for DAC gain update */
 	snd_soc_write(codec, DA7210_SOFTMUTE, DA7210_RAMP_EN);
 
+	/* Enable standby for all inputs and outputs */
+	snd_soc_write(codec, DA7210_STARTUP2, DA7210_LOUT1_L_STBY |
+		DA7210_LOUT1_R_STBY | DA7210_LOUT2_STBY | DA7210_HP_L_STBY |
+		DA7210_HP_R_STBY | DA7210_DAC_L_STBY | DA7210_DAC_R_STBY);
+	snd_soc_write(codec, DA7210_STARTUP3, DA7210_MIC_L_STBY |
+		DA7210_MIC_R_STBY | DA7210_LIN1_L_STBY | DA7210_LIN1_R_STBY |
+		DA7210_LIN2_STBY | DA7210_ADC_L_STBY | DA7210_ADC_R_STBY);
+
 	/* Diable PLL and bypass it */
 	snd_soc_write(codec, DA7210_PLL, DA7210_PLL_FS_48000);
 
@@ -828,6 +1038,7 @@ static int da7210_probe(struct snd_soc_codec *codec)
 
 	snd_soc_add_controls(codec, da7210_snd_controls,
 			     ARRAY_SIZE(da7210_snd_controls));
+	da7210_add_widgets(codec);
 
 	dev_info(codec->dev, "DA7210 Audio Codec %s\n", DA7210_VERSION);
 
-- 
1.7.1



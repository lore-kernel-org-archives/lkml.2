Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab1JLO6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:58:15 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:9572
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751988Ab1JLO6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:58:14 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: [alsa-devel] [PATCH 8/9] ASoC: da7210: Add support for High pass
 and Voice filters for ADC and DAC
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        alsa-devel <alsa-devel@alsa-project.org>
CC: David Dajun Chen <david.chen@diasemi.com>,
        <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 20:39:44 +0530
Message-ID: <1318432184.12107.430.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add controls for setting cut-off for high pass and voice
filters of ADC and DAC. There are also switches to enable/disable
these filters.

Also removed hard coded, fixed  values of these parameters used by
previous version of driver.

Tested on Samsung SMDK6410 board with DA7210 evaluation board.

Signed-off-by: Ashish Chavan <ashish.chavan@kpitcummins.com>
Signed-off-by: David Dajun Chen <dchen@diasemi.com>
---
 sound/soc/codecs/da7210.c |   57 +++++++++++++++++++++++++-------------------
 1 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/sound/soc/codecs/da7210.c b/sound/soc/codecs/da7210.c
index 9cab62a..2c6e47c 100644
--- a/sound/soc/codecs/da7210.c
+++ b/sound/soc/codecs/da7210.c
@@ -274,6 +274,28 @@ static const char *da7210_hp_mode_txt[] = {
 static const struct soc_enum da7210_hp_mode_sel =
 	SOC_ENUM_SINGLE(DA7210_HP_CFG, 0, 2, da7210_hp_mode_txt);
 
+/* ADC and DAC high pass filter f0 value */
+static const char const *da7210_hpf_cutoff_txt[] = {
+	"Fs/8192*pi", "Fs/4096*pi", "Fs/2048*pi", "Fs/1024*pi"
+};
+
+static const struct soc_enum da7210_dac_hpf_cutoff =
+	SOC_ENUM_SINGLE(DA7210_DAC_HPF, 0, 4, da7210_hpf_cutoff_txt);
+
+static const struct soc_enum da7210_adc_hpf_cutoff =
+	SOC_ENUM_SINGLE(DA7210_ADC_HPF, 0, 4, da7210_hpf_cutoff_txt);
+
+/* ADC and DAC voice (8kHz) high pass cutoff value */
+static const char const *da7210_vf_cutoff_txt[] = {
+	"2.5Hz", "25Hz", "50Hz", "100Hz", "150Hz", "200Hz", "300Hz", "400Hz"
+};
+
+static const struct soc_enum da7210_dac_vf_cutoff =
+	SOC_ENUM_SINGLE(DA7210_DAC_HPF, 4, 8, da7210_vf_cutoff_txt);
+
+static const struct soc_enum da7210_adc_vf_cutoff =
+	SOC_ENUM_SINGLE(DA7210_ADC_HPF, 4, 8, da7210_vf_cutoff_txt);
+
 /* ALC can be enabled only if noise suppression is disabled */
 static int da7210_put_alc_sw(struct snd_kcontrol *kcontrol,
 			     struct snd_ctl_elem_value *ucontrol)
@@ -426,6 +448,16 @@ static const struct snd_kcontrol_new da7210_snd_controls[] = {
 
 	SOC_SINGLE_EXT("Noise Suppression Enable Switch", DA7210_CONTROL, 3, 1,
 		       0, snd_soc_get_volsw, da7210_put_noise_sup_sw),
+
+	SOC_SINGLE("DAC HPF Switch", DA7210_DAC_HPF, 3, 1, 0),
+	SOC_ENUM("DAC HPF Cutoff", da7210_dac_hpf_cutoff),
+	SOC_SINGLE("DAC Voice Mode Switch", DA7210_DAC_HPF, 7, 1, 0),
+	SOC_ENUM("DAC Voice Cutoff", da7210_dac_vf_cutoff),
+
+	SOC_SINGLE("ADC HPF Switch", DA7210_ADC_HPF, 3, 1, 0),
+	SOC_ENUM("ADC HPF Cutoff", da7210_adc_hpf_cutoff),
+	SOC_SINGLE("ADC Voice Mode Switch", DA7210_ADC_HPF, 7, 1, 0),
+	SOC_ENUM("ADC Voice Cutoff", da7210_adc_vf_cutoff),
 };
 
 /* Codec private data */
@@ -497,7 +529,6 @@ static int da7210_hw_params(struct snd_pcm_substream *substream,
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
 	struct snd_soc_codec *codec = rtd->codec;
 	u32 dai_cfg1;
-	u32 hpf_reg, hpf_mask, hpf_value;
 	u32 fs, bypass;
 
 	/* set DAI source to Left and Right ADC */
@@ -528,68 +559,45 @@ static int da7210_hw_params(struct snd_pcm_substream *substream,
 
 	snd_soc_write(codec, DA7210_DAI_CFG1, dai_cfg1);
 
-	hpf_reg = (SNDRV_PCM_STREAM_PLAYBACK == substream->stream) ?
-		DA7210_DAC_HPF : DA7210_ADC_HPF;
-
 	switch (params_rate(params)) {
 	case 8000:
 		fs		= DA7210_PLL_FS_8000;
-		hpf_mask	= DA7210_VOICE_F0_MASK	| DA7210_VOICE_EN;
-		hpf_value	= DA7210_VOICE_F0_25	| DA7210_VOICE_EN;
 		bypass		= DA7210_PLL_BYP;
 		break;
 	case 11025:
 		fs		= DA7210_PLL_FS_11025;
-		hpf_mask	= DA7210_VOICE_F0_MASK	| DA7210_VOICE_EN;
-		hpf_value	= DA7210_VOICE_F0_25	| DA7210_VOICE_EN;
 		bypass		= 0;
 		break;
 	case 12000:
 		fs		= DA7210_PLL_FS_12000;
-		hpf_mask	= DA7210_VOICE_F0_MASK	| DA7210_VOICE_EN;
-		hpf_value	= DA7210_VOICE_F0_25	| DA7210_VOICE_EN;
 		bypass		= DA7210_PLL_BYP;
 		break;
 	case 16000:
 		fs		= DA7210_PLL_FS_16000;
-		hpf_mask	= DA7210_VOICE_F0_MASK	| DA7210_VOICE_EN;
-		hpf_value	= DA7210_VOICE_F0_25	| DA7210_VOICE_EN;
 		bypass		= DA7210_PLL_BYP;
 		break;
 	case 22050:
 		fs		= DA7210_PLL_FS_22050;
-		hpf_mask	= DA7210_VOICE_EN;
-		hpf_value	= 0;
 		bypass		= 0;
 		break;
 	case 32000:
 		fs		= DA7210_PLL_FS_32000;
-		hpf_mask	= DA7210_VOICE_EN;
-		hpf_value	= 0;
 		bypass		= DA7210_PLL_BYP;
 		break;
 	case 44100:
 		fs		= DA7210_PLL_FS_44100;
-		hpf_mask	= DA7210_VOICE_EN;
-		hpf_value	= 0;
 		bypass		= 0;
 		break;
 	case 48000:
 		fs		= DA7210_PLL_FS_48000;
-		hpf_mask	= DA7210_VOICE_EN;
-		hpf_value	= 0;
 		bypass		= DA7210_PLL_BYP;
 		break;
 	case 88200:
 		fs		= DA7210_PLL_FS_88200;
-		hpf_mask	= DA7210_VOICE_EN;
-		hpf_value	= 0;
 		bypass		= 0;
 		break;
 	case 96000:
 		fs		= DA7210_PLL_FS_96000;
-		hpf_mask	= DA7210_VOICE_EN;
-		hpf_value	= 0;
 		bypass		= DA7210_PLL_BYP;
 		break;
 	default:
@@ -599,7 +607,6 @@ static int da7210_hw_params(struct snd_pcm_substream *substream,
 	/* Disable active mode */
 	snd_soc_update_bits(codec, DA7210_STARTUP1, DA7210_SC_MST_EN, 0);
 
-	snd_soc_update_bits(codec, hpf_reg, hpf_mask, hpf_value);
 	snd_soc_update_bits(codec, DA7210_PLL, DA7210_PLL_FS_MASK, fs);
 	snd_soc_update_bits(codec, DA7210_PLL_DIV3, DA7210_PLL_BYP, bypass);
 
-- 
1.7.1



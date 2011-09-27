Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab1I0SuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:50:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57324 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752175Ab1I0SuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:50:12 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] ASoC: Add WM1811 support
Date: Tue, 27 Sep 2011 19:50:07 +0100
Message-Id: <1317149407-27635-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317149407-27635-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1317149407-27635-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM1811 is mostly register compatible with the WM8994 and WM8958,
providing a high performance audio hub CODEC in a small form factor
suitable for ultra compact system designs.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/mfd/wm8994/registers.h |    4 ++
 sound/soc/codecs/wm8994.c            |   83 +++++++++++++++++++++++++++++++--
 2 files changed, 82 insertions(+), 5 deletions(-)

diff --git a/include/linux/mfd/wm8994/registers.h b/include/linux/mfd/wm8994/registers.h
index 23b24ca..d7be463 100644
--- a/include/linux/mfd/wm8994/registers.h
+++ b/include/linux/mfd/wm8994/registers.h
@@ -2073,6 +2073,10 @@
 /*
  * R96 (0x60) - Analogue HP (1)
  */
+#define WM1811_HPOUT1_ATTN                      0x0100  /* HPOUT1_ATTN */
+#define WM1811_HPOUT1_ATTN_MASK                 0x0100  /* HPOUT1_ATTN */
+#define WM1811_HPOUT1_ATTN_SHIFT                     8  /* HPOUT1_ATTN */
+#define WM1811_HPOUT1_ATTN_WIDTH                     1  /* HPOUT1_ATTN */
 #define WM8994_HPOUT1L_RMV_SHORT                0x0080  /* HPOUT1L_RMV_SHORT */
 #define WM8994_HPOUT1L_RMV_SHORT_MASK           0x0080  /* HPOUT1L_RMV_SHORT */
 #define WM8994_HPOUT1L_RMV_SHORT_SHIFT               7  /* HPOUT1L_RMV_SHORT */
diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index e537267..5e8d66d 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -283,6 +283,7 @@ static const DECLARE_TLV_DB_SCALE(st_tlv, -3600, 300, 0);
 static const DECLARE_TLV_DB_SCALE(wm8994_3d_tlv, -1600, 183, 0);
 static const DECLARE_TLV_DB_SCALE(eq_tlv, -1200, 100, 0);
 static const DECLARE_TLV_DB_SCALE(ng_tlv, -10200, 600, 0);
+static const DECLARE_TLV_DB_SCALE(mixin_boost_tlv, 0, 900, 0);
 
 #define WM8994_DRC_SWITCH(xname, reg, shift) \
 {	.iface = SNDRV_CTL_ELEM_IFACE_MIXER, .name = xname, \
@@ -703,6 +704,13 @@ SOC_SINGLE_TLV("AIF2DAC Noise Gate Threshold Volume",
 	       7, 1, ng_tlv),
 };
 
+static const struct snd_kcontrol_new wm1811_snd_controls[] = {
+SOC_SINGLE_TLV("MIXINL IN1LP Boost Volume", WM8994_INPUT_MIXER_1, 7, 1, 0,
+	       mixin_boost_tlv),
+SOC_SINGLE_TLV("MIXINL IN1RP Boost Volume", WM8994_INPUT_MIXER_1, 8, 1, 0,
+	       mixin_boost_tlv),
+};
+
 static int clk_sys_event(struct snd_soc_dapm_widget *w,
 			 struct snd_kcontrol *kcontrol, int event)
 {
@@ -2053,6 +2061,15 @@ static int wm8994_set_bias_level(struct snd_soc_codec *codec,
 							    WM8958_CP_DISCH);
 				}
 				break;
+
+			case WM1811:
+				if (wm8994->revision < 2) {
+					snd_soc_write(codec, 0x102, 0x3);
+					snd_soc_write(codec, 0x5d, 0x7e);
+					snd_soc_write(codec, 0x5e, 0x0);
+					snd_soc_write(codec, 0x102, 0x0);
+				}
+				break;
 			}
 
 			/* Discharge LINEOUT1 & 2 */
@@ -2168,10 +2185,18 @@ static int wm8994_set_dai_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 
 	/* The AIF2 format configuration needs to be mirrored to AIF3
 	 * on WM8958 if it's in use so just do it all the time. */
-	if (control->type == WM8958 && dai->id == 2)
-		snd_soc_update_bits(codec, WM8958_AIF3_CONTROL_1,
-				    WM8994_AIF1_LRCLK_INV |
-				    WM8958_AIF3_FMT_MASK, aif1);
+	switch (control->type) {
+	case WM1811:
+	case WM8958:
+		if (dai->id == 2)
+			snd_soc_update_bits(codec, WM8958_AIF3_CONTROL_1,
+					    WM8994_AIF1_LRCLK_INV |
+					    WM8958_AIF3_FMT_MASK, aif1);
+		break;
+
+	default:
+		break;
+	}
 
 	snd_soc_update_bits(codec, aif1_reg,
 			    WM8994_AIF1_BCLK_INV | WM8994_AIF1_LRCLK_INV |
@@ -2258,6 +2283,7 @@ static int wm8994_hw_params(struct snd_pcm_substream *substream,
 		break;
 	case 3:
 		switch (control->type) {
+		case WM1811:
 		case WM8958:
 			aif1_reg = WM8958_AIF3_CONTROL_1;
 			break;
@@ -2384,6 +2410,7 @@ static int wm8994_aif3_hw_params(struct snd_pcm_substream *substream,
 	switch (dai->id) {
 	case 3:
 		switch (control->type) {
+		case WM1811:
 		case WM8958:
 			aif1_reg = WM8958_AIF3_CONTROL_1;
 			break;
@@ -2614,6 +2641,7 @@ static int wm8994_suspend(struct snd_soc_codec *codec, pm_message_t state)
 	case WM8994:
 		snd_soc_update_bits(codec, WM8994_MICBIAS, WM8994_MICD_ENA, 0);
 		break;
+	case WM1811:
 	case WM8958:
 		snd_soc_update_bits(codec, WM8958_MIC_DETECT_1,
 				    WM8958_MICD_ENA, 0);
@@ -2682,6 +2710,7 @@ static int wm8994_resume(struct snd_soc_codec *codec)
 			snd_soc_update_bits(codec, WM8994_MICBIAS,
 					    WM8994_MICD_ENA, WM8994_MICD_ENA);
 		break;
+	case WM1811:
 	case WM8958:
 		if (wm8994->jack_cb)
 			snd_soc_update_bits(codec, WM8958_MIC_DETECT_1,
@@ -2980,8 +3009,13 @@ int wm8958_mic_detect(struct snd_soc_codec *codec, struct snd_soc_jack *jack,
 	struct wm8994_priv *wm8994 = snd_soc_codec_get_drvdata(codec);
 	struct wm8994 *control = codec->control_data;
 
-	if (control->type != WM8958)
+	switch (control->type) {
+	case WM1811:
+	case WM8958:
+		break;
+	default:
 		return -EINVAL;
+	}
 
 	if (jack) {
 		if (!cb) {
@@ -3135,6 +3169,24 @@ static int wm8994_codec_probe(struct snd_soc_codec *codec)
 		wm8994->hubs.dcs_readback_mode = 1;
 		break;
 
+	case WM1811:
+		wm8994->hubs.dcs_readback_mode = 2;
+		wm8994->hubs.no_series_update = 1;
+
+		switch (wm8994->revision) {
+		case 0:
+		case 1:
+			wm8994->hubs.dcs_codes_l = -7;
+			wm8994->hubs.dcs_codes_r = -4;
+			break;
+		default:
+			break;
+		}
+
+		snd_soc_update_bits(codec, WM8994_ANALOGUE_HP_1,
+				    WM1811_HPOUT1_ATTN, WM1811_HPOUT1_ATTN);
+		break;
+
 	default:
 		break;
 	}
@@ -3195,6 +3247,7 @@ static int wm8994_codec_probe(struct snd_soc_codec *codec)
 		break;
 
 	case WM8958:
+	case WM1811:
 		if (wm8994->micdet_irq) {
 			ret = request_threaded_irq(wm8994->micdet_irq, NULL,
 						   wm8958_mic_irq,
@@ -3357,6 +3410,19 @@ static int wm8994_codec_probe(struct snd_soc_codec *codec)
 						  ARRAY_SIZE(wm8994_dac_widgets));
 		}
 		break;
+
+	case WM1811:
+		snd_soc_add_controls(codec, wm8958_snd_controls,
+				     ARRAY_SIZE(wm8958_snd_controls));
+		snd_soc_dapm_new_controls(dapm, wm8958_dapm_widgets,
+					  ARRAY_SIZE(wm8958_dapm_widgets));
+		snd_soc_dapm_new_controls(dapm, wm8994_lateclk_widgets,
+					  ARRAY_SIZE(wm8994_lateclk_widgets));
+		snd_soc_dapm_new_controls(dapm, wm8994_adc_widgets,
+					  ARRAY_SIZE(wm8994_adc_widgets));
+		snd_soc_dapm_new_controls(dapm, wm8994_dac_widgets,
+					  ARRAY_SIZE(wm8994_dac_widgets));
+		break;
 	}
 		
 
@@ -3393,6 +3459,12 @@ static int wm8994_codec_probe(struct snd_soc_codec *codec)
 
 		wm8958_dsp2_init(codec);
 		break;
+	case WM1811:
+		snd_soc_dapm_add_routes(dapm, wm8994_lateclk_intercon,
+					ARRAY_SIZE(wm8994_lateclk_intercon));
+		snd_soc_dapm_add_routes(dapm, wm8958_intercon,
+					ARRAY_SIZE(wm8958_intercon));
+		break;
 	}
 
 	return 0;
@@ -3448,6 +3520,7 @@ static int  wm8994_codec_remove(struct snd_soc_codec *codec)
 				wm8994);
 		break;
 
+	case WM1811:
 	case WM8958:
 		if (wm8994->micdet_irq)
 			free_irq(wm8994->micdet_irq, wm8994);
-- 
1.7.6.3


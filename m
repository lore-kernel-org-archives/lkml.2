Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab1GDKHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 06:07:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41301 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab1GDKGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 06:06:06 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 2/6] ASoC: twl6040: Move PLL selection to codec driver
Date: Mon, 4 Jul 2011 13:05:54 +0300
Message-ID: <1309773958-14608-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1309773958-14608-1-git-send-email-peter.ujfalusi@ti.com>
References: <1309773958-14608-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is better if the selection between the Low power,
and High performance PLL is handled within the codec
driver, not in machine driver(s) to avoid duplicated
code, and also to have consistent tracking of the selected
PLL, and the resulting differences in supported sample
rates.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl6040.c |  110 +++++++++++++++++++++++++++++---------------
 sound/soc/codecs/twl6040.h |    1 +
 sound/soc/omap/sdp4430.c   |   47 ++-----------------
 3 files changed, 79 insertions(+), 79 deletions(-)

diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index 3b2843c..e61f32f 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -79,6 +79,7 @@ struct twl6040_data {
 	int codec_powered;
 	int pll;
 	int non_lp;
+	int pll_power_mode;
 	int hs_power_mode;
 	int hs_power_mode_locked;
 	unsigned int clk_in;
@@ -209,6 +210,37 @@ static const int twl6040_vdd_reg[TWL6040_VDDREGNUM] = {
 	TWL6040_REG_DLB,
 };
 
+/* set of rates for each pll: low-power and high-performance */
+static unsigned int lp_rates[] = {
+	8000,
+	11250,
+	16000,
+	22500,
+	32000,
+	44100,
+	48000,
+	88200,
+	96000,
+};
+
+static struct snd_pcm_hw_constraint_list lp_constraints = {
+	.count	= ARRAY_SIZE(lp_rates),
+	.list	= lp_rates,
+};
+
+static unsigned int hp_rates[] = {
+	8000,
+	16000,
+	32000,
+	48000,
+	96000,
+};
+
+static struct snd_pcm_hw_constraint_list hp_constraints = {
+	.count	= ARRAY_SIZE(hp_rates),
+	.list	= hp_rates,
+};
+
 /*
  * read twl6040 register cache
  */
@@ -1048,6 +1080,43 @@ static int twl6040_headset_power_put_enum(struct snd_kcontrol *kcontrol,
 	return ret;
 }
 
+static int twl6040_pll_get_enum(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct twl6040_data *priv = snd_soc_codec_get_drvdata(codec);
+
+	ucontrol->value.enumerated.item[0] = priv->pll_power_mode;
+
+	return 0;
+}
+
+static int twl6040_pll_put_enum(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct twl6040_data *priv = snd_soc_codec_get_drvdata(codec);
+
+	priv->pll_power_mode = ucontrol->value.enumerated.item[0];
+	if (priv->pll_power_mode)
+		priv->sysclk_constraints = &hp_constraints;
+	else
+		priv->sysclk_constraints = &lp_constraints;
+
+	return 0;
+}
+
+int twl6040_get_clk_id(struct snd_soc_codec *codec)
+{
+	struct twl6040_data *priv = snd_soc_codec_get_drvdata(codec);
+
+	if (priv->pll_power_mode)
+		return TWL6040_SYSCLK_SEL_HPPLL;
+	else
+		return TWL6040_SYSCLK_SEL_LPPLL;
+}
+EXPORT_SYMBOL_GPL(twl6040_get_clk_id);
+
 static const struct snd_kcontrol_new twl6040_snd_controls[] = {
 	/* Capture gains */
 	SOC_DOUBLE_TLV("Capture Preamplifier Volume",
@@ -1070,6 +1139,9 @@ static const struct snd_kcontrol_new twl6040_snd_controls[] = {
 	SOC_ENUM_EXT("Headset Power Mode", twl6040_power_mode_enum,
 		twl6040_headset_power_get_enum,
 		twl6040_headset_power_put_enum),
+
+	SOC_ENUM_EXT("PLL Selection", twl6040_power_mode_enum,
+		twl6040_pll_get_enum, twl6040_pll_put_enum),
 };
 
 static const struct snd_soc_dapm_widget twl6040_dapm_widgets[] = {
@@ -1288,38 +1360,6 @@ static int twl6040_set_bias_level(struct snd_soc_codec *codec,
 	return 0;
 }
 
-/* set of rates for each pll: low-power and high-performance */
-
-static unsigned int lp_rates[] = {
-	8000,
-	11250,
-	16000,
-	22500,
-	32000,
-	44100,
-	48000,
-	88200,
-	96000,
-};
-
-static struct snd_pcm_hw_constraint_list lp_constraints = {
-	.count	= ARRAY_SIZE(lp_rates),
-	.list	= lp_rates,
-};
-
-static unsigned int hp_rates[] = {
-	8000,
-	16000,
-	32000,
-	48000,
-	96000,
-};
-
-static struct snd_pcm_hw_constraint_list hp_constraints = {
-	.count	= ARRAY_SIZE(hp_rates),
-	.list	= hp_rates,
-};
-
 static int twl6040_startup(struct snd_pcm_substream *substream,
 			struct snd_soc_dai *dai)
 {
@@ -1426,16 +1466,12 @@ static int twl6040_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 				      freq, priv->sysclk);
 		if (ret)
 			return ret;
-
-		priv->sysclk_constraints = &lp_constraints;
 		break;
 	case TWL6040_SYSCLK_SEL_HPPLL:
 		ret = twl6040_set_pll(twl6040, TWL6040_HPPLL_ID,
 				      freq, priv->sysclk);
 		if (ret)
 			return ret;
-
-		priv->sysclk_constraints = &hp_constraints;
 		break;
 	default:
 		dev_err(codec->dev, "unknown clk_id %d\n", clk_id);
@@ -1553,7 +1589,7 @@ static int twl6040_probe(struct snd_soc_codec *codec)
 		priv->hf_right_step = 1;
 	}
 
-	priv->sysclk_constraints = &hp_constraints;
+	priv->sysclk_constraints = &lp_constraints;
 	priv->workqueue = create_singlethread_workqueue("twl6040-codec");
 	if (!priv->workqueue) {
 		ret = -ENOMEM;
diff --git a/sound/soc/codecs/twl6040.h b/sound/soc/codecs/twl6040.h
index 234bfad..d8de678 100644
--- a/sound/soc/codecs/twl6040.h
+++ b/sound/soc/codecs/twl6040.h
@@ -24,5 +24,6 @@
 
 void twl6040_hs_jack_detect(struct snd_soc_codec *codec,
 			    struct snd_soc_jack *jack, int report);
+int twl6040_get_clk_id(struct snd_soc_codec *codec);
 
 #endif /* End of __TWL6040_H__ */
diff --git a/sound/soc/omap/sdp4430.c b/sound/soc/omap/sdp4430.c
index 5d67c25..d9172c0 100644
--- a/sound/soc/omap/sdp4430.c
+++ b/sound/soc/omap/sdp4430.c
@@ -36,8 +36,6 @@
 #include "omap-pcm.h"
 #include "../codecs/twl6040.h"
 
-static int twl6040_power_mode;
-
 static int sdp4430_hw_params(struct snd_pcm_substream *substream,
 	struct snd_pcm_hw_params *params)
 {
@@ -46,13 +44,13 @@ static int sdp4430_hw_params(struct snd_pcm_substream *substream,
 	int clk_id, freq;
 	int ret;
 
-	if (twl6040_power_mode) {
-		clk_id = TWL6040_SYSCLK_SEL_HPPLL;
+	clk_id = twl6040_get_clk_id(rtd->codec);
+	if (clk_id == TWL6040_SYSCLK_SEL_HPPLL)
 		freq = 38400000;
-	} else {
-		clk_id = TWL6040_SYSCLK_SEL_LPPLL;
+	else if (clk_id == TWL6040_SYSCLK_SEL_LPPLL)
 		freq = 32768;
-	}
+	else
+		return -EINVAL;
 
 	/* set the codec mclk */
 	ret = snd_soc_dai_set_sysclk(codec_dai, clk_id, freq,
@@ -83,35 +81,6 @@ static struct snd_soc_jack_pin hs_jack_pins[] = {
 	},
 };
 
-static int sdp4430_get_power_mode(struct snd_kcontrol *kcontrol,
-	struct snd_ctl_elem_value *ucontrol)
-{
-	ucontrol->value.integer.value[0] = twl6040_power_mode;
-	return 0;
-}
-
-static int sdp4430_set_power_mode(struct snd_kcontrol *kcontrol,
-	struct snd_ctl_elem_value *ucontrol)
-{
-	if (twl6040_power_mode == ucontrol->value.integer.value[0])
-		return 0;
-
-	twl6040_power_mode = ucontrol->value.integer.value[0];
-
-	return 1;
-}
-
-static const char *power_texts[] = {"Low-Power", "High-Performance"};
-
-static const struct soc_enum sdp4430_enum[] = {
-	SOC_ENUM_SINGLE_EXT(2, power_texts),
-};
-
-static const struct snd_kcontrol_new sdp4430_controls[] = {
-	SOC_ENUM_EXT("TWL6040 Power Mode", sdp4430_enum[0],
-		sdp4430_get_power_mode, sdp4430_set_power_mode),
-};
-
 /* SDP4430 machine DAPM */
 static const struct snd_soc_dapm_widget sdp4430_twl6040_dapm_widgets[] = {
 	SND_SOC_DAPM_MIC("Ext Mic", NULL),
@@ -154,12 +123,6 @@ static int sdp4430_twl6040_init(struct snd_soc_pcm_runtime *rtd)
 	struct snd_soc_dapm_context *dapm = &codec->dapm;
 	int ret;
 
-	/* Add SDP4430 specific controls */
-	ret = snd_soc_add_controls(codec, sdp4430_controls,
-				ARRAY_SIZE(sdp4430_controls));
-	if (ret)
-		return ret;
-
 	/* Add SDP4430 specific widgets */
 	ret = snd_soc_dapm_new_controls(dapm, sdp4430_twl6040_dapm_widgets,
 				ARRAY_SIZE(sdp4430_twl6040_dapm_widgets));
-- 
1.7.6


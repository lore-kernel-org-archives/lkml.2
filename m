Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab1FUOl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:41:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48294 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170Ab1FUOkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:40:16 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH v6 15/18] ASoC: twl6040: Remove pll and headset mode dependency
Date: Tue, 21 Jun 2011 16:39:13 +0300
Message-ID: <1308663556-29120-16-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Misael Lopez Cruz <misael.lopez@ti.com>

Remove dependency between pll (hppll, lppll) and headset power
mode (low-power, high-performance), as headset power mode can
be used with any pll.

A new control is created to allow headset power mode configuration
from userspace. Changing headset power mode during earpiece related
usecases is not propagated down to the codec as earpiece requires
HS DAC in HP mode.

Signed-off-by: Misael Lopez Cruz <misael.lopez@ti.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl6040.c |   62 ++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 57 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index 7845cdb..c8f7fc2 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -79,6 +79,8 @@ struct twl6040_data {
 	int codec_powered;
 	int pll;
 	int non_lp;
+	int hs_power_mode;
+	int hs_power_mode_locked;
 	unsigned int clk_in;
 	unsigned int sysclk;
 	struct snd_pcm_hw_constraint_list *sysclk_constraints;
@@ -651,15 +653,26 @@ static int twl6040_power_mode_event(struct snd_soc_dapm_widget *w,
 {
 	struct snd_soc_codec *codec = w->codec;
 	struct twl6040_data *priv = snd_soc_codec_get_drvdata(codec);
+	int ret = 0;
 
-	if (SND_SOC_DAPM_EVENT_ON(event))
+	if (SND_SOC_DAPM_EVENT_ON(event)) {
 		priv->non_lp++;
-	else
+		if (!strcmp(w->name, "Earphone Driver")) {
+			/* Earphone doesn't support low power mode */
+			priv->hs_power_mode_locked = 1;
+			ret = headset_power_mode(codec, 1);
+		}
+	} else {
 		priv->non_lp--;
+		if (!strcmp(w->name, "Earphone Driver")) {
+			priv->hs_power_mode_locked = 0;
+			ret = headset_power_mode(codec, priv->hs_power_mode);
+		}
+	}
 
 	msleep(1);
 
-	return 0;
+	return ret;
 }
 
 static void twl6040_hs_jack_report(struct snd_soc_codec *codec,
@@ -964,6 +977,43 @@ static const struct snd_kcontrol_new hfr_mux_controls =
 static const struct snd_kcontrol_new ep_driver_switch_controls =
 	SOC_DAPM_SINGLE("Switch", TWL6040_REG_EARCTL, 0, 1, 0);
 
+/* Headset power mode */
+static const char *twl6040_headset_power_texts[] = {
+	"Low-Power", "High-Perfomance",
+};
+
+static const struct soc_enum twl6040_headset_power_enum =
+	SOC_ENUM_SINGLE_EXT(ARRAY_SIZE(twl6040_headset_power_texts),
+			twl6040_headset_power_texts);
+
+static int twl6040_headset_power_get_enum(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct twl6040_data *priv = snd_soc_codec_get_drvdata(codec);
+
+	ucontrol->value.enumerated.item[0] = priv->hs_power_mode;
+
+	return 0;
+}
+
+static int twl6040_headset_power_put_enum(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct twl6040_data *priv = snd_soc_codec_get_drvdata(codec);
+	int high_perf = ucontrol->value.enumerated.item[0];
+	int ret = 0;
+
+	if (!priv->hs_power_mode_locked)
+		ret = headset_power_mode(codec, high_perf);
+
+	if (!ret)
+		priv->hs_power_mode = high_perf;
+
+	return ret;
+}
+
 static const struct snd_kcontrol_new twl6040_snd_controls[] = {
 	/* Capture gains */
 	SOC_DOUBLE_TLV("Capture Preamplifier Volume",
@@ -982,6 +1032,10 @@ static const struct snd_kcontrol_new twl6040_snd_controls[] = {
 		TWL6040_REG_HFLGAIN, TWL6040_REG_HFRGAIN, 0, 0x1D, 1, hf_tlv),
 	SOC_SINGLE_TLV("Earphone Playback Volume",
 		TWL6040_REG_EARCTL, 1, 0xF, 1, ep_tlv),
+
+	SOC_ENUM_EXT("Headset Power Mode", twl6040_headset_power_enum,
+		twl6040_headset_power_get_enum,
+		twl6040_headset_power_put_enum),
 };
 
 static const struct snd_soc_dapm_widget twl6040_dapm_widgets[] = {
@@ -1339,7 +1393,6 @@ static int twl6040_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 		if (ret)
 			return ret;
 
-		headset_power_mode(codec, 0);
 		priv->sysclk_constraints = &lp_constraints;
 		break;
 	case TWL6040_SYSCLK_SEL_HPPLL:
@@ -1348,7 +1401,6 @@ static int twl6040_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 		if (ret)
 			return ret;
 
-		headset_power_mode(codec, 1);
 		priv->sysclk_constraints = &hp_constraints;
 		break;
 	default:
-- 
1.7.5.3


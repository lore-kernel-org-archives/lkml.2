Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933758Ab1IONAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 09:00:37 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:51568 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933748Ab1IONAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 09:00:10 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-input@vger.kernel.org
Subject: [PATCH 8/8] ASoC: twl6040: Support for vibra output paths
Date: Thu, 15 Sep 2011 15:59:21 +0300
Message-Id: <1316091561-30899-9-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316091561-30899-1-git-send-email-peter.ujfalusi@ti.com>
References: <1316091561-30899-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

twl6040 have two vibra output drivers.
They can be operated with audio stream coming through
the PDM interface (fifth channel).
The vibra outputs can be controlled via the input/FF
driver as well.
Selection between the two mode is implemented within
the codec driver, the input/FF driver can only operate if
the routing is set to "Input FF".
Changing from "Input FF" to "Audio PDM" mode is protected
as well: The switchin can only be done, if there is no
running effect from the input/FF.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl6040.c |   72 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index 70f9a64..6667d7a 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -944,6 +944,23 @@ static int twl6040_get_volsw_2r(struct snd_kcontrol *kcontrol,
 		{.reg = reg_left, .rreg = reg_right, .shift = xshift, \
 		 .rshift = xshift, .max = xmax, .invert = xinvert}, }
 
+static int twl6040_soc_dapm_put_vibra_enum(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_dapm_widget_list *wlist = snd_kcontrol_chip(kcontrol);
+	struct snd_soc_dapm_widget *widget = wlist->widgets[0];
+	struct snd_soc_codec *codec = widget->codec;
+	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
+	unsigned int val;
+
+	/* Do not allow changes while Input/FF efect is running */
+	val = twl6040_read_reg_volatile(codec, e->reg);
+	if (val & TWL6040_VIBENA && !(val & TWL6040_VIBSEL))
+		return -EBUSY;
+
+	return snd_soc_dapm_put_enum_double(kcontrol, ucontrol);
+}
+
 /*
  * MICATT volume control:
  * from -6 to 0 dB in 6 dB steps
@@ -1015,6 +1032,19 @@ static const struct soc_enum twl6040_hf_enum[] = {
 			twl6040_hf_texts),
 };
 
+static const char *twl6040_vibrapath_texts[] = {
+	"Input FF", "Audio PDM"
+};
+
+static const struct soc_enum twl6040_vibra_enum[] = {
+	SOC_ENUM_SINGLE(TWL6040_REG_VIBCTLL, 1,
+			ARRAY_SIZE(twl6040_vibrapath_texts),
+			twl6040_vibrapath_texts),
+	SOC_ENUM_SINGLE(TWL6040_REG_VIBCTLR, 1,
+			ARRAY_SIZE(twl6040_vibrapath_texts),
+			twl6040_vibrapath_texts),
+};
+
 static const struct snd_kcontrol_new amicl_control =
 	SOC_DAPM_ENUM("Route", twl6040_enum[0]);
 
@@ -1044,6 +1074,17 @@ static const struct snd_kcontrol_new auxl_switch_control =
 static const struct snd_kcontrol_new auxr_switch_control =
 	SOC_DAPM_SINGLE("Switch", TWL6040_REG_HFRCTL, 6, 1, 0);
 
+/* Vibra playback switches */
+static const struct snd_kcontrol_new vibral_mux_controls =
+	SOC_DAPM_ENUM_EXT("Route", twl6040_vibra_enum[0],
+		snd_soc_dapm_get_enum_double,
+		twl6040_soc_dapm_put_vibra_enum);
+
+static const struct snd_kcontrol_new vibrar_mux_controls =
+	SOC_DAPM_ENUM_EXT("Route", twl6040_vibra_enum[1],
+		snd_soc_dapm_get_enum_double,
+		twl6040_soc_dapm_put_vibra_enum);
+
 /* Headset power mode */
 static const char *twl6040_power_mode_texts[] = {
 	"Low-Power", "High-Perfomance",
@@ -1163,6 +1204,8 @@ static const struct snd_soc_dapm_widget twl6040_dapm_widgets[] = {
 	SND_SOC_DAPM_OUTPUT("EP"),
 	SND_SOC_DAPM_OUTPUT("AUXL"),
 	SND_SOC_DAPM_OUTPUT("AUXR"),
+	SND_SOC_DAPM_OUTPUT("VIBRAL"),
+	SND_SOC_DAPM_OUTPUT("VIBRAR"),
 
 	/* Analog input muxes for the capture amplifiers */
 	SND_SOC_DAPM_MUX("Analog Left Capture Route",
@@ -1215,6 +1258,9 @@ static const struct snd_soc_dapm_widget twl6040_dapm_widgets[] = {
 			TWL6040_REG_HFRCTL, 0, 0,
 			twl6040_power_mode_event,
 			SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_POST_PMD),
+	/* Virtual DAC for vibra path (DL4 channel) */
+	SND_SOC_DAPM_DAC("VIBRA DAC", "Vibra Playback",
+			SND_SOC_NOPM, 0, 0),
 
 	SND_SOC_DAPM_MUX("Handsfree Left Playback",
 			SND_SOC_NOPM, 0, 0, &hfl_mux_controls),
@@ -1226,6 +1272,11 @@ static const struct snd_soc_dapm_widget twl6040_dapm_widgets[] = {
 	SND_SOC_DAPM_MUX("Headset Right Playback",
 			SND_SOC_NOPM, 0, 0, &hsr_mux_controls),
 
+	SND_SOC_DAPM_MUX("Vibra Left Playback", SND_SOC_NOPM, 0, 0,
+			&vibral_mux_controls),
+	SND_SOC_DAPM_MUX("Vibra Right Playback", SND_SOC_NOPM, 0, 0,
+			&vibrar_mux_controls),
+
 	SND_SOC_DAPM_SWITCH("Earphone Playback", SND_SOC_NOPM, 0, 0,
 			&ep_path_enable_control),
 	SND_SOC_DAPM_SWITCH("AUXL Playback", SND_SOC_NOPM, 0, 0,
@@ -1254,6 +1305,15 @@ static const struct snd_soc_dapm_widget twl6040_dapm_widgets[] = {
 			TWL6040_REG_EARCTL, 0, 0, NULL, 0,
 			twl6040_power_mode_event,
 			SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_POST_PMD),
+	SND_SOC_DAPM_OUT_DRV("Vibra Left Driver",
+			TWL6040_REG_VIBCTLL, 0, 0, NULL, 0),
+	SND_SOC_DAPM_OUT_DRV("Vibra Right Driver",
+			TWL6040_REG_VIBCTLR, 0, 0, NULL, 0),
+
+	SND_SOC_DAPM_SUPPLY("Vibra Left Control", TWL6040_REG_VIBCTLL, 2, 0,
+			    NULL, 0),
+	SND_SOC_DAPM_SUPPLY("Vibra Right Control", TWL6040_REG_VIBCTLR, 2, 0,
+			    NULL, 0),
 
 	/* Analog playback PGAs */
 	SND_SOC_DAPM_PGA("HF Left PGA",
@@ -1320,6 +1380,18 @@ static const struct snd_soc_dapm_route intercon[] = {
 
 	{"AUXL", NULL, "AUXL Playback"},
 	{"AUXR", NULL, "AUXR Playback"},
+
+	/* Vibrator paths */
+	{"Vibra Left Playback", "Audio PDM", "VIBRA DAC"},
+	{"Vibra Right Playback", "Audio PDM", "VIBRA DAC"},
+
+	{"Vibra Left Driver", NULL, "Vibra Left Playback"},
+	{"Vibra Right Driver", NULL, "Vibra Right Playback"},
+	{"Vibra Left Driver", NULL, "Vibra Left Control"},
+	{"Vibra Right Driver", NULL, "Vibra Right Control"},
+
+	{"VIBRAL", NULL, "Vibra Left Driver"},
+	{"VIBRAR", NULL, "Vibra Right Driver"},
 };
 
 static int twl6040_add_widgets(struct snd_soc_codec *codec)
-- 
1.7.6.1


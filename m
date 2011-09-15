Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587Ab1IOMot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:44:49 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:57198 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933525Ab1IOMki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:40:38 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 11/17] ASoC: twl6040: Earphone path correction
Date: Thu, 15 Sep 2011 15:39:33 +0300
Message-Id: <1316090379-30760-12-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the DAPM routing for the earphone path.
Convert the DAPM_SWITCH_E to DAPM_OUT_DRV_E, so we can have correct
power up, and down sequence for EP.
Introduce mute control (Earphone Playback Switch) for users to
enable/disable the EP path.
Note: the EP does not have it's own dedicated DAC. EP is connected to
HSL DAC.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl6040.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index ce9fb37..8b908ab 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -61,6 +61,9 @@
 #define TWL6040_REG_SW_SHADOW	0x2F
 #define TWL6040_CACHEREGNUM	(TWL6040_REG_SW_SHADOW + 1)
 
+/* TWL6040_REG_SW_SHADOW (0x2F) fields */
+#define TWL6040_EAR_PATH_ENABLE	0x01
+
 struct twl6040_output {
 	u16 active;
 	u16 left_vol;
@@ -987,8 +990,8 @@ static const struct snd_kcontrol_new hfl_mux_controls =
 static const struct snd_kcontrol_new hfr_mux_controls =
 	SOC_DAPM_ENUM("Route", twl6040_hf_enum[1]);
 
-static const struct snd_kcontrol_new ep_driver_switch_controls =
-	SOC_DAPM_SINGLE("Switch", TWL6040_REG_EARCTL, 0, 1, 0);
+static const struct snd_kcontrol_new ep_path_enable_control =
+	SOC_DAPM_SINGLE("Switch", TWL6040_REG_SW_SHADOW, 0, 1, 0);
 
 /* Headset power mode */
 static const char *twl6040_power_mode_texts[] = {
@@ -1161,6 +1164,9 @@ static const struct snd_soc_dapm_widget twl6040_dapm_widgets[] = {
 	SND_SOC_DAPM_MUX("HS Right Playback",
 			SND_SOC_NOPM, 0, 0, &hsr_mux_controls),
 
+	SND_SOC_DAPM_SWITCH("Earphone Playback", SND_SOC_NOPM, 0, 0,
+			&ep_path_enable_control),
+
 	/* Analog playback drivers */
 	SND_SOC_DAPM_OUT_DRV_E("Handsfree Left Driver",
 			TWL6040_REG_HFLCTL, 4, 0, NULL, 0,
@@ -1178,8 +1184,8 @@ static const struct snd_soc_dapm_widget twl6040_dapm_widgets[] = {
 			TWL6040_REG_HSRCTL, 2, 0, NULL, 0,
 			pga_event,
 			SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD),
-	SND_SOC_DAPM_SWITCH_E("Earphone Driver",
-			SND_SOC_NOPM, 0, 0, &ep_driver_switch_controls,
+	SND_SOC_DAPM_OUT_DRV_E("Earphone Driver",
+			TWL6040_REG_EARCTL, 0, 0, NULL, 0,
 			twl6040_power_mode_event,
 			SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_POST_PMD),
 
@@ -1224,7 +1230,8 @@ static const struct snd_soc_dapm_route intercon[] = {
 	{"HSOR", NULL, "Headset Right Driver"},
 
 	/* Earphone playback path */
-	{"Earphone Driver", "Switch", "HSDAC Left"},
+	{"Earphone Playback", "Switch", "HSDAC Left"},
+	{"Earphone Driver", NULL, "Earphone Playback"},
 	{"EP", NULL, "Earphone Driver"},
 
 	{"HF Left Playback", "HF DAC", "HFDAC Left"},
-- 
1.7.6.1


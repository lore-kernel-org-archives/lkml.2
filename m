Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1BFXDL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:03:11 -0500
Received: from smtp-out-016.synserver.de ([212.40.185.16]:1139 "HELO
	smtp-out-016.synserver.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753759Ab1BFXDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:03:09 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 15254
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/7] ASoC: neo1973_wm8753: Remove scenario management code.
Date: Mon,  7 Feb 2011 00:04:17 +0100
Message-Id: <1297033463-14577-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has been proven to be inflexible to do scenario management in kernel space.

Since actual neo1973 board support has not been merged in mainline and this
patch has been in the neo1973 tree for some time now it should be safe to remove
this functionality without breaking existing userspace.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/samsung/neo1973_wm8753.c |  142 +----------------------------------
 1 files changed, 5 insertions(+), 137 deletions(-)

diff --git a/sound/soc/samsung/neo1973_wm8753.c b/sound/soc/samsung/neo1973_wm8753.c
index d3cd688..1ea6e61 100644
--- a/sound/soc/samsung/neo1973_wm8753.c
+++ b/sound/soc/samsung/neo1973_wm8753.c
@@ -37,17 +37,6 @@
 #include "dma.h"
 #include "s3c24xx-i2s.h"
 
-/* define the scenarios */
-#define NEO_AUDIO_OFF			0
-#define NEO_GSM_CALL_AUDIO_HANDSET	1
-#define NEO_GSM_CALL_AUDIO_HEADSET	2
-#define NEO_GSM_CALL_AUDIO_BLUETOOTH	3
-#define NEO_STEREO_TO_SPEAKERS		4
-#define NEO_STEREO_TO_HEADPHONES	5
-#define NEO_CAPTURE_HANDSET		6
-#define NEO_CAPTURE_HEADSET		7
-#define NEO_CAPTURE_BLUETOOTH		8
-
 static struct snd_soc_card neo1973;
 static struct i2c_client *i2c;
 
@@ -224,113 +213,6 @@ static struct snd_soc_ops neo1973_voice_ops = {
 	.hw_free = neo1973_voice_hw_free,
 };
 
-static int neo1973_scenario;
-
-static int neo1973_get_scenario(struct snd_kcontrol *kcontrol,
-	struct snd_ctl_elem_value *ucontrol)
-{
-	ucontrol->value.integer.value[0] = neo1973_scenario;
-	return 0;
-}
-
-static int set_scenario_endpoints(struct snd_soc_codec *codec, int scenario)
-{
-	struct snd_soc_dapm_context *dapm = &codec->dapm;
-
-	pr_debug("Entered %s\n", __func__);
-
-	switch (neo1973_scenario) {
-	case NEO_AUDIO_OFF:
-		snd_soc_dapm_disable_pin(dapm, "Audio Out");
-		snd_soc_dapm_disable_pin(dapm, "GSM Line Out");
-		snd_soc_dapm_disable_pin(dapm, "GSM Line In");
-		snd_soc_dapm_disable_pin(dapm, "Headset Mic");
-		snd_soc_dapm_disable_pin(dapm, "Call Mic");
-		break;
-	case NEO_GSM_CALL_AUDIO_HANDSET:
-		snd_soc_dapm_enable_pin(dapm, "Audio Out");
-		snd_soc_dapm_enable_pin(dapm, "GSM Line Out");
-		snd_soc_dapm_enable_pin(dapm, "GSM Line In");
-		snd_soc_dapm_disable_pin(dapm, "Headset Mic");
-		snd_soc_dapm_enable_pin(dapm, "Call Mic");
-		break;
-	case NEO_GSM_CALL_AUDIO_HEADSET:
-		snd_soc_dapm_enable_pin(dapm, "Audio Out");
-		snd_soc_dapm_enable_pin(dapm, "GSM Line Out");
-		snd_soc_dapm_enable_pin(dapm, "GSM Line In");
-		snd_soc_dapm_enable_pin(dapm, "Headset Mic");
-		snd_soc_dapm_disable_pin(dapm, "Call Mic");
-		break;
-	case NEO_GSM_CALL_AUDIO_BLUETOOTH:
-		snd_soc_dapm_disable_pin(dapm, "Audio Out");
-		snd_soc_dapm_enable_pin(dapm, "GSM Line Out");
-		snd_soc_dapm_enable_pin(dapm, "GSM Line In");
-		snd_soc_dapm_disable_pin(dapm, "Headset Mic");
-		snd_soc_dapm_disable_pin(dapm, "Call Mic");
-		break;
-	case NEO_STEREO_TO_SPEAKERS:
-		snd_soc_dapm_enable_pin(dapm, "Audio Out");
-		snd_soc_dapm_disable_pin(dapm, "GSM Line Out");
-		snd_soc_dapm_disable_pin(dapm, "GSM Line In");
-		snd_soc_dapm_disable_pin(dapm, "Headset Mic");
-		snd_soc_dapm_disable_pin(dapm, "Call Mic");
-		break;
-	case NEO_STEREO_TO_HEADPHONES:
-		snd_soc_dapm_enable_pin(dapm, "Audio Out");
-		snd_soc_dapm_disable_pin(dapm, "GSM Line Out");
-		snd_soc_dapm_disable_pin(dapm, "GSM Line In");
-		snd_soc_dapm_disable_pin(dapm, "Headset Mic");
-		snd_soc_dapm_disable_pin(dapm, "Call Mic");
-		break;
-	case NEO_CAPTURE_HANDSET:
-		snd_soc_dapm_disable_pin(dapm, "Audio Out");
-		snd_soc_dapm_disable_pin(dapm, "GSM Line Out");
-		snd_soc_dapm_disable_pin(dapm, "GSM Line In");
-		snd_soc_dapm_disable_pin(dapm, "Headset Mic");
-		snd_soc_dapm_enable_pin(dapm, "Call Mic");
-		break;
-	case NEO_CAPTURE_HEADSET:
-		snd_soc_dapm_disable_pin(dapm, "Audio Out");
-		snd_soc_dapm_disable_pin(dapm, "GSM Line Out");
-		snd_soc_dapm_disable_pin(dapm, "GSM Line In");
-		snd_soc_dapm_enable_pin(dapm, "Headset Mic");
-		snd_soc_dapm_disable_pin(dapm, "Call Mic");
-		break;
-	case NEO_CAPTURE_BLUETOOTH:
-		snd_soc_dapm_disable_pin(dapm, "Audio Out");
-		snd_soc_dapm_disable_pin(dapm, "GSM Line Out");
-		snd_soc_dapm_disable_pin(dapm, "GSM Line In");
-		snd_soc_dapm_disable_pin(dapm, "Headset Mic");
-		snd_soc_dapm_disable_pin(dapm, "Call Mic");
-		break;
-	default:
-		snd_soc_dapm_disable_pin(dapm, "Audio Out");
-		snd_soc_dapm_disable_pin(dapm, "GSM Line Out");
-		snd_soc_dapm_disable_pin(dapm, "GSM Line In");
-		snd_soc_dapm_disable_pin(dapm, "Headset Mic");
-		snd_soc_dapm_disable_pin(dapm, "Call Mic");
-	}
-
-	snd_soc_dapm_sync(dapm);
-
-	return 0;
-}
-
-static int neo1973_set_scenario(struct snd_kcontrol *kcontrol,
-	struct snd_ctl_elem_value *ucontrol)
-{
-	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
-
-	pr_debug("Entered %s\n", __func__);
-
-	if (neo1973_scenario == ucontrol->value.integer.value[0])
-		return 0;
-
-	neo1973_scenario = ucontrol->value.integer.value[0];
-	set_scenario_endpoints(codec, neo1973_scenario);
-	return 1;
-}
-
 static u8 lm4857_regs[4] = {0x00, 0x40, 0x80, 0xC0};
 
 static void lm4857_write_regs(void)
@@ -454,22 +336,6 @@ static const struct soc_enum lm4857_mode_enum[] = {
 	SOC_ENUM_SINGLE_EXT(ARRAY_SIZE(lm4857_mode), lm4857_mode),
 };
 
-static const char *neo_scenarios[] = {
-	"Off",
-	"GSM Handset",
-	"GSM Headset",
-	"GSM Bluetooth",
-	"Speakers",
-	"Headphones",
-	"Capture Handset",
-	"Capture Headset",
-	"Capture Bluetooth"
-};
-
-static const struct soc_enum neo_scenario_enum[] = {
-	SOC_ENUM_SINGLE_EXT(ARRAY_SIZE(neo_scenarios), neo_scenarios),
-};
-
 static const DECLARE_TLV_DB_SCALE(stereo_tlv, -4050, 150, 0);
 static const DECLARE_TLV_DB_SCALE(mono_tlv, -3450, 150, 0);
 
@@ -482,8 +348,6 @@ static const struct snd_kcontrol_new wm8753_neo1973_controls[] = {
 		lm4857_get_reg, lm4857_set_reg, mono_tlv),
 	SOC_ENUM_EXT("Amp Mode", lm4857_mode_enum[0],
 		lm4857_get_mode, lm4857_set_mode),
-	SOC_ENUM_EXT("Neo Mode", neo_scenario_enum[0],
-		neo1973_get_scenario, neo1973_set_scenario),
 	SOC_SINGLE_EXT("Amp Spk 3D Playback Switch", LM4857_LVOL, 5, 1, 0,
 		lm4857_get_reg, lm4857_set_reg),
 	SOC_SINGLE_EXT("Amp HP 3d Playback Switch", LM4857_RVOL, 5, 1, 0,
@@ -520,7 +384,11 @@ static int neo1973_wm8753_init(struct snd_soc_pcm_runtime *rtd)
 				  ARRAY_SIZE(wm8753_dapm_widgets));
 
 	/* set endpoints to default mode */
-	set_scenario_endpoints(codec, NEO_AUDIO_OFF);
+	snd_soc_dapm_disable_pin(codec, "Audio Out");
+	snd_soc_dapm_disable_pin(codec, "GSM Line Out");
+	snd_soc_dapm_disable_pin(codec, "GSM Line In");
+	snd_soc_dapm_disable_pin(codec, "Headset Mic");
+	snd_soc_dapm_disable_pin(codec, "Call Mic");
 
 	/* add neo1973 specific controls */
 	err = snd_soc_add_controls(codec, wm8753_neo1973_controls,
-- 
1.7.2.3


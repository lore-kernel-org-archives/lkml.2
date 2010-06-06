Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab0FFXJw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 19:09:52 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64195 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab0FFXJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 19:09:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pdfBXa0/e90BaSOafjcv44OERT3VXPanDuEuMJ4aj6NZaBXZrY81xHSAlSLm3S8821
         26qUM7zJ/Ajrble+90N+fRcwMCIGX8fE//oSknCCfCWDEUQDCdUa2VN91Hoh/xb3lkx0
         itQIQ1mId+0JGuR5zcF38MLFhihfiOp2+hr4E=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: alsa-devel@alsa-project.org
Cc: tiwai@suse.de, linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/5]alsa:patch_realtek.c Add support for the MacBookAir1,1
Date: Sun,  6 Jun 2010 16:09:50 -0700
Message-Id: <1275865793-7357-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1275865793-7357-1-git-send-email-justinmattock@gmail.com>
References: <1275865793-7357-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: The below patch does not work with patch 3/5
(Add-SSID-table-for-MacBookAir1-1)

I'm giving the option of either adding/creating a whole
new section for the MacBookAir1,1 and or just add
the SSID for the MacBookAir1,1 using ALC885_MBP3
(Add-SSID-table-for-MacBookAir1-1).

Below is a patch that add's support to the MacBookAir1,1
to patch_realtek.c to enable it's functions for sound
mic, etc..
the bug entry is located here:
https://bugs.launchpad.net/mactel-support/+bug/268301
Also cleans up some coding fixes for:ALC885_MBA21
 
Note:I do not have this machine on hand only
codec#0 file for the machine so please
test if you have the appropriate equipment.
And also keep in mind I did look at both
the MacBookAir1,1(2,1) both seem to display
no info on what/where the mic is in their codec#0
file..(hopefully that can get resolved).


 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/sound/alsa/HD-Audio-Models.txt |    1 +
 sound/pci/hda/patch_realtek.c                |   78 ++++++++++++++++++++++----
 2 files changed, 68 insertions(+), 11 deletions(-)

diff --git a/Documentation/sound/alsa/HD-Audio-Models.txt b/Documentation/sound/alsa/HD-Audio-Models.txt
index 1d38b0d..d3838b5 100644
--- a/Documentation/sound/alsa/HD-Audio-Models.txt
+++ b/Documentation/sound/alsa/HD-Audio-Models.txt
@@ -125,6 +125,7 @@ ALC882/883/885/888/889
   macpro	MacPro support
   mb5		Macbook 5,1
   macmini3	Macmini 3,1
+  mba11		MacBook Air 1,1
   mba21		Macbook Air 2,1
   mbp3		Macbook Pro rev3
   imac24	iMac 24'' with jack detection
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 9b82d28..5cc55ff 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -209,6 +209,7 @@ enum {
 	ALC882_ASUS_A7J,
 	ALC882_ASUS_A7M,
 	ALC885_MACPRO,
+	ALC885_MBA11,
 	ALC885_MBA21,
 	ALC885_MBP3,
 	ALC885_MB5,
@@ -7444,6 +7445,13 @@ static struct snd_kcontrol_new alc885_mba21_mixer[] = {
      { }
 };
 
+/* MacBookAir1,1 not sure what/where things are(dont have the machine). */
+
+static struct snd_kcontrol_new alc885_mba11_mixer[] = {
+      HDA_CODEC_VOLUME("Speaker Playback Volume", 0x0c, 0x00, HDA_OUTPUT),
+      HDA_BIND_MUTE("Speaker Playback Switch", 0x0c, 0x02, HDA_OUTPUT),
+     { }
+};
 
 static struct snd_kcontrol_new alc885_mbp3_mixer[] = {
 	HDA_CODEC_VOLUME("Speaker Playback Volume", 0x0c, 0x00, HDA_OUTPUT),
@@ -7929,6 +7937,40 @@ static struct hda_verb alc885_mba21_init_verbs[] = {
 	{ }
  };
 
+static struct hda_verb alc885_mba11_init_verbs[] = {
+	/*Internal and HP Speaker Mixer*/
+	{0x0c, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_ZERO},
+	{0x0c, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
+	{0x0c, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(1)},
+	/* Main Speaker */	
+	{0x14, AC_VERB_SET_PIN_WIDGET_CONTROL, (PIN_OUT | AC_PINCTL_VREF_50) },
+	{0x14, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE},
+	{0x14, AC_VERB_SET_CONNECT_SEL, 0x00},
+	/* HP jack */
+	{0x15, AC_VERB_SET_PIN_WIDGET_CONTROL, 0xc4},
+	{0x15, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE},
+	{0x15, AC_VERB_SET_CONNECT_SEL, 0x00},
+	{0x15, AC_VERB_SET_UNSOLICITED_ENABLE, (ALC880_HP_EVENT | AC_USRSP_EN)},
+	/* FIXME: Line in? (as well as  the mic). */
+	{0x17, AC_VERB_SET_PIN_WIDGET_CONTROL, AC_PINCTL_VREF_50},
+	{0x17, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
+	/* 0x22 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In */
+	{0x22, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
+	{0x22, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(3)},
+	{0x22, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(2)},
+	{0x22, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(4)},
+	/* 0x23 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In */
+	{0x23, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
+	{0x23, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(3)},
+	{0x23, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(2)},
+	{0x23, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(4)},
+	/* 0x24 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In */
+	{0x24, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
+	{0x24, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(3)},
+	{0x24, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(2)},
+	{0x24, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(4)},
+	{ }
+};
 
 /* Macbook Pro rev3 */
 static struct hda_verb alc885_mbp3_init_verbs[] = {
@@ -9298,6 +9340,7 @@ static const char *alc882_models[ALC882_MODEL_LAST] = {
 	[ALC885_MACPRO]		= "macpro",
 	[ALC885_MB5]		= "mb5",
 	[ALC885_MACMINI3]	= "macmini3",
+	[ALC885_MBA11]		= "mba11",
 	[ALC885_MBA21]		= "mba21",
 	[ALC885_MBP3]		= "mbp3",
 	[ALC885_IMAC24]		= "imac24",
@@ -9488,6 +9531,7 @@ static struct snd_pci_quirk alc882_ssid_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x106b, 0x4600, "MacbookPro 5,2", ALC885_MB5),
 	SND_PCI_QUIRK(0x106b, 0x4100, "Macmini 3,1", ALC885_MACMINI3),
 	SND_PCI_QUIRK(0x106b, 0x3500, "MacBookAir 2,1", ALC885_MBA21),
+	SND_PCI_QUIRK(0x106b, 0x3400, "MacBookAir 1,1", ALC885_MBA11),
 	{} /* terminator */
 };
 
@@ -9539,17 +9583,29 @@ static struct alc_config_preset alc882_presets[] = {
 		.input_mux = &alc882_capture_source,
 		.dig_out_nid = ALC882_DIGOUT_NID,
 	},
-	   [ALC885_MBA21] = {
-			.mixers = { alc885_mba21_mixer },
-			.init_verbs = { alc885_mba21_init_verbs, alc880_gpio1_init_verbs },
-			.num_dacs = 2,
-			.dac_nids = alc882_dac_nids,
-			.channel_mode = alc885_mba21_ch_modes,
-			.num_channel_mode = ARRAY_SIZE(alc885_mba21_ch_modes),
-			.input_mux = &alc882_capture_source,
-			.unsol_event = alc_automute_amp_unsol_event,
-			.setup = alc885_mba21_setup,
-			.init_hook = alc_automute_amp,
+	[ALC885_MBA11] = {
+		.mixers = { alc885_mba11_mixer },
+		.init_verbs = { alc885_mba11_init_verbs, alc880_gpio1_init_verbs },
+		.num_dacs = 2,
+		.dac_nids = alc882_dac_nids,
+		.channel_mode = alc885_mba21_ch_modes,
+		.num_channel_mode = ARRAY_SIZE(alc885_mba21_ch_modes),
+		.input_mux = &alc882_capture_source,
+		.unsol_event = alc_automute_amp_unsol_event,
+		.setup = alc885_mb3_setup,
+		.init_hook = alc_automute_amp,
+	},
+	[ALC885_MBA21] = {
+		.mixers = { alc885_mba21_mixer },
+		.init_verbs = { alc885_mba21_init_verbs, alc880_gpio1_init_verbs },
+		.num_dacs = 2,
+		.dac_nids = alc882_dac_nids,
+		.channel_mode = alc885_mba21_ch_modes,
+		.num_channel_mode = ARRAY_SIZE(alc885_mba21_ch_modes),
+		.input_mux = &alc882_capture_source,
+		.unsol_event = alc_automute_amp_unsol_event,
+		.setup = alc885_mba21_setup,
+		.init_hook = alc_automute_amp,
        },
 	[ALC885_MBP3] = {
 		.mixers = { alc885_mbp3_mixer, alc882_chmode_mixer },
-- 
1.6.5.2.180.gc5b3e


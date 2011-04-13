Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab1DMQMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:12:35 -0400
Received: from kroah.org ([198.145.64.141]:52640 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932659Ab1DMQMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:12:32 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:42 2011
Message-Id: <20110413161042.573636690@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:09:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [01/71] ALSA: HDA: New AD1984A model for Dell Precision R5500
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 677cd904aba939bc4cfdc3c1eada8ec46582127e upstream.

For codec AD1984A, add a new model to support Dell Precision R5500
or the microphone jack won't work correctly.

BugLink: http://bugs.launchpad.net/bugs/741516
Tested-by: Kent Baxley <kent.baxley@canonical.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_analog.c |   89 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -4058,6 +4058,84 @@ static int ad1984a_thinkpad_init(struct
 }
 
 /*
+ * Precision R5500
+ * 0x12 - HP/line-out
+ * 0x13 - speaker (mono)
+ * 0x15 - mic-in
+ */
+
+static struct hda_verb ad1984a_precision_verbs[] = {
+	/* Unmute main output path */
+	{0x03, AC_VERB_SET_AMP_GAIN_MUTE, 0x27}, /* 0dB */
+	{0x21, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE + 0x1f}, /* 0dB */
+	{0x20, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(5) + 0x17}, /* 0dB */
+	/* Analog mixer; mute as default */
+	{0x20, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(0)},
+	{0x20, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(1)},
+	{0x20, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(2)},
+	{0x20, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(3)},
+	{0x20, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(4)},
+	/* Select mic as input */
+	{0x0c, AC_VERB_SET_CONNECT_SEL, 0x1},
+	{0x0c, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE + 0x27}, /* 0dB */
+	/* Configure as mic */
+	{0x15, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_VREF80},
+	{0x15, AC_VERB_SET_AMP_GAIN_MUTE, 0x7002}, /* raise mic as default */
+	/* HP unmute */
+	{0x12, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE},
+	/* turn on EAPD */
+	{0x13, AC_VERB_SET_EAPD_BTLENABLE, 0x02},
+	/* unsolicited event for pin-sense */
+	{0x12, AC_VERB_SET_UNSOLICITED_ENABLE, AC_USRSP_EN | AD1884A_HP_EVENT},
+	{ } /* end */
+};
+
+static struct snd_kcontrol_new ad1984a_precision_mixers[] = {
+	HDA_CODEC_VOLUME("Master Playback Volume", 0x21, 0x0, HDA_OUTPUT),
+	HDA_CODEC_MUTE("Master Playback Switch", 0x21, 0x0, HDA_OUTPUT),
+	HDA_CODEC_VOLUME("PCM Playback Volume", 0x20, 0x5, HDA_INPUT),
+	HDA_CODEC_MUTE("PCM Playback Switch", 0x20, 0x5, HDA_INPUT),
+	HDA_CODEC_VOLUME("Mic Playback Volume", 0x20, 0x01, HDA_INPUT),
+	HDA_CODEC_MUTE("Mic Playback Switch", 0x20, 0x01, HDA_INPUT),
+	HDA_CODEC_VOLUME("Mic Boost Volume", 0x15, 0x0, HDA_INPUT),
+	HDA_CODEC_MUTE("Front Playback Switch", 0x12, 0x0, HDA_OUTPUT),
+	HDA_CODEC_VOLUME("Speaker Playback Volume", 0x13, 0x0, HDA_OUTPUT),
+	HDA_CODEC_VOLUME("Capture Volume", 0x0c, 0x0, HDA_OUTPUT),
+	HDA_CODEC_MUTE("Capture Switch", 0x0c, 0x0, HDA_OUTPUT),
+	{ } /* end */
+};
+
+
+/* mute internal speaker if HP is plugged */
+static void ad1984a_precision_automute(struct hda_codec *codec)
+{
+	unsigned int present;
+
+	present = snd_hda_jack_detect(codec, 0x12);
+	snd_hda_codec_amp_stereo(codec, 0x13, HDA_OUTPUT, 0,
+				 HDA_AMP_MUTE, present ? HDA_AMP_MUTE : 0);
+}
+
+
+/* unsolicited event for HP jack sensing */
+static void ad1984a_precision_unsol_event(struct hda_codec *codec,
+					 unsigned int res)
+{
+	if ((res >> 26) != AD1884A_HP_EVENT)
+		return;
+	ad1984a_precision_automute(codec);
+}
+
+/* initialize jack-sensing, too */
+static int ad1984a_precision_init(struct hda_codec *codec)
+{
+	ad198x_init(codec);
+	ad1984a_precision_automute(codec);
+	return 0;
+}
+
+
+/*
  * HP Touchsmart
  * port-A (0x11)      - front hp-out
  * port-B (0x14)      - unused
@@ -4185,6 +4263,7 @@ enum {
 	AD1884A_MOBILE,
 	AD1884A_THINKPAD,
 	AD1984A_TOUCHSMART,
+	AD1984A_PRECISION,
 	AD1884A_MODELS
 };
 
@@ -4194,9 +4273,11 @@ static const char *ad1884a_models[AD1884
 	[AD1884A_MOBILE]	= "mobile",
 	[AD1884A_THINKPAD]	= "thinkpad",
 	[AD1984A_TOUCHSMART]	= "touchsmart",
+	[AD1984A_PRECISION]	= "precision",
 };
 
 static struct snd_pci_quirk ad1884a_cfg_tbl[] = {
+	SND_PCI_QUIRK(0x1028, 0x04ac, "Precision R5500", AD1984A_PRECISION),
 	SND_PCI_QUIRK(0x103c, 0x3030, "HP", AD1884A_MOBILE),
 	SND_PCI_QUIRK(0x103c, 0x3037, "HP 2230s", AD1884A_LAPTOP),
 	SND_PCI_QUIRK(0x103c, 0x3056, "HP", AD1884A_MOBILE),
@@ -4290,6 +4371,14 @@ static int patch_ad1884a(struct hda_code
 		codec->patch_ops.unsol_event = ad1984a_thinkpad_unsol_event;
 		codec->patch_ops.init = ad1984a_thinkpad_init;
 		break;
+	case AD1984A_PRECISION:
+		spec->mixers[0] = ad1984a_precision_mixers;
+		spec->init_verbs[spec->num_init_verbs++] =
+			ad1984a_precision_verbs;
+		spec->multiout.dig_out_nid = 0;
+		codec->patch_ops.unsol_event = ad1984a_precision_unsol_event;
+		codec->patch_ops.init = ad1984a_precision_init;
+		break;
 	case AD1984A_TOUCHSMART:
 		spec->mixers[0] = ad1984a_touchsmart_mixers;
 		spec->init_verbs[0] = ad1984a_touchsmart_verbs;



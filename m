Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab0DNWI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 18:08:26 -0400
Received: from shamrock.taprogge.org ([213.146.117.139]:42345 "EHLO
	shamrock.taprogge.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab0DNWIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 18:08:24 -0400
X-Greylist: delayed 1534 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Apr 2010 18:08:24 EDT
Date: Wed, 14 Apr 2010 23:42:04 +0200
From: Jens Taprogge <jens.taprogge@taprogge.org>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: Add initial support for Thinkpad T410s HDA codec.
Message-ID: <20100414214204.GA15425@ranger.taprogge.wh>
Mail-Followup-To: Jens Taprogge <jens.taprogge@taprogge.org>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-Score: -2.4 (--)
X-Spam-Report: Spam detection software, running on the system "shamrock.taprogge.org", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  Dear ALSA Maintainers, attached please find a patch that adds
	support for at least the T410s HDA codec. Most likely it will also add support
	for the T410 and T510 based models. The patch was derived from Ideapad support.
	Support for the laptop's and docking-station output connectors as well as
	the docking-station microphone connector and the laptops internal devices
	has been tested. Since it has been developed without a data-sheet available,
	support for digital outputs and the laptop's microphone input may well be
	incorrect. [...] 
	Content analysis details:   (-2.4 points, 10.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	1.9 TVD_RCVD_IP            TVD_RCVD_IP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.1 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear ALSA Maintainers,

attached please find a patch that adds support for at least the T410s
HDA codec.  Most likely it will also add support for the T410 and T510
based models.


The patch was derived from Ideapad support.  Support for the laptop's and
docking-station output connectors as well as the docking-station microphone
connector and the laptops internal devices has been tested.  Since it has been
developed without a data-sheet available, support for digital outputs and the
laptop's microphone input may well be incorrect.

Microphone mute functionality is not included:
The microphone mute button seems to be reported through thinkpad_acpi key
0000101b.  The mute button LED seems to be wired to thinkpad_acpi led
number 15.

Please apply.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
---
 sound/pci/hda/patch_conexant.c |  153 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 149 insertions(+), 4 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 61682e1..2a488f6 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -115,6 +115,7 @@ struct conexant_spec {
 	unsigned int port_d_mode;
 	unsigned int dell_vostro:1;
 	unsigned int ideapad:1;
+	unsigned int thinkpad:1;
 
 	unsigned int ext_mic_present;
 	unsigned int recording;
@@ -2031,6 +2032,9 @@ static void cxt5066_update_speaker(struct hda_codec *codec)
 	/* Port D (HP/LO) */
 	pinctl = ((spec->hp_present & 2) && spec->cur_eapd)
 		? spec->port_d_mode : 0;
+	/* Mute if Port A is connected on Thinkpad */
+	if (spec->thinkpad && (spec->hp_present & 1))
+		pinctl = 0;
 	snd_hda_codec_write(codec, 0x1c, 0, AC_VERB_SET_PIN_WIDGET_CONTROL,
 			pinctl);
 
@@ -2211,6 +2215,50 @@ static void cxt5066_ideapad_automic(struct hda_codec *codec)
 	}
 }
 
+/* toggle input of built-in digital mic and mic jack appropriately
+   order is: external mic -> dock mic -> interal mic */
+static void cxt5066_thinkpad_automic(struct hda_codec *codec)
+{
+	unsigned int ext_present, dock_present;
+
+	static struct hda_verb ext_mic_present[] = {
+		{0x14, AC_VERB_SET_CONNECT_SEL, 0},
+		{0x17, AC_VERB_SET_CONNECT_SEL, 1},
+		{0x1b, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_VREF80},
+		{0x23, AC_VERB_SET_PIN_WIDGET_CONTROL, 0},
+		{0x1a, AC_VERB_SET_PIN_WIDGET_CONTROL, 0},
+		{}
+	};
+	static struct hda_verb dock_mic_present[] = {
+		{0x14, AC_VERB_SET_CONNECT_SEL, 0},
+		{0x17, AC_VERB_SET_CONNECT_SEL, 0},
+		{0x1a, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_VREF80},
+		{0x23, AC_VERB_SET_PIN_WIDGET_CONTROL, 0},
+		{0x1b, AC_VERB_SET_PIN_WIDGET_CONTROL, 0},
+		{}
+	};
+	static struct hda_verb ext_mic_absent[] = {
+		{0x14, AC_VERB_SET_CONNECT_SEL, 2},
+		{0x23, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_IN},
+		{0x1b, AC_VERB_SET_PIN_WIDGET_CONTROL, 0},
+		{0x1a, AC_VERB_SET_PIN_WIDGET_CONTROL, 0},
+		{}
+	};
+
+	ext_present = snd_hda_jack_detect(codec, 0x1b);
+	dock_present = snd_hda_jack_detect(codec, 0x1a);
+	if (ext_present) {
+		snd_printdd("CXT5066: external microphone detected\n");
+		snd_hda_sequence_write(codec, ext_mic_present);
+	} else if (dock_present) {
+		snd_printdd("CXT5066: dock microphone detected\n");
+		snd_hda_sequence_write(codec, dock_mic_present);
+	} else {
+		snd_printdd("CXT5066: external microphone absent\n");
+		snd_hda_sequence_write(codec, ext_mic_absent);
+	}
+}
+
 /* mute internal speaker if HP is plugged */
 static void cxt5066_hp_automute(struct hda_codec *codec)
 {
@@ -2223,7 +2271,8 @@ static void cxt5066_hp_automute(struct hda_codec *codec)
 	/* Port D */
 	portD = snd_hda_jack_detect(codec, 0x1c);
 
-	spec->hp_present = !!(portA | portD);
+	spec->hp_present = !!(portA);
+	spec->hp_present |= portD ? 2 : 0;
 	snd_printdd("CXT5066: hp automute portA=%x portD=%x present=%d\n",
 		portA, portD, spec->hp_present);
 	cxt5066_update_speaker(codec);
@@ -2274,6 +2323,20 @@ static void cxt5066_ideapad_event(struct hda_codec *codec, unsigned int res)
 	}
 }
 
+/* unsolicited event for jack sensing */
+static void cxt5066_thinkpad_event(struct hda_codec *codec, unsigned int res)
+{
+	snd_printdd("CXT5066_thinkpad: unsol event %x (%x)\n", res, res >> 26);
+	switch (res >> 26) {
+	case CONEXANT_HP_EVENT:
+		cxt5066_hp_automute(codec);
+		break;
+	case CONEXANT_MIC_EVENT:
+		cxt5066_thinkpad_automic(codec);
+		break;
+	}
+}
+
 static const struct hda_input_mux cxt5066_analog_mic_boost = {
 	.num_items = 5,
 	.items = {
@@ -2292,7 +2355,7 @@ static void cxt5066_set_mic_boost(struct hda_codec *codec)
 		AC_VERB_SET_AMP_GAIN_MUTE,
 		AC_AMP_SET_RIGHT | AC_AMP_SET_LEFT | AC_AMP_SET_OUTPUT |
 			cxt5066_analog_mic_boost.items[spec->mic_boost].index);
-	if (spec->ideapad) {
+	if (spec->ideapad | spec->thinkpad) {
 		/* adjust the internal mic as well...it is not through 0x17 */
 		snd_hda_codec_write_cache(codec, 0x23, 0,
 			AC_VERB_SET_AMP_GAIN_MUTE,
@@ -2780,6 +2843,64 @@ static struct hda_verb cxt5066_init_verbs_ideapad[] = {
 	{ } /* end */
 };
 
+static struct hda_verb cxt5066_init_verbs_thinkpad[] = {
+	{0x1e, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_IN}, /* Port F */
+	{0x1d, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_IN}, /* Port E */
+
+	/* Port G: internal speakers  */
+	{0x1f, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT},
+	{0x1f, AC_VERB_SET_CONNECT_SEL, 0x00}, /* DAC1 */
+
+	/* Port A: HP, Amp  */
+	{0x19, AC_VERB_SET_PIN_WIDGET_CONTROL, 0},
+	{0x19, AC_VERB_SET_CONNECT_SEL, 0x00}, /* DAC1 */
+
+	/* Port B: Mic Dock */
+	{0x1a, AC_VERB_SET_PIN_WIDGET_CONTROL, 0},
+
+	/* Port C: Mic */
+	{0x1b, AC_VERB_SET_PIN_WIDGET_CONTROL, 0},
+
+	/* Port D: HP Dock, Amp */
+	{0x1c, AC_VERB_SET_PIN_WIDGET_CONTROL, 0},
+	{0x1c, AC_VERB_SET_CONNECT_SEL, 0x00}, /* DAC1 */
+
+	/* DAC1 */
+	{0x10, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE},
+
+	/* Node 14 connections: 0x17 0x18 0x23 0x24 0x27 */
+	{0x14, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0) | 0x50},
+	{0x14, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(1)},
+	{0x14, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(2) | 0x50},
+	{0x14, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(3)},
+	{0x14, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(4)},
+	{0x14, AC_VERB_SET_CONNECT_SEL, 2},	/* default to internal mic */
+
+	/* Audio input selector */
+	{0x17, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE | 0x2},
+	{0x17, AC_VERB_SET_CONNECT_SEL, 1},	/* route ext mic */
+
+	/* SPDIF route: PCM */
+	{0x20, AC_VERB_SET_CONNECT_SEL, 0x0},
+	{0x22, AC_VERB_SET_CONNECT_SEL, 0x0},
+
+	{0x20, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT},
+	{0x22, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT},
+
+	/* internal microphone */
+	{0x23, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_IN}, /* enable int mic */
+
+	/* EAPD */
+	{0x1d, AC_VERB_SET_EAPD_BTLENABLE, 0x2}, /* default on */
+
+	/* enable unsolicited events for Port A, B, C and D */
+	{0x19, AC_VERB_SET_UNSOLICITED_ENABLE, AC_USRSP_EN | CONEXANT_HP_EVENT},
+	{0x1c, AC_VERB_SET_UNSOLICITED_ENABLE, AC_USRSP_EN | CONEXANT_HP_EVENT},
+	{0x1a, AC_VERB_SET_UNSOLICITED_ENABLE, AC_USRSP_EN | CONEXANT_MIC_EVENT},
+	{0x1b, AC_VERB_SET_UNSOLICITED_ENABLE, AC_USRSP_EN | CONEXANT_MIC_EVENT},
+	{ } /* end */
+};
+
 static struct hda_verb cxt5066_init_verbs_portd_lo[] = {
 	{0x1c, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT},
 	{ } /* end */
@@ -2798,6 +2919,8 @@ static int cxt5066_init(struct hda_codec *codec)
 			cxt5066_vostro_automic(codec);
 		else if (spec->ideapad)
 			cxt5066_ideapad_automic(codec);
+		else if (spec->thinkpad)
+			cxt5066_thinkpad_automic(codec);
 	}
 	cxt5066_set_mic_boost(codec);
 	return 0;
@@ -2819,20 +2942,22 @@ static int cxt5066_olpc_init(struct hda_codec *codec)
 }
 
 enum {
-	CXT5066_LAPTOP,			/* Laptops w/ EAPD support */
+	CXT5066_LAPTOP,		/* Laptops w/ EAPD support */
 	CXT5066_DELL_LAPTOP,	/* Dell Laptop */
 	CXT5066_OLPC_XO_1_5,	/* OLPC XO 1.5 */
 	CXT5066_DELL_VOSTO,	/* Dell Vostro 1015i */
 	CXT5066_IDEAPAD,	/* Lenovo IdeaPad U150 */
+	CXT5066_THINKPAD,	/* Lenovo ThinkPad T410s, others? */
 	CXT5066_MODELS
 };
 
 static const char *cxt5066_models[CXT5066_MODELS] = {
-	[CXT5066_LAPTOP]		= "laptop",
+	[CXT5066_LAPTOP]	= "laptop",
 	[CXT5066_DELL_LAPTOP]	= "dell-laptop",
 	[CXT5066_OLPC_XO_1_5]	= "olpc-xo-1_5",
 	[CXT5066_DELL_VOSTO]    = "dell-vostro",
 	[CXT5066_IDEAPAD]	= "ideapad",
+	[CXT5066_THINKPAD]	= "thinkpad",
 };
 
 static struct snd_pci_quirk cxt5066_cfg_tbl[] = {
@@ -2843,6 +2968,7 @@ static struct snd_pci_quirk cxt5066_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x152d, 0x0833, "OLPC XO-1.5", CXT5066_OLPC_XO_1_5),
 	SND_PCI_QUIRK(0x1028, 0x0402, "Dell Vostro", CXT5066_DELL_VOSTO),
 	SND_PCI_QUIRK(0x17aa, 0x3a0d, "ideapad", CXT5066_IDEAPAD),
+	SND_PCI_QUIRK(0x17aa, 0x215e, "Lenovo Thinkpad", CXT5066_THINKPAD),
 	{}
 };
 
@@ -2950,6 +3076,22 @@ static int patch_cxt5066(struct hda_codec *codec)
 		/* input source automatically selected */
 		spec->input_mux = NULL;
 		break;
+	case CXT5066_THINKPAD:
+		codec->patch_ops.init = cxt5066_init;
+		codec->patch_ops.unsol_event = cxt5066_thinkpad_event;
+		spec->mixers[spec->num_mixers++] = cxt5066_mixer_master;
+		spec->mixers[spec->num_mixers++] = cxt5066_mixers;
+		spec->init_verbs[0] = cxt5066_init_verbs_thinkpad;
+		spec->thinkpad = 1;
+		spec->port_d_mode = PIN_OUT;
+		spec->mic_boost = 2;	/* default 20dB gain */
+
+		/* no S/PDIF out */
+		spec->multiout.dig_out_nid = 0;
+
+		/* input source automatically selected */
+		spec->input_mux = NULL;
+		break;
 	}
 
 	return 0;
@@ -2969,6 +3111,8 @@ static struct hda_codec_preset snd_hda_preset_conexant[] = {
 	  .patch = patch_cxt5066 },
 	{ .id = 0x14f15067, .name = "CX20583 (Pebble HSF)",
 	  .patch = patch_cxt5066 },
+	{ .id = 0x14f15069, .name = "CX20585",
+	  .patch = patch_cxt5066 },
 	{} /* terminator */
 };
 
@@ -2977,6 +3121,7 @@ MODULE_ALIAS("snd-hda-codec-id:14f15047");
 MODULE_ALIAS("snd-hda-codec-id:14f15051");
 MODULE_ALIAS("snd-hda-codec-id:14f15066");
 MODULE_ALIAS("snd-hda-codec-id:14f15067");
+MODULE_ALIAS("snd-hda-codec-id:14f15069");
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Conexant HD-audio codec");
-- 
1.7.0.4


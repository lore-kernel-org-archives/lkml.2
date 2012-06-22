Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab2FVDFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 23:05:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61380 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab2FVDF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 23:05:28 -0400
From: Huacai Chen <chenhuacai@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>, Zhangjin Wu <wuzhangjin@gmail.com>,
        Huacai Chen <chenhc@lemote.com>, Hongliang Tao <taohl@lemote.com>,
        Hua Yan <yanh@lemote.com>, alsa-devel@alsa-project.org
Subject: [PATCH V3 12/16] ALSA: HDA: Make hda sound card usable for Loongson.
Date: Fri, 22 Jun 2012 11:01:09 +0800
Message-Id: <1340334073-17804-13-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340334073-17804-1-git-send-email-chenhc@lemote.com>
References: <1340334073-17804-1-git-send-email-chenhc@lemote.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lemote A1004(Laptop) and A1205(All-In-One) use Conexant's hda codec,
this patch modify patch_conexant.c to add Lemote specific code.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Hongliang Tao <taohl@lemote.com>
Signed-off-by: Hua Yan <yanh@lemote.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Clemens Ladisch <clemens@ladisch.de>
Cc: alsa-devel@alsa-project.org
---
 include/linux/pci_ids.h        |    2 +
 sound/pci/hda/patch_conexant.c |   52 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index ab741b0..d8b0a52 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2906,3 +2906,5 @@
 #define PCI_DEVICE_ID_XEN_PLATFORM	0x0001
 
 #define PCI_VENDOR_ID_OCZ		0x1b85
+
+#define PCI_VENDOR_ID_LEMOTE		0x1c06
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 172370b..ca3cc237 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -142,6 +142,7 @@ struct conexant_spec {
 	unsigned int thinkpad:1;
 	unsigned int hp_laptop:1;
 	unsigned int asus:1;
+	unsigned int lemote:1;
 	unsigned int pin_eapd_ctrls:1;
 	unsigned int fixup_stereo_dmic:1;
 
@@ -2278,7 +2279,7 @@ static void cxt5066_automic(struct hda_codec *codec)
 		cxt5066_thinkpad_automic(codec);
 	else if (spec->hp_laptop)
 		cxt5066_hp_laptop_automic(codec);
-	else if (spec->asus)
+	else if (spec->asus || spec->lemote)
 		cxt5066_asus_automic(codec);
 }
 
@@ -2911,6 +2912,32 @@ static const struct hda_verb cxt5066_init_verbs_hp_laptop[] = {
 	{ } /* end */
 };
 
+static struct hda_verb cxt5066_init_verbs_lemote[] = {
+	{0x14, AC_VERB_SET_CONNECT_SEL, 0x0}, /* ADC1: Connection index: 0 */
+	{0x19, AC_VERB_SET_UNSOLICITED_ENABLE, AC_USRSP_EN | CONEXANT_HP_EVENT},
+	{0x1b, AC_VERB_SET_UNSOLICITED_ENABLE, AC_USRSP_EN | CONEXANT_MIC_EVENT},
+
+	/* DAC2: unused */
+	{0x11, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
+
+	/* ADC2, ADC3: unused */
+	{0x15, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(0)},
+	{0x15, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(1)},
+	{0x15, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(2)},
+	{0x15, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(3)},
+	{0x16, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(0)},
+	{0x16, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(1)},
+	{0x16, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(2)},
+	{0x16, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(3)},
+
+	/* Disable digital microphone port */
+	{0x23, AC_VERB_SET_PIN_WIDGET_CONTROL, 0},
+
+	/* Disable SPDIF */
+	{0x20, AC_VERB_SET_PIN_WIDGET_CONTROL, 0},
+	{ } /* end */
+};
+
 /* initialize jack-sensing, too */
 static int cxt5066_init(struct hda_codec *codec)
 {
@@ -2948,6 +2975,8 @@ enum {
 	CXT5066_THINKPAD,	/* Lenovo ThinkPad T410s, others? */
 	CXT5066_ASUS,		/* Asus K52JU, Lenovo G560 - Int mic at 0x1a and Ext mic at 0x1b */
 	CXT5066_HP_LAPTOP,      /* HP Laptop */
+	CXT5066_LEMOTE_A1004,   /* Lemote Laptop A1004 */
+	CXT5066_LEMOTE_A1205,   /* Lemote All-In-One A1205 */
 	CXT5066_AUTO,		/* BIOS auto-parser */
 	CXT5066_MODELS
 };
@@ -2961,6 +2990,8 @@ static const char * const cxt5066_models[CXT5066_MODELS] = {
 	[CXT5066_THINKPAD]	= "thinkpad",
 	[CXT5066_ASUS]		= "asus",
 	[CXT5066_HP_LAPTOP]	= "hp-laptop",
+	[CXT5066_LEMOTE_A1004]  = "lemote-laptop-a1004",
+	[CXT5066_LEMOTE_A1205]  = "lemote-aio-a1205",
 	[CXT5066_AUTO]		= "auto",
 };
 
@@ -2993,6 +3024,8 @@ static const struct snd_pci_quirk cxt5066_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3a0d, "Lenovo U350", CXT5066_ASUS),
 	SND_PCI_QUIRK(0x17aa, 0x38af, "Lenovo G560", CXT5066_ASUS),
 	SND_PCI_QUIRK(0x17aa, 0x3938, "Lenovo G565", CXT5066_AUTO),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_LEMOTE, 0x2011, "Lemote A1004", CXT5066_LEMOTE_A1004),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_LEMOTE, 0x2012, "Lemote A1205", CXT5066_LEMOTE_A1205),
 	SND_PCI_QUIRK(0x1b0a, 0x2092, "CyberpowerPC Gamer Xplorer N57001", CXT5066_AUTO),
 	{}
 };
@@ -3073,7 +3106,22 @@ static int patch_cxt5066(struct hda_codec *codec)
 		spec->port_d_mode = 0;
 		spec->mic_boost = 3; /* default 30dB gain */
 		break;
-
+	case CXT5066_LEMOTE_A1004:
+	case CXT5066_LEMOTE_A1205:
+		codec->patch_ops.init = cxt5066_init;
+		codec->patch_ops.unsol_event = cxt5066_unsol_event;
+		spec->init_verbs[spec->num_init_verbs] =
+			cxt5066_init_verbs_lemote;
+		spec->num_init_verbs++;
+		spec->lemote = 1;
+		spec->mixers[spec->num_mixers++] = cxt5066_mixer_master;
+		spec->mixers[spec->num_mixers++] = cxt5066_mixers;
+		/* no S/PDIF out */
+		/* input source automatically selected */
+		spec->input_mux = NULL;
+		spec->port_d_mode = 0;
+		spec->mic_boost = 3; /* default 30dB gain */
+		break;
 	case CXT5066_OLPC_XO_1_5:
 		codec->patch_ops.init = cxt5066_olpc_init;
 		codec->patch_ops.unsol_event = cxt5066_olpc_unsol_event;
-- 
1.7.7.3


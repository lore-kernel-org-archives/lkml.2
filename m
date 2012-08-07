Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab2HGXPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:15:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41610 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932906Ab2HGWhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:37:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        John McCarron <john.mccarron@canonical.com>,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 026/109] ALSA: hda - add dock support for Thinkpad X230 Tablet
Date: Tue,  7 Aug 2012 15:34:45 -0700
Message-Id: <20120807222045.389463462@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 108cc108a3bb42fe4705df1317ff98e1e29428a6 upstream.

Also add a model/fixup string "lenovo-dock", so that other Thinkpad
users will be able to test this fixup easily, to see if it enables
dock I/O for them as well.

BugLink: https://bugs.launchpad.net/bugs/1026953
Tested-by: John McCarron <john.mccarron@canonical.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/sound/alsa/HD-Audio-Models.txt |    3 ++-
 sound/pci/hda/patch_realtek.c                |   27 +++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 1 deletion(-)

--- a/Documentation/sound/alsa/HD-Audio-Models.txt
+++ b/Documentation/sound/alsa/HD-Audio-Models.txt
@@ -21,10 +21,11 @@ ALC267/268
 ==========
   N/A
 
-ALC269
+ALC269/270/275/276/280/282
 ======
   laptop-amic	Laptops with analog-mic input
   laptop-dmic	Laptops with digital-mic input
+  lenovo-dock   Enables docking station I/O for some Lenovos
 
 ALC662/663/272
 ==============
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5858,6 +5858,15 @@ static int alc269_resume(struct hda_code
 }
 #endif /* CONFIG_PM */
 
+static void alc269_fixup_pincfg_no_hp_to_lineout(struct hda_codec *codec,
+						 const struct alc_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (action == ALC_FIXUP_ACT_PRE_PROBE)
+		spec->parse_flags = HDA_PINCFG_NO_HP_FIXUP;
+}
+
 static void alc269_fixup_hweq(struct hda_codec *codec,
 			       const struct alc_fixup *fix, int action)
 {
@@ -5984,6 +5993,8 @@ enum {
 	ALC269VB_FIXUP_AMIC,
 	ALC269VB_FIXUP_DMIC,
 	ALC269_FIXUP_MIC2_MUTE_LED,
+	ALC269_FIXUP_LENOVO_DOCK,
+	ALC269_FIXUP_PINCFG_NO_HP_TO_LINEOUT,
 };
 
 static const struct alc_fixup alc269_fixups[] = {
@@ -6108,6 +6119,20 @@ static const struct alc_fixup alc269_fix
 		.type = ALC_FIXUP_FUNC,
 		.v.func = alc269_fixup_mic2_mute,
 	},
+	[ALC269_FIXUP_LENOVO_DOCK] = {
+		.type = ALC_FIXUP_PINS,
+		.v.pins = (const struct alc_pincfg[]) {
+			{ 0x19, 0x23a11040 }, /* dock mic */
+			{ 0x1b, 0x2121103f }, /* dock headphone */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_PINCFG_NO_HP_TO_LINEOUT
+	},
+	[ALC269_FIXUP_PINCFG_NO_HP_TO_LINEOUT] = {
+		.type = ALC_FIXUP_FUNC,
+		.v.func = alc269_fixup_pincfg_no_hp_to_lineout,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -6131,6 +6156,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x21b8, "Thinkpad Edge 14", ALC269_FIXUP_SKU_IGNORE),
 	SND_PCI_QUIRK(0x17aa, 0x21ca, "Thinkpad L412", ALC269_FIXUP_SKU_IGNORE),
 	SND_PCI_QUIRK(0x17aa, 0x21e9, "Thinkpad Edge 15", ALC269_FIXUP_SKU_IGNORE),
+	SND_PCI_QUIRK(0x17aa, 0x2203, "Thinkpad X230 Tablet", ALC269_FIXUP_LENOVO_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x3bf8, "Quanta FL1", ALC269_FIXUP_QUANTA_MUTE),
 	SND_PCI_QUIRK(0x17aa, 0x3bf8, "Lenovo Ideapd", ALC269_FIXUP_PCM_44K),
 	SND_PCI_QUIRK(0x17aa, 0x9e54, "LENOVO NB", ALC269_FIXUP_LENOVO_EAPD),
@@ -6189,6 +6215,7 @@ static const struct snd_pci_quirk alc269
 static const struct alc_model_fixup alc269_fixup_models[] = {
 	{.id = ALC269_FIXUP_AMIC, .name = "laptop-amic"},
 	{.id = ALC269_FIXUP_DMIC, .name = "laptop-dmic"},
+	{.id = ALC269_FIXUP_LENOVO_DOCK, .name = "lenovo-dock"},
 	{}
 };
 



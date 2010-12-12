Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab0LLXrD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:47:03 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36220 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab0LLXq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:56 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: david.henningsson@canonical.com, tiwai@suse.de, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [114/223] ALSA: HDA: Add fixup pins for Ideapad Y550
Message-Id: <20101212234655.48AFFB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:55 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: David Henningsson <david.henningsson@canonical.com>

commit 6cb3b707f95954ac18f19b4b3919af235738371a upstream.

By adding the subwoofer as a speaker pin, it is treated correctly when auto-muting.

BugLink: https://launchpad.net/bugs/611803
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/hda/patch_realtek.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

Index: linux/sound/pci/hda/patch_realtek.c
===================================================================
--- linux.orig/sound/pci/hda/patch_realtek.c
+++ linux/sound/pci/hda/patch_realtek.c
@@ -18679,6 +18679,26 @@ static void alc662_auto_init(struct hda_
 		alc_inithook(codec);
 }
 
+enum {
+	ALC662_FIXUP_IDEAPAD,
+};
+
+static const struct alc_fixup alc662_fixups[] = {
+	[ALC662_FIXUP_IDEAPAD] = {
+		.pins = (const struct alc_pincfg[]) {
+			{ 0x17, 0x99130112 }, /* subwoofer */
+			{ }
+		}
+	},
+};
+
+static struct snd_pci_quirk alc662_fixup_tbl[] = {
+	SND_PCI_QUIRK(0x17aa, 0x3a0d, "Lenovo Ideapad Y550", ALC662_FIXUP_IDEAPAD),
+	{}
+};
+
+
+
 static int patch_alc662(struct hda_codec *codec)
 {
 	struct alc_spec *spec;
@@ -18711,6 +18731,7 @@ static int patch_alc662(struct hda_codec
 	}
 
 	if (board_config == ALC662_AUTO) {
+		alc_pick_fixup(codec, alc662_fixup_tbl, alc662_fixups, 1);
 		/* automatic parse from the BIOS config */
 		err = alc662_parse_auto_config(codec);
 		if (err < 0) {
@@ -18769,8 +18790,11 @@ static int patch_alc662(struct hda_codec
 	spec->vmaster_nid = 0x02;
 
 	codec->patch_ops = alc_patch_ops;
-	if (board_config == ALC662_AUTO)
+	if (board_config == ALC662_AUTO) {
 		spec->init_hook = alc662_auto_init;
+		alc_pick_fixup(codec, alc662_fixup_tbl, alc662_fixups, 0);
+	}
+
 #ifdef CONFIG_SND_HDA_POWER_SAVE
 	if (!spec->loopback.amplist)
 		spec->loopback.amplist = alc662_loopbacks;

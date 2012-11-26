Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab2KZReV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:34:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47963 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933748Ab2KZRMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:12:21 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 199/270] ALSA: hda - Fix silent headphone output from Toshiba P200
Date: Mon, 26 Nov 2012 14:58:09 -0200
Message-Id: <1353949160-26803-200-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit cb766404e6b8c566569eb9ada02ea45d28729864 upstream.

By some reason, Toshiba laptop doesn't like the EAPD turned up for the
headphone pin.  Add a fix up code to force to turn down EAPD for NID
0x15.

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=569991

Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ herton: backported to 3.5:
  create enum/structs from scratch, instead of bringing
  commit 6e72aa5f. alc_apply_fixup with ALC_FIXUP_ACT_PRE_PROBE should
  be a noop on this, but keep it as it's a skeleton for possible
  quirks in the future being applied through stable ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/pci/hda/patch_realtek.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index e996453..649ce26 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5546,6 +5546,33 @@ static const struct hda_verb alc268_beep_init_verbs[] = {
 	{ }
 };
 
+enum {
+	ALC268_FIXUP_HP_EAPD,
+};
+
+static const struct alc_fixup alc268_fixups[] = {
+	[ALC268_FIXUP_HP_EAPD] = {
+		.type = ALC_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			{0x15, AC_VERB_SET_EAPD_BTLENABLE, 0},
+			{}
+		}
+	},
+};
+
+static const struct alc_model_fixup alc268_fixup_models[] = {
+	{.id = ALC268_FIXUP_HP_EAPD, .name = "hp-eapd"},
+	{}
+};
+
+static const struct snd_pci_quirk alc268_fixup_tbl[] = {
+	/* below is codec SSID since multiple Toshiba laptops have the
+	 * same PCI SSID 1179:ff00
+	 */
+	SND_PCI_QUIRK(0x1179, 0xff06, "Toshiba P200", ALC268_FIXUP_HP_EAPD),
+	{}
+};
+
 /*
  * BIOS auto configuration
  */
@@ -5577,6 +5604,9 @@ static int patch_alc268(struct hda_codec *codec)
 
 	spec = codec->spec;
 
+	alc_pick_fixup(codec, alc268_fixup_models, alc268_fixup_tbl, alc268_fixups);
+	alc_apply_fixup(codec, ALC_FIXUP_ACT_PRE_PROBE);
+
 	/* automatic parse from the BIOS config */
 	err = alc268_parse_auto_config(codec);
 	if (err < 0)
@@ -5606,6 +5636,8 @@ static int patch_alc268(struct hda_codec *codec)
 	codec->patch_ops = alc_patch_ops;
 	spec->shutup = alc_eapd_shutup;
 
+	alc_apply_fixup(codec, ALC_FIXUP_ACT_PROBE);
+
 	return 0;
 
  error:
-- 
1.7.9.5


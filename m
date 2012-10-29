Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761107Ab2J2Vgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:36:35 -0400
Received: from mail.kernel.org ([198.145.19.201]:47035 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761087Ab2J2Vgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:36:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 004/101] ALSA: hda - Fix silent headphone output from Toshiba P200
Date: Mon, 29 Oct 2012 14:34:17 -0700
Message-Id: <20121029213240.640989661@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit cb766404e6b8c566569eb9ada02ea45d28729864 upstream.

By some reason, Toshiba laptop doesn't like the EAPD turned up for the
headphone pin.  Add a fix up code to force to turn down EAPD for NID
0x15.

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=569991

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5704,6 +5704,7 @@ static const struct hda_verb alc268_beep
 
 enum {
 	ALC268_FIXUP_INV_DMIC,
+	ALC268_FIXUP_HP_EAPD,
 };
 
 static const struct alc_fixup alc268_fixups[] = {
@@ -5711,10 +5712,26 @@ static const struct alc_fixup alc268_fix
 		.type = ALC_FIXUP_FUNC,
 		.v.func = alc_fixup_inv_dmic_0x12,
 	},
+	[ALC268_FIXUP_HP_EAPD] = {
+		.type = ALC_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			{0x15, AC_VERB_SET_EAPD_BTLENABLE, 0},
+			{}
+		}
+	},
 };
 
 static const struct alc_model_fixup alc268_fixup_models[] = {
 	{.id = ALC268_FIXUP_INV_DMIC, .name = "inv-dmic"},
+	{.id = ALC268_FIXUP_HP_EAPD, .name = "hp-eapd"},
+	{}
+};
+
+static const struct snd_pci_quirk alc268_fixup_tbl[] = {
+	/* below is codec SSID since multiple Toshiba laptops have the
+	 * same PCI SSID 1179:ff00
+	 */
+	SND_PCI_QUIRK(0x1179, 0xff06, "Toshiba P200", ALC268_FIXUP_HP_EAPD),
 	{}
 };
 
@@ -5749,7 +5766,7 @@ static int patch_alc268(struct hda_codec
 
 	spec = codec->spec;
 
-	alc_pick_fixup(codec, alc268_fixup_models, NULL, alc268_fixups);
+	alc_pick_fixup(codec, alc268_fixup_models, alc268_fixup_tbl, alc268_fixups);
 	alc_apply_fixup(codec, ALC_FIXUP_ACT_PRE_PROBE);
 
 	/* automatic parse from the BIOS config */



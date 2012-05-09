Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab2EIGf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:35:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38622 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754187Ab2EIFwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:24 -0400
Message-Id: <20120509055030.181908488@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:33 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>,
        Josh Boyer <jwboyer@redhat.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>
Subject: [ 004/167] [PATCH] ALSA: hda/conexant - Set up the missing docking-station pins
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit d70f363222ef373c2037412f09a600357cfa1c7a upstream.

ThinkPad 410,420,510,520 and X201 with cx50585 & co chips have the
docking-station ports, but BIOS doesn't initialize for these pins.
Thus, like the former X200, we need to set up the pins manually in the
driver.

The odd part is that the same PCI SSID is used for X200 and T400, thus
we need to prepare individual fixup tables for cx5051 and others.

Bugzilla entries:
	https://bugzilla.redhat.com/show_bug.cgi?id=808559
	https://bugzilla.redhat.com/show_bug.cgi?id=806217
	https://bugzilla.redhat.com/show_bug.cgi?id=810697

Reported-by: Josh Boyer <jwboyer@redhat.com>
Reported-by: Jens Taprogge <jens.taprogge@taprogge.org>
Tested-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_conexant.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index f52c9ef..58b5de4 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -4367,8 +4367,10 @@ static void apply_pin_fixup(struct hda_codec *codec,
 
 enum {
 	CXT_PINCFG_LENOVO_X200,
+	CXT_PINCFG_LENOVO_TP410,
 };
 
+/* ThinkPad X200 & co with cxt5051 */
 static const struct cxt_pincfg cxt_pincfg_lenovo_x200[] = {
 	{ 0x16, 0x042140ff }, /* HP (seq# overridden) */
 	{ 0x17, 0x21a11000 }, /* dock-mic */
@@ -4376,15 +4378,33 @@ static const struct cxt_pincfg cxt_pincfg_lenovo_x200[] = {
 	{}
 };
 
+/* ThinkPad 410/420/510/520, X201 & co with cxt5066 */
+static const struct cxt_pincfg cxt_pincfg_lenovo_tp410[] = {
+	{ 0x19, 0x042110ff }, /* HP (seq# overridden) */
+	{ 0x1a, 0x21a190f0 }, /* dock-mic */
+	{ 0x1c, 0x212140ff }, /* dock-HP */
+	{}
+};
+
 static const struct cxt_pincfg *cxt_pincfg_tbl[] = {
 	[CXT_PINCFG_LENOVO_X200] = cxt_pincfg_lenovo_x200,
+	[CXT_PINCFG_LENOVO_TP410] = cxt_pincfg_lenovo_tp410,
 };
 
-static const struct snd_pci_quirk cxt_fixups[] = {
+static const struct snd_pci_quirk cxt5051_fixups[] = {
 	SND_PCI_QUIRK(0x17aa, 0x20f2, "Lenovo X200", CXT_PINCFG_LENOVO_X200),
 	{}
 };
 
+static const struct snd_pci_quirk cxt5066_fixups[] = {
+	SND_PCI_QUIRK(0x17aa, 0x20f2, "Lenovo T400", CXT_PINCFG_LENOVO_TP410),
+	SND_PCI_QUIRK(0x17aa, 0x215e, "Lenovo T410", CXT_PINCFG_LENOVO_TP410),
+	SND_PCI_QUIRK(0x17aa, 0x215f, "Lenovo T510", CXT_PINCFG_LENOVO_TP410),
+	SND_PCI_QUIRK(0x17aa, 0x21ce, "Lenovo T420", CXT_PINCFG_LENOVO_TP410),
+	SND_PCI_QUIRK(0x17aa, 0x21cf, "Lenovo T520", CXT_PINCFG_LENOVO_TP410),
+	{}
+};
+
 /* add "fake" mute amp-caps to DACs on cx5051 so that mixer mute switches
  * can be created (bko#42825)
  */
@@ -4421,11 +4441,13 @@ static int patch_conexant_auto(struct hda_codec *codec)
 		break;
 	case 0x14f15051:
 		add_cx5051_fake_mutes(codec);
+		apply_pin_fixup(codec, cxt5051_fixups, cxt_pincfg_tbl);
+		break;
+	default:
+		apply_pin_fixup(codec, cxt5066_fixups, cxt_pincfg_tbl);
 		break;
 	}
 
-	apply_pin_fixup(codec, cxt_fixups, cxt_pincfg_tbl);
-
 	err = cx_auto_search_adcs(codec);
 	if (err < 0)
 		return err;
-- 
1.7.10




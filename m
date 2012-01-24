Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab2AXCoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:44:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756394Ab2AXCn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:43:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:24 2012
Message-Id: <20120124023924.862736560@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:33:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [010/129] ALSA: HDA: Fix automute for Cirrus Logic 421x
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1423
Lines: 42

From: David Henningsson <david.henningsson@canonical.com>

commit 78e2a928e377d5124932d4399c6c581908b027a0 upstream.

There was a bug in the automute logic causing speakers not to
mute when headphones were plugged in.

Tested-by: Hsin-Yi Chen <hychen@canonical.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_cirrus.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -920,16 +920,14 @@ static void cs_automute(struct hda_codec
 
 	/* mute speakers if spdif or hp jack is plugged in */
 	for (i = 0; i < cfg->speaker_outs; i++) {
+		int pin_ctl = hp_present ? 0 : PIN_OUT;
+		/* detect on spdif is specific to CS421x */
+		if (spdif_present && (spec->vendor_nid == CS421X_VENDOR_NID))
+			pin_ctl = 0;
+
 		nid = cfg->speaker_pins[i];
 		snd_hda_codec_write(codec, nid, 0,
-				    AC_VERB_SET_PIN_WIDGET_CONTROL,
-				    hp_present ? 0 : PIN_OUT);
-		/* detect on spdif is specific to CS421x */
-		if (spec->vendor_nid == CS421X_VENDOR_NID) {
-			snd_hda_codec_write(codec, nid, 0,
-					AC_VERB_SET_PIN_WIDGET_CONTROL,
-					spdif_present ? 0 : PIN_OUT);
-		}
+				    AC_VERB_SET_PIN_WIDGET_CONTROL, pin_ctl);
 	}
 	if (spec->gpio_eapd_hp) {
 		unsigned int gpio = hp_present ?



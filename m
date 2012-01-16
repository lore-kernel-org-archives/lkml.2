Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab2APS5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:57:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42873 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756191Ab2APSsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:48:36 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 16 10:45:16 2012
Message-Id: <20120116184516.521429308@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Mon, 16 Jan 2012 10:44:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [09/48] ALSA: HDA: Fix automute for Cirrus Logic 421x
In-Reply-To: <20120116184527.GA11972@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

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
@@ -916,16 +916,14 @@ static void cs_automute(struct hda_codec
 
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
 	if (spec->board_config == CS420X_MBP53 ||
 	    spec->board_config == CS420X_MBP55 ||



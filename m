Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab1CUXoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:44:09 -0400
Received: from kroah.org ([198.145.64.141]:49502 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341Ab1CUXPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:51 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:14 2011
Message-Id: <20110321230714.678550422@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [53/87] ALSA: HDA: Realtek ALC88x: Do not over-initialize speakers and hp that are primary outputs
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 0a3fabe30e1a3b2037a12b863b8c45fffce38ee9 upstream.

Do not initialize again the what has already been initialized as
multi outs, as this breaks surround speakers.

Tested-by: Bartłomiej Żogała <nusch88@gmail.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |   37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10736,23 +10736,28 @@ static void alc882_auto_init_hp_out(stru
 	hda_nid_t pin, dac;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(spec->autocfg.hp_pins); i++) {
-		pin = spec->autocfg.hp_pins[i];
-		if (!pin)
-			break;
-		dac = spec->multiout.hp_nid;
-		if (!dac)
-			dac = spec->multiout.dac_nids[0]; /* to front */
-		alc882_auto_set_output_and_unmute(codec, pin, PIN_HP, dac);
+	if (spec->autocfg.line_out_type != AUTO_PIN_HP_OUT) {
+		for (i = 0; i < ARRAY_SIZE(spec->autocfg.hp_pins); i++) {
+			pin = spec->autocfg.hp_pins[i];
+			if (!pin)
+				break;
+			dac = spec->multiout.hp_nid;
+			if (!dac)
+				dac = spec->multiout.dac_nids[0]; /* to front */
+			alc882_auto_set_output_and_unmute(codec, pin, PIN_HP, dac);
+		}
 	}
-	for (i = 0; i < ARRAY_SIZE(spec->autocfg.speaker_pins); i++) {
-		pin = spec->autocfg.speaker_pins[i];
-		if (!pin)
-			break;
-		dac = spec->multiout.extra_out_nid[0];
-		if (!dac)
-			dac = spec->multiout.dac_nids[0]; /* to front */
-		alc882_auto_set_output_and_unmute(codec, pin, PIN_OUT, dac);
+
+	if (spec->autocfg.line_out_type != AUTO_PIN_SPEAKER_OUT) {
+		for (i = 0; i < ARRAY_SIZE(spec->autocfg.speaker_pins); i++) {
+			pin = spec->autocfg.speaker_pins[i];
+			if (!pin)
+				break;
+			dac = spec->multiout.extra_out_nid[0];
+			if (!dac)
+				dac = spec->multiout.dac_nids[0]; /* to front */
+			alc882_auto_set_output_and_unmute(codec, pin, PIN_OUT, dac);
+		}
 	}
 }
 



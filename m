Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111Ab1LGQVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:21:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33766 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756342Ab1LGQVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:21:14 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:16 2011
Message-Id: <20111207161216.741462772@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:26 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Takashi Iwai <tiwai@suse.de>
Subject: [024/104] ALSA: hda/realtek - Fix missing inits of item indices for auto-mic
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6759dc323826c2c806c998cd93945c5476688dd2 upstream.

When the imux entries are rebuilt in alc_rebuild_imux_for_auto_mic(),
the initialization of index field is missing.  It may work without it
casually when the original imux was created by the auto-parser, but
it's definitely broken in the case of static configs where no imux was
parsed beforehand.  Because of this, the auto-mic switching doesn't
work properly on some model options.

This patch adds the missing initialization of index field.

Reported-by: Dmitry Nezhevenko <dion@inhex.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1023,8 +1023,20 @@ static bool alc_rebuild_imux_for_auto_mi
 	spec->imux_pins[2] = spec->dock_mic_pin;
 	for (i = 0; i < 3; i++) {
 		strcpy(imux->items[i].label, texts[i]);
-		if (spec->imux_pins[i])
+		if (spec->imux_pins[i]) {
+			hda_nid_t pin = spec->imux_pins[i];
+			int c;
+			for (c = 0; c < spec->num_adc_nids; c++) {
+				hda_nid_t cap = spec->capsrc_nids ?
+				spec->capsrc_nids[c] : spec->adc_nids[c];
+				int idx = get_connection_index(codec, cap, pin);
+				if (idx >= 0) {
+					imux->items[i].index = idx;
+					break;
+				}
+			}
 			imux->num_items = i + 1;
+		}
 	}
 	spec->num_mux_defs = 1;
 	spec->input_mux = imux;



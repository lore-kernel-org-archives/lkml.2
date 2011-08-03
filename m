Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab1HCX14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:27:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142Ab1HCX1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:27:40 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:49 2011
Message-Id: <20110803221249.110300342@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [051/102] ALSA: hda - Fix duplicated DAC assignments for Realtek
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit c48a8fb0d31d6147d8d76b8e2ad7f51a2fbb5c4d upstream.

Copying hp_pins and speaker_pins from line_out_pins may confuse the
parser, and it can lead to duplicated initializations for the same pin
with a wrong DAC assignment.  The problem appears in 3.0 kernel code.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1578,13 +1578,15 @@ static void alc_init_auto_hp(struct hda_
 	if (present == 3)
 		spec->automute_hp_lo = 1; /* both HP and LO automute */
 
-	if (!cfg->speaker_pins[0]) {
+	if (!cfg->speaker_pins[0] &&
+	    cfg->line_out_type == AUTO_PIN_SPEAKER_OUT) {
 		memcpy(cfg->speaker_pins, cfg->line_out_pins,
 		       sizeof(cfg->speaker_pins));
 		cfg->speaker_outs = cfg->line_outs;
 	}
 
-	if (!cfg->hp_pins[0]) {
+	if (!cfg->hp_pins[0] &&
+	    cfg->line_out_type == AUTO_PIN_HP_OUT) {
 		memcpy(cfg->hp_pins, cfg->line_out_pins,
 		       sizeof(cfg->hp_pins));
 		cfg->hp_outs = cfg->line_outs;
@@ -1603,6 +1605,7 @@ static void alc_init_auto_hp(struct hda_
 		spec->automute_mode = ALC_AUTOMUTE_PIN;
 	}
 	if (spec->automute && cfg->line_out_pins[0] &&
+	    cfg->speaker_pins[0] &&
 	    cfg->line_out_pins[0] != cfg->hp_pins[0] &&
 	    cfg->line_out_pins[0] != cfg->speaker_pins[0]) {
 		for (i = 0; i < cfg->line_outs; i++) {



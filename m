Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933649Ab2DLAIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:08:30 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:63303 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933537Ab2DKXOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:14:51 -0400
Message-Id: <20120411231019.558439340@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:10:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [ 08/78] ALSA: hda/realtek - Fix ADC assignment with a shared HP/Mic pin
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 26acaf08556a3c64ebf8ea3654b51e6acbb0a26c upstream.

The recent Realtek driver tries to assign an extra input via the
headphone plug when only a single input source is found.  The code
worked on Samsung Q1, but it broke ASUS 1015 where the mic is a
digital-mic and only a specific ADC works.

This patch fixes the assignment of ADC in the shared mic/hp case.
Instead of assuming the single ADC at first, reduce the ADCs after
trying to assign both mic and HP pins.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=42973

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2709,9 +2709,6 @@ static int alc_auto_fill_adc_caps(struct
 	int max_nums = ARRAY_SIZE(spec->private_adc_nids);
 	int i, nums = 0;
 
-	if (spec->shared_mic_hp)
-		max_nums = 1; /* no multi streams with the shared HP/mic */
-
 	nid = codec->start_nid;
 	for (i = 0; i < codec->num_nodes; i++, nid++) {
 		hda_nid_t src;
@@ -3723,6 +3720,7 @@ static void alc_remove_invalid_adc_nids(
 	if (spec->dyn_adc_switch)
 		return;
 
+ again:
 	nums = 0;
 	for (n = 0; n < spec->num_adc_nids; n++) {
 		hda_nid_t cap = spec->private_capsrc_nids[n];
@@ -3743,6 +3741,11 @@ static void alc_remove_invalid_adc_nids(
 	if (!nums) {
 		/* check whether ADC-switch is possible */
 		if (!alc_check_dyn_adc_switch(codec)) {
+			if (spec->shared_mic_hp) {
+				spec->shared_mic_hp = 0;
+				spec->private_imux[0].num_items = 1;
+				goto again;
+			}
 			printk(KERN_WARNING "hda_codec: %s: no valid ADC found;"
 			       " using fallback 0x%x\n",
 			       codec->chip_name, spec->private_adc_nids[0]);
@@ -3760,7 +3763,7 @@ static void alc_remove_invalid_adc_nids(
 
 	if (spec->auto_mic)
 		alc_auto_mic_check_imux(codec); /* check auto-mic setups */
-	else if (spec->input_mux->num_items == 1)
+	else if (spec->input_mux->num_items == 1 || spec->shared_mic_hp)
 		spec->num_adc_nids = 1; /* reduce to a single ADC */
 }
 



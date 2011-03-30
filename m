Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965075Ab1C3V0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:26:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:48428 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965070Ab1C3VJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133751"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: Vitaliy.Kulikov@idt.com, tiwai@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [202/275] ALSA: hda - fix digital mic selection in mixer on 92HD8X codecs
Message-Id: <20110330210726.63FF73E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Vitaliy Kulikov <Vitaliy.Kulikov@idt.com>

commit 094a42452abd5564429045e210281c6d22e67fca upstream.

When the mux for digital mic is different from the mux for other mics,
the current auto-parser doesn't handle them in a right way but provides
only one mic.  This patch fixes the issue.

Signed-off-by: Vitaliy Kulikov <Vitaliy.Kulikov@idt.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/hda/patch_sigmatel.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/sound/pci/hda/patch_sigmatel.c
===================================================================
--- linux-2.6.35.y.orig/sound/pci/hda/patch_sigmatel.c	2011-03-29 22:50:39.070258709 -0700
+++ linux-2.6.35.y/sound/pci/hda/patch_sigmatel.c	2011-03-29 23:03:02.481236681 -0700
@@ -737,7 +737,7 @@
 	struct sigmatel_spec *spec = codec->spec;
 	unsigned int adc_idx = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id);
 	const struct hda_input_mux *imux = spec->input_mux;
-	unsigned int idx, prev_idx;
+	unsigned int idx, prev_idx, didx;
 
 	idx = ucontrol->value.enumerated.item[0];
 	if (idx >= imux->num_items)
@@ -749,7 +749,8 @@
 		snd_hda_codec_write_cache(codec, spec->mux_nids[adc_idx], 0,
 					  AC_VERB_SET_CONNECT_SEL,
 					  imux->items[idx].index);
-		if (prev_idx >= spec->num_analog_muxes) {
+		if (prev_idx >= spec->num_analog_muxes &&
+		    spec->mux_nids[adc_idx] != spec->dmux_nids[adc_idx]) {
 			imux = spec->dinput_mux;
 			/* 0 = analog */
 			snd_hda_codec_write_cache(codec,
@@ -759,9 +760,13 @@
 		}
 	} else {
 		imux = spec->dinput_mux;
+		/* first dimux item is hardcoded to select analog imux,
+		 * so lets skip it
+		 */
+		didx = idx - spec->num_analog_muxes + 1;
 		snd_hda_codec_write_cache(codec, spec->dmux_nids[adc_idx], 0,
 					  AC_VERB_SET_CONNECT_SEL,
-					  imux->items[idx - 1].index);
+					  imux->items[didx].index);
 	}
 	spec->cur_mux[adc_idx] = idx;
 	return 1;

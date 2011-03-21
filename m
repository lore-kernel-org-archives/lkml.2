Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab1CUX7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:59:00 -0400
Received: from kroah.org ([198.145.64.141]:49022 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014Ab1CUXNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:13:51 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:10:52 2011
Message-Id: <20110321231052.804625596@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:10:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vitaliy Kulikov <Vitaliy.Kulikov@idt.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [20/44] ALSA: hda - fix digital mic selection in mixer on 92HD8X codecs
In-Reply-To: <20110321231105.GA1744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Vitaliy Kulikov <Vitaliy.Kulikov@idt.com>

commit 094a42452abd5564429045e210281c6d22e67fca upstream.

When the mux for digital mic is different from the mux for other mics,
the current auto-parser doesn't handle them in a right way but provides
only one mic.  This patch fixes the issue.

Signed-off-by: Vitaliy Kulikov <Vitaliy.Kulikov@idt.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -727,7 +727,7 @@ static int stac92xx_mux_enum_put(struct
 	struct sigmatel_spec *spec = codec->spec;
 	unsigned int adc_idx = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id);
 	const struct hda_input_mux *imux = spec->input_mux;
-	unsigned int idx, prev_idx;
+	unsigned int idx, prev_idx, didx;
 
 	idx = ucontrol->value.enumerated.item[0];
 	if (idx >= imux->num_items)
@@ -739,7 +739,8 @@ static int stac92xx_mux_enum_put(struct
 		snd_hda_codec_write_cache(codec, spec->mux_nids[adc_idx], 0,
 					  AC_VERB_SET_CONNECT_SEL,
 					  imux->items[idx].index);
-		if (prev_idx >= spec->num_analog_muxes) {
+		if (prev_idx >= spec->num_analog_muxes &&
+		    spec->mux_nids[adc_idx] != spec->dmux_nids[adc_idx]) {
 			imux = spec->dinput_mux;
 			/* 0 = analog */
 			snd_hda_codec_write_cache(codec,
@@ -749,9 +750,13 @@ static int stac92xx_mux_enum_put(struct
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



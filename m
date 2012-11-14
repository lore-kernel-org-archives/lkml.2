Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab2KNGBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:01:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55126 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756279Ab2KNFuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:37 -0500
Message-Id: <20121114053941.997269152@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:32 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>, Massimo Del Fedele <max@veneto.com>
Subject: [ 59/82] ALSA: hda - Fix empty DAC filling in patch_via.c
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 5b3761954dac2d1393beef8210eb8cee81d16b8d upstream.

In via_auto_fill_adc_nids(), the parser tries to fill dac_nids[] at
the point of the current line-out (i).  When no valid path is found
for this output, this results in dac = 0, thus it creates a hole in
dac_nids[].  This confuses is_empty_dac() and trims the detected DAC
in later reference.

This patch fixes the bug by appending DAC properly to dac_nids[] in
via_auto_fill_adc_nids().

Reported-by: Massimo Del Fedele <max@veneto.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_via.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index 72a2f60..bf57fa6 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -1809,11 +1809,11 @@ static int via_auto_fill_dac_nids(struct hda_codec *codec)
 {
 	struct via_spec *spec = codec->spec;
 	const struct auto_pin_cfg *cfg = &spec->autocfg;
-	int i, dac_num;
+	int i;
 	hda_nid_t nid;
 
+	spec->multiout.num_dacs = 0;
 	spec->multiout.dac_nids = spec->private_dac_nids;
-	dac_num = 0;
 	for (i = 0; i < cfg->line_outs; i++) {
 		hda_nid_t dac = 0;
 		nid = cfg->line_out_pins[i];
@@ -1824,16 +1824,13 @@ static int via_auto_fill_dac_nids(struct hda_codec *codec)
 		if (!i && parse_output_path(codec, nid, dac, 1,
 					    &spec->out_mix_path))
 			dac = spec->out_mix_path.path[0];
-		if (dac) {
-			spec->private_dac_nids[i] = dac;
-			dac_num++;
-		}
+		if (dac)
+			spec->private_dac_nids[spec->multiout.num_dacs++] = dac;
 	}
 	if (!spec->out_path[0].depth && spec->out_mix_path.depth) {
 		spec->out_path[0] = spec->out_mix_path;
 		spec->out_mix_path.depth = 0;
 	}
-	spec->multiout.num_dacs = dac_num;
 	return 0;
 }
 



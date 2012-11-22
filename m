Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821Ab2KVV7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:59:36 -0500
Received: from mail.kernel.org ([198.145.19.201]:49645 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894Ab2KVSkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Massimo Del Fedele <max@veneto.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 21/83] ALSA: hda - Fix empty DAC filling in patch_via.c
Date: Wed, 21 Nov 2012 16:41:43 -0800
Message-Id: <20121122004214.863758881@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_via.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -1875,11 +1875,11 @@ static int via_auto_fill_dac_nids(struct
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
@@ -1890,16 +1890,13 @@ static int via_auto_fill_dac_nids(struct
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
 



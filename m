Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab2LMOEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:04:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44223 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094Ab2LMOEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:04:11 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 056/241] ALSA: hda - Fix empty DAC filling in patch_via.c
Date: Thu, 13 Dec 2012 11:57:01 -0200
Message-Id: <1355407206-17100-57-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/pci/hda/patch_via.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index 92dff3e..b601888 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -1866,11 +1866,11 @@ static int via_auto_fill_dac_nids(struct hda_codec *codec)
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
@@ -1881,16 +1881,13 @@ static int via_auto_fill_dac_nids(struct hda_codec *codec)
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
 
-- 
1.7.9.5


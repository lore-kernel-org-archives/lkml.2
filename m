Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726Ab1FWRyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:54:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:35263 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933666Ab1FWRh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:57 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Vitaliy Kulikov <Vitaliy.Kulikov@idt.com>,
        Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 184/247] ALSA: hda - fix digital mic selection in mixer on 92HD8X codecs
Date: Thu, 23 Jun 2011 13:34:12 -0400
Message-Id: <1308850515-15242-125-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaliy Kulikov <Vitaliy.Kulikov@idt.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 094a42452abd5564429045e210281c6d22e67fca upstream.

When the mux for digital mic is different from the mux for other mics,
the current auto-parser doesn't handle them in a right way but provides
only one mic.  This patch fixes the issue.

Signed-off-by: Vitaliy Kulikov <Vitaliy.Kulikov@idt.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/hda/patch_sigmatel.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 6cf2dd4..02b813ef6 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -735,7 +735,7 @@ static int stac92xx_mux_enum_put(struct snd_kcontrol *kcontrol, struct snd_ctl_e
 	struct sigmatel_spec *spec = codec->spec;
 	unsigned int adc_idx = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id);
 	const struct hda_input_mux *imux = spec->input_mux;
-	unsigned int idx, prev_idx;
+	unsigned int idx, prev_idx, didx;
 
 	idx = ucontrol->value.enumerated.item[0];
 	if (idx >= imux->num_items)
@@ -747,7 +747,8 @@ static int stac92xx_mux_enum_put(struct snd_kcontrol *kcontrol, struct snd_ctl_e
 		snd_hda_codec_write_cache(codec, spec->mux_nids[adc_idx], 0,
 					  AC_VERB_SET_CONNECT_SEL,
 					  imux->items[idx].index);
-		if (prev_idx >= spec->num_analog_muxes) {
+		if (prev_idx >= spec->num_analog_muxes &&
+		    spec->mux_nids[adc_idx] != spec->dmux_nids[adc_idx]) {
 			imux = spec->dinput_mux;
 			/* 0 = analog */
 			snd_hda_codec_write_cache(codec,
@@ -757,9 +758,13 @@ static int stac92xx_mux_enum_put(struct snd_kcontrol *kcontrol, struct snd_ctl_e
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
-- 
1.7.4.4


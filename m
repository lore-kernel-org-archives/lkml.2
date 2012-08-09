Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab2HIGr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 02:47:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59538 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab2HIGrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 02:47:25 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Cc: David Henningsson <david.henningsson@canonical.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: hda/realtek - Keep analog bypass muted on ALC892
Date: Thu,  9 Aug 2012 08:47:19 +0200
Message-Id: <1344494839-6942-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.11.4
X-Provags-ID: V02:K0:ldZICzQpTxNY0t0slPSqGmST00jhDli5qVDqIpEFzA4
 Id3BNPYgQWVRyQt67m7OCVRHLY8ag3zI/o1noMn63WSX0uVDxZ
 bhFAgPDHaxczYEKmYjb5cGB5qOkFbwks3tPQpyIgPMHHQjYoRG
 132AKM3N7l6cICum05jiunhM0lhe8gPUyCPgqSNKfHkmQsNdAS
 PLDz1eOH77NB7hYNRaBZnba1YflYdilHVw5J81/ooz2uYzbE9q
 qFkmHp0Ko19ern8v5w/Nqyd7LZFsyCplJMOJvoLSr4ylgrYh94
 3h1Jv6Qgp+3jZB6hGRHR4M+54Ao+NifIXQhZucu9sXEp8624Va
 6iO8uSjF4Me+GesQMuOBEwRejj85Nr3px307TXQ8r2J5o5B6Jc
 8arCEVqTb6Tg1r3VKXHU52rG+0gBxHAlaPl9yrQci69UDt89Iu
 tCWZB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unmuting the analog bypass causes any input to be directly bypassed to
the outputs, which is usually not expected by the user.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
Note that this patch could be generalized to include all codec variants
that have this second channel. As I don't have access to all the data
sheets I'll leave that decision up to somebody with more hardware
available.

 sound/pci/hda/patch_realtek.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 4f81dd4..54d0917 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3752,8 +3752,15 @@ static void alc_auto_set_output_and_unmute(struct hda_codec *codec,
 	if (nid_has_mute(codec, mix, HDA_INPUT)) {
 		snd_hda_codec_write(codec, mix, 0, AC_VERB_SET_AMP_GAIN_MUTE,
 			    AMP_IN_UNMUTE(0));
-		snd_hda_codec_write(codec, mix, 0, AC_VERB_SET_AMP_GAIN_MUTE,
-			    AMP_IN_UNMUTE(1));
+		/*
+		 * On ALC892, the second entry in the connection list is the
+		 * analog bypass. Unmuting it will cause any inputs to be
+		 * directly forwarded to the corresponding outputs.
+		 */
+		if (codec->subsystem_id != 0x10ec0892)
+			snd_hda_codec_write(codec, mix, 0,
+					    AC_VERB_SET_AMP_GAIN_MUTE,
+					    AMP_IN_UNMUTE(1));
 	}
 	/* initialize volume */
 	nid = alc_look_for_out_vol_nid(codec, pin, dac);
-- 
1.7.11.4


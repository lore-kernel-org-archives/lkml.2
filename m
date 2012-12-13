Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab2LMO6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:58:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44244 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109Ab2LMOE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:04:28 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 060/241] ALSA: hda - Improve HP depop when system enter to S3
Date: Thu, 13 Dec 2012 11:57:05 -0200
Message-Id: <1355407206-17100-61-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 1387e2d12799e554df2f60e7ae7fe01384bcb96f upstream.

alc269_toggle_power_output() was only use in ALC269VB.  I rename it to
alc269vb_toggle_power_output().

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/pci/hda/patch_realtek.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 649ce26..bc6799d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5705,7 +5705,7 @@ static int alc269_parse_auto_config(struct hda_codec *codec)
 	return alc_parse_auto_config(codec, alc269_ignore, ssids);
 }
 
-static void alc269_toggle_power_output(struct hda_codec *codec, int power_up)
+static void alc269vb_toggle_power_output(struct hda_codec *codec, int power_up)
 {
 	int val = alc_read_coef_idx(codec, 0x04);
 	if (power_up)
@@ -5722,10 +5722,10 @@ static void alc269_shutup(struct hda_codec *codec)
 	if (spec->codec_variant != ALC269_TYPE_ALC269VB)
 		return;
 
-	if ((alc_get_coef0(codec) & 0x00ff) == 0x017)
-		alc269_toggle_power_output(codec, 0);
-	if ((alc_get_coef0(codec) & 0x00ff) == 0x018) {
-		alc269_toggle_power_output(codec, 0);
+	if (spec->codec_variant == ALC269_TYPE_ALC269VB)
+		alc269vb_toggle_power_output(codec, 0);
+	if (spec->codec_variant == ALC269_TYPE_ALC269VB &&
+			(alc_get_coef0(codec) & 0x00ff) == 0x018) {
 		msleep(150);
 	}
 }
@@ -5735,24 +5735,22 @@ static int alc269_resume(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
 
-	if (spec->codec_variant == ALC269_TYPE_ALC269VB ||
+	if (spec->codec_variant == ALC269_TYPE_ALC269VB)
+		alc269vb_toggle_power_output(codec, 0);
+	if (spec->codec_variant == ALC269_TYPE_ALC269VB &&
 			(alc_get_coef0(codec) & 0x00ff) == 0x018) {
-		alc269_toggle_power_output(codec, 0);
 		msleep(150);
 	}
 
 	codec->patch_ops.init(codec);
 
-	if (spec->codec_variant == ALC269_TYPE_ALC269VB ||
+	if (spec->codec_variant == ALC269_TYPE_ALC269VB)
+		alc269vb_toggle_power_output(codec, 1);
+	if (spec->codec_variant == ALC269_TYPE_ALC269VB &&
 			(alc_get_coef0(codec) & 0x00ff) == 0x017) {
-		alc269_toggle_power_output(codec, 1);
 		msleep(200);
 	}
 
-	if (spec->codec_variant == ALC269_TYPE_ALC269VB ||
-			(alc_get_coef0(codec) & 0x00ff) == 0x018)
-		alc269_toggle_power_output(codec, 1);
-
 	snd_hda_codec_resume_amp(codec);
 	snd_hda_codec_resume_cache(codec);
 	hda_call_check_power_status(codec, 0x01);
-- 
1.7.9.5


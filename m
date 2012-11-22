Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab2KVV45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:56:57 -0500
Received: from mail.kernel.org ([198.145.19.201]:49630 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754927Ab2KVSkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 23/83] ALSA: hda - Improve HP depop when system enter to S3
Date: Wed, 21 Nov 2012 16:41:45 -0800
Message-Id: <20121122004215.110228788@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 1387e2d12799e554df2f60e7ae7fe01384bcb96f upstream.

alc269_toggle_power_output() was only use in ALC269VB.  I rename it to
alc269vb_toggle_power_output().

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5867,7 +5867,7 @@ static int alc269_parse_auto_config(stru
 	return alc_parse_auto_config(codec, alc269_ignore, ssids);
 }
 
-static void alc269_toggle_power_output(struct hda_codec *codec, int power_up)
+static void alc269vb_toggle_power_output(struct hda_codec *codec, int power_up)
 {
 	int val = alc_read_coef_idx(codec, 0x04);
 	if (power_up)
@@ -5884,10 +5884,10 @@ static void alc269_shutup(struct hda_cod
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
@@ -5897,24 +5897,22 @@ static int alc269_resume(struct hda_code
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



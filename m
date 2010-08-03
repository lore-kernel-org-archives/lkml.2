Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab0HCKiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 06:38:10 -0400
Received: from saarni.dnainternet.net ([83.102.40.136]:58930 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab0HCKiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 06:38:04 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.36
From: Anssi Hannula <anssi.hannula@iki.fi>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Anssi Hannula <anssi.hannula@iki.fi>
Subject: [PATCH 1/2] ALSA: hda - Set Stream Type in Stream Format according to AES0
Date: Tue,  3 Aug 2010 13:28:57 +0300
Message-Id: <1280831338-4596-2-git-send-email-anssi.hannula@iki.fi>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1280831338-4596-1-git-send-email-anssi.hannula@iki.fi>
References: <1280831338-4596-1-git-send-email-anssi.hannula@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set bit 15 (Stream Type) of HDA Stream Format to 1 (Non-PCM) when IEC958
channel status bit 1 (AES0 & 0x02) is set to 1 (non-audio).

This is a prequisite for HDMI HBR passthrough.

Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
---
 sound/pci/hda/hda_codec.c |    6 +++++-
 sound/pci/hda/hda_codec.h |    3 ++-
 sound/pci/hda/hda_intel.c |    3 ++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index d9d1c91..bd8d7a6 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -3051,7 +3051,8 @@ static struct hda_rate_tbl rate_bits[] = {
 unsigned int snd_hda_calc_stream_format(unsigned int rate,
 					unsigned int channels,
 					unsigned int format,
-					unsigned int maxbps)
+					unsigned int maxbps,
+					unsigned short spdif_ctls)
 {
 	int i;
 	unsigned int val = 0;
@@ -3095,6 +3096,9 @@ unsigned int snd_hda_calc_stream_format(unsigned int rate,
 		return 0;
 	}
 
+	if (spdif_ctls & AC_DIG1_NONAUDIO)
+		val |= 0x8000;
+
 	return val;
 }
 EXPORT_SYMBOL_HDA(snd_hda_calc_stream_format);
diff --git a/sound/pci/hda/hda_codec.h b/sound/pci/hda/hda_codec.h
index 5991d14..4797416 100644
--- a/sound/pci/hda/hda_codec.h
+++ b/sound/pci/hda/hda_codec.h
@@ -928,7 +928,8 @@ void snd_hda_codec_cleanup_stream(struct hda_codec *codec, hda_nid_t nid);
 unsigned int snd_hda_calc_stream_format(unsigned int rate,
 					unsigned int channels,
 					unsigned int format,
-					unsigned int maxbps);
+					unsigned int maxbps,
+					unsigned short spdif_ctls);
 int snd_hda_is_supported_format(struct hda_codec *codec, hda_nid_t nid,
 				unsigned int format);
 
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 1df25cf..f8a2f5a 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1653,7 +1653,8 @@ static int azx_pcm_prepare(struct snd_pcm_substream *substream)
 	format_val = snd_hda_calc_stream_format(runtime->rate,
 						runtime->channels,
 						runtime->format,
-						hinfo->maxbps);
+						hinfo->maxbps,
+						apcm->codec->spdif_ctls);
 	if (!format_val) {
 		snd_printk(KERN_ERR SFX
 			   "invalid format_val, rate=%d, ch=%d, format=%d\n",
-- 
1.7.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab1DGATM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 20:19:12 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19107 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab1DGATK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 20:19:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 06 Apr 2011 17:19:06 -0700
Date: Wed, 6 Apr 2011 17:19:04 -0700
From: Aaron Plattner <aplattner@nvidia.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Anssi Hannula <anssi.hannula@iki.fi>,
        Wu Fengguang <fengguang.wu@intel.com>
CC: Stephen Warren <swarren@nvidia.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] ALSA: hda - HDMI: Fix MCP7x audio infoframe checksums
Message-ID: <20110407001904.GA4922@soprano.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MCP7x hardware computes the audio infoframe channel count
automatically, but requires the audio driver to set the audio
infoframe checksum manually via the Nv_VERB_SET_Info_Frame_Checksum
control verb.

When audio starts playing, nvhdmi_8ch_7x_pcm_prepare sets the checksum
to (0x71 - chan - chanmask).  For example, for 2ch audio, chan == 1
and chanmask == 0 so the checksum is set to 0x70.  When audio playback
finishes and the device is closed, nvhdmi_8ch_7x_pcm_close resets the
channel formats, causing the channel count to revert to 8ch.  Since
the checksum is not reset, the hardware starts generating audio
infoframes with invalid checksums.  This causes some displays to blank
the video.

Fix this by updating the checksum and channel mask when the device is
closed and also when it is first initialized.  In addition, make sure
that the channel mask is appropriate for an 8ch infoframe by setting
it to 0x13 (FL FR LFE FC RL RR RLC RRC).

Signed-off-by: Aaron Plattner <aplattner@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
---
 sound/pci/hda/patch_hdmi.c |   70 +++++++++++++++++++++++++++----------------
 1 files changed, 44 insertions(+), 26 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 251773e..715615a 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1280,6 +1280,39 @@ static int simple_playback_pcm_prepare(struct hda_pcm_stream *hinfo,
 					     stream_tag, format, substream);
 }
 
+static void nvhdmi_8ch_7x_set_info_frame_parameters(struct hda_codec *codec,
+						    int channels)
+{
+	unsigned int chanmask;
+	int chan = channels ? (channels - 1) : 1;
+
+	switch (channels) {
+	default:
+	case 0:
+	case 2:
+		chanmask = 0x00;
+		break;
+	case 4:
+		chanmask = 0x08;
+		break;
+	case 6:
+		chanmask = 0x0b;
+		break;
+	case 8:
+		chanmask = 0x13;
+		break;
+	}
+
+	/* Set the audio infoframe channel allocation and checksum fields.  The
+	 * channel count is computed implicitly by the hardware. */
+	snd_hda_codec_write(codec, 0x1, 0,
+			Nv_VERB_SET_Channel_Allocation, chanmask);
+
+	snd_hda_codec_write(codec, 0x1, 0,
+			Nv_VERB_SET_Info_Frame_Checksum,
+			(0x71 - chan - chanmask));
+}
+
 static int nvhdmi_8ch_7x_pcm_close(struct hda_pcm_stream *hinfo,
 				   struct hda_codec *codec,
 				   struct snd_pcm_substream *substream)
@@ -1298,6 +1331,10 @@ static int nvhdmi_8ch_7x_pcm_close(struct hda_pcm_stream *hinfo,
 				AC_VERB_SET_STREAM_FORMAT, 0);
 	}
 
+	/* The audio hardware sends a channel count of 0x7 (8ch) when all the
+	 * streams are disabled. */
+	nvhdmi_8ch_7x_set_info_frame_parameters(codec, 8);
+
 	return snd_hda_multi_out_dig_close(codec, &spec->multiout);
 }
 
@@ -1308,37 +1345,16 @@ static int nvhdmi_8ch_7x_pcm_prepare(struct hda_pcm_stream *hinfo,
 				     struct snd_pcm_substream *substream)
 {
 	int chs;
-	unsigned int dataDCC1, dataDCC2, chan, chanmask, channel_id;
+	unsigned int dataDCC1, dataDCC2, channel_id;
 	int i;
 
 	mutex_lock(&codec->spdif_mutex);
 
 	chs = substream->runtime->channels;
-	chan = chs ? (chs - 1) : 1;
 
-	switch (chs) {
-	default:
-	case 0:
-	case 2:
-		chanmask = 0x00;
-		break;
-	case 4:
-		chanmask = 0x08;
-		break;
-	case 6:
-		chanmask = 0x0b;
-		break;
-	case 8:
-		chanmask = 0x13;
-		break;
-	}
 	dataDCC1 = AC_DIG1_ENABLE | AC_DIG1_COPYRIGHT;
 	dataDCC2 = 0x2;
 
-	/* set the Audio InforFrame Channel Allocation */
-	snd_hda_codec_write(codec, 0x1, 0,
-			Nv_VERB_SET_Channel_Allocation, chanmask);
-
 	/* turn off SPDIF once; otherwise the IEC958 bits won't be updated */
 	if (codec->spdif_status_reset && (codec->spdif_ctls & AC_DIG1_ENABLE))
 		snd_hda_codec_write(codec,
@@ -1413,10 +1429,7 @@ static int nvhdmi_8ch_7x_pcm_prepare(struct hda_pcm_stream *hinfo,
 		}
 	}
 
-	/* set the Audio Info Frame Checksum */
-	snd_hda_codec_write(codec, 0x1, 0,
-			Nv_VERB_SET_Info_Frame_Checksum,
-			(0x71 - chan - chanmask));
+	nvhdmi_8ch_7x_set_info_frame_parameters(codec, chs);
 
 	mutex_unlock(&codec->spdif_mutex);
 	return 0;
@@ -1512,6 +1525,11 @@ static int patch_nvhdmi_8ch_7x(struct hda_codec *codec)
 	spec->multiout.max_channels = 8;
 	spec->pcm_playback = &nvhdmi_pcm_playback_8ch_7x;
 	codec->patch_ops = nvhdmi_patch_ops_8ch_7x;
+
+	/* Initialize the audio infoframe channel mask and checksum to something
+	 * valid */
+	nvhdmi_8ch_7x_set_info_frame_parameters(codec, 8);
+
 	return 0;
 }
 
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab1DLOwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:52:50 -0400
Received: from kroah.org ([198.145.64.141]:57560 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658Ab1DLOiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:03 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:52 2011
Message-Id: <20110412143552.325880363@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Aaron Plattner <aplattner@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>, Takashi Iwai <tiwai@suse.de>
Subject: [041/105] ALSA: hda - HDMI: Fix MCP7x audio infoframe checksums
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Aaron Plattner <aplattner@nvidia.com>

commit 1f348522844bb1f6e7b10d50b9e8aa89a2511b09 upstream.

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
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_hdmi.c |   70 ++++++++++++++++++++++++++++-----------------
 1 file changed, 44 insertions(+), 26 deletions(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1276,6 +1276,39 @@ static int simple_playback_pcm_prepare(s
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
@@ -1294,6 +1327,10 @@ static int nvhdmi_8ch_7x_pcm_close(struc
 				AC_VERB_SET_STREAM_FORMAT, 0);
 	}
 
+	/* The audio hardware sends a channel count of 0x7 (8ch) when all the
+	 * streams are disabled. */
+	nvhdmi_8ch_7x_set_info_frame_parameters(codec, 8);
+
 	return snd_hda_multi_out_dig_close(codec, &spec->multiout);
 }
 
@@ -1304,37 +1341,16 @@ static int nvhdmi_8ch_7x_pcm_prepare(str
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
@@ -1409,10 +1425,7 @@ static int nvhdmi_8ch_7x_pcm_prepare(str
 		}
 	}
 
-	/* set the Audio Info Frame Checksum */
-	snd_hda_codec_write(codec, 0x1, 0,
-			Nv_VERB_SET_Info_Frame_Checksum,
-			(0x71 - chan - chanmask));
+	nvhdmi_8ch_7x_set_info_frame_parameters(codec, chs);
 
 	mutex_unlock(&codec->spdif_mutex);
 	return 0;
@@ -1508,6 +1521,11 @@ static int patch_nvhdmi_8ch_7x(struct hd
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
 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab0HCKiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 06:38:07 -0400
Received: from sypressi.dnainternet.net ([83.102.40.135]:58425 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941Ab0HCKiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 06:38:04 -0400
X-Greylist: delayed 518 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Aug 2010 06:38:03 EDT
X-Spam-Flag: NO
X-Spam-Score: -1.36
From: Anssi Hannula <anssi.hannula@iki.fi>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Anssi Hannula <anssi.hannula@iki.fi>
Subject: [PATCH 2/2] ALSA: hda - Add support for HDMI HBR passthrough
Date: Tue,  3 Aug 2010 13:28:58 +0300
Message-Id: <1280831338-4596-3-git-send-email-anssi.hannula@iki.fi>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1280831338-4596-1-git-send-email-anssi.hannula@iki.fi>
References: <1280831338-4596-1-git-send-email-anssi.hannula@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Passing IEC 61937 encapsulated compressed audio at bitrates over 6.144
Mbps (i.e. more than a single 2-channel 16-bit 192kHz IEC 60958 link)
over HDMI requires the use of HBR Audio Stream Packets instead of Audio
Sample Packets.

Enable HBR mode when the stream has 8 channels and the Non-PCM bit is
set.

If the audio converter is not connected to any HBR-capable pins, return
-EINVAL in prepare().

Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
---
 sound/pci/hda/hda_codec.h       |    3 ++
 sound/pci/hda/patch_hdmi.c      |   40 ++++++++++++++++++++++++++++++++++++++-
 sound/pci/hda/patch_intelhdmi.c |    3 +-
 sound/pci/hda/patch_nvhdmi.c    |    3 +-
 4 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/sound/pci/hda/hda_codec.h b/sound/pci/hda/hda_codec.h
index 4797416..48b3367 100644
--- a/sound/pci/hda/hda_codec.h
+++ b/sound/pci/hda/hda_codec.h
@@ -364,6 +364,9 @@ enum {
 #define AC_DIG2_CC			(0x7f<<0)
 
 /* Pin widget control - 8bit */
+#define AC_PINCTL_EPT			(0x3<<0)
+#define AC_PINCTL_EPT_NATIVE		0
+#define AC_PINCTL_EPT_HBR		3
 #define AC_PINCTL_VREFEN		(0x7<<0)
 #define AC_PINCTL_VREF_HIZ		0	/* Hi-Z */
 #define AC_PINCTL_VREF_50		1	/* 50% */
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 2fc5396..8534792 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -698,11 +698,48 @@ static void hdmi_unsol_event(struct hda_codec *codec, unsigned int res)
  * Callbacks
  */
 
-static void hdmi_setup_stream(struct hda_codec *codec, hda_nid_t nid,
+static int hdmi_setup_stream(struct hda_codec *codec, hda_nid_t nid,
 			      u32 stream_tag, int format)
 {
+	struct hdmi_spec *spec = codec->spec;
 	int tag;
 	int fmt;
+	int pinctl;
+	int new_pinctl = 0;
+	int i;
+
+	for (i = 0; i < spec->num_pins; i++) {
+		if (spec->pin_cvt[i] != nid)
+			continue;
+		if (!(snd_hda_query_pin_caps(codec, spec->pin[i]) & AC_PINCAP_HBR))
+			continue;
+
+		pinctl = snd_hda_codec_read(codec, spec->pin[i], 0,
+					    AC_VERB_GET_PIN_WIDGET_CONTROL, 0);
+
+		new_pinctl = pinctl & ~AC_PINCTL_EPT;
+		/* Non-PCM, 8 channels */
+		if ((format & 0x8000) && (format & 0x0f) == 7)
+			new_pinctl |= AC_PINCTL_EPT_HBR;
+		else
+			new_pinctl |= AC_PINCTL_EPT_NATIVE;
+
+		snd_printdd("hdmi_setup_stream: "
+			    "NID=0x%x, %spinctl=0x%x\n",
+			    spec->pin[i],
+			    pinctl == new_pinctl ? "" : "new-",
+			    new_pinctl);
+
+		if (pinctl != new_pinctl)
+			snd_hda_codec_write(codec, spec->pin[i], 0,
+					    AC_VERB_SET_PIN_WIDGET_CONTROL,
+					    new_pinctl);
+	}
+
+	if ((format & 0x8000) && (format & 0x0f) == 7 && !new_pinctl) {
+		snd_printdd("hdmi_setup_stream: HBR is not supported\n");
+		return -EINVAL;
+	}
 
 	tag = snd_hda_codec_read(codec, nid, 0, AC_VERB_GET_CONV, 0) >> 4;
 	fmt = snd_hda_codec_read(codec, nid, 0, AC_VERB_GET_STREAM_FORMAT, 0);
@@ -722,6 +759,7 @@ static void hdmi_setup_stream(struct hda_codec *codec, hda_nid_t nid,
 	if (fmt != format)
 		snd_hda_codec_write(codec, nid, 0,
 				    AC_VERB_SET_STREAM_FORMAT, format);
+	return 0;
 }
 
 /*
diff --git a/sound/pci/hda/patch_intelhdmi.c b/sound/pci/hda/patch_intelhdmi.c
index b81d23e..5972d5e 100644
--- a/sound/pci/hda/patch_intelhdmi.c
+++ b/sound/pci/hda/patch_intelhdmi.c
@@ -66,8 +66,7 @@ static int intel_hdmi_playback_pcm_prepare(struct hda_pcm_stream *hinfo,
 
 	hdmi_setup_audio_infoframe(codec, hinfo->nid, substream);
 
-	hdmi_setup_stream(codec, hinfo->nid, stream_tag, format);
-	return 0;
+	return hdmi_setup_stream(codec, hinfo->nid, stream_tag, format);
 }
 
 static int intel_hdmi_playback_pcm_cleanup(struct hda_pcm_stream *hinfo,
diff --git a/sound/pci/hda/patch_nvhdmi.c b/sound/pci/hda/patch_nvhdmi.c
index b0652ac..a281836 100644
--- a/sound/pci/hda/patch_nvhdmi.c
+++ b/sound/pci/hda/patch_nvhdmi.c
@@ -202,8 +202,7 @@ static int nvhdmi_dig_playback_pcm_prepare_8ch_89(struct hda_pcm_stream *hinfo,
 
 	hdmi_setup_audio_infoframe(codec, hinfo->nid, substream);
 
-	hdmi_setup_stream(codec, hinfo->nid, stream_tag, format);
-	return 0;
+	return hdmi_setup_stream(codec, hinfo->nid, stream_tag, format);
 }
 
 static int nvhdmi_dig_playback_pcm_prepare_8ch(struct hda_pcm_stream *hinfo,
-- 
1.7.2


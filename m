Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab1BPAUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:20:41 -0500
Received: from kroah.org ([198.145.64.141]:39099 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757142Ab1BPAUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:20:30 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:34 2011
Message-Id: <20110216001434.229274715@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nitin Daga <ndaga@nvidia.com>, Stephen Warren <swarren@nvidia.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [091/272] ALSA: hda: Disable 4/6 channels on some NVIDIA GPUs.
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nitin Daga <ndaga@nvidia.com>

commit 393004b2ea49524ee41a562cae8db67f50f372a5 upstream.

Added hardware constraint in patch_hdmi.c to disable
channels 4/6 which are not supported by some older
NVIDIA GPUs.

Signed-off-by: Nitin Daga <ndaga@nvidia.com>
Acked-By: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_hdmi.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1165,11 +1165,53 @@ static int nvhdmi_7x_init(struct hda_cod
 	return 0;
 }
 
+static unsigned int channels_2_6_8[] = {
+	2, 6, 8
+};
+
+static unsigned int channels_2_8[] = {
+	2, 8
+};
+
+static struct snd_pcm_hw_constraint_list hw_constraints_2_6_8_channels = {
+	.count = ARRAY_SIZE(channels_2_6_8),
+	.list = channels_2_6_8,
+	.mask = 0,
+};
+
+static struct snd_pcm_hw_constraint_list hw_constraints_2_8_channels = {
+	.count = ARRAY_SIZE(channels_2_8),
+	.list = channels_2_8,
+	.mask = 0,
+};
+
 static int simple_playback_pcm_open(struct hda_pcm_stream *hinfo,
 				    struct hda_codec *codec,
 				    struct snd_pcm_substream *substream)
 {
 	struct hdmi_spec *spec = codec->spec;
+	struct snd_pcm_hw_constraint_list *hw_constraints_channels = NULL;
+
+	switch (codec->preset->id) {
+	case 0x10de0002:
+	case 0x10de0003:
+	case 0x10de0005:
+	case 0x10de0006:
+		hw_constraints_channels = &hw_constraints_2_8_channels;
+		break;
+	case 0x10de0007:
+		hw_constraints_channels = &hw_constraints_2_6_8_channels;
+		break;
+	default:
+		break;
+	}
+
+	if (hw_constraints_channels != NULL) {
+		snd_pcm_hw_constraint_list(substream->runtime, 0,
+				SNDRV_PCM_HW_PARAM_CHANNELS,
+				hw_constraints_channels);
+	}
+
 	return snd_hda_multi_out_dig_open(codec, &spec->multiout);
 }
 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab1AFBDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 20:03:46 -0500
Received: from kroah.org ([198.145.64.141]:35372 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab1AFA2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:28:47 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:22:57 2011
Message-Id: <20110106002257.196351070@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:21:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anssi Hannula <anssi.hannula@iki.fi>, Takashi Iwai <tiwai@suse.de>
Subject: [005/152] ALSA: hda - Do not wrongly restrict min_channels based on ELD
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anssi Hannula <anssi.hannula@iki.fi>

commit 4b0dbdb17f846a8887e5f7fbeea2deb0703236bd upstream.

Commit bbbe33900d1f3c added functionality to restrict PCM parameters
based on ELD info (derived from EDID data) of the audio sink.

However, it wrongly assumes that the bits 0-2 of the first byte of
CEA Short Audio Descriptors mean a supported number of channels. In
reality, they mean the maximum number of channels (as per CEA-861-D
7.5.2). This means that the channel count can only be used to restrict
max_channels, not min_channels.

Restricting min_channels causes us to deny opening the device in stereo
mode if the sink only has SADs that declare larger numbers of channels
(like Primare SP32 AV Processor does).

Fix that by not restricting min_channels based on ELD information.

Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
Reported-by: Jean-Yves Avenard <jyavenard@gmail.com>
Tested-by: Jean-Yves Avenard <jyavenard@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_eld.c    |    4 ----
 sound/pci/hda/patch_hdmi.c |    1 -
 2 files changed, 5 deletions(-)

--- a/sound/pci/hda/hda_eld.c
+++ b/sound/pci/hda/hda_eld.c
@@ -607,13 +607,10 @@ void hdmi_eld_update_pcm_info(struct hdm
 	pcm->rates = 0;
 	pcm->formats = 0;
 	pcm->maxbps = 0;
-	pcm->channels_min = -1;
 	pcm->channels_max = 0;
 	for (i = 0; i < eld->sad_count; i++) {
 		struct cea_sad *a = &eld->sad[i];
 		pcm->rates |= a->rates;
-		if (a->channels < pcm->channels_min)
-			pcm->channels_min = a->channels;
 		if (a->channels > pcm->channels_max)
 			pcm->channels_max = a->channels;
 		if (a->format == AUDIO_CODING_TYPE_LPCM) {
@@ -641,7 +638,6 @@ void hdmi_eld_update_pcm_info(struct hdm
 	/* restrict the parameters by the values the codec provides */
 	pcm->rates &= codec_pars->rates;
 	pcm->formats &= codec_pars->formats;
-	pcm->channels_min = max(pcm->channels_min, codec_pars->channels_min);
 	pcm->channels_max = min(pcm->channels_max, codec_pars->channels_max);
 	pcm->maxbps = min(pcm->maxbps, codec_pars->maxbps);
 }
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -779,7 +779,6 @@ static int hdmi_pcm_open(struct hda_pcm_
 			return -ENODEV;
 	} else {
 		/* fallback to the codec default */
-		hinfo->channels_min = codec_pars->channels_min;
 		hinfo->channels_max = codec_pars->channels_max;
 		hinfo->rates = codec_pars->rates;
 		hinfo->formats = codec_pars->formats;



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab1AFA2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:28:50 -0500
Received: from kroah.org ([198.145.64.141]:35373 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753460Ab1AFA2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:28:49 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:22:57 2011
Message-Id: <20110106002257.280100577@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:21:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anssi Hannula <anssi.hannula@iki.fi>, Takashi Iwai <tiwai@suse.de>
Subject: [006/152] ALSA: hda - Always allow basic audio irrespective of ELD info
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anssi Hannula <anssi.hannula@iki.fi>

commit 3dc86429032910bdf762adeb2969112bb303924c upstream.

Commit bbbe33900d1f3c added functionality to restrict PCM parameters
based on ELD info (derived from EDID data) of the audio sink.

However, according to CEA-861-D no SAD is needed for basic audio
(32/44.1/48kHz stereo 16-bit audio), which is instead indicated with a
basic audio flag in the CEA EDID Extension.

The flag is not present in ELD. However, as all audio capable sinks are
required to support basic audio, we can assume it to be always
available.

Fix allowed audio formats with sinks that have SADs (Short Audio
Descriptors) which do not completely overlap with the basic audio
formats (there are no reports of affected devices so far) by always
assuming that basic audio is supported.

Reported-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_eld.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/sound/pci/hda/hda_eld.c
+++ b/sound/pci/hda/hda_eld.c
@@ -604,21 +604,19 @@ void hdmi_eld_update_pcm_info(struct hdm
 {
 	int i;
 
-	pcm->rates = 0;
-	pcm->formats = 0;
-	pcm->maxbps = 0;
-	pcm->channels_max = 0;
+	/* assume basic audio support (the basic audio flag is not in ELD;
+	 * however, all audio capable sinks are required to support basic
+	 * audio) */
+	pcm->rates = SNDRV_PCM_RATE_32000 | SNDRV_PCM_RATE_44100 | SNDRV_PCM_RATE_48000;
+	pcm->formats = SNDRV_PCM_FMTBIT_S16_LE;
+	pcm->maxbps = 16;
+	pcm->channels_max = 2;
 	for (i = 0; i < eld->sad_count; i++) {
 		struct cea_sad *a = &eld->sad[i];
 		pcm->rates |= a->rates;
 		if (a->channels > pcm->channels_max)
 			pcm->channels_max = a->channels;
 		if (a->format == AUDIO_CODING_TYPE_LPCM) {
-			if (a->sample_bits & AC_SUPPCM_BITS_16) {
-				pcm->formats |= SNDRV_PCM_FMTBIT_S16_LE;
-				if (pcm->maxbps < 16)
-					pcm->maxbps = 16;
-			}
 			if (a->sample_bits & AC_SUPPCM_BITS_20) {
 				pcm->formats |= SNDRV_PCM_FMTBIT_S32_LE;
 				if (pcm->maxbps < 20)



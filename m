Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab1BPBLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:11:16 -0500
Received: from kroah.org ([198.145.64.141]:45660 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933040Ab1BPAtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:49:20 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:06 2011
Message-Id: <20110216002106.833293174@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:20:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Raymond Yau <superquad.vortex2@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [patch 077/176] ALSA : au88x0 - Limit number of channels to fix Oops via OSS emu
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Raymond Yau <superquad.vortex2@gmail.com>

commit d9ab344336f74c012f6643ed3d1ad8ca0136de3b upstream.

Fix playback/capture channels patch to change supported playback
channels of au8830 to 1,2,4 and capture channels to 1,2.
This prevent oops when oss emulation use SNDCTL_DSP_CHANNELS to
set 3 Channels

Signed-off-by: Raymond Yau <superquad.vortex2@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/au88x0/au88x0_pcm.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/sound/pci/au88x0/au88x0_pcm.c
+++ b/sound/pci/au88x0/au88x0_pcm.c
@@ -42,11 +42,7 @@ static struct snd_pcm_hardware snd_vorte
 	.rate_min = 5000,
 	.rate_max = 48000,
 	.channels_min = 1,
-#ifdef CHIP_AU8830
-	.channels_max = 4,
-#else
 	.channels_max = 2,
-#endif
 	.buffer_bytes_max = 0x10000,
 	.period_bytes_min = 0x1,
 	.period_bytes_max = 0x1000,
@@ -115,6 +111,17 @@ static struct snd_pcm_hardware snd_vorte
 	.periods_max = 64,
 };
 #endif
+#ifdef CHIP_AU8830
+static unsigned int au8830_channels[3] = {
+	1, 2, 4,
+};
+
+static struct snd_pcm_hw_constraint_list hw_constraints_au8830_channels = {
+	.count = ARRAY_SIZE(au8830_channels),
+	.list = au8830_channels,
+	.mask = 0,
+};
+#endif
 /* open callback */
 static int snd_vortex_pcm_open(struct snd_pcm_substream *substream)
 {
@@ -156,6 +163,15 @@ static int snd_vortex_pcm_open(struct sn
 		if (VORTEX_PCM_TYPE(substream->pcm) == VORTEX_PCM_ADB
 		    || VORTEX_PCM_TYPE(substream->pcm) == VORTEX_PCM_I2S)
 			runtime->hw = snd_vortex_playback_hw_adb;
+#ifdef CHIP_AU8830
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK &&
+			VORTEX_PCM_TYPE(substream->pcm) == VORTEX_PCM_ADB) {
+			runtime->hw.channels_max = 4;
+			snd_pcm_hw_constraint_list(runtime, 0,
+				SNDRV_PCM_HW_PARAM_CHANNELS,
+				&hw_constraints_au8830_channels);
+		}
+#endif
 		substream->runtime->private_data = NULL;
 	}
 #ifndef CHIP_AU8810



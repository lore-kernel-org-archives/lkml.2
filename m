Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261Ab1C3VG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:06:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:15931 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933163Ab1C3VGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447226"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: superquad.vortex2@gmail.com, tiwai@suse.de, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [44/275] ALSA : au88x0 - Limit number of channels to fix Oops via OSS emu
Message-Id: <20110330210440.07ABA3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/au88x0/au88x0_pcm.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/sound/pci/au88x0/au88x0_pcm.c
===================================================================
--- linux-2.6.35.y.orig/sound/pci/au88x0/au88x0_pcm.c	2011-03-29 22:51:51.705400156 -0700
+++ linux-2.6.35.y/sound/pci/au88x0/au88x0_pcm.c	2011-03-29 23:02:59.103323115 -0700
@@ -42,11 +42,7 @@
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
@@ -115,6 +111,17 @@
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
@@ -156,6 +163,15 @@
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

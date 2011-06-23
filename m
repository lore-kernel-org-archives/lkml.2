Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab1FWRWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:22:32 -0400
Received: from mail.windriver.com ([147.11.1.11]:63141 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723Ab1FWRW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:29 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Raymond Yau <superquad.vortex2@gmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 039/247] ALSA : au88x0 - Limit number of channels to fix Oops via OSS emu
Date: Thu, 23 Jun 2011 13:18:02 -0400
Message-Id: <1308849690-14530-40-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raymond Yau <superquad.vortex2@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d9ab344336f74c012f6643ed3d1ad8ca0136de3b upstream.

Fix playback/capture channels patch to change supported playback
channels of au8830 to 1,2,4 and capture channels to 1,2.
This prevent oops when oss emulation use SNDCTL_DSP_CHANNELS to
set 3 Channels

Signed-off-by: Raymond Yau <superquad.vortex2@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/au88x0/au88x0_pcm.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/sound/pci/au88x0/au88x0_pcm.c b/sound/pci/au88x0/au88x0_pcm.c
index b9d2f20..5439d66 100644
--- a/sound/pci/au88x0/au88x0_pcm.c
+++ b/sound/pci/au88x0/au88x0_pcm.c
@@ -42,11 +42,7 @@ static struct snd_pcm_hardware snd_vortex_playback_hw_adb = {
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
@@ -115,6 +111,17 @@ static struct snd_pcm_hardware snd_vortex_playback_hw_wt = {
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
@@ -156,6 +163,15 @@ static int snd_vortex_pcm_open(struct snd_pcm_substream *substream)
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
-- 
1.7.4.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965220Ab2EOCsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:48:06 -0400
Received: from mail.windriver.com ([147.11.1.11]:49697 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965175Ab2EOCR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:26 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 106/179] ASoC: Fix Blackfin I2S _pointer() implementation return in bounds values
Date: Mon, 14 May 2012 22:13:22 -0400
Message-ID: <1337048075-6132-107-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e999dc50404d401150a5429b6459473a691fd1a0 upstream.

The Blackfin DMA controller can report one frame beyond the end of the
buffer in the wraparound case but ALSA requires that the pointer always
be in the buffer. Do the wraparound to handle this. A similar bug is
likely to apply to the other Blackfin PCM drivers but the code is less
obvious to inspection and I don't have a user to test.

Reported-by: Kieran O'Leary <Kieran.O'Leary@wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/soc/blackfin/bf5xx-i2s-pcm.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/sound/soc/blackfin/bf5xx-i2s-pcm.c b/sound/soc/blackfin/bf5xx-i2s-pcm.c
index 1d2a1ad..9aa41b1 100644
--- a/sound/soc/blackfin/bf5xx-i2s-pcm.c
+++ b/sound/soc/blackfin/bf5xx-i2s-pcm.c
@@ -139,11 +139,20 @@ static snd_pcm_uframes_t bf5xx_pcm_pointer(struct snd_pcm_substream *substream)
 	pr_debug("%s enter\n", __func__);
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		diff = sport_curr_offset_tx(sport);
-		frames = bytes_to_frames(substream->runtime, diff);
 	} else {
 		diff = sport_curr_offset_rx(sport);
-		frames = bytes_to_frames(substream->runtime, diff);
 	}
+
+	/*
+	 * TX at least can report one frame beyond the end of the
+	 * buffer if we hit the wraparound case - clamp to within the
+	 * buffer as the ALSA APIs require.
+	 */
+	if (diff == snd_pcm_lib_buffer_bytes(substream))
+		diff = 0;
+
+	frames = bytes_to_frames(substream->runtime, diff);
+
 	return frames;
 }
 
-- 
1.7.9.6


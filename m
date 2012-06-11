Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab2FKMBC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 08:01:02 -0400
Received: from smtp-out-194.synserver.de ([212.40.185.194]:1097 "EHLO
	smtp-out-178.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753908Ab2FKMBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 08:01:00 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 20459
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Vinod Koul <vinod.koul@intel.com>
Cc: Russell King <linux@arm.linux.org.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/2] ASoC: dmaengine-pcm: Add support for querying stream position from DMA device
Date: Mon, 11 Jun 2012 14:04:13 +0200
Message-Id: <1339416253-4121-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339416253-4121-1-git-send-email-lars@metafoo.de>
References: <1339416253-4121-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the sound dmaengine pcm helper functions implement the pcm_pointer
callback by trying to count the number of elapsed periods. This is done by
advancing the stream position in the dmaengine callback by one period.
Unfortunately there is no guarantee that the callback will be called for each
elapsed period. It may be possible that under high system load it is only called
once for multiple elapsed periods. This patch addresses the issue by
implementing support for querying the current stream position directly from the
dmaengine device. Since not all dmaengine drivers support reporting the stream
position yet the old period counting mechanism is kept as a fallback.

Furthermore the new mechanism allows to report the stream position with a
sub-period granularity, given that the dmaengine driver supports this.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/soc-dmaengine-pcm.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-dmaengine-pcm.c b/sound/soc/soc-dmaengine-pcm.c
index 643147e..1c754a7 100644
--- a/sound/soc/soc-dmaengine-pcm.c
+++ b/sound/soc/soc-dmaengine-pcm.c
@@ -30,6 +30,7 @@
 
 struct dmaengine_pcm_runtime_data {
 	struct dma_chan *dma_chan;
+	dma_cookie_t cookie;
 
 	unsigned int pos;
 
@@ -146,7 +147,7 @@ static int dmaengine_pcm_prepare_and_submit(struct snd_pcm_substream *substream)
 
 	desc->callback = dmaengine_pcm_dma_complete;
 	desc->callback_param = substream;
-	dmaengine_submit(desc);
+	prtd->cookie = dmaengine_submit(desc);
 
 	return 0;
 }
@@ -202,7 +203,27 @@ EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_trigger);
 snd_pcm_uframes_t snd_dmaengine_pcm_pointer(struct snd_pcm_substream *substream)
 {
 	struct dmaengine_pcm_runtime_data *prtd = substream_to_prtd(substream);
-	return bytes_to_frames(substream->runtime, prtd->pos);
+	struct dma_tx_state state;
+	enum dma_status status;
+	unsigned int pos;
+
+	status = dmaengine_tx_status(prtd->dma_chan, prtd->cookie, &state);
+	if (status != DMA_IN_PROGRESS && status != DMA_PAUSED) {
+		pos = 0;
+	} else if (state.residue == 0) {
+		/* This should never happen with cyclic transfers, so assume
+		 * that the dmaengine driver does not support reporting residue
+		 * and fall back to counting periods. */
+		pos = prtd->pos;
+	} else {
+		pos = snd_pcm_lib_buffer_bytes(substream);
+		if (state.residue <= pos)
+			pos -= state.residue;
+		else
+			pos = 0;
+	}
+
+	return bytes_to_frames(substream->runtime, pos);
 }
 EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_pointer);
 
-- 
1.7.10


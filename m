Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab2IXH5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 03:57:17 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:42657 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755263Ab2IXH5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 03:57:13 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/2] dmaengine: Add flags parameter to dmaengine_prep_dma_cyclic()
Date: Mon, 24 Sep 2012 10:58:04 +0300
Message-Id: <1348473485-5081-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1348473485-5081-1-git-send-email-peter.ujfalusi@ti.com>
References: <20120924133923.130c4db72aa8105cb5647d7a@canb.auug.org.au>
 <1348473485-5081-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this parameter added to dmaengine_prep_dma_cyclic() the API will be in
sync with other dmaengine_prep_*() functions.
The dmaengine_prep_dma_cyclic() function primarily used by audio for cyclic
transfer required by ALSA, we use the from audio to ask dma drivers to
suppress interrupts (if DMA_PREP_INTERRUPT is cleared) when it is supported
on the platform.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Lars-Peter Clausen <lars@metafoo.de>
---
 include/linux/dmaengine.h     | 3 ++-
 sound/soc/soc-dmaengine-pcm.c | 6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 09da4e5..d3201e4 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -653,7 +653,8 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_rio_sg(
 
 static inline struct dma_async_tx_descriptor *dmaengine_prep_dma_cyclic(
 		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
-		size_t period_len, enum dma_transfer_direction dir)
+		size_t period_len, enum dma_transfer_direction dir,
+		unsigned long flags)
 {
 	return chan->device->device_prep_dma_cyclic(chan, buf_addr, buf_len,
 						period_len, dir, flags, NULL);
diff --git a/sound/soc/soc-dmaengine-pcm.c b/sound/soc/soc-dmaengine-pcm.c
index 5df529e..bbc1257 100644
--- a/sound/soc/soc-dmaengine-pcm.c
+++ b/sound/soc/soc-dmaengine-pcm.c
@@ -140,14 +140,18 @@ static int dmaengine_pcm_prepare_and_submit(struct snd_pcm_substream *substream)
 	struct dma_chan *chan = prtd->dma_chan;
 	struct dma_async_tx_descriptor *desc;
 	enum dma_transfer_direction direction;
+	unsigned long flags = DMA_CTRL_ACK;
 
 	direction = snd_pcm_substream_to_dma_direction(substream);
 
+	if (!substream->runtime->no_period_wakeup)
+		flags |= DMA_PREP_INTERRUPT;
+
 	prtd->pos = 0;
 	desc = dmaengine_prep_dma_cyclic(chan,
 		substream->runtime->dma_addr,
 		snd_pcm_lib_buffer_bytes(substream),
-		snd_pcm_lib_period_bytes(substream), direction);
+		snd_pcm_lib_period_bytes(substream), direction, flags);
 
 	if (!desc)
 		return -ENOMEM;
-- 
1.7.12


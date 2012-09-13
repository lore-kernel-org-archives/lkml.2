Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab2IMNl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:41:57 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:58922 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752719Ab2IMNhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:37:48 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 03/15] dmaengine: Add no_wakeup parameter to dmaengine_prep_dma_cyclic()
Date: Thu, 13 Sep 2012 16:37:53 +0300
Message-Id: <1347543485-339-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dmaengine_prep_dma_cyclic() function primarily used by audio for cyclic
transfer required by ALSA.
With this new parameter it is going to be possible to enable the
SNDRV_PCM_INFO_NO_PERIOD_WAKEUP mode on platforms where it is possible.
This patch only changes the public API first. Followup patch will change
the device_prep_dma_cyclic() callback parameters to pass this information
towards the dma drivers.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Lars-Peter Clausen <lars@metafoo.de>
---
 include/linux/dmaengine.h     | 3 ++-
 sound/soc/soc-dmaengine-pcm.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 9c02a45..990444b 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -653,7 +653,8 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_rio_sg(
 
 static inline struct dma_async_tx_descriptor *dmaengine_prep_dma_cyclic(
 		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
-		size_t period_len, enum dma_transfer_direction dir)
+		size_t period_len, enum dma_transfer_direction dir,
+		bool no_wakeup)
 {
 	return chan->device->device_prep_dma_cyclic(chan, buf_addr, buf_len,
 						period_len, dir, NULL);
diff --git a/sound/soc/soc-dmaengine-pcm.c b/sound/soc/soc-dmaengine-pcm.c
index 5df529e..6b70adb 100644
--- a/sound/soc/soc-dmaengine-pcm.c
+++ b/sound/soc/soc-dmaengine-pcm.c
@@ -147,7 +147,8 @@ static int dmaengine_pcm_prepare_and_submit(struct snd_pcm_substream *substream)
 	desc = dmaengine_prep_dma_cyclic(chan,
 		substream->runtime->dma_addr,
 		snd_pcm_lib_buffer_bytes(substream),
-		snd_pcm_lib_period_bytes(substream), direction);
+		snd_pcm_lib_period_bytes(substream), direction,
+		substream->runtime->no_period_wakeup);
 
 	if (!desc)
 		return -ENOMEM;
-- 
1.7.12


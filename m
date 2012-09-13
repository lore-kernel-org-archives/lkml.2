Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab2IMNiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:38:07 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:49066 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752657Ab2IMNiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:38:00 -0400
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
Subject: [PATCH v2 06/15] ASoC: omap-mcbsp: Use sDMA packet mode instead of frame mode
Date: Thu, 13 Sep 2012 16:37:56 +0300
Message-Id: <1347543485-339-7-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When McBSP is configured in threshold mode we can use sDMA packet mode in
all cases.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/omap/omap-mcbsp.c | 47 ++++++++++++++++-----------------------------
 1 file changed, 17 insertions(+), 30 deletions(-)

diff --git a/sound/soc/omap/omap-mcbsp.c b/sound/soc/omap/omap-mcbsp.c
index 2e91a86..fe3debc 100644
--- a/sound/soc/omap/omap-mcbsp.c
+++ b/sound/soc/omap/omap-mcbsp.c
@@ -81,9 +81,6 @@ static void omap_mcbsp_set_threshold(struct snd_pcm_substream *substream)
 	 */
 	if (dma_data->packet_size)
 		words = dma_data->packet_size;
-	else if (mcbsp->dma_op_mode == MCBSP_DMA_MODE_THRESHOLD)
-		words = snd_pcm_lib_period_bytes(substream) /
-						(mcbsp->wlen / 8);
 	else
 		words = 1;
 
@@ -251,6 +248,7 @@ static int omap_mcbsp_dai_hw_params(struct snd_pcm_substream *substream,
 		dma_data->set_threshold = omap_mcbsp_set_threshold;
 		if (mcbsp->dma_op_mode == MCBSP_DMA_MODE_THRESHOLD) {
 			int period_words, max_thrsh;
+			int divider = 0;
 
 			period_words = params_period_bytes(params) / (wlen / 8);
 			if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
@@ -258,34 +256,23 @@ static int omap_mcbsp_dai_hw_params(struct snd_pcm_substream *substream,
 			else
 				max_thrsh = mcbsp->max_rx_thres;
 			/*
-			 * If the period contains less or equal number of words,
-			 * we are using the original threshold mode setup:
-			 * McBSP threshold = sDMA frame size = period_size
-			 * Otherwise we switch to sDMA packet mode:
-			 * McBSP threshold = sDMA packet size
-			 * sDMA frame size = period size
+			 * Use sDMA packet mode if McBSP is in threshold mode:
+			 * If period words less than the FIFO size the packet
+			 * size is set to the number of period words, otherwise
+			 * Look for the biggest threshold value which divides
+			 * the period size evenly.
 			 */
-			if (period_words > max_thrsh) {
-				int divider = 0;
-
-				/*
-				 * Look for the biggest threshold value, which
-				 * divides the period size evenly.
-				 */
-				divider = period_words / max_thrsh;
-				if (period_words % max_thrsh)
-					divider++;
-				while (period_words % divider &&
-					divider < period_words)
-					divider++;
-				if (divider == period_words)
-					return -EINVAL;
-
-				pkt_size = period_words / divider;
-				sync_mode = OMAP_DMA_SYNC_PACKET;
-			} else {
-				sync_mode = OMAP_DMA_SYNC_FRAME;
-			}
+			divider = period_words / max_thrsh;
+			if (period_words % max_thrsh)
+				divider++;
+			while (period_words % divider &&
+				divider < period_words)
+				divider++;
+			if (divider == period_words)
+				return -EINVAL;
+
+			pkt_size = period_words / divider;
+			sync_mode = OMAP_DMA_SYNC_PACKET;
 		} else if (channels > 1) {
 			/* Use packet mode for non mono streams */
 			pkt_size = channels;
-- 
1.7.12


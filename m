Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587Ab2INMGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:06:11 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:34167 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759507Ab2INMGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:06:05 -0400
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
Subject: [PATCH v3 07/15] ASoC: omap-pcm: Select sDMA synchronization based on packet_size
Date: Fri, 14 Sep 2012 15:05:50 +0300
Message-Id: <1347624358-25582-8-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347624358-25582-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347624358-25582-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we only have element or packet synchronization we can use the
dma_data->packet_size to select the desired mode:
if packet_size is 0 we use ELEMENT mode
if packet_size is not 0 we use PACKET mode for sDMA synchronization.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/omap/omap-pcm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/soc/omap/omap-pcm.c b/sound/soc/omap/omap-pcm.c
index f0feb06..02eeb2e 100644
--- a/sound/soc/omap/omap-pcm.c
+++ b/sound/soc/omap/omap-pcm.c
@@ -165,7 +165,12 @@ static int omap_pcm_prepare(struct snd_pcm_substream *substream)
 	memset(&dma_params, 0, sizeof(dma_params));
 	dma_params.data_type			= dma_data->data_type;
 	dma_params.trigger			= dma_data->dma_req;
-	dma_params.sync_mode			= dma_data->sync_mode;
+
+	if (dma_data->packet_size)
+		dma_params.sync_mode = OMAP_DMA_SYNC_PACKET;
+	else
+		dma_params.sync_mode = OMAP_DMA_SYNC_ELEMENT;
+
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		dma_params.src_amode		= OMAP_DMA_AMODE_POST_INC;
 		dma_params.dst_amode		= OMAP_DMA_AMODE_CONSTANT;
-- 
1.7.12


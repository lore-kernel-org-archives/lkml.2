Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab2ILLsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 07:48:03 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:50671 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756478Ab2ILLrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 07:47:10 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>
Subject: [PATCH 09/11] ASoC: omap-pcm, omap-hdmi: Change the use of omap_pcm_dma_data->data_type
Date: Wed, 12 Sep 2012 14:47:05 +0300
Message-Id: <1347450427-27627-10-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347450427-27627-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347450427-27627-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of the OMAP DMA data type definition the data_type will be used to
specify the number of bits the DMA word should be configured or 0 in case
when based on the stream's format the omap-pcm can decide the needed DMA
word size.
This feature is needed for the omap-hdmi where the sDMA need to be
configured for 32bit word type regardless of the audio format used.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/omap/omap-hdmi.c | 3 +--
 sound/soc/omap/omap-pcm.c  | 3 ++-
 sound/soc/omap/omap-pcm.h  | 3 ++-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/sound/soc/omap/omap-hdmi.c b/sound/soc/omap/omap-hdmi.c
index b194646..0951767 100644
--- a/sound/soc/omap/omap-hdmi.c
+++ b/sound/soc/omap/omap-hdmi.c
@@ -34,7 +34,6 @@
 #include <sound/asoundef.h>
 #include <video/omapdss.h>
 
-#include <plat/dma.h>
 #include "omap-pcm.h"
 #include "omap-hdmi.h"
 
@@ -100,7 +99,7 @@ static int omap_hdmi_dai_hw_params(struct snd_pcm_substream *substream,
 		return -EINVAL;
 	}
 
-	priv->dma_params.data_type = OMAP_DMA_DATA_TYPE_S32;
+	priv->dma_params.data_type = 32;
 
 	snd_soc_dai_set_dma_data(dai, substream,
 				 &priv->dma_params);
diff --git a/sound/soc/omap/omap-pcm.c b/sound/soc/omap/omap-pcm.c
index 4c13a5f..74da4b7 100644
--- a/sound/soc/omap/omap-pcm.c
+++ b/sound/soc/omap/omap-pcm.c
@@ -183,7 +183,8 @@ static int omap_pcm_prepare(struct snd_pcm_substream *substream)
 	memset(&dma_params, 0, sizeof(dma_params));
 
 	if (dma_data->data_type)
-		dma_params.data_type = dma_data->data_type;
+		dma_params.data_type = omap_pcm_get_dma_type(
+				dma_data->data_type);
 	else
 		dma_params.data_type = omap_pcm_get_dma_type(
 				snd_pcm_format_physical_width(runtime->format));
diff --git a/sound/soc/omap/omap-pcm.h b/sound/soc/omap/omap-pcm.h
index 1bf47e4..cabe74c 100644
--- a/sound/soc/omap/omap-pcm.h
+++ b/sound/soc/omap/omap-pcm.h
@@ -32,7 +32,8 @@ struct omap_pcm_dma_data {
 	int		dma_req;	/* DMA request line */
 	unsigned long	port_addr;	/* transmit/receive register */
 	void (*set_threshold)(struct snd_pcm_substream *substream);
-	int		data_type;	/* data type 8,16,32 */
+	int		data_type;	/* 8, 16, 32 (bits) or 0 to let omap-pcm
+					 * to decide the sDMA data type */
 	int		packet_size;	/* packet size only in PACKET mode */
 };
 
-- 
1.7.12


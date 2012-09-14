Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620Ab2INMJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:09:17 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:38695 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759552Ab2INMGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:06:06 -0400
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
Subject: [PATCH v3 08/15] ASoC: OMAP: Remove sync_mode from omap_pcm_dma_data struct
Date: Fri, 14 Sep 2012 15:05:51 +0300
Message-Id: <1347624358-25582-9-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347624358-25582-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347624358-25582-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The omap-pcm platform driver no longer needs this parameter to select
between ELEMENT and PACKET mode. The selection is based on the configured
packet_size.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/omap/omap-dmic.c  | 1 -
 sound/soc/omap/omap-hdmi.c  | 1 -
 sound/soc/omap/omap-mcbsp.c | 5 +----
 sound/soc/omap/omap-mcpdm.c | 2 --
 sound/soc/omap/omap-pcm.h   | 1 -
 5 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/sound/soc/omap/omap-dmic.c b/sound/soc/omap/omap-dmic.c
index 75f5dca..60b7b8c 100644
--- a/sound/soc/omap/omap-dmic.c
+++ b/sound/soc/omap/omap-dmic.c
@@ -64,7 +64,6 @@ struct omap_dmic {
 static struct omap_pcm_dma_data omap_dmic_dai_dma_params = {
 	.name		= "DMIC capture",
 	.data_type	= OMAP_DMA_DATA_TYPE_S32,
-	.sync_mode	= OMAP_DMA_SYNC_PACKET,
 };
 
 static inline void omap_dmic_write(struct omap_dmic *dmic, u16 reg, u32 val)
diff --git a/sound/soc/omap/omap-hdmi.c b/sound/soc/omap/omap-hdmi.c
index a08245d..b194646 100644
--- a/sound/soc/omap/omap-hdmi.c
+++ b/sound/soc/omap/omap-hdmi.c
@@ -290,7 +290,6 @@ static __devinit int omap_hdmi_probe(struct platform_device *pdev)
 
 	hdmi_data->dma_params.dma_req =  hdmi_rsrc->start;
 	hdmi_data->dma_params.name = "HDMI playback";
-	hdmi_data->dma_params.sync_mode = OMAP_DMA_SYNC_PACKET;
 
 	/*
 	 * TODO: We assume that there is only one DSS HDMI device. Future
diff --git a/sound/soc/omap/omap-mcbsp.c b/sound/soc/omap/omap-mcbsp.c
index fe3debc..5b3bacc 100644
--- a/sound/soc/omap/omap-mcbsp.c
+++ b/sound/soc/omap/omap-mcbsp.c
@@ -225,7 +225,7 @@ static int omap_mcbsp_dai_hw_params(struct snd_pcm_substream *substream,
 	struct omap_mcbsp *mcbsp = snd_soc_dai_get_drvdata(cpu_dai);
 	struct omap_mcbsp_reg_cfg *regs = &mcbsp->cfg_regs;
 	struct omap_pcm_dma_data *dma_data;
-	int wlen, channels, wpf, sync_mode = OMAP_DMA_SYNC_ELEMENT;
+	int wlen, channels, wpf;
 	int pkt_size = 0;
 	unsigned int format, div, framesize, master;
 
@@ -272,15 +272,12 @@ static int omap_mcbsp_dai_hw_params(struct snd_pcm_substream *substream,
 				return -EINVAL;
 
 			pkt_size = period_words / divider;
-			sync_mode = OMAP_DMA_SYNC_PACKET;
 		} else if (channels > 1) {
 			/* Use packet mode for non mono streams */
 			pkt_size = channels;
-			sync_mode = OMAP_DMA_SYNC_PACKET;
 		}
 	}
 
-	dma_data->sync_mode = sync_mode;
 	dma_data->packet_size = pkt_size;
 
 	snd_soc_dai_set_dma_data(cpu_dai, substream, dma_data);
diff --git a/sound/soc/omap/omap-mcpdm.c b/sound/soc/omap/omap-mcpdm.c
index f7babb3..baf92da 100644
--- a/sound/soc/omap/omap-mcpdm.c
+++ b/sound/soc/omap/omap-mcpdm.c
@@ -73,14 +73,12 @@ static struct omap_pcm_dma_data omap_mcpdm_dai_dma_params[] = {
 		.name = "Audio playback",
 		.dma_req = OMAP44XX_DMA_MCPDM_DL,
 		.data_type = OMAP_DMA_DATA_TYPE_S32,
-		.sync_mode = OMAP_DMA_SYNC_PACKET,
 		.port_addr = OMAP44XX_MCPDM_L3_BASE + MCPDM_REG_DN_DATA,
 	},
 	{
 		.name = "Audio capture",
 		.dma_req = OMAP44XX_DMA_MCPDM_UP,
 		.data_type = OMAP_DMA_DATA_TYPE_S32,
-		.sync_mode = OMAP_DMA_SYNC_PACKET,
 		.port_addr = OMAP44XX_MCPDM_L3_BASE + MCPDM_REG_UP_DATA,
 	},
 };
diff --git a/sound/soc/omap/omap-pcm.h b/sound/soc/omap/omap-pcm.h
index b92248c..1bf47e4 100644
--- a/sound/soc/omap/omap-pcm.h
+++ b/sound/soc/omap/omap-pcm.h
@@ -33,7 +33,6 @@ struct omap_pcm_dma_data {
 	unsigned long	port_addr;	/* transmit/receive register */
 	void (*set_threshold)(struct snd_pcm_substream *substream);
 	int		data_type;	/* data type 8,16,32 */
-	int		sync_mode;	/* DMA sync mode */
 	int		packet_size;	/* packet size only in PACKET mode */
 };
 
-- 
1.7.12


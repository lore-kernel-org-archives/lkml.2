Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab1JNFsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 01:48:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:62630 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932566Ab1JNFr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 01:47:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,344,1315206000"; 
   d="scan'208";a="62487056"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, jaswinder.singh@linaro.org,
        21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Vinod Koul <vinod.koul@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 08/10] sound-soc: move to dma_transfer_direction
Date: Fri, 14 Oct 2011 11:08:23 +0530
Message-Id: <1318570705-17595-9-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@linux.intel.com>

Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 sound/atmel/abdac.c             |    2 +-
 sound/atmel/ac97c.c             |   10 +++++-----
 sound/soc/ep93xx/ep93xx-pcm.c   |    4 ++--
 sound/soc/imx/imx-pcm-dma-mx2.c |    6 +++---
 sound/soc/samsung/dma.c         |    4 ++--
 sound/soc/sh/siu_pcm.c          |    4 ++--
 sound/soc/txx9/txx9aclc.c       |    2 +-
 7 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/sound/atmel/abdac.c b/sound/atmel/abdac.c
index 6fd9391..4c2d9ae 100644
--- a/sound/atmel/abdac.c
+++ b/sound/atmel/abdac.c
@@ -133,7 +133,7 @@ static int atmel_abdac_prepare_dma(struct atmel_abdac *dac,
 	period_len = frames_to_bytes(runtime, runtime->period_size);
 
 	cdesc = dw_dma_cyclic_prep(chan, runtime->dma_addr, buffer_len,
-			period_len, DMA_TO_DEVICE);
+			period_len, MEM_TO_DEV);
 	if (IS_ERR(cdesc)) {
 		dev_dbg(&dac->pdev->dev, "could not prepare cyclic DMA\n");
 		return PTR_ERR(cdesc);
diff --git a/sound/atmel/ac97c.c b/sound/atmel/ac97c.c
index 6e5adde..d03663e 100644
--- a/sound/atmel/ac97c.c
+++ b/sound/atmel/ac97c.c
@@ -102,7 +102,7 @@ static void atmel_ac97c_dma_capture_period_done(void *arg)
 
 static int atmel_ac97c_prepare_dma(struct atmel_ac97c *chip,
 		struct snd_pcm_substream *substream,
-		enum dma_data_direction direction)
+		enum dma_transfer_direction direction)
 {
 	struct dma_chan			*chan;
 	struct dw_cyclic_desc		*cdesc;
@@ -118,7 +118,7 @@ static int atmel_ac97c_prepare_dma(struct atmel_ac97c *chip,
 		return -EINVAL;
 	}
 
-	if (direction == DMA_TO_DEVICE)
+	if (direction == MEM_TO_DEV)
 		chan = chip->dma.tx_chan;
 	else
 		chan = chip->dma.rx_chan;
@@ -133,7 +133,7 @@ static int atmel_ac97c_prepare_dma(struct atmel_ac97c *chip,
 		return PTR_ERR(cdesc);
 	}
 
-	if (direction == DMA_TO_DEVICE) {
+	if (direction == MEM_TO_DEV) {
 		cdesc->period_callback = atmel_ac97c_dma_playback_period_done;
 		set_bit(DMA_TX_READY, &chip->flags);
 	} else {
@@ -393,7 +393,7 @@ static int atmel_ac97c_playback_prepare(struct snd_pcm_substream *substream)
 	if (cpu_is_at32ap7000()) {
 		if (!test_bit(DMA_TX_READY, &chip->flags))
 			retval = atmel_ac97c_prepare_dma(chip, substream,
-					DMA_TO_DEVICE);
+					MEM_TO_DEV);
 	} else {
 		/* Initialize and start the PDC */
 		writel(runtime->dma_addr, chip->regs + ATMEL_PDC_TPR);
@@ -484,7 +484,7 @@ static int atmel_ac97c_capture_prepare(struct snd_pcm_substream *substream)
 	if (cpu_is_at32ap7000()) {
 		if (!test_bit(DMA_RX_READY, &chip->flags))
 			retval = atmel_ac97c_prepare_dma(chip, substream,
-					DMA_FROM_DEVICE);
+					DEV_TO_MEM);
 	} else {
 		/* Initialize and start the PDC */
 		writel(runtime->dma_addr, chip->regs + ATMEL_PDC_RPR);
diff --git a/sound/soc/ep93xx/ep93xx-pcm.c b/sound/soc/ep93xx/ep93xx-pcm.c
index 8dfd3ad..0f9dd1f 100644
--- a/sound/soc/ep93xx/ep93xx-pcm.c
+++ b/sound/soc/ep93xx/ep93xx-pcm.c
@@ -113,9 +113,9 @@ static int ep93xx_pcm_open(struct snd_pcm_substream *substream)
 	rtd->dma_data.name = dma_params->name;
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-		rtd->dma_data.direction = DMA_TO_DEVICE;
+		rtd->dma_data.direction = MEM_TO_DEV;
 	else
-		rtd->dma_data.direction = DMA_FROM_DEVICE;
+		rtd->dma_data.direction = DEV_TO_MEM;
 
 	rtd->dma_chan = dma_request_channel(mask, ep93xx_pcm_dma_filter,
 					    &rtd->dma_data);
diff --git a/sound/soc/imx/imx-pcm-dma-mx2.c b/sound/soc/imx/imx-pcm-dma-mx2.c
index 43fdc24..b5eeaa7 100644
--- a/sound/soc/imx/imx-pcm-dma-mx2.c
+++ b/sound/soc/imx/imx-pcm-dma-mx2.c
@@ -107,12 +107,12 @@ static int imx_ssi_dma_alloc(struct snd_pcm_substream *substream,
 	}
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
-		slave_config.direction = DMA_TO_DEVICE;
+		slave_config.direction = MEM_TO_DEV;
 		slave_config.dst_addr = dma_params->dma_addr;
 		slave_config.dst_addr_width = buswidth;
 		slave_config.dst_maxburst = dma_params->burstsize;
 	} else {
-		slave_config.direction = DMA_FROM_DEVICE;
+		slave_config.direction = DEV_TO_MEM;
 		slave_config.src_addr = dma_params->dma_addr;
 		slave_config.src_addr_width = buswidth;
 		slave_config.src_maxburst = dma_params->burstsize;
@@ -159,7 +159,7 @@ static int snd_imx_pcm_hw_params(struct snd_pcm_substream *substream,
 			iprtd->period_bytes * iprtd->periods,
 			iprtd->period_bytes,
 			substream->stream == SNDRV_PCM_STREAM_PLAYBACK ?
-			DMA_TO_DEVICE : DMA_FROM_DEVICE);
+			MEM_TO_DEV : DEV_TO_MEM);
 	if (!iprtd->desc) {
 		dev_err(&chan->dev->device, "cannot prepare slave dma\n");
 		return -EINVAL;
diff --git a/sound/soc/samsung/dma.c b/sound/soc/samsung/dma.c
index 851346f..47a4093 100644
--- a/sound/soc/samsung/dma.c
+++ b/sound/soc/samsung/dma.c
@@ -85,7 +85,7 @@ static void dma_enqueue(struct snd_pcm_substream *substream)
 	dma_info.cap = (samsung_dma_has_circular() ? DMA_CYCLIC : DMA_SLAVE);
 	dma_info.direction =
 		(substream->stream == SNDRV_PCM_STREAM_PLAYBACK
-		? DMA_TO_DEVICE : DMA_FROM_DEVICE);
+		? MEM_TO_DEV : DEV_TO_MEM);
 	dma_info.fp = audio_buffdone;
 	dma_info.fp_param = substream;
 	dma_info.period = prtd->dma_period;
@@ -170,7 +170,7 @@ static int dma_hw_params(struct snd_pcm_substream *substream,
 		dma_info.client = prtd->params->client;
 		dma_info.direction =
 			(substream->stream == SNDRV_PCM_STREAM_PLAYBACK
-			? DMA_TO_DEVICE : DMA_FROM_DEVICE);
+			? MEM_TO_DEV : DEV_TO_MEM);
 		dma_info.width = prtd->params->dma_size;
 		dma_info.fifo = prtd->params->dma_addr;
 		prtd->params->ch = prtd->params->ops->request(
diff --git a/sound/soc/sh/siu_pcm.c b/sound/soc/sh/siu_pcm.c
index f8f6816..0b9b323 100644
--- a/sound/soc/sh/siu_pcm.c
+++ b/sound/soc/sh/siu_pcm.c
@@ -131,7 +131,7 @@ static int siu_pcm_wr_set(struct siu_port *port_info,
 	sg_dma_address(&sg) = buff;
 
 	desc = siu_stream->chan->device->device_prep_slave_sg(siu_stream->chan,
-		&sg, 1, DMA_TO_DEVICE, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+		&sg, 1, MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc) {
 		dev_err(dev, "Failed to allocate a dma descriptor\n");
 		return -ENOMEM;
@@ -181,7 +181,7 @@ static int siu_pcm_rd_set(struct siu_port *port_info,
 	sg_dma_address(&sg) = buff;
 
 	desc = siu_stream->chan->device->device_prep_slave_sg(siu_stream->chan,
-		&sg, 1, DMA_FROM_DEVICE, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+		&sg, 1, DEV_TO_MEM, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc) {
 		dev_err(dev, "Failed to allocate dma descriptor\n");
 		return -ENOMEM;
diff --git a/sound/soc/txx9/txx9aclc.c b/sound/soc/txx9/txx9aclc.c
index 3de99af..c3c890a 100644
--- a/sound/soc/txx9/txx9aclc.c
+++ b/sound/soc/txx9/txx9aclc.c
@@ -134,7 +134,7 @@ txx9aclc_dma_submit(struct txx9aclc_dmadata *dmadata, dma_addr_t buf_dma_addr)
 	sg_dma_address(&sg) = buf_dma_addr;
 	desc = chan->device->device_prep_slave_sg(chan, &sg, 1,
 		dmadata->substream->stream == SNDRV_PCM_STREAM_PLAYBACK ?
-		DMA_TO_DEVICE : DMA_FROM_DEVICE,
+		MEM_TO_DEV : DEV_TO_MEM,
 		DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc) {
 		dev_err(&chan->dev->device, "cannot prepare slave dma\n");
-- 
1.7.0.4


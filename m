Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab2B1H24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 02:28:56 -0500
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:42069 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756406Ab2B1H2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 02:28:53 -0500
From: zhaoy <zhaoy@marvell.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nicolas.pitre@linaro.org, linux@arm.linux.org.uk, hzhuang1@marvell.com,
        cxie4@marvell.com, leoy@marvell.com
Cc: zhaoy <zhaoy@marvell.com>
Subject: [PATCH 10/13] dmaengine:audio:mmp audio use generic dma engine APIs
Date: Tue, 28 Feb 2012 15:27:42 +0800
Message-Id: <1330414065-2949-11-git-send-email-zhaoy@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <Y>
References: <Y>
X-OriginalArrivalTime: 28 Feb 2012 07:28:33.0798 (UTC) FILETIME=[93D0AA60:01CCF5EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	1.change mmp audio to use dma engine

Change-Id: I7be32501b87927a6d05ed34f1c73242e1c60517a
Signed-off-by: zhaoy <zhaoy@marvell.com>
---
 sound/soc/pxa/mmp-pcm.c  |  223 ++++++++++++++++++++++++----------------------
 sound/soc/pxa/mmp-pcm.h  |    4 +-
 sound/soc/pxa/mmp2-squ.c |  182 ++++++++++++++++++--------------------
 sound/soc/pxa/mmp2-squ.h |    8 ++-
 4 files changed, 210 insertions(+), 207 deletions(-)

diff --git a/sound/soc/pxa/mmp-pcm.c b/sound/soc/pxa/mmp-pcm.c
index 7469e19..0e322a2 100644
--- a/sound/soc/pxa/mmp-pcm.c
+++ b/sound/soc/pxa/mmp-pcm.c
@@ -137,7 +137,7 @@ static void mmp2_pcm_sync_sram_with_ddr(struct snd_pcm_substream *substream)
 	char *src, *dst;
 	u32 point, rest;
 	int num, i;
-	u32 base;
+
 	pr_debug("%s: copy begin, sram_blk_idx = %d rbuf_blk_idx = %d "
 		 "sync_blk = %d", __func__,
 		 prtd->sram_blk_idx,  prtd->rbuf_blk_idx,
@@ -146,13 +146,12 @@ static void mmp2_pcm_sync_sram_with_ddr(struct snd_pcm_substream *substream)
 	if (!prtd->sync_blk)
 		return;
 
-	base = mmp_get_dma_reg_base(prtd->adma_ch);
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		/*
 		 * adjust sram index if dma has run ahead
 		 * rather than memory copy speed
 		 */
-		point = TDSAR(base) - prtd->sram_phys;
+		point = mmp_tdma_chan_get_ptr(prtd->dma_chan) - prtd->sram_phys;
 		rest = mmp2_pcm_point_is_in_region(prtd->sram_size,
 				prtd->sram_blk_idx * prtd->blk_size,
 				prtd->sync_blk * prtd->blk_size,
@@ -173,7 +172,7 @@ static void mmp2_pcm_sync_sram_with_ddr(struct snd_pcm_substream *substream)
 		 * by dma polluted, will copy these periods data
 		 * as possible.
 		 */
-		point = TDSAR(base) - prtd->sram_phys;
+		point = mmp_tdma_chan_get_ptr(prtd->dma_chan) - prtd->sram_phys;
 		rest = mmp2_pcm_point_is_in_region(prtd->sram_size,
 				prtd->sram_blk_idx * prtd->blk_size,
 				prtd->sync_blk * prtd->blk_size,
@@ -193,7 +192,6 @@ static void mmp2_pcm_sync_sram_with_ddr(struct snd_pcm_substream *substream)
 
 	num = prtd->sync_blk;
 	for (i = 0; i < num; i++) {
-
 		mmp2_pcm_copy_data((int *)dst, (int *)src,
 			prtd->blk_size);
 
@@ -216,18 +214,24 @@ static void mmp2_pcm_sync_sram_with_ddr(struct snd_pcm_substream *substream)
 	return;
 }
 
-static void mmp2_pcm_adma_irq(int dma_ch, void *data)
+static bool filter(struct dma_chan *chan, void *param)
+{
+	struct mmp2_runtime_data *prtd = param;
+
+	if (!mmp_adma_is_this_type(chan))
+		return false;
+
+	if (!mmp_tdma_is_specific_chan(chan, prtd->dma_ch))
+		return false;
+
+	chan->private = &prtd->tdma_data;
+	return true;
+}
+
+static void mmp2_pcm_adma_irq(void *data)
 {
 	struct snd_pcm_substream *substream = data;
 	struct mmp2_runtime_data *prtd = substream->runtime->private_data;
-	u32 base = mmp_get_dma_reg_base(prtd->adma_ch);
-	if (!base)
-		return;
-
-	if (!(TDISR(base) & 0x1))
-		return;
-	/* clear adma irq status */
-	TDISR(base) = 0;
 
 	/* sync sram with ring buf */
 	prtd->sync_blk = min(prtd->sync_blk + 1, prtd->sram_blk_num);
@@ -247,11 +251,12 @@ static int mmp2_pcm_hw_params(struct snd_pcm_substream *substream,
 	size_t totsize = params_buffer_bytes(params);
 	size_t period = params_period_bytes(params);
 	struct mmp_tdma_desc *adma_desc;
-	dma_addr_t dma_buff_phys, next_desc_phys;
+	dma_addr_t adma_buff_phys, next_desc_phys;
 	int ret;
+	dma_cap_mask_t mask;
+
+	dma = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
 
-	dma = substream->stream == SNDRV_PCM_STREAM_PLAYBACK ?
-	    rtd->cpu_dai->playback_dma_data : rtd->cpu_dai->capture_dma_data;
 	/* return if this is a bufferless transfer e.g.
 	 * codec <--> BT codec or GSM modem -- lg FIXME */
 	if (!dma)
@@ -261,27 +266,66 @@ static int mmp2_pcm_hw_params(struct snd_pcm_substream *substream,
 	 * this may get called several times by oss
 	 * emulation with different params
 	 */
-	if (prtd->params == NULL) {
-		prtd->params = dma;
-		ret = mmp_request_dma(prtd->params->name, dma->dma_ch,
-					 mmp2_pcm_adma_irq, substream);
-		if (ret < 0)
-			return ret;
-
-		prtd->adma_ch = ret;
-	} else if (prtd->params != dma) {
-		mmp_free_dma(prtd->adma_ch);
-		prtd->params = dma;
-		ret = mmp_request_dma(prtd->params->name, dma->dma_ch,
-					 mmp2_pcm_adma_irq, substream);
-		if (ret < 0)
-			return ret;
-
-		prtd->adma_ch = ret;
+	prtd->dma_ch = dma->dma_ch;
+
+	switch (params_format(params)) {
+	case SNDRV_PCM_FORMAT_S8:
+		prtd->tdma_data.bus_size = TDCR_SSZ_8_BITS;
+		break;
+	case SNDRV_PCM_FORMAT_S16_LE:
+		prtd->tdma_data.bus_size = TDCR_SSZ_16_BITS;
+		break;
+	case SNDRV_PCM_FORMAT_S24_LE:
+		prtd->tdma_data.bus_size = TDCR_SSZ_24_BITS;
+		break;
+	case SNDRV_PCM_FORMAT_S32_LE:
+		prtd->tdma_data.bus_size = TDCR_SSZ_32_BITS;
+		break;
+	default:
+		return -EINVAL;
 	}
+	prtd->tdma_data.pack_mod = true;
+
+	/* Try to grab a DMA channel */
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_CYCLIC, mask);
+	prtd->dma_chan = dma_request_channel(mask, filter, prtd);
+	if (!prtd->dma_chan)
+		return -EINVAL;
+
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		prtd->slave_config.direction    = DMA_TO_DEVICE;
+		prtd->slave_config.dst_addr     = dma->dev_addr;
+		prtd->slave_config.dst_maxburst = TDCR_BURSTSZ_4B;
+	} else {
+		prtd->slave_config.direction	  = DMA_FROM_DEVICE;
+		prtd->slave_config.src_addr	  = dma->dev_addr;
+		prtd->slave_config.src_maxburst = TDCR_BURSTSZ_4B;
+	}
+
+	ret = dmaengine_slave_config(prtd->dma_chan, &(prtd->slave_config));
+	if (ret) {
+		printk(KERN_ERR "%s: dmaengine slave config err.\n", __func__);
+		return ret;
+	}
+
 	snd_pcm_set_runtime_buffer(substream, &substream->dma_buffer);
-	runtime->dma_bytes = totsize;
 
+	/*
+	 * init prtd value.
+	 * the driver has alloc from sram for dma transfer,
+	 * size = MMP2_ADMA_BUF_SIZE (now is equal to PAGE_SIZE).
+	 * and driver has alloc ddr buffer for mmapping to userspace,
+	 * and the size = MMP2_DDR_BUF_SIZE, now is 64KB.
+	 *
+	 * but should note the used buffer size is specified
+	 * by userspace's app, which is calculated by the
+	 * periold_size and buffer_size. The buffer size
+	 * is even less than the buffer size which allocated
+	 * from the sram.
+	 * So at this point should adjust the parameters
+	 * according to user's setting.
+	 */
 	prtd->blk_size     = period;
 	prtd->rbuf_virt    = (u32)runtime->dma_area;
 	prtd->rbuf_phys    = (u32)runtime->dma_addr;
@@ -294,31 +338,22 @@ static int mmp2_pcm_hw_params(struct snd_pcm_substream *substream,
 	prtd->sync_blk     = 0;
 
 	totsize        = prtd->sram_size;
-	dma_buff_phys  = prtd->sram_phys;
+	adma_buff_phys = prtd->sram_phys;
 	next_desc_phys = prtd->adma_desc_array_phys;
 	adma_desc      = prtd->adma_desc_array;
 
-	do {
-		next_desc_phys += sizeof(struct mmp_tdma_desc);
-
-		adma_desc->nxt_desc = next_desc_phys;
-		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
-			adma_desc->src_addr = dma_buff_phys;
-			adma_desc->dst_addr = prtd->params->dev_addr;
-		} else {
-			adma_desc->src_addr = prtd->params->dev_addr;
-			adma_desc->dst_addr = dma_buff_phys;
-		}
-		if (period > totsize)
-			period = totsize;
-		adma_desc->byte_cnt = period;
-		adma_desc++;
-		dma_buff_phys += period;
-
-	} while (totsize -= period);
-	adma_desc[-1].nxt_desc = prtd->adma_desc_array_phys;
+	prtd->desc = prtd->dma_chan->device->device_prep_dma_cyclic(
+			prtd->dma_chan, adma_buff_phys, totsize, period,
+			substream->stream == SNDRV_PCM_STREAM_PLAYBACK ?
+			DMA_TO_DEVICE : DMA_FROM_DEVICE);
+	if (!prtd->desc) {
+		dev_err(&prtd->dma_chan->dev->device,
+			"cannot prepare slave dma\n");
+		return -EINVAL;
+	}
 
-	mmp2_pcm_dump_adma_list(prtd);
+	prtd->desc->callback = mmp2_pcm_adma_irq;
+	prtd->desc->callback_param = substream;
 
 	return 0;
 }
@@ -327,10 +362,9 @@ static int mmp2_pcm_hw_free(struct snd_pcm_substream *substream)
 {
 	struct mmp2_runtime_data *prtd = substream->runtime->private_data;
 
-	if (prtd->adma_ch != -1) {
-		snd_pcm_set_runtime_buffer(substream, NULL);
-		mmp_free_dma(prtd->adma_ch);
-		prtd->adma_ch = -1;
+	if (prtd->dma_chan) {
+		dma_release_channel(prtd->dma_chan);
+		prtd->dma_chan = NULL;
 	}
 
 	return 0;
@@ -338,16 +372,6 @@ static int mmp2_pcm_hw_free(struct snd_pcm_substream *substream)
 
 static int mmp2_pcm_prepare(struct snd_pcm_substream *substream)
 {
-	struct mmp2_runtime_data *prtd = substream->runtime->private_data;
-	u32 base;
-
-	base = mmp_get_dma_reg_base(prtd->adma_ch);
-	if (!base)
-		return -EINVAL;
-
-	TDCR(base)  = (prtd->params->dcmd) & (~TDCR_CHANEN);
-	TDIMR(base) = TDIMR_COMP;
-
 	return 0;
 }
 
@@ -356,11 +380,6 @@ static int mmp2_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 	struct mmp2_runtime_data *prtd = substream->runtime->private_data;
 	unsigned long flags;
 	int ret = 0;
-	u32 base_register;
-
-	base_register = mmp_get_dma_reg_base(prtd->adma_ch);
-	if (!base_register)
-		return -EINVAL;
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
@@ -378,24 +397,21 @@ static int mmp2_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 		mmp2_pcm_sync_sram_with_ddr(substream);
 		spin_unlock_irqrestore(&prtd->lock, flags);
 
-		TDNDPR(base_register) = prtd->adma_desc_array_phys;
-		TDCR(base_register) = prtd->params->dcmd | TDCR_CHANEN;
+		dmaengine_submit(prtd->desc);
 		break;
 
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		TDCR(base_register) = prtd->params->dcmd;
-		wake_up(&dma_wq);
+		dmaengine_terminate_all(prtd->dma_chan);
 		break;
 
 	case SNDRV_PCM_TRIGGER_RESUME:
-		TDCR(base_register) = prtd->params->dcmd | TDCR_CHANEN;
+		dmaengine_submit(prtd->desc);
 		break;
 
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
-		TDNDPR(base_register) = prtd->adma_desc_array_phys;
-		TDCR(base_register) = prtd->params->dcmd | TDCR_CHANEN;
+		dmaengine_submit(prtd->desc);
 		break;
 
 	default:
@@ -460,7 +476,7 @@ static int mmp2_pcm_open(struct snd_pcm_substream *substream)
 
 	prtd->substream = substream;
 	runtime->private_data = prtd;
-	prtd->adma_ch = -1;
+	prtd->dma_ch = -1;
 
 	/*
 	 * avoid sram fragment, allocate dma buffer and
@@ -471,6 +487,11 @@ static int mmp2_pcm_open(struct snd_pcm_substream *substream)
 			MMP2_ADMA_BUF_SIZE + MMP2_ADMA_DESC_SIZE,
 			(dma_addr_t *)&prtd->sram_phys);
 
+	if (!prtd->sram_virt) {
+		printk(KERN_ERR "failed to map audio sram\n");
+		goto alloc_sram_err;
+	}
+
 	prtd->adma_desc_array = (void *)(prtd->sram_virt + MMP2_ADMA_BUF_SIZE);
 	prtd->adma_desc_array_phys = (dma_addr_t)(prtd->sram_phys
 					+ MMP2_ADMA_BUF_SIZE);
@@ -492,7 +513,7 @@ static int mmp2_pcm_suspend(struct snd_soc_dai *dai)
 	struct snd_pcm_substream *substream;
 	struct snd_pcm_runtime *runtime;
 	struct mmp2_runtime_data *prtd;
-	u32 base, ch;
+	u32 ch;
 	int stream;
 
 	for (stream = 0; stream < 2; stream++) {
@@ -504,22 +525,10 @@ static int mmp2_pcm_suspend(struct snd_soc_dai *dai)
 			continue;
 
 		prtd = runtime->private_data;
-		ch = prtd->adma_ch;
+		ch = prtd->dma_ch;
 
 		pr_debug("%s: dai name %s stream %d dma ch %d prtd %p\n",
-			__func__, dai->name, stream, prtd->adma_ch, prtd);
-
-		/* mmp2 only uses chain mode */
-		base = mmp_get_dma_reg_base(ch);
-
-		prtd->adma_saved.src_addr  = TDSAR(base);
-		prtd->adma_saved.dest_addr = TDDAR(base);
-		prtd->adma_saved.next_desc_ptr = TDNDPR(base);
-		prtd->adma_saved.ctrl = TDCR(base) & ~TDCR_CHANEN;
-		prtd->adma_saved.chan_pri = TDCP(base);
-		prtd->adma_saved.curr_desc_ptr = TDCDPR(base);
-		prtd->adma_saved.intr_mask = TDIMR(base);
-		prtd->adma_saved.intr_status = TDISR(base);
+			__func__, dai->name, stream, prtd->dma_ch, prtd);
 
 		memcpy(prtd->sram_saved, (void *)prtd->sram_virt,
 			MMP2_ADMA_BUF_SIZE + MMP2_ADMA_DESC_SIZE);
@@ -534,7 +543,7 @@ static int mmp2_pcm_resume(struct snd_soc_dai *dai)
 	struct snd_pcm_substream *substream;
 	struct snd_pcm_runtime *runtime;
 	struct mmp2_runtime_data *prtd;
-	u32 base, ch;
+	u32 ch;
 	int stream;
 
 	for (stream = 0; stream < 2; stream++) {
@@ -545,18 +554,18 @@ static int mmp2_pcm_resume(struct snd_soc_dai *dai)
 			continue;
 
 		prtd = runtime->private_data;
-		ch = prtd->adma_ch;
+		ch = prtd->dma_ch;
 
 		pr_debug("%s: dai name %s stream %d dma ch %d prtd %p\n",
-			__func__, dai->name, stream, prtd->adma_ch, prtd);
+			__func__, dai->name, stream, prtd->dma_ch, prtd);
 
-		base = mmp_get_dma_reg_base(ch);
+		dmaengine_slave_config(prtd->dma_chan, &(prtd->slave_config));
 
-		/* MMP2 only uses chain mode */
-		TDNDPR(base) = prtd->adma_saved.next_desc_ptr;
-		TDCP(base)   = prtd->adma_saved.chan_pri;
-		TDIMR(base)  = prtd->adma_saved.intr_mask;
-		TDCR(base)   = prtd->adma_saved.ctrl;
+		prtd->dma_chan->device->device_prep_dma_cyclic(
+			prtd->dma_chan, prtd->sram_phys,
+			prtd->sram_size, prtd->blk_size,
+			substream->stream == SNDRV_PCM_STREAM_PLAYBACK ?
+			DMA_TO_DEVICE : DMA_FROM_DEVICE);
 
 		memcpy((void *)prtd->sram_virt, prtd->sram_saved,
 			MMP2_ADMA_BUF_SIZE + MMP2_ADMA_DESC_SIZE);
diff --git a/sound/soc/pxa/mmp-pcm.h b/sound/soc/pxa/mmp-pcm.h
index ab03e9d..909d61a 100644
--- a/sound/soc/pxa/mmp-pcm.h
+++ b/sound/soc/pxa/mmp-pcm.h
@@ -44,7 +44,8 @@ struct mmp2_adma_registers {
 };
 
 struct mmp2_runtime_data {
-	int adma_ch;
+	int dma_ch;
+	struct mmp_tdma_data tdma_data;
 	struct mmp2_adma_params *params;
 	void *adma_desc_array;
 	dma_addr_t adma_desc_array_phys;
@@ -75,6 +76,7 @@ struct mmp2_runtime_data {
 
 	struct mmp2_adma_registers adma_saved;
 	char sram_saved[MMP2_ADMA_TOTAL_SIZE];
+	struct dma_slave_config slave_config;
 };
 
 extern struct snd_soc_platform_driver mmp2_soc_platform;
diff --git a/sound/soc/pxa/mmp2-squ.c b/sound/soc/pxa/mmp2-squ.c
index 6d3cc10..4b9bb3b 100644
--- a/sound/soc/pxa/mmp2-squ.c
+++ b/sound/soc/pxa/mmp2-squ.c
@@ -27,6 +27,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/dma-mapping.h>
+#include <linux/dmaengine.h>
 
 #include <sound/core.h>
 #include <sound/pcm.h>
@@ -131,21 +132,25 @@ static int mmp2_sram_mmap_noncached(struct vm_area_struct *vma,
 	return ret;
 }
 
-static void mmp2_adma_irq(int dma_ch, void *dev_id)
+static void mmp2_adma_irq(void *data)
 {
-	struct snd_pcm_substream *substream = dev_id;
-	struct mmp2_runtime_data *prtd = substream->runtime->private_data;
+	struct snd_pcm_substream *substream = (struct snd_pcm_substream *)data;
 
-	u32 base_register = mmp_get_dma_reg_base(dma_ch);
-	if (base_register) {
-		if (TDISR(base_register) & 0x1)
-			snd_pcm_period_elapsed(substream);
-		else {
-			printk(KERN_ERR "%s: SQU error on channel %d\n",
-			       prtd->params->name, dma_ch);
-		}
-		TDISR(base_register) = 0;
-	}
+	snd_pcm_period_elapsed(substream);
+}
+
+static bool filter(struct dma_chan *chan, void *param)
+{
+	struct mmp2_runtime_data *prtd = param;
+
+	if (!mmp_adma_is_this_type(chan))
+		return false;
+
+	if (!mmp_tdma_is_specific_chan(chan, prtd->dma_ch))
+		return false;
+
+	chan->private = &prtd->tdma_data;
+	return true;
 }
 
 static int mmp2_pcm_hw_params(struct snd_pcm_substream *substream,
@@ -159,6 +164,9 @@ static int mmp2_pcm_hw_params(struct snd_pcm_substream *substream,
 	size_t period = params_period_bytes(params);
 	struct mmp_tdma_desc *adma_desc;
 	dma_addr_t dma_buff_phys, next_desc_phys;
+	struct dma_slave_config slave_config;
+	dma_cap_mask_t mask;
+	enum dma_slave_buswidth buswidth;
 	int ret;
 
 	dma = substream->stream == SNDRV_PCM_STREAM_PLAYBACK ?
@@ -168,25 +176,47 @@ static int mmp2_pcm_hw_params(struct snd_pcm_substream *substream,
 	if (!dma)
 		return 0;
 
-	/* this may get called several times by oss emulation
-	 * with different params */
-	if (prtd->params == NULL) {
-		prtd->params = dma;
-		ret = mmp_request_dma(prtd->params->name, dma->dma_ch,
-					 mmp2_adma_irq, substream);
-		if (ret < 0)
-			return ret;
-
-		prtd->adma_ch = ret;
-	} else if (prtd->params != dma) {
-		mmp_free_dma(prtd->adma_ch);
-		prtd->params = dma;
-		ret = mmp_request_dma(prtd->params->name, dma->dma_ch,
-					 mmp2_adma_irq, substream);
-		if (ret < 0)
-			return ret;
-
-		prtd->adma_ch = ret;
+	prtd->dma_ch = dma->dma_ch;
+
+	switch (params_format(params)) {
+	case SNDRV_PCM_FORMAT_S8:
+		prtd->tdma_data.bus_size = TDCR_SSZ_8_BITS;
+		break;
+	case SNDRV_PCM_FORMAT_S16_LE:
+		prtd->tdma_data.bus_size = TDCR_SSZ_16_BITS;
+		break;
+	case SNDRV_PCM_FORMAT_S24_LE:
+		prtd->tdma_data.bus_size = TDCR_SSZ_24_BITS;
+		break;
+	case SNDRV_PCM_FORMAT_S32_LE:
+		prtd->tdma_data.bus_size = TDCR_SSZ_32_BITS;
+		break;
+	default:
+		return -EINVAL;
+	}
+	prtd->tdma_data.pack_mod = true;
+
+	/* Try to grab a DMA channel */
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_CYCLIC, mask);
+	prtd->dma_chan = dma_request_channel(mask, filter, prtd);
+	if (!prtd->dma_chan)
+		return -EINVAL;
+
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		slave_config.direction    = DMA_TO_DEVICE;
+		slave_config.dst_addr     = dma->dev_addr;
+		slave_config.dst_maxburst = TDCR_BURSTSZ_4B;
+	} else {
+		slave_config.direction	  = DMA_FROM_DEVICE;
+		slave_config.src_addr	  = dma->dev_addr;
+		slave_config.src_maxburst = TDCR_BURSTSZ_4B;
+	}
+
+	ret = dmaengine_slave_config(prtd->dma_chan, &slave_config);
+	if (ret) {
+		printk(KERN_ERR "%s: dmaengine slave config err.\n", __func__);
+		return ret;
 	}
 
 	snd_pcm_set_runtime_buffer(substream, &substream->dma_buffer);
@@ -196,25 +226,19 @@ static int mmp2_pcm_hw_params(struct snd_pcm_substream *substream,
 	dma_buff_phys = runtime->dma_addr;
 
 	adma_desc = prtd->adma_desc_array;
-	do {
-		next_desc_phys += sizeof(struct mmp_tdma_desc);
-
-		adma_desc->nxt_desc = next_desc_phys;
-		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
-			adma_desc->src_addr = dma_buff_phys;
-			adma_desc->dst_addr = prtd->params->dev_addr;
-		} else {
-			adma_desc->src_addr = prtd->params->dev_addr;
-			adma_desc->dst_addr = dma_buff_phys;
-		}
-		if (period > totsize)
-			period = totsize;
-		adma_desc->byte_cnt = period;
-		adma_desc++;
-		dma_buff_phys += period;
-
-	} while (totsize -= period);
-	adma_desc[-1].nxt_desc = prtd->adma_desc_array_phys;
+
+	prtd->desc = prtd->dma_chan->device->device_prep_dma_cyclic(
+			prtd->dma_chan, dma_buff_phys, totsize, period,
+			substream->stream == SNDRV_PCM_STREAM_PLAYBACK ?
+			DMA_TO_DEVICE : DMA_FROM_DEVICE);
+	if (!prtd->desc) {
+		dev_err(&prtd->dma_chan->dev->device,
+				"cannot prepare slave dma\n");
+		return -EINVAL;
+	}
+
+	prtd->desc->callback = mmp2_adma_irq;
+	prtd->desc->callback_param = substream;
 
 	return 0;
 }
@@ -223,10 +247,9 @@ static int mmp2_pcm_hw_free(struct snd_pcm_substream *substream)
 {
 	struct mmp2_runtime_data *prtd = substream->runtime->private_data;
 
-	if (prtd->adma_ch != -1) {
-		snd_pcm_set_runtime_buffer(substream, NULL);
-		mmp_free_dma(prtd->adma_ch);
-		prtd->adma_ch = -1;
+	if (prtd->dma_chan) {
+		dma_release_channel(prtd->dma_chan);
+		prtd->dma_chan = NULL;
 	}
 
 	return 0;
@@ -234,50 +257,31 @@ static int mmp2_pcm_hw_free(struct snd_pcm_substream *substream)
 
 static int mmp2_pcm_prepare(struct snd_pcm_substream *substream)
 {
-	int ret = 0;
-	struct mmp2_runtime_data *prtd = substream->runtime->private_data;
-
-	u32 base_register = mmp_get_dma_reg_base(prtd->adma_ch);
-	if (base_register) {
-		TDCR(base_register) = (prtd->params->dcmd)
-		    & (~TDCR_CHANEN);
-		TDIMR(base_register) = TDIMR_COMP;
-	} else
-		ret = -EINVAL;
-
-	return ret;
+	return 0;
 }
 
 static int mmp2_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 {
 	struct mmp2_runtime_data *prtd = substream->runtime->private_data;
 	int ret = 0;
-	u32 base_register;
-
-	base_register = mmp_get_dma_reg_base(prtd->adma_ch);
-	if (!base_register)
-		return -EINVAL;
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
-		TDNDPR(base_register) = prtd->adma_desc_array_phys;
-		TDCR(base_register) = prtd->params->dcmd | TDCR_CHANEN;
+		dmaengine_submit(prtd->desc);
 		break;
 
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		TDCR(base_register) = prtd->params->dcmd;
-		wake_up(&dma_wq);
+		dmaengine_terminate_all(prtd->dma_chan);
 		break;
 
 	case SNDRV_PCM_TRIGGER_RESUME:
-		TDCR(base_register) = prtd->params->dcmd | TDCR_CHANEN;
+		dmaengine_submit(prtd->desc);
 		break;
 
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
-		TDNDPR(base_register) = prtd->adma_desc_array_phys;
-		TDCR(base_register) = prtd->params->dcmd | TDCR_CHANEN;
+		dmaengine_submit(prtd->desc);
 		break;
 
 	default:
@@ -294,9 +298,7 @@ static snd_pcm_uframes_t mmp2_pcm_pointer(struct snd_pcm_substream *substream)
 	dma_addr_t ptr;
 	snd_pcm_uframes_t x;
 
-	u32 base_register = mmp_get_dma_reg_base(prtd->adma_ch);
-	ptr = (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) ?
-	    TDSAR(base_register) : TDDAR(base_register);
+	ptr = mmp_tdma_chan_get_ptr(prtd->dma_chan);
 
 	x = bytes_to_frames(runtime, ptr - runtime->dma_addr);
 
@@ -344,23 +346,11 @@ static int mmp2_pcm_open(struct snd_pcm_substream *substream)
 		goto out;
 	}
 
-	/*
-	 * avoid sram fragment, allocate dma buffer and
-	 * dma desc list at the same time.
-	 */
-	prtd->adma_desc_array = sram_alloc("audio sram", PAGE_SIZE,
-				    (dma_addr_t *)&prtd->adma_desc_array_phys);
-	if (!prtd->adma_desc_array) {
-		ret = -ENOMEM;
-		goto err1;
-	}
-
 	runtime->private_data = prtd;
+	prtd->dma_ch = -1;
 
 	return 0;
 
-err1:
-	kfree(prtd);
 out:
 	return ret;
 }
@@ -370,8 +360,6 @@ static int mmp2_pcm_close(struct snd_pcm_substream *substream)
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct mmp2_runtime_data *prtd = runtime->private_data;
 
-	sram_free("audio sram", (void *)prtd->adma_desc_array, PAGE_SIZE);
-
 	kfree(prtd);
 	runtime->private_data = NULL;
 	return 0;
diff --git a/sound/soc/pxa/mmp2-squ.h b/sound/soc/pxa/mmp2-squ.h
index 4f03bb4..ff8a832 100644
--- a/sound/soc/pxa/mmp2-squ.h
+++ b/sound/soc/pxa/mmp2-squ.h
@@ -15,6 +15,8 @@
 #ifndef _MMP2_SQU_H
 #define _MMP2_SQU_H
 
+#include <mach/mmp_dma.h>
+
 #define MMP2_ADMA_BUF_SIZE		(PAGE_SIZE)
 #define MMP2_ADMA_DESC_SIZE		(1024)
 #define MMP2_DDR_BUF_SIZE		(MMP2_ADMA_BUF_SIZE << 4)
@@ -42,8 +44,8 @@ struct mmp2_adma_registers {
 };
 
 struct mmp2_runtime_data {
-	int adma_ch;
-	struct mmp2_adma_params *params;
+	int dma_ch;
+	struct mmp_tdma_data tdma_data;
 	void *adma_desc_array;
 	dma_addr_t adma_desc_array_phys;
 
@@ -69,6 +71,8 @@ struct mmp2_runtime_data {
 	u32 blk_size;
 
 	struct snd_pcm_substream *substream;
+	struct dma_chan *dma_chan;
+	struct dma_async_tx_descriptor *desc;
 
 	struct mmp2_adma_registers adma_saved;
 	char sram_saved[MMP2_ADMA_TOTAL_SIZE];
-- 
1.7.0.4


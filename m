Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab2IMNih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:38:37 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:40664 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756140Ab2IMNib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:38:31 -0400
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
Subject: [PATCH v2 15/15] ASoC: omap-pcm: Convert to use dmaengine
Date: Thu, 13 Sep 2012 16:38:05 +0300
Message-Id: <1347543485-339-16-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original author: Russell King <rmk+kernel@arm.linux.org.uk>

Switch the omap-pcm to use dmaengine.
Certain features are not supported by after dmaengine conversion:
1. No period wakeup mode
   DMA engine has no way to communicate this information through
   standard channels.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Russell King <rmk+kernel@arm.linux.org.uk>
---
 sound/soc/omap/Kconfig    |   3 +-
 sound/soc/omap/omap-pcm.c | 269 ++++++++++------------------------------------
 2 files changed, 61 insertions(+), 211 deletions(-)

diff --git a/sound/soc/omap/Kconfig b/sound/soc/omap/Kconfig
index 2c484a5..7048137 100644
--- a/sound/soc/omap/Kconfig
+++ b/sound/soc/omap/Kconfig
@@ -1,6 +1,7 @@
 config SND_OMAP_SOC
 	tristate "SoC Audio for the Texas Instruments OMAP chips"
-	depends on ARCH_OMAP
+	depends on ARCH_OMAP && DMA_OMAP
+	select SND_SOC_DMAENGINE_PCM
 
 config SND_OMAP_SOC_DMIC
 	tristate
diff --git a/sound/soc/omap/omap-pcm.c b/sound/soc/omap/omap-pcm.c
index 74da4b7..a2636f6 100644
--- a/sound/soc/omap/omap-pcm.c
+++ b/sound/soc/omap/omap-pcm.c
@@ -25,12 +25,13 @@
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/omap-dma.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
+#include <sound/dmaengine_pcm.h>
 #include <sound/soc.h>
 
-#include <plat/dma.h>
 #include "omap-pcm.h"
 
 static const struct snd_pcm_hardware omap_pcm_hardware = {
@@ -49,61 +50,34 @@ static const struct snd_pcm_hardware omap_pcm_hardware = {
 	.buffer_bytes_max	= 128 * 1024,
 };
 
-struct omap_runtime_data {
-	spinlock_t			lock;
-	struct omap_pcm_dma_data	*dma_data;
-	int				dma_ch;
-	int				period_index;
-};
-
-static void omap_pcm_dma_irq(int ch, u16 stat, void *data)
+static int omap_pcm_get_dma_buswidth(int num_bits)
 {
-	struct snd_pcm_substream *substream = data;
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct omap_runtime_data *prtd = runtime->private_data;
-	unsigned long flags;
-
-	if ((cpu_is_omap1510())) {
-		/*
-		 * OMAP1510 doesn't fully support DMA progress counter
-		 * and there is no software emulation implemented yet,
-		 * so have to maintain our own progress counters
-		 * that can be used by omap_pcm_pointer() instead.
-		 */
-		spin_lock_irqsave(&prtd->lock, flags);
-		if ((stat == OMAP_DMA_LAST_IRQ) &&
-				(prtd->period_index == runtime->periods - 1)) {
-			/* we are in sync, do nothing */
-			spin_unlock_irqrestore(&prtd->lock, flags);
-			return;
-		}
-		if (prtd->period_index >= 0) {
-			if (stat & OMAP_DMA_BLOCK_IRQ) {
-				/* end of buffer reached, loop back */
-				prtd->period_index = 0;
-			} else if (stat & OMAP_DMA_LAST_IRQ) {
-				/* update the counter for the last period */
-				prtd->period_index = runtime->periods - 1;
-			} else if (++prtd->period_index >= runtime->periods) {
-				/* end of buffer missed? loop back */
-				prtd->period_index = 0;
-			}
-		}
-		spin_unlock_irqrestore(&prtd->lock, flags);
-	}
+	int buswidth;
 
-	snd_pcm_period_elapsed(substream);
+	switch (num_bits) {
+	case 16:
+		buswidth = DMA_SLAVE_BUSWIDTH_2_BYTES;
+		break;
+	case 32:
+		buswidth = DMA_SLAVE_BUSWIDTH_4_BYTES;
+		break;
+	default:
+		buswidth = -EINVAL;
+		break;
+	}
+	return buswidth;
 }
 
+
 /* this may get called several times by oss emulation */
 static int omap_pcm_hw_params(struct snd_pcm_substream *substream,
 			      struct snd_pcm_hw_params *params)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	struct omap_runtime_data *prtd = runtime->private_data;
 	struct omap_pcm_dma_data *dma_data;
-
+	struct dma_slave_config config;
+	struct dma_chan *chan;
 	int err = 0;
 
 	dma_data = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
@@ -116,195 +90,78 @@ static int omap_pcm_hw_params(struct snd_pcm_substream *substream,
 	snd_pcm_set_runtime_buffer(substream, &substream->dma_buffer);
 	runtime->dma_bytes = params_buffer_bytes(params);
 
-	if (prtd->dma_data)
-		return 0;
-	prtd->dma_data = dma_data;
-	err = omap_request_dma(dma_data->dma_req, dma_data->name,
-			       omap_pcm_dma_irq, substream, &prtd->dma_ch);
-	if (!err) {
-		/*
-		 * Link channel with itself so DMA doesn't need any
-		 * reprogramming while looping the buffer
-		 */
-		omap_dma_link_lch(prtd->dma_ch, prtd->dma_ch);
-	}
-
-	return err;
-}
-
-static int omap_pcm_hw_free(struct snd_pcm_substream *substream)
-{
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct omap_runtime_data *prtd = runtime->private_data;
-
-	if (prtd->dma_data == NULL)
-		return 0;
+	chan = snd_dmaengine_pcm_get_chan(substream);
+	if (!chan)
+		return -EINVAL;
 
-	omap_dma_unlink_lch(prtd->dma_ch, prtd->dma_ch);
-	omap_free_dma(prtd->dma_ch);
-	prtd->dma_data = NULL;
+	/* fills in addr_width and direction */
+	err = snd_hwparams_to_dma_slave_config(substream, params, &config);
+	if (err)
+		return err;
 
-	snd_pcm_set_runtime_buffer(substream, NULL);
+	/* Override the *_dma addr_width if requested by the DAI driver */
+	if (dma_data->data_type) {
+		int buswidth = omap_pcm_get_dma_buswidth(dma_data->data_type);
 
-	return 0;
-}
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+			config.dst_addr_width = buswidth;
+		else
+			config.src_addr_width = buswidth;
+	}
 
-static int omap_pcm_get_dma_type(int num_bits)
-{
-	int data_type;
+	config.src_addr = dma_data->port_addr;
+	config.dst_addr = dma_data->port_addr;
+	config.src_maxburst = dma_data->packet_size;
+	config.dst_maxburst = dma_data->packet_size;
 
-	switch (num_bits) {
-	case 16:
-		data_type = OMAP_DMA_DATA_TYPE_S16;
-		break;
-	case 32:
-		data_type = OMAP_DMA_DATA_TYPE_S32;
-		break;
-	default:
-		data_type = -EINVAL;
-		break;
-	}
-	return data_type;
+	return dmaengine_slave_config(chan, &config);
 }
 
-static int omap_pcm_prepare(struct snd_pcm_substream *substream)
+static int omap_pcm_hw_free(struct snd_pcm_substream *substream)
 {
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct omap_runtime_data *prtd = runtime->private_data;
-	struct omap_pcm_dma_data *dma_data = prtd->dma_data;
-	struct omap_dma_channel_params dma_params;
-	int bytes;
-
-	/* return if this is a bufferless transfer e.g.
-	 * codec <--> BT codec or GSM modem -- lg FIXME */
-	if (!prtd->dma_data)
-		return 0;
-
-	memset(&dma_params, 0, sizeof(dma_params));
-
-	if (dma_data->data_type)
-		dma_params.data_type = omap_pcm_get_dma_type(
-				dma_data->data_type);
-	else
-		dma_params.data_type = omap_pcm_get_dma_type(
-				snd_pcm_format_physical_width(runtime->format));
-
-	if (dma_params.data_type < 0)
-		return dma_params.data_type;
-
-	dma_params.trigger			= dma_data->dma_req;
-
-	if (dma_data->packet_size)
-		dma_params.sync_mode = OMAP_DMA_SYNC_PACKET;
-	else
-		dma_params.sync_mode = OMAP_DMA_SYNC_ELEMENT;
-
-	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
-		dma_params.src_amode		= OMAP_DMA_AMODE_POST_INC;
-		dma_params.dst_amode		= OMAP_DMA_AMODE_CONSTANT;
-		dma_params.src_or_dst_synch	= OMAP_DMA_DST_SYNC;
-		dma_params.src_start		= runtime->dma_addr;
-		dma_params.dst_start		= dma_data->port_addr;
-		dma_params.dst_port		= OMAP_DMA_PORT_MPUI;
-		dma_params.dst_fi		= dma_data->packet_size;
-	} else {
-		dma_params.src_amode		= OMAP_DMA_AMODE_CONSTANT;
-		dma_params.dst_amode		= OMAP_DMA_AMODE_POST_INC;
-		dma_params.src_or_dst_synch	= OMAP_DMA_SRC_SYNC;
-		dma_params.src_start		= dma_data->port_addr;
-		dma_params.dst_start		= runtime->dma_addr;
-		dma_params.src_port		= OMAP_DMA_PORT_MPUI;
-		dma_params.src_fi		= dma_data->packet_size;
-	}
-	/*
-	 * Set DMA transfer frame size equal to ALSA period size and frame
-	 * count as no. of ALSA periods. Then with DMA frame interrupt enabled,
-	 * we can transfer the whole ALSA buffer with single DMA transfer but
-	 * still can get an interrupt at each period bounary
-	 */
-	bytes = snd_pcm_lib_period_bytes(substream);
-	dma_params.elem_count	= bytes >> dma_params.data_type;
-	dma_params.frame_count	= runtime->periods;
-	omap_set_dma_params(prtd->dma_ch, &dma_params);
-
-	if ((cpu_is_omap1510()))
-		omap_enable_dma_irq(prtd->dma_ch, OMAP_DMA_FRAME_IRQ |
-			      OMAP_DMA_LAST_IRQ | OMAP_DMA_BLOCK_IRQ);
-	else if (!substream->runtime->no_period_wakeup)
-		omap_enable_dma_irq(prtd->dma_ch, OMAP_DMA_FRAME_IRQ);
-	else {
-		/*
-		 * No period wakeup:
-		 * we need to disable BLOCK_IRQ, which is enabled by the omap
-		 * dma core at request dma time.
-		 */
-		omap_disable_dma_irq(prtd->dma_ch, OMAP_DMA_BLOCK_IRQ);
-	}
-
-	if (!(cpu_class_is_omap1())) {
-		omap_set_dma_src_burst_mode(prtd->dma_ch,
-						OMAP_DMA_DATA_BURST_16);
-		omap_set_dma_dest_burst_mode(prtd->dma_ch,
-						OMAP_DMA_DATA_BURST_16);
-	}
-
+	snd_pcm_set_runtime_buffer(substream, NULL);
 	return 0;
 }
 
 static int omap_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 {
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct omap_runtime_data *prtd = runtime->private_data;
-	struct omap_pcm_dma_data *dma_data = prtd->dma_data;
-	unsigned long flags;
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct omap_pcm_dma_data *dma_data;
 	int ret = 0;
 
-	spin_lock_irqsave(&prtd->lock, flags);
+	dma_data = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
+
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_RESUME:
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
-		prtd->period_index = 0;
 		/* Configure McBSP internal buffer usage */
 		if (dma_data->set_threshold)
 			dma_data->set_threshold(substream);
-
-		omap_start_dma(prtd->dma_ch);
 		break;
 
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		prtd->period_index = -1;
-		omap_stop_dma(prtd->dma_ch);
 		break;
 	default:
 		ret = -EINVAL;
 	}
-	spin_unlock_irqrestore(&prtd->lock, flags);
+
+	if (ret == 0)
+		ret = snd_dmaengine_pcm_trigger(substream, cmd);
 
 	return ret;
 }
 
 static snd_pcm_uframes_t omap_pcm_pointer(struct snd_pcm_substream *substream)
 {
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct omap_runtime_data *prtd = runtime->private_data;
-	dma_addr_t ptr;
 	snd_pcm_uframes_t offset;
 
-	if (cpu_is_omap1510()) {
-		offset = prtd->period_index * runtime->period_size;
-	} else if (substream->stream == SNDRV_PCM_STREAM_CAPTURE) {
-		ptr = omap_get_dma_dst_pos(prtd->dma_ch);
-		offset = bytes_to_frames(runtime, ptr - runtime->dma_addr);
-	} else {
-		ptr = omap_get_dma_src_pos(prtd->dma_ch);
-		offset = bytes_to_frames(runtime, ptr - runtime->dma_addr);
-	}
-
-	if (offset >= runtime->buffer_size)
-		offset = 0;
+	if (cpu_is_omap1510())
+		offset = snd_dmaengine_pcm_pointer_no_residue(substream);
+	else
+		offset = snd_dmaengine_pcm_pointer(substream);
 
 	return offset;
 }
@@ -312,7 +169,8 @@ static snd_pcm_uframes_t omap_pcm_pointer(struct snd_pcm_substream *substream)
 static int omap_pcm_open(struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct omap_runtime_data *prtd;
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct omap_pcm_dma_data *dma_data;
 	int ret;
 
 	snd_soc_set_runtime_hwparams(substream, &omap_pcm_hardware);
@@ -321,25 +179,17 @@ static int omap_pcm_open(struct snd_pcm_substream *substream)
 	ret = snd_pcm_hw_constraint_integer(runtime,
 					    SNDRV_PCM_HW_PARAM_PERIODS);
 	if (ret < 0)
-		goto out;
-
-	prtd = kzalloc(sizeof(*prtd), GFP_KERNEL);
-	if (prtd == NULL) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	spin_lock_init(&prtd->lock);
-	runtime->private_data = prtd;
+		return ret;
 
-out:
+	dma_data = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
+	ret = snd_dmaengine_pcm_open(substream, omap_dma_filter_fn,
+				     &dma_data->dma_req);
 	return ret;
 }
 
 static int omap_pcm_close(struct snd_pcm_substream *substream)
 {
-	struct snd_pcm_runtime *runtime = substream->runtime;
-
-	kfree(runtime->private_data);
+	snd_dmaengine_pcm_close(substream);
 	return 0;
 }
 
@@ -360,7 +210,6 @@ static struct snd_pcm_ops omap_pcm_ops = {
 	.ioctl		= snd_pcm_lib_ioctl,
 	.hw_params	= omap_pcm_hw_params,
 	.hw_free	= omap_pcm_hw_free,
-	.prepare	= omap_pcm_prepare,
 	.trigger	= omap_pcm_trigger,
 	.pointer	= omap_pcm_pointer,
 	.mmap		= omap_pcm_mmap,
-- 
1.7.12


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab2HPObh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:31:37 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1112 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674Ab2HPObe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:31:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 16 Aug 2012 07:31:25 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <olof@lixom.net>, <grant.likely@secretlab.ca>,
        <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>
CC: <vinod.koul@linux.intel.com>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>,
        <alsa-devel@alsa-project.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 5/5] ASoC: tegra: remove support of legacy DMA driver based access
Date: Thu, 16 Aug 2012 19:43:17 +0530
Message-ID: <1345126397-28864-6-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1345126397-28864-1-git-send-email-ldewangan@nvidia.com>
References: <1345126397-28864-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the support code which uses the legacy APB DMA driver
for accessing the I2S FIFO.
The driver will use the dmaengine based APB DMA driver for
accessing reqding/writing to I2S FIFO.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 sound/soc/tegra/Kconfig     |    2 +-
 sound/soc/tegra/tegra_pcm.c |  232 -------------------------------------------
 sound/soc/tegra/tegra_pcm.h |   14 ---
 3 files changed, 1 insertions(+), 247 deletions(-)

diff --git a/sound/soc/tegra/Kconfig b/sound/soc/tegra/Kconfig
index 02bcd30..19e5fe7 100644
--- a/sound/soc/tegra/Kconfig
+++ b/sound/soc/tegra/Kconfig
@@ -1,6 +1,6 @@
 config SND_SOC_TEGRA
 	tristate "SoC Audio for the Tegra System-on-Chip"
-	depends on ARCH_TEGRA && (TEGRA_SYSTEM_DMA || TEGRA20_APB_DMA)
+	depends on ARCH_TEGRA && TEGRA20_APB_DMA
 	select REGMAP_MMIO
 	select SND_SOC_DMAENGINE_PCM if TEGRA20_APB_DMA
 	help
diff --git a/sound/soc/tegra/tegra_pcm.c b/sound/soc/tegra/tegra_pcm.c
index 5658bce..1cab2cd 100644
--- a/sound/soc/tegra/tegra_pcm.c
+++ b/sound/soc/tegra/tegra_pcm.c
@@ -57,237 +57,6 @@ static const struct snd_pcm_hardware tegra_pcm_hardware = {
 	.fifo_size		= 4,
 };
 
-#if defined(CONFIG_TEGRA_SYSTEM_DMA)
-static void tegra_pcm_queue_dma(struct tegra_runtime_data *prtd)
-{
-	struct snd_pcm_substream *substream = prtd->substream;
-	struct snd_dma_buffer *buf = &substream->dma_buffer;
-	struct tegra_dma_req *dma_req;
-	unsigned long addr;
-
-	dma_req = &prtd->dma_req[prtd->dma_req_idx];
-	prtd->dma_req_idx = 1 - prtd->dma_req_idx;
-
-	addr = buf->addr + prtd->dma_pos;
-	prtd->dma_pos += dma_req->size;
-	if (prtd->dma_pos >= prtd->dma_pos_end)
-		prtd->dma_pos = 0;
-
-	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-		dma_req->source_addr = addr;
-	else
-		dma_req->dest_addr = addr;
-
-	tegra_dma_enqueue_req(prtd->dma_chan, dma_req);
-}
-
-static void dma_complete_callback(struct tegra_dma_req *req)
-{
-	struct tegra_runtime_data *prtd = (struct tegra_runtime_data *)req->dev;
-	struct snd_pcm_substream *substream = prtd->substream;
-	struct snd_pcm_runtime *runtime = substream->runtime;
-
-	spin_lock(&prtd->lock);
-
-	if (!prtd->running) {
-		spin_unlock(&prtd->lock);
-		return;
-	}
-
-	if (++prtd->period_index >= runtime->periods)
-		prtd->period_index = 0;
-
-	tegra_pcm_queue_dma(prtd);
-
-	spin_unlock(&prtd->lock);
-
-	snd_pcm_period_elapsed(substream);
-}
-
-static void setup_dma_tx_request(struct tegra_dma_req *req,
-					struct tegra_pcm_dma_params * dmap)
-{
-	req->complete = dma_complete_callback;
-	req->to_memory = false;
-	req->dest_addr = dmap->addr;
-	req->dest_wrap = dmap->wrap;
-	req->source_bus_width = 32;
-	req->source_wrap = 0;
-	req->dest_bus_width = dmap->width;
-	req->req_sel = dmap->req_sel;
-}
-
-static void setup_dma_rx_request(struct tegra_dma_req *req,
-					struct tegra_pcm_dma_params * dmap)
-{
-	req->complete = dma_complete_callback;
-	req->to_memory = true;
-	req->source_addr = dmap->addr;
-	req->dest_wrap = 0;
-	req->source_bus_width = dmap->width;
-	req->source_wrap = dmap->wrap;
-	req->dest_bus_width = 32;
-	req->req_sel = dmap->req_sel;
-}
-
-static int tegra_pcm_open(struct snd_pcm_substream *substream)
-{
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct tegra_runtime_data *prtd;
-	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	struct tegra_pcm_dma_params * dmap;
-	int ret = 0;
-
-	prtd = kzalloc(sizeof(struct tegra_runtime_data), GFP_KERNEL);
-	if (prtd == NULL)
-		return -ENOMEM;
-
-	runtime->private_data = prtd;
-	prtd->substream = substream;
-
-	spin_lock_init(&prtd->lock);
-
-	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
-		dmap = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
-		setup_dma_tx_request(&prtd->dma_req[0], dmap);
-		setup_dma_tx_request(&prtd->dma_req[1], dmap);
-	} else {
-		dmap = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
-		setup_dma_rx_request(&prtd->dma_req[0], dmap);
-		setup_dma_rx_request(&prtd->dma_req[1], dmap);
-	}
-
-	prtd->dma_req[0].dev = prtd;
-	prtd->dma_req[1].dev = prtd;
-
-	prtd->dma_chan = tegra_dma_allocate_channel(TEGRA_DMA_MODE_ONESHOT);
-	if (prtd->dma_chan == NULL) {
-		ret = -ENOMEM;
-		goto err;
-	}
-
-	/* Set HW params now that initialization is complete */
-	snd_soc_set_runtime_hwparams(substream, &tegra_pcm_hardware);
-
-	/* Ensure that buffer size is a multiple of period size */
-	ret = snd_pcm_hw_constraint_integer(runtime,
-						SNDRV_PCM_HW_PARAM_PERIODS);
-	if (ret < 0)
-		goto err;
-
-	return 0;
-
-err:
-	if (prtd->dma_chan) {
-		tegra_dma_free_channel(prtd->dma_chan);
-	}
-
-	kfree(prtd);
-
-	return ret;
-}
-
-static int tegra_pcm_close(struct snd_pcm_substream *substream)
-{
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct tegra_runtime_data *prtd = runtime->private_data;
-
-	tegra_dma_free_channel(prtd->dma_chan);
-
-	kfree(prtd);
-
-	return 0;
-}
-
-static int tegra_pcm_hw_params(struct snd_pcm_substream *substream,
-				struct snd_pcm_hw_params *params)
-{
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct tegra_runtime_data *prtd = runtime->private_data;
-
-	snd_pcm_set_runtime_buffer(substream, &substream->dma_buffer);
-
-	prtd->dma_req[0].size = params_period_bytes(params);
-	prtd->dma_req[1].size = prtd->dma_req[0].size;
-
-	return 0;
-}
-
-static int tegra_pcm_hw_free(struct snd_pcm_substream *substream)
-{
-	snd_pcm_set_runtime_buffer(substream, NULL);
-
-	return 0;
-}
-
-static int tegra_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
-{
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct tegra_runtime_data *prtd = runtime->private_data;
-	unsigned long flags;
-
-	switch (cmd) {
-	case SNDRV_PCM_TRIGGER_START:
-		prtd->dma_pos = 0;
-		prtd->dma_pos_end = frames_to_bytes(runtime, runtime->periods * runtime->period_size);
-		prtd->period_index = 0;
-		prtd->dma_req_idx = 0;
-		/* Fall-through */
-	case SNDRV_PCM_TRIGGER_RESUME:
-	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
-		spin_lock_irqsave(&prtd->lock, flags);
-		prtd->running = 1;
-		spin_unlock_irqrestore(&prtd->lock, flags);
-		tegra_pcm_queue_dma(prtd);
-		tegra_pcm_queue_dma(prtd);
-		break;
-	case SNDRV_PCM_TRIGGER_STOP:
-	case SNDRV_PCM_TRIGGER_SUSPEND:
-	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		spin_lock_irqsave(&prtd->lock, flags);
-		prtd->running = 0;
-		spin_unlock_irqrestore(&prtd->lock, flags);
-		tegra_dma_dequeue_req(prtd->dma_chan, &prtd->dma_req[0]);
-		tegra_dma_dequeue_req(prtd->dma_chan, &prtd->dma_req[1]);
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static snd_pcm_uframes_t tegra_pcm_pointer(struct snd_pcm_substream *substream)
-{
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct tegra_runtime_data *prtd = runtime->private_data;
-
-	return prtd->period_index * runtime->period_size;
-}
-
-
-static int tegra_pcm_mmap(struct snd_pcm_substream *substream,
-				struct vm_area_struct *vma)
-{
-	struct snd_pcm_runtime *runtime = substream->runtime;
-
-	return dma_mmap_writecombine(substream->pcm->card->dev, vma,
-					runtime->dma_area,
-					runtime->dma_addr,
-					runtime->dma_bytes);
-}
-
-static struct snd_pcm_ops tegra_pcm_ops = {
-	.open		= tegra_pcm_open,
-	.close		= tegra_pcm_close,
-	.ioctl		= snd_pcm_lib_ioctl,
-	.hw_params	= tegra_pcm_hw_params,
-	.hw_free	= tegra_pcm_hw_free,
-	.trigger	= tegra_pcm_trigger,
-	.pointer	= tegra_pcm_pointer,
-	.mmap		= tegra_pcm_mmap,
-};
-#else
 static int tegra_pcm_open(struct snd_pcm_substream *substream)
 {
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
@@ -399,7 +168,6 @@ static struct snd_pcm_ops tegra_pcm_ops = {
 	.pointer	= snd_dmaengine_pcm_pointer,
 	.mmap		= tegra_pcm_mmap,
 };
-#endif
 
 static int tegra_pcm_preallocate_dma_buffer(struct snd_pcm *pcm, int stream)
 {
diff --git a/sound/soc/tegra/tegra_pcm.h b/sound/soc/tegra/tegra_pcm.h
index a3a4503..b40279b 100644
--- a/sound/soc/tegra/tegra_pcm.h
+++ b/sound/soc/tegra/tegra_pcm.h
@@ -40,20 +40,6 @@ struct tegra_pcm_dma_params {
 	unsigned long req_sel;
 };
 
-#if defined(CONFIG_TEGRA_SYSTEM_DMA)
-struct tegra_runtime_data {
-	struct snd_pcm_substream *substream;
-	spinlock_t lock;
-	int running;
-	int dma_pos;
-	int dma_pos_end;
-	int period_index;
-	int dma_req_idx;
-	struct tegra_dma_req dma_req[2];
-	struct tegra_dma_channel *dma_chan;
-};
-#endif
-
 int tegra_pcm_platform_register(struct device *dev);
 void tegra_pcm_platform_unregister(struct device *dev);
 
-- 
1.7.1.1


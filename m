Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab2F2K0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 06:26:51 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19759 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab2F2K0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 06:26:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 29 Jun 2012 03:23:28 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <tiwai@suse.de>, <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>,
        <lars@metafoo.de>, <swarren@nvidia.com>, <perex@perex.cz>,
        <clemens@ladisch.de>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 3/3] ASoC: tegra: use core/pcm library for pcm buffer allocation
Date: Fri, 29 Jun 2012 15:53:18 +0530
Message-ID: <1340965398-20872-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1340965398-20872-1-git-send-email-ldewangan@nvidia.com>
References: <1340965398-20872-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The soc/core support the APIs for allocate and deallocate the
writecombine dma buffer for pcm substream.
Use these APIs and remove the local implementation for achieving
these functionalities.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 sound/soc/tegra/tegra_pcm.c |   92 ++-----------------------------------------
 1 files changed, 4 insertions(+), 88 deletions(-)

diff --git a/sound/soc/tegra/tegra_pcm.c b/sound/soc/tegra/tegra_pcm.c
index 127348d..6754697 100644
--- a/sound/soc/tegra/tegra_pcm.c
+++ b/sound/soc/tegra/tegra_pcm.c
@@ -263,18 +263,6 @@ static snd_pcm_uframes_t tegra_pcm_pointer(struct snd_pcm_substream *substream)
 	return prtd->period_index * runtime->period_size;
 }
 
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
 static struct snd_pcm_ops tegra_pcm_ops = {
 	.open		= tegra_pcm_open,
 	.close		= tegra_pcm_close,
@@ -283,91 +271,19 @@ static struct snd_pcm_ops tegra_pcm_ops = {
 	.hw_free	= tegra_pcm_hw_free,
 	.trigger	= tegra_pcm_trigger,
 	.pointer	= tegra_pcm_pointer,
-	.mmap		= tegra_pcm_mmap,
+	.mmap		= snd_pcm_lib_mmap_writecombine_dma_buffer,
 };
 
-static int tegra_pcm_preallocate_dma_buffer(struct snd_pcm *pcm, int stream)
-{
-	struct snd_pcm_substream *substream = pcm->streams[stream].substream;
-	struct snd_dma_buffer *buf = &substream->dma_buffer;
-	size_t size = tegra_pcm_hardware.buffer_bytes_max;
-
-	buf->area = dma_alloc_writecombine(pcm->card->dev, size,
-						&buf->addr, GFP_KERNEL);
-	if (!buf->area)
-		return -ENOMEM;
-
-	buf->dev.type = SNDRV_DMA_TYPE_DEV;
-	buf->dev.dev = pcm->card->dev;
-	buf->private_data = NULL;
-	buf->bytes = size;
-
-	return 0;
-}
-
-static void tegra_pcm_deallocate_dma_buffer(struct snd_pcm *pcm, int stream)
-{
-	struct snd_pcm_substream *substream;
-	struct snd_dma_buffer *buf;
-
-	substream = pcm->streams[stream].substream;
-	if (!substream)
-		return;
-
-	buf = &substream->dma_buffer;
-	if (!buf->area)
-		return;
-
-	dma_free_writecombine(pcm->card->dev, buf->bytes,
-				buf->area, buf->addr);
-	buf->area = NULL;
-}
-
-static u64 tegra_dma_mask = DMA_BIT_MASK(32);
-
 static int tegra_pcm_new(struct snd_soc_pcm_runtime *rtd)
 {
-	struct snd_card *card = rtd->card->snd_card;
-	struct snd_pcm *pcm = rtd->pcm;
-	int ret = 0;
-
-	if (!card->dev->dma_mask)
-		card->dev->dma_mask = &tegra_dma_mask;
-	if (!card->dev->coherent_dma_mask)
-		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
-
-	if (pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream) {
-		ret = tegra_pcm_preallocate_dma_buffer(pcm,
-						SNDRV_PCM_STREAM_PLAYBACK);
-		if (ret)
-			goto err;
-	}
-
-	if (pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream) {
-		ret = tegra_pcm_preallocate_dma_buffer(pcm,
-						SNDRV_PCM_STREAM_CAPTURE);
-		if (ret)
-			goto err_free_play;
-	}
-
-	return 0;
-
-err_free_play:
-	tegra_pcm_deallocate_dma_buffer(pcm, SNDRV_PCM_STREAM_PLAYBACK);
-err:
-	return ret;
-}
-
-static void tegra_pcm_free(struct snd_pcm *pcm)
-{
-	tegra_pcm_deallocate_dma_buffer(pcm, SNDRV_PCM_STREAM_CAPTURE);
-	tegra_pcm_deallocate_dma_buffer(pcm, SNDRV_PCM_STREAM_PLAYBACK);
+	return snd_soc_pcm_new_writecombine_dma_buffer(rtd,
+			tegra_pcm_hardware.buffer_bytes_max);
 }
 
 static struct snd_soc_platform_driver tegra_pcm_platform = {
 	.ops		= &tegra_pcm_ops,
 	.pcm_new	= tegra_pcm_new,
-	.pcm_free	= tegra_pcm_free,
+	.pcm_free	= snd_soc_pcm_free_writecombine_dma_buffer,
 };
 
 int __devinit tegra_pcm_platform_register(struct device *dev)
-- 
1.7.1.1


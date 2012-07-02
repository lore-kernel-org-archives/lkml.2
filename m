Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab2GBNDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 09:03:53 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19515 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab2GBNDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:03:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 02 Jul 2012 06:03:41 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <tiwai@suse.de>, <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>,
        <lars@metafoo.de>, <swarren@nvidia.com>, <perex@perex.cz>,
        <clemens@ladisch.de>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 2/2] ASoC: tegra: use sound pcm library for substream dma buffer
Date: Mon, 2 Jul 2012 18:29:41 +0530
Message-ID: <1341233981-32412-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1341233981-32412-1-git-send-email-ldewangan@nvidia.com>
References: <1341233981-32412-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sound pcm library support the writecombine DMA buffer
allocation/deallocation/mapping and hence using the APIs
form sound pcm library inplace of implementing the same
locally.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
Changes done to use the existing APIs for sound pcm memory management
which is now supporting writecombine.

Changes from V2:
- remove mmap initialization from tegra_pcm.
- Put back the dma mask initialisation in tegra_pcm.

 sound/soc/tegra/tegra_pcm.c |   98 +++++++++----------------------------------
 1 files changed, 20 insertions(+), 78 deletions(-)

diff --git a/sound/soc/tegra/tegra_pcm.c b/sound/soc/tegra/tegra_pcm.c
index 127348d..1ed9df0 100644
--- a/sound/soc/tegra/tegra_pcm.c
+++ b/sound/soc/tegra/tegra_pcm.c
@@ -202,8 +202,14 @@ static int tegra_pcm_hw_params(struct snd_pcm_substream *substream,
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct tegra_runtime_data *prtd = runtime->private_data;
+	int ret;
 
-	snd_pcm_set_runtime_buffer(substream, &substream->dma_buffer);
+	ret = snd_pcm_lib_malloc_pages(substream,
+				params_buffer_bytes(params));
+	if (ret < 0) {
+		pr_err("page allocation failed, err %d\n", ret);
+		return ret;
+	}
 
 	prtd->dma_req[0].size = params_period_bytes(params);
 	prtd->dma_req[1].size = prtd->dma_req[0].size;
@@ -213,9 +219,7 @@ static int tegra_pcm_hw_params(struct snd_pcm_substream *substream,
 
 static int tegra_pcm_hw_free(struct snd_pcm_substream *substream)
 {
-	snd_pcm_set_runtime_buffer(substream, NULL);
-
-	return 0;
+	return snd_pcm_lib_free_pages(substream);
 }
 
 static int tegra_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
@@ -263,18 +267,6 @@ static snd_pcm_uframes_t tegra_pcm_pointer(struct snd_pcm_substream *substream)
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
@@ -283,87 +275,37 @@ static struct snd_pcm_ops tegra_pcm_ops = {
 	.hw_free	= tegra_pcm_hw_free,
 	.trigger	= tegra_pcm_trigger,
 	.pointer	= tegra_pcm_pointer,
-	.mmap		= tegra_pcm_mmap,
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
 static u64 tegra_dma_mask = DMA_BIT_MASK(32);
-
+#define TEGRA_PCM_PREALLOC_BUFFER	(32 * 1024)
+#define TEGRA_PCM_PREALLOC_BUFFER_MAX	(32 * 1024)
 static int tegra_pcm_new(struct snd_soc_pcm_runtime *rtd)
 {
-	struct snd_card *card = rtd->card->snd_card;
 	struct snd_pcm *pcm = rtd->pcm;
-	int ret = 0;
+	struct snd_card *card = rtd->card->snd_card;
+	int ret;
 
 	if (!card->dev->dma_mask)
 		card->dev->dma_mask = &tegra_dma_mask;
 	if (!card->dev->coherent_dma_mask)
 		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
 
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
+	ret =  snd_pcm_lib_preallocate_pages_for_all(pcm,
+			SNDRV_DMA_TYPE_DEV_WC, card->dev,
+			TEGRA_PCM_PREALLOC_BUFFER,
+			TEGRA_PCM_PREALLOC_BUFFER_MAX);
+	if (ret < 0)
+		dev_err(card->dev, "dma buffer pre-alloc failed err %d\n", ret);
 	return ret;
 }
 
 static void tegra_pcm_free(struct snd_pcm *pcm)
 {
-	tegra_pcm_deallocate_dma_buffer(pcm, SNDRV_PCM_STREAM_CAPTURE);
-	tegra_pcm_deallocate_dma_buffer(pcm, SNDRV_PCM_STREAM_PLAYBACK);
+	snd_pcm_lib_preallocate_free_for_all(pcm);
 }
 
+
 static struct snd_soc_platform_driver tegra_pcm_platform = {
 	.ops		= &tegra_pcm_ops,
 	.pcm_new	= tegra_pcm_new,
-- 
1.7.1.1


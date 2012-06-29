Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab2F2Lh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 07:37:57 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19627 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab2F2Lhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 07:37:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 29 Jun 2012 04:34:33 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <tiwai@suse.de>, <perex@perex.cz>, <swarren@nvidia.com>,
        <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] ASoC: tegra: use dmaengine based dma driver
Date: Fri, 29 Jun 2012 17:04:33 +0530
Message-ID: <1340969673-7776-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1340969673-7776-1-git-send-email-ldewangan@nvidia.com>
References: <1340969673-7776-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the dmaengine based Tegra APB DMA driver for
data transfer between SPI fifo and memory in
place of legacy Tegra APB DMA.

Because generic soc-dmaengine-pcm uses the DMAs API
based on dmaengine, using the exported APIs provided
by this generic driver.

The new driver is selected if legacy driver is not
selected and new dma driver is enabled through config
file.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 sound/soc/tegra/Kconfig     |    3 +-
 sound/soc/tegra/tegra_pcm.c |  115 +++++++++++++++++++++++++++++++++++++++++++
 sound/soc/tegra/tegra_pcm.h |    2 +
 3 files changed, 119 insertions(+), 1 deletions(-)

diff --git a/sound/soc/tegra/Kconfig b/sound/soc/tegra/Kconfig
index 76dc230..02bcd30 100644
--- a/sound/soc/tegra/Kconfig
+++ b/sound/soc/tegra/Kconfig
@@ -1,7 +1,8 @@
 config SND_SOC_TEGRA
 	tristate "SoC Audio for the Tegra System-on-Chip"
-	depends on ARCH_TEGRA && TEGRA_SYSTEM_DMA
+	depends on ARCH_TEGRA && (TEGRA_SYSTEM_DMA || TEGRA20_APB_DMA)
 	select REGMAP_MMIO
+	select SND_SOC_DMAENGINE_PCM if TEGRA20_APB_DMA
 	help
 	  Say Y or M here if you want support for SoC audio on Tegra.
 
diff --git a/sound/soc/tegra/tegra_pcm.c b/sound/soc/tegra/tegra_pcm.c
index 127348d..5658bce 100644
--- a/sound/soc/tegra/tegra_pcm.c
+++ b/sound/soc/tegra/tegra_pcm.c
@@ -36,6 +36,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
+#include <sound/dmaengine_pcm.h>
 
 #include "tegra_pcm.h"
 
@@ -56,6 +57,7 @@ static const struct snd_pcm_hardware tegra_pcm_hardware = {
 	.fifo_size		= 4,
 };
 
+#if defined(CONFIG_TEGRA_SYSTEM_DMA)
 static void tegra_pcm_queue_dma(struct tegra_runtime_data *prtd)
 {
 	struct snd_pcm_substream *substream = prtd->substream;
@@ -285,6 +287,119 @@ static struct snd_pcm_ops tegra_pcm_ops = {
 	.pointer	= tegra_pcm_pointer,
 	.mmap		= tegra_pcm_mmap,
 };
+#else
+static int tegra_pcm_open(struct snd_pcm_substream *substream)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct device *dev = rtd->platform->dev;
+	int ret;
+
+	/* Set HW params now that initialization is complete */
+	snd_soc_set_runtime_hwparams(substream, &tegra_pcm_hardware);
+
+	ret = snd_dmaengine_pcm_open(substream, NULL, NULL);
+	if (ret) {
+		dev_err(dev, "dmaengine pcm open failed with err %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int tegra_pcm_close(struct snd_pcm_substream *substream)
+{
+	snd_dmaengine_pcm_close(substream);
+	return 0;
+}
+
+static int tegra_pcm_hw_params(struct snd_pcm_substream *substream,
+				struct snd_pcm_hw_params *params)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct device *dev = rtd->platform->dev;
+	struct dma_chan *chan = snd_dmaengine_pcm_get_chan(substream);
+	struct tegra_pcm_dma_params *dmap;
+	struct dma_slave_config slave_config;
+	int ret;
+
+	dmap = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
+
+	ret = snd_hwparams_to_dma_slave_config(substream, params,
+						&slave_config);
+	if (ret) {
+		dev_err(dev, "hw params config failed with err %d\n", ret);
+		return ret;
+	}
+
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		slave_config.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+		slave_config.dst_addr = dmap->addr;
+		slave_config.src_maxburst = 0;
+	} else {
+		slave_config.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+		slave_config.src_addr = dmap->addr;
+		slave_config.dst_maxburst = 0;
+	}
+	slave_config.slave_id = dmap->req_sel;
+
+	ret = dmaengine_slave_config(chan, &slave_config);
+	if (ret < 0) {
+		dev_err(dev, "dma slave config failed with err %d\n", ret);
+		return ret;
+	}
+
+	snd_pcm_set_runtime_buffer(substream, &substream->dma_buffer);
+	return 0;
+}
+
+static int tegra_pcm_hw_free(struct snd_pcm_substream *substream)
+{
+	snd_pcm_set_runtime_buffer(substream, NULL);
+	return 0;
+}
+
+static int tegra_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
+{
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+	case SNDRV_PCM_TRIGGER_RESUME:
+	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		return snd_dmaengine_pcm_trigger(substream,
+					SNDRV_PCM_TRIGGER_START);
+
+	case SNDRV_PCM_TRIGGER_STOP:
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+		return snd_dmaengine_pcm_trigger(substream,
+					SNDRV_PCM_TRIGGER_STOP);
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int tegra_pcm_mmap(struct snd_pcm_substream *substream,
+				struct vm_area_struct *vma)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+
+	return dma_mmap_writecombine(substream->pcm->card->dev, vma,
+					runtime->dma_area,
+					runtime->dma_addr,
+					runtime->dma_bytes);
+}
+
+static struct snd_pcm_ops tegra_pcm_ops = {
+	.open		= tegra_pcm_open,
+	.close		= tegra_pcm_close,
+	.ioctl		= snd_pcm_lib_ioctl,
+	.hw_params	= tegra_pcm_hw_params,
+	.hw_free	= tegra_pcm_hw_free,
+	.trigger	= tegra_pcm_trigger,
+	.pointer	= snd_dmaengine_pcm_pointer,
+	.mmap		= tegra_pcm_mmap,
+};
+#endif
 
 static int tegra_pcm_preallocate_dma_buffer(struct snd_pcm *pcm, int stream)
 {
diff --git a/sound/soc/tegra/tegra_pcm.h b/sound/soc/tegra/tegra_pcm.h
index 985d418..a3a4503 100644
--- a/sound/soc/tegra/tegra_pcm.h
+++ b/sound/soc/tegra/tegra_pcm.h
@@ -40,6 +40,7 @@ struct tegra_pcm_dma_params {
 	unsigned long req_sel;
 };
 
+#if defined(CONFIG_TEGRA_SYSTEM_DMA)
 struct tegra_runtime_data {
 	struct snd_pcm_substream *substream;
 	spinlock_t lock;
@@ -51,6 +52,7 @@ struct tegra_runtime_data {
 	struct tegra_dma_req dma_req[2];
 	struct tegra_dma_channel *dma_chan;
 };
+#endif
 
 int tegra_pcm_platform_register(struct device *dev);
 void tegra_pcm_platform_unregister(struct device *dev);
-- 
1.7.1.1


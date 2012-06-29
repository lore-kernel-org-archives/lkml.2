Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab2F2K0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 06:26:50 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19757 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab2F2K0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 06:26:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 29 Jun 2012 03:23:20 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <tiwai@suse.de>, <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>,
        <lars@metafoo.de>, <swarren@nvidia.com>, <perex@perex.cz>,
        <clemens@ladisch.de>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/3] ALSA: pcm: add apis for writecombine dma buffer allocation
Date: Fri, 29 Jun 2012 15:53:16 +0530
Message-ID: <1340965398-20872-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1340965398-20872-1-git-send-email-ldewangan@nvidia.com>
References: <1340965398-20872-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add APIs for allocation/deallocation of writecombine dma buffer
for pcm substreams.
The write combine dma buffer is not supported on few
architecture like ARM and restricting these APIs support
for ARM specific.

This can be make available to other architecture if they
start supporting this.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 include/sound/pcm.h     |   17 +++++++++++++++
 sound/core/pcm_native.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/include/sound/pcm.h b/include/sound/pcm.h
index e7afcc9..e1c8ac4 100644
--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -1054,6 +1054,23 @@ int snd_pcm_lib_mmap_iomem(struct snd_pcm_substream *substream, struct vm_area_s
 #define snd_pcm_lib_mmap_iomem	NULL
 #endif
 
+/**
+ * Allocate the write combine DMA buffer for the PCM streams.
+ * Not all architecture support the writecombine dma allocation and
+ * hence restricting this to ARM specific. Once all architecture
+ * support the writecombine dma buffer then these APIs will be available
+ * for all architecture.
+ */
+#ifdef CONFIG_ARM
+int snd_pcm_lib_alloc_writecombine_dma_buffer(struct snd_pcm *pcm,
+		size_t size, int stream);
+void snd_pcm_lib_dealloc_writecombine_dma_buffer(struct snd_pcm *pcm,
+		int stream);
+int snd_pcm_lib_mmap_writecombine_dma_buffer(
+		struct snd_pcm_substream *substream,
+		struct vm_area_struct *vma);
+#endif
+
 #define snd_pcm_lib_mmap_vmalloc NULL
 
 static inline void snd_pcm_limit_isa_dma_size(int dma, size_t *max)
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 53b5ada..fa56ad9 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3213,6 +3213,59 @@ int snd_pcm_lib_mmap_iomem(struct snd_pcm_substream *substream,
 EXPORT_SYMBOL(snd_pcm_lib_mmap_iomem);
 #endif /* SNDRV_PCM_INFO_MMAP */
 
+#ifdef CONFIG_ARM
+int snd_pcm_lib_alloc_writecombine_dma_buffer(struct snd_pcm *pcm,
+		size_t size, int stream)
+{
+	struct snd_pcm_substream *substream = pcm->streams[stream].substream;
+	struct snd_dma_buffer *buf = &substream->dma_buffer;
+
+	buf->area = dma_alloc_writecombine(pcm->card->dev, size,
+				&buf->addr, GFP_KERNEL);
+	if (!buf->area)
+		return -ENOMEM;
+
+	buf->dev.type = SNDRV_DMA_TYPE_DEV;
+	buf->dev.dev = pcm->card->dev;
+	buf->private_data = NULL;
+	buf->bytes = size;
+
+	return 0;
+}
+EXPORT_SYMBOL(snd_pcm_lib_alloc_writecombine_dma_buffer);
+
+void snd_pcm_lib_dealloc_writecombine_dma_buffer(struct snd_pcm *pcm,
+		int stream)
+{
+	struct snd_pcm_substream *substream = pcm->streams[stream].substream;
+	struct snd_dma_buffer *buf;
+
+	if (!substream)
+		return;
+
+	buf = &substream->dma_buffer;
+	if (!buf->area)
+		return;
+
+	dma_free_writecombine(pcm->card->dev, buf->bytes,
+			buf->area, buf->addr);
+	buf->area = NULL;
+}
+EXPORT_SYMBOL(snd_pcm_lib_dealloc_writecombine_dma_buffer);
+
+int snd_pcm_lib_mmap_writecombine_dma_buffer(
+		struct snd_pcm_substream *substream,
+		struct vm_area_struct *vma)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+
+	return dma_mmap_writecombine(substream->pcm->card->dev, vma,
+			runtime->dma_area, runtime->dma_addr,
+			runtime->dma_bytes);
+}
+EXPORT_SYMBOL(snd_pcm_lib_mmap_writecombine_dma_buffer);
+#endif
+
 /*
  * mmap DMA buffer
  */
-- 
1.7.1.1


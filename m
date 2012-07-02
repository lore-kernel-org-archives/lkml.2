Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab2GBNE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 09:04:27 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18042 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab2GBNE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:04:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 02 Jul 2012 06:03:37 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <tiwai@suse.de>, <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>,
        <lars@metafoo.de>, <swarren@nvidia.com>, <perex@perex.cz>,
        <clemens@ladisch.de>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 1/2] ALSA: Support writecombine DMA buffer memory page alloc/free
Date: Mon, 2 Jul 2012 18:29:40 +0530
Message-ID: <1341233981-32412-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1341233981-32412-1-git-send-email-ldewangan@nvidia.com>
References: <1341233981-32412-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of architecture like ARM support the writecombine DMA
buffer which is used for pcm substream DMA buffer.

Supporting writecombine DMA buffer allocation/free/mmap
through the sound library memory management.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
Integrate the changes from Takashi's sample code for supporting
writecombine.

Changes from V2: 
- Added some more comment for WAR for ARM specific.

 include/sound/memalloc.h |    1 +
 sound/core/memalloc.c    |   86 +++++++++++++++++++++++++++++++++++++++++----
 sound/core/pcm_native.c  |   17 +++++++++
 3 files changed, 96 insertions(+), 8 deletions(-)

diff --git a/include/sound/memalloc.h b/include/sound/memalloc.h
index c425062..0328e37 100644
--- a/include/sound/memalloc.h
+++ b/include/sound/memalloc.h
@@ -52,6 +52,7 @@ struct snd_dma_device {
 #else
 #define SNDRV_DMA_TYPE_DEV_SG	SNDRV_DMA_TYPE_DEV /* no SG-buf support */
 #endif
+#define SNDRV_DMA_TYPE_DEV_WC		4	/* writecombine page */
 
 /*
  * info for buffer allocation
diff --git a/sound/core/memalloc.c b/sound/core/memalloc.c
index 6915692..de99743 100644
--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -124,8 +124,9 @@ void snd_free_pages(void *ptr, size_t size)
  */
 
 #ifdef CONFIG_HAS_DMA
-/* allocate the coherent DMA pages */
-static void *snd_malloc_dev_pages(struct device *dev, size_t size, dma_addr_t *dma)
+static void *_snd_malloc_dev_pages(struct device *dev, size_t size, dma_addr_t *dma,
+		void *(*alloc_func)(struct device *dev, size_t size,
+			dma_addr_t *dma, gfp_t gfp_flags))
 {
 	int pg;
 	void *res;
@@ -138,16 +139,18 @@ static void *snd_malloc_dev_pages(struct device *dev, size_t size, dma_addr_t *d
 		| __GFP_COMP	/* compound page lets parts be mapped */
 		| __GFP_NORETRY /* don't trigger OOM-killer */
 		| __GFP_NOWARN; /* no stack trace print - this call is non-critical */
-	res = dma_alloc_coherent(dev, PAGE_SIZE << pg, dma, gfp_flags);
+	res = alloc_func(dev, PAGE_SIZE << pg, dma, gfp_flags);
 	if (res != NULL)
 		inc_snd_pages(pg);
 
 	return res;
 }
 
-/* free the coherent DMA pages */
-static void snd_free_dev_pages(struct device *dev, size_t size, void *ptr,
-			       dma_addr_t dma)
+static void _snd_free_dev_pages(struct device *dev, size_t size, void *ptr,
+				dma_addr_t dma,
+				void (*free_func)(struct device *dev,
+					size_t size, void *vaddr,
+					dma_addr_t dma_handle))
 {
 	int pg;
 
@@ -155,8 +158,57 @@ static void snd_free_dev_pages(struct device *dev, size_t size, void *ptr,
 		return;
 	pg = get_order(size);
 	dec_snd_pages(pg);
-	dma_free_coherent(dev, PAGE_SIZE << pg, ptr, dma);
+	free_func(dev, PAGE_SIZE << pg, ptr, dma);
+}
+
+static void *_dma_alloc_coherent(struct device *dev, size_t size,
+		dma_addr_t *dma_handle, gfp_t flag)
+{
+	return dma_alloc_coherent(dev, size, dma_handle, flag);
+}
+
+static void _dma_free_coherent(struct device *dev, size_t size,
+			void *vaddr, dma_addr_t dma_handle)
+{
+	dma_free_coherent(dev, size, vaddr, dma_handle);
+}
+
+
+/* allocate the coherent DMA pages */
+static void *snd_malloc_dev_pages(struct device *dev, size_t size, dma_addr_t *dma)
+{
+	return _snd_malloc_dev_pages(dev, size, dma, _dma_alloc_coherent);
+}
+
+/* free the coherent DMA pages */
+static void snd_free_dev_pages(struct device *dev, size_t size, void *ptr,
+			       dma_addr_t dma)
+{
+	_snd_free_dev_pages(dev, size, ptr, dma, _dma_free_coherent);
 }
+
+
+/**
+ * Support writecombine DMA buffer allocation and deallocation.
+ * TODO: Currently all architectures do not support the writecombine
+ * dma buffer. It is supported by ARM and hence enabling for ARM.
+ * Once all architectures support, the restriction for ARM only can
+ * be removed.
+ */
+#ifdef CONFIG_ARM
+/* allocate the writecombine DMA pages */
+static void *snd_malloc_dev_wc_pages(struct device *dev, size_t size, dma_addr_t *dma)
+{
+	return _snd_malloc_dev_pages(dev, size, dma, dma_alloc_writecombine);
+}
+
+/* free the writecombine DMA pages */
+static void snd_free_dev_wc_pages(struct device *dev, size_t size, void *ptr,
+			       dma_addr_t dma)
+{
+	_snd_free_dev_pages(dev, size, ptr, dma, dma_free_writecombine);
+}
+#endif
 #endif /* CONFIG_HAS_DMA */
 
 /*
@@ -200,6 +252,15 @@ int snd_dma_alloc_pages(int type, struct device *device, size_t size,
 	case SNDRV_DMA_TYPE_DEV:
 		dmab->area = snd_malloc_dev_pages(device, size, &dmab->addr);
 		break;
+/**
+ * TODO: Support writecombine DMA type for ARM only as all archs do not
+ * support this. This restriction can be remove once all archs support it.
+ */
+#ifdef CONFIG_ARM
+	case SNDRV_DMA_TYPE_DEV_WC:
+		dmab->area = snd_malloc_dev_wc_pages(device, size, &dmab->addr);
+		break;
+#endif
 #endif
 #ifdef CONFIG_SND_DMA_SGBUF
 	case SNDRV_DMA_TYPE_DEV_SG:
@@ -272,6 +333,15 @@ void snd_dma_free_pages(struct snd_dma_buffer *dmab)
 	case SNDRV_DMA_TYPE_DEV:
 		snd_free_dev_pages(dmab->dev.dev, dmab->bytes, dmab->area, dmab->addr);
 		break;
+/**
+ * TODO: Support writecombine DMA type for ARM only as all archs do not
+ * support this. This restriction can be remove once all archs support it.
+ */
+#ifdef CONFIG_ARM
+	case SNDRV_DMA_TYPE_DEV_WC:
+		snd_free_dev_wc_pages(dmab->dev.dev, dmab->bytes, dmab->area, dmab->addr);
+		break;
+#endif
 #endif
 #ifdef CONFIG_SND_DMA_SGBUF
 	case SNDRV_DMA_TYPE_DEV_SG:
@@ -378,7 +448,7 @@ static int snd_mem_proc_read(struct seq_file *seq, void *offset)
 	long pages = snd_allocated_pages >> (PAGE_SHIFT-12);
 	struct snd_mem_list *mem;
 	int devno;
-	static char *types[] = { "UNKNOWN", "CONT", "DEV", "DEV-SG" };
+	static char *types[] = { "UNKNOWN", "CONT", "DEV", "DEV-SG" , "WC"};
 
 	mutex_lock(&list_mutex);
 	seq_printf(seq, "pages  : %li bytes (%li pages per %likB)\n",
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 53b5ada..827835b 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3170,6 +3170,23 @@ int snd_pcm_lib_default_mmap(struct snd_pcm_substream *substream,
 			     struct vm_area_struct *area)
 {
 	area->vm_flags |= VM_RESERVED;
+
+/**
+ * Support writecombine DMA device type for mmap.
+ * TODO: Currently all architectures do not support the writecombine
+ * DMA buffer. It is supported by ARM and hence enabling for ARM.
+ * Once all architectures support, the restriction for ARM only can
+ * be removed.
+ */
+#ifdef CONFIG_ARM
+	if (substream->dma_buffer.dev.type == SNDRV_DMA_TYPE_DEV_WC)
+		return dma_mmap_writecombine(substream->dma_buffer.dev.dev,
+				area,
+				substream->runtime->dma_area,
+				substream->runtime->dma_addr,
+				area->vm_end - area->vm_start);
+#endif
+
 #ifdef ARCH_HAS_DMA_MMAP_COHERENT
 	if (!substream->ops->page &&
 	    substream->dma_buffer.dev.type == SNDRV_DMA_TYPE_DEV)
-- 
1.7.1.1


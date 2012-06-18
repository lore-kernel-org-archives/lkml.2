Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab2FRHvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 03:51:19 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9904 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab2FRHvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 03:51:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 18 Jun 2012 00:51:03 -0700
Date: Mon, 18 Jun 2012 10:50:59 +0300
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Subash Patel <subash.ramaswamy@linaro.org>,
        "Sumit Semwal" <sumit.semwal@linaro.org>,
        Abhinav Kochhar <abhinav.k@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH/RFC 0/2] ARM: DMA-mapping: new extensions for buffer
 sharing (part 2)
Message-ID: <20120618105059.12c709d68240ad18c5f8c7a5@nvidia.com>
In-Reply-To: <1338988657-20770-1-git-send-email-m.szyprowski@samsung.com>
References: <1338988657-20770-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On Wed, 6 Jun 2012 15:17:35 +0200
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> Hello,
> 
> This is a continuation of the dma-mapping extensions posted in the
> following thread:
> http://thread.gmane.org/gmane.linux.kernel.mm/78644
> 
> We noticed that some advanced buffer sharing use cases usually require
> creating a dma mapping for the same memory buffer for more than one
> device. Usually also such buffer is never touched with CPU, so the data
> are processed by the devices.
> 
> From the DMA-mapping perspective this requires to call one of the
> dma_map_{page,single,sg} function for the given memory buffer a few
> times, for each of the devices. Each dma_map_* call performs CPU cache
> synchronization, what might be a time consuming operation, especially
> when the buffers are large. We would like to avoid any useless and time
> consuming operations, so that was the main reason for introducing
> another attribute for DMA-mapping subsystem: DMA_ATTR_SKIP_CPU_SYNC,
> which lets dma-mapping core to skip CPU cache synchronization in certain
> cases.

I had implemented the similer patch(*1) to optimize/skip the cache
maintanace, but we did this with "dir", not with "attr", making use of
the existing DMA_NONE to skip cache operations. I'm just interested in
why you choose attr for this purpose. Could you enlight me why attr is
used here?

Any way, this feature is necessary for us. Thank you for posting them.

*1: FYI:

>From 4656146d23d0a3bd02131f732b0c04e50475b8da Mon Sep 17 00:00:00 2001
From: Hiroshi DOYU <hdoyu@nvidia.com>
Date: Tue, 20 Mar 2012 15:09:30 +0200
Subject: [PATCH 1/1] ARM: dma-mapping: Allow DMA_NONE to skip cache_maint

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 arch/arm/mm/dma-mapping.c                |   16 ++++++++--------
 drivers/video/tegra/nvmap/nvmap.c        |    2 +-
 drivers/video/tegra/nvmap/nvmap_handle.c |    2 +-
 include/linux/dma-mapping.h              |   16 +++++++++++++---
 4 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 83f0ac6..c4b1587 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1161,7 +1161,7 @@ static int __map_sg_chunk(struct device *dev, struct scatterlist *sg,
 		phys_addr_t phys = page_to_phys(sg_page(s));
 		unsigned int len = PAGE_ALIGN(s->offset + s->length);
 
-		if (!arch_is_coherent())
+		if (!arch_is_coherent() && (dir != DMA_NONE))
 			__dma_page_cpu_to_dev(sg_page(s), s->offset, s->length, dir);
 
 		ret = iommu_map(mapping->domain, iova, phys, len, 0);
@@ -1254,7 +1254,7 @@ void arm_iommu_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
 		if (sg_dma_len(s))
 			__iommu_remove_mapping(dev, sg_dma_address(s),
 					       sg_dma_len(s));
-		if (!arch_is_coherent())
+		if (!arch_is_coherent() && (dir != DMA_NONE))
 			__dma_page_dev_to_cpu(sg_page(s), s->offset,
 					      s->length, dir);
 	}
@@ -1274,7 +1274,7 @@ void arm_iommu_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 	int i;
 
 	for_each_sg(sg, s, nents, i)
-		if (!arch_is_coherent())
+		if (!arch_is_coherent() && (dir != DMA_NONE))
 			__dma_page_dev_to_cpu(sg_page(s), s->offset, s->length, dir);
 
 }
@@ -1293,7 +1293,7 @@ void arm_iommu_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 	int i;
 
 	for_each_sg(sg, s, nents, i)
-		if (!arch_is_coherent())
+		if (!arch_is_coherent() && (dir != DMA_NONE))
 			__dma_page_cpu_to_dev(sg_page(s), s->offset, s->length, dir);
 }
 
@@ -1305,7 +1305,7 @@ static dma_addr_t __arm_iommu_map_page_at(struct device *dev, struct page *page,
 	dma_addr_t dma_addr;
 	int ret, len = PAGE_ALIGN(size + offset);
 
-	if (!arch_is_coherent())
+	if (!arch_is_coherent() && (dir != DMA_NONE))
 		__dma_page_cpu_to_dev(page, offset, size, dir);
 
 	dma_addr = __alloc_iova_at(mapping, req, len);
@@ -1349,7 +1349,7 @@ dma_addr_t arm_iommu_map_page_at(struct device *dev, struct page *page,
 	unsigned int phys;
 	int ret;
 
-	if (!arch_is_coherent())
+	if (!arch_is_coherent() && (dir != DMA_NONE))
 		__dma_page_cpu_to_dev(page, offset, size, dir);
 
 	/* Check if iova area is reserved in advance. */
@@ -1386,7 +1386,7 @@ static void __arm_iommu_unmap_page_at(struct device *dev, dma_addr_t handle,
 	if (!iova)
 		return;
 
-	if (!arch_is_coherent())
+	if (!arch_is_coherent() && (dir != DMA_NONE))
 		__dma_page_dev_to_cpu(page, offset, size, dir);
 
 	iommu_unmap(mapping->domain, iova, len);
@@ -1430,7 +1430,7 @@ static void arm_iommu_sync_single_for_cpu(struct device *dev,
 	if (!iova)
 		return;
 
-	if (!arch_is_coherent())
+	if (!arch_is_coherent() && (dir != DMA_NONE))
 		__dma_page_dev_to_cpu(page, offset, size, dir);
 }
 
diff --git a/drivers/video/tegra/nvmap/nvmap.c b/drivers/video/tegra/nvmap/nvmap.c
index 1032224..e98dd11 100644
--- a/drivers/video/tegra/nvmap/nvmap.c
+++ b/drivers/video/tegra/nvmap/nvmap.c
@@ -56,7 +56,7 @@ static void map_iovmm_area(struct nvmap_handle *h)
 		BUG_ON(!pfn_valid(page_to_pfn(h->pgalloc.pages[i])));
 
 		iova = dma_map_page_at(to_iovmm_dev(h), h->pgalloc.pages[i],
-				       va, 0, PAGE_SIZE, DMA_BIDIRECTIONAL);
+				       va, 0, PAGE_SIZE, DMA_NONE);
 		BUG_ON(iova != va);
 	}
 	h->pgalloc.dirty = false;
diff --git a/drivers/video/tegra/nvmap/nvmap_handle.c b/drivers/video/tegra/nvmap/nvmap_handle.c
index 853f87e..b2bbeb1 100644
--- a/drivers/video/tegra/nvmap/nvmap_handle.c
+++ b/drivers/video/tegra/nvmap/nvmap_handle.c
@@ -504,7 +504,7 @@ void nvmap_free_vm(struct device *dev, struct tegra_iovmm_area *area)
 		dma_addr_t iova;
 
 		iova = area->iovm_start + i * PAGE_SIZE;
-		dma_unmap_page(dev, iova, PAGE_SIZE, DMA_BIDIRECTIONAL);
+		dma_unmap_page(dev, iova, PAGE_SIZE, DMA_NONE);
 	}
 	kfree(area);
 }
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 36dfe06..cbd8d47 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -55,9 +55,19 @@ struct dma_map_ops {
 
 static inline int valid_dma_direction(int dma_direction)
 {
-	return ((dma_direction == DMA_BIDIRECTIONAL) ||
-		(dma_direction == DMA_TO_DEVICE) ||
-		(dma_direction == DMA_FROM_DEVICE));
+	int ret = 1;
+
+	switch (dma_direction) {
+	case DMA_BIDIRECTIONAL:
+	case DMA_TO_DEVICE:
+	case DMA_FROM_DEVICE:
+	case DMA_NONE:
+		break;
+	default:
+		ret = !!ret;
+		break;
+	} 
+	return ret;
 }
 
 static inline int is_device_dma_capable(struct device *dev)
-- 
1.7.5.4


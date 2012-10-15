Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab2JOOFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 10:05:13 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10459 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab2JOOFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 10:05:11 -0400
X-AuditID: cbfee61b-b7fd46d0000046e0-fe-507c17f16fa0
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Inki Dae <inki.dae@samsung.com>, Rob Clark <rob@ti.com>
Subject: [RFC 2/2] ARM: dma-mapping: add support for DMA_ATTR_FORCE_CONTIGUOUS
 attribute
Date: Mon, 15 Oct 2012 16:03:52 +0200
Message-id: <1350309832-18461-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1350309832-18461-1-git-send-email-m.szyprowski@samsung.com>
References: <1350309832-18461-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLJMWRmVeSWpSXmKPExsVy+t9jAd2P4jUBBltOy1hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mnz8/MxZ8kKiYv16ugXGaSBcjJ4eEgInE5ylf2CFsMYkL99az
	dTFycQgJLGKUODbrJwtIQkhgBZPEtF2VIDabgKFE19suoCIODhGBGol5MxhB6pkFXjNKzNq5
	GSwuLBAlse9rJkg5i4CqxIs7v1hAwrwCHhIvN4JVSAgoSMyZZANSwSngKfH04VxGiEUeEvMa
	dzNPYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyPY08+kdzCuarA4xCjAwajEw/vT
	qzpAiDWxrLgy9xCjBAezkgjvs0dAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzNHikBQgLpiSWp
	2ampBalFMFkmDk6pBkYJ+1uzO63dZVu3JAdX5ATvvCI5i+2Fd/Z/PZaNDt1fj7psv/hs/Tpp
	SR8zpYCUK5evqU+VXZ7G/PGEpmD13MJs01yHFc/57s+cKnxixXTuxQ11HULxGZNU5jyZuvJ1
	/C+G5XkMJ3Z+8/oyKUHDsblvahyHU1xtVf3u4Np7T+KqX76d+PnomXdKLMUZiYZazEXFiQD0
	W16w8AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for DMA_ATTR_FORCE_CONTIGUOUS attribute for
dma_alloc_attrs() in IOMMU-aware implementation. For allocating physically
contiguous buffers Contiguous Memory Allocator is used.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/mm/dma-mapping.c |   41 +++++++++++++++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 477a2d2..583a302 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1036,7 +1036,8 @@ static inline void __free_iova(struct dma_iommu_mapping *mapping,
 	spin_unlock_irqrestore(&mapping->lock, flags);
 }
 
-static struct page **__iommu_alloc_buffer(struct device *dev, size_t size, gfp_t gfp)
+static struct page **__iommu_alloc_buffer(struct device *dev, size_t size,
+					  gfp_t gfp, struct dma_attrs *attrs)
 {
 	struct page **pages;
 	int count = size >> PAGE_SHIFT;
@@ -1050,6 +1051,23 @@ static struct page **__iommu_alloc_buffer(struct device *dev, size_t size, gfp_t
 	if (!pages)
 		return NULL;
 
+	if (dma_get_attr(DMA_ATTR_FORCE_CONTIGUOUS, attrs))
+	{
+		unsigned long order = get_order(size);
+		struct page *page;
+
+		page = dma_alloc_from_contiguous(dev, count, order);
+		if (!page)
+			goto error;
+
+		__dma_clear_buffer(page, size);
+
+		for (i = 0; i < count; i++)
+			pages[i] = page + i;
+
+		return pages;
+	}
+
 	while (count) {
 		int j, order = __fls(count);
 
@@ -1083,14 +1101,21 @@ error:
 	return NULL;
 }
 
-static int __iommu_free_buffer(struct device *dev, struct page **pages, size_t size)
+static int __iommu_free_buffer(struct device *dev, struct page **pages,
+			       size_t size, struct dma_attrs *attrs)
 {
 	int count = size >> PAGE_SHIFT;
 	int array_size = count * sizeof(struct page *);
 	int i;
-	for (i = 0; i < count; i++)
-		if (pages[i])
-			__free_pages(pages[i], 0);
+
+	if (dma_get_attr(DMA_ATTR_FORCE_CONTIGUOUS, attrs)) {
+		dma_release_from_contiguous(dev, pages[0], count);
+	} else {
+		for (i = 0; i < count; i++)
+			if (pages[i])
+				__free_pages(pages[i], 0);
+	}
+
 	if (array_size <= PAGE_SIZE)
 		kfree(pages);
 	else
@@ -1252,7 +1277,7 @@ static void *arm_iommu_alloc_attrs(struct device *dev, size_t size,
 	if (gfp & GFP_ATOMIC)
 		return __iommu_alloc_atomic(dev, size, handle);
 
-	pages = __iommu_alloc_buffer(dev, size, gfp);
+	pages = __iommu_alloc_buffer(dev, size, gfp, attrs);
 	if (!pages)
 		return NULL;
 
@@ -1273,7 +1298,7 @@ static void *arm_iommu_alloc_attrs(struct device *dev, size_t size,
 err_mapping:
 	__iommu_remove_mapping(dev, *handle, size);
 err_buffer:
-	__iommu_free_buffer(dev, pages, size);
+	__iommu_free_buffer(dev, pages, size, attrs);
 	return NULL;
 }
 
@@ -1329,7 +1354,7 @@ void arm_iommu_free_attrs(struct device *dev, size_t size, void *cpu_addr,
 	}
 
 	__iommu_remove_mapping(dev, handle, size);
-	__iommu_free_buffer(dev, pages, size);
+	__iommu_free_buffer(dev, pages, size, attrs);
 }
 
 static int arm_iommu_get_sgtable(struct device *dev, struct sg_table *sgt,
-- 
1.7.9.5


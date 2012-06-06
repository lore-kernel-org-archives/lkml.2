Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab2FFNTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:19:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45256 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab2FFNTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:19:06 -0400
X-AuditID: cbfee61b-b7f8f6d000005ca4-34-4fcf58c9c026
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Subash Patel <subash.ramaswamy@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Abhinav Kochhar <abhinav.k@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 2/2] ARM: dma-mapping: add support for DMA_ATTR_SKIP_CPU_SYNC
 attribute
Date: Wed, 06 Jun 2012 15:17:37 +0200
Message-id: <1338988657-20770-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1338988657-20770-1-git-send-email-m.szyprowski@samsung.com>
References: <1338988657-20770-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJMWRmVeSWpSXmKPExsVy+t9jAd2TEef9DS4957Po2PWVxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVsvzOBueCWYsX2f/3sDYxnpLsYOTkkBEwkFt7pYoWw
	xSQu3FvP1sXIxSEksIhRYv+GjawQTheTxN5788Cq2AQMJbredrGB2CICMxgldvWlgRQxC+xj
	kejcfIIRJCEsEClxaMo7sCIWAVWJOxO2gjXzCnhILPp9ngVinbzE0/t9YDWcAp4SUw7OZwex
	hYBqbp3oZZrAyLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRrD/n0nvYFzVYHGIUYCD
	UYmH923YeX8h1sSy4srcQ4wSHMxKIrxxzkAh3pTEyqrUovz4otKc1OJDjNIcLErivH3HzvkL
	CaQnlqRmp6YWpBbBZJk4OKUaGBX8fBcKzQ1/vre9TzjnE8vduq239HqNgjxd3/iJiOWuzjj3
	KtOnZPPFOj3OW6z6t6V/eARtkBSeOolJdM3ynbe3fdy+yPzqSRW2AwXLIpwiDIOTJ28+WPLo
	aZTSno1HdyjcOOh3Pvzwyw0REet10xYX7Jni5ZrcXJ2UetLFgjnHZeucu10rdJVYijMSDbWY
	i4oTAcUHt6/7AQAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for DMA_ATTR_SKIP_CPU_SYNC attribute for
dma_(un)map_(single,page,sg) functions family. It lets dma mapping clients
to create a mapping for the buffer for the given device without performing
a CPU cache synchronization. CPU cache synchronization can be skipped for
the buffers which it is known that they are already in 'device' domain (CPU
caches have been already synchronized or there are only coherent mappings
for the buffer). For advanced users only, please use it with care.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/mm/dma-mapping.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index b140440..62a0023 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -68,7 +68,7 @@ static dma_addr_t arm_dma_map_page(struct device *dev, struct page *page,
 	     unsigned long offset, size_t size, enum dma_data_direction dir,
 	     struct dma_attrs *attrs)
 {
-	if (!arch_is_coherent())
+	if (!arch_is_coherent() && !dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
 		__dma_page_cpu_to_dev(page, offset, size, dir);
 	return pfn_to_dma(dev, page_to_pfn(page)) + offset;
 }
@@ -91,7 +91,7 @@ static void arm_dma_unmap_page(struct device *dev, dma_addr_t handle,
 		size_t size, enum dma_data_direction dir,
 		struct dma_attrs *attrs)
 {
-	if (!arch_is_coherent())
+	if (!arch_is_coherent() && !dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
 		__dma_page_dev_to_cpu(pfn_to_page(dma_to_pfn(dev, handle)),
 				      handle & ~PAGE_MASK, size, dir);
 }
@@ -1077,7 +1077,7 @@ static int arm_iommu_get_sgtable(struct device *dev, struct sg_table *sgt,
  */
 static int __map_sg_chunk(struct device *dev, struct scatterlist *sg,
 			  size_t size, dma_addr_t *handle,
-			  enum dma_data_direction dir)
+			  enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	struct dma_iommu_mapping *mapping = dev->archdata.mapping;
 	dma_addr_t iova, iova_base;
@@ -1096,7 +1096,8 @@ static int __map_sg_chunk(struct device *dev, struct scatterlist *sg,
 		phys_addr_t phys = page_to_phys(sg_page(s));
 		unsigned int len = PAGE_ALIGN(s->offset + s->length);
 
-		if (!arch_is_coherent())
+		if (!arch_is_coherent() &&
+		    !dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
 			__dma_page_cpu_to_dev(sg_page(s), s->offset, s->length, dir);
 
 		ret = iommu_map(mapping->domain, iova, phys, len, 0);
@@ -1143,7 +1144,7 @@ int arm_iommu_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 
 		if (s->offset || (size & ~PAGE_MASK) || size + s->length > max) {
 			if (__map_sg_chunk(dev, start, size, &dma->dma_address,
-			    dir) < 0)
+			    dir, attrs) < 0)
 				goto bad_mapping;
 
 			dma->dma_address += offset;
@@ -1156,7 +1157,7 @@ int arm_iommu_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 		}
 		size += s->length;
 	}
-	if (__map_sg_chunk(dev, start, size, &dma->dma_address, dir) < 0)
+	if (__map_sg_chunk(dev, start, size, &dma->dma_address, dir, attrs) < 0)
 		goto bad_mapping;
 
 	dma->dma_address += offset;
@@ -1190,7 +1191,8 @@ void arm_iommu_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
 		if (sg_dma_len(s))
 			__iommu_remove_mapping(dev, sg_dma_address(s),
 					       sg_dma_len(s));
-		if (!arch_is_coherent())
+		if (!arch_is_coherent() &&
+		    !dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
 			__dma_page_dev_to_cpu(sg_page(s), s->offset,
 					      s->length, dir);
 	}
@@ -1252,7 +1254,7 @@ static dma_addr_t arm_iommu_map_page(struct device *dev, struct page *page,
 	dma_addr_t dma_addr;
 	int ret, len = PAGE_ALIGN(size + offset);
 
-	if (!arch_is_coherent())
+	if (!arch_is_coherent() && !dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
 		__dma_page_cpu_to_dev(page, offset, size, dir);
 
 	dma_addr = __alloc_iova(mapping, len);
@@ -1291,7 +1293,7 @@ static void arm_iommu_unmap_page(struct device *dev, dma_addr_t handle,
 	if (!iova)
 		return;
 
-	if (!arch_is_coherent())
+	if (!arch_is_coherent() && !dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
 		__dma_page_dev_to_cpu(page, offset, size, dir);
 
 	iommu_unmap(mapping->domain, iova, len);
-- 
1.7.1.569.g6f426


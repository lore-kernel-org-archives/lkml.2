Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124Ab2HWGLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 02:11:48 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1575 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277Ab2HWGLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 02:11:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 22 Aug 2012 23:05:08 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <m.szyprowski@samsung.com>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, <linux-arm-kernel@lists.infradead.org>,
        <linaro-mm-sig@lists.linaro.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kyungmin.park@samsung.com>,
        <arnd@arndb.de>, <linux@arm.linux.org.uk>, <chunsang.jeong@linaro.org>,
        <vdumpa@nvidia.com>, <konrad.wilk@oracle.com>, <subashrp@gmail.com>,
        <minchan@kernel.org>, <pullip.cho@samsung.com>
Subject: [v2 4/4] ARM: dma-mapping: IOMMU allocates pages from atomic_pool with GFP_ATOMIC
Date: Thu, 23 Aug 2012 09:10:29 +0300
Message-ID: <1345702229-9539-5-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1345702229-9539-1-git-send-email-hdoyu@nvidia.com>
References: <1345702229-9539-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes use of the same atomic pool from DMA, and skips kernel page
mapping which can involve sleep'able operations at allocating a kernel
page table.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/mm/dma-mapping.c |   30 +++++++++++++++++++++++++-----
 1 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 7ab016b..433312a 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1063,7 +1063,6 @@ static struct page **__iommu_alloc_buffer(struct device *dev, size_t size,
 	struct page **pages;
 	int count = size >> PAGE_SHIFT;
 	int array_size = count * sizeof(struct page *);
-	int err;
 
 	if ((array_size <= PAGE_SIZE) || (gfp & GFP_ATOMIC))
 		pages = kzalloc(array_size, gfp);
@@ -1072,9 +1071,20 @@ static struct page **__iommu_alloc_buffer(struct device *dev, size_t size,
 	if (!pages)
 		return NULL;
 
-	err = __alloc_fill_pages(&pages, count, gfp);
-	if (err)
-		goto error
+	if (gfp & GFP_ATOMIC) {
+		struct page *page;
+		int i;
+		void *addr = __alloc_from_pool(size, &page);
+		if (!addr)
+			goto error;
+
+		for (i = 0; i < count; i++)
+			pages[i] = page + i;
+	} else {
+		int err = __alloc_fill_pages(&pages, count, gfp);
+		if (err)
+			goto error;
+	}
 
 	return pages;
 
@@ -1091,9 +1101,15 @@ static int __iommu_free_buffer(struct device *dev, struct page **pages, size_t s
 	int count = size >> PAGE_SHIFT;
 	int array_size = count * sizeof(struct page *);
 	int i;
+
+	if (__free_from_pool(page_address(pages[0]), size))
+		goto out;
+
 	for (i = 0; i < count; i++)
 		if (pages[i])
 			__free_pages(pages[i], 0);
+
+out:
 	if ((array_size <= PAGE_SIZE) ||
 	    __in_atomic_pool(page_address(pages[0]), size))
 		kfree(pages);
@@ -1221,6 +1237,9 @@ static void *arm_iommu_alloc_attrs(struct device *dev, size_t size,
 	if (*handle == DMA_ERROR_CODE)
 		goto err_buffer;
 
+	if (gfp & GFP_ATOMIC)
+		return page_address(pages[0]);
+
 	if (dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs))
 		return pages;
 
@@ -1279,7 +1298,8 @@ void arm_iommu_free_attrs(struct device *dev, size_t size, void *cpu_addr,
 		return;
 	}
 
-	if (!dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs)) {
+	if (!dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs) ||
+	    !__in_atomic_pool(cpu_addr, size)) {
 		unmap_kernel_range((unsigned long)cpu_addr, size);
 		vunmap(cpu_addr);
 	}
-- 
1.7.5.4


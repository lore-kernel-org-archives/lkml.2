Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab2FMLvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:51:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53370 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab2FMLvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:51:01 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-fa-4fd87ea42ba5
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
Subject: [PATCHv2 2/6] ARM: dma-mapping: add support for
 DMA_ATTR_NO_KERNEL_MAPPING attribute
Date: Wed, 13 Jun 2012 13:50:14 +0200
Message-id: <1339588218-24398-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1339588218-24398-1-git-send-email-m.szyprowski@samsung.com>
References: <1339588218-24398-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJMWRmVeSWpSXmKPExsVy+t9jAd0ldTf8Db5MFLHo2PWVxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGUcvTubseCWaMWJK5+YGxgnC3UxcnBICJhIXD/m3sXI
	CWSKSVy4t56ti5GLQ0hgEaNE8702dpCEkEAXk8TXDk8Qm03AUKLrbRcbiC0iMINRYldfGkgD
	s8A+FonOzScYQRLCAvESp9a8YwFZwCKgKnFjIQtImFfAQ6Jz3ndGiGXyEk/v94HN4RTwlPj9
	bB8TxC4Pid/TDjNPYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyPY88+kdzCuarA4
	xCjAwajEw5sBDAgh1sSy4srcQ4wSHMxKIrzPsoFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZus
	L/gLCaQnlqRmp6YWpBbBZJk4OKUaGA12Hntz+n7UPDutl/LbD1bH5n0/bbvTS87q1w7v7Gk5
	GwzunHf9uKjXZa2ZnIvH92DpmT+me7Y+rnXIfF/+LvOmWe7dC1I24ZxW03n/dz++sOjW1bfL
	BXolAooXNU28t0qCL3Mz5yQ+0Ujr52HtJe/bjYrC453P2fuyyx1oy7OONHD/wtutpcRSnJFo
	qMVcVJwIABLWu974AQAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for DMA_ATTR_NO_KERNEL_MAPPING attribute for
IOMMU allocations, what let drivers to save precious kernel virtual
address space for large buffers that are intended to be accessed only
from userspace.

This patch is heavily based on initial work kindly provided by Abhinav
Kochhar <abhinav.k@samsung.com>.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mm/dma-mapping.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index b3ffcf9..5d8b8b2 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1071,10 +1071,13 @@ static int __iommu_remove_mapping(struct device *dev, dma_addr_t iova, size_t si
 	return 0;
 }
 
-static struct page **__iommu_get_pages(void *cpu_addr)
+static struct page **__iommu_get_pages(void *cpu_addr, struct dma_attrs *attrs)
 {
 	struct vm_struct *area;
 
+	if (dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs))
+		return cpu_addr;
+
 	area = find_vm_area(cpu_addr);
 	if (area && (area->flags & VM_DMA))
 		return area->pages;
@@ -1099,6 +1102,9 @@ static void *arm_iommu_alloc_attrs(struct device *dev, size_t size,
 	if (*handle == DMA_ERROR_CODE)
 		goto err_buffer;
 
+	if (dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs))
+		return pages;
+
 	addr = __iommu_alloc_remap(pages, size, gfp, prot,
 				   __builtin_return_address(0));
 	if (!addr)
@@ -1119,7 +1125,7 @@ static int arm_iommu_mmap_attrs(struct device *dev, struct vm_area_struct *vma,
 {
 	unsigned long uaddr = vma->vm_start;
 	unsigned long usize = vma->vm_end - vma->vm_start;
-	struct page **pages = __iommu_get_pages(cpu_addr);
+	struct page **pages = __iommu_get_pages(cpu_addr, attrs);
 
 	vma->vm_page_prot = __get_dma_pgprot(attrs, vma->vm_page_prot);
 
@@ -1146,7 +1152,7 @@ static int arm_iommu_mmap_attrs(struct device *dev, struct vm_area_struct *vma,
 void arm_iommu_free_attrs(struct device *dev, size_t size, void *cpu_addr,
 			  dma_addr_t handle, struct dma_attrs *attrs)
 {
-	struct page **pages = __iommu_get_pages(cpu_addr);
+	struct page **pages = __iommu_get_pages(cpu_addr, attrs);
 	size = PAGE_ALIGN(size);
 
 	if (!pages) {
@@ -1156,8 +1162,10 @@ void arm_iommu_free_attrs(struct device *dev, size_t size, void *cpu_addr,
 		return;
 	}
 
-	unmap_kernel_range((unsigned long)cpu_addr, size);
-	vunmap(cpu_addr);
+	if (!dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs)) {
+		unmap_kernel_range((unsigned long)cpu_addr, size);
+		vunmap(cpu_addr);
+	}
 
 	__iommu_remove_mapping(dev, handle, size);
 	__iommu_free_buffer(dev, pages, size);
-- 
1.7.1.569.g6f426


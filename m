Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab0FVTqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:46:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51703 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab0FVTqn (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 22 Jun 2010 15:46:43 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 07/19] swiotlb-xen: Make 'xen_swiotlb_alloc_coherent' work.
Date: Tue, 22 Jun 2010 15:42:40 -0400
Message-Id: <1277235772-26757-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
References: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090203.4C2112C8.01DC:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We allocate the requested page from wherever (we ignore the DMA32 flags)
and after allocation make a call for the kernel & hypervisor to replace
the memory at the virtual addresses with physical memory that is under
the 4GB mark.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb-xen.c |   55 ++++++++++++++++++++++------------------------------
 1 files changed, 23 insertions(+), 32 deletions(-)

diff --git a/lib/swiotlb-xen.c b/lib/swiotlb-xen.c
index c177f32..89443e4 100644
--- a/lib/swiotlb-xen.c
+++ b/lib/swiotlb-xen.c
@@ -35,6 +35,7 @@
 
 #include <linux/dma-mapping.h>
 #include <xen/page.h>
+#include <xen/xen-ops.h>
 
 /*
  * Used to do a quick range check in swiotlb_tbl_unmap_single and
@@ -129,47 +130,37 @@ void *
 xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			   dma_addr_t *dma_handle, gfp_t flags)
 {
-	dma_addr_t dev_addr;
 	void *ret;
 	int order = get_order(size);
 	u64 dma_mask = DMA_BIT_MASK(32);
+	unsigned long vstart;
 
-	if (hwdev && hwdev->coherent_dma_mask)
-		dma_mask = hwdev->coherent_dma_mask;
+	/*
+	* Ignore region specifiers - the kernel's ideas of
+	* pseudo-phys memory layout has nothing to do with the
+	* machine physical layout.  We can't allocate highmem
+	* because we can't return a pointer to it.
+	*/
+	flags &= ~(__GFP_DMA | __GFP_HIGHMEM);
 
-	ret = (void *)__get_free_pages(flags, order);
-	if (ret && xen_virt_to_bus(hwdev, ret) + size - 1 > dma_mask) {
-		/*
-		 * The allocated memory isn't reachable by the device.
-		 */
-		free_pages((unsigned long) ret, order);
-		ret = NULL;
-	}
-	if (!ret) {
-		/*
-		 * We are either out of memory or the device can't DMA to
-		 * GFP_DMA memory; fall back on map_single(), which
-		 * will grab memory from the lowest available address range.
-		 */
-		ret = xen_map_single(hwdev, 0, size, DMA_FROM_DEVICE);
-		if (!ret)
-			return NULL;
-	}
+	if (dma_alloc_from_coherent(hwdev, size, dma_handle, &ret))
+		return ret;
 
-	memset(ret, 0, size);
-	dev_addr = xen_virt_to_bus(hwdev, ret);
+	vstart = __get_free_pages(flags, order);
+	ret = (void *)vstart;
 
-	/* Confirm address can be DMA'd by device */
-	if (dev_addr + size - 1 > dma_mask) {
-		printk("hwdev DMA mask = 0x%016Lx, dev_addr = 0x%016Lx\n",
-		       (unsigned long long)dma_mask,
-		       (unsigned long long)dev_addr);
+	if (hwdev && hwdev->coherent_dma_mask)
+		dma_mask = hwdev->coherent_dma_mask;
 
-		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
-		swiotlb_tbl_unmap_single(hwdev, ret, size, DMA_TO_DEVICE);
-		return NULL;
+	if (ret) {
+		if (xen_create_contiguous_region(vstart, order,
+						 fls64(dma_mask)) != 0) {
+			free_pages(vstart, order);
+			return NULL;
+		}
+		memset(ret, 0, size);
+		*dma_handle = virt_to_machine(ret).maddr;
 	}
-	*dma_handle = dev_addr;
 	return ret;
 }
 EXPORT_SYMBOL_GPL(xen_swiotlb_alloc_coherent);
-- 
1.7.0.1


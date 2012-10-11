Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030209Ab2JKUex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:34:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:23213 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856Ab2JKUem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:34:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,573,1344236400"; 
   d="scan'208";a="204510608"
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH v2 6/7] swiotlb: Use physical addresses instead of virtual in
	swiotlb_tbl_sync_single
To: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, akpm@linux-foundation.org,
        joerg.roedel@amd.com, bhelgaas@google.com, shuahkhan@gmail.com,
        fujita.tomonori@lab.ntt.co.jp
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Date: Thu, 11 Oct 2012 13:34:52 -0700
Message-ID: <20121011203452.12444.35813.stgit@gitlad.jf.intel.com>
In-Reply-To: <20121011203010.12444.15503.stgit@gitlad.jf.intel.com>
References: <20121011203010.12444.15503.stgit@gitlad.jf.intel.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change makes it so that the sync functionality also uses physical
addresses.  This helps to further reduce the use of virt_to_phys and
phys_to_virt functions.

In order to clarify things since we now have 2 physical addresses in use
inside of swiotlb_tbl_sync_single I am renaming phys to orig_addr, and
dma_addr to tlb_addr.  This way is should be clear that orig_addr is
contained within io_orig_addr and tlb_addr is an address within the
io_tlb_addr buffer.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---

 drivers/xen/swiotlb-xen.c |    3 +--
 include/linux/swiotlb.h   |    3 ++-
 lib/swiotlb.c             |   22 +++++++++++-----------
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 4cedc28..af47e75 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -433,8 +433,7 @@ xen_swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 
 	/* NOTE: We use dev_addr here, not paddr! */
 	if (is_xen_swiotlb_buffer(dev_addr)) {
-		swiotlb_tbl_sync_single(hwdev, phys_to_virt(paddr), size, dir,
-				       target);
+		swiotlb_tbl_sync_single(hwdev, paddr, size, dir, target);
 		return;
 	}
 
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 291643c..e0ac98f 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -47,7 +47,8 @@ extern void swiotlb_tbl_unmap_single(struct device *hwdev,
 				     phys_addr_t tlb_addr,
 				     size_t size, enum dma_data_direction dir);
 
-extern void swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr,
+extern void swiotlb_tbl_sync_single(struct device *hwdev,
+				    phys_addr_t tlb_addr,
 				    size_t size, enum dma_data_direction dir,
 				    enum dma_sync_target target);
 
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index e0e66db..a81138f 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -557,26 +557,27 @@ void swiotlb_tbl_unmap_single(struct device *hwdev, phys_addr_t tlb_addr,
 }
 EXPORT_SYMBOL_GPL(swiotlb_tbl_unmap_single);
 
-void
-swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr, size_t size,
-			enum dma_data_direction dir,
-			enum dma_sync_target target)
+void swiotlb_tbl_sync_single(struct device *hwdev, phys_addr_t tlb_addr,
+			     size_t size, enum dma_data_direction dir,
+			     enum dma_sync_target target)
 {
-	int index = (dma_addr - (char *)phys_to_virt(io_tlb_start)) >> IO_TLB_SHIFT;
-	phys_addr_t phys = io_tlb_orig_addr[index];
+	int index = (tlb_addr - io_tlb_start) >> IO_TLB_SHIFT;
+	phys_addr_t orig_addr = io_tlb_orig_addr[index];
 
-	phys += ((unsigned long)dma_addr & ((1 << IO_TLB_SHIFT) - 1));
+	orig_addr += (unsigned long)tlb_addr & ((1 << IO_TLB_SHIFT) - 1);
 
 	switch (target) {
 	case SYNC_FOR_CPU:
 		if (likely(dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL))
-			swiotlb_bounce(phys, dma_addr, size, DMA_FROM_DEVICE);
+			swiotlb_bounce(orig_addr, phys_to_virt(tlb_addr),
+				       size, DMA_FROM_DEVICE);
 		else
 			BUG_ON(dir != DMA_TO_DEVICE);
 		break;
 	case SYNC_FOR_DEVICE:
 		if (likely(dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
-			swiotlb_bounce(phys, dma_addr, size, DMA_TO_DEVICE);
+			swiotlb_bounce(orig_addr, phys_to_virt(tlb_addr),
+				       size, DMA_TO_DEVICE);
 		else
 			BUG_ON(dir != DMA_FROM_DEVICE);
 		break;
@@ -785,8 +786,7 @@ swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 	BUG_ON(dir == DMA_NONE);
 
 	if (is_swiotlb_buffer(paddr)) {
-		swiotlb_tbl_sync_single(hwdev, phys_to_virt(paddr), size, dir,
-				       target);
+		swiotlb_tbl_sync_single(hwdev, paddr, size, dir, target);
 		return;
 	}
 


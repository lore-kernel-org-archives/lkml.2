Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340Ab2JDAjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 20:39:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:36635 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933167Ab2JDAi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 20:38:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,530,1344236400"; 
   d="scan'208";a="219543795"
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [RFC PATCH 6/7] swiotlb: Use physical addresses instead of virtual in
	swiotlb_tbl_sync_single
To: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, akpm@linux-foundation.org,
        joerg.roedel@amd.com, bhelgaas@google.com, shuahkhan@gmail.com
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, x86@kernel.org
Date: Wed, 03 Oct 2012 17:39:14 -0700
Message-ID: <20121004003914.5016.9561.stgit@gitlad.jf.intel.com>
In-Reply-To: <20121004002113.5016.66913.stgit@gitlad.jf.intel.com>
References: <20121004002113.5016.66913.stgit@gitlad.jf.intel.com>
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

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---

 drivers/xen/swiotlb-xen.c |    3 +--
 include/linux/swiotlb.h   |    3 ++-
 lib/swiotlb.c             |   18 +++++++++---------
 3 files changed, 12 insertions(+), 12 deletions(-)

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
index 5a5a654..ba1bd38 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -47,7 +47,8 @@ extern void swiotlb_tbl_unmap_single(struct device *hwdev,
 				     phys_addr_t dma_addr,
 				     size_t size, enum dma_data_direction dir);
 
-extern void swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr,
+extern void swiotlb_tbl_sync_single(struct device *hwdev,
+				    phys_addr_t dma_addr,
 				    size_t size, enum dma_data_direction dir,
 				    enum dma_sync_target target);
 
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 41e1d9a..7cfe850 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -552,12 +552,11 @@ void swiotlb_tbl_unmap_single(struct device *hwdev, phys_addr_t dma_addr,
 }
 EXPORT_SYMBOL_GPL(swiotlb_tbl_unmap_single);
 
-void
-swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr, size_t size,
-			enum dma_data_direction dir,
-			enum dma_sync_target target)
+void swiotlb_tbl_sync_single(struct device *hwdev, phys_addr_t dma_addr,
+			     size_t size, enum dma_data_direction dir,
+			     enum dma_sync_target target)
 {
-	int index = (dma_addr - (char *)phys_to_virt(io_tlb_start)) >> IO_TLB_SHIFT;
+	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
 	phys_addr_t phys = io_tlb_orig_addr[index];
 
 	phys += ((unsigned long)dma_addr & ((1 << IO_TLB_SHIFT) - 1));
@@ -565,13 +564,15 @@ swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr, size_t size,
 	switch (target) {
 	case SYNC_FOR_CPU:
 		if (likely(dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL))
-			swiotlb_bounce(phys, dma_addr, size, DMA_FROM_DEVICE);
+			swiotlb_bounce(phys, phys_to_virt(dma_addr),
+				       size, DMA_FROM_DEVICE);
 		else
 			BUG_ON(dir != DMA_TO_DEVICE);
 		break;
 	case SYNC_FOR_DEVICE:
 		if (likely(dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
-			swiotlb_bounce(phys, dma_addr, size, DMA_TO_DEVICE);
+			swiotlb_bounce(phys, phys_to_virt(dma_addr),
+				       size, DMA_TO_DEVICE);
 		else
 			BUG_ON(dir != DMA_FROM_DEVICE);
 		break;
@@ -780,8 +781,7 @@ swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 	BUG_ON(dir == DMA_NONE);
 
 	if (is_swiotlb_buffer(paddr)) {
-		swiotlb_tbl_sync_single(hwdev, phys_to_virt(paddr), size, dir,
-				       target);
+		swiotlb_tbl_sync_single(hwdev, paddr, size, dir, target);
 		return;
 	}
 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab2JORUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:20:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:63481 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095Ab2JORT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:19:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,588,1344236400"; 
   d="scan'208";a="234137891"
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH v3 7/7] swiotlb: Do not export swiotlb_bounce since there are
	no external consumers
To: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, akpm@linux-foundation.org,
        joerg.roedel@amd.com, bhelgaas@google.com, shuahkhan@gmail.com,
        fujita.tomonori@lab.ntt.co.jp
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Date: Mon, 15 Oct 2012 10:19:55 -0700
Message-ID: <20121015171955.25171.81915.stgit@gitlad.jf.intel.com>
In-Reply-To: <20121015171707.25171.35294.stgit@gitlad.jf.intel.com>
References: <20121015171707.25171.35294.stgit@gitlad.jf.intel.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently swiotlb is the only consumer for swiotlb_bounce.  Since that is the
case it doesn't make much sense to be exporting it so make it a static
function only.

In addition we can save a few more lines of code by making it so that it
accepts the DMA address as a physical address instead of a virtual one.  This
is the last piece in essentially pushing all of the DMA address values to use
physical addresses in swiotlb.

In order to clarify things since we now have 2 physical addresses in use
inside of swiotlb_bounce I am renaming phys to orig_addr, and dma_addr to
tlb_addr.  This way is should be clear that orig_addr is contained within
io_orig_addr and tlb_addr is an address within the io_tlb_addr buffer.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---

 include/linux/swiotlb.h |    3 ---
 lib/swiotlb.c           |   35 ++++++++++++++++-------------------
 2 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index e0ac98f..071d62c 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -53,9 +53,6 @@ extern void swiotlb_tbl_sync_single(struct device *hwdev,
 				    enum dma_sync_target target);
 
 /* Accessory functions. */
-extern void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
-			   enum dma_data_direction dir);
-
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			dma_addr_t *dma_handle, gfp_t flags);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 16a548d..196b069 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -355,14 +355,15 @@ static int is_swiotlb_buffer(phys_addr_t paddr)
 /*
  * Bounce: copy the swiotlb buffer back to the original dma location
  */
-void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
-		    enum dma_data_direction dir)
+static void swiotlb_bounce(phys_addr_t orig_addr, phys_addr_t tlb_addr,
+			   size_t size, enum dma_data_direction dir)
 {
-	unsigned long pfn = PFN_DOWN(phys);
+	unsigned long pfn = PFN_DOWN(orig_addr);
+	unsigned char *vaddr = phys_to_virt(tlb_addr);
 
 	if (PageHighMem(pfn_to_page(pfn))) {
 		/* The buffer does not have a mapping.  Map it in and copy */
-		unsigned int offset = phys & ~PAGE_MASK;
+		unsigned int offset = orig_addr & ~PAGE_MASK;
 		char *buffer;
 		unsigned int sz = 0;
 		unsigned long flags;
@@ -373,25 +374,23 @@ void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 			local_irq_save(flags);
 			buffer = kmap_atomic(pfn_to_page(pfn));
 			if (dir == DMA_TO_DEVICE)
-				memcpy(dma_addr, buffer + offset, sz);
+				memcpy(vaddr, buffer + offset, sz);
 			else
-				memcpy(buffer + offset, dma_addr, sz);
+				memcpy(buffer + offset, vaddr, sz);
 			kunmap_atomic(buffer);
 			local_irq_restore(flags);
 
 			size -= sz;
 			pfn++;
-			dma_addr += sz;
+			vaddr += sz;
 			offset = 0;
 		}
+	} else if (dir == DMA_TO_DEVICE) {
+		memcpy(vaddr, phys_to_virt(orig_addr), size);
 	} else {
-		if (dir == DMA_TO_DEVICE)
-			memcpy(dma_addr, phys_to_virt(phys), size);
-		else
-			memcpy(phys_to_virt(phys), dma_addr, size);
+		memcpy(phys_to_virt(orig_addr), vaddr, size);
 	}
 }
-EXPORT_SYMBOL_GPL(swiotlb_bounce);
 
 phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
 				   dma_addr_t tbl_dma_addr,
@@ -493,8 +492,7 @@ found:
 	for (i = 0; i < nslots; i++)
 		io_tlb_orig_addr[index+i] = orig_addr + (i << IO_TLB_SHIFT);
 	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
-		swiotlb_bounce(orig_addr, phys_to_virt(tlb_addr), size,
-			       DMA_TO_DEVICE);
+		swiotlb_bounce(orig_addr, tlb_addr, size, DMA_TO_DEVICE);
 
 	return tlb_addr;
 }
@@ -526,9 +524,8 @@ void swiotlb_tbl_unmap_single(struct device *hwdev, phys_addr_t tlb_addr,
 	/*
 	 * First, sync the memory before unmapping the entry
 	 */
-	if (phys && ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL)))
-		swiotlb_bounce(orig_addr, phys_to_virt(tlb_addr),
-			       size, DMA_FROM_DEVICE);
+	if (orig_addr && ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL)))
+		swiotlb_bounce(orig_addr, tlb_addr, size, DMA_FROM_DEVICE);
 
 	/*
 	 * Return the buffer to the free list by setting the corresponding
@@ -569,14 +566,14 @@ void swiotlb_tbl_sync_single(struct device *hwdev, phys_addr_t tlb_addr,
 	switch (target) {
 	case SYNC_FOR_CPU:
 		if (likely(dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL))
-			swiotlb_bounce(orig_addr, phys_to_virt(tlb_addr),
+			swiotlb_bounce(orig_addr, tlb_addr,
 				       size, DMA_FROM_DEVICE);
 		else
 			BUG_ON(dir != DMA_TO_DEVICE);
 		break;
 	case SYNC_FOR_DEVICE:
 		if (likely(dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
-			swiotlb_bounce(orig_addr, phys_to_virt(tlb_addr),
+			swiotlb_bounce(orig_addr, tlb_addr,
 				       size, DMA_TO_DEVICE);
 		else
 			BUG_ON(dir != DMA_FROM_DEVICE);


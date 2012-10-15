Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab2JORT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:19:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:1713 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab2JORTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:19:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,588,1344236400"; 
   d="scan'208";a="204674428"
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH v3 3/7] swiotlb: Make io_tlb_overflow_buffer a physical address
To: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, akpm@linux-foundation.org,
        joerg.roedel@amd.com, bhelgaas@google.com, shuahkhan@gmail.com,
        fujita.tomonori@lab.ntt.co.jp
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Date: Mon, 15 Oct 2012 10:19:34 -0700
Message-ID: <20121015171933.25171.78413.stgit@gitlad.jf.intel.com>
In-Reply-To: <20121015171707.25171.35294.stgit@gitlad.jf.intel.com>
References: <20121015171707.25171.35294.stgit@gitlad.jf.intel.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change makes it so that we can avoid virt_to_phys overhead when using the
io_tlb_overflow_buffer.  My original plan was to completely remove the value
and replace it with a constant but I had seen that there were recent patches
that stated this couldn't be done until all device drivers that depended on
that functionality be updated.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---

 lib/swiotlb.c |   61 ++++++++++++++++++++++++++++++++-------------------------
 1 files changed, 34 insertions(+), 27 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 8c4791f..f8c0d4e 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -70,7 +70,7 @@ static unsigned long io_tlb_nslabs;
  */
 static unsigned long io_tlb_overflow = 32*1024;
 
-static void *io_tlb_overflow_buffer;
+static phys_addr_t io_tlb_overflow_buffer;
 
 /*
  * This is a free list describing the number of free entries available from
@@ -138,6 +138,7 @@ void swiotlb_print_info(void)
 
 void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
 {
+	void *v_overflow_buffer;
 	unsigned long i, bytes;
 
 	bytes = nslabs << IO_TLB_SHIFT;
@@ -147,6 +148,15 @@ void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
 	io_tlb_end = io_tlb_start + bytes;
 
 	/*
+	 * Get the overflow emergency buffer
+	 */
+	v_overflow_buffer = alloc_bootmem_low_pages(PAGE_ALIGN(io_tlb_overflow));
+	if (!v_overflow_buffer)
+		panic("Cannot allocate SWIOTLB overflow buffer!\n");
+
+	io_tlb_overflow_buffer = __pa(v_overflow_buffer);
+
+	/*
 	 * Allocate and initialize the free list array.  This array is used
 	 * to find contiguous free memory regions of size up to IO_TLB_SEGSIZE
 	 * between io_tlb_start and io_tlb_end.
@@ -157,12 +167,6 @@ void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
 	io_tlb_index = 0;
 	io_tlb_orig_addr = alloc_bootmem_pages(PAGE_ALIGN(io_tlb_nslabs * sizeof(phys_addr_t)));
 
-	/*
-	 * Get the overflow emergency buffer
-	 */
-	io_tlb_overflow_buffer = alloc_bootmem_low_pages(PAGE_ALIGN(io_tlb_overflow));
-	if (!io_tlb_overflow_buffer)
-		panic("Cannot allocate SWIOTLB overflow buffer!\n");
 	if (verbose)
 		swiotlb_print_info();
 }
@@ -252,6 +256,7 @@ int
 swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
 {
 	unsigned long i, bytes;
+	unsigned char *v_overflow_buffer;
 
 	bytes = nslabs << IO_TLB_SHIFT;
 
@@ -262,6 +267,16 @@ swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
 	memset(tlb, 0, bytes);
 
 	/*
+	 * Get the overflow emergency buffer
+	 */
+	v_overflow_buffer = (void *)__get_free_pages(GFP_DMA,
+						     get_order(io_tlb_overflow));
+	if (!v_overflow_buffer)
+		goto cleanup2;
+
+	io_tlb_overflow_buffer = virt_to_phys(v_overflow_buffer);
+
+	/*
 	 * Allocate and initialize the free list array.  This array is used
 	 * to find contiguous free memory regions of size up to IO_TLB_SEGSIZE
 	 * between io_tlb_start and io_tlb_end.
@@ -269,7 +284,7 @@ swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
 	io_tlb_list = (unsigned int *)__get_free_pages(GFP_KERNEL,
 	                              get_order(io_tlb_nslabs * sizeof(int)));
 	if (!io_tlb_list)
-		goto cleanup2;
+		goto cleanup3;
 
 	for (i = 0; i < io_tlb_nslabs; i++)
  		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
@@ -280,18 +295,10 @@ swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
 				 get_order(io_tlb_nslabs *
 					   sizeof(phys_addr_t)));
 	if (!io_tlb_orig_addr)
-		goto cleanup3;
+		goto cleanup4;
 
 	memset(io_tlb_orig_addr, 0, io_tlb_nslabs * sizeof(phys_addr_t));
 
-	/*
-	 * Get the overflow emergency buffer
-	 */
-	io_tlb_overflow_buffer = (void *)__get_free_pages(GFP_DMA,
-	                                          get_order(io_tlb_overflow));
-	if (!io_tlb_overflow_buffer)
-		goto cleanup4;
-
 	swiotlb_print_info();
 
 	late_alloc = 1;
@@ -299,13 +306,13 @@ swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
 	return 0;
 
 cleanup4:
-	free_pages((unsigned long)io_tlb_orig_addr,
-		   get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
-	io_tlb_orig_addr = NULL;
-cleanup3:
 	free_pages((unsigned long)io_tlb_list, get_order(io_tlb_nslabs *
 	                                                 sizeof(int)));
 	io_tlb_list = NULL;
+cleanup3:
+	free_pages((unsigned long)v_overflow_buffer,
+		   get_order(io_tlb_overflow));
+	io_tlb_overflow_buffer = 0;
 cleanup2:
 	io_tlb_end = 0;
 	io_tlb_start = 0;
@@ -315,11 +322,11 @@ cleanup2:
 
 void __init swiotlb_free(void)
 {
-	if (!io_tlb_overflow_buffer)
+	if (!io_tlb_orig_addr)
 		return;
 
 	if (late_alloc) {
-		free_pages((unsigned long)io_tlb_overflow_buffer,
+		free_pages((unsigned long)phys_to_virt(io_tlb_overflow_buffer),
 			   get_order(io_tlb_overflow));
 		free_pages((unsigned long)io_tlb_orig_addr,
 			   get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
@@ -328,7 +335,7 @@ void __init swiotlb_free(void)
 		free_pages((unsigned long)phys_to_virt(io_tlb_start),
 			   get_order(io_tlb_nslabs << IO_TLB_SHIFT));
 	} else {
-		free_bootmem_late(__pa(io_tlb_overflow_buffer),
+		free_bootmem_late(io_tlb_overflow_buffer,
 				  PAGE_ALIGN(io_tlb_overflow));
 		free_bootmem_late(__pa(io_tlb_orig_addr),
 				  PAGE_ALIGN(io_tlb_nslabs * sizeof(phys_addr_t)));
@@ -698,7 +705,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	map = map_single(dev, phys, size, dir);
 	if (!map) {
 		swiotlb_full(dev, size, dir, 1);
-		map = io_tlb_overflow_buffer;
+		return phys_to_dma(dev, io_tlb_overflow_buffer);
 	}
 
 	dev_addr = swiotlb_virt_to_bus(dev, map);
@@ -708,7 +715,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	 */
 	if (!dma_capable(dev, dev_addr, size)) {
 		swiotlb_tbl_unmap_single(dev, map, size, dir);
-		dev_addr = swiotlb_virt_to_bus(dev, io_tlb_overflow_buffer);
+		return phys_to_dma(dev, io_tlb_overflow_buffer);
 	}
 
 	return dev_addr;
@@ -927,7 +934,7 @@ EXPORT_SYMBOL(swiotlb_sync_sg_for_device);
 int
 swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
 {
-	return (dma_addr == swiotlb_virt_to_bus(hwdev, io_tlb_overflow_buffer));
+	return (dma_addr == phys_to_dma(hwdev, io_tlb_overflow_buffer));
 }
 EXPORT_SYMBOL(swiotlb_dma_mapping_error);
 


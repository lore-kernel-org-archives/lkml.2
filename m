Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab0IWWro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:47:44 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5666 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab0IWWrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:47:43 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@elte.hu>,
        Andre Goddard Rosa <andre.goddard@gmail.com>
Subject: [PATCH 7/9] swiotlb: Make bounce buffer bounds non-static.
Date: Thu, 23 Sep 2010 15:47:31 -0700
Message-Id: <1285282051-24907-2-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com>
References: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 23 Sep 2010 22:47:43.0150 (UTC) FILETIME=[5558B4E0:01CB5B71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Octeon PCI mapping has to be established to cover the bounce buffers,
so it has to have access to the bounds.

Rename the bounds variables to match the names of other parts of swiotlb.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andre Goddard Rosa <andre.goddard@gmail.com>
---
 include/linux/swiotlb.h |    6 ++++
 lib/swiotlb.c           |   62 +++++++++++++++++++++++-----------------------
 2 files changed, 37 insertions(+), 31 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index dba51fe..0b8fbe9 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -22,6 +22,12 @@ extern int swiotlb_force;
  */
 #define IO_TLB_SHIFT 11
 
+/*
+ * The memory range used by the swiotlb
+ */
+extern char *swiotlb_start;
+extern char *swiotlb_end;
+
 extern void swiotlb_init(int verbose);
 extern void swiotlb_init_with_default_size(size_t, int);
 extern void swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 34e3082..4cb4ad7 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -57,11 +57,11 @@ int swiotlb_force;
  * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
  * API.
  */
-static char *io_tlb_start, *io_tlb_end;
+char *swiotlb_start, *swiotlb_end;
 
 /*
- * The number of IO TLB blocks (in groups of 64) betweeen io_tlb_start and
- * io_tlb_end.  This is command line adjustable via setup_io_tlb_npages.
+ * The number of IO TLB blocks (in groups of 64) betweeen swiotlb_start and
+ * swiotlb_end.  This is command line adjustable via setup_io_tlb_npages.
  */
 static unsigned long io_tlb_nslabs;
 
@@ -122,11 +122,11 @@ void swiotlb_print_info(void)
 	unsigned long bytes = io_tlb_nslabs << IO_TLB_SHIFT;
 	phys_addr_t pstart, pend;
 
-	pstart = virt_to_phys(io_tlb_start);
-	pend = virt_to_phys(io_tlb_end);
+	pstart = virt_to_phys(swiotlb_start);
+	pend = virt_to_phys(swiotlb_end);
 
 	printk(KERN_INFO "Placing %luMB software IO TLB between %p - %p\n",
-	       bytes >> 20, io_tlb_start, io_tlb_end);
+	       bytes >> 20, swiotlb_start, swiotlb_end);
 	printk(KERN_INFO "software IO TLB at phys %#llx - %#llx\n",
 	       (unsigned long long)pstart,
 	       (unsigned long long)pend);
@@ -139,13 +139,13 @@ void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
 	bytes = nslabs << IO_TLB_SHIFT;
 
 	io_tlb_nslabs = nslabs;
-	io_tlb_start = tlb;
-	io_tlb_end = io_tlb_start + bytes;
+	swiotlb_start = tlb;
+	swiotlb_end = swiotlb_start + bytes;
 
 	/*
 	 * Allocate and initialize the free list array.  This array is used
 	 * to find contiguous free memory regions of size up to IO_TLB_SEGSIZE
-	 * between io_tlb_start and io_tlb_end.
+	 * between swiotlb_start and swiotlb_end.
 	 */
 	io_tlb_list = alloc_bootmem(io_tlb_nslabs * sizeof(int));
 	for (i = 0; i < io_tlb_nslabs; i++)
@@ -182,11 +182,11 @@ swiotlb_init_with_default_size(size_t default_size, int verbose)
 	/*
 	 * Get IO TLB memory from the low pages
 	 */
-	io_tlb_start = alloc_bootmem_low_pages(bytes);
-	if (!io_tlb_start)
+	swiotlb_start = alloc_bootmem_low_pages(bytes);
+	if (!swiotlb_start)
 		panic("Cannot allocate SWIOTLB buffer");
 
-	swiotlb_init_with_tbl(io_tlb_start, io_tlb_nslabs, verbose);
+	swiotlb_init_with_tbl(swiotlb_start, io_tlb_nslabs, verbose);
 }
 
 void __init
@@ -219,14 +219,14 @@ swiotlb_late_init_with_default_size(size_t default_size)
 	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
 
 	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
-		io_tlb_start = (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
-							order);
-		if (io_tlb_start)
+		swiotlb_start =
+			(void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
+		if (swiotlb_start)
 			break;
 		order--;
 	}
 
-	if (!io_tlb_start)
+	if (!swiotlb_start)
 		goto cleanup1;
 
 	if (order != get_order(bytes)) {
@@ -235,13 +235,13 @@ swiotlb_late_init_with_default_size(size_t default_size)
 		io_tlb_nslabs = SLABS_PER_PAGE << order;
 		bytes = io_tlb_nslabs << IO_TLB_SHIFT;
 	}
-	io_tlb_end = io_tlb_start + bytes;
-	memset(io_tlb_start, 0, bytes);
+	swiotlb_end = swiotlb_start + bytes;
+	memset(swiotlb_start, 0, bytes);
 
 	/*
 	 * Allocate and initialize the free list array.  This array is used
 	 * to find contiguous free memory regions of size up to IO_TLB_SEGSIZE
-	 * between io_tlb_start and io_tlb_end.
+	 * between swiotlb_start and swiotlb_end.
 	 */
 	io_tlb_list = (unsigned int *)__get_free_pages(GFP_KERNEL,
 	                              get_order(io_tlb_nslabs * sizeof(int)));
@@ -284,9 +284,9 @@ cleanup3:
 	                                                 sizeof(int)));
 	io_tlb_list = NULL;
 cleanup2:
-	io_tlb_end = NULL;
-	free_pages((unsigned long)io_tlb_start, order);
-	io_tlb_start = NULL;
+	swiotlb_end = NULL;
+	free_pages((unsigned long)swiotlb_start, order);
+	swiotlb_start = NULL;
 cleanup1:
 	io_tlb_nslabs = req_nslabs;
 	return -ENOMEM;
@@ -304,7 +304,7 @@ void __init swiotlb_free(void)
 			   get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
 		free_pages((unsigned long)io_tlb_list, get_order(io_tlb_nslabs *
 								 sizeof(int)));
-		free_pages((unsigned long)io_tlb_start,
+		free_pages((unsigned long)swiotlb_start,
 			   get_order(io_tlb_nslabs << IO_TLB_SHIFT));
 	} else {
 		free_bootmem_late(__pa(io_tlb_overflow_buffer),
@@ -313,15 +313,15 @@ void __init swiotlb_free(void)
 				  io_tlb_nslabs * sizeof(phys_addr_t));
 		free_bootmem_late(__pa(io_tlb_list),
 				  io_tlb_nslabs * sizeof(int));
-		free_bootmem_late(__pa(io_tlb_start),
+		free_bootmem_late(__pa(swiotlb_start),
 				  io_tlb_nslabs << IO_TLB_SHIFT);
 	}
 }
 
 static int is_swiotlb_buffer(phys_addr_t paddr)
 {
-	return paddr >= virt_to_phys(io_tlb_start) &&
-		paddr < virt_to_phys(io_tlb_end);
+	return paddr >= virt_to_phys(swiotlb_start) &&
+		paddr < virt_to_phys(swiotlb_end);
 }
 
 /*
@@ -435,7 +435,7 @@ void *swiotlb_tbl_map_single(struct device *hwdev, dma_addr_t tbl_dma_addr,
 				io_tlb_list[i] = 0;
 			for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE) != IO_TLB_SEGSIZE - 1) && io_tlb_list[i]; i--)
 				io_tlb_list[i] = ++count;
-			dma_addr = io_tlb_start + (index << IO_TLB_SHIFT);
+			dma_addr = swiotlb_start + (index << IO_TLB_SHIFT);
 
 			/*
 			 * Update the indices to avoid searching in the next
@@ -479,7 +479,7 @@ static void *
 map_single(struct device *hwdev, phys_addr_t phys, size_t size,
 	   enum dma_data_direction dir)
 {
-	dma_addr_t start_dma_addr = swiotlb_virt_to_bus(hwdev, io_tlb_start);
+	dma_addr_t start_dma_addr = swiotlb_virt_to_bus(hwdev, swiotlb_start);
 
 	return swiotlb_tbl_map_single(hwdev, start_dma_addr, phys, size, dir);
 }
@@ -493,7 +493,7 @@ swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
 {
 	unsigned long flags;
 	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
-	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
+	int index = (dma_addr - swiotlb_start) >> IO_TLB_SHIFT;
 	phys_addr_t phys = io_tlb_orig_addr[index];
 
 	/*
@@ -534,7 +534,7 @@ swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr, size_t size,
 			enum dma_data_direction dir,
 			enum dma_sync_target target)
 {
-	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
+	int index = (dma_addr - swiotlb_start) >> IO_TLB_SHIFT;
 	phys_addr_t phys = io_tlb_orig_addr[index];
 
 	phys += ((unsigned long)dma_addr & ((1 << IO_TLB_SHIFT) - 1));
@@ -918,6 +918,6 @@ EXPORT_SYMBOL(swiotlb_dma_mapping_error);
 int
 swiotlb_dma_supported(struct device *hwdev, u64 mask)
 {
-	return swiotlb_virt_to_bus(hwdev, io_tlb_end - 1) <= mask;
+	return swiotlb_virt_to_bus(hwdev, swiotlb_end - 1) <= mask;
 }
 EXPORT_SYMBOL(swiotlb_dma_supported);
-- 
1.7.2.2


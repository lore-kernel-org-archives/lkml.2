Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab0CSPik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:38:40 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:19789 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab0CSPii (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 19 Mar 2010 11:38:38 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es
Cc: chrisw@sous-sol.org, jeremy@goop.org, Ian.Campbell@eu.citrix.com,
       dwmw2@infradead.org, alex.williamson@hp.com,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/5] swiotlb: Make all bookkeeping functions and variables have same prefix.
Date: Fri, 19 Mar 2010 11:04:20 -0400
Message-Id: <1269011062-25915-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1269011062-25915-3-git-send-email-konrad.wilk@oracle.com>
References: <1269011062-25915-1-git-send-email-konrad.wilk@oracle.com>
 <1269011062-25915-2-git-send-email-konrad.wilk@oracle.com>
 <1269011062-25915-3-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BA39997.0119:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We prefix all book keeping functions and variables with the
'swiotlb_bk' prefix.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb.c |  247 +++++++++++++++++++++++++++++----------------------------
 1 files changed, 126 insertions(+), 121 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 5a7d73b..3926c14 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -64,38 +64,38 @@ int swiotlb_force;
  * swiotlb_bk_sync_single_*, to see if the memory was in fact allocated by this
  * API.
  */
-static char *io_tlb_start, *io_tlb_end;
+static char *swiotlb_bk_start, *swiotlb_bk_end;
 
 /*
- * The number of IO TLB blocks (in groups of 64) betweeen io_tlb_start and
- * io_tlb_end.  This is command line adjustable via setup_io_tlb_npages.
+ * The number of IO TLB blocks (in groups of 64) betweeen swiotlb_bk_start and
+ * swiotlb_bk_end.  This is command line adjustable via setup_io_tlb_npages.
  */
-static unsigned long io_tlb_nslabs;
+static unsigned long swiotlb_bk_nslabs;
 
 /*
  * When the IOMMU overflows we return a fallback buffer. This sets the size.
  */
-static unsigned long io_tlb_overflow = 32*1024;
+static unsigned long swiotlb_bk_overflow = 32*1024;
 
-void *io_tlb_overflow_buffer;
+void *swiotlb_bk_overflow_buffer;
 
 /*
  * This is a free list describing the number of free entries available from
  * each index
  */
-static unsigned int *io_tlb_list;
-static unsigned int io_tlb_index;
+static unsigned int *swiotlb_bk_list;
+static unsigned int swiotlb_bk_index;
 
 /*
  * We need to save away the original address corresponding to a mapped entry
  * for the sync operations.
  */
-static phys_addr_t *io_tlb_orig_addr;
+static phys_addr_t *swiotlb_bk_orig_addr;
 
 /*
  * Protect the above data structures in the map and unmap calls
  */
-static DEFINE_SPINLOCK(io_tlb_lock);
+static DEFINE_SPINLOCK(swiotlb_bk_lock);
 
 static int late_alloc;
 
@@ -103,9 +103,9 @@ static int __init
 setup_io_tlb_npages(char *str)
 {
 	if (isdigit(*str)) {
-		io_tlb_nslabs = simple_strtoul(str, &str, 0);
+		swiotlb_bk_nslabs = simple_strtoul(str, &str, 0);
 		/* avoid tail segment of size < IO_TLB_SEGSIZE */
-		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
+		swiotlb_bk_nslabs = ALIGN(swiotlb_bk_nslabs, IO_TLB_SEGSIZE);
 	}
 	if (*str == ',')
 		++str;
@@ -115,7 +115,7 @@ setup_io_tlb_npages(char *str)
 	return 1;
 }
 __setup("swiotlb=", setup_io_tlb_npages);
-/* make io_tlb_overflow tunable too? */
+/* make swiotlb_bk_overflow tunable too? */
 
 /* Note that this doesn't work with highmem page */
 static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
@@ -126,14 +126,14 @@ static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
 
 void swiotlb_print_info(void)
 {
-	unsigned long bytes = io_tlb_nslabs << IO_TLB_SHIFT;
+	unsigned long bytes = swiotlb_bk_nslabs << IO_TLB_SHIFT;
 	phys_addr_t pstart, pend;
 
-	pstart = virt_to_phys(io_tlb_start);
-	pend = virt_to_phys(io_tlb_end);
+	pstart = virt_to_phys(swiotlb_bk_start);
+	pend = virt_to_phys(swiotlb_bk_end);
 
 	printk(KERN_INFO "Placing %luMB software IO TLB between %p - %p\n",
-	       bytes >> 20, io_tlb_start, io_tlb_end);
+	       bytes >> 20, swiotlb_bk_start, swiotlb_bk_end);
 	printk(KERN_INFO "software IO TLB at phys %#llx - %#llx\n",
 	       (unsigned long long)pstart,
 	       (unsigned long long)pend);
@@ -148,37 +148,38 @@ swiotlb_init_with_default_size(size_t default_size, int verbose)
 {
 	unsigned long i, bytes;
 
-	if (!io_tlb_nslabs) {
-		io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
-		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
+	if (!swiotlb_bk_nslabs) {
+		swiotlb_bk_nslabs = (default_size >> IO_TLB_SHIFT);
+		swiotlb_bk_nslabs = ALIGN(swiotlb_bk_nslabs, IO_TLB_SEGSIZE);
 	}
 
-	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
+	bytes = swiotlb_bk_nslabs << IO_TLB_SHIFT;
 
 	/*
 	 * Get IO TLB memory from the low pages
 	 */
-	io_tlb_start = alloc_bootmem_low_pages(bytes);
-	if (!io_tlb_start)
+	swiotlb_bk_start = alloc_bootmem_low_pages(bytes);
+	if (!swiotlb_bk_start)
 		panic("Cannot allocate SWIOTLB buffer");
-	io_tlb_end = io_tlb_start + bytes;
+	swiotlb_bk_end = swiotlb_bk_start + bytes;
 
 	/*
 	 * Allocate and initialize the free list array.  This array is used
 	 * to find contiguous free memory regions of size up to IO_TLB_SEGSIZE
-	 * between io_tlb_start and io_tlb_end.
+	 * between swiotlb_bk_start and swiotlb_bk_end.
 	 */
-	io_tlb_list = alloc_bootmem(io_tlb_nslabs * sizeof(int));
-	for (i = 0; i < io_tlb_nslabs; i++)
- 		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
-	io_tlb_index = 0;
-	io_tlb_orig_addr = alloc_bootmem(io_tlb_nslabs * sizeof(phys_addr_t));
+	swiotlb_bk_list = alloc_bootmem(swiotlb_bk_nslabs * sizeof(int));
+	for (i = 0; i < swiotlb_bk_nslabs; i++)
+		swiotlb_bk_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
+	swiotlb_bk_index = 0;
+	swiotlb_bk_orig_addr = alloc_bootmem(swiotlb_bk_nslabs *
+					     sizeof(phys_addr_t));
 
 	/*
 	 * Get the overflow emergency buffer
 	 */
-	io_tlb_overflow_buffer = alloc_bootmem_low(io_tlb_overflow);
-	if (!io_tlb_overflow_buffer)
+	swiotlb_bk_overflow_buffer = alloc_bootmem_low(swiotlb_bk_overflow);
+	if (!swiotlb_bk_overflow_buffer)
 		panic("Cannot allocate SWIOTLB overflow buffer!\n");
 	if (verbose)
 		swiotlb_print_info();
@@ -198,70 +199,71 @@ swiotlb_init(int verbose)
 int
 swiotlb_late_init_with_default_size(size_t default_size)
 {
-	unsigned long i, bytes, req_nslabs = io_tlb_nslabs;
+	unsigned long i, bytes, req_nslabs = swiotlb_bk_nslabs;
 	unsigned int order;
 
-	if (!io_tlb_nslabs) {
-		io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
-		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
+	if (!swiotlb_bk_nslabs) {
+		swiotlb_bk_nslabs = (default_size >> IO_TLB_SHIFT);
+		swiotlb_bk_nslabs = ALIGN(swiotlb_bk_nslabs, IO_TLB_SEGSIZE);
 	}
 
 	/*
 	 * Get IO TLB memory from the low pages
 	 */
-	order = get_order(io_tlb_nslabs << IO_TLB_SHIFT);
-	io_tlb_nslabs = SLABS_PER_PAGE << order;
-	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
+	order = get_order(swiotlb_bk_nslabs << IO_TLB_SHIFT);
+	swiotlb_bk_nslabs = SLABS_PER_PAGE << order;
+	bytes = swiotlb_bk_nslabs << IO_TLB_SHIFT;
 
 	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
-		io_tlb_start = (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
+		swiotlb_bk_start = (void *)__get_free_pages(GFP_DMA |
+							__GFP_NOWARN,
 							order);
-		if (io_tlb_start)
+		if (swiotlb_bk_start)
 			break;
 		order--;
 	}
 
-	if (!io_tlb_start)
+	if (!swiotlb_bk_start)
 		goto cleanup1;
 
 	if (order != get_order(bytes)) {
 		printk(KERN_WARNING "Warning: only able to allocate %ld MB "
 		       "for software IO TLB\n", (PAGE_SIZE << order) >> 20);
-		io_tlb_nslabs = SLABS_PER_PAGE << order;
-		bytes = io_tlb_nslabs << IO_TLB_SHIFT;
+		swiotlb_bk_nslabs = SLABS_PER_PAGE << order;
+		bytes = swiotlb_bk_nslabs << IO_TLB_SHIFT;
 	}
-	io_tlb_end = io_tlb_start + bytes;
-	memset(io_tlb_start, 0, bytes);
+	swiotlb_bk_end = swiotlb_bk_start + bytes;
+	memset(swiotlb_bk_start, 0, bytes);
 
 	/*
 	 * Allocate and initialize the free list array.  This array is used
 	 * to find contiguous free memory regions of size up to IO_TLB_SEGSIZE
-	 * between io_tlb_start and io_tlb_end.
+	 * between swiotlb_bk_start and swiotlb_bk_end.
 	 */
-	io_tlb_list = (unsigned int *)__get_free_pages(GFP_KERNEL,
-	                              get_order(io_tlb_nslabs * sizeof(int)));
-	if (!io_tlb_list)
+	swiotlb_bk_list = (unsigned int *)__get_free_pages(GFP_KERNEL,
+				get_order(swiotlb_bk_nslabs * sizeof(int)));
+	if (!swiotlb_bk_list)
 		goto cleanup2;
 
-	for (i = 0; i < io_tlb_nslabs; i++)
- 		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
-	io_tlb_index = 0;
+	for (i = 0; i < swiotlb_bk_nslabs; i++)
+		swiotlb_bk_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
+	swiotlb_bk_index = 0;
 
-	io_tlb_orig_addr = (phys_addr_t *)
-		__get_free_pages(GFP_KERNEL,
-				 get_order(io_tlb_nslabs *
-					   sizeof(phys_addr_t)));
-	if (!io_tlb_orig_addr)
+	swiotlb_bk_orig_addr = (phys_addr_t *)__get_free_pages(GFP_KERNEL,
+						get_order(swiotlb_bk_nslabs *
+						  sizeof(phys_addr_t)));
+	if (!swiotlb_bk_orig_addr)
 		goto cleanup3;
 
-	memset(io_tlb_orig_addr, 0, io_tlb_nslabs * sizeof(phys_addr_t));
+	memset(swiotlb_bk_orig_addr, 0, swiotlb_bk_nslabs *
+					sizeof(phys_addr_t));
 
 	/*
 	 * Get the overflow emergency buffer
 	 */
-	io_tlb_overflow_buffer = (void *)__get_free_pages(GFP_DMA,
-	                                          get_order(io_tlb_overflow));
-	if (!io_tlb_overflow_buffer)
+	swiotlb_bk_overflow_buffer = (void *)__get_free_pages(GFP_DMA,
+					  get_order(swiotlb_bk_overflow));
+	if (!swiotlb_bk_overflow_buffer)
 		goto cleanup4;
 
 	swiotlb_print_info();
@@ -271,52 +273,52 @@ swiotlb_late_init_with_default_size(size_t default_size)
 	return 0;
 
 cleanup4:
-	free_pages((unsigned long)io_tlb_orig_addr,
-		   get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
-	io_tlb_orig_addr = NULL;
+	free_pages((unsigned long)swiotlb_bk_orig_addr,
+		   get_order(swiotlb_bk_nslabs * sizeof(phys_addr_t)));
+	swiotlb_bk_orig_addr = NULL;
 cleanup3:
-	free_pages((unsigned long)io_tlb_list, get_order(io_tlb_nslabs *
+	free_pages((unsigned long)swiotlb_bk_list, get_order(swiotlb_bk_nslabs *
 	                                                 sizeof(int)));
-	io_tlb_list = NULL;
+	swiotlb_bk_list = NULL;
 cleanup2:
-	io_tlb_end = NULL;
-	free_pages((unsigned long)io_tlb_start, order);
-	io_tlb_start = NULL;
+	swiotlb_bk_end = NULL;
+	free_pages((unsigned long)swiotlb_bk_start, order);
+	swiotlb_bk_start = NULL;
 cleanup1:
-	io_tlb_nslabs = req_nslabs;
+	swiotlb_bk_nslabs = req_nslabs;
 	return -ENOMEM;
 }
 
 void __init swiotlb_free(void)
 {
-	if (!io_tlb_overflow_buffer)
+	if (!swiotlb_bk_overflow_buffer)
 		return;
 
 	if (late_alloc) {
-		free_pages((unsigned long)io_tlb_overflow_buffer,
-			   get_order(io_tlb_overflow));
-		free_pages((unsigned long)io_tlb_orig_addr,
-			   get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
-		free_pages((unsigned long)io_tlb_list, get_order(io_tlb_nslabs *
-								 sizeof(int)));
-		free_pages((unsigned long)io_tlb_start,
-			   get_order(io_tlb_nslabs << IO_TLB_SHIFT));
+		free_pages((unsigned long)swiotlb_bk_overflow_buffer,
+			   get_order(swiotlb_bk_overflow));
+		free_pages((unsigned long)swiotlb_bk_orig_addr,
+			   get_order(swiotlb_bk_nslabs * sizeof(phys_addr_t)));
+		free_pages((unsigned long)swiotlb_bk_list,
+			   get_order(swiotlb_bk_nslabs * sizeof(int)));
+		free_pages((unsigned long)swiotlb_bk_start,
+			   get_order(swiotlb_bk_nslabs << IO_TLB_SHIFT));
 	} else {
-		free_bootmem_late(__pa(io_tlb_overflow_buffer),
-				  io_tlb_overflow);
-		free_bootmem_late(__pa(io_tlb_orig_addr),
-				  io_tlb_nslabs * sizeof(phys_addr_t));
-		free_bootmem_late(__pa(io_tlb_list),
-				  io_tlb_nslabs * sizeof(int));
-		free_bootmem_late(__pa(io_tlb_start),
-				  io_tlb_nslabs << IO_TLB_SHIFT);
+		free_bootmem_late(__pa(swiotlb_bk_overflow_buffer),
+				  swiotlb_bk_overflow);
+		free_bootmem_late(__pa(swiotlb_bk_orig_addr),
+				  swiotlb_bk_nslabs * sizeof(phys_addr_t));
+		free_bootmem_late(__pa(swiotlb_bk_list),
+				  swiotlb_bk_nslabs * sizeof(int));
+		free_bootmem_late(__pa(swiotlb_bk_start),
+				  swiotlb_bk_nslabs << IO_TLB_SHIFT);
 	}
 }
 
 static int is_swiotlb_buffer(phys_addr_t paddr)
 {
-	return paddr >= virt_to_phys(io_tlb_start) &&
-		paddr < virt_to_phys(io_tlb_end);
+	return paddr >= virt_to_phys(swiotlb_bk_start) &&
+		paddr < virt_to_phys(swiotlb_bk_end);
 }
 
 /*
@@ -402,9 +404,9 @@ swiotlb_bk_map_single(struct device *hwdev, phys_addr_t phys,
 	 * Find suitable number of IO TLB entries size that will fit this
 	 * request and allocate a buffer from that IO TLB pool.
 	 */
-	spin_lock_irqsave(&io_tlb_lock, flags);
-	index = ALIGN(io_tlb_index, stride);
-	if (index >= io_tlb_nslabs)
+	spin_lock_irqsave(&swiotlb_bk_lock, flags);
+	index = ALIGN(swiotlb_bk_index, stride);
+	if (index >= swiotlb_bk_nslabs)
 		index = 0;
 	wrap = index;
 
@@ -412,7 +414,7 @@ swiotlb_bk_map_single(struct device *hwdev, phys_addr_t phys,
 		while (iommu_is_span_boundary(index, nslots, offset_slots,
 					      max_slots)) {
 			index += stride;
-			if (index >= io_tlb_nslabs)
+			if (index >= swiotlb_bk_nslabs)
 				index = 0;
 			if (index == wrap)
 				goto not_found;
@@ -423,34 +425,35 @@ swiotlb_bk_map_single(struct device *hwdev, phys_addr_t phys,
 		 * contiguous buffers, we allocate the buffers from that slot
 		 * and mark the entries as '0' indicating unavailable.
 		 */
-		if (io_tlb_list[index] >= nslots) {
+		if (swiotlb_bk_list[index] >= nslots) {
 			int count = 0;
 
 			for (i = index; i < (int) (index + nslots); i++)
-				io_tlb_list[i] = 0;
-			for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE) != IO_TLB_SEGSIZE - 1) && io_tlb_list[i]; i--)
-				io_tlb_list[i] = ++count;
-			dma_addr = io_tlb_start + (index << IO_TLB_SHIFT);
+				swiotlb_bk_list[i] = 0;
+			for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE)
+			     != IO_TLB_SEGSIZE - 1) && swiotlb_bk_list[i]; i--)
+				swiotlb_bk_list[i] = ++count;
+			dma_addr = swiotlb_bk_start + (index << IO_TLB_SHIFT);
 
 			/*
 			 * Update the indices to avoid searching in the next
 			 * round.
 			 */
-			io_tlb_index = ((index + nslots) < io_tlb_nslabs
+			swiotlb_bk_index = ((index + nslots) < swiotlb_bk_nslabs
 					? (index + nslots) : 0);
 
 			goto found;
 		}
 		index += stride;
-		if (index >= io_tlb_nslabs)
+		if (index >= swiotlb_bk_nslabs)
 			index = 0;
 	} while (index != wrap);
 
 not_found:
-	spin_unlock_irqrestore(&io_tlb_lock, flags);
+	spin_unlock_irqrestore(&swiotlb_bk_lock, flags);
 	return NULL;
 found:
-	spin_unlock_irqrestore(&io_tlb_lock, flags);
+	spin_unlock_irqrestore(&swiotlb_bk_lock, flags);
 
 	/*
 	 * Save away the mapping from the original address to the DMA address.
@@ -458,7 +461,7 @@ found:
 	 * needed.
 	 */
 	for (i = 0; i < nslots; i++)
-		io_tlb_orig_addr[index+i] = phys + (i << IO_TLB_SHIFT);
+		swiotlb_bk_orig_addr[index+i] = phys + (i << IO_TLB_SHIFT);
 	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
 		swiotlb_bounce(phys, dma_addr, size, DMA_TO_DEVICE);
 
@@ -474,8 +477,8 @@ swiotlb_bk_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
 {
 	unsigned long flags;
 	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
-	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
-	phys_addr_t phys = io_tlb_orig_addr[index];
+	int index = (dma_addr - swiotlb_bk_start) >> IO_TLB_SHIFT;
+	phys_addr_t phys = swiotlb_bk_orig_addr[index];
 
 	/*
 	 * First, sync the memory before unmapping the entry
@@ -489,32 +492,33 @@ swiotlb_bk_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
 	 * While returning the entries to the free list, we merge the entries
 	 * with slots below and above the pool being returned.
 	 */
-	spin_lock_irqsave(&io_tlb_lock, flags);
+	spin_lock_irqsave(&swiotlb_bk_lock, flags);
 	{
 		count = ((index + nslots) < ALIGN(index + 1, IO_TLB_SEGSIZE) ?
-			 io_tlb_list[index + nslots] : 0);
+			 swiotlb_bk_list[index + nslots] : 0);
 		/*
 		 * Step 1: return the slots to the free list, merging the
 		 * slots with superceeding slots
 		 */
 		for (i = index + nslots - 1; i >= index; i--)
-			io_tlb_list[i] = ++count;
+			swiotlb_bk_list[i] = ++count;
 		/*
 		 * Step 2: merge the returned slots with the preceding slots,
 		 * if available (non zero)
 		 */
-		for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE) != IO_TLB_SEGSIZE -1) && io_tlb_list[i]; i--)
-			io_tlb_list[i] = ++count;
+		for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE)
+		     != IO_TLB_SEGSIZE - 1) && swiotlb_bk_list[i]; i--)
+			swiotlb_bk_list[i] = ++count;
 	}
-	spin_unlock_irqrestore(&io_tlb_lock, flags);
+	spin_unlock_irqrestore(&swiotlb_bk_lock, flags);
 }
 
 static void
 swiotlb_bk_sync_single(struct device *hwdev, char *dma_addr, size_t size,
 	    int dir, int target)
 {
-	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
-	phys_addr_t phys = io_tlb_orig_addr[index];
+	int index = (dma_addr - swiotlb_bk_start) >> IO_TLB_SHIFT;
+	phys_addr_t phys = swiotlb_bk_orig_addr[index];
 
 	phys += ((unsigned long)dma_addr & ((1 << IO_TLB_SHIFT) - 1));
 
@@ -563,7 +567,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		 * GFP_DMA memory; fall back on swiotlb_bk_map_single(), which
 		 * will grab memory from the lowest available address range.
 		 */
-		start_dma_addr = swiotlb_virt_to_bus(hwdev, io_tlb_start);
+		start_dma_addr = swiotlb_virt_to_bus(hwdev, swiotlb_bk_start);
 		ret = swiotlb_bk_map_single(hwdev, 0, start_dma_addr, size,
 					    DMA_FROM_DEVICE);
 		if (!ret)
@@ -616,7 +620,7 @@ swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
 	printk(KERN_ERR "DMA: Out of SW-IOMMU space for %zu bytes at "
 	       "device %s\n", size, dev ? dev_name(dev) : "?");
 
-	if (size <= io_tlb_overflow || !do_panic)
+	if (size <= swiotlb_bk_overflow || !do_panic)
 		return;
 
 	if (dir == DMA_BIDIRECTIONAL)
@@ -656,11 +660,11 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	/*
 	 * Oh well, have to allocate and map a bounce buffer.
 	 */
-	start_dma_addr = swiotlb_virt_to_bus(dev, io_tlb_start);
+	start_dma_addr = swiotlb_virt_to_bus(dev, swiotlb_bk_start);
 	map = swiotlb_bk_map_single(dev, phys, start_dma_addr, size, dir);
 	if (!map) {
 		swiotlb_full(dev, size, dir, 1);
-		map = io_tlb_overflow_buffer;
+		map = swiotlb_bk_overflow_buffer;
 	}
 
 	dev_addr = swiotlb_virt_to_bus(dev, map);
@@ -818,7 +822,7 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 
 	BUG_ON(dir == DMA_NONE);
 
-	start_dma_addr = swiotlb_virt_to_bus(hwdev, io_tlb_start);
+	start_dma_addr = swiotlb_virt_to_bus(hwdev, swiotlb_bk_start);
 	for_each_sg(sgl, sg, nelems, i) {
 		phys_addr_t paddr = sg_phys(sg);
 		dma_addr_t dev_addr = phys_to_dma(hwdev, paddr);
@@ -919,7 +923,8 @@ EXPORT_SYMBOL(swiotlb_sync_sg_for_device);
 int
 swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
 {
-	return (dma_addr == swiotlb_virt_to_bus(hwdev, io_tlb_overflow_buffer));
+	return (dma_addr == swiotlb_virt_to_bus(hwdev,
+						swiotlb_bk_overflow_buffer));
 }
 EXPORT_SYMBOL(swiotlb_dma_mapping_error);
 
@@ -932,6 +937,6 @@ EXPORT_SYMBOL(swiotlb_dma_mapping_error);
 int
 swiotlb_dma_supported(struct device *hwdev, u64 mask)
 {
-	return swiotlb_virt_to_bus(hwdev, io_tlb_end - 1) <= mask;
+	return swiotlb_virt_to_bus(hwdev, swiotlb_bk_end - 1) <= mask;
 }
 EXPORT_SYMBOL(swiotlb_dma_supported);
-- 
1.6.2.5


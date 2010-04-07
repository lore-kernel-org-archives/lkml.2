Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab0DGUb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 16:31:27 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:17507 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab0DGUbJ (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 7 Apr 2010 16:31:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       albert_herranz@yahoo.es
Cc: linux@eikelenboom.it, chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com,
       jeremy@goop.org, dwmw2@infradead.org, alex.williamson@hp.com,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/6] swiotlb: Make exportable bookkeeping functions and variables have same prefix.
Date: Wed,  7 Apr 2010 16:29:27 -0400
Message-Id: <1270672170-31833-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1270672170-31833-3-git-send-email-konrad.wilk@oracle.com>
References: <1270672170-31833-1-git-send-email-konrad.wilk@oracle.com>
 <1270672170-31833-2-git-send-email-konrad.wilk@oracle.com>
 <1270672170-31833-3-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4BBCEB49.00E3:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We prefix pertient book keeping functions and variables with the
'swiotlb_tbl' prefix.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb.c |  149 +++++++++++++++++++++++++++++---------------------------
 1 files changed, 77 insertions(+), 72 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index bc516bb..5451517 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -64,13 +64,13 @@ int swiotlb_force;
  * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
  * API.
  */
-static char *io_tlb_start, *io_tlb_end;
+static char *swiotlb_tbl_start, *io_tlb_end;
 
 /*
- * The number of IO TLB blocks (in groups of 64) betweeen io_tlb_start and
+ * The number of IO TLB blocks (in groups of 64) betweeen swiotlb_tbl_start and
  * io_tlb_end.  This is command line adjustable via setup_io_tlb_npages.
  */
-static unsigned long io_tlb_nslabs;
+static unsigned long swiotlb_tbl_nslabs;
 
 /*
  * When the IOMMU overflows we return a fallback buffer. This sets the size.
@@ -103,9 +103,9 @@ static int __init
 setup_io_tlb_npages(char *str)
 {
 	if (isdigit(*str)) {
-		io_tlb_nslabs = simple_strtoul(str, &str, 0);
+		swiotlb_tbl_nslabs = simple_strtoul(str, &str, 0);
 		/* avoid tail segment of size < IO_TLB_SEGSIZE */
-		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
+		swiotlb_tbl_nslabs = ALIGN(swiotlb_tbl_nslabs, IO_TLB_SEGSIZE);
 	}
 	if (*str == ',')
 		++str;
@@ -126,14 +126,14 @@ static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
 
 void swiotlb_print_info(void)
 {
-	unsigned long bytes = io_tlb_nslabs << IO_TLB_SHIFT;
+	unsigned long bytes = swiotlb_tbl_nslabs << IO_TLB_SHIFT;
 	phys_addr_t pstart, pend;
 
-	pstart = virt_to_phys(io_tlb_start);
+	pstart = virt_to_phys(swiotlb_tbl_start);
 	pend = virt_to_phys(io_tlb_end);
 
 	printk(KERN_INFO "Placing %luMB software IO TLB between %p - %p\n",
-	       bytes >> 20, io_tlb_start, io_tlb_end);
+	       bytes >> 20, swiotlb_tbl_start, io_tlb_end);
 	printk(KERN_INFO "software IO TLB at phys %#llx - %#llx\n",
 	       (unsigned long long)pstart,
 	       (unsigned long long)pend);
@@ -148,31 +148,32 @@ swiotlb_init_with_default_size(size_t default_size, int verbose)
 {
 	unsigned long i, bytes;
 
-	if (!io_tlb_nslabs) {
-		io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
-		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
+	if (!swiotlb_tbl_nslabs) {
+		swiotlb_tbl_nslabs = (default_size >> IO_TLB_SHIFT);
+		swiotlb_tbl_nslabs = ALIGN(swiotlb_tbl_nslabs, IO_TLB_SEGSIZE);
 	}
 
-	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
+	bytes = swiotlb_tbl_nslabs << IO_TLB_SHIFT;
 
 	/*
 	 * Get IO TLB memory from the low pages
 	 */
-	io_tlb_start = alloc_bootmem_low_pages(bytes);
-	if (!io_tlb_start)
+	swiotlb_tbl_start = alloc_bootmem_low_pages(bytes);
+	if (!swiotlb_tbl_start)
 		panic("Cannot allocate SWIOTLB buffer");
-	io_tlb_end = io_tlb_start + bytes;
+	io_tlb_end = swiotlb_tbl_start + bytes;
 
 	/*
 	 * Allocate and initialize the free list array.  This array is used
 	 * to find contiguous free memory regions of size up to IO_TLB_SEGSIZE
-	 * between io_tlb_start and io_tlb_end.
+	 * between swiotlb_tbl_start and io_tlb_end.
 	 */
-	io_tlb_list = alloc_bootmem(io_tlb_nslabs * sizeof(int));
-	for (i = 0; i < io_tlb_nslabs; i++)
- 		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
+	io_tlb_list = alloc_bootmem(swiotlb_tbl_nslabs * sizeof(int));
+	for (i = 0; i < swiotlb_tbl_nslabs; i++)
+		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
 	io_tlb_index = 0;
-	io_tlb_orig_addr = alloc_bootmem(io_tlb_nslabs * sizeof(phys_addr_t));
+	io_tlb_orig_addr = alloc_bootmem(swiotlb_tbl_nslabs *
+					     sizeof(phys_addr_t));
 
 	/*
 	 * Get the overflow emergency buffer
@@ -198,69 +199,70 @@ swiotlb_init(int verbose)
 int
 swiotlb_late_init_with_default_size(size_t default_size)
 {
-	unsigned long i, bytes, req_nslabs = io_tlb_nslabs;
+	unsigned long i, bytes, req_nslabs = swiotlb_tbl_nslabs;
 	unsigned int order;
 
-	if (!io_tlb_nslabs) {
-		io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
-		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
+	if (!swiotlb_tbl_nslabs) {
+		swiotlb_tbl_nslabs = (default_size >> IO_TLB_SHIFT);
+		swiotlb_tbl_nslabs = ALIGN(swiotlb_tbl_nslabs, IO_TLB_SEGSIZE);
 	}
 
 	/*
 	 * Get IO TLB memory from the low pages
 	 */
-	order = get_order(io_tlb_nslabs << IO_TLB_SHIFT);
-	io_tlb_nslabs = SLABS_PER_PAGE << order;
-	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
+	order = get_order(swiotlb_tbl_nslabs << IO_TLB_SHIFT);
+	swiotlb_tbl_nslabs = SLABS_PER_PAGE << order;
+	bytes = swiotlb_tbl_nslabs << IO_TLB_SHIFT;
 
 	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
-		io_tlb_start = (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
+		swiotlb_tbl_start = (void *)__get_free_pages(GFP_DMA |
+							__GFP_NOWARN,
 							order);
-		if (io_tlb_start)
+		if (swiotlb_tbl_start)
 			break;
 		order--;
 	}
 
-	if (!io_tlb_start)
+	if (!swiotlb_tbl_start)
 		goto cleanup1;
 
 	if (order != get_order(bytes)) {
 		printk(KERN_WARNING "Warning: only able to allocate %ld MB "
 		       "for software IO TLB\n", (PAGE_SIZE << order) >> 20);
-		io_tlb_nslabs = SLABS_PER_PAGE << order;
-		bytes = io_tlb_nslabs << IO_TLB_SHIFT;
+		swiotlb_tbl_nslabs = SLABS_PER_PAGE << order;
+		bytes = swiotlb_tbl_nslabs << IO_TLB_SHIFT;
 	}
-	io_tlb_end = io_tlb_start + bytes;
-	memset(io_tlb_start, 0, bytes);
+	io_tlb_end = swiotlb_tbl_start + bytes;
+	memset(swiotlb_tbl_start, 0, bytes);
 
 	/*
 	 * Allocate and initialize the free list array.  This array is used
 	 * to find contiguous free memory regions of size up to IO_TLB_SEGSIZE
-	 * between io_tlb_start and io_tlb_end.
+	 * between swiotlb_tbl_start and io_tlb_end.
 	 */
 	io_tlb_list = (unsigned int *)__get_free_pages(GFP_KERNEL,
-	                              get_order(io_tlb_nslabs * sizeof(int)));
+				get_order(swiotlb_tbl_nslabs * sizeof(int)));
 	if (!io_tlb_list)
 		goto cleanup2;
 
-	for (i = 0; i < io_tlb_nslabs; i++)
- 		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
+	for (i = 0; i < swiotlb_tbl_nslabs; i++)
+		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
 	io_tlb_index = 0;
 
-	io_tlb_orig_addr = (phys_addr_t *)
-		__get_free_pages(GFP_KERNEL,
-				 get_order(io_tlb_nslabs *
-					   sizeof(phys_addr_t)));
+	io_tlb_orig_addr = (phys_addr_t *)__get_free_pages(GFP_KERNEL,
+						get_order(swiotlb_tbl_nslabs *
+						  sizeof(phys_addr_t)));
 	if (!io_tlb_orig_addr)
 		goto cleanup3;
 
-	memset(io_tlb_orig_addr, 0, io_tlb_nslabs * sizeof(phys_addr_t));
+	memset(io_tlb_orig_addr, 0, swiotlb_tbl_nslabs *
+					sizeof(phys_addr_t));
 
 	/*
 	 * Get the overflow emergency buffer
 	 */
 	io_tlb_overflow_buffer = (void *)__get_free_pages(GFP_DMA,
-	                                          get_order(io_tlb_overflow));
+					  get_order(io_tlb_overflow));
 	if (!io_tlb_overflow_buffer)
 		goto cleanup4;
 
@@ -272,18 +274,18 @@ swiotlb_late_init_with_default_size(size_t default_size)
 
 cleanup4:
 	free_pages((unsigned long)io_tlb_orig_addr,
-		   get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
+		   get_order(swiotlb_tbl_nslabs * sizeof(phys_addr_t)));
 	io_tlb_orig_addr = NULL;
 cleanup3:
-	free_pages((unsigned long)io_tlb_list, get_order(io_tlb_nslabs *
+	free_pages((unsigned long)io_tlb_list, get_order(swiotlb_tbl_nslabs *
 	                                                 sizeof(int)));
 	io_tlb_list = NULL;
 cleanup2:
 	io_tlb_end = NULL;
-	free_pages((unsigned long)io_tlb_start, order);
-	io_tlb_start = NULL;
+	free_pages((unsigned long)swiotlb_tbl_start, order);
+	swiotlb_tbl_start = NULL;
 cleanup1:
-	io_tlb_nslabs = req_nslabs;
+	swiotlb_tbl_nslabs = req_nslabs;
 	return -ENOMEM;
 }
 
@@ -296,26 +298,26 @@ void __init swiotlb_free(void)
 		free_pages((unsigned long)io_tlb_overflow_buffer,
 			   get_order(io_tlb_overflow));
 		free_pages((unsigned long)io_tlb_orig_addr,
-			   get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
-		free_pages((unsigned long)io_tlb_list, get_order(io_tlb_nslabs *
-								 sizeof(int)));
-		free_pages((unsigned long)io_tlb_start,
-			   get_order(io_tlb_nslabs << IO_TLB_SHIFT));
+			   get_order(swiotlb_tbl_nslabs * sizeof(phys_addr_t)));
+		free_pages((unsigned long)io_tlb_list,
+			   get_order(swiotlb_tbl_nslabs * sizeof(int)));
+		free_pages((unsigned long)swiotlb_tbl_start,
+			   get_order(swiotlb_tbl_nslabs << IO_TLB_SHIFT));
 	} else {
 		free_bootmem_late(__pa(io_tlb_overflow_buffer),
 				  io_tlb_overflow);
 		free_bootmem_late(__pa(io_tlb_orig_addr),
-				  io_tlb_nslabs * sizeof(phys_addr_t));
+				  swiotlb_tbl_nslabs * sizeof(phys_addr_t));
 		free_bootmem_late(__pa(io_tlb_list),
-				  io_tlb_nslabs * sizeof(int));
-		free_bootmem_late(__pa(io_tlb_start),
-				  io_tlb_nslabs << IO_TLB_SHIFT);
+				  swiotlb_tbl_nslabs * sizeof(int));
+		free_bootmem_late(__pa(swiotlb_tbl_start),
+				  swiotlb_tbl_nslabs << IO_TLB_SHIFT);
 	}
 }
 
 static int is_swiotlb_buffer(phys_addr_t paddr)
 {
-	return paddr >= virt_to_phys(io_tlb_start) &&
+	return paddr >= virt_to_phys(swiotlb_tbl_start) &&
 		paddr < virt_to_phys(io_tlb_end);
 }
 
@@ -404,7 +406,7 @@ swiotlb_tbl_map_single(struct device *hwdev, phys_addr_t phys,
 	 */
 	spin_lock_irqsave(&io_tlb_lock, flags);
 	index = ALIGN(io_tlb_index, stride);
-	if (index >= io_tlb_nslabs)
+	if (index >= swiotlb_tbl_nslabs)
 		index = 0;
 	wrap = index;
 
@@ -412,7 +414,7 @@ swiotlb_tbl_map_single(struct device *hwdev, phys_addr_t phys,
 		while (iommu_is_span_boundary(index, nslots, offset_slots,
 					      max_slots)) {
 			index += stride;
-			if (index >= io_tlb_nslabs)
+			if (index >= swiotlb_tbl_nslabs)
 				index = 0;
 			if (index == wrap)
 				goto not_found;
@@ -428,21 +430,22 @@ swiotlb_tbl_map_single(struct device *hwdev, phys_addr_t phys,
 
 			for (i = index; i < (int) (index + nslots); i++)
 				io_tlb_list[i] = 0;
-			for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE) != IO_TLB_SEGSIZE - 1) && io_tlb_list[i]; i--)
+			for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE)
+			     != IO_TLB_SEGSIZE - 1) && io_tlb_list[i]; i--)
 				io_tlb_list[i] = ++count;
-			dma_addr = io_tlb_start + (index << IO_TLB_SHIFT);
+			dma_addr = swiotlb_tbl_start + (index << IO_TLB_SHIFT);
 
 			/*
 			 * Update the indices to avoid searching in the next
 			 * round.
 			 */
-			io_tlb_index = ((index + nslots) < io_tlb_nslabs
+			io_tlb_index = ((index + nslots) < swiotlb_tbl_nslabs
 					? (index + nslots) : 0);
 
 			goto found;
 		}
 		index += stride;
-		if (index >= io_tlb_nslabs)
+		if (index >= swiotlb_tbl_nslabs)
 			index = 0;
 	} while (index != wrap);
 
@@ -474,7 +477,7 @@ swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
 {
 	unsigned long flags;
 	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
-	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
+	int index = (dma_addr - swiotlb_tbl_start) >> IO_TLB_SHIFT;
 	phys_addr_t phys = io_tlb_orig_addr[index];
 
 	/*
@@ -503,7 +506,8 @@ swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
 		 * Step 2: merge the returned slots with the preceding slots,
 		 * if available (non zero)
 		 */
-		for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE) != IO_TLB_SEGSIZE -1) && io_tlb_list[i]; i--)
+		for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE)
+		     != IO_TLB_SEGSIZE - 1) && io_tlb_list[i]; i--)
 			io_tlb_list[i] = ++count;
 	}
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
@@ -513,7 +517,7 @@ static void
 swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr, size_t size,
 	    int dir, int target)
 {
-	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
+	int index = (dma_addr - swiotlb_tbl_start) >> IO_TLB_SHIFT;
 	phys_addr_t phys = io_tlb_orig_addr[index];
 
 	phys += ((unsigned long)dma_addr & ((1 << IO_TLB_SHIFT) - 1));
@@ -563,7 +567,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		 * GFP_DMA memory; fall back on swiotlb_tbl_map_single(), which
 		 * will grab memory from the lowest available address range.
 		 */
-		start_dma_addr = swiotlb_virt_to_bus(hwdev, io_tlb_start);
+		start_dma_addr = swiotlb_virt_to_bus(hwdev, swiotlb_tbl_start);
 		ret = swiotlb_tbl_map_single(hwdev, 0, start_dma_addr, size,
 					    DMA_FROM_DEVICE);
 		if (!ret)
@@ -656,7 +660,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	/*
 	 * Oh well, have to allocate and map a bounce buffer.
 	 */
-	start_dma_addr = swiotlb_virt_to_bus(dev, io_tlb_start);
+	start_dma_addr = swiotlb_virt_to_bus(dev, swiotlb_tbl_start);
 	map = swiotlb_tbl_map_single(dev, phys, start_dma_addr, size, dir);
 	if (!map) {
 		swiotlb_full(dev, size, dir, 1);
@@ -818,7 +822,7 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 
 	BUG_ON(dir == DMA_NONE);
 
-	start_dma_addr = swiotlb_virt_to_bus(hwdev, io_tlb_start);
+	start_dma_addr = swiotlb_virt_to_bus(hwdev, swiotlb_tbl_start);
 	for_each_sg(sgl, sg, nelems, i) {
 		phys_addr_t paddr = sg_phys(sg);
 		dma_addr_t dev_addr = phys_to_dma(hwdev, paddr);
@@ -919,7 +923,8 @@ EXPORT_SYMBOL(swiotlb_sync_sg_for_device);
 int
 swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
 {
-	return (dma_addr == swiotlb_virt_to_bus(hwdev, io_tlb_overflow_buffer));
+	return (dma_addr == swiotlb_virt_to_bus(hwdev,
+						io_tlb_overflow_buffer));
 }
 EXPORT_SYMBOL(swiotlb_dma_mapping_error);
 
-- 
1.6.2.5


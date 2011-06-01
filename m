Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab1FAQnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 12:43:09 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43882 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab1FAQnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 12:43:04 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] swiotlb: Export io_tlb_nslabs as swiotlb_nslabs and use it.
Date: Wed,  1 Jun 2011 12:42:44 -0400
Message-Id: <1306946564-30481-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306946564-30481-1-git-send-email-konrad.wilk@oracle.com>
References: <1306946564-30481-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090203.4DE66C15.015C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By default the io_tlb_nslabs is set to zero, and gets set to
whatever value is passed in via swiotlb_init_with_tbl function.
The default value passed in is 64MB. However, if the user provides
the 'swiotlb=<nslabs>' the default value is ignored and
the value provided by the user is used... Except when the SWIOTLB
is used under Xen - there the default value of 64MB is used and
the Xen-SWIOTLB has no mechanism to get the 'io_tlb_nslabs' filled
out by setup_io_tlb_npages functions. This patch exports the
value that is potentially set by setup_io_tlb_npages and renames
it to swiotlb_nslabs.

CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/swiotlb-xen.c |    7 +++-
 include/linux/swiotlb.h   |    5 +++
 lib/swiotlb.c             |   78 ++++++++++++++++++++++----------------------
 3 files changed, 49 insertions(+), 41 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 54469c3..20b0a54 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -148,8 +148,11 @@ void __init xen_swiotlb_init(int verbose)
 	unsigned long bytes;
 	int rc;
 
-	xen_io_tlb_nslabs = (64 * 1024 * 1024 >> IO_TLB_SHIFT);
-	xen_io_tlb_nslabs = ALIGN(xen_io_tlb_nslabs, IO_TLB_SEGSIZE);
+	if (!swiotlb_nslabs) {
+		xen_io_tlb_nslabs = (64 * 1024 * 1024 >> IO_TLB_SHIFT);
+		xen_io_tlb_nslabs = ALIGN(xen_io_tlb_nslabs, IO_TLB_SEGSIZE);
+	} else
+		xen_io_tlb_nslabs = swiotlb_nslabs;
 
 	bytes = xen_io_tlb_nslabs << IO_TLB_SHIFT;
 
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 8c0e349..c373c23 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -10,6 +10,11 @@ struct scatterlist;
 extern int swiotlb_force;
 
 /*
+ * The amount of slabs set by swiotlb=<pages> argument.
+ * It is multiple of 128Kb chunks.
+ */
+extern unsigned long swiotlb_nslabs;
+/*
  * Maximum allowable number of contiguous slabs to map,
  * must be a power of 2.  What is the appropriate value ?
  * The complexity of {map,unmap}_single is linearly dependent on this value.
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 93ca08b..0822fec 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -63,7 +63,7 @@ static char *io_tlb_start, *io_tlb_end;
  * The number of IO TLB blocks (in groups of 64) between io_tlb_start and
  * io_tlb_end.  This is command line adjustable via setup_io_tlb_npages.
  */
-static unsigned long io_tlb_nslabs;
+unsigned long swiotlb_nslabs;
 
 /*
  * When the IOMMU overflows we return a fallback buffer. This sets the size.
@@ -96,9 +96,9 @@ static int __init
 setup_io_tlb_npages(char *str)
 {
 	if (isdigit(*str)) {
-		io_tlb_nslabs = simple_strtoul(str, &str, 0);
+		swiotlb_nslabs = simple_strtoul(str, &str, 0);
 		/* avoid tail segment of size < IO_TLB_SEGSIZE */
-		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
+		swiotlb_nslabs = ALIGN(swiotlb_nslabs, IO_TLB_SEGSIZE);
 	}
 	if (*str == ',')
 		++str;
@@ -119,7 +119,7 @@ static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
 
 void swiotlb_print_info(void)
 {
-	unsigned long bytes = io_tlb_nslabs << IO_TLB_SHIFT;
+	unsigned long bytes = swiotlb_nslabs << IO_TLB_SHIFT;
 	phys_addr_t pstart, pend;
 
 	pstart = virt_to_phys(io_tlb_start);
@@ -138,7 +138,7 @@ void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
 
 	bytes = nslabs << IO_TLB_SHIFT;
 
-	io_tlb_nslabs = nslabs;
+	swiotlb_nslabs = nslabs;
 	io_tlb_start = tlb;
 	io_tlb_end = io_tlb_start + bytes;
 
@@ -147,11 +147,11 @@ void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
 	 * to find contiguous free memory regions of size up to IO_TLB_SEGSIZE
 	 * between io_tlb_start and io_tlb_end.
 	 */
-	io_tlb_list = alloc_bootmem_pages(PAGE_ALIGN(io_tlb_nslabs * sizeof(int)));
-	for (i = 0; i < io_tlb_nslabs; i++)
+	io_tlb_list = alloc_bootmem_pages(PAGE_ALIGN(swiotlb_nslabs * sizeof(int)));
+	for (i = 0; i < swiotlb_nslabs; i++)
  		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
 	io_tlb_index = 0;
-	io_tlb_orig_addr = alloc_bootmem_pages(PAGE_ALIGN(io_tlb_nslabs * sizeof(phys_addr_t)));
+	io_tlb_orig_addr = alloc_bootmem_pages(PAGE_ALIGN(swiotlb_nslabs * sizeof(phys_addr_t)));
 
 	/*
 	 * Get the overflow emergency buffer
@@ -172,12 +172,12 @@ swiotlb_init_with_default_size(size_t default_size, int verbose)
 {
 	unsigned long bytes;
 
-	if (!io_tlb_nslabs) {
-		io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
-		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
+	if (!swiotlb_nslabs) {
+		swiotlb_nslabs = (default_size >> IO_TLB_SHIFT);
+		swiotlb_nslabs = ALIGN(swiotlb_nslabs, IO_TLB_SEGSIZE);
 	}
 
-	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
+	bytes = swiotlb_nslabs << IO_TLB_SHIFT;
 
 	/*
 	 * Get IO TLB memory from the low pages
@@ -186,7 +186,7 @@ swiotlb_init_with_default_size(size_t default_size, int verbose)
 	if (!io_tlb_start)
 		panic("Cannot allocate SWIOTLB buffer");
 
-	swiotlb_init_with_tbl(io_tlb_start, io_tlb_nslabs, verbose);
+	swiotlb_init_with_tbl(io_tlb_start, swiotlb_nslabs, verbose);
 }
 
 void __init
@@ -203,20 +203,20 @@ swiotlb_init(int verbose)
 int
 swiotlb_late_init_with_default_size(size_t default_size)
 {
-	unsigned long i, bytes, req_nslabs = io_tlb_nslabs;
+	unsigned long i, bytes, req_nslabs = swiotlb_nslabs;
 	unsigned int order;
 
-	if (!io_tlb_nslabs) {
-		io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
-		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
+	if (!swiotlb_nslabs) {
+		swiotlb_nslabs = (default_size >> IO_TLB_SHIFT);
+		swiotlb_nslabs = ALIGN(swiotlb_nslabs, IO_TLB_SEGSIZE);
 	}
 
 	/*
 	 * Get IO TLB memory from the low pages
 	 */
-	order = get_order(io_tlb_nslabs << IO_TLB_SHIFT);
-	io_tlb_nslabs = SLABS_PER_PAGE << order;
-	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
+	order = get_order(swiotlb_nslabs << IO_TLB_SHIFT);
+	swiotlb_nslabs = SLABS_PER_PAGE << order;
+	bytes = swiotlb_nslabs << IO_TLB_SHIFT;
 
 	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
 		io_tlb_start = (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
@@ -232,8 +232,8 @@ swiotlb_late_init_with_default_size(size_t default_size)
 	if (order != get_order(bytes)) {
 		printk(KERN_WARNING "Warning: only able to allocate %ld MB "
 		       "for software IO TLB\n", (PAGE_SIZE << order) >> 20);
-		io_tlb_nslabs = SLABS_PER_PAGE << order;
-		bytes = io_tlb_nslabs << IO_TLB_SHIFT;
+		swiotlb_nslabs = SLABS_PER_PAGE << order;
+		bytes = swiotlb_nslabs << IO_TLB_SHIFT;
 	}
 	io_tlb_end = io_tlb_start + bytes;
 	memset(io_tlb_start, 0, bytes);
@@ -244,22 +244,22 @@ swiotlb_late_init_with_default_size(size_t default_size)
 	 * between io_tlb_start and io_tlb_end.
 	 */
 	io_tlb_list = (unsigned int *)__get_free_pages(GFP_KERNEL,
-	                              get_order(io_tlb_nslabs * sizeof(int)));
+	                              get_order(swiotlb_nslabs * sizeof(int)));
 	if (!io_tlb_list)
 		goto cleanup2;
 
-	for (i = 0; i < io_tlb_nslabs; i++)
+	for (i = 0; i < swiotlb_nslabs; i++)
  		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
 	io_tlb_index = 0;
 
 	io_tlb_orig_addr = (phys_addr_t *)
 		__get_free_pages(GFP_KERNEL,
-				 get_order(io_tlb_nslabs *
+				 get_order(swiotlb_nslabs *
 					   sizeof(phys_addr_t)));
 	if (!io_tlb_orig_addr)
 		goto cleanup3;
 
-	memset(io_tlb_orig_addr, 0, io_tlb_nslabs * sizeof(phys_addr_t));
+	memset(io_tlb_orig_addr, 0, swiotlb_nslabs * sizeof(phys_addr_t));
 
 	/*
 	 * Get the overflow emergency buffer
@@ -277,10 +277,10 @@ swiotlb_late_init_with_default_size(size_t default_size)
 
 cleanup4:
 	free_pages((unsigned long)io_tlb_orig_addr,
-		   get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
+		   get_order(swiotlb_nslabs * sizeof(phys_addr_t)));
 	io_tlb_orig_addr = NULL;
 cleanup3:
-	free_pages((unsigned long)io_tlb_list, get_order(io_tlb_nslabs *
+	free_pages((unsigned long)io_tlb_list, get_order(swiotlb_nslabs *
 	                                                 sizeof(int)));
 	io_tlb_list = NULL;
 cleanup2:
@@ -288,7 +288,7 @@ cleanup2:
 	free_pages((unsigned long)io_tlb_start, order);
 	io_tlb_start = NULL;
 cleanup1:
-	io_tlb_nslabs = req_nslabs;
+	swiotlb_nslabs = req_nslabs;
 	return -ENOMEM;
 }
 
@@ -301,20 +301,20 @@ void __init swiotlb_free(void)
 		free_pages((unsigned long)io_tlb_overflow_buffer,
 			   get_order(io_tlb_overflow));
 		free_pages((unsigned long)io_tlb_orig_addr,
-			   get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
-		free_pages((unsigned long)io_tlb_list, get_order(io_tlb_nslabs *
+			   get_order(swiotlb_nslabs * sizeof(phys_addr_t)));
+		free_pages((unsigned long)io_tlb_list, get_order(swiotlb_nslabs *
 								 sizeof(int)));
 		free_pages((unsigned long)io_tlb_start,
-			   get_order(io_tlb_nslabs << IO_TLB_SHIFT));
+			   get_order(swiotlb_nslabs << IO_TLB_SHIFT));
 	} else {
 		free_bootmem_late(__pa(io_tlb_overflow_buffer),
 				  PAGE_ALIGN(io_tlb_overflow));
 		free_bootmem_late(__pa(io_tlb_orig_addr),
-				  PAGE_ALIGN(io_tlb_nslabs * sizeof(phys_addr_t)));
+				  PAGE_ALIGN(swiotlb_nslabs * sizeof(phys_addr_t)));
 		free_bootmem_late(__pa(io_tlb_list),
-				  PAGE_ALIGN(io_tlb_nslabs * sizeof(int)));
+				  PAGE_ALIGN(swiotlb_nslabs * sizeof(int)));
 		free_bootmem_late(__pa(io_tlb_start),
-				  PAGE_ALIGN(io_tlb_nslabs << IO_TLB_SHIFT));
+				  PAGE_ALIGN(swiotlb_nslabs << IO_TLB_SHIFT));
 	}
 }
 
@@ -409,7 +409,7 @@ void *swiotlb_tbl_map_single(struct device *hwdev, dma_addr_t tbl_dma_addr,
 	 */
 	spin_lock_irqsave(&io_tlb_lock, flags);
 	index = ALIGN(io_tlb_index, stride);
-	if (index >= io_tlb_nslabs)
+	if (index >= swiotlb_nslabs)
 		index = 0;
 	wrap = index;
 
@@ -417,7 +417,7 @@ void *swiotlb_tbl_map_single(struct device *hwdev, dma_addr_t tbl_dma_addr,
 		while (iommu_is_span_boundary(index, nslots, offset_slots,
 					      max_slots)) {
 			index += stride;
-			if (index >= io_tlb_nslabs)
+			if (index >= swiotlb_nslabs)
 				index = 0;
 			if (index == wrap)
 				goto not_found;
@@ -441,13 +441,13 @@ void *swiotlb_tbl_map_single(struct device *hwdev, dma_addr_t tbl_dma_addr,
 			 * Update the indices to avoid searching in the next
 			 * round.
 			 */
-			io_tlb_index = ((index + nslots) < io_tlb_nslabs
+			io_tlb_index = ((index + nslots) < swiotlb_nslabs
 					? (index + nslots) : 0);
 
 			goto found;
 		}
 		index += stride;
-		if (index >= io_tlb_nslabs)
+		if (index >= swiotlb_nslabs)
 			index = 0;
 	} while (index != wrap);
 
-- 
1.7.4.1


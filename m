Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311Ab2JKUeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:34:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:23899 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361Ab2JKUeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:34:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,573,1344236400"; 
   d="scan'208";a="233703221"
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH v2 2/7] swiotlb: Make io_tlb_start a physical address instead
	of a virtual one
To: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, akpm@linux-foundation.org,
        joerg.roedel@amd.com, bhelgaas@google.com, shuahkhan@gmail.com,
        fujita.tomonori@lab.ntt.co.jp
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Date: Thu, 11 Oct 2012 13:34:31 -0700
Message-ID: <20121011203431.12444.25518.stgit@gitlad.jf.intel.com>
In-Reply-To: <20121011203010.12444.15503.stgit@gitlad.jf.intel.com>
References: <20121011203010.12444.15503.stgit@gitlad.jf.intel.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change replaces all references to the virtual address for io_tlb_start
with references to the physical address io_tlb_end.  The main advantage of
replacing the virtual address with a physical address is that we can avoid
having to do multiple translations from the virtual address to the physical
one needed for testing an existing DMA address.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---

 lib/swiotlb.c |   58 +++++++++++++++++++++++++++++----------------------------
 1 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 19aac9f..c492b84 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -57,8 +57,7 @@ int swiotlb_force;
  * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
  * API.
  */
-static char *io_tlb_start;
-phys_addr_t io_tlb_end;
+phys_addr_t io_tlb_start, io_tlb_end;
 
 /*
  * The number of IO TLB blocks (in groups of 64) between io_tlb_start and
@@ -126,16 +125,15 @@ static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
 void swiotlb_print_info(void)
 {
 	unsigned long bytes = io_tlb_nslabs << IO_TLB_SHIFT;
-	phys_addr_t pstart;
-	unsigned char *vend;
+	unsigned char *vstart, *vend;
 
-	pstart = virt_to_phys(io_tlb_start);
+	vstart = phys_to_virt(io_tlb_start);
 	vend = phys_to_virt(io_tlb_end);
 
 	printk(KERN_INFO "software IO TLB [mem %#010llx-%#010llx] (%luMB) mapped at [%p-%p]\n",
-	       (unsigned long long)pstart,
+	       (unsigned long long)io_tlb_start,
 	       (unsigned long long)io_tlb_end,
-	       bytes >> 20, io_tlb_start, vend - 1);
+	       bytes >> 20, vstart, vend - 1);
 }
 
 void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
@@ -145,8 +143,8 @@ void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
 	bytes = nslabs << IO_TLB_SHIFT;
 
 	io_tlb_nslabs = nslabs;
-	io_tlb_start = tlb;
-	io_tlb_end = __pa(io_tlb_start) + bytes;
+	io_tlb_start = __pa(tlb);
+	io_tlb_end = io_tlb_start + bytes;
 
 	/*
 	 * Allocate and initialize the free list array.  This array is used
@@ -176,6 +174,7 @@ void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
 static void __init
 swiotlb_init_with_default_size(size_t default_size, int verbose)
 {
+	unsigned char *vstart;
 	unsigned long bytes;
 
 	if (!io_tlb_nslabs) {
@@ -188,11 +187,11 @@ swiotlb_init_with_default_size(size_t default_size, int verbose)
 	/*
 	 * Get IO TLB memory from the low pages
 	 */
-	io_tlb_start = alloc_bootmem_low_pages(PAGE_ALIGN(bytes));
-	if (!io_tlb_start)
+	vstart = alloc_bootmem_low_pages(PAGE_ALIGN(bytes));
+	if (!vstart)
 		panic("Cannot allocate SWIOTLB buffer");
 
-	swiotlb_init_with_tbl(io_tlb_start, io_tlb_nslabs, verbose);
+	swiotlb_init_with_tbl(vstart, io_tlb_nslabs, verbose);
 }
 
 void __init
@@ -210,6 +209,7 @@ int
 swiotlb_late_init_with_default_size(size_t default_size)
 {
 	unsigned long bytes, req_nslabs = io_tlb_nslabs;
+	unsigned char *vstart = NULL;
 	unsigned int order;
 	int rc = 0;
 
@@ -226,14 +226,14 @@ swiotlb_late_init_with_default_size(size_t default_size)
 	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
 
 	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
-		io_tlb_start = (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
-							order);
-		if (io_tlb_start)
+		vstart = (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
+						  order);
+		if (vstart)
 			break;
 		order--;
 	}
 
-	if (!io_tlb_start) {
+	if (!vstart) {
 		io_tlb_nslabs = req_nslabs;
 		return -ENOMEM;
 	}
@@ -242,9 +242,9 @@ swiotlb_late_init_with_default_size(size_t default_size)
 		       "for software IO TLB\n", (PAGE_SIZE << order) >> 20);
 		io_tlb_nslabs = SLABS_PER_PAGE << order;
 	}
-	rc = swiotlb_late_init_with_tbl(io_tlb_start, io_tlb_nslabs);
+	rc = swiotlb_late_init_with_tbl(vstart, io_tlb_nslabs);
 	if (rc)
-		free_pages((unsigned long)io_tlb_start, order);
+		free_pages((unsigned long)vstart, order);
 	return rc;
 }
 
@@ -256,10 +256,10 @@ swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
 	bytes = nslabs << IO_TLB_SHIFT;
 
 	io_tlb_nslabs = nslabs;
-	io_tlb_start = tlb;
-	io_tlb_end = virt_to_phys(io_tlb_start) + bytes;
+	io_tlb_start = virt_to_phys(tlb);
+	io_tlb_end = io_tlb_start + bytes;
 
-	memset(io_tlb_start, 0, bytes);
+	memset(tlb, 0, bytes);
 
 	/*
 	 * Allocate and initialize the free list array.  This array is used
@@ -308,7 +308,7 @@ cleanup3:
 	io_tlb_list = NULL;
 cleanup2:
 	io_tlb_end = 0;
-	io_tlb_start = NULL;
+	io_tlb_start = 0;
 	io_tlb_nslabs = 0;
 	return -ENOMEM;
 }
@@ -325,7 +325,7 @@ void __init swiotlb_free(void)
 			   get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
 		free_pages((unsigned long)io_tlb_list, get_order(io_tlb_nslabs *
 								 sizeof(int)));
-		free_pages((unsigned long)io_tlb_start,
+		free_pages((unsigned long)phys_to_virt(io_tlb_start),
 			   get_order(io_tlb_nslabs << IO_TLB_SHIFT));
 	} else {
 		free_bootmem_late(__pa(io_tlb_overflow_buffer),
@@ -334,7 +334,7 @@ void __init swiotlb_free(void)
 				  PAGE_ALIGN(io_tlb_nslabs * sizeof(phys_addr_t)));
 		free_bootmem_late(__pa(io_tlb_list),
 				  PAGE_ALIGN(io_tlb_nslabs * sizeof(int)));
-		free_bootmem_late(__pa(io_tlb_start),
+		free_bootmem_late(io_tlb_start,
 				  PAGE_ALIGN(io_tlb_nslabs << IO_TLB_SHIFT));
 	}
 	io_tlb_nslabs = 0;
@@ -342,7 +342,7 @@ void __init swiotlb_free(void)
 
 static int is_swiotlb_buffer(phys_addr_t paddr)
 {
-	return paddr >= virt_to_phys(io_tlb_start) && paddr < io_tlb_end;
+	return paddr >= io_tlb_start && paddr < io_tlb_end;
 }
 
 /*
@@ -455,7 +455,7 @@ void *swiotlb_tbl_map_single(struct device *hwdev, dma_addr_t tbl_dma_addr,
 				io_tlb_list[i] = 0;
 			for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE) != IO_TLB_SEGSIZE - 1) && io_tlb_list[i]; i--)
 				io_tlb_list[i] = ++count;
-			dma_addr = io_tlb_start + (index << IO_TLB_SHIFT);
+			dma_addr = (char *)phys_to_virt(io_tlb_start) + (index << IO_TLB_SHIFT);
 
 			/*
 			 * Update the indices to avoid searching in the next
@@ -499,7 +499,7 @@ static void *
 map_single(struct device *hwdev, phys_addr_t phys, size_t size,
 	   enum dma_data_direction dir)
 {
-	dma_addr_t start_dma_addr = swiotlb_virt_to_bus(hwdev, io_tlb_start);
+	dma_addr_t start_dma_addr = phys_to_dma(hwdev, io_tlb_start);
 
 	return swiotlb_tbl_map_single(hwdev, start_dma_addr, phys, size, dir);
 }
@@ -513,7 +513,7 @@ swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
 {
 	unsigned long flags;
 	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
-	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
+	int index = (dma_addr - (char *)phys_to_virt(io_tlb_start)) >> IO_TLB_SHIFT;
 	phys_addr_t phys = io_tlb_orig_addr[index];
 
 	/*
@@ -554,7 +554,7 @@ swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr, size_t size,
 			enum dma_data_direction dir,
 			enum dma_sync_target target)
 {
-	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
+	int index = (dma_addr - (char *)phys_to_virt(io_tlb_start)) >> IO_TLB_SHIFT;
 	phys_addr_t phys = io_tlb_orig_addr[index];
 
 	phys += ((unsigned long)dma_addr & ((1 << IO_TLB_SHIFT) - 1));


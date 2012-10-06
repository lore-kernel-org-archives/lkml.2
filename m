Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab2JFAds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 20:33:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:64179 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683Ab2JFAdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 20:33:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,541,1344236400"; 
   d="scan'208";a="201185591"
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH 2/7] swiotlb: Replace virtual io_tlb_start with physical
	io_tlb_addr
To: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, akpm@linux-foundation.org,
        joerg.roedel@amd.com, bhelgaas@google.com, shuahkhan@gmail.com,
        fujita.tomonori@lab.ntt.co.jp
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Date: Fri, 05 Oct 2012 17:33:59 -0700
Message-ID: <20121006003359.2561.81712.stgit@gitlad.jf.intel.com>
In-Reply-To: <20121006000746.2561.67407.stgit@gitlad.jf.intel.com>
References: <20121006000746.2561.67407.stgit@gitlad.jf.intel.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change replaces all references to the virtual address for io_tlb_start
with references to the physical address io_tlb_addr.  The main advantage of
replacing the virtual address with a physical address is that we can avoid
having to do multiple translations from the virtual address to the physical
one needed for testing an existing DMA address.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---

 lib/swiotlb.c |   67 +++++++++++++++++++++++++++++----------------------------
 1 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 5cc4d4e..3c45f10 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -53,11 +53,11 @@
 int swiotlb_force;
 
 /*
- * Used to do a quick range check in swiotlb_tbl_unmap_single and
- * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
- * API.
+ * Physical address for swiotlb bounce buffer.  Used to do a quick range
+ * check in swiotlb_tbl_unmap_single and swiotlb_tbl_sync_single_*, to see
+ * if the memory was in fact allocated by this API.
  */
-static char *io_tlb_start;
+phys_addr_t io_tlb_addr;
 
 /*
  * The number of IO TLB blocks (in groups of 64).
@@ -125,14 +125,15 @@ static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
 void swiotlb_print_info(void)
 {
 	unsigned long bytes = io_tlb_nslabs << IO_TLB_SHIFT;
-	phys_addr_t pstart, pend;
+	unsigned char *vstart, *vend;
 
-	pstart = virt_to_phys(io_tlb_start);
-	pend = pstart + bytes;
+	vstart = phys_to_virt(io_tlb_addr);
+	vend = vstart + bytes;
 
 	printk(KERN_INFO "software IO TLB [mem %#010llx-%#010llx] (%luMB) mapped at [%p-%p]\n",
-	       (unsigned long long)pstart, (unsigned long long)pend - 1,
-	       bytes >> 20, io_tlb_start, io_tlb_start + bytes - 1);
+	       (unsigned long long)io_tlb_addr,
+	       (unsigned long long)io_tlb_addr + bytes - 1,
+	       bytes >> 20, vstart, vend - 1);
 }
 
 void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
@@ -142,7 +143,7 @@ void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
 	bytes = nslabs << IO_TLB_SHIFT;
 
 	io_tlb_nslabs = nslabs;
-	io_tlb_start = tlb;
+	io_tlb_addr = __pa(tlb);
 
 	/*
 	 * Allocate and initialize the free list array.  This array is used
@@ -171,6 +172,7 @@ void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
 static void __init
 swiotlb_init_with_default_size(size_t default_size, int verbose)
 {
+	unsigned char *vstart;
 	unsigned long bytes;
 
 	if (!io_tlb_nslabs) {
@@ -183,11 +185,11 @@ swiotlb_init_with_default_size(size_t default_size, int verbose)
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
@@ -205,6 +207,7 @@ int
 swiotlb_late_init_with_default_size(size_t default_size)
 {
 	unsigned long bytes, req_nslabs = io_tlb_nslabs;
+	unsigned char *vstart = NULL;
 	unsigned int order;
 	int rc = 0;
 
@@ -221,14 +224,14 @@ swiotlb_late_init_with_default_size(size_t default_size)
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
@@ -237,9 +240,9 @@ swiotlb_late_init_with_default_size(size_t default_size)
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
 
@@ -251,9 +254,9 @@ swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
 	bytes = nslabs << IO_TLB_SHIFT;
 
 	io_tlb_nslabs = nslabs;
-	io_tlb_start = tlb;
+	io_tlb_addr = virt_to_phys(tlb);
 
-	memset(io_tlb_start, 0, bytes);
+	memset(tlb, 0, bytes);
 
 	/*
 	 * Allocate and initialize the free list array.  This array is used
@@ -300,7 +303,7 @@ cleanup3:
 	                                                 sizeof(int)));
 	io_tlb_list = NULL;
 cleanup2:
-	io_tlb_start = NULL;
+	io_tlb_addr = 0;
 	io_tlb_nslabs = 0;
 	return -ENOMEM;
 }
@@ -317,7 +320,7 @@ void __init swiotlb_free(void)
 			   get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
 		free_pages((unsigned long)io_tlb_list, get_order(io_tlb_nslabs *
 								 sizeof(int)));
-		free_pages((unsigned long)io_tlb_start,
+		free_pages((unsigned long)phys_to_virt(io_tlb_addr),
 			   get_order(io_tlb_nslabs << IO_TLB_SHIFT));
 	} else {
 		free_bootmem_late(__pa(io_tlb_overflow_buffer),
@@ -326,7 +329,7 @@ void __init swiotlb_free(void)
 				  PAGE_ALIGN(io_tlb_nslabs * sizeof(phys_addr_t)));
 		free_bootmem_late(__pa(io_tlb_list),
 				  PAGE_ALIGN(io_tlb_nslabs * sizeof(int)));
-		free_bootmem_late(__pa(io_tlb_start),
+		free_bootmem_late(io_tlb_addr,
 				  PAGE_ALIGN(io_tlb_nslabs << IO_TLB_SHIFT));
 	}
 	io_tlb_nslabs = 0;
@@ -334,10 +337,8 @@ void __init swiotlb_free(void)
 
 static int is_swiotlb_buffer(phys_addr_t paddr)
 {
-	phys_addr_t swiotlb_start = virt_to_phys(io_tlb_start);
-
-	return paddr >= swiotlb_start &&
-		paddr < (swiotlb_start + (io_tlb_nslabs << IO_TLB_SHIFT));
+	return paddr >= io_tlb_addr &&
+		paddr < (io_tlb_addr + (io_tlb_nslabs << IO_TLB_SHIFT));
 }
 
 /*
@@ -450,7 +451,7 @@ void *swiotlb_tbl_map_single(struct device *hwdev, dma_addr_t tbl_dma_addr,
 				io_tlb_list[i] = 0;
 			for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE) != IO_TLB_SEGSIZE - 1) && io_tlb_list[i]; i--)
 				io_tlb_list[i] = ++count;
-			dma_addr = io_tlb_start + (index << IO_TLB_SHIFT);
+			dma_addr = (char *)phys_to_virt(io_tlb_addr) + (index << IO_TLB_SHIFT);
 
 			/*
 			 * Update the indices to avoid searching in the next
@@ -494,7 +495,7 @@ static void *
 map_single(struct device *hwdev, phys_addr_t phys, size_t size,
 	   enum dma_data_direction dir)
 {
-	dma_addr_t start_dma_addr = swiotlb_virt_to_bus(hwdev, io_tlb_start);
+	dma_addr_t start_dma_addr = phys_to_dma(hwdev, io_tlb_addr);
 
 	return swiotlb_tbl_map_single(hwdev, start_dma_addr, phys, size, dir);
 }
@@ -508,7 +509,7 @@ swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
 {
 	unsigned long flags;
 	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
-	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
+	int index = (dma_addr - (char *)phys_to_virt(io_tlb_addr)) >> IO_TLB_SHIFT;
 	phys_addr_t phys = io_tlb_orig_addr[index];
 
 	/*
@@ -549,7 +550,7 @@ swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr, size_t size,
 			enum dma_data_direction dir,
 			enum dma_sync_target target)
 {
-	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
+	int index = (dma_addr - (char *)phys_to_virt(io_tlb_addr)) >> IO_TLB_SHIFT;
 	phys_addr_t phys = io_tlb_orig_addr[index];
 
 	phys += ((unsigned long)dma_addr & ((1 << IO_TLB_SHIFT) - 1));
@@ -937,6 +938,6 @@ swiotlb_dma_supported(struct device *hwdev, u64 mask)
 {
 	unsigned long bytes = io_tlb_nslabs << IO_TLB_SHIFT;
 
-	return swiotlb_virt_to_bus(hwdev, io_tlb_start + bytes - 1) <= mask;
+	return phys_to_dma(hwdev, io_tlb_addr + bytes - 1) <= mask;
 }
 EXPORT_SYMBOL(swiotlb_dma_supported);


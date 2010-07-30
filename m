Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab0G3PiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 11:38:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:41920 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547Ab0G3PiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 11:38:05 -0400
Date: Sat, 31 Jul 2010 00:37:54 +0900
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, ak@linux.intel.com, konrad.wilk@oracle.com,
        akataria@vmware.com
Subject: [PATCH] swiotlb: enlarge iotlb buffer on demand
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100731003643E.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 31 Jul 2010 00:37:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that this isn't for the next merge window. Seems that it works
but I need more testings and cleanups (and need to fix ia64 code).

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] swiotlb: enlarge iotlb buffer on demand

This enables swiotlb to enlarg iotlb (bounce) buffer on demand.

On x86_64, swiotlb is enabled only when more than 4GB memory is
available. swiotlb uses 64MB memory by default. 64MB is not so
precious in this case, I suppose.

The problem is that it's likely that x86_64 always needs to enable
swiotlb due to hotplug memory support. 64MB could be very precious.

swiotlb iotlb buffer is physically continuous (64MB by default). With
this patch, iotlb buffer doesn't need to be physically continuous. So
swiotlb can allocate iotlb buffer on demand. Currently, swiotlb
allocates 256KB at a time.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 lib/swiotlb.c |  186 ++++++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 138 insertions(+), 48 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index a009055..e2c64ab 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -65,11 +65,14 @@ int swiotlb_force;
  * sync_single_*, to see if the memory was in fact allocated by this
  * API.
  */
-static char *io_tlb_start, *io_tlb_end;
+static char **__io_tlb_start;
+
+static int alloc_io_tlb_chunks;
 
 /*
- * The number of IO TLB blocks (in groups of 64) betweeen io_tlb_start and
- * io_tlb_end.  This is command line adjustable via setup_io_tlb_npages.
+ * The number of IO TLB blocks (in groups of 64) betweeen
+ * io_tlb_start. This is command line adjustable via
+ * setup_io_tlb_npages.
  */
 static unsigned long io_tlb_nslabs;
 
@@ -130,11 +133,11 @@ void swiotlb_print_info(void)
 	unsigned long bytes = io_tlb_nslabs << IO_TLB_SHIFT;
 	phys_addr_t pstart, pend;
 
-	pstart = virt_to_phys(io_tlb_start);
-	pend = virt_to_phys(io_tlb_end);
+	pstart = virt_to_phys(__io_tlb_start[0]);
+	pend = virt_to_phys(__io_tlb_start[0] + (IO_TLB_SEGSIZE << IO_TLB_SHIFT));
 
-	printk(KERN_INFO "Placing %luMB software IO TLB between %p - %p\n",
-	       bytes >> 20, io_tlb_start, io_tlb_end);
+	printk(KERN_INFO "software IO TLB can be enlarged to %lu MB\n",
+	       bytes >> 20);
 	printk(KERN_INFO "software IO TLB at phys %#llx - %#llx\n",
 	       (unsigned long long)pstart,
 	       (unsigned long long)pend);
@@ -154,20 +157,24 @@ swiotlb_init_with_default_size(size_t default_size, int verbose)
 		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
 	}
 
-	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
+	bytes = IO_TLB_SEGSIZE << IO_TLB_SHIFT;
+
+	__io_tlb_start = alloc_bootmem(
+		(io_tlb_nslabs / IO_TLB_SEGSIZE) * sizeof(char *));
+	memset(__io_tlb_start, 0, (io_tlb_nslabs / IO_TLB_SEGSIZE) * sizeof(char *));
+	alloc_io_tlb_chunks = 1;
 
 	/*
 	 * Get IO TLB memory from the low pages
 	 */
-	io_tlb_start = alloc_bootmem_low_pages(bytes);
-	if (!io_tlb_start)
+	__io_tlb_start[0] = alloc_bootmem_low_pages(bytes);
+	if (!__io_tlb_start[0])
 		panic("Cannot allocate SWIOTLB buffer");
-	io_tlb_end = io_tlb_start + bytes;
 
 	/*
 	 * Allocate and initialize the free list array.  This array is used
 	 * to find contiguous free memory regions of size up to IO_TLB_SEGSIZE
-	 * between io_tlb_start and io_tlb_end.
+	 * between io_tlb_start.
 	 */
 	io_tlb_list = alloc_bootmem(io_tlb_nslabs * sizeof(int));
 	for (i = 0; i < io_tlb_nslabs; i++)
@@ -215,14 +222,14 @@ swiotlb_late_init_with_default_size(size_t default_size)
 	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
 
 	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
-		io_tlb_start = (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
-							order);
-		if (io_tlb_start)
+		__io_tlb_start[0] = (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
+							     order);
+		if (__io_tlb_start[0])
 			break;
 		order--;
 	}
 
-	if (!io_tlb_start)
+	if (!__io_tlb_start[0])
 		goto cleanup1;
 
 	if (order != get_order(bytes)) {
@@ -231,13 +238,12 @@ swiotlb_late_init_with_default_size(size_t default_size)
 		io_tlb_nslabs = SLABS_PER_PAGE << order;
 		bytes = io_tlb_nslabs << IO_TLB_SHIFT;
 	}
-	io_tlb_end = io_tlb_start + bytes;
-	memset(io_tlb_start, 0, bytes);
+	memset(__io_tlb_start[0], 0, bytes);
 
 	/*
 	 * Allocate and initialize the free list array.  This array is used
 	 * to find contiguous free memory regions of size up to IO_TLB_SEGSIZE
-	 * between io_tlb_start and io_tlb_end.
+	 * between io_tlb_start.
 	 */
 	io_tlb_list = (unsigned int *)__get_free_pages(GFP_KERNEL,
 	                              get_order(io_tlb_nslabs * sizeof(int)));
@@ -280,9 +286,8 @@ cleanup3:
 	                                                 sizeof(int)));
 	io_tlb_list = NULL;
 cleanup2:
-	io_tlb_end = NULL;
-	free_pages((unsigned long)io_tlb_start, order);
-	io_tlb_start = NULL;
+	free_pages((unsigned long)__io_tlb_start[0], order);
+	__io_tlb_start[0] = NULL;
 cleanup1:
 	io_tlb_nslabs = req_nslabs;
 	return -ENOMEM;
@@ -300,7 +305,7 @@ void __init swiotlb_free(void)
 			   get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
 		free_pages((unsigned long)io_tlb_list, get_order(io_tlb_nslabs *
 								 sizeof(int)));
-		free_pages((unsigned long)io_tlb_start,
+		free_pages((unsigned long)__io_tlb_start[0],
 			   get_order(io_tlb_nslabs << IO_TLB_SHIFT));
 	} else {
 		free_bootmem_late(__pa(io_tlb_overflow_buffer),
@@ -309,15 +314,36 @@ void __init swiotlb_free(void)
 				  io_tlb_nslabs * sizeof(phys_addr_t));
 		free_bootmem_late(__pa(io_tlb_list),
 				  io_tlb_nslabs * sizeof(int));
-		free_bootmem_late(__pa(io_tlb_start),
+		free_bootmem_late(__pa(__io_tlb_start[0]),
 				  io_tlb_nslabs << IO_TLB_SHIFT);
 	}
 }
 
 static int is_swiotlb_buffer(phys_addr_t paddr)
 {
-	return paddr >= virt_to_phys(io_tlb_start) &&
-		paddr < virt_to_phys(io_tlb_end);
+	unsigned long flags;
+	int i, ret = 0;
+	char *vstart;
+	phys_addr_t pstart, pend;
+
+	spin_lock_irqsave(&io_tlb_lock, flags);
+	for (i = 0; i < alloc_io_tlb_chunks; i++) {
+		vstart = __io_tlb_start[i];
+
+		if (!vstart)
+			break;
+
+		pstart = virt_to_phys(vstart);
+		pend = virt_to_phys(vstart + (IO_TLB_SEGSIZE << IO_TLB_SHIFT));
+
+		if (paddr >= pstart && paddr < pend) {
+			ret = 1;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&io_tlb_lock, flags);
+
+	return ret;
 }
 
 /*
@@ -361,6 +387,35 @@ static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 	}
 }
 
+static int expand_io_tlb(void)
+{
+	int order;
+	char *v;
+
+	/* we can't expand anymore. */
+	if (alloc_io_tlb_chunks == io_tlb_nslabs / IO_TLB_SEGSIZE) {
+		printk("%s %d: can't expand swiotlb %d, %lu\n",
+		       __func__, __LINE__,
+		       alloc_io_tlb_chunks, io_tlb_nslabs);
+		return 1;
+	}
+
+	order = get_order(IO_TLB_SEGSIZE << IO_TLB_SHIFT);
+
+	printk("%s %d: tlb is expanded, %d\n", __func__, __LINE__,
+		alloc_io_tlb_chunks);
+
+	v = (void *)__get_free_pages(GFP_NOWAIT | __GFP_NOWARN, order);
+	if (!v) {
+		printk("%s %d: swiotlb oom\n", __func__, __LINE__);
+		return 1;
+	}
+
+	__io_tlb_start[alloc_io_tlb_chunks++] = v;
+
+	return 0;
+}
+
 /*
  * Allocates bounce buffer and returns its kernel virtual address.
  */
@@ -375,9 +430,13 @@ map_single(struct device *hwdev, phys_addr_t phys, size_t size, int dir)
 	unsigned long mask;
 	unsigned long offset_slots;
 	unsigned long max_slots;
+	int tlb_chunk_index = 0;
+
+again:
+	BUG_ON(tlb_chunk_index >= alloc_io_tlb_chunks);
 
 	mask = dma_get_seg_boundary(hwdev);
-	start_dma_addr = swiotlb_virt_to_bus(hwdev, io_tlb_start) & mask;
+	start_dma_addr = swiotlb_virt_to_bus(hwdev, __io_tlb_start[tlb_chunk_index]) & mask;
 
 	offset_slots = ALIGN(start_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
 
@@ -405,16 +464,17 @@ map_single(struct device *hwdev, phys_addr_t phys, size_t size, int dir)
 	 * request and allocate a buffer from that IO TLB pool.
 	 */
 	spin_lock_irqsave(&io_tlb_lock, flags);
-	index = ALIGN(io_tlb_index, stride);
-	if (index >= io_tlb_nslabs)
-		index = 0;
+	index = 0;
 	wrap = index;
 
 	do {
+		unsigned int *tlb_list = io_tlb_list +
+			tlb_chunk_index * IO_TLB_SEGSIZE;
+
 		while (iommu_is_span_boundary(index, nslots, offset_slots,
 					      max_slots)) {
 			index += stride;
-			if (index >= io_tlb_nslabs)
+			if (index >= IO_TLB_SEGSIZE)
 				index = 0;
 			if (index == wrap)
 				goto not_found;
@@ -425,30 +485,31 @@ map_single(struct device *hwdev, phys_addr_t phys, size_t size, int dir)
 		 * contiguous buffers, we allocate the buffers from that slot
 		 * and mark the entries as '0' indicating unavailable.
 		 */
-		if (io_tlb_list[index] >= nslots) {
+		if (tlb_list[index] >= nslots) {
 			int count = 0;
 
 			for (i = index; i < (int) (index + nslots); i++)
-				io_tlb_list[i] = 0;
+				tlb_list[i] = 0;
 			for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE) != IO_TLB_SEGSIZE - 1) && io_tlb_list[i]; i--)
-				io_tlb_list[i] = ++count;
-			dma_addr = io_tlb_start + (index << IO_TLB_SHIFT);
-
-			/*
-			 * Update the indices to avoid searching in the next
-			 * round.
-			 */
-			io_tlb_index = ((index + nslots) < io_tlb_nslabs
-					? (index + nslots) : 0);
-
+				tlb_list[i] = ++count;
+			dma_addr = __io_tlb_start[tlb_chunk_index] + (index << IO_TLB_SHIFT);
 			goto found;
 		}
 		index += stride;
-		if (index >= io_tlb_nslabs)
+		if (index >= IO_TLB_SEGSIZE)
 			index = 0;
 	} while (index != wrap);
 
 not_found:
+	if (tlb_chunk_index < io_tlb_nslabs / IO_TLB_SEGSIZE) {
+		tlb_chunk_index++;
+		if (tlb_chunk_index < alloc_io_tlb_chunks ||
+		    !expand_io_tlb()) {
+			spin_unlock_irqrestore(&io_tlb_lock, flags);
+			goto again;
+		}
+	}
+
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
 	return NULL;
 found:
@@ -460,13 +521,41 @@ found:
 	 * needed.
 	 */
 	for (i = 0; i < nslots; i++)
-		io_tlb_orig_addr[index+i] = phys + (i << IO_TLB_SHIFT);
+		io_tlb_orig_addr[tlb_chunk_index * IO_TLB_SEGSIZE + index + i] = phys + (i << IO_TLB_SHIFT);
 	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
 		swiotlb_bounce(phys, dma_addr, size, DMA_TO_DEVICE);
 
 	return dma_addr;
 }
 
+static int get_index(char *vaddr)
+{
+	int i, index, ret = 0;
+	unsigned long flags;
+	char *vstart;
+
+	spin_lock_irqsave(&io_tlb_lock, flags);
+	for (i = 0; i < alloc_io_tlb_chunks; i++) {
+		vstart = __io_tlb_start[i];
+
+		if (!vstart)
+			break;
+
+		if (vaddr >= vstart && vaddr < vstart +
+		    (IO_TLB_SEGSIZE << IO_TLB_SHIFT)) {
+			ret = 1;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&io_tlb_lock, flags);
+
+	BUG_ON(!ret);
+
+	index = (vaddr - __io_tlb_start[i]) >> IO_TLB_SHIFT;
+
+	return (i * IO_TLB_SEGSIZE) + index;
+}
+
 /*
  * dma_addr is the kernel virtual address of the bounce buffer to unmap.
  */
@@ -475,7 +564,7 @@ do_unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
 {
 	unsigned long flags;
 	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
-	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
+	int index = get_index(dma_addr);
 	phys_addr_t phys = io_tlb_orig_addr[index];
 
 	/*
@@ -514,7 +603,7 @@ static void
 sync_single(struct device *hwdev, char *dma_addr, size_t size,
 	    int dir, int target)
 {
-	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
+	int index = get_index(dma_addr);
 	phys_addr_t phys = io_tlb_orig_addr[index];
 
 	phys += ((unsigned long)dma_addr & ((1 << IO_TLB_SHIFT) - 1));
@@ -893,6 +982,7 @@ EXPORT_SYMBOL(swiotlb_dma_mapping_error);
 int
 swiotlb_dma_supported(struct device *hwdev, u64 mask)
 {
-	return swiotlb_virt_to_bus(hwdev, io_tlb_end - 1) <= mask;
+	char *vend = __io_tlb_start[0] + (io_tlb_nslabs << IO_TLB_SHIFT);
+	return swiotlb_virt_to_bus(hwdev, vend - 1) <= mask;
 }
 EXPORT_SYMBOL(swiotlb_dma_supported);
-- 
1.6.5


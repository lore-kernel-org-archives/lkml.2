Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab0DHEMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 00:12:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:53242 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab0DHEMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 00:12:21 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, graff.yang@gmail.com, dhowells@redhat.com,
       akpm@linux-foundation.org, uclinux-dist-devel@blackfin.uclinux.org,
       sonic.adi@gmail.com, cl@linux-foundation.org, mingo@elte.hu
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/5] percpu: move vmalloc based chunk management into percpu-vm.c
Date: Thu,  8 Apr 2010 13:11:04 +0900
Message-Id: <1270699865-16954-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270699865-16954-1-git-send-email-tj@kernel.org>
References: <1270699865-16954-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 08 Apr 2010 04:11:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out and move chunk management (creation/desctruction and
[de]population) code into percpu-vm.c which is included by percpu.c
and compiled together.  The interface for chunk management is defined
as follows.

 * pcpu_populate_chunk		- populate the specified range of a chunk
 * pcpu_depopulate_chunk	- depopulate the specified range of a chunk
 * pcpu_create_chunk		- create a new chunk
 * pcpu_destroy_chunk		- destroy a chunk, always preceded by full depop
 * pcpu_addr_to_page		- translate address to physical address
 * pcpu_verify_alloc_info	- check alloc_info is acceptable during init

Other than wrapping vmalloc_to_page() inside pcpu_addr_to_page() and
dummy pcpu_verify_alloc_info() implementation, this patch only moves
code around.  This separation is to allow alternate chunk management
implementation.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Graff Yang <graff.yang@gmail.com>
Cc: Sonic Zhang <sonic.adi@gmail.com>
Cc: David Howells <dhowells@redhat.com>
---
 mm/percpu-vm.c |  451 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/percpu.c    |  452 +++-----------------------------------------------------
 2 files changed, 475 insertions(+), 428 deletions(-)
 create mode 100644 mm/percpu-vm.c

diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
new file mode 100644
index 0000000..7d9c1d0
--- /dev/null
+++ b/mm/percpu-vm.c
@@ -0,0 +1,451 @@
+/*
+ * mm/percpu-vm.c - vmalloc area based chunk allocation
+ *
+ * Copyright (C) 2010		SUSE Linux Products GmbH
+ * Copyright (C) 2010		Tejun Heo <tj@kernel.org>
+ *
+ * This file is released under the GPLv2.
+ *
+ * Chunks are mapped into vmalloc areas and populated page by page.
+ * This is the default chunk allocator.
+ */
+
+static struct page *pcpu_chunk_page(struct pcpu_chunk *chunk,
+				    unsigned int cpu, int page_idx)
+{
+	/* must not be used on pre-mapped chunk */
+	WARN_ON(chunk->immutable);
+
+	return vmalloc_to_page((void *)pcpu_chunk_addr(chunk, cpu, page_idx));
+}
+
+/**
+ * pcpu_get_pages_and_bitmap - get temp pages array and bitmap
+ * @chunk: chunk of interest
+ * @bitmapp: output parameter for bitmap
+ * @may_alloc: may allocate the array
+ *
+ * Returns pointer to array of pointers to struct page and bitmap,
+ * both of which can be indexed with pcpu_page_idx().  The returned
+ * array is cleared to zero and *@bitmapp is copied from
+ * @chunk->populated.  Note that there is only one array and bitmap
+ * and access exclusion is the caller's responsibility.
+ *
+ * CONTEXT:
+ * pcpu_alloc_mutex and does GFP_KERNEL allocation if @may_alloc.
+ * Otherwise, don't care.
+ *
+ * RETURNS:
+ * Pointer to temp pages array on success, NULL on failure.
+ */
+static struct page **pcpu_get_pages_and_bitmap(struct pcpu_chunk *chunk,
+					       unsigned long **bitmapp,
+					       bool may_alloc)
+{
+	static struct page **pages;
+	static unsigned long *bitmap;
+	size_t pages_size = pcpu_nr_units * pcpu_unit_pages * sizeof(pages[0]);
+	size_t bitmap_size = BITS_TO_LONGS(pcpu_unit_pages) *
+			     sizeof(unsigned long);
+
+	if (!pages || !bitmap) {
+		if (may_alloc && !pages)
+			pages = pcpu_mem_alloc(pages_size);
+		if (may_alloc && !bitmap)
+			bitmap = pcpu_mem_alloc(bitmap_size);
+		if (!pages || !bitmap)
+			return NULL;
+	}
+
+	memset(pages, 0, pages_size);
+	bitmap_copy(bitmap, chunk->populated, pcpu_unit_pages);
+
+	*bitmapp = bitmap;
+	return pages;
+}
+
+/**
+ * pcpu_free_pages - free pages which were allocated for @chunk
+ * @chunk: chunk pages were allocated for
+ * @pages: array of pages to be freed, indexed by pcpu_page_idx()
+ * @populated: populated bitmap
+ * @page_start: page index of the first page to be freed
+ * @page_end: page index of the last page to be freed + 1
+ *
+ * Free pages [@page_start and @page_end) in @pages for all units.
+ * The pages were allocated for @chunk.
+ */
+static void pcpu_free_pages(struct pcpu_chunk *chunk,
+			    struct page **pages, unsigned long *populated,
+			    int page_start, int page_end)
+{
+	unsigned int cpu;
+	int i;
+
+	for_each_possible_cpu(cpu) {
+		for (i = page_start; i < page_end; i++) {
+			struct page *page = pages[pcpu_page_idx(cpu, i)];
+
+			if (page)
+				__free_page(page);
+		}
+	}
+}
+
+/**
+ * pcpu_alloc_pages - allocates pages for @chunk
+ * @chunk: target chunk
+ * @pages: array to put the allocated pages into, indexed by pcpu_page_idx()
+ * @populated: populated bitmap
+ * @page_start: page index of the first page to be allocated
+ * @page_end: page index of the last page to be allocated + 1
+ *
+ * Allocate pages [@page_start,@page_end) into @pages for all units.
+ * The allocation is for @chunk.  Percpu core doesn't care about the
+ * content of @pages and will pass it verbatim to pcpu_map_pages().
+ */
+static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
+			    struct page **pages, unsigned long *populated,
+			    int page_start, int page_end)
+{
+	const gfp_t gfp = GFP_KERNEL | __GFP_HIGHMEM | __GFP_COLD;
+	unsigned int cpu;
+	int i;
+
+	for_each_possible_cpu(cpu) {
+		for (i = page_start; i < page_end; i++) {
+			struct page **pagep = &pages[pcpu_page_idx(cpu, i)];
+
+			*pagep = alloc_pages_node(cpu_to_node(cpu), gfp, 0);
+			if (!*pagep) {
+				pcpu_free_pages(chunk, pages, populated,
+						page_start, page_end);
+				return -ENOMEM;
+			}
+		}
+	}
+	return 0;
+}
+
+/**
+ * pcpu_pre_unmap_flush - flush cache prior to unmapping
+ * @chunk: chunk the regions to be flushed belongs to
+ * @page_start: page index of the first page to be flushed
+ * @page_end: page index of the last page to be flushed + 1
+ *
+ * Pages in [@page_start,@page_end) of @chunk are about to be
+ * unmapped.  Flush cache.  As each flushing trial can be very
+ * expensive, issue flush on the whole region at once rather than
+ * doing it for each cpu.  This could be an overkill but is more
+ * scalable.
+ */
+static void pcpu_pre_unmap_flush(struct pcpu_chunk *chunk,
+				 int page_start, int page_end)
+{
+	flush_cache_vunmap(
+		pcpu_chunk_addr(chunk, pcpu_first_unit_cpu, page_start),
+		pcpu_chunk_addr(chunk, pcpu_last_unit_cpu, page_end));
+}
+
+static void __pcpu_unmap_pages(unsigned long addr, int nr_pages)
+{
+	unmap_kernel_range_noflush(addr, nr_pages << PAGE_SHIFT);
+}
+
+/**
+ * pcpu_unmap_pages - unmap pages out of a pcpu_chunk
+ * @chunk: chunk of interest
+ * @pages: pages array which can be used to pass information to free
+ * @populated: populated bitmap
+ * @page_start: page index of the first page to unmap
+ * @page_end: page index of the last page to unmap + 1
+ *
+ * For each cpu, unmap pages [@page_start,@page_end) out of @chunk.
+ * Corresponding elements in @pages were cleared by the caller and can
+ * be used to carry information to pcpu_free_pages() which will be
+ * called after all unmaps are finished.  The caller should call
+ * proper pre/post flush functions.
+ */
+static void pcpu_unmap_pages(struct pcpu_chunk *chunk,
+			     struct page **pages, unsigned long *populated,
+			     int page_start, int page_end)
+{
+	unsigned int cpu;
+	int i;
+
+	for_each_possible_cpu(cpu) {
+		for (i = page_start; i < page_end; i++) {
+			struct page *page;
+
+			page = pcpu_chunk_page(chunk, cpu, i);
+			WARN_ON(!page);
+			pages[pcpu_page_idx(cpu, i)] = page;
+		}
+		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, cpu, page_start),
+				   page_end - page_start);
+	}
+
+	for (i = page_start; i < page_end; i++)
+		__clear_bit(i, populated);
+}
+
+/**
+ * pcpu_post_unmap_tlb_flush - flush TLB after unmapping
+ * @chunk: pcpu_chunk the regions to be flushed belong to
+ * @page_start: page index of the first page to be flushed
+ * @page_end: page index of the last page to be flushed + 1
+ *
+ * Pages [@page_start,@page_end) of @chunk have been unmapped.  Flush
+ * TLB for the regions.  This can be skipped if the area is to be
+ * returned to vmalloc as vmalloc will handle TLB flushing lazily.
+ *
+ * As with pcpu_pre_unmap_flush(), TLB flushing also is done at once
+ * for the whole region.
+ */
+static void pcpu_post_unmap_tlb_flush(struct pcpu_chunk *chunk,
+				      int page_start, int page_end)
+{
+	flush_tlb_kernel_range(
+		pcpu_chunk_addr(chunk, pcpu_first_unit_cpu, page_start),
+		pcpu_chunk_addr(chunk, pcpu_last_unit_cpu, page_end));
+}
+
+static int __pcpu_map_pages(unsigned long addr, struct page **pages,
+			    int nr_pages)
+{
+	return map_kernel_range_noflush(addr, nr_pages << PAGE_SHIFT,
+					PAGE_KERNEL, pages);
+}
+
+/**
+ * pcpu_map_pages - map pages into a pcpu_chunk
+ * @chunk: chunk of interest
+ * @pages: pages array containing pages to be mapped
+ * @populated: populated bitmap
+ * @page_start: page index of the first page to map
+ * @page_end: page index of the last page to map + 1
+ *
+ * For each cpu, map pages [@page_start,@page_end) into @chunk.  The
+ * caller is responsible for calling pcpu_post_map_flush() after all
+ * mappings are complete.
+ *
+ * This function is responsible for setting corresponding bits in
+ * @chunk->populated bitmap and whatever is necessary for reverse
+ * lookup (addr -> chunk).
+ */
+static int pcpu_map_pages(struct pcpu_chunk *chunk,
+			  struct page **pages, unsigned long *populated,
+			  int page_start, int page_end)
+{
+	unsigned int cpu, tcpu;
+	int i, err;
+
+	for_each_possible_cpu(cpu) {
+		err = __pcpu_map_pages(pcpu_chunk_addr(chunk, cpu, page_start),
+				       &pages[pcpu_page_idx(cpu, page_start)],
+				       page_end - page_start);
+		if (err < 0)
+			goto err;
+	}
+
+	/* mapping successful, link chunk and mark populated */
+	for (i = page_start; i < page_end; i++) {
+		for_each_possible_cpu(cpu)
+			pcpu_set_page_chunk(pages[pcpu_page_idx(cpu, i)],
+					    chunk);
+		__set_bit(i, populated);
+	}
+
+	return 0;
+
+err:
+	for_each_possible_cpu(tcpu) {
+		if (tcpu == cpu)
+			break;
+		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, tcpu, page_start),
+				   page_end - page_start);
+	}
+	return err;
+}
+
+/**
+ * pcpu_post_map_flush - flush cache after mapping
+ * @chunk: pcpu_chunk the regions to be flushed belong to
+ * @page_start: page index of the first page to be flushed
+ * @page_end: page index of the last page to be flushed + 1
+ *
+ * Pages [@page_start,@page_end) of @chunk have been mapped.  Flush
+ * cache.
+ *
+ * As with pcpu_pre_unmap_flush(), TLB flushing also is done at once
+ * for the whole region.
+ */
+static void pcpu_post_map_flush(struct pcpu_chunk *chunk,
+				int page_start, int page_end)
+{
+	flush_cache_vmap(
+		pcpu_chunk_addr(chunk, pcpu_first_unit_cpu, page_start),
+		pcpu_chunk_addr(chunk, pcpu_last_unit_cpu, page_end));
+}
+
+/**
+ * pcpu_populate_chunk - populate and map an area of a pcpu_chunk
+ * @chunk: chunk of interest
+ * @off: offset to the area to populate
+ * @size: size of the area to populate in bytes
+ *
+ * For each cpu, populate and map pages [@page_start,@page_end) into
+ * @chunk.  The area is cleared on return.
+ *
+ * CONTEXT:
+ * pcpu_alloc_mutex, does GFP_KERNEL allocation.
+ */
+static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
+{
+	int page_start = PFN_DOWN(off);
+	int page_end = PFN_UP(off + size);
+	int free_end = page_start, unmap_end = page_start;
+	struct page **pages;
+	unsigned long *populated;
+	unsigned int cpu;
+	int rs, re, rc;
+
+	/* quick path, check whether all pages are already there */
+	rs = page_start;
+	pcpu_next_pop(chunk, &rs, &re, page_end);
+	if (rs == page_start && re == page_end)
+		goto clear;
+
+	/* need to allocate and map pages, this chunk can't be immutable */
+	WARN_ON(chunk->immutable);
+
+	pages = pcpu_get_pages_and_bitmap(chunk, &populated, true);
+	if (!pages)
+		return -ENOMEM;
+
+	/* alloc and map */
+	pcpu_for_each_unpop_region(chunk, rs, re, page_start, page_end) {
+		rc = pcpu_alloc_pages(chunk, pages, populated, rs, re);
+		if (rc)
+			goto err_free;
+		free_end = re;
+	}
+
+	pcpu_for_each_unpop_region(chunk, rs, re, page_start, page_end) {
+		rc = pcpu_map_pages(chunk, pages, populated, rs, re);
+		if (rc)
+			goto err_unmap;
+		unmap_end = re;
+	}
+	pcpu_post_map_flush(chunk, page_start, page_end);
+
+	/* commit new bitmap */
+	bitmap_copy(chunk->populated, populated, pcpu_unit_pages);
+clear:
+	for_each_possible_cpu(cpu)
+		memset((void *)pcpu_chunk_addr(chunk, cpu, 0) + off, 0, size);
+	return 0;
+
+err_unmap:
+	pcpu_pre_unmap_flush(chunk, page_start, unmap_end);
+	pcpu_for_each_unpop_region(chunk, rs, re, page_start, unmap_end)
+		pcpu_unmap_pages(chunk, pages, populated, rs, re);
+	pcpu_post_unmap_tlb_flush(chunk, page_start, unmap_end);
+err_free:
+	pcpu_for_each_unpop_region(chunk, rs, re, page_start, free_end)
+		pcpu_free_pages(chunk, pages, populated, rs, re);
+	return rc;
+}
+
+/**
+ * pcpu_depopulate_chunk - depopulate and unmap an area of a pcpu_chunk
+ * @chunk: chunk to depopulate
+ * @off: offset to the area to depopulate
+ * @size: size of the area to depopulate in bytes
+ * @flush: whether to flush cache and tlb or not
+ *
+ * For each cpu, depopulate and unmap pages [@page_start,@page_end)
+ * from @chunk.  If @flush is true, vcache is flushed before unmapping
+ * and tlb after.
+ *
+ * CONTEXT:
+ * pcpu_alloc_mutex.
+ */
+static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size)
+{
+	int page_start = PFN_DOWN(off);
+	int page_end = PFN_UP(off + size);
+	struct page **pages;
+	unsigned long *populated;
+	int rs, re;
+
+	/* quick path, check whether it's empty already */
+	rs = page_start;
+	pcpu_next_unpop(chunk, &rs, &re, page_end);
+	if (rs == page_start && re == page_end)
+		return;
+
+	/* immutable chunks can't be depopulated */
+	WARN_ON(chunk->immutable);
+
+	/*
+	 * If control reaches here, there must have been at least one
+	 * successful population attempt so the temp pages array must
+	 * be available now.
+	 */
+	pages = pcpu_get_pages_and_bitmap(chunk, &populated, false);
+	BUG_ON(!pages);
+
+	/* unmap and free */
+	pcpu_pre_unmap_flush(chunk, page_start, page_end);
+
+	pcpu_for_each_pop_region(chunk, rs, re, page_start, page_end)
+		pcpu_unmap_pages(chunk, pages, populated, rs, re);
+
+	/* no need to flush tlb, vmalloc will handle it lazily */
+
+	pcpu_for_each_pop_region(chunk, rs, re, page_start, page_end)
+		pcpu_free_pages(chunk, pages, populated, rs, re);
+
+	/* commit new bitmap */
+	bitmap_copy(chunk->populated, populated, pcpu_unit_pages);
+}
+
+static struct pcpu_chunk *pcpu_create_chunk(void)
+{
+	struct pcpu_chunk *chunk;
+	struct vm_struct **vms;
+
+	chunk = pcpu_alloc_chunk();
+	if (!chunk)
+		return NULL;
+
+	vms = pcpu_get_vm_areas(pcpu_group_offsets, pcpu_group_sizes,
+				pcpu_nr_groups, pcpu_atom_size, GFP_KERNEL);
+	if (!vms) {
+		pcpu_free_chunk(chunk);
+		return NULL;
+	}
+
+	chunk->data = vms;
+	chunk->base_addr = vms[0]->addr - pcpu_group_offsets[0];
+	return chunk;
+}
+
+static void pcpu_destroy_chunk(struct pcpu_chunk *chunk)
+{
+	if (chunk && chunk->data)
+		pcpu_free_vm_areas(chunk->data, pcpu_nr_groups);
+	pcpu_free_chunk(chunk);
+}
+
+static struct page *pcpu_addr_to_page(void *addr)
+{
+	return vmalloc_to_page(addr);
+}
+
+static int __init pcpu_verify_alloc_info(const struct pcpu_alloc_info *ai)
+{
+	/* no extra restriction */
+	return 0;
+}
diff --git a/mm/percpu.c b/mm/percpu.c
index 5bfe4d7..4c5b074 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -236,15 +236,6 @@ static unsigned long __maybe_unused pcpu_chunk_addr(struct pcpu_chunk *chunk,
 		(page_idx << PAGE_SHIFT);
 }
 
-static struct page *pcpu_chunk_page(struct pcpu_chunk *chunk,
-				    unsigned int cpu, int page_idx)
-{
-	/* must not be used on pre-mapped chunk */
-	WARN_ON(chunk->immutable);
-
-	return vmalloc_to_page((void *)pcpu_chunk_addr(chunk, cpu, page_idx));
-}
-
 static void __maybe_unused pcpu_next_unpop(struct pcpu_chunk *chunk,
 					   int *rs, int *re, int end)
 {
@@ -636,425 +627,29 @@ static void pcpu_free_chunk(struct pcpu_chunk *chunk)
 	kfree(chunk);
 }
 
-/**
- * pcpu_get_pages_and_bitmap - get temp pages array and bitmap
- * @chunk: chunk of interest
- * @bitmapp: output parameter for bitmap
- * @may_alloc: may allocate the array
- *
- * Returns pointer to array of pointers to struct page and bitmap,
- * both of which can be indexed with pcpu_page_idx().  The returned
- * array is cleared to zero and *@bitmapp is copied from
- * @chunk->populated.  Note that there is only one array and bitmap
- * and access exclusion is the caller's responsibility.
- *
- * CONTEXT:
- * pcpu_alloc_mutex and does GFP_KERNEL allocation if @may_alloc.
- * Otherwise, don't care.
- *
- * RETURNS:
- * Pointer to temp pages array on success, NULL on failure.
- */
-static struct page **pcpu_get_pages_and_bitmap(struct pcpu_chunk *chunk,
-					       unsigned long **bitmapp,
-					       bool may_alloc)
-{
-	static struct page **pages;
-	static unsigned long *bitmap;
-	size_t pages_size = pcpu_nr_units * pcpu_unit_pages * sizeof(pages[0]);
-	size_t bitmap_size = BITS_TO_LONGS(pcpu_unit_pages) *
-			     sizeof(unsigned long);
-
-	if (!pages || !bitmap) {
-		if (may_alloc && !pages)
-			pages = pcpu_mem_alloc(pages_size);
-		if (may_alloc && !bitmap)
-			bitmap = pcpu_mem_alloc(bitmap_size);
-		if (!pages || !bitmap)
-			return NULL;
-	}
-
-	memset(pages, 0, pages_size);
-	bitmap_copy(bitmap, chunk->populated, pcpu_unit_pages);
-
-	*bitmapp = bitmap;
-	return pages;
-}
-
-/**
- * pcpu_free_pages - free pages which were allocated for @chunk
- * @chunk: chunk pages were allocated for
- * @pages: array of pages to be freed, indexed by pcpu_page_idx()
- * @populated: populated bitmap
- * @page_start: page index of the first page to be freed
- * @page_end: page index of the last page to be freed + 1
- *
- * Free pages [@page_start and @page_end) in @pages for all units.
- * The pages were allocated for @chunk.
- */
-static void pcpu_free_pages(struct pcpu_chunk *chunk,
-			    struct page **pages, unsigned long *populated,
-			    int page_start, int page_end)
-{
-	unsigned int cpu;
-	int i;
-
-	for_each_possible_cpu(cpu) {
-		for (i = page_start; i < page_end; i++) {
-			struct page *page = pages[pcpu_page_idx(cpu, i)];
-
-			if (page)
-				__free_page(page);
-		}
-	}
-}
-
-/**
- * pcpu_alloc_pages - allocates pages for @chunk
- * @chunk: target chunk
- * @pages: array to put the allocated pages into, indexed by pcpu_page_idx()
- * @populated: populated bitmap
- * @page_start: page index of the first page to be allocated
- * @page_end: page index of the last page to be allocated + 1
- *
- * Allocate pages [@page_start,@page_end) into @pages for all units.
- * The allocation is for @chunk.  Percpu core doesn't care about the
- * content of @pages and will pass it verbatim to pcpu_map_pages().
- */
-static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
-			    struct page **pages, unsigned long *populated,
-			    int page_start, int page_end)
-{
-	const gfp_t gfp = GFP_KERNEL | __GFP_HIGHMEM | __GFP_COLD;
-	unsigned int cpu;
-	int i;
-
-	for_each_possible_cpu(cpu) {
-		for (i = page_start; i < page_end; i++) {
-			struct page **pagep = &pages[pcpu_page_idx(cpu, i)];
-
-			*pagep = alloc_pages_node(cpu_to_node(cpu), gfp, 0);
-			if (!*pagep) {
-				pcpu_free_pages(chunk, pages, populated,
-						page_start, page_end);
-				return -ENOMEM;
-			}
-		}
-	}
-	return 0;
-}
-
-/**
- * pcpu_pre_unmap_flush - flush cache prior to unmapping
- * @chunk: chunk the regions to be flushed belongs to
- * @page_start: page index of the first page to be flushed
- * @page_end: page index of the last page to be flushed + 1
- *
- * Pages in [@page_start,@page_end) of @chunk are about to be
- * unmapped.  Flush cache.  As each flushing trial can be very
- * expensive, issue flush on the whole region at once rather than
- * doing it for each cpu.  This could be an overkill but is more
- * scalable.
- */
-static void pcpu_pre_unmap_flush(struct pcpu_chunk *chunk,
-				 int page_start, int page_end)
-{
-	flush_cache_vunmap(
-		pcpu_chunk_addr(chunk, pcpu_first_unit_cpu, page_start),
-		pcpu_chunk_addr(chunk, pcpu_last_unit_cpu, page_end));
-}
-
-static void __pcpu_unmap_pages(unsigned long addr, int nr_pages)
-{
-	unmap_kernel_range_noflush(addr, nr_pages << PAGE_SHIFT);
-}
-
-/**
- * pcpu_unmap_pages - unmap pages out of a pcpu_chunk
- * @chunk: chunk of interest
- * @pages: pages array which can be used to pass information to free
- * @populated: populated bitmap
- * @page_start: page index of the first page to unmap
- * @page_end: page index of the last page to unmap + 1
- *
- * For each cpu, unmap pages [@page_start,@page_end) out of @chunk.
- * Corresponding elements in @pages were cleared by the caller and can
- * be used to carry information to pcpu_free_pages() which will be
- * called after all unmaps are finished.  The caller should call
- * proper pre/post flush functions.
- */
-static void pcpu_unmap_pages(struct pcpu_chunk *chunk,
-			     struct page **pages, unsigned long *populated,
-			     int page_start, int page_end)
-{
-	unsigned int cpu;
-	int i;
-
-	for_each_possible_cpu(cpu) {
-		for (i = page_start; i < page_end; i++) {
-			struct page *page;
-
-			page = pcpu_chunk_page(chunk, cpu, i);
-			WARN_ON(!page);
-			pages[pcpu_page_idx(cpu, i)] = page;
-		}
-		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, cpu, page_start),
-				   page_end - page_start);
-	}
-
-	for (i = page_start; i < page_end; i++)
-		__clear_bit(i, populated);
-}
-
-/**
- * pcpu_post_unmap_tlb_flush - flush TLB after unmapping
- * @chunk: pcpu_chunk the regions to be flushed belong to
- * @page_start: page index of the first page to be flushed
- * @page_end: page index of the last page to be flushed + 1
- *
- * Pages [@page_start,@page_end) of @chunk have been unmapped.  Flush
- * TLB for the regions.  This can be skipped if the area is to be
- * returned to vmalloc as vmalloc will handle TLB flushing lazily.
- *
- * As with pcpu_pre_unmap_flush(), TLB flushing also is done at once
- * for the whole region.
- */
-static void pcpu_post_unmap_tlb_flush(struct pcpu_chunk *chunk,
-				      int page_start, int page_end)
-{
-	flush_tlb_kernel_range(
-		pcpu_chunk_addr(chunk, pcpu_first_unit_cpu, page_start),
-		pcpu_chunk_addr(chunk, pcpu_last_unit_cpu, page_end));
-}
-
-static int __pcpu_map_pages(unsigned long addr, struct page **pages,
-			    int nr_pages)
-{
-	return map_kernel_range_noflush(addr, nr_pages << PAGE_SHIFT,
-					PAGE_KERNEL, pages);
-}
-
-/**
- * pcpu_map_pages - map pages into a pcpu_chunk
- * @chunk: chunk of interest
- * @pages: pages array containing pages to be mapped
- * @populated: populated bitmap
- * @page_start: page index of the first page to map
- * @page_end: page index of the last page to map + 1
- *
- * For each cpu, map pages [@page_start,@page_end) into @chunk.  The
- * caller is responsible for calling pcpu_post_map_flush() after all
- * mappings are complete.
- *
- * This function is responsible for setting corresponding bits in
- * @chunk->populated bitmap and whatever is necessary for reverse
- * lookup (addr -> chunk).
- */
-static int pcpu_map_pages(struct pcpu_chunk *chunk,
-			  struct page **pages, unsigned long *populated,
-			  int page_start, int page_end)
-{
-	unsigned int cpu, tcpu;
-	int i, err;
-
-	for_each_possible_cpu(cpu) {
-		err = __pcpu_map_pages(pcpu_chunk_addr(chunk, cpu, page_start),
-				       &pages[pcpu_page_idx(cpu, page_start)],
-				       page_end - page_start);
-		if (err < 0)
-			goto err;
-	}
-
-	/* mapping successful, link chunk and mark populated */
-	for (i = page_start; i < page_end; i++) {
-		for_each_possible_cpu(cpu)
-			pcpu_set_page_chunk(pages[pcpu_page_idx(cpu, i)],
-					    chunk);
-		__set_bit(i, populated);
-	}
-
-	return 0;
-
-err:
-	for_each_possible_cpu(tcpu) {
-		if (tcpu == cpu)
-			break;
-		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, tcpu, page_start),
-				   page_end - page_start);
-	}
-	return err;
-}
-
-/**
- * pcpu_post_map_flush - flush cache after mapping
- * @chunk: pcpu_chunk the regions to be flushed belong to
- * @page_start: page index of the first page to be flushed
- * @page_end: page index of the last page to be flushed + 1
- *
- * Pages [@page_start,@page_end) of @chunk have been mapped.  Flush
- * cache.
- *
- * As with pcpu_pre_unmap_flush(), TLB flushing also is done at once
- * for the whole region.
- */
-static void pcpu_post_map_flush(struct pcpu_chunk *chunk,
-				int page_start, int page_end)
-{
-	flush_cache_vmap(
-		pcpu_chunk_addr(chunk, pcpu_first_unit_cpu, page_start),
-		pcpu_chunk_addr(chunk, pcpu_last_unit_cpu, page_end));
-}
-
-/**
- * pcpu_depopulate_chunk - depopulate and unmap an area of a pcpu_chunk
- * @chunk: chunk to depopulate
- * @off: offset to the area to depopulate
- * @size: size of the area to depopulate in bytes
- * @flush: whether to flush cache and tlb or not
- *
- * For each cpu, depopulate and unmap pages [@page_start,@page_end)
- * from @chunk.  If @flush is true, vcache is flushed before unmapping
- * and tlb after.
- *
- * CONTEXT:
- * pcpu_alloc_mutex.
- */
-static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size)
-{
-	int page_start = PFN_DOWN(off);
-	int page_end = PFN_UP(off + size);
-	struct page **pages;
-	unsigned long *populated;
-	int rs, re;
-
-	/* quick path, check whether it's empty already */
-	rs = page_start;
-	pcpu_next_unpop(chunk, &rs, &re, page_end);
-	if (rs == page_start && re == page_end)
-		return;
-
-	/* immutable chunks can't be depopulated */
-	WARN_ON(chunk->immutable);
-
-	/*
-	 * If control reaches here, there must have been at least one
-	 * successful population attempt so the temp pages array must
-	 * be available now.
-	 */
-	pages = pcpu_get_pages_and_bitmap(chunk, &populated, false);
-	BUG_ON(!pages);
-
-	/* unmap and free */
-	pcpu_pre_unmap_flush(chunk, page_start, page_end);
-
-	pcpu_for_each_pop_region(chunk, rs, re, page_start, page_end)
-		pcpu_unmap_pages(chunk, pages, populated, rs, re);
-
-	/* no need to flush tlb, vmalloc will handle it lazily */
-
-	pcpu_for_each_pop_region(chunk, rs, re, page_start, page_end)
-		pcpu_free_pages(chunk, pages, populated, rs, re);
-
-	/* commit new bitmap */
-	bitmap_copy(chunk->populated, populated, pcpu_unit_pages);
-}
-
-/**
- * pcpu_populate_chunk - populate and map an area of a pcpu_chunk
- * @chunk: chunk of interest
- * @off: offset to the area to populate
- * @size: size of the area to populate in bytes
- *
- * For each cpu, populate and map pages [@page_start,@page_end) into
- * @chunk.  The area is cleared on return.
- *
- * CONTEXT:
- * pcpu_alloc_mutex, does GFP_KERNEL allocation.
+/*
+ * Chunk management implementation.
+ *
+ * To allow different implementations, chunk alloc/free and
+ * [de]population are implemented in a separate file which is pulled
+ * into this file and compiled together.  The following functions
+ * should be implemented.
+ *
+ * pcpu_populate_chunk		- populate the specified range of a chunk
+ * pcpu_depopulate_chunk	- depopulate the specified range of a chunk
+ * pcpu_create_chunk		- create a new chunk
+ * pcpu_destroy_chunk		- destroy a chunk, always preceded by full depop
+ * pcpu_addr_to_page		- translate address to physical address
+ * pcpu_verify_alloc_info	- check alloc_info is acceptable during init
  */
-static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
-{
-	int page_start = PFN_DOWN(off);
-	int page_end = PFN_UP(off + size);
-	int free_end = page_start, unmap_end = page_start;
-	struct page **pages;
-	unsigned long *populated;
-	unsigned int cpu;
-	int rs, re, rc;
-
-	/* quick path, check whether all pages are already there */
-	rs = page_start;
-	pcpu_next_pop(chunk, &rs, &re, page_end);
-	if (rs == page_start && re == page_end)
-		goto clear;
-
-	/* need to allocate and map pages, this chunk can't be immutable */
-	WARN_ON(chunk->immutable);
-
-	pages = pcpu_get_pages_and_bitmap(chunk, &populated, true);
-	if (!pages)
-		return -ENOMEM;
-
-	/* alloc and map */
-	pcpu_for_each_unpop_region(chunk, rs, re, page_start, page_end) {
-		rc = pcpu_alloc_pages(chunk, pages, populated, rs, re);
-		if (rc)
-			goto err_free;
-		free_end = re;
-	}
-
-	pcpu_for_each_unpop_region(chunk, rs, re, page_start, page_end) {
-		rc = pcpu_map_pages(chunk, pages, populated, rs, re);
-		if (rc)
-			goto err_unmap;
-		unmap_end = re;
-	}
-	pcpu_post_map_flush(chunk, page_start, page_end);
-
-	/* commit new bitmap */
-	bitmap_copy(chunk->populated, populated, pcpu_unit_pages);
-clear:
-	for_each_possible_cpu(cpu)
-		memset((void *)pcpu_chunk_addr(chunk, cpu, 0) + off, 0, size);
-	return 0;
-
-err_unmap:
-	pcpu_pre_unmap_flush(chunk, page_start, unmap_end);
-	pcpu_for_each_unpop_region(chunk, rs, re, page_start, unmap_end)
-		pcpu_unmap_pages(chunk, pages, populated, rs, re);
-	pcpu_post_unmap_tlb_flush(chunk, page_start, unmap_end);
-err_free:
-	pcpu_for_each_unpop_region(chunk, rs, re, page_start, free_end)
-		pcpu_free_pages(chunk, pages, populated, rs, re);
-	return rc;
-}
+static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size);
+static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size);
+static struct pcpu_chunk *pcpu_create_chunk(void);
+static void pcpu_destroy_chunk(struct pcpu_chunk *chunk);
+static struct page *pcpu_addr_to_page(void *addr);
+static int __init pcpu_verify_alloc_info(const struct pcpu_alloc_info *ai);
 
-static void pcpu_destroy_chunk(struct pcpu_chunk *chunk)
-{
-	if (chunk && chunk->data)
-		pcpu_free_vm_areas(chunk->data, pcpu_nr_groups);
-	pcpu_free_chunk(chunk);
-}
-
-static struct pcpu_chunk *pcpu_create_chunk(void)
-{
-	struct pcpu_chunk *chunk;
-	struct vm_struct **vms;
-
-	chunk = pcpu_alloc_chunk();
-	if (!chunk)
-		return NULL;
-
-	vms = pcpu_get_vm_areas(pcpu_group_offsets, pcpu_group_sizes,
-				pcpu_nr_groups, pcpu_atom_size, GFP_KERNEL);
-	if (!vms) {
-		pcpu_free_chunk(chunk);
-		return NULL;
-	}
-
-	chunk->data = vms;
-	chunk->base_addr = vms[0]->addr - pcpu_group_offsets[0];
-	return chunk;
-}
+#include "percpu-vm.c"
 
 /**
  * pcpu_chunk_addr_search - determine chunk containing specified address
@@ -1081,7 +676,7 @@ static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
 	 * there's no need to worry about preemption or cpu hotplug.
 	 */
 	addr += pcpu_unit_offsets[raw_smp_processor_id()];
-	return pcpu_get_page_chunk(vmalloc_to_page(addr));
+	return pcpu_get_page_chunk(pcpu_addr_to_page(addr));
 }
 
 /**
@@ -1381,7 +976,7 @@ phys_addr_t per_cpu_ptr_to_phys(void *addr)
 		else
 			return page_to_phys(vmalloc_to_page(addr));
 	} else
-		return page_to_phys(vmalloc_to_page(addr));
+		return page_to_phys(pcpu_addr_to_page(addr));
 }
 
 static inline size_t pcpu_calc_fc_sizes(size_t static_size,
@@ -1753,6 +1348,7 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	PCPU_SETUP_BUG_ON(ai->unit_size < size_sum);
 	PCPU_SETUP_BUG_ON(ai->unit_size & ~PAGE_MASK);
 	PCPU_SETUP_BUG_ON(ai->unit_size < PCPU_MIN_UNIT_SIZE);
+	PCPU_SETUP_BUG_ON(pcpu_verify_alloc_info(ai) < 0);
 
 	/* process group information and build config tables accordingly */
 	group_offsets = alloc_bootmem(ai->nr_groups * sizeof(group_offsets[0]));
-- 
1.6.4.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab0DAKVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 06:21:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:41172 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043Ab0DAKUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 06:20:54 -0400
Message-ID: <4BB47367.8030305@kernel.org>
Date: Thu, 01 Apr 2010 19:20:23 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: graff yang <graff.yang@gmail.com>
CC: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] mm/nommu.c:Dynamic alloc/free percpu area for nommu
References: <1268989324-7575-1-git-send-email-graff.yang@gmail.com>	 <4BA449E2.3080707@kernel.org> <7d86d44a1003211933h6628ae04vc9d1c393e1733ce5@mail.gmail.com>
In-Reply-To: <7d86d44a1003211933h6628ae04vc9d1c393e1733ce5@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 01 Apr 2010 10:20:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/22/2010 11:33 AM, graff yang wrote:
> I understand the complexity of percpu allocation code. As a nommu
> arch, we have to allocate a bulk of memory in one time to insure its
> contiguous.  And in my implementation, many pages are wasted.  It
> would be better, if the percpu allocation code provide some hooks
> for us.  Thanks for your feedback.

Can you please test the following patch?  You'll need to do the
followings,

* define CONFIG_NEED_PER_CPU_KM from the arch Kconfig.

* CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK must not be defined.  It's not
  compatible with PER_CPU_KM.  EMBED_FIRST_CHUNK should work fine.

* NUMA is not supported.  When setting up the first chunk,
  @cpu_distance_fn should be NULL or report all CPUs to be nearer than
  or at LOCAL_DISTANCE.

* It's best if the chunk size is power of two multiple of PAGE_SIZE.
  Because each chunk is allocated as a contiguous kernel memory block
  using alloc_pages(), memory will be wasted if chunk size is not
  aligned.  percpu code will whine about it.

I've tested it on x86 and it seems to work pretty well.  If this is
acceptable for bfin smp configurations, I'll post properly split patch
series.

Thanks.

Index: work/mm/percpu.c
===================================================================
--- work.orig/mm/percpu.c
+++ work/mm/percpu.c
@@ -1,5 +1,5 @@
 /*
- * linux/mm/percpu.c - percpu memory allocator
+ * mm/percpu.c - percpu memory allocator
  *
  * Copyright (C) 2009		SUSE Linux Products GmbH
  * Copyright (C) 2009		Tejun Heo <tj@kernel.org>
@@ -7,14 +7,13 @@
  * This file is released under the GPLv2.
  *
  * This is percpu allocator which can handle both static and dynamic
- * areas.  Percpu areas are allocated in chunks in vmalloc area.  Each
- * chunk is consisted of boot-time determined number of units and the
- * first chunk is used for static percpu variables in the kernel image
+ * areas.  Percpu areas are allocated in chunks.  Each chunk is
+ * consisted of boot-time determined number of units and the first
+ * chunk is used for static percpu variables in the kernel image
  * (special boot time alloc/init handling necessary as these areas
  * need to be brought up before allocation services are running).
  * Unit grows as necessary and all units grow or shrink in unison.
- * When a chunk is filled up, another chunk is allocated.  ie. in
- * vmalloc area
+ * When a chunk is filled up, another chunk is allocated.
  *
  *  c0                           c1                         c2
  *  -------------------          -------------------        ------------
@@ -99,7 +98,7 @@ struct pcpu_chunk {
 	int			map_used;	/* # of map entries used */
 	int			map_alloc;	/* # of map entries allocated */
 	int			*map;		/* allocation map */
-	struct vm_struct	**vms;		/* mapped vmalloc regions */
+	void			*data;		/* chunk data */
 	bool			immutable;	/* no [de]population allowed */
 	unsigned long		populated[];	/* populated bitmap */
 };
@@ -177,6 +176,21 @@ static struct list_head *pcpu_slot __rea
 static void pcpu_reclaim(struct work_struct *work);
 static DECLARE_WORK(pcpu_reclaim_work, pcpu_reclaim);

+static bool pcpu_addr_in_first_chunk(void *addr)
+{
+	void *first_start = pcpu_first_chunk->base_addr;
+
+	return addr >= first_start && addr < first_start + pcpu_unit_size;
+}
+
+static bool pcpu_addr_in_reserved_chunk(void *addr)
+{
+	void *first_start = pcpu_first_chunk->base_addr;
+
+	return addr >= first_start &&
+		addr < first_start + pcpu_reserved_chunk_limit;
+}
+
 static int __pcpu_size_to_slot(int size)
 {
 	int highbit = fls(size);	/* size is in bytes */
@@ -198,27 +212,6 @@ static int pcpu_chunk_slot(const struct
 	return pcpu_size_to_slot(chunk->free_size);
 }

-static int pcpu_page_idx(unsigned int cpu, int page_idx)
-{
-	return pcpu_unit_map[cpu] * pcpu_unit_pages + page_idx;
-}
-
-static unsigned long pcpu_chunk_addr(struct pcpu_chunk *chunk,
-				     unsigned int cpu, int page_idx)
-{
-	return (unsigned long)chunk->base_addr + pcpu_unit_offsets[cpu] +
-		(page_idx << PAGE_SHIFT);
-}
-
-static struct page *pcpu_chunk_page(struct pcpu_chunk *chunk,
-				    unsigned int cpu, int page_idx)
-{
-	/* must not be used on pre-mapped chunk */
-	WARN_ON(chunk->immutable);
-
-	return vmalloc_to_page((void *)pcpu_chunk_addr(chunk, cpu, page_idx));
-}
-
 /* set the pointer to a chunk in a page struct */
 static void pcpu_set_page_chunk(struct page *page, struct pcpu_chunk *pcpu)
 {
@@ -231,13 +224,27 @@ static struct pcpu_chunk *pcpu_get_page_
 	return (struct pcpu_chunk *)page->index;
 }

-static void pcpu_next_unpop(struct pcpu_chunk *chunk, int *rs, int *re, int end)
+static int __maybe_unused pcpu_page_idx(unsigned int cpu, int page_idx)
+{
+	return pcpu_unit_map[cpu] * pcpu_unit_pages + page_idx;
+}
+
+static unsigned long __maybe_unused pcpu_chunk_addr(struct pcpu_chunk *chunk,
+						unsigned int cpu, int page_idx)
+{
+	return (unsigned long)chunk->base_addr + pcpu_unit_offsets[cpu] +
+		(page_idx << PAGE_SHIFT);
+}
+
+static void __maybe_unused pcpu_next_unpop(struct pcpu_chunk *chunk,
+					   int *rs, int *re, int end)
 {
 	*rs = find_next_zero_bit(chunk->populated, end, *rs);
 	*re = find_next_bit(chunk->populated, end, *rs + 1);
 }

-static void pcpu_next_pop(struct pcpu_chunk *chunk, int *rs, int *re, int end)
+static void __maybe_unused pcpu_next_pop(struct pcpu_chunk *chunk,
+					 int *rs, int *re, int end)
 {
 	*rs = find_next_bit(chunk->populated, end, *rs);
 	*re = find_next_zero_bit(chunk->populated, end, *rs + 1);
@@ -326,36 +333,6 @@ static void pcpu_chunk_relocate(struct p
 }

 /**
- * pcpu_chunk_addr_search - determine chunk containing specified address
- * @addr: address for which the chunk needs to be determined.
- *
- * RETURNS:
- * The address of the found chunk.
- */
-static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
-{
-	void *first_start = pcpu_first_chunk->base_addr;
-
-	/* is it in the first chunk? */
-	if (addr >= first_start && addr < first_start + pcpu_unit_size) {
-		/* is it in the reserved area? */
-		if (addr < first_start + pcpu_reserved_chunk_limit)
-			return pcpu_reserved_chunk;
-		return pcpu_first_chunk;
-	}
-
-	/*
-	 * The address is relative to unit0 which might be unused and
-	 * thus unmapped.  Offset the address to the unit space of the
-	 * current processor before looking it up in the vmalloc
-	 * space.  Note that any possible cpu id can be used here, so
-	 * there's no need to worry about preemption or cpu hotplug.
-	 */
-	addr += pcpu_unit_offsets[raw_smp_processor_id()];
-	return pcpu_get_page_chunk(vmalloc_to_page(addr));
-}
-
-/**
  * pcpu_need_to_extend - determine whether chunk area map needs to be extended
  * @chunk: chunk of interest
  *
@@ -623,434 +600,87 @@ static void pcpu_free_area(struct pcpu_c
 	pcpu_chunk_relocate(chunk, oslot);
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
+static struct pcpu_chunk *pcpu_alloc_chunk(void)
 {
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
+	struct pcpu_chunk *chunk;

-	*bitmapp = bitmap;
-	return pages;
-}
+	chunk = kzalloc(pcpu_chunk_struct_size, GFP_KERNEL);
+	if (!chunk)
+		return NULL;

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
+	chunk->map = pcpu_mem_alloc(PCPU_DFL_MAP_ALLOC * sizeof(chunk->map[0]));
+	chunk->map_alloc = PCPU_DFL_MAP_ALLOC;
+	chunk->map[chunk->map_used++] = pcpu_unit_size;

-	for_each_possible_cpu(cpu) {
-		for (i = page_start; i < page_end; i++) {
-			struct page *page = pages[pcpu_page_idx(cpu, i)];
+	INIT_LIST_HEAD(&chunk->list);
+	chunk->free_size = pcpu_unit_size;
+	chunk->contig_hint = pcpu_unit_size;

-			if (page)
-				__free_page(page);
-		}
-	}
+	return chunk;
 }

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
+static void pcpu_free_chunk(struct pcpu_chunk *chunk)
 {
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
+	if (!chunk)
+		return;
+	pcpu_mem_free(chunk->map, chunk->map_alloc * sizeof(chunk->map[0]));
+	kfree(chunk);
 }

-/**
- * pcpu_pre_unmap_flush - flush cache prior to unmapping
- * @chunk: chunk the regions to be flushed belongs to
- * @page_start: page index of the first page to be flushed
- * @page_end: page index of the last page to be flushed + 1
+/*
+ * Chunk management implementation.
  *
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
+ */
+static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size);
+static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size);
+static struct pcpu_chunk *pcpu_create_chunk(void);
+static void pcpu_destroy_chunk(struct pcpu_chunk *chunk);
+static struct page *pcpu_addr_to_page(void *addr);
+static int __init pcpu_verify_alloc_info(const struct pcpu_alloc_info *ai);
+
+#ifdef CONFIG_NEED_PER_CPU_KM
+#include "percpu-km.c"
+#else
+#include "percpu-vm.c"
+#endif

 /**
- * pcpu_post_unmap_tlb_flush - flush TLB after unmapping
- * @chunk: pcpu_chunk the regions to be flushed belong to
- * @page_start: page index of the first page to be flushed
- * @page_end: page index of the last page to be flushed + 1
- *
- * Pages [@page_start,@page_end) of @chunk have been unmapped.  Flush
- * TLB for the regions.  This can be skipped if the area is to be
- * returned to vmalloc as vmalloc will handle TLB flushing lazily.
+ * pcpu_chunk_addr_search - determine chunk containing specified address
+ * @addr: address for which the chunk needs to be determined.
  *
- * As with pcpu_pre_unmap_flush(), TLB flushing also is done at once
- * for the whole region.
+ * RETURNS:
+ * The address of the found chunk.
  */
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
+static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
 {
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
+	/* is it in the first chunk? */
+	if (pcpu_addr_in_first_chunk(addr)) {
+		/* is it in the reserved area? */
+		if (pcpu_addr_in_reserved_chunk(addr))
+			return pcpu_reserved_chunk;
+		return pcpu_first_chunk;
 	}
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

 	/*
-	 * If control reaches here, there must have been at least one
-	 * successful population attempt so the temp pages array must
-	 * be available now.
+	 * The address is relative to unit0 which might be unused and
+	 * thus unmapped.  Offset the address to the unit space of the
+	 * current processor before looking it up in the vmalloc
+	 * space.  Note that any possible cpu id can be used here, so
+	 * there's no need to worry about preemption or cpu hotplug.
 	 */
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
- */
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
-
-static void free_pcpu_chunk(struct pcpu_chunk *chunk)
-{
-	if (!chunk)
-		return;
-	if (chunk->vms)
-		pcpu_free_vm_areas(chunk->vms, pcpu_nr_groups);
-	pcpu_mem_free(chunk->map, chunk->map_alloc * sizeof(chunk->map[0]));
-	kfree(chunk);
-}
-
-static struct pcpu_chunk *alloc_pcpu_chunk(void)
-{
-	struct pcpu_chunk *chunk;
-
-	chunk = kzalloc(pcpu_chunk_struct_size, GFP_KERNEL);
-	if (!chunk)
-		return NULL;
-
-	chunk->map = pcpu_mem_alloc(PCPU_DFL_MAP_ALLOC * sizeof(chunk->map[0]));
-	chunk->map_alloc = PCPU_DFL_MAP_ALLOC;
-	chunk->map[chunk->map_used++] = pcpu_unit_size;
-
-	chunk->vms = pcpu_get_vm_areas(pcpu_group_offsets, pcpu_group_sizes,
-				       pcpu_nr_groups, pcpu_atom_size,
-				       GFP_KERNEL);
-	if (!chunk->vms) {
-		free_pcpu_chunk(chunk);
-		return NULL;
-	}
-
-	INIT_LIST_HEAD(&chunk->list);
-	chunk->free_size = pcpu_unit_size;
-	chunk->contig_hint = pcpu_unit_size;
-	chunk->base_addr = chunk->vms[0]->addr - pcpu_group_offsets[0];
-
-	return chunk;
+	addr += pcpu_unit_offsets[raw_smp_processor_id()];
+	return pcpu_get_page_chunk(pcpu_addr_to_page(addr));
 }

 /**
@@ -1142,7 +772,7 @@ restart:
 	/* hmmm... no space left, create a new chunk */
 	spin_unlock_irqrestore(&pcpu_lock, flags);

-	chunk = alloc_pcpu_chunk();
+	chunk = pcpu_create_chunk();
 	if (!chunk) {
 		err = "failed to allocate new chunk";
 		goto fail_unlock_mutex;
@@ -1254,7 +884,7 @@ static void pcpu_reclaim(struct work_str

 	list_for_each_entry_safe(chunk, next, &todo, list) {
 		pcpu_depopulate_chunk(chunk, 0, pcpu_unit_size);
-		free_pcpu_chunk(chunk);
+		pcpu_destroy_chunk(chunk);
 	}

 	mutex_unlock(&pcpu_alloc_mutex);
@@ -1343,11 +973,14 @@ bool is_kernel_percpu_address(unsigned l
  */
 phys_addr_t per_cpu_ptr_to_phys(void *addr)
 {
-	if ((unsigned long)addr < VMALLOC_START ||
-			(unsigned long)addr >= VMALLOC_END)
-		return __pa(addr);
-	else
-		return page_to_phys(vmalloc_to_page(addr));
+	if (pcpu_addr_in_first_chunk(addr)) {
+		if ((unsigned long)addr < VMALLOC_START ||
+		    (unsigned long)addr >= VMALLOC_END)
+			return __pa(addr);
+		else
+			return page_to_phys(vmalloc_to_page(addr));
+	} else
+		return page_to_phys(pcpu_addr_to_page(addr));
 }

 static inline size_t pcpu_calc_fc_sizes(size_t static_size,
@@ -1719,6 +1352,7 @@ int __init pcpu_setup_first_chunk(const
 	PCPU_SETUP_BUG_ON(ai->unit_size < size_sum);
 	PCPU_SETUP_BUG_ON(ai->unit_size & ~PAGE_MASK);
 	PCPU_SETUP_BUG_ON(ai->unit_size < PCPU_MIN_UNIT_SIZE);
+	PCPU_SETUP_BUG_ON(pcpu_verify_alloc_info(ai) < 0);

 	/* process group information and build config tables accordingly */
 	group_offsets = alloc_bootmem(ai->nr_groups * sizeof(group_offsets[0]));
Index: work/mm/percpu-vm.c
===================================================================
--- /dev/null
+++ work/mm/percpu-vm.c
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
Index: work/mm/percpu-km.c
===================================================================
--- /dev/null
+++ work/mm/percpu-km.c
@@ -0,0 +1,87 @@
+/*
+ * mm/percpu-km.c - kernel memory based chunk allocation
+ *
+ * Copyright (C) 2010		SUSE Linux Products GmbH
+ * Copyright (C) 2010		Tejun Heo <tj@kernel.org>
+ *
+ * This file is released under the GPLv2.
+ *
+ * Chunks are allocated as a contiguous kernel memory using gfp
+ * allocation.  This is to be used on nommu architectures.
+ */
+
+#ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
+#error "contiguous percpu allocation is incompatible with paged first chunk"
+#endif
+
+#include <linux/log2.h>
+
+static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
+{
+	/* noop */
+	return 0;
+}
+
+static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size)
+{
+	/* nada */
+}
+
+static struct pcpu_chunk *pcpu_create_chunk(void)
+{
+	const int nr_pages = pcpu_group_sizes[0] >> PAGE_SHIFT;
+	struct pcpu_chunk *chunk;
+	struct page *pages;
+	int i;
+
+	chunk = pcpu_alloc_chunk();
+	if (!chunk)
+		return NULL;
+
+	pages = alloc_pages(GFP_KERNEL, order_base_2(nr_pages));
+	if (!pages) {
+		pcpu_free_chunk(chunk);
+		return NULL;
+	}
+
+	for (i = 0; i < nr_pages; i++)
+		pcpu_set_page_chunk(nth_page(pages, i), chunk);
+
+	chunk->data = pages;
+	chunk->base_addr = page_address(pages) - pcpu_group_offsets[0];
+	return chunk;
+}
+
+static void pcpu_destroy_chunk(struct pcpu_chunk *chunk)
+{
+	const int nr_pages = pcpu_group_sizes[0] >> PAGE_SHIFT;
+
+	if (chunk && chunk->data)
+		__free_pages(chunk->data, order_base_2(nr_pages));
+	kfree(chunk);
+}
+
+static struct page *pcpu_addr_to_page(void *addr)
+{
+	return virt_to_page(addr);
+}
+
+static int __init pcpu_verify_alloc_info(const struct pcpu_alloc_info *ai)
+{
+	size_t nr_pages, alloc_pages;
+
+	/* all units must be in a single group */
+	if (ai->nr_groups != 1) {
+		printk(KERN_CRIT "percpu: can't handle more than one groups\n");
+		return -EINVAL;
+	}
+
+	nr_pages = (ai->groups[0].nr_units * ai->unit_size) >> PAGE_SHIFT;
+	alloc_pages = roundup_pow_of_two(nr_pages);
+
+	if (alloc_pages > nr_pages)
+		printk(KERN_WARNING "percpu: wasting %zu pages per chunk\n",
+		       alloc_pages - nr_pages);
+
+	return 0;
+}

-- 
tejun

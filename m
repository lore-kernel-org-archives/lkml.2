Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab0DHEMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 00:12:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:53245 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab0DHEM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 00:12:29 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, graff.yang@gmail.com, dhowells@redhat.com,
       akpm@linux-foundation.org, uclinux-dist-devel@blackfin.uclinux.org,
       sonic.adi@gmail.com, cl@linux-foundation.org, mingo@elte.hu
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/5] percpu: misc preparations for nommu support
Date: Thu,  8 Apr 2010 13:11:03 +0900
Message-Id: <1270699865-16954-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270699865-16954-1-git-send-email-tj@kernel.org>
References: <1270699865-16954-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 08 Apr 2010 04:11:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the following misc preparations for percpu nommu support.

* Remove refernces to vmalloc in common comments as nommu percpu won't
  use it.

* Rename chunk->vms to chunk->data and make it void *.  Its use is
  determined by chunk management implementation.

* Relocate utility functions and add __maybe_unused to functions which
  might not be used by different chunk management implementations.

This patch doesn't cause any functional change.  This is to allow
alternate chunk management implementation for percpu nommu support.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Graff Yang <graff.yang@gmail.com>
Cc: Sonic Zhang <sonic.adi@gmail.com>
Cc: David Howells <dhowells@redhat.com>
---
 mm/percpu.c |  111 ++++++++++++++++++++++++++++++-----------------------------
 1 files changed, 56 insertions(+), 55 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index c30ca03..5bfe4d7 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
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
@@ -213,13 +212,25 @@ static int pcpu_chunk_slot(const struct pcpu_chunk *chunk)
 	return pcpu_size_to_slot(chunk->free_size);
 }
 
-static int pcpu_page_idx(unsigned int cpu, int page_idx)
+/* set the pointer to a chunk in a page struct */
+static void pcpu_set_page_chunk(struct page *page, struct pcpu_chunk *pcpu)
+{
+	page->index = (unsigned long)pcpu;
+}
+
+/* obtain pointer to a chunk from a page struct */
+static struct pcpu_chunk *pcpu_get_page_chunk(struct page *page)
+{
+	return (struct pcpu_chunk *)page->index;
+}
+
+static int __maybe_unused pcpu_page_idx(unsigned int cpu, int page_idx)
 {
 	return pcpu_unit_map[cpu] * pcpu_unit_pages + page_idx;
 }
 
-static unsigned long pcpu_chunk_addr(struct pcpu_chunk *chunk,
-				     unsigned int cpu, int page_idx)
+static unsigned long __maybe_unused pcpu_chunk_addr(struct pcpu_chunk *chunk,
+						unsigned int cpu, int page_idx)
 {
 	return (unsigned long)chunk->base_addr + pcpu_unit_offsets[cpu] +
 		(page_idx << PAGE_SHIFT);
@@ -234,25 +245,15 @@ static struct page *pcpu_chunk_page(struct pcpu_chunk *chunk,
 	return vmalloc_to_page((void *)pcpu_chunk_addr(chunk, cpu, page_idx));
 }
 
-/* set the pointer to a chunk in a page struct */
-static void pcpu_set_page_chunk(struct page *page, struct pcpu_chunk *pcpu)
-{
-	page->index = (unsigned long)pcpu;
-}
-
-/* obtain pointer to a chunk from a page struct */
-static struct pcpu_chunk *pcpu_get_page_chunk(struct page *page)
-{
-	return (struct pcpu_chunk *)page->index;
-}
-
-static void pcpu_next_unpop(struct pcpu_chunk *chunk, int *rs, int *re, int end)
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
@@ -341,34 +342,6 @@ static void pcpu_chunk_relocate(struct pcpu_chunk *chunk, int oslot)
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
-	/* is it in the first chunk? */
-	if (pcpu_addr_in_first_chunk(addr)) {
-		/* is it in the reserved area? */
-		if (pcpu_addr_in_reserved_chunk(addr))
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
@@ -1057,8 +1030,8 @@ err_free:
 
 static void pcpu_destroy_chunk(struct pcpu_chunk *chunk)
 {
-	if (chunk && chunk->vms)
-		pcpu_free_vm_areas(chunk->vms, pcpu_nr_groups);
+	if (chunk && chunk->data)
+		pcpu_free_vm_areas(chunk->data, pcpu_nr_groups);
 	pcpu_free_chunk(chunk);
 }
 
@@ -1078,12 +1051,40 @@ static struct pcpu_chunk *pcpu_create_chunk(void)
 		return NULL;
 	}
 
-	chunk->vms = vms;
+	chunk->data = vms;
 	chunk->base_addr = vms[0]->addr - pcpu_group_offsets[0];
 	return chunk;
 }
 
 /**
+ * pcpu_chunk_addr_search - determine chunk containing specified address
+ * @addr: address for which the chunk needs to be determined.
+ *
+ * RETURNS:
+ * The address of the found chunk.
+ */
+static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
+{
+	/* is it in the first chunk? */
+	if (pcpu_addr_in_first_chunk(addr)) {
+		/* is it in the reserved area? */
+		if (pcpu_addr_in_reserved_chunk(addr))
+			return pcpu_reserved_chunk;
+		return pcpu_first_chunk;
+	}
+
+	/*
+	 * The address is relative to unit0 which might be unused and
+	 * thus unmapped.  Offset the address to the unit space of the
+	 * current processor before looking it up in the vmalloc
+	 * space.  Note that any possible cpu id can be used here, so
+	 * there's no need to worry about preemption or cpu hotplug.
+	 */
+	addr += pcpu_unit_offsets[raw_smp_processor_id()];
+	return pcpu_get_page_chunk(vmalloc_to_page(addr));
+}
+
+/**
  * pcpu_alloc - the percpu allocator
  * @size: size of area to allocate in bytes
  * @align: alignment of area (max PAGE_SIZE)
-- 
1.6.4.2


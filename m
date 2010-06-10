Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901Ab0FJLLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:11:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39173 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867Ab0FJLK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:10:57 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20100610110.764742110@firstfloor.org>
In-Reply-To: <20100610110.764742110@firstfloor.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [20/23] MM: Fix unused but set warnings
Message-Id: <20100610111056.557F8B1A2B@basil.firstfloor.org>
Date: Thu, 10 Jun 2010 13:10:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No real bugs, just some dead code and some fixups.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/pgtable_64.h |    4 ++--
 include/linux/highmem.h           |    6 +++++-
 include/linux/mmdebug.h           |    2 +-
 mm/filemap.c                      |    2 --
 mm/memory.c                       |    2 --
 mm/slab.c                         |    2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

Index: linux-2.6.35-rc2-gcc/mm/filemap.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/mm/filemap.c
+++ linux-2.6.35-rc2-gcc/mm/filemap.c
@@ -2238,14 +2238,12 @@ static ssize_t generic_perform_write(str
 
 	do {
 		struct page *page;
-		pgoff_t index;		/* Pagecache index for current page */
 		unsigned long offset;	/* Offset into pagecache page */
 		unsigned long bytes;	/* Bytes to write to page */
 		size_t copied;		/* Bytes copied from user */
 		void *fsdata;
 
 		offset = (pos & (PAGE_CACHE_SIZE - 1));
-		index = pos >> PAGE_CACHE_SHIFT;
 		bytes = min_t(unsigned long, PAGE_CACHE_SIZE - offset,
 						iov_iter_count(i));
 
Index: linux-2.6.35-rc2-gcc/mm/memory.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/mm/memory.c
+++ linux-2.6.35-rc2-gcc/mm/memory.c
@@ -307,7 +307,6 @@ void free_pgd_range(struct mmu_gather *t
 {
 	pgd_t *pgd;
 	unsigned long next;
-	unsigned long start;
 
 	/*
 	 * The next few lines have given us lots of grief...
@@ -351,7 +350,6 @@ void free_pgd_range(struct mmu_gather *t
 	if (addr > end - 1)
 		return;
 
-	start = addr;
 	pgd = pgd_offset(tlb->mm, addr);
 	do {
 		next = pgd_addr_end(addr, end);
Index: linux-2.6.35-rc2-gcc/arch/x86/include/asm/pgtable_64.h
===================================================================
--- linux-2.6.35-rc2-gcc.orig/arch/x86/include/asm/pgtable_64.h
+++ linux-2.6.35-rc2-gcc/arch/x86/include/asm/pgtable_64.h
@@ -126,8 +126,8 @@ static inline int pgd_large(pgd_t pgd) {
 /* x86-64 always has all page tables mapped. */
 #define pte_offset_map(dir, address) pte_offset_kernel((dir), (address))
 #define pte_offset_map_nested(dir, address) pte_offset_kernel((dir), (address))
-#define pte_unmap(pte) /* NOP */
-#define pte_unmap_nested(pte) /* NOP */
+#define pte_unmap(pte) ((void)(pte))/* NOP */
+#define pte_unmap_nested(pte) ((void)(pte)) /* NOP */
 
 #define update_mmu_cache(vma, address, ptep) do { } while (0)
 
Index: linux-2.6.35-rc2-gcc/include/linux/mmdebug.h
===================================================================
--- linux-2.6.35-rc2-gcc.orig/include/linux/mmdebug.h
+++ linux-2.6.35-rc2-gcc/include/linux/mmdebug.h
@@ -4,7 +4,7 @@
 #ifdef CONFIG_DEBUG_VM
 #define VM_BUG_ON(cond) BUG_ON(cond)
 #else
-#define VM_BUG_ON(cond) do { } while (0)
+#define VM_BUG_ON(cond) do { (void)(cond); } while (0)
 #endif
 
 #ifdef CONFIG_DEBUG_VIRTUAL
Index: linux-2.6.35-rc2-gcc/mm/slab.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/mm/slab.c
+++ linux-2.6.35-rc2-gcc/mm/slab.c
@@ -395,7 +395,7 @@ static void kmem_list3_init(struct kmem_
 #define	STATS_DEC_ACTIVE(x)	do { } while (0)
 #define	STATS_INC_ALLOCED(x)	do { } while (0)
 #define	STATS_INC_GROWN(x)	do { } while (0)
-#define	STATS_ADD_REAPED(x,y)	do { } while (0)
+#define	STATS_ADD_REAPED(x,y)	do { (void)(y); } while (0)
 #define	STATS_SET_HIGH(x)	do { } while (0)
 #define	STATS_INC_ERR(x)	do { } while (0)
 #define	STATS_INC_NODEALLOCS(x)	do { } while (0)
Index: linux-2.6.35-rc2-gcc/include/linux/highmem.h
===================================================================
--- linux-2.6.35-rc2-gcc.orig/include/linux/highmem.h
+++ linux-2.6.35-rc2-gcc/include/linux/highmem.h
@@ -72,7 +72,11 @@ static inline void *kmap_atomic(struct p
 }
 #define kmap_atomic_prot(page, idx, prot)	kmap_atomic(page, idx)
 
-#define kunmap_atomic(addr, idx)	do { pagefault_enable(); } while (0)
+static inline void kunmap_atomic(void *addr, enum km_type idx)
+{
+	pagefault_enable();
+}
+
 #define kmap_atomic_pfn(pfn, idx)	kmap_atomic(pfn_to_page(pfn), (idx))
 #define kmap_atomic_to_page(ptr)	virt_to_page(ptr)
 

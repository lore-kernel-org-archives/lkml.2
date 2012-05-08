Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab2EHSzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:55:48 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:43079 "HELO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752618Ab2EHSzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:55:47 -0400
From: Pravin B Shelar <pshelar@nicira.com>
To: cl@linux.com, penberg@kernel.org, mpm@selenic.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jesse@nicira.com,
        abhide@nicira.com, Pravin B Shelar <pshelar@nicira.com>
Subject: [PATCH] mm: sl[auo]b: Use atomic bit operations to update page-flags.
Date: Tue,  8 May 2012 11:55:39 -0700
Message-Id: <1336503339-18722-1-git-send-email-pshelar@nicira.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Transparent huge pages can change page->flags (PG_compound_lock)
without taking Slab lock. So sl[auo]b need to use atomic bit
operation while changing page->flags.
Specificly this patch fixes race between compound_unlock and slab
functions which does page-flags update. This can occur when
get_page/put_page is called on page from slab object.

Reported-by: Amey Bhide <abhide@nicira.com>
Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
---
 include/linux/page-flags.h |    4 ++--
 mm/slab.c                  |    4 ++--
 mm/slob.c                  |    8 ++++----
 mm/slub.c                  |    4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index c88d2a9..ba5b275 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -201,14 +201,14 @@ PAGEFLAG(Dirty, dirty) TESTSCFLAG(Dirty, dirty) __CLEARPAGEFLAG(Dirty, dirty)
 PAGEFLAG(LRU, lru) __CLEARPAGEFLAG(LRU, lru)
 PAGEFLAG(Active, active) __CLEARPAGEFLAG(Active, active)
 	TESTCLEARFLAG(Active, active)
-__PAGEFLAG(Slab, slab)
+PAGEFLAG(Slab, slab)
 PAGEFLAG(Checked, checked)		/* Used by some filesystems */
 PAGEFLAG(Pinned, pinned) TESTSCFLAG(Pinned, pinned)	/* Xen */
 PAGEFLAG(SavePinned, savepinned);			/* Xen */
 PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
 PAGEFLAG(SwapBacked, swapbacked) __CLEARPAGEFLAG(SwapBacked, swapbacked)
 
-__PAGEFLAG(SlobFree, slob_free)
+PAGEFLAG(SlobFree, slob_free)
 
 /*
  * Private page markings that may be used by the filesystem that owns the page
diff --git a/mm/slab.c b/mm/slab.c
index e901a36..55e8c61 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1817,7 +1817,7 @@ static void *kmem_getpages(struct kmem_cache *cachep, gfp_t flags, int nodeid)
 		add_zone_page_state(page_zone(page),
 			NR_SLAB_UNRECLAIMABLE, nr_pages);
 	for (i = 0; i < nr_pages; i++)
-		__SetPageSlab(page + i);
+		SetPageSlab(page + i);
 
 	if (kmemcheck_enabled && !(cachep->flags & SLAB_NOTRACK)) {
 		kmemcheck_alloc_shadow(page, cachep->gfporder, flags, nodeid);
@@ -1850,7 +1850,7 @@ static void kmem_freepages(struct kmem_cache *cachep, void *addr)
 				NR_SLAB_UNRECLAIMABLE, nr_freed);
 	while (i--) {
 		BUG_ON(!PageSlab(page));
-		__ClearPageSlab(page);
+		ClearPageSlab(page);
 		page++;
 	}
 	if (current->reclaim_state)
diff --git a/mm/slob.c b/mm/slob.c
index 8105be4..7256a1a 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -140,12 +140,12 @@ static inline int is_slob_page(struct slob_page *sp)
 
 static inline void set_slob_page(struct slob_page *sp)
 {
-	__SetPageSlab((struct page *)sp);
+	SetPageSlab((struct page *)sp);
 }
 
 static inline void clear_slob_page(struct slob_page *sp)
 {
-	__ClearPageSlab((struct page *)sp);
+	ClearPageSlab((struct page *)sp);
 }
 
 static inline struct slob_page *slob_page(const void *addr)
@@ -164,13 +164,13 @@ static inline int slob_page_free(struct slob_page *sp)
 static void set_slob_page_free(struct slob_page *sp, struct list_head *list)
 {
 	list_add(&sp->list, list);
-	__SetPageSlobFree((struct page *)sp);
+	SetPageSlobFree((struct page *)sp);
 }
 
 static inline void clear_slob_page_free(struct slob_page *sp)
 {
 	list_del(&sp->list);
-	__ClearPageSlobFree((struct page *)sp);
+	ClearPageSlobFree((struct page *)sp);
 }
 
 #define SLOB_UNIT sizeof(slob_t)
diff --git a/mm/slub.c b/mm/slub.c
index 548bd12..0b53cb5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -362,7 +362,7 @@ static __always_inline void slab_lock(struct page *page)
 
 static __always_inline void slab_unlock(struct page *page)
 {
-	__bit_spin_unlock(PG_locked, &page->flags);
+	bit_spin_unlock(PG_locked, &page->flags);
 }
 
 /* Interrupts must be disabled (for the fallback code to work right) */
@@ -1413,7 +1413,7 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
 		-pages);
 
-	__ClearPageSlab(page);
+	ClearPageSlab(page);
 	reset_page_mapcount(page);
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += pages;
-- 
1.7.10


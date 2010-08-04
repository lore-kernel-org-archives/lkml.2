Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248Ab0HDC4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:56:54 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:48633 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932242Ab0HDCwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:52:10 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 6e2QonEVM1kE62f90MJfjwZ10uN1KOOlb8KAF3u8G4P2htk
 CcQLzjDopi0ByHh2Hx9f.Jh3PfKps2YqwE9aIltJYo5t9FFqIAaVKF7JjcBD
 EssYSavxA2Z7JKXCWC4Kcu3HaPXcBXRx98BuDyZnPsibgHD4JGvoPB.37uSG
 IFNApy1Kjg5_ZrmezQjLtmzPJ0yNgQOM9A2b94EQeapXOCAZVt0fn7FOLUgI
 mgaSj1IOGWmqXb8Gs5oEy3cKk3kw8.2n_wv_GYzhfekjREMu9EfQQ6JFr0IQ
 Om5X5X2HWt7eZPdhi
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20100804024527.878097777@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 Aug 2010 21:45:21 -0500
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@suse.de>
Subject: [S+Q3 07/23] slub: Use kmem_cache flags to detect if slab is in debugging mode.
References: <20100804024514.139976032@linux.com>
Content-Disposition: inline; filename=slub_debug_on
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cacheline with the flags is reachable from the hot paths after the
percpu allocator changes went in. So there is no need anymore to put a
flag into each slab page. Get rid of the SlubDebug flag and use
the flags in kmem_cache instead.

Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 include/linux/page-flags.h |    2 --
 mm/slub.c                  |   33 ++++++++++++---------------------
 2 files changed, 12 insertions(+), 23 deletions(-)

Index: linux-2.6/include/linux/page-flags.h
===================================================================
--- linux-2.6.orig/include/linux/page-flags.h	2010-07-28 12:03:19.000000000 -0500
+++ linux-2.6/include/linux/page-flags.h	2010-07-28 12:44:57.000000000 -0500
@@ -128,7 +128,6 @@ enum pageflags {
 
 	/* SLUB */
 	PG_slub_frozen = PG_active,
-	PG_slub_debug = PG_error,
 };
 
 #ifndef __GENERATING_BOUNDS_H
@@ -215,7 +214,6 @@ PAGEFLAG(SwapBacked, swapbacked) __CLEAR
 __PAGEFLAG(SlobFree, slob_free)
 
 __PAGEFLAG(SlubFrozen, slub_frozen)
-__PAGEFLAG(SlubDebug, slub_debug)
 
 /*
  * Private page markings that may be used by the filesystem that owns the page
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-07-28 12:44:56.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-07-28 12:44:57.000000000 -0500
@@ -107,11 +107,17 @@
  * 			the fast path and disables lockless freelists.
  */
 
+#define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
+		SLAB_TRACE | SLAB_DEBUG_FREE)
+
+static inline int kmem_cache_debug(struct kmem_cache *s)
+{
 #ifdef CONFIG_SLUB_DEBUG
-#define SLABDEBUG 1
+	return unlikely(s->flags & SLAB_DEBUG_FLAGS);
 #else
-#define SLABDEBUG 0
+	return 0;
 #endif
+}
 
 /*
  * Issues still to be resolved:
@@ -1157,9 +1163,6 @@ static struct page *new_slab(struct kmem
 	inc_slabs_node(s, page_to_nid(page), page->objects);
 	page->slab = s;
 	page->flags |= 1 << PG_slab;
-	if (s->flags & (SLAB_DEBUG_FREE | SLAB_RED_ZONE | SLAB_POISON |
-			SLAB_STORE_USER | SLAB_TRACE))
-		__SetPageSlubDebug(page);
 
 	start = page_address(page);
 
@@ -1186,14 +1189,13 @@ static void __free_slab(struct kmem_cach
 	int order = compound_order(page);
 	int pages = 1 << order;
 
-	if (unlikely(SLABDEBUG && PageSlubDebug(page))) {
+	if (kmem_cache_debug(s)) {
 		void *p;
 
 		slab_pad_check(s, page);
 		for_each_object(p, s, page_address(page),
 						page->objects)
 			check_object(s, page, p, 0);
-		__ClearPageSlubDebug(page);
 	}
 
 	kmemcheck_free_shadow(page, compound_order(page));
@@ -1415,8 +1417,7 @@ static void unfreeze_slab(struct kmem_ca
 			stat(s, tail ? DEACTIVATE_TO_TAIL : DEACTIVATE_TO_HEAD);
 		} else {
 			stat(s, DEACTIVATE_FULL);
-			if (SLABDEBUG && PageSlubDebug(page) &&
-						(s->flags & SLAB_STORE_USER))
+			if (kmem_cache_debug(s) && (s->flags & SLAB_STORE_USER))
 				add_full(n, page);
 		}
 		slab_unlock(page);
@@ -1624,7 +1625,7 @@ load_freelist:
 	object = c->page->freelist;
 	if (unlikely(!object))
 		goto another_slab;
-	if (unlikely(SLABDEBUG && PageSlubDebug(c->page)))
+	if (kmem_cache_debug(s))
 		goto debug;
 
 	c->freelist = get_freepointer(s, object);
@@ -1783,7 +1784,7 @@ static void __slab_free(struct kmem_cach
 	stat(s, FREE_SLOWPATH);
 	slab_lock(page);
 
-	if (unlikely(SLABDEBUG && PageSlubDebug(page)))
+	if (kmem_cache_debug(s))
 		goto debug;
 
 checks_ok:
@@ -3398,16 +3399,6 @@ static void validate_slab_slab(struct km
 	} else
 		printk(KERN_INFO "SLUB %s: Skipped busy slab 0x%p\n",
 			s->name, page);
-
-	if (s->flags & DEBUG_DEFAULT_FLAGS) {
-		if (!PageSlubDebug(page))
-			printk(KERN_ERR "SLUB %s: SlubDebug not set "
-				"on slab 0x%p\n", s->name, page);
-	} else {
-		if (PageSlubDebug(page))
-			printk(KERN_ERR "SLUB %s: SlubDebug set on "
-				"slab 0x%p\n", s->name, page);
-	}
 }
 
 static int validate_slab_node(struct kmem_cache *s,


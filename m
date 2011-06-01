Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336Ab1FAR2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:28:47 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:26799 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759150Ab1FAR0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:26:17 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: rVO.sSoVM1lBI2BnJYcbcxzTyz5QzRpGar4Bt.KpmZ4K4Ns
 2rM_0qqojqqfgbgMW75jJo_wIFB0SPyXyPODv94PTX8hdm8VpSSdjKtaLdKV
 sb3mWOWB17U2Zhyfa7VMqjzuUDMP3qsxTva5_X9ETOzafUBRtC0VPgw_Kzho
 qDx0qE0iguj_gyLNil4b4Qm0orjxhBrE2A8H5CNH6.4A7g5WpuFF5DdY2MZv
 CYhlnUZwVCvfvH7p0i3k7lQ3qxPvThVB6jLlOdykCgcI2.nnTtTZ0wWz9NiP
 7HWHnCjZrPxcEQUsDaP3UFSwIv0tXbVWodL2QL_RQkhAEcdbz_LYjSUH1zsu
 yoBmuwP47055ejBGqi0D30jjU
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110601172615.848578051@linux.com>
User-Agent: quilt/0.48-1
Date: Wed, 01 Jun 2011 12:25:50 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv7 07/17] slub: explicit list_lock taking
References: <20110601172543.437240675@linux.com>
Content-Disposition: inline; filename=unlock_list_ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The allocator fastpath rework does change the usage of the list_lock.
Remove the list_lock processing from the functions that hide them from the
critical sections and move them into those critical sections.

This in turn simplifies the support functions (no __ variant needed anymore)
and simplifies the lock handling on bootstrap.

Inline add_partial since it becomes pretty simple.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |   89 ++++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 49 insertions(+), 40 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-31 10:14:00.812977367 -0500
+++ linux-2.6/mm/slub.c	2011-05-31 10:14:03.852977349 -0500
@@ -916,26 +916,27 @@ static inline void slab_free_hook(struct
 
 /*
  * Tracking of fully allocated slabs for debugging purposes.
+ *
+ * list_lock must be held.
  */
-static void add_full(struct kmem_cache_node *n, struct page *page)
+static void add_full(struct kmem_cache *s,
+	struct kmem_cache_node *n, struct page *page)
 {
-	spin_lock(&n->list_lock);
+	if (!(s->flags & SLAB_STORE_USER))
+		return;
+
 	list_add(&page->lru, &n->full);
-	spin_unlock(&n->list_lock);
 }
 
+/*
+ * list_lock must be held.
+ */
 static void remove_full(struct kmem_cache *s, struct page *page)
 {
-	struct kmem_cache_node *n;
-
 	if (!(s->flags & SLAB_STORE_USER))
 		return;
 
-	n = get_node(s, page_to_nid(page));
-
-	spin_lock(&n->list_lock);
 	list_del(&page->lru);
-	spin_unlock(&n->list_lock);
 }
 
 /* Tracking of the number of slabs for debugging purposes */
@@ -1060,8 +1061,13 @@ static noinline int free_debug_processin
 	}
 
 	/* Special debug activities for freeing objects */
-	if (!page->frozen && !page->freelist)
+	if (!page->frozen && !page->freelist) {
+		struct kmem_cache_node *n = get_node(s, page_to_nid(page));
+
+		spin_lock(&n->list_lock);
 		remove_full(s, page);
+		spin_unlock(&n->list_lock);
+	}
 	if (s->flags & SLAB_STORE_USER)
 		set_track(s, object, TRACK_FREE, addr);
 	trace(s, page, object, 0);
@@ -1170,7 +1176,8 @@ static inline int slab_pad_check(struct
 			{ return 1; }
 static inline int check_object(struct kmem_cache *s, struct page *page,
 			void *object, u8 val) { return 1; }
-static inline void add_full(struct kmem_cache_node *n, struct page *page) {}
+static inline void add_full(struct kmem_cache *s, struct kmem_cache_node *n,
+					struct page *page) {}
 static inline unsigned long kmem_cache_flags(unsigned long objsize,
 	unsigned long flags, const char *name,
 	void (*ctor)(void *))
@@ -1420,38 +1427,33 @@ static __always_inline int slab_trylock(
 }
 
 /*
- * Management of partially allocated slabs
+ * Management of partially allocated slabs.
+ *
+ * list_lock must be held.
  */
-static void add_partial(struct kmem_cache_node *n,
+static inline void add_partial(struct kmem_cache_node *n,
 				struct page *page, int tail)
 {
-	spin_lock(&n->list_lock);
 	n->nr_partial++;
 	if (tail)
 		list_add_tail(&page->lru, &n->partial);
 	else
 		list_add(&page->lru, &n->partial);
-	spin_unlock(&n->list_lock);
 }
 
-static inline void __remove_partial(struct kmem_cache_node *n,
+/*
+ * list_lock must be held.
+ */
+static inline void remove_partial(struct kmem_cache_node *n,
 					struct page *page)
 {
 	list_del(&page->lru);
 	n->nr_partial--;
 }
 
-static void remove_partial(struct kmem_cache *s, struct page *page)
-{
-	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
-
-	spin_lock(&n->list_lock);
-	__remove_partial(n, page);
-	spin_unlock(&n->list_lock);
-}
-
 /*
- * Lock slab and remove from the partial list.
+ * Lock slab, remove from the partial list and put the object into the
+ * per cpu freelist.
  *
  * Must hold list_lock.
  */
@@ -1459,7 +1461,7 @@ static inline int lock_and_freeze_slab(s
 							struct page *page)
 {
 	if (slab_trylock(page)) {
-		__remove_partial(n, page);
+		remove_partial(n, page);
 		return 1;
 	}
 	return 0;
@@ -1576,12 +1578,17 @@ static void unfreeze_slab(struct kmem_ca
 	if (page->inuse) {
 
 		if (page->freelist) {
+			spin_lock(&n->list_lock);
 			add_partial(n, page, tail);
+			spin_unlock(&n->list_lock);
 			stat(s, tail ? DEACTIVATE_TO_TAIL : DEACTIVATE_TO_HEAD);
 		} else {
 			stat(s, DEACTIVATE_FULL);
-			if (kmem_cache_debug(s) && (s->flags & SLAB_STORE_USER))
-				add_full(n, page);
+			if (kmem_cache_debug(s) && (s->flags & SLAB_STORE_USER)) {
+				spin_lock(&n->list_lock);
+				add_full(s, n, page);
+				spin_unlock(&n->list_lock);
+			}
 		}
 		slab_unlock(page);
 	} else {
@@ -1597,7 +1604,9 @@ static void unfreeze_slab(struct kmem_ca
 			 * kmem_cache_shrink can reclaim any empty slabs from
 			 * the partial list.
 			 */
+			spin_lock(&n->list_lock);
 			add_partial(n, page, 1);
+			spin_unlock(&n->list_lock);
 			slab_unlock(page);
 		} else {
 			slab_unlock(page);
@@ -2099,7 +2108,11 @@ static void __slab_free(struct kmem_cach
 	 * then add it.
 	 */
 	if (unlikely(!prior)) {
+		struct kmem_cache_node *n = get_node(s, page_to_nid(page));
+
+		spin_lock(&n->list_lock);
 		add_partial(get_node(s, page_to_nid(page)), page, 1);
+		spin_unlock(&n->list_lock);
 		stat(s, FREE_ADD_PARTIAL);
 	}
 
@@ -2113,7 +2126,11 @@ slab_empty:
 		/*
 		 * Slab still on the partial list.
 		 */
-		remove_partial(s, page);
+		struct kmem_cache_node *n = get_node(s, page_to_nid(page));
+
+		spin_lock(&n->list_lock);
+		remove_partial(n, page);
+		spin_unlock(&n->list_lock);
 		stat(s, FREE_REMOVE_PARTIAL);
 	}
 	slab_unlock(page);
@@ -2395,7 +2412,6 @@ static void early_kmem_cache_node_alloc(
 {
 	struct page *page;
 	struct kmem_cache_node *n;
-	unsigned long flags;
 
 	BUG_ON(kmem_cache_node->size < sizeof(struct kmem_cache_node));
 
@@ -2422,14 +2438,7 @@ static void early_kmem_cache_node_alloc(
 	init_kmem_cache_node(n, kmem_cache_node);
 	inc_slabs_node(kmem_cache_node, node, page->objects);
 
-	/*
-	 * lockdep requires consistent irq usage for each lock
-	 * so even though there cannot be a race this early in
-	 * the boot sequence, we still disable irqs.
-	 */
-	local_irq_save(flags);
 	add_partial(n, page, 0);
-	local_irq_restore(flags);
 }
 
 static void free_kmem_cache_nodes(struct kmem_cache *s)
@@ -2713,7 +2722,7 @@ static void free_partial(struct kmem_cac
 	spin_lock_irqsave(&n->list_lock, flags);
 	list_for_each_entry_safe(page, h, &n->partial, lru) {
 		if (!page->inuse) {
-			__remove_partial(n, page);
+			remove_partial(n, page);
 			discard_slab(s, page);
 		} else {
 			list_slab_objects(s, page,
@@ -3051,7 +3060,7 @@ int kmem_cache_shrink(struct kmem_cache
 				 * may have freed the last object and be
 				 * waiting to release the slab.
 				 */
-				__remove_partial(n, page);
+				remove_partial(n, page);
 				slab_unlock(page);
 				discard_slab(s, page);
 			} else {


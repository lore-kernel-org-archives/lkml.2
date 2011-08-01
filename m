Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab1HAQ27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 12:28:59 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:47954 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753110Ab1HAQ2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 12:28:51 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: xKjhUtMVM1nFMkjjTFcDpIQyzk9X62k10oPENFwzLQD0Q22
 7sodOW6s05p0_UPlZBc19qeuQMOkFH3afRevliGtRNEp0gSyvAnyCgS1Fd._
 31lYfkSd15FFcw5sX7xAxhTPo0Kksy5OLNxlZQp9OtTZYfRXXRV4Jz6BL.wy
 p18An8UkbsR548Dj6DcZOMW91ep91FQjfhHbRuyGCVH1BCwKycyQ8aPG5ZwO
 dys_Bs_d.nLpVFtVdAhs4Hdnq48lDzem.OIsfxDwz97t3KqxPIF0E6u8IoAi
 4namae15L0VSd_0FKApnNM3UNJrpXk4N.5i2ukEdo3iVXRlkZUeW5Z5UAyVk
 lb7irjwm4qJDaxwzlLUJSf6.E
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Message-Id: <20110801162849.367401409@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 01 Aug 2011 11:28:24 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: tj@kernel.org
Cc: Metathronius Galabant <m.galabant@googlemail.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Adrian Drzewiecki <z@drze.net>
Cc: linux-kernel@vger.kernel.org
Subject: [slub p3 1/7] slub: free slabs without holding locks (V2)
References: <20110801162823.755182213@linux.com>
Content-Disposition: inline; filename=slub_free_wo_locks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two situations in which slub holds a lock while releasing
pages:

	A. During kmem_cache_shrink()
	B. During kmem_cache_close()

For A build a list while holding the lock and then release the pages
later. In case of B we are the last remaining user of the slab so
there is no need to take the listlock.

After this patch all calls to the page allocator to free pages are
done without holding any spinlocks. kmem_cache_destroy() will still
hold the slub_lock semaphore.

V1->V2. Remove kfree. Avoid locking in free_partial.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-08-01 10:22:37.455874973 -0500
+++ linux-2.6/mm/slub.c	2011-08-01 10:24:38.525874198 -0500
@@ -2968,13 +2968,13 @@ static void list_slab_objects(struct kme
 
 /*
  * Attempt to free all partial slabs on a node.
+ * This is called from kmem_cache_close(). We must be the last thread
+ * using the cache and therefore we do not need to lock anymore.
  */
 static void free_partial(struct kmem_cache *s, struct kmem_cache_node *n)
 {
-	unsigned long flags;
 	struct page *page, *h;
 
-	spin_lock_irqsave(&n->list_lock, flags);
 	list_for_each_entry_safe(page, h, &n->partial, lru) {
 		if (!page->inuse) {
 			remove_partial(n, page);
@@ -2984,7 +2984,6 @@ static void free_partial(struct kmem_cac
 				"Objects remaining on kmem_cache_close()");
 		}
 	}
-	spin_unlock_irqrestore(&n->list_lock, flags);
 }
 
 /*
@@ -3018,6 +3017,7 @@ void kmem_cache_destroy(struct kmem_cach
 	s->refcount--;
 	if (!s->refcount) {
 		list_del(&s->list);
+		up_write(&slub_lock);
 		if (kmem_cache_close(s)) {
 			printk(KERN_ERR "SLUB %s: %s called for cache that "
 				"still has objects.\n", s->name, __func__);
@@ -3026,8 +3026,8 @@ void kmem_cache_destroy(struct kmem_cach
 		if (s->flags & SLAB_DESTROY_BY_RCU)
 			rcu_barrier();
 		sysfs_slab_remove(s);
-	}
-	up_write(&slub_lock);
+	} else
+		up_write(&slub_lock);
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
 
@@ -3345,23 +3345,23 @@ int kmem_cache_shrink(struct kmem_cache
 		 * list_lock. page->inuse here is the upper limit.
 		 */
 		list_for_each_entry_safe(page, t, &n->partial, lru) {
-			if (!page->inuse) {
-				remove_partial(n, page);
-				discard_slab(s, page);
-			} else {
-				list_move(&page->lru,
-				slabs_by_inuse + page->inuse);
-			}
+			list_move(&page->lru, slabs_by_inuse + page->inuse);
+			if (!page->inuse)
+				n->nr_partial--;
 		}
 
 		/*
 		 * Rebuild the partial list with the slabs filled up most
 		 * first and the least used slabs at the end.
 		 */
-		for (i = objects - 1; i >= 0; i--)
+		for (i = objects - 1; i > 0; i--)
 			list_splice(slabs_by_inuse + i, n->partial.prev);
 
 		spin_unlock_irqrestore(&n->list_lock, flags);
+
+		/* Release empty slabs */
+		list_for_each_entry_safe(page, t, slabs_by_inuse, lru)
+			discard_slab(s, page);
 	}
 
 	kfree(slabs_by_inuse);


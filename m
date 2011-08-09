Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab1HIVfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 17:35:08 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:32425 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751257Ab1HIVfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 17:35:06 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: NK2dapwVM1nA2GgaUV6zv23VIuWDjKM6dmv4tUJWFG9O5zZ
 gQejgu7V6eJy1qsoWWBcpvQCFnrSVfFJZBJs94MJqkDofRrb8XMDKkEwGhQI
 FErviznZ1Jm8nK9ftDpZbx7.TvH5BeuoIXb7VFPqjs.2f55QqN1u_ptRc92l
 vOn7FqDeBUSJFyoyDWWeT0_JvypEcHsae.nFk7z23ilNsf.ypV2ayUy_y73L
 UswxWu3AbTtRvMfHhaZ.1ZAgbdKHBIphUY3XsWSk4q_YxQG7iaToeOrb4jFL
 WQ5MrnPrBwY467ykFSmZoEvEW2CP.fnlgrSxSloxQKPBKfvJZ5nBQ4XR2spm
 Sjywy6MI4x4paEiV7wpaUFRRJcP1kgma7mNSG.V9nV0l4L7TB00BUY.KF_VA
 S_fi_vNtyH29PMfjd_2.Kog--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Message-Id: <20110809211259.123603907@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 09 Aug 2011 16:12:22 -0500
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
Subject: [slub p4 1/7] slub: free slabs without holding locks (V2)
References: <20110809211221.831975979@linux.com>
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
--- linux-2.6.orig/mm/slub.c	2011-08-09 13:01:59.071582163 -0500
+++ linux-2.6/mm/slub.c	2011-08-09 13:05:00.051582012 -0500
@@ -2970,13 +2970,13 @@ static void list_slab_objects(struct kme
 
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
@@ -2986,7 +2986,6 @@ static void free_partial(struct kmem_cac
 				"Objects remaining on kmem_cache_close()");
 		}
 	}
-	spin_unlock_irqrestore(&n->list_lock, flags);
 }
 
 /*
@@ -3020,6 +3019,7 @@ void kmem_cache_destroy(struct kmem_cach
 	s->refcount--;
 	if (!s->refcount) {
 		list_del(&s->list);
+		up_write(&slub_lock);
 		if (kmem_cache_close(s)) {
 			printk(KERN_ERR "SLUB %s: %s called for cache that "
 				"still has objects.\n", s->name, __func__);
@@ -3028,8 +3028,8 @@ void kmem_cache_destroy(struct kmem_cach
 		if (s->flags & SLAB_DESTROY_BY_RCU)
 			rcu_barrier();
 		sysfs_slab_remove(s);
-	}
-	up_write(&slub_lock);
+	} else
+		up_write(&slub_lock);
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
 
@@ -3347,23 +3347,23 @@ int kmem_cache_shrink(struct kmem_cache
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


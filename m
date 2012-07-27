Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab2G0UTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 16:19:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61325 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab2G0UTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 16:19:04 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>, Christoph Lameter <cl@linux.com>
Subject: [PATCH] slub: remove one code path and reduce lock contention in __slab_free()
Date: Sat, 28 Jul 2012 05:17:51 +0900
Message-Id: <1343420271-3825-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we try to free object, there is some of case that we need
to take a node lock. This is the necessary step for preventing a race.
After taking a lock, then we try to cmpxchg_double_slab().
But, there is a possible scenario that cmpxchg_double_slab() is failed.
Following example explains this.

CPU A               CPU B
need lock
...                 need lock
...                 lock!!
lock..but spin      free success
spin...             unlock
lock!!
free fail

In this case, retry with taking a lock is occured in CPU A.

I think that in this case,
"release a lock first, and re-take a lock if necessary" is preferable way.
There are two reasons for this.
First, this makes __slab_free()'s logic somehow simple.
Second, it may reduce lock contention.
When we do retrying, status of slab is already changed,
so we don't need a lock anymore in almost every case.
"release a lock first, and re-take a lock if necessary" policy is
helpful to this.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
---
This is v2 of "slub: release a lock if freeing object with a lock is failed in __slab_free()"
Subject and commit log are changed from v1.
Code is same as v1.

diff --git a/mm/slub.c b/mm/slub.c
index ca778e5..efce427 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2421,7 +2421,6 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
 	void *prior;
 	void **object = (void *)x;
 	int was_frozen;
-	int inuse;
 	struct page new;
 	unsigned long counters;
 	struct kmem_cache_node *n = NULL;
@@ -2433,13 +2432,17 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
 		return;
 
 	do {
+		if (unlikely(n)) {
+			spin_unlock_irqrestore(&n->list_lock, flags);
+			n = NULL;
+		}
 		prior = page->freelist;
 		counters = page->counters;
 		set_freepointer(s, object, prior);
 		new.counters = counters;
 		was_frozen = new.frozen;
 		new.inuse--;
-		if ((!new.inuse || !prior) && !was_frozen && !n) {
+		if ((!new.inuse || !prior) && !was_frozen) {
 
 			if (!kmem_cache_debug(s) && !prior)
 
@@ -2464,7 +2467,6 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
 
 			}
 		}
-		inuse = new.inuse;
 
 	} while (!cmpxchg_double_slab(s, page,
 		prior, counters,
@@ -2490,25 +2492,17 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
                 return;
         }
 
+	if (unlikely(!new.inuse && n->nr_partial > s->min_partial))
+		goto slab_empty;
+
 	/*
-	 * was_frozen may have been set after we acquired the list_lock in
-	 * an earlier loop. So we need to check it here again.
+	 * Objects left in the slab. If it was not on the partial list before
+	 * then add it.
 	 */
-	if (was_frozen)
-		stat(s, FREE_FROZEN);
-	else {
-		if (unlikely(!inuse && n->nr_partial > s->min_partial))
-                        goto slab_empty;
-
-		/*
-		 * Objects left in the slab. If it was not on the partial list before
-		 * then add it.
-		 */
-		if (unlikely(!prior)) {
-			remove_full(s, page);
-			add_partial(n, page, DEACTIVATE_TO_TAIL);
-			stat(s, FREE_ADD_PARTIAL);
-		}
+	if (kmem_cache_debug(s) && unlikely(!prior)) {
+		remove_full(s, page);
+		add_partial(n, page, DEACTIVATE_TO_TAIL);
+		stat(s, FREE_ADD_PARTIAL);
 	}
 	spin_unlock_irqrestore(&n->list_lock, flags);
 	return;
-- 
1.7.9.5


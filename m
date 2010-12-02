Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab0LBVyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 16:54:43 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:29806 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758093Ab0LBVyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 16:54:05 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: f7K3zMkVM1nm69SDyi7bfN.yRDUolvfEAVDj5ck_lNF7PrI
 Ew0r5w7bj26pxlYR1zN3gt2AE3kaEKKflif.CrRqxsW5Q.VAWtLTE0_LMHT0
 Rz62mTkOut09iMUro3q9Q79Q5Hkq3urPvsyVOjlxCuIUC3kSYVN4paStQYK7
 Ki3oBy1cXUt77lDd1TeWiBrD5PY7EgjzpNCqR6JtxPPOfyLbCNh4pE7epCyT
 DPG_aEkUqVMWQxe7GGGaQZzIVrZvEzmOi7PQ1jra23SoHx6TWeVn0G8_gpOB
 f6SAewtqxAI7S9eJOxOAp
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101202215403.569179520@linux.com>
User-Agent: quilt/0.48-1
Date: Thu, 02 Dec 2010 15:53:48 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Subject: [rfc: cpuops adv V1 8/8] slub: [RFC] Partially lockless freepath slowpath
References: <20101202215340.562309713@linux.com>
Content-Disposition: inline; filename=slub_lockless_slowpath
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The slub slow freepath is frequently invoked since fast frees are only
possible for objects from the current slab page. Optimization of the
slowpath is therefore necessary to increase freeing performance.

This patch supplies a partially lockless slowpath. It addresses the
performance issues related to cycle count in the slow path but not issues
that may arise because cache hotness (that are tracked differently in SLAB).

In the fastpaths we use a cmpxchg_local with segment prefix to perform
freelist insertion. We can provide a similar approach for the slowpath but
there we must use a regular cmpxchg with lock prefix since frees to a page
may occur from multiple processors.

The cmpxchg only updates the freelist in the page struct. We also maintain
an object counter (inuse) in the page structure. That counter is decremented
in a racy way. This means that we may miss a decrement and the counter may
be higher that the actual number of used objects in the slab. The counter
is not used for the determination if the page is filled up though. Thus the
page will cycle via the partial list back to slab_alloc. The counter is then
fixed in allocation processing because allocation takes the whole list for the
per cpu allocation list.

Serialization via the slab_lock() is still performed for any situation in which
the freelist needs to be shrunk. Thus holding the slab_lock prevents the fastpath
from zapping the freelist. This can be used to guarantee that no new object are
allocated from a slab during free.

Results show that the slowpath performance is improved by around 40% to 100%.

10000 Allocations then 10000 frees test

Before (no lockless patches):

10000 times kmalloc(8) -> 207 cycles kfree -> 156 cycles
10000 times kmalloc(16) -> 208 cycles kfree -> 158 cycles
10000 times kmalloc(32) -> 257 cycles kfree -> 159 cycles
10000 times kmalloc(64) -> 383 cycles kfree -> 169 cycles
10000 times kmalloc(128) -> 375 cycles kfree -> 170 cycles
10000 times kmalloc(256) -> 869 cycles kfree -> 187 cycles
10000 times kmalloc(512) -> 1129 cycles kfree -> 307 cycles
10000 times kmalloc(1024) -> 2087 cycles kfree -> 554 cycles
10000 times kmalloc(2048) -> 3912 cycles kfree -> 588 cycles
10000 times kmalloc(4096) -> 7584 cycles kfree -> 664 cycles
10000 times kmalloc(8192) -> 7927 cycles kfree -> 903 cycles
10000 times kmalloc(16384) -> 8625 cycles kfree -> 1308 cycles


After (ll fastpath and slowpath):

10000 times kmalloc(8) -> 125 cycles kfree -> 95 cycles
10000 times kmalloc(16) -> 81 cycles kfree -> 109 cycles
10000 times kmalloc(32) -> 114 cycles kfree -> 101 cycles
10000 times kmalloc(64) -> 193 cycles kfree -> 110 cycles
10000 times kmalloc(128) -> 323 cycles kfree -> 124 cycles
10000 times kmalloc(256) -> 808 cycles kfree -> 141 cycles
10000 times kmalloc(512) -> 1051 cycles kfree -> 264 cycles
10000 times kmalloc(1024) -> 2026 cycles kfree -> 523 cycles
10000 times kmalloc(2048) -> 3970 cycles kfree -> 581 cycles
10000 times kmalloc(4096) -> 7677 cycles kfree -> 683 cycles
10000 times kmalloc(8192) -> 8022 cycles kfree -> 946 cycles
10000 times kmalloc(16384) -> 8641 cycles kfree -> 1286 cycles

10000 (alloc + free) test

Before:

10000 times kmalloc(8)/kfree -> 180 cycles
10000 times kmalloc(16)/kfree -> 180 cycles
10000 times kmalloc(32)/kfree -> 187 cycles
10000 times kmalloc(64)/kfree -> 186 cycles
10000 times kmalloc(128)/kfree -> 190 cycles
10000 times kmalloc(256)/kfree -> 188 cycles
10000 times kmalloc(512)/kfree -> 197 cycles
10000 times kmalloc(1024)/kfree -> 189 cycles
10000 times kmalloc(2048)/kfree -> 190 cycles
10000 times kmalloc(4096)/kfree -> 190 cycles
10000 times kmalloc(8192)/kfree -> 192 cycles
10000 times kmalloc(16384)/kfree -> 758 cycles

After:

10000 times kmalloc(8)/kfree -> 72 cycles
10000 times kmalloc(16)/kfree -> 83 cycles
10000 times kmalloc(32)/kfree -> 72 cycles
10000 times kmalloc(64)/kfree -> 72 cycles
10000 times kmalloc(128)/kfree -> 83 cycles
10000 times kmalloc(256)/kfree -> 93 cycles
10000 times kmalloc(512)/kfree -> 77 cycles
10000 times kmalloc(1024)/kfree -> 76 cycles
10000 times kmalloc(2048)/kfree -> 87 cycles
10000 times kmalloc(4096)/kfree -> 75 cycles
10000 times kmalloc(8192)/kfree -> 77 cycles
10000 times kmalloc(16384)/kfree -> 754 cycles

Concurrent alloc/free on all cpus:

Before:

Kmalloc N*(alloc free)(8): 0=176 1=177 2=176 3=176 4=184 5=176 6=176 7=176 Average=177
Kmalloc N*(alloc free)(16): 0=176 1=176 2=176 3=176 4=176 5=182 6=176 7=182 Average=177
Kmalloc N*(alloc free)(32): 0=178 1=178 2=177 3=178 4=177 5=182 6=178 7=184 Average=179
Kmalloc N*(alloc free)(64): 0=176 1=176 2=176 3=176 4=176 5=182 6=176 7=182 Average=177
Kmalloc N*(alloc free)(128): 0=176 1=178 2=176 3=176 4=176 5=176 6=176 7=182 Average=177
Kmalloc N*(alloc free)(256): 0=176 1=178 2=178 3=178 4=176 5=184 6=178 7=178 Average=178
Kmalloc N*(alloc free)(512): 0=178 1=178 2=178 3=178 4=178 5=182 6=178 7=184 Average=179
Kmalloc N*(alloc free)(1024): 0=178 1=178 2=178 3=188 4=178 5=178 6=178 7=184 Average=180
Kmalloc N*(alloc free)(2048): 0=400 1=177 2=178 3=176 4=282 5=185 6=233 7=237 Average=233
Kmalloc N*(alloc free)(4096): 0=178 1=178 2=178 3=178 4=178 5=184 6=178 7=183 Average=179

After:

Kmalloc N*(alloc free)(8): 0=73 1=73 2=73 3=71 4=71 5=71 6=71 7=75 Average=72
Kmalloc N*(alloc free)(16): 0=74 1=71 2=71 3=72 4=71 5=73 6=71 7=73 Average=72
Kmalloc N*(alloc free)(32): 0=73 1=71 2=71 3=71 4=71 5=71 6=72 7=71 Average=71
Kmalloc N*(alloc free)(64): 0=71 1=74 2=71 3=71 4=73 5=73 6=71 7=71 Average=72
Kmalloc N*(alloc free)(128): 0=71 1=71 2=81 3=73 4=71 5=71 6=75 7=75 Average=73
Kmalloc N*(alloc free)(256): 0=72 1=76 2=76 3=72 4=76 5=76 6=76 7=76 Average=75
Kmalloc N*(alloc free)(512): 0=76 1=76 2=76 3=76 4=72 5=72 6=76 7=76 Average=75
Kmalloc N*(alloc free)(1024): 0=76 1=76 2=76 3=76 4=77 5=76 6=168 7=77 Average=88
Kmalloc N*(alloc free)(2048): 0=81 1=81 2=81 3=81 4=77 5=77 6=72 7=76 Average=78
Kmalloc N*(alloc free)(4096): 0=99 1=76 2=76 3=76 4=77 5=94 6=72 7=76 Average=81


WARNING: The patch is not mature yet. There are unresolved issues around
freelist traversal and fallback for arches not supporting cmpxchg etc.

The resulting kernel so far survived initial testing in kvm with the
in-kernel memory allocator benchmarks and hackbench from user space.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |   65 +++++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 37 insertions(+), 28 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-12-02 15:36:59.000000000 -0600
+++ linux-2.6/mm/slub.c	2010-12-02 15:37:24.000000000 -0600
@@ -1579,6 +1579,10 @@ static void deactivate_slab(struct kmem_
 
 	if (page->freelist)
 		stat(s, DEACTIVATE_REMOTE_FREES);
+	else
+		/* Fix up results of any racy updates */
+		page->inuse = page->objects;
+
 	/*
 	 * Merge cpu freelist into slab freelist. Typically we get here
 	 * because both freelists are empty. So this is unlikely
@@ -1586,6 +1590,7 @@ static void deactivate_slab(struct kmem_
 	 */
 	while (unlikely(c->freelist)) {
 		void **object;
+		void *prior;
 
 		tail = 0;	/* Hot objects. Put the slab first */
 
@@ -1594,8 +1599,11 @@ static void deactivate_slab(struct kmem_
 		c->freelist = get_freepointer(s, c->freelist);
 
 		/* And put onto the regular freelist */
-		set_freepointer(s, object, page->freelist);
-		page->freelist = object;
+redo:
+		prior = page->freelist;
+		set_freepointer(s, object, prior);
+		if (cmpxchg(&page->freelist, prior, object) != prior)
+			goto redo;
 		page->inuse--;
 	}
 	c->page = NULL;
@@ -1763,15 +1771,14 @@ static void *__slab_alloc(struct kmem_ca
 	stat(s, ALLOC_REFILL);
 
 load_freelist:
-	object = c->page->freelist;
+	c->page->inuse = c->page->objects;
+	object = xchg(&c->page->freelist, NULL);
 	if (unlikely(!object))
 		goto another_slab;
 	if (kmem_cache_debug(s))
 		goto debug;
 
 	c->freelist = get_freepointer(s, object);
-	c->page->inuse = c->page->objects;
-	c->page->freelist = NULL;
 	c->node = page_to_nid(c->page);
 unlock_out:
 	slab_unlock(c->page);
@@ -1970,40 +1977,48 @@ static void __slab_free(struct kmem_cach
 {
 	void *prior;
 	void **object = (void *)x;
-#ifdef CONFIG_CMPXCHG_LOCAL
 	unsigned long flags;
 
-	local_irq_save(flags);
-#endif
-	slab_lock(page);
 	stat(s, FREE_SLOWPATH);
-
 	if (kmem_cache_debug(s))
 		goto debug;
 
 checks_ok:
 	prior = page->freelist;
 	set_freepointer(s, object, prior);
-	page->freelist = object;
-	page->inuse--;
+	if (cmpxchg(&page->freelist, prior, object) != prior)
+		goto checks_ok;
 
-	if (unlikely(PageSlubFrozen(page))) {
+	/* Racy update */
+	if (unlikely(PageSlubFrozen(page) || (--page->inuse && prior))) {
 		stat(s, FREE_FROZEN);
-		goto out_unlock;
+		return;
 	}
 
-	if (unlikely(!page->inuse))
-		goto slab_empty;
+#ifdef CONFIG_CMPXCHG_LOCAL
+	local_irq_save(flags);
+#endif
+	slab_lock(page);	/* Locking prevents reduction of free list */
+
+	if (PageSlubFrozen(page))	/* If page has been exempted by now yield */
+		goto out_unlock;
+
+	/*
+	 * Still objects in use but those may be gone at any point now since
+	 * we are not locking out the freepath.
+	 */
 
 	/*
 	 * Objects left in the slab. If it was not on the partial list before
 	 * then add it.
 	 */
-	if (unlikely(!prior)) {
-		add_partial(get_node(s, page_to_nid(page)), page, 1);
-		stat(s, FREE_ADD_PARTIAL);
-	}
+	add_partial(get_node(s, page_to_nid(page)), page, 1);
 
+	if (!page->inuse)
+		/* They are indeed gone and we need to remove the page from the partial list again */
+		goto slab_empty;
+
+	/* Objects left and slab on the partial list */
 out_unlock:
 	slab_unlock(page);
 #ifdef CONFIG_CMPXCHG_LOCAL
@@ -2012,13 +2027,7 @@ out_unlock:
 	return;
 
 slab_empty:
-	if (prior) {
-		/*
-		 * Slab still on the partial list.
-		 */
-		remove_partial(s, page);
-		stat(s, FREE_REMOVE_PARTIAL);
-	}
+	remove_partial(s, page);
 	slab_unlock(page);
 #ifdef CONFIG_CMPXCHG_LOCAL
 	local_irq_restore(flags);
@@ -2029,7 +2038,7 @@ slab_empty:
 
 debug:
 	if (!free_debug_processing(s, page, x, addr))
-		goto out_unlock;
+		return;
 	goto checks_ok;
 }
 


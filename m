Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052Ab1CXQPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:15:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35286 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822Ab1CXQO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 12:14:59 -0400
Date: Thu, 24 Mar 2011 17:14:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: torvalds@linux-foundation.org, cl@linux-foundation.org,
        akpm@linux-foundation.org, tj@kernel.org, npiggin@kernel.dk,
        rientjes@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
Message-ID: <20110324161446.GA32068@elte.hu>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>
 <20110324142146.GA11682@elte.hu>
 <20110324160310.GA27127@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110324160310.GA27127@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Caused by:
> 
> | 8a5ec0ba42c4919e2d8f4c3138cc8b987fdb0b79 is the first bad commit
> | commit 8a5ec0ba42c4919e2d8f4c3138cc8b987fdb0b79
> | Author: Christoph Lameter <cl@linux.com>
> | Date:   Fri Feb 25 11:38:54 2011 -0600
> |
> |    Lockless (and preemptless) fastpaths for slub
> 
> I'll try to revert these:
> 
>  2fd66c517d5e: slub: Add missing irq restore for the OOM path
>  a24c5a0ea902: slub: Dont define useless label in the !CONFIG_CMPXCHG_LOCAL case
>  8a5ec0ba42c4: Lockless (and preemptless) fastpaths for slub

The combo revert below solves the boot crash.

Thanks,

	Ingo

------------------------------->
>From 1b322eee05a96e8395b62e04a3d1f10fb483c259 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 24 Mar 2011 17:03:51 +0100
Subject: [PATCH] Revert various slub patches

Revert "slub: Add missing irq restore for the OOM path"

This reverts commit 2fd66c517d5e98de2528d86e0e62f5069ff99f59.

Revert "slub: Dont define useless label in the !CONFIG_CMPXCHG_LOCAL case"

This reverts commit a24c5a0ea902bcda348f086bd909cc2d6e305bf8.

Revert "slub,rcu: don't assume the size of struct rcu_head"

This reverts commit da9a638c6f8fc0633fa94a334f1c053f5e307177.

Revert "slub: Add statistics for this_cmpxchg_double failures"

This reverts commit 4fdccdfbb4652a7bbac8adbce7449eb093775118.

Revert "Lockless (and preemptless) fastpaths for slub"

This reverts commit 8a5ec0ba42c4919e2d8f4c3138cc8b987fdb0b79.
---
 include/linux/slub_def.h |    6 +-
 mm/slub.c                |  243 ++--------------------------------------------
 2 files changed, 9 insertions(+), 240 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 45ca123..74af3d6 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -32,14 +32,10 @@ enum stat_item {
 	DEACTIVATE_TO_TAIL,	/* Cpu slab was moved to the tail of partials */
 	DEACTIVATE_REMOTE_FREES,/* Slab contained remotely freed objects */
 	ORDER_FALLBACK,		/* Number of times fallback was necessary */
-	CMPXCHG_DOUBLE_CPU_FAIL,/* Failure of this_cpu_cmpxchg_double */
 	NR_SLUB_STAT_ITEMS };
 
 struct kmem_cache_cpu {
-	void **freelist;	/* Pointer to next available object */
-#ifdef CONFIG_CMPXCHG_LOCAL
-	unsigned long tid;	/* Globally unique transaction id */
-#endif
+	void **freelist;	/* Pointer to first free per cpu object */
 	struct page *page;	/* The slab from which we are allocating */
 	int node;		/* The node of the page (or -1 for debug) */
 #ifdef CONFIG_SLUB_STATS
diff --git a/mm/slub.c b/mm/slub.c
index 93de30d..bd84722 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -217,7 +217,7 @@ static inline void sysfs_slab_remove(struct kmem_cache *s)
 
 #endif
 
-static inline void stat(const struct kmem_cache *s, enum stat_item si)
+static inline void stat(struct kmem_cache *s, enum stat_item si)
 {
 #ifdef CONFIG_SLUB_STATS
 	__this_cpu_inc(s->cpu_slab->stat[si]);
@@ -1285,38 +1285,21 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
 	__free_pages(page, order);
 }
 
-#define need_reserve_slab_rcu						\
-	(sizeof(((struct page *)NULL)->lru) < sizeof(struct rcu_head))
-
 static void rcu_free_slab(struct rcu_head *h)
 {
 	struct page *page;
 
-	if (need_reserve_slab_rcu)
-		page = virt_to_head_page(h);
-	else
-		page = container_of((struct list_head *)h, struct page, lru);
-
+	page = container_of((struct list_head *)h, struct page, lru);
 	__free_slab(page->slab, page);
 }
 
 static void free_slab(struct kmem_cache *s, struct page *page)
 {
 	if (unlikely(s->flags & SLAB_DESTROY_BY_RCU)) {
-		struct rcu_head *head;
-
-		if (need_reserve_slab_rcu) {
-			int order = compound_order(page);
-			int offset = (PAGE_SIZE << order) - s->reserved;
-
-			VM_BUG_ON(s->reserved != sizeof(*head));
-			head = page_address(page) + offset;
-		} else {
-			/*
-			 * RCU free overloads the RCU head over the LRU
-			 */
-			head = (void *)&page->lru;
-		}
+		/*
+		 * RCU free overloads the RCU head over the LRU
+		 */
+		struct rcu_head *head = (void *)&page->lru;
 
 		call_rcu(head, rcu_free_slab);
 	} else
@@ -1540,78 +1523,6 @@ static void unfreeze_slab(struct kmem_cache *s, struct page *page, int tail)
 	}
 }
 
-#ifdef CONFIG_CMPXCHG_LOCAL
-#ifdef CONFIG_PREEMPT
-/*
- * Calculate the next globally unique transaction for disambiguiation
- * during cmpxchg. The transactions start with the cpu number and are then
- * incremented by CONFIG_NR_CPUS.
- */
-#define TID_STEP  roundup_pow_of_two(CONFIG_NR_CPUS)
-#else
-/*
- * No preemption supported therefore also no need to check for
- * different cpus.
- */
-#define TID_STEP 1
-#endif
-
-static inline unsigned long next_tid(unsigned long tid)
-{
-	return tid + TID_STEP;
-}
-
-static inline unsigned int tid_to_cpu(unsigned long tid)
-{
-	return tid % TID_STEP;
-}
-
-static inline unsigned long tid_to_event(unsigned long tid)
-{
-	return tid / TID_STEP;
-}
-
-static inline unsigned int init_tid(int cpu)
-{
-	return cpu;
-}
-
-static inline void note_cmpxchg_failure(const char *n,
-		const struct kmem_cache *s, unsigned long tid)
-{
-#ifdef SLUB_DEBUG_CMPXCHG
-	unsigned long actual_tid = __this_cpu_read(s->cpu_slab->tid);
-
-	printk(KERN_INFO "%s %s: cmpxchg redo ", n, s->name);
-
-#ifdef CONFIG_PREEMPT
-	if (tid_to_cpu(tid) != tid_to_cpu(actual_tid))
-		printk("due to cpu change %d -> %d\n",
-			tid_to_cpu(tid), tid_to_cpu(actual_tid));
-	else
-#endif
-	if (tid_to_event(tid) != tid_to_event(actual_tid))
-		printk("due to cpu running other code. Event %ld->%ld\n",
-			tid_to_event(tid), tid_to_event(actual_tid));
-	else
-		printk("for unknown reason: actual=%lx was=%lx target=%lx\n",
-			actual_tid, tid, next_tid(tid));
-#endif
-	stat(s, CMPXCHG_DOUBLE_CPU_FAIL);
-}
-
-#endif
-
-void init_kmem_cache_cpus(struct kmem_cache *s)
-{
-#if defined(CONFIG_CMPXCHG_LOCAL) && defined(CONFIG_PREEMPT)
-	int cpu;
-
-	for_each_possible_cpu(cpu)
-		per_cpu_ptr(s->cpu_slab, cpu)->tid = init_tid(cpu);
-#endif
-
-}
 /*
  * Remove the cpu slab
  */
@@ -1643,9 +1554,6 @@ static void deactivate_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 		page->inuse--;
 	}
 	c->page = NULL;
-#ifdef CONFIG_CMPXCHG_LOCAL
-	c->tid = next_tid(c->tid);
-#endif
 	unfreeze_slab(s, page, tail);
 }
 
@@ -1780,19 +1688,6 @@ static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 {
 	void **object;
 	struct page *new;
-#ifdef CONFIG_CMPXCHG_LOCAL
-	unsigned long flags;
-
-	local_irq_save(flags);
-#ifdef CONFIG_PREEMPT
-	/*
-	 * We may have been preempted and rescheduled on a different
-	 * cpu before disabling interrupts. Need to reload cpu area
-	 * pointer.
-	 */
-	c = this_cpu_ptr(s->cpu_slab);
-#endif
-#endif
 
 	/* We handle __GFP_ZERO in the caller */
 	gfpflags &= ~__GFP_ZERO;
@@ -1819,10 +1714,6 @@ load_freelist:
 	c->node = page_to_nid(c->page);
 unlock_out:
 	slab_unlock(c->page);
-#ifdef CONFIG_CMPXCHG_LOCAL
-	c->tid = next_tid(c->tid);
-	local_irq_restore(flags);
-#endif
 	stat(s, ALLOC_SLOWPATH);
 	return object;
 
@@ -1858,9 +1749,6 @@ new_slab:
 	}
 	if (!(gfpflags & __GFP_NOWARN) && printk_ratelimit())
 		slab_out_of_memory(s, gfpflags, node);
-#ifdef CONFIG_CMPXCHG_LOCAL
-	local_irq_restore(flags);
-#endif
 	return NULL;
 debug:
 	if (!alloc_debug_processing(s, c->page, object, addr))
@@ -1887,76 +1775,23 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 {
 	void **object;
 	struct kmem_cache_cpu *c;
-#ifdef CONFIG_CMPXCHG_LOCAL
-	unsigned long tid;
-#else
 	unsigned long flags;
-#endif
 
 	if (slab_pre_alloc_hook(s, gfpflags))
 		return NULL;
 
-#ifndef CONFIG_CMPXCHG_LOCAL
 	local_irq_save(flags);
-#else
-redo:
-#endif
-
-	/*
-	 * Must read kmem_cache cpu data via this cpu ptr. Preemption is
-	 * enabled. We may switch back and forth between cpus while
-	 * reading from one cpu area. That does not matter as long
-	 * as we end up on the original cpu again when doing the cmpxchg.
-	 */
 	c = __this_cpu_ptr(s->cpu_slab);
-
-#ifdef CONFIG_CMPXCHG_LOCAL
-	/*
-	 * The transaction ids are globally unique per cpu and per operation on
-	 * a per cpu queue. Thus they can be guarantee that the cmpxchg_double
-	 * occurs on the right processor and that there was no operation on the
-	 * linked list in between.
-	 */
-	tid = c->tid;
-	barrier();
-#endif
-
 	object = c->freelist;
 	if (unlikely(!object || !node_match(c, node)))
 
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 
 	else {
-#ifdef CONFIG_CMPXCHG_LOCAL
-		/*
-		 * The cmpxchg will only match if there was no additonal
-		 * operation and if we are on the right processor.
-		 *
-		 * The cmpxchg does the following atomically (without lock semantics!)
-		 * 1. Relocate first pointer to the current per cpu area.
-		 * 2. Verify that tid and freelist have not been changed
-		 * 3. If they were not changed replace tid and freelist
-		 *
-		 * Since this is without lock semantics the protection is only against
-		 * code executing on this cpu *not* from access by other cpus.
-		 */
-		if (unlikely(!this_cpu_cmpxchg_double(
-				s->cpu_slab->freelist, s->cpu_slab->tid,
-				object, tid,
-				get_freepointer(s, object), next_tid(tid)))) {
-
-			note_cmpxchg_failure("slab_alloc", s, tid);
-			goto redo;
-		}
-#else
 		c->freelist = get_freepointer(s, object);
-#endif
 		stat(s, ALLOC_FASTPATH);
 	}
-
-#ifndef CONFIG_CMPXCHG_LOCAL
 	local_irq_restore(flags);
-#endif
 
 	if (unlikely(gfpflags & __GFP_ZERO) && object)
 		memset(object, 0, s->objsize);
@@ -2034,13 +1869,9 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
 {
 	void *prior;
 	void **object = (void *)x;
-#ifdef CONFIG_CMPXCHG_LOCAL
-	unsigned long flags;
 
-	local_irq_save(flags);
-#endif
-	slab_lock(page);
 	stat(s, FREE_SLOWPATH);
+	slab_lock(page);
 
 	if (kmem_cache_debug(s))
 		goto debug;
@@ -2070,9 +1901,6 @@ checks_ok:
 
 out_unlock:
 	slab_unlock(page);
-#ifdef CONFIG_CMPXCHG_LOCAL
-	local_irq_restore(flags);
-#endif
 	return;
 
 slab_empty:
@@ -2084,9 +1912,6 @@ slab_empty:
 		stat(s, FREE_REMOVE_PARTIAL);
 	}
 	slab_unlock(page);
-#ifdef CONFIG_CMPXCHG_LOCAL
-	local_irq_restore(flags);
-#endif
 	stat(s, FREE_SLAB);
 	discard_slab(s, page);
 	return;
@@ -2113,56 +1938,21 @@ static __always_inline void slab_free(struct kmem_cache *s,
 {
 	void **object = (void *)x;
 	struct kmem_cache_cpu *c;
-#ifdef CONFIG_CMPXCHG_LOCAL
-	unsigned long tid;
-#else
 	unsigned long flags;
-#endif
 
 	slab_free_hook(s, x);
 
-#ifndef CONFIG_CMPXCHG_LOCAL
 	local_irq_save(flags);
-
-#else
-redo:
-#endif
-
-	/*
-	 * Determine the currently cpus per cpu slab.
-	 * The cpu may change afterward. However that does not matter since
-	 * data is retrieved via this pointer. If we are on the same cpu
-	 * during the cmpxchg then the free will succedd.
-	 */
 	c = __this_cpu_ptr(s->cpu_slab);
 
-#ifdef CONFIG_CMPXCHG_LOCAL
-	tid = c->tid;
-	barrier();
-#endif
-
 	if (likely(page == c->page && c->node != NUMA_NO_NODE)) {
 		set_freepointer(s, object, c->freelist);
-
-#ifdef CONFIG_CMPXCHG_LOCAL
-		if (unlikely(!this_cpu_cmpxchg_double(
-				s->cpu_slab->freelist, s->cpu_slab->tid,
-				c->freelist, tid,
-				object, next_tid(tid)))) {
-
-			note_cmpxchg_failure("slab_free", s, tid);
-			goto redo;
-		}
-#else
 		c->freelist = object;
-#endif
 		stat(s, FREE_FASTPATH);
 	} else
 		__slab_free(s, page, x, addr);
 
-#ifndef CONFIG_CMPXCHG_LOCAL
 	local_irq_restore(flags);
-#endif
 }
 
 void kmem_cache_free(struct kmem_cache *s, void *x)
@@ -2354,23 +2144,9 @@ static inline int alloc_kmem_cache_cpus(struct kmem_cache *s)
 	BUILD_BUG_ON(PERCPU_DYNAMIC_EARLY_SIZE <
 			SLUB_PAGE_SHIFT * sizeof(struct kmem_cache_cpu));
 
-#ifdef CONFIG_CMPXCHG_LOCAL
-	/*
-	 * Must align to double word boundary for the double cmpxchg instructions
-	 * to work.
-	 */
-	s->cpu_slab = __alloc_percpu(sizeof(struct kmem_cache_cpu), 2 * sizeof(void *));
-#else
-	/* Regular alignment is sufficient */
 	s->cpu_slab = alloc_percpu(struct kmem_cache_cpu);
-#endif
-
-	if (!s->cpu_slab)
-		return 0;
 
-	init_kmem_cache_cpus(s);
-
-	return 1;
+	return s->cpu_slab != NULL;
 }
 
 static struct kmem_cache *kmem_cache_node;
@@ -2609,9 +2385,6 @@ static int kmem_cache_open(struct kmem_cache *s,
 	s->flags = kmem_cache_flags(size, flags, name, ctor);
 	s->reserved = 0;
 
-	if (need_reserve_slab_rcu && (s->flags & SLAB_DESTROY_BY_RCU))
-		s->reserved = sizeof(struct rcu_head);
-
 	if (!calculate_sizes(s, -1))
 		goto error;
 	if (disable_higher_order_debug) {

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab1EDOVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:21:11 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:28942 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753837Ab1EDOVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:21:09 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: MrTPqJgVM1mwEZae9r_QEI0aBQaG9oUOwQ1SEsUPBo9eQEw
 fI0wNQsG6KWdhYLN_kgp4gpk5Bf745cX7QNH.rvhcq5l3DtBkiRAt9aEIMoV
 2G5ROEauMCQWDYVOCVDuO53dGnouvvTwx8Sp.ZFSLK59CsnLCWaXmu.zQkZy
 JyW472JqIYzRemKuWeYXTmBWY6fWuSrhgOQbevVc.wFK2.GrVoygF8JORgQO
 pMWIJsR4mvJH9nYUFAE4JrNK71FvPfxc4lWWukDwMlAb8CrZ9oVm51qdd7fE
 2g1aEBMryCdeglF8tCU95.mktk7.29DRqKlqSSYUJmWKQY8IMfKwHqRbczrk
 UPuSxhqAa8cTw5NYtMxjrW8sF
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 4 May 2011 09:21:05 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Thomas Gleixner <tglx@linutronix.de>
cc: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
In-Reply-To: <alpine.LFD.2.02.1105041417330.3005@ionos>
Message-ID: <alpine.DEB.2.00.1105040905280.5495@router.home>
References: <BANLkTikFqF1vzMq3L9zDB=MDnCOFYp+XEQ@mail.gmail.com> <web-516990066@zbackend1.aha.ru> <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com> <20110503190822.GA20520@elte.hu> <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com> <20110504083559.GB25724@elte.hu>
 <alpine.LFD.2.02.1105041124080.3005@ionos> <20110504101932.GA3392@elte.hu> <alpine.LFD.2.02.1105041233280.3005@ionos> <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com> <20110504112746.GE8007@htj.dyndns.org> <alpine.LFD.2.02.1105041417330.3005@ionos>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Thomas Gleixner wrote:

> So the question is whether CMPXCHG_LOCAL for x86 wants to depend on
> X86_CMPXCHG64.

Right.

> The other solution is to use irqsafe_cpu_cmpxchg_double() instead of
> this_cpu_cmpxchg_double() in slub.c.
>
> This will not hurt the X86_CMPXCHG64=y case, but keep the expansion to
> the above __this_cpu_generic_cmpxchg_double working.
>
> Which makes me even wonder some more whether we need that whole
> CMPXCHG_LOCAL #ifdeffery in slub.c at all.

Hmmm... I have not measured it but it would certainly be nice to get rid
of it. The period of irq disablement is then reduced in the fastpath too.
However, we need to do additional tid checking (which should be fast).

The following patch does that and runs here in kvm

---
 include/linux/percpu.h   |    2 -
 include/linux/slub_def.h |    2 -
 mm/slub.c                |   60 +----------------------------------------------
 3 files changed, 3 insertions(+), 61 deletions(-)

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2011-05-04 09:13:10.000000000 -0500
+++ linux-2.6/include/linux/percpu.h	2011-05-04 09:13:28.000000000 -0500
@@ -948,7 +948,7 @@ do {									\
 	irqsafe_generic_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
 # endif
 # define irqsafe_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	__pcpu_double_call_return_int(irqsafe_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
+	__pcpu_double_call_return_bool(irqsafe_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
 #endif

 #endif /* __LINUX_PERCPU_H */
Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2011-05-04 09:11:12.000000000 -0500
+++ linux-2.6/include/linux/slub_def.h	2011-05-04 09:11:17.000000000 -0500
@@ -37,9 +37,7 @@ enum stat_item {

 struct kmem_cache_cpu {
 	void **freelist;	/* Pointer to next available object */
-#ifdef CONFIG_CMPXCHG_LOCAL
 	unsigned long tid;	/* Globally unique transaction id */
-#endif
 	struct page *page;	/* The slab from which we are allocating */
 	int node;		/* The node of the page (or -1 for debug) */
 #ifdef CONFIG_SLUB_STATS
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-04 09:07:10.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-05-04 09:13:58.000000000 -0500
@@ -1540,7 +1540,6 @@ static void unfreeze_slab(struct kmem_ca
 	}
 }

-#ifdef CONFIG_CMPXCHG_LOCAL
 #ifdef CONFIG_PREEMPT
 /*
  * Calculate the next globally unique transaction for disambiguiation
@@ -1600,17 +1599,12 @@ static inline void note_cmpxchg_failure(
 	stat(s, CMPXCHG_DOUBLE_CPU_FAIL);
 }

-#endif
-
 void init_kmem_cache_cpus(struct kmem_cache *s)
 {
-#ifdef CONFIG_CMPXCHG_LOCAL
 	int cpu;

 	for_each_possible_cpu(cpu)
 		per_cpu_ptr(s->cpu_slab, cpu)->tid = init_tid(cpu);
-#endif
-
 }
 /*
  * Remove the cpu slab
@@ -1643,9 +1637,7 @@ static void deactivate_slab(struct kmem_
 		page->inuse--;
 	}
 	c->page = NULL;
-#ifdef CONFIG_CMPXCHG_LOCAL
 	c->tid = next_tid(c->tid);
-#endif
 	unfreeze_slab(s, page, tail);
 }

@@ -1780,7 +1772,6 @@ static void *__slab_alloc(struct kmem_ca
 {
 	void **object;
 	struct page *new;
-#ifdef CONFIG_CMPXCHG_LOCAL
 	unsigned long flags;

 	local_irq_save(flags);
@@ -1792,7 +1783,6 @@ static void *__slab_alloc(struct kmem_ca
 	 */
 	c = this_cpu_ptr(s->cpu_slab);
 #endif
-#endif

 	/* We handle __GFP_ZERO in the caller */
 	gfpflags &= ~__GFP_ZERO;
@@ -1819,10 +1809,8 @@ load_freelist:
 	c->node = page_to_nid(c->page);
 unlock_out:
 	slab_unlock(c->page);
-#ifdef CONFIG_CMPXCHG_LOCAL
 	c->tid = next_tid(c->tid);
 	local_irq_restore(flags);
-#endif
 	stat(s, ALLOC_SLOWPATH);
 	return object;

@@ -1858,9 +1846,7 @@ new_slab:
 	}
 	if (!(gfpflags & __GFP_NOWARN) && printk_ratelimit())
 		slab_out_of_memory(s, gfpflags, node);
-#ifdef CONFIG_CMPXCHG_LOCAL
 	local_irq_restore(flags);
-#endif
 	return NULL;
 debug:
 	if (!alloc_debug_processing(s, c->page, object, addr))
@@ -1887,20 +1873,12 @@ static __always_inline void *slab_alloc(
 {
 	void **object;
 	struct kmem_cache_cpu *c;
-#ifdef CONFIG_CMPXCHG_LOCAL
 	unsigned long tid;
-#else
-	unsigned long flags;
-#endif

 	if (slab_pre_alloc_hook(s, gfpflags))
 		return NULL;

-#ifndef CONFIG_CMPXCHG_LOCAL
-	local_irq_save(flags);
-#else
 redo:
-#endif

 	/*
 	 * Must read kmem_cache cpu data via this cpu ptr. Preemption is
@@ -1910,7 +1888,6 @@ redo:
 	 */
 	c = __this_cpu_ptr(s->cpu_slab);

-#ifdef CONFIG_CMPXCHG_LOCAL
 	/*
 	 * The transaction ids are globally unique per cpu and per operation on
 	 * a per cpu queue. Thus they can be guarantee that the cmpxchg_double
@@ -1919,7 +1896,6 @@ redo:
 	 */
 	tid = c->tid;
 	barrier();
-#endif

 	object = c->freelist;
 	if (unlikely(!object || !node_match(c, node)))
@@ -1927,7 +1903,6 @@ redo:
 		object = __slab_alloc(s, gfpflags, node, addr, c);

 	else {
-#ifdef CONFIG_CMPXCHG_LOCAL
 		/*
 		 * The cmpxchg will only match if there was no additional
 		 * operation and if we are on the right processor.
@@ -1940,7 +1915,7 @@ redo:
 		 * Since this is without lock semantics the protection is only against
 		 * code executing on this cpu *not* from access by other cpus.
 		 */
-		if (unlikely(!this_cpu_cmpxchg_double(
+		if (unlikely(!irqsafe_cpu_cmpxchg_double(
 				s->cpu_slab->freelist, s->cpu_slab->tid,
 				object, tid,
 				get_freepointer(s, object), next_tid(tid)))) {
@@ -1948,16 +1923,9 @@ redo:
 			note_cmpxchg_failure("slab_alloc", s, tid);
 			goto redo;
 		}
-#else
-		c->freelist = get_freepointer(s, object);
-#endif
 		stat(s, ALLOC_FASTPATH);
 	}

-#ifndef CONFIG_CMPXCHG_LOCAL
-	local_irq_restore(flags);
-#endif
-
 	if (unlikely(gfpflags & __GFP_ZERO) && object)
 		memset(object, 0, s->objsize);

@@ -2034,11 +2002,9 @@ static void __slab_free(struct kmem_cach
 {
 	void *prior;
 	void **object = (void *)x;
-#ifdef CONFIG_CMPXCHG_LOCAL
 	unsigned long flags;

 	local_irq_save(flags);
-#endif
 	slab_lock(page);
 	stat(s, FREE_SLOWPATH);

@@ -2070,9 +2036,7 @@ checks_ok:

 out_unlock:
 	slab_unlock(page);
-#ifdef CONFIG_CMPXCHG_LOCAL
 	local_irq_restore(flags);
-#endif
 	return;

 slab_empty:
@@ -2084,9 +2048,7 @@ slab_empty:
 		stat(s, FREE_REMOVE_PARTIAL);
 	}
 	slab_unlock(page);
-#ifdef CONFIG_CMPXCHG_LOCAL
 	local_irq_restore(flags);
-#endif
 	stat(s, FREE_SLAB);
 	discard_slab(s, page);
 	return;
@@ -2113,20 +2075,11 @@ static __always_inline void slab_free(st
 {
 	void **object = (void *)x;
 	struct kmem_cache_cpu *c;
-#ifdef CONFIG_CMPXCHG_LOCAL
 	unsigned long tid;
-#else
-	unsigned long flags;
-#endif

 	slab_free_hook(s, x);

-#ifndef CONFIG_CMPXCHG_LOCAL
-	local_irq_save(flags);
-
-#else
 redo:
-#endif

 	/*
 	 * Determine the currently cpus per cpu slab.
@@ -2136,16 +2089,13 @@ redo:
 	 */
 	c = __this_cpu_ptr(s->cpu_slab);

-#ifdef CONFIG_CMPXCHG_LOCAL
 	tid = c->tid;
 	barrier();
-#endif

 	if (likely(page == c->page && c->node != NUMA_NO_NODE)) {
 		set_freepointer(s, object, c->freelist);

-#ifdef CONFIG_CMPXCHG_LOCAL
-		if (unlikely(!this_cpu_cmpxchg_double(
+		if (unlikely(!irqsafe_cpu_cmpxchg_double(
 				s->cpu_slab->freelist, s->cpu_slab->tid,
 				c->freelist, tid,
 				object, next_tid(tid)))) {
@@ -2153,16 +2103,10 @@ redo:
 			note_cmpxchg_failure("slab_free", s, tid);
 			goto redo;
 		}
-#else
-		c->freelist = object;
-#endif
 		stat(s, FREE_FASTPATH);
 	} else
 		__slab_free(s, page, x, addr);

-#ifndef CONFIG_CMPXCHG_LOCAL
-	local_irq_restore(flags);
-#endif
 }

 void kmem_cache_free(struct kmem_cache *s, void *x)


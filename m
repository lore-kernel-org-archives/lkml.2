Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab1EDPAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:00:36 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:48225 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754509Ab1EDPAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:00:35 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: cqSlO6kVM1m7xzEDFwHDGj7R2I5grtSfxB.spZ8MKP6Nu2e
 ZFEwlvh7Ef6CvcHqM4wTJhaWIar4KgB6LYRojGbGFwe1ytp2y67ph.e_iV0z
 1udXJfVDr6rpWmZu9Pa9BdBTOdOQj2AsLKPVFTmIUrQ6tHBbkXyWghPgRRAv
 iUBlQkxlK_3sToTq6Yz_hGRbnjw29QEe4guN_YiCZhaP2Ck_0aCnR_kvE3We
 kMl8Ao2gRDglT_s16rAa9PikO_z2qSsIocHOyYi7NH1AtDoK9tn5Vn_kZ_06
 VsNfXIkNb0wTOKTUgPEsEt.68MmFODVQtIbCNpoy2J_zxs8wp
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 4 May 2011 10:00:30 -0500 (CDT)
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
In-Reply-To: <alpine.LFD.2.02.1105041640020.3005@ionos>
Message-ID: <alpine.DEB.2.00.1105040958570.5495@router.home>
References: <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com> <20110504083559.GB25724@elte.hu> <alpine.LFD.2.02.1105041124080.3005@ionos> <20110504101932.GA3392@elte.hu> <alpine.LFD.2.02.1105041233280.3005@ionos> <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com>
 <20110504112746.GE8007@htj.dyndns.org> <alpine.LFD.2.02.1105041417330.3005@ionos> <20110504132022.GA17294@htj.dyndns.org> <alpine.LFD.2.02.1105041539050.3005@ionos> <20110504142532.GC17294@htj.dyndns.org> <alpine.LFD.2.02.1105041640020.3005@ionos>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So you have local irq disable/enable in both cases. So for the case
> where you don't have a local cmpxchg8b/16b available it's not worse
> versus irq disable/enable than now. It just has the possible repeat
> case when stuff changed between the prep and the actual cmpxchg, which
> is the same problem when cmpxchg8b/16 is available.

Right there is only the tid management that is added. Hope I am fast
enough to at least get one patch in (not very well tested):



Subject: slub: Remove CONFIG_CMPXCHG_LOCAL ifdeffery

Remove the #ifdefs. This means that the irqsafe_cpu_cmpxchg_double() is used
everywhere.

There may be performance implications since:

A. We now have to manage a transaction ID for all arches

B. The interrupt holdoff for arches not supporting CONFIG_CMPXCHG_LOCAL is reduced
to a very short irqoff section.

There are no multiple irqoff/irqon sequences as a result of this change. Even in the fallback
case we only have to do one disable and enable like before.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/slub_def.h |    2 -
 mm/slub.c                |   56 -----------------------------------------------
 2 files changed, 58 deletions(-)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2011-05-04 09:33:08.000000000 -0500
+++ linux-2.6/include/linux/slub_def.h	2011-05-04 09:42:05.000000000 -0500
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
--- linux-2.6.orig/mm/slub.c	2011-05-04 09:41:59.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-05-04 09:48:11.000000000 -0500
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
@@ -2136,15 +2089,12 @@ redo:
 	 */
 	c = __this_cpu_ptr(s->cpu_slab);

-#ifdef CONFIG_CMPXCHG_LOCAL
 	tid = c->tid;
 	barrier();
-#endif

 	if (likely(page == c->page && c->node != NUMA_NO_NODE)) {
 		set_freepointer(s, object, c->freelist);

-#ifdef CONFIG_CMPXCHG_LOCAL
 		if (unlikely(!irqsafe_cpu_cmpxchg_double(
 				s->cpu_slab->freelist, s->cpu_slab->tid,
 				c->freelist, tid,
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

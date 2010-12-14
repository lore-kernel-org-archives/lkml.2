Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759865Ab0LNRtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 12:49:45 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:30771 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759825Ab0LNRtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 12:49:04 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: NEMcWdgVM1lFcuedfAxgInoUXo6bULZ05M6Tg8c3VtwuqSf
 XOCsN7lYKcSqDsiskLWGwndu90XQnyOryhbT_OEBweWb5FnQdumiCG7b1otf
 EXD8V6pd8lVsv5xoC6xhwJHqmCdtRm4fM6aOwzh8dv41jQHcIJHWMBdd3er6
 mxz1bb69MuueotPH1kJ4YiVs62bkPV.yvmxlnbPSG0PTlFfNOcTBDge5iiRE
 f2uPB_pw7qPj5z9HFYSyyFa9Cg1g_df7r3D1Q20nTSXylYuC__wFPTi8C0JL
 pFl9VKL_yVlD8EpjTBolFsDM_BGLS_8tOv9f.F4xaNK1D3CEdr1UnveVqwA-
 -
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101214174901.827380447@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 14 Dec 2010 11:48:51 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops cmpxchg double V1 4/4] Lockless (and preemptless) fastpaths for slub
References: <20101214174847.887713690@linux.com>
Content-Disposition: inline; filename=cpuops_double_slub_fastpath
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the this_cpu_cmpxchg_double functionality to implement a lockless
allocation algorithm on arches that support fast this_cpu_ops.

Each of the per cpu pointers is paired with a transaction id that ensures
that updates of the per cpu information can only occur in sequence on
a certain cpu.

A transaction id is a "long" integer that is comprised of an event number
and the cpu number. The event number is incremented for every change to the
per cpu state. This means that the cmpxchg instruction can verify for an
update that nothing interfered and that we are updating the percpu structure
for the processor where we picked up the information and that we are also
currently on that processor when we update the information.

This results in a significant decrease of the overhead in the fastpaths. It
also makes it easy to adopt the fast path for realtime kernels since this
is lockless and does not require the use of the current per cpu area
over the critical section. It is only important that the per cpu area is
current at the beginning of the critical section and at the end.

So there is no need even to disable preemption.

Test results show that the fastpath cycle count is reduced by up to ~ 40%
(alloc/free test goes from ~140 cycles down to ~80). The slowpath for kfree
adds a few cycles.

Sadly this does nothing for the slowpath which is where the main issues with
performance in slub are but the best case performance rises significantly.
(For that see the more complex slub patches that require cmpxchg_double)

Kmalloc: alloc/free test

Before:

10000 times kmalloc(8)/kfree -> 142 cycles
10000 times kmalloc(16)/kfree -> 142 cycles
10000 times kmalloc(32)/kfree -> 142 cycles
10000 times kmalloc(64)/kfree -> 142 cycles
10000 times kmalloc(128)/kfree -> 142 cycles
10000 times kmalloc(256)/kfree -> 140 cycles
10000 times kmalloc(512)/kfree -> 140 cycles
10000 times kmalloc(1024)/kfree -> 144 cycles
10000 times kmalloc(2048)/kfree -> 144 cycles
10000 times kmalloc(4096)/kfree -> 144 cycles
10000 times kmalloc(8192)/kfree -> 144 cycles
10000 times kmalloc(16384)/kfree -> 913 cycles

After:

10000 times kmalloc(8)/kfree -> 81 cycles
10000 times kmalloc(16)/kfree -> 81 cycles
10000 times kmalloc(32)/kfree -> 81 cycles
10000 times kmalloc(64)/kfree -> 81 cycles
10000 times kmalloc(128)/kfree -> 81 cycles
10000 times kmalloc(256)/kfree -> 87 cycles
10000 times kmalloc(512)/kfree -> 87 cycles
10000 times kmalloc(1024)/kfree -> 87 cycles
10000 times kmalloc(2048)/kfree -> 84 cycles
10000 times kmalloc(4096)/kfree -> 81 cycles
10000 times kmalloc(8192)/kfree -> 81 cycles
10000 times kmalloc(16384)/kfree -> 927 cycles


Kmalloc: Repeatedly allocate then free test

Before:

10000 times kmalloc(8) -> 102 cycles kfree -> 111 cycles
10000 times kmalloc(16) -> 101 cycles kfree -> 111 cycles
10000 times kmalloc(32) -> 120 cycles kfree -> 114 cycles
10000 times kmalloc(64) -> 161 cycles kfree -> 130 cycles
10000 times kmalloc(128) -> 284 cycles kfree -> 129 cycles
10000 times kmalloc(256) -> 410 cycles kfree -> 134 cycles
10000 times kmalloc(512) -> 312 cycles kfree -> 197 cycles
10000 times kmalloc(1024) -> 377 cycles kfree -> 494 cycles
10000 times kmalloc(2048) -> 571 cycles kfree -> 522 cycles
10000 times kmalloc(4096) -> 674 cycles kfree -> 565 cycles
10000 times kmalloc(8192) -> 836 cycles kfree -> 648 cycles
10000 times kmalloc(16384) -> 1201 cycles kfree -> 775 cycles

After:

10000 times kmalloc(8) -> 69 cycles kfree -> 115 cycles
10000 times kmalloc(16) -> 73 cycles kfree -> 115 cycles
10000 times kmalloc(32) -> 86 cycles kfree -> 119 cycles
10000 times kmalloc(64) -> 122 cycles kfree -> 125 cycles
10000 times kmalloc(128) -> 247 cycles kfree -> 132 cycles
10000 times kmalloc(256) -> 375 cycles kfree -> 137 cycles
10000 times kmalloc(512) -> 283 cycles kfree -> 183 cycles
10000 times kmalloc(1024) -> 316 cycles kfree -> 504 cycles
10000 times kmalloc(2048) -> 516 cycles kfree -> 531 cycles
10000 times kmalloc(4096) -> 610 cycles kfree -> 570 cycles
10000 times kmalloc(8192) -> 759 cycles kfree -> 651 cycles
10000 times kmalloc(16384) -> 1169 cycles kfree -> 778 cycles

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/slub_def.h |    5 -
 mm/slub.c                |  201 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 203 insertions(+), 3 deletions(-)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2010-12-14 10:51:17.000000000 -0600
+++ linux-2.6/include/linux/slub_def.h	2010-12-14 10:51:27.000000000 -0600
@@ -36,7 +36,10 @@ enum stat_item {
 	NR_SLUB_STAT_ITEMS };
 
 struct kmem_cache_cpu {
-	void **freelist;	/* Pointer to first free per cpu object */
+	void **freelist;	/* Pointer to next available object */
+#ifdef CONFIG_CMPXCHG_LOCAL
+	unsigned long tid;	/* Globally unique transaction id */
+#endif
 	struct page *page;	/* The slab from which we are allocating */
 	int node;		/* The node of the page (or -1 for debug) */
 #ifdef CONFIG_SLUB_STATS
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-12-14 10:51:24.000000000 -0600
+++ linux-2.6/mm/slub.c	2010-12-14 10:51:29.000000000 -0600
@@ -1492,6 +1492,77 @@ static void unfreeze_slab(struct kmem_ca
 	}
 }
 
+#ifdef CONFIG_CMPXCHG_LOCAL
+#ifdef CONFIG_PREEMPT
+/*
+ * Calculate the next globally unique transaction for disambiguiation
+ * during cmpxchg. The transactions start with the cpu number and are then
+ * incremented by CONFIG_NR_CPUS.
+ */
+#define TID_STEP  roundup_pow_of_two(CONFIG_NR_CPUS)
+#else
+/*
+ * No preemption supported therefore also no need to check for
+ * different cpus.
+ */
+#define TID_STEP 1
+#endif
+
+static inline unsigned long next_tid(unsigned long tid)
+{
+	return tid + TID_STEP;
+}
+
+static inline unsigned int tid_to_cpu(unsigned long tid)
+{
+	return tid % TID_STEP;
+}
+
+static inline unsigned long tid_to_event(unsigned long tid)
+{
+	return tid / TID_STEP;
+}
+
+static inline unsigned int init_tid(int cpu)
+{
+	return cpu;
+}
+
+static inline void note_cmpxchg_failure(const char *n,
+		const struct kmem_cache *s, unsigned long tid)
+{
+#ifdef CONFIG_DEBUG_VM
+	unsigned long actual_tid = __this_cpu_read(s->cpu_slab->tid);
+
+	printk(KERN_INFO "%s %s: cmpxchg redo ", n, s->name);
+
+#ifdef CONFIG_PREEMPT
+	if (tid_to_cpu(tid) != tid_to_cpu(actual_tid))
+		printk("due to cpu change %d -> %d\n",
+			tid_to_cpu(tid), tid_to_cpu(actual_tid));
+	else
+#endif
+	if (tid_to_event(tid) != tid_to_event(actual_tid))
+		printk("due to cpu running other code. Event %ld->%ld\n",
+			tid_to_event(tid), tid_to_event(actual_tid));
+	else
+		printk("for unknown reason: actual=%lx was=%lx target=%lx\n",
+			actual_tid, tid, next_tid(tid));
+#endif
+}
+
+#endif
+
+void init_kmem_cache_cpus(struct kmem_cache *s)
+{
+#if defined(CONFIG_CMPXCHG_LOCAL) && defined(CONFIG_PREEMPT)
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		per_cpu_ptr(s->cpu_slab, cpu)->tid = init_tid(cpu);
+#endif
+
+}
 /*
  * Remove the cpu slab
  */
@@ -1523,6 +1594,9 @@ static void deactivate_slab(struct kmem_
 		page->inuse--;
 	}
 	c->page = NULL;
+#ifdef CONFIG_CMPXCHG_LOCAL
+	c->tid = next_tid(c->tid);
+#endif
 	unfreeze_slab(s, page, tail);
 }
 
@@ -1657,6 +1731,19 @@ static void *__slab_alloc(struct kmem_ca
 {
 	void **object;
 	struct page *new;
+#ifdef CONFIG_CMPXCHG_LOCAL
+	unsigned long flags;
+
+	local_irq_save(flags);
+#ifdef CONFIG_PREEMPT
+	/*
+	 * We may have been preempted and rescheduled on a different
+	 * cpu before disabling interrupts. Need to reload cpu area
+	 * pointer.
+	 */
+	c = this_cpu_ptr(s->cpu_slab);
+#endif
+#endif
 
 	/* We handle __GFP_ZERO in the caller */
 	gfpflags &= ~__GFP_ZERO;
@@ -1683,6 +1770,10 @@ load_freelist:
 	c->node = page_to_nid(c->page);
 unlock_out:
 	slab_unlock(c->page);
+#ifdef CONFIG_CMPXCHG_LOCAL
+	c->tid = next_tid(c->tid);
+	local_irq_restore(flags);
+#endif
 	stat(s, ALLOC_SLOWPATH);
 	return object;
 
@@ -1744,23 +1835,73 @@ static __always_inline void *slab_alloc(
 {
 	void **object;
 	struct kmem_cache_cpu *c;
+#ifdef CONFIG_CMPXCHG_LOCAL
+	unsigned long tid;
+#else
 	unsigned long flags;
+#endif
 
 	if (slab_pre_alloc_hook(s, gfpflags))
 		return NULL;
 
+#ifndef CONFIG_CMPXCHG_LOCAL
 	local_irq_save(flags);
+redo:
+#endif
+
+	/*
+	 * Must read kmem_cache cpu data via this cpu ptr. Preemption is
+	 * enabled. We may switch back and forth between cpus while
+	 * reading from one cpu area. That does not matter as long
+	 * as we end up on the original cpu again when doing the cmpxchg.
+	 */
 	c = __this_cpu_ptr(s->cpu_slab);
+
+#ifdef CONFIG_CMPXCHG_LOCAL
+	/*
+	 * The transaction ids are globally unique per cpu and per operation on
+	 * a per cpu queue. Thus they can be guarantee that the cmpxchg_double
+	 * occurs on the right processor and that there was no operation on the
+	 * linked list in between.
+	 */
+	tid = c->tid;
+	barrier();
+#endif
+
 	object = c->freelist;
 	if (unlikely(!object || !node_match(c, node)))
 
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 
 	else {
+#ifdef CMPXCHG_LOCAL
+		/*
+		 * The cmpxchg will only match if there was no additonal
+		 * operation and if we are on the right processor.
+		 *
+		 * The cmpxchg does the following atomically (without lock semantics!)
+		 * 1. Relocate first pointer to the current per cpu area.
+		 * 2. Verify that tid and freelist have not been changed
+		 * 3. If they were not changed replace tid and freelist
+		 *
+		 * Since this is without lock semantics the protection is only against
+		 * code executing on this cpu *not* from access by other cpus.
+		 */
+		if (unlikely(!this_cpu_cmpxchg_double(&s->cpu_slab->freelist, object, tid,
+				get_freepointer(s, object), next_tid(tid)))) {
+
+			note_cmpxchg_failure("slab_alloc", s, tid);
+			goto redo;
+		}
+#else
 		c->freelist = get_freepointer(s, object);
+#endif
 		stat(s, ALLOC_FASTPATH);
 	}
+
+#ifndef CONFIG_CMPXCHG_LOCAL
 	local_irq_restore(flags);
+#endif
 
 	if (unlikely(gfpflags & __GFP_ZERO) && object)
 		memset(object, 0, s->objsize);
@@ -1824,9 +1965,13 @@ static void __slab_free(struct kmem_cach
 {
 	void *prior;
 	void **object = (void *)x;
+#ifdef CONFIG_CMPXCHG_LOCAL
+	unsigned long flags;
 
-	stat(s, FREE_SLOWPATH);
+	local_irq_save(flags);
+#endif
 	slab_lock(page);
+	stat(s, FREE_SLOWPATH);
 
 	if (kmem_cache_debug(s))
 		goto debug;
@@ -1856,6 +2001,9 @@ checks_ok:
 
 out_unlock:
 	slab_unlock(page);
+#ifdef CONFIG_CMPXCHG_LOCAL
+	local_irq_restore(flags);
+#endif
 	return;
 
 slab_empty:
@@ -1867,6 +2015,9 @@ slab_empty:
 		stat(s, FREE_REMOVE_PARTIAL);
 	}
 	slab_unlock(page);
+#ifdef CONFIG_CMPXCHG_LOCAL
+	local_irq_restore(flags);
+#endif
 	stat(s, FREE_SLAB);
 	discard_slab(s, page);
 	return;
@@ -1893,21 +2044,53 @@ static __always_inline void slab_free(st
 {
 	void **object = (void *)x;
 	struct kmem_cache_cpu *c;
+#ifdef CONFIG_CMPXCHG_LOCAL
+	unsigned long tid;
+#else
 	unsigned long flags;
+#endif
 
 	slab_free_hook(s, x);
 
+#ifndef CONFIG_CMPXCHG_LOCAL
 	local_irq_save(flags);
+#endif
+
+redo:
+	/*
+	 * Determine the currently cpus per cpu slab.
+	 * The cpu may change afterward. However that does not matter since
+	 * data is retrieved via this pointer. If we are on the same cpu
+	 * during the cmpxchg then the free will succedd.
+	 */
 	c = __this_cpu_ptr(s->cpu_slab);
 
+#ifdef CONFIG_CMPXCHG_LOCAL
+	tid = c->tid;
+	barrier();
+#endif
+
 	if (likely(page == c->page && c->node != NUMA_NO_NODE)) {
 		set_freepointer(s, object, c->freelist);
+
+#ifdef CONFIG_CMPXCHG_LOCAL
+		if (unlikely(!this_cpu_cmpxchg_double(&s->cpu_slab->freelist,
+				c->freelist, tid,
+				object, next_tid(tid)))) {
+
+			note_cmpxchg_failure("slab_free", s, tid);
+			goto redo;
+		}
+#else
 		c->freelist = object;
+#endif
 		stat(s, FREE_FASTPATH);
 	} else
 		__slab_free(s, page, x, addr);
 
+#ifndef CONFIG_CMPXCHG_LOCAL
 	local_irq_restore(flags);
+#endif
 }
 
 void kmem_cache_free(struct kmem_cache *s, void *x)
@@ -2110,9 +2293,23 @@ static inline int alloc_kmem_cache_cpus(
 	BUILD_BUG_ON(PERCPU_DYNAMIC_EARLY_SIZE <
 			SLUB_PAGE_SHIFT * sizeof(struct kmem_cache_cpu));
 
+#ifdef CONFIG_CMPXCHG_LOCAL
+	/*
+	 * Must align to double word boundary for the double cmpxchg instructions
+	 * to work.
+	 */
+	s->cpu_slab = __alloc_percpu(sizeof(struct kmem_cache_cpu), 2 * sizeof(void *));
+#else
+	/* Regular alignment is sufficient */
 	s->cpu_slab = alloc_percpu(struct kmem_cache_cpu);
+#endif
+
+	if (!s->cpu_slab)
+		return 0;
 
-	return s->cpu_slab != NULL;
+	init_kmem_cache_cpus(s);
+
+	return 1;
 }
 
 static struct kmem_cache *kmem_cache_node;


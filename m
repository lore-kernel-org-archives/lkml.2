Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab0KWXwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:52:34 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:28749 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754589Ab0KWXwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:52:04 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: N5Khv.YVM1lj8ci3H1MRRmvRd5IpvuqKheRjMo2H1YqIAaX
 fIqsxXlY8zBIPhazcXzS1SWzSQxtMg2JE.1IPz_8k.cTnZV72H83s4dohSOR
 r4bdbzwKMqMSV66YobHwCmWfBWRzOTcDUoC53P7aAdMaeJ5ZuCX7hvaqKnAp
 CqGRpUiGzq03fv0.xF1ozMyyboQ4evWOsWVBeViEuESYlu4PJvaHeybWlq0b
 VwY.V1h.Mgdt0yQGi7sABeMNOhJTcm5KuVuNDmD19Zs_JBbI7och_0fNUms4
 OKCE60drykhSIFGbZCQVrInLCWsTA
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101123235201.758191189@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 23 Nov 2010 17:51:49 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Subject: [thiscpuops upgrade 10/10] Lockless (and preemptless) fastpaths for slub
References: <20101123235139.908255844@linux.com>
Content-Disposition: inline; filename=slub_generation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the this_cpu_cmpxchg_double functionality to implement a lockless
allocation algorith.

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
is lockless and does not require that the use of the current per cpu area
over the critical section. It is only important that the per cpu area is
current at the beginning of the critical section and at that end.

So there is no need even to disable preemption which will make the allocations
scale well in a RT environment.

[Beware: There have been previous attempts at lockless fastpaths that
did not succeed. We hope to have learned from these experiences but
review certainly is necessary.]

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/slub_def.h |    3 -
 mm/slub.c                |  128 ++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 113 insertions(+), 18 deletions(-)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2010-11-23 16:31:06.000000000 -0600
+++ linux-2.6/include/linux/slub_def.h	2010-11-23 16:53:34.000000000 -0600
@@ -36,7 +36,8 @@ enum stat_item {
 	NR_SLUB_STAT_ITEMS };
 
 struct kmem_cache_cpu {
-	void **freelist;	/* Pointer to first free per cpu object */
+	void **freelist;		/* Pointer to next available object */
+	unsigned long tid;	/* Globally unique transaction id */
 	struct page *page;	/* The slab from which we are allocating */
 	int node;		/* The node of the page (or -1 for debug) */
 #ifdef CONFIG_SLUB_STATS
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-11-23 16:31:06.000000000 -0600
+++ linux-2.6/mm/slub.c	2010-11-23 16:55:49.000000000 -0600
@@ -1486,6 +1486,31 @@ static void unfreeze_slab(struct kmem_ca
 }
 
 /*
+ * Calculate the next globally unique transaction for disambiguiation
+ * during cmpxchg. The transactions start with the cpu number and are then
+ * incremented by CONFIG_NR_CPUS.
+ */
+static inline unsigned long next_tid(unsigned long tid)
+{
+	return tid + CONFIG_NR_CPUS;
+}
+
+static inline unsigned int tid_to_cpu(unsigned long tid)
+{
+	return tid % CONFIG_NR_CPUS;
+}
+
+static inline unsigned long tid_to_event(unsigned long tid)
+{
+	return tid / CONFIG_NR_CPUS;
+}
+
+static inline unsigned int init_tid(int cpu)
+{
+	return cpu;
+}
+
+/*
  * Remove the cpu slab
  */
 static void deactivate_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
@@ -1509,6 +1534,7 @@ static void deactivate_slab(struct kmem_
 		/* Retrieve object from cpu_freelist */
 		object = c->freelist;
 		c->freelist = get_freepointer(s, c->freelist);
+		c->tid = next_tid(c->tid);
 
 		/* And put onto the regular freelist */
 		set_freepointer(s, object, page->freelist);
@@ -1646,10 +1672,15 @@ slab_out_of_memory(struct kmem_cache *s,
  * a call to the page allocator and the setup of a new slab.
  */
 static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
-			  unsigned long addr, struct kmem_cache_cpu *c)
+			  unsigned long addr)
 {
 	void **object;
 	struct page *new;
+	unsigned long flags;
+	struct kmem_cache_cpu *c;
+
+	local_irq_save(flags);
+	c = this_cpu_ptr(s->cpu_slab);
 
 	/* We handle __GFP_ZERO in the caller */
 	gfpflags &= ~__GFP_ZERO;
@@ -1675,7 +1706,9 @@ load_freelist:
 	c->page->freelist = NULL;
 	c->node = page_to_nid(c->page);
 unlock_out:
+	c->tid = next_tid(c->tid);
 	slab_unlock(c->page);
+	local_irq_restore(flags);
 	stat(s, ALLOC_SLOWPATH);
 	return object;
 
@@ -1737,23 +1770,53 @@ static __always_inline void *slab_alloc(
 {
 	void **object;
 	struct kmem_cache_cpu *c;
-	unsigned long flags;
+	unsigned long tid;
 
 	if (slab_pre_alloc_hook(s, gfpflags))
 		return NULL;
 
-	local_irq_save(flags);
+redo:
+	/*
+	 * Must read kmem_cache cpu data via this cpu ptr. Preemption is
+	 * enabled. We may switch back and forth between cpus while
+	 * reading from one cpu area. That does not matter as long
+	 * as we end up on the original cpu again when doing the cmpxchg.
+	 */
 	c = __this_cpu_ptr(s->cpu_slab);
+
+	/*
+	 * The transaction ids are globally unique per cpu and per operation on
+	 * a per cpu queue. Thus they can be guarantee that the cmpxchg_double
+	 * occurs on the right processor and that there was no operation on the
+	 * linked list in between.
+	 */
+	tid = c->tid;
+	barrier();
+
 	object = c->freelist;
-	if (unlikely(!object || !node_match(c, node)))
+	if (unlikely(!object || !node_match(c, c->node)))
 
-		object = __slab_alloc(s, gfpflags, node, addr, c);
+		object = __slab_alloc(s, gfpflags, c->node, addr);
 
 	else {
-		c->freelist = get_freepointer(s, object);
+		/*
+		 * The cmpxchg will only match if there was not additonal
+		 * operation and if we are on the right processor.
+		 */
+		if (unlikely(!irqsafe_cmpxchg_double(&s->cpu_slab->freelist, object, tid,
+				get_freepointer(s, object), next_tid(tid)))) {
+#ifdef CONFIG_DEBUG_VM
+			unsigned long actual_tid = __this_cpu_read(s->cpu_slab->tid);
+
+			printk(KERN_INFO "slab_free %s: redo cpu %u->[%u] event=[%ld] %ld->%ld\n",
+				s->name, tid_to_cpu(tid), tid_to_cpu(actual_tid),
+				tid_to_event(actual_tid), tid_to_event(tid),
+				tid_to_event(next_tid(tid)));
+#endif
+			goto redo;
+		}
 		stat(s, ALLOC_FASTPATH);
 	}
-	local_irq_restore(flags);
 
 	if (unlikely(gfpflags & __GFP_ZERO) && object)
 		memset(object, 0, s->objsize);
@@ -1817,8 +1880,10 @@ static void __slab_free(struct kmem_cach
 {
 	void *prior;
 	void **object = (void *)x;
+	unsigned long flags;
 
 	stat(s, FREE_SLOWPATH);
+	local_irq_save(flags);
 	slab_lock(page);
 
 	if (kmem_cache_debug(s))
@@ -1849,6 +1914,7 @@ checks_ok:
 
 out_unlock:
 	slab_unlock(page);
+	local_irq_restore(flags);
 	return;
 
 slab_empty:
@@ -1860,6 +1926,7 @@ slab_empty:
 		stat(s, FREE_REMOVE_PARTIAL);
 	}
 	slab_unlock(page);
+	local_irq_restore(flags);
 	stat(s, FREE_SLAB);
 	discard_slab(s, page);
 	return;
@@ -1886,23 +1953,38 @@ static __always_inline void slab_free(st
 {
 	void **object = (void *)x;
 	struct kmem_cache_cpu *c;
-	unsigned long flags;
+	unsigned long tid;
 
 	slab_free_hook(s, x);
 
-	local_irq_save(flags);
-	c = __this_cpu_ptr(s->cpu_slab);
-
 	slab_free_hook_irq(s, x);
 
-	if (likely(page == c->page && c->node != NUMA_NO_NODE)) {
+redo:
+	c = this_cpu_ptr(s->cpu_slab);
+	tid = c->tid;
+	barrier();
+
+	if (likely(page == c->page) &&
+			c->node != NUMA_NO_NODE) {
+
 		set_freepointer(s, object, c->freelist);
-		c->freelist = object;
+
+		if (unlikely(!irqsafe_cmpxchg_double(&s->cpu_slab->freelist,
+				c->freelist, tid,
+				object, next_tid(tid)))) {
+#ifdef CONFIG_DEBUG_VM
+			unsigned long actual_tid = __this_cpu_read(s->cpu_slab->tid);
+
+			printk(KERN_INFO "slab_free %s: redo cpu %d->[%d] event=[%ld] %ld->%ld\n", s->name,
+				tid_to_cpu(tid), tid_to_cpu(actual_tid),
+				tid_to_event(actual_tid), tid_to_event(tid),
+				tid_to_event(next_tid(tid)));
+#endif
+			goto redo;
+		}
 		stat(s, FREE_FASTPATH);
 	} else
 		__slab_free(s, page, x, addr);
-
-	local_irq_restore(flags);
 }
 
 void kmem_cache_free(struct kmem_cache *s, void *x)
@@ -2102,12 +2184,24 @@ init_kmem_cache_node(struct kmem_cache_n
 
 static inline int alloc_kmem_cache_cpus(struct kmem_cache *s)
 {
+	int cpu;
+
 	BUILD_BUG_ON(PERCPU_DYNAMIC_EARLY_SIZE <
 			SLUB_PAGE_SHIFT * sizeof(struct kmem_cache_cpu));
 
-	s->cpu_slab = alloc_percpu(struct kmem_cache_cpu);
+	/*
+	 * Must align to double word boundary for the long cmpxchg instructions
+	 * to work.
+	 */
+	s->cpu_slab = __alloc_percpu(sizeof(struct kmem_cache_cpu), 2 * sizeof(void *));
+
+	if (!s->cpu_slab)
+		return 0;
+
+	for_each_possible_cpu(cpu)
+		per_cpu_ptr(s->cpu_slab, cpu)->tid = init_tid(cpu);
 
-	return s->cpu_slab != NULL;
+	return 1;
 }
 
 static struct kmem_cache *kmem_cache_node;


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab1IWXyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 19:54:25 -0400
Received: from home.kolivas.org ([59.167.196.135]:43451 "EHLO mine.kolivas.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750845Ab1IWXyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 19:54:24 -0400
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Sep 2011 19:54:23 EDT
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: BFS cpu scheduler and skip list implementation
Date: Sat, 24 Sep 2011 09:45:58 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.38.4-ck1; KDE/4.6.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201109240945.58879.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

Many of you may know about Skip lists as an alternative to balanced binary 
search trees. They feature O(log n) insertion, lookup and removal of table 
entries. Anyway I've been looking for some time at the O(n) lookup of BFS 
(which is O(1) insertion and removal) to try and find a solution that didn't 
cost us at the desktop level since O(n) of small numbers of n is very fast. 
The problem is of course at higher numbers of n (or server type loads), where 
it gets linearly slower, and the cache trashing aspect of scanning linked 
lists becomes expensive.

http://en.wikipedia.org/wiki/Skip_list

So to cut a long story short, I've implemented the first draft of a custom 
version of skip lists for BFS in place of the O(n) lookup. The insertion 
remains O(log n), but by sorting all tasks realtime, iso, normal, batch and 
idleprio in a way they all end up on the same table, I was able to do away 
with the regular linked lists and the bitmap priority lookup. Then I was able 
to utilise one of the features of the skip lists in that the first task on the 
"bottom" list is always sorted to be the highest priority. This means the 
lookup is O(1). Then I put an extra pointer into each entry to the previous 
entry (the original design normally only points to the next entry). Finally I 
placed a pointer to the entry in the task struct as a way of reverse looking 
up the entry without any search.

So what I'm left with is an O(log n) insertion, O(1) lookup, and O(k) removal 
(k is the "height" of the node in question, up to 16, but usually only 1-4).

I've implemented the sticky task used for CPU affinity by simply comparing the 
last sticky task to the first entry returned from the skip list. Alas I have 
not yet provided a good version of the sticky task being used to improve 
scaling governor behaviour. This means that this will likely perform worse 
with the ondemand governor at this stage. On the other hand, the performance 
governor seems to be working very nicely in my preliminary tests.

Here's some code (for a BFS patched 3.0.x kernel):

http://ck.kolivas.org/patches/bfs/test/bfs406-skiplists.patch

Try it out, see what you think. It seems to be running safely here but as 
always, there are no guarantees. All going well, you should notice pretty much 
no difference on a desktop. If you do any throughput benchmarks comparing 
before/after, I'd love to hear about them. 

Patch inserted here as well:

---
 include/linux/init_task.h  |    2 
 include/linux/sched.h      |    3 
 include/linux/skip_lists.h |   26 ++++++
 kernel/Makefile            |    2 
 kernel/sched_bfs.c         |  175 ++++++++++++++++++++-------------------------
 kernel/skip_lists.c        |  159 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 268 insertions(+), 99 deletions(-)

Index: linux-3.0.0-ck1/include/linux/sched.h
===================================================================
--- linux-3.0.0-ck1.orig/include/linux/sched.h	2011-09-23 23:20:55.498045319 +1000
+++ linux-3.0.0-ck1/include/linux/sched.h	2011-09-23 23:21:36.757045313 +1000
@@ -97,6 +97,7 @@ struct sched_param {
 #include <linux/task_io_accounting.h>
 #include <linux/latencytop.h>
 #include <linux/cred.h>
+#include <linux/skip_lists.h>
 
 #include <asm/processor.h>
 
@@ -1243,7 +1244,7 @@ struct task_struct {
 #ifdef CONFIG_SCHED_BFS
 	int time_slice;
 	u64 deadline;
-	struct list_head run_list;
+	skiplist_node *node; /* Skip list node id */
 	u64 last_ran;
 	u64 sched_time; /* sched_clock time spent running */
 #ifdef CONFIG_SMP
Index: linux-3.0.0-ck1/kernel/Makefile
===================================================================
--- linux-3.0.0-ck1.orig/kernel/Makefile	2011-09-23 23:20:55.512045319 +1000
+++ linux-3.0.0-ck1/kernel/Makefile	2011-09-23 23:21:36.757045313 +1000
@@ -117,6 +117,8 @@ ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER
 CFLAGS_sched.o := $(PROFILING) -fno-omit-frame-pointer
 endif
 
+obj-$(CONFIG_SCHED_BFS) += skip_lists.o
+
 $(obj)/configs.o: $(obj)/config_data.h
 
 # config_data.h contains the same information as ikconfig.h but gzipped.
Index: linux-3.0.0-ck1/kernel/sched_bfs.c
===================================================================
--- linux-3.0.0-ck1.orig/kernel/sched_bfs.c	2011-09-23 23:20:55.524045319 +1000
+++ linux-3.0.0-ck1/kernel/sched_bfs.c	2011-09-24 00:25:14.331291981 +1000
@@ -67,6 +67,7 @@
 #include <linux/bootmem.h>
 #include <linux/ftrace.h>
 #include <linux/slab.h>
+#include <linux/skip_lists.h>
 
 #include <asm/tlb.h>
 #include <asm/unistd.h>
@@ -163,8 +164,7 @@ struct global_rq {
 	unsigned long nr_running;
 	unsigned long nr_uninterruptible;
 	unsigned long long nr_switches;
-	struct list_head queue[PRIO_LIMIT];
-	DECLARE_BITMAP(prio_bitmap, PRIO_LIMIT + 1);
+
 #ifdef CONFIG_SMP
 	unsigned long qnr; /* queued not running */
 	cpumask_t cpu_idle_map;
@@ -177,6 +177,9 @@ struct global_rq {
 	raw_spinlock_t iso_lock;
 	int iso_ticks;
 	int iso_refractory;
+
+	skiplist_node *node;
+	skiplist *sl;
 };
 
 #ifdef CONFIG_SMP
@@ -641,24 +644,25 @@ static inline int deadline_after(u64 dea
 }
 
 /*
- * A task that is queued but not running will be on the grq run list.
- * A task that is not running or queued will not be on the grq run list.
- * A task that is currently running will have ->on_cpu set but not on the
- * grq run list.
+ * A task that is not running or queued will not have a node set.
+ * A task that is queued but not running will have a node set.
+ * A task that is currently running will have ->on_cpu set but no node set.
  */
 static inline int task_queued(struct task_struct *p)
 {
-	return (!list_empty(&p->run_list));
+	return !!(p->node);
 }
 
 /*
- * Removing from the global runqueue. Enter with grq locked.
+ * Removing from the global runqueue. Enter with grq locked. Deleting a task
+ * from the skip list is done via the stored node reference in the task struct
+ * and does not require a full look up. Thus it occurs in O(k) time where k
+ * is the "level" of the list the task was stored at - usually < 4, max 16.
  */
 static void dequeue_task(struct task_struct *p)
 {
-	list_del_init(&p->run_list);
-	if (list_empty(grq.queue + p->prio))
-		__clear_bit(p->prio, grq.prio_bitmap);
+	skiplist_delnode(grq.node, grq.sl, p->node);
+	p->node = NULL;
 }
 
 /*
@@ -680,29 +684,56 @@ static int isoprio_suitable(void)
 	return !grq.iso_refractory;
 }
 
+static inline int task_sticky(struct task_struct *p);
+static inline int longest_deadline_diff(void);
+
 /*
  * Adding to the global runqueue. Enter with grq locked.
  */
 static void enqueue_task(struct task_struct *p)
 {
+	u64 sl_id;
+
 	if (!rt_task(p)) {
 		/* Check it hasn't gotten rt from PI */
 		if ((idleprio_task(p) && idleprio_suitable(p)) ||
-		   (iso_task(p) && isoprio_suitable()))
+		   (iso_task(p) && isoprio_suitable())) {
 			p->prio = p->normal_prio;
-		else
+		} else
 			p->prio = NORMAL_PRIO;
 	}
-	__set_bit(p->prio, grq.prio_bitmap);
-	list_add_tail(&p->run_list, grq.queue + p->prio);
+	/*
+	 * The sl_id key passed to the skiplist generates a sorted list.
+	 * Realtime and sched iso tasks run FIFO so they only need be sorted
+	 * according to priority. The skiplist will put tasks of the same
+	 * key inserted later in FIFO order. Tasks of sched normal, batch
+	 * and idleprio are sorted according to their deadlines. Idleprio
+	 * tasks are offset by an impossibly large deadline value ensuring
+	 * they get sorted into last positions, but still according to their
+	 * own deadlines. This creates a "landscape" of skiplists running
+	 * from priority 0 realtime in first place to the lowest priority
+	 * idleprio tasks last. Skiplist insertion is an O(log n) process.
+	 */
+	if (p->prio <= ISO_PRIO)
+		sl_id = p->prio;
+	else {
+		sl_id = p->deadline;
+		/* We offset the deadline here for sticky tasks. During
+		 * lookup, the sticky task for the CPU in question is checked
+		 * to see what its real deadline would be */
+		if (task_sticky(p))
+			sl_id += longest_deadline_diff();
+		if (p->prio == IDLE_PRIO)
+			sl_id |= 0xF000000000000000;
+	}
+	p->node = skiplist_insert(grq.node, grq.sl, sl_id, p, grq.niffies);
 	sched_info_queued(p);
 }
 
 /* Only idle task does this as a real time task*/
 static inline void enqueue_task_head(struct task_struct *p)
 {
-	__set_bit(p->prio, grq.prio_bitmap);
-	list_add(&p->run_list, grq.queue + p->prio);
+	p->node = skiplist_insert(grq.node, grq.sl, (u64)p->prio, p, grq.niffies);
 	sched_info_queued(p);
 }
 
@@ -1111,7 +1142,7 @@ static inline void unstick_task(struct r
  * Move a task off the global queue and take it to a cpu for it will
  * become the running task.
  */
-static inline void take_task(struct rq *rq, struct task_struct *p)
+static void take_task(struct rq *rq, struct task_struct *p)
 {
 	set_task_cpu(p, cpu_of(rq));
 	dequeue_task(p);
@@ -1681,8 +1712,8 @@ void sched_fork(struct task_struct *p)
 	 * Make sure we do not leak PI boosting priority to the child.
 	 */
 	p->prio = curr->normal_prio;
+	p->node = NULL;
 
-	INIT_LIST_HEAD(&p->run_list);
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	if (unlikely(sched_info_on()))
 		memset(&p->sched_info, 0, sizeof(p->sched_info));
@@ -2903,90 +2934,42 @@ static inline void check_deadline(struct
 }
 
 /*
- * O(n) lookup of all tasks in the global runqueue. The real brainfuck
- * of lock contention and O(n). It's not really O(n) as only the queued,
- * but not running tasks are scanned, and is O(n) queued in the worst case
- * scenario only because the right task can be found before scanning all of
- * them.
- * Tasks are selected in this order:
- * Real time tasks are selected purely by their static priority and in the
- * order they were queued, so the lowest value idx, and the first queued task
- * of that priority value is chosen.
- * If no real time tasks are found, the SCHED_ISO priority is checked, and
- * all SCHED_ISO tasks have the same priority value, so they're selected by
- * the earliest deadline value.
- * If no SCHED_ISO tasks are found, SCHED_NORMAL tasks are selected by the
- * earliest deadline.
- * Finally if no SCHED_NORMAL tasks are found, SCHED_IDLEPRIO tasks are
- * selected by the earliest deadline.
- */
+ * Task selection with skiplists is a simple matter of picking off the first
+ * task in the sorted list, an O(1) operation. The only time it takes longer
+ * is if tasks do not have suitable affinity and then we iterate over entries
+ * till we find the first that does. Worst case here is no tasks with suitable
+ * affinity and taking O(n). */
 static inline struct
 task_struct *earliest_deadline_task(struct rq *rq, struct task_struct *idle)
 {
-	u64 dl, earliest_deadline = 0; /* Initialise to silence compiler */
-	struct task_struct *p, *edt = idle;
+	struct task_struct *edt = idle, *rqs = rq->sticky_task;
+	skiplist_node *node = grq.node;
 	unsigned int cpu = cpu_of(rq);
-	struct list_head *queue;
-	int idx = 0;
 
-retry:
-	idx = find_next_bit(grq.prio_bitmap, PRIO_LIMIT, idx);
-	if (idx >= PRIO_LIMIT)
-		goto out;
-	queue = grq.queue + idx;
-
-	if (idx < MAX_RT_PRIO) {
-		/* We found an rt task */
-		list_for_each_entry(p, queue, run_list) {
-			/* Make sure cpu affinity is ok */
-			if (needs_other_cpu(p, cpu))
-				continue;
-			edt = p;
-			goto out_take;
-		}
-		/* None of the RT tasks at this priority can run on this cpu */
-		++idx;
-		goto retry;
-	}
+	while ((node = node->next[0]) != grq.node) {
+		struct task_struct *slp = node->value;
 
-	list_for_each_entry(p, queue, run_list) {
-		/* Make sure cpu affinity is ok */
-		if (needs_other_cpu(p, cpu))
+		/* Make sure affinity is ok */
+		if (needs_other_cpu(slp, cpu))
 			continue;
 
-		/*
-		 * Soft affinity happens here by not scheduling a task with
-		 * its sticky flag set that ran on a different CPU last when
-		 * the CPU is scaling, or by greatly biasing against its
-		 * deadline when not.
-		 */
-		if (task_rq(p) != rq && task_sticky(p)) {
-			if (scaling_rq(rq))
-				continue;
-			else
-				dl = p->deadline + longest_deadline_diff();
-		} else
-			dl = p->deadline;
+		/* FIXME: Do something here for sticky tasks and scaling
+		 * cpu frequency governors */
 
-		/*
-		 * No rt tasks. Find the earliest deadline task. Now we're in
-		 * O(n) territory. This is what we silenced the compiler for:
-		 * edt will always start as idle.
-		 */
-		if (edt == idle ||
-		    deadline_before(dl, earliest_deadline)) {
-			earliest_deadline = dl;
-			edt = p;
-		}
+		edt = slp;
+		break;
 	}
-	if (edt == idle) {
-		if (++idx < PRIO_LIMIT)
-			goto retry;
-		goto out;
+
+	if (!rt_task(edt) && rqs) {
+		/* Check the sticky task for this CPU isn't a better choice
+		 * than the task returned by the skiplist since the sticky
+		 * task will have its deadline offset when being inserted */
+		if (rqs != edt && task_queued(rqs) &&
+		    rqs->deadline - longest_deadline_diff() < edt->deadline)
+			edt = rqs;
 	}
-out_take:
-	take_task(rq, edt);
-out:
+	if (edt != idle)
+		take_task(rq, edt);
 	return edt;
 }
 
@@ -6832,6 +6815,9 @@ void __init sched_init(void)
 	raw_spin_lock_init(&grq.iso_lock);
 	grq.iso_ticks = grq.iso_refractory = 0;
 	grq.noc = 1;
+	grq.node = skiplist_init();
+	grq.sl = new_skiplist(grq.node);
+
 #ifdef CONFIG_SMP
 	init_defrootdomain();
 	grq.qnr = grq.idle_cpus = 0;
@@ -6889,11 +6875,6 @@ void __init sched_init(void)
 	}
 #endif
 
-	for (i = 0; i < PRIO_LIMIT; i++)
-		INIT_LIST_HEAD(grq.queue + i);
-	/* delimiter for bitsearch */
-	__set_bit(PRIO_LIMIT, grq.prio_bitmap);
-
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&init_task.preempt_notifiers);
 #endif
Index: linux-3.0.0-ck1/kernel/skip_lists.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-3.0.0-ck1/kernel/skip_lists.c	2011-09-23 23:21:36.760045313 +1000
@@ -0,0 +1,159 @@
+/*
+  Copyright (C) 2011 Con Kolivas.
+
+  Code based on example originally by William Pugh.
+
+Skip Lists are a probabilistic alternative to balanced trees, as
+described in the June 1990 issue of CACM and were invented by
+William Pugh in 1987.
+
+A couple of comments about this implementation:
+The routine randomLevel has been hard-coded to generate random
+levels using p=0.25. It can be easily changed.
+
+The insertion routine has been implemented so as to use the
+dirty hack described in the CACM paper: if a random level is
+generated that is more than the current maximum level, the
+current maximum level plus one is used instead.
+
+Levels start at zero and go up to MaxLevel (which is equal to
+	(MaxNumberOfLevels-1).
+
+The routines defined in this file are:
+
+init: defines slnode
+
+new_skiplist: returns a new, empty list
+
+randomLevel: Returns a random level based on a u64 random seed passed to it.
+In BFS, the "niffy" time is used for this purpose.
+
+insert(l,key, value): inserts the binding (key, value) into l. This operation
+occurs in O(log n) time.
+
+delnode(slnode, l, node): deletes any binding of key from the l based on the
+actual node value. This operation occurs in O(k) time where k is the
+number of levels of the node in question (max 16). The original delete
+function occurred in O(log n) time and involved a search.
+
+BFS Notes: In this implementation of skiplists, there are bidirectional
+next/prev pointers and the insert function returns a pointer to the actual
+node the value is stored. The key here is chosen by the scheduler so as to
+sort tasks according to the priority list requirements and is no longer used
+by the scheduler after insertion. The scheduler lookup, however, occurs in
+O(1) time because it is always the first item in the level 0 linked list.
+Since the task struct stores a copy of the node pointer upon skiplist_insert,
+it can also remove it much faster than the original implementation with the
+aid of prev<->next pointer manipulation and no searching.
+
+*/
+
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/skip_lists.h>
+
+#define MaxNumberOfLevels 16
+#define MaxLevel (MaxNumberOfLevels - 1)
+#define newNode (skiplist_node *)kmalloc(sizeof(struct nodeStructure), GFP_ATOMIC)
+
+skiplist_node *skiplist_init(void)
+{
+	skiplist_node *slnode;
+	int i;
+
+	slnode = newNode;
+	BUG_ON(!slnode);
+	slnode->key = 0xFFFFFFFFFFFFFFFF;
+	slnode->level = 0;
+	slnode->value = NULL;
+	for (i = 0; i < MaxNumberOfLevels; i++)
+		slnode->next[i] = slnode->prev[i] = slnode;
+	return slnode;
+}
+
+skiplist *new_skiplist(skiplist_node *slnode)
+{
+	skiplist *l;
+
+	l = (skiplist *)kmalloc(sizeof(struct listStructure), GFP_ATOMIC);
+	BUG_ON(!l);
+	l->level = 0;
+	l->header = slnode;
+	return l;
+}
+
+void free_skiplist(skiplist_node *slnode, skiplist *l)
+{
+	skiplist_node *p, *q;
+
+	p = l->header;
+	do {
+		q = p->next[0];
+		p->next[0]->prev[0] = q->prev[0];
+		kfree(p);
+		p = q;
+	} while (p != slnode);
+	kfree(l);
+}
+
+static inline int randomLevel(u64 randseed)
+{
+	int level = 0;
+
+	while (randseed && !(randseed & 3)) {
+		randseed >>= 2;
+		level++;
+	}
+	return (level > MaxLevel ? MaxLevel : level);
+}
+
+skiplist_node *skiplist_insert(skiplist_node *slnode, skiplist *l, keyType key, valueType value, u64 randseed)
+{
+	int k;
+	skiplist_node *update[MaxNumberOfLevels];
+	skiplist_node *p, *q;
+
+	k = l->level;
+	p = slnode;
+	do {
+		while (q = p->next[k], q->key <= key)
+			p = q;
+		update[k] = p;
+	} while (--k >= 0);
+
+	k = randomLevel(randseed);
+	if (k > l->level) {
+		k = ++l->level;
+		update[k] = slnode;
+	}
+
+	q = newNode;
+	q->level = k;
+	q->key = key;
+	q->value = value;
+	do {
+		p = update[k];
+		q->next[k] = p->next[k];
+		p->next[k] = q;
+		q->prev[k] = p;
+		q->next[k]->prev[k] = q;
+	} while (--k >= 0);
+	return q;
+}
+
+void skiplist_delnode(skiplist_node *slnode, skiplist *l, skiplist_node *node)
+{
+	int k, m;
+
+	m = node->level;
+	for (k = 0; k <= m; k++) {
+		node->prev[k]->next[k] = node->next[k];
+		node->next[k]->prev[k] = node->prev[k];
+	}
+	kfree(node);
+	if (m == l->level) {
+		while (l->header->next[m] == slnode && l->header->prev[m] == slnode && m > 0)
+			m--;
+		l->level = m;
+	}
+}
Index: linux-3.0.0-ck1/include/linux/init_task.h
===================================================================
--- linux-3.0.0-ck1.orig/include/linux/init_task.h	2011-09-23 23:20:55.506045319 +1000
+++ linux-3.0.0-ck1/include/linux/init_task.h	2011-09-23 23:21:36.760045313 +1000
@@ -145,7 +145,7 @@ extern struct cred init_cred;
 	.cpus_allowed	= CPU_MASK_ALL,					\
 	.mm		= NULL,						\
 	.active_mm	= &init_mm,					\
-	.run_list	= LIST_HEAD_INIT(tsk.run_list),			\
+	.node		= NULL,						\
 	.time_slice	= HZ,					\
 	.tasks		= LIST_HEAD_INIT(tsk.tasks),			\
 	INIT_PUSHABLE_TASKS(tsk)					\
Index: linux-3.0.0-ck1/include/linux/skip_lists.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-3.0.0-ck1/include/linux/skip_lists.h	2011-09-23 23:22:22.769045306 +1000
@@ -0,0 +1,26 @@
+#ifndef _LINUX_SKIP_LISTS_H
+#define _LINUX_SKIP_LISTS_H
+typedef u64 keyType;
+typedef struct task_struct *valueType;
+
+typedef struct nodeStructure skiplist_node;
+
+struct nodeStructure {
+	int level;	/* Levels in this structure */
+	keyType key;
+	valueType value;
+	skiplist_node *next[16];
+	skiplist_node *prev[16];
+};
+
+typedef struct listStructure {
+	int level;	/* Maximum level of the list
+			(1 more than the number of levels in the list) */
+	struct nodeStructure * header; /* pointer to header */
+} skiplist;
+
+skiplist_node *skiplist_init(void);
+skiplist *new_skiplist(skiplist_node *slnode);
+skiplist_node *skiplist_insert(skiplist_node *slnode, skiplist *l, keyType key, valueType value, u64 randseed);
+void skiplist_delnode(skiplist_node *slnode, skiplist *l, skiplist_node *node);
+#endif /* _LINUX_SKIP_LISTS_H */



-- 
-ck

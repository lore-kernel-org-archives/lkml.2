Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab1DINPN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 09:15:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52392 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab1DINPK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 09:15:10 -0400
Subject: Re: [PATCH] perf: Don't schedule tracepoints when exclude_kernel
 is set
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <1302296275-26767-1-git-send-email-fweisbec@gmail.com>
References: <1302296275-26767-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 09 Apr 2011 15:14:44 +0200
Message-ID: <1302354884.9086.1272.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-08 at 22:57 +0200, Frederic Weisbecker wrote:
> Instead of checking attr.exclude_kernel anytime a tracepoint
> event triggers, simply don't schedule the tracepoint it that
> attribute is set. This makes one test less in the tracing
> path.

Meh, I'd much rather someone spend some time on finishing the below,
which is a much bigger improvement for trace-events.

---
Subject: perf: Tracepoint collection support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Sat Nov 20 18:09:34 CET 2010

Due to popular demand this implements a tracepoint collection event
{ .type = PERF_TYPE_TRACEPOINT, .config = ~0ULL }. by default it
contains no tracepoints, but tracepoints can be added using:
  ioctl(fd, PERF_EVENT_IOC_ADD_TP, tp_id);

In order to provide a dense ID space for tracepoints replace the
tracepoint ID generation with an IDR tree.

Furthermore, replace the whole trace-event <-> perf infrastructure with
multiple IDR trees.

We keep an IDR tree per perf_event, this tree collects all the
tracepoints the perf_event is interested in and stores the corresponding
'node'. This tree manages the node life-time.

Then we keep an IDR tree per task and per CPU. Both of these trees are
accumulation trees, they're the union of all events of that particular
task/CPU. It stores a list of 'node's.

Then, when a trace-event happens, we look for it in both the CPU tree as
well as the current task tree. For both, if present we iterate the node
list and deliver the event to the corresponding perf_events.

We manage the IDR trees on perf_event creation/destruction and
ioctl(ADD_TP) time. This mean that pmu::{add,remove} are empty ops, the
per-task stat is taken care of in the per-task tree after all.

The patch got hammered by tglx, but wants some more review as well as
solving the open points before merging.

The open points are:
 - like the breakpoint muck it suffers from the pmu::event_init() vs
   context-attach inversion, and
 - the whole fancy inherited context avoid switch logic needs a fix.

[ merged a cleanup contributed by Lin Ming ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/ftrace_event.h    |   10 
 include/linux/perf_event.h      |    9 
 include/linux/sched.h           |    9 
 include/trace/ftrace.h          |    4 
 kernel/perf_event.c             |  416 ++++++++++++++++++++++++++++++++++++++--
 kernel/trace/trace_event_perf.c |   95 +++------
 kernel/trace/trace_kprobe.c     |   10 
 kernel/trace/trace_output.c     |  116 +++--------
 kernel/trace/trace_syscalls.c   |    8 
 9 files changed, 503 insertions(+), 174 deletions(-)

Index: linux-2.6/include/linux/ftrace_event.h
===================================================================
--- linux-2.6.orig/include/linux/ftrace_event.h
+++ linux-2.6/include/linux/ftrace_event.h
@@ -86,8 +86,6 @@ struct trace_event_functions {
 };
 
 struct trace_event {
-	struct hlist_node		node;
-	struct list_head		list;
 	int				type;
 	struct trace_event_functions	*funcs;
 };
@@ -193,7 +191,6 @@ struct ftrace_event_call {
 
 #ifdef CONFIG_PERF_EVENTS
 	int				perf_refcount;
-	struct hlist_head __percpu	*perf_events;
 #endif
 };
 
@@ -262,8 +259,9 @@ struct perf_event;
 
 DECLARE_PER_CPU(struct pt_regs, perf_trace_regs);
 
-extern int  perf_trace_init(struct perf_event *event);
+extern int  perf_trace_init(struct perf_event *event, int event_id);
 extern void perf_trace_destroy(struct perf_event *event);
+extern void perf_trace_destroy_id(int id);
 extern int  perf_trace_add(struct perf_event *event, int flags);
 extern void perf_trace_del(struct perf_event *event, int flags);
 extern int  ftrace_profile_set_filter(struct perf_event *event, int event_id,
@@ -274,9 +272,9 @@ extern void *perf_trace_buf_prepare(int 
 
 static inline void
 perf_trace_buf_submit(void *raw_data, int size, int rctx, u64 addr,
-		       u64 count, struct pt_regs *regs, void *head)
+		       u64 count, struct pt_regs *regs, int id)
 {
-	perf_tp_event(addr, count, raw_data, size, regs, head, rctx);
+	perf_tp_event(addr, count, raw_data, size, regs, rctx, id);
 }
 #endif
 
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -245,6 +245,7 @@ struct perf_event_attr {
 #define PERF_EVENT_IOC_PERIOD		_IOW('$', 4, __u64)
 #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
 #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
+#define PERF_EVENT_IOC_ADD_TP		_IO ('$', 7)
 
 enum perf_event_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
@@ -566,6 +567,11 @@ struct hw_perf_event {
 			struct task_struct		*bp_target;
 		};
 #endif
+		/*
+		 * Same fudge as for breakpoints, trace-events needs
+		 * it too,.. convert the bp crap over..
+		 */
+		struct task_struct *event_target;
 	};
 	int				state;
 	local64_t			prev_count;
@@ -857,6 +863,7 @@ struct perf_event {
 #ifdef CONFIG_EVENT_TRACING
 	struct ftrace_event_call	*tp_event;
 	struct event_filter		*filter;
+	struct perf_tp_idr		tp_idr;
 #endif
 
 #ifdef CONFIG_CGROUP_PERF
@@ -1139,7 +1146,7 @@ static inline bool perf_paranoid_kernel(
 extern void perf_event_init(void);
 extern void perf_tp_event(u64 addr, u64 count, void *record,
 			  int entry_size, struct pt_regs *regs,
-			  struct hlist_head *head, int rctx);
+			  int rctx, int id);
 extern void perf_bp_event(struct perf_event *event, void *data);
 
 #ifndef perf_misc_flags
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -82,6 +82,7 @@ struct sched_param {
 #include <linux/rculist.h>
 #include <linux/rtmutex.h>
 
+#include <linux/idr.h>
 #include <linux/time.h>
 #include <linux/param.h>
 #include <linux/resource.h>
@@ -1190,6 +1191,11 @@ enum perf_event_task_context {
 	perf_nr_task_contexts,
 };
 
+struct perf_tp_idr {
+	struct mutex	lock;
+	struct idr	idr;
+};
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
@@ -1473,6 +1479,9 @@ struct task_struct {
 	struct perf_event_context *perf_event_ctxp[perf_nr_task_contexts];
 	struct mutex perf_event_mutex;
 	struct list_head perf_event_list;
+#ifdef CONFIG_EVENT_TRACING
+	struct perf_tp_idr *perf_tp_idr;
+#endif
 #endif
 #ifdef CONFIG_NUMA
 	struct mempolicy *mempolicy;	/* Protected by alloc_lock */
Index: linux-2.6/include/trace/ftrace.h
===================================================================
--- linux-2.6.orig/include/trace/ftrace.h
+++ linux-2.6/include/trace/ftrace.h
@@ -708,7 +708,6 @@ perf_trace_##call(void *__data, proto)		
 	struct ftrace_raw_##call *entry;				\
 	struct pt_regs __regs;						\
 	u64 __addr = 0, __count = 1;					\
-	struct hlist_head *head;					\
 	int __entry_size;						\
 	int __data_size;						\
 	int rctx;							\
@@ -733,9 +732,8 @@ perf_trace_##call(void *__data, proto)		
 									\
 	{ assign; }							\
 									\
-	head = this_cpu_ptr(event_call->perf_events);			\
 	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
-		__count, &__regs, head);				\
+		__count, &__regs, event_call->event.type);		\
 }
 
 /*
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -830,6 +830,7 @@ list_add_event(struct perf_event *event,
 	ctx->nr_events++;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat++;
+	++ctx->generation;
 }
 
 /*
@@ -983,6 +984,7 @@ list_del_event(struct perf_event *event,
 	 */
 	if (event->state > PERF_EVENT_STATE_OFF)
 		event->state = PERF_EVENT_STATE_OFF;
+	++ctx->generation;
 }
 
 static void perf_group_detach(struct perf_event *event)
@@ -1901,6 +1903,14 @@ static void perf_event_context_sched_out
 	if (!cpuctx->task_ctx)
 		return;
 
+	/*
+	 * Need to sort out how to make task_struct::perf_tp_idr
+	 * work with this fancy switching stuff.. tracepoints could be
+	 * in multiple contexts due to the software event muck.
+	 */
+	if (task->perf_tp_idr)
+		goto do_switch;
+
 	rcu_read_lock();
 	parent = rcu_dereference(ctx->parent_ctx);
 	next_ctx = next->perf_event_ctxp[ctxn];
@@ -1936,6 +1946,7 @@ static void perf_event_context_sched_out
 	rcu_read_unlock();
 
 	if (do_switch) {
+do_switch:
 		ctx_sched_out(ctx, cpuctx, EVENT_ALL);
 		cpuctx->task_ctx = NULL;
 	}
@@ -3257,6 +3268,7 @@ static struct perf_event *perf_fget_ligh
 static int perf_event_set_output(struct perf_event *event,
 				 struct perf_event *output_event);
 static int perf_event_set_filter(struct perf_event *event, void __user *arg);
+static int perf_event_add_tp(struct perf_event *event, int tp_id);
 
 static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
@@ -3303,6 +3315,9 @@ static long perf_ioctl(struct file *file
 	case PERF_EVENT_IOC_SET_FILTER:
 		return perf_event_set_filter(event, (void __user *)arg);
 
+	case PERF_EVENT_IOC_ADD_TP:
+		return perf_event_add_tp(event, arg);
+
 	default:
 		return -ENOTTY;
 	}
@@ -5475,6 +5490,9 @@ static struct pmu perf_swevent = {
 
 #ifdef CONFIG_EVENT_TRACING
 
+#include <linux/ftrace_event.h>
+#include "trace/trace_output.h"
+
 static int perf_tp_filter_match(struct perf_event *event,
 				struct perf_sample_data *data)
 {
@@ -5489,8 +5507,12 @@ static int perf_tp_event_match(struct pe
 				struct perf_sample_data *data,
 				struct pt_regs *regs)
 {
+	if (event->state != PERF_EVENT_STATE_ACTIVE)
+		return 0;
+
 	if (event->hw.state & PERF_HES_STOPPED)
 		return 0;
+
 	/*
 	 * All tracepoints are from kernel-space.
 	 */
@@ -5503,12 +5525,62 @@ static int perf_tp_event_match(struct pe
 	return 1;
 }
 
+static void perf_tp_idr_init(struct perf_tp_idr *idr)
+{
+	idr_init(&idr->idr);
+	mutex_init(&idr->lock);
+}
+
+static DEFINE_PER_CPU(struct perf_tp_idr, perf_tp_idr);
+
+struct perf_tp_node {
+	struct list_head	list;
+	struct perf_event	*event;
+	struct rcu_head		rcu;
+};
+
+static void do_perf_tp_event(struct perf_event *event, u64 count,
+			     struct perf_sample_data *data,
+			     struct pt_regs *regs)
+{
+	if (perf_tp_event_match(event, data, regs))
+		perf_swevent_event(event, count, 1, data, regs);
+}
+
+static void perf_tp_idr_event(struct perf_tp_idr *tp_idr,
+			      int id, u64 count,
+			      struct perf_sample_data *data,
+			      struct pt_regs *regs)
+{
+	struct perf_tp_node *tp_node, *node;
+	struct perf_event *event;
+
+	if (!tp_idr)
+		return;
+
+	/*
+	 * Most of this is done under rcu_read_lock_sched(), which doesn't
+	 * exclude regular RCU grace periods, but the IDR code uses call_rcu()
+	 * so we have to use rcu_read_lock() here as well.
+	 */
+	rcu_read_lock();
+	tp_node = idr_find(&tp_idr->idr, id);
+	rcu_read_unlock();
+
+	if (!tp_node)
+		return;
+
+	event = tp_node->event;
+
+	do_perf_tp_event(event, count, data, regs);
+	list_for_each_entry_rcu(node, &tp_node->list, list)
+		do_perf_tp_event(node->event, count, data, regs);
+}
+
 void perf_tp_event(u64 addr, u64 count, void *record, int entry_size,
-		   struct pt_regs *regs, struct hlist_head *head, int rctx)
+		   struct pt_regs *regs, int rctx, int id)
 {
 	struct perf_sample_data data;
-	struct perf_event *event;
-	struct hlist_node *node;
 
 	struct perf_raw_record raw = {
 		.size = entry_size,
@@ -5518,18 +5590,197 @@ void perf_tp_event(u64 addr, u64 count, 
 	perf_sample_data_init(&data, addr);
 	data.raw = &raw;
 
-	hlist_for_each_entry_rcu(event, node, head, hlist_entry) {
-		if (perf_tp_event_match(event, &data, regs))
-			perf_swevent_event(event, count, 1, &data, regs);
-	}
+	perf_tp_idr_event(&__get_cpu_var(perf_tp_idr), id, count, &data, regs);
+	perf_tp_idr_event(current->perf_tp_idr, id, count, &data, regs);
 
 	perf_swevent_put_recursion_context(rctx);
 }
 EXPORT_SYMBOL_GPL(perf_tp_event);
 
+static struct perf_tp_idr *
+perf_tp_init_task(struct perf_event *event, struct task_struct *task)
+{
+	struct perf_tp_idr *idr;
+
+	mutex_lock(&task->perf_event_mutex);
+	idr = task->perf_tp_idr;
+	if (idr)
+		goto unlock;
+
+	idr = kzalloc(sizeof(struct perf_tp_idr), GFP_KERNEL);
+	if (!idr)
+		goto unlock;
+
+	perf_tp_idr_init(idr);
+
+	task->perf_tp_idr = idr;
+unlock:
+	mutex_unlock(&task->perf_event_mutex);
+
+	return idr;
+}
+
+static struct perf_tp_idr *perf_event_idr(struct perf_event *event, bool create)
+{
+	struct perf_tp_idr *tp_idr;
+	struct task_struct *task;
+
+	if (event->attach_state & PERF_ATTACH_TASK) {
+		task = event->hw.event_target;
+		tp_idr = task->perf_tp_idr;
+		if (!tp_idr && create)
+			tp_idr = perf_tp_init_task(event, task);
+	} else
+		tp_idr = &per_cpu(perf_tp_idr, event->cpu);
+
+	return tp_idr;
+}
+
+static void perf_tp_free_node(struct rcu_head *rcu)
+{
+	struct perf_tp_node *node = container_of(rcu, struct perf_tp_node, rcu);
+
+	kfree(node);
+}
+
+static int perf_tp_remove_idr(int id, void *p, void *data)
+{
+	struct perf_tp_node *node = p;
+	struct perf_tp_node *first, *next;
+	struct perf_tp_idr *tp_idr = data;
+
+	if (!tp_idr)
+		goto no_idr;
+
+	mutex_lock(&tp_idr->lock);
+	first = idr_find(&tp_idr->idr, id);
+	if (first == node) {
+		next = list_first_entry(&first->list, struct perf_tp_node, list);
+		if (next != first)
+			idr_replace(&tp_idr->idr, next, id);
+		else
+			idr_remove(&tp_idr->idr, id);
+	}
+	list_del_rcu(&node->list);
+	mutex_unlock(&tp_idr->lock);
+
+no_idr:
+	perf_trace_destroy_id(id);
+	call_rcu_sched(&node->rcu, perf_tp_free_node);
+	return 0;
+}
+
 static void tp_perf_event_destroy(struct perf_event *event)
 {
-	perf_trace_destroy(event);
+	/*
+	 * Since this is the free path, the fd is gone an there
+	 * can be no concurrency on event->tp_idr.
+	 */
+
+	idr_for_each(&event->tp_idr.idr, perf_tp_remove_idr,
+			perf_event_idr(event, false));
+
+	idr_remove_all(&event->tp_idr.idr);
+	idr_destroy(&event->tp_idr.idr);
+}
+
+static int __perf_event_add_tp(struct perf_event *event, int tp_id)
+{
+	struct perf_tp_node *node, *first;
+	struct perf_tp_idr *idr;
+	int tmp_id, err, ret = -ENOMEM;
+
+	node = kmalloc(sizeof(*node), GFP_KERNEL);
+	if (!node)
+		goto out;
+
+	node->event = event;
+	INIT_LIST_HEAD(&node->list);
+
+	/*
+	 * Insert the node into the event->idr, this idr tracks the
+	 * tracepoints we're interested in, it has a 1:1 relation
+	 * with the node.
+	 */
+	idr = &event->tp_idr;
+	mutex_lock(&idr->lock);
+	err = idr_pre_get(&idr->idr, GFP_KERNEL);
+	if (!err) {
+		ret = -ENOMEM;
+		goto free_node;
+	}
+
+	ret = idr_get_new_above(&idr->idr, node, tp_id, &tmp_id);
+	if (ret)
+		goto free_node;
+
+	if (WARN_ON(tp_id != tmp_id)) {
+		printk(KERN_ERR "fail: %d %d\n" , tp_id, tmp_id);
+		ret = -EBUSY;
+		goto free_idr1;
+	}
+	mutex_unlock(&idr->lock);
+
+	/*
+	 * Insert the node into the task/cpu idr, this idr tracks
+	 * all active tracepoints for the task/cpu, it has a 1:n relation
+	 * with the node.
+	 */
+	idr = perf_event_idr(event, true);
+	if (!idr) {
+		if (event->attach_state & PERF_ATTACH_CONTEXT)
+			ret = -ENOMEM;
+		else
+			ret = -ESRCH;
+		goto free_idr1_set;
+	}
+	mutex_lock(&idr->lock);
+	first = idr_find(&idr->idr, tp_id);
+	if (first) {
+		list_add_rcu(&node->list, &first->list);
+		goto unlock;
+	}
+
+	err = idr_pre_get(&idr->idr, GFP_KERNEL);
+	if (!err) {
+		ret = -ENOMEM;
+		goto free_idr1_set_unlock;
+	}
+
+	ret = idr_get_new_above(&idr->idr, node, tp_id, &tmp_id);
+	if (ret)
+		goto free_idr1_set;
+
+	if (WARN_ON(tp_id != tmp_id)) {
+		ret = -EBUSY;
+		goto free_idr2;
+	}
+unlock:
+	mutex_unlock(&idr->lock);
+
+	ret = perf_trace_init(event, tp_id);
+	if (ret)
+		goto free_all;
+
+out:
+	return ret;
+
+free_all:
+	mutex_lock(&idr->lock);
+free_idr2:
+	idr_remove(&idr->idr, tmp_id);
+free_idr1_set_unlock:
+	mutex_unlock(&idr->lock);
+free_idr1_set:
+	idr = &event->tp_idr;
+	tmp_id = tp_id;
+	mutex_lock(&idr->lock);
+free_idr1:
+	idr_remove(&idr->idr, tmp_id);
+free_node:
+	mutex_unlock(&idr->lock);
+	kfree(node);
+	goto out;
 }
 
 static int perf_tp_event_init(struct perf_event *event)
@@ -5539,21 +5790,35 @@ static int perf_tp_event_init(struct per
 	if (event->attr.type != PERF_TYPE_TRACEPOINT)
 		return -ENOENT;
 
-	err = perf_trace_init(event);
-	if (err)
-		return err;
+	perf_tp_idr_init(&event->tp_idr);
 
 	event->destroy = tp_perf_event_destroy;
 
+	if (event->attr.config != ~0ULL) {
+		err = __perf_event_add_tp(event, event->attr.config);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
+static int perf_tp_event_add(struct perf_event *event, int flags)
+{
+	event->hw.state = flags & PERF_EF_START ? 0 : PERF_HES_STOPPED;
+	return 0;
+}
+
+static void perf_tp_event_del(struct perf_event *event, int flags)
+{
+}
+
 static struct pmu perf_tracepoint = {
 	.task_ctx_nr	= perf_sw_context,
 
 	.event_init	= perf_tp_event_init,
-	.add		= perf_trace_add,
-	.del		= perf_trace_del,
+	.add		= perf_tp_event_add,
+	.del		= perf_tp_event_del,
 	.start		= perf_swevent_start,
 	.stop		= perf_swevent_stop,
 	.read		= perf_swevent_read,
@@ -5561,6 +5826,11 @@ static struct pmu perf_tracepoint = {
 
 static inline void perf_tp_register(void)
 {
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		perf_tp_idr_init(&per_cpu(perf_tp_idr, cpu));
+
 	perf_pmu_register(&perf_tracepoint, "tracepoint", PERF_TYPE_TRACEPOINT);
 }
 
@@ -5569,7 +5839,8 @@ static int perf_event_set_filter(struct 
 	char *filter_str;
 	int ret;
 
-	if (event->attr.type != PERF_TYPE_TRACEPOINT)
+	if (event->attr.type != PERF_TYPE_TRACEPOINT ||
+	    event->attr.config == ~0ULL)
 		return -EINVAL;
 
 	filter_str = strndup_user(arg, PAGE_SIZE);
@@ -5587,6 +5858,74 @@ static void perf_event_free_filter(struc
 	ftrace_profile_free_filter(event);
 }
 
+static int perf_event_add_tp(struct perf_event *event, int tp_id)
+{
+	if (event->attr.type != PERF_TYPE_TRACEPOINT &&
+	    event->attr.config != ~0ULL)
+		return -EINVAL;
+
+	return __perf_event_add_tp(event, tp_id);
+}
+
+/*
+ * Called from the exit path, _after_ all events have been detached from it.
+ */
+static void perf_tp_event_exit(struct task_struct *tsk)
+{
+	struct perf_tp_idr *idr = tsk->perf_tp_idr;
+
+	if (!idr)
+		return;
+
+	idr_remove_all(&idr->idr);
+	idr_destroy(&idr->idr);
+}
+
+static void perf_tp_event_delayed_put(struct task_struct *tsk)
+{
+	struct perf_tp_idr *idr = tsk->perf_tp_idr;
+
+	tsk->perf_tp_idr = NULL;
+	kfree(idr);
+}
+
+static int perf_tp_inherit_idr(int id, void *p, void *data)
+{
+	struct perf_event *child = data;
+
+	return __perf_event_add_tp(child, id);
+}
+
+static int perf_tp_event_inherit(struct perf_event *parent_event,
+				 struct perf_event *child_event)
+{
+	int ret;
+
+	if (parent_event->attr.type != PERF_TYPE_TRACEPOINT ||
+	    parent_event->attr.config != ~0ULL)
+		return 0;
+
+	/*
+	 * The child is not yet exposed, hence no need to serialize things
+	 * on that side.
+	 */
+	mutex_lock(&parent_event->tp_idr.lock);
+	ret = idr_for_each(&parent_event->tp_idr.idr,
+			perf_tp_inherit_idr,
+			child_event);
+	mutex_unlock(&parent_event->tp_idr.lock);
+
+	return ret;
+}
+
+static void perf_tp_event_init_task(struct task_struct *child)
+{
+	/*
+	 * Clear the idr pointer copied from the parent.
+	 */
+	child->perf_tp_idr = NULL;
+}
+
 #else
 
 static inline void perf_tp_register(void)
@@ -5602,6 +5941,29 @@ static void perf_event_free_filter(struc
 {
 }
 
+static int perf_event_add_tp(struct perf_event *event, int tp_id)
+{
+	return -ENOENT;
+}
+
+static void perf_tp_event_exit(struct task_struct *tsk)
+{
+}
+
+static void perf_tp_event_delayed_put(struct task_struct *tsk)
+{
+}
+
+static int perf_tp_event_inherit(struct perf_event *parent_event,
+				 struct perf_event *child_event)
+{
+	return 0;
+}
+
+static void perf_tp_event_init_task()(struct task_struct *child)
+{
+}
+
 #endif /* CONFIG_EVENT_TRACING */
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
@@ -6177,6 +6539,9 @@ perf_event_alloc(struct perf_event_attr 
 	INIT_LIST_HEAD(&event->sibling_list);
 	init_waitqueue_head(&event->waitq);
 	init_irq_work(&event->pending, perf_pending_event);
+#ifdef CONFIG_EVENT_TRACING
+	perf_tp_idr_init(&event->tp_idr);
+#endif
 
 	mutex_init(&event->mmap_mutex);
 
@@ -6195,6 +6560,7 @@ perf_event_alloc(struct perf_event_attr 
 
 	if (task) {
 		event->attach_state = PERF_ATTACH_TASK;
+		event->hw.event_target = task;
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 		/*
 		 * hw_breakpoint is a bit difficult here..
@@ -6240,7 +6606,7 @@ perf_event_alloc(struct perf_event_attr 
 	if (err) {
 		if (event->ns)
 			put_pid_ns(event->ns);
-		kfree(event);
+		free_event(event);
 		return ERR_PTR(err);
 	}
 
@@ -6603,7 +6969,6 @@ SYSCALL_DEFINE5(perf_event_open,
 	}
 
 	perf_install_in_context(ctx, event, cpu);
-	++ctx->generation;
 	perf_unpin_context(ctx);
 	mutex_unlock(&ctx->mutex);
 
@@ -6680,7 +7045,6 @@ perf_event_create_kernel_counter(struct 
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
 	perf_install_in_context(ctx, event, cpu);
-	++ctx->generation;
 	perf_unpin_context(ctx);
 	mutex_unlock(&ctx->mutex);
 
@@ -6857,6 +7221,8 @@ void perf_event_exit_task(struct task_st
 
 	for_each_task_context_nr(ctxn)
 		perf_event_exit_task_context(child, ctxn);
+
+	perf_tp_event_exit(child);
 }
 
 static void perf_free_event(struct perf_event *event,
@@ -6919,6 +7285,8 @@ void perf_event_delayed_put(struct task_
 
 	for_each_task_context_nr(ctxn)
 		WARN_ON_ONCE(task->perf_event_ctxp[ctxn]);
+
+	perf_tp_event_delayed_put(task);
 }
 
 /*
@@ -6934,6 +7302,7 @@ inherit_event(struct perf_event *parent_
 {
 	struct perf_event *child_event;
 	unsigned long flags;
+	int ret;
 
 	/*
 	 * Instead of creating recursive hierarchies of events,
@@ -6951,6 +7320,13 @@ inherit_event(struct perf_event *parent_
 					   NULL);
 	if (IS_ERR(child_event))
 		return child_event;
+
+	ret = perf_tp_event_inherit(parent_event, child_event);
+	if (ret) {
+		free_event(child_event);
+		return ERR_PTR(ret);
+	}
+
 	get_ctx(child_ctx);
 
 	/*
@@ -7061,9 +7437,7 @@ inherit_task_group(struct perf_event *ev
 		child->perf_event_ctxp[ctxn] = child_ctx;
 	}
 
-	ret = inherit_group(event, parent, parent_ctx,
-			    child, child_ctx);
-
+	ret = inherit_group(event, parent, parent_ctx, child, child_ctx);
 	if (ret)
 		*inherited_all = 0;
 
@@ -7176,6 +7550,8 @@ int perf_event_init_task(struct task_str
 	mutex_init(&child->perf_event_mutex);
 	INIT_LIST_HEAD(&child->perf_event_list);
 
+	perf_tp_event_init_task(child);
+
 	for_each_task_context_nr(ctxn) {
 		ret = perf_event_init_context(child, ctxn);
 		if (ret)
Index: linux-2.6/kernel/trace/trace_event_perf.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_event_perf.c
+++ linux-2.6/kernel/trace/trace_event_perf.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/kprobes.h>
 #include "trace.h"
+#include "trace_output.h"
 
 static char __percpu *perf_trace_buf[PERF_NR_CONTEXTS];
 
@@ -47,9 +48,7 @@ static int perf_trace_event_perm(struct 
 static int perf_trace_event_init(struct ftrace_event_call *tp_event,
 				 struct perf_event *p_event)
 {
-	struct hlist_head __percpu *list;
 	int ret;
-	int cpu;
 
 	ret = perf_trace_event_perm(tp_event, p_event);
 	if (ret)
@@ -61,15 +60,6 @@ static int perf_trace_event_init(struct 
 
 	ret = -ENOMEM;
 
-	list = alloc_percpu(struct hlist_head);
-	if (!list)
-		goto fail;
-
-	for_each_possible_cpu(cpu)
-		INIT_HLIST_HEAD(per_cpu_ptr(list, cpu));
-
-	tp_event->perf_events = list;
-
 	if (!total_ref_count) {
 		char __percpu *buf;
 		int i;
@@ -100,63 +90,40 @@ static int perf_trace_event_init(struct 
 		}
 	}
 
-	if (!--tp_event->perf_refcount) {
-		free_percpu(tp_event->perf_events);
-		tp_event->perf_events = NULL;
-	}
+	--tp_event->perf_refcount;
 
 	return ret;
 }
 
-int perf_trace_init(struct perf_event *p_event)
+int perf_trace_init(struct perf_event *p_event, int event_id)
 {
 	struct ftrace_event_call *tp_event;
-	int event_id = p_event->attr.config;
+	struct trace_event *t_event;
 	int ret = -EINVAL;
 
+	trace_event_read_lock();
+	t_event = ftrace_find_event(event_id);
+	if (!t_event)
+		goto out;
+
+	tp_event = container_of(t_event, struct ftrace_event_call, event);
+
 	mutex_lock(&event_mutex);
-	list_for_each_entry(tp_event, &ftrace_events, list) {
-		if (tp_event->event.type == event_id &&
-		    tp_event->class && tp_event->class->reg &&
-		    try_module_get(tp_event->mod)) {
-			ret = perf_trace_event_init(tp_event, p_event);
-			if (ret)
-				module_put(tp_event->mod);
-			break;
-		}
+	if (tp_event->class && tp_event->class->reg &&
+			try_module_get(tp_event->mod)) {
+		ret = perf_trace_event_init(tp_event, p_event);
+		if (ret)
+			module_put(tp_event->mod);
 	}
 	mutex_unlock(&event_mutex);
+out:
+	trace_event_read_unlock();
 
 	return ret;
 }
 
-int perf_trace_add(struct perf_event *p_event, int flags)
-{
-	struct ftrace_event_call *tp_event = p_event->tp_event;
-	struct hlist_head __percpu *pcpu_list;
-	struct hlist_head *list;
-
-	pcpu_list = tp_event->perf_events;
-	if (WARN_ON_ONCE(!pcpu_list))
-		return -EINVAL;
-
-	if (!(flags & PERF_EF_START))
-		p_event->hw.state = PERF_HES_STOPPED;
-
-	list = this_cpu_ptr(pcpu_list);
-	hlist_add_head_rcu(&p_event->hlist_entry, list);
-
-	return 0;
-}
-
-void perf_trace_del(struct perf_event *p_event, int flags)
-{
-	hlist_del_rcu(&p_event->hlist_entry);
-}
-
-void perf_trace_destroy(struct perf_event *p_event)
+static void __perf_trace_destroy(struct ftrace_event_call *tp_event)
 {
-	struct ftrace_event_call *tp_event = p_event->tp_event;
 	int i;
 
 	mutex_lock(&event_mutex);
@@ -171,9 +138,6 @@ void perf_trace_destroy(struct perf_even
 	 */
 	tracepoint_synchronize_unregister();
 
-	free_percpu(tp_event->perf_events);
-	tp_event->perf_events = NULL;
-
 	if (!--total_ref_count) {
 		for (i = 0; i < PERF_NR_CONTEXTS; i++) {
 			free_percpu(perf_trace_buf[i]);
@@ -185,6 +149,27 @@ void perf_trace_destroy(struct perf_even
 	mutex_unlock(&event_mutex);
 }
 
+void perf_trace_destroy(struct perf_event *p_event)
+{
+	__perf_trace_destroy(p_event->tp_event);
+}
+
+void perf_trace_destroy_id(int event_id)
+{
+	struct ftrace_event_call *tp_event;
+	struct trace_event *t_event;
+
+	trace_event_read_lock();
+	t_event = ftrace_find_event(event_id);
+	if (!t_event)
+		goto unlock;
+
+	tp_event = container_of(t_event, struct ftrace_event_call, event);
+	__perf_trace_destroy(tp_event);
+unlock:
+	trace_event_read_unlock();
+}
+
 __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
 				       struct pt_regs *regs, int *rctxp)
 {
Index: linux-2.6/kernel/trace/trace_kprobe.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_kprobe.c
+++ linux-2.6/kernel/trace/trace_kprobe.c
@@ -1660,7 +1660,6 @@ static __kprobes void kprobe_perf_func(s
 	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
 	struct ftrace_event_call *call = &tp->call;
 	struct kprobe_trace_entry_head *entry;
-	struct hlist_head *head;
 	int size, __size, dsize;
 	int rctx;
 
@@ -1680,8 +1679,8 @@ static __kprobes void kprobe_perf_func(s
 	memset(&entry[1], 0, dsize);
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
 
-	head = this_cpu_ptr(call->perf_events);
-	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, regs, head);
+	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, regs,
+			      call->event.type);
 }
 
 /* Kretprobe profile handler */
@@ -1691,7 +1690,6 @@ static __kprobes void kretprobe_perf_fun
 	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
 	struct ftrace_event_call *call = &tp->call;
 	struct kretprobe_trace_entry_head *entry;
-	struct hlist_head *head;
 	int size, __size, dsize;
 	int rctx;
 
@@ -1711,8 +1709,8 @@ static __kprobes void kretprobe_perf_fun
 	entry->ret_ip = (unsigned long)ri->ret_addr;
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
 
-	head = this_cpu_ptr(call->perf_events);
-	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1, regs, head);
+	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1,
+			      regs, call->event.type);
 }
 
 static int probe_perf_enable(struct ftrace_event_call *call)
Index: linux-2.6/kernel/trace/trace_output.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_output.c
+++ linux-2.6/kernel/trace/trace_output.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/ftrace.h>
+#include <linux/idr.h>
 
 #include "trace_output.h"
 
@@ -16,9 +17,9 @@
 
 DECLARE_RWSEM(trace_event_mutex);
 
-static struct hlist_head event_hash[EVENT_HASHSIZE] __read_mostly;
+static const int first_event_type = __TRACE_LAST_TYPE + 1;
 
-static int next_event_type = __TRACE_LAST_TYPE + 1;
+static DEFINE_IDR(trace_type_idr);
 
 int trace_print_seq(struct seq_file *m, struct trace_seq *s)
 {
@@ -664,58 +665,43 @@ static int task_state_char(unsigned long
  */
 struct trace_event *ftrace_find_event(int type)
 {
-	struct trace_event *event;
-	struct hlist_node *n;
-	unsigned key;
-
-	key = type & (EVENT_HASHSIZE - 1);
-
-	hlist_for_each_entry(event, n, &event_hash[key], node) {
-		if (event->type == type)
-			return event;
-	}
-
-	return NULL;
+	return idr_find(&trace_type_idr, type);
 }
 
-static LIST_HEAD(ftrace_event_list);
+void trace_event_read_lock(void)
+{
+	down_read(&trace_event_mutex);
+}
 
-static int trace_search_list(struct list_head **list)
+void trace_event_read_unlock(void)
 {
-	struct trace_event *e;
-	int last = __TRACE_LAST_TYPE;
+	up_read(&trace_event_mutex);
+}
 
-	if (list_empty(&ftrace_event_list)) {
-		*list = &ftrace_event_list;
-		return last + 1;
-	}
+static int register_event(struct trace_event *event, int id, bool strict)
+{
+	int ret, type;
 
-	/*
-	 * We used up all possible max events,
-	 * lets see if somebody freed one.
-	 */
-	list_for_each_entry(e, &ftrace_event_list, list) {
-		if (e->type != last + 1)
-			break;
-		last++;
-	}
+	ret = idr_pre_get(&trace_type_idr, GFP_KERNEL);
+	if (!ret)
+		return 0;
 
-	/* Did we used up all 65 thousand events??? */
-	if ((last + 1) > FTRACE_MAX_EVENT)
+	ret = idr_get_new_above(&trace_type_idr, event, id, &type);
+	if (ret)
 		return 0;
 
-	*list = &e->list;
-	return last + 1;
-}
+	if (strict && id != type) {
+		idr_remove(&trace_type_idr, type);
+		return 0;
+	}
 
-void trace_event_read_lock(void)
-{
-	down_read(&trace_event_mutex);
-}
+	if (type > FTRACE_MAX_EVENT) {
+		idr_remove(&trace_type_idr, type);
+		return 0;
+	}
 
-void trace_event_read_unlock(void)
-{
-	up_read(&trace_event_mutex);
+	event->type = type;
+	return type;
 }
 
 /**
@@ -735,7 +721,6 @@ void trace_event_read_unlock(void)
  */
 int register_ftrace_event(struct trace_event *event)
 {
-	unsigned key;
 	int ret = 0;
 
 	down_write(&trace_event_mutex);
@@ -746,35 +731,18 @@ int register_ftrace_event(struct trace_e
 	if (WARN_ON(!event->funcs))
 		goto out;
 
-	INIT_LIST_HEAD(&event->list);
-
 	if (!event->type) {
-		struct list_head *list = NULL;
-
-		if (next_event_type > FTRACE_MAX_EVENT) {
-
-			event->type = trace_search_list(&list);
-			if (!event->type)
-				goto out;
-
-		} else {
-			
-			event->type = next_event_type++;
-			list = &ftrace_event_list;
-		}
-
-		if (WARN_ON(ftrace_find_event(event->type)))
+		ret = register_event(event, first_event_type, false);
+		if (!ret)
 			goto out;
-
-		list_add_tail(&event->list, list);
-
-	} else if (event->type > __TRACE_LAST_TYPE) {
-		printk(KERN_WARNING "Need to add type to trace.h\n");
-		WARN_ON(1);
-		goto out;
 	} else {
-		/* Is this event already used */
-		if (ftrace_find_event(event->type))
+		if (event->type > __TRACE_LAST_TYPE) {
+			printk(KERN_WARNING "Need to add type to trace.h\n");
+			WARN_ON(1);
+			goto out;
+		}
+		ret = register_event(event, event->type, true);
+		if (!ret)
 			goto out;
 	}
 
@@ -787,11 +755,6 @@ int register_ftrace_event(struct trace_e
 	if (event->funcs->binary == NULL)
 		event->funcs->binary = trace_nop_print;
 
-	key = event->type & (EVENT_HASHSIZE - 1);
-
-	hlist_add_head(&event->node, &event_hash[key]);
-
-	ret = event->type;
  out:
 	up_write(&trace_event_mutex);
 
@@ -804,8 +767,7 @@ EXPORT_SYMBOL_GPL(register_ftrace_event)
  */
 int __unregister_ftrace_event(struct trace_event *event)
 {
-	hlist_del(&event->node);
-	list_del(&event->list);
+	idr_remove(&trace_type_idr, event->type);
 	return 0;
 }
 
Index: linux-2.6/kernel/trace/trace_syscalls.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_syscalls.c
+++ linux-2.6/kernel/trace/trace_syscalls.c
@@ -499,7 +499,6 @@ static void perf_syscall_enter(void *ign
 {
 	struct syscall_metadata *sys_data;
 	struct syscall_trace_enter *rec;
-	struct hlist_head *head;
 	int syscall_nr;
 	int rctx;
 	int size;
@@ -530,8 +529,7 @@ static void perf_syscall_enter(void *ign
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args,
 			       (unsigned long *)&rec->args);
 
-	head = this_cpu_ptr(sys_data->enter_event->perf_events);
-	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head);
+	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, rec->ent.type);
 }
 
 int perf_sysenter_enable(struct ftrace_event_call *call)
@@ -573,7 +571,6 @@ static void perf_syscall_exit(void *igno
 {
 	struct syscall_metadata *sys_data;
 	struct syscall_trace_exit *rec;
-	struct hlist_head *head;
 	int syscall_nr;
 	int rctx;
 	int size;
@@ -606,8 +603,7 @@ static void perf_syscall_exit(void *igno
 	rec->nr = syscall_nr;
 	rec->ret = syscall_get_return_value(current, regs);
 
-	head = this_cpu_ptr(sys_data->exit_event->perf_events);
-	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head);
+	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, rec->ent.type);
 }
 
 int perf_sysexit_enable(struct ftrace_event_call *call)


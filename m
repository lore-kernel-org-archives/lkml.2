Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab0HaPcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:32:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:47634 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224Ab0HaPcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:32:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=Z1aFCmkw5k3A7NyfoanZVA1rINTXUsZe148NGDU7npvXDGakb+c/+6TwUfl0rhA1e
	kDQyrhcMhwPZ6U3DinxhQ==
Message-ID: <4c7d2077.1707e30a.0547.6dd4@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Tue, 31 Aug 2010 17:25:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com
Subject: [RFC PATCH 1/2] perf_events: add support for per-cpu per-cgroup monitoring
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This kernel patch adds the ability to filter monitoring based on
container groups (cgroups). This is for use in per-cpu mode only.
    
The patch adds perf_event_attr.cgroup, a boolean, to activate
the mode. The cgroup is designated by passing, perf_event_attr.cgroup_fd,
on opened file descriptor to the <mnt>/<cgroup>/perf_event.perf file.
    
Signed-off-by: Stephane Eranian <eranian@google.com>
--

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 3cb7d04..ed76357 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -618,6 +618,8 @@ bool css_is_ancestor(struct cgroup_subsys_state *cg,
 unsigned short css_id(struct cgroup_subsys_state *css);
 unsigned short css_depth(struct cgroup_subsys_state *css);
 
+struct cgroup_subsys_state *cgroup_css_from_file(struct file *f, int id);
+
 #else /* !CONFIG_CGROUPS */
 
 static inline int cgroup_init_early(void) { return 0; }
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index ccefff0..93f86b7 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -65,4 +65,8 @@ SUBSYS(net_cls)
 SUBSYS(blkio)
 #endif
 
+#ifdef CONFIG_PERF_EVENTS
+SUBSYS(perf)
+#endif
+
 /* */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 000610c..9f7a645 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -215,8 +215,9 @@ struct perf_event_attr {
 				 */
 				precise_ip     :  2, /* skid constraint       */
 				mmap_data      :  1, /* non-exec mmap data    */
+				cgroup         :  1, /* cgroup aggregation    */
 
-				__reserved_1   : 46;
+				__reserved_1   : 45;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -226,6 +227,8 @@ struct perf_event_attr {
 	__u32			bp_type;
 	__u64			bp_addr;
 	__u64			bp_len;
+
+	int			cgroup_fd;
 };
 
 /*
@@ -463,6 +466,7 @@ enum perf_callchain_context {
 #ifdef CONFIG_PERF_EVENTS
 # include <asm/perf_event.h>
 # include <asm/local64.h>
+# include <linux/cgroup.h>
 #endif
 
 struct perf_guest_info_callbacks {
@@ -657,6 +661,12 @@ struct swevent_hlist {
 #define PERF_ATTACH_CONTEXT	0x01
 #define PERF_ATTACH_GROUP	0x02
 
+#ifdef CONFIG_CGROUPS
+struct perf_cgroup {
+	struct cgroup_subsys_state css;
+};
+#endif
+
 /**
  * struct perf_event - performance event kernel representation:
  */
@@ -759,7 +769,9 @@ struct perf_event {
 	struct ftrace_event_call	*tp_event;
 	struct event_filter		*filter;
 #endif
-
+#ifdef CONFIG_CGROUPS
+	struct perf_cgroup		*css;
+#endif
 #endif /* CONFIG_PERF_EVENTS */
 };
 
@@ -806,6 +818,8 @@ struct perf_event_context {
 	u64				generation;
 	int				pin_count;
 	struct rcu_head			rcu_head;
+
+	int				nr_cgroups;
 };
 
 /*
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e5c5497..3e56354 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4722,6 +4722,23 @@ css_get_next(struct cgroup_subsys *ss, int id,
 	return ret;
 }
 
+struct cgroup_subsys_state *cgroup_css_from_file(struct file *f, int id)
+{
+	struct cgroup *cgrp;
+
+	/* check in cgroup filesystem */
+	if (f->f_op != &cgroup_seqfile_operations)
+		return ERR_PTR(-EBADF);
+
+	if (id < 0 || id >= CGROUP_SUBSYS_COUNT)
+		return ERR_PTR(-EINVAL);
+
+	/* get cgroup */
+	cgrp = __d_cgrp(f->f_dentry->d_parent);
+
+	return cgrp->subsys[id];
+}
+
 #ifdef CONFIG_CGROUP_DEBUG
 static struct cgroup_subsys_state *debug_create(struct cgroup_subsys *ss,
 						   struct cgroup *cont)
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index d196412..01a85f7 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -49,6 +49,77 @@ static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
 static atomic_t nr_task_events __read_mostly;
 
+#ifdef CONFIG_CGROUPS
+
+static inline struct perf_cgroup *
+perf_cgroup_from_task(struct task_struct *task)
+{
+	if (!task)
+		return NULL;
+	return container_of(task_subsys_state(task, perf_subsys_id),
+			struct perf_cgroup, css);
+}
+
+static inline
+struct perf_cgroup *perf_cgroup_from_cont(struct cgroup *cont)
+{
+	return container_of(cgroup_subsys_state(cont, perf_subsys_id),
+			struct perf_cgroup, css);
+}
+
+static inline bool
+perf_cgroup_match(struct perf_event *event, struct task_struct *task)
+{
+	struct perf_cgroup *css = perf_cgroup_from_task(task);
+	return !event->css || event->css == css;
+}
+
+static void *perf_get_cgroup(int fd)
+{
+	struct cgroup_subsys_state *css;
+	struct file *file;
+	int fput_needed;
+
+	file = fget_light(fd, &fput_needed);
+	if (!file)
+		return ERR_PTR(-EBADF);
+
+	css = cgroup_css_from_file(file, perf_subsys_id);
+	if (!IS_ERR(css))
+		css_get(css);
+
+	fput_light(file, fput_needed);
+
+	return css;
+}
+
+static inline void perf_put_cgroup(struct perf_event *event)
+{
+	if (event->css)
+		css_put(&event->css->css);
+}
+#else /* !CONFIG_CGROUP */
+static inline bool
+perf_cgroup_match(struct perf_event *event, struct task_struct *task)
+{
+	return true;
+}
+
+static inline void *perf_get_cgroup(int fd)
+{
+	return ERR_PTR(-ENOTSUPP);
+}
+
+static inline void perf_put_cgroup(struct perf_event *event)
+{}
+
+#endif
+
+static inline int is_cgroup_event(struct perf_event *event)
+{
+	return event->css != NULL;
+}
+
 /*
  * perf event paranoia level:
  *  -1 - not paranoid at all
@@ -301,6 +372,9 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 		list_add_tail(&event->group_entry, list);
 	}
 
+	if (is_cgroup_event(event))
+		ctx->nr_cgroups++;
+
 	list_add_rcu(&event->event_entry, &ctx->event_list);
 	ctx->nr_events++;
 	if (event->attr.inherit_stat)
@@ -340,6 +414,9 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 
 	event->attach_state &= ~PERF_ATTACH_CONTEXT;
 
+	if (is_cgroup_event(event))
+		ctx->nr_cgroups--;
+
 	ctx->nr_events--;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat--;
@@ -403,9 +480,10 @@ static void perf_group_detach(struct perf_event *event)
 }
 
 static inline int
-event_filter_match(struct perf_event *event)
+event_filter_match(struct perf_event *event, struct task_struct *task)
 {
-	return event->cpu == -1 || event->cpu == smp_processor_id();
+	return (event->cpu == -1 || event->cpu == smp_processor_id())
+	    && perf_cgroup_match(event, task);
 }
 
 static void
@@ -421,7 +499,7 @@ event_sched_out(struct perf_event *event,
 	 * via read() for time_enabled, time_running
 	 */
 	if (event->state == PERF_EVENT_STATE_INACTIVE
-	    && !event_filter_match(event)) {
+	    && !event_filter_match(event, current)) {
 		delta = ctx->time - event->tstamp_stopped;
 		event->tstamp_running += delta;
 		event->tstamp_stopped = ctx->time;
@@ -820,7 +898,7 @@ static void __perf_install_in_context(void *info)
 
 	add_event_to_ctx(event, ctx);
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event, current))
 		goto unlock;
 
 	/*
@@ -966,7 +1044,7 @@ static void __perf_event_enable(void *info)
 		goto unlock;
 	__perf_event_mark_enabled(event, ctx);
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event, current))
 		goto unlock;
 
 	/*
@@ -1209,71 +1287,6 @@ static void perf_event_sync_stat(struct perf_event_context *ctx,
 	}
 }
 
-/*
- * Called from scheduler to remove the events of the current task,
- * with interrupts disabled.
- *
- * We stop each event and update the event value in event->count.
- *
- * This does not protect us against NMI, but disable()
- * sets the disabled bit in the control field of event _before_
- * accessing the event control register. If a NMI hits, then it will
- * not restart the event.
- */
-void perf_event_task_sched_out(struct task_struct *task,
-				 struct task_struct *next)
-{
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
-	struct perf_event_context *ctx = task->perf_event_ctxp;
-	struct perf_event_context *next_ctx;
-	struct perf_event_context *parent;
-	int do_switch = 1;
-
-	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
-
-	if (likely(!ctx || !cpuctx->task_ctx))
-		return;
-
-	rcu_read_lock();
-	parent = rcu_dereference(ctx->parent_ctx);
-	next_ctx = next->perf_event_ctxp;
-	if (parent && next_ctx &&
-	    rcu_dereference(next_ctx->parent_ctx) == parent) {
-		/*
-		 * Looks like the two contexts are clones, so we might be
-		 * able to optimize the context switch.  We lock both
-		 * contexts and check that they are clones under the
-		 * lock (including re-checking that neither has been
-		 * uncloned in the meantime).  It doesn't matter which
-		 * order we take the locks because no other cpu could
-		 * be trying to lock both of these tasks.
-		 */
-		raw_spin_lock(&ctx->lock);
-		raw_spin_lock_nested(&next_ctx->lock, SINGLE_DEPTH_NESTING);
-		if (context_equiv(ctx, next_ctx)) {
-			/*
-			 * XXX do we need a memory barrier of sorts
-			 * wrt to rcu_dereference() of perf_event_ctxp
-			 */
-			task->perf_event_ctxp = next_ctx;
-			next->perf_event_ctxp = ctx;
-			ctx->task = next;
-			next_ctx->task = task;
-			do_switch = 0;
-
-			perf_event_sync_stat(ctx, next_ctx);
-		}
-		raw_spin_unlock(&next_ctx->lock);
-		raw_spin_unlock(&ctx->lock);
-	}
-	rcu_read_unlock();
-
-	if (do_switch) {
-		ctx_sched_out(ctx, cpuctx, EVENT_ALL);
-		cpuctx->task_ctx = NULL;
-	}
-}
-
 static void task_ctx_sched_out(struct perf_event_context *ctx,
 			       enum event_type_t event_type)
 {
@@ -1308,14 +1321,15 @@ static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
 
 static void
 ctx_pinned_sched_in(struct perf_event_context *ctx,
-		    struct perf_cpu_context *cpuctx)
+		    struct perf_cpu_context *cpuctx,
+		    struct task_struct *task)
 {
 	struct perf_event *event;
 
 	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
 		if (event->state <= PERF_EVENT_STATE_OFF)
 			continue;
-		if (event->cpu != -1 && event->cpu != smp_processor_id())
+		if (!event_filter_match(event, task))
 			continue;
 
 		if (group_can_go_on(event, cpuctx, 1))
@@ -1334,7 +1348,8 @@ ctx_pinned_sched_in(struct perf_event_context *ctx,
 
 static void
 ctx_flexible_sched_in(struct perf_event_context *ctx,
-		      struct perf_cpu_context *cpuctx)
+		      struct perf_cpu_context *cpuctx,
+		      struct task_struct *task)
 {
 	struct perf_event *event;
 	int can_add_hw = 1;
@@ -1347,7 +1362,7 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
 		 * Listen to the 'cpu' scheduling filter constraint
 		 * of events:
 		 */
-		if (event->cpu != -1 && event->cpu != smp_processor_id())
+		if (!event_filter_match(event, task))
 			continue;
 
 		if (group_can_go_on(event, cpuctx, can_add_hw))
@@ -1359,7 +1374,8 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
 static void
 ctx_sched_in(struct perf_event_context *ctx,
 	     struct perf_cpu_context *cpuctx,
-	     enum event_type_t event_type)
+	     enum event_type_t event_type,
+	     struct task_struct *task)
 {
 	raw_spin_lock(&ctx->lock);
 	ctx->is_active = 1;
@@ -1375,11 +1391,11 @@ ctx_sched_in(struct perf_event_context *ctx,
 	 * in order to give them the best chance of going on.
 	 */
 	if (event_type & EVENT_PINNED)
-		ctx_pinned_sched_in(ctx, cpuctx);
+		ctx_pinned_sched_in(ctx, cpuctx, task);
 
 	/* Then walk through the lower prio flexible groups */
 	if (event_type & EVENT_FLEXIBLE)
-		ctx_flexible_sched_in(ctx, cpuctx);
+		ctx_flexible_sched_in(ctx, cpuctx, task);
 
 	perf_enable();
  out:
@@ -1387,11 +1403,12 @@ ctx_sched_in(struct perf_event_context *ctx,
 }
 
 static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
-			     enum event_type_t event_type)
+			     enum event_type_t event_type,
+			     struct task_struct *task)
 {
 	struct perf_event_context *ctx = &cpuctx->ctx;
 
-	ctx_sched_in(ctx, cpuctx, event_type);
+	ctx_sched_in(ctx, cpuctx, event_type, task);
 }
 
 static void task_ctx_sched_in(struct task_struct *task,
@@ -1404,7 +1421,7 @@ static void task_ctx_sched_in(struct task_struct *task,
 		return;
 	if (cpuctx->task_ctx == ctx)
 		return;
-	ctx_sched_in(ctx, cpuctx, event_type);
+	ctx_sched_in(ctx, cpuctx, event_type, task);
 	cpuctx->task_ctx = ctx;
 }
 /*
@@ -1438,15 +1455,90 @@ void perf_event_task_sched_in(struct task_struct *task)
 	 */
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 
-	ctx_sched_in(ctx, cpuctx, EVENT_PINNED);
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
-	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE);
+	ctx_sched_in(ctx, cpuctx, EVENT_PINNED, task);
+	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, task);
+	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE, task);
 
 	cpuctx->task_ctx = ctx;
 
 	perf_enable();
 }
 
+/*
+ * Called from scheduler to remove the events of the current task,
+ * with interrupts disabled.
+ *
+ * We stop each event and update the event value in event->count.
+ *
+ * This does not protect us against NMI, but disable()
+ * sets the disabled bit in the control field of event _before_
+ * accessing the event control register. If a NMI hits, then it will
+ * not restart the event.
+ */
+void perf_event_task_sched_out(struct task_struct *task,
+				 struct task_struct *next)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_event_context *ctx = task->perf_event_ctxp;
+	struct perf_event_context *next_ctx;
+	struct perf_event_context *parent;
+	int do_switch = 1;
+
+	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
+
+	/*
+	 * if events have cgroups, then we switch out all per-cpu
+	 * events, and reschedule only the ones for the cgroup to
+	 * come
+	 */
+	if (cpuctx->ctx.nr_cgroups > 0) {
+		cpu_ctx_sched_out(cpuctx, EVENT_ALL);
+		cpu_ctx_sched_in(cpuctx, EVENT_ALL, next);
+	}
+	if (likely(!ctx || !cpuctx->task_ctx))
+		return;
+
+	rcu_read_lock();
+	parent = rcu_dereference(ctx->parent_ctx);
+	next_ctx = next->perf_event_ctxp;
+	if (parent && next_ctx &&
+	    rcu_dereference(next_ctx->parent_ctx) == parent) {
+		/*
+		 * Looks like the two contexts are clones, so we might be
+		 * able to optimize the context switch.  We lock both
+		 * contexts and check that they are clones under the
+		 * lock (including re-checking that neither has been
+		 * uncloned in the meantime).  It doesn't matter which
+		 * order we take the locks because no other cpu could
+		 * be trying to lock both of these tasks.
+		 */
+		raw_spin_lock(&ctx->lock);
+		raw_spin_lock_nested(&next_ctx->lock, SINGLE_DEPTH_NESTING);
+		if (context_equiv(ctx, next_ctx)) {
+			/*
+			 * XXX do we need a memory barrier of sorts
+			 * wrt to rcu_dereference() of perf_event_ctxp
+			 */
+			task->perf_event_ctxp = next_ctx;
+			next->perf_event_ctxp = ctx;
+			ctx->task = next;
+			next_ctx->task = task;
+			do_switch = 0;
+
+			perf_event_sync_stat(ctx, next_ctx);
+		}
+		raw_spin_unlock(&next_ctx->lock);
+		raw_spin_unlock(&ctx->lock);
+	}
+	rcu_read_unlock();
+
+	if (do_switch) {
+		ctx_sched_out(ctx, cpuctx, EVENT_ALL);
+		cpuctx->task_ctx = NULL;
+	}
+}
+
+
 #define MAX_INTERRUPTS (~0ULL)
 
 static void perf_log_throttle(struct perf_event *event, int enable);
@@ -1579,7 +1671,7 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
 
-		if (event->cpu != -1 && event->cpu != smp_processor_id())
+		if (!event_filter_match(event, current))
 			continue;
 
 		hwc = &event->hw;
@@ -1660,7 +1752,7 @@ void perf_event_task_tick(struct task_struct *curr)
 	if (ctx)
 		rotate_ctx(ctx);
 
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
+	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, curr);
 	if (ctx)
 		task_ctx_sched_in(curr, EVENT_FLEXIBLE);
 	perf_enable();
@@ -2132,6 +2224,9 @@ static void free_event(struct perf_event *event)
 		event->buffer = NULL;
 	}
 
+	if (is_cgroup_event(event))
+		perf_put_cgroup(event);
+
 	if (event->destroy)
 		event->destroy(event);
 
@@ -3764,7 +3859,7 @@ static int perf_event_task_match(struct perf_event *event)
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event, current))
 		return 0;
 
 	if (event->attr.comm || event->attr.mmap ||
@@ -3878,7 +3973,7 @@ static int perf_event_comm_match(struct perf_event *event)
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event, current))
 		return 0;
 
 	if (event->attr.comm)
@@ -3999,7 +4094,7 @@ static int perf_event_mmap_match(struct perf_event *event,
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event, current))
 		return 0;
 
 	if ((!executable && event->attr.mmap_data) ||
@@ -5031,12 +5126,32 @@ perf_event_alloc(struct perf_event_attr *attr,
 	const struct pmu *pmu;
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
+	struct perf_cgroup *css = NULL;
 	long err;
 
 	event = kzalloc(sizeof(*event), gfpflags);
 	if (!event)
 		return ERR_PTR(-ENOMEM);
 
+	if (attr->cgroup) {
+		css = perf_get_cgroup(attr->cgroup_fd);
+		if (IS_ERR(css)) {
+			kfree(event);
+			return (void *)css;
+		}
+		/*
+		 * all events in a group must monitor
+		 * the same cgroup because a thread belongs
+		 * to only one cgroup at a time
+		 */
+		if (group_leader && group_leader->css != css) {
+			event->css = css;
+			perf_put_cgroup(event);
+			kfree(event);
+			return ERR_PTR(-EINVAL);
+		}
+	}
+
 	/*
 	 * Single events are their own group leaders, with an
 	 * empty sibling list:
@@ -5067,6 +5182,7 @@ perf_event_alloc(struct perf_event_attr *attr,
 	event->id		= atomic64_inc_return(&perf_event_id);
 
 	event->state		= PERF_EVENT_STATE_INACTIVE;
+	event->css		= css;
 
 	if (!overflow_handler && parent_event)
 		overflow_handler = parent_event->overflow_handler;
@@ -5125,6 +5241,7 @@ done:
 	if (err) {
 		if (event->ns)
 			put_pid_ns(event->ns);
+		perf_put_cgroup(event);
 		kfree(event);
 		return ERR_PTR(err);
 	}
@@ -5320,6 +5437,10 @@ SYSCALL_DEFINE5(perf_event_open,
 			return -EINVAL;
 	}
 
+	/* cgroup reserved for system-wide */
+	if (attr.cgroup && pid != -1)
+		return -EINVAL;
+
 	event_fd = get_unused_fd_flags(O_RDWR);
 	if (event_fd < 0)
 		return event_fd;
@@ -6094,3 +6215,51 @@ static int __init perf_event_sysfs_init(void)
 				  &perfclass_attr_group);
 }
 device_initcall(perf_event_sysfs_init);
+
+#ifdef CONFIG_CGROUPS
+static int perf_cgroup_read_map(struct cgroup *cgrp, struct cftype *cft,
+				struct cgroup_map_cb *cb)
+{
+	return 0;
+}
+
+static struct cftype perf_cgroup_files[] = {
+	{ .name = "perf",
+	  .read_map = perf_cgroup_read_map,
+	},
+};
+
+static struct cgroup_subsys_state *perf_cgroup_create(
+	struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	struct perf_cgroup *jc;
+
+	jc = vmalloc(sizeof(*jc));
+	if (!jc)
+		return ERR_PTR(-ENOMEM);
+	memset(jc, 0, sizeof(*jc));
+	return &jc->css;
+}
+
+static void perf_cgroup_destroy(struct cgroup_subsys *ss,
+				struct cgroup *cont)
+{
+	vfree(perf_cgroup_from_cont(cont));
+}
+
+static int perf_cgroup_populate(struct cgroup_subsys *ss,
+				struct cgroup *cont)
+{
+	return cgroup_add_files(cont, ss, perf_cgroup_files,
+			ARRAY_SIZE(perf_cgroup_files));
+}
+
+struct cgroup_subsys perf_subsys = {
+	.name = "perf_event",
+	.subsys_id = perf_subsys_id,
+	.create = perf_cgroup_create,
+	.destroy = perf_cgroup_destroy,
+	.populate = perf_cgroup_populate,
+	.early_init = 0,
+};
+#endif /* CONFIG_CGROUP */

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab0IINKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 09:10:06 -0400
Received: from smtp-out.google.com ([216.239.44.51]:32734 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab0IINJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 09:09:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=uaejsZBC/sdV9loRdRiGZLHXLZf5xKVyr0+GFMwmpNP+IP34nnwlvm6600VVrrd9d
	uQ1KFzjRF8kUOk49FJqpQ==
Message-ID: <4c88dca1.44e7d80a.577e.3592@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Thu, 09 Sep 2010 06:09:53 -0700 (PDT)
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com
Subject: [RFC PATCH 1/2] perf_events: add support for per-cpu per-cgroup monitoring (v3)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This kernel patch adds the ability to filter monitoring based on
container groups (cgroups). This is for use in per-cpu mode only.
    
The patch adds perf_event_attr.cgroup, a boolean, to activate
this new mode. The cgroup is designated by passing in
perf_event_attr.cgroup_fd, an opened file descriptor to
the <mnt>/<cgroup>/perf_event.perf file.
    
This is the second version of this patch. It corrects the way
time_enabled is accounted for. In cgroup mode, time_enabled reflects
the time the cgroup was active, i.e., threads from the cgroup executed
on the monitored CPU.  This is a more useful metric than just
wall-clock. The meaning of time_enabled without cgroup is unaffected.

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
index 000610c..f84b38e 100644
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
@@ -461,6 +464,7 @@ enum perf_callchain_context {
  */
 
 #ifdef CONFIG_PERF_EVENTS
+# include <linux/cgroup.h>
 # include <asm/perf_event.h>
 # include <asm/local64.h>
 #endif
@@ -657,6 +661,18 @@ struct swevent_hlist {
 #define PERF_ATTACH_CONTEXT	0x01
 #define PERF_ATTACH_GROUP	0x02
 
+#ifdef CONFIG_CGROUPS
+struct perf_cgroup_time {
+	u64 time;
+	u64 timestamp;
+};
+
+struct perf_cgroup {
+	struct cgroup_subsys_state css;
+	struct perf_cgroup_time *time;
+};
+#endif
+
 /**
  * struct perf_event - performance event kernel representation:
  */
@@ -759,7 +775,9 @@ struct perf_event {
 	struct ftrace_event_call	*tp_event;
 	struct event_filter		*filter;
 #endif
-
+#ifdef CONFIG_CGROUPS
+	struct perf_cgroup		*css;
+#endif
 #endif /* CONFIG_PERF_EVENTS */
 };
 
@@ -806,6 +824,8 @@ struct perf_event_context {
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
index 4b84e63..2723d52 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -35,6 +35,7 @@
 
 #include <asm/irq_regs.h>
 
+#define PERF_TSTAMP_ENABLE_INVALID (~0) /* invalid marker, cannot be zero */
 /*
  * Each CPU has a list of per CPU events:
  */
@@ -49,6 +50,228 @@ static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
 static atomic_t nr_task_events __read_mostly;
 
+enum event_type_t {
+	EVENT_FLEXIBLE = 0x1,
+	EVENT_PINNED = 0x2,
+	EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED,
+};
+
+static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
+			      enum event_type_t event_type);
+
+static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
+			     enum event_type_t event_type,
+			     struct task_struct *task, int css_sw);
+static inline u64 perf_clock(void)
+{
+	return local_clock();
+}
+
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
+
+static inline int is_cgroup_event(struct perf_event *event)
+{
+	return event->css != NULL;
+}
+
+static inline int is_css_current(struct perf_event *event)
+{
+	struct perf_cgroup *css = perf_cgroup_from_task(current);
+
+	return css == event->css;
+}
+
+static inline u64 __perf_event_css_time(struct perf_event *event)
+{
+	struct perf_cgroup_time *t;
+	t = per_cpu_ptr(event->css->time, event->cpu);
+	return t->time;
+}
+
+static inline void __update_css_time(struct perf_cgroup *css)
+{
+	u64 now;
+	struct perf_cgroup_time *t;
+	int cpu = smp_processor_id();
+
+	if (!css)
+		return;
+
+	now = perf_clock();
+
+	t = per_cpu_ptr(css->time, cpu);
+
+	t->time += now - t->timestamp;
+	t->timestamp = now;
+}
+
+static inline void update_task_css_time(struct task_struct *task)
+{
+	struct perf_cgroup *css_out = perf_cgroup_from_task(task);
+	__update_css_time(css_out);
+}
+
+static inline void update_event_css_time(struct perf_event *event)
+{
+	if (!is_css_current(event))
+		return;
+	__update_css_time(event->css);
+}
+
+static inline void perf_cgroup_switch(struct task_struct *task,
+				      struct task_struct *next)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_cgroup *css_out = perf_cgroup_from_task(task);
+	struct perf_cgroup *css_in = perf_cgroup_from_task(next);
+	struct perf_cgroup_time *t;
+	int css_sw;
+
+	if (css_out != css_in) {
+		css_sw = 1;
+		update_task_css_time(task);
+		t = per_cpu_ptr(css_in->time, smp_processor_id());
+		t->timestamp = perf_clock();
+	}
+
+	/*
+	 * if cpu context has at least one event with cgroup constraint,
+	 * then flushout all existing events and scheduled again taking
+	 * into account the incoming cgroup. This is a cgroup switch
+	 */
+	if (cpuctx->ctx.nr_cgroups > 0 && css_sw) {
+		cpu_ctx_sched_out(cpuctx, EVENT_ALL);
+		cpu_ctx_sched_in(cpuctx, EVENT_ALL, next, 1);
+	}
+}
+
+static inline int perf_connect_cgroup(struct perf_event *event,
+				      struct perf_event_attr *attr,
+				      struct perf_event *group_leader)
+{
+	struct perf_cgroup *css;
+
+	css = perf_get_cgroup(attr->cgroup_fd);
+	if (IS_ERR(css))
+		return PTR_ERR(css);
+	/*
+	 * all events in a group must monitor
+	 * the same cgroup because a thread belongs
+	 * to only one cgroup at a time
+	 */
+	if (group_leader && group_leader->css != css) {
+		event->css = css;
+		perf_put_cgroup(event);
+		return -EINVAL;
+	}
+
+	event->css = css;
+
+	return 0;
+}
+
+#else /* !CONFIG_CGROUP */
+
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
+static inline int is_cgroup_event(struct perf_event *event)
+{
+	return 0;
+}
+
+static inline int is_css_current(struct perf_event *event)
+{
+	return 0;
+}
+
+static inline u64 __perf_event_css_time(struct perf_event *event)
+{
+	return 0;
+}
+
+static inline void update_css_time(void *css)
+{}
+
+static inline void update_event_css_time(struct perf_event *event)
+{}
+
+static inline void update_task_css_time(struct task_struct *t)
+{}
+static inline void perf_cgroup_switch(struct task_struct *task,
+				      struct task_struct *next)
+{}
+
+static inline int perf_connect_cgroup(struct perf_event *event,
+				      struct perf_event_attr *attr,
+				      struct perf_event *gorup_leader)
+{
+	return -EINVAL;
+}
+
+#endif
+
+
+
 /*
  * perf event paranoia level:
  *  -1 - not paranoid at all
@@ -212,11 +435,6 @@ static void perf_unpin_context(struct perf_event_context *ctx)
 	put_ctx(ctx);
 }
 
-static inline u64 perf_clock(void)
-{
-	return local_clock();
-}
-
 /*
  * Update the record of the current time in a context.
  */
@@ -228,29 +446,46 @@ static void update_context_time(struct perf_event_context *ctx)
 	ctx->timestamp = now;
 }
 
+static u64 perf_event_time(struct perf_event *event)
+{
+	struct perf_event_context *ctx = event->ctx;
+
+	if (is_cgroup_event(event)) {
+		if (event->cpu == -1) {
+			WARN_ON(event->cpu != smp_processor_id());
+			return 0;
+		}
+		return __perf_event_css_time(event);
+	}
+
+	return ctx ? ctx->time : 0;
+}
+
 /*
  * Update the total_time_enabled and total_time_running fields for a event.
  */
 static void update_event_times(struct perf_event *event)
 {
-	struct perf_event_context *ctx = event->ctx;
-	u64 run_end;
+	u64 run_end, run_start;
 
 	if (event->state < PERF_EVENT_STATE_INACTIVE ||
 	    event->group_leader->state < PERF_EVENT_STATE_INACTIVE)
 		return;
 
-	if (ctx->is_active)
-		run_end = ctx->time;
-	else
-		run_end = event->tstamp_stopped;
+	run_end = perf_event_time(event);
+	run_start = event->tstamp_enabled;
 
-	event->total_time_enabled = run_end - event->tstamp_enabled;
+	/*
+	 * that means the cgroup never got scheduled in
+	 * so ensure total_time_enabled is zero
+	 */
+	if (run_start == PERF_TSTAMP_ENABLE_INVALID)
+		run_start = run_end;
+
+	event->total_time_enabled = run_end - run_start;
 
 	if (event->state == PERF_EVENT_STATE_INACTIVE)
 		run_end = event->tstamp_stopped;
-	else
-		run_end = ctx->time;
 
 	event->total_time_running = run_end - event->tstamp_running;
 }
@@ -301,6 +536,9 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 		list_add_tail(&event->group_entry, list);
 	}
 
+	if (is_cgroup_event(event))
+		ctx->nr_cgroups++;
+
 	list_add_rcu(&event->event_entry, &ctx->event_list);
 	ctx->nr_events++;
 	if (event->attr.inherit_stat)
@@ -340,6 +578,9 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 
 	event->attach_state &= ~PERF_ATTACH_CONTEXT;
 
+	if (is_cgroup_event(event))
+		ctx->nr_cgroups--;
+
 	ctx->nr_events--;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat--;
@@ -403,9 +644,10 @@ static void perf_group_detach(struct perf_event *event)
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
@@ -413,6 +655,7 @@ event_sched_out(struct perf_event *event,
 		  struct perf_cpu_context *cpuctx,
 		  struct perf_event_context *ctx)
 {
+	u64 tstamp = perf_event_time(event);
 	u64 delta;
 	/*
 	 * An event which could not be activated because of
@@ -421,10 +664,10 @@ event_sched_out(struct perf_event *event,
 	 * via read() for time_enabled, time_running:
 	 */
 	if (event->state == PERF_EVENT_STATE_INACTIVE
-	    && !event_filter_match(event)) {
-		delta = ctx->time - event->tstamp_stopped;
+	    && !event_filter_match(event, current)) {
+		delta = tstamp - event->tstamp_stopped;
 		event->tstamp_running += delta;
-		event->tstamp_stopped = ctx->time;
+		event->tstamp_stopped = tstamp;
 	}
 
 	if (event->state != PERF_EVENT_STATE_ACTIVE)
@@ -435,7 +678,7 @@ event_sched_out(struct perf_event *event,
 		event->pending_disable = 0;
 		event->state = PERF_EVENT_STATE_OFF;
 	}
-	event->tstamp_stopped = ctx->time;
+	event->tstamp_stopped = tstamp;
 	event->pmu->disable(event);
 	event->oncpu = -1;
 
@@ -589,6 +832,11 @@ static void __perf_event_disable(void *info)
 	 * If it is in error state, leave it in error state.
 	 */
 	if (event->state >= PERF_EVENT_STATE_INACTIVE) {
+		/*
+		 * update css time only if current->css corresponds
+		 * to event. This is used to update tstamp->stopped
+		 */
+		update_event_css_time(event);
 		update_context_time(ctx);
 		update_group_times(event);
 		if (event == event->group_leader)
@@ -673,7 +921,8 @@ event_sched_in(struct perf_event *event,
 		return -EAGAIN;
 	}
 
-	event->tstamp_running += ctx->time - event->tstamp_stopped;
+	event->tstamp_running +=
+			perf_event_time(event) - event->tstamp_stopped;
 
 	if (!is_software_event(event))
 		cpuctx->active_oncpu++;
@@ -775,11 +1024,33 @@ static int group_can_go_on(struct perf_event *event,
 static void add_event_to_ctx(struct perf_event *event,
 			       struct perf_event_context *ctx)
 {
+	u64 tstamp = perf_event_time(event);
+
 	list_add_event(event, ctx);
 	perf_group_attach(event);
-	event->tstamp_enabled = ctx->time;
-	event->tstamp_running = ctx->time;
-	event->tstamp_stopped = ctx->time;
+
+	event->tstamp_running = tstamp;
+	event->tstamp_stopped = tstamp;
+	event->tstamp_enabled = tstamp;
+
+	/*
+	 * an event is added to a context even if the css constraint
+	 * is not satisfied.  In per-cgroup mode, time_enabled only
+	 * counts when threads from the css are active on the CPU.
+	 *
+	 * tstamp_enabled denotes the first time the event CAN be
+	 * enabled, i.e., the first time threads from the css are
+	 * scheduled in. Note that the event may not be scheduled
+	 * immediately if the PMU is overcommitted yet the timestamp
+	 * points to the first css activation.
+	 *
+	 * If css is not currently active, then we mark
+	 * tstamp_enabled = ~0 to remember that it needs to be
+	 * corrected in ctx_flexible_sched_in() and
+	 * ctx_pinned_sched_in()
+	 */
+	if (is_cgroup_event(event) && !is_css_current(event))
+		event->tstamp_enabled = PERF_TSTAMP_ENABLE_INVALID;
 }
 
 /*
@@ -818,9 +1089,16 @@ static void __perf_install_in_context(void *info)
 	 */
 	perf_disable();
 
+	/*
+	 * in cgroup mode, we know the event matches
+	 * the current cgroup, so update the cgroup's
+	 * time so we timestamp correctly.
+	 */
+	update_event_css_time(event);
+
 	add_event_to_ctx(event, ctx);
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event, current))
 		goto unlock;
 
 	/*
@@ -928,13 +1206,14 @@ static void __perf_event_mark_enabled(struct perf_event *event,
 					struct perf_event_context *ctx)
 {
 	struct perf_event *sub;
+	u64 tstamp = perf_event_time(event);
 
 	event->state = PERF_EVENT_STATE_INACTIVE;
-	event->tstamp_enabled = ctx->time - event->total_time_enabled;
+	event->tstamp_enabled = tstamp - event->total_time_enabled;
+
 	list_for_each_entry(sub, &event->sibling_list, group_entry)
 		if (sub->state >= PERF_EVENT_STATE_INACTIVE)
-			sub->tstamp_enabled =
-				ctx->time - sub->total_time_enabled;
+			sub->tstamp_enabled = tstamp - sub->total_time_enabled;
 }
 
 /*
@@ -964,9 +1243,17 @@ static void __perf_event_enable(void *info)
 
 	if (event->state >= PERF_EVENT_STATE_INACTIVE)
 		goto unlock;
+
+	/*
+	 * in cgroup mode, we know the event matches
+	 * the current cgroup, so update the cgroup's
+	 * time so we timestamp correctly.
+	 */
+	update_event_css_time(event);
+
 	__perf_event_mark_enabled(event, ctx);
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event, current))
 		goto unlock;
 
 	/*
@@ -1079,12 +1366,6 @@ static int perf_event_refresh(struct perf_event *event, int refresh)
 	return 0;
 }
 
-enum event_type_t {
-	EVENT_FLEXIBLE = 0x1,
-	EVENT_PINNED = 0x2,
-	EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED,
-};
-
 static void ctx_sched_out(struct perf_event_context *ctx,
 			  struct perf_cpu_context *cpuctx,
 			  enum event_type_t event_type)
@@ -1096,6 +1377,7 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 	if (likely(!ctx->nr_events))
 		goto out;
 	update_context_time(ctx);
+	update_task_css_time(current);
 
 	perf_disable();
 	if (!ctx->nr_active)
@@ -1209,71 +1491,6 @@ static void perf_event_sync_stat(struct perf_event_context *ctx,
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
@@ -1308,16 +1525,40 @@ static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
 
 static void
 ctx_pinned_sched_in(struct perf_event_context *ctx,
-		    struct perf_cpu_context *cpuctx)
+		    struct perf_cpu_context *cpuctx,
+		    struct task_struct *task, int css_sw)
 {
 	struct perf_event *event;
 
 	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
+		u64 tstamp = perf_event_time(event);
+
 		if (event->state <= PERF_EVENT_STATE_OFF)
 			continue;
-		if (event->cpu != -1 && event->cpu != smp_processor_id())
+		if (!event_filter_match(event, task))
 			continue;
 
+		if (is_cgroup_event(event)) {
+			/*
+			 * if css was not active when the event was
+			 * added to ctx, then this is the first time
+			 * the event can be effectively scheduled, thus
+			 * we update tstamp_enabled
+			 */
+			if (event->tstamp_enabled == PERF_TSTAMP_ENABLE_INVALID)
+				event->tstamp_enabled = tstamp;
+			/*
+			 * if we come here because of a context switch
+			 * with cgroup switch, then we need to update
+			 * the point in time at which all cgroup events
+			 * have been stopped. Oterwise, we would compute
+			 * bogus tstamp_running deltas, which would include
+			 * time the cgorup is not active.
+			 */
+			if (css_sw)
+				event->tstamp_stopped = tstamp;
+		}
+
 		if (group_can_go_on(event, cpuctx, 1))
 			group_sched_in(event, cpuctx, ctx);
 
@@ -1334,7 +1575,8 @@ ctx_pinned_sched_in(struct perf_event_context *ctx,
 
 static void
 ctx_flexible_sched_in(struct perf_event_context *ctx,
-		      struct perf_cpu_context *cpuctx)
+		      struct perf_cpu_context *cpuctx,
+		      struct task_struct *task, int css_sw)
 {
 	struct perf_event *event;
 	int can_add_hw = 1;
@@ -1347,9 +1589,31 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
 		 * Listen to the 'cpu' scheduling filter constraint
 		 * of events:
 		 */
-		if (event->cpu != -1 && event->cpu != smp_processor_id())
+		if (!event_filter_match(event, task))
 			continue;
 
+		if (is_cgroup_event(event)) {
+			u64 tstamp = perf_event_time(event);
+			/*
+			 * if css was not active when the event was
+			 * added to ctx, then this is the first time
+			 * the event can be effectively scheduled, thus
+			 * we update tstamp_enabled
+			 */
+			if (event->tstamp_enabled == PERF_TSTAMP_ENABLE_INVALID)
+				event->tstamp_enabled = tstamp;
+			/*
+			 * if we come here because of a context switch
+			 * with cgroup switch, then we need to update
+			 * the point in time at which all cgroup events
+			 * have been stopped. Oterwise, we would compute
+			 * bogus tstamp_running deltas, which would include
+			 * time the cgorup is not active.
+			 */
+			if (css_sw)
+				event->tstamp_stopped = tstamp;
+		}
+
 		if (group_can_go_on(event, cpuctx, can_add_hw))
 			if (group_sched_in(event, cpuctx, ctx))
 				can_add_hw = 0;
@@ -1359,7 +1623,8 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
 static void
 ctx_sched_in(struct perf_event_context *ctx,
 	     struct perf_cpu_context *cpuctx,
-	     enum event_type_t event_type)
+	     enum event_type_t event_type,
+	     struct task_struct *task, int css_sw)
 {
 	raw_spin_lock(&ctx->lock);
 	ctx->is_active = 1;
@@ -1375,11 +1640,11 @@ ctx_sched_in(struct perf_event_context *ctx,
 	 * in order to give them the best chance of going on.
 	 */
 	if (event_type & EVENT_PINNED)
-		ctx_pinned_sched_in(ctx, cpuctx);
+		ctx_pinned_sched_in(ctx, cpuctx, task, css_sw);
 
 	/* Then walk through the lower prio flexible groups */
 	if (event_type & EVENT_FLEXIBLE)
-		ctx_flexible_sched_in(ctx, cpuctx);
+		ctx_flexible_sched_in(ctx, cpuctx, task, css_sw);
 
 	perf_enable();
  out:
@@ -1387,11 +1652,12 @@ ctx_sched_in(struct perf_event_context *ctx,
 }
 
 static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
-			     enum event_type_t event_type)
+			     enum event_type_t event_type,
+			     struct task_struct *task, int css_sw)
 {
 	struct perf_event_context *ctx = &cpuctx->ctx;
 
-	ctx_sched_in(ctx, cpuctx, event_type);
+	ctx_sched_in(ctx, cpuctx, event_type, task, css_sw);
 }
 
 static void task_ctx_sched_in(struct task_struct *task,
@@ -1404,7 +1670,7 @@ static void task_ctx_sched_in(struct task_struct *task,
 		return;
 	if (cpuctx->task_ctx == ctx)
 		return;
-	ctx_sched_in(ctx, cpuctx, event_type);
+	ctx_sched_in(ctx, cpuctx, event_type, task, 0);
 	cpuctx->task_ctx = ctx;
 }
 /*
@@ -1438,15 +1704,88 @@ void perf_event_task_sched_in(struct task_struct *task)
 	 */
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 
-	ctx_sched_in(ctx, cpuctx, EVENT_PINNED);
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
-	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE);
+	ctx_sched_in(ctx, cpuctx, EVENT_PINNED, task, 0);
+	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, task, 0);
+	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE, task, 0);
 
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
+	 * switching cgroups
+	 * must update time in going out cgroup
+	 * mark new start time in coming in cgroup
+	 */
+	perf_cgroup_switch(task, next);
+
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
@@ -1579,7 +1918,7 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
 
-		if (event->cpu != -1 && event->cpu != smp_processor_id())
+		if (!event_filter_match(event, current))
 			continue;
 
 		hwc = &event->hw;
@@ -1660,7 +1999,7 @@ void perf_event_task_tick(struct task_struct *curr)
 	if (ctx)
 		rotate_ctx(ctx);
 
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
+	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, curr, 0);
 	if (ctx)
 		task_ctx_sched_in(curr, EVENT_FLEXIBLE);
 	perf_enable();
@@ -1747,6 +2086,7 @@ static void __perf_event_read(void *info)
 		return;
 
 	raw_spin_lock(&ctx->lock);
+	update_event_css_time(event);
 	update_context_time(ctx);
 	update_event_times(event);
 	raw_spin_unlock(&ctx->lock);
@@ -1773,6 +2113,7 @@ static u64 perf_event_read(struct perf_event *event)
 		unsigned long flags;
 
 		raw_spin_lock_irqsave(&ctx->lock, flags);
+		update_event_css_time(event);
 		update_context_time(ctx);
 		update_event_times(event);
 		raw_spin_unlock_irqrestore(&ctx->lock, flags);
@@ -2132,6 +2473,9 @@ static void free_event(struct perf_event *event)
 		event->buffer = NULL;
 	}
 
+	if (is_cgroup_event(event))
+		perf_put_cgroup(event);
+
 	if (event->destroy)
 		event->destroy(event);
 
@@ -3764,7 +4108,7 @@ static int perf_event_task_match(struct perf_event *event)
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event, current))
 		return 0;
 
 	if (event->attr.comm || event->attr.mmap ||
@@ -3878,7 +4222,7 @@ static int perf_event_comm_match(struct perf_event *event)
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event, current))
 		return 0;
 
 	if (event->attr.comm)
@@ -3999,7 +4343,7 @@ static int perf_event_mmap_match(struct perf_event *event,
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event, current))
 		return 0;
 
 	if ((!executable && event->attr.mmap_data) ||
@@ -4660,6 +5004,7 @@ static void task_clock_perf_event_read(struct perf_event *event)
 	u64 time;
 
 	if (!in_nmi()) {
+		update_event_css_time(event);
 		update_context_time(event->ctx);
 		time = event->ctx->time;
 	} else {
@@ -5037,6 +5382,14 @@ perf_event_alloc(struct perf_event_attr *attr,
 	if (!event)
 		return ERR_PTR(-ENOMEM);
 
+	if (attr->cgroup) {
+		err = perf_connect_cgroup(event, attr, group_leader);
+		if (err) {
+			kfree(event);
+			return ERR_PTR(err);
+		}
+	}
+
 	/*
 	 * Single events are their own group leaders, with an
 	 * empty sibling list:
@@ -5125,6 +5478,7 @@ done:
 	if (err) {
 		if (event->ns)
 			put_pid_ns(event->ns);
+		perf_put_cgroup(event);
 		kfree(event);
 		return ERR_PTR(err);
 	}
@@ -5320,6 +5674,10 @@ SYSCALL_DEFINE5(perf_event_open,
 			return -EINVAL;
 	}
 
+	/* cgroup reserved for system-wide */
+	if (attr.cgroup && pid != -1)
+		return -EINVAL;
+
 	event_fd = get_unused_fd_flags(O_RDWR);
 	if (event_fd < 0)
 		return event_fd;
@@ -6094,3 +6452,69 @@ static int __init perf_event_sysfs_init(void)
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
+	struct perf_cgroup_time *t;
+	int c;
+
+	jc = vmalloc(sizeof(*jc));
+	if (!jc)
+		return ERR_PTR(-ENOMEM);
+
+	memset(jc, 0, sizeof(*jc));
+
+	jc->time = alloc_percpu(struct perf_cgroup_time);
+	if (!jc->time) {
+		vfree(jc);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	for_each_possible_cpu(c) {
+		t = per_cpu_ptr(jc->time, c);
+		t->time = 0;
+		t->timestamp = 0;
+	}
+	return &jc->css;
+}
+
+static void perf_cgroup_destroy(struct cgroup_subsys *ss,
+				struct cgroup *cont)
+{
+	struct perf_cgroup *jc = perf_cgroup_from_cont(cont);
+
+	free_percpu(jc->time);
+	vfree(jc);
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

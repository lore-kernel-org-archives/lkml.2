Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab0KRLlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 06:41:18 -0500
Received: from smtp-out.google.com ([74.125.121.35]:39264 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab0KRLlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 06:41:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=dPGnNAWEUx0dLoaMENAN8vXmN2YU5WwcgvMu90+t3Ak/q3sIQbDe7hHjBaFUc2SnVX
         28IoiiiGkOLsjUkG7bLA==
Message-ID: <4ce510d4.0fedd80a.742c.10b9@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Thu, 18 Nov 2010 12:40:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
Subject: [PATCH 1/2] perf_events: add support for per-cpu per-cgroup monitoring (v5)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This kernel patch adds the ability to filter monitoring based on
container groups (cgroups). This is for use in per-cpu mode only.
    
The cgroup to monitor is passed as a file descriptor in the pid
argument to the syscall. The file descriptor must be opened to 
the cgroup name in the cgroup filesystem. For instance, if the
cgroup name is foo and cgroupfs is mounted in /cgroup, then the
file descriptor is opened to /cgroup/foo. Cgroup mode is
activated by passing PERF_FLAG_PID_CGROUP in the flags argument
to the syscall.

For instance to measure in cgroup foo on CPU1 assuming
cgroupfs is mounted under /cgroup:

struct perf_event_attr attr;
int cgroup_fd, fd;

cgroup_fd = open("/cgroup/foo", O_RDONLY);
fd = perf_event_open(&attr, cgroup_fd, 1, -1, PERF_FLAG_PID_CGROUP);
close(cgroup_fd);

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index ed4ba11..62fe681 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -627,6 +627,8 @@ bool css_is_ancestor(struct cgroup_subsys_state *cg,
 unsigned short css_id(struct cgroup_subsys_state *css);
 unsigned short css_depth(struct cgroup_subsys_state *css);
 
+struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id);
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
index 40150f3..a008ae2 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -454,6 +454,7 @@ enum perf_callchain_context {
 
 #define PERF_FLAG_FD_NO_GROUP	(1U << 0)
 #define PERF_FLAG_FD_OUTPUT	(1U << 1)
+#define PERF_FLAG_PID_CGROUP	(1U << 2) /* pid=cgroup id, per-cpu mode */
 
 #ifdef __KERNEL__
 /*
@@ -461,6 +462,7 @@ enum perf_callchain_context {
  */
 
 #ifdef CONFIG_PERF_EVENTS
+# include <linux/cgroup.h>
 # include <asm/perf_event.h>
 # include <asm/local64.h>
 #endif
@@ -702,6 +704,18 @@ struct swevent_hlist {
 #define PERF_ATTACH_GROUP	0x02
 #define PERF_ATTACH_TASK	0x04
 
+#ifdef CONFIG_CGROUPS
+struct perf_cgroup_info {
+	u64 time;
+	u64 timestamp;
+};
+
+struct perf_cgroup {
+	struct cgroup_subsys_state css;
+	struct perf_cgroup_info *info;
+};
+#endif
+
 /**
  * struct perf_event - performance event kernel representation:
  */
@@ -815,6 +829,10 @@ struct perf_event {
 	struct event_filter		*filter;
 #endif
 
+#ifdef CONFIG_CGROUPS
+	struct perf_cgroup		*css;
+#endif
+
 #endif /* CONFIG_PERF_EVENTS */
 };
 
@@ -868,6 +886,8 @@ struct perf_event_context {
 	u64				generation;
 	int				pin_count;
 	struct rcu_head			rcu_head;
+
+	int				nr_cgroups; /* cgroup events present */
 };
 
 /*
@@ -911,6 +931,12 @@ extern void __perf_event_task_sched_out(struct task_struct *task, struct task_st
 
 extern atomic_t perf_task_events;
 
+#ifdef CONFIG_CGROUPS
+extern void perf_cgroup_switch(struct task_struct *task,
+			       struct task_struct *next);
+DECLARE_PER_CPU(atomic_t, perf_cgroup_events);
+#endif
+
 static inline void perf_event_task_sched_in(struct task_struct *task)
 {
 	COND_STMT(&perf_task_events, __perf_event_task_sched_in(task));
@@ -919,6 +945,10 @@ static inline void perf_event_task_sched_in(struct task_struct *task)
 static inline
 void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next)
 {
+#ifdef CONFIG_CGROUPS
+	atomic_t *cgroup_events = &__get_cpu_var(perf_cgroup_events);
+	COND_STMT(cgroup_events, perf_cgroup_switch(task, next));
+#endif
 	COND_STMT(&perf_task_events, __perf_event_task_sched_out(task, next));
 }
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 66a416b..1c8bee8 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4790,6 +4790,29 @@ css_get_next(struct cgroup_subsys *ss, int id,
 	return ret;
 }
 
+/*
+ * get corresponding css from file open on cgroupfs directory
+ */
+struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id)
+{
+	struct cgroup *cgrp;
+	struct inode *inode;
+	struct cgroup_subsys_state *css;
+
+	inode = f->f_dentry->d_inode;
+	/* check in cgroup filesystem dir */
+	if (inode->i_op != &cgroup_dir_inode_operations)
+		return ERR_PTR(-EBADF);
+
+	if (id < 0 || id >= CGROUP_SUBSYS_COUNT)
+		return ERR_PTR(-EINVAL);
+
+	/* get cgroup */
+	cgrp = __d_cgrp(f->f_dentry);
+	css = cgrp->subsys[id];
+	return css ? css : ERR_PTR(-ENOENT);
+}
+
 #ifdef CONFIG_CGROUP_DEBUG
 static struct cgroup_subsys_state *debug_create(struct cgroup_subsys *ss,
 						   struct cgroup *cont)
diff --git a/kernel/exit.c b/kernel/exit.c
index 21aa7b3..0c15963 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -985,6 +985,12 @@ NORET_TYPE void do_exit(long code)
 	exit_fs(tsk);
 	check_stack_usage();
 	exit_thread();
+	/*
+	 * Flush inherited counters to the parent - before the parent
+	 * gets woken up by child-exit notifications.
+	 * because of cgroup mode, must be called before cgroup_exit()
+	 */
+	perf_event_exit_task(tsk);
 	cgroup_exit(tsk, 1);
 
 	if (group_dead)
@@ -998,11 +1004,6 @@ NORET_TYPE void do_exit(long code)
 	 * FIXME: do that only when needed, using sched_exit tracepoint
 	 */
 	flush_ptrace_hw_breakpoint(tsk);
-	/*
-	 * Flush inherited counters to the parent - before the parent
-	 * gets woken up by child-exit notifications.
-	 */
-	perf_event_exit_task(tsk);
 
 	exit_notify(tsk, group_dead);
 #ifdef CONFIG_NUMA
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 84076bf..90b218c 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -43,6 +43,8 @@ static LIST_HEAD(pmus);
 static DEFINE_MUTEX(pmus_lock);
 static struct srcu_struct pmus_srcu;
 
+DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
+
 /*
  * perf event paranoia level:
  *  -1 - not paranoid at all
@@ -68,6 +70,334 @@ extern __weak const char *perf_pmu_name(void)
 	return "pmu";
 }
 
+enum event_type_t {
+	EVENT_FLEXIBLE = 0x1,
+	EVENT_PINNED = 0x2,
+	EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED,
+};
+
+#define PERF_FLAG_ALL (PERF_FLAG_FD_NO_GROUP |\
+		       PERF_FLAG_FD_OUTPUT  |\
+		       PERF_FLAG_PID_CGROUP)
+
+static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
+			      enum event_type_t event_type);
+
+static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
+			     enum event_type_t event_type,
+			     struct task_struct *task, int css_sw);
+
+static u64 perf_event_time(struct perf_event *event);
+
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
+static inline bool
+perf_cgroup_match(struct perf_event *event, struct task_struct *task)
+{
+	struct perf_cgroup *css = NULL;
+	if (task)
+		css = perf_cgroup_from_task(task);
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
+	css = cgroup_css_from_dir(file, perf_subsys_id);
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
+static inline u64 perf_cgroup_event_css_time(struct perf_event *event)
+{
+	struct perf_cgroup_info *t;
+
+	if (WARN_ON_ONCE(event->cpu == -1))
+		return 0;
+
+	t = per_cpu_ptr(event->css->info, event->cpu);
+	return t->time;
+}
+
+static inline void __update_css_time(struct perf_cgroup *css)
+{
+	u64 now;
+	struct perf_cgroup_info *t;
+	int cpu = smp_processor_id();
+
+	if (!css)
+		return;
+
+	now = perf_clock();
+
+	t = per_cpu_ptr(css->info, cpu);
+
+	t->time += now - t->timestamp;
+	t->timestamp = now;
+}
+
+static inline void update_css_time_from_task(struct task_struct *task)
+{
+	struct perf_cgroup *css_out = perf_cgroup_from_task(task);
+	__update_css_time(css_out);
+}
+
+static inline void update_css_time_from_event(struct perf_event *event)
+{
+	struct perf_cgroup *css = perf_cgroup_from_task(current);
+	/*
+	 * do not update time when css is not active
+	 */
+	if (!event->css || css != event->css)
+		return;
+
+	__update_css_time(event->css);
+}
+
+static inline void
+perf_cgroup_set_timestamp(struct task_struct *task, u64 now)
+{
+	struct perf_cgroup *css;
+	struct perf_cgroup_info *info;
+
+	if (!task)
+		return;
+
+	css = perf_cgroup_from_task(task);
+	info = per_cpu_ptr(css->info, smp_processor_id());
+	info->timestamp = now;
+}
+
+static inline void
+perf_cgroup_sched_in(struct perf_event *event, int css_sw)
+{
+	/*
+	 * if we come here because of a context switch
+	 * with cgroup switch, then we need to update
+	 * the point in time at which all cgroup events
+	 * have been stopped. Otherwise, we would compute
+	 * bogus tstamp_running deltas, which would include
+	 * time the cgroup was not active.
+	 */
+	if (css_sw)
+		event->tstamp_stopped = perf_event_time(event);
+}
+
+/*
+ * called from perf_event_ask_sched_out() conditional to jump label
+ */
+void
+perf_cgroup_switch(struct task_struct *task, struct task_struct *next)
+{
+	struct perf_cgroup *css_out = perf_cgroup_from_task(task);
+	struct perf_cgroup *css_in = perf_cgroup_from_task(next);
+	struct perf_cpu_context *cpuctx;
+	struct pmu *pmu;
+	/*
+	 * if task is DEAD, then css_out is irrelevant, it has
+	 * been changed to init_css in cgroup_exit() from do_exit().
+	 * Furthermore, perf_cgroup_exit_task(), has scheduled out
+	 * all css constrained events, only unconstrained events
+	 * remain. Therefore we need to reschedule based on css_in.
+	 */
+	if (task->state != TASK_DEAD && css_out == css_in)
+		return;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+
+		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
+
+		perf_pmu_disable(cpuctx->ctx.pmu);
+
+		/*
+		 * jump label perf_cgroup_events says at least one
+		 * context on this CPU has cgroup events.
+		 *
+		 * ctx->nr_cgroups reports the number of cgroup
+		 * events for a context. Given there can be multiple
+		 * PMUs, there can be multiple contexts.
+		 */
+		if (cpuctx->ctx.nr_cgroups > 0) {
+			/*
+			 * schedule out everything we have
+			 * task == DEAD: only unconstrained events
+			 * task != DEAD: css constrained + unconstrained events
+			 *
+			 * We kick out all events (even if unconstrained)
+			 * to allow the constrained events to be scheduled
+			 * based on their position in the event list (fairness)
+			 */
+			cpu_ctx_sched_out(cpuctx, EVENT_ALL);
+			/*
+			 * reschedule css_in constrained + unconstrained events
+			 */
+			cpu_ctx_sched_in(cpuctx, EVENT_ALL, next, 1);
+		}
+
+		perf_pmu_enable(cpuctx->ctx.pmu);
+	}
+
+	rcu_read_unlock();
+}
+
+static inline void
+perf_cgroup_exit_task(struct task_struct *task)
+{
+	struct perf_cpu_context *cpuctx;
+	struct pmu *pmu;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+
+		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
+
+		perf_pmu_disable(cpuctx->ctx.pmu);
+
+		if (cpuctx->ctx.nr_cgroups > 0) {
+			/*
+			 * task is going to be detached from css.
+			 * We cannot keep a reference on the css
+			 * as it may disappear before we get to
+			 * perf_cgroup_switch(). Thus, we remove
+			 * all css constrained events.
+			 *
+			 * We do this by scheduling out everything
+			 * we have, and then only rescheduling only
+			 * the unconstrained events. Those can keep
+			 * on counting.
+			 *
+			 * We re-examine the situation in the final
+			 * perf_cgroup_switch() call for this task
+			 * once we know the next task.
+			 */
+			cpu_ctx_sched_out(cpuctx, EVENT_ALL);
+			/*
+			 * task = NULL causes perf_cgroup_match()
+			 * to match only unconstrained events
+			 */
+			cpu_ctx_sched_in(cpuctx, EVENT_ALL, NULL, 1);
+		}
+
+		perf_pmu_enable(cpuctx->ctx.pmu);
+	}
+	rcu_read_unlock();
+
+	local_irq_restore(flags);
+}
+
+static inline int perf_connect_cgroup(pid_t pid, struct perf_event *event,
+				      struct perf_event_attr *attr,
+				      struct perf_event *group_leader)
+{
+	struct perf_cgroup *css;
+
+	/* pid contains cgroup fd */
+	css = perf_get_cgroup(pid);
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
+	event->css = css;
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
+static inline void perf_put_cgroup(struct perf_event *event)
+{}
+
+static inline int is_cgroup_event(struct perf_event *event)
+{
+	return 0;
+}
+
+static inline u64 perf_cgroup_event_css_time(struct perf_event *event)
+{
+	return 0;
+}
+
+static inline void update_css_time_from_event(struct perf_event *event)
+{}
+
+static inline void update_css_time_from_task(struct task_struct *t)
+{}
+
+static inline int perf_connect_cgroup(pid_t pid, struct perf_event *event,
+				      struct perf_event_attr *attr,
+				      struct perf_event *group_leader)
+{
+	return -EINVAL;
+}
+
+static inline void
+perf_cgroup_sched_in(struct perf_event *event, int css_sw)
+{}
+
+static inline void
+perf_cgroup_set_timestamp(struct task_struct *task, u64 now)
+{}
+
+static inline void
+perf_cgroup_exit_task(struct task_struct *task)
+{}
+
+#endif
 void perf_pmu_disable(struct pmu *pmu)
 {
 	int *count = this_cpu_ptr(pmu->pmu_disable_count);
@@ -214,11 +544,6 @@ static void perf_unpin_context(struct perf_event_context *ctx)
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
@@ -230,6 +555,16 @@ static void update_context_time(struct perf_event_context *ctx)
 	ctx->timestamp = now;
 }
 
+static u64 perf_event_time(struct perf_event *event)
+{
+	struct perf_event_context *ctx = event->ctx;
+
+	if (is_cgroup_event(event))
+		return perf_cgroup_event_css_time(event);
+
+	return ctx ? ctx->time : 0;
+}
+
 /*
  * Update the total_time_enabled and total_time_running fields for a event.
  */
@@ -242,7 +577,9 @@ static void update_event_times(struct perf_event *event)
 	    event->group_leader->state < PERF_EVENT_STATE_INACTIVE)
 		return;
 
-	if (ctx->is_active)
+	if (is_cgroup_event(event))
+		run_end = perf_cgroup_event_css_time(event);
+	else if (ctx->is_active)
 		run_end = ctx->time;
 	else
 		run_end = event->tstamp_stopped;
@@ -252,7 +589,7 @@ static void update_event_times(struct perf_event *event)
 	if (event->state == PERF_EVENT_STATE_INACTIVE)
 		run_end = event->tstamp_stopped;
 	else
-		run_end = ctx->time;
+		run_end = perf_event_time(event);
 
 	event->total_time_running = run_end - event->tstamp_running;
 }
@@ -303,6 +640,11 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 		list_add_tail(&event->group_entry, list);
 	}
 
+	if (is_cgroup_event(event)) {
+		ctx->nr_cgroups++;
+		jump_label_inc(&per_cpu(perf_cgroup_events, event->cpu));
+	}
+
 	list_add_rcu(&event->event_entry, &ctx->event_list);
 	if (!ctx->nr_events)
 		perf_pmu_rotate_start(ctx->pmu);
@@ -349,6 +691,11 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 
 	event->attach_state &= ~PERF_ATTACH_CONTEXT;
 
+	if (is_cgroup_event(event)) {
+		ctx->nr_cgroups--;
+		jump_label_dec(&per_cpu(perf_cgroup_events, event->cpu));
+	}
+
 	ctx->nr_events--;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat--;
@@ -412,9 +759,10 @@ static void perf_group_detach(struct perf_event *event)
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
@@ -422,6 +770,7 @@ event_sched_out(struct perf_event *event,
 		  struct perf_cpu_context *cpuctx,
 		  struct perf_event_context *ctx)
 {
+	u64 tstamp = perf_event_time(event);
 	u64 delta;
 	/*
 	 * An event which could not be activated because of
@@ -430,10 +779,10 @@ event_sched_out(struct perf_event *event,
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
@@ -444,7 +793,7 @@ event_sched_out(struct perf_event *event,
 		event->pending_disable = 0;
 		event->state = PERF_EVENT_STATE_OFF;
 	}
-	event->tstamp_stopped = ctx->time;
+	event->tstamp_stopped = tstamp;
 	event->pmu->del(event, 0);
 	event->oncpu = -1;
 
@@ -589,6 +938,7 @@ static void __perf_event_disable(void *info)
 	 */
 	if (event->state >= PERF_EVENT_STATE_INACTIVE) {
 		update_context_time(ctx);
+		update_css_time_from_event(event);
 		update_group_times(event);
 		if (event == event->group_leader)
 			group_sched_out(event, cpuctx, ctx);
@@ -656,6 +1006,8 @@ event_sched_in(struct perf_event *event,
 		 struct perf_cpu_context *cpuctx,
 		 struct perf_event_context *ctx)
 {
+	u64 tstamp;
+
 	if (event->state <= PERF_EVENT_STATE_OFF)
 		return 0;
 
@@ -672,7 +1024,8 @@ event_sched_in(struct perf_event *event,
 		return -EAGAIN;
 	}
 
-	event->tstamp_running += ctx->time - event->tstamp_stopped;
+	tstamp = perf_event_time(event);
+	event->tstamp_running += tstamp - event->tstamp_stopped;
 
 	event->shadow_ctx_time = ctx->time - ctx->timestamp;
 
@@ -786,11 +1139,14 @@ static int group_can_go_on(struct perf_event *event,
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
 }
 
 /*
@@ -823,9 +1179,16 @@ static void __perf_install_in_context(void *info)
 	ctx->is_active = 1;
 	update_context_time(ctx);
 
+	/*
+	 * update css time only if current css
+	 * matches event->css. Must be done before
+	 * calling add_event_to_ctx()
+	 */
+	update_css_time_from_event(event);
+
 	add_event_to_ctx(event, ctx);
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event, current))
 		goto unlock;
 
 	/*
@@ -930,14 +1293,13 @@ static void __perf_event_mark_enabled(struct perf_event *event,
 					struct perf_event_context *ctx)
 {
 	struct perf_event *sub;
+	u64 tstamp = perf_event_time(event);
 
 	event->state = PERF_EVENT_STATE_INACTIVE;
-	event->tstamp_enabled = ctx->time - event->total_time_enabled;
+	event->tstamp_enabled = tstamp - event->total_time_enabled;
 	list_for_each_entry(sub, &event->sibling_list, group_entry) {
-		if (sub->state >= PERF_EVENT_STATE_INACTIVE) {
-			sub->tstamp_enabled =
-				ctx->time - sub->total_time_enabled;
-		}
+		if (sub->state >= PERF_EVENT_STATE_INACTIVE)
+			sub->tstamp_enabled = tstamp - sub->total_time_enabled;
 	}
 }
 
@@ -968,9 +1330,17 @@ static void __perf_event_enable(void *info)
 
 	if (event->state >= PERF_EVENT_STATE_INACTIVE)
 		goto unlock;
+
+	/*
+	 * update css time when current css corresponds
+	 * to event->css. Must be done before calling
+	 * __perf_event_mark_enabled()
+	 */
+	update_css_time_from_event(event);
+
 	__perf_event_mark_enabled(event, ctx);
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event, current))
 		goto unlock;
 
 	/*
@@ -1081,12 +1451,6 @@ static int perf_event_refresh(struct perf_event *event, int refresh)
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
@@ -1099,6 +1463,7 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 	if (likely(!ctx->nr_events))
 		goto out;
 	update_context_time(ctx);
+	update_css_time_from_task(current);
 
 	if (!ctx->nr_active)
 		goto out;
@@ -1318,16 +1683,21 @@ static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
 
 static void
 ctx_pinned_sched_in(struct perf_event_context *ctx,
-		    struct perf_cpu_context *cpuctx)
+		    struct perf_cpu_context *cpuctx,
+		    struct task_struct *task, int css_sw)
 {
 	struct perf_event *event;
 
 	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
 		if (event->state <= PERF_EVENT_STATE_OFF)
 			continue;
-		if (event->cpu != -1 && event->cpu != smp_processor_id())
+
+		if (!event_filter_match(event, task))
 			continue;
 
+		if (is_cgroup_event(event))
+			perf_cgroup_sched_in(event, css_sw);
+
 		if (group_can_go_on(event, cpuctx, 1))
 			group_sched_in(event, cpuctx, ctx);
 
@@ -1344,7 +1714,8 @@ ctx_pinned_sched_in(struct perf_event_context *ctx,
 
 static void
 ctx_flexible_sched_in(struct perf_event_context *ctx,
-		      struct perf_cpu_context *cpuctx)
+		      struct perf_cpu_context *cpuctx,
+		      struct task_struct *task, int css_sw)
 {
 	struct perf_event *event;
 	int can_add_hw = 1;
@@ -1357,9 +1728,12 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
 		 * Listen to the 'cpu' scheduling filter constraint
 		 * of events:
 		 */
-		if (event->cpu != -1 && event->cpu != smp_processor_id())
+		if (!event_filter_match(event, task))
 			continue;
 
+		if (is_cgroup_event(event))
+			perf_cgroup_sched_in(event, css_sw);
+
 		if (group_can_go_on(event, cpuctx, can_add_hw)) {
 			if (group_sched_in(event, cpuctx, ctx))
 				can_add_hw = 0;
@@ -1370,36 +1744,42 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
 static void
 ctx_sched_in(struct perf_event_context *ctx,
 	     struct perf_cpu_context *cpuctx,
-	     enum event_type_t event_type)
+	     enum event_type_t event_type,
+	     struct task_struct *task, int css_sw)
 {
+	u64 now;
+
 	raw_spin_lock(&ctx->lock);
 	ctx->is_active = 1;
 	if (likely(!ctx->nr_events))
 		goto out;
 
-	ctx->timestamp = perf_clock();
+	now = perf_clock();
+	ctx->timestamp = now;
 
+	perf_cgroup_set_timestamp(task, now);
 	/*
 	 * First go through the list and put on any pinned groups
 	 * in order to give them the best chance of going on.
 	 */
 	if (event_type & EVENT_PINNED)
-		ctx_pinned_sched_in(ctx, cpuctx);
+		ctx_pinned_sched_in(ctx, cpuctx, task, css_sw);
 
 	/* Then walk through the lower prio flexible groups */
 	if (event_type & EVENT_FLEXIBLE)
-		ctx_flexible_sched_in(ctx, cpuctx);
+		ctx_flexible_sched_in(ctx, cpuctx, task, css_sw);
 
 out:
 	raw_spin_unlock(&ctx->lock);
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
 
 static void task_ctx_sched_in(struct perf_event_context *ctx,
@@ -1411,11 +1791,12 @@ static void task_ctx_sched_in(struct perf_event_context *ctx,
 	if (cpuctx->task_ctx == ctx)
 		return;
 
-	ctx_sched_in(ctx, cpuctx, event_type);
+	ctx_sched_in(ctx, cpuctx, event_type, ctx->task, 0);
 	cpuctx->task_ctx = ctx;
 }
 
-void perf_event_context_sched_in(struct perf_event_context *ctx)
+void perf_event_context_sched_in(struct perf_event_context *ctx,
+				 struct task_struct *task)
 {
 	struct perf_cpu_context *cpuctx;
 
@@ -1431,9 +1812,9 @@ void perf_event_context_sched_in(struct perf_event_context *ctx)
 	 */
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 
-	ctx_sched_in(ctx, cpuctx, EVENT_PINNED);
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
-	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE);
+	ctx_sched_in(ctx, cpuctx, EVENT_PINNED, task, 0);
+	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, task, 0);
+	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE, task, 0);
 
 	cpuctx->task_ctx = ctx;
 
@@ -1466,7 +1847,7 @@ void __perf_event_task_sched_in(struct task_struct *task)
 		if (likely(!ctx))
 			continue;
 
-		perf_event_context_sched_in(ctx);
+		perf_event_context_sched_in(ctx, task);
 	}
 }
 
@@ -1584,7 +1965,7 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
 
-		if (event->cpu != -1 && event->cpu != smp_processor_id())
+		if (!event_filter_match(event, current))
 			continue;
 
 		hwc = &event->hw;
@@ -1667,7 +2048,7 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
 	if (ctx)
 		rotate_ctx(ctx);
 
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
+	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, current, 0);
 	if (ctx)
 		task_ctx_sched_in(ctx, EVENT_FLEXIBLE);
 
@@ -1746,7 +2127,7 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 
 	raw_spin_unlock(&ctx->lock);
 
-	perf_event_context_sched_in(ctx);
+	perf_event_context_sched_in(ctx, ctx->task);
 out:
 	local_irq_restore(flags);
 }
@@ -1772,6 +2153,7 @@ static void __perf_event_read(void *info)
 
 	raw_spin_lock(&ctx->lock);
 	update_context_time(ctx);
+	update_css_time_from_event(event);
 	update_event_times(event);
 	raw_spin_unlock(&ctx->lock);
 
@@ -1802,8 +2184,10 @@ static u64 perf_event_read(struct perf_event *event)
 		 * (e.g., thread is blocked), in that case
 		 * we cannot update context time
 		 */
-		if (ctx->is_active)
+		if (ctx->is_active) {
 			update_context_time(ctx);
+			update_css_time_from_event(event);
+		}
 		update_event_times(event);
 		raw_spin_unlock_irqrestore(&ctx->lock, flags);
 	}
@@ -2195,6 +2579,9 @@ static void free_event(struct perf_event *event)
 		event->buffer = NULL;
 	}
 
+	if (is_cgroup_event(event))
+		perf_put_cgroup(event);
+
 	if (event->destroy)
 		event->destroy(event);
 
@@ -3761,7 +4148,7 @@ static int perf_event_task_match(struct perf_event *event)
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event, current))
 		return 0;
 
 	if (event->attr.comm || event->attr.mmap ||
@@ -3886,7 +4273,7 @@ static int perf_event_comm_match(struct perf_event *event)
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event, current))
 		return 0;
 
 	if (event->attr.comm)
@@ -4024,7 +4411,7 @@ static int perf_event_mmap_match(struct perf_event *event,
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event, current))
 		return 0;
 
 	if ((!executable && event->attr.mmap_data) ||
@@ -5036,6 +5423,7 @@ static void task_clock_event_read(struct perf_event *event)
 	u64 time;
 
 	if (!in_nmi()) {
+		update_css_time_from_event(event);
 		update_context_time(event->ctx);
 		time = event->ctx->time;
 	} else {
@@ -5241,6 +5629,7 @@ unlock:
 static struct perf_event *
 perf_event_alloc(struct perf_event_attr *attr, int cpu,
 		 struct task_struct *task,
+		 pid_t pid, int flags,
 		 struct perf_event *group_leader,
 		 struct perf_event *parent_event,
 		 perf_overflow_handler_t overflow_handler)
@@ -5254,6 +5643,14 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	if (!event)
 		return ERR_PTR(-ENOMEM);
 
+	if (flags & PERF_FLAG_PID_CGROUP) {
+		err = perf_connect_cgroup(pid, event, attr, group_leader);
+		if (err) {
+			kfree(event);
+			return ERR_PTR(err);
+		}
+	}
+
 	/*
 	 * Single events are their own group leaders, with an
 	 * empty sibling list:
@@ -5332,6 +5729,7 @@ done:
 	if (err) {
 		if (event->ns)
 			put_pid_ns(event->ns);
+		perf_put_cgroup(event);
 		kfree(event);
 		return ERR_PTR(err);
 	}
@@ -5515,7 +5913,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	int err;
 
 	/* for future expandability... */
-	if (flags & ~(PERF_FLAG_FD_NO_GROUP | PERF_FLAG_FD_OUTPUT))
+	if (flags & ~PERF_FLAG_ALL)
 		return -EINVAL;
 
 	err = perf_copy_attr(attr_uptr, &attr);
@@ -5532,6 +5930,10 @@ SYSCALL_DEFINE5(perf_event_open,
 			return -EINVAL;
 	}
 
+	/* cgroup must provide pid (cgroup fd) and cpu */
+	if ((flags & PERF_FLAG_PID_CGROUP) && (pid == -1 || cpu == -1))
+		return -EINVAL;
+
 	event_fd = get_unused_fd_flags(O_RDWR);
 	if (event_fd < 0)
 		return event_fd;
@@ -5549,7 +5951,7 @@ SYSCALL_DEFINE5(perf_event_open,
 			group_leader = NULL;
 	}
 
-	if (pid != -1) {
+	if (pid != -1 && !(flags & PERF_FLAG_PID_CGROUP)) {
 		task = find_lively_task_by_vpid(pid);
 		if (IS_ERR(task)) {
 			err = PTR_ERR(task);
@@ -5557,7 +5959,8 @@ SYSCALL_DEFINE5(perf_event_open,
 		}
 	}
 
-	event = perf_event_alloc(&attr, cpu, task, group_leader, NULL, NULL);
+	event = perf_event_alloc(&attr, cpu, task, pid, flags, group_leader,
+				 NULL, NULL);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err_task;
@@ -5726,7 +6129,8 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	 * Get the target context (task or percpu):
 	 */
 
-	event = perf_event_alloc(attr, cpu, task, NULL, NULL, overflow_handler);
+	event = perf_event_alloc(attr, cpu, task, -1, 0, NULL,
+				 NULL, overflow_handler);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err;
@@ -5905,6 +6309,8 @@ void perf_event_exit_task(struct task_struct *child)
 
 	for_each_task_context_nr(ctxn)
 		perf_event_exit_task_context(child, ctxn);
+
+	perf_cgroup_exit_task(child);
 }
 
 static void perf_free_event(struct perf_event *event,
@@ -5995,6 +6401,7 @@ inherit_event(struct perf_event *parent_event,
 	child_event = perf_event_alloc(&parent_event->attr,
 					   parent_event->cpu,
 					   child,
+					   -1, 0,
 					   group_leader, parent_event,
 					   NULL);
 	if (IS_ERR(child_event))
@@ -6329,3 +6736,51 @@ void __init perf_event_init(void)
 	perf_tp_register();
 	perf_cpu_notifier(perf_cpu_notify);
 }
+
+#ifdef CONFIG_CGROUPS
+static struct cgroup_subsys_state *perf_cgroup_create(
+	struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	struct perf_cgroup *jc;
+	struct perf_cgroup_info *t;
+	int c;
+
+	jc = vmalloc(sizeof(*jc));
+	if (!jc)
+		return ERR_PTR(-ENOMEM);
+
+	memset(jc, 0, sizeof(*jc));
+
+	jc->info = alloc_percpu(struct perf_cgroup_info);
+	if (!jc->info) {
+		vfree(jc);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	for_each_possible_cpu(c) {
+		t = per_cpu_ptr(jc->info, c);
+		t->time = 0;
+		t->timestamp = 0;
+	}
+	return &jc->css;
+}
+
+static void perf_cgroup_destroy(struct cgroup_subsys *ss,
+				struct cgroup *cont)
+{
+	struct perf_cgroup *jc;
+	jc = container_of(cgroup_subsys_state(cont, perf_subsys_id),
+			  struct perf_cgroup, css);
+
+	free_percpu(jc->info);
+	vfree(jc);
+}
+
+struct cgroup_subsys perf_subsys = {
+	.name = "perf_event",
+	.subsys_id = perf_subsys_id,
+	.create = perf_cgroup_create,
+	.destroy = perf_cgroup_destroy,
+	.early_init = 0,
+};
+#endif /* CONFIG_CGROUP */

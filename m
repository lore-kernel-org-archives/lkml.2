Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab1ACRqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 12:46:15 -0500
Received: from smtp-out.google.com ([74.125.121.67]:22843 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410Ab1ACRqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 12:46:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=LcEhkQ3SAsfVzzObvwb7IxrxwS/u5Ckh4sugPmm/KiPnrKzzz3JF6dBgzuiOQDt4pe
         HDVCr6kvRtikYNfqs7jA==
Message-ID: <4d2205a1.8b02e30a.3541.ffff8aee@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Mon, 3 Jan 2011 18:20:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
Subject: [PATCH 4/5] perf_events: add cgroup support (v7)
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
index ed4ba11..5449b61 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -626,6 +626,7 @@ bool css_is_ancestor(struct cgroup_subsys_state *cg,
 /* Get id and depth of css */
 unsigned short css_id(struct cgroup_subsys_state *css);
 unsigned short css_depth(struct cgroup_subsys_state *css);
+struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id);
 
 #else /* !CONFIG_CGROUPS */
 
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index ccefff0..cdbfcb8 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -65,4 +65,8 @@ SUBSYS(net_cls)
 SUBSYS(blkio)
 #endif
 
+#ifdef CONFIG_CGROUP_PERF
+SUBSYS(perf)
+#endif
+
 /* */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index dda5b0a..8843da4 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -464,6 +464,7 @@ enum perf_callchain_context {
 
 #define PERF_FLAG_FD_NO_GROUP	(1U << 0)
 #define PERF_FLAG_FD_OUTPUT	(1U << 1)
+#define PERF_FLAG_PID_CGROUP	(1U << 2) /* pid=cgroup id, per-cpu mode only */
 
 #ifdef __KERNEL__
 /*
@@ -471,6 +472,7 @@ enum perf_callchain_context {
  */
 
 #ifdef CONFIG_PERF_EVENTS
+# include <linux/cgroup.h>
 # include <asm/perf_event.h>
 # include <asm/local64.h>
 #endif
@@ -716,6 +718,22 @@ struct swevent_hlist {
 #define PERF_ATTACH_GROUP	0x02
 #define PERF_ATTACH_TASK	0x04
 
+#ifdef CONFIG_CGROUP_PERF
+/*
+ * perf_cgroup_info keeps track of time_enabled for a cgroup.
+ * This is a per-cpu dynamically allocated data structure.
+ */
+struct perf_cgroup_info {
+	u64 time;
+	u64 timestamp;
+};
+
+struct perf_cgroup {
+	struct cgroup_subsys_state css;
+	struct perf_cgroup_info *info;	/* timing info, one per cpu */
+};
+#endif
+
 /**
  * struct perf_event - performance event kernel representation:
  */
@@ -832,6 +850,10 @@ struct perf_event {
 	struct event_filter		*filter;
 #endif
 
+#ifdef CONFIG_CGROUP_PERF
+	struct perf_cgroup		*cgrp; /* cgroup event is attach to */
+#endif
+
 #endif /* CONFIG_PERF_EVENTS */
 };
 
@@ -886,6 +908,7 @@ struct perf_event_context {
 	u64				generation;
 	int				pin_count;
 	struct rcu_head			rcu_head;
+	int				nr_cgroups; /* cgroup events present */
 };
 
 /*
@@ -1040,11 +1063,11 @@ have_event:
 	__perf_sw_event(event_id, nr, nmi, regs, addr);
 }
 
-extern atomic_t perf_task_events;
+extern atomic_t perf_sched_events;
 
 static inline void perf_event_task_sched_in(struct task_struct *task)
 {
-	COND_STMT(&perf_task_events, __perf_event_task_sched_in(task));
+	COND_STMT(&perf_sched_events, __perf_event_task_sched_in(task));
 }
 
 static inline
@@ -1052,7 +1075,7 @@ void perf_event_task_sched_out(struct task_struct *task, struct task_struct *nex
 {
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
 
-	COND_STMT(&perf_task_events, __perf_event_task_sched_out(task, next));
+	COND_STMT(&perf_sched_events, __perf_event_task_sched_out(task, next));
 }
 
 extern void perf_event_mmap(struct vm_area_struct *vma);
diff --git a/init/Kconfig b/init/Kconfig
index 8dfd094..fd24181 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -680,6 +680,16 @@ config CGROUP_MEM_RES_CTLR_SWAP_ENABLED
 	  select this option (if, for some reason, they need to disable it
 	  then noswapaccount does the trick).
 
+config CGROUP_PERF
+	bool "Enable perf_event per-cpu per-container group (cgroup) monitoring"
+	depends on PERF_EVENTS && CGROUPS
+	help
+	  This option extends the per-cpu mode to restrict monitoring to
+	  threads which belong to the cgroup specificied and run on the
+	  designated cpu.
+
+	  Say N if unsure.
+
 menuconfig CGROUP_SCHED
 	bool "Group CPU scheduler"
 	depends on EXPERIMENTAL
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
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index b782b7a..905b91a 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -38,13 +38,23 @@
 
 #include <asm/irq_regs.h>
 
+#define PERF_FLAG_ALL (PERF_FLAG_FD_NO_GROUP |\
+		       PERF_FLAG_FD_OUTPUT  |\
+		       PERF_FLAG_PID_CGROUP)
+
 enum event_type_t {
 	EVENT_FLEXIBLE = 0x1,
 	EVENT_PINNED = 0x2,
 	EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED,
 };
 
-atomic_t perf_task_events __read_mostly;
+/*
+ * perf_sched_events : >0 events exist
+ * perf_cgroup_events: >0 per-cpu cgroup events exist on this cpu
+ */
+atomic_t perf_sched_events __read_mostly;
+static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
+
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
 static atomic_t nr_task_events __read_mostly;
@@ -75,7 +85,10 @@ static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
 			      enum event_type_t event_type);
 
 static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
-			     enum event_type_t event_type);
+			     enum event_type_t event_type,
+			     struct task_struct *task, int css_sw);
+
+static u64 perf_event_time(struct perf_event *event);
 
 void __weak perf_event_print_debug(void)	{ }
 
@@ -89,6 +102,326 @@ static inline u64 perf_clock(void)
 	return local_clock();
 }
 
+#ifdef CONFIG_CGROUP_PERF
+static inline struct perf_cgroup *
+perf_cgroup_from_task(struct task_struct *task)
+{
+	return container_of(task_subsys_state(task, perf_subsys_id),
+			struct perf_cgroup, css);
+}
+
+static inline bool
+perf_cgroup_match(struct perf_event *event, struct task_struct *task)
+{
+	struct perf_cgroup *cgrp = NULL;
+	if (task)
+		cgrp = perf_cgroup_from_task(task);
+	return !event->cgrp || event->cgrp == cgrp;
+}
+
+static inline void perf_get_cgroup(struct perf_event *event)
+{
+	css_get(&event->cgrp->css);
+}
+
+static inline void perf_put_cgroup(struct perf_event *event)
+{
+	css_put(&event->cgrp->css);
+}
+
+static inline void perf_detach_cgroup(struct perf_event *event)
+{
+	perf_put_cgroup(event);
+	event->cgrp = NULL;
+}
+
+static inline int is_cgroup_event(struct perf_event *event)
+{
+	return event->cgrp != NULL;
+}
+
+static inline u64 perf_cgroup_event_time(struct perf_event *event)
+{
+	struct perf_cgroup_info *t;
+
+	t = per_cpu_ptr(event->cgrp->info, event->cpu);
+	return t->time;
+}
+
+static inline void __update_cgrp_time(struct perf_cgroup *cgrp)
+{
+	struct perf_cgroup_info *t;
+	u64 now;
+
+	now = perf_clock();
+
+	t = per_cpu_ptr(cgrp->info, smp_processor_id());
+
+	t->time += now - t->timestamp;
+	t->timestamp = now;
+}
+
+static inline void update_cgrp_time_from_task(struct task_struct *task)
+{
+	struct perf_cgroup *cgrp_out = perf_cgroup_from_task(task);
+	if (cgrp_out)
+		__update_cgrp_time(cgrp_out);
+}
+
+static inline void update_cgrp_time_from_event(struct perf_event *event)
+{
+	struct perf_cgroup *cgrp = perf_cgroup_from_task(current);
+	/*
+	 * do not update time when cgroup is not active
+	 */
+	if (!event->cgrp || cgrp != event->cgrp)
+		return;
+
+	__update_cgrp_time(event->cgrp);
+}
+
+static inline void
+perf_cgroup_set_timestamp(struct task_struct *task, u64 now)
+{
+	struct perf_cgroup *cgrp;
+	struct perf_cgroup_info *info;
+
+	if (!task)
+		return;
+
+	cgrp = perf_cgroup_from_task(task);
+	info = per_cpu_ptr(cgrp->info, smp_processor_id());
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
+	struct perf_cgroup *cgrp_out = perf_cgroup_from_task(task);
+	struct perf_cgroup *cgrp_in = perf_cgroup_from_task(next);
+	struct perf_cpu_context *cpuctx;
+	struct pmu *pmu;
+	/*
+	 * if task is DEAD, then css_out is irrelevant, it has
+	 * been changed to init_cgrp in cgroup_exit() from do_exit().
+	 * Furthermore, perf_cgroup_exit_task(), has scheduled out
+	 * all css constrained events, only unconstrained events
+	 * remain. Therefore we need to reschedule based on css_in.
+	 */
+	if (task->state != TASK_DEAD && cgrp_out == cgrp_in)
+		return;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+
+		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+
+		perf_pmu_disable(cpuctx->ctx.pmu);
+
+		/*
+		 * perf_cgroup_events says at least one
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
+		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
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
+static inline int perf_cgroup_connect(int fd, struct perf_event *event,
+				      struct perf_event_attr *attr,
+				      struct perf_event *group_leader)
+{
+	struct perf_cgroup *cgrp;
+	struct cgroup_subsys_state *css;
+	struct file *file;
+	int ret = 0, fput_needed;
+
+	file = fget_light(fd, &fput_needed);
+	if (!file)
+		return -EBADF;
+
+	css = cgroup_css_from_dir(file, perf_subsys_id);
+	if (IS_ERR(css))
+		return PTR_ERR(css);
+
+	cgrp = container_of(css, struct perf_cgroup, css);
+	event->cgrp = cgrp;
+
+	/*
+	 * all events in a group must monitor
+	 * the same cgroup because a thread belongs
+	 * to only one perf cgroup at a time
+	 */
+	if (group_leader && group_leader->cgrp != cgrp) {
+		perf_detach_cgroup(event);
+		ret = -EINVAL;
+	} else {
+		/* must be done before we fput() the file */
+		perf_get_cgroup(event);
+	}
+	fput_light(file, fput_needed);
+	return ret;
+}
+
+static inline void
+perf_cgroup_set_shadow_time(struct perf_event *event, u64 now)
+{
+	struct perf_cgroup_info *t;
+	t = per_cpu_ptr(event->cgrp->info, event->cpu);
+	event->shadow_ctx_time = now - t->timestamp;
+}
+
+#else /* !CONFIG_CGROUP_PERF */
+
+static inline bool
+perf_cgroup_match(struct perf_event *event, struct task_struct *task)
+{
+	return true;
+}
+
+static inline void perf_detach_cgroup(struct perf_event *event)
+{}
+
+static inline int is_cgroup_event(struct perf_event *event)
+{
+	return 0;
+}
+
+static inline u64 perf_cgroup_event_cgrp_time(struct perf_event *event)
+{
+	return 0;
+}
+
+static inline void update_cgrp_time_from_event(struct perf_event *event)
+{}
+
+static inline void update_cgrp_time_from_task(struct task_struct *t)
+{}
+
+static inline int perf_cgroup_connect(pid_t pid, struct perf_event *event,
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
+void
+perf_cgroup_switch(struct task_struct *task, struct task_struct *next)
+{}
+
+static inline void
+perf_cgroup_exit_task(struct task_struct *task)
+{}
+
+static inline void
+perf_cgroup_set_shadow_time(struct perf_event *event, u64 now)
+{}
+
+static inline u64 perf_cgroup_event_time(struct perf_event *event)
+{
+	return 0;
+}
+
+#endif
+
 void perf_pmu_disable(struct pmu *pmu)
 {
 	int *count = this_cpu_ptr(pmu->pmu_disable_count);
@@ -271,6 +604,10 @@ static void update_context_time(struct perf_event_context *ctx)
 static u64 perf_event_time(struct perf_event *event)
 {
 	struct perf_event_context *ctx = event->ctx;
+
+	if (is_cgroup_event(event))
+		return perf_cgroup_event_time(event);
+
 	return ctx ? ctx->time : 0;
 }
 
@@ -285,9 +622,19 @@ static void update_event_times(struct perf_event *event)
 	if (event->state < PERF_EVENT_STATE_INACTIVE ||
 	    event->group_leader->state < PERF_EVENT_STATE_INACTIVE)
 		return;
-
-	if (ctx->is_active)
-		run_end = perf_event_time(event);
+	/*
+	 * in cgroup mode, time_enabled represents
+	 * the time the event was enabled AND the active
+	 * thread was in the monitoring cgroup. This is
+	 * independent of activity of the context as there
+	 * may be a mix of cgroup and non-cgroup events.
+	 * That is why we treat cgroup events differently
+	 * here.
+	 */
+	if (is_cgroup_event(event))
+		run_end = perf_cgroup_event_time(event);
+	else if (ctx->is_active)
+		run_end = ctx->time;
 	else
 		run_end = event->tstamp_stopped;
 
@@ -347,6 +694,17 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 		list_add_tail(&event->group_entry, list);
 	}
 
+	if (is_cgroup_event(event)) {
+		ctx->nr_cgroups++;
+		/*
+		 * one more event:
+		 * - that has cgroup constraint on event->cpu
+		 * - that may need work on context switch
+		 */
+		atomic_inc(&per_cpu(perf_cgroup_events, event->cpu));
+		jump_label_inc(&perf_sched_events);
+	}
+
 	list_add_rcu(&event->event_entry, &ctx->event_list);
 	if (!ctx->nr_events)
 		perf_pmu_rotate_start(ctx->pmu);
@@ -473,6 +831,12 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 
 	event->attach_state &= ~PERF_ATTACH_CONTEXT;
 
+	if (is_cgroup_event(event)) {
+		ctx->nr_cgroups--;
+		atomic_dec(&per_cpu(perf_cgroup_events, event->cpu));
+		jump_label_dec(&perf_sched_events);
+	}
+
 	ctx->nr_events--;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat--;
@@ -542,9 +906,10 @@ out:
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
@@ -561,8 +926,8 @@ event_sched_out(struct perf_event *event,
 	 * via read() for time_enabled, time_running:
 	 */
 	if (event->state == PERF_EVENT_STATE_INACTIVE
-	    && !event_filter_match(event)) {
-		delta = ctx->time - event->tstamp_stopped;
+	    && !event_filter_match(event, current)) {
+		delta = tstamp - event->tstamp_stopped;
 		event->tstamp_running += delta;
 		event->tstamp_stopped = tstamp;
 	}
@@ -720,6 +1085,7 @@ static void __perf_event_disable(void *info)
 	 */
 	if (event->state >= PERF_EVENT_STATE_INACTIVE) {
 		update_context_time(ctx);
+		update_cgrp_time_from_event(event);
 		update_group_times(event);
 		if (event == event->group_leader)
 			group_sched_out(event, cpuctx, ctx);
@@ -782,6 +1148,41 @@ retry:
 	raw_spin_unlock_irq(&ctx->lock);
 }
 
+static void perf_set_shadow_time(struct perf_event *event,
+				 struct perf_event_context *ctx,
+				 u64 tstamp)
+{
+	/*
+	 * use the correct time source for the time snapshot
+	 *
+	 * We could get by without this by leveraging the
+	 * fact that to get to this function, the caller
+	 * has most likely already called update_context_time()
+	 * and update_cgrp_time_xx() and thus both timestamp
+	 * are identical (or very close). Given that tstamp is,
+	 * already adjusted for cgroup, we could say that:
+	 *    tstamp - ctx->timestamp
+	 * is equivalent to
+	 *    tstamp - cgrp->timestamp.
+	 *
+	 * Then, in perf_output_read(), the calculation would
+	 * work with no changes because:
+	 * - event is guaranteed scheduled in
+	 * - no scheduled out in between
+	 * - thus the timestamp would be the same
+	 *
+	 * But this is a bit hairy.
+	 *
+	 * So instead, we have an explicit cgroup call to remain
+	 * within the time time source all along. We believe it
+	 * is cleaner and simpler to understand.
+	 */
+	if (is_cgroup_event(event))
+		perf_cgroup_set_shadow_time(event, tstamp);
+	else
+		event->shadow_ctx_time = tstamp - ctx->timestamp;
+}
+
 static int
 event_sched_in(struct perf_event *event,
 		 struct perf_cpu_context *cpuctx,
@@ -807,7 +1208,7 @@ event_sched_in(struct perf_event *event,
 
 	event->tstamp_running += tstamp - event->tstamp_stopped;
 
-	event->shadow_ctx_time = tstamp - ctx->timestamp;
+	perf_set_shadow_time(event, ctx, tstamp);
 
 	if (!is_software_event(event))
 		cpuctx->active_oncpu++;
@@ -957,10 +1358,16 @@ static void __perf_install_in_context(void *info)
 	raw_spin_lock(&ctx->lock);
 	ctx->is_active = 1;
 	update_context_time(ctx);
+	/*
+	 * update css time only if current css
+	 * matches event->css. Must be done before
+	 * calling add_event_to_ctx()
+	 */
+	update_cgrp_time_from_event(event);
 
 	add_event_to_ctx(event, ctx);
 
-	if (!event_filter_match(event))
+	if (!event_filter_match(event, current))
 		goto unlock;
 
 	/*
@@ -1102,9 +1509,16 @@ static void __perf_event_enable(void *info)
 
 	if (event->state >= PERF_EVENT_STATE_INACTIVE)
 		goto unlock;
+	/*
+	 * update css time when current css corresponds
+	 * to event->css. Must be done before calling
+	 * __perf_event_mark_enabled()
+	 */
+	update_cgrp_time_from_event(event);
+
 	__perf_event_mark_enabled(event, ctx);
 
-	if (!event_filter_match(event))
+	if (!event_filter_match(event, current))
 		goto unlock;
 
 	/*
@@ -1227,6 +1641,7 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 	if (likely(!ctx->nr_events))
 		goto out;
 	update_context_time(ctx);
+	update_cgrp_time_from_task(current);
 
 	if (!ctx->nr_active)
 		goto out;
@@ -1416,6 +1831,13 @@ void __perf_event_task_sched_out(struct task_struct *task,
 
 	for_each_task_context_nr(ctxn)
 		perf_event_context_sched_out(task, ctxn, next);
+
+	/*
+	 * if cgroup events exist on this CPU, then we need
+	 * to check if we have to save/restore PMU state.
+	 */
+	if (atomic_read(&__get_cpu_var(perf_cgroup_events)))
+		perf_cgroup_switch(task, next);
 }
 
 static void task_ctx_sched_out(struct perf_event_context *ctx,
@@ -1444,16 +1866,20 @@ static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
 
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
-		if (!event_filter_match(event))
+		if (!event_filter_match(event, task))
 			continue;
 
+		if (is_cgroup_event(event))
+			perf_cgroup_sched_in(event, css_sw);
+
 		if (group_can_go_on(event, cpuctx, 1))
 			group_sched_in(event, cpuctx, ctx);
 
@@ -1470,7 +1896,8 @@ ctx_pinned_sched_in(struct perf_event_context *ctx,
 
 static void
 ctx_flexible_sched_in(struct perf_event_context *ctx,
-		      struct perf_cpu_context *cpuctx)
+		      struct perf_cpu_context *cpuctx,
+		      struct task_struct *task, int css_sw)
 {
 	struct perf_event *event;
 	int can_add_hw = 1;
@@ -1483,9 +1910,12 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
 		 * Listen to the 'cpu' scheduling filter constraint
 		 * of events:
 		 */
-		if (!event_filter_match(event))
+		if (!event_filter_match(event, task))
 			continue;
 
+		if (is_cgroup_event(event))
+			perf_cgroup_sched_in(event, css_sw);
+
 		if (group_can_go_on(event, cpuctx, can_add_hw)) {
 			if (group_sched_in(event, cpuctx, ctx))
 				can_add_hw = 0;
@@ -1496,36 +1926,41 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
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
-
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
@@ -1537,11 +1972,12 @@ static void task_ctx_sched_in(struct perf_event_context *ctx,
 	if (cpuctx->task_ctx == ctx)
 		return;
 
-	ctx_sched_in(ctx, cpuctx, event_type);
+	ctx_sched_in(ctx, cpuctx, event_type, NULL, 0);
 	cpuctx->task_ctx = ctx;
 }
 
-void perf_event_context_sched_in(struct perf_event_context *ctx)
+void perf_event_context_sched_in(struct perf_event_context *ctx,
+				 struct task_struct *task)
 {
 	struct perf_cpu_context *cpuctx;
 
@@ -1557,9 +1993,9 @@ void perf_event_context_sched_in(struct perf_event_context *ctx)
 	 */
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 
-	ctx_sched_in(ctx, cpuctx, EVENT_PINNED);
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
-	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE);
+	ctx_sched_in(ctx, cpuctx, EVENT_PINNED, task, 0);
+	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, task, 0);
+	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE, task, 0);
 
 	cpuctx->task_ctx = ctx;
 
@@ -1592,7 +2028,7 @@ void __perf_event_task_sched_in(struct task_struct *task)
 		if (likely(!ctx))
 			continue;
 
-		perf_event_context_sched_in(ctx);
+		perf_event_context_sched_in(ctx, task);
 	}
 }
 
@@ -1710,7 +2146,7 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
 
-		if (!event_filter_match(event))
+		if (!event_filter_match(event, current))
 			continue;
 
 		hwc = &event->hw;
@@ -1797,7 +2233,7 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
 	if (ctx)
 		rotate_ctx(ctx);
 
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
+	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, current, 0);
 	if (ctx)
 		task_ctx_sched_in(ctx, EVENT_FLEXIBLE);
 
@@ -1876,7 +2312,7 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 
 	raw_spin_unlock(&ctx->lock);
 
-	perf_event_context_sched_in(ctx);
+	perf_event_context_sched_in(ctx, ctx->task);
 out:
 	local_irq_restore(flags);
 }
@@ -1902,6 +2338,7 @@ static void __perf_event_read(void *info)
 
 	raw_spin_lock(&ctx->lock);
 	update_context_time(ctx);
+	update_cgrp_time_from_event(event);
 	update_event_times(event);
 	raw_spin_unlock(&ctx->lock);
 
@@ -1932,8 +2369,10 @@ static u64 perf_event_read(struct perf_event *event)
 		 * (e.g., thread is blocked), in that case
 		 * we cannot update context time
 		 */
-		if (ctx->is_active)
+		if (ctx->is_active) {
 			update_context_time(ctx);
+			update_cgrp_time_from_event(event);
+		}
 		update_event_times(event);
 		raw_spin_unlock_irqrestore(&ctx->lock, flags);
 	}
@@ -2309,7 +2748,7 @@ static void free_event(struct perf_event *event)
 
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
-			jump_label_dec(&perf_task_events);
+			jump_label_dec(&perf_sched_events);
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_dec(&nr_mmap_events);
 		if (event->attr.comm)
@@ -2325,6 +2764,9 @@ static void free_event(struct perf_event *event)
 		event->buffer = NULL;
 	}
 
+	if (is_cgroup_event(event))
+		perf_detach_cgroup(event);
+
 	if (event->destroy)
 		event->destroy(event);
 
@@ -3909,7 +4351,7 @@ static int perf_event_task_match(struct perf_event *event)
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (!event_filter_match(event))
+	if (!event_filter_match(event, current))
 		return 0;
 
 	if (event->attr.comm || event->attr.mmap ||
@@ -4046,7 +4488,7 @@ static int perf_event_comm_match(struct perf_event *event)
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (!event_filter_match(event))
+	if (!event_filter_match(event, current))
 		return 0;
 
 	if (event->attr.comm)
@@ -4194,7 +4636,7 @@ static int perf_event_mmap_match(struct perf_event *event,
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (!event_filter_match(event))
+	if (!event_filter_match(event, current))
 		return 0;
 
 	if ((!executable && event->attr.mmap_data) ||
@@ -5214,6 +5656,7 @@ static void task_clock_event_read(struct perf_event *event)
 
 	if (!in_nmi()) {
 		update_context_time(event->ctx);
+		update_cgrp_time_from_event(event);
 		time = event->ctx->time;
 	} else {
 		u64 now = perf_clock();
@@ -5631,7 +6074,7 @@ done:
 
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
-			jump_label_inc(&perf_task_events);
+			jump_label_inc(&perf_sched_events);
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_inc(&nr_mmap_events);
 		if (event->attr.comm)
@@ -5806,7 +6249,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	int err;
 
 	/* for future expandability... */
-	if (flags & ~(PERF_FLAG_FD_NO_GROUP | PERF_FLAG_FD_OUTPUT))
+	if (flags & ~PERF_FLAG_ALL)
 		return -EINVAL;
 
 	err = perf_copy_attr(attr_uptr, &attr);
@@ -5823,6 +6266,15 @@ SYSCALL_DEFINE5(perf_event_open,
 			return -EINVAL;
 	}
 
+	/*
+	 * In cgroup mode, the pid argument is used to pass the fd
+	 * opened to the cgroup directory in cgroupfs. The cpu argument
+	 * designates the cpu on which to monitor threads from that
+	 * cgroup.
+	 */
+	if ((flags & PERF_FLAG_PID_CGROUP) && (pid == -1 || cpu == -1))
+		return -EINVAL;
+
 	event_fd = get_unused_fd_flags(O_RDWR);
 	if (event_fd < 0)
 		return event_fd;
@@ -5840,7 +6292,7 @@ SYSCALL_DEFINE5(perf_event_open,
 			group_leader = NULL;
 	}
 
-	if (pid != -1) {
+	if (pid != -1 && !(flags & PERF_FLAG_PID_CGROUP)) {
 		task = find_lively_task_by_vpid(pid);
 		if (IS_ERR(task)) {
 			err = PTR_ERR(task);
@@ -5854,6 +6306,12 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_task;
 	}
 
+	if (flags & PERF_FLAG_PID_CGROUP) {
+		err = perf_cgroup_connect(pid, event, &attr, group_leader);
+		if (err)
+			goto err_alloc;
+	}
+
 	/*
 	 * Special case software events and allow them to be part of
 	 * any hardware group.
@@ -6212,6 +6670,8 @@ void perf_event_exit_task(struct task_struct *child)
 
 	for_each_task_context_nr(ctxn)
 		perf_event_exit_task_context(child, ctxn);
+
+	perf_cgroup_exit_task(child);
 }
 
 static void perf_free_event(struct perf_event *event,
@@ -6712,3 +7172,49 @@ unlock:
 	return ret;
 }
 device_initcall(perf_event_sysfs_init);
+
+#ifdef CONFIG_CGROUP_PERF
+static struct cgroup_subsys_state *perf_cgroup_create(
+	struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	struct perf_cgroup *jc;
+	struct perf_cgroup_info *t;
+	int c;
+
+	jc = kmalloc(sizeof(*jc), GFP_KERNEL);
+	if (!jc)
+		return ERR_PTR(-ENOMEM);
+
+	memset(jc, 0, sizeof(*jc));
+
+	jc->info = alloc_percpu(struct perf_cgroup_info);
+	if (!jc->info) {
+		kfree(jc);
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
+	free_percpu(jc->info);
+	kfree(jc);
+}
+
+struct cgroup_subsys perf_subsys = {
+	.name = "perf_event",
+	.subsys_id = perf_subsys_id,
+	.create = perf_cgroup_create,
+	.destroy = perf_cgroup_destroy,
+};
+#endif /* CONFIG_CGROUP_PERF */

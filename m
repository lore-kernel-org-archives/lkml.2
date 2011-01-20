Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab1ATOae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 09:30:34 -0500
Received: from smtp-out.google.com ([74.125.121.67]:11265 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab1ATOab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 09:30:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=xJq9vgP37UTY3MvI4V0e4JJj6F/RKi+2NET8h9OhNOB0UzIE9pP5eFjMjjMW19Amjt
         jhENmoyhe9P0Wf5rLipw==
Message-ID: <4d384700.2308e30a.70bc.ffffd532@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Thu, 20 Jan 2011 15:30:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
Subject: [PATCH 1/2] perf_events: add cgroup support (v8)
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
index ce104e3..780e88c 100644
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
index dda5b0a..c905765 100644
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
@@ -832,6 +850,11 @@ struct perf_event {
 	struct event_filter		*filter;
 #endif
 
+#ifdef CONFIG_CGROUP_PERF
+	struct perf_cgroup		*cgrp; /* cgroup event is attach to */
+	int				cgrp_defer_enabled;
+#endif
+
 #endif /* CONFIG_PERF_EVENTS */
 };
 
@@ -886,6 +909,7 @@ struct perf_event_context {
 	u64				generation;
 	int				pin_count;
 	struct rcu_head			rcu_head;
+	int				nr_cgroups; /* cgroup events present */
 };
 
 /*
@@ -1040,11 +1064,11 @@ have_event:
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
@@ -1052,7 +1076,7 @@ void perf_event_task_sched_out(struct task_struct *task, struct task_struct *nex
 {
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
 
-	COND_STMT(&perf_task_events, __perf_event_task_sched_out(task, next));
+	COND_STMT(&perf_sched_events, __perf_event_task_sched_out(task, next));
 }
 
 extern void perf_event_mmap(struct vm_area_struct *vma);
@@ -1121,6 +1145,29 @@ extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern void perf_event_task_tick(void);
+
+#ifdef CONFIG_CGROUP_PERF
+
+#define PERF_CGROUP_SWOUT	0x1 /* cgroup switch out every event */
+#define PERF_CGROUP_SWIN	0x2 /* cgroup switch in events based on task */
+
+extern void perf_cgroup_switch(struct task_struct *tsk, int mode);
+
+static inline void perf_cgroup_sched_out(struct task_struct *task)
+{
+	/* if necessary, deschedule all events */
+	perf_cgroup_switch(task, PERF_CGROUP_SWOUT);
+}
+
+static inline void perf_cgroup_sched_in(struct task_struct *task)
+{
+	/* if necessary, schedule cgroup events */
+	perf_cgroup_switch(task, PERF_CGROUP_SWIN);
+}
+#else
+static inline void perf_cgroup_sched_out(struct task_struct *task)	{ }
+static inline void perf_cgroup_sched_in(struct task_struct *task)	{ }
+#endif
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
@@ -1134,6 +1181,8 @@ static inline void perf_event_delayed_put(struct task_struct *task)	{ }
 static inline void perf_event_print_debug(void)				{ }
 static inline int perf_event_task_disable(void)				{ return -EINVAL; }
 static inline int perf_event_task_enable(void)				{ return -EINVAL; }
+static inline void perf_cgroup_sched_out(struct task_struct *task)	{ }
+static inline void perf_cgroup_sched_in(struct task_struct *task)	{ }
 
 static inline void
 perf_sw_event(u32 event_id, u64 nr, int nmi,
diff --git a/init/Kconfig b/init/Kconfig
index 4e33790..954eac3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -683,6 +683,16 @@ config CGROUP_MEM_RES_CTLR_SWAP_ENABLED
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
index b24d702..a27f64a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -57,6 +57,7 @@
 #include <linux/vmalloc.h> /* TODO: replace with more sophisticated array */
 #include <linux/eventfd.h>
 #include <linux/poll.h>
+#include <linux/perf_event.h>
 
 #include <asm/atomic.h>
 
@@ -4232,6 +4233,7 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 {
 	int i;
 	struct css_set *cg;
+	unsigned long flags;
 
 	if (run_callbacks && need_forkexit_callback) {
 		/*
@@ -4259,8 +4261,20 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 
 	/* Reassign the task to the init_css_set. */
 	task_lock(tsk);
+	/*
+	 * we mask interrupts to prevent:
+	 * - timer tick to cause event rotation which
+	 *   could schedule back in cgroup events after
+	 *   they were switched out by perf_cgroup_sched_out()
+	 *
+	 * - preemption which could schedule back in cgroup events
+	 */
+	local_irq_save(flags);
+	perf_cgroup_sched_out(tsk);
 	cg = tsk->cgroups;
 	tsk->cgroups = &init_css_set;
+	perf_cgroup_sched_in(tsk);
+	local_irq_restore(flags);
 	task_unlock(tsk);
 	if (cg)
 		put_css_set_taskexit(cg);
@@ -4813,6 +4827,29 @@ css_get_next(struct cgroup_subsys *ss, int id,
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
index 244ca3a..14bdefe 100644
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
@@ -75,7 +85,11 @@ static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
 			      enum event_type_t event_type);
 
 static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
-			     enum event_type_t event_type);
+			     enum event_type_t event_type,
+			     struct task_struct *task, int cgrp_sw);
+
+static void update_context_time(struct perf_event_context *ctx);
+static u64 perf_event_time(struct perf_event *event);
 
 void __weak perf_event_print_debug(void)	{ }
 
@@ -89,6 +103,292 @@ static inline u64 perf_clock(void)
 	return local_clock();
 }
 
+#ifdef CONFIG_CGROUP_PERF
+
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
+	struct perf_cgroup_info *info;
+	u64 now;
+
+	now = perf_clock();
+
+	info = this_cpu_ptr(cgrp->info);
+
+	info->time += now - info->timestamp;
+	info->timestamp = now;
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
+/*
+ * reschedule events based on the cgroup constraint of task.
+ *
+ * mode SWOUT : schedule out everything
+ * mode SWIN : schedule in based on cgroup for next
+ */
+void perf_cgroup_switch(struct task_struct *task, int mode)
+{
+	struct perf_cpu_context *cpuctx;
+	struct pmu *pmu;
+	unsigned long flags;
+
+	/*
+	 * disable interrupts to avoid geting nr_cgroup
+	 * changes via __perf_event_disable(). Also
+	 * avoids preemption.
+	 */
+	local_irq_save(flags);
+
+	/*
+	 * we reschedule only in the presence of cgroup
+	 * constrained events.
+	 */
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
+		 * events for a context.
+		 */
+		if (cpuctx->ctx.nr_cgroups > 0) {
+
+			if (mode & PERF_CGROUP_SWOUT)
+				cpu_ctx_sched_out(cpuctx, EVENT_ALL);
+
+			if (mode & PERF_CGROUP_SWIN)
+				cpu_ctx_sched_in(cpuctx, EVENT_ALL, task, 1);
+		}
+
+		perf_pmu_enable(cpuctx->ctx.pmu);
+	}
+
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
+	 * the same cgroup because a task belongs
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
+static inline void
+perf_cgroup_defer_enabled(struct perf_event *event, struct task_struct *task)
+{
+	/*
+	 * when the current task's perf cgroup does not match
+	 * the event's, we need to remember to call the
+	 * perf_mark_enable() function the first time a task with
+	 * a matching perf cgroup is scheduled in.
+	 */
+	if (is_cgroup_event(event) && !perf_cgroup_match(event, task))
+		event->cgrp_defer_enabled = 1;
+}
+
+static inline void
+perf_cgroup_mark_enabled(struct perf_event *event,
+			 struct perf_event_context *ctx)
+{
+	struct perf_event *sub;
+	u64 tstamp = perf_event_time(event);
+
+	if (!event->cgrp_defer_enabled)
+		return;
+
+	event->cgrp_defer_enabled = 0;
+
+	event->tstamp_enabled = tstamp - event->total_time_enabled;
+	list_for_each_entry(sub, &event->sibling_list, group_entry) {
+		if (sub->state >= PERF_EVENT_STATE_INACTIVE) {
+			sub->tstamp_enabled = tstamp - sub->total_time_enabled;
+			sub->cgrp_defer_enabled = 0;
+		}
+	}
+}
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
+perf_cgroup_set_timestamp(struct task_struct *task, u64 now)
+{}
+
+void
+perf_cgroup_switch(struct task_struct *task, struct task_struct *next)
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
+static inline void
+perf_cgroup_defer_enabled(struct perf_event *event, struct task_struct *task)
+{}
+
+static inline void
+perf_cgroup_mark_enabled(struct perf_event *event,
+			 struct perf_event_context *ctx)
+{}
+#endif
+
 void perf_pmu_disable(struct pmu *pmu)
 {
 	int *count = this_cpu_ptr(pmu->pmu_disable_count);
@@ -271,6 +571,10 @@ static void update_context_time(struct perf_event_context *ctx)
 static u64 perf_event_time(struct perf_event *event)
 {
 	struct perf_event_context *ctx = event->ctx;
+
+	if (is_cgroup_event(event))
+		return perf_cgroup_event_time(event);
+
 	return ctx ? ctx->time : 0;
 }
 
@@ -285,9 +589,20 @@ static void update_event_times(struct perf_event *event)
 	if (event->state < PERF_EVENT_STATE_INACTIVE ||
 	    event->group_leader->state < PERF_EVENT_STATE_INACTIVE)
 		return;
-
-	if (ctx->is_active)
+	/*
+	 * in cgroup mode, time_enabled represents
+	 * the time the event was enabled AND active
+	 * tasks were in the monitored cgroup. This is
+	 * independent of the activity of the context as
+	 * there may be a mix of cgroup and non-cgroup events.
+	 *
+	 * That is why we treat cgroup events differently
+	 * here.
+	 */
+	if (is_cgroup_event(event))
 		run_end = perf_event_time(event);
+	else if (ctx->is_active)
+		run_end = ctx->time;
 	else
 		run_end = event->tstamp_stopped;
 
@@ -299,6 +614,7 @@ static void update_event_times(struct perf_event *event)
 		run_end = perf_event_time(event);
 
 	event->total_time_running = run_end - event->tstamp_running;
+
 }
 
 /*
@@ -347,6 +663,17 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
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
@@ -473,6 +800,12 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 
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
@@ -542,9 +875,10 @@ out:
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
@@ -561,8 +895,8 @@ event_sched_out(struct perf_event *event,
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
@@ -720,6 +1054,7 @@ static void __perf_event_disable(void *info)
 	 */
 	if (event->state >= PERF_EVENT_STATE_INACTIVE) {
 		update_context_time(ctx);
+		update_cgrp_time_from_event(event);
 		update_group_times(event);
 		if (event == event->group_leader)
 			group_sched_out(event, cpuctx, ctx);
@@ -782,6 +1117,41 @@ retry:
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
@@ -807,7 +1177,7 @@ event_sched_in(struct perf_event *event,
 
 	event->tstamp_running += tstamp - event->tstamp_stopped;
 
-	event->shadow_ctx_time = tstamp - ctx->timestamp;
+	perf_set_shadow_time(event, ctx, tstamp);
 
 	if (!is_software_event(event))
 		cpuctx->active_oncpu++;
@@ -923,9 +1293,9 @@ static void add_event_to_ctx(struct perf_event *event,
 
 	list_add_event(event, ctx);
 	perf_group_attach(event);
-	event->tstamp_enabled = tstamp;
 	event->tstamp_running = tstamp;
 	event->tstamp_stopped = tstamp;
+	event->tstamp_enabled = tstamp;
 }
 
 /*
@@ -957,10 +1327,16 @@ static void __perf_install_in_context(void *info)
 	raw_spin_lock(&ctx->lock);
 	ctx->is_active = 1;
 	update_context_time(ctx);
+	/*
+	 * update cgrp time only if current cgrp
+	 * matches event->cgrp. Must be done before
+	 * calling add_event_to_ctx()
+	 */
+	update_cgrp_time_from_event(event);
 
 	add_event_to_ctx(event, ctx);
 
-	if (!event_filter_match(event))
+	if (!event_filter_match(event, current))
 		goto unlock;
 
 	/*
@@ -1102,10 +1478,19 @@ static void __perf_event_enable(void *info)
 
 	if (event->state >= PERF_EVENT_STATE_INACTIVE)
 		goto unlock;
+
+	/*
+	 * set current task's cgroup time reference point
+	 */
+	perf_cgroup_set_timestamp(current, perf_clock());
+
 	__perf_event_mark_enabled(event, ctx);
 
-	if (!event_filter_match(event))
+	if (!event_filter_match(event, current)) {
+		if (is_cgroup_event(event))
+			perf_cgroup_defer_enabled(event, current);
 		goto unlock;
+	}
 
 	/*
 	 * If the event is in a group and isn't the group leader,
@@ -1227,6 +1612,7 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 	if (likely(!ctx->nr_events))
 		goto out;
 	update_context_time(ctx);
+	update_cgrp_time_from_task(current);
 
 	if (!ctx->nr_active)
 		goto out;
@@ -1416,6 +1802,14 @@ void __perf_event_task_sched_out(struct task_struct *task,
 
 	for_each_task_context_nr(ctxn)
 		perf_event_context_sched_out(task, ctxn, next);
+
+	/*
+	 * if cgroup events exist on this CPU, then we need
+	 * to check if we have to switch out PMU state.
+	 * cgroup event are system-wide mode only
+	 */
+	if (atomic_read(&__get_cpu_var(perf_cgroup_events)))
+		perf_cgroup_sched_out(task);
 }
 
 static void task_ctx_sched_out(struct perf_event_context *ctx,
@@ -1444,16 +1838,21 @@ static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
 
 static void
 ctx_pinned_sched_in(struct perf_event_context *ctx,
-		    struct perf_cpu_context *cpuctx)
+		    struct perf_cpu_context *cpuctx,
+		    struct task_struct *task, int cgrp_sw)
 {
 	struct perf_event *event;
 
 	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
 		if (event->state <= PERF_EVENT_STATE_OFF)
 			continue;
-		if (!event_filter_match(event))
+		if (!event_filter_match(event, task))
 			continue;
 
+		/* may need to reset tstamp_enabled */
+		if (is_cgroup_event(event))
+			perf_cgroup_mark_enabled(event, ctx);
+
 		if (group_can_go_on(event, cpuctx, 1))
 			group_sched_in(event, cpuctx, ctx);
 
@@ -1470,7 +1869,8 @@ ctx_pinned_sched_in(struct perf_event_context *ctx,
 
 static void
 ctx_flexible_sched_in(struct perf_event_context *ctx,
-		      struct perf_cpu_context *cpuctx)
+		      struct perf_cpu_context *cpuctx,
+		      struct task_struct *task, int cgrp_sw)
 {
 	struct perf_event *event;
 	int can_add_hw = 1;
@@ -1483,9 +1883,13 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
 		 * Listen to the 'cpu' scheduling filter constraint
 		 * of events:
 		 */
-		if (!event_filter_match(event))
+		if (!event_filter_match(event, task))
 			continue;
 
+		/* may need to reset tstamp_enabled */
+		if (is_cgroup_event(event))
+			perf_cgroup_mark_enabled(event, ctx);
+
 		if (group_can_go_on(event, cpuctx, can_add_hw)) {
 			if (group_sched_in(event, cpuctx, ctx))
 				can_add_hw = 0;
@@ -1496,36 +1900,41 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
 static void
 ctx_sched_in(struct perf_event_context *ctx,
 	     struct perf_cpu_context *cpuctx,
-	     enum event_type_t event_type)
+	     enum event_type_t event_type,
+	     struct task_struct *task, int cgrp_sw)
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
+		ctx_pinned_sched_in(ctx, cpuctx, task, cgrp_sw);
 
 	/* Then walk through the lower prio flexible groups */
 	if (event_type & EVENT_FLEXIBLE)
-		ctx_flexible_sched_in(ctx, cpuctx);
+		ctx_flexible_sched_in(ctx, cpuctx, task, cgrp_sw);
 
 out:
 	raw_spin_unlock(&ctx->lock);
 }
 
 static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
-			     enum event_type_t event_type)
+			     enum event_type_t event_type,
+			     struct task_struct *task, int cgrp_sw)
 {
 	struct perf_event_context *ctx = &cpuctx->ctx;
 
-	ctx_sched_in(ctx, cpuctx, event_type);
+	ctx_sched_in(ctx, cpuctx, event_type, task, cgrp_sw);
 }
 
 static void task_ctx_sched_in(struct perf_event_context *ctx,
@@ -1537,11 +1946,12 @@ static void task_ctx_sched_in(struct perf_event_context *ctx,
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
 
@@ -1557,9 +1967,9 @@ void perf_event_context_sched_in(struct perf_event_context *ctx)
 	 */
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 
-	ctx_sched_in(ctx, cpuctx, EVENT_PINNED);
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
-	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE);
+	ctx_sched_in(ctx, cpuctx, EVENT_PINNED, task, 0);
+	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, task, 0);
+	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE, task, 0);
 
 	cpuctx->task_ctx = ctx;
 
@@ -1592,8 +2002,15 @@ void __perf_event_task_sched_in(struct task_struct *task)
 		if (likely(!ctx))
 			continue;
 
-		perf_event_context_sched_in(ctx);
+		perf_event_context_sched_in(ctx, task);
 	}
+	/*
+	 * if cgroup events exist on this CPU, then we need
+	 * to check if we have to switch in PMU state.
+	 * cgroup event are system-wide mode only
+	 */
+	if (atomic_read(&__get_cpu_var(perf_cgroup_events)))
+		perf_cgroup_sched_in(task);
 }
 
 #define MAX_INTERRUPTS (~0ULL)
@@ -1710,7 +2127,7 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
 
-		if (!event_filter_match(event))
+		if (!event_filter_match(event, current))
 			continue;
 
 		hwc = &event->hw;
@@ -1768,9 +2185,10 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
 	struct perf_event_context *ctx = NULL;
 	int rotate = 0, remove = 1;
 
-	if (cpuctx->ctx.nr_events) {
+	ctx = &cpuctx->ctx;
+	if (ctx->nr_events) {
 		remove = 0;
-		if (cpuctx->ctx.nr_events != cpuctx->ctx.nr_active)
+		if (ctx->nr_events != ctx->nr_active)
 			rotate = 1;
 	}
 
@@ -1797,7 +2215,7 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
 	if (ctx)
 		rotate_ctx(ctx);
 
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
+	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, current, 0);
 	if (ctx)
 		task_ctx_sched_in(ctx, EVENT_FLEXIBLE);
 
@@ -1876,7 +2294,7 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 
 	raw_spin_unlock(&ctx->lock);
 
-	perf_event_context_sched_in(ctx);
+	perf_event_context_sched_in(ctx, ctx->task);
 out:
 	local_irq_restore(flags);
 }
@@ -1902,6 +2320,7 @@ static void __perf_event_read(void *info)
 
 	raw_spin_lock(&ctx->lock);
 	update_context_time(ctx);
+	update_cgrp_time_from_event(event);
 	update_event_times(event);
 	raw_spin_unlock(&ctx->lock);
 
@@ -1932,8 +2351,10 @@ static u64 perf_event_read(struct perf_event *event)
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
@@ -2312,7 +2733,7 @@ static void free_event(struct perf_event *event)
 
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
-			jump_label_dec(&perf_task_events);
+			jump_label_dec(&perf_sched_events);
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_dec(&nr_mmap_events);
 		if (event->attr.comm)
@@ -2328,6 +2749,9 @@ static void free_event(struct perf_event *event)
 		event->buffer = NULL;
 	}
 
+	if (is_cgroup_event(event))
+		perf_detach_cgroup(event);
+
 	if (event->destroy)
 		event->destroy(event);
 
@@ -3912,7 +4336,7 @@ static int perf_event_task_match(struct perf_event *event)
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (!event_filter_match(event))
+	if (!event_filter_match(event, current))
 		return 0;
 
 	if (event->attr.comm || event->attr.mmap ||
@@ -4049,7 +4473,7 @@ static int perf_event_comm_match(struct perf_event *event)
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (!event_filter_match(event))
+	if (!event_filter_match(event, current))
 		return 0;
 
 	if (event->attr.comm)
@@ -4197,7 +4621,7 @@ static int perf_event_mmap_match(struct perf_event *event,
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (!event_filter_match(event))
+	if (!event_filter_match(event, current))
 		return 0;
 
 	if ((!executable && event->attr.mmap_data) ||
@@ -5217,6 +5641,7 @@ static void task_clock_event_read(struct perf_event *event)
 
 	if (!in_nmi()) {
 		update_context_time(event->ctx);
+		update_cgrp_time_from_event(event);
 		time = event->ctx->time;
 	} else {
 		u64 now = perf_clock();
@@ -5639,7 +6064,7 @@ done:
 
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
-			jump_label_inc(&perf_task_events);
+			jump_label_inc(&perf_sched_events);
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_inc(&nr_mmap_events);
 		if (event->attr.comm)
@@ -5814,7 +6239,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	int err;
 
 	/* for future expandability... */
-	if (flags & ~(PERF_FLAG_FD_NO_GROUP | PERF_FLAG_FD_OUTPUT))
+	if (flags & ~PERF_FLAG_ALL)
 		return -EINVAL;
 
 	err = perf_copy_attr(attr_uptr, &attr);
@@ -5831,6 +6256,15 @@ SYSCALL_DEFINE5(perf_event_open,
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
@@ -5848,7 +6282,7 @@ SYSCALL_DEFINE5(perf_event_open,
 			group_leader = NULL;
 	}
 
-	if (pid != -1) {
+	if (pid != -1 && !(flags & PERF_FLAG_PID_CGROUP)) {
 		task = find_lively_task_by_vpid(pid);
 		if (IS_ERR(task)) {
 			err = PTR_ERR(task);
@@ -5862,6 +6296,12 @@ SYSCALL_DEFINE5(perf_event_open,
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
@@ -6718,3 +7158,49 @@ unlock:
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

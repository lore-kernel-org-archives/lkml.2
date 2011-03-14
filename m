Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab1CNTSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:18:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56486 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004Ab1CNTSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:18:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=L2MhK3L3LFhHUnaVn140cWvIHsUHIhZ3apQ2c+2PSmAuKy0tSFdEwIdI68nYPAP3H6
         djgOQkRW24/oVuW2s0LMQc1Q5quxX/26n4RnSiL3mHMPPac15VbKLtJBmUcuZ+5ASV8h
         etJaW26QcHrxiCKLUCjuyoqD+AMvZP7QuBCNY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: [RFC PATCH 1/4] perf: Starter and stopper events
Date: Mon, 14 Mar 2011 20:18:00 +0100
Message-Id: <1300130283-10466-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
References: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current event contexts are limited to the task and/or cpu scope.
However perf has a bunch of meaningful events on top of which
one could create his own custom contexts on top of the task
and/or cpu ones.

Starter and stopper events provide this custom context granularity.
One can create an event and attribute it a starter and a stopper. The
starter, when it triggers an event, starts the target perf event
(using the lightweight pmu->start() callback) and the stopper does the
reverse. The target will then only count and sample inside the
boundaries created by the starter and stopper when they overflow.

This creates two new ioctls:

- PERF_EVENT_IOC_SET_STARTER
- PERF_EVENT_IOC_SET_STOPPER

An event can have only one starter and one stopper which can't be
changed once attributed.

But an event can be a starter or a stopper of as many events it
wants as far as they belong to the same task and cpu context.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
---
 include/linux/perf_event.h |   11 ++-
 kernel/perf_event.c        |  295 +++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 288 insertions(+), 18 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 614615b..3d33bb8 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -245,6 +245,8 @@ struct perf_event_attr {
 #define PERF_EVENT_IOC_PERIOD		_IOW('$', 4, __u64)
 #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
 #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
+#define PERF_EVENT_IOC_SET_STARTER	_IO('$', 7)
+#define PERF_EVENT_IOC_SET_STOPPER	_IO('$', 8)
 
 enum perf_event_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
@@ -863,7 +865,14 @@ struct perf_event {
 	struct perf_cgroup		*cgrp; /* cgroup event is attach to */
 	int				cgrp_defer_enabled;
 #endif
-
+	struct mutex			starter_stopper_mutex;
+	struct list_head		starter_entry;
+	struct list_head		stopper_entry;
+	struct list_head		starter_list;
+	struct list_head		stopper_list;
+	struct perf_event		*starter;
+	struct perf_event		*stopper;
+	int				paused;
 #endif /* CONFIG_PERF_EVENTS */
 };
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 533f715..c58ee74 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1299,6 +1299,7 @@ event_sched_in(struct perf_event *event,
 		 struct perf_event_context *ctx)
 {
 	u64 tstamp = perf_event_time(event);
+	int add_flags = PERF_EF_START;
 
 	if (event->state <= PERF_EVENT_STATE_OFF)
 		return 0;
@@ -1321,7 +1322,10 @@ event_sched_in(struct perf_event *event,
 	 */
 	smp_wmb();
 
-	if (event->pmu->add(event, PERF_EF_START)) {
+	if (event->paused)
+		add_flags = 0;
+
+	if (event->pmu->add(event, add_flags)) {
 		event->state = PERF_EVENT_STATE_INACTIVE;
 		event->oncpu = -1;
 		return -EAGAIN;
@@ -2918,6 +2922,7 @@ static void free_event(struct perf_event *event)
 int perf_event_release_kernel(struct perf_event *event)
 {
 	struct perf_event_context *ctx = event->ctx;
+	struct perf_event *state_event;
 
 	/*
 	 * Remove from the PMU, can't get re-enabled since we got
@@ -2945,6 +2950,20 @@ int perf_event_release_kernel(struct perf_event *event)
 	raw_spin_unlock_irq(&ctx->lock);
 	mutex_unlock(&ctx->mutex);
 
+	if (event->starter) {
+		state_event = event->starter;
+		mutex_lock(&state_event->starter_stopper_mutex);
+		list_del_rcu(&event->starter_entry);
+		mutex_unlock(&state_event->starter_stopper_mutex);
+	}
+
+	if (event->stopper) {
+		state_event = event->stopper;
+		mutex_lock(&state_event->starter_stopper_mutex);
+		list_del_rcu(&event->stopper_entry);
+		mutex_unlock(&state_event->starter_stopper_mutex);
+	}
+
 	free_event(event);
 
 	return 0;
@@ -3246,6 +3265,73 @@ static struct perf_event *perf_fget_light(int fd, int *fput_needed)
 static int perf_event_set_output(struct perf_event *event,
 				 struct perf_event *output_event);
 static int perf_event_set_filter(struct perf_event *event, void __user *arg);
+static void perf_event_pause_resume(struct perf_event *event, int nmi,
+				    struct perf_sample_data *data,
+				    struct pt_regs *regs);
+
+static int perf_event_set_starter(struct perf_event *event,
+				  struct perf_event *target)
+{
+	struct perf_event *iter;
+	int err = 0;
+
+	if (event->ctx->task != target->ctx->task ||
+	    event->cpu != target->cpu)
+		return -EINVAL;
+
+	mutex_lock(&event->starter_stopper_mutex);
+
+	list_for_each_entry_rcu(iter, &event->starter_list, starter_entry) {
+		if (iter == target) {
+			err = -EEXIST;
+			goto end;
+		}
+	}
+
+	if (cmpxchg(&target->starter, NULL, event) == NULL) {
+		list_add_rcu(&target->starter_entry, &event->starter_list);
+		event->overflow_handler = perf_event_pause_resume;
+	} else {
+		err = -EBUSY;
+	}
+
+ end:
+	mutex_unlock(&event->starter_stopper_mutex);
+
+	return err;
+}
+
+static int perf_event_set_stopper(struct perf_event *event,
+				  struct perf_event *target)
+{
+	struct perf_event *iter;
+	int err = 0;
+
+	if (event->ctx->task != target->ctx->task ||
+	    event->cpu != target->cpu)
+		return -EINVAL;
+
+	mutex_lock(&event->starter_stopper_mutex);
+
+	list_for_each_entry_rcu(iter, &event->stopper_list, stopper_entry) {
+		if (iter == target) {
+			err = -EEXIST;
+			goto end;
+		}
+	}
+
+	if (cmpxchg(&target->stopper, NULL, event) == NULL) {
+		list_add_rcu(&target->stopper_entry, &event->stopper_list);
+		event->overflow_handler = perf_event_pause_resume;
+	} else {
+		err = -EBUSY;
+	}
+
+ end:
+	mutex_unlock(&event->starter_stopper_mutex);
+
+	return err;
+}
 
 static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
@@ -3292,6 +3378,44 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case PERF_EVENT_IOC_SET_FILTER:
 		return perf_event_set_filter(event, (void __user *)arg);
 
+	case PERF_EVENT_IOC_SET_STARTER:
+	{
+		struct perf_event *target = NULL;
+		int fput_needed = 0;
+		int ret;
+
+		if (arg != -1) {
+			target = perf_fget_light(arg, &fput_needed);
+			if (IS_ERR(target))
+				return PTR_ERR(target);
+		}
+
+		ret = perf_event_set_starter(event, target);
+		if (target)
+			fput_light(target->filp, fput_needed);
+
+		return ret;
+	}
+
+	case PERF_EVENT_IOC_SET_STOPPER:
+	{
+		struct perf_event *target = NULL;
+		int fput_needed = 0;
+		int ret;
+
+		if (arg != -1) {
+			target = perf_fget_light(arg, &fput_needed);
+			if (IS_ERR(target))
+				return PTR_ERR(target);
+		}
+
+		ret = perf_event_set_stopper(event, target);
+		if (target)
+			fput_light(target->filp, fput_needed);
+
+		return ret;
+	}
+
 	default:
 		return -ENOTTY;
 	}
@@ -5017,12 +5141,62 @@ static int __perf_event_overflow(struct perf_event *event, int nmi,
 }
 
 int perf_event_overflow(struct perf_event *event, int nmi,
-			  struct perf_sample_data *data,
-			  struct pt_regs *regs)
+			struct perf_sample_data *data,
+			struct pt_regs *regs)
 {
 	return __perf_event_overflow(event, nmi, 1, data, regs);
 }
 
+static void perf_event_pause_resume(struct perf_event *event, int nmi,
+				    struct perf_sample_data *data,
+				    struct pt_regs *regs)
+{
+	struct perf_event *iter;
+	unsigned long flags;
+
+	/*
+	 * Ensure the targets can't be sched in/out concurrently.
+	 * Disabling irqs is sufficient for that because starters/stoppers
+	 * are on the same cpu/task.
+	 */
+	local_irq_save(flags);
+
+
+	/* Prevent the targets from being removed under us. */
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(iter, &event->starter_list, starter_entry) {
+		/*
+		 * There is a small race window here, between the state
+		 * gets set to active and the event is actually ->add().
+		 * We need to find a way to ensure the starter/stopper
+		 * can't trigger in between.
+		 */
+		if (iter->state == PERF_EVENT_STATE_ACTIVE) {
+			if (iter->paused) {
+				iter->pmu->start(iter, PERF_EF_RELOAD);
+				iter->paused = 0;
+			}
+		}
+	}
+
+	list_for_each_entry_rcu(iter, &event->stopper_list, stopper_entry) {
+		/* Similar race with ->del() */
+		if (iter->state == PERF_EVENT_STATE_ACTIVE) {
+			if (!iter->paused) {
+				iter->pmu->stop(iter, PERF_EF_UPDATE);
+				iter->paused = 1;
+			}
+		}
+	}
+
+	rcu_read_unlock();
+
+	local_irq_restore(flags);
+
+	perf_event_output(event, nmi, data, regs);
+}
+
 /*
  * Generic software event infrastructure
  */
@@ -6164,6 +6338,11 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	INIT_LIST_HEAD(&event->group_entry);
 	INIT_LIST_HEAD(&event->event_entry);
 	INIT_LIST_HEAD(&event->sibling_list);
+
+	mutex_init(&event->starter_stopper_mutex);
+	INIT_LIST_HEAD(&event->starter_list);
+	INIT_LIST_HEAD(&event->stopper_list);
+
 	init_waitqueue_head(&event->waitq);
 	init_irq_work(&event->pending, perf_pending_event);
 
@@ -6916,7 +7095,8 @@ inherit_event(struct perf_event *parent_event,
 	      struct perf_event_context *parent_ctx,
 	      struct task_struct *child,
 	      struct perf_event *group_leader,
-	      struct perf_event_context *child_ctx)
+	      struct perf_event_context *child_ctx,
+	      int *triggers)
 {
 	struct perf_event *child_event;
 	unsigned long flags;
@@ -6930,6 +7110,9 @@ inherit_event(struct perf_event *parent_event,
 	if (parent_event->parent)
 		parent_event = parent_event->parent;
 
+	if (parent_event->starter || parent_event->stopper)
+		*triggers = 1;
+
 	child_event = perf_event_alloc(&parent_event->attr,
 					   parent_event->cpu,
 					   child,
@@ -6995,22 +7178,23 @@ inherit_event(struct perf_event *parent_event,
 }
 
 static int inherit_group(struct perf_event *parent_event,
-	      struct task_struct *parent,
-	      struct perf_event_context *parent_ctx,
-	      struct task_struct *child,
-	      struct perf_event_context *child_ctx)
+			 struct task_struct *parent,
+			 struct perf_event_context *parent_ctx,
+			 struct task_struct *child,
+			 struct perf_event_context *child_ctx,
+			 int *triggers)
 {
 	struct perf_event *leader;
 	struct perf_event *sub;
 	struct perf_event *child_ctr;
 
 	leader = inherit_event(parent_event, parent, parent_ctx,
-				 child, NULL, child_ctx);
+			       child, NULL, child_ctx, triggers);
 	if (IS_ERR(leader))
 		return PTR_ERR(leader);
 	list_for_each_entry(sub, &parent_event->sibling_list, group_entry) {
 		child_ctr = inherit_event(sub, parent, parent_ctx,
-					    child, leader, child_ctx);
+					  child, leader, child_ctx, triggers);
 		if (IS_ERR(child_ctr))
 			return PTR_ERR(child_ctr);
 	}
@@ -7021,7 +7205,7 @@ static int
 inherit_task_group(struct perf_event *event, struct task_struct *parent,
 		   struct perf_event_context *parent_ctx,
 		   struct task_struct *child, int ctxn,
-		   int *inherited_all)
+		   int *inherited_all, int *triggers)
 {
 	int ret;
 	struct perf_event_context *child_ctx;
@@ -7048,7 +7232,7 @@ inherit_task_group(struct perf_event *event, struct task_struct *parent,
 	}
 
 	ret = inherit_group(event, parent, parent_ctx,
-			    child, child_ctx);
+			    child, child_ctx, triggers);
 
 	if (ret)
 		*inherited_all = 0;
@@ -7059,7 +7243,7 @@ inherit_task_group(struct perf_event *event, struct task_struct *parent,
 /*
  * Initialize the perf_event context in task_struct
  */
-int perf_event_init_context(struct task_struct *child, int ctxn)
+int perf_event_init_context(struct task_struct *child, int ctxn, int *triggers)
 {
 	struct perf_event_context *child_ctx, *parent_ctx;
 	struct perf_event_context *cloned_ctx;
@@ -7097,7 +7281,8 @@ int perf_event_init_context(struct task_struct *child, int ctxn)
 	 */
 	list_for_each_entry(event, &parent_ctx->pinned_groups, group_entry) {
 		ret = inherit_task_group(event, parent, parent_ctx,
-					 child, ctxn, &inherited_all);
+					 child, ctxn, &inherited_all,
+					 triggers);
 		if (ret)
 			break;
 	}
@@ -7113,7 +7298,8 @@ int perf_event_init_context(struct task_struct *child, int ctxn)
 
 	list_for_each_entry(event, &parent_ctx->flexible_groups, group_entry) {
 		ret = inherit_task_group(event, parent, parent_ctx,
-					 child, ctxn, &inherited_all);
+					 child, ctxn, &inherited_all,
+					 triggers);
 		if (ret)
 			break;
 	}
@@ -7151,23 +7337,98 @@ int perf_event_init_context(struct task_struct *child, int ctxn)
 	return ret;
 }
 
+static void
+perf_event_inherit_starter(struct task_struct *child,
+			   struct perf_event *event,
+			   struct perf_event *parent_starter)
+{
+	int ctxn;
+	struct perf_event *iter;
+	struct perf_event_context *ctx;
+
+	ctxn = parent_starter->pmu->task_ctx_nr;
+	ctx = child->perf_event_ctxp[ctxn];
+
+	if (WARN_ON_ONCE(!ctx))
+		return;
+
+	list_for_each_entry(iter, &ctx->event_list, event_entry) {
+		if (iter->parent == parent_starter) {
+			list_add_tail(&event->starter_entry, &iter->starter_list);
+			return;
+		}
+	}
+
+	WARN_ONCE(1, "inherited starter not found\n");
+}
+
+static void
+perf_event_inherit_stopper(struct task_struct *child,
+			   struct perf_event *event,
+			   struct perf_event *parent_stopper)
+{
+	int ctxn;
+	struct perf_event *iter;
+	struct perf_event_context *ctx;
+
+	ctxn = parent_stopper->pmu->task_ctx_nr;
+	ctx = child->perf_event_ctxp[ctxn];
+
+	if (WARN_ON_ONCE(!ctx))
+		return;
+
+	list_for_each_entry(iter, &ctx->event_list, event_entry) {
+		if (iter->parent == parent_stopper) {
+			list_add_tail(&event->stopper_entry, &iter->stopper_list);
+			return;
+		}
+	}
+
+	WARN_ONCE(1, "inherited stopper not found\n");
+}
+
+
+static void
+perf_event_inherit_triggers(struct task_struct *child, int ctxn)
+{
+	struct perf_event_context *ctx;
+	struct perf_event *event;
+
+	ctx = child->perf_event_ctxp[ctxn];
+	if (!ctx)
+		return;
+
+	list_for_each_entry(event, &ctx->event_list, event_entry) {
+		if (event->parent->starter)
+			perf_event_inherit_starter(child, event, event->parent->starter);
+		if (event->parent->stopper)
+			perf_event_inherit_stopper(child, event, event->parent->stopper);
+	}
+}
+
+
 /*
  * Initialize the perf_event context in task_struct
  */
 int perf_event_init_task(struct task_struct *child)
 {
-	int ctxn, ret;
+	int ctxn, ret, triggers = 0;
 
 	memset(child->perf_event_ctxp, 0, sizeof(child->perf_event_ctxp));
 	mutex_init(&child->perf_event_mutex);
 	INIT_LIST_HEAD(&child->perf_event_list);
 
 	for_each_task_context_nr(ctxn) {
-		ret = perf_event_init_context(child, ctxn);
+		ret = perf_event_init_context(child, ctxn, &triggers);
 		if (ret)
 			return ret;
 	}
 
+	if (triggers) {
+		for_each_task_context_nr(ctxn)
+			perf_event_inherit_triggers(child, ctxn);
+	}
+
 	return 0;
 }
 
-- 
1.7.3.2


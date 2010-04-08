Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231Ab0DHTja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:39:30 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52477 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933028Ab0DHTjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:39:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BDm/wy1u/iTt2gAzMgozyVo0D5ZUNHpyjaRR078/o5PcCpXgyoXPe/o2bFOnVe8Z1O
         6Re995syysEqe0f2IBCC7UpXRrOmxW3e9Fj5rcVT7pxr6i1xYdlbEPBSPpauQ2yRxYE7
         gB7sn+xGKzaaIPE6slKxw3E9LoxygmCofYH2g=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v2] perf: Store active software events in a hashlist
Date: Thu,  8 Apr 2010 21:39:14 +0200
Message-Id: <1270755554-6618-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1270642150.20295.831.camel@laptop>
References: <1270642150.20295.831.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each time a software event triggers, we need to walk through
the entire list of events from the current cpu and task contexts
to retrieve a running perf event that matches.
We also need to check a matching perf event is actually counting.

This walk is wasteful and makes the event fast path scaling
down with a growing number of events running on the same
contexts.

To solve this, we store the running perf events in a hashlist to
get an immediate access to them against their type:event_id when
they trigger.

v2: - Fix SWEVENT_HLIST_SIZE definition (and re-learn some basic
      maths along the way)
    - Only allocate hlist for online cpus, but keep track of the
      refcount on offline possible cpus too, so that we allocate it
      if needed when it becomes online.
    - Drop the kref use as it's not adapted to our tricks anymore.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |   12 ++
 kernel/perf_event.c        |  251 +++++++++++++++++++++++++++++++++-----------
 2 files changed, 200 insertions(+), 63 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 6e96cc8..bf896d0 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -589,6 +589,14 @@ enum perf_group_flag {
 	PERF_GROUP_SOFTWARE = 0x1,
 };
 
+#define SWEVENT_HLIST_BITS	8
+#define SWEVENT_HLIST_SIZE	(1 << SWEVENT_HLIST_BITS)
+
+struct swevent_hlist {
+	struct hlist_head	heads[SWEVENT_HLIST_SIZE];
+	struct rcu_head		rcu_head;
+};
+
 /**
  * struct perf_event - performance event kernel representation:
  */
@@ -597,6 +605,7 @@ struct perf_event {
 	struct list_head		group_entry;
 	struct list_head		event_entry;
 	struct list_head		sibling_list;
+	struct hlist_node		hlist_entry;
 	int				nr_siblings;
 	int				group_flags;
 	struct perf_event		*group_leader;
@@ -744,6 +753,9 @@ struct perf_cpu_context {
 	int				active_oncpu;
 	int				max_pertask;
 	int				exclusive;
+	struct swevent_hlist		*swevent_hlist;
+	struct mutex			hlist_mutex;
+	int				hlist_refcount;
 
 	/*
 	 * Recursion avoidance:
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 4aa50ff..c953cfb 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -15,6 +15,7 @@
 #include <linux/smp.h>
 #include <linux/file.h>
 #include <linux/poll.h>
+#include <linux/hash.h>
 #include <linux/sysfs.h>
 #include <linux/dcache.h>
 #include <linux/percpu.h>
@@ -3965,36 +3966,6 @@ static void perf_swevent_add(struct perf_event *event, u64 nr,
 	perf_swevent_overflow(event, 0, nmi, data, regs);
 }
 
-static int perf_swevent_is_counting(struct perf_event *event)
-{
-	/*
-	 * The event is active, we're good!
-	 */
-	if (event->state == PERF_EVENT_STATE_ACTIVE)
-		return 1;
-
-	/*
-	 * The event is off/error, not counting.
-	 */
-	if (event->state != PERF_EVENT_STATE_INACTIVE)
-		return 0;
-
-	/*
-	 * The event is inactive, if the context is active
-	 * we're part of a group that didn't make it on the 'pmu',
-	 * not counting.
-	 */
-	if (event->ctx->is_active)
-		return 0;
-
-	/*
-	 * We're inactive and the context is too, this means the
-	 * task is scheduled out, we're counting events that happen
-	 * to us, like migration events.
-	 */
-	return 1;
-}
-
 static int perf_tp_event_match(struct perf_event *event,
 				struct perf_sample_data *data);
 
@@ -4018,12 +3989,6 @@ static int perf_swevent_match(struct perf_event *event,
 				struct perf_sample_data *data,
 				struct pt_regs *regs)
 {
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
-		return 0;
-
-	if (!perf_swevent_is_counting(event))
-		return 0;
-
 	if (event->attr.type != type)
 		return 0;
 
@@ -4040,18 +4005,53 @@ static int perf_swevent_match(struct perf_event *event,
 	return 1;
 }
 
-static void perf_swevent_ctx_event(struct perf_event_context *ctx,
-				     enum perf_type_id type,
-				     u32 event_id, u64 nr, int nmi,
-				     struct perf_sample_data *data,
-				     struct pt_regs *regs)
+static inline u64 swevent_hash(u64 type, u32 event_id)
 {
+	u64 val = event_id | (type << 32);
+
+	return hash_64(val, SWEVENT_HLIST_BITS);
+}
+
+static struct hlist_head *
+find_swevent_head(struct perf_cpu_context *ctx, u64 type, u32 event_id)
+{
+	u64 hash;
+	struct swevent_hlist *hlist;
+
+	hash = swevent_hash(type, event_id);
+
+	hlist = rcu_dereference(ctx->swevent_hlist);
+	if (!hlist)
+		return NULL;
+
+	return &hlist->heads[hash];
+}
+
+static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
+				    u64 nr, int nmi,
+				    struct perf_sample_data *data,
+				    struct pt_regs *regs)
+{
+	struct perf_cpu_context *cpuctx;
 	struct perf_event *event;
+	struct hlist_node *node;
+	struct hlist_head *head;
 
-	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
+	cpuctx = &__get_cpu_var(perf_cpu_context);
+
+	rcu_read_lock();
+
+	head = find_swevent_head(cpuctx, type, event_id);
+
+	if (!head)
+		goto end;
+
+	hlist_for_each_entry_rcu(event, node, head, hlist_entry) {
 		if (perf_swevent_match(event, type, event_id, data, regs))
 			perf_swevent_add(event, nr, nmi, data, regs);
 	}
+end:
+	rcu_read_unlock();
 }
 
 int perf_swevent_get_recursion_context(void)
@@ -4089,27 +4089,6 @@ void perf_swevent_put_recursion_context(int rctx)
 }
 EXPORT_SYMBOL_GPL(perf_swevent_put_recursion_context);
 
-static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
-				    u64 nr, int nmi,
-				    struct perf_sample_data *data,
-				    struct pt_regs *regs)
-{
-	struct perf_cpu_context *cpuctx;
-	struct perf_event_context *ctx;
-
-	cpuctx = &__get_cpu_var(perf_cpu_context);
-	rcu_read_lock();
-	perf_swevent_ctx_event(&cpuctx->ctx, type, event_id,
-				 nr, nmi, data, regs);
-	/*
-	 * doesn't really matter which of the child contexts the
-	 * events ends up in.
-	 */
-	ctx = rcu_dereference(current->perf_event_ctxp);
-	if (ctx)
-		perf_swevent_ctx_event(ctx, type, event_id, nr, nmi, data, regs);
-	rcu_read_unlock();
-}
 
 void __perf_sw_event(u32 event_id, u64 nr, int nmi,
 			    struct pt_regs *regs, u64 addr)
@@ -4135,16 +4114,28 @@ static void perf_swevent_read(struct perf_event *event)
 static int perf_swevent_enable(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
+	struct perf_cpu_context *cpuctx;
+	struct hlist_head *head;
+
+	cpuctx = &__get_cpu_var(perf_cpu_context);
 
 	if (hwc->sample_period) {
 		hwc->last_period = hwc->sample_period;
 		perf_swevent_set_period(event);
 	}
+
+	head = find_swevent_head(cpuctx, event->attr.type, event->attr.config);
+	if (WARN_ON_ONCE(!head))
+		return -EINVAL;
+
+	hlist_add_head_rcu(&event->hlist_entry, head);
+
 	return 0;
 }
 
 static void perf_swevent_disable(struct perf_event *event)
 {
+	hlist_del_rcu(&event->hlist_entry);
 }
 
 static const struct pmu perf_ops_generic = {
@@ -4358,13 +4349,115 @@ static int perf_tp_event_match(struct perf_event *event,
 	return 0;
 }
 
+static void swevent_hlist_release_rcu(struct rcu_head *rcu_head)
+{
+	struct swevent_hlist *hlist;
+
+	hlist = container_of(rcu_head, struct swevent_hlist, rcu_head);
+	kfree(hlist);
+}
+
+static void swevent_hlist_release(struct perf_cpu_context *cpuctx)
+{
+	struct swevent_hlist *hlist;
+
+	if (!cpuctx->swevent_hlist)
+		return;
+
+	hlist = cpuctx->swevent_hlist;
+	rcu_assign_pointer(cpuctx->swevent_hlist, NULL);
+	call_rcu(&hlist->rcu_head, swevent_hlist_release_rcu);
+}
+
+static void swevent_hlist_put_cpu(struct perf_event *event, int cpu)
+{
+	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
+
+	mutex_lock(&cpuctx->hlist_mutex);
+
+	if (!--cpuctx->hlist_refcount)
+		swevent_hlist_release(cpuctx);
+
+	mutex_unlock(&cpuctx->hlist_mutex);
+}
+
+static void swevent_hlist_put(struct perf_event *event)
+{
+	int cpu;
+
+	if (event->cpu != -1) {
+		swevent_hlist_put_cpu(event, event->cpu);
+		return;
+	}
+
+	for_each_possible_cpu(cpu)
+		swevent_hlist_put_cpu(event, cpu);
+}
+
+static int swevent_hlist_get_cpu(struct perf_event *event, int cpu)
+{
+	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
+	int err = 0;
+
+	mutex_lock(&cpuctx->hlist_mutex);
+
+	if (!cpuctx->swevent_hlist && cpu_online(cpu)) {
+		struct swevent_hlist *hlist;
+
+		hlist = kzalloc(sizeof(*hlist), GFP_KERNEL);
+		if (!hlist) {
+			err = -ENOMEM;
+			goto exit;
+		}
+		rcu_assign_pointer(cpuctx->swevent_hlist, hlist);
+	}
+	cpuctx->hlist_refcount++;
+ exit:
+	mutex_unlock(&cpuctx->hlist_mutex);
+
+	return err;
+}
+
+static int swevent_hlist_get(struct perf_event *event)
+{
+	int err;
+	int cpu, failed_cpu;
+
+	if (event->cpu != -1)
+		return swevent_hlist_get_cpu(event, event->cpu);
+
+	get_online_cpus();
+	for_each_possible_cpu(cpu) {
+		err = swevent_hlist_get_cpu(event, cpu);
+		if (err) {
+			failed_cpu = cpu;
+			goto fail;
+		}
+	}
+	put_online_cpus();
+
+	return 0;
+ fail:
+	for_each_possible_cpu(cpu) {
+		if (cpu == failed_cpu)
+			break;
+		swevent_hlist_put_cpu(event, cpu);
+	}
+
+	put_online_cpus();
+	return err;
+}
+
 static void tp_perf_event_destroy(struct perf_event *event)
 {
 	perf_trace_disable(event->attr.config);
+	swevent_hlist_put(event);
 }
 
 static const struct pmu *tp_perf_event_init(struct perf_event *event)
 {
+	int err;
+
 	/*
 	 * Raw tracepoint data is a severe data leak, only allow root to
 	 * have these.
@@ -4378,6 +4471,11 @@ static const struct pmu *tp_perf_event_init(struct perf_event *event)
 		return NULL;
 
 	event->destroy = tp_perf_event_destroy;
+	err = swevent_hlist_get(event);
+	if (err) {
+		perf_trace_disable(event->attr.config);
+		return ERR_PTR(err);
+	}
 
 	return &perf_ops_generic;
 }
@@ -4478,6 +4576,7 @@ static void sw_perf_event_destroy(struct perf_event *event)
 	WARN_ON(event->parent);
 
 	atomic_dec(&perf_swevent_enabled[event_id]);
+	swevent_hlist_put(event);
 }
 
 static const struct pmu *sw_perf_event_init(struct perf_event *event)
@@ -4516,6 +4615,12 @@ static const struct pmu *sw_perf_event_init(struct perf_event *event)
 	case PERF_COUNT_SW_ALIGNMENT_FAULTS:
 	case PERF_COUNT_SW_EMULATION_FAULTS:
 		if (!event->parent) {
+			int err;
+
+			err = swevent_hlist_get(event);
+			if (err)
+				return ERR_PTR(err);
+
 			atomic_inc(&perf_swevent_enabled[event_id]);
 			event->destroy = sw_perf_event_destroy;
 		}
@@ -5388,6 +5493,7 @@ static void __init perf_event_init_all_cpus(void)
 
 	for_each_possible_cpu(cpu) {
 		cpuctx = &per_cpu(perf_cpu_context, cpu);
+		mutex_init(&cpuctx->hlist_mutex);
 		__perf_event_init_context(&cpuctx->ctx, NULL);
 	}
 }
@@ -5401,6 +5507,16 @@ static void __cpuinit perf_event_init_cpu(int cpu)
 	spin_lock(&perf_resource_lock);
 	cpuctx->max_pertask = perf_max_events - perf_reserved_percpu;
 	spin_unlock(&perf_resource_lock);
+
+	mutex_lock(&cpuctx->hlist_mutex);
+	if (&cpuctx->hlist_refcount > 0) {
+		struct swevent_hlist *hlist;
+
+		hlist = kzalloc(sizeof(*hlist), GFP_KERNEL);
+		WARN_ON_ONCE(!hlist);
+		rcu_assign_pointer(cpuctx->swevent_hlist, hlist);
+	}
+	mutex_unlock(&cpuctx->hlist_mutex);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -5414,6 +5530,15 @@ static void __perf_event_exit_cpu(void *info)
 		__perf_event_remove_from_context(event);
 	list_for_each_entry_safe(event, tmp, &ctx->flexible_groups, group_entry)
 		__perf_event_remove_from_context(event);
+
+	mutex_lock(&cpuctx->hlist_mutex);
+	/*
+	 * We may have interrupted a triggering software event. So release
+	 * the hlist in an rcu safe fashion
+	 */
+	swevent_hlist_release(cpuctx);
+	mutex_unlock(&cpuctx->hlist_mutex);
+
 }
 static void perf_event_exit_cpu(int cpu)
 {
-- 
1.6.2.3


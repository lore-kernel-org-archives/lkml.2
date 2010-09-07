Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab0IGQ4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 12:56:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32837 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943Ab0IGQ4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:56:38 -0400
Message-Id: <20100907165011.890202348@chello.nl>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 18:46:45 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
        Robert Richter <robert.richter@amd.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Yanmin <yanmin_zhang@linux.intel.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 12/19] perf: Remove the swevent hash-table from the cpu context
References: <20100907164633.879932949@chello.nl>
Content-Disposition: inline; filename=perf-pmu-context-5.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate the swevent hash-table from the cpu_context bits in preparation
for per pmu cpu contexts.

This keeps the swevent hash a global entity.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |    6 --
 kernel/perf_event.c        |  104 +++++++++++++++++++++++++--------------------
 2 files changed, 58 insertions(+), 52 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -866,12 +866,6 @@ struct perf_cpu_context {
 	struct perf_event_context	*task_ctx;
 	int				active_oncpu;
 	int				exclusive;
-	struct swevent_hlist		*swevent_hlist;
-	struct mutex			hlist_mutex;
-	int				hlist_refcount;
-
-	/* Recursion avoidance in each contexts */
-	int				recursion[PERF_NR_CONTEXTS];
 };
 
 struct perf_output_handle {
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -4154,6 +4154,17 @@ int perf_event_overflow(struct perf_even
  * Generic software event infrastructure
  */
 
+struct swevent_htable {
+	struct swevent_hlist		*swevent_hlist;
+	struct mutex			hlist_mutex;
+	int				hlist_refcount;
+
+	/* Recursion avoidance in each contexts */
+	int				recursion[PERF_NR_CONTEXTS];
+};
+
+static DEFINE_PER_CPU(struct swevent_htable, swevent_htable);
+
 /*
  * We directly increment event->count and keep a second value in
  * event->hw.period_left to count intervals. This period event
@@ -4286,11 +4297,11 @@ __find_swevent_head(struct swevent_hlist
 
 /* For the read side: events when they trigger */
 static inline struct hlist_head *
-find_swevent_head_rcu(struct perf_cpu_context *ctx, u64 type, u32 event_id)
+find_swevent_head_rcu(struct swevent_htable *swhash, u64 type, u32 event_id)
 {
 	struct swevent_hlist *hlist;
 
-	hlist = rcu_dereference(ctx->swevent_hlist);
+	hlist = rcu_dereference(swhash->swevent_hlist);
 	if (!hlist)
 		return NULL;
 
@@ -4299,7 +4310,7 @@ find_swevent_head_rcu(struct perf_cpu_co
 
 /* For the event head insertion and removal in the hlist */
 static inline struct hlist_head *
-find_swevent_head(struct perf_cpu_context *ctx, struct perf_event *event)
+find_swevent_head(struct swevent_htable *swhash, struct perf_event *event)
 {
 	struct swevent_hlist *hlist;
 	u32 event_id = event->attr.config;
@@ -4310,7 +4321,7 @@ find_swevent_head(struct perf_cpu_contex
 	 * and release. Which makes the protected version suitable here.
 	 * The context lock guarantees that.
 	 */
-	hlist = rcu_dereference_protected(ctx->swevent_hlist,
+	hlist = rcu_dereference_protected(swhash->swevent_hlist,
 					  lockdep_is_held(&event->ctx->lock));
 	if (!hlist)
 		return NULL;
@@ -4323,17 +4334,13 @@ static void do_perf_sw_event(enum perf_t
 				    struct perf_sample_data *data,
 				    struct pt_regs *regs)
 {
-	struct perf_cpu_context *cpuctx;
+	struct swevent_htable *swhash = &__get_cpu_var(swevent_htable);
 	struct perf_event *event;
 	struct hlist_node *node;
 	struct hlist_head *head;
 
-	cpuctx = &__get_cpu_var(perf_cpu_context);
-
 	rcu_read_lock();
-
-	head = find_swevent_head_rcu(cpuctx, type, event_id);
-
+	head = find_swevent_head_rcu(swhash, type, event_id);
 	if (!head)
 		goto end;
 
@@ -4347,17 +4354,17 @@ static void do_perf_sw_event(enum perf_t
 
 int perf_swevent_get_recursion_context(void)
 {
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct swevent_htable *swhash = &__get_cpu_var(swevent_htable);
 
-	return get_recursion_context(cpuctx->recursion);
+	return get_recursion_context(swhash->recursion);
 }
 EXPORT_SYMBOL_GPL(perf_swevent_get_recursion_context);
 
 void inline perf_swevent_put_recursion_context(int rctx)
 {
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct swevent_htable *swhash = &__get_cpu_var(swevent_htable);
 
-	put_recursion_context(cpuctx->recursion, rctx);
+	put_recursion_context(swhash->recursion, rctx);
 }
 
 void __perf_sw_event(u32 event_id, u64 nr, int nmi,
@@ -4385,12 +4392,10 @@ static void perf_swevent_read(struct per
 
 static int perf_swevent_add(struct perf_event *event, int flags)
 {
+	struct swevent_htable *swhash = &__get_cpu_var(swevent_htable);
 	struct hw_perf_event *hwc = &event->hw;
-	struct perf_cpu_context *cpuctx;
 	struct hlist_head *head;
 
-	cpuctx = &__get_cpu_var(perf_cpu_context);
-
 	if (hwc->sample_period) {
 		hwc->last_period = hwc->sample_period;
 		perf_swevent_set_period(event);
@@ -4398,7 +4403,7 @@ static int perf_swevent_add(struct perf_
 
 	hwc->state = !(flags & PERF_EF_START);
 
-	head = find_swevent_head(cpuctx, event);
+	head = find_swevent_head(swhash, event);
 	if (WARN_ON_ONCE(!head))
 		return -EINVAL;
 
@@ -4424,10 +4429,10 @@ static void perf_swevent_stop(struct per
 
 /* Deref the hlist from the update side */
 static inline struct swevent_hlist *
-swevent_hlist_deref(struct perf_cpu_context *cpuctx)
+swevent_hlist_deref(struct swevent_htable *swhash)
 {
-	return rcu_dereference_protected(cpuctx->swevent_hlist,
-					 lockdep_is_held(&cpuctx->hlist_mutex));
+	return rcu_dereference_protected(swhash->swevent_hlist,
+					 lockdep_is_held(&swhash->hlist_mutex));
 }
 
 static void swevent_hlist_release_rcu(struct rcu_head *rcu_head)
@@ -4438,27 +4443,27 @@ static void swevent_hlist_release_rcu(st
 	kfree(hlist);
 }
 
-static void swevent_hlist_release(struct perf_cpu_context *cpuctx)
+static void swevent_hlist_release(struct swevent_htable *swhash)
 {
-	struct swevent_hlist *hlist = swevent_hlist_deref(cpuctx);
+	struct swevent_hlist *hlist = swevent_hlist_deref(swhash);
 
 	if (!hlist)
 		return;
 
-	rcu_assign_pointer(cpuctx->swevent_hlist, NULL);
+	rcu_assign_pointer(swhash->swevent_hlist, NULL);
 	call_rcu(&hlist->rcu_head, swevent_hlist_release_rcu);
 }
 
 static void swevent_hlist_put_cpu(struct perf_event *event, int cpu)
 {
-	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
+	struct swevent_htable *swhash = &per_cpu(swevent_htable, cpu);
 
-	mutex_lock(&cpuctx->hlist_mutex);
+	mutex_lock(&swhash->hlist_mutex);
 
-	if (!--cpuctx->hlist_refcount)
-		swevent_hlist_release(cpuctx);
+	if (!--swhash->hlist_refcount)
+		swevent_hlist_release(swhash);
 
-	mutex_unlock(&cpuctx->hlist_mutex);
+	mutex_unlock(&swhash->hlist_mutex);
 }
 
 static void swevent_hlist_put(struct perf_event *event)
@@ -4476,12 +4481,12 @@ static void swevent_hlist_put(struct per
 
 static int swevent_hlist_get_cpu(struct perf_event *event, int cpu)
 {
-	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
+	struct swevent_htable *swhash = &per_cpu(swevent_htable, cpu);
 	int err = 0;
 
-	mutex_lock(&cpuctx->hlist_mutex);
+	mutex_lock(&swhash->hlist_mutex);
 
-	if (!swevent_hlist_deref(cpuctx) && cpu_online(cpu)) {
+	if (!swevent_hlist_deref(swhash) && cpu_online(cpu)) {
 		struct swevent_hlist *hlist;
 
 		hlist = kzalloc(sizeof(*hlist), GFP_KERNEL);
@@ -4489,11 +4494,11 @@ static int swevent_hlist_get_cpu(struct 
 			err = -ENOMEM;
 			goto exit;
 		}
-		rcu_assign_pointer(cpuctx->swevent_hlist, hlist);
+		rcu_assign_pointer(swhash->swevent_hlist, hlist);
 	}
-	cpuctx->hlist_refcount++;
+	swhash->hlist_refcount++;
 exit:
-	mutex_unlock(&cpuctx->hlist_mutex);
+	mutex_unlock(&swhash->hlist_mutex);
 
 	return err;
 }
@@ -5891,12 +5896,15 @@ int perf_event_init_task(struct task_str
 
 static void __init perf_event_init_all_cpus(void)
 {
-	int cpu;
 	struct perf_cpu_context *cpuctx;
+	struct swevent_htable *swhash;
+	int cpu;
 
 	for_each_possible_cpu(cpu) {
+		swhash = &per_cpu(swevent_htable, cpu);
+		mutex_init(&swhash->hlist_mutex);
+
 		cpuctx = &per_cpu(perf_cpu_context, cpu);
-		mutex_init(&cpuctx->hlist_mutex);
 		__perf_event_init_context(&cpuctx->ctx, NULL);
 	}
 }
@@ -5904,18 +5912,21 @@ static void __init perf_event_init_all_c
 static void __cpuinit perf_event_init_cpu(int cpu)
 {
 	struct perf_cpu_context *cpuctx;
+	struct swevent_htable *swhash;
 
 	cpuctx = &per_cpu(perf_cpu_context, cpu);
 
-	mutex_lock(&cpuctx->hlist_mutex);
-	if (cpuctx->hlist_refcount > 0) {
+	swhash = &per_cpu(swevent_htable, cpu);
+
+	mutex_lock(&swhash->hlist_mutex);
+	if (swhash->hlist_refcount > 0) {
 		struct swevent_hlist *hlist;
 
-		hlist = kzalloc(sizeof(*hlist), GFP_KERNEL);
-		WARN_ON_ONCE(!hlist);
-		rcu_assign_pointer(cpuctx->swevent_hlist, hlist);
+		hlist = kzalloc_node(sizeof(*hlist), GFP_KERNEL, cpu_to_node(cpu));
+		WARN_ON(!hlist);
+		rcu_assign_pointer(swhash->swevent_hlist, hlist);
 	}
-	mutex_unlock(&cpuctx->hlist_mutex);
+	mutex_unlock(&swhash->hlist_mutex);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -5933,11 +5944,12 @@ static void __perf_event_exit_cpu(void *
 static void perf_event_exit_cpu(int cpu)
 {
 	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
+	struct swevent_htable *swhash = &per_cpu(swevent_htable, cpu);
 	struct perf_event_context *ctx = &cpuctx->ctx;
 
-	mutex_lock(&cpuctx->hlist_mutex);
-	swevent_hlist_release(cpuctx);
-	mutex_unlock(&cpuctx->hlist_mutex);
+	mutex_lock(&swhash->hlist_mutex);
+	swevent_hlist_release(swhash);
+	mutex_unlock(&swhash->hlist_mutex);
 
 	mutex_lock(&ctx->mutex);
 	smp_call_function_single(cpu, __perf_event_exit_cpu, NULL, 1);



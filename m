Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab0IITvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:51:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:33181 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970Ab0IITvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:51:37 -0400
Date: Thu, 9 Sep 2010 19:51:11 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, eranian@googlemail.com, a.p.zijlstra@chello.nl,
        yanmin_zhang@linux.intel.com, robert.richter@amd.com,
        fweisbec@gmail.com, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, eranian@googlemail.com,
        a.p.zijlstra@chello.nl, yanmin_zhang@linux.intel.com,
        fweisbec@gmail.com, robert.richter@amd.com, ming.m.lin@intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Remove the swevent hash-table from the cpu context
Message-ID: <tip-b28ab83c595e767f2028276b7398d17f2253cec0@git.kernel.org>
Git-Commit-ID: b28ab83c595e767f2028276b7398d17f2253cec0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:51:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b28ab83c595e767f2028276b7398d17f2253cec0
Gitweb:     http://git.kernel.org/tip/b28ab83c595e767f2028276b7398d17f2253cec0
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 6 Sep 2010 14:48:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Sep 2010 20:46:32 +0200

perf: Remove the swevent hash-table from the cpu context

Separate the swevent hash-table from the cpu_context bits in
preparation for per pmu cpu contexts.

This keeps the swevent hash a global entity.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>
Cc: stephane eranian <eranian@googlemail.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Yanmin <yanmin_zhang@linux.intel.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    6 ---
 kernel/perf_event.c        |  104 ++++++++++++++++++++++++-------------------
 2 files changed, 58 insertions(+), 52 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index b22176d..4ab4f0c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -861,12 +861,6 @@ struct perf_cpu_context {
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
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a3c86a8..2c47ed6 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4154,6 +4154,17 @@ int perf_event_overflow(struct perf_event *event, int nmi,
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
@@ -4286,11 +4297,11 @@ __find_swevent_head(struct swevent_hlist *hlist, u64 type, u32 event_id)
 
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
 
@@ -4299,7 +4310,7 @@ find_swevent_head_rcu(struct perf_cpu_context *ctx, u64 type, u32 event_id)
 
 /* For the event head insertion and removal in the hlist */
 static inline struct hlist_head *
-find_swevent_head(struct perf_cpu_context *ctx, struct perf_event *event)
+find_swevent_head(struct swevent_htable *swhash, struct perf_event *event)
 {
 	struct swevent_hlist *hlist;
 	u32 event_id = event->attr.config;
@@ -4310,7 +4321,7 @@ find_swevent_head(struct perf_cpu_context *ctx, struct perf_event *event)
 	 * and release. Which makes the protected version suitable here.
 	 * The context lock guarantees that.
 	 */
-	hlist = rcu_dereference_protected(ctx->swevent_hlist,
+	hlist = rcu_dereference_protected(swhash->swevent_hlist,
 					  lockdep_is_held(&event->ctx->lock));
 	if (!hlist)
 		return NULL;
@@ -4323,17 +4334,13 @@ static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
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
 
@@ -4347,17 +4354,17 @@ end:
 
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
@@ -4385,12 +4392,10 @@ static void perf_swevent_read(struct perf_event *event)
 
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
@@ -4398,7 +4403,7 @@ static int perf_swevent_add(struct perf_event *event, int flags)
 
 	hwc->state = !(flags & PERF_EF_START);
 
-	head = find_swevent_head(cpuctx, event);
+	head = find_swevent_head(swhash, event);
 	if (WARN_ON_ONCE(!head))
 		return -EINVAL;
 
@@ -4424,10 +4429,10 @@ static void perf_swevent_stop(struct perf_event *event, int flags)
 
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
@@ -4438,27 +4443,27 @@ static void swevent_hlist_release_rcu(struct rcu_head *rcu_head)
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
@@ -4476,12 +4481,12 @@ static void swevent_hlist_put(struct perf_event *event)
 
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
@@ -4489,11 +4494,11 @@ static int swevent_hlist_get_cpu(struct perf_event *event, int cpu)
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
@@ -5889,12 +5894,15 @@ int perf_event_init_task(struct task_struct *child)
 
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
@@ -5902,18 +5910,21 @@ static void __init perf_event_init_all_cpus(void)
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
@@ -5931,11 +5942,12 @@ static void __perf_event_exit_cpu(void *info)
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

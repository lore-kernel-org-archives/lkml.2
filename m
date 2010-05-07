Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037Ab0EGSp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:45:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:46650 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757632Ab0EGSp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:45:26 -0400
Date: Fri, 7 May 2010 18:44:50 GMT
From: tip-bot for Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, eranian@google.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       davem@davemloft.net, ming.m.lin@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       davem@davemloft.net, ming.m.lin@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1272002172.5707.61.camel@minggr.sh.intel.com>
References: <1272002172.5707.61.camel@minggr.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: implement group scheduling transactional APIs
Message-ID: <tip-4d1c52b02d977d884abb21d0bbaba6b5d6bc8374@git.kernel.org>
Git-Commit-ID: 4d1c52b02d977d884abb21d0bbaba6b5d6bc8374
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 May 2010 18:44:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4d1c52b02d977d884abb21d0bbaba6b5d6bc8374
Gitweb:     http://git.kernel.org/tip/4d1c52b02d977d884abb21d0bbaba6b5d6bc8374
Author:     Lin Ming <ming.m.lin@intel.com>
AuthorDate: Fri, 23 Apr 2010 13:56:12 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 May 2010 11:31:03 +0200

perf, x86: implement group scheduling transactional APIs

Convert to the transactional PMU API and remove the duplication of
group_sched_in().

Reviewed-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Miller <davem@davemloft.net>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1272002172.5707.61.camel@minggr.sh.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |  180 ++++++++++++++------------------------
 1 files changed, 67 insertions(+), 113 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 27fa9ee..fd4db0d 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -110,6 +110,8 @@ struct cpu_hw_events {
 	u64			tags[X86_PMC_IDX_MAX];
 	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
 
+	unsigned int		group_flag;
+
 	/*
 	 * Intel DebugStore bits
 	 */
@@ -961,6 +963,14 @@ static int x86_pmu_enable(struct perf_event *event)
 	if (n < 0)
 		return n;
 
+	/*
+	 * If group events scheduling transaction was started,
+	 * skip the schedulability test here, it will be peformed
+	 * at commit time(->commit_txn) as a whole
+	 */
+	if (cpuc->group_flag & PERF_EVENT_TXN_STARTED)
+		goto out;
+
 	ret = x86_pmu.schedule_events(cpuc, n, assign);
 	if (ret)
 		return ret;
@@ -970,6 +980,7 @@ static int x86_pmu_enable(struct perf_event *event)
 	 */
 	memcpy(cpuc->assign, assign, n*sizeof(int));
 
+out:
 	cpuc->n_events = n;
 	cpuc->n_added += n - n0;
 
@@ -1227,119 +1238,6 @@ x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 	return &unconstrained;
 }
 
-static int x86_event_sched_in(struct perf_event *event,
-			  struct perf_cpu_context *cpuctx)
-{
-	int ret = 0;
-
-	event->state = PERF_EVENT_STATE_ACTIVE;
-	event->oncpu = smp_processor_id();
-	event->tstamp_running += event->ctx->time - event->tstamp_stopped;
-
-	if (!is_x86_event(event))
-		ret = event->pmu->enable(event);
-
-	if (!ret && !is_software_event(event))
-		cpuctx->active_oncpu++;
-
-	if (!ret && event->attr.exclusive)
-		cpuctx->exclusive = 1;
-
-	return ret;
-}
-
-static void x86_event_sched_out(struct perf_event *event,
-			    struct perf_cpu_context *cpuctx)
-{
-	event->state = PERF_EVENT_STATE_INACTIVE;
-	event->oncpu = -1;
-
-	if (!is_x86_event(event))
-		event->pmu->disable(event);
-
-	event->tstamp_running -= event->ctx->time - event->tstamp_stopped;
-
-	if (!is_software_event(event))
-		cpuctx->active_oncpu--;
-
-	if (event->attr.exclusive || !cpuctx->active_oncpu)
-		cpuctx->exclusive = 0;
-}
-
-/*
- * Called to enable a whole group of events.
- * Returns 1 if the group was enabled, or -EAGAIN if it could not be.
- * Assumes the caller has disabled interrupts and has
- * frozen the PMU with hw_perf_save_disable.
- *
- * called with PMU disabled. If successful and return value 1,
- * then guaranteed to call perf_enable() and hw_perf_enable()
- */
-int hw_perf_group_sched_in(struct perf_event *leader,
-	       struct perf_cpu_context *cpuctx,
-	       struct perf_event_context *ctx)
-{
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct perf_event *sub;
-	int assign[X86_PMC_IDX_MAX];
-	int n0, n1, ret;
-
-	if (!x86_pmu_initialized())
-		return 0;
-
-	/* n0 = total number of events */
-	n0 = collect_events(cpuc, leader, true);
-	if (n0 < 0)
-		return n0;
-
-	ret = x86_pmu.schedule_events(cpuc, n0, assign);
-	if (ret)
-		return ret;
-
-	ret = x86_event_sched_in(leader, cpuctx);
-	if (ret)
-		return ret;
-
-	n1 = 1;
-	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
-		if (sub->state > PERF_EVENT_STATE_OFF) {
-			ret = x86_event_sched_in(sub, cpuctx);
-			if (ret)
-				goto undo;
-			++n1;
-		}
-	}
-	/*
-	 * copy new assignment, now we know it is possible
-	 * will be used by hw_perf_enable()
-	 */
-	memcpy(cpuc->assign, assign, n0*sizeof(int));
-
-	cpuc->n_events  = n0;
-	cpuc->n_added  += n1;
-	ctx->nr_active += n1;
-
-	/*
-	 * 1 means successful and events are active
-	 * This is not quite true because we defer
-	 * actual activation until hw_perf_enable() but
-	 * this way we* ensure caller won't try to enable
-	 * individual events
-	 */
-	return 1;
-undo:
-	x86_event_sched_out(leader, cpuctx);
-	n0  = 1;
-	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
-		if (sub->state == PERF_EVENT_STATE_ACTIVE) {
-			x86_event_sched_out(sub, cpuctx);
-			if (++n0 == n1)
-				break;
-		}
-	}
-	return ret;
-}
-
 #include "perf_event_amd.c"
 #include "perf_event_p6.c"
 #include "perf_event_p4.c"
@@ -1471,6 +1369,59 @@ static inline void x86_pmu_read(struct perf_event *event)
 	x86_perf_event_update(event);
 }
 
+/*
+ * Start group events scheduling transaction
+ * Set the flag to make pmu::enable() not perform the
+ * schedulability test, it will be performed at commit time
+ */
+static void x86_pmu_start_txn(const struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	cpuc->group_flag |= PERF_EVENT_TXN_STARTED;
+}
+
+/*
+ * Stop group events scheduling transaction
+ * Clear the flag and pmu::enable() will perform the
+ * schedulability test.
+ */
+static void x86_pmu_cancel_txn(const struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	cpuc->group_flag &= ~PERF_EVENT_TXN_STARTED;
+}
+
+/*
+ * Commit group events scheduling transaction
+ * Perform the group schedulability test as a whole
+ * Return 0 if success
+ */
+static int x86_pmu_commit_txn(const struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int assign[X86_PMC_IDX_MAX];
+	int n, ret;
+
+	n = cpuc->n_events;
+
+	if (!x86_pmu_initialized())
+		return -EAGAIN;
+
+	ret = x86_pmu.schedule_events(cpuc, n, assign);
+	if (ret)
+		return ret;
+
+	/*
+	 * copy new assignment, now we know it is possible
+	 * will be used by hw_perf_enable()
+	 */
+	memcpy(cpuc->assign, assign, n*sizeof(int));
+
+	return 0;
+}
+
 static const struct pmu pmu = {
 	.enable		= x86_pmu_enable,
 	.disable	= x86_pmu_disable,
@@ -1478,6 +1429,9 @@ static const struct pmu pmu = {
 	.stop		= x86_pmu_stop,
 	.read		= x86_pmu_read,
 	.unthrottle	= x86_pmu_unthrottle,
+	.start_txn	= x86_pmu_start_txn,
+	.cancel_txn	= x86_pmu_cancel_txn,
+	.commit_txn	= x86_pmu_commit_txn,
 };
 
 /*

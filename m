Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab0EKPoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:44:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:37756 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453Ab0EKPn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:43:59 -0400
Date: Tue, 11 May 2010 15:43:36 GMT
From: tip-bot for Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, ming.m.lin@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100508102841.GA10650@brick.ozlabs.ibm.com>
References: <20100508102841.GA10650@brick.ozlabs.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, powerpc: Implement group scheduling transactional APIs
Message-ID: <tip-8e6d5573af55435160d329f6ae3fe16a0abbdaec@git.kernel.org>
Git-Commit-ID: 8e6d5573af55435160d329f6ae3fe16a0abbdaec
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 11 May 2010 15:43:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e6d5573af55435160d329f6ae3fe16a0abbdaec
Gitweb:     http://git.kernel.org/tip/8e6d5573af55435160d329f6ae3fe16a0abbdaec
Author:     Lin Ming <ming.m.lin@intel.com>
AuthorDate: Sat, 8 May 2010 20:28:41 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 11 May 2010 17:08:24 +0200

perf, powerpc: Implement group scheduling transactional APIs

[paulus@samba.org: Set cpuhw->event[i]->hw.config in
power_pmu_commit_txn.]

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100508102841.GA10650@brick.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/powerpc/kernel/perf_event.c |  129 ++++++++++++++++++++------------------
 1 files changed, 68 insertions(+), 61 deletions(-)

diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index 08460a2..43b83c3 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -35,6 +35,9 @@ struct cpu_hw_events {
 	u64 alternatives[MAX_HWEVENTS][MAX_EVENT_ALTERNATIVES];
 	unsigned long amasks[MAX_HWEVENTS][MAX_EVENT_ALTERNATIVES];
 	unsigned long avalues[MAX_HWEVENTS][MAX_EVENT_ALTERNATIVES];
+
+	unsigned int group_flag;
+	int n_txn_start;
 };
 DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events);
 
@@ -718,66 +721,6 @@ static int collect_events(struct perf_event *group, int max_count,
 	return n;
 }
 
-static void event_sched_in(struct perf_event *event)
-{
-	event->state = PERF_EVENT_STATE_ACTIVE;
-	event->oncpu = smp_processor_id();
-	event->tstamp_running += event->ctx->time - event->tstamp_stopped;
-	if (is_software_event(event))
-		event->pmu->enable(event);
-}
-
-/*
- * Called to enable a whole group of events.
- * Returns 1 if the group was enabled, or -EAGAIN if it could not be.
- * Assumes the caller has disabled interrupts and has
- * frozen the PMU with hw_perf_save_disable.
- */
-int hw_perf_group_sched_in(struct perf_event *group_leader,
-	       struct perf_cpu_context *cpuctx,
-	       struct perf_event_context *ctx)
-{
-	struct cpu_hw_events *cpuhw;
-	long i, n, n0;
-	struct perf_event *sub;
-
-	if (!ppmu)
-		return 0;
-	cpuhw = &__get_cpu_var(cpu_hw_events);
-	n0 = cpuhw->n_events;
-	n = collect_events(group_leader, ppmu->n_counter - n0,
-			   &cpuhw->event[n0], &cpuhw->events[n0],
-			   &cpuhw->flags[n0]);
-	if (n < 0)
-		return -EAGAIN;
-	if (check_excludes(cpuhw->event, cpuhw->flags, n0, n))
-		return -EAGAIN;
-	i = power_check_constraints(cpuhw, cpuhw->events, cpuhw->flags, n + n0);
-	if (i < 0)
-		return -EAGAIN;
-	cpuhw->n_events = n0 + n;
-	cpuhw->n_added += n;
-
-	/*
-	 * OK, this group can go on; update event states etc.,
-	 * and enable any software events
-	 */
-	for (i = n0; i < n0 + n; ++i)
-		cpuhw->event[i]->hw.config = cpuhw->events[i];
-	cpuctx->active_oncpu += n;
-	n = 1;
-	event_sched_in(group_leader);
-	list_for_each_entry(sub, &group_leader->sibling_list, group_entry) {
-		if (sub->state != PERF_EVENT_STATE_OFF) {
-			event_sched_in(sub);
-			++n;
-		}
-	}
-	ctx->nr_active += n;
-
-	return 1;
-}
-
 /*
  * Add a event to the PMU.
  * If all events are not already frozen, then we disable and
@@ -805,12 +748,22 @@ static int power_pmu_enable(struct perf_event *event)
 	cpuhw->event[n0] = event;
 	cpuhw->events[n0] = event->hw.config;
 	cpuhw->flags[n0] = event->hw.event_base;
+
+	/*
+	 * If group events scheduling transaction was started,
+	 * skip the schedulability test here, it will be peformed
+	 * at commit time(->commit_txn) as a whole
+	 */
+	if (cpuhw->group_flag & PERF_EVENT_TXN_STARTED)
+		goto nocheck;
+
 	if (check_excludes(cpuhw->event, cpuhw->flags, n0, 1))
 		goto out;
 	if (power_check_constraints(cpuhw, cpuhw->events, cpuhw->flags, n0 + 1))
 		goto out;
-
 	event->hw.config = cpuhw->events[n0];
+
+nocheck:
 	++cpuhw->n_events;
 	++cpuhw->n_added;
 
@@ -896,11 +849,65 @@ static void power_pmu_unthrottle(struct perf_event *event)
 	local_irq_restore(flags);
 }
 
+/*
+ * Start group events scheduling transaction
+ * Set the flag to make pmu::enable() not perform the
+ * schedulability test, it will be performed at commit time
+ */
+void power_pmu_start_txn(const struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+
+	cpuhw->group_flag |= PERF_EVENT_TXN_STARTED;
+	cpuhw->n_txn_start = cpuhw->n_events;
+}
+
+/*
+ * Stop group events scheduling transaction
+ * Clear the flag and pmu::enable() will perform the
+ * schedulability test.
+ */
+void power_pmu_cancel_txn(const struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+
+	cpuhw->group_flag &= ~PERF_EVENT_TXN_STARTED;
+}
+
+/*
+ * Commit group events scheduling transaction
+ * Perform the group schedulability test as a whole
+ * Return 0 if success
+ */
+int power_pmu_commit_txn(const struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuhw;
+	long i, n;
+
+	if (!ppmu)
+		return -EAGAIN;
+	cpuhw = &__get_cpu_var(cpu_hw_events);
+	n = cpuhw->n_events;
+	if (check_excludes(cpuhw->event, cpuhw->flags, 0, n))
+		return -EAGAIN;
+	i = power_check_constraints(cpuhw, cpuhw->events, cpuhw->flags, n);
+	if (i < 0)
+		return -EAGAIN;
+
+	for (i = cpuhw->n_txn_start; i < n; ++i)
+		cpuhw->event[i]->hw.config = cpuhw->events[i];
+
+	return 0;
+}
+
 struct pmu power_pmu = {
 	.enable		= power_pmu_enable,
 	.disable	= power_pmu_disable,
 	.read		= power_pmu_read,
 	.unthrottle	= power_pmu_unthrottle,
+	.start_txn	= power_pmu_start_txn,
+	.cancel_txn	= power_pmu_cancel_txn,
+	.commit_txn	= power_pmu_commit_txn,
 };
 
 /*

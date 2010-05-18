Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489Ab0ERRTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:19:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:60849 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757932Ab0ERRTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:19:10 -0400
Date: Tue, 18 May 2010 17:17:49 GMT
From: tip-bot for Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, davem@davemloft.net,
       ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       davem@davemloft.net, ming.m.lin@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1272002193.5707.65.camel@minggr.sh.intel.com>
References: <1272002193.5707.65.camel@minggr.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, sparc: Implement group scheduling transactional APIs
Message-ID: <tip-a13c3afd9b62b6dace80654964cc4ca7d2db8092@git.kernel.org>
Git-Commit-ID: a13c3afd9b62b6dace80654964cc4ca7d2db8092
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 May 2010 17:17:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a13c3afd9b62b6dace80654964cc4ca7d2db8092
Gitweb:     http://git.kernel.org/tip/a13c3afd9b62b6dace80654964cc4ca7d2db8092
Author:     Lin Ming <ming.m.lin@intel.com>
AuthorDate: Fri, 23 Apr 2010 13:56:33 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 May 2010 18:59:12 +0200

perf, sparc: Implement group scheduling transactional APIs

Convert to the transactional PMU API and remove the duplication of
group_sched_in().

[cross build only]

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Acked-by: David Miller <davem@davemloft.net>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1272002193.5707.65.camel@minggr.sh.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/sparc/kernel/perf_event.c |  108 ++++++++++++++++++++++-----------------
 1 files changed, 61 insertions(+), 47 deletions(-)

diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index e277193..cf4ce26 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -91,6 +91,8 @@ struct cpu_hw_events {
 
 	/* Enabled/disable state.  */
 	int			enabled;
+
+	unsigned int		group_flag;
 };
 DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = { .enabled = 1, };
 
@@ -980,53 +982,6 @@ static int collect_events(struct perf_event *group, int max_count,
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
-int hw_perf_group_sched_in(struct perf_event *group_leader,
-			   struct perf_cpu_context *cpuctx,
-			   struct perf_event_context *ctx)
-{
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct perf_event *sub;
-	int n0, n;
-
-	if (!sparc_pmu)
-		return 0;
-
-	n0 = cpuc->n_events;
-	n = collect_events(group_leader, perf_max_events - n0,
-			   &cpuc->event[n0], &cpuc->events[n0],
-			   &cpuc->current_idx[n0]);
-	if (n < 0)
-		return -EAGAIN;
-	if (check_excludes(cpuc->event, n0, n))
-		return -EINVAL;
-	if (sparc_check_constraints(cpuc->event, cpuc->events, n + n0))
-		return -EAGAIN;
-	cpuc->n_events = n0 + n;
-	cpuc->n_added += n;
-
-	cpuctx->active_oncpu += n;
-	n = 1;
-	event_sched_in(group_leader);
-	list_for_each_entry(sub, &group_leader->sibling_list, group_entry) {
-		if (sub->state != PERF_EVENT_STATE_OFF) {
-			event_sched_in(sub);
-			n++;
-		}
-	}
-	ctx->nr_active += n;
-
-	return 1;
-}
-
 static int sparc_pmu_enable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -1044,11 +999,20 @@ static int sparc_pmu_enable(struct perf_event *event)
 	cpuc->events[n0] = event->hw.event_base;
 	cpuc->current_idx[n0] = PIC_NO_INDEX;
 
+	/*
+	 * If group events scheduling transaction was started,
+	 * skip the schedulability test here, it will be peformed
+	 * at commit time(->commit_txn) as a whole
+	 */
+	if (cpuc->group_flag & PERF_EVENT_TXN_STARTED)
+		goto nocheck;
+
 	if (check_excludes(cpuc->event, n0, 1))
 		goto out;
 	if (sparc_check_constraints(cpuc->event, cpuc->events, n0 + 1))
 		goto out;
 
+nocheck:
 	cpuc->n_events++;
 	cpuc->n_added++;
 
@@ -1128,11 +1092,61 @@ static int __hw_perf_event_init(struct perf_event *event)
 	return 0;
 }
 
+/*
+ * Start group events scheduling transaction
+ * Set the flag to make pmu::enable() not perform the
+ * schedulability test, it will be performed at commit time
+ */
+static void sparc_pmu_start_txn(const struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+
+	cpuhw->group_flag |= PERF_EVENT_TXN_STARTED;
+}
+
+/*
+ * Stop group events scheduling transaction
+ * Clear the flag and pmu::enable() will perform the
+ * schedulability test.
+ */
+static void sparc_pmu_cancel_txn(const struct pmu *pmu)
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
+static int sparc_pmu_commit_txn(const struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int n;
+
+	if (!sparc_pmu)
+		return -EINVAL;
+
+	cpuc = &__get_cpu_var(cpu_hw_events);
+	n = cpuc->n_events;
+	if (check_excludes(cpuc->event, 0, n))
+		return -EINVAL;
+	if (sparc_check_constraints(cpuc->event, cpuc->events, n))
+		return -EAGAIN;
+
+	return 0;
+}
+
 static const struct pmu pmu = {
 	.enable		= sparc_pmu_enable,
 	.disable	= sparc_pmu_disable,
 	.read		= sparc_pmu_read,
 	.unthrottle	= sparc_pmu_unthrottle,
+	.start_txn	= sparc_pmu_start_txn,
+	.cancel_txn	= sparc_pmu_cancel_txn,
+	.commit_txn	= sparc_pmu_commit_txn,
 };
 
 const struct pmu *hw_perf_event_init(struct perf_event *event)

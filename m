Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258Ab0FPQHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 12:07:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:33961 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759211Ab0FPQGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 12:06:35 -0400
Message-Id: <20100616160238.638868251@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 16 Jun 2010 18:00:34 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 7/8] perf: Default PMU ops
References: <20100616160027.590430763@chello.nl>
Content-Disposition: inline; filename=perf-default-ops.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide default implementations for the pmu txn methods, this allows
us to remove some conditional code.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |   45 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 10 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -656,17 +656,11 @@ group_sched_in(struct perf_event *group_
 {
 	struct perf_event *event, *partial_group = NULL;
 	struct pmu *pmu = group_event->pmu;
-	bool txn = false;
 
 	if (group_event->state == PERF_EVENT_STATE_OFF)
 		return 0;
 
-	/* Check if group transaction availabe */
-	if (pmu->start_txn)
-		txn = true;
-
-	if (txn)
-		pmu->start_txn(pmu);
+	pmu->start_txn(pmu);
 
 	if (event_sched_in(group_event, cpuctx, ctx)) {
 		if (txn)
@@ -684,7 +678,7 @@ group_sched_in(struct perf_event *group_
 		}
 	}
 
-	if (!txn || !pmu->commit_txn(pmu))
+	if (!pmu->commit_txn(pmu))
 		return 0;
 
 group_error:
@@ -699,8 +693,7 @@ group_error:
 	}
 	event_sched_out(group_event, cpuctx, ctx);
 
-	if (txn)
-		pmu->cancel_txn(pmu);
+	pmu->cancel_txn(pmu);
 
 	return -EAGAIN;
 }
@@ -4748,6 +4741,26 @@ static struct list_head pmus;
 static DEFINE_SPINLOCK(pmus_lock);
 static struct srcu_struct pmus_srcu;
 
+static void perf_pmu_nop(struct pmu *pmu)
+{
+}
+
+static void perf_pmu_start_txn(struct pmu *pmu)
+{
+	perf_disable_pmu(pmu);
+}
+
+static int perf_pmu_commit_txn(struct pmu *pmu)
+{
+	perf_enable_pmu(pmu);
+	return 0;
+}
+
+static void perf_pmu_cancel_txn(struct pmu *pmu)
+{
+	perf_enable_pmu(pmu);
+}
+
 int perf_pmu_register(struct pmu *pmu)
 {
 	int ret;
@@ -4757,6 +4770,18 @@ int perf_pmu_register(struct pmu *pmu)
 	pmu->pmu_disable_count = alloc_percpu(int);
 	if (!pmu->pmu_disable_count)
 		goto unlock;
+
+	if (!pmu->pmu_enable) {
+		pmu->pmu_enable  = perf_pmu_nop;
+		pmu->pmu_disable = perf_pmu_nop;
+	}
+
+	if (!pmu->start_txn) {
+		pmu->start_txn  = perf_pmu_start_txn;
+		pmu->commit_txn = perf_pmu_commit_txn;
+		pmu->cancel_txn = perf_pmu_cancel_txn;
+	}
+
 	list_add_rcu(&pmu->entry, &pmus);
 	ret = 0;
 unlock:



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab0GIIkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 04:40:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:52213 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab0GIIkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 04:40:00 -0400
Message-Id: <20100709083248.216905425@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 09 Jul 2010 10:21:28 +0200
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
Subject: [RFC][PATCH 11/13] perf: Default PMU ops
References: <20100709082117.631541128@chello.nl>
Content-Disposition: inline; filename=perf-default-ops.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide default implementations for the pmu txn methods, this allows
us to remove some conditional code.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |   10 +++----
 kernel/perf_event.c        |   64 ++++++++++++++++++++++++++++++++++++---------
 2 files changed, 57 insertions(+), 17 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -656,21 +656,14 @@ group_sched_in(struct perf_event *group_
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
-		if (txn)
-			pmu->cancel_txn(pmu);
+		pmu->cancel_txn(pmu);
 		return -EAGAIN;
 	}
 
@@ -684,7 +677,7 @@ group_sched_in(struct perf_event *group_
 		}
 	}
 
-	if (!txn || !pmu->commit_txn(pmu))
+	if (!pmu->commit_txn(pmu))
 		return 0;
 
 group_error:
@@ -699,8 +692,7 @@ group_error:
 	}
 	event_sched_out(group_event, cpuctx, ctx);
 
-	if (txn)
-		pmu->cancel_txn(pmu);
+	pmu->cancel_txn(pmu);
 
 	return -EAGAIN;
 }
@@ -4755,6 +4747,31 @@ static LIST_HEAD(pmus);
 static DEFINE_MUTEX(pmus_lock);
 static struct srcu_struct pmus_srcu;
 
+static void perf_pmu_nop_void(struct pmu *pmu)
+{
+}
+
+static int perf_pmu_nop_int(struct pmu *pmu)
+{
+	return 0;
+}
+
+static void perf_pmu_start_txn(struct pmu *pmu)
+{
+	perf_pmu_disable(pmu);
+}
+
+static int perf_pmu_commit_txn(struct pmu *pmu)
+{
+	perf_pmu_enable(pmu);
+	return 0;
+}
+
+static void perf_pmu_cancel_txn(struct pmu *pmu)
+{
+	perf_pmu_enable(pmu);
+}
+
 int perf_pmu_register(struct pmu *pmu)
 {
 	int ret;
@@ -4764,6 +4781,29 @@ int perf_pmu_register(struct pmu *pmu)
 	pmu->pmu_disable_count = alloc_percpu(int);
 	if (!pmu->pmu_disable_count)
 		goto unlock;
+
+	if (!pmu->start_txn) {
+		if (pmu->pmu_enable) {
+			/*
+			 * If we have pmu_enable/pmu_disable calls, install
+			 * transaction stubs that use that to try and batch
+			 * hardware accesses.
+			 */
+			pmu->start_txn  = perf_pmu_start_txn;
+			pmu->commit_txn = perf_pmu_commit_txn;
+			pmu->cancel_txn = perf_pmu_cancel_txn;
+		} else {
+			pmu->start_txn  = perf_pmu_nop_void;
+			pmu->commit_txn = perf_pmu_nop_int;
+			pmu->cancel_txn = perf_pmu_nop_void;
+		}
+	}
+
+	if (!pmu->pmu_enable) {
+		pmu->pmu_enable  = perf_pmu_nop_void;
+		pmu->pmu_disable = perf_pmu_nop_void;
+	}
+
 	list_add_rcu(&pmu->entry, &pmus);
 	ret = 0;
 unlock:
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -565,8 +565,8 @@ struct pmu {
 
 	int				*pmu_disable_count;
 
-	void (*pmu_enable)		(struct pmu *pmu);
-	void (*pmu_disable)		(struct pmu *pmu);
+	void (*pmu_enable)		(struct pmu *pmu); /* optional */
+	void (*pmu_disable)		(struct pmu *pmu); /* optional */
 
 	/*
 	 * Should return -ENOENT when the @event doesn't match this PMU.
@@ -590,19 +590,19 @@ struct pmu {
 	 * Start the transaction, after this ->enable() doesn't need to
 	 * do schedulability tests.
 	 */
-	void (*start_txn)	(struct pmu *pmu);
+	void (*start_txn)	(struct pmu *pmu); /* optional */
 	/*
 	 * If ->start_txn() disabled the ->enable() schedulability test
 	 * then ->commit_txn() is required to perform one. On success
 	 * the transaction is closed. On error the transaction is kept
 	 * open until ->cancel_txn() is called.
 	 */
-	int  (*commit_txn)	(struct pmu *pmu);
+	int  (*commit_txn)	(struct pmu *pmu); /* optional */
 	/*
 	 * Will cancel the transaction, assumes ->disable() is called
 	 * for each successfull ->enable() during the transaction.
 	 */
-	void (*cancel_txn)	(struct pmu *pmu);
+	void (*cancel_txn)	(struct pmu *pmu); /* optional */
 };
 
 /**



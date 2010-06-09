Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab0FIKQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:16:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:36276 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757491Ab0FIKQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:16:20 -0400
Date: Wed, 9 Jun 2010 10:15:50 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1274803086.5882.1752.camel@twins>
References: <1274803086.5882.1752.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Cleanup {start,commit,cancel}_txn details
Message-ID: <tip-8d2cacbbb8deadfae78aa16e4e1ee619bdd7019e@git.kernel.org>
Git-Commit-ID: 8d2cacbbb8deadfae78aa16e4e1ee619bdd7019e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 10:15:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d2cacbbb8deadfae78aa16e4e1ee619bdd7019e
Gitweb:     http://git.kernel.org/tip/8d2cacbbb8deadfae78aa16e4e1ee619bdd7019e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 25 May 2010 17:49:05 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Jun 2010 11:12:34 +0200

perf: Cleanup {start,commit,cancel}_txn details

Clarify some of the transactional group scheduling API details
and change it so that a successfull ->commit_txn also closes
the transaction.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1274803086.5882.1752.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/powerpc/kernel/perf_event.c |    7 ++++---
 arch/sparc/kernel/perf_event.c   |    7 ++++---
 arch/x86/kernel/cpu/perf_event.c |   14 +++++---------
 include/linux/perf_event.h       |   27 ++++++++++++++++++++++-----
 kernel/perf_event.c              |    9 +--------
 5 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index 43b83c3..ac2a8c2 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -754,7 +754,7 @@ static int power_pmu_enable(struct perf_event *event)
 	 * skip the schedulability test here, it will be peformed
 	 * at commit time(->commit_txn) as a whole
 	 */
-	if (cpuhw->group_flag & PERF_EVENT_TXN_STARTED)
+	if (cpuhw->group_flag & PERF_EVENT_TXN)
 		goto nocheck;
 
 	if (check_excludes(cpuhw->event, cpuhw->flags, n0, 1))
@@ -858,7 +858,7 @@ void power_pmu_start_txn(const struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
-	cpuhw->group_flag |= PERF_EVENT_TXN_STARTED;
+	cpuhw->group_flag |= PERF_EVENT_TXN;
 	cpuhw->n_txn_start = cpuhw->n_events;
 }
 
@@ -871,7 +871,7 @@ void power_pmu_cancel_txn(const struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
-	cpuhw->group_flag &= ~PERF_EVENT_TXN_STARTED;
+	cpuhw->group_flag &= ~PERF_EVENT_TXN;
 }
 
 /*
@@ -897,6 +897,7 @@ int power_pmu_commit_txn(const struct pmu *pmu)
 	for (i = cpuhw->n_txn_start; i < n; ++i)
 		cpuhw->event[i]->hw.config = cpuhw->events[i];
 
+	cpuhw->group_flag &= ~PERF_EVENT_TXN;
 	return 0;
 }
 
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 0ec92c8..beeb92f 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1005,7 +1005,7 @@ static int sparc_pmu_enable(struct perf_event *event)
 	 * skip the schedulability test here, it will be peformed
 	 * at commit time(->commit_txn) as a whole
 	 */
-	if (cpuc->group_flag & PERF_EVENT_TXN_STARTED)
+	if (cpuc->group_flag & PERF_EVENT_TXN)
 		goto nocheck;
 
 	if (check_excludes(cpuc->event, n0, 1))
@@ -1102,7 +1102,7 @@ static void sparc_pmu_start_txn(const struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
-	cpuhw->group_flag |= PERF_EVENT_TXN_STARTED;
+	cpuhw->group_flag |= PERF_EVENT_TXN;
 }
 
 /*
@@ -1114,7 +1114,7 @@ static void sparc_pmu_cancel_txn(const struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
-	cpuhw->group_flag &= ~PERF_EVENT_TXN_STARTED;
+	cpuhw->group_flag &= ~PERF_EVENT_TXN;
 }
 
 /*
@@ -1137,6 +1137,7 @@ static int sparc_pmu_commit_txn(const struct pmu *pmu)
 	if (sparc_check_constraints(cpuc->event, cpuc->events, n))
 		return -EAGAIN;
 
+	cpuc->group_flag &= ~PERF_EVENT_TXN;
 	return 0;
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5db5b7d..af04c6f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -969,7 +969,7 @@ static int x86_pmu_enable(struct perf_event *event)
 	 * skip the schedulability test here, it will be peformed
 	 * at commit time(->commit_txn) as a whole
 	 */
-	if (cpuc->group_flag & PERF_EVENT_TXN_STARTED)
+	if (cpuc->group_flag & PERF_EVENT_TXN)
 		goto out;
 
 	ret = x86_pmu.schedule_events(cpuc, n, assign);
@@ -1096,7 +1096,7 @@ static void x86_pmu_disable(struct perf_event *event)
 	 * The events never got scheduled and ->cancel_txn will truncate
 	 * the event_list.
 	 */
-	if (cpuc->group_flag & PERF_EVENT_TXN_STARTED)
+	if (cpuc->group_flag & PERF_EVENT_TXN)
 		return;
 
 	x86_pmu_stop(event);
@@ -1388,7 +1388,7 @@ static void x86_pmu_start_txn(const struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
-	cpuc->group_flag |= PERF_EVENT_TXN_STARTED;
+	cpuc->group_flag |= PERF_EVENT_TXN;
 	cpuc->n_txn = 0;
 }
 
@@ -1401,7 +1401,7 @@ static void x86_pmu_cancel_txn(const struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
-	cpuc->group_flag &= ~PERF_EVENT_TXN_STARTED;
+	cpuc->group_flag &= ~PERF_EVENT_TXN;
 	/*
 	 * Truncate the collected events.
 	 */
@@ -1435,11 +1435,7 @@ static int x86_pmu_commit_txn(const struct pmu *pmu)
 	 */
 	memcpy(cpuc->assign, assign, n*sizeof(int));
 
-	/*
-	 * Clear out the txn count so that ->cancel_txn() which gets
-	 * run after ->commit_txn() doesn't undo things.
-	 */
-	cpuc->n_txn = 0;
+	cpuc->group_flag &= ~PERF_EVENT_TXN;
 
 	return 0;
 }
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 36efad9..f1b6ba0 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -549,7 +549,10 @@ struct hw_perf_event {
 
 struct perf_event;
 
-#define PERF_EVENT_TXN_STARTED 1
+/*
+ * Common implementation detail of pmu::{start,commit,cancel}_txn
+ */
+#define PERF_EVENT_TXN 0x1
 
 /**
  * struct pmu - generic performance monitoring unit
@@ -563,14 +566,28 @@ struct pmu {
 	void (*unthrottle)		(struct perf_event *event);
 
 	/*
-	 * group events scheduling is treated as a transaction,
-	 * add group events as a whole and perform one schedulability test.
-	 * If test fails, roll back the whole group
+	 * Group events scheduling is treated as a transaction, add group
+	 * events as a whole and perform one schedulability test. If the test
+	 * fails, roll back the whole group
 	 */
 
+	/*
+	 * Start the transaction, after this ->enable() doesn't need
+	 * to do schedulability tests.
+	 */
 	void (*start_txn)	(const struct pmu *pmu);
-	void (*cancel_txn)	(const struct pmu *pmu);
+	/*
+	 * If ->start_txn() disabled the ->enable() schedulability test
+	 * then ->commit_txn() is required to perform one. On success
+	 * the transaction is closed. On error the transaction is kept
+	 * open until ->cancel_txn() is called.
+	 */
 	int  (*commit_txn)	(const struct pmu *pmu);
+	/*
+	 * Will cancel the transaction, assumes ->disable() is called for
+	 * each successfull ->enable() during the transaction.
+	 */
+	void (*cancel_txn)	(const struct pmu *pmu);
 };
 
 /**
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 227ed9c..6f60920 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -675,7 +675,6 @@ group_sched_in(struct perf_event *group_event,
 	struct perf_event *event, *partial_group = NULL;
 	const struct pmu *pmu = group_event->pmu;
 	bool txn = false;
-	int ret;
 
 	if (group_event->state == PERF_EVENT_STATE_OFF)
 		return 0;
@@ -703,15 +702,9 @@ group_sched_in(struct perf_event *group_event,
 		}
 	}
 
-	if (!txn)
+	if (!txn || !pmu->commit_txn(pmu))
 		return 0;
 
-	ret = pmu->commit_txn(pmu);
-	if (!ret) {
-		pmu->cancel_txn(pmu);
-		return 0;
-	}
-
 group_error:
 	/*
 	 * Groups can be scheduled in as one unit only, so undo any

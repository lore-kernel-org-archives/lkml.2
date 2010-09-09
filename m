Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab0IITuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:50:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:33088 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133Ab0IITuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:50:14 -0400
Date: Thu, 9 Sep 2010 19:49:25 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@redhat.com, dengcheng.zhu@gmail.com, a.p.zijlstra@chello.nl,
        yanmin_zhang@linux.intel.com, gorcunov@gmail.com, fweisbec@gmail.com,
        robert.richter@amd.com, ming.m.lin@intel.com, tglx@linutronix.de,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        eranian@googlemail.com, will.deacon@arm.com, lethal@linux-sh.org,
        davem@davemloft.net, mingo@elte.hu, mcree@orcon.net.nz
Reply-To: mingo@redhat.com, dengcheng.zhu@gmail.com, a.p.zijlstra@chello.nl,
        yanmin_zhang@linux.intel.com, gorcunov@gmail.com, fweisbec@gmail.com,
        robert.richter@amd.com, ming.m.lin@intel.com, tglx@linutronix.de,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        eranian@googlemail.com, will.deacon@arm.com, lethal@linux-sh.org,
        davem@davemloft.net, mingo@elte.hu, mcree@orcon.net.nz
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Default PMU ops
Message-ID: <tip-ad5133b7030d04ce7701aa7cbe98f561347c79c2@git.kernel.org>
Git-Commit-ID: ad5133b7030d04ce7701aa7cbe98f561347c79c2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:49:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ad5133b7030d04ce7701aa7cbe98f561347c79c2
Gitweb:     http://git.kernel.org/tip/ad5133b7030d04ce7701aa7cbe98f561347c79c2
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 15 Jun 2010 12:22:39 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Sep 2010 20:46:30 +0200

perf: Default PMU ops

Provide default implementations for the pmu txn methods, this
allows us to remove some conditional code.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>
Cc: stephane eranian <eranian@googlemail.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Yanmin <yanmin_zhang@linux.intel.com>
Cc: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Cc: David Miller <davem@davemloft.net>
Cc: Michael Cree <mcree@orcon.net.nz>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |   10 +++---
 kernel/perf_event.c        |   64 +++++++++++++++++++++++++++++++++++--------
 2 files changed, 57 insertions(+), 17 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 6abf103..bf85733 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
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
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 5ed0c06..8ef4ba3 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -674,21 +674,14 @@ group_sched_in(struct perf_event *group_event,
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
 
@@ -702,7 +695,7 @@ group_sched_in(struct perf_event *group_event,
 		}
 	}
 
-	if (!txn || !pmu->commit_txn(pmu))
+	if (!pmu->commit_txn(pmu))
 		return 0;
 
 group_error:
@@ -717,8 +710,7 @@ group_error:
 	}
 	event_sched_out(group_event, cpuctx, ctx);
 
-	if (txn)
-		pmu->cancel_txn(pmu);
+	pmu->cancel_txn(pmu);
 
 	return -EAGAIN;
 }
@@ -4965,6 +4957,31 @@ static LIST_HEAD(pmus);
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
@@ -4974,6 +4991,29 @@ int perf_pmu_register(struct pmu *pmu)
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

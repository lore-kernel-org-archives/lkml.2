Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab0EYP61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:58:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:47456 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab0EYP60 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:58:26 -0400
Subject: Re: [PATCH] perf_events: fix event scheduling issues introduced by
 transactional API (take 2)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: eranian@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       acme@infradead.org, ming.m.lin@intel.com, perfmon2-devel@lists.sf.net
In-Reply-To: <1274801531.5882.1670.camel@twins>
References: <4bfbceef.e495e30a.5dae.61b6@mx.google.com>
	 <1274794518.5882.1280.camel@twins>
	 <AANLkTilEnIrY2HDdxDMdDIfkz8j1ueTbOf0CmD1y14ra@mail.gmail.com>
	 <1274796225.5882.1389.camel@twins>
	 <AANLkTinTfqLdRbgqRfn4Avl6bedB6xyLbRybwencYRiF@mail.gmail.com>
	 <AANLkTimWx4fnqA5hviwv8gOTH1eydC0SMllcmsQp8jSB@mail.gmail.com>
	 <1274801531.5882.1670.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 May 2010 17:58:06 +0200
Message-ID: <1274803086.5882.1752.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 17:32 +0200, Peter Zijlstra wrote:
> > Because you always call cancel_txn() even when commit()
> > succeeds. I don't really understand why. I think it could be
> > avoided by clearing the group_flag in commit_txn() if it
> > succeeds. It would also make the logical flow more natural. Why
> > cancel something that has succeeded. You cancel when you fail/abort.
> 
> Gah, I forgot about that. I think I suggested to Lin to do that and
> then
> promptly forgot.
> 
> Let me add that and at least push this patch fwd, we can try and clean
> up that detail later on. 

How about something like the below?

---
Subject: perf: Cleanup {start,commit,cancel}_txn details
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue May 25 17:49:05 CEST 2010

Clarify some of the transactional group scheduling API details
and change it so that a successfull ->commit_txn also closes
the transaction.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/powerpc/kernel/perf_event.c |    7 ++++---
 arch/sparc/kernel/perf_event.c   |    7 ++++---
 arch/x86/kernel/cpu/perf_event.c |   14 +++++---------
 include/linux/perf_event.h       |   27 ++++++++++++++++++++++-----
 kernel/perf_event.c              |    8 +-------
 5 files changed, 36 insertions(+), 27 deletions(-)

Index: linux-2.6/arch/powerpc/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_event.c
+++ linux-2.6/arch/powerpc/kernel/perf_event.c
@@ -754,7 +754,7 @@ static int power_pmu_enable(struct perf_
 	 * skip the schedulability test here, it will be peformed
 	 * at commit time(->commit_txn) as a whole
 	 */
-	if (cpuhw->group_flag & PERF_EVENT_TXN_STARTED)
+	if (cpuhw->group_flag & PERF_EVENT_TXN)
 		goto nocheck;
 
 	if (check_excludes(cpuhw->event, cpuhw->flags, n0, 1))
@@ -858,7 +858,7 @@ void power_pmu_start_txn(const struct pm
 {
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
-	cpuhw->group_flag |= PERF_EVENT_TXN_STARTED;
+	cpuhw->group_flag |= PERF_EVENT_TXN;
 	cpuhw->n_txn_start = cpuhw->n_events;
 }
 
@@ -871,7 +871,7 @@ void power_pmu_cancel_txn(const struct p
 {
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
-	cpuhw->group_flag &= ~PERF_EVENT_TXN_STARTED;
+	cpuhw->group_flag &= ~PERF_EVENT_TXN;
 }
 
 /*
@@ -897,6 +897,7 @@ int power_pmu_commit_txn(const struct pm
 	for (i = cpuhw->n_txn_start; i < n; ++i)
 		cpuhw->event[i]->hw.config = cpuhw->events[i];
 
+	cpuhw->group_flag &= ~PERF_EVENT_TXN;
 	return 0;
 }
 
Index: linux-2.6/arch/sparc/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/perf_event.c
+++ linux-2.6/arch/sparc/kernel/perf_event.c
@@ -1005,7 +1005,7 @@ static int sparc_pmu_enable(struct perf_
 	 * skip the schedulability test here, it will be peformed
 	 * at commit time(->commit_txn) as a whole
 	 */
-	if (cpuc->group_flag & PERF_EVENT_TXN_STARTED)
+	if (cpuc->group_flag & PERF_EVENT_TXN)
 		goto nocheck;
 
 	if (check_excludes(cpuc->event, n0, 1))
@@ -1102,7 +1102,7 @@ static void sparc_pmu_start_txn(const st
 {
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
-	cpuhw->group_flag |= PERF_EVENT_TXN_STARTED;
+	cpuhw->group_flag |= PERF_EVENT_TXN;
 }
 
 /*
@@ -1114,7 +1114,7 @@ static void sparc_pmu_cancel_txn(const s
 {
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
-	cpuhw->group_flag &= ~PERF_EVENT_TXN_STARTED;
+	cpuhw->group_flag &= ~PERF_EVENT_TXN;
 }
 
 /*
@@ -1137,6 +1137,7 @@ static int sparc_pmu_commit_txn(const st
 	if (sparc_check_constraints(cpuc->event, cpuc->events, n))
 		return -EAGAIN;
 
+	cpuhw->group_flag &= ~PERF_EVENT_TXN;
 	return 0;
 }
 
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -969,7 +969,7 @@ static int x86_pmu_enable(struct perf_ev
 	 * skip the schedulability test here, it will be peformed
 	 * at commit time(->commit_txn) as a whole
 	 */
-	if (cpuc->group_flag & PERF_EVENT_TXN_STARTED)
+	if (cpuc->group_flag & PERF_EVENT_TXN)
 		goto out;
 
 	ret = x86_pmu.schedule_events(cpuc, n, assign);
@@ -1096,7 +1096,7 @@ static void x86_pmu_disable(struct perf_
 	 * The events never got scheduled and ->cancel_txn will truncate
 	 * the event_list.
 	 */
-	if (cpuc->group_flags & PERF_EVENT_TXN_STARTED)
+	if (cpuc->group_flags & PERF_EVENT_TXN)
 		return;
 
 	x86_pmu_stop(event);
@@ -1388,7 +1388,7 @@ static void x86_pmu_start_txn(const stru
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
-	cpuc->group_flag |= PERF_EVENT_TXN_STARTED;
+	cpuc->group_flag |= PERF_EVENT_TXN;
 	cpuc->n_txn = 0;
 }
 
@@ -1401,7 +1401,7 @@ static void x86_pmu_cancel_txn(const str
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
-	cpuc->group_flag &= ~PERF_EVENT_TXN_STARTED;
+	cpuc->group_flag &= ~PERF_EVENT_TXN;
 	/*
 	 * Truncate the collected events.
 	 */
@@ -1435,11 +1435,7 @@ static int x86_pmu_commit_txn(const stru
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
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
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
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -668,15 +668,9 @@ group_sched_in(struct perf_event *group_
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


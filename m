Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab0EaHU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:20:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:42501 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756443Ab0EaHUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:20:53 -0400
Date: Mon, 31 May 2010 07:20:26 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1274796225.5882.1389.camel@twins>
References: <1274796225.5882.1389.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_events: Fix event scheduling issues introduced by transactional API
Message-ID: <tip-90151c35b19633e0cab5a6c80f1ba4a51e7c913b@git.kernel.org>
Git-Commit-ID: 90151c35b19633e0cab5a6c80f1ba4a51e7c913b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 May 2010 07:20:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  90151c35b19633e0cab5a6c80f1ba4a51e7c913b
Gitweb:     http://git.kernel.org/tip/90151c35b19633e0cab5a6c80f1ba4a51e7c913b
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 25 May 2010 16:23:10 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 May 2010 08:46:10 +0200

perf_events: Fix event scheduling issues introduced by transactional API

The transactional API patch between the generic and model-specific
code introduced several important bugs with event scheduling, at
least on X86. If you had pinned events, e.g., watchdog,  and were
over-committing the PMU, you would get bogus counts. The bug was
showing up on Intel CPU because events would move around more
often that on AMD. But the problem also existed on AMD, though
harder to expose.

The issues were:

 - group_sched_in() was missing a cancel_txn() in the error path

 - cpuc->n_added was not properly maintained, leading to missing
   actions in hw_perf_enable(), i.e., n_running being 0. You cannot
   update n_added until you know the transaction has succeeded. In
   case of failed transaction n_added was not adjusted back.

 - in case of failed transactions, event_sched_out() was called
   and eventually invoked x86_disable_event() to touch the HW reg.
   But with transactions, on X86, event_sched_in() does not touch
   HW registers, it simply collects events into a list. Thus, you
   could end up calling x86_disable_event() on a counter which
   did not correspond to the current event when idx != -1.

The patch modifies the generic and X86 code to avoid all those problems.

First, we keep track of the number of events added last. In case the
transaction fails, we substract them from n_added. This approach is
necessary (as opposed to delaying updates to n_added) because not all
event updates use the transaction API, e.g., single events.

Second, we encapsulate the event_sched_in() and event_sched_out() in
group_sched_in() inside the transaction. That makes the operations
symmetrical and you can also detect that you are inside a transaction
and skip the HW reg access by checking cpuc->group_flag.

With this patch, you can now overcommit the PMU even with pinned
system-wide events present and still get valid counts.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1274796225.5882.1389.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   22 ++++++++++++++++++++++
 kernel/perf_event.c              |   11 +++++++----
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c775860..5db5b7d 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -106,6 +106,7 @@ struct cpu_hw_events {
 
 	int			n_events;
 	int			n_added;
+	int			n_txn;
 	int			assign[X86_PMC_IDX_MAX]; /* event to counter assignment */
 	u64			tags[X86_PMC_IDX_MAX];
 	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
@@ -983,6 +984,7 @@ static int x86_pmu_enable(struct perf_event *event)
 out:
 	cpuc->n_events = n;
 	cpuc->n_added += n - n0;
+	cpuc->n_txn += n - n0;
 
 	return 0;
 }
@@ -1089,6 +1091,14 @@ static void x86_pmu_disable(struct perf_event *event)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int i;
 
+	/*
+	 * If we're called during a txn, we don't need to do anything.
+	 * The events never got scheduled and ->cancel_txn will truncate
+	 * the event_list.
+	 */
+	if (cpuc->group_flag & PERF_EVENT_TXN_STARTED)
+		return;
+
 	x86_pmu_stop(event);
 
 	for (i = 0; i < cpuc->n_events; i++) {
@@ -1379,6 +1389,7 @@ static void x86_pmu_start_txn(const struct pmu *pmu)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
 	cpuc->group_flag |= PERF_EVENT_TXN_STARTED;
+	cpuc->n_txn = 0;
 }
 
 /*
@@ -1391,6 +1402,11 @@ static void x86_pmu_cancel_txn(const struct pmu *pmu)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
 	cpuc->group_flag &= ~PERF_EVENT_TXN_STARTED;
+	/*
+	 * Truncate the collected events.
+	 */
+	cpuc->n_added -= cpuc->n_txn;
+	cpuc->n_events -= cpuc->n_txn;
 }
 
 /*
@@ -1419,6 +1435,12 @@ static int x86_pmu_commit_txn(const struct pmu *pmu)
 	 */
 	memcpy(cpuc->assign, assign, n*sizeof(int));
 
+	/*
+	 * Clear out the txn count so that ->cancel_txn() which gets
+	 * run after ->commit_txn() doesn't undo things.
+	 */
+	cpuc->n_txn = 0;
+
 	return 0;
 }
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 10a1aee..42a0e91 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -687,8 +687,11 @@ group_sched_in(struct perf_event *group_event,
 	if (txn)
 		pmu->start_txn(pmu);
 
-	if (event_sched_in(group_event, cpuctx, ctx))
+	if (event_sched_in(group_event, cpuctx, ctx)) {
+		if (txn)
+			pmu->cancel_txn(pmu);
 		return -EAGAIN;
+	}
 
 	/*
 	 * Schedule in siblings as one group (if any):
@@ -710,9 +713,6 @@ group_sched_in(struct perf_event *group_event,
 	}
 
 group_error:
-	if (txn)
-		pmu->cancel_txn(pmu);
-
 	/*
 	 * Groups can be scheduled in as one unit only, so undo any
 	 * partial group before returning:
@@ -724,6 +724,9 @@ group_error:
 	}
 	event_sched_out(group_event, cpuctx, ctx);
 
+	if (txn)
+		pmu->cancel_txn(pmu);
+
 	return -EAGAIN;
 }
 

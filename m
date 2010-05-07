Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab0EGSpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:45:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:46665 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757632Ab0EGSps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:45:48 -0400
Date: Fri, 7 May 2010 18:44:32 GMT
From: tip-bot for Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, eranian@google.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       davem@davemloft.net, fweisbec@gmail.com, ming.m.lin@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       davem@davemloft.net, fweisbec@gmail.com, ming.m.lin@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1272002160.5707.60.camel@minggr.sh.intel.com>
References: <1272002160.5707.60.camel@minggr.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Add group scheduling transactional APIs
Message-ID: <tip-6bde9b6ce0127e2a56228a2071536d422be31336@git.kernel.org>
Git-Commit-ID: 6bde9b6ce0127e2a56228a2071536d422be31336
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 May 2010 18:44:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6bde9b6ce0127e2a56228a2071536d422be31336
Gitweb:     http://git.kernel.org/tip/6bde9b6ce0127e2a56228a2071536d422be31336
Author:     Lin Ming <ming.m.lin@intel.com>
AuthorDate: Fri, 23 Apr 2010 13:56:00 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 May 2010 11:31:02 +0200

perf: Add group scheduling transactional APIs

Add group scheduling transactional APIs to struct pmu.
These APIs will be implemented in arch code, based on Peter's idea as
below.

> the idea behind hw_perf_group_sched_in() is to not perform
> schedulability tests on each event in the group, but to add the group
> as a whole and then perform one test.
>
> Of course, when that test fails, you'll have to roll-back the whole
> group again.
>
> So start_txn (or a better name) would simply toggle a flag in the pmu
> implementation that will make pmu::enable() not perform the
> schedulablilty test.
>
> Then commit_txn() will perform the schedulability test (so note the
> method has to have a !void return value.
>
> This will allow us to use the regular
> kernel/perf_event.c::group_sched_in() and all the rollback code.
> Currently each hw_perf_group_sched_in() implementation duplicates all
> the rolllback code (with various bugs).

->start_txn:
Start group events scheduling transaction, set a flag to make
pmu::enable() not perform the schedulability test, it will be performed
at commit time.

->commit_txn:
Commit group events scheduling transaction, perform the group
schedulability as a whole

->cancel_txn:
Stop group events scheduling transaction, clear the flag so
pmu::enable() will perform the schedulability test.

Reviewed-by: Stephane Eranian <eranian@google.com>
Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Cc: David Miller <davem@davemloft.net>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1272002160.5707.60.camel@minggr.sh.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |   15 ++++++++++++---
 kernel/perf_event.c        |   33 ++++++++++++++++++++-------------
 2 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 23cd005..4924c96 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -547,6 +547,8 @@ struct hw_perf_event {
 
 struct perf_event;
 
+#define PERF_EVENT_TXN_STARTED 1
+
 /**
  * struct pmu - generic performance monitoring unit
  */
@@ -557,6 +559,16 @@ struct pmu {
 	void (*stop)			(struct perf_event *event);
 	void (*read)			(struct perf_event *event);
 	void (*unthrottle)		(struct perf_event *event);
+
+	/*
+	 * group events scheduling is treated as a transaction,
+	 * add group events as a whole and perform one schedulability test.
+	 * If test fails, roll back the whole group
+	 */
+
+	void (*start_txn)	(const struct pmu *pmu);
+	void (*cancel_txn)	(const struct pmu *pmu);
+	int  (*commit_txn)	(const struct pmu *pmu);
 };
 
 /**
@@ -823,9 +835,6 @@ extern void perf_disable(void);
 extern void perf_enable(void);
 extern int perf_event_task_disable(void);
 extern int perf_event_task_enable(void);
-extern int hw_perf_group_sched_in(struct perf_event *group_leader,
-	       struct perf_cpu_context *cpuctx,
-	       struct perf_event_context *ctx);
 extern void perf_event_update_userpage(struct perf_event *event);
 extern int perf_event_release_kernel(struct perf_event *event);
 extern struct perf_event *
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 34659d4..bb06382 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -83,14 +83,6 @@ extern __weak const struct pmu *hw_perf_event_init(struct perf_event *event)
 void __weak hw_perf_disable(void)		{ barrier(); }
 void __weak hw_perf_enable(void)		{ barrier(); }
 
-int __weak
-hw_perf_group_sched_in(struct perf_event *group_leader,
-	       struct perf_cpu_context *cpuctx,
-	       struct perf_event_context *ctx)
-{
-	return 0;
-}
-
 void __weak perf_event_print_debug(void)	{ }
 
 static DEFINE_PER_CPU(int, perf_disable_count);
@@ -644,15 +636,20 @@ group_sched_in(struct perf_event *group_event,
 	       struct perf_cpu_context *cpuctx,
 	       struct perf_event_context *ctx)
 {
-	struct perf_event *event, *partial_group;
+	struct perf_event *event, *partial_group = NULL;
+	const struct pmu *pmu = group_event->pmu;
+	bool txn = false;
 	int ret;
 
 	if (group_event->state == PERF_EVENT_STATE_OFF)
 		return 0;
 
-	ret = hw_perf_group_sched_in(group_event, cpuctx, ctx);
-	if (ret)
-		return ret < 0 ? ret : 0;
+	/* Check if group transaction availabe */
+	if (pmu->start_txn)
+		txn = true;
+
+	if (txn)
+		pmu->start_txn(pmu);
 
 	if (event_sched_in(group_event, cpuctx, ctx))
 		return -EAGAIN;
@@ -667,9 +664,19 @@ group_sched_in(struct perf_event *group_event,
 		}
 	}
 
-	return 0;
+	if (txn) {
+		ret = pmu->commit_txn(pmu);
+		if (!ret) {
+			pmu->cancel_txn(pmu);
+
+			return 0;
+		}
+	}
 
 group_error:
+	if (txn)
+		pmu->cancel_txn(pmu);
+
 	/*
 	 * Groups can be scheduled in as one unit only, so undo any
 	 * partial group before returning:

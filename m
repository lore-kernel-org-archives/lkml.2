Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab0DWFzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 01:55:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:11011 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755884Ab0DWFzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 01:55:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,260,1270450800"; 
   d="scan'208";a="269211820"
Subject: [RFC][PATCH v2 1/4] perf: core, add group scheduling transactional
 APIs
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 23 Apr 2010 13:56:00 +0800
Message-Id: <1272002160.5707.60.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add group scheduling transactional APIs to struct pmu.
These APIs will be implemented in arch code, based on Peter's idea as
below.

> the idea behind hw_perf_group_sched_in() is to not perform
> schedulability tests on each event in the group, but to add the group
as
> a whole and then perform one test.
>
> Of course, when that test fails, you'll have to roll-back the whole
> group again.
>
> So start_txn (or a better name) would simply toggle a flag in the pmu
> implementation that will make pmu::enable() not perform the
> schedulablilty test.
>
> Then commit_txn() will perform the schedulability test (so note the
> method has to have a !void return value, my mistake in the earlier
> email).
>
> This will allow us to use the regular
> kernel/perf_event.c::group_sched_in() and all the rollback code.
> Currently each hw_perf_group_sched_in() implementation duplicates all
> the rolllback code (with various bugs).

*_txn was renamed to *_group_trans for better readability.

->start_group_trans:
Start group events scheduling transaction, set a flag to make
pmu::enable() not perform the schedulability test, it will be performed
at commit time.

->commit_group_trans:
Commit group events scheduling transaction, perform the group
schedulability as a whole

->stop_group_trans:
Stop group events scheduling transaction, clear the flag so
pmu::enable() will perform the schedulability test.

Reviewed-by: Stephane Eranian <eranian@google.com>
Reviewed-by: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>

---
 include/linux/perf_event.h |   20 +++++++++++++++++---
 kernel/perf_event.c        |   33 ++++++++++++++++++++-------------
 2 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ace31fb..f514825 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -532,6 +532,8 @@ struct hw_perf_event {
 
 struct perf_event;
 
+#define PERF_EVENT_TRAN_STARTED 1
+
 /**
  * struct pmu - generic performance monitoring unit
  */
@@ -542,6 +544,21 @@ struct pmu {
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
+	/* start group events transaction  */
+	void (*start_group_trans)	(const struct pmu *pmu);
+
+	/* stop group events transaction  */
+	void (*stop_group_trans)	(const struct pmu *pmu);
+
+	/* commit group events transaction */
+	int (*commit_group_trans)	(const struct pmu *pmu);
 };
 
 /**
@@ -807,9 +824,6 @@ extern void perf_disable(void);
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
index 9dbe8cd..eac6fe7 100644
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
@@ -641,15 +633,20 @@ group_sched_in(struct perf_event *group_event,
 	       struct perf_cpu_context *cpuctx,
 	       struct perf_event_context *ctx)
 {
-	struct perf_event *event, *partial_group;
+	struct perf_event *event, *partial_group = NULL;
+	const struct pmu *pmu = group_event->pmu;
+	bool trans = false;
 	int ret;
 
 	if (group_event->state == PERF_EVENT_STATE_OFF)
 		return 0;
 
-	ret = hw_perf_group_sched_in(group_event, cpuctx, ctx);
-	if (ret)
-		return ret < 0 ? ret : 0;
+	/* Check if group transaction availabe */
+	if (pmu->start_group_trans)
+		trans = true;
+
+	if (trans)
+		pmu->start_group_trans(pmu);
 
 	if (event_sched_in(group_event, cpuctx, ctx))
 		return -EAGAIN;
@@ -664,9 +661,19 @@ group_sched_in(struct perf_event *group_event,
 		}
 	}
 
-	return 0;
+	if (trans) {
+		ret = pmu->commit_group_trans(pmu);
+		if (!ret) {
+			pmu->stop_group_trans(pmu);
+
+			return 0;
+		}
+	}
 
 group_error:
+	if (trans)
+		pmu->stop_group_trans(pmu);
+
 	/*
 	 * Groups can be scheduled in as one unit only, so undo any
 	 * partial group before returning:




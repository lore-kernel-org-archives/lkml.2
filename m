Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab0DVHuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 03:50:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:20189 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab0DVHuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 03:50:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,254,1270450800"; 
   d="scan'208";a="560420755"
Subject: [RFC][PATCH 1/4] perf: core, add group scheduling transactional
 APIs
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>, arjan@linux.intel.com,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 22 Apr 2010 15:51:02 +0800
Message-Id: <1271922662.30535.107.camel@minggr.sh.intel.com>
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


Reviewed-by: Stephane Eranian <eranian@google.com>
Reviewed-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 include/linux/perf_event.h |    8 +++++---
 kernel/perf_event.c        |   29 ++++++++++++++++-------------
 2 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ace31fb..b16cfba 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -532,6 +532,8 @@ struct hw_perf_event {
 
 struct perf_event;
 
+#define PERF_EVENT_TRAN_STARTED 1
+
 /**
  * struct pmu - generic performance monitoring unit
  */
@@ -542,6 +544,9 @@ struct pmu {
 	void (*stop)			(struct perf_event *event);
 	void (*read)			(struct perf_event *event);
 	void (*unthrottle)		(struct perf_event *event);
+	void (*start_txn)		(const struct pmu *pmu);
+	void (*stop_txn)		(const struct pmu *pmu);
+	int (*commit_txn)		(const struct pmu *pmu);
 };
 
 /**
@@ -807,9 +812,6 @@ extern void perf_disable(void);
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
index 9dbe8cd..ffd2360 100644
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
@@ -641,15 +633,15 @@ group_sched_in(struct perf_event *group_event,
 	       struct perf_cpu_context *cpuctx,
 	       struct perf_event_context *ctx)
 {
-	struct perf_event *event, *partial_group;
+	struct perf_event *event, *partial_group = NULL;
+	const struct pmu *pmu = group_event->pmu;
 	int ret;
 
 	if (group_event->state == PERF_EVENT_STATE_OFF)
 		return 0;
 
-	ret = hw_perf_group_sched_in(group_event, cpuctx, ctx);
-	if (ret)
-		return ret < 0 ? ret : 0;
+	if (pmu->start_txn)
+		pmu->start_txn(pmu);
 
 	if (event_sched_in(group_event, cpuctx, ctx))
 		return -EAGAIN;
@@ -664,9 +656,20 @@ group_sched_in(struct perf_event *group_event,
 		}
 	}
 
-	return 0;
+	if (pmu->commit_txn) {
+		ret = pmu->commit_txn(pmu);
+		if (!ret) {
+			if (pmu->stop_txn)
+				pmu->stop_txn(pmu);
+
+			return 0;
+		}
+	}
 
 group_error:
+	if (pmu->stop_txn)
+		pmu->stop_txn(pmu);
+
 	/*
 	 * Groups can be scheduled in as one unit only, so undo any
 	 * partial group before returning:



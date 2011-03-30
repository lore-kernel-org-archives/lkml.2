Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964836Ab1C3VuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:50:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:60385 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933450Ab1C3VHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447549"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: venki@google.com, a.p.zijlstra@chello.nl, ak@linux.intel.com,
        mingo@elte.hu, efault@gmx.de, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [104/275] sched: Remove irq time from available CPU power
Message-Id: <20110330210543.2885D3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
Commit: aa483808516ca5cacfa0e5849691f64fec25828e upstream

The idea was suggested by Peter Zijlstra here:

  http://marc.info/?l=linux-kernel&m=127476934517534&w=2

irq time is technically not available to the tasks running on the CPU.
This patch removes irq time from CPU power piggybacking on
sched_rt_avg_update().

Tested this by keeping CPU X busy with a network intensive task having 75%
oa a single CPU irq processing (hard+soft) on a 4-way system. And start seven
cycle soakers on the system. Without this change, there will be two tasks on
each CPU. With this change, there is a single task on irq busy CPU X and
remaining 7 tasks are spread around among other 3 CPUs.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <1286237003-12406-8-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c          |   18 ++++++++++++++++++
 kernel/sched_fair.c     |    7 ++++++-
 kernel/sched_features.h |    5 +++++
 3 files changed, 29 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/kernel/sched.c
===================================================================
--- linux-2.6.35.y.orig/kernel/sched.c	2011-03-29 23:03:00.319292001 -0700
+++ linux-2.6.35.y/kernel/sched.c	2011-03-29 23:54:58.951494004 -0700
@@ -519,6 +519,10 @@
 	u64 avg_idle;
 #endif
 
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+	u64 prev_irq_time;
+#endif
+
 	/* calc_load related fields */
 	unsigned long calc_load_update;
 	long calc_load_active;
@@ -643,6 +647,7 @@
 #endif /* CONFIG_CGROUP_SCHED */
 
 static u64 irq_time_cpu(int cpu);
+static void sched_irq_time_avg_update(struct rq *rq, u64 irq_time);
 
 inline void update_rq_clock(struct rq *rq)
 {
@@ -654,6 +659,8 @@
 	irq_time = irq_time_cpu(cpu);
 	if (rq->clock - irq_time > rq->clock_task)
 		rq->clock_task = rq->clock - irq_time;
+
+	sched_irq_time_avg_update(rq, irq_time);
 }
 
 /*
@@ -1895,6 +1902,15 @@
 	local_irq_restore(flags);
 }
 
+static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time)
+{
+	if (sched_clock_irqtime && sched_feat(NONIRQ_POWER)) {
+		u64 delta_irq = curr_irq_time - rq->prev_irq_time;
+		rq->prev_irq_time = curr_irq_time;
+		sched_rt_avg_update(rq, delta_irq);
+	}
+}
+
 #else
 
 static u64 irq_time_cpu(int cpu)
@@ -1902,6 +1918,8 @@
 	return 0;
 }
 
+static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time) { }
+
 #endif
 
 #include "sched_stats.h"
Index: linux-2.6.35.y/kernel/sched_features.h
===================================================================
--- linux-2.6.35.y.orig/kernel/sched_features.h	2011-03-29 22:51:28.061005159 -0700
+++ linux-2.6.35.y/kernel/sched_features.h	2011-03-29 23:03:00.345291335 -0700
@@ -61,3 +61,8 @@
  * release the lock. Decreases scheduling overhead.
  */
 SCHED_FEAT(OWNER_SPIN, 1)
+
+/*
+ * Decrement CPU power based on irq activity
+ */
+SCHED_FEAT(NONIRQ_POWER, 1)
Index: linux-2.6.35.y/kernel/sched_fair.c
===================================================================
--- linux-2.6.35.y.orig/kernel/sched_fair.c	2011-03-29 23:03:00.320291975 -0700
+++ linux-2.6.35.y/kernel/sched_fair.c	2011-03-29 23:54:58.089516061 -0700
@@ -2276,8 +2276,13 @@
 	u64 total, available;
 
 	total = sched_avg_period() + (rq->clock - rq->age_stamp);
-	available = total - rq->rt_avg;
 
+	if (unlikely(total < rq->rt_avg)) {
+		/* Ensures that power won't end up being negative */
+		available = 0;
+	} else {
+		available = total - rq->rt_avg;
+	}
 	if (unlikely((s64)total < SCHED_LOAD_SCALE))
 		total = SCHED_LOAD_SCALE;
 

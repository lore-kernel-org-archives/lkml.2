Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706Ab0JRT1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:27:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:58859 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757488Ab0JRT1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:27:15 -0400
Date: Mon, 18 Oct 2010 19:26:50 GMT
From: tip-bot for Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, venki@google.com,
        mingo@elte.hu
In-Reply-To: <1286237003-12406-8-git-send-email-venki@google.com>
References: <1286237003-12406-8-git-send-email-venki@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove irq time from available CPU power
Message-ID: <tip-aa483808516ca5cacfa0e5849691f64fec25828e@git.kernel.org>
Git-Commit-ID: aa483808516ca5cacfa0e5849691f64fec25828e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:26:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aa483808516ca5cacfa0e5849691f64fec25828e
Gitweb:     http://git.kernel.org/tip/aa483808516ca5cacfa0e5849691f64fec25828e
Author:     Venkatesh Pallipadi <venki@google.com>
AuthorDate: Mon, 4 Oct 2010 17:03:22 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 20:52:27 +0200

sched: Remove irq time from available CPU power

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
LKML-Reference: <1286237003-12406-8-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c          |   18 ++++++++++++++++++
 kernel/sched_fair.c     |    8 +++++++-
 kernel/sched_features.h |    5 +++++
 3 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9e01b71..bff9ef5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -519,6 +519,10 @@ struct rq {
 	u64 avg_idle;
 #endif
 
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+	u64 prev_irq_time;
+#endif
+
 	/* calc_load related fields */
 	unsigned long calc_load_update;
 	long calc_load_active;
@@ -643,6 +647,7 @@ static inline struct task_group *task_group(struct task_struct *p)
 #endif /* CONFIG_CGROUP_SCHED */
 
 static u64 irq_time_cpu(int cpu);
+static void sched_irq_time_avg_update(struct rq *rq, u64 irq_time);
 
 inline void update_rq_clock(struct rq *rq)
 {
@@ -654,6 +659,8 @@ inline void update_rq_clock(struct rq *rq)
 		irq_time = irq_time_cpu(cpu);
 		if (rq->clock - irq_time > rq->clock_task)
 			rq->clock_task = rq->clock - irq_time;
+
+		sched_irq_time_avg_update(rq, irq_time);
 	}
 }
 
@@ -1985,6 +1992,15 @@ void account_system_vtime(struct task_struct *curr)
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
@@ -1992,6 +2008,8 @@ static u64 irq_time_cpu(int cpu)
 	return 0;
 }
 
+static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time) { }
+
 #endif
 
 #include "sched_idletask.c"
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c358d40..74cccfa 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2275,7 +2275,13 @@ unsigned long scale_rt_power(int cpu)
 	u64 total, available;
 
 	total = sched_avg_period() + (rq->clock - rq->age_stamp);
-	available = total - rq->rt_avg;
+
+	if (unlikely(total < rq->rt_avg)) {
+		/* Ensures that power won't end up being negative */
+		available = 0;
+	} else {
+		available = total - rq->rt_avg;
+	}
 
 	if (unlikely((s64)total < SCHED_LOAD_SCALE))
 		total = SCHED_LOAD_SCALE;
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 83c66e8..185f920 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -61,3 +61,8 @@ SCHED_FEAT(ASYM_EFF_LOAD, 1)
  * release the lock. Decreases scheduling overhead.
  */
 SCHED_FEAT(OWNER_SPIN, 1)
+
+/*
+ * Decrement CPU power based on irq activity
+ */
+SCHED_FEAT(NONIRQ_POWER, 1)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab0I2TWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 15:22:34 -0400
Received: from smtp-out.google.com ([216.239.44.51]:51516 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab0I2TWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 15:22:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:x-system-of-record;
	b=vbAsPkx0x1vSuPEjccNd9lxRSa2Oe3aMR55oJw8iTFBNFLzl4OHioUCUJhb7FCvJf
	S5a9PgZIT84NpSq55fXQQ==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 6/7] sched: Remove irq time from available CPU power -v3
Date: Wed, 29 Sep 2010 12:21:35 -0700
Message-Id: <1285788096-29471-7-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285788096-29471-1-git-send-email-venki@google.com>
References: <1285788096-29471-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea suggested by Peter Zijlstra here.
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
---
 kernel/sched.c          |   18 ++++++++++++++++++
 kernel/sched_fair.c     |    8 +++++++-
 kernel/sched_features.h |    5 +++++
 3 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 771bfa9..bfbe064 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -521,6 +521,10 @@ struct rq {
 	u64 avg_idle;
 #endif
 
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+	u64 prev_irq_time;
+#endif
+
 	/* calc_load related fields */
 	unsigned long calc_load_update;
 	long calc_load_active;
@@ -645,6 +649,7 @@ static inline struct task_group *task_group(struct task_struct *p)
 #endif /* CONFIG_CGROUP_SCHED */
 
 static u64 irq_time_cpu(int cpu);
+static void sched_irq_time_avg_update(struct rq *rq, u64 irq_time);
 
 inline void update_rq_clock(struct rq *rq)
 {
@@ -656,6 +661,8 @@ inline void update_rq_clock(struct rq *rq)
 		irq_time = irq_time_cpu(cpu);
 		if (rq->clock - irq_time > rq->clock_task)
 			rq->clock_task = rq->clock - irq_time;
+
+		sched_irq_time_avg_update(rq, irq_time);
 	}
 }
 
@@ -1983,6 +1990,15 @@ void account_system_vtime(struct task_struct *curr)
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
@@ -1990,6 +2006,8 @@ static u64 irq_time_cpu(int cpu)
 	return 0;
 }
 
+static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time) { }
+
 #endif
 
 #include "sched_idletask.c"
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0baa696..6d0362a 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2268,7 +2268,13 @@ unsigned long scale_rt_power(int cpu)
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
-- 
1.7.1


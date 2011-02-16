Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674Ab1BPByj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:54:39 -0500
Received: from kroah.org ([198.145.64.141]:49372 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758525Ab1BPBwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:52:00 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:04 2011
Message-Id: <20110216014704.747571814@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:46:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Subject: [105/115] sched: Remove irq time from available CPU power
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
LKML-Reference: <1286237003-12406-8-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c          |   26 +++++++++++++++++++++++++-
 kernel/sched_features.h |    5 +++++
 2 files changed, 30 insertions(+), 1 deletion(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -553,6 +553,10 @@ struct rq {
 	u64 avg_idle;
 #endif
 
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+	u64 prev_irq_time;
+#endif
+
 	/* calc_load related fields */
 	unsigned long calc_load_update;
 	long calc_load_active;
@@ -622,6 +626,7 @@ static inline int cpu_of(struct rq *rq)
 #define raw_rq()		(&__raw_get_cpu_var(runqueues))
 
 static u64 irq_time_cpu(int cpu);
+static void sched_irq_time_avg_update(struct rq *rq, u64 irq_time);
 
 inline void update_rq_clock(struct rq *rq)
 {
@@ -632,6 +637,8 @@ inline void update_rq_clock(struct rq *r
 	irq_time = irq_time_cpu(cpu);
 	if (rq->clock - irq_time > rq->clock_task)
 		rq->clock_task = rq->clock - irq_time;
+
+	sched_irq_time_avg_update(rq, irq_time);
 }
 
 /*
@@ -1883,6 +1890,15 @@ void account_system_vtime(struct task_st
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
@@ -1890,6 +1906,8 @@ static u64 irq_time_cpu(int cpu)
 	return 0;
 }
 
+static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time) { }
+
 #endif
 
 #include "sched_stats.h"
@@ -3755,7 +3773,13 @@ unsigned long scale_rt_power(int cpu)
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
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -121,3 +121,8 @@ SCHED_FEAT(ASYM_EFF_LOAD, 1)
  * release the lock. Decreases scheduling overhead.
  */
 SCHED_FEAT(OWNER_SPIN, 1)
+
+/*
+ * Decrement CPU power based on irq activity
+ */
+SCHED_FEAT(NONIRQ_POWER, 1)



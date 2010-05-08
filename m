Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620Ab0EHBtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 21:49:25 -0400
Received: from smtp-out.google.com ([74.125.121.35]:17768 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab0EHBtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 21:49:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:x-system-of-record;
	b=OnOfxoMxqth58DilwQzdWdkC3/2iNFwPJJuq7vq/Lyzc15SAqH2pVJHPGNwVnni3e
	6wXaZtsbC8EBs2cxO7eUw==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Ken Chen <kenchen@google.com>,
       Paul Turner <pjt@google.com>, Nikhil Rao <ncrao@google.com>,
       Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH] sched: Avoid side-effect of tickless idle on update_cpu_load
Date: Fri,  7 May 2010 18:48:49 -0700
Message-Id: <1273283329-25258-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.0.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tickless idle has a negative side effect on update_cpu_load(),
which in turn can affect load balancing behavior.

update_cpu_load() is supposed to be called every tick, to keep track of
various load indicies. With tickless idle, there are no scheduler ticks called
on the idle CPUs. Idle CPUs may still do load balancing (with idle_load_balance
CPU) using the stale cpu_load. It will also cause problems when all CPUs go
idle for a while and become active again. In this case loads would not degrade
as expected.

This is how rq->nr_load_updates change looks like under different conditions:

<cpu_num> <nr_load_updates change>
All CPUS idle for 10 seconds (HZ=1000)
0 1621
10 496
11 139
12 875
13 1672
14 12
15 21
1 1472
2 2426
3 1161
4 2108
5 1525
6 701
7 249
8 766
9 1967

One CPU busy rest idle for 10 seconds
0 10003
10 601
11 95
12 966
13 1597
14 114
15 98
1 3457
2 93
3 6679
4 1425
5 1479
6 595
7 193
8 633
9 1687

All CPUs busy for 10 seconds
0 10026
10 10026
11 10026
12 10026
13 10025
14 10025
15 10025
1 10026
2 10026
3 10026
4 10026
5 10026
6 10026
7 10026
8 10026
9 10026

That is update_cpu_load works properly only when all CPUs are busy.
If all are idle, all the CPUs get way lower updates.
And when few CPUs are busy and rest are idle, only busy and ilb does
proper updates and rest of the idle CPUs will get lower updates.

The patch keeps track of when a last update was done and fixes up
the load avg based on current time.

On one of my test system SPECjbb with warehouse 1..numcpus, patch improves
throughput numbers by ~1% (average of 6 runs).
On another test system (with different domain hierarchy) there is no
noticable change in perf.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 kernel/sched.c      |   82 +++++++++++++++++++++++++++++++++++++++++++++++---
 kernel/sched_fair.c |    5 ++-
 2 files changed, 81 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3c2a54f..0abd7db 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -502,6 +502,7 @@ struct rq {
 	unsigned long nr_running;
 	#define CPU_LOAD_IDX_MAX 5
 	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
+	unsigned long last_load_update_tick;
 #ifdef CONFIG_NO_HZ
 	unsigned char in_nohz_recently;
 #endif
@@ -1816,6 +1817,7 @@ static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
 static void calc_load_account_active(struct rq *this_rq);
 static void update_sysctl(void);
 static int get_update_sysctl_factor(void);
+static void update_cpu_load(struct rq *this_rq);
 
 static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 {
@@ -3088,23 +3090,84 @@ static void calc_load_account_active(struct rq *this_rq)
 }
 
 /*
+ * Load degrade calculations below are approximated on a 128 point scale.
+ * degrade_zero_ticks is the number of ticks after which old_load at any
+ * particular idx is approximated to be zero.
+ * degrade_factor is a precomputed table, a row for each load idx.
+ * Each column corresponds to degradation factor for a power of two ticks,
+ * based on 128 point scale.
+ * Example:
+ * row 2, col 3 (=12) says that the degradation at load idx 2 after
+ * 8 ticks is 12/128 (which is an approximation of 3^8/4^8).
+ */
+#define DEGRADE_SHIFT		7
+static const unsigned char
+		degrade_zero_ticks[CPU_LOAD_IDX_MAX] = {0, 8, 32, 64, 128};
+static const unsigned char
+		degrade_factor[CPU_LOAD_IDX_MAX][DEGRADE_SHIFT + 1] = {
+					{0, 0, 0, 0, 0, 0, 0, 0},
+					{64, 32, 8, 0, 0, 0, 0, 0},
+					{96, 72, 40, 12, 1, 0, 0},
+					{112, 98, 75, 43, 15, 1, 0},
+					{120, 112, 98, 76, 45, 16, 2} };
+
+/*
+ * Update cpu_load for any backlog'd ticks. The backlog would be when
+ * CPU is idle and so we just decay the old load without adding any new load.
+ */
+static unsigned long update_backlog(unsigned long load,
+                        unsigned long missed_updates, int idx)
+{
+	int j = 0;
+
+	if (missed_updates >= degrade_zero_ticks[idx])
+		return 0;
+
+	if (idx == 1)
+		return load >> missed_updates;
+
+	while (missed_updates) {
+		if (missed_updates % 2)
+			load =(load * degrade_factor[idx][j]) >> DEGRADE_SHIFT;
+
+		missed_updates >>= 1;
+		j++;
+	}
+	return load;
+}
+
+/*
  * Update rq->cpu_load[] statistics. This function is usually called every
- * scheduler tick (TICK_NSEC).
+ * scheduler tick (TICK_NSEC). With tickless idle this will not be called
+ * every tick. We fix it up based on jiffies.
  */
 static void update_cpu_load(struct rq *this_rq)
 {
 	unsigned long this_load = this_rq->load.weight;
+	unsigned long curr_jiffies = jiffies;
+	unsigned long pending_updates, missed_updates;
 	int i, scale;
 
 	this_rq->nr_load_updates++;
 
+	if (curr_jiffies == this_rq->last_load_update_tick)
+		return;
+
+	pending_updates = curr_jiffies - this_rq->last_load_update_tick;
+	this_rq->last_load_update_tick = curr_jiffies;
+	missed_updates = pending_updates - 1;
+
 	/* Update our load: */
-	for (i = 0, scale = 1; i < CPU_LOAD_IDX_MAX; i++, scale += scale) {
+	this_rq->cpu_load[0] = this_load; /* Fasttrack for idx 0 */
+	for (i = 1, scale = 2; i < CPU_LOAD_IDX_MAX; i++, scale += scale) {
 		unsigned long old_load, new_load;
 
 		/* scale is effectively 1 << i now, and >> i divides by scale */
 
 		old_load = this_rq->cpu_load[i];
+		if (missed_updates)
+			old_load = update_backlog(old_load, missed_updates, i);
+
 		new_load = this_load;
 		/*
 		 * Round up the averaging division if load is increasing. This
@@ -3112,9 +3175,15 @@ static void update_cpu_load(struct rq *this_rq)
 		 * example.
 		 */
 		if (new_load > old_load)
-			new_load += scale-1;
-		this_rq->cpu_load[i] = (old_load*(scale-1) + new_load) >> i;
+			new_load += scale - 1;
+
+		this_rq->cpu_load[i] = (old_load * (scale - 1) + new_load) >> i;
 	}
+}
+
+static void update_cpu_load_active(struct rq *this_rq)
+{
+	update_cpu_load(this_rq);
 
 	if (time_after_eq(jiffies, this_rq->calc_load_update)) {
 		this_rq->calc_load_update += LOAD_FREQ;
@@ -3522,7 +3591,7 @@ void scheduler_tick(void)
 
 	raw_spin_lock(&rq->lock);
 	update_rq_clock(rq);
-	update_cpu_load(rq);
+	update_cpu_load_active(rq);
 	curr->sched_class->task_tick(rq, curr, 0);
 	raw_spin_unlock(&rq->lock);
 
@@ -7789,6 +7858,9 @@ void __init sched_init(void)
 
 		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
 			rq->cpu_load[j] = 0;
+
+		rq->last_load_update_tick = jiffies;
+
 #ifdef CONFIG_SMP
 		rq->sd = NULL;
 		rq->rd = NULL;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5a5ea2c..22c0a58 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3464,9 +3464,12 @@ static void run_rebalance_domains(struct softirq_action *h)
 			if (need_resched())
 				break;
 
+			rq = cpu_rq(balance_cpu);
+			raw_spin_lock(&rq->lock);
+			update_cpu_load(rq);
+			raw_spin_unlock(&rq->lock);
 			rebalance_domains(balance_cpu, CPU_IDLE);
 
-			rq = cpu_rq(balance_cpu);
 			if (time_after(this_rq->next_balance, rq->next_balance))
 				this_rq->next_balance = rq->next_balance;
 		}
-- 
1.7.0.1


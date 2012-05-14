Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab2ENNrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:47:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56633 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab2ENNrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:47:23 -0400
Date: Mon, 14 May 2012 06:47:10 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-tp4kj18xdd5aj4vvj0qg55s2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, venki@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, venki@google.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/nohz: Fix rq->cpu_load[] calculations
Git-Commit-ID: 556061b00c9f2fd6a5524b6bde823ef12f299ecf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 14 May 2012 06:47:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  556061b00c9f2fd6a5524b6bde823ef12f299ecf
Gitweb:     http://git.kernel.org/tip/556061b00c9f2fd6a5524b6bde823ef12f299ecf
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 11 May 2012 17:31:26 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 14 May 2012 15:05:27 +0200

sched/nohz: Fix rq->cpu_load[] calculations

While investigating why the load-balancer did funny I found that the
rq->cpu_load[] tables were completely screwy.. a bit more digging
revealed that the updates that got through were missing ticks followed
by a catchup of 2 ticks.

The catchup assumes the cpu was idle during that time (since only nohz
can cause missed ticks and the machine is idle etc..) this means that
esp. the higher indices were significantly lower than they ought to
be.

The reason for this is that its not correct to compare against jiffies
on every jiffy on any other cpu than the cpu that updates jiffies.

This patch cludges around it by only doing the catch-up stuff from
nohz_idle_balance() and doing the regular stuff unconditionally from
the tick.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: pjt@google.com
Cc: Venkatesh Pallipadi <venki@google.com>
Link: http://lkml.kernel.org/n/tip-tp4kj18xdd5aj4vvj0qg55s2@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c  |   53 ++++++++++++++++++++++++++++++++++++-------------
 kernel/sched/fair.c  |    2 +-
 kernel/sched/sched.h |    2 +-
 3 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6883d99..860fddf 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -692,8 +692,6 @@ int tg_nop(struct task_group *tg, void *data)
 }
 #endif
 
-void update_cpu_load(struct rq *this_rq);
-
 static void set_load_weight(struct task_struct *p)
 {
 	int prio = p->static_prio - MAX_RT_PRIO;
@@ -2486,22 +2484,13 @@ decay_load_missed(unsigned long load, unsigned long missed_updates, int idx)
  * scheduler tick (TICK_NSEC). With tickless idle this will not be called
  * every tick. We fix it up based on jiffies.
  */
-void update_cpu_load(struct rq *this_rq)
+static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
+			      unsigned long pending_updates)
 {
-	unsigned long this_load = this_rq->load.weight;
-	unsigned long curr_jiffies = jiffies;
-	unsigned long pending_updates;
 	int i, scale;
 
 	this_rq->nr_load_updates++;
 
-	/* Avoid repeated calls on same jiffy, when moving in and out of idle */
-	if (curr_jiffies == this_rq->last_load_update_tick)
-		return;
-
-	pending_updates = curr_jiffies - this_rq->last_load_update_tick;
-	this_rq->last_load_update_tick = curr_jiffies;
-
 	/* Update our load: */
 	this_rq->cpu_load[0] = this_load; /* Fasttrack for idx 0 */
 	for (i = 1, scale = 2; i < CPU_LOAD_IDX_MAX; i++, scale += scale) {
@@ -2526,9 +2515,45 @@ void update_cpu_load(struct rq *this_rq)
 	sched_avg_update(this_rq);
 }
 
+/*
+ * Called from nohz_idle_balance() to update the load ratings before doing the
+ * idle balance.
+ */
+void update_idle_cpu_load(struct rq *this_rq)
+{
+	unsigned long curr_jiffies = jiffies;
+	unsigned long load = this_rq->load.weight;
+	unsigned long pending_updates;
+
+	/*
+	 * Bloody broken means of dealing with nohz, but better than nothing..
+	 * jiffies is updated by one cpu, another cpu can drift wrt the jiffy
+	 * update and see 0 difference the one time and 2 the next, even though
+	 * we ticked at roughtly the same rate.
+	 *
+	 * Hence we only use this from nohz_idle_balance() and skip this
+	 * nonsense when called from the scheduler_tick() since that's
+	 * guaranteed a stable rate.
+	 */
+	if (load || curr_jiffies == this_rq->last_load_update_tick)
+		return;
+
+	pending_updates = curr_jiffies - this_rq->last_load_update_tick;
+	this_rq->last_load_update_tick = curr_jiffies;
+
+	__update_cpu_load(this_rq, load, pending_updates);
+}
+
+/*
+ * Called from scheduler_tick()
+ */
 static void update_cpu_load_active(struct rq *this_rq)
 {
-	update_cpu_load(this_rq);
+	/*
+	 * See the mess in update_idle_cpu_load().
+	 */
+	this_rq->last_load_update_tick = jiffies;
+	__update_cpu_load(this_rq, this_rq->load.weight, 1);
 
 	calc_load_account_active(this_rq);
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a259a61..124e6b6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5012,7 +5012,7 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
 
 		raw_spin_lock_irq(&this_rq->lock);
 		update_rq_clock(this_rq);
-		update_cpu_load(this_rq);
+		update_idle_cpu_load(this_rq);
 		raw_spin_unlock_irq(&this_rq->lock);
 
 		rebalance_domains(balance_cpu, CPU_IDLE);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 7282e7b..ba9dccf 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -876,7 +876,7 @@ extern void resched_cpu(int cpu);
 extern struct rt_bandwidth def_rt_bandwidth;
 extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime);
 
-extern void update_cpu_load(struct rq *this_rq);
+extern void update_idle_cpu_load(struct rq *this_rq);
 
 #ifdef CONFIG_CGROUP_CPUACCT
 #include <linux/cgroup.h>

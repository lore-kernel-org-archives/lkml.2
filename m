Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab2GaEuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:50:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48527 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755325Ab2GaEuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:50:06 -0400
Message-Id: <20120731044314.153043819@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:43:28 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [ 18/73] sched/nohz: Fix rq->cpu_load[] calculations
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 556061b00c9f2fd6a5524b6bde823ef12f299ecf upstream.

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
[bwh: Backported to 3.2: adjust filenames and context; keep functions static]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1887,7 +1887,7 @@ static void double_rq_unlock(struct rq *
 
 static void update_sysctl(void);
 static int get_update_sysctl_factor(void);
-static void update_cpu_load(struct rq *this_rq);
+static void update_idle_cpu_load(struct rq *this_rq);
 
 static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 {
@@ -3855,22 +3855,13 @@ decay_load_missed(unsigned long load, un
  * scheduler tick (TICK_NSEC). With tickless idle this will not be called
  * every tick. We fix it up based on jiffies.
  */
-static void update_cpu_load(struct rq *this_rq)
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
@@ -3895,9 +3886,45 @@ static void update_cpu_load(struct rq *t
 	sched_avg_update(this_rq);
 }
 
+/*
+ * Called from nohz_idle_balance() to update the load ratings before doing the
+ * idle balance.
+ */
+static void update_idle_cpu_load(struct rq *this_rq)
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
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -4735,7 +4735,7 @@ static void nohz_idle_balance(int this_c
 
 		raw_spin_lock_irq(&this_rq->lock);
 		update_rq_clock(this_rq);
-		update_cpu_load(this_rq);
+		update_idle_cpu_load(this_rq);
 		raw_spin_unlock_irq(&this_rq->lock);
 
 		rebalance_domains(balance_cpu, CPU_IDLE);



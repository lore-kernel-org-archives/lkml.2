Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab1BPBwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:52:23 -0500
Received: from kroah.org ([198.145.64.141]:51373 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758653Ab1BPBwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:52:14 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:05 2011
Message-Id: <20110216014705.543091606@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:46:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Subject: [113/115] sched: Fix wake_affine() vs RT tasks
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

Commit: e51fd5e22e12b39f49b1bb60b37b300b17378a43 upstream

Mike reports that since e9e9250b (sched: Scale down cpu_power due to RT
tasks), wake_affine() goes funny on RT tasks due to them still having a
!0 weight and wake_affine() still subtracts that from the rq weight.

Since nobody should be using se->weight for RT tasks, set the value to
zero. Also, since we now use ->cpu_power to normalize rq weights to
account for RT cpu usage, add that factor into the imbalance computation.

Reported-by: Mike Galbraith <efault@gmx.de>
Tested-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1275316109.27810.22969.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c      |   25 +++++++------------------
 kernel/sched_fair.c |   22 ++++++++++++++++------
 2 files changed, 23 insertions(+), 24 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -533,6 +533,8 @@ struct rq {
 	struct root_domain *rd;
 	struct sched_domain *sd;
 
+	unsigned long cpu_power;
+
 	unsigned char idle_at_tick;
 	/* For active balancing */
 	int post_schedule;
@@ -1520,24 +1522,9 @@ static unsigned long target_load(int cpu
 	return max(rq->cpu_load[type-1], total);
 }
 
-static struct sched_group *group_of(int cpu)
-{
-	struct sched_domain *sd = rcu_dereference(cpu_rq(cpu)->sd);
-
-	if (!sd)
-		return NULL;
-
-	return sd->groups;
-}
-
 static unsigned long power_of(int cpu)
 {
-	struct sched_group *group = group_of(cpu);
-
-	if (!group)
-		return SCHED_LOAD_SCALE;
-
-	return group->cpu_power;
+	return cpu_rq(cpu)->cpu_power;
 }
 
 static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
@@ -1932,8 +1919,8 @@ static void dec_nr_running(struct rq *rq
 static void set_load_weight(struct task_struct *p)
 {
 	if (task_has_rt_policy(p)) {
-		p->se.load.weight = prio_to_weight[0] * 2;
-		p->se.load.inv_weight = prio_to_wmult[0] >> 1;
+		p->se.load.weight = 0;
+		p->se.load.inv_weight = WMULT_CONST;
 		return;
 	}
 
@@ -3833,6 +3820,7 @@ static void update_cpu_power(struct sche
 	if (!power)
 		power = 1;
 
+	cpu_rq(cpu)->cpu_power = power;
 	sdg->cpu_power = power;
 }
 
@@ -9788,6 +9776,7 @@ void __init sched_init(void)
 #ifdef CONFIG_SMP
 		rq->sd = NULL;
 		rq->rd = NULL;
+		rq->cpu_power = SCHED_LOAD_SCALE;
 		rq->post_schedule = 0;
 		rq->active_balance = 0;
 		rq->next_balance = jiffies;
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1222,7 +1222,6 @@ static int wake_affine(struct sched_doma
 	unsigned long this_load, load;
 	int idx, this_cpu, prev_cpu;
 	unsigned long tl_per_task;
-	unsigned int imbalance;
 	struct task_group *tg;
 	unsigned long weight;
 	int balanced;
@@ -1262,8 +1261,6 @@ static int wake_affine(struct sched_doma
 	tg = task_group(p);
 	weight = p->se.load.weight;
 
-	imbalance = 100 + (sd->imbalance_pct - 100) / 2;
-
 	/*
 	 * In low-load situations, where prev_cpu is idle and this_cpu is idle
 	 * due to the sync cause above having dropped this_load to 0, we'll
@@ -1273,9 +1270,22 @@ static int wake_affine(struct sched_doma
 	 * Otherwise check if either cpus are near enough in load to allow this
 	 * task to be woken on this_cpu.
 	 */
-	balanced = !this_load ||
-		100*(this_load + effective_load(tg, this_cpu, weight, weight)) <=
-		imbalance*(load + effective_load(tg, prev_cpu, 0, weight));
+	if (this_load) {
+		unsigned long this_eff_load, prev_eff_load;
+
+		this_eff_load = 100;
+		this_eff_load *= power_of(prev_cpu);
+		this_eff_load *= this_load +
+			effective_load(tg, this_cpu, weight, weight);
+
+		prev_eff_load = 100 + (sd->imbalance_pct - 100) / 2;
+		prev_eff_load *= power_of(this_cpu);
+		prev_eff_load *= load + effective_load(tg, prev_cpu, 0, weight);
+
+		balanced = this_eff_load <= prev_eff_load;
+	} else
+		balanced = true;
+
 	rcu_read_unlock();
 
 	/*



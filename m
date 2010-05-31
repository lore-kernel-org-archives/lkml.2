Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab0EaO2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 10:28:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45250 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab0EaO2U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 10:28:20 -0400
Subject: Re: commit e9e9250b: sync wakeup bustage when waker is an RT task
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1275314209.17599.7.camel@marge.simson.net>
References: <1273924628.10630.24.camel@marge.simson.net>
	 <1273925052.1674.138.camel@laptop>
	 <1273943222.8752.7.camel@marge.simson.net>
	 <1273994510.7873.10.camel@marge.simson.net>
	 <1275306978.27810.22357.camel@twins>
	 <1275314209.17599.7.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 31 May 2010 16:28:29 +0200
Message-ID: <1275316109.27810.22969.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 15:56 +0200, Mike Galbraith wrote:
> On Mon, 2010-05-31 at 13:56 +0200, Peter Zijlstra wrote:
> > On Sun, 2010-05-16 at 09:21 +0200, Mike Galbraith wrote:
> > > sched: RT waker sync wakeup bugfix
> > > 
> > > An RT waker's weight is not on the runqueue, but we try to subrtact it anyway
> > > in the sync wakeup case,  sending this_load negative.  This leads to affine
> > > wakeup failure in cases where it should succeed.  This was found while testing
> > > an PREEMPT_RT kernel with lmbench's lat_udp.  In a PREEMPT_RT kernel, softirq
> > > threads act as a ~proxy for the !RT buddy.  Approximate !PREEMPT_RT sync wakeup
> > > behavior by looking at the buddy instead, and subtracting the maximum task weight
> > > that will not send this_load negative. 
> > 
> > 
> > Does the below work?
> 
> Had to make a dinky adjustment for x86-tip-rt33, but yeah, the horrid
> latencies are gone.  (hm, skinnier than expected too)


Here's one that should be even skinnier ;-)

I knew I already had an accessor: power_of(), also, I duplicated the
cpu_power variable inside struct rq so we don't have to chase three
pointers to get it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c      |   24 ++++++------------------
 kernel/sched_fair.c |   22 ++++++++++++++++------
 2 files changed, 22 insertions(+), 24 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -545,6 +545,8 @@ struct rq {
 	struct root_domain *rd;
 	struct sched_domain *sd;
 
+	unsigned long cpu_power;
+
 	unsigned char idle_at_tick;
 	/* For active balancing */
 	int post_schedule;
@@ -1521,24 +1523,9 @@ static unsigned long target_load(int cpu
 	return max(rq->cpu_load[type-1], total);
 }
 
-static struct sched_group *group_of(int cpu)
-{
-	struct sched_domain *sd = rcu_dereference_sched(cpu_rq(cpu)->sd);
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
@@ -1877,8 +1864,8 @@ static void dec_nr_running(struct rq *rq
 static void set_load_weight(struct task_struct *p)
 {
 	if (task_has_rt_policy(p)) {
-		p->se.load.weight = prio_to_weight[0] * 2;
-		p->se.load.inv_weight = prio_to_wmult[0] >> 1;
+		p->se.load.weight = 0;
+		p->se.load.inv_weight = WMULT_CONST;
 		return;
 	}
 
@@ -7715,6 +7702,7 @@ void __init sched_init(void)
 #ifdef CONFIG_SMP
 		rq->sd = NULL;
 		rq->rd = NULL;
+		rq->cpu_power = SCHED_LOAD_SCALE;
 		rq->post_schedule = 0;
 		rq->active_balance = 0;
 		rq->next_balance = jiffies;
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1225,7 +1225,6 @@ static int wake_affine(struct sched_doma
 	unsigned long this_load, load;
 	int idx, this_cpu, prev_cpu;
 	unsigned long tl_per_task;
-	unsigned int imbalance;
 	struct task_group *tg;
 	unsigned long weight;
 	int balanced;
@@ -1252,8 +1251,6 @@ static int wake_affine(struct sched_doma
 	tg = task_group(p);
 	weight = p->se.load.weight;
 
-	imbalance = 100 + (sd->imbalance_pct - 100) / 2;
-
 	/*
 	 * In low-load situations, where prev_cpu is idle and this_cpu is idle
 	 * due to the sync cause above having dropped this_load to 0, we'll
@@ -1263,9 +1260,21 @@ static int wake_affine(struct sched_doma
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
 
 	/*
 	 * If the currently running task will sleep within
@@ -2298,6 +2307,7 @@ static void update_cpu_power(struct sche
 	if (!power)
 		power = 1;
 
+	cpu_rq(cpu)->cpu_power = power;
 	sdg->cpu_power = power;
 }
 


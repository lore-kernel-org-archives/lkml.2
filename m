Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab0FAJOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 05:14:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:48151 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab0FAJOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 05:14:21 -0400
Date: Tue, 1 Jun 2010 09:12:41 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1275316109.27810.22969.camel@twins>
References: <1275316109.27810.22969.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix wake_affine() vs RT tasks
Message-ID: <tip-e51fd5e22e12b39f49b1bb60b37b300b17378a43@git.kernel.org>
Git-Commit-ID: e51fd5e22e12b39f49b1bb60b37b300b17378a43
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 01 Jun 2010 09:12:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e51fd5e22e12b39f49b1bb60b37b300b17378a43
Gitweb:     http://git.kernel.org/tip/e51fd5e22e12b39f49b1bb60b37b300b17378a43
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 31 May 2010 12:37:30 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 1 Jun 2010 09:27:16 +0200

sched: Fix wake_affine() vs RT tasks

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
---
 kernel/sched.c      |   24 ++++++------------------
 kernel/sched_fair.c |   22 ++++++++++++++++------
 2 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d484081..f8b8996 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -544,6 +544,8 @@ struct rq {
 	struct root_domain *rd;
 	struct sched_domain *sd;
 
+	unsigned long cpu_power;
+
 	unsigned char idle_at_tick;
 	/* For active balancing */
 	int post_schedule;
@@ -1499,24 +1501,9 @@ static unsigned long target_load(int cpu, int type)
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
@@ -1854,8 +1841,8 @@ static void dec_nr_running(struct rq *rq)
 static void set_load_weight(struct task_struct *p)
 {
 	if (task_has_rt_policy(p)) {
-		p->se.load.weight = prio_to_weight[0] * 2;
-		p->se.load.inv_weight = prio_to_wmult[0] >> 1;
+		p->se.load.weight = 0;
+		p->se.load.inv_weight = WMULT_CONST;
 		return;
 	}
 
@@ -7605,6 +7592,7 @@ void __init sched_init(void)
 #ifdef CONFIG_SMP
 		rq->sd = NULL;
 		rq->rd = NULL;
+		rq->cpu_power = SCHED_LOAD_SCALE;
 		rq->post_schedule = 0;
 		rq->active_balance = 0;
 		rq->next_balance = jiffies;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 217e4a9..eed35ed 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1225,7 +1225,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	unsigned long this_load, load;
 	int idx, this_cpu, prev_cpu;
 	unsigned long tl_per_task;
-	unsigned int imbalance;
 	struct task_group *tg;
 	unsigned long weight;
 	int balanced;
@@ -1252,8 +1251,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	tg = task_group(p);
 	weight = p->se.load.weight;
 
-	imbalance = 100 + (sd->imbalance_pct - 100) / 2;
-
 	/*
 	 * In low-load situations, where prev_cpu is idle and this_cpu is idle
 	 * due to the sync cause above having dropped this_load to 0, we'll
@@ -1263,9 +1260,21 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
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
@@ -2298,6 +2307,7 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 	if (!power)
 		power = 1;
 
+	cpu_rq(cpu)->cpu_power = power;
 	sdg->cpu_power = power;
 }
 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174Ab1LFJ4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:56:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34991 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933071Ab1LFJ4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:56:08 -0500
Date: Tue, 6 Dec 2011 01:55:45 -0800
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-786d6dc7aeb2bfbfe417507b7beb83919f319db3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20111202010832.656983582@sbsiddha-desk.sc.intel.com>
References: <20111202010832.656983582@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, nohz: Clean up the find_new_ilb() using sched groups nr_busy_cpus
Git-Commit-ID: 786d6dc7aeb2bfbfe417507b7beb83919f319db3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:55:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  786d6dc7aeb2bfbfe417507b7beb83919f319db3
Gitweb:     http://git.kernel.org/tip/786d6dc7aeb2bfbfe417507b7beb83919f319db3
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Thu, 1 Dec 2011 17:07:35 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 09:06:36 +0100

sched, nohz: Clean up the find_new_ilb() using sched groups nr_busy_cpus

nr_busy_cpus in the sched_group_power indicates whether the group
is semi idle or not. This helps remove the is_semi_idle_group() and simplify
the find_new_ilb() in the context of finding an optimal cpu that can do
idle load balancing.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20111202010832.656983582@sbsiddha-desk.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/fair.c |   48 ++++++++++++------------------------------------
 1 files changed, 12 insertions(+), 36 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 821af14..65a6f8b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4733,7 +4733,6 @@ out_unlock:
  */
 static struct {
 	cpumask_var_t idle_cpus_mask;
-	cpumask_var_t grp_idle_mask;
 	atomic_t nr_cpus;
 	unsigned long next_balance;     /* in jiffy units */
 } nohz ____cacheline_aligned;
@@ -4774,33 +4773,6 @@ static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
 		(sd && (sd->flags & flag)); sd = sd->parent)
 
 /**
- * is_semi_idle_group - Checks if the given sched_group is semi-idle.
- * @ilb_group:	group to be checked for semi-idleness
- *
- * Returns:	1 if the group is semi-idle. 0 otherwise.
- *
- * We define a sched_group to be semi idle if it has atleast one idle-CPU
- * and atleast one non-idle CPU. This helper function checks if the given
- * sched_group is semi-idle or not.
- */
-static inline int is_semi_idle_group(struct sched_group *ilb_group)
-{
-	cpumask_and(nohz.grp_idle_mask, nohz.idle_cpus_mask,
-					sched_group_cpus(ilb_group));
-
-	/*
-	 * A sched_group is semi-idle when it has atleast one busy cpu
-	 * and atleast one idle cpu.
-	 */
-	if (cpumask_empty(nohz.grp_idle_mask))
-		return 0;
-
-	if (cpumask_equal(nohz.grp_idle_mask, sched_group_cpus(ilb_group)))
-		return 0;
-
-	return 1;
-}
-/**
  * find_new_ilb - Finds the optimum idle load balancer for nomination.
  * @cpu:	The cpu which is nominating a new idle_load_balancer.
  *
@@ -4815,8 +4787,8 @@ static inline int is_semi_idle_group(struct sched_group *ilb_group)
 static int find_new_ilb(int cpu)
 {
 	int ilb = cpumask_first(nohz.idle_cpus_mask);
+	struct sched_group *ilbg;
 	struct sched_domain *sd;
-	struct sched_group *ilb_group;
 
 	/*
 	 * Have idle load balancer selection from semi-idle packages only
@@ -4834,23 +4806,28 @@ static int find_new_ilb(int cpu)
 
 	rcu_read_lock();
 	for_each_flag_domain(cpu, sd, SD_POWERSAVINGS_BALANCE) {
-		ilb_group = sd->groups;
+		ilbg = sd->groups;
 
 		do {
-			if (is_semi_idle_group(ilb_group)) {
-				ilb = cpumask_first(nohz.grp_idle_mask);
+			if (ilbg->group_weight !=
+				atomic_read(&ilbg->sgp->nr_busy_cpus)) {
+				ilb = cpumask_first_and(nohz.idle_cpus_mask,
+							sched_group_cpus(ilbg));
 				goto unlock;
 			}
 
-			ilb_group = ilb_group->next;
+			ilbg = ilbg->next;
 
-		} while (ilb_group != sd->groups);
+		} while (ilbg != sd->groups);
 	}
 unlock:
 	rcu_read_unlock();
 
 out_done:
-	return ilb;
+	if (ilb < nr_cpu_ids && idle_cpu(ilb))
+		return ilb;
+
+	return nr_cpu_ids;
 }
 #else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
 static inline int find_new_ilb(int call_cpu)
@@ -5588,7 +5565,6 @@ __init void init_sched_fair_class(void)
 
 #ifdef CONFIG_NO_HZ
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
-	alloc_cpumask_var(&nohz.grp_idle_mask, GFP_NOWAIT);
 #endif
 #endif /* SMP */
 

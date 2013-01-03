Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab3ACKjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 05:39:23 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:40761 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab3ACKjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:39:20 -0500
Message-ID: <50E55F99.6090104@linux.vnet.ibm.com>
Date: Thu, 03 Jan 2013 16:08:17 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Paul McKenney <paul.mckenney@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Venki Pallipadi <venki@google.com>,
        Robin Randhawa <robin.randhawa@arm.com>,
        Lists linaro-dev <linaro-dev@lists.linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Alex Shi <alex.shi@intel.com>,
        srikar@linux.vnet.ibm.com
Subject: Re: sched: Consequences of integrating the Per Entity Load Tracking
 Metric into the Load Balancer
References: <50E3B61A.3040808@linux.vnet.ibm.com> <1357114354.5586.39.camel@marge.simpson.net>
In-Reply-To: <1357114354.5586.39.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010310-9264-0000-0000-000002EF302D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Thank you very much for your feedback.Considering your suggestions,I have posted out a 
proposed solution to prevent select_idle_sibling() from becoming a disadvantage to normal
load balancing,rather aiding it.

**This patch is *without* the enablement of the per entity load tracking metric.**

This is with an intention to correct the existing select_idle_sibling() mess before
going ahead.

-------------------BEGIN PATCH--------------------------------------------------------

Subject: [PATCH] sched: Merge select_idle_sibling with the behaviour of SD_BALANCE_WAKE

The function of select_idle_sibling() is to place the woken up task in the
vicinity of the waking cpu or on the previous cpu depending on what wake_affine() says.
This placement being only in an idle group.If an idle group is not found,the
fallback cpu is either the waking cpu or the previous cpu accordingly.

This results in the runqueue of the waking cpu or the previous cpu getting
overloaded when the system is committed,which is a latency hit to these tasks.

What is required is that the newly woken up tasks be placed close to the wake
up cpu or the previous cpu,whichever is best, for reasons to avoid latency hit and cache
coldness respectively.This is achieved with wake_affine() deciding which
cache domain the task should be placed on.

Once this is decided,instead of searching for a completely idle group,let us
search for the idlest group.This will anyway return a completely idle group
if it exists and its mechanism will fall back to what select_idle_sibling()
was doing.But if this fails,find_idlest_group() continues the search for a
relatively more idle group.

The argument could be that,we wish to avoid migration of the newly woken up
task to any other group unless it is completely idle.But in this case, to
begin with we choose a sched domain,within which a migration could be less
harmful.We enable the SD_BALANCE_WAKE flag on the SMT and MC domains to co-operate
with the same.

This patch is based on the tip tree without enabling the per entity load
tracking.This is with an intention to clear up the select_idle_sibling() mess
before introducing the metric.
---
 include/linux/topology.h |    4 ++-
 kernel/sched/fair.c      |   61 +++++-----------------------------------------
 2 files changed, 9 insertions(+), 56 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index d3cf0d6..eeb309e 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -95,7 +95,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
+				| 1*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
 				| 1*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
@@ -127,7 +127,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
+				| 1*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b29cdbf..c33eda7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3303,58 +3303,6 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 	return idlest;
 }
 
-/*
- * Try and locate an idle CPU in the sched_domain.
- */
-static int select_idle_sibling(struct task_struct *p, int target)
-{
-	int cpu = smp_processor_id();
-	int prev_cpu = task_cpu(p);
-	struct sched_domain *sd;
-	struct sched_group *sg;
-	int i;
-
-	/*
-	 * If the task is going to be woken-up on this cpu and if it is
-	 * already idle, then it is the right target.
-	 */
-	if (target == cpu && idle_cpu(cpu))
-		return cpu;
-
-	/*
-	 * If the task is going to be woken-up on the cpu where it previously
-	 * ran and if it is currently idle, then it the right target.
-	 */
-	if (target == prev_cpu && idle_cpu(prev_cpu))
-		return prev_cpu;
-
-	/*
-	 * Otherwise, iterate the domains and find an elegible idle cpu.
-	 */
-	sd = rcu_dereference(per_cpu(sd_llc, target));
-	for_each_lower_domain(sd) {
-		sg = sd->groups;
-		do {
-			if (!cpumask_intersects(sched_group_cpus(sg),
-						tsk_cpus_allowed(p)))
-				goto next;
-
-			for_each_cpu(i, sched_group_cpus(sg)) {
-				if (!idle_cpu(i))
-					goto next;
-			}
-
-			target = cpumask_first_and(sched_group_cpus(sg),
-					tsk_cpus_allowed(p));
-			goto done;
-next:
-			sg = sg->next;
-		} while (sg != sd->groups);
-	}
-done:
-	return target;
-}
-
 #ifdef CONFIG_SCHED_NUMA
 static inline bool pick_numa_rand(int n)
 {
@@ -3469,8 +3417,13 @@ find_sd:
 		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
 			prev_cpu = cpu;
 
-		new_cpu = select_idle_sibling(p, prev_cpu);
-		goto unlock;
+		if (prev_cpu == task_cpu(p) && idle_cpu(prev_cpu) ||
+		    prev_cpu == smp_processor_id() && idle_cpu(prev_cpu)) {
+			new_cpu = prev_cpu;
+			goto unlock;
+		} else {
+			sd = rcu_dereference(per_cpu(sd_llc, prev_cpu));
+		}
 	}
 
 pick_idlest:







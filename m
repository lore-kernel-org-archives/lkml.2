Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab3AHImb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 03:42:31 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:45693 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab3AHIm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 03:42:29 -0500
Message-ID: <50EBDBB7.5060803@linux.vnet.ibm.com>
Date: Tue, 08 Jan 2013 14:11:27 +0530
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
References: <50E3B61A.3040808@linux.vnet.ibm.com> <1357114354.5586.39.camel@marge.simpson.net> <50E55F99.6090104@linux.vnet.ibm.com> <1357373590.5690.172.camel@marge.simpson.net> <1357489955.5717.21.camel@marge.simpson.net> <50EA5D41.4090502@linux.vnet.ibm.com> <1357544184.5792.140.camel@marge.simpson.net>
In-Reply-To: <1357544184.5792.140.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010808-9574-0000-0000-000006166ADE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Thank you very much for such a clear and comprehensive explanation.
So when I put together the problem and the proposed solution pieces in the current
scheduler scalability,the following was what I found:

1. select_idle_sibling() is needed as an agent to correctly find the right cpu for wake
   up tasks to go to."Correctly" would be to find an idle cpu at the lowest cost possible.
2."Cost could be lowered" either by optimizing the order of searching for an idle cpu or
   restricting the search to a few cpus alone.
3. The former has the problem that it would not prevent bouncing tasks all over the domain
   sharing an L3 cache,which could potentially affect the fast moving tasks.
4. The latter has the problem that it is not aggressive enough in finding an idle cpu.

This is some tangled problem,but I think the solution at best could be smoothed to a a flowchart.

       STEP1                       STEP2                STEP3
 _____________________
|                     |
|See if the idle buddy|No    _________________  Yes   ________________
|is free at all sched |---->| Do we search the|----> |Optimized search|
|domains              |     |sched domains    |      |________________|
|_____________________|     |for an idle cpu  |                 |
          |Yes              |_________________|                \|/
         \|/                        |No: saturated     Return target cpu
        Return                     \|/     system
        cpu buddy                Return prev_cpu

I dont know how well we can do STEP2. That seems to be the biggest challenge.STEP 1 is a
reverted commit 37407ea7,
"sched: Improve scalability via 'CPU buddies', which withstand random perturbations"
for reasons which can hopefully be overcome by this flowchart.

I have tried to tackle STEP3.STEP 3 will not prevent bouncing but a good STEP2 could tell
us if it is worth the bounce.

STEP3 Patch is given below:

***********************START PATCH**************************************

sched:Reduce the overhead of select_idle_sibling

From: Preeti U Murthy <preeti@linux.vnet.ibm.com>

The traversal of the sched domains to find the idlest cpu is a costly
operation currently in select_idle_sibling() due to large L3 caches.
So the traversal better be worth the effort.

In the current approach,in select_idle_sibling(),the sched domains are
searched top to bottom starting at the last level cache domain,and the search
is for the idlest *group*. It is less likely that you will find a completely
idle group at a higher level sched domain compared to a lower level sched
domain.This will make the first few iterations fruitless most of the times.
And it is less likely to find an idle *group* compared to an idle *cpu*.

This patch aims at finding an idle cpu.And since the iterations are from bottom to
top,stopping at the last level cache domain,it tries to see if the task can
be scheduled on a core which shares the l2 cache with the waking cpu/prev cpu first,
before probing the cpus at the higher level domain,trying to make the cost of
migration lower than the current approach.

Also it tries to return an idle cpu as soon as it finds one,without querying
the status of the other cpus in the sched group.This could potentially be
much faster unless a worse case such as not finding an idle cpu at every
domain occurs.
---
 kernel/sched/fair.c |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b29cdbf..6123bca 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3310,7 +3310,7 @@ static int select_idle_sibling(struct task_struct *p, int target)
 {
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
-	struct sched_domain *sd;
+	struct sched_domain *sd, *tmp;
 	struct sched_group *sg;
 	int i;
 
@@ -3332,24 +3332,33 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	 * Otherwise, iterate the domains and find an elegible idle cpu.
 	 */
 	sd = rcu_dereference(per_cpu(sd_llc, target));
-	for_each_lower_domain(sd) {
-		sg = sd->groups;
+	/*
+ 	 * Iterate the domains bottom up,to cash in on the shared lower level
+ 	 * cache advantages.
+ 	 * Since this iteration is costly,return any idle cpu and dont wait
+ 	 * for a completely idle group.
+ 	 */
+	for_each_domain(target, tmp) {
+		sg = tmp->groups;
 		do {
 			if (!cpumask_intersects(sched_group_cpus(sg),
 						tsk_cpus_allowed(p)))
 				goto next;
-
 			for_each_cpu(i, sched_group_cpus(sg)) {
-				if (!idle_cpu(i))
-					goto next;
+				if (idle_cpu(i)) {
+					target = i;
+					goto done;
+				}
 			}
+next:			sg = sg->next;
 
-			target = cpumask_first_and(sched_group_cpus(sg),
-					tsk_cpus_allowed(p));
-			goto done;
-next:
-			sg = sg->next;
-		} while (sg != sd->groups);
+		} while (sg != tmp->groups);
+
+		/* if you have covered the llc domain then break out,it is
+		 * not worth migrating on any higher level domain
+		 */
+		if (tmp == sd)
+			break;
 	}
 done:
 	return target;


Regards
Preeti U Murthy


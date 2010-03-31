Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab0CaXtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 19:49:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:25077 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756126Ab0CaXs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 19:48:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,344,1267430400"; 
   d="scan'208";a="785605453"
Subject: Re: [patch v2 1/2] sched: check for prev_cpu == this_cpu before
 calling wake_affine()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yanmin Zhang <yanmin_zhang@linux.jf.intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <1270031119.5003.93.camel@laptop>
References: <20100308221946.842728363@sbs-t61.sc.intel.com>
	 <1270031119.5003.93.camel@laptop>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 31 Mar 2010 16:47:45 -0700
Message-Id: <1270079265.7835.8.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-31 at 03:25 -0700, Peter Zijlstra wrote: 
> Right, so we since merged 8b911acd, in which Mike did almost this but
> not quite, the question is over: cpu == prev_cpu vs this_cpu ==
> prev_cpu.
> 
> Mike seems to see some workloads regress with the this_cpu check, does
> your workload work with the cpu == prev_cpu one?

Mike saw a regression with the sync check that was in the previous
version (v1). Anyways, the current code in -tip has the check that I
wanted and which addresses the netbook (2 SMT cpu's) performance issue.

But the current logic in select_task_rq_fair() is not quite correct,
especially we can wake the task on a busy core rather than on an idle
core, as the latest changes are making the wake up decisions entirely on
an idle HT sibling if there is one.

Also there are couple of more issues which I have explained in the
previous version of the patch. I have updated my patch on top of the
latest -tip, which addresses all these issues. Let me know your
thoughts. Thanks.

--- 
From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: sched: fix select_idle_sibling() logic in select_task_rq_fair()

Issues in the current select_idle_sibling() logic in select_task_rq_fair()
in the context of a task wake-up:

a) Once we select the idle sibling, we use that domain (spanning the cpu that
   the task is currently woken-up and the idle sibling that we found) in our
   wake_affine() decisions. This domain is completely different from the
   domain(we are supposed to use) that spans the cpu that the task currently
   woken-up and the cpu where the task previously ran.

b) We do select_idle_sibling() check only for the cpu that the task is
   currently woken-up on. If select_task_rq_fair() selects the previously run
   cpu for waking the task, doing a select_idle_sibling() check
   for that cpu also helps and we don't do this currently.

c) In the scenarios where the cpu that the task is woken-up is busy but
   with its HT siblings are idle, we are selecting the task be woken-up
   on the idle HT sibling instead of a core that it previously ran
   and currently completely idle. i.e., we are not taking decisions based on
   wake_affine() but directly selecting an idle sibling that can cause
   an imbalance at the SMT/MC level which will be later corrected by the
   periodic load balancer.

Fix this by first going through the load imbalance calculations using
wake_affine() and once we make a decision of woken-up cpu vs previously-ran cpu,
then choose a possible idle sibling for waking up the task on.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 49ad993..f905a4b 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1385,28 +1385,48 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
  * Try and locate an idle CPU in the sched_domain.
  */
 static int
-select_idle_sibling(struct task_struct *p, struct sched_domain *sd, int target)
+select_idle_sibling(struct task_struct *p, int target)
 {
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	int i;
+	struct sched_domain *sd;
 
 	/*
-	 * If this domain spans both cpu and prev_cpu (see the SD_WAKE_AFFINE
-	 * test in select_task_rq_fair) and the prev_cpu is idle then that's
-	 * always a better target than the current cpu.
+	 * If the task is going to be woken-up on this cpu and if it is
+	 * already idle, then it is the right target.
 	 */
-	if (target == cpu && !cpu_rq(prev_cpu)->cfs.nr_running)
+	if (target == cpu && !cpu_rq(cpu)->cfs.nr_running)
+		return cpu;
+
+	/*
+	 * If the task is going to be woken-up on the cpu where it previously
+	 * ran and if it is currently idle, then it the right target.
+	 */
+	if (target == prev_cpu && !cpu_rq(prev_cpu)->cfs.nr_running)
 		return prev_cpu;
 
 	/*
-	 * Otherwise, iterate the domain and find an elegible idle cpu.
+	 * Otherwise, iterate the domains and find an elegible idle cpu.
 	 */
-	for_each_cpu_and(i, sched_domain_span(sd), &p->cpus_allowed) {
-		if (!cpu_rq(i)->cfs.nr_running) {
-			target = i;
+	for_each_domain(target, sd) {
+		if (!(sd->flags & SD_SHARE_PKG_RESOURCES))
 			break;
+
+		for_each_cpu_and(i, sched_domain_span(sd), &p->cpus_allowed) {
+			if (!cpu_rq(i)->cfs.nr_running) {
+				target = i;
+				break;
+			}
 		}
+
+		/*
+		 * Lets stop looking for an idle sibling when we reached
+		 * the domain that spans the current cpu and prev_cpu.
+		 */
+		if (cpumask_test_cpu(cpu, sched_domain_span(sd)) &&
+		    cpumask_test_cpu(prev_cpu, sched_domain_span(sd)))
+			break;
 	}
 
 	return target;
@@ -1429,7 +1449,7 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	int new_cpu = cpu;
-	int want_affine = 0, cpu_idle = !current->pid;
+	int want_affine = 0;
 	int want_sd = 1;
 	int sync = wake_flags & WF_SYNC;
 
@@ -1467,36 +1487,15 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 				want_sd = 0;
 		}
 
-		/*
-		 * While iterating the domains looking for a spanning
-		 * WAKE_AFFINE domain, adjust the affine target to any idle cpu
-		 * in cache sharing domains along the way.
-		 */
 		if (want_affine) {
-			int target = -1;
-
 			/*
 			 * If both cpu and prev_cpu are part of this domain,
 			 * cpu is a valid SD_WAKE_AFFINE target.
 			 */
-			if (cpumask_test_cpu(prev_cpu, sched_domain_span(tmp)))
-				target = cpu;
-
-			/*
-			 * If there's an idle sibling in this domain, make that
-			 * the wake_affine target instead of the current cpu.
-			 */
-			if (!cpu_idle && tmp->flags & SD_SHARE_PKG_RESOURCES)
-				target = select_idle_sibling(p, tmp, target);
-
-			if (target >= 0) {
-				if (tmp->flags & SD_WAKE_AFFINE) {
-					affine_sd = tmp;
-					want_affine = 0;
-					if (target != cpu)
-						cpu_idle = 1;
-				}
-				cpu = target;
+			if (cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))
+			    && (tmp->flags & SD_WAKE_AFFINE)) {
+				affine_sd = tmp;
+				want_affine = 0;
 			}
 		}
 
@@ -1527,8 +1526,10 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 #endif
 
 	if (affine_sd) {
-		if (cpu_idle || cpu == prev_cpu || wake_affine(affine_sd, p, sync))
-			return cpu;
+		if (cpu == prev_cpu || wake_affine(affine_sd, p, sync))
+			return select_idle_sibling(p, cpu);
+		else
+			return select_idle_sibling(p, prev_cpu);
 	}
 
 	while (sd) {



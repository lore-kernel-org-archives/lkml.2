Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965014Ab2CEPYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:24:55 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:43229 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964837Ab2CEPYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:24:54 -0500
Date: Mon, 5 Mar 2012 20:54:44 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
Message-ID: <20120305152443.GE26559@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1329764866.2293.376.camhel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12030515-8878-0000-0000-0000018C0D13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-02-20 20:07:46]:

> On Mon, 2012-02-20 at 19:14 +0100, Mike Galbraith wrote:
> > Enabling SD_BALANCE_WAKE used to be decidedly too expensive to consider.
> > Maybe that has changed, but I doubt it.
> 
> Right, I through I remembered somet such, you could see it on wakeup
> heavy things like pipe-bench and that java msg passing thing, right?

I did some experiments with volanomark and it does turn out to be
sensitive to SD_BALANCE_WAKE, while the other wake-heavy benchmark that I am
dealing with (Trade) benefits from it.

Normalized results for both benchmarks provided below. 

Machine : 2 Quad-core Intel X5570 CPU (H/T enabled)
Kernel  : tip (HEAD at b86148a) 

	   	   Before patch	    After patch

Trade thr'put		1		2.17 (~200% improvement)
volanomark		1		0.8  (20% degradation)


Quick description of benchmarks 
===============================

Trade was run inside a 8-vcpu VM (cgroup). 4 other 4-vcpu VMs running
cpu hogs were also present, leading to this cgroup setup:

	/cgroup/sys (1024 shares - hosts all system tasks)
	/cgroup/libvirt (20000 shares)
	/cgroup/libvirt/qemu/VM1 (8192 cpu shares)
	/cgroup/libvirt/qemu/VM2-5 (1024 shares)

Volanomark server/client programs were run in root cgroup.

The patch essentially does balance on wake to look for any idle cpu in
same cache domain as its prev_cpu (or cur_cpu if wake_affine obliges),
failing to find looks for least loaded cpu. This helps minimize
latencies for trade workload (and thus boost its score). For volanomark, 
it seems to hurt because of waking on a colder L2 cache.  The
tradeoff seems to be between latency and cache-misses. Short of adding
another tunable, are there better suggestions on how we can address this
sort of tradeoff?

Not-yet-Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

---
 include/linux/topology.h |    4 ++--
 kernel/sched/fair.c      |   26 +++++++++++++++++++++-----
 2 files changed, 23 insertions(+), 7 deletions(-)

Index: current/include/linux/topology.h
===================================================================
--- current.orig/include/linux/topology.h
+++ current/include/linux/topology.h
@@ -96,7 +96,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
+				| 1*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
 				| 1*SD_SHARE_CPUPOWER			\
 				| 0*SD_POWERSAVINGS_BALANCE		\
@@ -129,7 +129,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
+				| 1*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
 				| 0*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
Index: current/kernel/sched/fair.c
===================================================================
--- current.orig/kernel/sched/fair.c
+++ current/kernel/sched/fair.c
@@ -2638,7 +2638,7 @@ static int select_idle_sibling(struct ta
 	int prev_cpu = task_cpu(p);
 	struct sched_domain *sd;
 	struct sched_group *sg;
-	int i;
+	int i, some_idle_cpu = -1;
 
 	/*
 	 * If the task is going to be woken-up on this cpu and if it is
@@ -2661,15 +2661,25 @@ static int select_idle_sibling(struct ta
 	for_each_lower_domain(sd) {
 		sg = sd->groups;
 		do {
+			int skip = 0;
+
 			if (!cpumask_intersects(sched_group_cpus(sg),
 						tsk_cpus_allowed(p)))
 				goto next;
 
-			for_each_cpu(i, sched_group_cpus(sg)) {
-				if (!idle_cpu(i))
-					goto next;
+			for_each_cpu_and(i, sched_group_cpus(sg),
+							 tsk_cpus_allowed(p)) {
+				if (!idle_cpu(i)) {
+					if (some_idle_cpu >= 0)
+						goto next;
+					skip = 1;
+				} else
+					some_idle_cpu = i;
 			}
 
+			if (skip)
+				goto next;
+
 			target = cpumask_first_and(sched_group_cpus(sg),
 					tsk_cpus_allowed(p));
 			goto done;
@@ -2677,6 +2687,9 @@ next:
 			sg = sg->next;
 		} while (sg != sd->groups);
 	}
+
+	if (some_idle_cpu >= 0)
+		target = some_idle_cpu;
 done:
 	return target;
 }
@@ -2766,7 +2779,10 @@ select_task_rq_fair(struct task_struct *
 			prev_cpu = cpu;
 
 		new_cpu = select_idle_sibling(p, prev_cpu);
-		goto unlock;
+		if (idle_cpu(new_cpu))
+			goto unlock;
+		sd = rcu_dereference(per_cpu(sd_llc, prev_cpu));
+		cpu = prev_cpu;
 	}
 
 	while (sd) {








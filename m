Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab2LDErT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 23:47:19 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:50863 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab2LDErS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 23:47:18 -0500
Message-ID: <50BD8028.1040909@linux.vnet.ibm.com>
Date: Tue, 04 Dec 2012 10:16:32 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, vincent.guittot@linaro.org,
        a.p.zijlstra@chello.nl, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, amit.kucheria@linaro.org,
        Morten.Rasmussen@arm.com, paul.mckenney@linaro.org,
        akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
        arjan@linux.intel.com, mingo@kernel.org, pjt@google.com
CC: venki@google.com, robin.randhawa@arm.com, linaro-dev@lists.linaro.org,
        suresh.b.siddha@intel.com, mjg59@srcf.ucam.org,
        deepthi@linux.vnet.ibm.com, srivatsa.bhat@linux.vnet.ibm.com,
        Arvind.Chauhan@arm.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC v2 PATCH 2.1] sched: Use Per-Entity-Load-Tracking metric
 for load balancing
References: <20121115164730.17426.36051.stgit@preeti.in.ibm.com> <20121115165422.17426.3978.stgit@preeti.in.ibm.com>
In-Reply-To: <20121115165422.17426.3978.stgit@preeti.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120404-5564-0000-0000-0000059F9623
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sched: Use Per-Entity-Load-Tracking metric for load balancing

From: Preeti U Murthy <preeti@linux.vnet.ibm.com>

Currently the load balancer weighs a task based upon its priority,and this
weight consequently gets added up to the weight of the run queue that it is
on.It is this weight of the runqueue that sums up to a sched group's load
which is used to decide the busiest or the idlest group and the runqueue
thereof.

The Per-Entity-Load-Tracking metric however measures how long a task has
been runnable over the duration of its lifetime.This gives us a hint of
the amount of CPU time that the task can demand.This metric takes care of the
task priority as well.Therefore apart from the priority of a task we also
have an idea of the live behavior of the task.This seems to be a more
realistic metric to use to compute task weight which adds upto the run queue
weight and the weight of the sched group.Consequently they can be used for
load balancing.

The semantics of load balancing is left untouched.The two functions
load_balance() and select_task_rq_fair() perform the task of load
balancing.These two paths have been browsed through in this patch to make
necessary changes.

weighted_cpuload() and task_h_load() provide the run queue weight and the
weight of the task respectively.They have been modified to provide the
Per-Entity-Load-Tracking metric as relevant for each.
The rest of the modifications had to be made to suit these two changes.

Completely Fair Scheduler class is the only sched_class which contributes to
the run queue load.Therefore the rq->load.weight==cfs_rq->load.weight when
the cfs_rq is the root cfs_rq (rq->cfs) of the hierarchy.When replacing this
with Per-Entity-Load-Tracking metric,cfs_rq->runnable_load_avg needs to be
used as this is the right reflection of the run queue load when
the cfs_rq is the root cfs_rq (rq->cfs) of the hierarchy.This metric reflects
the percentage uptime of the tasks that are queued on it and hence that contribute
to the load.Thus cfs_rq->runnable_load_avg replaces the metric earlier used in
weighted_cpuload().

The task load is aptly captured by se.avg.load_avg_contrib which captures the
runnable time vs the alive time of the task against its priority.This metric
replaces the earlier metric used in task_h_load().

The consequent changes appear as data type changes for the helper variables;
they abound in number.Because cfs_rq->runnable_load_avg needs to be big enough
to capture the tasks' load often and accurately.

The following patch does not consider CONFIG_FAIR_GROUP_SCHED AND
CONFIG_SCHED_NUMA.This is done so as to evaluate this approach starting from the
simplest scenario.Earlier discussions can be found in the link below.

Link: https://lkml.org/lkml/2012/10/25/162
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
I apologise about having overlooked this one change in the patchset.This needs to
be applied on top of patch2 of this patchset.The experiment results that have been
posted in reply to this thread are done after having applied this patch.

 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f8f3a29..19094eb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4362,7 +4362,7 @@ struct sd_lb_stats {
  * sg_lb_stats - stats of a sched_group required for load_balancing
  */
 struct sg_lb_stats {
-	unsigned long avg_load; /*Avg load across the CPUs of the group */
+	u64 avg_load; /*Avg load across the CPUs of the group */
 	u64 group_load; /* Total load over the CPUs of the group */
 	unsigned long sum_nr_running; /* Nr tasks running in the group */
 	u64 sum_weighted_load; /* Weighted load of group's tasks */


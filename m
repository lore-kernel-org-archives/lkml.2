Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab2JYKZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 06:25:45 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:38271 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab2JYKZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 06:25:42 -0400
Subject: [RFC PATCH 00/13] sched: Integrating Per-entity-load-tracking with
 the core scheduler
To: svaidy@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: mingo@kernel.org, venki@google.com, robin.randhawa@arm.com,
        linaro-dev@lists.linaro.org, a.p.zijlstra@chello.nl,
        mjg59@srcf.ucam.org, viresh.kumar@linaro.org,
        akpm@linux-foundation.org, amit.kucheria@linaro.org,
        deepthi@linux.vnet.ibm.com, paul.mckenney@linaro.org,
        arjan@linux.intel.com, paulmck@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, vincent.guittot@linaro.org,
        tglx@linutronix.de, Arvind.Chauhan@arm.com, pjt@google.com,
        Morten.Rasmussen@arm.com, linux-arm-kernel@lists.infradead.org,
        suresh.b.siddha@intel.com
Date: Thu, 25 Oct 2012 15:54:41 +0530
Message-ID: <20121025102045.21022.92489.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12102510-9264-0000-0000-0000028E12CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset uses the per-entity-load-tracking patchset which will soon be
available in the kernel.It is based on the tip/master tree before the
(HEAD at b654f92c06e562c)integration of per-entity-load-tracking patchset.
The first 8 latest patches of sched:per-entity-load-tracking alone have
been imported to the tree from the quilt series of Peter(when they were
present) to avoid the complexities of task groups and to hold back the
optimizations of this patchset for now.This patchset is based at this level.
Refer https://lkml.org/lkml/2012/10/12/9.This series is a continuation
of the patchset in this link.

This patchset is an attempt to begin the integration of PJT's
metric with the load balancer in a step wise fashion,and progress based
on the consequences.This patchset has been tested with the config excluding
CONFIG_FAIR_GROUP_SCHED.

The following issues have been considered towards this:
[NOTE:an x% task referred to in the logs and below is calculated over a
duty cycle of 10ms.]

1.Consider a scenario,where there are two 10% tasks running on a cpu.The
  present code will consider the load on this queue to be 2048,while
  using PJT's metric the load is calculated to be <1000,rarely exceeding this
  limit.Although the tasks are not contributing much to the cpu load,they are
  decided to be moved by the scheduler.

  But one could argue that 'not moving one of these tasks could throttle
  them.If there was an idle cpu,perhaps we could have moved them'.While the
  power save mode would have been fine with not moving the task,the
  performance mode would prefer not to throttle the tasks.We could strive
  to strike a balance by making this decision tunable with certain parameters.
  This patchset includes such tunables.This issue is addressed in Patch[1/2].

  *The advantage of this behavior of PJT's metric has been demonstrated via
   an experiment*.Please see the reply to this cover letter to be posted right
   away.

2.We need to be able to do this cautiously,as the scheduler code is too
  complex.This patchset is an attempt to begin the integration of PJT's
  metric with the load balancer in a step wise fashion,and progress based on
  the consequences.
  *What this patchset essentially does is in two primary places of the
   scheduler,PJT's metric has replaced the existing metric to make decisions for load
   balancing*.
  1.load_balance()
  2.select_task_rq_fair()

  This description of the patches are below:

         Patch[1/13]: This patch aims at detecting short running tasks and
	 prevent their movement.In update_sg_lb_stats,dismiss a sched group
         as a candidate for load balancing,if load calculated by PJT's metric
	 says that the average load on the sched_group <= 1024+(.15*1024).
	 This is a tunable,which can be varied after sufficient experiments.

         Patch[2/13]:In the current scheduler greater load would be analogous
         to more number of tasks.Therefore when the busiest group is picked
         from the sched domain in update_sd_lb_stats,only the loads of the
         groups are compared between them.If we were to use PJT's metric,a
         higher load does not necessarily mean more number of tasks.This
	 patch addresses this issue.

	 Patch[3/13] to Patch[13/13] : Replacement of the existing metrics
	 deciding load balancing and selecting a runqueue for load
         placement,with the PJT's metric and subsequent usage of PJT's metric
         for schduling.

3.The Primary advantage that I see in integrating PJT's metric with the core
  scheduler is listed below:

  1. Excluding short running tasks from being candidates for load balancing.
     This would avoid unnecessary migrations when the CPU is not sufficiently
     loaded.This advantage has been portrayed in the results of the
     experiment.

     Run the workload attached.There are 8 threads spwaned each being 10%
     tasks.
     The number of migrations was measured from /proc/schedstat

     Machine: 1 socket 4 core pre-nehalem.

     Experimental Setup:
     cat /proc/schedstat > stat_initial
     gcc -Wall -Wshadow -lpthread  -o test test.c
     cat /proc/schedstat > stat_final
     The difference in the number of pull requests from both these files have
     been calculated and are as below:

     Observations:
					With_Patchset	Without_patchset
     ---------------------------------------------------------------------
     Average_number_of_migrations	    0		 46
     Average_number_of_records/s          9,71,114	9,45,158

  With more memory intensive workloads, a higher difference in the number of
  migrations is seen without any performance compromise.

---

Preeti U Murthy (13):
      sched:Prevent movement of short running tasks during load balancing
      sched:Pick the apt busy sched group during load balancing
      sched:Decide whether there be transfer of loads based on the PJT's metric
      sched:Decide group_imb using PJT's metric
      sched:Calculate imbalance using PJT's metric
      sched:Changing find_busiest_queue to use PJT's metric
      sched:Change move_tasks to use PJT's metric
      sched:Some miscallaneous changes in load_balance
      sched:Modify check_asym_packing to use PJT's metric
      sched:Modify fix_small_imbalance to use PJT's metric
      sched:Modify find_idlest_group to use PJT's metric
      sched:Modify find_idlest_cpu to use PJT's metric
      sched:Modifying wake_affine to use PJT's metric


 kernel/sched/fair.c |  262 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 186 insertions(+), 76 deletions(-)

-- 
Preeti U Murthy


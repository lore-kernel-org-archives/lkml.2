Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab0FGPHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 11:07:19 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33742 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab0FGPHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 11:07:17 -0400
Date: Mon, 7 Jun 2010 20:36:51 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Neuling <mikey@neuling.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH 1/5] sched: fix capacity calculations for SMT4
Message-ID: <20100607150651.GA13993@linux.vnet.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20100409062118.D4096CBB6C@localhost.localdomain>
 <1271161766.4807.1280.camel@twins>
 <2906.1271219317@neuling.org>
 <1271426308.1674.429.camel@laptop>
 <1275294796.27810.21554.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275294796.27810.21554.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 10:33:16AM +0200, Peter Zijlstra wrote:
> On Fri, 2010-04-16 at 15:58 +0200, Peter Zijlstra wrote:
> > 
> > 
> > Hrmm, my brain seems muddled but I might have another solution, let me
> > ponder this for a bit..
> > 
> 
> Right, so the thing I was thinking about is taking the group capacity
> into account when determining the capacity for a single cpu.

Peter,
	We are exploring an alternate solution which seems to be working as
expected. Basically allow capacity of 1 for SMT threads provided there is
no significant influence by RT tasks or freq scaling. Note that at core level,
capacity is unchanged and hence this affects only how tasks are distributed
within a core.

Mike Neuling should post an updated patchset containing this patch
(with more comments added ofcourse!).


Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

---
 include/linux/sched.h |    2 +-
 kernel/sched_fair.c   |   30 +++++++++++++++++++++++-------
 2 files changed, 24 insertions(+), 8 deletions(-)

Index: linux-2.6-ozlabs/include/linux/sched.h
===================================================================
--- linux-2.6-ozlabs.orig/include/linux/sched.h
+++ linux-2.6-ozlabs/include/linux/sched.h
@@ -860,7 +860,7 @@ struct sched_group {
 	 * CPU power of this group, SCHED_LOAD_SCALE being max power for a
 	 * single CPU.
 	 */
-	unsigned int cpu_power;
+	unsigned int cpu_power, cpu_power_orig;
 
 	/*
 	 * The CPUs this group covers.
Index: linux-2.6-ozlabs/kernel/sched_fair.c
===================================================================
--- linux-2.6-ozlabs.orig/kernel/sched_fair.c
+++ linux-2.6-ozlabs/kernel/sched_fair.c
@@ -2285,13 +2285,6 @@ static void update_cpu_power(struct sche
 	unsigned long power = SCHED_LOAD_SCALE;
 	struct sched_group *sdg = sd->groups;
 
-	if (sched_feat(ARCH_POWER))
-		power *= arch_scale_freq_power(sd, cpu);
-	else
-		power *= default_scale_freq_power(sd, cpu);
-
-	power >>= SCHED_LOAD_SHIFT;
-
 	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
 		if (sched_feat(ARCH_POWER))
 			power *= arch_scale_smt_power(sd, cpu);
@@ -2301,6 +2294,15 @@ static void update_cpu_power(struct sche
 		power >>= SCHED_LOAD_SHIFT;
 	}
 
+	sdg->cpu_power_orig = power;
+
+	if (sched_feat(ARCH_POWER))
+		power *= arch_scale_freq_power(sd, cpu);
+	else
+		power *= default_scale_freq_power(sd, cpu);
+
+	power >>= SCHED_LOAD_SHIFT;
+
 	power *= scale_rt_power(cpu);
 	power >>= SCHED_LOAD_SHIFT;
 
@@ -2333,6 +2335,22 @@ static void update_group_power(struct sc
 	sdg->cpu_power = power;
 }
 
+static inline int
+rt_freq_influence(struct sched_group *group, struct sched_domain *sd)
+{
+	if (sd->child)
+		return 1;
+
+	/*
+	 * Check to see if the final cpu power was reduced by more
+	 * than 10% by frequency or rt tasks
+	 */
+	if (group->cpu_power * 100 < group->cpu_power_orig * 90)
+		return 1;
+
+	return 0;
+}
+
 /**
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
  * @sd: The sched_domain whose statistics are to be updated.
@@ -2426,6 +2444,8 @@ static inline void update_sg_lb_stats(st
 
 	sgs->group_capacity =
 		DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
+	if (!sgs->group_capacity && !rt_freq_influence(group, sd))
+		sgs->group_capacity = 1;
 }
 
 /**
@@ -2725,7 +2745,8 @@ ret:
  */
 static struct rq *
 find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
-		   unsigned long imbalance, const struct cpumask *cpus)
+		   unsigned long imbalance, const struct cpumask *cpus,
+		   struct sched_domain *sd)
 {
 	struct rq *busiest = NULL, *rq;
 	unsigned long max_load = 0;
@@ -2736,6 +2757,9 @@ find_busiest_queue(struct sched_group *g
 		unsigned long capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);
 		unsigned long wl;
 
+		if (!capacity && !rt_freq_influence(group, sd))
+			capacity = 1;
+
 		if (!cpumask_test_cpu(i, cpus))
 			continue;
 
@@ -2852,7 +2876,7 @@ redo:
 		goto out_balanced;
 	}
 
-	busiest = find_busiest_queue(group, idle, imbalance, cpus);
+	busiest = find_busiest_queue(group, idle, imbalance, cpus, sd);
 	if (!busiest) {
 		schedstat_inc(sd, lb_nobusyq[idle]);
 		goto out_balanced;



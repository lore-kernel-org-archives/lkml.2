Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab0DIGVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 02:21:55 -0400
Received: from ozlabs.org ([203.10.76.45]:46538 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681Ab0DIGVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 02:21:24 -0400
To: Peter Zijlstra <peterz@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
From: Michael Neuling <mikey@neuling.org>
Date: Fri, 09 Apr 2010 16:21:18 +1000
Subject: [PATCH 4/5] sched: Mark the balance type for use in need_active_balance()
In-Reply-To: <1270794078.794237.347827867455.qpush@pale>
CC: <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Message-Id: <20100409062119.040B0CBB6F@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

need_active_balance() gates the asymmetric packing based due to power
save logic, but for packing we don't care.

This marks the type of balanace we are attempting to do perform from
f_b_g() and stops need_active_balance() power save logic gating a
balance in the asymmetric packing case.

Signed-off-by: Michael Neuling <mikey@neuling.org>

---

 kernel/sched_fair.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

Index: linux-2.6-ozlabs/kernel/sched_fair.c
===================================================================
--- linux-2.6-ozlabs.orig/kernel/sched_fair.c
+++ linux-2.6-ozlabs/kernel/sched_fair.c
@@ -91,6 +91,13 @@ const_debug unsigned int sysctl_sched_mi
 
 static const struct sched_class fair_sched_class;
 
+enum balance_type {
+	BALANCE_NONE = 0,
+	BALANCE_LOAD,
+	BALANCE_POWER,
+	BALANCE_PACKING
+};
+
 /**************************************************************
  * CFS operations on generic schedulable entities:
  */
@@ -2783,7 +2790,8 @@ static inline void calculate_imbalance(s
 static struct sched_group *
 find_busiest_group(struct sched_domain *sd, int this_cpu,
 		   unsigned long *imbalance, enum cpu_idle_type idle,
-		   int *sd_idle, const struct cpumask *cpus, int *balance)
+		   int *sd_idle, const struct cpumask *cpus, int *balance,
+		   enum balance_type *bt)
 {
 	struct sd_lb_stats sds;
 
@@ -2808,6 +2816,7 @@ find_busiest_group(struct sched_domain *
 	if (!(*balance))
 		goto ret;
 
+	*bt = BALANCE_PACKING;
 	if ((idle == CPU_IDLE || idle == CPU_NEWLY_IDLE) &&
 	    check_asym_packing(sd, &sds, this_cpu, imbalance))
 		return sds.busiest;
@@ -2828,6 +2837,7 @@ find_busiest_group(struct sched_domain *
 
 	/* Looks like there is an imbalance. Compute it */
 	calculate_imbalance(&sds, this_cpu, imbalance);
+	*bt = BALANCE_LOAD;
 	return sds.busiest;
 
 out_balanced:
@@ -2835,10 +2845,12 @@ out_balanced:
 	 * There is no obvious imbalance. But check if we can do some balancing
 	 * to save power.
 	 */
+	*bt = BALANCE_POWER;
 	if (check_power_save_busiest_group(&sds, this_cpu, imbalance))
 		return sds.busiest;
 ret:
 	*imbalance = 0;
+	*bt = BALANCE_NONE;
 	return NULL;
 }
 
@@ -2899,9 +2911,10 @@ find_busiest_queue(struct sched_group *g
 /* Working cpumask for load_balance and load_balance_newidle. */
 static DEFINE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
 
-static int need_active_balance(struct sched_domain *sd, int sd_idle, int idle)
+static int need_active_balance(struct sched_domain *sd, int sd_idle, int idle,
+			       enum balance_type *bt)
 {
-	if (idle == CPU_NEWLY_IDLE) {
+	if (idle == CPU_NEWLY_IDLE && *bt != BALANCE_PACKING) {
 		/*
 		 * The only task running in a non-idle cpu can be moved to this
 		 * cpu in an attempt to completely freeup the other CPU
@@ -2946,6 +2959,7 @@ static int load_balance(int this_cpu, st
 	struct rq *busiest;
 	unsigned long flags;
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
+	enum balance_type bt;
 
 	cpumask_copy(cpus, cpu_active_mask);
 
@@ -2964,7 +2978,7 @@ static int load_balance(int this_cpu, st
 redo:
 	update_shares(sd);
 	group = find_busiest_group(sd, this_cpu, &imbalance, idle, &sd_idle,
-				   cpus, balance);
+				   cpus, balance, &bt);
 
 	if (*balance == 0)
 		goto out_balanced;
@@ -3018,7 +3032,7 @@ redo:
 		schedstat_inc(sd, lb_failed[idle]);
 		sd->nr_balance_failed++;
 
-		if (need_active_balance(sd, sd_idle, idle)) {
+		if (need_active_balance(sd, sd_idle, idle, &bt)) {
 			raw_spin_lock_irqsave(&busiest->lock, flags);
 
 			/* don't kick the migration_thread, if the curr

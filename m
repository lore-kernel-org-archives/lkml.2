Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab0DOEPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 00:15:16 -0400
Received: from ozlabs.org ([203.10.76.45]:56612 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031Ab0DOEPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 00:15:14 -0400
From: Michael Neuling <mikey@neuling.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH 4/5] sched: Mark the balance type for use in need_active_balance()
In-reply-to: <1271161768.4807.1282.camel@twins>
References: <20100409062119.040B0CBB6F@localhost.localdomain> <1271161768.4807.1282.camel@twins>
Comments: In-reply-to Peter Zijlstra <peterz@infradead.org>
   message dated "Tue, 13 Apr 2010 14:29:28 +0200."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Thu, 15 Apr 2010 14:15:12 +1000
Message-ID: <25935.1271304912@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 2010-04-09 at 16:21 +1000, Michael Neuling wrote:
> > need_active_balance() gates the asymmetric packing based due to power
> > save logic, but for packing we don't care.
> 
> This explanation lacks a how/why.
> 
> So the problem is that need_active_balance() ends up returning false and
> prevents the active balance from pulling a task to a lower available SMT
> sibling?

Correct.  I've put a more detailed description in the patch below.  

> > This marks the type of balanace we are attempting to do perform from
> > f_b_g() and stops need_active_balance() power save logic gating a
> > balance in the asymmetric packing case.
> 
> At the very least this wants more comments in the code. 

Sorry again for the lack luster comments. I've updated this patch also.

> I'm not really charmed by having to add yet another variable to pass
> around that mess, but I can't seem to come up with something cleaner
> either.

Yeah, the current case only ever reads the balance type in the !=
BALANCE_POWER so a full enum might be overkill, but I though it might
come in useful for someone else.

Updated patch below.

Mikey


[PATCH 4/5] sched: fix need_active_balance() from preventing asymmetric packing 

need_active_balance() prevents a task being pulled onto a newly idle
package in an attempt to completely free it so it can be powered down.
Hence it returns false to load_balance() and prevents the active
balance from occurring.

Unfortunately, when asymmetric packing is enabled at the sibling level
this power save logic is preventing the packing balance from moving a
task to a lower idle thread.  At the sibling level SD_SHARE_CPUPOWER
and parent(SD_POWERSAVINGS_BALANCE) are enabled and the domain is also
non-idle (since we have at least 1 task we are trying to move down).
Hence the following code, prevents the an active balance from
occurring:

		if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
		    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
			return 0;

To fix this, this patch classifies the type of balance we are
attempting to perform into none, load, power and packing based on what
function finds busiest in f_b_g().  This classification is then used
by need_active_balance() to prevent the above power saving logic from
stopping a balance due to asymmetric packing.  This ensures tasks can
be correctly moved down to lower sibling threads.  

Signed-off-by: Michael Neuling <mikey@neuling.org>
---

 kernel/sched_fair.c |   35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

Index: linux-2.6-ozlabs/kernel/sched_fair.c
===================================================================
--- linux-2.6-ozlabs.orig/kernel/sched_fair.c
+++ linux-2.6-ozlabs/kernel/sched_fair.c
@@ -91,6 +91,14 @@ const_debug unsigned int sysctl_sched_mi
 
 static const struct sched_class fair_sched_class;
 
+/* Enum to classify the type of balance we are attempting to perform */
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
@@ -2803,16 +2811,19 @@ static inline void calculate_imbalance(s
  * @cpus: The set of CPUs under consideration for load-balancing.
  * @balance: Pointer to a variable indicating if this_cpu
  *	is the appropriate cpu to perform load balancing at this_level.
+ * @bt: returns the type of imbalance found
  *
  * Returns:	- the busiest group if imbalance exists.
  *		- If no imbalance and user has opted for power-savings balance,
  *		   return the least loaded group whose CPUs can be
  *		   put to idle by rebalancing its tasks onto our group.
+ *		- *bt classifies the type of imbalance found
  */
 static struct sched_group *
 find_busiest_group(struct sched_domain *sd, int this_cpu,
 		   unsigned long *imbalance, enum cpu_idle_type idle,
-		   int *sd_idle, const struct cpumask *cpus, int *balance)
+		   int *sd_idle, const struct cpumask *cpus, int *balance,
+		   enum balance_type *bt)
 {
 	struct sd_lb_stats sds;
 
@@ -2837,6 +2848,7 @@ find_busiest_group(struct sched_domain *
 	if (!(*balance))
 		goto ret;
 
+	*bt = BALANCE_PACKING;
 	if ((idle == CPU_IDLE || idle == CPU_NEWLY_IDLE) &&
 	    check_asym_packing(sd, &sds, this_cpu, imbalance))
 		return sds.busiest;
@@ -2857,6 +2869,7 @@ find_busiest_group(struct sched_domain *
 
 	/* Looks like there is an imbalance. Compute it */
 	calculate_imbalance(&sds, this_cpu, imbalance);
+	*bt = BALANCE_LOAD;
 	return sds.busiest;
 
 out_balanced:
@@ -2864,10 +2877,12 @@ out_balanced:
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
 
@@ -2928,9 +2943,18 @@ find_busiest_queue(struct sched_group *g
 /* Working cpumask for load_balance and load_balance_newidle. */
 static DEFINE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
 
-static int need_active_balance(struct sched_domain *sd, int sd_idle, int idle)
+static int need_active_balance(struct sched_domain *sd, int sd_idle, int idle,
+			       enum balance_type *bt)
 {
-	if (idle == CPU_NEWLY_IDLE) {
+	/*
+	 * The powersave code will stop a task being moved in an
+	 * attempt to freeup CPU package wich could be powered
+	 * down. In the case where we are attempting to balance due to
+	 * asymmetric packing at the sibling level, we don't care
+	 * about power save.  Hence prevent powersave stopping a
+	 * balance trigged by packing.
+         */
+	if (idle == CPU_NEWLY_IDLE && *bt != BALANCE_PACKING) {
 		/*
 		 * The only task running in a non-idle cpu can be moved to this
 		 * cpu in an attempt to completely freeup the other CPU
@@ -2975,6 +2999,7 @@ static int load_balance(int this_cpu, st
 	struct rq *busiest;
 	unsigned long flags;
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
+	enum balance_type bt;
 
 	cpumask_copy(cpus, cpu_active_mask);
 
@@ -2993,7 +3018,7 @@ static int load_balance(int this_cpu, st
 redo:
 	update_shares(sd);
 	group = find_busiest_group(sd, this_cpu, &imbalance, idle, &sd_idle,
-				   cpus, balance);
+				   cpus, balance, &bt);
 
 	if (*balance == 0)
 		goto out_balanced;
@@ -3047,7 +3072,7 @@ redo:
 		schedstat_inc(sd, lb_failed[idle]);
 		sd->nr_balance_failed++;
 
-		if (need_active_balance(sd, sd_idle, idle)) {
+		if (need_active_balance(sd, sd_idle, idle, &bt)) {
 			raw_spin_lock_irqsave(&busiest->lock, flags);
 
 			/* don't kick the migration_thread, if the curr

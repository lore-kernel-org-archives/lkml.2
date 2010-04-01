Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab0DAH6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 03:58:46 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:39194 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab0DAH6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 03:58:41 -0400
Date: Thu, 1 Apr 2010 13:28:24 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@redhat.com>, Venkatesh Pallipadi <venki@google.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, ego@in.ibm.com
Subject: [patch repost] sched: Fix group_capacity for
 sched_smt_powersavings=1
Message-ID: <20100401075824.GU5300@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

This is repost of the same patch http://lkml.org/lkml/2010/3/22/275
(and http://lkml.org/lkml/2010/3/2/216)

After applying Suresh's fixes from discussion thread
http://lkml.org/lkml/2010/2/12/352, we still need the attached patch
to restore sched_smt_powersavings=1 functionality where tasks prefer
sibling threads and keep more cores idle.

Please apply to sched-tip, the patch is rebased and tested on today's
sched-tip master.

The attached patch will run 4 while(1) loops in two cores when
sched_smt_power_savings=1.  Tested on two socket, quad core, hyper
threaded system.

Additional testing was done on POWER platform where
sched_smt_powersavings was able to consolidate tasks on sibling
threads leaving more idle cores.

Thanks,
Vaidy
---
        sched: Fix group_capacity for sched_smt_powersavings=1

        sched_smt_powersavings for threaded systems need this fix for
        consolidation to sibling threads to work.  Since threads have 
        fractional capacity, group_capacity will turn out to be one 
        always and not accommodate another task in the sibling thread.
        
        This fix makes group_capacity a function of cpumask_weight that
        will enable the power saving load balancer to pack tasks among
        sibling threads and keep more cores idle.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5a5ea2c..7c0a29a 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2538,6 +2538,21 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 		 */
 		if (prefer_sibling)
 			sgs.group_capacity = min(sgs.group_capacity, 1UL);
+		/*
+		 * If power savings balance is set at this domain, then
+		 * make capacity equal to number of hardware threads to
+		 * accommodate more tasks until capacity is reached.
+		 */
+		else if (sd->flags & SD_POWERSAVINGS_BALANCE)
+			sgs.group_capacity =
+				cpumask_weight(sched_group_cpus(group));
+
+			/*
+			 * The default group_capacity is rounded from sum of
+			 * fractional cpu_powers of sibling hardware threads
+			 * in order to enable fair use of available hardware
+			 * resources.
+			 */
 
 		if (local_group) {
 			sds->this_load = sgs.avg_load;
@@ -2863,7 +2878,8 @@ static int need_active_balance(struct sched_domain *sd, int sd_idle, int idle)
 		    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
 			return 0;
 
-		if (sched_mc_power_savings < POWERSAVINGS_BALANCE_WAKEUP)
+		if (sched_mc_power_savings < POWERSAVINGS_BALANCE_WAKEUP &&
+		    sched_smt_power_savings < POWERSAVINGS_BALANCE_WAKEUP)
 			return 0;
 	}
 

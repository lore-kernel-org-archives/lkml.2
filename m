Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab2AJQp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 11:45:27 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:41533 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab2AJQpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 11:45:25 -0500
Date: Tue, 10 Jan 2012 22:14:55 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com, len.brown@intel.com,
        anhua.xu@intel.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
Message-ID: <20120110164455.GA17432@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
 <1326103578.2442.50.camel@twins>
 <20120110001445.GA20542@linux-youquan.bj.intel.com>
 <1326107156.2442.59.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1326107156.2442.59.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12011016-5816-0000-0000-000000C9E1B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2012-01-09 12:05:56]:

> On Mon, 2012-01-09 at 19:14 -0500, Youquan Song wrote:
> > Fine, I will base your suggestion to develop another patch soon.
> > 
> 
> > 
> > @@ -3923,6 +3923,10 @@ static inline void update_sg_lb_stats(struct
> > sched_domain *sd,
> >                                                 SCHED_POWER_SCALE);
> >         if (!sgs->group_capacity)
> >                 sgs->group_capacity = fix_small_capacity(sd, group);
> > +
> > +       if (sched_smt_power_savings)
> > +               sgs->group_capacity *= 2; 
> 
> Note, this has the hard-coded assumption you only have 2 threads per
> core, which while true for intel, isn't true in general. I think you
> meant to write *= group->group_weight or somesuch.
> 
> Also, you forgot to limit this to the SD_SHARE_CPUPOWER domain, you're
> now doubling the capacity for all domains.
> 
> Furthermore, have a look at the SD_PREFER_SIBLING logic and make sure
> you're not fighting that.

Hi Peter,

I think I had proposed the following fix earlier.  Can we revisit this
now?  This works, but it is not the best solution.

    sched: Fix group_capacity for sched_smt_powersavings
    
    sched_smt_powersavings for threaded systems need this fix for
    consolidation to sibling threads to work.  Since threads have
    fractional capacity, group_capacity will turn out to be one
    always and not accommodate another task in the sibling thread.
    
    This fix makes group_capacity a function of cpumask_weight that
    will enable the power saving load balancer to pack tasks among
    sibling threads and keep more cores idle.
    
    Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8e42de9..77ac4ca 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4010,6 +4010,21 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 		 */
 		if (prefer_sibling && !local_group && sds->this_has_capacity)
 			sgs.group_capacity = min(sgs.group_capacity, 1UL);
+		/*
+		 * If power savings balance is set at this domain, then
+		 * make capacity equal to number of hardware threads to
+		 * accommodate more tasks until capacity is reached.
+		 */
+		else if (sd->flags & SD_POWERSAVINGS_BALANCE)
+			sgs.group_capacity =
+				cpumask_weight(sched_group_cpus(sg));
+
+			/*
+			 * The default group_capacity is rounded from sum of
+			 * fractional cpu_powers of sibling hardware threads
+			 * in order to enable fair use of available hardware
+			 * resources.
+			 */
 
 		if (local_group) {
 			sds->this_load = sgs.avg_load;
@@ -4432,7 +4447,8 @@ static int need_active_balance(struct sched_domain *sd, int idle,
 		 * move_tasks() will succeed.  ld_moved will be true and this
 		 * active balance code will not be triggered.
 		 */
-		if (sched_mc_power_savings < POWERSAVINGS_BALANCE_WAKEUP)
+		if (sched_mc_power_savings < POWERSAVINGS_BALANCE_WAKEUP &&
+		    sched_smt_power_savings < POWERSAVINGS_BALANCE_WAKEUP)
 			return 0;
 	}
 


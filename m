Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab1EMOPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 10:15:10 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:36381 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab1EMOPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 10:15:08 -0400
Date: Fri, 13 May 2011 07:14:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110513141431.GV2258@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110512060344.GB3191@elte.hu>
 <4DCB8BCD.1080607@kernel.org>
 <4DCB8F7A.90603@kernel.org>
 <20110512092013.GJ2258@linux.vnet.ibm.com>
 <4DCC52FB.6030500@kernel.org>
 <4DCC894D.3070204@kernel.org>
 <20110513084253.GE13647@elte.hu>
 <20110513121906.GA3676@elte.hu>
 <20110513130414.GA6863@elte.hu>
 <20110513131218.GA7669@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513131218.GA7669@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 03:12:18PM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > I started bisecting this, and the two relevant endpoints:
> > 
> >   bad: 11c476f: net,rcu: convert call_rcu(prl_entry_destroy_rcu) to kfree
> >  good: 0ee5623f: Linux 2.6.39-rc6
> > 
> > very clearly indicate that this is an RCU regression.
> 
> This might be the same one Yinghai found:
> 
>  e59fb3120bec: rcu: Decrease memory-barrier usage based on semi-formal proof
> 
> So with the config i sent it's definitely reproducible.
> 
> At first sight couldnt this be related not to barriers, but to not setting 
> need_resched() like we did before?

Thank you both!!!  I had inspected the commit, but missed the fact that
the new version refuses to call set_need_resched() if irqs are enabled.  :-(
The following (untested) patch restores the set_need_resched() operation.

Does this help?

							Thanx, Paul

------------------------------------------------------------------------

rcu: Reschedule from dyntick even if irqs are enabled.

Commit e59fb3120bec (rcu: Decrease memory-barrier usage based on
semi-formal proof) attempted to optimize by invoking set_need_resched()
only when irqs are disabled.  This patch restores the prior behavior
of invoking set_need_resched() even if irqs are enabled, but leaves
the memory-barrier-usage changes untouched.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5b0b482..8c490ef 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -335,10 +335,9 @@ void rcu_enter_nohz(void)
 	local_irq_restore(flags);
 
 	/* If the interrupt queued a callback, get out of dyntick mode. */
-	if (in_irq() &&
-	    (__get_cpu_var(rcu_sched_data).nxtlist ||
-	     __get_cpu_var(rcu_bh_data).nxtlist ||
-	     rcu_preempt_needs_cpu(smp_processor_id())))
+	if (__get_cpu_var(rcu_sched_data).nxtlist ||
+	    __get_cpu_var(rcu_bh_data).nxtlist ||
+	    rcu_preempt_needs_cpu(smp_processor_id()))
 		set_need_resched();
 }
 

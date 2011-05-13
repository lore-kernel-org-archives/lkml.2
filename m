Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab1ENOti (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 10:49:38 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33696 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758045Ab1ENOtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 10:49:33 -0400
Date: Fri, 13 May 2011 09:26:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110513162646.GW2258@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4DCB8F7A.90603@kernel.org>
 <20110512092013.GJ2258@linux.vnet.ibm.com>
 <4DCC52FB.6030500@kernel.org>
 <4DCC894D.3070204@kernel.org>
 <20110513084253.GE13647@elte.hu>
 <20110513121906.GA3676@elte.hu>
 <20110513130414.GA6863@elte.hu>
 <20110513131218.GA7669@elte.hu>
 <20110513141431.GV2258@linux.vnet.ibm.com>
 <20110513150744.GE32688@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513150744.GE32688@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 05:07:44PM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Fri, May 13, 2011 at 03:12:18PM +0200, Ingo Molnar wrote:
> > > 
> > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > I started bisecting this, and the two relevant endpoints:
> > > > 
> > > >   bad: 11c476f: net,rcu: convert call_rcu(prl_entry_destroy_rcu) to kfree
> > > >  good: 0ee5623f: Linux 2.6.39-rc6
> > > > 
> > > > very clearly indicate that this is an RCU regression.
> > > 
> > > This might be the same one Yinghai found:
> > > 
> > >  e59fb3120bec: rcu: Decrease memory-barrier usage based on semi-formal proof
> > > 
> > > So with the config i sent it's definitely reproducible.
> > > 
> > > At first sight couldnt this be related not to barriers, but to not setting 
> > > need_resched() like we did before?
> > 
> > Thank you both!!!  I had inspected the commit, but missed the fact that
> > the new version refuses to call set_need_resched() if irqs are enabled.  :-(
> > The following (untested) patch restores the set_need_resched() operation.
> 
> Btw., in hindsight, e59fb3120bec was a tad big, which made analysis harder.
> 
> Would it have been possible to split it in two, one for the movement of the 
> notifiers, the other for the barrier changes?
> 
> That way the bisection would have fingered the movement commit. Or so.

In hindsight, that certainly would have been better.

> > Does this help?
> 
> No, unfortunately not, the long delay is still there:
> 
> device: 'ttyS0': device_add
> PM: Adding info for No Bus:ttyS0
> INFO: rcu_sched_state detected stalls on CPUs/tasks: { 0} (detected by 1, t=6002 jiffies)

I was afraid of that...

On the off-chance that moving the memory barriers was at fault,
the following patch restores all of them that don't have in situ
replacements.  Grasping at straws, admittedly.

						Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 8c490ef..a4a2ef0 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1449,10 +1449,12 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
  */
 static void rcu_process_callbacks(void)
 {
+	smp_mb();
 	__rcu_process_callbacks(&rcu_sched_state,
 				&__get_cpu_var(rcu_sched_data));
 	__rcu_process_callbacks(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
 	rcu_preempt_process_callbacks();
+	smp_mb();
 
 	/* If we are last CPU on way to dyntick-idle mode, accelerate it. */
 	rcu_needs_cpu_flush();

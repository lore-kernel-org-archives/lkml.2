Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130Ab1HNXFE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 19:05:04 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35992 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab1HNXFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 19:05:01 -0400
Date: Sun, 14 Aug 2011 16:04:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.0-git15 Atomic scheduling in pidmap_init
Message-ID: <20110814230453.GP2650@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110805065646.GC13065@linux.vnet.ibm.com>
 <20110805142245.GP2096@zod.bos.redhat.com>
 <20110805170805.GB22164@somewhere>
 <20110805222641.GB2245@linux.vnet.ibm.com>
 <20110805231216.GE22164@somewhere>
 <20110808020914.GC2385@linux.vnet.ibm.com>
 <20110808025505.GF29058@somewhere>
 <20110808031014.GE2385@linux.vnet.ibm.com>
 <20110809113514.GA27301@somewhere.redhat.com>
 <20110810124528.GC2566@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810124528.GC2566@zod.bos.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 08:45:29AM -0400, Josh Boyer wrote:
> On Tue, Aug 09, 2011 at 01:35:18PM +0200, Frederic Weisbecker wrote:
> > > > > > > > > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > > > > > > > > index ba06207..8c6cb6e 100644
> > > > > > > > > --- a/kernel/rcutree.c
> > > > > > > > > +++ b/kernel/rcutree.c
> > > > > > > > > @@ -1681,8 +1681,14 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
> > > > > > > > >  		rdp->n_rp_qs_pending++;
> > > > > > > > >  		if (!rdp->preemptible &&
> > > > > > > > >  		    ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs) - 1,
> > > > > > > > > -				 jiffies))
> > > > > > > > > -			set_need_resched();
> > > > > > > > > +				 jiffies)) {
> > > > > > > > > +			/* Make sure we're ready to mark the task as needing
> > > > > > > > > + 			 * rescheduling otherwise we can trigger oopes early
> > > > > > > > > + 			 * in the init path
> > > > > > > > > + 			 */
> > > > > > > > > +			if (rcu_scheduler_active)
> > > > > > > > > +				set_need_resched();
> > > > > > > > 
> 
> <snip>
> 
> > > > > The first time we take a scheduling-clock interrupt on a CPU with a
> > > > > callback queued, we will also set qs_pending.  Hence the need to also
> > > > > suppress the assignment in __note_new_gpnum().  Or better yet, just
> > > > > prevent new grace periods in cpu_needs_another_gp().  I believe that doing
> > > > > this will make it unnecessary to do anything in rcu_init_percpu_data().
> > > > 
> > > > Yeah if we have callbacks enqueued during the boot then we need to have
> > > > a check in cpu_needs_another_gp().
> > > > 
> > > > Now rcu_init_percpu_data() still sets rdp->qs_pending to 1, and that
> > > > is going to stay as is as long as preemption is disabled.
> > > 
> > > But setting rdp->qs_pending to 1 in rcu_init_percpu_data() has no effect
> > > until a grace period starts.  So, if grace periods are prevented from
> 
> Er... really?  Because it gets set and __rcu_pending looks at it
> unconditionally in the case that is calling set_need_resched.  It
> doesn't check if there is anything about a grace period going on or not.

Frederic noted the condition that prevents this at boot time, but it
appears that newly onlined CPUs might send themselves needless resched
IPIs at runtime if RCU is idle.

> > > starting, no need to mess with rcu_init_percpu_data().  Especially given
> > > that rcu_init_percpu_data() is also used at late boot and runtime for
> > > CPU hotplug.
> > 
> > Ok.
> > 
> > > 
> > > So I believe that it is sufficient to change cpu_needs_another_gp()
> > > to check for boot being far enough along to allow grace periods.
> > 
> > Yep, sounds good.
> 
> I looked at doing this but got lost as to 1) how it would help the
> situtation I've reported, and 2) exactly how to do that.

It would prevent control from reaching that point, and that might
well be needed for other reasons.  (This bit about RCU needing to
work differently at boot time is, well, "interesting".)

> I'd be happy to test, but at the moment the proposed solution is
> confusing to me.

Please see the attached.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Avoid having just-onlined CPU resched itself when RCU is idle

CPUs set rdp->qs_pending when coming online to resolve races with
grace-period start.  However, this means that if RCU is idle, the
just-onlined CPU might needlessly send itself resched IPIs.  Adjust
the online-CPU initialization to avoid this, and also to correctly
cause the CPU to respond to the current grace period if needed.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index daa2e62..23ce24e 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1915,8 +1915,6 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 
 	/* Set up local state, ensuring consistent view of global state. */
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-	rdp->passed_quiesce = 0;  /* We could be racing with new GP, */
-	rdp->qs_pending = 1;	 /*  so set up to respond to current GP. */
 	rdp->beenonline = 1;	 /* We have now been online. */
 	rdp->preemptible = preemptible;
 	rdp->qlen_last_fqs_check = 0;
@@ -1941,8 +1939,15 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 		rnp->qsmaskinit |= mask;
 		mask = rnp->grpmask;
 		if (rnp == rdp->mynode) {
-			rdp->gpnum = rnp->completed; /* if GP in progress... */
+			/*
+			 * If there is a grace period in progress, we will
+			 * set up to wait for it next time we run the
+			 * RCU core code.
+			 */
+			rdp->gpnum = rnp->completed;
 			rdp->completed = rnp->completed;
+			rdp->passed_quiesce = 0;
+			rdp->qs_pending = 0;
 			rdp->passed_quiesce_gpnum = rnp->gpnum - 1;
 			trace_rcu_grace_period(rsp->name, rdp->gpnum, "cpuonl");
 		}

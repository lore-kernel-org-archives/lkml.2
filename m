Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab1HHDKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 23:10:21 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46104 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769Ab1HHDKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 23:10:20 -0400
Date: Sun, 7 Aug 2011 20:10:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.0-git15 Atomic scheduling in pidmap_init
Message-ID: <20110808031014.GE2385@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110804162658.GZ13065@linux.vnet.ibm.com>
 <20110804173145.GM2096@zod.bos.redhat.com>
 <CA+5PVA7R+H4MfU=war6G3ZRYEi6nZ=vVZ3B8g-Ag6pOdA4cTBw@mail.gmail.com>
 <20110805065646.GC13065@linux.vnet.ibm.com>
 <20110805142245.GP2096@zod.bos.redhat.com>
 <20110805170805.GB22164@somewhere>
 <20110805222641.GB2245@linux.vnet.ibm.com>
 <20110805231216.GE22164@somewhere>
 <20110808020914.GC2385@linux.vnet.ibm.com>
 <20110808025505.GF29058@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110808025505.GF29058@somewhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 04:55:07AM +0200, Frederic Weisbecker wrote:
> On Sun, Aug 07, 2011 at 07:09:14PM -0700, Paul E. McKenney wrote:
> > On Sat, Aug 06, 2011 at 01:12:18AM +0200, Frederic Weisbecker wrote:
> > > On Fri, Aug 05, 2011 at 03:26:41PM -0700, Paul E. McKenney wrote:
> > > > On Fri, Aug 05, 2011 at 07:08:08PM +0200, Frederic Weisbecker wrote:
> > > > > On Fri, Aug 05, 2011 at 10:22:45AM -0400, Josh Boyer wrote:
> > > > > > On Thu, Aug 04, 2011 at 11:56:46PM -0700, Paul E. McKenney wrote:
> > > > > > > > > I could be missing something obvious, but I don't see a way to avoid
> > > > > > > > > using GFP_KERNEL without a lot of rip-up in the rest of the init path.
> > > > > > > > 
> > > > > > > > As an aside, I bisected this back to:
> > > > > > > > 
> > > > > > > > e8f7c70f44f sched: Make sleeping inside spinlock detection working in
> > > > > > > > !CONFIG_PREEMPT
> > > > > > > 
> > > > > > > OK, added Frederic on CC.
> > > > > > > 
> > > > > > > > However, that doesn't seem all that helpful.  The
> > > > > > > > CONFIG_DEBUG_SPINLOCK_SLEEP option later got renamed to
> > > > > > > > DEBUG_ATOMIC_SLEEP, and all it's doing is selecting PREEMPT_COUNT.  At
> > > > > > > > first glance, it seems this commit just allowed an issue that's been
> > > > > > > > around for a while (benign or otherwise) to finally show up.
> > > > > > > > 
> > > > > > > > (The Fedora kernel configs have CONFIG_PREEMPT_VOLUNTARY set, but not
> > > > > > > > CONFIG_PREEMPT so PREEMPT_COUNT wasn't getting selected until this
> > > > > > > > option did so.)
> > > > > > > 
> > > > > > > Understood.  So my question is "what is the real way to fix this?"
> > > > > > > Within RCU, I would probably wrapper the calls to set_need_resched()
> > > > > > > so that it checks for the scheduler being fully alive.  Except for the
> > > > > > > call from rcu_enter_nohz(), of course -- if that one is called before
> > > > > > > the scheduler is ready, then that is a bug that needs to be fixed.
> > > > > > 
> > > > > > By scheduler being fully alive, do you mean when rcu_scheduler_starting
> > > > > > is called?  Or do you mean the actual scheduler, because sched_init is
> > > > > > called well before any of this happens.
> > > > > > 
> > > > > > > Nevertheless, I am wondering if all of this isn't really papering over
> > > > > > > some real problem somewhere.  The way we get to this place is from people
> > > > > > > registering RCU callbacks during early boot, which is OK in and of itself,
> > > > > > > at least in moderation.  But if someone is expecting those callbacks to be
> > > > > > > invoked before the scheduler is fully set up and running multiple tasks,
> > > > > > > they are going to be disappointed.
> > > > > > 
> > > > > > Is there a way to dump what callbacks have been registered?  As far as I
> > > > > > can see, we call rcu_check_callbacks unconditionally when a timer
> > > > > > interrupt is taken and that calls rcu_pending unconditionally as well.
> > > > > > Before that, rcu_init is called which eventually sets up the per-cpu
> > > > > > data via rcu_init_percpu_data and that sets rdp->qs_pending = 1.
> > > > > > Until a quiescent state is reached __rcu_pending is going to try and
> > > > > > force it, which is where the set_need_resched is called.
> > > > > > 
> > > > > > Basically, I took what you said about wrapping set_need_resched and came
> > > > > > up with the patch below.  It gets rid of the oops from pidmap_init, but
> > > > > > I need to test it a bit more.  Would be happy to have feedback.
> > > > > > 
> > > > > > josh
> > > > > > 
> > > > > > ---
> > > > > > 
> > > > > > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > > > > > index ba06207..8c6cb6e 100644
> > > > > > --- a/kernel/rcutree.c
> > > > > > +++ b/kernel/rcutree.c
> > > > > > @@ -1681,8 +1681,14 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
> > > > > >  		rdp->n_rp_qs_pending++;
> > > > > >  		if (!rdp->preemptible &&
> > > > > >  		    ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs) - 1,
> > > > > > -				 jiffies))
> > > > > > -			set_need_resched();
> > > > > > +				 jiffies)) {
> > > > > > +			/* Make sure we're ready to mark the task as needing
> > > > > > + 			 * rescheduling otherwise we can trigger oopes early
> > > > > > + 			 * in the init path
> > > > > > + 			 */
> > > > > > +			if (rcu_scheduler_active)
> > > > > > +				set_need_resched();
> > > > > 
> > > > > What about we avoid setting rdp->qs_pending = 1 for the CPU
> > > > > that handles the boot?
> > > > 
> > > > That sounds promising -- only checked at the beginning of a grace period,
> > > > so not too much overhead.  In contrast, __rcu_pending() is called
> > > > multiple times per transition to dyntick-idle state.
> > > > 
> > > > I will take a look at this.
> > > > 
> > > > 							Thanx, Paul
> > > 
> > > I actually thought it could be done from rcu_init_percpu_data(). This
> > > is where we initialize the qs_pending to 1, which I believe is responsible
> > > for that set_need_resched() from rcu soon after on boot.
> > 
> > That would cover some of the situations, but...
> > 
> > > It's possible we also have secondary offenders in places that enqueue
> > > rcu callbacks in the boot. But if not, then we are fine with tweaking
> > > that qs_pending on cpu boot.
> > 
> > The first time we take a scheduling-clock interrupt on a CPU with a
> > callback queued, we will also set qs_pending.  Hence the need to also
> > suppress the assignment in __note_new_gpnum().  Or better yet, just
> > prevent new grace periods in cpu_needs_another_gp().  I believe that doing
> > this will make it unnecessary to do anything in rcu_init_percpu_data().
> 
> Yeah if we have callbacks enqueued during the boot then we need to have
> a check in cpu_needs_another_gp().
> 
> Now rcu_init_percpu_data() still sets rdp->qs_pending to 1, and that
> is going to stay as is as long as preemption is disabled.

But setting rdp->qs_pending to 1 in rcu_init_percpu_data() has no effect
until a grace period starts.  So, if grace periods are prevented from
starting, no need to mess with rcu_init_percpu_data().  Especially given
that rcu_init_percpu_data() is also used at late boot and runtime for
CPU hotplug.

So I believe that it is sufficient to change cpu_needs_another_gp()
to check for boot being far enough along to allow grace periods.

							Thanx, Paul

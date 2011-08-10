Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab1HJMpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:45:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022Ab1HJMpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:45:41 -0400
Date: Wed, 10 Aug 2011 08:45:29 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.0-git15 Atomic scheduling in pidmap_init
Message-ID: <20110810124528.GC2566@zod.bos.redhat.com>
References: <CA+5PVA7R+H4MfU=war6G3ZRYEi6nZ=vVZ3B8g-Ag6pOdA4cTBw@mail.gmail.com>
 <20110805065646.GC13065@linux.vnet.ibm.com>
 <20110805142245.GP2096@zod.bos.redhat.com>
 <20110805170805.GB22164@somewhere>
 <20110805222641.GB2245@linux.vnet.ibm.com>
 <20110805231216.GE22164@somewhere>
 <20110808020914.GC2385@linux.vnet.ibm.com>
 <20110808025505.GF29058@somewhere>
 <20110808031014.GE2385@linux.vnet.ibm.com>
 <20110809113514.GA27301@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110809113514.GA27301@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 01:35:18PM +0200, Frederic Weisbecker wrote:
> > > > > > > > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > > > > > > > index ba06207..8c6cb6e 100644
> > > > > > > > --- a/kernel/rcutree.c
> > > > > > > > +++ b/kernel/rcutree.c
> > > > > > > > @@ -1681,8 +1681,14 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
> > > > > > > >  		rdp->n_rp_qs_pending++;
> > > > > > > >  		if (!rdp->preemptible &&
> > > > > > > >  		    ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs) - 1,
> > > > > > > > -				 jiffies))
> > > > > > > > -			set_need_resched();
> > > > > > > > +				 jiffies)) {
> > > > > > > > +			/* Make sure we're ready to mark the task as needing
> > > > > > > > + 			 * rescheduling otherwise we can trigger oopes early
> > > > > > > > + 			 * in the init path
> > > > > > > > + 			 */
> > > > > > > > +			if (rcu_scheduler_active)
> > > > > > > > +				set_need_resched();
> > > > > > > 

<snip>

> > > > The first time we take a scheduling-clock interrupt on a CPU with a
> > > > callback queued, we will also set qs_pending.  Hence the need to also
> > > > suppress the assignment in __note_new_gpnum().  Or better yet, just
> > > > prevent new grace periods in cpu_needs_another_gp().  I believe that doing
> > > > this will make it unnecessary to do anything in rcu_init_percpu_data().
> > > 
> > > Yeah if we have callbacks enqueued during the boot then we need to have
> > > a check in cpu_needs_another_gp().
> > > 
> > > Now rcu_init_percpu_data() still sets rdp->qs_pending to 1, and that
> > > is going to stay as is as long as preemption is disabled.
> > 
> > But setting rdp->qs_pending to 1 in rcu_init_percpu_data() has no effect
> > until a grace period starts.  So, if grace periods are prevented from

Er... really?  Because it gets set and __rcu_pending looks at it
unconditionally in the case that is calling set_need_resched.  It
doesn't check if there is anything about a grace period going on or not.

> > starting, no need to mess with rcu_init_percpu_data().  Especially given
> > that rcu_init_percpu_data() is also used at late boot and runtime for
> > CPU hotplug.
> 
> Ok.
> 
> > 
> > So I believe that it is sufficient to change cpu_needs_another_gp()
> > to check for boot being far enough along to allow grace periods.
> 
> Yep, sounds good.

I looked at doing this but got lost as to 1) how it would help the
situtation I've reported, and 2) exactly how to do that.

I'd be happy to test, but at the moment the proposed solution is
confusing to me.

josh

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab1FRQKl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 12:10:41 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:34029 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab1FRQKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 12:10:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PA8p+3LCxOVROuDpQDn4bWLELkF4laKM7nMtbUxCsIsnlxeQrPZKO2TSm41lNpOYWU
         VBYRVrwUM7g3eBmBdaK77QVQ6bzSkII9v66Woeo/VQ5Z+WdvwS+trrZRwm6wjL3l3IoH
         60PDqXg4nl0Cf91ISZBlMeJ6SPN8eEa9UVs7M=
Date: Sat, 18 Jun 2011 18:10:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH 1/4] rcu: Detect uses of rcu read side in extended
 quiescent states
Message-ID: <20110618161032.GB9266@somewhere>
References: <1307663247-5397-1-git-send-email-fweisbec@gmail.com>
 <1307663247-5397-2-git-send-email-fweisbec@gmail.com>
 <20110610002350.GO2285@linux.vnet.ibm.com>
 <20110610005041.GI25771@somewhere.redhat.com>
 <20110617231902.GM2258@linux.vnet.ibm.com>
 <20110618142353.GA9266@somewhere>
 <20110618160426.GB2238@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110618160426.GB2238@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 18, 2011 at 09:04:27AM -0700, Paul E. McKenney wrote:
> On Sat, Jun 18, 2011 at 04:23:58PM +0200, Frederic Weisbecker wrote:
> > On Fri, Jun 17, 2011 at 04:19:03PM -0700, Paul E. McKenney wrote:
> > > On Fri, Jun 10, 2011 at 02:50:43AM +0200, Frederic Weisbecker wrote:
> > > > On Thu, Jun 09, 2011 at 05:23:50PM -0700, Paul E. McKenney wrote:
> > > > > On Fri, Jun 10, 2011 at 01:47:24AM +0200, Frederic Weisbecker wrote:
> > > > > > Detect uses of rcu that are not supposed to happen when we
> > > > > > are in an extended quiescent state.
> > > > > > 
> > > > > > This can happen for example if we use rcu between the time we
> > > > > > stop the tick and the time we restart it. Or inside an irq that
> > > > > > didn't use rcu_irq_enter,exit() or other possible kind of rcu API
> > > > > > misuse.
> > > > > > 
> > > > > > v2: Rebase against latest rcu changes, handle tiny RCU as well
> > > > > 
> > > > > Good idea on checking for RCU read-side critical sections happening
> > > > > in dyntick-idle periods!
> > > > > 
> > > > > But wouldn't it be better to put the checks in rcu_read_lock() and
> > > > > friends?  The problem I see with putting them in rcu_dereference_check()
> > > > > is that someone can legitimately do something like the following
> > > > > while in dyntick-idle mode:
> > > > > 
> > > > > 	spin_lock(&mylock);
> > > > > 	/* do a bunch of stuff */
> > > > > 	p = rcu_dereference_check(myrcuptr, lockdep_is_held(&mylock));
> > > > > 
> > > > > The logic below would complain about this usage, despite the fact
> > > > > that it is perfectly safe because the update-side lock is held.
> > > > > 
> > > > > Make sense, or am I missing something?
> > > > > 
> > > > > 						Thanx, Paul
> > > > 
> > > > I'm an idiot. I put my check in rcu_dereference_check() on purpose because
> > > > it's always called from places that check one of the rcu locks are held,
> > > > but I forgot that's also used for custom conditions with the _check()
> > > > things.
> > > > 
> > > > That said, putting the check in rcu_read_lock() and alike  would only work
> > > > with rcu_read_lock() itself. Few users of rcu_read_lock_sched() actually
> > > > call it explicitely but rely on irq disabled or preempt disabled. And I can't put the
> > > > checks there as it's fine to disabled irqs in dyntick idle.
> > > > 
> > > > What about the below? (untested yet)
> > > > 
> > > > And I would print the state of dynticks-idle mode in the final lockdep warning.
> > > 
> > > Printing the dynticks-idle mode would be quite good!
> > > 
> > > However, it is possible to have an RCU read-side critical section that does
> > > not have an rcu_dereference() or an rcu_read_lock_held().  So I do believe
> > > that we really do need rcu_read_lock() and friends to do this checking.
> > 
> > Right, then we need to check everything: rcu_read_lock() and friends in case
> > we have no rcu_read_lock_held() check made (ie: no rcu_dereference_check()),
> > but also rcu_read_lock_held()/rcu_read_lock_sched_held()/... because preempt_disable(),
> > local_irq_disable(), local_bh_disable() can't be checked so for rcu sched and rcu bh
> > we can only check the ...held() things.
> 
> Good point.  To make sure I understand, we have different approaches
> for the different types of RCU.  We need to instrument the following
> primitives:
> 
> 1.	rcu_read_lock() because a stray rcu_dereference() will already
> 	be caught by PROVE_RCU.
> 2.	rcu_read_lock_bh_held() because it is OK to do local_bh_disable()
> 	in dyntick-idle mode, so we cannot prohibit all of the
> 	read-acquisition cases.  We can also instrument rcu_read_lock_bh()
> 	to catch RCU-bh read-side critical sections that don't happen
> 	to contain rcu_dereference_bh().
> 3.	rcu_read_lock_sched_held() because it is OK to do preempt_disable()
> 	and local_irq_save() from dyntick-idle mode, so we again
> 	cannot prohibit all of the read-acquisition cases.  We can
> 	also instrument rcu_read_lock_sched() to catch RCU-sched
> 	read-side critical sections that don't happen to contain
> 	rcu_dereference_sched().

Exactly!

> 4.	srcu_read_lock() because a stray srcu_dereference() will already
> 	by caught by PROVE_RCU.

Well I have no idea how srcu works so I'll first focus on the rcu part :)

> 
> We miss a few cases, for example, an RCU-sched read-side critical
> section that uses local_irq_disable(), but that also does not contain
> an rcu_dereference_sched().  But still this sounds quite worthwhile.

Right.

So I'll send a v3 that takes the above point into accounts.

Thanks.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab1GXP46 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 11:56:58 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39879 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab1GXP4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 11:56:55 -0400
Date: Sun, 24 Jul 2011 08:56:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, laijs@cn.fujitsu.com,
        darren@dvhart.com, rostedt@goodmis.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] rtmutex: Permit rt_mutex_unlock() to be invoked
 with irqs disabled
Message-ID: <20110724155634.GG2415@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110719201410.GA10553@linux.vnet.ibm.com>
 <1311247968.29152.122.camel@twins>
 <20110723220348.GD2415@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1107240118550.2702@ionos>
 <alpine.LFD.2.02.1107240202500.2702@ionos>
 <20110724051744.GF2415@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1107241057320.2702@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1107241057320.2702@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 11:00:41AM +0200, Thomas Gleixner wrote:
> On Sat, 23 Jul 2011, Paul E. McKenney wrote:
> > On Sun, Jul 24, 2011 at 02:05:13AM +0200, Thomas Gleixner wrote:
> > > On Sun, 24 Jul 2011, Thomas Gleixner wrote:
> > > > > > Thomas, I'm inclined to merge this, any objections?
> > > > > 
> > > > > FWIW, it has been passing tests here.
> > > > 
> > > > If it's only the unlock path, I'm fine with that change.
> > > > 
> > > > Acked-by-me
> > > 
> > > Hrmpft. That's requiring all places to take the lock irq safe. Not
> > > really amused. For -RT that's a hotpath and we can really do without
> > > the irq fiddling there. That needs a bit more thought.
> > 
> > Indeed...  If I make only some of the lock acquisitions irq safe, lockdep
> > will yell at me.  And rightfully so, as that could result in deadlock.
> > 
> > So, what did you have in mind?
> 
> Have no real good idea yet for this. Could you grab rt and check
> whether you can observe any impact when the patch is applied?

Hmmm, wait a minute...  There might be a way to do this with zero
impact on the fastpath, given that I am allocating an rt_mutex on
the stack that is used only by RCU priority boosting, and that only
rt_mutex_init_proxy_locked(), rt_mutex_lock(), and rt_mutex_unlock()
are used.

So I could do the following:

o	Use lockdep_set_class_and_name() to make the ->wait_lock()
	field of my rt_mutex have a separate lockdep class.  I guess
	I should allocate a global variable for lock_class_key
	rather than allocating it on the stack.  ;-)

o	Make all calls from RCU priority boosting to rt_mutex_lock()
	and rt_mutex_unlock() have irqs disabled.

o	Make __rt_mutex_slowlock() do the following when sleeping:

	raw_spin_unlock(&lock->wait_lock);

	debug_rt_mutex_print_deadlock(waiter);

	{
		int was_disabled = irqs_disabled();

		if (was_disabled)
			local_irq_enable();

		schedule_rt_mutex(lock);

		if (was_disabled)
			local_irq_disable();

	}

	raw_spin_lock(&lock->wait_lock);
	set_current_state(state);

Would that work reasonably?

							Thanx, Paul

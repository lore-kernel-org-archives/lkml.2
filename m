Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599Ab0DPQpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 12:45:17 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44127 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758584Ab0DPQpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 12:45:11 -0400
Date: Fri, 16 Apr 2010 09:45:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 01/13] powerpc: Add rcu_read_lock() to gup_fast()
 implementation
Message-ID: <20100416164503.GH2615@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100413034311.GB2772@linux.vnet.ibm.com>
 <1271253110.32749.47.camel@laptop>
 <20100415142852.GA2471@linux.vnet.ibm.com>
 <1271425881.4807.2319.camel@twins>
 <20100416141745.GC2615@linux.vnet.ibm.com>
 <1271427819.4807.2353.camel@twins>
 <20100416143202.GE2615@linux.vnet.ibm.com>
 <1271429810.4807.2390.camel@twins>
 <20100416150909.GF2615@linux.vnet.ibm.com>
 <1271430855.4807.2411.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271430855.4807.2411.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 05:14:15PM +0200, Peter Zijlstra wrote:
> On Fri, 2010-04-16 at 08:09 -0700, Paul E. McKenney wrote:
> > On Fri, Apr 16, 2010 at 04:56:50PM +0200, Peter Zijlstra wrote:
> > > On Fri, 2010-04-16 at 07:32 -0700, Paul E. McKenney wrote:
> > > > On Fri, Apr 16, 2010 at 04:23:39PM +0200, Peter Zijlstra wrote:
> > > > > On Fri, 2010-04-16 at 07:17 -0700, Paul E. McKenney wrote:
> > > > > 
> > > > > > > > Of course, with call_rcu_sched(), the corresponding RCU read-side critical
> > > > > > > > sections are non-preemptible.  Therefore, in CONFIG_PREEMPT_RT, these
> > > > > > > > read-side critical sections must use raw spinlocks.
> > > > > > > 
> > > > > > > OK, so if we fully remove CONFIG_TREE_PREEMPT_RCU (defaulting to y),
> > > > > > > rename all the {call_rcu, rcu_read_lock, rcu_read_unlock,
> > > > > > > synchronize_rcu} functions to {*}_preempt and then add a new
> > > > > > > CONFIG_PREEMPT_RCU that simply maps {*} to either {*}_sched or
> > > > > > > {*}_preempt, we've basically got what I've been asking for for a while,
> > > > > > > no?
> > > > > > 
> > > > > > What would rcu_read_lock_preempt() do in a !CONFIG_PREEMPT kernel?
> > > > > 
> > > > > Same as for a preempt one, since you'd have to be able to schedule()
> > > > > while holding it to be able to do things like mutex_lock().
> > > > 
> > > > So what you really want is something like rcu_read_lock_sleep() rather
> > > > than rcu_read_lock_preempt(), right?  The point is that you want to do
> > > > more than merely preempt, given that it is legal to do general blocking
> > > > while holding a mutex, correct?
> > > 
> > > Right, but CONFIG_TREE_PREEMPT_RCU=y ends up being that. We could change
> > > the name to _sleep, but we've been calling it preemptible-rcu for a long
> > > while now.
> > 
> > It is actually not permitted to do general blocking in a preemptible RCU
> > read-side critical section.  Otherwise, someone is going to block waiting
> > for a network packet that never comes, thus OOMing the system.
> 
> Sure, something that guarantees progress seems like a sensible
> restriction for any lock, and in particular RCU :-)

Excellent point -- much of the issue really does center around
forward-progress guarantees.  In fact the Linux kernel has a number of
locking primitives that require different degrees of forward-progress
guarantee from the code in their respective critical sections:

o	spin_lock_irqsave(): Critical sections must guarantee forward
	progress against everything except NMI handlers.

o	raw_spin_lock(): Critical sections must guarantee forward
	progress against everything except IRQ (including softirq)
	and NMI handlers.

o	spin_lock(): Critical sections must guarantee forward
	progress against everything except IRQ (again including softirq)
	and NMI handlers and (given CONFIG_PREEMPT_RT) higher-priority
	realtime tasks.

o	mutex_lock(): Critical sections need not guarantee
	forward progress, as general blocking is permitted.

The other issue is the scope of the lock.  The Linux kernel has
the following:

o	BKL: global scope.

o	Everything else: scope defined by the use of the underlying
	lock variable.

One of the many reasons that we are trying to get rid of BKL is because
it combines global scope with relatively weak forward-progress guarantees.

So here is how the various RCU flavors stack up:

o	rcu_read_lock_bh(): critical sections must guarantee forward
	progress against everything except NMI handlers and IRQ handlers,
	but not against softirq handlers.  Global in scope, so that
	violating the forward-progress guarantee risks OOMing the system.

o	rcu_read_lock_sched(): critical sections must guarantee
	forward progress against everything except NMI and IRQ handlers,
	including softirq handlers.  Global in scope, so that violating
	the forward-progress guarantee risks OOMing the system.

o	rcu_read_lock(): critical sections must guarantee forward
	progress against everything except NMI handlers, IRQ handlers,
	softirq handlers, and (in CONFIG_PREEMPT_RT) higher-priority
	realtime tasks.  Global in scope, so that violating the
	forward-progress guarantee risks OOMing the system.

o	srcu_read_lock(): critical sections need not guarantee forward
	progress, as general blocking is permitted.  Scope is controlled
	by the use of the underlying srcu_struct structure.

As you say, one can block in rcu_read_lock() critical sections, but
the only blocking that is really safe is blocking that is subject to
priority inheritance.  This prohibits mutexes, because although the
mutexes themselves are subject to priority inheritance, the mutexes'
critical sections might well not be.

So the easy response is "just use SRCU."  Of course, SRCU has some
disadvantages at the moment:

o	The return value from srcu_read_lock() must be passed to
	srcu_read_unlock().  I believe that I can fix this.

o	There is no call_srcu().  I believe that I can fix this.

o	SRCU uses a flat per-CPU counter scheme that is not particularly
	scalable.  I believe that I can fix this.

o	SRCU's current implementation makes it almost impossible to
	implement priority boosting.  I believe that I can fix this.

o	SRCU requires explicit initialization of the underlying
	srcu_struct.  Unfortunately, I don't see a reasonable way
	around this.  Not yet, anyway.

So, is there anything else that you don't like about SRCU?

							Thanx, Paul

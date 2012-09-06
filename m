Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028Ab2IFSZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 14:25:43 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34356 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373Ab2IFSZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 14:25:41 -0400
Date: Thu, 6 Sep 2012 11:25:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 18/23] rcu: Add random PROVE_RCU_DELAY to
 grace-period initialization
Message-ID: <20120906182511.GQ2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-18-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346941673.18408.21.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346941673.18408.21.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090618-7182-0000-0000-00000286606A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 04:27:53PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-08-30 at 11:18 -0700, Paul E. McKenney wrote:
> > 
> > 1.      CPU 0 completes a grace period, but needs an additional
> >         grace period, so starts initializing one, initializing all
> >         the non-leaf rcu_node strcutures and the first leaf rcu_node
> >         structure.  Because CPU 0 is both completing the old grace
> >         period and starting a new one, it marks the completion of
> >         the old grace period and the start of the new grace period
> >         in a single traversal of the rcu_node structures.
> > 
> >         Therefore, CPUs corresponding to the first rcu_node structure
> >         can become aware that the prior grace period has ended, but
> >         CPUs corresponding to the other rcu_node structures cannot
> >         yet become aware of this.
> > 
> > 2.      CPU 1 passes through a quiescent state, and therefore informs
> >         the RCU core.  Because its leaf rcu_node structure has already
> >         been initialized, so this CPU's quiescent state is applied to
> >         the new (and only partially initialized) grace period.
> > 
> > 3.      CPU 1 enters an RCU read-side critical section and acquires
> >         a reference to data item A.  Note that this critical section
> >         will not block the new grace period.
> > 
> > 4.      CPU 16 exits dyntick-idle mode.  Because it was in dyntick-idle
> >         mode, some other CPU informed the RCU core of its extended
> >         quiescent state for the past several grace periods.  This means
> >         that CPU 16 is not yet aware that these grace periods have ended.
> > 
> > 5.      CPU 16 on the second leaf rcu_node structure removes data item A
> >         from its enclosing data structure and passes it to call_rcu(),
> >         which queues a callback in the RCU_NEXT_TAIL segment of the
> >         callback queue.
> > 
> > 6.      CPU 16 enters the RCU core, possibly because it has taken a
> >         scheduling-clock interrupt, or alternatively because it has
> >         more than 10,000 callbacks queued.  It notes that the second
> >         most recent grace period has ended (recall that it cannot yet
> >         become aware that the most recent grace period has completed),
> >         and therefore advances its callbacks.  The callback for data
> >         item A is therefore in the RCU_NEXT_READY_TAIL segment of the
> >         callback queue.
> > 
> > 7.      CPU 0 completes initialization of the remaining leaf rcu_node
> >         structures for the new grace period, including the structure
> >         corresponding to CPU 16.
> > 
> > 8.      CPU 16 again enters the RCU core, again, possibly because it has
> >         taken a scheduling-clock interrupt, or alternatively because
> >         it now has more than 10,000 callbacks queued.   It notes that
> >         the most recent grace period has ended, and therefore advances
> >         its callbacks.  The callback for data item A is therefore in
> >         the RCU_NEXT_TAIL segment of the callback queue.
> > 
> > 9.      All CPUs other than CPU 1 pass through quiescent states, so that
> >         the new grace period completes.  Note that CPU 1 is still in
> >         its RCU read-side critical section, still referencing data item A.
> > 
> > 10.     Suppose that CPU 2 is the last CPU to pass through a quiescent
> >         state for the new grace period, and suppose further that CPU 2
> >         does not have any callbacks queued.  It therefore traverses
> >         all of the rcu_node structures, marking the new grace period
> >         as completed, but does not initialize a new grace period.
> > 
> > 11.     CPU 16 yet again enters the RCU core, yet again possibly because
> >         it has taken a scheduling-clock interrupt, or alternatively
> >         because it now has more than 10,000 callbacks queued.   It notes
> >         that the new grace period has ended, and therefore advances
> >         its callbacks.  The callback for data item A is therefore in
> >         the RCU_DONE_TAIL segment of the callback queue.  This means
> >         that this callback is now considered ready to be invoked.
> > 
> > 12.     CPU 16 invokes the callback, freeing data item A while CPU 1
> >         is still referencing it. 
> 
> This is the same scenario as the previous patch (17), right?

Yep.  That one fixed the race, this one makes the race more probable.

> However did you find a 12-stage race like that, is that PROMELA goodness
> or are you training to beat some chess champion?

I saw actual test failures after introducing the patch moving the
grace-period initialization process to a kthread.  After chopping the
original single patch into pieces and seeing that failures appeared at
the point where I introduced preemption, it was clear what the overall
form of the failure had to be.  That said, it did take a few tries to
work out the exact failure scenario.  And I need to fix a few typos
in it.  :-/

RCU's state space is -way- too big for Promela to handle in one shot.
So I have been working on three approaches:

1.	Simplify RCU, or perhaps more accurately, introduce more
	invariants.

2.	Work with various formal-methods people in the hope that we
	can come up with something that actually can (in)validate the
	Linux-kernel RCU implementation in one go.  One of them did
	send me a draft paper formalizing RCU's semantics in a variant
	of separation logic, so progress is being made!

3.	Do line-by-line documentation of the current implementation.
	This has resulted in some bug fixes and some of #1 above.
	But it is going quite slowly, especially given that I keep
	changing RCU.  ;-)

It is really cool seeing some formal-methods people willing to take
on something like RCU!  In addition, others in the same group have
been working on taking the entire Linux kernel as written as input to
their tools, in one case handling about a million lines of the kernel.
Lots more work left to do, but meaningful progress!

							Thanx, Paul


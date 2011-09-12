Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab1ILQdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 12:33:39 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58561 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740Ab1ILQdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 12:33:38 -0400
Date: Mon, 12 Sep 2011 09:33:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Benjamin Poirier <benjamin.poirier@gmail.com>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Documentation/memory-barriers.txt
Message-ID: <20110912163307.GC2362@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110912141520.GA18647@synalogic.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110912141520.GA18647@synalogic.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11091216-6078-0000-0000-000000A2E4F1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 10:15:20AM -0400, Benjamin Poirier wrote:
> Hello David, Paul,
> 
> Thank you for this great piece on memory barriers. I think it made a
> complex topic approachable. I have two questions:
> 1)
> I had a hard time understanding the second part of the example in the
> section "Sleep and wake-up functions".
> 
> > 	set_current_state(TASK_INTERRUPTIBLE);
> > 	if (event_indicated)
> > 		break;
> > 	__set_current_state(TASK_RUNNING);
> > 	do_something(my_data);
> 
> I understand the need for memory barriers, but I don't understand what
> the code is trying to achieve.
> Where are the for (;;) loop and the schedule() call gone to?

This is a discussion of memory barriers, which handle communication
between multiple CPUs.  So, yes, in many cases the for-loop is required,
but the actual communication will occur on a particular iteration of
the for-loop.  But there are other use cases, for example, involving
prepare_to_wait()/schedule()/finish_wait(), that do not need an enclosing
loop.  See for example the use in bsg_io_schedule().

Nevertheless, all of the wait/wakeup examples need to enforce proper
memory ordering, and we therefore take the least common denominator
for the more detailed examples.

> > 	set_current_state(TASK_INTERRUPTIBLE);
> > 	if (event_indicated) {
> > 		smp_rmb();
> > 		do_something(my_data);
> > 	}
> 
> Isn't a break; missing here? How come do_something() has moved inside
> the condition?

Again, it depends on the enclosing use case.  Keep in mind that even
in cases involving a loop, there is only one pass through the loop that
actually does anything.

> I'm thinking these final example code bits should look like this
> (without and with the smp_rmb), no?:
> 
> for (;;) {
> 	set_current_state(TASK_INTERRUPTIBLE);
> 	if (event_indicated) {
> 		smp_rmb();
> 		do_something(my_data);
> 		break;
> 	}
> 	schedule();
> }
> __set_current_state(TASK_RUNNING);

This example would be correct for a looping case, but is more ornate than
required for illustrating the effects of memory barriers.  So we took the
simpler case without the loop.

> 2)
> On a more general note, why is there a read_barrier_depends() but not a
> write_barrier_depends()?

You use rcu_assign_pointer() for write_barrier_depends().  An alternative
extremely expensive definition of write_barrier_depends() is to force
a memory barrier on all CPUs.  This was debated quite some time ago and
was rejected.

However, you can get this effect by calling one of the synchronize_rcu()
or synchronize_rcu_expedited() family of functions.  Please be aware that
synchronize_rcu() will impose several milliseconds of latency but minimal
CPU overhead, while synchronize_rcu_expedited() will impose only a few
tens of microseconds of latency, but will IPI each and every CPU.  So
both of these are expensive in different ways.

Another way to get this effect is to use smp_call_function().  Like
synchronize_rcu_expedited(), this will IPI each and every CPU.

But before going down any of these paths other than rcu_assign_pointer(),
you really need to look very carefully at why you need smp_mb() on each
and every CPU.  Normally, this is a way bigger hammer than you need.

To reiterate, if you think you need write_barrier_depends(), please
carefully revisit your design.  The odds are that you really do not
need it.

> l=7
> "write_barrier_depends()"
> g=&l
> 
> ---
> 
> l=g
> read_barrier_depends()
> t=*l
> 
> Most processors do not reorder dependent loads but do reorder loads
> after loads. I'm guessing there's no processor that does not reorder
> dependent stores but that does reorder stores after stores. So there's
> no point in having write_barrier_depends(), it would always be defined
> to wmb()?

Yes, exactly -- rcu_assign_pointer() does use smp_wmb().

The only CPU that could make good generic use of write_barrier_depends()
is DEC Alpha.  What we do instead is make Alpha's read_barrier_depends()
use smp_rmb().

								Thanx, Paul


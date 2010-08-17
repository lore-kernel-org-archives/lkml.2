Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab0HQMdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 08:33:13 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:53394 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734Ab0HQMdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 08:33:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAD8cakxGGN19/2dsb2JhbACgPHK9KoU3BIRj
Date: Tue, 17 Aug 2010 08:33:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC] Introduce barrier2(a, b) (was: Re: [PATCH tip/core/rcu
	08/10] rcu: Add a TINY_PREEMPT_RCU)
Message-ID: <20100817123309.GA27280@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 07:47:30 up 131 days, 21:39,  4 users,  load average: 0.11, 0.40,
	0.33
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(re-threaded because this looks like a whole new topic here)

* Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> On 08/17/2010 06:24 AM, Paul E. McKenney wrote:
> > On Mon, Aug 16, 2010 at 06:07:05PM -0400, Mathieu Desnoyers wrote:
> >
> >> --(t->rcu_read_lock_nesting)
> >>
> >> could be split in two distinct operations:
> >>
> >> read t->rcu_read_lock_nesting
> >> decrement t->rcu_read_lock_nesting
> >>
> >> Note that in order to know the result required to pass the sequence
> >> point "&&" (the test), we only need to perform the read, not the
> >> decrement. AFAIU, gcc would be in its rights to move the
> >> t->rcu_read_lock_nesting update after the volatile access.
> > 
> > I will run this by some compiler experts.
> > 
> 
> We can just use "read and decrement statements" instead of "--" to
> avoid dependency from compilers.

Maybe it is time to introduce a more specific class of compiler barriers
so developers won't be tempted to use volatile accesses. I propose:

#define barrier2(a, b) __asm__ __volatile__("": "+rm"(a), "+rm"(b))

(Disclaimer: the barrier2() above should be run through compiler experts
to ensure that it does the same as a "memory" clobber applied
specifically to "a" and "b")

I assume you are proposing something like:

read t->rcu_read_lock_nesting
decrement t->rcu_read_lock_nesting
barrier();	/* some nice comment */
read "special" value
...

I agree that explicitly coding the barrier() forces us to document the
need for compiler ordering here. This would be a bit more verbose, and
IMHO good in this case. Volatile accesses "work", but does not do a very
good documentation job. We could argue, in favor of volatile, that they
only apply ordering to the volatile accesses, not all other accesses
around, which is a weaker constraint and therefore does not limit
compiler optimisations as much as barrier().

With something like barrier2(), we can do the following, which does the
best of both worlds: specific compiler ordering (without volatiles!!)
and good documentation. Moreover, it does not order with respect to
other volatile accesses we don't care about.

void __rcu_read_unlock(void)
{
	struct task_struct *t = current;
	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutiny.c */
	if (--t->rcu_read_lock_nesting == 0) {
		/*
		 * Update rcu_read_lock_nesting before reading
		 * rcu_read_unlock_special so we don't miss a
		 * preemption.
		 */
		barrier2(t->rcu_read_lock_nesting, t->rcu_read_unlock_special);
		if (unlikely(t->rcu_read_unlock_special))
			rcu_read_unlock_special(t);
	}
#ifdef CONFIG_PROVE_LOCKING
	WARN_ON_ONCE(t->rcu_read_lock_nesting < 0);
#endif /* #ifdef CONFIG_PROVE_LOCKING */
}

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

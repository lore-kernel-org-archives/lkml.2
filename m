Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab0HQOQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 10:16:46 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:57577 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755463Ab0HQOQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 10:16:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFYxakxGGN19/2dsb2JhbACgPHK/YoU3BIRj
Date: Tue, 17 Aug 2010 10:16:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH tip/core/rcu 08/10] rcu: Add a TINY_PREEMPT_RCU
Message-ID: <20100817141638.GA5722@Krystal>
References: <20100809221447.GA24358@linux.vnet.ibm.com> <1281392111-25060-8-git-send-email-paulmck@linux.vnet.ibm.com> <20100816150737.GB8320@Krystal> <20100816183355.GH2388@linux.vnet.ibm.com> <20100816191947.GA970@Krystal> <20100816213200.GK2388@linux.vnet.ibm.com> <20100816214123.GA15663@Krystal> <20100816215555.GL2388@linux.vnet.ibm.com> <20100816220705.GA18650@Krystal> <1282051639.3268.1335.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1282051639.3268.1335.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:41:11 up 131 days, 23:32,  4 users,  load average: 0.39, 0.17,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Mon, 2010-08-16 at 18:07 -0400, Mathieu Desnoyers wrote:
> 
> > > Moving this down past the check of t->rcu_read_lock_special (which is
> > > now covered by ACCESS_ONCE()) would violate the C standard, as it would
> > > be equivalent to moving a volatile up past a sequence point.
> > 
> > Hrm, I'm not quite convinced yet. I am not concerned about gcc moving
> > the volatile access prior to the sequence point (as you say, this is
> > forbidden by the C standard), but rather that:
> > 
> > --(t->rcu_read_lock_nesting)
> > 
> > could be split in two distinct operations:
> > 
> > read t->rcu_read_lock_nesting
> > decrement t->rcu_read_lock_nesting
> > 
> > Note that in order to know the result required to pass the sequence
> > point "&&" (the test), we only need to perform the read, not the
> > decrement. AFAIU, gcc would be in its rights to move the
> > t->rcu_read_lock_nesting update after the volatile access.
> > 
> 
> If we are this concerned, what about just doing:
> 
> 	--t->rcu_read_lock_nesting;
>         if (ACCESS_ONCE(t->rcu_read_lock_nesting) == 0 &&
>              unlikely((ACCESS_ONCE(t->rcu_read_unlock_special)))

I'd be concerned by the fact that there is no strong ordering guarantee
that the non-volatile --t->rcu_read_lock_nesting is done before
ACCESS_ONCE(t->rcu_read_unlock_special).

My concern is that the compiler might be allowed to turn your code into:

        if (ACCESS_ONCE(t->rcu_read_lock_nesting) == 1 &&
             unlikely((ACCESS_ONCE(t->rcu_read_unlock_special))) {
 		--t->rcu_read_lock_nesting;
		do_something();
	} else
	 	--t->rcu_read_lock_nesting;

So whether or not this could be done by the compiler depending on the
various definitions of volatile, I strongly recommend against using
volatile accesses to provide compiler ordering guarantees. It is bad in
terms of code documentation (we don't document _what_ is ordered) and it
is also bad because the volatile ordering guarantees seems to be
very easy to misinterpret.

ACCESS_ONCE() should be only that: a macro that tells the access should
be performed only once. Why are we suddenly presuming it should have any
ordering semantic ?

It should be totally valid to create arch-specific ACCESS_ONCE() macros
that only perform the "read once", without the ordering guarantees
provided by the current ACCESS_ONCE() "volatile" implementation. The
following code is only for unsigned long, but you get the idea: there is
no volatile at all, and I ensure that "val" is only read once by using
the "+m" (val) constraint, telling the compiler (falsely) that the
assembler is modifying the value (it therefore has a side-effect), so
gcc won't be tempted to re-issue the assembly statement.

static inline unsigned long arch_access_once(unsigned long val)
{
	unsigned long ret;

#if (__BITS_PER_LONG == 32)
	asm ("movl %1,%0": "=r" (ret), "+m" (val));
#else
	asm ("movq %1,%0": "=r" (ret), "+m" (val));
#endif
}

Thanks,

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

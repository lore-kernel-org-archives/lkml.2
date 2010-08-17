Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab0HQQAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:00:38 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:36913 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961Ab0HQQAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:00:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFZPakxGGN19/2dsb2JhbACgPXLBD4U3BIRj
Date: Tue, 17 Aug 2010 11:55:21 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH tip/core/rcu 08/10] rcu: Add a TINY_PREEMPT_RCU
Message-ID: <20100817155521.GA17849@Krystal>
References: <20100816150737.GB8320@Krystal> <20100816183355.GH2388@linux.vnet.ibm.com> <20100816191947.GA970@Krystal> <20100816213200.GK2388@linux.vnet.ibm.com> <20100816214123.GA15663@Krystal> <20100816215555.GL2388@linux.vnet.ibm.com> <20100816220705.GA18650@Krystal> <1282051639.3268.1335.camel@gandalf.stny.rr.com> <20100817141638.GA5722@Krystal> <1282056878.3268.1437.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1282056878.3268.1437.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:36:11 up 132 days,  1:27,  4 users,  load average: 0.00, 0.03,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, 2010-08-17 at 10:16 -0400, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> > > If we are this concerned, what about just doing:
> > > 
> > > 	--t->rcu_read_lock_nesting;
> > >         if (ACCESS_ONCE(t->rcu_read_lock_nesting) == 0 &&
> > >              unlikely((ACCESS_ONCE(t->rcu_read_unlock_special)))
> > 
> > I'd be concerned by the fact that there is no strong ordering guarantee
> > that the non-volatile --t->rcu_read_lock_nesting is done before
> > ACCESS_ONCE(t->rcu_read_unlock_special).
> > 
> > My concern is that the compiler might be allowed to turn your code into:
> > 
> >         if (ACCESS_ONCE(t->rcu_read_lock_nesting) == 1 &&
> >              unlikely((ACCESS_ONCE(t->rcu_read_unlock_special))) {
> >  		--t->rcu_read_lock_nesting;
> > 		do_something();
> > 	} else
> > 	 	--t->rcu_read_lock_nesting;
> 
> 
> That just seems to break all sorts of rules.

Is there a rule stating that a non-volatile access is ensured to be in
issued in program order wrt other accesses to that same variable ?

The stardard discourages compilers to do any kind of optimization when
volatile is detected on a variable
(http://gcc.gnu.org/onlinedocs/gcc/Volatiles.html), but that's a very
weak guarantee I would not like to rely on.

The only strong guarantee it provides is:
"The minimum either standard specifies is that at a sequence point all
previous accesses to volatile objects have stabilized and no subsequent
accesses have occurred."

So the question here is: given that the "--t->rcu_read_lock_nesting"
access is not marked volatile, but the following
"ACCESS_ONCE(t->rcu_read_lock_nesting)" read is volatile, should we
consider than "--t->rcu_read_lock_nesting" apply to a volatile object or
not ?

This is the kind of grey zone I dislike.

> 
> > 
> > So whether or not this could be done by the compiler depending on the
> > various definitions of volatile, I strongly recommend against using
> > volatile accesses to provide compiler ordering guarantees. It is bad in
> > terms of code documentation (we don't document _what_ is ordered) and it
> > is also bad because the volatile ordering guarantees seems to be
> > very easy to misinterpret.
> 
> Yes, volatile does not guarantee ordering of other accesses, but it
> should at least guarantee ordering of access to the thing that is
> volatile.
> 
> 	b++;
> 	a++;
> 	c = ACCESS_ONCE(a);
> 
> 'b++' can be moved to anywhere. But I'm pretty sure the compiler is not
> allowed to move the 'a++' after the ACCESS_ONCE(a) because it is the
> thing that is volatile.

AFAIU, the standard only requires ordering between volatile "objects".
So when we cast non-volatile objects to volatile, I assume the
non-volatile accesses apply only to the non-volatile version of the
object. So volatile ordering guarantees would not apply to "a".

> We are telling the compiler that 'a' can change
> outside our scope, which to me is the same as doing:
> 
> 	a++;
> 	c = some_global_function(&a);
> 
> Where, the compiler does not know the result of 'a' and can not move the
> 'a++'.

The code here is different: calling an external function is equivalent
to put a full compiler memory barrier ("memory" clobber). Volatile is
quite different from that; the compiler is only told to keep ordering
between volatile accesses, and to try not to optimize the volatile
access per se.

> 
> 
> Maybe I'm wrong, and need to verify this with a compiler expert. But
> what's the use of volatile if it can't protect the ordering of what is
> volatile from itself.

I'm concerned about the fact that volatile seems to have been initially
designed to apply to a variable declaration (object) rather than a
specific access through a cast. So I really wonder if the non-volatile
object accesses has the same guarantees as the accesses performed on its
volatile cast version.

> 
> > 
> > ACCESS_ONCE() should be only that: a macro that tells the access should
> > be performed only once. Why are we suddenly presuming it should have any
> > ordering semantic ?
> 
> Only ordering with the variable that is volatile. It has no ordering to
> any other variable.

This is not quite correct. Volatile orders with respect to _all_ other
volatile accesses.

What I am pointing out here is that the macro name "ACCESS_ONCE()" does
not convey any ordering semantic, and should not.

> 
> > 
> > It should be totally valid to create arch-specific ACCESS_ONCE() macros
> > that only perform the "read once", without the ordering guarantees
> > provided by the current ACCESS_ONCE() "volatile" implementation. The
> > following code is only for unsigned long, but you get the idea: there is
> > no volatile at all, and I ensure that "val" is only read once by using
> > the "+m" (val) constraint, telling the compiler (falsely) that the
> > assembler is modifying the value (it therefore has a side-effect), so
> > gcc won't be tempted to re-issue the assembly statement.
> > 
> > static inline unsigned long arch_access_once(unsigned long val)
> > {
> > 	unsigned long ret;
> > 
> > #if (__BITS_PER_LONG == 32)
> > 	asm ("movl %1,%0": "=r" (ret), "+m" (val));
> > #else
> > 	asm ("movq %1,%0": "=r" (ret), "+m" (val));
> > #endif
> > }
> 
> Heck, this is too much micro optimization. We could just be safe and do
> the:
>  	--t->rcu_read_lock_nesting;
> 	barrier();
>          if (ACCESS_ONCE(t->rcu_read_lock_nesting) == 0 &&
>               unlikely((ACCESS_ONCE(t->rcu_read_unlock_special)))
>  
> And be done with it.

Then we could go for the simpler:

  	--t->rcu_read_lock_nesting;
 	barrier();
        if (t->rcu_read_lock_nesting == 0 &&
             unlikely((t->rcu_read_unlock_special))

Which puts a constraint across all memory accesses. I'd be fine with
that if you are afraid of too much micro-optimization (e.g. my
barrier2(a, b) proposal).

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

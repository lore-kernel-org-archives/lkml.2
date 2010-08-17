Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab0HQOyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 10:54:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60913 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab0HQOyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 10:54:40 -0400
X-Authority-Analysis: v=1.1 cv=FLDyhxrUEZZDQYGWQdnXfbzWjjll+fIPMqQTcKt1R7E= c=1 sm=0 a=ApKsrK4jzPIA:10 a=Q9fys5e9bTEA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=meVymXHHAAAA:8 a=I4TMfN7F3NOZZWHdNI4A:9 a=lTRcRUVkHRl9kGo02jUA:7 a=SsUn-8oYKeVB7J_Wi4uVSwooL7AA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Subject: Re: [PATCH tip/core/rcu 08/10] rcu: Add a TINY_PREEMPT_RCU
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20100817141638.GA5722@Krystal>
References: <20100809221447.GA24358@linux.vnet.ibm.com>
	 <1281392111-25060-8-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20100816150737.GB8320@Krystal> <20100816183355.GH2388@linux.vnet.ibm.com>
	 <20100816191947.GA970@Krystal> <20100816213200.GK2388@linux.vnet.ibm.com>
	 <20100816214123.GA15663@Krystal> <20100816215555.GL2388@linux.vnet.ibm.com>
	 <20100816220705.GA18650@Krystal>
	 <1282051639.3268.1335.camel@gandalf.stny.rr.com>
	 <20100817141638.GA5722@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 17 Aug 2010 10:54:38 -0400
Message-ID: <1282056878.3268.1437.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 10:16 -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:

> > If we are this concerned, what about just doing:
> > 
> > 	--t->rcu_read_lock_nesting;
> >         if (ACCESS_ONCE(t->rcu_read_lock_nesting) == 0 &&
> >              unlikely((ACCESS_ONCE(t->rcu_read_unlock_special)))
> 
> I'd be concerned by the fact that there is no strong ordering guarantee
> that the non-volatile --t->rcu_read_lock_nesting is done before
> ACCESS_ONCE(t->rcu_read_unlock_special).
> 
> My concern is that the compiler might be allowed to turn your code into:
> 
>         if (ACCESS_ONCE(t->rcu_read_lock_nesting) == 1 &&
>              unlikely((ACCESS_ONCE(t->rcu_read_unlock_special))) {
>  		--t->rcu_read_lock_nesting;
> 		do_something();
> 	} else
> 	 	--t->rcu_read_lock_nesting;


That just seems to break all sorts of rules.

> 
> So whether or not this could be done by the compiler depending on the
> various definitions of volatile, I strongly recommend against using
> volatile accesses to provide compiler ordering guarantees. It is bad in
> terms of code documentation (we don't document _what_ is ordered) and it
> is also bad because the volatile ordering guarantees seems to be
> very easy to misinterpret.

Yes, volatile does not guarantee ordering of other accesses, but it
should at least guarantee ordering of access to the thing that is
volatile.

	b++;
	a++;
	c = ACCESS_ONCE(a);

'b++' can be moved to anywhere. But I'm pretty sure the compiler is not
allowed to move the 'a++' after the ACCESS_ONCE(a) because it is the
thing that is volatile. We are telling the compiler that 'a' can change
outside our scope, which to me is the same as doing:

	a++;
	c = some_global_function(&a);

Where, the compiler does not know the result of 'a' and can not move the
'a++'.


Maybe I'm wrong, and need to verify this with a compiler expert. But
what's the use of volatile if it can't protect the ordering of what is
volatile from itself.

> 
> ACCESS_ONCE() should be only that: a macro that tells the access should
> be performed only once. Why are we suddenly presuming it should have any
> ordering semantic ?

Only ordering with the variable that is volatile. It has no ordering to
any other variable.

> 
> It should be totally valid to create arch-specific ACCESS_ONCE() macros
> that only perform the "read once", without the ordering guarantees
> provided by the current ACCESS_ONCE() "volatile" implementation. The
> following code is only for unsigned long, but you get the idea: there is
> no volatile at all, and I ensure that "val" is only read once by using
> the "+m" (val) constraint, telling the compiler (falsely) that the
> assembler is modifying the value (it therefore has a side-effect), so
> gcc won't be tempted to re-issue the assembly statement.
> 
> static inline unsigned long arch_access_once(unsigned long val)
> {
> 	unsigned long ret;
> 
> #if (__BITS_PER_LONG == 32)
> 	asm ("movl %1,%0": "=r" (ret), "+m" (val));
> #else
> 	asm ("movq %1,%0": "=r" (ret), "+m" (val));
> #endif
> }

Heck, this is too much micro optimization. We could just be safe and do
the:
 	--t->rcu_read_lock_nesting;
	barrier();
         if (ACCESS_ONCE(t->rcu_read_lock_nesting) == 0 &&
              unlikely((ACCESS_ONCE(t->rcu_read_unlock_special)))
 
And be done with it.

-- Steve



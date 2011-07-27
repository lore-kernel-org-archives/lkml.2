Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab1G0QUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:20:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48441 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab1G0QUp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:20:45 -0400
Subject: Re: per-cpu operation madness vs validation
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, eric.dumazet@gmail.com
In-Reply-To: <alpine.DEB.2.00.1107270904290.9418@router.home>
References: <1311714410.24752.404.camel@twins>
	 <alpine.DEB.2.00.1107261624210.10273@router.home>
	 <1311768693.24752.488.camel@twins>
	 <alpine.DEB.2.00.1107270904290.9418@router.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 27 Jul 2011 18:20:16 +0200
Message-ID: <1311783616.5890.178.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-27 at 09:16 -0500, Christoph Lameter wrote:

> Well yes these are multiple operations that have a sort of atomicity
> requirement together. You want both variables to be updated together and
> therefore the individual RMV operations wont do the trick. The algorithm
> would have to be changed to take advantage of the this_cpu ops or you will
> have to take the penalty of higher synchronization costs.

You're still not getting it, synchronization cost isn't the point.

> > Now clearly my example is very artificial but not far fetched at all,
> 
> Sure but these issues require a different way of structuring the
> algorithm. That is why I have introduced longer cmpxchg operations.

They require nothing of the sort.

> What you can do is what the slub fastpath does in order to allow updates
> without caring about preemption or interrupts.

> 1. You get a reference to the current per cpu data.
> 2. You obtain a transaction id that is cpu specific and operation specifc.
> 3. Speculatively access an object and work with the information of that
> object. Do not change anything.

Pretty hard when the whole point if changing stuff.

> 4. Calculate the next transaction id
> 4. Replace pointer and transaction id with a new object pointer and new
> tranaction id. If there is no match restart at 1.

Which is utter crap, ease up on the the drugs. That mandates a
read-copy-update like approach to all per-cpu data.

> Otherwise you are done. Any interrupt or preemption section that also does
> operation on the critical data also would increment the transaction id and
> cause a retry of the section.
> 
> So now you have a per cpu access that is fully immunte from interrupt and
> preemption issues.

And suffers from allocation issues.. allocating a new piece of data,
copying over the old one, modifying it, installing the new pointer,
managing references to the old pointer etc.. You're on crack, that's
often way too much trouble for nearly no gain.

> > Hence my suggestion to do something like:
> >
> > struct foo {
> > 	percpu_lock_t lock;
> > 	int a;
> > 	int b;
> > }
> >
> > DEFINE_PER_CPU(struct foo, foo);
> >
> > percpu_lock(&foo.lock);
> > __this_cpu_inc(foo.a);
> > __this_cpu_inc(foo.b);
> > percpu_unlock(&foo.lock);
> 
> This is too expensive for my taste.

It doesn't cost a cycle nor byte extra over what mainline does now, how
is it too expensive? Its just a clearer way of writing the code since it
cleanly couples locks to data instead of using blanket preempt/bh/irq
disable stmts and assuming things -- and yes preempt/bh/irq are locks.

> percpu sections are very performance critical components of the kernel.
> Taking locks could be avoided with serialization through transaction ids
> f.e.

Not the fucking point! This isn't about making things go faster, this is
about breaking up the horrid implicit preempt/bh/irq assumptions all
over the place. It really is no different from killing the BKL.

You'll need this even if you're going to rewrite the kernel with your
cmpxchg_double wankery simply because you need to know how stuff is
supposed to work.

All this is simply about de-obfuscating all per-cpu assumptions. This is
about verification and traceability/debuggability.



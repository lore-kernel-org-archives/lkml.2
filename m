Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab1G0MMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 08:12:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36815 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab1G0ML7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 08:11:59 -0400
Subject: Re: per-cpu operation madness vs validation
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.DEB.2.00.1107261624210.10273@router.home>
References: <1311714410.24752.404.camel@twins>
	 <alpine.DEB.2.00.1107261624210.10273@router.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 27 Jul 2011 14:11:33 +0200
Message-ID: <1311768693.24752.488.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 16:32 -0500, Christoph Lameter wrote:

> Those all fold to the same operation on x86. The x86 cpu operations with
> segment prefix are interrupt and preempt safe. The context issues come
> into play in fallback scenarios where other architectures do not have
> instructions that can perform the same things as x86.

Right, but that doesn't help us much if anything.

> > Now the reason is of course that -rt changes some things, even when
> > using migrate_disable() it might be multiple processes might try and
> > access the per-cpu variable, needing serialization.
> 
> On x86 these operations are rt safe by the pure fact that all these
> operations are the same interrupt safe instruction.

The number of instructions has nothing what so ever to do with things.
And while the individual ops might be preempt/irq/nmi safe, that doesn't
say anything at all about the piece of code they're used in.

>  The difficulties come in for other
> architectures. In those cases preemption or interrupts need to be
> disabled.

Irrelevant.

> > The point of course is, how are we going to go about doing this, I'm
> > sure adding a proper conditional to each and every per-cpu op is going
> > to be a herculean task, and most of it utterly boring.
> 
> Basically we need to track the contexts in which references to a certain
> per cpu variable are established. Then constraints can be enforced. For
> example:
> 
> 1. A variable used in an interupt context with __this_cpu ops requires
> irqsafe_cpu_xxx when used in context where interrupts are enabled.
> 
> 2. A variable used in a non-preemptible context with __this_cpu ops
> requires this_cpu ops in a preemptible context.

And doesn't solve the larger issue of multiple per-cpu variables forming
a consistent piece of data.

Suppose there's two per-cpu variables, a and b, and we have an invariant
that says that a-b := 5. Then the following code:

preempt_disable();
__this_cpu_inc(a);
__this_cpu_inc(b);
preempt_enable();

is only correct when used from task context, an IRQ user can easily
observe our invariant failing and none of your above validations will
catch this.

Now move to -rt where the above will likely end up looking something
like:

migrate_disable();
__this_cpu_inc(a);
__this_cpu_inc(b);
migrate_enable();

and everybody can see the invariant failing.

Now clearly my example is very artificial but not far fetched at all,
there's lots of code like this, and -rt gets to try and unravel all
this. Basically preempt_disable()/local_bh_disable()/local_irq_disable()
are the next BKL, there is no context what so ever to reconstruct what
invariants certain pieces of code expect.

Hence my suggestion to do something like:

struct foo {
	percpu_lock_t lock;
	int a;
	int b;
}

DEFINE_PER_CPU(struct foo, foo);

percpu_lock(&foo.lock);
__this_cpu_inc(foo.a);
__this_cpu_inc(foo.b);
percpu_unlock(&foo.lock);

That would get us (aside from a shitload of work to make it so):

 - clear boundaries of where the data structure atomicy lie
 - validation, for if the above piece of code was also ran from IRQ
   context we could get lockdep complaining about IRQ unsafe locks used
   from IRQ context.

Now for !-rt percpu_lock will not emit more than
preempt_disable/local_bh_disable/local_irq_disable, depending on what
variant is used, and the data type percpu_lock_t would be empty (except
when enabling lockdep of course).

Possibly we could reduce all this percpu madness back to one form
(__this_cpu_*) and require that when used a lock of the percpu_lock_t is
taken.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab2KIPqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:46:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab2KIPqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:46:32 -0500
Date: Fri, 9 Nov 2012 16:46:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 1/1] percpu_rw_semaphore: reimplement to not
	block the readers unnecessarily
Message-ID: <20121109154656.GA26134@redhat.com>
References: <20121019192838.GM2518@linux.vnet.ibm.com> <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com> <20121030184800.GA16129@redhat.com> <20121031194135.GA504@redhat.com> <20121031194158.GB504@redhat.com> <CA+55aFx0yyke6V1+wgMPBN4QZ0w=YoV7yBRqp0uy6aGKbcmC5g@mail.gmail.com> <20121102180606.GA13255@redhat.com> <20121108134805.GA23870@redhat.com> <20121108134849.GB23870@redhat.com> <20121108120700.42d438f2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121108120700.42d438f2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08, Andrew Morton wrote:
>
> On Thu, 8 Nov 2012 14:48:49 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> >
> >  include/linux/percpu-rwsem.h |   83 +++++------------------------
> >  lib/Makefile                 |    2 +-
> >  lib/percpu-rwsem.c           |  123 ++++++++++++++++++++++++++++++++++++++++++
>
> The patch also uninlines everything.
>
> And it didn't export the resulting symbols to modules, so it isn't an
> equivalent.  We can export thing later if needed I guess.

Yes, currently it is only used by block_dev.c

> It adds percpu-rwsem.o to lib-y, so the CONFIG_BLOCK=n kernel will
> avoid including the code altogether, methinks?

I am going to add another user (uprobes), this was my motivation for
this patch. And perhaps it will have more users.

But I agree, CONFIG_PERCPU_RWSEM makes sense at least now, I'll send
the patch.

> > +#include <linux/percpu-rwsem.h>
> > +#include <linux/rcupdate.h>
> > +#include <linux/sched.h>
>
> This list is nowhere near sufficient to support this file's
> requirements.  atomic.h, percpu.h, rwsem.h, wait.h, errno.h and plenty
> more.  IOW, if it compiles, it was sheer luck.

OK, thanks, I'll send
send percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessarily.fix

> > +/*
> > + * A writer takes ->writer_mutex to exclude other writers and to force the
> > + * readers to switch to the slow mode, note the mutex_is_locked() check in
> > + * update_fast_ctr().
> > + *
> > + * After that the readers can only inc/dec the slow ->slow_read_ctr counter,
> > + * ->fast_read_ctr is stable. Once the writer moves its sum into the slow
> > + * counter it represents the number of active readers.
> > + *
> > + * Finally the writer takes ->rw_sem for writing and blocks the new readers,
> > + * then waits until the slow counter becomes zero.
> > + */
>
> Some overview of how fast/slow_read_ctr are supposed to work would be
> useful.  This comment seems to assume that the reader already knew
> that.

I hate to say this, but I'll try to update this comment too ;)

> > +void percpu_down_write(struct percpu_rw_semaphore *brw)
> > +{
> > +	/* also blocks update_fast_ctr() which checks mutex_is_locked() */
> > +	mutex_lock(&brw->writer_mutex);
> > +
> > +	/*
> > +	 * 1. Ensures mutex_is_locked() is visible to any down_read/up_read
> > +	 *    so that update_fast_ctr() can't succeed.
> > +	 *
> > +	 * 2. Ensures we see the result of every previous this_cpu_add() in
> > +	 *    update_fast_ctr().
> > +	 *
> > +	 * 3. Ensures that if any reader has exited its critical section via
> > +	 *    fast-path, it executes a full memory barrier before we return.
> > +	 */
> > +	synchronize_sched();
>
> Here's where I get horridly confused.  Your patch completely deRCUifies
> this code, yes?  Yet here we're using an RCU primitive.  And we seem to
> be using it not as an RCU primitive but as a handy thing which happens
> to have desirable side-effects.  But the implementation of
> synchronize_sched() differs considerably according to which rcu
> flavor-of-the-minute you're using.

It is documented that synchronize_sched() should play well with
preempt_disable/enable. From the comment:

	Note that preempt_disable(),
	local_irq_disable(), and so on may be used in place of
	rcu_read_lock_sched().

But I guess this needs more discussion, I see other emails in this
thread...

> And part 3 talks about the reader's critical section.  The only
> critical sections I can see on the reader side are already covered by
> mutex_lock() and preempt_diable().

Yes, but we need to ensure that if we take the lock for writing, we
should see all memory modifications done under down_read/up_read().

IOW. Suppose that the reader does

	percpu_down_read();
	STORE;
	percpu_up_read();	// no barriers in the fast path

The writer should see the result of that STORE under percpu_down_write().

Part 3 tries to say that at this point we should already see the result,
so we should not worry about acquire/release semantics.

> If this code isn't as brain damaged as it
> initially appears then please,

I hope ;)

> go easy on us simpletons in the next
> version?

Well, I'll try to update the comments... but the code is simple, I do
not think I can simplify it more. The nontrivial part is the barriers,
but this is always nontrivial.

Contrary, I am going to try to add some complications later, so that
it can have more users. In particular, I think it can replace
get_online_cpus/cpu_hotplug_begin, just we need
percpu_down_write_but_dont_deadlock_with_recursive_readers().

Oleg.


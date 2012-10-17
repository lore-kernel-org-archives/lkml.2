Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab2JQQgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 12:36:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756420Ab2JQQgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 12:36:19 -0400
Date: Wed, 17 Oct 2012 18:37:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] brw_mutex: big read-write mutex
Message-ID: <20121017163702.GA9872@redhat.com>
References: <20121015190958.GA4799@redhat.com> <20121015191018.GA4816@redhat.com> <20121015232814.GC3010@linux.vnet.ibm.com> <20121016155623.GA4028@redhat.com> <20121016185852.GH2385@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121016185852.GH2385@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16, Paul E. McKenney wrote:
>
> On Tue, Oct 16, 2012 at 05:56:23PM +0200, Oleg Nesterov wrote:
> > >
> > > I believe that you need smp_mb() here.
> >
> > I don't understand why...
> >
> > > The wake_up_all()'s memory barriers
> > > do not suffice because some other reader might have awakened the writer
> > > between this_cpu_dec() and wake_up_all().
> >
> > But __wake_up(q) takes q->lock? And the same lock is taken by
> > prepare_to_wait(), so how can the writer miss the result of _dec?
>
> Suppose that the writer arrives and sees that the value of the counter
> is zero,

after synchronize_sched(). So there are no readers (but perhaps there
are brw_end_read's in flight which already decremented read_ctr)

> and thus never sleeps, and so is also not awakened?

and why do we need wakeup in this case?

> > > void brw_end_read(struct brw_mutex *brw)
> > > {
> > > 	if (unlikely(atomic_read(&brw->write_ctr))) {
> > > 		smp_mb();
> > > 		this_cpu_dec(*brw->read_ctr);
> > > 		wake_up_all(&brw->write_waitq);
> >
> > Hmm... still can't understand.
> >
> > It seems that this mb() is needed to ensure that brw_end_read() can't
> > miss write_ctr != 0.
> >
> > But we do not care unless the writer already does wait_event(). And
> > before it does wait_event() it calls synchronize_sched() after it sets
> > write_ctr != 0. Doesn't this mean that after that any preempt-disabled
> > section must see write_ctr != 0 ?
> >
> > This code actually checks write_ctr after preempt_disable + enable,
> > but I think this doesn't matter?
> >
> > Paul, most probably I misunderstood you. Could you spell please?
>
> Let me try outlining the sequence of events that I am worried about...
>
> 1.	Task A invokes brw_start_read().  There is no writer, so it
> 	takes the fastpath.
>
> 2.	Task B invokes brw_start_write(), atomically increments
> 	&brw->write_ctr, and executes synchronize_sched().
>
> 3.	Task A invokes brw_end_read() and does this_cpu_dec().

OK. And to simplify this discussion, suppose that A invoked
brw_start_read() on CPU_0 and thus incremented read_ctr[0], and
then it migrates to CPU_1 and brw_end_read() uses read_ctr[1].

My understanding was, brw_start_write() must see read_ctr[0] == 1
after synchronize_sched().

> 4.	Task B invokes wait_event(), which invokes brw_read_ctr()
> 	and sees the result as zero.

So my understanding is completely wrong? I thought that after
synchronize_sched() we should see the result of any operation
which were done inside the preempt-disable section.

No?

Hmm. Suppose that we have long A = B = STOP = 0, and

	void func(void)
	{
		preempt_disable();
		if (!STOP) {
			A = 1;
			B = 1;
		}
		preempt_enable();
	}

Now, you are saying that this code

	STOP = 1;

	synchronize_sched();

	BUG_ON(A != B);

is not correct? (yes, yes, this example is not very good).

The comment above synchronize_sched() says:

	return ... after all currently executing
	rcu-sched read-side critical sections have completed.

But if this code is wrong, then what "completed" actually means?
I thought that it also means "all memory operations have completed",
but this is not true?

Oleg.


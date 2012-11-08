Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab2KHNcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:32:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193Ab2KHNcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:32:54 -0500
Date: Thu, 8 Nov 2012 14:33:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] percpu_rw_semaphore: reimplement to not block
	the readers unnecessarily
Message-ID: <20121108133327.GA23425@redhat.com>
References: <20121018175747.GA30691@redhat.com> <20121019192838.GM2518@linux.vnet.ibm.com> <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com> <20121030184800.GA16129@redhat.com> <20121031194135.GA504@redhat.com> <20121031194158.GB504@redhat.com> <CA+55aFx0yyke6V1+wgMPBN4QZ0w=YoV7yBRqp0uy6aGKbcmC5g@mail.gmail.com> <20121102180606.GA13255@redhat.com> <20121102180629.GB13255@redhat.com> <20121108011654.GJ2541@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121108011654.GJ2541@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07, Paul E. McKenney wrote:
>
> On Fri, Nov 02, 2012 at 07:06:29PM +0100, Oleg Nesterov wrote:
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
> > +
> > +	/* nobody can use fast_read_ctr, move its sum into slow_read_ctr */
> > +	atomic_add(clear_fast_ctr(brw), &brw->slow_read_ctr);
> > +
> > +	/* block the new readers completely */
> > +	down_write(&brw->rw_sem);
> > +
> > +	/* wait for all readers to complete their percpu_up_read() */
> > +	wait_event(brw->write_waitq, !atomic_read(&brw->slow_read_ctr));
> > +}
> > +
> > +void percpu_up_write(struct percpu_rw_semaphore *brw)
> > +{
> > +	/* allow the new readers, but only the slow-path */
> > +	up_write(&brw->rw_sem);
> > +
> > +	/* insert the barrier before the next fast-path in down_read */
> > +	synchronize_sched();
>
> Ah, my added comments describing the memory-order properties of
> synchronize_sched() were incomplete.  As you say in the comment above,
> a valid RCU implementation must ensure that each CPU executes a memory
> barrier between the time that synchronize_sched() starts executing and
> the time that this same CPU starts its first RCU read-side critical
> section that ends after synchronize_sched() finishes executing.  (This
> is symmetric with the requirement discussed earlier.)

I think, yes. Let me repeat my example (changed a little bit). Suppose
that we have

	int A = 0, B = 0, STOP = 0;

	// can be called at any time, and many times
	void func(void)
	{
		rcu_read_lock_sched();
		if (!STOP) {
			A++;
			B++;
		}
		rcu_read_unlock_sched();
	}

Then I believe the following code should be correct:

	STOP = 1;

	synchronize_sched();

	BUG_ON(A != B);

We should see the result of the previous increments, and func() should
see STOP != 0 if it races with BUG_ON().

> And if a reader sees brw->writer_mutex as unlocked, then that reader's
> RCU read-side critical section must end after the above synchronize_sched()
> completes, which in turn means that there must have been a memory barrier
> on that reader's CPU after the synchronize_sched() started, so that the
> reader correctly sees the writer's updates.

Yes.

> But please let me know what you
> think of the added memory-order constraint.

I am going to (try to) do other changes on top of this patch, and I'll
certainly try to think more about this, thanks.

> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Great! thanks a lot Paul.

Oleg.


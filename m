Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934234Ab2J3SwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:52:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965461Ab2J3SrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:47:17 -0400
Date: Tue, 30 Oct 2012 19:48:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] fix and improvements for percpu-rw-semaphores
	(was: brw_mutex: big read-write mutex)
Message-ID: <20121030184800.GA16129@redhat.com>
References: <20121015190958.GA4799@redhat.com> <20121015191018.GA4816@redhat.com> <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com> <20121017165902.GB9872@redhat.com> <20121017224430.GC2518@linux.vnet.ibm.com> <20121018162409.GA28504@redhat.com> <20121018163833.GK2518@linux.vnet.ibm.com> <20121018175747.GA30691@redhat.com> <20121019192838.GM2518@linux.vnet.ibm.com> <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22, Mikulas Patocka wrote:
>
> > > Ooooh. And I just noticed include/linux/percpu-rwsem.h which does
> > > something similar. Certainly it was not in my tree when I started
> > > this patch... percpu_down_write() doesn't allow multiple writers,
> > > but the main problem it uses msleep(1). It should not, I think.

But, since we already have percpu_rw_semaphore, I do not think I can
add another similar thing,

However percpu_rw_semaphore is sub-optimal, not sure uprobes can use
it to block dup_mmap(). Perhaps we can improve it?

> > > But. It seems that percpu_up_write() is equally wrong? Doesn't
> > > it need synchronize_rcu() before "p->locked = false" ?
> > >
> > > (add Mikulas)
> >
> > Mikulas said something about doing an updated patch, so I figured I
> > would look at his next version.
> >
> > 							Thanx, Paul
>
> The best ideas proposed in this thread are:
>
>
> Using heavy/light barries by Lai Jiangshan.

So. down_write/up_right does msleep() and it needs to call
synchronize_sched() 3 times.

This looks too much. It is not that I am worried about the writers,
the problem is that the new readers are blocked completely while the
writer sleeps in msleep/synchronize_sched.

Paul, Mikulas, et al. Could you please look at the new implementation
below? Completely untested/uncompiled, just for discussion.

Compared to the current implementation, down_read() is still possible
while the writer sleeps in synchronize_sched(), but the reader uses
rw_semaphore/atomic_inc when it detects the waiting writer.

Can this work? Do you think this is better than we have now?


Note: probably we can optimize percpu_down/up_write more, we can
"factor out" synchronize_sched(), multiple writers can do this in
parallel before they take ->writer_mutex to exclude each other.
But this won't affect the readers, and this can be done later.

Oleg.

------------------------------------------------------------------------------
struct percpu_rw_semaphore {
	long __percpu		*fast_read_ctr;
	struct mutex            writer_mutex;
	struct rw_semaphore 	rw_sem;
	atomit_t		slow_read_ctr;
};

static bool update_fast_ctr(struct percpu_rw_semaphore *brw, long val)
{
	bool success = false;

	preempt_disable();
	if (likely(!mutex_is_locked(&brw->writer_mutex))) {
		__this_cpu_add(*brw->fast_read_ctr, val);
		success = true;
	}
	preempt_enable();

	return success;
}

static long clear_fast_read_ctr(struct percpu_rw_semaphore *brw)
{
	long sum = 0;
	int cpu;

	for_each_possible_cpu(cpu) {
		sum += per_cpu(*brw->fast_read_ctr, cpu);
		per_cpu(*brw->fast_read_ctr, cpu) = 0;
	}

	return sum;
}

void percpu_down_read(struct percpu_rw_semaphore *brw)
{
	if (likely(update_fast_ctr(+1)))
		return;

	down_read(&brw->rw_sem);
	atomic_inc(&brw->slow_read_ctr);
	up_read(&brw->rw_sem);
}

void percpu_up_read(struct percpu_rw_semaphore *brw)
{
	if (likely(update_fast_ctr(-1)))
		return;

	if (atomic_dec_and_test(&brw->slow_read_ctr))
		wake_up_all(&brw->write_waitq);
}

void percpu_down_write(struct percpu_rw_semaphore *brw)
{
	mutex_lock(&brw->writer_mutex);
	/* ensure mutex_is_locked() is visible to the readers */
	synchronize_sched();

	/* block the new readers */
	down_write(&brw->rw_sem);

	atomic_add(&brw->slow_read_ctr, clear_fast_read_ctr(brw));

	wait_event(brw->write_waitq, !atomic_read(&brw->slow_read_ctr));
}

void percpu_up_write(struct percpu_rw_semaphore *brw)
{
	up_write(&brw->rw_sem);
	/* insert the barrier before the next fast-path in down_read */
	synchronize_sched();

	mutex_unlock(&brw->writer_mutex);
}


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935239Ab2JXQek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:34:40 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:55478 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934356Ab2JXQei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:34:38 -0400
Date: Wed, 24 Oct 2012 09:16:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] percpu-rw-semaphores: use rcu_read_lock_sched
Message-ID: <20121024161638.GA2465@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com>
 <20121017165902.GB9872@redhat.com>
 <20121017224430.GC2518@linux.vnet.ibm.com>
 <20121018162409.GA28504@redhat.com>
 <20121018163833.GK2518@linux.vnet.ibm.com>
 <20121018175747.GA30691@redhat.com>
 <20121019192838.GM2518@linux.vnet.ibm.com>
 <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com>
 <Pine.LNX.4.64.1210221936570.25995@file.rdu.redhat.com>
 <Pine.LNX.4.64.1210221937550.25995@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1210221937550.25995@file.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102416-2876-0000-0000-0000015308B6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 07:39:16PM -0400, Mikulas Patocka wrote:
> Use rcu_read_lock_sched / rcu_read_unlock_sched / synchronize_sched
> instead of rcu_read_lock / rcu_read_unlock / synchronize_rcu.
> 
> This is an optimization. The RCU-protected region is very small, so
> there will be no latency problems if we disable preempt in this region.
> 
> So we use rcu_read_lock_sched / rcu_read_unlock_sched that translates
> to preempt_disable / preempt_disable. It is smaller (and supposedly
> faster) than preemptible rcu_read_lock / rcu_read_unlock.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

OK, as promised/threatened, I finally got a chance to take a closer look.

The light_mb() and heavy_mb() definitions aren't doing much for me,
the code would be cleared with them expanded inline.  And while the
approach of pairing barrier() with synchronize_sched() is interesting,
it would be simpler to rely on RCU's properties.  The key point is that
if RCU cannot prove that a given RCU-sched read-side critical section
is seen by all CPUs to have started after a given synchronize_sched(),
then that synchronize_sched() must wait for that RCU-sched read-side
critical section to complete.

This means, as discussed earlier, that there will be a memory barrier
somewhere following the end of that RCU-sched read-side critical section,
and that this memory barrier executes before the completion of the
synchronize_sched().

So I suggest something like the following (untested!) implementation:

------------------------------------------------------------------------

struct percpu_rw_semaphore {
	unsigned __percpu *counters;
	bool locked;
	struct mutex mtx;
	wait_queue_head_t wq;
};

static inline void percpu_down_read(struct percpu_rw_semaphore *p)
{
	rcu_read_lock_sched();
	if (unlikely(p->locked)) {
		rcu_read_unlock_sched();

		/*
		 * There might (or might not) be a writer.  Acquire &p->mtx,
		 * it is always safe (if a bit slow) to do so.
		 */
		mutex_lock(&p->mtx);
		this_cpu_inc(*p->counters);
		mutex_unlock(&p->mtx);
		return;
	}

	/* No writer, proceed locklessly. */
	this_cpu_inc(*p->counters);
	rcu_read_unlock_sched();
}

static inline void percpu_up_read(struct percpu_rw_semaphore *p)
{
	/*
	 * Decrement our count, but protected by RCU-sched so that
	 * the writer can force proper serialization.
	 */
	rcu_read_lock_sched();
	this_cpu_dec(*p->counters);
	rcu_read_unlock_sched();
}

static inline unsigned __percpu_count(unsigned __percpu *counters)
{
	unsigned total = 0;
	int cpu;

	for_each_possible_cpu(cpu)
		total += ACCESS_ONCE(*per_cpu_ptr(counters, cpu));

	return total;
}

static inline void percpu_down_write(struct percpu_rw_semaphore *p)
{
	mutex_lock(&p->mtx);

	/* Wait for a previous writer, if necessary. */
	wait_event(p->wq, !ACCESS_ONCE(p->locked));

	/* Force the readers to acquire the lock when manipulating counts. */
	ACCESS_ONCE(p->locked) = true;

	/* Wait for all pre-existing readers' checks of ->locked to finish. */
	synchronize_sched();
	/*
	 * At this point, all percpu_down_read() invocations will
	 * acquire p->mtx.
	 */

	/*
	 * Wait for all pre-existing readers to complete their
	 * percpu_up_read() calls.  Because ->locked is set and
	 * because we hold ->mtx, there cannot be any new readers.
	 * ->counters will therefore monotonically decrement to zero.
	 */
	while (__percpu_count(p->counters))
		msleep(1);

	/*
	 * Invoke synchronize_sched() in order to force the last
	 * caller of percpu_up_read() to exit its RCU-sched read-side
	 * critical section.  On SMP systems, this also forces the CPU
	 * that invoked that percpu_up_read() to execute a full memory
	 * barrier between the time it exited the RCU-sched read-side
	 * critical section and the time that synchronize_sched() returns,
	 * so that the critical section begun by this invocation of
	 * percpu_down_write() will happen after the critical section
	 * ended by percpu_up_read().
	 */
	synchronize_sched();
}

static inline void percpu_up_write(struct percpu_rw_semaphore *p)
{
	/* Allow others to proceed, but not yet locklessly. */
	mutex_unlock(&p->mtx);

	/*
	 * Ensure that all calls to percpu_down_read() that did not
	 * start unambiguously after the above mutex_unlock() still
	 * acquire the lock, forcing their critical sections to be
	 * serialized with the one terminated by this call to
	 * percpu_up_write().
	 */
	synchronize_sched();

	/* Now it is safe to allow readers to proceed locklessly. */
	ACCESS_ONCE(p->locked) = false;

	/*
	 * If there is another writer waiting, wake it up.  Note that
	 * p->mtx properly serializes its critical section with the
	 * critical section terminated by this call to percpu_up_write().
	 */
	wake_up(&p->wq);
}

static inline int percpu_init_rwsem(struct percpu_rw_semaphore *p)
{
	p->counters = alloc_percpu(unsigned);
	if (unlikely(!p->counters))
		return -ENOMEM;
	p->locked = false;
	mutex_init(&p->mtx);
	init_waitqueue_head(&p->wq);
	return 0;
}

static inline void percpu_free_rwsem(struct percpu_rw_semaphore *p)
{
	free_percpu(p->counters);
	p->counters = NULL; /* catch use after free bugs */
}

------------------------------------------------------------------------

Of course, it would be nice to get rid of the extra synchronize_sched().
One way to do this is to use SRCU, which allows blocking operations in
its read-side critical sections (though also increasing read-side overhead
a bit, and also untested):

------------------------------------------------------------------------

struct percpu_rw_semaphore {
	bool locked;
	struct mutex mtx; /* Could also be rw_semaphore. */
	struct srcu_struct s;
	wait_queue_head_t wq;
};

static inline int percpu_down_read(struct percpu_rw_semaphore *p)
{
	int idx;

	idx = srcu_read_lock(&p->s);
	if (unlikely(p->locked)) {
		srcu_read_unlock(&p->s, idx);

		/*
		 * There might (or might not) be a writer.  Acquire &p->mtx,
		 * it is always safe (if a bit slow) to do so.
		 */
		mutex_lock(&p->mtx);
		return -1;  /* srcu_read_lock() cannot return -1. */
	}
	return idx;
}

static inline void percpu_up_read(struct percpu_rw_semaphore *p, int idx)
{
	if (idx == -1)
		mutex_unlock(&p->mtx);
	else
		srcu_read_unlock(&p->s, idx);
}

static inline void percpu_down_write(struct percpu_rw_semaphore *p)
{
	mutex_lock(&p->mtx);

	/* Wait for a previous writer, if necessary. */
	wait_event(p->wq, !ACCESS_ONCE(p->locked));

	/* Force new readers to acquire the lock when manipulating counts. */
	ACCESS_ONCE(p->locked) = true;

	/* Wait for all pre-existing readers' checks of ->locked to finish. */
	synchronize_srcu(&p->s);
	/* At this point, all lockless readers have completed. */
}

static inline void percpu_up_write(struct percpu_rw_semaphore *p)
{
	/* Allow others to proceed, but not yet locklessly. */
	mutex_unlock(&p->mtx);

	/*
	 * Ensure that all calls to percpu_down_read() that did not
	 * start unambiguously after the above mutex_unlock() still
	 * acquire the lock, forcing their critical sections to be
	 * serialized with the one terminated by this call to
	 * percpu_up_write().
	 */
	synchronize_sched();

	/* Now it is safe to allow readers to proceed locklessly. */
	ACCESS_ONCE(p->locked) = false;

	/*
	 * If there is another writer waiting, wake it up.  Note that
	 * p->mtx properly serializes its critical section with the
	 * critical section terminated by this call to percpu_up_write().
	 */
	wake_up(&p->wq);
}

static inline int percpu_init_rwsem(struct percpu_rw_semaphore *p)
{
	p->locked = false;
	mutex_init(&p->mtx);
	if (unlikely(!init_srcu_struct(&p->s)));
		return -ENOMEM;
	init_waitqueue_head(&p->wq);
	return 0;
}

static inline void percpu_free_rwsem(struct percpu_rw_semaphore *p)
{
	cleanup_srcu_struct(&p->s);
}

------------------------------------------------------------------------

Of course, there was a question raised as to whether something already
exists that does this job...

And you guys did ask!

							Thanx, Paul


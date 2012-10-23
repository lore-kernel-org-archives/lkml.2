Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab2JWSHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 14:07:49 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38998 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740Ab2JWSHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 14:07:48 -0400
Date: Tue, 23 Oct 2012 11:05:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] percpu-rw-semaphores: use light/heavy barriers
Message-ID: <20121023180558.GF2585@linux.vnet.ibm.com>
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
 <20121023165912.GA18712@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023165912.GA18712@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102318-9360-0000-0000-00000BFF63F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 06:59:12PM +0200, Oleg Nesterov wrote:
> Not really the comment, but the question...
> 
> On 10/22, Mikulas Patocka wrote:
> >
> >  static inline void percpu_down_read(struct percpu_rw_semaphore *p)
> >  {
> >  	rcu_read_lock();
> > @@ -24,22 +27,12 @@ static inline void percpu_down_read(stru
> >  	}
> >  	this_cpu_inc(*p->counters);
> >  	rcu_read_unlock();
> > +	light_mb(); /* A, between read of p->locked and read of data, paired with D */
> >  }
> 
> rcu_read_unlock() (or even preempt_enable) should have compiler barrier
> semantics... But I agree, this adds more documentation for free.

Although rcu_read_lock() does have compiler-barrier semantics if
CONFIG_PREEMPT=y, it does not for CONFIG_PREEMPT=n.  So the
light_mb() (which appears to be barrier()) is needed in that case.

> >  static inline void percpu_up_read(struct percpu_rw_semaphore *p)
> >  {
> > -	/*
> > -	 * On X86, write operation in this_cpu_dec serves as a memory unlock
> > -	 * barrier (i.e. memory accesses may be moved before the write, but
> > -	 * no memory accesses are moved past the write).
> > -	 * On other architectures this may not be the case, so we need smp_mb()
> > -	 * there.
> > -	 */
> > -#if defined(CONFIG_X86) && (!defined(CONFIG_X86_PPRO_FENCE) && !defined(CONFIG_X86_OOSTORE))
> > -	barrier();
> > -#else
> > -	smp_mb();
> > -#endif
> > +	light_mb(); /* B, between read of the data and write to p->counter, paired with C */
> >  	this_cpu_dec(*p->counters);
> >  }
> >
> > @@ -61,11 +54,12 @@ static inline void percpu_down_write(str
> >  	synchronize_rcu();
> >  	while (__percpu_count(p->counters))
> >  		msleep(1);
> > -	smp_rmb(); /* paired with smp_mb() in percpu_sem_up_read() */
> > +	heavy_mb(); /* C, between read of p->counter and write to data, paired with B */
> 
> I _think_ this is correct.
> 
> 
> Just I am wondering if this is strongly correct in theory, I would
> really like to know what Paul thinks.

I need to take a closer look.

> Ignoring the current implementation, according to the documentation
> synchronize_sched() has all rights to return immediately if there is
> no active rcu_read_lock_sched() section. If this were possible, than
> percpu_up_read() lacks mb.

Even if there happen to be no RCU-sched read-side critical sections
at the current instant, synchronize_sched() is required to make sure
that everyone agrees that whatever code is executed by the caller after
synchronize_sched() returns happens after any of the preceding RCU
read-side critical sections.

So, if we have this, with x==0 initially:

	Task 0					Task 1

						rcu_read_lock_sched();
						x = 1;
						rcu_read_unlock_sched();
	synchronize_sched();
	r1 = x;

Then the value of r1 had better be one.

Of course, the above code fragment is doing absolutely nothing to ensure
that the synchronize_sched() really does start after Task 1's very strange
RCU read-side critical section, but if things did happen in that order,
synchronize_sched() would be required to make this guarantee.

> So _perhaps_ it makes sense to document that synchronize_sched() also
> guarantees that all pending loads/stores on other CPUs should be
> completed upon return? Or I misunderstood the patch?

Good point.  The current documentation implies that it does make that
guarantee, but it would be good for it to be explicit.  Queued for 3.8
is the following addition:

 * Note that this guarantee implies a further memory-ordering guarantee.
 * On systems with more than one CPU, when synchronize_sched() returns,
 * each CPU is guaranteed to have executed a full memory barrier since
 * the end of its last RCU read-side critical section whose beginning
 * preceded the call to synchronize_sched().  Note that this guarantee
 * includes CPUs that are offline, idle, or executing in user mode, as
 * well as CPUs that are executing in the kernel.  Furthermore, if CPU A
 * invoked synchronize_sched(), which returned to its caller on CPU B,
 * then both CPU A and CPU B are guaranteed to have executed a full memory
 * barrier during the execution of synchronize_sched().

The full comment block now reads:

/**
 * synchronize_sched - wait until an rcu-sched grace period has elapsed.
 *
 * Control will return to the caller some time after a full rcu-sched
 * grace period has elapsed, in other words after all currently executing
 * rcu-sched read-side critical sections have completed.   These read-side
 * critical sections are delimited by rcu_read_lock_sched() and
 * rcu_read_unlock_sched(), and may be nested.  Note that preempt_disable(),
 * local_irq_disable(), and so on may be used in place of
 * rcu_read_lock_sched().
 *
 * This means that all preempt_disable code sequences, including NMI and
 * hardware-interrupt handlers, in progress on entry will have completed
 * before this primitive returns.  However, this does not guarantee that
 * softirq handlers will have completed, since in some kernels, these
 * handlers can run in process context, and can block.
 *
 * Note that this guarantee implies a further memory-ordering guarantee.
 * On systems with more than one CPU, when synchronize_sched() returns,
 * each CPU is guaranteed to have executed a full memory barrier since
 * the end of its last RCU read-side critical section whose beginning
 * preceded the call to synchronize_sched().  Note that this guarantee
 * includes CPUs that are offline, idle, or executing in user mode, as
 * well as CPUs that are executing in the kernel.  Furthermore, if CPU A
 * invoked synchronize_sched(), which returned to its caller on CPU B,
 * then both CPU A and CPU B are guaranteed to have executed a full memory
 * barrier during the execution of synchronize_sched().
 *
 * This primitive provides the guarantees made by the (now removed)
 * synchronize_kernel() API.  In contrast, synchronize_rcu() only
 * guarantees that rcu_read_lock() sections will have completed.
 * In "classic RCU", these two guarantees happen to be one and
 * the same, but can differ in realtime RCU implementations.
 */

If this wording looks good to you, I will apply it to the other
grace-period primitives as well.

							Thanx, Paul


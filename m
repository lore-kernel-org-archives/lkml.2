Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab0KFT2X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 15:28:23 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35913 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab0KFT2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 15:28:21 -0400
Date: Sat, 6 Nov 2010 12:28:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joe Korty <joe.korty@ccur.com>
Cc: fweisbec@gmail.com, mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org
Subject: Re: [PATCH] a local-timer-free version of RCU
Message-ID: <20101106192812.GI15561@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101104232148.GA28037@linux.vnet.ibm.com>
 <20101105210059.GA27317@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101105210059.GA27317@tsunami.ccur.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 05:00:59PM -0400, Joe Korty wrote:
> On Thu, Nov 04, 2010 at 04:21:48PM -0700, Paul E. McKenney wrote:
> > Just wanted some written record of our discussion this Wednesday.
> > I don't have an email address for Jim Houston, and I am not sure I have
> > all of the attendees, but here goes anyway.  Please don't hesitate to
> > reply with any corrections!
> > 
> > The goal is to be able to turn of scheduling-clock interrupts for
> > long-running user-mode execution when there is but one runnable task
> > on a given CPU, but while still allowing RCU to function correctly.
> > In particular, we need to minimize (or better, eliminate) any source
> > of interruption to such a CPU.  We discussed these approaches, along
> > with their advantages and disadvantages:

Thank you very much for forward-porting and sending this, Joe!!!

A few questions and comments interspersed, probably mostly reflecting
my confusion about what this is doing.  The basic approach of driving
the grace periods out of rcu_read_unlock() and a per-CPU kthread does
seem quite workable in any case.

							Thanx, Paul

> Jim Houston's timer-less version of RCU.
> 	
> This rather ancient version of RCU handles RCU garbage
> collection in the absence of a per-cpu local timer
> interrupt.
> 
> This is a minimal forward port to 2.6.36.  It works,
> but it is not yet a complete implementation of RCU.
> 
> Developed-by: Jim Houston <jim.houston@ccur.com>
> Signed-off-by: Joe Korty <joe.korty@ccur.com>
> 
> Index: b/arch/x86/kernel/cpu/mcheck/mce.c
> ===================================================================
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -167,7 +167,8 @@ void mce_log(struct mce *mce)
>  	mce->finished = 0;
>  	wmb();
>  	for (;;) {
> -		entry = rcu_dereference_check_mce(mcelog.next);
> +		entry = mcelog.next;
> +		smp_read_barrier_depends();
>  		for (;;) {
>  			/*
>  			 * If edac_mce is enabled, it will check the error type
> @@ -1558,7 +1559,8 @@ static ssize_t mce_read(struct file *fil
>  			goto out;
>  	}
> 
> -	next = rcu_dereference_check_mce(mcelog.next);
> +	next = mcelog.next;
> +	smp_read_barrier_depends();
> 
>  	/* Only supports full reads right now */
>  	err = -EINVAL;
> Index: b/include/linux/rcushield.h
> ===================================================================
> --- /dev/null
> +++ b/include/linux/rcushield.h
> @@ -0,0 +1,361 @@
> +/*
> + * Read-Copy Update mechanism for mutual exclusion
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + * Copyright (C) IBM Corporation, 2001
> + *
> + * Author: Dipankar Sarma <dipankar@in.ibm.com>
> + *
> + * Based on the original work by Paul McKenney <paul.mckenney@us.ibm.com>
> + * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
> + * Papers:
> + * http://www.rdrop.com/users/paulmck/paper/rclockpdcsproof.pdf
> + * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
> + *
> + * For detailed explanation of Read-Copy Update mechanism see -
> + * 		http://lse.sourceforge.net/locking/rcupdate.html
> + *
> + */
> +
> +#ifndef __LINUX_RCUPDATE_H
> +#define __LINUX_RCUPDATE_H
> +
> +#ifdef __KERNEL__
> +
> +#include <linux/cache.h>
> +#include <linux/spinlock.h>
> +#include <linux/threads.h>
> +#include <linux/smp.h>
> +#include <linux/cpumask.h>
> +
> +/*
> + * These #includes are not used by shielded RCUs; they are here
> + * to match the #includes made by the other rcu implementations.
> + */
> +#include <linux/seqlock.h>
> +#include <linux/lockdep.h>
> +#include <linux/completion.h>
> +
> +/**
> + * struct rcu_head - callback structure for use with RCU
> + * @next: next update requests in a list
> + * @func: actual update function to call after the grace period.
> + */
> +struct rcu_head {
> +	struct rcu_head *next;
> +	void (*func)(struct rcu_head *head);
> +};
> +
> +#define RCU_HEAD_INIT 	{ .next = NULL, .func = NULL }
> +#define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
> +#define INIT_RCU_HEAD(ptr) do { \
> +       (ptr)->next = NULL; (ptr)->func = NULL; \
> +} while (0)
> +
> +/*
> + * The rcu_batch variable contains the current batch number
> + * and the following flags.  The RCU_NEXT_PENDING bit requests that
> + * a new batch should start when the current batch completes.  The
> + * RCU_COMPLETE bit indicates that the most recent batch has completed
> + * and RCU processing has stopped.
> + */
> +extern long rcu_batch;
> +#define RCU_BATCH_MASK		(~3)
> +#define RCU_INCREMENT		4
> +#define RCU_COMPLETE		2
> +#define RCU_NEXT_PENDING	1
> +
> +/* Is batch a before batch b ? */
> +static inline int rcu_batch_before(long a, long b)
> +{
> +	return (a - b) < 0;
> +}
> +
> +/* Is batch a after batch b ? */
> +static inline int rcu_batch_after(long a, long b)
> +{
> +	return (a - b) > 0;
> +}
> +
> +static inline int rcu_batch_complete(long batch)
> +{
> +	return !rcu_batch_before((rcu_batch & ~RCU_NEXT_PENDING), batch);
> +}
> +
> +struct rcu_list {
> +	struct rcu_head *head;
> +	struct rcu_head **tail;
> +};
> +
> +static inline void rcu_list_init(struct rcu_list *l)
> +{
> +	l->head = NULL;
> +	l->tail = &l->head;
> +}
> +
> +static inline void rcu_list_add(struct rcu_list *l, struct rcu_head *h)
> +{
> +	*l->tail = h;
> +	l->tail = &h->next;
> +}
> +
> +static inline void rcu_list_move(struct rcu_list *to, struct rcu_list *from)
> +{
> +	if (from->head) {
> +		*to->tail = from->head;
> +		to->tail = from->tail;
> +		rcu_list_init(from);
> +	}
> +}
> +
> +/*
> + * Per-CPU data for Read-Copy UPdate.
> + * nxtlist - new callbacks are added here
> + * curlist - current batch for which quiescent cycle started if any
> + */
> +struct rcu_data {
> +	/* 1) batch handling */
> +	long  	       	batch;		/* batch # for current RCU batch */
> +	unsigned long	nxtbatch;	/* batch # for next queue */
> +	struct rcu_list nxt;
> +	struct rcu_list cur;
> +	struct rcu_list done;

Lai Jiangshan's multi-tail trick would work well here, but this works
fine too.

> +	long		nxtcount;	/* number of callbacks queued */
> +	struct task_struct *krcud;
> +	struct rcu_head barrier;
> +
> +	/* 2) synchronization between rcu_read_lock and rcu_start_batch. */
> +	int		nest_count;	/* count of rcu_read_lock nesting */
> +	unsigned int	flags;
> +	unsigned int	sequence;	/* count of read locks. */
> +};
> +
> +/*
> + * Flags values used to synchronize between rcu_read_lock/rcu_read_unlock
> + * and the rcu_start_batch.  Only processors executing rcu_read_lock
> + * protected code get invited to the rendezvous.
> + */
> +#define	IN_RCU_READ_LOCK	1
> +#define	DO_RCU_COMPLETION	2
> +
> +DECLARE_PER_CPU(struct rcu_data, rcu_data);
> +
> +/**
> + * rcu_assign_pointer - assign (publicize) a pointer to a newly
> + * initialized structure that will be dereferenced by RCU read-side
> + * critical sections.  Returns the value assigned.
> + *
> + * Inserts memory barriers on architectures that require them
> + * (pretty much all of them other than x86), and also prevents
> + * the compiler from reordering the code that initializes the
> + * structure after the pointer assignment.  More importantly, this
> + * call documents which pointers will be dereferenced by RCU read-side
> + * code.
> + */
> +
> +#define rcu_assign_pointer(p, v)	({ \
> +						smp_wmb(); \
> +						(p) = (v); \
> +					})
> +
> +extern void rcu_init(void);
> +extern void rcu_restart_cpu(int cpu);
> +extern void rcu_quiescent(int cpu);
> +extern void rcu_poll(int cpu);
> +
> +/* stubs for mainline rcu features we do not need */
> +static inline void rcu_sched_qs(int cpu) { }
> +static inline void rcu_bh_qs(int cpu) { }
> +static inline int rcu_needs_cpu(int cpu) { return 0; }
> +static inline void rcu_enter_nohz(void) { }
> +static inline void rcu_exit_nohz(void) { }
> +static inline void rcu_init_sched(void) { }
> +
> +extern void __rcu_read_lock(void);
> +extern void __rcu_read_unlock(void);
> +
> +static inline void rcu_read_lock(void)
> +{
> +	preempt_disable();

We will need preemptible read-side critical sections for some workloads,
however, the HPC guys are probably OK with non-preemptible read-side
critical sections.  And it is probably not impossible to adapt something
like this for the preemptible case.

> +	__rcu_read_lock();
> +}
> +
> +static inline void rcu_read_unlock(void)
> +{
> +	__rcu_read_unlock();
> +	preempt_enable();
> +}
> +
> +#define rcu_read_lock_sched(void) rcu_read_lock()
> +#define rcu_read_unlock_sched(void) rcu_read_unlock()
> +
> +static inline void rcu_read_lock_sched_notrace(void)
> +{
> +	preempt_disable_notrace();
> +	__rcu_read_lock();
> +}
> +
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +#error need DEBUG_LOCK_ALLOC definitions for rcu_read_lock_*_held
> +#else
> +static inline int rcu_read_lock_held(void)
> +{
> +	return 1;
> +}
> +
> +static inline int rcu_read_lock_bh_held(void)
> +{
> +	return 1;
> +}
> +#endif /* CONFIG_DEBUG_LOCK_ALLOC */
> +
> +static inline int rcu_preempt_depth(void)
> +{
> +	return 0;
> +}
> +
> +static inline void exit_rcu(void)
> +{
> +}
> +
> +static inline void rcu_read_unlock_sched_notrace(void)
> +{
> +	__rcu_read_unlock();
> +	preempt_enable_notrace();
> +}
> +
> +#ifdef CONFIG_DEBUG_KERNEL
> +/*
> + * Try to catch code which depends on RCU but doesn't
> + * hold the rcu_read_lock.
> + */
> +static inline void rcu_read_lock_assert(void)
> +{
> +#ifdef NOTYET
> +	/* 2.6.13 has _lots_ of panics here.  Must fix up. */
> +	struct rcu_data *r;
> +
> +	r = &per_cpu(rcu_data, smp_processor_id());
> +	BUG_ON(r->nest_count == 0);
> +#endif
> +}
> +#else
> +static inline void rcu_read_lock_assert(void) {}
> +#endif
> +
> +/*
> + * So where is rcu_write_lock()?  It does not exist, as there is no
> + * way for writers to lock out RCU readers.  This is a feature, not
> + * a bug -- this property is what provides RCU's performance benefits.
> + * Of course, writers must coordinate with each other.  The normal
> + * spinlock primitives work well for this, but any other technique may be
> + * used as well.  RCU does not care how the writers keep out of each
> + * others' way, as long as they do so.
> + */
> +
> +/**
> + * rcu_read_lock_bh - mark the beginning of a softirq-only RCU critical section
> + *
> + * This is equivalent of rcu_read_lock(), but to be used when updates
> + * are being done using call_rcu_bh(). Since call_rcu_bh() callbacks
> + * consider completion of a softirq handler to be a quiescent state,
> + * a process in RCU read-side critical section must be protected by
> + * disabling softirqs. Read-side critical sections in interrupt context
> + * can use just rcu_read_lock().
> + *
> + * Hack alert.  I'm not sure if I understand the reason this interface
> + * is needed and if it is still needed with my implementation of RCU.

Given that you keep track of RCU read-side critical sections exactly
rather than relying on quiescent states, this should work fine.

> + */
> +static inline void rcu_read_lock_bh(void)
> +{
> +	local_bh_disable();
> +	rcu_read_lock();
> +}
> +
> +/*
> + * rcu_read_unlock_bh - marks the end of a softirq-only RCU critical section
> + *
> + * See rcu_read_lock_bh() for more information.
> + */
> +static inline void rcu_read_unlock_bh(void)
> +{
> +	rcu_read_unlock();
> +	local_bh_enable();
> +}
> +
> +/**
> + * rcu_dereference - fetch an RCU-protected pointer in an
> + * RCU read-side critical section.  This pointer may later
> + * be safely dereferenced.
> + *
> + * Inserts memory barriers on architectures that require them
> + * (currently only the Alpha), and, more importantly, documents
> + * exactly which pointers are protected by RCU.
> + */
> +
> +#define rcu_dereference(p)     ({ \
> +				typeof(p) _________p1 = p; \
> +				rcu_read_lock_assert(); \
> +				smp_read_barrier_depends(); \
> +				(_________p1); \
> +				})
> +
> +#define rcu_dereference_raw(p)     ({ \
> +				typeof(p) _________p1 = p; \
> +				smp_read_barrier_depends(); \
> +				(_________p1); \
> +				})
> +
> +#define rcu_dereference_sched(p) rcu_dereference(p)
> +#define rcu_dereference_check(p, c) rcu_dereference(p)
> +#define rcu_dereference_index_check(p, c) rcu_dereference(p)
> +#define rcu_dereference_protected(p, c) rcu_dereference(p)
> +#define rcu_dereference_bh(p) rcu_dereference(p)
> +
> +static inline void rcu_note_context_switch(int cpu) {}
> +
> +/**
> + * synchronize_sched - block until all CPUs have exited any non-preemptive
> + * kernel code sequences.
> + *
> + * This means that all preempt_disable code sequences, including NMI and
> + * hardware-interrupt handlers, in progress on entry will have completed
> + * before this primitive returns.  However, this does not guarantee that
> + * softirq handlers will have completed, since in some kernels

OK, so your approach treats preempt_disable code sequences as RCU
read-side critical sections by relying on the fact that the per-CPU
->krcud task cannot run until such code sequences complete, correct?

This seems to require that each CPU's ->krcud task be awakened at
least once per grace period, but I might well be missing something.

> + * This primitive provides the guarantees made by the (deprecated)
> + * synchronize_kernel() API.  In contrast, synchronize_rcu() only
> + * guarantees that rcu_read_lock() sections will have completed.
> + */
> +#define synchronize_sched synchronize_rcu
> +#define synchronize_sched_expedited synchronize_rcu
> +
> +/* Exported interfaces */
> +#define call_rcu_sched(head, func) call_rcu(head, func)
> +extern void call_rcu(struct rcu_head *head,
> +		void (*func)(struct rcu_head *head));
> +extern void call_rcu_bh(struct rcu_head *head,
> +		void (*func)(struct rcu_head *head));
> +extern __deprecated_for_modules void synchronize_kernel(void);
> +extern void synchronize_rcu(void);
> +extern void rcu_barrier(void);
> +#define rcu_barrier_sched rcu_barrier
> +#define rcu_barrier_bh rcu_barrier
> +static inline void rcu_scheduler_starting(void) {}
> +extern void do_delayed_rcu_daemon_wakeups(void);
> +
> +#endif /* __KERNEL__ */
> +#endif /* __LINUX_RCUPDATE_H */
> Index: b/include/linux/rcupdate.h
> ===================================================================
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -30,6 +30,10 @@
>   *
>   */
> 
> +#ifdef CONFIG_SHIELDING_RCU
> +#include <linux/rcushield.h>
> +#else
> +
>  #ifndef __LINUX_RCUPDATE_H
>  #define __LINUX_RCUPDATE_H
> 
> @@ -600,3 +604,4 @@ static inline void debug_rcu_head_unqueu
>  	__rcu_dereference_index_check((p), (c))
> 
>  #endif /* __LINUX_RCUPDATE_H */
> +#endif /* CONFIG_SHIELDING_RCU */
> Index: b/include/linux/sysctl.h
> ===================================================================
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -153,6 +153,7 @@ enum
>  	KERN_MAX_LOCK_DEPTH=74, /* int: rtmutex's maximum lock depth */
>  	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
>  	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
> +	KERN_RCU=77,	/* make rcu variables available for debug */
>  };
> 
> 
> @@ -235,6 +236,11 @@ enum
>  	RANDOM_UUID=6
>  };
> 
> +/* /proc/sys/kernel/rcu */
> +enum {
> +	RCU_BATCH=1
> +};
> +
>  /* /proc/sys/kernel/pty */
>  enum
>  {
> Index: b/init/main.c
> ===================================================================
> --- a/init/main.c
> +++ b/init/main.c
> @@ -606,13 +606,13 @@ asmlinkage void __init start_kernel(void
>  				"enabled *very* early, fixing it\n");
>  		local_irq_disable();
>  	}
> -	rcu_init();
>  	radix_tree_init();
>  	/* init some links before init_ISA_irqs() */
>  	early_irq_init();
>  	init_IRQ();
>  	prio_tree_init();
>  	init_timers();
> +	rcu_init();  /* must appear after init_timers for shielded rcu */
>  	hrtimers_init();
>  	softirq_init();
>  	timekeeping_init();
> Index: b/kernel/Makefile
> ===================================================================
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -6,13 +6,16 @@ obj-y     = sched.o fork.o exec_domain.o
>  	    cpu.o exit.o itimer.o time.o softirq.o resource.o \
>  	    sysctl.o sysctl_binary.o capability.o ptrace.o timer.o user.o \
>  	    signal.o sys.o kmod.o workqueue.o pid.o \
> -	    rcupdate.o extable.o params.o posix-timers.o \
> +	    extable.o params.o posix-timers.o \
>  	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
>  	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
>  	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
>  	    async.o range.o
>  obj-$(CONFIG_HAVE_EARLY_RES) += early_res.o
>  obj-y += groups.o
> +ifndef CONFIG_SHIELDING_RCU
> +obj-y += rcupdate.o
> +endif
> 
>  ifdef CONFIG_FUNCTION_TRACER
>  # Do not trace debug files and internal ftrace files
> @@ -81,6 +84,7 @@ obj-$(CONFIG_DETECT_HUNG_TASK) += hung_t
>  obj-$(CONFIG_LOCKUP_DETECTOR) += watchdog.o
>  obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
>  obj-$(CONFIG_SECCOMP) += seccomp.o
> +obj-$(CONFIG_SHIELDING_RCU) += rcushield.o
>  obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
>  obj-$(CONFIG_TREE_RCU) += rcutree.o
>  obj-$(CONFIG_TREE_PREEMPT_RCU) += rcutree.o
> Index: b/kernel/rcushield.c
> ===================================================================
> --- /dev/null
> +++ b/kernel/rcushield.c
> @@ -0,0 +1,812 @@
> +/*
> + * Read-Copy Update mechanism for mutual exclusion
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + * Copyright (C) IBM Corporation, 2001
> + *
> + * Authors: Dipankar Sarma <dipankar@in.ibm.com>
> + *	    Manfred Spraul <manfred@colorfullife.com>
> + *
> + * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
> + * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
> + * Papers:
> + * http://www.rdrop.com/users/paulmck/paper/rclockpdcsproof.pdf
> + * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
> + *
> + * For detailed explanation of Read-Copy Update mechanism see -
> + * 		http://lse.sourceforge.net/locking/rcupdate.html
> + *
> + * Modified by:  Jim Houston <jim.houston@ccur.com>
> + * 	This is a experimental version which uses explicit synchronization
> + *	between rcu_read_lock/rcu_read_unlock and rcu_poll_other_cpus()
> + *	to complete RCU batches without relying on timer based polling.
> + *
> + */
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/spinlock.h>
> +#include <linux/smp.h>
> +#include <linux/interrupt.h>
> +#include <linux/sched.h>
> +#include <asm/atomic.h>
> +#include <linux/bitops.h>
> +#include <linux/module.h>
> +#include <linux/completion.h>
> +#include <linux/moduleparam.h>
> +#include <linux/percpu.h>
> +#include <linux/notifier.h>
> +#include <linux/rcupdate.h>
> +#include <linux/cpu.h>
> +#include <linux/jiffies.h>
> +#include <linux/kthread.h>
> +#include <linux/sysctl.h>
> +
> +/*
> + * Definition for rcu_batch.  This variable includes the flags:
> + *	RCU_NEXT_PENDING
> + * 		used to request that another batch should be
> + *		started when the current batch completes.
> + *	RCU_COMPLETE
> + *		which indicates that the last batch completed and
> + *		that rcu callback processing is stopped.
> + *
> + * Combinning this state in a single word allows them to be maintained
> + * using an atomic exchange.
> + */
> +long rcu_batch = (-300*RCU_INCREMENT)+RCU_COMPLETE;
> +unsigned long rcu_timestamp;
> +
> +/* Bookkeeping of the progress of the grace period */
> +struct {
> +	cpumask_t	rcu_cpu_mask; /* CPUs that need to switch in order    */
> +				      /* for current batch to proceed.        */
> +} rcu_state ____cacheline_internodealigned_in_smp =
> +	  { .rcu_cpu_mask = CPU_MASK_NONE };
> +
> +
> +DEFINE_PER_CPU(struct rcu_data, rcu_data) = { 0L };
> +
> +/*
> + * Limits to control when new batchs of RCU callbacks are started.
> + */
> +long rcu_max_count = 256;
> +unsigned long rcu_max_time = HZ/10;
> +
> +static void rcu_start_batch(void);
> +
> +/*
> + * Make the rcu_batch available for debug.
> + */
> +ctl_table rcu_table[] = {
> +	{
> +		.procname	= "batch",
> +		.data		= &rcu_batch,
> +		.maxlen		= sizeof(rcu_batch),
> +		.mode		= 0444,
> +		.proc_handler	= &proc_doulongvec_minmax,
> +	},
> +	{}
> +};
> +
> +/*
> + * rcu_set_state maintains the RCU_COMPLETE and RCU_NEXT_PENDING
> + * bits in rcu_batch.  Multiple processors might try to mark the
> + * current batch as complete, or start a new batch at the same time.
> + * The cmpxchg() makes the state transition atomic. rcu_set_state()
> + * returns the previous state.  This allows the caller to tell if
> + * it caused the state transition.
> + */
> +
> +int rcu_set_state(long state)
> +{
> +	long batch, new, last;
> +	do {
> +		batch = rcu_batch;
> +		if (batch & state)
> +			return batch & (RCU_COMPLETE | RCU_NEXT_PENDING);
> +		new = batch | state;
> +		last = cmpxchg(&rcu_batch, batch, new);
> +	} while (unlikely(last != batch));
> +	return last & (RCU_COMPLETE | RCU_NEXT_PENDING);
> +}
> +
> +
> +static atomic_t rcu_barrier_cpu_count;
> +static struct mutex rcu_barrier_mutex;
> +static struct completion rcu_barrier_completion;
> +
> +/*
> + * If the batch in the nxt list or cur list has completed move it to the
> + * done list.  If its grace period for the nxt list has begun
> + * move the contents to the cur list.
> + */
> +static int rcu_move_if_done(struct rcu_data *r)
> +{
> +	int done = 0;
> +
> +	if (r->cur.head && rcu_batch_complete(r->batch)) {
> +		rcu_list_move(&r->done, &r->cur);
> +		done = 1;
> +	}
> +	if (r->nxt.head) {
> +		if (rcu_batch_complete(r->nxtbatch)) {
> +			rcu_list_move(&r->done, &r->nxt);
> +			r->nxtcount = 0;
> +			done = 1;
> +		} else if (r->nxtbatch == rcu_batch) {
> +			/*
> +			 * The grace period for the nxt list has started
> +			 * move its content to the cur list.
> +			 */
> +			rcu_list_move(&r->cur, &r->nxt);
> +			r->batch = r->nxtbatch;
> +			r->nxtcount = 0;
> +		}
> +	}
> +	return done;
> +}
> +
> +/*
> + * support delayed krcud wakeups.  Needed whenever we
> + * cannot wake up krcud directly, this happens whenever
> + * rcu_read_lock ... rcu_read_unlock is used under
> + * rq->lock.
> + */
> +static cpumask_t rcu_wake_mask = CPU_MASK_NONE;
> +static cpumask_t rcu_wake_mask_copy;
> +static DEFINE_RAW_SPINLOCK(rcu_wake_lock);
> +static int rcu_delayed_wake_count;
> +
> +void do_delayed_rcu_daemon_wakeups(void)
> +{
> +	int cpu;
> +	unsigned long flags;
> +	struct rcu_data *r;
> +	struct task_struct *p;
> +
> +	if (likely(cpumask_empty(&rcu_wake_mask)))
> +		return;
> +
> +	raw_spin_lock_irqsave(&rcu_wake_lock, flags);
> +	cpumask_copy(&rcu_wake_mask_copy, &rcu_wake_mask);
> +	cpumask_clear(&rcu_wake_mask);
> +	raw_spin_unlock_irqrestore(&rcu_wake_lock, flags);
> +
> +	for_each_cpu(cpu, &rcu_wake_mask_copy) {
> +		r = &per_cpu(rcu_data, cpu);
> +		p = r->krcud;
> +		if (p && p->state != TASK_RUNNING) {
> +			wake_up_process(p);
> +			rcu_delayed_wake_count++;
> +		}
> +	}
> +}

Hmmm....  I wonder if it would make sense to use RCU_SOFTIRQ for
the delay, where needed?

> +void rcu_wake_daemon_delayed(struct rcu_data *r)
> +{
> +	unsigned long flags;
> +	raw_spin_lock_irqsave(&rcu_wake_lock, flags);
> +	cpumask_set_cpu(task_cpu(r->krcud), &rcu_wake_mask);
> +	raw_spin_unlock_irqrestore(&rcu_wake_lock, flags);
> +}
> +
> +/*
> + * Wake rcu daemon if it is not already running.  Note that
> + * we avoid invoking wake_up_process if RCU is being used under
> + * the rq lock.
> + */
> +void rcu_wake_daemon(struct rcu_data *r)
> +{
> +	struct task_struct *p = r->krcud;
> +
> +	if (p && p->state != TASK_RUNNING) {
> +#ifdef BROKEN
> +		/* runqueue_is_locked is racy, let us use only
> +		 * the delayed approach.
> +		 */
> +		if (unlikely(runqueue_is_locked(smp_processor_id())))
> +			rcu_wake_daemon_delayed(r);
> +		else
> +			wake_up_process(p);
> +#else
> +		rcu_wake_daemon_delayed(r);
> +#endif
> +	}
> +}
> +
> +/**
> + * rcu_read_lock - mark the beginning of an RCU read-side critical section.
> + *
> + * When synchronize_rcu() is invoked on one CPU while other CPUs
> + * are within RCU read-side critical sections, then the
> + * synchronize_rcu() is guaranteed to block until after all the other
> + * CPUs exit their critical sections.  Similarly, if call_rcu() is invoked
> + * on one CPU while other CPUs are within RCU read-side critical
> + * sections, invocation of the corresponding RCU callback is deferred
> + * until after the all the other CPUs exit their critical sections.
> + *
> + * Note, however, that RCU callbacks are permitted to run concurrently
> + * with RCU read-side critical sections.  One way that this can happen
> + * is via the following sequence of events: (1) CPU 0 enters an RCU
> + * read-side critical section, (2) CPU 1 invokes call_rcu() to register
> + * an RCU callback, (3) CPU 0 exits the RCU read-side critical section,
> + * (4) CPU 2 enters a RCU read-side critical section, (5) the RCU
> + * callback is invoked.  This is legal, because the RCU read-side critical
> + * section that was running concurrently with the call_rcu() (and which
> + * therefore might be referencing something that the corresponding RCU
> + * callback would free up) has completed before the corresponding
> + * RCU callback is invoked.
> + *
> + * RCU read-side critical sections may be nested.  Any deferred actions
> + * will be deferred until the outermost RCU read-side critical section
> + * completes.
> + *
> + * It is illegal to block while in an RCU read-side critical section.
> + */
> +void __rcu_read_lock(void)
> +{
> +	struct rcu_data *r;
> +
> +	r = &per_cpu(rcu_data, smp_processor_id());
> +	if (r->nest_count++ == 0)
> +		/*
> +		 * Set the flags value to show that we are in
> +		 * a read side critical section.  The code starting
> +		 * a batch uses this to determine if a processor
> +		 * needs to participate in the batch.  Including
> +		 * a sequence allows the remote processor to tell
> +		 * that a critical section has completed and another
> +		 * has begun.
> +		 */
> +		r->flags = IN_RCU_READ_LOCK | (r->sequence++ << 2);

It seems to me that we need a memory barrier here -- what am I missing?

> +}
> +EXPORT_SYMBOL(__rcu_read_lock);
> +
> +/**
> + * rcu_read_unlock - marks the end of an RCU read-side critical section.
> + * Check if a RCU batch was started while we were in the critical
> + * section.  If so, call rcu_quiescent() join the rendezvous.
> + *
> + * See rcu_read_lock() for more information.
> + */
> +void __rcu_read_unlock(void)
> +{
> +	struct rcu_data *r;
> +	int	cpu, flags;
> +
> +	cpu = smp_processor_id();
> +	r = &per_cpu(rcu_data, cpu);
> +	if (--r->nest_count == 0) {
> +		flags = xchg(&r->flags, 0);
> +		if (flags & DO_RCU_COMPLETION)
> +			rcu_quiescent(cpu);
> +	}
> +}
> +EXPORT_SYMBOL(__rcu_read_unlock);
> +
> +/**
> + * call_rcu - Queue an RCU callback for invocation after a grace period.
> + * @head: structure to be used for queueing the RCU updates.
> + * @func: actual update function to be invoked after the grace period
> + *
> + * The update function will be invoked some time after a full grace
> + * period elapses, in other words after all currently executing RCU
> + * read-side critical sections have completed.  RCU read-side critical
> + * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
> + * and may be nested.
> + */
> +void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
> +{
> +	struct rcu_data *r;
> +	unsigned long flags;
> +	int cpu;
> +
> +	head->func = func;
> +	head->next = NULL;
> +	local_irq_save(flags);
> +	cpu = smp_processor_id();
> +	r = &per_cpu(rcu_data, cpu);
> +	/*
> +	 * Avoid mixing new entries with batches which have already
> +	 * completed or have a grace period in progress.
> +	 */
> +	if (r->nxt.head && rcu_move_if_done(r))
> +		rcu_wake_daemon(r);
> +
> +	rcu_list_add(&r->nxt, head);
> +	if (r->nxtcount++ == 0) {
> +		r->nxtbatch = (rcu_batch & RCU_BATCH_MASK) + RCU_INCREMENT;
> +		barrier();
> +		if (!rcu_timestamp)
> +			rcu_timestamp = jiffies ?: 1;
> +	}
> +	/* If we reach the limit start a batch. */
> +	if (r->nxtcount > rcu_max_count) {
> +		if (rcu_set_state(RCU_NEXT_PENDING) == RCU_COMPLETE)
> +			rcu_start_batch();
> +	}
> +	local_irq_restore(flags);
> +}
> +EXPORT_SYMBOL_GPL(call_rcu);
> +
> +/*
> + * Revisit - my patch treats any code not protected by rcu_read_lock(),
> + * rcu_read_unlock() as a quiescent state.  I suspect that the call_rcu_bh()
> + * interface is not needed.
> + */
> +void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
> +{
> +	call_rcu(head, func);
> +}
> +EXPORT_SYMBOL_GPL(call_rcu_bh);
> +
> +static void rcu_barrier_callback(struct rcu_head *notused)
> +{
> +	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
> +		complete(&rcu_barrier_completion);
> +}
> +
> +/*
> + * Called with preemption disabled, and from cross-cpu IRQ context.
> + */
> +static void rcu_barrier_func(void *notused)
> +{
> +	int cpu = smp_processor_id();
> +	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
> +	struct rcu_head *head;
> +
> +	head = &rdp->barrier;
> +	atomic_inc(&rcu_barrier_cpu_count);
> +	call_rcu(head, rcu_barrier_callback);
> +}
> +
> +/**
> + * rcu_barrier - Wait until all the in-flight RCUs are complete.
> + */
> +void rcu_barrier(void)
> +{
> +	BUG_ON(in_interrupt());
> +	/* Take cpucontrol semaphore to protect against CPU hotplug */
> +	mutex_lock(&rcu_barrier_mutex);
> +	init_completion(&rcu_barrier_completion);
> +	atomic_set(&rcu_barrier_cpu_count, 0);
> +	on_each_cpu(rcu_barrier_func, NULL, 1);
> +	wait_for_completion(&rcu_barrier_completion);
> +	mutex_unlock(&rcu_barrier_mutex);
> +}
> +EXPORT_SYMBOL(rcu_barrier);
> +
> +
> +/*
> + * cpu went through a quiescent state since the beginning of the grace period.
> + * Clear it from the cpu mask and complete the grace period if it was the last
> + * cpu. Start another grace period if someone has further entries pending
> + */
> +
> +static void rcu_grace_period_complete(void)
> +{
> +	struct rcu_data *r;
> +	int cpu, last;
> +
> +	/*
> +	 * Mark the batch as complete.  If RCU_COMPLETE was
> +	 * already set we raced with another processor
> +	 * and it will finish the completion processing.
> +	 */
> +	last = rcu_set_state(RCU_COMPLETE);
> +	if (last & RCU_COMPLETE)
> +		return;
> +	/*
> +	 * If RCU_NEXT_PENDING is set, start the new batch.
> +	 */
> +	if (last & RCU_NEXT_PENDING)
> +		rcu_start_batch();
> +	/*
> +	 * Wake the krcud for any cpu which has requests queued.
> +	 */
> +	for_each_online_cpu(cpu) {
> +		r = &per_cpu(rcu_data, cpu);
> +		if (r->nxt.head || r->cur.head || r->done.head)
> +			rcu_wake_daemon(r);
> +	}
> +}
> +
> +/*
> + * rcu_quiescent() is called from rcu_read_unlock() when a
> + * RCU batch was started while the rcu_read_lock/rcu_read_unlock
> + * critical section was executing.
> + */
> +
> +void rcu_quiescent(int cpu)
> +{

What prevents two different CPUs from calling this concurrently?
Ah, apparently nothing -- the idea being that rcu_grace_period_complete()
sorts it out.  Though if the second CPU was delayed, it seems like it
might incorrectly end a subsequent grace period as follows:

o	CPU 0 clears the second-to-last bit.

o	CPU 1 clears the last bit.

o	CPU 1 sees that the mask is empty, so invokes
	rcu_grace_period_complete(), but is delayed in the function
	preamble.

o	CPU 0 sees that the mask is empty, so invokes
	rcu_grace_period_complete(), ending the grace period.
	Because the RCU_NEXT_PENDING is set, it also starts
	a new grace period.

o	CPU 1 continues in rcu_grace_period_complete(), incorrectly
	ending the new grace period.

Or am I missing something here?

> +	cpu_clear(cpu, rcu_state.rcu_cpu_mask);
> +	if (cpus_empty(rcu_state.rcu_cpu_mask))
> +		rcu_grace_period_complete();
> +}
> +
> +/*
> + * Check if the other cpus are in rcu_read_lock/rcu_read_unlock protected code.
> + * If not they are assumed to be quiescent and we can clear the bit in
> + * bitmap.  If not set DO_RCU_COMPLETION to request a quiescent point on
> + * the rcu_read_unlock.
> + *
> + * Do this in two passes.  On the first pass we sample the flags value.
> + * The second pass only looks at processors which were found in the read
> + * side critical section on the first pass.  The flags value contains
> + * a sequence value so we can tell if the processor has completed a
> + * critical section even if it has started another.
> + */
> +long rcu_grace_periods;
> +long rcu_count1;
> +long rcu_count2;
> +long rcu_count3;

The above three rcu_countN variables are for debug, correct?

> +void rcu_poll_other_cpus(void)
> +{
> +	struct rcu_data *r;
> +	int cpu;
> +	cpumask_t mask;
> +	unsigned int f, flags[NR_CPUS];

The NR_CPUS array will be a problem for large numbers of CPUs, but
this can be worked around.

> +	rcu_grace_periods++;
> +	for_each_online_cpu(cpu) {
> +		r = &per_cpu(rcu_data, cpu);
> +		f = flags[cpu] = r->flags;
> +		if (f == 0) {
> +			cpu_clear(cpu, rcu_state.rcu_cpu_mask);
> +			rcu_count1++;
> +		}
> +	}

My first thought was that we needed a memory barrier here, but after some
thought the fact that we are accessing the same ->flags fields before
and after, and without any interdependencies among these variables,
seems to be why you don't need a barrier.

> +	mask = rcu_state.rcu_cpu_mask;
> +	for_each_cpu_mask(cpu, mask) {
> +		r = &per_cpu(rcu_data, cpu);
> +		/*
> +		 * If the remote processor is still in the same read-side
> +		 * critical section set DO_RCU_COMPLETION to request that
> +		 * the cpu participate in the grace period.
> +		 */
> +		f = r->flags;
> +		if (f == flags[cpu])
> +			f = cmpxchg(&r->flags, f, f | DO_RCU_COMPLETION);
> +		/*
> +		 * If the other processors flags value changes before
> +		 * the cmpxchg() that processor is nolonger in the
> +		 * read-side critical section so we clear its bit.
> +		 */
> +		if (f != flags[cpu]) {
> +			cpu_clear(cpu, rcu_state.rcu_cpu_mask);
> +			rcu_count2++;
> +		} else
> +			rcu_count3++;
> +
> +	}

At this point, one of the CPUs that we hit with DO_RCU_COMPLETION might
have finished the grace period.  So how do we know that we are still
in the same grace period that we were in when this function was called?

If this is a real problem rather than a figment of my imagination,
then one way to solve it would be to set a local flag if we
set DO_RCU_COMPLETION on any CPU's ->flags field, and to invoke
rcu_grace_period_complete() only if that local flag is clear.

> +	if (cpus_empty(rcu_state.rcu_cpu_mask))
> +		rcu_grace_period_complete();
> +}
> +
> +/*
> + * Grace period handling:
> + * The grace period handling consists out of two steps:
> + * - A new grace period is started.
> + *   This is done by rcu_start_batch. The rcu_poll_other_cpus()
> + *   call drives the synchronization.  It loops checking if each
> + *   of the other cpus are executing in a rcu_read_lock/rcu_read_unlock
> + *   critical section.  The flags word for the cpus it finds in a
> + *   rcu_read_lock/rcu_read_unlock critical section will be updated to
> + *   request a rcu_quiescent() call.
> + * - Each of the cpus which were in the rcu_read_lock/rcu_read_unlock
> + *   critical section will eventually call rcu_quiescent() and clear
> + *   the bit corresponding to their cpu in rcu_state.rcu_cpu_mask.
> + * - The processor which clears the last bit wakes the krcud for
> + *   the cpus which have rcu callback requests queued.
> + *
> + * The process of starting a batch is arbitrated with the RCU_COMPLETE &
> + * RCU_NEXT_PENDING bits. These bits can be set in either order but the
> + * thread which sets the second bit must call rcu_start_batch().
> + * Multiple processors might try to set these bits at the same time.
> + * By using cmpxchg() we can determine which processor actually set
> + * the bit and be sure that only a single thread trys to start the batch.
> + *
> + */
> +static void rcu_start_batch(void)
> +{
> +	long batch, new;
> +
> +	batch = rcu_batch;
> +	BUG_ON((batch & (RCU_COMPLETE|RCU_NEXT_PENDING)) !=
> +		(RCU_COMPLETE|RCU_NEXT_PENDING));
> +	rcu_timestamp = 0;
> +	smp_mb();
> +	/*
> +	 * nohz_cpu_mask can go away because only cpus executing
> +	 * rcu_read_lock/rcu_read_unlock critical sections need to
> +	 * participate in the rendezvous.
> +	 */
> +	cpumask_andnot(&rcu_state.rcu_cpu_mask, cpu_online_mask, nohz_cpu_mask);

Hmmm...  Suppose that a CPU has its nohz_cpu_mask bit set, but is
currently in an interrupt handler where it is executing RCU read-side
critical sections?  If I understand this code correctly, any such
read-side critical sections would be incorrectly ignored.  (And yes,
we did have a similar bug in mainline for something like 5 years before
people started hitting it.)

> +	new = (batch & RCU_BATCH_MASK) + RCU_INCREMENT;
> +	smp_mb();
> +	rcu_batch = new;
> +	smp_mb();
> +	rcu_poll_other_cpus();
> +}
> +
> +
> +
> +#ifdef CONFIG_HOTPLUG_CPU
> +
> +static void rcu_offline_cpu(int cpu)
> +{
> +	struct rcu_data *this_rdp = &get_cpu_var(rcu_data);
> +	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
> +
> +#if 0
> +	/*
> +	 * The cpu should not have been in a read side critical
> +	 * section when it was removed.  So this code is not needed.
> +	 */
> +	/* if the cpu going offline owns the grace period
> +	 * we can block indefinitely waiting for it, so flush
> +	 * it here
> +	 */
> +	if (!(rcu_batch & RCU_COMPLETE))
> +		rcu_quiescent(cpu);
> +#endif
> +	local_irq_disable();
> +	/*
> +	 * The rcu lists are per-cpu private data only protected by
> +	 * disabling interrupts.  Since we know the other cpu is dead
> +	 * it should not be manipulating these lists.
> +	 */
> +	rcu_list_move(&this_rdp->cur, &rdp->cur);
> +	rcu_list_move(&this_rdp->nxt, &rdp->nxt);
> +	this_rdp->nxtbatch = (rcu_batch & RCU_BATCH_MASK) + RCU_INCREMENT;
> +	local_irq_enable();
> +	put_cpu_var(rcu_data);
> +}
> +
> +#else
> +
> +static inline void rcu_offline_cpu(int cpu)
> +{
> +}
> +
> +#endif
> +
> +/*
> + * Process the completed RCU callbacks.
> + */
> +static void rcu_process_callbacks(struct rcu_data *r)
> +{
> +	struct rcu_head *list, *next;
> +
> +	local_irq_disable();
> +	rcu_move_if_done(r);
> +	list = r->done.head;
> +	rcu_list_init(&r->done);
> +	local_irq_enable();
> +
> +	while (list) {
> +		next = list->next;
> +		list->func(list);
> +		list = next;

For large systems, we need to limit the number of callbacks executed
in one shot, but this is easy to fix.

> +	}
> +}
> +
> +/*
> + * Poll rcu_timestamp to start a RCU batch if there are
> + * any pending request which have been waiting longer
> + * than rcu_max_time.
> + */
> +struct timer_list rcu_timer;
> +
> +void rcu_timeout(unsigned long unused)
> +{
> +	do_delayed_rcu_daemon_wakeups();
> +
> +	if (rcu_timestamp
> +	&& time_after(jiffies, (rcu_timestamp + rcu_max_time))) {
> +		if (rcu_set_state(RCU_NEXT_PENDING) == RCU_COMPLETE)
> +			rcu_start_batch();
> +	}
> +	init_timer(&rcu_timer);
> +	rcu_timer.expires = jiffies + (rcu_max_time/2?:1);
> +	add_timer(&rcu_timer);

Ah, a self-spawning timer.  This needs to be on a "sacrificial lamb"
CPU.

> +}
> +
> +static void __devinit rcu_online_cpu(int cpu)
> +{
> +	struct rcu_data *r = &per_cpu(rcu_data, cpu);
> +
> +	memset(&per_cpu(rcu_data, cpu), 0, sizeof(struct rcu_data));
> +	rcu_list_init(&r->nxt);
> +	rcu_list_init(&r->cur);
> +	rcu_list_init(&r->done);
> +}
> +
> +int rcu_pending(struct rcu_data *r)
> +{
> +	return r->done.head ||
> +		(r->cur.head && rcu_batch_complete(r->batch)) ||
> +		(r->nxt.head && rcu_batch_complete(r->nxtbatch));
> +}
> +
> +static int krcud(void *__bind_cpu)
> +{
> +	int cpu = (int)(long) __bind_cpu;
> +	struct rcu_data *r = &per_cpu(rcu_data, cpu);
> +
> +	set_user_nice(current, 19);
> +	current->flags |= PF_NOFREEZE;
> +
> +	set_current_state(TASK_INTERRUPTIBLE);
> +
> +	while (!kthread_should_stop()) {
> +		if (!rcu_pending(r))
> +			schedule();
> +
> +		__set_current_state(TASK_RUNNING);
> +
> +		while (rcu_pending(r)) {
> +			/* Preempt disable stops cpu going offline.
> +			   If already offline, we'll be on wrong CPU:
> +			   don't process */
> +			preempt_disable();
> +			if (cpu_is_offline((long)__bind_cpu))
> +				goto wait_to_die;
> +			preempt_enable();
> +			rcu_process_callbacks(r);
> +			cond_resched();
> +		}
> +
> +		set_current_state(TASK_INTERRUPTIBLE);
> +	}
> +	__set_current_state(TASK_RUNNING);
> +	return 0;
> +
> +wait_to_die:
> +	preempt_enable();
> +	/* Wait for kthread_stop */
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	while (!kthread_should_stop()) {
> +		schedule();
> +		set_current_state(TASK_INTERRUPTIBLE);
> +	}
> +	__set_current_state(TASK_RUNNING);
> +	return 0;
> +}
> +
> +static int __devinit rcu_cpu_notify(struct notifier_block *nfb,
> +				  unsigned long action,
> +				  void *hcpu)
> +{
> +	int cpu = (unsigned long)hcpu;
> +	struct rcu_data *r = &per_cpu(rcu_data, cpu);
> +	struct task_struct *p;
> +
> +	switch (action) {
> +	case CPU_UP_PREPARE:
> +		rcu_online_cpu(cpu);
> +		p = kthread_create(krcud, hcpu, "krcud/%d", cpu);
> +		if (IS_ERR(p)) {
> +			printk(KERN_INFO "krcud for %i failed\n", cpu);
> +			return NOTIFY_BAD;
> +		}
> +		kthread_bind(p, cpu);
> +		r->krcud = p;
> +		break;
> +	case CPU_ONLINE:
> +		wake_up_process(r->krcud);
> +		break;
> +#ifdef CONFIG_HOTPLUG_CPU
> +	case CPU_UP_CANCELED:
> +		/* Unbind so it can run.  Fall thru. */
> +		kthread_bind(r->krcud, smp_processor_id());
> +	case CPU_DEAD:
> +		p = r->krcud;
> +		r->krcud = NULL;
> +		kthread_stop(p);
> +		rcu_offline_cpu(cpu);
> +		break;
> +#endif /* CONFIG_HOTPLUG_CPU */
> +	}
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block __devinitdata rcu_nb = {
> +	.notifier_call	= rcu_cpu_notify,
> +};
> +
> +static __init int spawn_krcud(void)
> +{
> +	void *cpu = (void *)(long)smp_processor_id();
> +	rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE, cpu);
> +	rcu_cpu_notify(&rcu_nb, CPU_ONLINE, cpu);
> +	register_cpu_notifier(&rcu_nb);
> +	return 0;
> +}
> +early_initcall(spawn_krcud);
> +/*
> + * Initializes rcu mechanism.  Assumed to be called early.
> + * That is before local timer(SMP) or jiffie timer (uniproc) is setup.
> + * Note that rcu_qsctr and friends are implicitly
> + * initialized due to the choice of ``0'' for RCU_CTR_INVALID.
> + */
> +void __init rcu_init(void)
> +{
> +	mutex_init(&rcu_barrier_mutex);
> +	rcu_online_cpu(smp_processor_id());
> +	/*
> +	 * Use a timer to catch the elephants which would otherwise
> +	 * fall throught the cracks on local timer shielded cpus.
> +	 */
> +	init_timer(&rcu_timer);
> +	rcu_timer.function = rcu_timeout;
> +	rcu_timer.expires = jiffies + (rcu_max_time/2?:1);
> +	add_timer(&rcu_timer);

OK, so CPU 0 is apparently the sacrificial lamb for the timer.

> +}
> +
> +
> +struct rcu_synchronize {
> +	struct rcu_head head;
> +	struct completion completion;
> +};
> +
> +/* Because of FASTCALL declaration of complete, we use this wrapper */
> +static void wakeme_after_rcu(struct rcu_head  *head)
> +{
> +	struct rcu_synchronize *rcu;
> +
> +	rcu = container_of(head, struct rcu_synchronize, head);
> +	complete(&rcu->completion);
> +}
> +
> +/**
> + * synchronize_rcu - wait until a grace period has elapsed.
> + *
> + * Control will return to the caller some time after a full grace
> + * period has elapsed, in other words after all currently executing RCU
> + * read-side critical sections have completed.  RCU read-side critical
> + * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
> + * and may be nested.
> + *
> + * If your read-side code is not protected by rcu_read_lock(), do -not-
> + * use synchronize_rcu().
> + */
> +void synchronize_rcu(void)
> +{
> +	struct rcu_synchronize rcu;
> +
> +	init_completion(&rcu.completion);
> +	/* Will wake me after RCU finished */
> +	call_rcu(&rcu.head, wakeme_after_rcu);
> +
> +	/* Wait for it */
> +	wait_for_completion(&rcu.completion);
> +}
> +EXPORT_SYMBOL_GPL(synchronize_rcu);
> +
> +/*
> + * Deprecated, use synchronize_rcu() or synchronize_sched() instead.
> + */
> +void synchronize_kernel(void)
> +{
> +	synchronize_rcu();
> +}
> +EXPORT_SYMBOL(synchronize_kernel);
> +
> +module_param(rcu_max_count, long, 0644);
> +module_param(rcu_max_time, long, 0644);
> Index: b/kernel/sysctl.c
> ===================================================================
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -215,6 +215,10 @@ extern struct ctl_table random_table[];
>  extern struct ctl_table epoll_table[];
>  #endif
> 
> +#ifdef CONFIG_SHIELDING_RCU
> +extern ctl_table rcu_table[];
> +#endif
> +
>  #ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
>  int sysctl_legacy_va_layout;
>  #endif
> @@ -808,6 +812,13 @@ static struct ctl_table kern_table[] = {
>  		.proc_handler	= proc_dointvec,
>  	},
>  #endif
> +#ifdef CONFIG_SHIELDING_RCU
> +	{
> +		.procname	= "rcu",
> +		.mode		= 0555,
> +		.child		= rcu_table,
> +	},
> +#endif
>  #if defined(CONFIG_S390) && defined(CONFIG_SMP)
>  	{
>  		.procname	= "spin_retry",
> Index: b/kernel/timer.c
> ===================================================================
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1272,12 +1272,15 @@ unsigned long get_next_timer_interrupt(u
>  void update_process_times(int user_tick)
>  {
>  	struct task_struct *p = current;
> -	int cpu = smp_processor_id();
> 
>  	/* Note: this timer irq context must be accounted for as well. */
>  	account_process_tick(p, user_tick);
>  	run_local_timers();
> -	rcu_check_callbacks(cpu, user_tick);
> +#ifndef CONFIG_SHIELDING_RCU
> +	rcu_check_callbacks(smp_processor_id(), user_tick);
> +#else
> +	do_delayed_rcu_daemon_wakeups();
> +#endif
>  	printk_tick();
>  	perf_event_do_pending();
>  	scheduler_tick();
> Index: b/lib/Kconfig.debug
> ===================================================================
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -791,6 +791,7 @@ config BOOT_PRINTK_DELAY
>  config RCU_TORTURE_TEST
>  	tristate "torture tests for RCU"
>  	depends on DEBUG_KERNEL
> +	depends on !SHIELDING_RCU
>  	default n
>  	help
>  	  This option provides a kernel module that runs torture tests
> Index: b/init/Kconfig
> ===================================================================
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -365,6 +365,13 @@ config TINY_RCU
>  	  is not required.  This option greatly reduces the
>  	  memory footprint of RCU.
> 
> +config SHIELDING_RCU
> +	bool "Shielding RCU"
> +	help
> +	  This option selects the RCU implementation that does not
> +	  depend on a per-cpu periodic interrupt to do garbage
> +	  collection.  This is good when one is trying to shield
> +	  some set of CPUs from as much system activity as possible.
>  endchoice
> 
>  config RCU_TRACE
> Index: b/include/linux/hardirq.h
> ===================================================================
> --- a/include/linux/hardirq.h
> +++ b/include/linux/hardirq.h
> @@ -138,7 +138,12 @@ static inline void account_system_vtime(
>  }
>  #endif
> 
> -#if defined(CONFIG_NO_HZ)
> +#if defined(CONFIG_SHIELDING_RCU)
> +# define rcu_irq_enter() do { } while (0)
> +# define rcu_irq_exit() do { } while (0)
> +# define rcu_nmi_enter() do { } while (0)
> +# define rcu_nmi_exit() do { } while (0)
> +#elif defined(CONFIG_NO_HZ)
>  #if defined(CONFIG_TINY_RCU)
>  extern void rcu_enter_nohz(void);
>  extern void rcu_exit_nohz(void);
> @@ -161,13 +166,13 @@ static inline void rcu_nmi_exit(void)
>  {
>  }
> 
> -#else
> +#else /* !CONFIG_TINY_RCU */
>  extern void rcu_irq_enter(void);
>  extern void rcu_irq_exit(void);
>  extern void rcu_nmi_enter(void);
>  extern void rcu_nmi_exit(void);
>  #endif
> -#else
> +#else /* !CONFIG_NO_HZ */
>  # define rcu_irq_enter() do { } while (0)
>  # define rcu_irq_exit() do { } while (0)
>  # define rcu_nmi_enter() do { } while (0)
> Index: b/kernel/sysctl_binary.c
> ===================================================================
> --- a/kernel/sysctl_binary.c
> +++ b/kernel/sysctl_binary.c
> @@ -61,6 +61,11 @@ static const struct bin_table bin_pty_ta
>  	{}
>  };
> 
> +static const struct bin_table bin_rcu_table[] = {
> +	{ CTL_INT,	RCU_BATCH,	"batch" },
> +	{}
> +};
> +
>  static const struct bin_table bin_kern_table[] = {
>  	{ CTL_STR,	KERN_OSTYPE,			"ostype" },
>  	{ CTL_STR,	KERN_OSRELEASE,			"osrelease" },
> @@ -138,6 +143,7 @@ static const struct bin_table bin_kern_t
>  	{ CTL_INT,	KERN_MAX_LOCK_DEPTH,		"max_lock_depth" },
>  	{ CTL_INT,	KERN_NMI_WATCHDOG,		"nmi_watchdog" },
>  	{ CTL_INT,	KERN_PANIC_ON_NMI,		"panic_on_unrecovered_nmi" },
> +	{ CTL_DIR,	KERN_RCU,			"rcu", bin_rcu_table },
>  	{}
>  };
> 
> Index: b/kernel/sched.c
> ===================================================================
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -9119,6 +9119,7 @@ struct cgroup_subsys cpuacct_subsys = {
>  };
>  #endif	/* CONFIG_CGROUP_CPUACCT */
> 
> +#ifndef CONFIG_SHIELDING_RCU
>  #ifndef CONFIG_SMP
> 
>  void synchronize_sched_expedited(void)
> @@ -9188,3 +9189,4 @@ void synchronize_sched_expedited(void)
>  EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
> 
>  #endif /* #else #ifndef CONFIG_SMP */
> +#endif /* CONFIG_SHIELDING_RCU */

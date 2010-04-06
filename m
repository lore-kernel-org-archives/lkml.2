Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127Ab0DFQ46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:56:58 -0400
Received: from www.tglx.de ([62.245.132.106]:45870 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab0DFQ4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:56:52 -0400
Date: Tue, 6 Apr 2010 18:55:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 4/6] futex: Add FUTEX_LOCK with optional adaptive
 spinning
In-Reply-To: <1270499039-23728-5-git-send-email-dvhltc@us.ibm.com>
Message-ID: <alpine.LFD.2.00.1004061818250.32352@localhost.localdomain>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> <1270499039-23728-5-git-send-email-dvhltc@us.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Apr 2010, Darren Hart wrote:
> +#ifdef CONFIG_SMP
> +struct thread_info *futex_owner(u32 __user *uaddr)
> +{
> +	struct thread_info *ti = NULL;
> +	struct task_struct *p;
> +	pid_t pid;
> +	u32 uval;
> +
> +	if (get_futex_value_locked(&uval, uaddr))
> +		return NULL;
> +
> +	pid = uval & FUTEX_TID_MASK;
> +	rcu_read_lock();
> +	p = find_task_by_vpid(pid);
> +	if (p) {
> +		const struct cred *cred, *pcred;
> +
> +		cred = current_cred();
> +		pcred = __task_cred(p);
> +		if (cred->euid == pcred->euid ||
> +		    cred->euid == pcred->uid)
> +			ti = task_thread_info(p);

  We want a get_task_struct() here, don't we ?

> +	}
> +	rcu_read_unlock();
> +
> +	return ti;
> +}
> +#endif
> +

> +/**
> + * trylock_futex_adaptive() - Try to acquire the futex lock in a busy loop
> + * @uaddr: the futex user address
> + *
> + * Try to acquire a futex lock in a loop until the owner changes or the owner
> + * is descheduled. To lock the futex, set the value to the current TID.
> + *
> + * Returns:
> + *  0 - Gave up, lock not acquired
> + *  1 - Futex lock acquired
> + * <0 - On error
> + */
> +static int trylock_futex_adaptive(u32 __user *uaddr)
> +{
> +	int ret = 0;
> +	u32 curval;
> +
> +	for (;;) {
> +		struct thread_info *owner;
> +
> +		owner = futex_owner(uaddr);
> +		if (owner && futex_spin_on_owner(uaddr, owner))
> +			break;
> +
> +		/*
> +		 * Try to acquire the lock. If we acquire it or error out,
> +		 * break to enable preemption and handle ret outside the loop.
> +		 */
> +		curval = cmpxchg_futex_value_locked(uaddr, 0,
> +		                                    task_pid_vnr(current));
> +
> +		if (curval == 0) {
> +			ret = 1;
> +			break;
> +		}
> +
> +		if (unlikely(curval == -EFAULT)) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +
> +		/*
> +		 * Futex locks manage the owner atomically. We are not in
> +		 * danger of deadlock by preempting a pending owner. Abort the
> +		 * loop if our time slice has expired.  RT Threads can spin
> +		 * until they preempt the owner, at which point they will break
> +		 * out of the loop anyway.
> +		 */
> +		if (need_resched())
> +			break;
> +
> +		cpu_relax();
> +	}
> +	return ret;
> +}


Hmm. The order is weird. Why don't you do that simpler ?

Get the uval, the tid and the thread_info pointer outside of the
loop. Also task_pid_vnr(current) just needs a one time lookup.

change the loop to do:

       for (;;) {
       	   curval = cmpxchg_futex_value_locked(uaddr, 0, curtid);
  
	   if (!curval)
	      return 1;
	   if ((curval & FUTEX_TID_MASK) != ownertid) {
	      ownertid = curval & FUTEX_TID_MASK;
	      owner = update_owner(ownertid);
	   }

	   if (owner && futex_spin_on_owner(....))
	   .....

       }

> +/**
> + * futex_lock() - Acquire the lock and set the futex value
> + * @uaddr:  the futex user address
> + * @flags:  futex flags (FLAGS_SHARED, FLAGS_CLOCKRT, FLAGS_ADAPTIVE, etc.)
> + * @detect: detect deadlock (1) or not (0)
> + * @time:   absolute timeout
> + *
> + * futex_(un)lock() define a futex value policy and implement a full mutex. The
> + * futex value stores the owner's TID or'd with FUTEX_WAITERS and/or
> + * FUTEX_OWNER_DIED as appropriate.
> + *
> + * Userspace tried a 0 -> TID atomic transition of the futex value and failed.
> + * Try to acquire the lock in the kernel, blocking if necessary. Return to
> + * userspace with the lock held and the futex value set accordingly (or after a
> + * timeout).
> + *
> + * Returns:
> + *  0 - On success
> + * <0 - On error
> + */
> +static int futex_lock(u32 __user *uaddr, int flags, int detect, ktime_t *time)
> +{
> +	struct hrtimer_sleeper timeout, *to = NULL;
> +	struct futex_hash_bucket *hb;
> +	struct futex_q q = FUTEX_Q_INIT;
> +	int ret = 0;
> +
> +	if (refill_pi_state_cache())
> +		return -ENOMEM;
> +
> +	if (time) {
> +		to = &timeout;
> +		hrtimer_init_on_stack(&to->timer, CLOCK_REALTIME,
> +				      HRTIMER_MODE_ABS);

  Please make that like the WAIT_BITSET one, which can select the
  clock and defaults to MONOTONIC.

> +		hrtimer_init_sleeper(to, current);
> +		hrtimer_set_expires(&to->timer, *time);
> +	}

  Why setup all this _before_ trying the adaptive spin ?

> +retry:
> +#ifdef CONFIG_SMP
> +	if (flags & FLAGS_ADAPTIVE) {

  Why do we want that non adaptive version at all ?

> +		preempt_disable();
> +		ret = trylock_futex_adaptive(uaddr);
> +		preempt_enable();
> +
> +		/* We got the lock. */
> +		if (ret == 1) {
> +			ret = 0;
> +			goto out;
> +		}
> +
> +		/* We encountered an error, -EFAULT most likely. */
> +		if (ret)
> +			goto out;
> +	}
> +#endif
> +	q.key = FUTEX_KEY_INIT;
> +	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q.key);
> +	if (unlikely(ret != 0))
> +		goto out;
> +
> +	hb = queue_lock(&q);
> +
> +	ret = lock_futex_atomic(uaddr, current, 0);
> +	if (unlikely(ret)) {
> +		switch (ret) {
> +		case 1:
> +			/* We got the lock. */
> +			ret = 0;
> +			goto out_unlock_put_key;
> +		case -EFAULT:
> +			goto uaddr_faulted;
> +		default:
> +			goto out_unlock_put_key;
> +		}
> +	}
> +	/*
> +	 * Only actually queue now that the atomic ops are done:
> +	 */
> +	futex_wait_queue_me(hb, &q, to);
> +
> +	ret = unqueue_me(&q);
> +
> +	/* If we were woken by the owner, try and acquire the lock. */
> +	if (!ret)
> +		goto retry;
> +
> +	ret = -ETIMEDOUT;
> +	if (to && !to->task)
> +		goto out_put_key;
> +
> +	/*
> +	 * We expect signal_pending(current), but we might be the
> +	 * victim of a spurious wakeup as well.
> +         */
> +	ret = -ERESTARTNOINTR;
> +	if (!signal_pending(current)) {
> +		put_futex_key(&q.key);
> +		goto retry;
> +	}
> +
> +	goto out_put_key;
> +
> +out_unlock_put_key:
> +	queue_unlock(&q, hb);
> +
> +out_put_key:
> +	put_futex_key(&q.key);
> +out:
> +	if (to)
> +		destroy_hrtimer_on_stack(&to->timer);
> +	return ret != -EINTR ? ret : -ERESTARTNOINTR;

  Which code sets -EINTR ?

> +
> +uaddr_faulted:
> +	queue_unlock(&q, hb);
> +
> +	ret = fault_in_user_writeable(uaddr);
> +	if (ret)
> +		goto out_put_key;
> +
> +	put_futex_key(&q.key);
> +	goto retry;
> +}
> +
> +
>  /*
>   * Support for robust futexes: the kernel cleans up held futexes at
>   * thread exit time.
> @@ -2623,6 +2830,12 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
>  	case FUTEX_CMP_REQUEUE_PI:
>  		ret = futex_requeue(uaddr, flags, uaddr2, val, val2, &val3, 1);
>  		break;
> +	case FUTEX_LOCK_ADAPTIVE:
> +		flags |= FLAGS_ADAPTIVE;
> +	case FUTEX_LOCK:
> +		if (futex_cmpxchg_enabled)
> +			ret = futex_lock(uaddr, flags, val, timeout);
> +		break;
>  	default:
>  		ret = -ENOSYS;
>  	}
> @@ -2641,7 +2854,8 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
>  
>  	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
>  		      cmd == FUTEX_WAIT_BITSET ||
> -		      cmd == FUTEX_WAIT_REQUEUE_PI)) {
> +		      cmd == FUTEX_WAIT_REQUEUE_PI ||
> +		      cmd == FUTEX_LOCK || cmd == FUTEX_LOCK_ADAPTIVE)) {
>  		if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
>  			return -EFAULT;
>  		if (!timespec_valid(&ts))
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 9ab3cd7..a2dbb5b 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -3818,6 +3818,65 @@ int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
>  out:
>  	return 1;
>  }
> +
> +#ifdef CONFIG_FUTEX
> +#include <linux/futex.h>
> +
> +int futex_spin_on_owner(u32 __user *uaddr, struct thread_info *owner)
> +{
> +	unsigned int cpu;
> +	struct rq *rq;
> +
> +	if (!sched_feat(OWNER_SPIN))
> +		return 0;
> +
> +#ifdef CONFIG_DEBUG_PAGEALLOC
> +	/*
> +	 * Need to access the cpu field knowing that
> +	 * DEBUG_PAGEALLOC could have unmapped it if
> +	 * the mutex owner just released it and exited.
> +	 */
> +	if (probe_kernel_address(&owner->cpu, cpu))
> +		goto out;
> +#else
> +	cpu = owner->cpu;
> +#endif
> +
> +	/*
> +	 * Even if the access succeeded (likely case),
> +	 * the cpu field may no longer be valid.
> +	 */
> +	if (cpu >= nr_cpumask_bits)
> +		goto out;
> +
> +	/*
> +	 * We need to validate that we can do a
> +	 * get_cpu() and that we have the percpu area.
> +	 */
> +	if (!cpu_online(cpu))
> +		goto out;
> +
> +	rq = cpu_rq(cpu);
> +
> +	for (;;) {
> +		/*
> +		 * Owner changed, break to re-assess state.
> +		 */
> +		if (futex_owner(uaddr) != owner)
> +			break;

  Uurg. It's enough to check whether the TID value changed. No need to
  look up the full thing in every iteration.

> +		/*
> +		 * Is that owner really running on that cpu?
> +		 */
> +		if (task_thread_info(rq->curr) != owner || need_resched())
> +			return 0;
> +
> +		cpu_relax();
> +	}
> +out:
> +	return 1;
> +}
> +#endif
>  #endif

Do we really need all this code ? A simple owner->on_cpu (owner needs
to be the task_struct then) would be sufficient to figure that out,
wouldn't it?

Thanks,

	tglx

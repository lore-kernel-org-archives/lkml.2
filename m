Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab2GUJeF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 05:34:05 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:50859 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2GUJeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 05:34:03 -0400
Message-ID: <500A7701.6090104@linux.vnet.ibm.com>
Date: Sat, 21 Jul 2012 15:01:45 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [Patch 2/7] kthread: Implement park/unpark facility
References: <20120716103749.122800930@linutronix.de> <20120716103948.236618824@linutronix.de>
In-Reply-To: <20120716103948.236618824@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12072109-5140-0000-0000-000001C82ABC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2012 04:12 PM, Thomas Gleixner wrote:
> To avoid the full teardown/setup of per cpu kthreads in the case of
> cpu hot(un)plug, provide a facility which allows to put the kthread
> into a park position and unpark it when the cpu comes online again.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Reviewed-by: Namhyung Kim <namhyung@kernel.org>

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> ---
>  include/linux/kthread.h |   11 ++
>  kernel/kthread.c        |  185 +++++++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 176 insertions(+), 20 deletions(-)
> 
> Index: tip/include/linux/kthread.h
> ===================================================================
> --- tip.orig/include/linux/kthread.h
> +++ tip/include/linux/kthread.h
> @@ -14,6 +14,11 @@ struct task_struct *kthread_create_on_no
>  	kthread_create_on_node(threadfn, data, -1, namefmt, ##arg)
> 
> 
> +struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
> +					  void *data,
> +					  unsigned int cpu,
> +					  const char *namefmt);
> +
>  /**
>   * kthread_run - create and wake a thread.
>   * @threadfn: the function to run until signal_pending(current).
> @@ -34,9 +39,13 @@ struct task_struct *kthread_create_on_no
> 
>  void kthread_bind(struct task_struct *k, unsigned int cpu);
>  int kthread_stop(struct task_struct *k);
> -int kthread_should_stop(void);
> +bool kthread_should_stop(void);
> +bool kthread_should_park(void);
>  bool kthread_freezable_should_stop(bool *was_frozen);
>  void *kthread_data(struct task_struct *k);
> +int kthread_park(struct task_struct *k);
> +void kthread_unpark(struct task_struct *k);
> +void kthread_parkme(void);
> 
>  int kthreadd(void *unused);
>  extern struct task_struct *kthreadd_task;
> Index: tip/kernel/kthread.c
> ===================================================================
> --- tip.orig/kernel/kthread.c
> +++ tip/kernel/kthread.c
> @@ -37,11 +37,20 @@ struct kthread_create_info
>  };
> 
>  struct kthread {
> -	int should_stop;
> +	unsigned long flags;
> +	unsigned int cpu;
>  	void *data;
> +	struct completion parked;
>  	struct completion exited;
>  };
> 
> +enum KTHREAD_BITS {
> +	KTHREAD_IS_PER_CPU = 0,
> +	KTHREAD_SHOULD_STOP,
> +	KTHREAD_SHOULD_PARK,
> +	KTHREAD_IS_PARKED,
> +};
> +
>  #define to_kthread(tsk)	\
>  	container_of((tsk)->vfork_done, struct kthread, exited)
> 
> @@ -52,13 +61,29 @@ struct kthread {
>   * and this will return true.  You should then return, and your return
>   * value will be passed through to kthread_stop().
>   */
> -int kthread_should_stop(void)
> +bool kthread_should_stop(void)
>  {
> -	return to_kthread(current)->should_stop;
> +	return test_bit(KTHREAD_SHOULD_STOP, &to_kthread(current)->flags);
>  }
>  EXPORT_SYMBOL(kthread_should_stop);
> 
>  /**
> + * kthread_should_park - should this kthread park now?
> + *
> + * When someone calls kthread_park() on your kthread, it will be woken
> + * and this will return true.  You should then do the necessary
> + * cleanup and call kthread_parkme()
> + *
> + * Similar to kthread_should_stop(), but this keeps the thread alive
> + * and in a park position. kthread_unpark() "restarts" the thread and
> + * calls the thread function again.
> + */
> +bool kthread_should_park(void)
> +{
> +	return test_bit(KTHREAD_SHOULD_PARK, &to_kthread(current)->flags);
> +}
> +
> +/**
>   * kthread_freezable_should_stop - should this freezable kthread return now?
>   * @was_frozen: optional out parameter, indicates whether %current was frozen
>   *
> @@ -96,6 +121,24 @@ void *kthread_data(struct task_struct *t
>  	return to_kthread(task)->data;
>  }
> 
> +static void __kthread_parkme(struct kthread *self)
> +{
> +	__set_current_state(TASK_INTERRUPTIBLE);
> +	while (test_bit(KTHREAD_SHOULD_PARK, &self->flags)) {
> +		if (!test_and_set_bit(KTHREAD_IS_PARKED, &self->flags))
> +			complete(&self->parked);
> +		schedule();
> +		__set_current_state(TASK_INTERRUPTIBLE);
> +	}
> +	clear_bit(KTHREAD_IS_PARKED, &self->flags);
> +	__set_current_state(TASK_RUNNING);
> +}
> +
> +void kthread_parkme(void)
> +{
> +	__kthread_parkme(to_kthread(current));
> +}
> +
>  static int kthread(void *_create)
>  {
>  	/* Copy data: it's on kthread's stack */
> @@ -105,9 +148,10 @@ static int kthread(void *_create)
>  	struct kthread self;
>  	int ret;
> 
> -	self.should_stop = 0;
> +	self.flags = 0;
>  	self.data = data;
>  	init_completion(&self.exited);
> +	init_completion(&self.parked);
>  	current->vfork_done = &self.exited;
> 
>  	/* OK, tell user we're spawned, wait for stop or wakeup */
> @@ -117,9 +161,11 @@ static int kthread(void *_create)
>  	schedule();
> 
>  	ret = -EINTR;
> -	if (!self.should_stop)
> -		ret = threadfn(data);
> 
> +	if (!test_bit(KTHREAD_SHOULD_STOP, &self.flags)) {
> +		__kthread_parkme(&self);
> +		ret = threadfn(data);
> +	}
>  	/* we can't just return, we must preserve "self" on stack */
>  	do_exit(ret);
>  }
> @@ -172,8 +218,7 @@ static void create_kthread(struct kthrea
>   * Returns a task_struct or ERR_PTR(-ENOMEM).
>   */
>  struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
> -					   void *data,
> -					   int node,
> +					   void *data, int node,
>  					   const char namefmt[],
>  					   ...)
>  {
> @@ -210,6 +255,13 @@ struct task_struct *kthread_create_on_no
>  }
>  EXPORT_SYMBOL(kthread_create_on_node);
> 
> +static void __kthread_bind(struct task_struct *p, unsigned int cpu)
> +{
> +	/* It's safe because the task is inactive. */
> +	do_set_cpus_allowed(p, cpumask_of(cpu));
> +	p->flags |= PF_THREAD_BOUND;
> +}
> +
>  /**
>   * kthread_bind - bind a just-created kthread to a cpu.
>   * @p: thread created by kthread_create().
> @@ -226,14 +278,112 @@ void kthread_bind(struct task_struct *p,
>  		WARN_ON(1);
>  		return;
>  	}
> -
> -	/* It's safe because the task is inactive. */
> -	do_set_cpus_allowed(p, cpumask_of(cpu));
> -	p->flags |= PF_THREAD_BOUND;
> +	__kthread_bind(p, cpu);
>  }
>  EXPORT_SYMBOL(kthread_bind);
> 
>  /**
> + * kthread_create_on_cpu - Create a cpu bound kthread
> + * @threadfn: the function to run until signal_pending(current).
> + * @data: data ptr for @threadfn.
> + * @cpu: The cpu on which the thread should be bound,
> + * @namefmt: printf-style name for the thread. Format is restricted
> + *	     to "name.*%u". Code fills in cpu number.
> + *
> + * Description: This helper function creates and names a kernel thread
> + * The thread will be woken and put into park mode.
> + */
> +struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
> +					  void *data, unsigned int cpu,
> +					  const char *namefmt)
> +{
> +	struct task_struct *p;
> +
> +	p = kthread_create_on_node(threadfn, data, cpu_to_node(cpu), namefmt,
> +				   cpu);
> +	if (IS_ERR(p))
> +		return p;
> +	set_bit(KTHREAD_IS_PER_CPU, &to_kthread(p)->flags);
> +	to_kthread(p)->cpu = cpu;
> +	/* Park the thread to get it out of TASK_UNINTERRUPTIBLE state */
> +	kthread_park(p);
> +	return p;
> +}
> +
> +static struct kthread *task_get_live_kthread(struct task_struct *k)
> +{
> +	struct kthread *kthread;
> +
> +	get_task_struct(k);
> +	kthread = to_kthread(k);
> +	/* It might have exited */
> +	barrier();
> +	if (k->vfork_done != NULL)
> +		return kthread;
> +	return NULL;
> +}
> +
> +/**
> + * kthread_unpark - unpark a thread created by kthread_create().
> + * @k:		thread created by kthread_create().
> + *
> + * Sets kthread_should_park() for @k to return false, wakes it, and
> + * waits for it to return. If the thread is marked percpu then its
> + * bound to the cpu again.
> + */
> +void kthread_unpark(struct task_struct *k)
> +{
> +	struct kthread *kthread = task_get_live_kthread(k);
> +
> +	if (kthread) {
> +		clear_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
> +		/*
> +		 * We clear the IS_PARKED bit here as we don't wait
> +		 * until the task has left the park code. So if we'd
> +		 * park before that happens we'd see the IS_PARKED bit
> +		 * which might be about to be cleared.
> +		 */
> +		if (test_and_clear_bit(KTHREAD_IS_PARKED, &kthread->flags)) {
> +			if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags))
> +				__kthread_bind(k, kthread->cpu);
> +			wake_up_process(k);
> +		}
> +	}
> +	put_task_struct(k);
> +}
> +
> +/**
> + * kthread_park - park a thread created by kthread_create().
> + * @k: thread created by kthread_create().
> + *
> + * Sets kthread_should_park() for @k to return true, wakes it, and
> + * waits for it to return. This can also be called after kthread_create()
> + * instead of calling wake_up_process(): the thread will park without
> + * calling threadfn().
> + *
> + * Returns 0 if the thread is parked, -ENOSYS if the thread exited.
> + * If called by the kthread itself just the park bit is set.
> + */
> +int kthread_park(struct task_struct *k)
> +{
> +	struct kthread *kthread = task_get_live_kthread(k);
> +	int ret = -ENOSYS;
> +
> +	if (kthread) {
> +		if (!test_bit(KTHREAD_IS_PARKED, &kthread->flags)) {
> +			set_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
> +			if (k != current) {
> +				wake_up_process(k);
> +				wait_for_completion(&kthread->parked);
> +			}
> +		}
> +		ret = 0;
> +	}
> +	put_task_struct(k);
> +	return ret;
> +}
> +
> +/**
>   * kthread_stop - stop a thread created by kthread_create().
>   * @k: thread created by kthread_create().
>   *
> @@ -250,16 +400,13 @@ EXPORT_SYMBOL(kthread_bind);
>   */
>  int kthread_stop(struct task_struct *k)
>  {
> -	struct kthread *kthread;
> +	struct kthread *kthread = task_get_live_kthread(k);
>  	int ret;
> 
>  	trace_sched_kthread_stop(k);
> -	get_task_struct(k);
> -
> -	kthread = to_kthread(k);
> -	barrier(); /* it might have exited */
> -	if (k->vfork_done != NULL) {
> -		kthread->should_stop = 1;
> +	if (kthread) {
> +		set_bit(KTHREAD_SHOULD_STOP, &kthread->flags);
> +		clear_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
>  		wake_up_process(k);
>  		wait_for_completion(&kthread->exited);
>  	}
> 
> 


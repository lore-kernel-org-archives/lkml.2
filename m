Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab2FNCe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 22:34:59 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52945 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab2FNCe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 22:34:58 -0400
X-AuditID: 9c93016f-b7c3cae000001954-71-4fd94dcf923d
From: Namhyung Kim <namhyung@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 1/5] kthread: Implement park/unpark facility
References: <20120613102823.373180763@linutronix.de>
	<20120613105815.132283147@linutronix.de>
Date: Thu, 14 Jun 2012 11:32:06 +0900
In-Reply-To: <20120613105815.132283147@linutronix.de> (Thomas Gleixner's
	message of "Wed, 13 Jun 2012 11:00:54 -0000")
Message-ID: <8762au62u1.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Thomas

A nitpick and questions. :)


On Wed, 13 Jun 2012 11:00:54 -0000, Thomas Gleixner wrote:
> To avoid the full teardown/setup of per cpu kthreads in the case of
> cpu hot(un)plug, provide a facility which allows to put the kthread
> into a park position and unpark it when the cpu comes online again.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
[snip]
>  
>  /**
> + * kthread_create_on_cpu - Create a cpu bound kthread
> + * @threadfn: the function to run until signal_pending(current).
> + * @data: data ptr for @threadfn.
> + * @node: memory node number.

Should be @cpu.


> + * @namefmt: printf-style name for the thread.
> + *
> + * Description: This helper function creates and names a kernel thread
> + * and binds it to a given CPU. The thread will be woken and put into
> + * park mode.
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
> +	/* Park the thread, mark it percpu and then bind it */
> +	kthread_park(p);

Why park? AFAIK the p is not running after creation, so binding it
doesn't need parking, right?


> +	set_bit(KTHREAD_IS_PER_CPU, &to_kthread(p)->flags);
> +	to_kthread(p)->cpu = cpu;
> +	__kthread_bind(p, cpu);
> +	return p;
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
> +	struct kthread *kthread;
> +
> +	get_task_struct(k);
> +
> +	kthread = to_kthread(k);
> +	barrier(); /* it might have exited */
> +	if (k->vfork_done != NULL) {

Does is guarantee it's not exited? If so, as it is used a couple of
times, wouldn't it be better making it up a (static?) helper (with
comments, hopefully) something like a kthread_is_alive() ?


> +		clear_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
> +		if (test_bit(KTHREAD_IS_PARKED, &kthread->flags)) {
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
> +	struct kthread *kthread;
> +	int ret = -ENOSYS;
> +
> +	get_task_struct(k);
> +
> +	kthread = to_kthread(k);
> +	barrier(); /* it might have exited */
> +	if (k->vfork_done != NULL) {
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
> @@ -259,7 +398,7 @@ int kthread_stop(struct task_struct *k)
>  	kthread = to_kthread(k);
>  	barrier(); /* it might have exited */
>  	if (k->vfork_done != NULL) {
> -		kthread->should_stop = 1;
> +		set_bit(KTHREAD_SHOULD_STOP, &kthread->flags);

I wonder whether it also needs to unpark @k. Isn't it possible to stop a
parked thread?

Thanks,
Namhyung


>  		wake_up_process(k);
>  		wait_for_completion(&kthread->exited);
>  	}

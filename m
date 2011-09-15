Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab1IORcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 13:32:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40935 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574Ab1IORcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 13:32:03 -0400
Message-ID: <4E7235F6.1030303@colorfullife.com>
Date: Thu, 15 Sep 2011 19:29:26 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC][PATCH 3/3] ipc/sem: Rework wakeup scheme
References: <20110914133034.687048806@chello.nl> <20110914133750.916911903@chello.nl>
In-Reply-To: <20110914133750.916911903@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,


On 09/14/2011 03:30 PM, Peter Zijlstra wrote:
> This removes the home-brew busy-wait and the requirement to keep
> preemption disabled.
In the initial mail of the patch series, you write:

>  Patch 3 converts sysv sems, and is broken


What is broken?

>
>   /**
>    * newary - Create a new semaphore set
> @@ -406,51 +388,39 @@ static int try_atomic_semop (struct sem_
>   	return result;
>   }
>
> -/** wake_up_sem_queue_prepare(q, error): Prepare wake-up
> +/** wake_up_sem_queue_prepare(wake_list, q, error): Prepare wake-up
> + * @wake_list: list to queue the to be woken task on
>    * @q: queue entry that must be signaled
>    * @error: Error value for the signal
>    *
>    * Prepare the wake-up of the queue entry q.
>    */
> -static void wake_up_sem_queue_prepare(struct list_head *pt,
> +static void wake_up_sem_queue_prepare(struct wake_list_head *wake_list,
>   				struct sem_queue *q, int error)
>   {
> -	if (list_empty(pt)) {
> -		/*
> -		 * Hold preempt off so that we don't get preempted and have the
> -		 * wakee busy-wait until we're scheduled back on.
> -		 */
> -		preempt_disable();
> -	}
> -	q->status = IN_WAKEUP;
> -	q->pid = error;
> +	struct task_struct *p = ACCESS_ONCE(q->sleeper);
>
> -	list_add_tail(&q->simple_list, pt);
> +	get_task_struct(p);
> +	q->status = error;
> +	/*
> +	 * implies a full barrier
> +	 */
> +	wake_list_add(wake_list, p);
> +	put_task_struct(p);
>   }
I think the get_task_struct()/put_task_struct is not necessary:
Just do the wake_list_add() before writing q->status:
wake_list_add() is identical to list_add_tail(&q->simple_list, pt).
[except that it contains additional locking, which doesn't matter here]

>
>   /**
> - * wake_up_sem_queue_do(pt) - do the actual wake-up
> - * @pt: list of tasks to be woken up
> + * wake_up_sem_queue_do(wake_list) - do the actual wake-up
> + * @wake_list: list of tasks to be woken up
>    *
>    * Do the actual wake-up.
>    * The function is called without any locks held, thus the semaphore array
>    * could be destroyed already and the tasks can disappear as soon as the
>    * status is set to the actual return code.
>    */
> -static void wake_up_sem_queue_do(struct list_head *pt)
> +static void wake_up_sem_queue_do(struct wake_list_head *wake_list)
>   {
> -	struct sem_queue *q, *t;
> -	int did_something;
> -
> -	did_something = !list_empty(pt);
> -	list_for_each_entry_safe(q, t, pt, simple_list) {
> -		wake_up_process(q->sleeper);
> -		/* q can disappear immediately after writing q->status. */
> -		smp_wmb();
> -		q->status = q->pid;
> -	}
> -	if (did_something)
> -		preempt_enable();
> +	wake_up_list(wake_list, TASK_ALL);
>   }
>   
wake_up_list() calls wake_up_state() that calls try_to_wake_up().
try_to_wake_up() seems to return immediately when the state is TASK_DEAD.

That leaves: Is it safe to call wake_up_list() in parallel with do_exit()?
The current implementation avoids that.

--
     Manfred

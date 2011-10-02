Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab1JBNzI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 09:55:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34894 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab1JBNzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 09:55:04 -0400
Message-ID: <4E886ED5.8060407@colorfullife.com>
Date: Sun, 02 Oct 2011 16:01:57 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC][PATCH 1/3] sched: Provide delayed wakeup list
References: <20110914133034.687048806@chello.nl> <20110914133750.739484417@chello.nl>
In-Reply-To: <20110914133750.739484417@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Do you still work on the wake_up_list() patch?

On 09/14/2011 03:30 PM, Peter Zijlstra wrote:
>   /*
>    * wake flags
>    */
> @@ -1255,6 +1268,8 @@ struct task_struct {
>   	unsigned int btrace_seq;
>   #endif
>
> +	struct wake_list_node wake_list;
> +
>   	unsigned int policy;
>   	cpumask_t cpus_allowed;
A global wake_list
>
> @@ -2143,6 +2158,35 @@ extern void wake_up_new_task(struct task
>   extern void sched_fork(struct task_struct *p);
>   extern void sched_dead(struct task_struct *p);
>
> +static inline void
> +wake_list_add(struct wake_list_head *head, struct task_struct *p)
> +{
> +	struct wake_list_node *n =&p->wake_list;
> +
> +	get_task_struct(p);
> +	/*
> +	 * Atomically grab the task, if ->wake_list is !0 already it means
> +	 * its already queued (either by us or someone else) and will get the
> +	 * wakeup due to that.
> +	 *
> +	 * This cmpxchg() implies a full barrier, which pairs with the write
> +	 * barrier implied by the wakeup in wake_up_list().
> +	 */
> +	if (cmpxchg(&n->next, 0, n) != 0) {
> +		/* It was already queued, drop the extra ref and we're done. */
> +		put_task_struct(p);
> +		return;
> +	}
> +
A task can be only once on the wake_list.
> +	/*
> +	 * The head is context local, there can be no concurrency.
> +	 */
> +	n->next = head->first;
> +	head->first = n;
> +}
> +
> +extern void wake_up_list(struct wake_list_head *head, unsigned int state);
> +
>   extern void proc_caches_init(void);
>   extern void flush_signals(struct task_struct *);
>   extern void __flush_signals(struct task_struct *);
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -2916,6 +2916,25 @@ int wake_up_state(struct task_struct *p,
>   	return try_to_wake_up(p, state, 0);
>   }
>
> +void wake_up_list(struct wake_list_head *head, unsigned int state)
> +{
> +	struct wake_list_node *n = head->first;
> +	struct task_struct *p;
> +
> +	while (n != WAKE_LIST_TAIL) {
> +		p = container_of(n, struct task_struct, wake_list);
> +		n = n->next;
> +
> +		p->wake_list.next = NULL;
> +		/*
> +		 * wake_up_state() implies a wmb() to pair with the queueing
> +		 * in wake_list_add() so as not to miss wakeups.
> +		 */
> +		wake_up_state(p, state);
> +		put_task_struct(p);
> +	}
> +}
And wake_up_list() uses state.
That can't work:
What if one waker wants to wake TASK_INTERRUPTIBLE and the other waker 
wants to wake TASK_UNINTERRUPTIBLE|TASK_INTERRUPTIBLE?

--
     Manfred

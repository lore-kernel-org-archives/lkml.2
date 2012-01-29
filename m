Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab2A2TGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 14:06:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684Ab2A2TGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 14:06:20 -0500
Date: Sun, 29 Jan 2012 19:59:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, y-goto@jp.fujitsu.com,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Fix ancient race in do_exit()
Message-ID: <20120129185949.GA27192@redhat.com>
References: <20120117174031.3118.E1E9C6FF@jp.fujitsu.com> <tip-b5740f4b2cb3503b436925eb2242bc3d75cd3dfe@git.kernel.org> <CA+55aFyO0KxGQxYYUqmVrNqG6qVFnRT2g-kYYKtH5QG3vTnO=A@mail.gmail.com> <20120129160711.GA20803@redhat.com> <CA+55aFz20=H0ZubZEAmEbv0gL8j3C5Kgt4m2+5MU63uVipZt0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz20=H0ZubZEAmEbv0gL8j3C5Kgt4m2+5MU63uVipZt0Q@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29, Linus Torvalds wrote:
>
> But yes, if you're talking about TASK_UNINTERRUPTIBLE, we do need to
> just remove the setting of that entirely. It needs to be set *before*
> adding us to the list, not after. That's just a bug - we get woken up
> when we've been given the lock.

Yes, I think this should work although I am not familiar with this code.

If we remove set_task_state() from the main waiting loop we can never race
with __rwsem_do_wake()->try_to_wake_up() seeing us in UNINTERRUPTIBLE state.
rwsem_down_failed_common() simply can't return until UNINTERRUPTIBLE->RUNNING
transition is finished (__rwsem_do_wake does wakeup first).

And since we do not play with current->state after spin_unlock(), it is
fine to "race" with waiter->task clearing, just we can do the unnecessary
but harmless schedule() in TASK_RUNNING.

> So it may be completely and utterly broken for some subtle reason,

Well, what about another spurious wakeup from somewhere? In this case
rwsem_down_failed_common() will do a busy-wait loop.

> @@ -92,10 +92,9 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
>  	 */
>  	list_del(&waiter->list);
>  	tsk = waiter->task;
> +	wake_up_process(tsk);
>  	smp_mb();
>  	waiter->task = NULL;

OK, now I understand why do we need "clear after wakeup".

But then I don't really understand this mb, perhaps wmb() is enough?
Afaics we only need to ensure we change waiter->task after changing
task's state.

OTOH,

> @@ -183,7 +181,6 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
>  	raw_spin_lock_irq(&sem->wait_lock);
>  	waiter.task = tsk;
>  	waiter.flags = flags;
> -	get_task_struct(tsk);
>
>  	if (list_empty(&sem->wait_list))
>  		adjustment += RWSEM_WAITING_BIAS;
> @@ -211,11 +208,8 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
>  		if (!waiter.task)
>  			break;
>  		schedule();
> -		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
>  	}
>
> -	tsk->state = TASK_RUNNING;
> -
>  	return sem;
>  }

Suppose that this task does tsk->state = TASK_WHATEVER after that.
It seems that we need mb() before return, otherwise the next ->state
change can be reordered with "if (!waiter.task)" above. Or not?

Oleg.


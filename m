Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab1AEQnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 11:43:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab1AEQnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 11:43:00 -0500
Date: Wed, 5 Jan 2011 17:35:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 7/7] ptrace: clean transitions between TASK_STOPPED and
	TRACED
Message-ID: <20110105163542.GA19474@redhat.com>
References: <1293199257-11255-1-git-send-email-tj@kernel.org> <1293199257-11255-8-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293199257-11255-8-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To me, the whole series is fine.

As for the user-visible changes, I believe they are carefully documented,
hopefully Roland and Jan can take a look.


This patch looks good too, a couple of minor nits below.

On 12/24, Tejun Heo wrote:
>
> + * task_clear_group_stop_trapping - clear group stop trapping bit
> + * @task: target task
> + *
> + * If GROUP_STOP_TRAPPING is set, a ptracer is waiting for us.  Clear it
> + * and wake up the ptracer.  Note that we don't need any further locking.
> + * @task->siglock guarantees that @task->parent points to the ptracer.
> + *
> + * CONTEXT:
> + * Must be called with @task->sighand->siglock held.
> + */
> +static void task_clear_group_stop_trapping(struct task_struct *task)
> +{
> +	if (unlikely(task->group_stop & GROUP_STOP_TRAPPING)) {
> +		task->group_stop &= ~GROUP_STOP_TRAPPING;
> +		__wake_up_sync(&task->parent->signal->wait_chldexit,
> +			       TASK_UNINTERRUPTIBLE, 1);

OK... we are doing __wake_up_sync_key(key => NULL), this looks unfriendly
to child_wait_callback(). But TASK_UNINTERRUPTIBLE means we can't abuse
the tracer's subthreads doing do_wait().

>  void task_clear_group_stop(struct task_struct *task)
>  {
>  	task->group_stop &= ~(GROUP_STOP_PENDING | GROUP_STOP_CONSUME);
> +	task_clear_group_stop_trapping(task);
>  }

Not a comment, but the question. I am not sure task_clear_group_stop()
needs task_clear_group_stop_trapping(), please see below...

> @@ -1694,6 +1716,14 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
>  	}
>  
>  	/*
> +	 * We're committing to trapping.  Clearing GROUP_STOP_TRAPPING and
> +	 * transition to TASK_TRACED should be atomic with respect to
> +	 * siglock.  Do it after the arch hook as siglock is released and
> +	 * regrabbed across it.
> +	 */
> +	task_clear_group_stop_trapping(current);

This wakes up the tracer. It can return from sys_ptrace(), call do_wait(),
and take tasklist_lock before us.

Of course, this is only theoretical problem, but perhaps it makes sense
to do this after __set_current_state(TASK_TRACED), otherwise
task_stopped_code() can fail.

> @@ -1839,13 +1875,25 @@ static int do_signal_stop(int signr)
>  		schedule();
>
>  		spin_lock_irq(&current->sighand->siglock);
> -	} else
> -		ptrace_stop(current->exit_code, CLD_STOPPED, 0, NULL);
> +	} else {
> +		ptrace_stop(current->group_stop & GROUP_STOP_SIGMASK,
> +			    CLD_STOPPED, 0, NULL);
> +		current->exit_code = 0;
> +	}
> +
> +	/*
> +	 * GROUP_STOP_PENDING could be set if another group stop has
> +	 * started since being woken up or ptrace wants us to transit
> +	 * between TASK_STOPPED and TRACED.  Retry group stop.
> +	 */
> +	if (current->group_stop & GROUP_STOP_PENDING) {
> +		WARN_ON_ONCE(!(current->group_stop & GROUP_STOP_SIGMASK));
> +		goto retry;
> +	}
>
>  	spin_unlock_irq(&current->sighand->siglock);

Can't we add task_clear_group_stop_trapping() right before we drop
->siglock ? This way we can remove it from task_clear_group_stop(),
afaics. Once again, this is up to you. Looks more clean to me, but
this is of course subjective.

If GROUP_STOP_PENDING is not set, but GROUP_STOP_TRAPPING is set,
then this task was SIGKILL'ed or SIGCONT'ed, we can notify the
tracer.

Otherwise (ignoring ptrace_stop), there is no reasons to check
GROUP_STOP_TRAPPING. It was set under ->siglock when the tracee
was in TASK_STOPPED state few lines above.

Oleg.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab0K1Uck (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 15:32:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab0K1Ucj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 15:32:39 -0500
Date: Sun, 28 Nov 2010 21:25:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "rjw@sisk.plpavel"@ucw.cz, Jan Kratochvil <jan.kratochvil@redhat.com>
Subject: Re: [PATCH 09/14] ptrace: clean transitions between TASK_STOPPED
	and TRACED
Message-ID: <20101128202535.GC12896@redhat.com>
References: <1290768569-16224-1-git-send-email-tj@kernel.org> <1290768569-16224-10-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290768569-16224-10-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26, Tejun Heo wrote:
>
> Currently, if the task is STOPPED on ptrace attach, it's left alone
> and the state is silently changed to TRACED on the next ptrace call.
> The behavior breaks the assumption that arch_ptrace_stop() is called
> before any task is poked by ptrace operations and is ugly in that a
> task manipulates the state of another task directly.
>
> With GROUP_STOP_PENDING, the transitions between TASK_STOPPED and
> TRACED can be made clean.  The tracer can use the flag to tell the
> tracee to retry stop on attach and detach.  On retry, the tracee will
> enter the desired state the correct way.  The lower 16bits of
> task->group_stop is used to remember the signal number which caused
> the last group stop.  This is used while retrying for ptrace attach as
> the original group_exit_code could have been consumed with wait(2) by
> then.

This adds another user-visible change, this time it is more serious.
Again, I do not claim it breaks ptrace, just I do not know.

> @@ -204,6 +202,19 @@ int ptrace_attach(struct task_struct *task)
>  	__ptrace_link(task, current);
>  	send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
>
> +	/*
> +	 * If the task is already STOPPED, set GROUP_STOP_PENDING and
> +	 * kick it so that it transits to TRACED.  This is safe as
> +	 * both transitions in and out of STOPPED are protected by
> +	 * siglock.
> +	 */
> +	spin_lock(&task->sighand->siglock);
> +	if (task_is_stopped(task)) {
> +		task->group_stop |= GROUP_STOP_PENDING;
> +		signal_wake_up(task, 1);

OK. Now we have a window if the tracer attaches to the stopped task.

Say,

	child = fork()

	if (!child)
		return child_do_something();

	kill(child, SIGSTOP);
	wait();			// <--- ensures it is stopped

	ptrace(PTRACE_ATTACH, child);

	assert(ptrace(PTRACE_WHATEVER, child) == 0);

Currently this code is correct. With this patch the assertion above
can fail, the child may be running, changing its state from STOPPED
to TRACED.


> @@ -1793,7 +1797,7 @@ static int do_signal_stop(int signr)
>
>  	if (consume_group_stop())
>  		sig->flags = SIGNAL_STOP_STOPPED;
> -
> +retry:
>  	current->exit_code = sig->group_exit_code;
>  	current->group_stop &= ~GROUP_STOP_PENDING;
>  	__set_current_state(TASK_STOPPED);
> @@ -1805,6 +1809,7 @@ static int do_signal_stop(int signr)
>  			read_lock(&tasklist_lock);
>  			do_notify_parent_cldstop(current, notify);
>  			read_unlock(&tasklist_lock);
> +			notify = 0;
>  		}
>
>  		/* Now we don't run again until woken by SIGCONT or SIGKILL */
> @@ -1812,7 +1817,13 @@ static int do_signal_stop(int signr)
>
>  		spin_lock_irq(&current->sighand->siglock);
>  	} else
> -		ptrace_stop(current->exit_code, CLD_STOPPED, 0, NULL);
> +		ptrace_stop(current->group_stop & GROUP_STOP_SIGMASK,
> +			    CLD_STOPPED, 0, NULL);
> +
> +	if (current->group_stop & GROUP_STOP_PENDING) {
> +		WARN_ON_ONCE(!(current->group_stop & GROUP_STOP_SIGMASK));
> +		goto retry;

This doesn't look right even without ptrace.

Suppose we have to threads, T1 and T2, both stopped, SIGNAL_STOP_STOPPED
is set.

SIGCONT wakes them up.

To simplify the discussion, suppose that T1 takes a long preemption
when it returns from schedule(), right before it takes ->siglock again.

T2 sends CLD_CONTINUED to parent and dequeues another SIGSTOP. It
initiates another group stop, sees T1 as running,  and stops with
->group_stop_count == 1. Now we are waiting for T1 which should
participate.

Finally T1 resumes and sees GROUP_STOP_PENDING. It goes to 'retry:'
and stops, but nobody notifies the parent ang ->group_stop_count is
still non-zero.

Oleg.


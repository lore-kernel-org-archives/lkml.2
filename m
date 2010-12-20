Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab0LTPHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:07:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932614Ab0LTPHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:07:37 -0500
Date: Mon, 20 Dec 2010 16:00:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 10/16] ptrace: clean transitions between TASK_STOPPED
	and TRACED
Message-ID: <20101220150037.GE11583@redhat.com>
References: <1291654624-6230-1-git-send-email-tj@kernel.org> <1291654624-6230-11-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291654624-6230-11-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06, Tejun Heo wrote:
>
> @@ -93,6 +99,7 @@ int ptrace_check_attach(struct task_struct *child, int kill)
>  	 * we are sure that this is our traced child and that can only
>  	 * be changed by us so it's not changing right after this.
>  	 */
> +relock:
>  	read_lock(&tasklist_lock);
>  	if ((child->ptrace & PT_PTRACED) && child->parent == current) {
>  		ret = 0;
> @@ -101,10 +108,30 @@ int ptrace_check_attach(struct task_struct *child, int kill)
>  		 * does ptrace_unlink() before __exit_signal().
>  		 */
>  		spin_lock_irq(&child->sighand->siglock);
> -		if (task_is_stopped(child))
> -			child->state = TASK_TRACED;
> -		else if (!task_is_traced(child) && !kill)
> +		if (!task_is_traced(child) && !kill) {
> +			/*
> +			 * If GROUP_STOP_TRAPPING is set, it is known that
> +			 * the tracee will enter either TRACED or the bit
> +			 * will be cleared in definite amount of (userland)
> +			 * time.  Wait while the bit is set.
> +			 *
> +			 * This hides PTRACE_ATTACH initiated transition
> +			 * from STOPPED to TRACED from userland.
> +			 */
> +			if (child->group_stop & GROUP_STOP_TRAPPING) {
> +				const int bit = ilog2(GROUP_STOP_TRAPPING);
> +				DEFINE_WAIT_BIT(wait, &child->group_stop, bit);

Unused "wait_bit_queue wait"

> +
> +				spin_unlock_irq(&child->sighand->siglock);
> +				read_unlock(&tasklist_lock);
> +
> +				wait_on_bit(&child->group_stop, bit,

Hmm. we could probably use ->wait_chldexit/__wake_up_parent instead,
although I am not sure this would be more clean...

> +					    ptrace_wait_trap,
> +					    TASK_UNINTERRUPTIBLE);

I am nervous ;) To me, TASK_KILLABLE makes more sense, and it is
safer if we have a bug.

> +				goto relock;

We already set ret = 0. "relock" should set -ESRCH.

> +			}
>  			ret = -ESRCH;
> +		}

Probably this deserves a minor cleanup,

	relock:
		ret = -ESRCH;
		read_lock(&tasklist_lock);
		if (task_is_traced() || kill) {
			ret = 0;
		} else {
		...


OK. So, ptrace_attach() asks a stopped tracee to s/STOPPED/TRACED/.
If it is not stopped, it should call ptrace_stop() eventually.

This doesn't work if ptrace_attach() races with clone(CLONE_STOPPED).
ptrace_check_attach() can return the wrong ESRCH after that. Perhaps
it is time to kill the CLONE_STOPPED code in do_fork().

> @@ -204,6 +231,26 @@ int ptrace_attach(struct task_struct *task)
>  	__ptrace_link(task, current);
>  	send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
>
> +	spin_lock(&task->sighand->siglock);
> +
> +	/*
> +	 * If the task is already STOPPED, set GROUP_STOP_PENDING and
> +	 * TRAPPING, and kick it so that it transits to TRACED.  TRAPPING
> +	 * will be cleared if the child completes the transition or any
> +	 * event which clears the group stop states happens.  The bit is
> +	 * waited by ptrace_check_attach() to hide the transition from
> +	 * userland.
> +	 *
> +	 * The following is safe as both transitions in and out of STOPPED
> +	 * are protected by siglock.
> +	 */
> +	if (task_is_stopped(task)) {
> +		task->group_stop |= GROUP_STOP_PENDING | GROUP_STOP_TRAPPING;
> +		signal_wake_up(task, 1);
> +	}
> +
> +	spin_unlock(&task->sighand->siglock);

Well. I do not know whether this matters, but "hide the transition from
userland" is not 100% correct. I mean, this change is still visible.

ptrace_check_attach()->wait_on_bit() logic fixes the previous example,
but:

	1. the tracer knows that the tracee is stopped

	2. the tracer does ptrace(ATTACH)

	3. the tracer does do_wait()

In this case do_wait() can see the tracee in TASK_RUNNING state,
this breaks wait_task_stopped(ptrace => true).

Jan?

> @@ -1799,22 +1830,28 @@ static int do_signal_stop(int signr)
>  		 */
>  		sig->group_exit_code = signr;
>
> -		current->group_stop = gstop;
> +		current->group_stop &= ~GROUP_STOP_SIGMASK;
> +		current->group_stop |= signr | gstop;
>  		sig->group_stop_count = 1;
> -		for (t = next_thread(current); t != current; t = next_thread(t))
> +		for (t = next_thread(current); t != current;
> +		     t = next_thread(t)) {
> +			t->group_stop &= ~GROUP_STOP_SIGMASK;
>  			/*
>  			 * Setting state to TASK_STOPPED for a group
>  			 * stop is always done with the siglock held,
>  			 * so this check has no races.
>  			 */
>  			if (!(t->flags & PF_EXITING) && !task_is_stopped(t)) {
> -				t->group_stop = gstop;
> +				t->group_stop |= signr | gstop;
>  				sig->group_stop_count++;
>  				signal_wake_up(t, 0);
> -			} else
> +			} else {
>  				task_clear_group_stop(t);

This looks racy. Suppose that "current" is ptraced, in this case
it can initiate the new group-stop even if SIGNAL_STOP_STOPPED
is set and we have another TASK_STOPPED thead T.

Suppose that another (or same) debugger ataches to this thread T,
wakes it up and sets GROUP_STOP_TRAPPING.

T resumes, calls ptrace_stop() in TASK_STOPPED, and temporary drops
->siglock.

Now, this task_clear_group_stop(T) confuses ptrace_check_attach(T).

I think ptrace_stop() should be called in TASK_RUNNING state.
This also makes sense because we may call arch_ptrace_stop().

> +				t->group_stop |= signr;

Probably this doesn't really matter, but why do we need to
change the GROUP_STOP_SIGMASK part of t->group_stop? If it
is exiting, this is not needed. If it is already stopped, then
it already has the correct (previous) signr.

> +			}
> +		}
>  	}
> -
> +retry:
>  	current->exit_code = sig->group_exit_code;
>  	__set_current_state(TASK_STOPPED);

It is no longer needed to set ->exit_code here. The only reason
was s/STOPPED/TRACED/ change in ptrace_check_attach(). Now that
we rely on ptrace_stop() which sets ->exit_state, this can be
removed.

And,

> @@ -1842,7 +1879,18 @@ static int do_signal_stop(int signr)
>
>  		spin_lock_irq(&current->sighand->siglock);
>  	} else
> -		ptrace_stop(current->exit_code, CLD_STOPPED, 0, NULL);
> +		ptrace_stop(current->group_stop & GROUP_STOP_SIGMASK,
> +			    CLD_STOPPED, 0, NULL);

Perhaps it would be more clean to clear ->exit_code here, in the
"else" branch.

Oleg.


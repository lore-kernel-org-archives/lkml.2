Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab1C3Tam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 15:30:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080Ab1C3Tal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 15:30:41 -0400
Date: Wed, 30 Mar 2011 21:29:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com
Subject: Re: [PATCH 3/3] signal, ptrace: Fix delayed CONTINUED notification
	when ptraced
Message-ID: <20110330192918.GA14861@redhat.com>
References: <20110329144603.GA29865@htj.dyndns.org> <20110329144648.GB29865@htj.dyndns.org> <20110329144710.GC29865@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110329144710.GC29865@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29, Tejun Heo wrote:
>
> Fix it by making job control continuation path use signal_wake_up()
> instead of wake_up_state() and recalc_sigpending_tsk() consider
> SIGNAL_CLD_MASK.

I still can't agree with this patch...

For the moment, please forget about ptrace. In this case this patch
is not needed, but it adds the small pessimization. OK, it is really
small, recalc_sigpending_tsk() is not called very often.

Also,

> After this patch, TIF_SIGPENDING is set for cases where it isn't
> strictly necessary; however, the only case which it makes any
> difference is when the SIGCONT is received while group stop is still
> in progress, which hardly is a case to optimize for.

Agreed. But, the current code is simply wrong even if the problem
is minor, and afaics your patch makes the things worse.

> @@ -652,6 +657,21 @@ void signal_wake_up(struct task_struct *t, int sig_type)
>  		mask = TASK_INTERRUPTIBLE;
>  		break;
>
> +	case SIGCONT:
> +		/*
> +		 * If there is a handler for SIGCONT, we must make sure
> +		 * that no thread returns to user mode before we post the
> +		 * signal, in case it was the only thread eligible to run
> +		 * the signal handler--then it must not do anything between
> +		 * resuming and running the handler.  This is ensured by
> +		 * setting TIF_SIGPENDING before waking up.
> +		 */
> +		mask = __TASK_STOPPED;
> +		if (sig_user_defined(t, SIGCONT) &&
> +		    !sigismember(&t->blocked, SIGCONT))
> +			mask |= TASK_INTERRUPTIBLE;
> +		break;
> +
>  	case SIGTRAP:
>  		mask = TASK_INTERRUPTIBLE | __TASK_STOPPED | __TASK_TRACED;
>  		break;
> @@ -821,31 +841,9 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
>  		rm_from_queue(SIG_KERNEL_STOP_MASK, &signal->shared_pending);
>  		t = p;
>  		do {
> [...snip...]
> -			wake_up_state(t, state);
> +			signal_wake_up(t, SIGCONT);
>  		} while_each_thread(p, t);

I don't think this logic should be moved into signal_wake_up(). Simply
because it is wrong.

Forget about SIGSTOP. Suppose that the thread group is running, and we
are doing tkill(SIGCONT). Now, why every thread gets TIF_SIGPENDING +
wakeup? This is not correct. Even the kill(SIGCONT) case is not exactly
right. This should be handled by complete_signal(). I think we had to
set TIF_SIGPENDING before, now the locking is different. I'll try to
make the patch.


Now, lets recall about ptrace. But please forget about the lost
notification. We are going to implement the new trap anyway. Ignoring
all details, how we can implement this? I think the most natural and
approach is something like this:

	- add the new GROUP_STOP_CONTTRAP (the name is random), it
	  lives in task->group_stop

	- this bit should be considered by recalc_sigpending_tsk()
	  along with GROUP_STOP_PENDING

	- it should be set by prepare_signal(SIGCONT) if the task
	  is traced

	- this bit should be checked by get_signal_to_deliver() to
	  trigger ptrace_stop()

Does this make any sense?

If yes, then everything works "automagically" after that. The tracee
will call get_signal_to_deliver() if it is running, and check
SIGNAL_CLD_MASK.

What do you think?

Oleg.


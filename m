Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab1CUN3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 09:29:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab1CUN3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 09:29:37 -0400
Date: Mon, 21 Mar 2011 14:20:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 1/8] job control: Don't set group_stop exit_code if
	re-entering job control stop
Message-ID: <20110321132024.GA18777@redhat.com>
References: <1299614199-25142-1-git-send-email-tj@kernel.org> <1299614199-25142-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299614199-25142-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Tejun Heo wrote:
>

Hi Tejun,

I hope you still remember you sent these patches, perhaps you can
even recall what they should do ;)

> @@ -1827,10 +1827,27 @@ static int do_signal_stop(int signr)
>  		    unlikely(signal_group_exit(sig)))
>  			return 0;
>  		/*
> -		 * There is no group stop already in progress.
> -		 * We must initiate one now.
> +		 * There is no group stop already in progress.  We must
> +		 * initiate one now.
> +		 *
> +		 * While ptraced, a task may be resumed while group stop is
> +		 * still in effect and then receive a stop signal and
> +		 * initiate another group stop.  This deviates from the
> +		 * usual behavior as two consecutive stop signals can't
> +		 * cause two group stops when !ptraced.
> +		 *
> +		 * The condition can be distinguished by testing whether
> +		 * SIGNAL_STOP_STOPPED is already set.  Don't generate
> +		 * group_exit_code in such case.
> +		 *
> +		 * This is not necessary for SIGNAL_STOP_CONTINUED because
> +		 * an intervening stop signal is required to cause two
> +		 * continued events regardless of ptrace.
>  		 */
> -		sig->group_exit_code = signr;
> +		if (!(sig->flags & SIGNAL_STOP_STOPPED))
> +			sig->group_exit_code = signr;
> +		else
> +			WARN_ON_ONCE(!task_ptrace(current));

Yes. But WARN_ON_ONCE() is wrong. Suppose that the tracee was stopped,
then PTRACE_CONT'ed, then it gets another SIGSTOP and reports it. Now
suppose that debugger does PTRACE_CONT(SIGSTOP) and exits before the
tracee processes this signal.

OTOH, this WARN_ON_ONCE() makes sense, but we should fix __ptrace_unlink().
This path should take siglock and check SIGNAL_STOP_STOPPED unconditionally.
This should also fix other problems with detach && SIGNAL_STOP_STOPPED.



Also. We should take ->group_stop_count != 0 into account, we should not
set (change) ->group_exit_code in this case too. This is is only "real"
problem in this patch I can see. Other comments are mostly the random
thoughts.



But lets look at the code below,

		for (t = next_thread(current); t != current;
		     t = next_thread(t)) {
			t->group_stop &= ~GROUP_STOP_SIGMASK;
			/*
			 * Setting state to TASK_STOPPED for a group
			 * stop is always done with the siglock held,
			 * so this check has no races.
			 */
			if (!(t->flags & PF_EXITING) && !task_is_stopped(t)) {
				t->group_stop |= signr | gstop;
				sig->group_stop_count++;
				signal_wake_up(t, 0);
			} else {
				task_clear_group_stop_pending(t);
			}
		}

Somehow I no longer understand "else task_clear_group_stop_pending()".
I mean, is it really needed?

If task_is_stopped() == T or it is PF_EXITING, this task has already
done task_participate_group_stop(), no?



Also. I do not think it is correct to change the "signr" part of
->group_stop (unless it is zero) when ->group_stop_count != 0
for other threads. This is minor, but still doesn't look exactly
correct. Probably we can ignore this.

Hmm. it turns out "group_stop & GROUP_STOP_SIGMASK" is only needed
to handle this special case: if debugger PTRACE_CONT's or more
stopped tracees and then som thread initiates the stop again, other
threads need to know that "signr". Otherwise this part of ->group_stop
is only valid "inside" the retry loop in do_signal_stop(), it can
be a local variable. I wonder if we can simply report SIGSTOP in
this case and kill the GROUP_STOP_SIGMASK logic. Nevermind.




And. I think this code does something we do not really want. Why do
we _always_ ask the task_is_traced() threads to participate?

2 threads T1 and T2, both stopped. they are TASK_TRACED, I mean
SIGNAL_STOP_STOPPED is stopped and both have already participated.

Debuggere PTRACE_CONTs T1, then it calls do_signal_stop() again
and sets T2->group_stop = GROUP_STOP_PENDING | GROUP_STOP_CONSUME.
This T2->group_stop doesn't look right, we can report the wrong
extra CLD_STOPPED after detach while ->group_exit_code can be 0.
I think that !task_ptrace(current) case in do_signal_stop() should
take SIGNAL_STOP_STOPPED into account, but perhaps we need another
GROUP_STOP_REPORTED bit, I am not sure.

Or, if debugger PTRACE_CONT's T2, it will report another
ptrace_stop(CLD_STOPPED) immediately, this differs from the current
behaviour although probably we do not care.

Oleg.


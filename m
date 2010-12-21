Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab0LUSRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 13:17:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280Ab0LUSQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 13:16:59 -0500
Date: Tue, 21 Dec 2010 18:25:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 14/16] ptrace: make SIGCONT notification reliable
	against ptrace
Message-ID: <20101221172516.GA16681@redhat.com>
References: <1291654624-6230-1-git-send-email-tj@kernel.org> <1291654624-6230-15-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291654624-6230-15-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06, Tejun Heo wrote:
>
> This patch adds a new signal flag SIGNAL_NOTIFY_CONT which is set when
> a task is woken up by SIGCONT and cleared once the event is notified
> to the parent.  SIGNAL_CLD_MASK bits are no longer cleared after
> notification.  Combined with clearing SIGNAL_CLD_MASK if
> !SIGNAL_NOTIFY_CONT on ptrace attach, these bits are set on ptrace
> detach iff the tracee owes a notification to the real parent.

But we can't know this. The notification and SIGNAL_NOTIFY_CONT are
per-process, while attach/detach is per-thread.

> @@ -66,6 +67,33 @@ void __ptrace_unlink(struct task_struct *child)
>  		if (sig->flags & SIGNAL_STOP_STOPPED || sig->group_stop_count)
>  			child->group_stop |= GROUP_STOP_PENDING;
>  		signal_wake_up(child, 1);
> +		woken_up = true;
> +	}
> +
> +	/*
> +	 * SIGNAL_CLD_MASK is cleared only on a stop signal or, if
> +	 * notification isn't pending, ptrace attach.  If any bit is
> +	 * set,
> +	 *
> +	 * - SIGCONT notification was pending before attach or there
> +	 *   was one or more SIGCONT notifications while tracing.
> +	 *
> +	 * - And, there hasn't been any stop signal since the last
> +	 *   pending SIGCONT notification.
> +	 *
> +	 * Combined, it means that the tracee owes a SIGCONT
> +	 * notification to the real parent.
> +	 */
> +	if (sig->flags & SIGNAL_CLD_MASK) {
> +		sig->flags |= SIGNAL_NOTIFY_CONT;

Two threads, T1 and T2. T1 is ptraced, T2 is not.

SIGSTOP stops them both. T1 sleeps in TASK_TRACED, T2 in TASK_STOPPED.

prepare_signal(SIGCONT) sets SIGNAL_NOTIFY_CONT + SIGNAL_CLD_CONTINUED,
and wakes T2 up.

T2 notifies its ->real_parent, clears SIGNAL_NOTIFY_CONT.

Debugger does ptrace(PTRACE_DETACH, T1), sees SIGNAL_CLD_MASK, and
restores SIGNAL_NOTIFY_CONT.

T1 resends the (bogus) notification to its (and T2's) real_parent.


Even if I missed something,

> @@ -245,6 +273,14 @@ int ptrace_attach(struct task_struct *task)
>  		signal_wake_up(task, 1);
>  	}
>
> +	/*
> +	 * Clear SIGNAL_CLD_MASK if NOTIFY_CONT is not set.  This is
> +	 * used to preserve SIGCONT notification across ptrace
> +	 * attach/detach.  Read the comment in __ptrace_unlink().
> +	 */
> +	if (!(task->signal->flags & SIGNAL_NOTIFY_CONT))
> +		task->signal->flags &= ~SIGNAL_CLD_MASK;

What if there is another ptraced sub-thread in this group who "owes"
the notification ?


> +              * Force the tracee into signal delivery path so that
> +              * the notification is delievered ASAP.  This wakeup
> +              * is unintrusive as SIGCONT delivery would have
> +              * caused the same effect.
> +              */
> +             if (!woken_up)
> +                     signal_wake_up(child, 0);

Well, signal_wake_up() can really force the tracee into signal delivery.
It only sets TIF_SIGPENDING, but this can race with recalc_sigpending().

Oh. This reminds me: http://marc.info/?t=123411921400004

> @@ -1639,7 +1642,24 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
>
>  	switch (why) {
>  	case CLD_CONTINUED:
> -		notify = why;
> +		/*
> +		 * Notify once if NOTIFY_CONT is set regardless of ptrace.
> +		 * NOTIFY_CONT will be reinstated on detach if necessary.
> +		 */
> +		if (!(sig->flags & SIGNAL_NOTIFY_CONT))
> +			break;
> +
> +		/*
> +		 * If ptraced, always report CLD_CONTINUED; otherwise,
> +		 * prepare_signal(SIGCONT) encodes the CLD_ si_code into
> +		 * SIGNAL_CLD_MASK bits.
> +		 */
> +		if (task_ptrace(tsk) || (sig->flags & SIGNAL_CLD_CONTINUED))
> +			notify = CLD_CONTINUED;

See the comment on 4/16

> @@ -2015,31 +2035,18 @@ relock:
>  	 */
>  	try_to_freeze();
>
> -	spin_lock_irq(&sighand->siglock);
>  	/*
> -	 * Every stopped thread goes here after wakeup. Check to see if
> -	 * we should notify the parent, prepare_signal(SIGCONT) encodes
> -	 * the CLD_ si_code into SIGNAL_CLD_MASK bits.
> +	 * Every stopped thread should go through this function after
> +	 * waking up.  Check to see if we should notify the parent.
>  	 */
> -	if (unlikely(signal->flags & SIGNAL_CLD_MASK)) {
> -		int why;
> -
> -		if (task_ptrace(current) ||
> -		    (signal->flags & SIGNAL_CLD_CONTINUED))
> -			why = CLD_CONTINUED;
> -		else
> -			why = CLD_STOPPED;
> -
> -		signal->flags &= ~SIGNAL_CLD_MASK;
> -
> -		spin_unlock_irq(&sighand->siglock);
> -
> +	if (unlikely(current->signal->flags & SIGNAL_NOTIFY_CONT)) {

I am not sure it is OK to check SIGNAL_NOTIFY_CONT without ->siglock.
If we return from do_signal_stop(), everything is fine.

But if we got here because of __ptrace_unlink()->signal_wake_up(1),
we can miss SIGNAL_NOTIFY_CONT.

Oleg.


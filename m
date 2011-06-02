Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab1FBRfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 13:35:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab1FBRfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 13:35:20 -0400
Date: Thu, 2 Jun 2011 19:33:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: Re: [PATCH 17/17] ptrace: implement PTRACE_LISTEN
Message-ID: <20110602173330.GA20384@redhat.com>
References: <1306710760-16440-1-git-send-email-tj@kernel.org> <1306710760-16440-18-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306710760-16440-18-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30, Tejun Heo wrote:
>
> This allows ptracer to monitor group stop state without running tracee
> - use INTERRUPT to put tracee into STOP trap, issue LISTEN and then
> wait(2) to wait for the next group stop event.  When it happens,
> PTRACE_GETSIGINFO provides information to determine the current state.

Great. Just a couple of questions,

> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -1416,7 +1416,7 @@ static int wait_task_stopped(struct wait_opts *wo,
>  	spin_lock_irq(&p->sighand->siglock);
>
>  	p_code = task_stopped_code(p, ptrace);
> -	if (unlikely(!p_code))
> +	if (unlikely(!p_code) || p->jobctl & JOBCTL_LISTENING)
>  		goto unlock_sig;

Up to you, but perhaps this JOBCTL_LISTENING check should go into
task_stopped_code() ? Or do you think we can't check it without
siglock?

> +	case PTRACE_LISTEN:
> +		/*
> +		 * Listen for events.  Tracee must be in STOP.  It's not
> +		 * resumed per-se but is not considered to be in TRACED by
> +		 * wait(2) or ptrace(2).  If an async event (e.g. group
> +		 * stop state change) happens, tracee will enter STOP trap
> +		 * again.  Alternatively, ptracer can issue INTERRUPT to
> +		 * finish listening and re-trap tracee into STOP.
> +		 */
> +		if (unlikely(!seized || !lock_task_sighand(child, &flags)))
> +			break;
> +
> +		si = child->last_siginfo;
> +		if (unlikely(!si || si->si_code != PTRACE_STOP_SI_CODE))
> +			break;
> +
> +		child->jobctl |= JOBCTL_LISTENING;
> +
> +		/*
> +		 * If NOTIFY is set, it means event happened between start
> +		 * of this trap and now.  Trigger re-trap immediately.
> +		 */
> +		if (child->jobctl & JOBCTL_TRAP_NOTIFY)
> +			signal_wake_up(child, true);

Again, I won't insist if you prefer signal_wake_up(), but afaics
wake_up_state(__TASK_TRACED) should be enough.

> @@ -838,7 +840,7 @@ static void ptrace_trap_notify(struct task_struct *t)
>  	assert_spin_locked(&t->sighand->siglock);
>
>  	task_set_jobctl_pending(t, JOBCTL_TRAP_NOTIFY);
> -	signal_wake_up(t, 0);
> +	signal_wake_up(t, t->jobctl & JOBCTL_LISTENING);
>  }

OK. The only thing I can't understand is why prepare_signal(SIGCONT)
calls ptrace_trap_notify() unconditionally. How about

		if (likely(!(t->ptrace & PT_SEIZED)))
			wake_up_state(t, __TASK_STOPPED);
	-	else
	+	else if (why)
			ptrace_trap_notify(t);

?

Oleg.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab1EJOHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 10:07:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932493Ab1EJOHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 10:07:45 -0400
Date: Tue, 10 May 2011 16:06:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 04/11] ptrace: implement PTRACE_INTERRUPT
Message-ID: <20110510140620.GB21834@redhat.com>
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-5-git-send-email-tj@kernel.org> <20110509165857.GA30607@redhat.com> <20110510095022.GR1661@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510095022.GR1661@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/10, Tejun Heo wrote:
>
> Hello,
>
> On Mon, May 09, 2011 at 06:58:57PM +0200, Oleg Nesterov wrote:
> > Right now I am a bit puzzled why do we have 2 bits, JOBCTL_TRAP_INTERRUPT
> > and JOBCTL_TRAP_SEIZE... But I didn't read this + other patches yet.
>
> It eventually ends up with three trap flags - SEIZE, INTERRUPT and
> NOTIFY.  They all use PTRACE_EVENT_INTERRUPT trap but are different as
> for when they're cleared.  SEIZE is cleared after any trap.  INTERRUPT
> is cleared after an INTERRUPT trap

Yes, I see, but still can't understand. OK, please ignore, let me read
other patches first.

Well, in fact I seem to understand why do we have 2 bits. Unless I misread
the code, PTRACE_INTERRUPT is sticky. It can't be lost even if the tracee
can report another event before. Contrary, SEIZE is cleared if the tracee
reports something else right after attach, but they both report the same
PTRACE_EVENT_INTERRUPT. So, if the user does

	ptrace(PTRACE_SEIZE);
	ptrace(PTRACE_INTERRUPT);

we need 2 bits to ensure PTRACE_EVENT_INTERRUPT will be reported in any
case.

And, you know, I am not sure this is very clear. What if we change the
rules so that PTRACE_SEIZE always reports PTRACE_EVENT_INTERRUPT like
PTRACE_INTERRUPT? This looks more symmetrical and simple to me. IOW,
ptrace(PTRACE_SEIZE) simply implies the implicit PTRACE_INTERRUPT.

Oh. And this reminds me the previous discussion. Should PTRACE_SEIZE
stop the tracee? Perhaps it should only attach or do PTRACE_INTERRUPT
depending on flags? Personally I think it should stop...

To clarify, personally I do not know. Jan, Denys, all, please comment.
If PTRACE_SEIZE doesn't stop the tracee, then we should probably pass
more options.



Either way, these changes do not handle the auto-attach case correctly.
tracehook_report_clone() shouldn't send SIGSTOP unconditionally, we
should check PT_SEIZED. And perhaps we can do auto-attach better, but
right now this is off-topic.


> > At first glance, JOBCTL_TRAP_INTERRUPT has the same problem with the
> > killed tracee. I think this is easy to fix.
>
> Again, isn't this cleared during __ptrace_unlink()?

Please see the previous email.

Also,

> @@ -693,6 +693,23 @@ int ptrace_request(struct task_struct *child, long request,
>  			ret = ptrace_setsiginfo(child, &siginfo);
>  		break;
>
> +	case PTRACE_INTERRUPT:
> +		if (!likely(child->ptrace & PT_SEIZED))
> +			break;
> +		/*
> +		 * Stop tracee without any side-effect on signal or job
> +		 * control.  If @child is already trapped, the current trap
> +		 * is not disturbed and INTERRUPT trap will happen after
> +		 * the current trap is ended with PTRACE_CONT.  Note that
> +		 * other traps may happen before the scheduled INTERRUPT.
> +		 */
> +		spin_lock(&child->sighand->siglock);
> +		child->jobctl |= JOBCTL_TRAP_INTERRUPT;
> +		signal_wake_up(child, 0);
> +		spin_unlock(&child->sighand->siglock);
> +		ret = 0;

spin_lock() is not safe. we need _irq, and ->sighand can be NULL if our
sub-thread reaps the dead tracee. IOW, this needs lock_task_sighand().

Well. Perhaps PTRACE_INTERRUPT should return -EALREADY or something if
JOBCTL_TRAP_INTERRUPT is already set? Again, again, it is not that I think
this is really useful. But since we are going to add the new API it is
better to discuss every detail.

Oleg.


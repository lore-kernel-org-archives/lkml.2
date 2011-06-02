Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab1FBS3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 14:29:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab1FBS3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 14:29:32 -0400
Date: Thu, 2 Jun 2011 20:27:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and
	group stop notification, take#4
Message-ID: <20110602182744.GA21705@redhat.com>
References: <1306710760-16440-1-git-send-email-tj@kernel.org> <20110530154211.GA11325@redhat.com> <20110601053903.GE23067@mtj.dyndns.org> <20110602123105.GD10410@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110602123105.GD10410@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 06/02, Tejun Heo wrote:
>
> I've tested threaded one and INTERRUPT immediate re-triggering and at
> least the apparent cases work fine.  I've re-generated the git tree on
> top of 3.0-rc1 with the updated patches.
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-ptrace-seize

Everything looks fine to me.

I feel we can cleanup this code a little bit, but we can do this later.

Only one thing. I think it makes sense to discuss the idea from Denys,

> * Which signo to use in exit_code on STOP traps.

Yes. other pending issues can be solved later.

So,

	static void ptrace_do_notify(int exit_code, int why)
	{
		info.si_signo = SIGTRAP;
		info.si_code = __SI_TRAP | exit_code;

		if ((current->ptrace & PT_SEIZED) &&
		    (sig->group_stop_count || sig->flags & SIGNAL_STOP_STOPPED)) {
			info.si_pt_flags |= PTRACE_SI_STOPPED;
			info.si_signo = current->jobctl & JOBCTL_STOP_SIGMASK;
			WARN_ON_ONCE(!info.si_signo);
		}

	}

Can't we set si_pt_flags only if PTRACE_EVENT_STOP? Afaics, this
should be enough to support the jobctl tracking.

If yes, then can't we encode si_pt_flags in task->exit_code which
is "visible" to wait?

IOW, ptrace_do_notify(PTRACE_EVENT_STOP) path should use

	exit_code = signr | PTRACE_EVENT_STOP<<8;

and signr is roughly calculated as

	if (group_stop_count || SIGNAL_STOP_STOPPED)
		signr = jobctl & JOBCTL_STOP_SIGMASK;
	else if (JOBCTL_TRAP_NOTIFY)
		signr = SIGCONT;
	else
		signr =  SIGTRAP; // PTRACE_INTERRUPT

In this case we can avoid all siginfo changes. The tracer does wait(status)
anyway, it can see the state without GETSIGINFO. The only problem, the tracer
should be careful to avoid the confusion with ptrace_signal(), it should
check status & (PTRACE_EVENT_STOP << 16).

What do you think?

Oleg.


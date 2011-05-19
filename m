Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933689Ab1ESRPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:15:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933640Ab1ESRPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:15:19 -0400
Date: Thu, 19 May 2011 19:13:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 10/10] ptrace: implement group stop notification for
	ptracer
Message-ID: <20110519171327.GA19698@redhat.com>
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <1305569849-10448-11-git-send-email-tj@kernel.org> <20110519163246.GF17265@redhat.com> <20110519165722.GP627@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519165722.GP627@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19, Tejun Heo wrote:
>
> Hey,
>
> On Thu, May 19, 2011 at 06:32:46PM +0200, Oleg Nesterov wrote:
> > > +static void ptrace_trap_notify(struct task_struct *t)
> > > +{
> > > +	siginfo_t *si = t->last_siginfo;
> > > +
> > > +	WARN_ON_ONCE(!(t->ptrace & PT_SEIZED));
> > > +	assert_spin_locked(&t->sighand->siglock);
> > > +
> > > +	/*
> > > +	 * @t is being ptraced and new SEIZE behavior is in effect.
> > > +	 * Schedule sticky trap which will clear on the next GETSIGINFO.
> > > +	 */
> > > +	t->jobctl |= JOBCTL_TRAP_NOTIFY;
> >
> > This is also set by do_signal_stop(). Cleared by PTRACE_GETSIGINFO.
> >
> > How can this work? Doesn't this mean PTRACE_GETSIGINFO becomes mandatory
> > before PTRACE_CONT? IOW, unless the tracee does PTRACE_GETSIGINFO to clear
> > this bit, PTRACE_CONT just leads to another trap, no?
>
> Yes, group stop state change raises a sticky trap condition which is
> cleared by GETSIGINFO.

Hmm. At least now I understand the meaining what "sticky" means in
this discussion ;) I was confused.

> > > +	if (task_is_traced(t) && si && si->si_code == PTRACE_STOP_SI_CODE) {
> >
> > OK, this PTRACE_STOP_SI_CODE check is clear. But the same check in
> > ptrace_check_attach() looks confusing, why can't we set BLOCK_NOTIFY
> > unconditionally?
>
> It's an optimization.  If we set the flag, we'll have to acquire
> siglock

OK, I see.

> > > +		t->jobctl |= JOBCTL_TRAPPING;
> > > +		if (!(t->jobctl & JOBCTL_BLOCK_NOTIFY))
> > > +			signal_wake_up(t, true);
> >
> > Could you please remind me why we can't avoid the awful ptrace_wait_trapping()
> > in do_wait() paths? Assuming that ptrace_check_attach() does this. I got lost
> > a bit.
>
> Please consider the following scenario.
>
> 1. Tracee is in group stop and stops at TRAP_STOP notifying the
>    tracer.
>
> 2. Tracer does WNOWAIT wait(2) and determines that the tracee is
>    trapped in TRAP_STOP.
>
> 3. Something generates SIGCONT which finishes the group stop and
>    triggers the notification re-trapping.
>
> 4. While tracee is re-trapping, tracer issues WNOHANG

OK. I still hope we can avoid this somehow. May be play with exit_code
so that do_wait() can succeed even if the JOBCTL_TRAPPING tracee is
running. Perhaps.

If only we could notify the tracer from ptrace_trap_notify... IIUC,
this is the only problem? I mean, apart from this there is no need
to wake up the tracee.

Oleg.


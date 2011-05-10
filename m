Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab1EJNVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 09:21:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab1EJNVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 09:21:42 -0400
Date: Tue, 10 May 2011 15:20:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 02/11] ptrace: implement PTRACE_SEIZE
Message-ID: <20110510132001.GA21834@redhat.com>
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-3-git-send-email-tj@kernel.org> <20110509161838.GA27473@redhat.com> <20110510094650.GQ1661@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510094650.GQ1661@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10, Tejun Heo wrote:
>
> On Mon, May 09, 2011 at 06:18:38PM +0200, Oleg Nesterov wrote:
>
> > > @@ -247,6 +272,14 @@ static int ptrace_attach(struct task_struct *task)
> > >  	if (task_is_stopped(task)) {
> > >  		task->jobctl |= JOBCTL_STOP_PENDING | JOBCTL_TRAPPING;
> > >  		signal_wake_up(task, 1);
> > > +	} else if (seize) {
> > > +		/*
> > > +		 * Otherwise, SEIZE uses jobctl trap to put tracee into
> > > +		 * TASK_TRACED, which doesn't have the nasty side effects
> > > +		 * of sending SIGSTOP.
> > > +		 */
> > > +		task->jobctl |= JOBCTL_TRAP_SEIZE;
> > > +		signal_wake_up(task, 0);
> >
> > OK... I am a bit worried we can set JOBCTL_TRAP_SEIZE even if the tracee
> > was already killed, and if it is killed later JOBCTL_TRAP_SEIZE won't be
> > cleared. Probably this is fine, ptrace_stop()->schedule() won't sleep in
> > this case.
>
> Hmmm... if killed, the tracee would go through __ptrace_unlink() which
> always clears JOBCTL_TRAP_MASK which includes JOBCTL_TRAP_SEIZE.  What
> am I missing?

No. If killed, the tracee becomes a zombie (but see below). __ptrace_unlink()
won't be called until the tracee does wait().

> > > @@ -1752,12 +1752,13 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
> > >  	set_current_state(TASK_TRACED);
> > >
> > >  	/*
> > > -	 * We're committing to trapping.  Clearing JOBCTL_TRAPPING and
> > > -	 * transition to TASK_TRACED should be atomic with respect to
> > > -	 * siglock.  This should be done after the arch hook as siglock is
> > > -	 * released and regrabbed across it.
> > > +	 * We're committing to trapping.  Adjust ->jobctl.  Updates to
> > > +	 * these flags and transition to TASK_TRACED should be atomic with
> > > +	 * respect to siglock.  This should be done after the arch hook as
> > > +	 * siglock may be released and regrabbed across it.
> > >  	 */
> > >  	task_clear_jobctl_trapping(current);
> > > +	current->jobctl &= ~JOBCTL_TRAP_SEIZE;
> >
> > Yes. But, it seems, this is too late.
> >
> > Suppose that the JOBCTL_TRAP_SEIZE tracee was SIGKILLED before it reports
> > PTRACE_EVENT_INTERRUPT. Now, if arch_ptrace_stop_needed() == T, ptrace_stop()
> > returns without clearing JOBCTL_TRAP_SEIZE/TIF_SIGPENDING. This means
> > get_signal_to_deliver() will loop forever.
>
> Argh... right it has an early exit path there.

Yes, and thus the tracee will loop forever until the tracer detaches, so
it can't even become a zombie. And the tracer can't detach via ptrace().

> > I never understood why ptrace_stop()->sigkill_pending() logic, I think
> > we should check fatal_signal_pending() unconditionally.
>
> Probably the best way to do it is adding fatal_signal_pending() into
> may_ptrace_stop() so that the failure path shares most of the code
> path instead of doing quick dirty exit?  It's just nasty to have early
> exit above there and walking through the normal code path wouldn't
> hurt SIGKILL either.

Yes, probably. But, apart from the user-visible change which needs another
discussion, there are more problems. fatal_signal_pending() can "wrongly"
return false if the caller is tracehook_report_exit(). OTOH, it can correctly
return true (exec), but we probably want to stop. Let's discuss this later,
I think this has nothing to do with your patches. The main problem is not
fatal_signal_pending(), we need the better definition of explicit SIGKILL
behaviour. Not for ptrace only, there are other issues.

Oleg.


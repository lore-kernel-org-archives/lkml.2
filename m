Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab1EJJq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 05:46:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33904 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab1EJJqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 05:46:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WDb34rYTIT9Pe0dOAtqEpr3jHalRwVD7DUezwI2sV0JckXf9LnpPGX8POtEpATKUFu
         0s6j5iZvCb29WJrNCdCQ0tGasCQtl4QKQegh24ehBFjcGM/79YFQx9utgNJwn6x0eDna
         Z2dITEV186jGdfTxZDj61SsIZI2wElkiz2C8g=
Date: Tue, 10 May 2011 11:46:50 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 02/11] ptrace: implement PTRACE_SEIZE
Message-ID: <20110510094650.GQ1661@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-3-git-send-email-tj@kernel.org>
 <20110509161838.GA27473@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110509161838.GA27473@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Oleg.

On Mon, May 09, 2011 at 06:18:38PM +0200, Oleg Nesterov wrote:
> On 05/08, Tejun Heo wrote:
> > -static int ptrace_attach(struct task_struct *task)
> > +static int ptrace_attach(struct task_struct *task, long request,
> > +			 unsigned long flags)
> >  {
> > +	bool seize = request == PTRACE_SEIZE;
> 
> Cough. I really hate the cosmetic nits but can't resist...
> 
> 	bool seize = (request == PTRACE_SEIZE);
> 
> looks more parseable, but feel free to ignore.

Heh yeah, I usually try to avoid unnecessary parantheses mostly
because that seems the easiest way to reach at least some level of
style uniformity.  The minimum is well defined idndependently of
anyone's taste and can serve as a meaningful convergence point.

That said, it's true that there are times when things just look better
with extra parantheses.  If the above bothers you, I'll update it. :-)

> > @@ -247,6 +272,14 @@ static int ptrace_attach(struct task_struct *task)
> >  	if (task_is_stopped(task)) {
> >  		task->jobctl |= JOBCTL_STOP_PENDING | JOBCTL_TRAPPING;
> >  		signal_wake_up(task, 1);
> > +	} else if (seize) {
> > +		/*
> > +		 * Otherwise, SEIZE uses jobctl trap to put tracee into
> > +		 * TASK_TRACED, which doesn't have the nasty side effects
> > +		 * of sending SIGSTOP.
> > +		 */
> > +		task->jobctl |= JOBCTL_TRAP_SEIZE;
> > +		signal_wake_up(task, 0);
> 
> OK... I am a bit worried we can set JOBCTL_TRAP_SEIZE even if the tracee
> was already killed, and if it is killed later JOBCTL_TRAP_SEIZE won't be
> cleared. Probably this is fine, ptrace_stop()->schedule() won't sleep in
> this case.

Hmmm... if killed, the tracee would go through __ptrace_unlink() which
always clears JOBCTL_TRAP_MASK which includes JOBCTL_TRAP_SEIZE.  What
am I missing?

> Hmm. but see below.
> 
> > @@ -1752,12 +1752,13 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
> >  	set_current_state(TASK_TRACED);
> >
> >  	/*
> > -	 * We're committing to trapping.  Clearing JOBCTL_TRAPPING and
> > -	 * transition to TASK_TRACED should be atomic with respect to
> > -	 * siglock.  This should be done after the arch hook as siglock is
> > -	 * released and regrabbed across it.
> > +	 * We're committing to trapping.  Adjust ->jobctl.  Updates to
> > +	 * these flags and transition to TASK_TRACED should be atomic with
> > +	 * respect to siglock.  This should be done after the arch hook as
> > +	 * siglock may be released and regrabbed across it.
> >  	 */
> >  	task_clear_jobctl_trapping(current);
> > +	current->jobctl &= ~JOBCTL_TRAP_SEIZE;
> 
> Yes. But, it seems, this is too late.
> 
> Suppose that the JOBCTL_TRAP_SEIZE tracee was SIGKILLED before it reports
> PTRACE_EVENT_INTERRUPT. Now, if arch_ptrace_stop_needed() == T, ptrace_stop()
> returns without clearing JOBCTL_TRAP_SEIZE/TIF_SIGPENDING. This means
> get_signal_to_deliver() will loop forever.

Argh... right it has an early exit path there.

> I never understood why ptrace_stop()->sigkill_pending() logic, I think
> we should check fatal_signal_pending() unconditionally.

Probably the best way to do it is adding fatal_signal_pending() into
may_ptrace_stop() so that the failure path shares most of the code
path instead of doing quick dirty exit?  It's just nasty to have early
exit above there and walking through the normal code path wouldn't
hurt SIGKILL either.
 
> Oh, and we have other subtle issues here.
>
> >  	for (;;) {
> >  		struct k_sigaction *ka;
> > +
> > +		/*
> > +		 * Check for ptrace trap conditions.  Jobctl traps are used
> > +		 * to trap ptracee while staying transparent regarding
> > +		 * signal and job control.
> > +		 */
> > +		if (unlikely(current->jobctl & JOBCTL_TRAP_MASK)) {
> > +			ptrace_notify_locked(SIGTRAP |
> > +					     (PTRACE_EVENT_INTERRUPT << 8));
> > +			continue;
> 
> Shouldn't we recheck SIGNAL_CLD_MASK after ptrace_notify_locked() returns?
> Probably not, but I am not sure...

Yeah, I thought about that one too.  I don't think it really matters
one way or the other.  I mostly just wanted to avoid an extra
spin_unlock_irq() after ptrace_notify_locked().

> In any case. This doesn't really matter, but can't we check
> JOBCTL_TRAP_MASK outside of the main loop? Unless we drop ->siglock
> this bit can't be changed, and every time we drop ->siglock we go to
> "relock".

Yeah, sure.  I basically just wanted to say "continue" there. :-) I'll
take it out of the loop and make it unlock and jump to relock.

Thank you.

-- 
tejun

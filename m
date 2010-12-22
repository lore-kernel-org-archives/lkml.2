Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab0LVKf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 05:35:29 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:41124 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab0LVKf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 05:35:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZtRK32JrYVIw/g2PATC2nyGuClLFV6QCpzBDTQ8nFZkgQeiZwDALOm1hVu/SNN7agB
         FF2d6sTM4fkU0DFKfW1EMNsob72zZTJHKhIgf8CjpGty1cWGYenmbm82irwhK9+TL5OB
         bYJIvbMFvQRVNEMIy9F75Kv0JP5tQQlBkei9I=
Date: Wed, 22 Dec 2010 11:35:22 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 14/16] ptrace: make SIGCONT notification reliable
 against ptrace
Message-ID: <20101222103522.GC4684@htj.dyndns.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
 <1291654624-6230-15-git-send-email-tj@kernel.org>
 <20101221172516.GA16681@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101221172516.GA16681@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Tue, Dec 21, 2010 at 06:25:16PM +0100, Oleg Nesterov wrote:
> Two threads, T1 and T2. T1 is ptraced, T2 is not.
> 
> SIGSTOP stops them both. T1 sleeps in TASK_TRACED, T2 in TASK_STOPPED.
> 
> prepare_signal(SIGCONT) sets SIGNAL_NOTIFY_CONT + SIGNAL_CLD_CONTINUED,
> and wakes T2 up.
> 
> T2 notifies its ->real_parent, clears SIGNAL_NOTIFY_CONT.
> 
> Debugger does ptrace(PTRACE_DETACH, T1), sees SIGNAL_CLD_MASK, and
> restores SIGNAL_NOTIFY_CONT.
> 
> T1 resends the (bogus) notification to its (and T2's) real_parent.

You're right.  Any thread which notifies the real parent should clear
the pending status.

> Even if I missed something,
> 
> > @@ -245,6 +273,14 @@ int ptrace_attach(struct task_struct *task)
> >  		signal_wake_up(task, 1);
> >  	}
> >
> > +	/*
> > +	 * Clear SIGNAL_CLD_MASK if NOTIFY_CONT is not set.  This is
> > +	 * used to preserve SIGCONT notification across ptrace
> > +	 * attach/detach.  Read the comment in __ptrace_unlink().
> > +	 */
> > +	if (!(task->signal->flags & SIGNAL_NOTIFY_CONT))
> > +		task->signal->flags &= ~SIGNAL_CLD_MASK;
> 
> What if there is another ptraced sub-thread in this group who "owes"
> the notification ?

Okay, hmmm... yeah, this is problematic.  Man, I suck.

Combined with the previously pointed out issue with indeterministic
behavior regarding stop notification, maybe it's better to reimplement
something which blocks both stop and cont notifications while any
thread in the group is ptraced and reissues them when all detach?  So
that we can get both transparent and more predictable behavior?

> > +              * Force the tracee into signal delivery path so that
> > +              * the notification is delievered ASAP.  This wakeup
> > +              * is unintrusive as SIGCONT delivery would have
> > +              * caused the same effect.
> > +              */
> > +             if (!woken_up)
> > +                     signal_wake_up(child, 0);
> 
> Well, signal_wake_up() can really force the tracee into signal delivery.
> It only sets TIF_SIGPENDING, but this can race with recalc_sigpending().

Indeed.

> Oh. This reminds me: http://marc.info/?t=123411921400004
> 
> > @@ -1639,7 +1642,24 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
> >
> >  	switch (why) {
> >  	case CLD_CONTINUED:
> > -		notify = why;
> > +		/*
> > +		 * Notify once if NOTIFY_CONT is set regardless of ptrace.
> > +		 * NOTIFY_CONT will be reinstated on detach if necessary.
> > +		 */
> > +		if (!(sig->flags & SIGNAL_NOTIFY_CONT))
> > +			break;
> > +
> > +		/*
> > +		 * If ptraced, always report CLD_CONTINUED; otherwise,
> > +		 * prepare_signal(SIGCONT) encodes the CLD_ si_code into
> > +		 * SIGNAL_CLD_MASK bits.
> > +		 */
> > +		if (task_ptrace(tsk) || (sig->flags & SIGNAL_CLD_CONTINUED))
> > +			notify = CLD_CONTINUED;
> 
> See the comment on 4/16

Will update.

> > @@ -2015,31 +2035,18 @@ relock:
> >  	 */
> >  	try_to_freeze();
> >
> > -	spin_lock_irq(&sighand->siglock);
> >  	/*
> > -	 * Every stopped thread goes here after wakeup. Check to see if
> > -	 * we should notify the parent, prepare_signal(SIGCONT) encodes
> > -	 * the CLD_ si_code into SIGNAL_CLD_MASK bits.
> > +	 * Every stopped thread should go through this function after
> > +	 * waking up.  Check to see if we should notify the parent.
> >  	 */
> > -	if (unlikely(signal->flags & SIGNAL_CLD_MASK)) {
> > -		int why;
> > -
> > -		if (task_ptrace(current) ||
> > -		    (signal->flags & SIGNAL_CLD_CONTINUED))
> > -			why = CLD_CONTINUED;
> > -		else
> > -			why = CLD_STOPPED;
> > -
> > -		signal->flags &= ~SIGNAL_CLD_MASK;
> > -
> > -		spin_unlock_irq(&sighand->siglock);
> > -
> > +	if (unlikely(current->signal->flags & SIGNAL_NOTIFY_CONT)) {
> 
> I am not sure it is OK to check SIGNAL_NOTIFY_CONT without ->siglock.
> If we return from do_signal_stop(), everything is fine.
> 
> But if we got here because of __ptrace_unlink()->signal_wake_up(1),
> we can miss SIGNAL_NOTIFY_CONT.

This probably should be resolved together with the above
recalc_sigpending() issue.  I'll think about it.

Thank you.

-- 
tejun

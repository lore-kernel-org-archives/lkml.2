Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666Ab1EJOUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 10:20:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40958 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557Ab1EJOUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 10:20:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RBaEvXdHYuCVHGJ+hBQ+qC7jx1ugLj0D+tkLMKaCKwHMhGN8HeBjQsoan25VNSNVw3
         2MPBIQLg7D1B3cCitLW2BkxaoUkwfzNfvp8lPHMuIvTaKbjidXwciM9TNc8XOj8IgxzF
         3uwLdph3OhpOcdoC3u9rLcTSIdHwAs6hd8mi8=
Date: Tue, 10 May 2011 16:20:33 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 04/11] ptrace: implement PTRACE_INTERRUPT
Message-ID: <20110510142033.GY1661@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-5-git-send-email-tj@kernel.org>
 <20110509165857.GA30607@redhat.com>
 <20110510095022.GR1661@htj.dyndns.org>
 <20110510140620.GB21834@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510140620.GB21834@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Tue, May 10, 2011 at 04:06:20PM +0200, Oleg Nesterov wrote:
> > It eventually ends up with three trap flags - SEIZE, INTERRUPT and
> > NOTIFY.  They all use PTRACE_EVENT_INTERRUPT trap but are different as
> > for when they're cleared.  SEIZE is cleared after any trap.  INTERRUPT
> > is cleared after an INTERRUPT trap
> 
> Yes, I see, but still can't understand. OK, please ignore, let me read
> other patches first.

Heh, my communication skill sucks.

> Well, in fact I seem to understand why do we have 2 bits. Unless I misread
> the code, PTRACE_INTERRUPT is sticky. It can't be lost even if the tracee
> can report another event before. Contrary, SEIZE is cleared if the tracee
> reports something else right after attach, but they both report the same
> PTRACE_EVENT_INTERRUPT. So, if the user does
> 
> 	ptrace(PTRACE_SEIZE);
> 	ptrace(PTRACE_INTERRUPT);
> 
> we need 2 bits to ensure PTRACE_EVENT_INTERRUPT will be reported in any
> case.

But you've figured it out anyway. :-)

I used the term 'sticky' for PTRACE_NOTIFY which may cause more than
on trap, so using sticky for INTERRUPT could be a bit confusing.  To
sum up,

 SEIZE		: schedules INTERRUPT trap, cleared on any trap

 INTERRUPT	: schedules INTERRUPT trap, cleared on INTERRUPT trap

 NOTIFY		: schedules INTERRUPT trap, cleared on GETSIGINFO,
		  may cause multiple INTERRUPT traps

> And, you know, I am not sure this is very clear. What if we change the
> rules so that PTRACE_SEIZE always reports PTRACE_EVENT_INTERRUPT like
> PTRACE_INTERRUPT? This looks more symmetrical and simple to me. IOW,
> ptrace(PTRACE_SEIZE) simply implies the implicit PTRACE_INTERRUPT.

Actually, that was my initial implementation but as we don't guarantee
that the first trap would be an INTERRUPT one, so it seemed nicer to
avoid double trapping after SEIZE.  Maybe we can make sure that
INTERRUPT is always the trap to be taken but it would be a tad bit
more complex than the current implementation.  I think it's doable
although there are some corner cases, I think.  Would that be better?

> Oh. And this reminds me the previous discussion. Should PTRACE_SEIZE
> stop the tracee? Perhaps it should only attach or do PTRACE_INTERRUPT
> depending on flags? Personally I think it should stop...
> 
> To clarify, personally I do not know. Jan, Denys, all, please comment.
> If PTRACE_SEIZE doesn't stop the tracee, then we should probably pass
> more options.

I'm rather strongly against not trapping and somebody would have to
give me _very_ convincing rationales to change my mind on the subject.

> Either way, these changes do not handle the auto-attach case correctly.
> tracehook_report_clone() shouldn't send SIGSTOP unconditionally, we
> should check PT_SEIZED. And perhaps we can do auto-attach better, but
> right now this is off-topic.

Oh yeah, that's something I meant to ask you but forgot.  The SEIZE
behaviors are not complete after this patchset and thus there's no
patch to remove the DEVEL flag yet.  ISTR you telling me there are two
or three conditions where the reporting/stopping isn't transparent in
a previous mail, which I can't find anymore.  One apparently is clone.
What were the others?

> > +	case PTRACE_INTERRUPT:
> > +		if (!likely(child->ptrace & PT_SEIZED))
> > +			break;
> > +		/*
> > +		 * Stop tracee without any side-effect on signal or job
> > +		 * control.  If @child is already trapped, the current trap
> > +		 * is not disturbed and INTERRUPT trap will happen after
> > +		 * the current trap is ended with PTRACE_CONT.  Note that
> > +		 * other traps may happen before the scheduled INTERRUPT.
> > +		 */
> > +		spin_lock(&child->sighand->siglock);
> > +		child->jobctl |= JOBCTL_TRAP_INTERRUPT;
> > +		signal_wake_up(child, 0);
> > +		spin_unlock(&child->sighand->siglock);
> > +		ret = 0;
> 
> spin_lock() is not safe. we need _irq, and ->sighand can be NULL if our
> sub-thread reaps the dead tracee. IOW, this needs lock_task_sighand().

Definitely.  Thanks for spotting that.

> Well. Perhaps PTRACE_INTERRUPT should return -EALREADY or something if
> JOBCTL_TRAP_INTERRUPT is already set? Again, again, it is not that I think
> this is really useful. But since we are going to add the new API it is
> better to discuss every detail.

At first I made PTRACE_INTERRUPT noop if it was already in INTERRUPT
trap but then changed my mind because guaranteeing that there will be
at least one PTRACE_EVENT_INTERRUPT trap after PTRACE_INTERRUPT seems
better than having subtle behavior difference which might be nicer in
limited use cases.

Thank you.

-- 
tejun

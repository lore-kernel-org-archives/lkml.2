Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab1CWIo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 04:44:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50055 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab1CWIo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 04:44:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TN2KefsYo9WbfsJUZYzT0YokzYvY9AqWplwMinnUkKag+0oJzfIXFz1MJS55KvVFnc
         UJJa4R/u2EcXiVr4PaytmNjla4tSfGRaWwE/w8sMdBQEzjgIFBhUt1UBJKb3S2AQLVTB
         SvYtVPjfNOPnOzNEYXaku5akFbZUSNKLb+XXs=
Date: Wed, 23 Mar 2011 09:44:21 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 1/8] job control: Don't set group_stop exit_code if
 re-entering job control stop
Message-ID: <20110323084421.GW12003@htj.dyndns.org>
References: <1299614199-25142-1-git-send-email-tj@kernel.org>
 <1299614199-25142-2-git-send-email-tj@kernel.org>
 <20110321132024.GA18777@redhat.com>
 <20110321155250.GE12003@htj.dyndns.org>
 <20110322184415.GA28038@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322184415.GA28038@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Mar 22, 2011 at 07:44:15PM +0100, Oleg Nesterov wrote:
> Suppose that debugger PTRACE_CONTs the stopped thread and then it
> gets SIGSTOP and calls do_signal_stop() again. In theory this all is
> possible before SIGNAL_STOP_STOPPED. This can confuse real_parent.
> Say, real_parent itself sends SIGTTIN to the child and naturally
> expects WIFSTOPPED() == SIGTTIN.

Hmmm... There are two competing signals in that case - SIGTTIN sent by
the parent and SIGSTOP sent by someone else.  The parent doesn't have
any control over which signal wins the race nor is it visible in any
way before the group stop is complete.  The two signals are
equivalent.

I can't think of a scenario where the parent would be able to
differentiate the two signals (in the sense that it can say the latter
is the wrong signal).  If you can, please share.

> But again, even if I am right this is minor and we can change this
> later. And btw, I think we should not change/set ->group_stop_count
> if SIGNAL_STOP_STOPPED || group_stop_count. We will see.

Yeah, maybe.  We would be suppressing group stop completion anyway so
the count doesn't make whole lot of difference.  The only difference
would be that group stop completion would be delayed if stop signals
are continuously delievered by ptracee's in the thread group.  I don't
think it matters one way or the other.

> For example. Ignoring task_participate_group_stop(), why
> task_clear_group_stop_pending() preserves the GROUP_STOP_SIGMASK ?
> This doesn't hurt, sure. But looks a bit inconsistent.

Yeah, it probably is better to clear the signo too.

> > * A thread does group stop and the parent consumed exit code.
> >
> > * ptracer attaches and sees the group stop signal.
> >
> > * PTRACE_CONT and the thread leaves do_signal_stop().
> >
> > * PTRACE_DETACH.  The thread returns to do_signal_stop() and re-enters
> >   TASK_STOPPED.
> >
> > * Another ptracer does PTRACE_ATTACH.
> >
> > The second ptracer wants to know the signo too but if it were stored
> > in a local variable, it wouldn't be available anywhere.
> 
> Yes, sure. But this is basically the same case. My point was, this
> signr must be correct inside the retry loop, otherwise we could just
> report SIGSTOP because we can't guarantee the "correct" signr anyway.
> 
> Let's look at your example again. Suppose that the process was stopped
> by SIGSTOP.
> 
> When the first ptracer attaches, each thread correctly reports SIGSTOP.
> But if it plays with PTRACE_CONT and then detaches, the next ptracer can
> see, say, SIGTTIN. And different threads can report different signals.

I think it depends on how you look at it.  Group stop behavior is
different under ptrace anyway.  We allow PTRACE_CONT'd tracees to
re-initiate and re-enter the existing group stop.  Which signo is the
right one to report is debatable, but,

* For the tracee which delivers the signal which re-initiates the
  existing group stop, it would be just weird to report different
  signo from the one delivered.

* It would also be weird to report different signo for other tracees
  in the group depending on whether they were running at the time of
  re-initiation or not.

So, I think just defining the stop signo to be reported while ptraced
as "the latest group stop signal delivered" isn't too bad.  It's
simple and more consistent with the existing behavior.

> > > Or, if debugger PTRACE_CONT's T2, it will report another
> > > ptrace_stop(CLD_STOPPED) immediately, this differs from the current
> > > behaviour although probably we do not care.
> >
> > This was changed by "signal: Use GROUP_STOP_PENDING to stop once for a
> > single group stop".
> 
> Not sure I understand... We are setting GROUP_STOP_PENDING | CONSUME
> again. T2 has already reported ptrace_stop(CLD_STOPPED) to the tracer.
> It is stopped. Now it will report another CLD_STOPPED after PTRACE_CONT.

Okay, I see.  Maybe we should discern between traced for group stop
from other traps but then again given the group stop re-entering while
ptraced it can be considered a relatively consistent behavior.  Yeah,
but probably better to remove the double reporting.

Thanks.

-- 
tejun

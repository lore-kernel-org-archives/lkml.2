Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab1A0N4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 08:56:40 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60707 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab1A0N4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 08:56:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M7PpRu5i65W2pxBFbtlotd3rbtriWS0o7iVUAiGfgWVZJVtCXLU8ZM3JQvH9WwG5TE
         GX/xOCzRg6f+kI0PM8AZO2bpkuR96LOgvdMtSo+d7V2au+ZVOXF7NDomDBxKBdddlmn4
         q5UMzGA749XywCc9WcP7s6LaVqjDT9Muyca2A=
Date: Thu, 27 Jan 2011 14:56:31 +0100
From: Tejun Heo <tj@kernel.org>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 09/16] ptrace: make do_signal_stop() use ptrace_stop()
 if the task is being ptraced
Message-ID: <20110127135631.GD24925@htj.dyndns.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
 <1291654624-6230-10-git-send-email-tj@kernel.org>
 <20101223122634.GA365@redhat.com>
 <20110117220923.EA622180996@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110117220923.EA622180996@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Roland.

On Mon, Jan 17, 2011 at 02:09:23PM -0800, Roland McGrath wrote:
> > In short: suppose that the tracee recieves a signal, reports it
> > to debugger, and the debugger does ptrace(PTRACE_CONT, pid, SIGSTOP).
> > 
> > Before the patch the tracee sleeps in TASK_STOPPED, after the patch
> > it becomes TASK_TRACED.
> 
> I am not immediately comfortable with this.  What really matters is
> the userland-visible behavior (ptrace, wait, and signals).  The
> /proc/pid/status difference of "T (stopped)" vs "T (traced)" is
> technically userland-visible, but I don't think that really matters
> to userland.
> 
> > I missed this part of the changelog. "visible via fs/proc" is not
> > the only change. Another change is how the tracee reacts to SIGCONT
> > after that. With this patch it can't wake the tracee up.
> 
> This seems like a problem to me, though there are caveats to that.
> My rationale has always been that there should be some way to get
> into normal job-control stop state, both meaning that group-stop
> happens normally and that SIGCONT works normally.  
> 
> However, it is not entirely clear how useful that is to userland
> given the rest of ptrace behavior as it stands.  That is, the real
> parent can't see the job-control stop anyway because its wait
> reports are preempted by ptrace, so what is it for?
> 
> It would be more clear if we had a cleaner interface available in
> which tracing did not prevent normal job-control stops from being
> reported to the real parent.  I'm not really sure how much we should
> try to change this stuff before adding something like that.

I think we're getting a bit off course here.  The CONT problem in this
context isn't generic at all.  In principle, CONT doesn't
(immediately) work on a ptraced task.  We basically just had this
window where STOPPED -> TRACED transition was delayed in which CONT
worked.  It's more of a behavioral inconsistency than anything else.

If a task was RUNNING when PTRACE_ATTACH happens, when the tracer
wait(2) completes, the task is TRACED and won't immediately respond to
CONT.  If a task was STOPPED, CONT can still wake up between the
completion of wait(2) and the first ptrace command on the tracee.
It's a subtle inconsistency which I don't believe anyone could have
taken advantag of.

As for the generic discussion of group stop vs. ptrace, yeah, there's
a lot to discuss and as I already wrote before I don't think there
will be a single behavior which would satisfy all the requirements.  I
think it would be best to iron out the existing inconsistencies in a
way which doesn't break the current users and then gradually introduce
a few more ptrace operations which have well defined and more flexible
interaction with group stop.

> But the way the code is structured, arch_ptrace_stop can only be used
> on current, meaning it requires waking it up from TASK_STOPPED long
> enough to run the ptrace_stop logic.  IMHO it would be wrong to
> introduce a new window visible to userland wherein a process
> previously in job-control stop is seen to be running before it gets
> into its ptrace stop.  It might not matter if /proc/pid/status can be
> read to see "R (running)" for such a window.  But certainly it should
> not have CLD_CONTINUED behavior (SIGCHLD and waitid visibility), nor
> report a CLD_TRAPPED stop via SIGCHLD or wait after it was already stopped.

As I wrote in another reply, the visibility is masked from the tracer
and only visible if the user does a pretty convoluted thing.  Unless
there's such current user, I think we can clearly define what's
guaranteed regarding ptrace/wait interaction and leave cases outside
of it as undefined.

> [tj:]
> > Yes, before the change, the task would respond to SIGCONT before the
> > first ptrace request succeeds after attach.  To me, this doesn't seem
> > to be anything intentional tho.  It seems a lot of ptrace and group
> > stop interactions is in the grey area with only the current (quirky,
> > I'm afraid) behavior drawing almost arbitrary lines across different
> > behaviors.
> 
> That is largely true.  But userland programs like gdb and strace have
> gone to lots of contortions to work with the behavior as it is, and we
> should not break what works in practice for them.

Sure, I definitely agree but at the same time that doesn't mean we
shouldn't improve ptrace at all.  It just means it's delicate and we
should proceed carefully, which we shall.

> > We can try to preserve all those behaviors but I don't think that will
> > be very beneficial.  I think the best way to proceed would be
> > identifying the sensible and depended upon assumptions and then draw
> > clear lines from there stating what's guaranteed and what's undefined.
> > We'll have to keep some of quirkiness for sure.
> 
> I agree with this overall.  But we must consider whatever weirdness
> comes up in ptrace.

Yeap.

> I quite agree.  The best way to fix this is with sane semantics for
> normal job-control operations when traced.  But ptrace has never had
> that before and it's just not possible both to be sane and to match
> the expected behavior of the traditional ptrace semantics.  Hence I
> lean towards leaving things as much as possible as they are today when
> only the ptrace operations we have today are used.

Yeap, definitely.  I want to make things just clean enough so that it
doesn't hinder introduction of improvements while not breaking the
existing users, but things like silent STOPPED -> TRACED transition
are outright buggy and have to be fixed one way or the other.  We
can't ignore them.

> I certainly agree that we should have some new operations or modes of
> tracing and have them behave sanely.  I don't think the details you've
> described here are exactly what would make sense, however.
> 
> IMHO there should be no discretion about whether a thread participates
> in a group stop.  If a group stop is happening, every thread must be
> stopped ASAP and the debugger should not be able to interfere with
> that.  (The time for the debugger to interfere is when it gets the
> chance to intercept the stop signal before it's delivered.)  If a
> thread is stop for tracing when a group stop happens, then the right
> way to think about its state is "both stopped for tracing and stopped
> for job-control".  When the tracer says it can resume, it goes to
> simply "stopped for job-control".  Likewise, if before that a SIGCONT
> is generated, then it goes to simply "stopped for tracing" and does
> not prevent the normal CLD_CONTINUED notification from happening.
> That is, to the non-debugger parts of the system, it's no different
> from if the debugger stopped that thread for tracing immediately after
> SIGCONT resumed it and before it had a chance to do anything else.
> (This is exactly the model we tried to implement in utrace.)

There are two extremes.  You can put ptrace under group stop or
completely the other way around.  I think there are valid use cases
for both of them.  I'll try to summarize it later.

> I've read over the rest of the long thread from December and will
> reply further to the later iterations of the patches shortly.  I'm
> sorry if I've replied to stale issues or overlooked questions still
> needing answers.  I hope we can all get caught up to discussing the
> same things this week.

Heh, I was the late one this time.  I'll soon repost the refreshed
STOPPED <-> TRACED patchset.  I think we're mostly in agreement
regarding that part.

Thank you.

-- 
tejun

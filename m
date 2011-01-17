Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab1AQWKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 17:10:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab1AQWKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 17:10:19 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 09/16] ptrace: make do_signal_stop() use ptrace_stop()
	if the task is being ptraced
In-Reply-To: Oleg Nesterov's message of  Thursday, 23 December 2010 13:26:34 +0100 <20101223122634.GA365@redhat.com>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
	<1291654624-6230-10-git-send-email-tj@kernel.org>
	<20101223122634.GA365@redhat.com>
Emacs: impress your (remaining) friends and neighbors.
Message-Id: <20110117220923.EA622180996@magilla.sf.frob.com>
Date: Mon, 17 Jan 2011 14:09:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In short: suppose that the tracee recieves a signal, reports it
> to debugger, and the debugger does ptrace(PTRACE_CONT, pid, SIGSTOP).
> 
> Before the patch the tracee sleeps in TASK_STOPPED, after the patch
> it becomes TASK_TRACED.

I am not immediately comfortable with this.  What really matters is
the userland-visible behavior (ptrace, wait, and signals).  The
/proc/pid/status difference of "T (stopped)" vs "T (traced)" is
technically userland-visible, but I don't think that really matters
to userland.

> I missed this part of the changelog. "visible via fs/proc" is not
> the only change. Another change is how the tracee reacts to SIGCONT
> after that. With this patch it can't wake the tracee up.

This seems like a problem to me, though there are caveats to that.
My rationale has always been that there should be some way to get
into normal job-control stop state, both meaning that group-stop
happens normally and that SIGCONT works normally.  

However, it is not entirely clear how useful that is to userland
given the rest of ptrace behavior as it stands.  That is, the real
parent can't see the job-control stop anyway because its wait
reports are preempted by ptrace, so what is it for?

It would be more clear if we had a cleaner interface available in
which tracing did not prevent normal job-control stops from being
reported to the real parent.  I'm not really sure how much we should
try to change this stuff before adding something like that.

> However. There is something I missed previously, and this small
> detail doesn't look good to me: the behaviour of SIGCONT becomes
> a bit unpredictable. Suppose it races with do_signal_stop() and
> clears GROUP_STOP_PENDING or SIGNAL_STOP_DEQUEUED before, in this
> case in can "wakeup" the tracee.

This sounds to me exactly like the normal race between a SIGSTOP and
a SIGCONT when ptrace is not involved.  It's supposed to be that
way, i.e. generating SIGCONT clears all stop signals whether pending
or in the midst of delivery or already fully delivered.  So, if the
meaning of PTRACE_CONT,SIGSTOP is to behave like a normal SIGSTOP
delivery, then that is what's expected.

> OTOH. Looking at this patch, I can no longer understand why
> ptrace_check_attach() can silently do s/STOPPED/TRACED/. 

The purpose of that is so that when ptrace is in use, SIGCONT can't
resume the tracee.  If the tracee was in TASK_STOPPED either because
it was already in job-control stop before PTRACE_ATTACH, or because
PTRACE_CONT,SIGSTOP put it there, then we need it to be in TASK_TRACED
while ptrace does its work in case an external SIGCONT comes along.

> Indeed, as Tejun pointed out, if ptrace_stop() needs
> arch_ptrace_stop(), then ptrace_check_attach() should be
> arch-friendly as well.

Yes, perhaps so.  It's certainly the case that the lack of complaint
from ia64/sparc users doesn't mean it's correct now, just that this
case is subtle, difficult to notice in practice, and subject to other
external conditions (other load causing flushes or not, etc.).

But the way the code is structured, arch_ptrace_stop can only be used
on current, meaning it requires waking it up from TASK_STOPPED long
enough to run the ptrace_stop logic.  IMHO it would be wrong to
introduce a new window visible to userland wherein a process
previously in job-control stop is seen to be running before it gets
into its ptrace stop.  It might not matter if /proc/pid/status can be
read to see "R (running)" for such a window.  But certainly it should
not have CLD_CONTINUED behavior (SIGCHLD and waitid visibility), nor
report a CLD_TRAPPED stop via SIGCHLD or wait after it was already stopped.

[tj:]
> Yes, before the change, the task would respond to SIGCONT before the
> first ptrace request succeeds after attach.  To me, this doesn't seem
> to be anything intentional tho.  It seems a lot of ptrace and group
> stop interactions is in the grey area with only the current (quirky,
> I'm afraid) behavior drawing almost arbitrary lines across different
> behaviors.

That is largely true.  But userland programs like gdb and strace have
gone to lots of contortions to work with the behavior as it is, and we
should not break what works in practice for them.

> We can try to preserve all those behaviors but I don't think that will
> be very beneficial.  I think the best way to proceed would be
> identifying the sensible and depended upon assumptions and then draw
> clear lines from there stating what's guaranteed and what's undefined.
> We'll have to keep some of quirkiness for sure.

I agree with this overall.  But we must consider whatever weirdness
comes up in ptrace.

> Anyways, pondering and verifying all the possibly visible changes
> definitely is necessary, but that said, we fortunately have rather
> limited number of ptrace users and their usages don't seem to be too
> wild (at least on my cursory investigation), so I think it to be
> doable without breaking anything noticeably.  But yeap we definitely
> need to be careful.

There are more ptrace users than you might think, though indeed there
are few of them that are widely-known and free code (strace and gdb).
Most every ptrace user out there has worked with the manifest behavior
seen on existing kernels rather than trying to understand any sound
principles of behavior, because it's been to hard to figure out.

> And, for longer term, I think it would be a good idea to separate
> group stop and ptrace trap mechanisms, so that ptrace trap works
> properly on per-task level and properly transparent from group stop
> handling.  The intertwining between the two across different domains
> of threads inhfferently involves a lot of grey areas where there is no
> good intuitive behavior.

I quite agree.  The best way to fix this is with sane semantics for
normal job-control operations when traced.  But ptrace has never had
that before and it's just not possible both to be sane and to match
the expected behavior of the traditional ptrace semantics.  Hence I
lean towards leaving things as much as possible as they are today when
only the ptrace operations we have today are used.

> IIUC, it dumps the register window to userland memory.  ia64 has this
> stacked windows of registers which gets wound up and unwound according
> to function calls and those need to be dumped to userland memory so
> that the debugger can PEEK and POKE them.  Not really sure why
> skipping it didn't cause any problem until now tho.

It's not necessarily that it didn't cause any problem.  It's more
likely that it's hard to notice, because the problems are so arcane.
It's also entirely possible that the remaining problematic cases just
happen to be vanishingly rare because of other factors--e.g., between
when something entered job-control stop and when ptrace was used, the
system is likely to have had enough other pressure on its magical
register caches that they got flushed anyway.  Moreover, the current
method with arch_ptrace_stop was only added relatively recently--on
the time scale for the actual users of these machines (in 2.6.28 for
sparc, in 2.6.25 for ia64).  Before that, ia64's PTRACE_PEEKDATA et al
used terrible arch-specific kludges to read the unflushed register
data rather than the real user memory (I don't know if sparc had
something similar).

> I think it would be better to introduce a few new ptrace operations
> and give them more control in clearly defined and hopefully intutive
> way.  For example, a ptracer is notified when a task is stopping for
> group stop and it should be able to decide and tell the kernel whether
> to participate in the group stop or not.  For SIGCONT, likewise, the
> kernel can notify all ptracers in the group and can notify the real
> parent if all ptracers decide to participate in the continuation.

I certainly agree that we should have some new operations or modes of
tracing and have them behave sanely.  I don't think the details you've
described here are exactly what would make sense, however.

IMHO there should be no discretion about whether a thread participates
in a group stop.  If a group stop is happening, every thread must be
stopped ASAP and the debugger should not be able to interfere with
that.  (The time for the debugger to interfere is when it gets the
chance to intercept the stop signal before it's delivered.)  If a
thread is stop for tracing when a group stop happens, then the right
way to think about its state is "both stopped for tracing and stopped
for job-control".  When the tracer says it can resume, it goes to
simply "stopped for job-control".  Likewise, if before that a SIGCONT
is generated, then it goes to simply "stopped for tracing" and does
not prevent the normal CLD_CONTINUED notification from happening.
That is, to the non-debugger parts of the system, it's no different
from if the debugger stopped that thread for tracing immediately after
SIGCONT resumed it and before it had a chance to do anything else.
(This is exactly the model we tried to implement in utrace.)

I've read over the rest of the long thread from December and will
reply further to the later iterations of the patches shortly.  I'm
sorry if I've replied to stale issues or overlooked questions still
needing answers.  I hope we can all get caught up to discussing the
same things this week.


Thanks,
Roland

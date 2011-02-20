Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab1BTSw1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 13:52:27 -0500
Received: from host1.dyn.jankratochvil.net ([89.250.240.48]:49639 "EHLO
	host1.dyn.jankratochvil.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754656Ab1BTSw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 13:52:26 -0500
Date: Sun, 20 Feb 2011 19:52:04 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110220185204.GA14737@host1.dyn.jankratochvil.net>
References: <20110219201603.GB8662@redhat.com>
 <20110219200637.GA8662@redhat.com>
 <20110220094050.GA7714@host1.dyn.jankratochvil.net>
 <20110220171658.GA27355@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110220171658.GA27355@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Feb 2011 18:16:58 +0100, Oleg Nesterov wrote:
> On 02/20, Jan Kratochvil wrote:
> > In GDB you can control as a user the way you want to continue the process:
> > 	(gdb) signal SIGCONT
> > 	Continuing with signal SIGCONT.
> 
> This just sets the argument for PTRACE_CONT, afaics

Yes.


> > > IOW. To simplify. Suppose we have a task in 'T (stopped)' state. Then
> > > debugger comes and does
> > >
> > > 	ptrace(PTRACE_ATTACH);
> > > 	PTRACE(PTRACE_CONT, 0);
> > >
> > > With the current code the tracee runs after that. We want to change
> > > the kernel so that the tracee won't run, but becomes 'T (stopped)'
> > > again. It only runs when it gets SIGCONT.
> > >
> > > Do you agree with such a change?
> > >
> > >
> > > And yes, yes,
> > >
> > > 	ptrace(PTRACE_ATTACH);
> > > 	ptrace(PTRACE_DETACH, 0)
> > >
> > > should leave it stopped too, of course.
> >
> > GDB (and I believe nobody else) does PTRACE_ATTACH without wait->SIGSTOP,
> > otherwise it would make `(T) stopped' regular processes.  So I find your
> > question irrelevant.
> 
> Not sure I understand why "without wait->SIGSTOP" matters. The tracee
> was stopped before attach. If you mean the bugs like
> wait-can-hang-after-attach they should be fixed, but this is another
> story.

If I do (on kernel-debug-2.6.35.11-83.fc14.x86_64)
	ptrace (PTRACE_ATTACH);
	sleep (1);
	ptrace (PTRACE_DETACH, 0);

even without the wait() it really has no effect.  I thought it will do like:
	ptrace (PTRACE_ATTACH);
	exit (0);

which will make the debuggee `T (stopped)'.


> > as one can do:
> > 	# kill -STOP applicationpid
> > 	# gdb -p applicationpid
> > 	(gdb) print getpid()
> 
> This calls the function on behalf of the tracee, yes?

Yes.


> In this case, if we do the proposed change, getpid() won't run until
> SIGCONT comes.

And this is such an incompatibility issue you were asking about.

OTOH FSF GDB can attach to `T (stopped)' processes only since 2008 (released
2009) and I have never seen non-commercial users to have any issues with
`T (stopped)' processes so the whole SIGSTOP backward compatibilities for FSF
GDB may not make much sense.


> > 	(gdb) quit
> > 	# expecting applicationpid is still stopped, which currently is not.
> 
> I am not sure this expectation is correct, with or without the proposed
> change.
> 
> The tracee was stopped. gdb makes it running. If gdb wants it stopped,
> it should take care during/before the detach. Like it should restore
> eip before detach. The kernel can't know what ptracer wants.

The ptracer does PTRACE_DETACH(0), therefore to "restore the original state".
If GDB uses uprobes one day it would also expect removal of breakpoints from
the inferior.  The same situation applies for intentional or unintentional
(crash) _exit() of the debugger.


> > > This can't be right.  I'd say, it doesn't make sense to take the state of
> > > the tracee before PTRACE_ATTACH into account. What does matter, is its state
> > > before PTRACE_DETACH.
> >
> > I do not agree with this point.  Real world debugging programs are buggy
> 
> Of course. But the kernel can't know how it should "fix" the bugs in the
> user-space. The kernel itself has a lot of bugs which we are trying to fix ;)

The same way it automatically frees memory, closes file descriptors etc. it
can also restore the debugee's state.  Unless the debugger enforces
`T (stopped)' by PTRACE_DETACH (SIGSTOP) or cancels any saved `T (stopped)' by
PTRACE_DETACH (SIGCONT).


> What if the correct apllication attaches to the stopped task and want to
> resume it and detach?

PTRACE_DETACH (SIGCONT)


> Why the kernel should remember the state of the tracee
> _before_ it was attached and then always restore this state?

As it does for other resources (memory/fds).  One day it should do it even
with hardware watchpoints (hw_breakpoint) and software breakpoints (uprobes).


> Jan, I think this is irrelevant. Once again. We are trying to enforce the
> very simple rule: the stopped tracee remains stopped until it gets SIGCONT.

I do not mind but you asked about compatibility with GDB and this breaks a use
case of post-2008 GDB.

I think such incompatibility is acceptable as there was the eaten-out SIGSTOP
notification so `T (stopped)' processes could not be debugged for many years
by GDB before 2008 anyway.


> Now, again. The tracee was 'T (stopped)' before attach. Then gdb comes,
> plays with the tracee, and does PTRACE_DETACH. In this case the tracee
> should be stopped unless it gets SIGCONT before detach.

Here is a mix of two issues:

I have shown you why it should be `(T) stopped' (on PTRACE_DETACH(0)) even if
GDB did whatever while the inferior is under debug.  This is a new feature and
not a compatibility issue.

Another issue is debuggee's inferior function calls will not work for
`(T) stopped'-on-attach processes.  This is backward incompatible change but
IMO acceptable as such case did not work till 2008 (2009 release) FSF GDB.


> If gdb wants to resume the tracee temporary (say, call getpid()) it should
> send SIGCONT itself.

This is a new feature.  GDB can do whatever as a new feature.  The problem is
existing GDBs do not do it.  And for some reason (probably as each vendor has
GDB patched a lot) there remain very old GDBs in use out there.


> And in this case, if gdb wants the stopped tracee after detach - it should
> take care. It can send another SIGSTOP or do ptrace(PTRACE_DETACH, SIGSTOP).

GDB can crash (yes, it happens), then it will accidentally resume the
inferior.  There also exist other tools (proprietary TotalView debugger etc.)
which I cannot speak for, if they can already attach to `(T) stopped'
processes (and would get broken by the new behavior in such case).



Thanks,
Jan

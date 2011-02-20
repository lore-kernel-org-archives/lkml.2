Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab1BTJlO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 04:41:14 -0500
Received: from host1.dyn.jankratochvil.net ([89.250.240.48]:35318 "EHLO
	host1.dyn.jankratochvil.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752165Ab1BTJlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 04:41:11 -0500
Date: Sun, 20 Feb 2011 10:40:50 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110220094050.GA7714@host1.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110219201603.GB8662@redhat.com>
 <20110219200637.GA8662@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Feb 2011 21:06:37 +0100, Oleg Nesterov wrote:
> On 02/18, Jan Kratochvil wrote:
> > If the application being investigated changes state between the various tools
> > it may be confusing as the dumps will not match.  Ale in some cases some
> > critical state being investigated may get lost.
> 
> Which state can be changed?
> 
> Of course, the tracee shouldn't return to the user-space before the
> stop, it shouldn't change its registers or anything which can be
> noticed by gcore/gstack/etc.

Yes, I meant this.

> But why it can't do any single PC step in kernel?

I do not know about the kernel internals.


> > I do not think
> > ptrace is a good tool for some general system monitoring - to see any
> > SIGCONT/SIGSTOP deliveries - because ptrace is (a) single-master limited
> > (second PTRACE_ATTACH gets EPERM)
> 
> This is what I certainly can't understand,
> 
> > and (b) ptrace-control is not transparent
> > due to the threads/races timing (on `t (tracing stop)').
> 
> We are going to try to fix this races,

No, even if ptrace will be perfect with the current design of ptrace it will
be affecting timing of its debuggee.

>From practice - GDB (which is single-threaded) is debugging multi-threaded
application and there are some bugs in GDB regarding proper handling of the
multi-threading events.  If you: strace gdb multithreadedapp -ex 'run'
then the bugs are no longer visible as strace-ing gdb will slow it down
compared to multithreadedapp so that the bugs in GDB are no longer
reproducible.

In such cases I used debug printf()s in GDB before without strace, nowadays
I can use systemtap instead of strace and the bug can be still reproducible.

This is why I believe when we design ptrace we should target more the
intrusive debugging tools than non-intrusive tracing tools as nowadays there
are better non-intrusive tracing ways than ptrace.


> Jan. Could you please explicitly answer our question? We have the numerious
> problems with jctl and ptrace. Everything is just broken. And it is broken
> by design, that is why it is not easy to fix the code: we should first
> discuss what do we want to get in result. Please forget about attach/detach
> for the moment. I'll repeat my question:
> 
> 	Suppose that the tracee is 'T (stopped)'. Because the debugger did
> 	PTRACE_CONT(SIGSTOP), or because debugger attached to the stopped task.
> 
> 	Currently, PTRACE_CONT(WHATEVER) after that always resumes the tracee,
> 	despite the fact it is still stopped in some sense. This leads to
> 	numerous oddities/bugs.
> 
> 	What we propose is to change this so that the tracee does not run
> 	until it actually recieves SIGCONT.
> 
> Is it OK for gdb or not?

>From GDB I do not see a problem.  It will change interactive behavior when
SIGSTOP is received, we can put a warning there when GDB does
PTRACE_CONT(SIGSTOP) so that the user knows (s)he should do external SIGCONT
and that the debugging is not broken.

When we talk about FSF GDB there isn't too much SIGSTOP-related code present.
There is the PTRACE_ATTACH-trick referenced before
	http://sourceware.org/cgi-bin/cvsweb.cgi/src/gdb/linux-nat.c.diff?r1=1.80&r2=1.81&cvsroot=src

There is also heavily used tkill(SIGSTOP), wait->SIGSTOP, PTRACE_CONT(0)
instead of some PTRACE_INTERRUPT (to stop each thread without affecting its
later run in any way).  This should not be changed.

With Fedora/RHEL GDB there were always hacks matching its specific Fedora/RHEL
kernel version which is offtopic here.

In GDB you can control as a user the way you want to continue the process:
	(gdb) signal SIGCONT
	Continuing with signal SIGCONT.
	(gdb) help signal
	Continue program giving it signal specified by the argument.
	An argument of "0" means continue program without giving it a signal.

Sure by default GDB does not do anything special, it will respawn (using
PTRACE_CONT(SIGSTOP)) any SIGSTOP it sees due to the default setting of:
	(gdb) handle SIGSTOP
	Signal        Stop  Print Pass to program Description
	SIGSTOP       Yes Yes Yes   Stopped (signal)

Therefore there happens the double SIGSTOP reporting as discussed before:
	(gdb) run
	Starting program: /bin/sleep 1h
	# external kill -STOP <inferior pid>
	Program received signal SIGSTOP, Stopped (signal).
	# State:	t (tracing stop)
	(gdb) continue 
	Continuing.
	Program received signal SIGSTOP, Stopped (signal).
	# State:	t (tracing stop)
	(gdb) continue 
	Continuing.
	# State:	S (sleeping)

Your proposal is I expect:
	(gdb) run
	Starting program: /bin/sleep 1h
	# external kill -STOP <inferior pid>
	Program received signal SIGSTOP, Stopped (signal).
	# State:	t (tracing stop)
	(gdb) continue 
	Continuing.
	# State:	T (stopped)

For non-interactive gstack (backtrace) / gcore (core dumping) GDB does not do
any PTRACE_CONT so it is offtopic here.

Upstream GDB always does PTRACE_DETACH(0).  Unexpected detach behavior would
be unwise but we do not discuss the PTRACE_DETACH here.


> IOW. To simplify. Suppose we have a task in 'T (stopped)' state. Then
> debugger comes and does
> 
> 	ptrace(PTRACE_ATTACH);
> 	PTRACE(PTRACE_CONT, 0);
> 
> With the current code the tracee runs after that. We want to change
> the kernel so that the tracee won't run, but becomes 'T (stopped)'
> again. It only runs when it gets SIGCONT.
> 
> Do you agree with such a change?
> 
> 
> And yes, yes,
> 
> 	ptrace(PTRACE_ATTACH);
> 	ptrace(PTRACE_DETACH, 0)
> 
> should leave it stopped too, of course.

GDB (and I believe nobody else) does PTRACE_ATTACH without wait->SIGSTOP,
otherwise it would make `(T) stopped' regular processes.  So I find your
question irrelevant.

If you ask about:
	ptrace(PTRACE_ATTACH);
	waitpid; eat SIGSTOP (being aware it may not be the first signal)
	PTRACE(PTRACE_CONT, 0);

Then I believe the debugee should run (and not to be stopped) as one can do:
	# kill -STOP applicationpid
	# gdb -p applicationpid
	(gdb) print getpid()
	(gdb) print show_me_your_internal_debug_dump()
	(gdb) quit
	# expecting applicationpid is still stopped, which currently is not.

The inferior calls are implemented as:
	PTRACE_GETREGS - save them somewhere
	PTRACE_SETREGS - change $RIP to show_me_your_internal_debug_dump
	PTRACE_CONT(0)
	waitpid->SIGTRAP - breakpoint show_me_your_internal_debug_dump returned
	PTRACE_SETREGS - restore the initial rgisters

Your other case:
	ptrace(PTRACE_ATTACH);
	waitpid; eat SIGSTOP (being aware it may not be the first signal)
	ptrace(PTRACE_DETACH, 0)

if inferior was `(T) stopped' before currently does not leave inferior
`(T) stopped'.  It would be good if this changes.

Also if GDB (or other debugging/tracing tool) crashes kernel does automatic
PTRACE_DETACH.  In such case if the inferior was `(T) stopped' it should be
still kept `(T) stopped'.


On Sat, 19 Feb 2011 21:16:03 +0100, Oleg Nesterov wrote:
> On 02/18, Jan Kratochvil wrote:
> >
> > On Thu, 17 Feb 2011 20:19:52 +0100, Oleg Nesterov wrote:
> > > > > That is after PTRACE_DETACH(0) the process should remain `T (stopped)'
> > > > > iff the process was `T (stopped)' before PTRACE_ATTACH.
> > > > >  - PTRACE_DETACH(0)       should preserve `T (stopped)'.
> > > >
> > > > I assume you are thinking about PTRACE_ATTACH + wait():SIGSTOP
> > > > + PTRACE_DETACH(0) sequence.
> > >
> > > plus it should be stopped before attach, I assume. Otherwise this
> > > not true with the current code.
> >
> > I did not talk about the current code.  I was making a proposal of new
> > behavior (which should not break existing software).
> 
> Confused.
> 
> > If PTRACE_ATTACH was done on process with `T (stopped)'
> 
> this matters "it should be stopped before attach"
> 
> > then after
> > PTRACE_DETACH(0) again the process should be `T (stopped)'.
> 
> Regardless of what the debugger did in between?

Yes.

> This can't be right.  I'd say, it doesn't make sense to take the state of
> the tracee before PTRACE_ATTACH into account. What does matter, is its state
> before PTRACE_DETACH.

I do not agree with this point.  Real world debugging programs are buggy
various ways and if they break you do not want to accidentally resume the `T
(stopped)' inferior under investigation.


> If the debugger did not resume the tracee before PTRACE_DETACH, then
> of course I agree, PTRACE_DETACH(0) should preserve T (stopped).

There are the common inferior calls in use, mostly because the debugger (GDB)
does not (even more before Python scripting was implemented) provide enough
user-providable per-application debugging facilities so they got implemented
into the inferiors themselves and people use GDB inferior calls to call them.


Thanks,
Jan

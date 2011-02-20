Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab1BTRZY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 12:25:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab1BTRZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 12:25:18 -0500
Date: Sun, 20 Feb 2011 18:16:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110220171658.GA27355@redhat.com>
References: <20110219201603.GB8662@redhat.com> <20110219200637.GA8662@redhat.com> <20110220094050.GA7714@host1.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110220094050.GA7714@host1.dyn.jankratochvil.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20, Jan Kratochvil wrote:
>
> On Sat, 19 Feb 2011 21:06:37 +0100, Oleg Nesterov wrote:
> > On 02/18, Jan Kratochvil wrote:
> > > If the application being investigated changes state between the various tools
> > > it may be confusing as the dumps will not match.  Ale in some cases some
> > > critical state being investigated may get lost.
> >
> > Which state can be changed?
> >
> > Of course, the tracee shouldn't return to the user-space before the
> > stop, it shouldn't change its registers or anything which can be
> > noticed by gcore/gstack/etc.
>
> Yes, I meant this.

OK, I misunderstood. Agreed, it shouldn't change the state.

> > > and (b) ptrace-control is not transparent
> > > due to the threads/races timing (on `t (tracing stop)').
> >
> > We are going to try to fix this races,
>
> No, even if ptrace will be perfect with the current design of ptrace it will
> be affecting timing of its debuggee.

Ah, indeed this is true, I misunderstood you again. In particular, yes, strace
shadows the problems quite often.

> This is why I believe when we design ptrace we should target more the
> intrusive debugging tools than non-intrusive tracing tools as nowadays there
> are better non-intrusive tracing ways than ptrace.

Perhaps. (I am not sure systemtap is always the right answer, and utrace
was designed with "non-intrusive tracing" in mind (I think), but this
off-topic too).

> > Jan. Could you please explicitly answer our question? We have the numerious
> > problems with jctl and ptrace. Everything is just broken. And it is broken
> > by design, that is why it is not easy to fix the code: we should first
> > discuss what do we want to get in result. Please forget about attach/detach
> > for the moment. I'll repeat my question:
> >
> > 	Suppose that the tracee is 'T (stopped)'. Because the debugger did
> > 	PTRACE_CONT(SIGSTOP), or because debugger attached to the stopped task.
> >
> > 	Currently, PTRACE_CONT(WHATEVER) after that always resumes the tracee,
> > 	despite the fact it is still stopped in some sense. This leads to
> > 	numerous oddities/bugs.
> >
> > 	What we propose is to change this so that the tracee does not run
> > 	until it actually recieves SIGCONT.
> >
> > Is it OK for gdb or not?
>
> From GDB I do not see a problem.  It will change interactive behavior when
> SIGSTOP is received, we can put a warning there when GDB does
> PTRACE_CONT(SIGSTOP) so that the user knows (s)he should do external SIGCONT
> and that the debugging is not broken.

OK, thanks.

> There is also heavily used tkill(SIGSTOP), wait->SIGSTOP, PTRACE_CONT(0)
> instead of some PTRACE_INTERRUPT (to stop each thread without affecting its
> later run in any way).  This should not be changed.

This should work, afaics.

> In GDB you can control as a user the way you want to continue the process:
> 	(gdb) signal SIGCONT
> 	Continuing with signal SIGCONT.

This just sets the argument for PTRACE_CONT, afaics

> Sure by default GDB does not do anything special, it will respawn (using
> PTRACE_CONT(SIGSTOP)) any SIGSTOP it sees due to the default setting of:

OK,

> Therefore there happens the double SIGSTOP reporting as discussed before:
> 	(gdb) run
> 	Starting program: /bin/sleep 1h
> 	# external kill -STOP <inferior pid>
> 	Program received signal SIGSTOP, Stopped (signal).
> 	# State:	t (tracing stop)
> 	(gdb) continue
> 	Continuing.
> 	Program received signal SIGSTOP, Stopped (signal).
> 	# State:	t (tracing stop)
> 	(gdb) continue
> 	Continuing.
> 	# State:	S (sleeping)
>
> Your proposal is I expect:
> 	(gdb) run
> 	Starting program: /bin/sleep 1h
> 	# external kill -STOP <inferior pid>
> 	Program received signal SIGSTOP, Stopped (signal).
> 	# State:	t (tracing stop)
> 	(gdb) continue
> 	Continuing.
> 	# State:	T (stopped)

Yes, I expect the same.

> > IOW. To simplify. Suppose we have a task in 'T (stopped)' state. Then
> > debugger comes and does
> >
> > 	ptrace(PTRACE_ATTACH);
> > 	PTRACE(PTRACE_CONT, 0);
> >
> > With the current code the tracee runs after that. We want to change
> > the kernel so that the tracee won't run, but becomes 'T (stopped)'
> > again. It only runs when it gets SIGCONT.
> >
> > Do you agree with such a change?
> >
> >
> > And yes, yes,
> >
> > 	ptrace(PTRACE_ATTACH);
> > 	ptrace(PTRACE_DETACH, 0)
> >
> > should leave it stopped too, of course.
>
> GDB (and I believe nobody else) does PTRACE_ATTACH without wait->SIGSTOP,
> otherwise it would make `(T) stopped' regular processes.  So I find your
> question irrelevant.

Not sure I understand why "without wait->SIGSTOP" matters. The tracee
was stopped before attach. If you mean the bugs like
wait-can-hang-after-attach they should be fixed, but this is another
story.

> If you ask about:
> 	ptrace(PTRACE_ATTACH);
> 	waitpid; eat SIGSTOP (being aware it may not be the first signal)
> 	PTRACE(PTRACE_CONT, 0);
>
> Then I believe the debugee should run (and not to be stopped)

Can't understand... waitpid() does not eat SIGSTOP. It only eats the
notification. PTRACE(PTRACE_CONT, 0) cancels/eats the pending SIGSTOP
which was sent during ATTACH, but only if it was already dequeued
(iow, waitpid() succeeds exactly because of that SIGSTOP sent by
PTRACE_ATTACH).

So. If the tracee was not stopped before PTRACE_ATTACH - it should run.
Otherwise it should wait for SIGCONT to resume.

> as one can do:
> 	# kill -STOP applicationpid
> 	# gdb -p applicationpid
> 	(gdb) print getpid()

This calls the function on behalf of the tracee, yes?

In this case, if we do the proposed change, getpid() won't run until
SIGCONT comes.

> 	(gdb) quit
> 	# expecting applicationpid is still stopped, which currently is not.

I am not sure this expectation is correct, with or without the proposed
change.

The tracee was stopped. gdb makes it running. If gdb wants it stopped,
it should take care during/before the detach. Like it should restore
eip before detach. The kernel can't know what ptracer wants.

> Your other case:
> 	ptrace(PTRACE_ATTACH);
> 	waitpid; eat SIGSTOP (being aware it may not be the first signal)
> 	ptrace(PTRACE_DETACH, 0)
>
> if inferior was `(T) stopped' before currently does not leave inferior
> `(T) stopped'.  It would be good if this changes.

Yes. IOW, in this case attach/detach should not change the state of
the tracee. If it was stopped it should be leaved stopped, otherwise
it should continue to run.

> > > then after
> > > PTRACE_DETACH(0) again the process should be `T (stopped)'.
> >
> > Regardless of what the debugger did in between?
>
> Yes.
>
> > This can't be right.  I'd say, it doesn't make sense to take the state of
> > the tracee before PTRACE_ATTACH into account. What does matter, is its state
> > before PTRACE_DETACH.
>
> I do not agree with this point.  Real world debugging programs are buggy

Of course. But the kernel can't know how it should "fix" the bugs in the
user-space. The kernel itself has a lot of bugs which we are trying to fix ;)

What if the correct apllication attaches to the stopped task and want to
resume it and detach? Why the kernel should remember the state of the tracee
_before_ it was attached and then always restore this state?

But probably (I hope) I misunderstood you.

> > If the debugger did not resume the tracee before PTRACE_DETACH, then
> > of course I agree, PTRACE_DETACH(0) should preserve T (stopped).
>
> There are the common inferior calls in use, mostly because the debugger (GDB)
> does not (even more before Python scripting was implemented) provide enough
> user-providable per-application debugging facilities so they got implemented
> into the inferiors themselves and people use GDB inferior calls to call them.

See above (getpid() example).


Jan, I think this is irrelevant. Once again. We are trying to enforce the
very simple rule: the stopped tracee remains stopped until it gets SIGCONT.
No matter what gdb does (unless of course it sends this signal itself) the
tracee doesn't run (lets ignore SIGKILL to simplify the further discussion).

And it doesn't matter why it is stopped, either because it was already
stopped before attach or it was stopped during the debug session (iow,
gdb acks SIGSTOP recieved while the task was ptraced).

Now, again. The tracee was 'T (stopped)' before attach. Then gdb comes,
plays with the tracee, and does PTRACE_DETACH. In this case the tracee
should be stopped unless it gets SIGCONT before detach. And if it gets
SIGCONT it is no longer stopped, the kernel shouldn't ignore SIGCONT.

If gdb wants to resume the tracee temporary (say, call getpid()) it should
send SIGCONT itself.

And in this case, if gdb wants the stopped tracee after detach - it should
take care. It can send another SIGSTOP or do ptrace(PTRACE_DETACH, SIGSTOP).

Oleg.


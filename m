Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1BTUrJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 15:47:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab1BTUrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 15:47:08 -0500
Date: Sun, 20 Feb 2011 21:38:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110220203819.GB32682@redhat.com>
References: <20110219201603.GB8662@redhat.com> <20110219200637.GA8662@redhat.com> <20110220094050.GA7714@host1.dyn.jankratochvil.net> <20110220171658.GA27355@redhat.com> <20110220185204.GA14737@host1.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110220185204.GA14737@host1.dyn.jankratochvil.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20, Jan Kratochvil wrote:
>
> On Sun, 20 Feb 2011 18:16:58 +0100, Oleg Nesterov wrote:
> > > > IOW. To simplify. Suppose we have a task in 'T (stopped)' state. Then
> > > > debugger comes and does
> > > >
> > > > 	ptrace(PTRACE_ATTACH);
> > > > 	PTRACE(PTRACE_CONT, 0);
> > > >
> > > > With the current code the tracee runs after that. We want to change
> > > > the kernel so that the tracee won't run, but becomes 'T (stopped)'
> > > > again. It only runs when it gets SIGCONT.
> > > >
> > > > Do you agree with such a change?
> > > >
> > > >
> > > > And yes, yes,
> > > >
> > > > 	ptrace(PTRACE_ATTACH);
> > > > 	ptrace(PTRACE_DETACH, 0)
> > > >
> > > > should leave it stopped too, of course.
> > >
> > > GDB (and I believe nobody else) does PTRACE_ATTACH without wait->SIGSTOP,
> > > otherwise it would make `(T) stopped' regular processes.  So I find your
> > > question irrelevant.
> >
> > Not sure I understand why "without wait->SIGSTOP" matters. The tracee
> > was stopped before attach. If you mean the bugs like
> > wait-can-hang-after-attach they should be fixed, but this is another
> > story.
>
> If I do (on kernel-debug-2.6.35.11-83.fc14.x86_64)
> 	ptrace (PTRACE_ATTACH);
> 	sleep (1);
> 	ptrace (PTRACE_DETACH, 0);
>
> even without the wait() it really has no effect.

Well. what does this "has no effect" mean? ;) I am totally confused.
We were talking about the case when the tracee was stopped before
attach, right?

(In this case I don't understand sleep() above, but this doesn't matter)

In this case it should be stopped after detach, do you agree?

And it will be stopped with or without the proposed change. And it will
be stopped with the current kernel.

So, I still can't understand...

If you meant the failing detach-stopped test-case, then please note
that it differs, mostly because it is multithreaded. And it fails
because (again! ;) we have more problems here. I already mentioned
them: the wrong wakeup and the broken SIGNAL_STO_DEQUEUED logic.

> > In this case, if we do the proposed change, getpid() won't run until
> > SIGCONT comes.
>
> And this is such an incompatibility issue you were asking about.

Sure, I understand. Like in your previous example,

	> >     # State:        t (tracing stop)
	> >     (gdb) continue
	> >     Continuing.
	> >     # State:        T (stopped)

this is the same user-visible change.

That is why we are asking you, we need your opinion: whether this
change is acceptable or not for gdb.

> > The tracee was stopped. gdb makes it running. If gdb wants it stopped,
> > it should take care during/before the detach. Like it should restore
> > eip before detach. The kernel can't know what ptracer wants.
>
> The ptracer does PTRACE_DETACH(0), therefore to "restore the original state".
> If GDB uses uprobes one day it would also expect removal of breakpoints from
> the inferior.  The same situation applies for intentional or unintentional
> (crash) _exit() of the debugger.

This doesn't explain why the kernel should restore TASK_STOPPED.
Suppose the tracee creates the file when it was run under debugger,
should the kernel remove this file after detach? STOPPED->RUNNING
transition is the same, I think. And, if SIGCONT comes in between,
the tracee is no longer stopped. It needs another SIGSTOP, gdb can
do this via ptrace(DETACH, SIGSTOP).

> > > > This can't be right.  I'd say, it doesn't make sense to take the state of
> > > > the tracee before PTRACE_ATTACH into account. What does matter, is its state
> > > > before PTRACE_DETACH.
> > >
> > > I do not agree with this point.  Real world debugging programs are buggy
> >
> > Of course. But the kernel can't know how it should "fix" the bugs in the
> > user-space. The kernel itself has a lot of bugs which we are trying to fix ;)
>
> The same way it automatically frees memory, closes file descriptors etc. it
> can also restore the debugee's state.

Then why gdb has to restore $RIP after '(gdb) print getpid()' + detach?
following your logic, this should be handled by the kernel as well.

In any case. This doesn't work currently, and it was never supposed to
work. If you think we need this new (and imho very wrong ;) feature -
lets discuss this separately.

> > What if the correct apllication attaches to the stopped task and want to
> > resume it and detach?
>
> PTRACE_DETACH (SIGCONT)

This was already discussed and you even managed to confuse me ;) Initially
I was going to agree with this special case, but then I agreed with Denys
and after that Roland nacked this approach.

> > Jan, I think this is irrelevant. Once again. We are trying to enforce the
> > very simple rule: the stopped tracee remains stopped until it gets SIGCONT.
>
> I do not mind but you asked about compatibility with GDB and this breaks a use
> case of post-2008 GDB.

Of course! Of course this is user-visible change, that is why we are asking
you.

The problem is, _any_ fix in this area is user-visible. By definition ;)
Even if we fix the obvious bug (like this damn wrong wakeup) we can
break something.

Let me remind. ptrace_detach()->wake_up_process() is just wrong. I tried
to remove it, but then later this patch was reverted because gdb was not
happy. But. If we keep this wakeup, then PTRACE_DETACH can _never_ leave
the tracee in the stopped state reliably, whatever we do. So, what we can
do? We are going to kill it again, even if this can break something else.
All this code is just wrong. We can not magically change it so that
everything will be happy.

> I think such incompatibility is acceptable as there was the eaten-out SIGSTOP
> notification so `T (stopped)' processes could not be debugged for many years
> by GDB before 2008 anyway.

OK, thanks.

So. So far I assume you are not against this change ;)

> > Now, again. The tracee was 'T (stopped)' before attach. Then gdb comes,
> > plays with the tracee, and does PTRACE_DETACH. In this case the tracee
> > should be stopped unless it gets SIGCONT before detach.
>
> Here is a mix of two issues:
>
> I have shown you why it should be `(T) stopped' (on PTRACE_DETACH(0)) even if
> GDB did whatever while the inferior is under debug.

I disagree ;) but,

> This is a new feature and
> not a compatibility issue.

Yes. So lets discuss this separately as the new-feature-request.

> Another issue is debuggee's inferior function calls will not work for
> `(T) stopped'-on-attach processes.  This is backward incompatible change but
> IMO acceptable as such case did not work till 2008 (2009 release) FSF GDB.

OK,

> > If gdb wants to resume the tracee temporary (say, call getpid()) it should
> > send SIGCONT itself.
>
> This is a new feature.  GDB can do whatever as a new feature.  The problem is
> existing GDBs do not do it.

Yes, yes, sure, I understand. Again, and again, this is the user-visible
change and that is why we need your opinion.

> > And in this case, if gdb wants the stopped tracee after detach - it should
> > take care. It can send another SIGSTOP or do ptrace(PTRACE_DETACH, SIGSTOP).
>
> GDB can crash (yes, it happens), then it will accidentally resume the
> inferior.

See above.

Oleg.


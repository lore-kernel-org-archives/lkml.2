Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab1BSUPZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 15:15:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab1BSUPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 15:15:24 -0500
Date: Sat, 19 Feb 2011 21:06:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110219200637.GA8662@redhat.com>
References: <20110204105343.GA12133@htj.dyndns.org> <20110207174821.GA1237@redhat.com> <20110209141803.GH3770@htj.dyndns.org> <201102132325.55353.vda.linux@googlemail.com> <20110214151340.GP18742@htj.dyndns.org> <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com> <20110216215157.GA6054@host1.dyn.jankratochvil.net> <20110217164906.GA5167@redhat.com> <20110218213429.GB2066@host1.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110218213429.GB2066@host1.dyn.jankratochvil.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18, Jan Kratochvil wrote:
>
> On Thu, 17 Feb 2011 17:49:06 +0100, Oleg Nesterov wrote:
> > > - that is to leave the process in
> > > `T (stopped)' without any single PC step.
> >
> > This is not exactly clear to me... I mean "without any single PC step".
> > Why?
>
> Engineers investigating problems of applications SIGSTOP it when it is in the
> critical situation.  Then they run gcore, gstack etc.  After they are
> satisfied with the analsysis they send SIGCONT.
>
> If the application being investigated changes state between the various tools
> it may be confusing as the dumps will not match.  Ale in some cases some
> critical state being investigated may get lost.

Which state can be changed?

Of course, the tracee shouldn't return to the user-space before the
stop, it shouldn't change its registers or anything which can be
noticed by gcore/gstack/etc. But why it can't do any single PC step
in kernel?

> > > A new proposal is to preserve the process's `T (stopped)' for
> > > a naive/legacy debugger / ptrace tool doing PTRACE_ATTACH, wait->SIGSTOP,
> > > PTRACE_DETACH(0), incl. GDB doing the "GDB trick" above.
> > > That is after PTRACE_DETACH(0) the process should remain `T (stopped)'
> > > iff the process was `T (stopped)' before PTRACE_ATTACH.
> > >  - PTRACE_DETACH(0)       should preserve `T (stopped)'.
> >
> > Hmm. OK, but I assume you meant "unless the tracee was resumed in between".
>
> You described the exact behavior of current Fedora/RHEL gdb.  But in general
> I do not insist on it, one can for example run an inferior function call
> during the investigation-under-SIGSTOP described above, even in such case one
> still wants to detach the application still in the `T (stopped)' mode.
>
> Detaching process as '(T) stopped' is not such a problem as the app/user can
> send SIGCONT to it.  But accidentally unstopping the process during detach
> cannot be fixed/workarounded.

Now I am confused. I do not really understand what do you want, but
I feel that what you are trying to suggest is not very right (or I
misunderstood you).

But, once again, I think this should be discussed in another thread.
Yes, we have multiple "it-doesnt-stop-after-detach" problems, but we
can't discuss all problems in this thread.

> > But. Let me remind. PTRACE_DETACH(SIGXXX) does not always work as
> > gdb thinks, SIGXXX can be ignored.
>
> In such case it is a bug.

Well, may be this is bug, may be not. This is fact ;) Perhaps we should
change this but, again, we need another thread for discussion.

And, btw, we already discussed this. I explained many times that DETACH/CONT
do not always respect SIGXXX argument, you never said this should be fixed.
In particular, I already mentioned in this thread that this argument has no
effect after the jctl stop. I guess this only proves we should discuss this
separately to avoid the confusion ;)

> Due to this bug there is probably the
> tgkill(SIGSTOP)+PTRACE_DETACH(0) used by the "detach-stopped-rhel5"
> ptrace-testsuite testfile, IIUC.

No. I already tried to explain the problems with detach-stopped in my
previous email:

	> This works in some kernels and
	> does not work in other kernels,

	Afaics, this only works in utrace-based kernels.

	In upstream kernel, we have the extra wake_up_state() in ptrace_detach().
	And,

	> it is "detach-stopped" test in:

	But there is another problem which can't be really tested by detach-stopped
	(because it detaches when the tracee was already stopped). The
	SIGNAL_STOP_DEQUEUED logic is not correct.

In short: the wrong wakeup + the broken SIGNAL_STOP_DEQUEUED logic.
detach-stopped-rhel5 does tkill(SIGSTOP), this fixes the latter. But
it can fail anyway afaics, just the probability is low.

> A process is not in the `T (stopped)' state randomly.  AFAIK it is there due
> to an engineer sending it SIGSTOP.  Applications themselves do not use SIGSTOP
> themselves to get into `T (stopped)' during their execution.

Well, they do ;) but I think this doesn't matter.

> And if the engineer sent SIGSTOP it was intentional.  The engineer does not
> want some tool to accidentally cancel his intentional SIGSTOP.  When the
> engineer decides so (s)he can send SIGCONT appropriately.
>
> SIGSTOP I find as a hard stop and thus even the tracers/debuggers of
> the `T (stopped)' process should just get no response from it.

If I understand you correctly, then I agree very much here, and this was
our point.

But I am afraid I could misunderstand, please see below.

> I do not think
> ptrace is a good tool for some general system monitoring - to see any
> SIGCONT/SIGSTOP deliveries - because ptrace is (a) single-master limited
> (second PTRACE_ATTACH gets EPERM)

This is what I certainly can't understand,

> and (b) ptrace-control is not transparent
> due to the threads/races timing (on `t (tracing stop)').

We are going to try to fix this races,

> Therefore if the debugger sends some SIGSTOP/SIGCONT those should be rather
> ignored for compatibility reasons

Well, I don't think so. In particular they shouldn't be ignored for
compatibility reasons.


Jan. Could you please explicitly answer our question? We have the numerious
problems with jctl and ptrace. Everything is just broken. And it is broken
by design, that is why it is not easy to fix the code: we should first
discuss what do we want to get in result. Please forget about attach/detach
for the moment. I'll repeat my question:

	Suppose that the tracee is 'T (stopped)'. Because the debugger did
	PTRACE_CONT(SIGSTOP), or because debugger attached to the stopped task.

	Currently, PTRACE_CONT(WHATEVER) after that always resumes the tracee,
	despite the fact it is still stopped in some sense. This leads to
	numerous oddities/bugs.

	What we propose is to change this so that the tracee does not run
	until it actually recieves SIGCONT.

Is it OK for gdb or not?

IOW. To simplify. Suppose we have a task in 'T (stopped)' state. Then
debugger comes and does

	ptrace(PTRACE_ATTACH);
	PTRACE(PTRACE_CONT, 0);

With the current code the tracee runs after that. We want to change
the kernel so that the tracee won't run, but becomes 'T (stopped)'
again. It only runs when it gets SIGCONT.

Do you agree with such a change?


And yes, yes,

	ptrace(PTRACE_ATTACH);
	ptrace(PTRACE_DETACH, 0)

should leave it stopped too, of course.

Oleg.


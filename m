Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1FCPYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:24:13 -0400
Received: from mail.codesourcery.com ([38.113.113.100]:54951 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab1FCPYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:24:12 -0400
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and group stop notification, take#4
Date: Fri, 3 Jun 2011 16:24:08 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
References: <1306710760-16440-1-git-send-email-tj@kernel.org> <201106031311.33929.pedro@codesourcery.com> <BANLkTinx8enCJHNMm+LN0TBtSF0=7PGRNw@mail.gmail.com>
In-Reply-To: <BANLkTinx8enCJHNMm+LN0TBtSF0=7PGRNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106031624.09371.pedro@codesourcery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 June 2011 15:12:55, Denys Vlasenko wrote:
> On Fri, Jun 3, 2011 at 2:11 PM, Pedro Alves <pedro@codesourcery.com> wrote:
> >> > > > * What to do about events which are reported by genuine SIGTRAP
> >> > > >  generation?
> >> > >
> >> > > I don't understand what you meant here. Example(s)?
> >> >
> >> > The syscall, breakpoint, single step SIGTRAPs which can't be
> >> > distinguished from userland generated SIGTRAPs and may be mixed and/or
> >> > lost.  Maybe it's best to leave them alone or maybe we can add some
> >> > way to distinguish them which is mostly backward compatible (which is
> >> > enabled w/ SEIZE and hopefully doesn't require noticeable userland
> >> > changes).
> >>
> >> Currently, all PTRACE_EVENTs are enabled with ptrace options.
> >>
> >> I propose using the same way instead of using something different.
> >> It works. It's not problematic. Just add more PTRACE_O_foo bits.
> >> Then user who really want it will use it, and users which
> >> would rather use their existing code with less changes aren't
> >> forced to change.
> >
> > I'm in principle against this.  What realistic good does it
> > bring over making exception/syscall SIGTRAPs distinguisheable
> > on the siginfo?
> 
> Requiring GETSIGINFO on every syscall trap is (1) a bit expensive
> and (2) was never needed before.

On (1) - a tracer can enable the sysgood bit today, no need to
GETSIGINFO in that case.  syscall traps are not generated if
a thread is not traced.  This leaves user-sent SIGTRAPs, breakpoints,
single-step/trace, data breakpoints/watchpoints.  The first
three are generatable without a tracer installed.  The latter,
not possible on x86 to tweak the debug registers from userspace
today (unless a ptracer tweaks the debug registers, and then
detaches, without clearing them), but possible to workaround with
a kernel module.  Likely possible to trigger on other archs though.

Does strace end up passing non-syscall SIGTRAPs down to
the tracee that it shouldn't today, due to bad ptrace API?  What
are those SIGTRAPs?

On (2) - Tracers who need to handle breakpoints and single-steps
need to do other ptrace calls on a SIGTRAP to handle the event.
Read registers (read current PC, unless you get that from ... siginfo),
read debug registers --- check whether you've hit a hardware
breakpoint or data breakpoint/watchpoint.  On PPC, for example, GDB
reads siginfo on every SIGTRAP to check for TRAP_HWBKPT on si_code,
and check its si_errno for which hwbreak triggered, so "never needed
before" is false.

And a flurry of user-sent SIGTRAPs is not something anything
sane would do.  :-)

> 
> >  Userspace should see these SIGTRAPs if a tracer
> > isn't there anyway, and, even if a tracer _is_ there, you
> > may want to forward breakpoint/step SIGTRAPs to the
> > tracee, just as if a ptracer wasn't there --- I do that often to
> > debug an in-process self debugger.
> 
> Ah, you are talking about int3 SIGTRAP? That one, IMHO,
> should be treated as "real" signal and passed down to the program
> by strace.

Of course.  int1's (single-step's, caused by TF (trace flag)
set on x86) should be treated the same.  These are real exceptions
that should be forwarded to a program as signals.  What are
the SIGTRAPs that shouldn't be passed down to the program
by strace (excluding the current PTRACE_EVENT_XXX SIGTRAPs)?

> For debuggers which use int3 as breakpoint insn,
> well, I don't know. 

They need to resort to heuristics based on their own state machine
logic (did I set the thread stepping?, is the PC the same as it was
before?, etc., is there an int3 at PC - 1?), to infer whether
a SIGTRAP corresponds to a known breakpoint hit or not,
and unwind the PC if so.  All that is heuristic, and can fail, e.g,
if you overwrite the int3 in memory, before waitpid'ing the SIGTRAP.
Failing to unwind the PC or unwinding it when you shouldn't is
disastrous.

> Perhaps they don't cope well with user-sent
> SIGTRAPs anyway?

Given that breakpoint/trace SIGTRAPs should be passed down to
the program, the fact that user-sent SIGTRAPs don't queue
with those, is not a ptrace problem --- it's a unix signals
problem that can happen without ptrace involved.

But who sends these anyway?  :-P

> >  Being able to distinguish the
> > cause of the SIGTRAP is useful for self debuggers as well,
> > which leads to putting the info in siginfo anyway.
> 
> I don't understand what use case you have in mind.

There are programs that implement a sort of self debugger.
A "ptracer" without ptrace.  We've written one recently for
x86/x86-64.  Install signal handlers for all signals, reserve
one thread for the "debugger", and a signal to interrupt other
threads.  Handle breakpoints and single-steps by handling SIGTRAP.
You need to take some trade offs, but it works.

If we have that info already available on siginfo (at least
some archs do, and I hope x86 gets it too), then it looks
like adding more special ptrace stuff wouldn't do a
significant good.

-- 
Pedro Alves

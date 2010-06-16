Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab0FPCbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 22:31:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068Ab0FPCbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 22:31:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: Bug 16061 - single stepping in a signal handler can cause the
	single step flag to get "stuck"
In-Reply-To: Oleg Nesterov's message of  Wednesday, 2 June 2010 21:23:18 +0200 <20100602192318.GA26735@redhat.com>
References: <20100602192318.GA26735@redhat.com>
X-Windows: complex nonsolutions to simple nonproblems.
Message-Id: <20100616023111.007FA40736@magilla.sf.frob.com>
Date: Tue, 15 Jun 2010 19:31:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I'm slow in getting back to this.  I was sick last week and I'm
still rather foggy-headed.  I haven't actually tried today to think
through all the corners you've talked about.

I'm hoping a couple of comments might clarify things for you enough
that you'll restate it all in ways that don't require me to get less
foggy and follow every detail of what you've said so far.  :-}

x86's TIF_SINGLESTEP is slightly confusingly overloaded for two things
that are sort of different, but also perhaps are entirely redundant.
(I'm the one who did that to begin with when originally fixing the
syscall-step and signal-step corners years ago, but I still get to
complain. ;-)  Its original use is for do_debug:

	if ((dr6 & DR_STEP) && !user_mode(regs)) {

This is for non-interrupt kernel entries where the hardware does not
clear TF from the incoming user-mode eflags.  I believe that's only the
sysenter instruction, but I'm not entirely positive off hand.  (This is
helpfully not true of the syscall instruction that x86-64 has and that
AMD CPUs use instead of sysenter for 32-bit processes on x86-64--grep
MSR_SYSCALL_MASK.)  Here the original idea was that the user registers
have TF set, but it took effect in kernel mode.  So it has to be cleared
to stop interfering with the normal kernel asm paths.  But it wants to
be set again before we return to user mode.  This is simplistic thinking
just trying to mimic the hardware logic for interrupt entries (including
'int $0x80' syscalls), where the hardware stores TF in the trap frame
with the rest of the user-mode state, and clears TF before executing the
first kernel-mode instruction.  (Since we set the MSR right, that's what
'syscall' instructions do in hardware too.)  In the problem cases (such
as ia32_sysenter_target), the hardware just goes to kernel mode and only
changes cs and ip so the kernel code has to manually store all the
user-mode state, including its eflags.  Since eflags is left as it was,
TF there causes the trap to do_debug after the first kernel-mode
instruction--a few instructions before the kernel asm has stored the
user eflags anywhere.  So the original meaning of TIF_SINGLESTEP was
simply to turn TF back on before going to user mode (I think it might
originally have been handled in do_notify_resume).  That was before I
got involved.  Perhaps some ancient LKML archives can reveal the actual
history, but I've never looked.  I suspect the way it went was that
people noticed an unhandled trap in kernel mode after sysenter support
was added, and just scratched that itch by clearing it in do_debug.
Then it would have been noticed that a sysenter (vs an 'int $0x80')
caused TF state just to be lost, so that both user-mode setting TF
itself, and PTRACE_SINGLESTEP as it existed at the time, stopped working
as they had.  That's solved by adding TIF_SINGLESTEP as it originally
was, just to get TF set again in user mode.

Then it was cited as a problem that single-step over a system call
instruction (of whichever flavor) didn't actually single-step, but
double-stepped.  This is when I first got involved, and this was the
beginning of my understanding of the kernel entry asm paths--I was
probably quite vague then on how the do_debug trap in kernel mode case
might happen.  For 'int $0x80' system calls, this is because the
user-mode TF is just restored by the hardware in 'iret' (which is what
transitions the hardware back from kernel to user mode), so it fires
when the next user instruction completes--but from the user perspective,
the last instruction was the 'int $0x80' itself (done with TF set), so
by the hardware rules as they apply to all unprivileged instructions,
the single-step trap should be right before the following instruction,
not after it.  For sysenter or syscall, it's similar: the sysexit (or
sysret) instruction restores the user-mode eflags at the same time it
transitions to user mode, so that TF applies to the following user
instruction rather than the sysenter (syscall) that has just completed
from the user perspective.

To address that, we added the TIF_SINGLESTEP path to syscall_trace_leave
(to further confuse things, it was a unified syscall_trace at the time).
That originally just treated TIF_SINGLESTEP the same as it did
TIF_SYSCALL_TRACE for exit tracing, since basic ptrace stops look the
same either way.  (We later cleaned that up since PTRACE_O_TRACESYSGOOD
makes a syscall-exit stop look different from a single-step trap, and
PTRACE_SINGLESTEP should look like a step, not like PTRACE_SYSCALL when
you didn't use that.  I also tried to clean it up more with thoughts of
utrace, where syscall-tracing and single-step are independent knobs
rather than being mutually exclusive as the old ptrace interface has it.
And, of course, there was TIF_SYSCALL_EMU thrown in there somewhere to
really complicate the possible control flow.)

Much later, the TIF_SINGLESTEP path to syscall_trace_enter was added.
(I'm skipping ahead in the chronology here to stay closer on topic.)
This is for the (original) scenario of the DR_STEP trap in kernel mode,
i.e. the sysenter entry path.  This is to notice that the user-mode TF
was artificially cleared by do_debug, and restore it into
task_pt_regs()->flags as early as possible.  (This would have been a
good way to do the original TIF_SINGLESTEP back in prehistory, but
nobody thought of doing it that way.)  This is so that an examination of
task_pt_regs() sees the "real" user-mode state, e.g. ptrace peeking at
it during the syscall-entry tracing stop.

Back to prehistory.  It's always been possible in the hardware for
user-mode to set TF itself, i.e.:

	pushf
	orw $0x200, (%esp)
	popf

Weird applications actually do this, for strange ideas about code that
checks who calls it, pure user self-debugging, and other weirdness.
(That all may be ill-advised to do, but it's always been well-defined.)
When user code does this, what happens is a natural analogue of what the
hardware does: you get a SIGTRAP signal (presumably having installed a
handler), with the whole register state (including TF set in eflags) in
the struct sigcontext for the handler, but TF is cleared before running
the signal handler, so it doesn't recurse.  This is why signal.c clears
TF in the task_pt_regs() (same pointer as regs arg to handle_signal)
when setting up a signal handler.

Around the same time as the syscall-step "double-step" issue was
noticed, someone noticed that PTRACE_SINGLESTEP,signr for a handled
signal had a similar issue: it gives you a SIGTRAP after executing the
first instruction of the signal handler.  But a person using a debugger
would like to see a "stepi" operation go from one known user instruction
that was about to be executed to the very next user-mode instruction
that will be executed--i.e., stop before the first instruction of the
signal handler and have the chance to look at registers and memory
before executing it.  Since in the signal-handling scenario, there is no
state at which you were before one user instruction with TF set, and at
the completion of that instruction you are at the first user instruction
of the signal handler, there is no way to have an actual trap (do_debug)
at the user register state we want to see.  So instead we added a "fake
trap" for PTRACE_SINGLESTEP, in the form of a ptrace_notify() call.
Later that became tracehook_signal_handler().

Not long after, I wanted to clean things up, and added TIF_FORCED_TF.
This is to keep debugger single-stepping coherent when user mode sets TF
itself, and to only ever show the "real" user mode eflags bits even when
debugger single-stepping is in use.  This is for user_regset (e.g. for
ptrace peeking at registers) and for struct sigcontext when the debugger
single-steps into a signal handler.  Linus had one of the aforementioned
weird applications in binary form and wanted to debug it, so he went
whole-hog and also added the is_setting_trap_flag() code that is now in
step.c--so single-stepping that "popf" clears TIF_FORCED_TF, and we
won't later confuse the user-chosen "real" TF (or lack thereof) with one
induced by user_enable_single_step().  (That detection is imperfect in
various ways, but solved the problem Linus had.)

To complete the background, there is one more set of wrinkles.  There
are the various potential ptrace stops that take place "inside" some
system call (execve, clone, fork, or vfork).  In these cases, from the
time a debugger could do PTRACE_SINGLESTEP with the user-mode PC about
to do the system call instruction (whichever one) until the next actual
execution of a user-mode instruction (i.e. the following one or a signal
handler preempting it, or the very first one at the entry point for an
exec), there is only a single "step" to make from one instruction to the
next.  But there might be three places for ptrace stops before you get
to where resuming would actually execute that next instruction:
syscall-entry tracing, in-syscall tracing (i.e. PTRACE_EVENT_*), and
syscall-exit tracing.  Then there might be a signal stop.  At all these
places, the debugger can decide to PTRACE_SINGLESTEP or not, after
either it or user-mode originally was single-stepping into the system
call instruction.  So what does that all mean?  Historically, we've
decided that if the last kind of resumption before signal handling was
single-step (or now, block-step) then we act as if you'd single-stepped
into the system call instruction, i.e. stop before the next user-mode
instruction.  So, if you had not been single-stepping and the first time
you looked at the user registers was in a PTRACE_EVENT_* stop, and then
you do PTRACE_SINGLESTEP, you'd next see a SIGTRAP (now sent inside
tracehook_report_syscall_exit(,1)) with the same PC that you just saw
(the one following the system call instruction).

One final note about the current behavior, for user-mode setting TF
itself.  Because the trap in kernel mode (sysenter instruction) makes
do_debug set TIF_SINGLESTEP, this triggers the syscall_trace_leave path.
So a user that does sysenter with TF set will get his SIGTRAP
immediately after the sysenter instruction.  Conversely, a syscall entry
with TF set via 'int $0x80' or via x86-64's 'syscall' just stores the
user's full eflags into task_pt_regs()->flags and never notices whether
it contains TF, never sets TIF_SINGLESTEP.  Hence, one of these entries
(i.e. all syscalls from 64-bit user mode, and non-sysenter syscalls from
32-bit user mode on both 32-bit and 64-bit kernels) will "double-step"
over the system call instruction and the one after it.  Unless I'm
mistaken, this is how it's always been for 'int $0x80' with TF set, and
was originally that way when there was first sysenter support too, and
from the time x86-64 came along, 64-bit system calls have behaved that
way too.  In the now several years since we overloaded TIF_SINGLESTEP
for PTRACE_SINGLESTEP over system calls not to double-step, user-mode
setting TF executing sysenter has behaved differently from 'int $0x80'.
If it has ever been done in actual application code, that is.  It's
likely that all the users of TF in pure user mode either don't care
about system calls at all, or use TF only on code that only uses 'int
$0x80' system calls.  (But who knows.)  So the status quo for user-mode
setting TF and doing system calls of various sorts is of dubious
correctness in the abstract, but apparently good enough for the music of
the people--and if the double-step is what it is, then the sysenter
variation from that is dubious; but since nobody complains, apparently
if anyone has ever actually cared they already catered to the quirk.  So
there is not much motivation to have any of the behavior seen by pure
user TF machinations change at all, even if that would be in the
direction of "obviously right in the abstract" (i.e. single-step means
single-step, not double-step if the first instruction was too magical).

So there you have it.  What does it all mean for how it ought to be today?

TIF_SINGLESTEP today means either or both of two things: TF was in force
when user-mode executed sysenter (whether that TF was set by user-mode
or by the debugger); or user_enable_single_step() was used more recently
than user_disable_single_step(), i.e. if we're in a system call now,
we're meant to act as if we'd single-stepped into the system call
instruction.

TIF_FORCED_TF today means that the user-mode eflags has TF clear,
whether or not TF is actually set in task_pt_regs()->flags at the
moment.  Various things (both hardware and kernel code) can clear TF
from the user-mode eflags but fail to clear TIF_FORCED_TF.

It may make sense to have signal.c just notice TIF_FORCED_TF and mask TF
out of what it stores in the signal frame rather than actually clearing
it in the registers beforehand.  (Note you must change ia32_signal.c
too.  If you use a helper for that, perhaps just globalize and rename
get_flags() from ptrace.c, since we have it there too.)  But it still
needs to clear TF for the handler entry if TIF_SINGLESTEP is not set.
And notice also restore_sigcontext (and ia32_restore_sigcontext), which
also lets userland choose the TF value without regard to TIF_FORCED_TF.
That should clear TIF_FORCED_TF if the new user value has TF, or else
keep TF set if TIF_FORCED_TF, like set_flags() from ptrace.c does.
(ptrace.c, signal.c, and ia32_signal.c all have their own ideas about
the mask of eflags that userland (i.e.) sigreturn-self or ptrace-other
is allowed to set or clear.  That's another dubious situation of its
own, but if we harmonize them then both directions of sigcontext
handling can just share the ptrace.c code.)

The change to the tracehook_signal_handler() call seems quite wrong to
me.  I'm not sure I could even define exactly what TIF_SINGLESTEP means
after that.  I think the problem it tries to address won't exist if all
the signal paths that touch TF maintain TIF_FORCED_TF judiciously
(e.g. by sharing the ptrace.c code), as I just described.

It might make sense to replace these two TIF flags with two flags that
have different meanings than these, and adjust everything accordingly to
wind up with a situation that's easier to follow.  But I don't have a
clear idea of what the definitions of those flags would be.


Thanks,
Roland

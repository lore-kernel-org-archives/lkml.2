Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524Ab0FPT63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 15:58:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab0FPT60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 15:58:26 -0400
Date: Wed, 16 Jun 2010 21:56:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: Bug 16061 - single stepping in a signal handler can cause the
	single step flag to get "stuck"
Message-ID: <20100616195629.GA25475@redhat.com>
References: <20100602192318.GA26735@redhat.com> <20100616023111.007FA40736@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616023111.007FA40736@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland, thanks a lot for this (long!) explanation. Another email from
you which I should save in ~/DOCS. I don't know how many time you spent
writing this message, but I bet I spent more trying to understand it ;)
And still I need to read it again later.

On 06/15, Roland McGrath wrote:
>
> x86's TIF_SINGLESTEP is slightly confusingly overloaded for two things
> that are sort of different, but also perhaps are entirely redundant.

Btw yes, I had the same feeling when I did ptrace-utrace.

> (I'm the one who did that to begin with when originally fixing the
> syscall-step and signal-step corners years ago, but I still get to
> complain. ;-)  Its original use is for do_debug:
>
> 	if ((dr6 & DR_STEP) && !user_mode(regs)) {
>
> This is for non-interrupt kernel entries where the hardware does not
> clear TF from the incoming user-mode eflags.

Aha.

Damn. Can't resists. And when I read to this point, I decided to
learn what exactly DR_STEP and db6 (I looked at native_get_debugreg)
mean. More than hour I was trying to google and search in the intel
pdf's I have. No lack. Nothing about db[0-6]! However, I discovered
that volume 3b system programming guide describes DR6 register (not db!)
and it has BS=14 bit (matches DR_STEP == (1 << 14)) which merely means:
"the debug exception was triggered by the single-step execution mode".
Heh. Finally I can understand this code, more or less.

> [... snip a lot of good-to-know details ...]

Thanks.

> hardware stores TF in the trap frame
> with the rest of the user-mode state, and clears TF before executing the
> first kernel-mode instruction.  (Since we set the MSR right, that's what
> 'syscall' instructions do in hardware too.)

grep, grep, grep, grep... syscall_init()->wrmsrl(X86_EFLAGS_TF), right?
I didn't know.

OK. And now I spent a couple more hours. Because I decided to learn
how actually syscalls work on x86_64. I read the sysenter code for
i386 a long ago, and I found my understanding doesn't match the current
reality. grep * a_lot.

So, the user-space doesn't use vdso/vsyscall, it merely calls the
"syscall" insn.

But what about vdso and vsyscall? Looks like, they both do (almost)
the same, but using different the methods.

IIUC, we put the context of vsyscall_64.o into the gate_vma address
(VSYSCALL_START), and then the user-space can call vgetcpu() directly
if the application knows about the VSYSCALL_ADDR() magic.

But, otoh, we also have vdso. And this is what ldd shows as
linux-vdso.so.1. And it also has the "getcpu" helper, __vdso_getcpu().
But, unlike vgetcpu(), this function is "visible" to dynamic linker
and thus looks like a normal function.

Correct? But why does it have both vdso and vsyscall? I guess, one
of them (probably vsyscall) is more or less historical?

OK, after this grepping I see it was off-topic. And I do not even
remember my concerns which forced me to study this magic now.

> So the original meaning of TIF_SINGLESTEP was
> simply to turn TF back on before going to user mode
> ...
> Much later, the TIF_SINGLESTEP path to syscall_trace_enter was added.
> This is to notice that the user-mode TF
> was artificially cleared by do_debug, and restore it into
> task_pt_regs()->flags as early as possible.
> This is so that an examination of
> task_pt_regs() sees the "real" user-mode state, e.g. ptrace peeking at
> it during the syscall-entry tracing stop.

Aha. So, in short: we restore TF in syscall_trace_enter() to expose
this flag to debugger, right? This was my (vague) understanding, but
I wasn't sure.

> Back to prehistory. It's always been possible in the hardware for
> user-mode to set TF itself, i.e.:
>
> 	pushf
> 	orw $0x200, (%esp)
> 	popf

Quick question: is it connected to is_setting_trap_flag() ? IOW,
what is_setting_trap_flag() actually tells us? Looks like, it should
return true if the next insn changes the flags, correct?

> but TF is cleared before running
> the signal handler, so it doesn't recurse.  This is why signal.c clears
> TF in the task_pt_regs() (same pointer as regs arg to handle_signal)
> when setting up a signal handler.

This is not clear to me. Why should we clear TF? The text above says
"before running the signal handler". But

	- if it was set by us: TIF_SINGLESTEP should be true, and
	  we are not going to run the signal handler, we are going
	  to ptrace_notify(SIGTRAP).

	- else: it was set by the app or debugger. Why should we
	  clear TF?

	  OK, probably we need this if the app sets TF for the
	  self-debugging and has a handerl for SIGTRAP...

	  If it was debugger, then I am not sure. OTOH, I do not
	  know why debugger may want to do set_flags(X86_EFLAGS_TF).

> Around the same time as the syscall-step "double-step" issue was
> noticed, someone noticed that PTRACE_SINGLESTEP,signr for a handled
> signal had a similar issue: it gives you a SIGTRAP after executing the
> first instruction of the signal handler.
> So instead we added a "fake
> trap" for PTRACE_SINGLESTEP

Yes, this is clear. Thanks.

> Not long after, I wanted to clean things up, and added TIF_FORCED_TF.

In short, TIF_FORCED_TF means: we believe we "own" X86_EFLAGS_TF.

> and also added the is_setting_trap_flag() code that is now in
> step.c--so single-stepping that "popf" clears TIF_FORCED_TF, and we
> won't later confuse the user-chosen "real" TF (or lack thereof) with one
> induced by user_enable_single_step().

OK, this probably answers my question about is_setting_trap_flag().
But I need to re-read the code and your explanation again, I am
starting to lose the concentration.

> (That detection is imperfect in
> various ways

Ah, good. I thought that my misunderstanding is the only problem.

> To complete the background, there is one more set of wrinkles.  There
> are the various potential ptrace stops that take place "inside" some
> system call (execve, clone, fork, or vfork).

Oh, thanks. I didn't think about this. Again, will re-read your explanation
tomorrow. (Probably this doesn't matter in the context of this particular
bug, but I am not sure...)

> One final note about the current behavior, for user-mode setting TF
> itself.  Because the trap in kernel mode (sysenter instruction) makes
> do_debug set TIF_SINGLESTEP, this triggers the syscall_trace_leave path.

Another thing I didn't think about.

> So a user that does sysenter with TF set will get his SIGTRAP
> immediately after the sysenter instruction.  Conversely, a syscall entry
> with TF set via 'int $0x80' or via x86-64's 'syscall' just stores the
> user's full eflags into task_pt_regs()->flags and never notices whether
> it contains TF, never sets TIF_SINGLESTEP.

Heh.

> Hence, one of these entries
> (i.e. all syscalls from 64-bit user mode, and non-sysenter syscalls from
> 32-bit user mode on both 32-bit and 64-bit kernels) will "double-step"
> over the system call instruction and the one after it.

Confused... syscall insn doesn't lead to TIF_SINGLESTEP, so
syscall_trace_leave() should return to user-space, and then we should
have a single step after the next instruction? (assuming TIF_SYSCALL_TRACE
is not set).

> It may make sense to have signal.c just notice TIF_FORCED_TF and mask TF
> out of what it stores in the signal frame rather than actually clearing
> it in the registers beforehand.

Yes, the patch I sent you privately does exactly this.

> (Note you must change ia32_signal.c

OOPS, indeed.

> If you use a helper for that, perhaps just globalize and rename
> get_flags() from ptrace.c, since we have it there too.)

Well, this is minor, but get_flags() from ptrace.c takes the task_struct
pointer, while we already have pt_regs in setup_sigcontext... OK, I agree,
but then we need a good name for this helper. ptrace_get_task_flags?

> But it still
> needs to clear TF for the handler entry if TIF_SINGLESTEP is not set.

Aha. This partly answers my "Why should we clear TF" question above.
At least you agree that if TIF_SINGLESTEP is set, this is not needed.

I still can't fully understand why should we clear it otherwise. But,
in any case, I guess we should do this because we do not want the user
visible changes.

> And notice also restore_sigcontext (and ia32_restore_sigcontext), which
> also lets userland choose the TF value without regard to TIF_FORCED_TF.

Oh! thanks... Again, again, again, will reread tomorrow. But at first
glance, doesn't this mean another problem/patch?

> The change to the tracehook_signal_handler() call seems quite wrong to
> me.

Yes, yes, this is clear.

See you tomorrow. Thanks!

Oleg.


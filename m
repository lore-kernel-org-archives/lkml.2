Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624Ab0FPUxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 16:53:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571Ab0FPUxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 16:53:17 -0400
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
In-Reply-To: Oleg Nesterov's message of  Wednesday, 16 June 2010 21:56:29 +0200 <20100616195629.GA25475@redhat.com>
References: <20100602192318.GA26735@redhat.com>
	<20100616023111.007FA40736@magilla.sf.frob.com>
	<20100616195629.GA25475@redhat.com>
X-Shopping-List: (1) Repugnant fatuous snoozeers
   (2) Mauve organ yies
   (3) Amorphous retardation breath
Message-Id: <20100616205311.B7BE8403D2@magilla.sf.frob.com>
Date: Wed, 16 Jun 2010 13:53:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Roland, thanks a lot for this (long!) explanation. Another email from
> you which I should save in ~/DOCS. I don't know how many time you spent
> writing this message, but I bet I spent more trying to understand it ;)

That was my plan. ;-)

> Damn. Can't resists. And when I read to this point, I decided to
> learn what exactly DR_STEP and db6 (I looked at native_get_debugreg)
> mean. More than hour I was trying to google and search in the intel
> pdf's I have. No lack. Nothing about db[0-6]! However, I discovered
> that volume 3b system programming guide describes DR6 register (not db!)

Yes, the assembly syntax is %dbN, some comments and docs say DBn, and
others say DRn.  They're called the "debug registers", abbreviate randomly.
Go team.

> and it has BS=14 bit (matches DR_STEP == (1 << 14)) which merely means:
> "the debug exception was triggered by the single-step execution mode".
> Heh. Finally I can understand this code, more or less.

Nobody understands it more than more or less. ;-) 
To get more confused, try to figure out when the hardware (or kernel) does
or doesn't clear the DR_STEP bit (or others) in %db6.  (Actually, don't.
You can find some old LKML thread about hw_breakpoint where we figured that
out, but my brain hurts just recalling that I once almost knew.)

> grep, grep, grep, grep... syscall_init()->wrmsrl(X86_EFLAGS_TF), right?

Right.

> OK. And now I spent a couple more hours. Because I decided to learn
> how actually syscalls work on x86_64. I read the sysenter code for
> i386 a long ago, and I found my understanding doesn't match the current
> reality. grep * a_lot.

Muwhahaha.  Indeed, this is not directly relevant and I judiciously said
"the next instruction" for sysenter without mentioning the vDSO magic that
is actually where that PC always is.  You don't really need to know about
that stuff, for this subject.  But go ahead and learn about it, and then
you'll get stuck fixing it next time there is a problem. ;-)

> So, the user-space doesn't use vdso/vsyscall, it merely calls the
> "syscall" insn.

Right.  x86-64 started out with a single, sensible and optimal mechanism
for native system calls.  The only reason i386 has __kernel_vsyscall is
that there are multiple variants best for different hardware, and you
don't know which flavor you want until you boot and see the actual CPU.

> But what about vdso and vsyscall? Looks like, they both do (almost)
> the same, but using different the methods.

Yes, the non-DSO vsyscall page is an older hack and now we are stuck with
that as a permanent part of the x86-64 user/kernel ABI.  The vDSO is the
"modern" method, and is treated similarly on i386 and several other
machines (e.g. powerpc has exported calls there too).

> OK, after this grepping I see it was off-topic. And I do not even
> remember my concerns which forced me to study this magic now.

Too late!  Now we know that you know, and you will be the expert when I am
hit by the bus.

> Aha. So, in short: we restore TF in syscall_trace_enter() to expose
> this flag to debugger, right? This was my (vague) understanding, but
> I wasn't sure.

Right.  It also exposes it correctly in struct sigcontext if user-mode had
set TF itself.  This fix came long after most of the rest of the logic.  So
some other existing code might be redundant or strange-looking now that we
have this.

> > Back to prehistory. It's always been possible in the hardware for
> > user-mode to set TF itself, i.e.:
> >
> > 	pushf
> > 	orw $0x200, (%esp)
> > 	popf
> 
> Quick question: is it connected to is_setting_trap_flag() ? IOW,
> what is_setting_trap_flag() actually tells us? Looks like, it should
> return true if the next insn changes the flags, correct?

Correct.  is_setting_trap_flag() returns true when the PC is pointing at
that "popf", for example.

> 	- if it was set by us: TIF_SINGLESTEP should be true, and
> 	  we are not going to run the signal handler, we are going
> 	  to ptrace_notify(SIGTRAP).

Right.

> 	- else: it was set by the app or debugger. Why should we
> 	  clear TF?
> 
> 	  OK, probably we need this if the app sets TF for the
> 	  self-debugging and has a handerl for SIGTRAP...

Correct.  That's always been the only way to usefully set TF yourself in
user mode (otherwise you'd just get infinite SIGTRAPs).  It corresponds to
how the hardware trap behavior works, e.g. if you were using signal
handlers to execute old DOS code in emulation and had a DOS debugger in
there.

> 	  If it was debugger, then I am not sure. OTOH, I do not
> 	  know why debugger may want to do set_flags(X86_EFLAGS_TF).

It's just the general pedanticism that the debugger should be able to set
up any state that user-mode code could have created itself.

> > Not long after, I wanted to clean things up, and added TIF_FORCED_TF.
> 
> In short, TIF_FORCED_TF means: we believe we "own" X86_EFLAGS_TF.

Well, only sort of.  It means we "own" it being on.  If it's off, that
doesn't mean we're choosing to turn it off when the userland state is on,
for example.  That might be a nice and clear thing for a flag like that to
mean.  But there are so many ways that it can be implicitly cleared by
hardware and such that it would take more work to make it mean that.

> > (That detection is imperfect in various ways
> 
> Ah, good. I thought that my misunderstanding is the only problem.

I could tell you some ways it could be wrong.  But that's left as an
exercise for the reader, and you really just don't care.

> > To complete the background, there is one more set of wrinkles.  There
> > are the various potential ptrace stops that take place "inside" some
> > system call (execve, clone, fork, or vfork).
> 
> Oh, thanks. I didn't think about this. Again, will re-read your explanation
> tomorrow. (Probably this doesn't matter in the context of this particular
> bug, but I am not sure...)

I don't think it directly influences anything we're talking about changing.
But it is a nonobvious thing I wanted to put in the record.

> Confused... syscall insn doesn't lead to TIF_SINGLESTEP, so
> syscall_trace_leave() should return to user-space, and then we should
> have a single step after the next instruction? (assuming TIF_SYSCALL_TRACE
> is not set).

You're not confused!  That's exactly how it works.
>From the userland perspective this is a "double-step":

0000000000400078 <_start>:
  400078:	9c                   	pushfq 
  400079:	66 81 0c 24 00 02    	orw    $0x200,(%rsp)
  40007f:	9d                   	popfq  
  400080:	0f 05                	syscall 
  400082:	f4                   	hlt    

This doesn't get a SIGTRAP at 400082 as it would for any normal instruction
instead of "syscall".  Instead it gets SIGSEGV because "hlt" is executed.

> > It may make sense to have signal.c just notice TIF_FORCED_TF and mask TF
> > out of what it stores in the signal frame rather than actually clearing
> > it in the registers beforehand.
> 
> Yes, the patch I sent you privately does exactly this.

Right.  I think that direction is where the right fixes lie.

> Well, this is minor, but get_flags() from ptrace.c takes the task_struct
> pointer, while we already have pt_regs in setup_sigcontext... OK, I agree,
> but then we need a good name for this helper. ptrace_get_task_flags?

I'd call it user_[gs]et_eflags, but names don't matter much.  Feel free to
change the signatures to take the pt_regs pointer too.  Half the ptrace.c
callers have the pointer on hand already too.  And it wouldn't hurt to
change the signature of the local {get,put}reg{,32} calls to take the
argument and have their callers use task_pt_regs() only once, too.

> > But it still
> > needs to clear TF for the handler entry if TIF_SINGLESTEP is not set.
> 
> Aha. This partly answers my "Why should we clear TF" question above.
> At least you agree that if TIF_SINGLESTEP is set, this is not needed.

Right.

> I still can't fully understand why should we clear it otherwise. But,
> in any case, I guess we should do this because we do not want the user
> visible changes.

It's the only way that user-mode being able to set TF on itself can ever
make any kind of sense.

> > And notice also restore_sigcontext (and ia32_restore_sigcontext), which
> > also lets userland choose the TF value without regard to TIF_FORCED_TF.
> 
> Oh! thanks... Again, again, again, will reread tomorrow. But at first
> glance, doesn't this mean another problem/patch?

Yes, those should use user_set_eflags.  With today's kernel I think you
could write another test case where a signal handler returns after setting
TF in the sigcontext, so that PTRACE_SINGLESTEP over the sigreturn syscall
breaks the untraced userland behavior by the next PTRACE_CONT clearing TF
when userland wants it set.


Thanks,
Roland

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab2D1Dcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 23:32:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52908 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab2D1Dcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 23:32:48 -0400
Date: Sat, 28 Apr 2012 04:32:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120428033245.GT6871@ZenIV.linux.org.uk>
References: <20120424072617.GB6871@ZenIV.linux.org.uk>
 <20120426183742.GA324@redhat.com>
 <20120426231942.GJ6871@ZenIV.linux.org.uk>
 <20120427172444.GA30267@redhat.com>
 <20120427184528.GL6871@ZenIV.linux.org.uk>
 <20120427202002.8ED632C0BF@topped-with-meat.com>
 <20120427211244.GO6871@ZenIV.linux.org.uk>
 <20120427212729.652542C0AF@topped-with-meat.com>
 <20120427231526.GP6871@ZenIV.linux.org.uk>
 <20120428024208.GS6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120428024208.GS6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 03:42:08AM +0100, Al Viro wrote:
> On Sat, Apr 28, 2012 at 12:15:26AM +0100, Al Viro wrote:
> 
> > I think all such architectures need that check lifted to do_notify_resume()
> > (and the rest needs it killed, of course).  Including x86, by the look
> > of it - we _probably_ can't get there with TIF_NOTIFY_RESUME and
> > !user_mode(regs), but I'm not entirely sure of that.  arm is in about the
> > same situation; alpha, ppc{32,64}, sparc{32,64} and m68k really can't get
> > there like that (they all check it in the asm glue).  mips probably might,
> > unless I'm misreading their ret_from_fork()...  Fun.
> 
> It's actually worse than I thought - we can't just lift that check
> to do_notify_resume() and be done with that.  Suppose do_signal() does
> get called on e.g. i386 or arm with !user_mode(regs).  What'll happen next?
> 
> We have TIF_SIGPENDING set in thread flags - otherwise we wouldn't get
> there at all.  OK, do_signal() doesn't do anything and returns.  So does
> do_notify_resume().  And we are back into the loop in asm glue, rereading
> the thread flags (still unchanged), checking if anything is to be done
> (yes, it is - TIF_SIGPENDING is still set), calling do_notify_resume(),
> ad infinitum.
> 
> Lifting the check into do_notify_resume() will not help at all, obviously.
> 
> AFAICS we can get hit by that.  At least i386, arm and mips have
> ret_from_fork going straight to "return from syscall" path, no checks for
> return to user mode done.  And process created by kernel_thread() will
> go there.  It's a narrow race, but AFAICS it's not impossible to hit -
> guess the PID of kernel thread to be launched, send it a signal and hit
> the moment before it gets to executing the payload.
> 
> It's probably not exploitable unless you are root, since most of the
> threads are spawned either by kthreadd or by khelper, both running as
> root.  OTOH, there might be other places leading to the same fun - e.g.
> kernel_execve() goes through the normal syscall return path almost on
> everything and in case of failure it returns to kernel mode.  Again,
> that one is unlikely to be exploitable (it only happens from root-owned
> threads), but I'm not sure if anything else gets there; IIRC, there had
> been an effort to get rid of issuing syscalls via int/syscall/trap/whatnot,
> but I don't remember how far did it go, especially under arch...

Actually, it looks like on i386 the loop will be broken by checks in
resume_userspace_sig, so the worst thing that might happen would be
a bogus call of tracehook_notify_resume() if it's possible to get there
with TIF_NOTIFY_RESUME for kernel thread.  No such luck on arm, though...
To be honest, I'd rather check for user_mode() before calling
do_notify_resume() and go away to no_work_pending if it's true.  For arm
and i386 that would probably look like this, and I'd really, *really*
like review and comments on that.  amd64 is, AFAICS, careful enough to
avoid hitting do_notify_resume() when returning into the kernel mode -
its implementations of ret_from_fork and kernel_execve take care to avoid
that.

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 82aaf0a..e147619 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -57,6 +57,9 @@ work_pending:
 	 * TIF_SIGPENDING or TIF_NOTIFY_RESUME must've been set if we got here
 	 */
 	mov	r0, sp				@ 'regs'
+	ldr	r2, [sp, #S_PSR]
+	tst	r2, #15
+	be	no_work_pending
 	mov	r2, why				@ 'syscall'
 	tst	r1, #_TIF_SIGPENDING		@ delivering a signal?
 	movne	why, #0				@ prevent further restarts
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index cd41742..f7b7a1c 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -641,15 +641,6 @@ static void do_signal(struct pt_regs *regs, int syscall)
 	int signr;
 
 	/*
-	 * We want the common case to go fast, which
-	 * is why we may in certain cases get here from
-	 * kernel mode. Just return without doing anything
-	 * if so.
-	 */
-	if (!user_mode(regs))
-		return;
-
-	/*
 	 * If we were from a system call, check for system call restarting...
 	 */
 	if (syscall) {
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 7b784f4..e858462 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -321,7 +321,6 @@ ret_from_exception:
 	preempt_stop(CLBR_ANY)
 ret_from_intr:
 	GET_THREAD_INFO(%ebp)
-resume_userspace_sig:
 #ifdef CONFIG_VM86
 	movl PT_EFLAGS(%esp), %eax	# mix EFLAGS and CS
 	movb PT_CS(%esp), %al
@@ -628,9 +627,13 @@ work_notifysig:				# deal with pending signals and
 					# vm86-space
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
+	movb PT_CS(%esp), %bl
+	andl $SEGMENT_RPL_MASK, %ebx
+	cmpl $USER_RPL, %ebx
+	jb resume_kernel
 	xorl %edx, %edx
 	call do_notify_resume
-	jmp resume_userspace_sig
+	jmp resume_userspace
 
 	ALIGN
 work_notifysig_v86:
@@ -643,9 +646,13 @@ work_notifysig_v86:
 #endif
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
+	movb PT_CS(%esp), %bl
+	andl $SEGMENT_RPL_MASK, %ebx
+	cmpl $USER_RPL, %ebx
+	jb resume_kernel
 	xorl %edx, %edx
 	call do_notify_resume
-	jmp resume_userspace_sig
+	jmp resume_userspace
 END(work_pending)
 
 	# perform syscall exit tracing
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 595969f..c4aa7c5 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -738,16 +738,6 @@ static void do_signal(struct pt_regs *regs)
 	siginfo_t info;
 	int signr;
 
-	/*
-	 * We want the common case to go fast, which is why we may in certain
-	 * cases get here from kernel mode. Just return without doing anything
-	 * if so.
-	 * X86_32: vm86 regs switched out by assembly code before reaching
-	 * here, so testing against kernel CS suffices.
-	 */
-	if (!user_mode(regs))
-		return;
-
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 	if (signr > 0) {
 		/* Whee! Actually deliver the signal.  */

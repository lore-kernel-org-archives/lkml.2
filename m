Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab2D2SFk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 14:05:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55723 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab2D2SFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 14:05:38 -0400
Date: Sun, 29 Apr 2012 19:05:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120429180535.GZ6871@ZenIV.linux.org.uk>
References: <20120426183742.GA324@redhat.com>
 <20120426231942.GJ6871@ZenIV.linux.org.uk>
 <20120427172444.GA30267@redhat.com>
 <20120427184528.GL6871@ZenIV.linux.org.uk>
 <20120427202002.8ED632C0BF@topped-with-meat.com>
 <20120427211244.GO6871@ZenIV.linux.org.uk>
 <20120427212729.652542C0AF@topped-with-meat.com>
 <20120427231526.GP6871@ZenIV.linux.org.uk>
 <20120428024208.GS6871@ZenIV.linux.org.uk>
 <20120429161818.GA15792@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120429161818.GA15792@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2012 at 06:18:18PM +0200, Oleg Nesterov wrote:

> Please look at 29a2e2836ff9ea65a603c89df217f4198973a74f
> x86-32: Fix endless loop when processing signals for kernel tasks
> 
> > At least i386, arm and mips have
> > ret_from_fork going straight to "return from syscall" path, no checks for
> > return to user mode done.  And process created by kernel_thread() will
> > go there.
> 
> Looks like, the patch above fixes that.

Yes, found that shortly after posting.  No such luck for arm, though...

> But, we call do_notify_resume() first, it would be nice to avoid this
> and remove the user_mode() check in do_signal() or lift into
> do_notify_resume().

See the proposed patch.  Does exactly that - lifts all the way to caller
of do_notify_resume(), buggers off if test fits.

> Question. So far I know that on x86 do_notify_resume() && !user_mode()
> is only possible on 32bit system, and the possible callers are
> ret_from_fork or kernel_execve (if it fails).
> 
> Plus, perhaps CONFIG_VM86 makes a difference?
> 
> Could you please clarify?

VM86 doesn't make a difference; we form normal pt_regs for it in case
we have a pending signal, but after that has been done, we don't need
to care.  Look:
	* NOTIFY_RESUME handling doesn't need to be done unless we are
returning to userland.  IOW, the first step is to lift that if (!user_mode(...
into do_notify_resume().  Agreed?
	* Now, if do_notify_resume() does nothing in case !user_mode(regs),
let's lift that check to (32bit) caller.  What we have right now is
	do_notify_resume(%esp, NULL, %ecx)
	goto resume_userspace_sig;
resume_userspace_sig:
	if (!user_mode_vm(%esp))
		goto resume_kernel;
resume_userspace:
So after lifting the check we get
	if (user_mode(%esp))
		do_notify_resume(%esp, NULL, %ecx)
	goto resume_userspace_sig;
resume_userspace_sig:
	if (!user_mode_vm(%esp))
		goto resume_kernel;
resume_userspace:
but user_mode(regs) being true means that user_mode_vm(regs) is also true,
so this code is equivalent to
	if (!user_mode(%esp))
		goto resume_kernel;
	do_notify_resume(%esp, NULL, %ecx)
	goto resume_userspace;
(with stuff around resume_userspace_sig left without changes).

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

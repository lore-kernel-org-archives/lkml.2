Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab0JGRKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 13:10:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50615 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab0JGRKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 13:10:15 -0400
Date: Thu, 07 Oct 2010 18:10:14 +0100
To: linux-m68k@vger.kernel.org
Subject: [PATCH 6/6] m68k: fix stack mangling logics in sigreturn
Cc: linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1P3tyw-0007kX-Gh@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


a) we should hold modifying regs->format until we know we *will* be
doing stack expansion; otherwise attacker can modify sigframe to
have wrong ->sc_formatvec and install SIGSEGV handler.

b) we should *not* mix copying saved extra stuff from userland with
expanding the stack; once we'd done that manual memmove, we'd better
not return to C, so cleanup is very hard to do.  The easiest way
is to copy it on stack first, making sure we won't overwrite on stack
expansion.  Fortunately that's easy to do...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/m68k/kernel/signal.c |  173 ++++++++++++++++-----------------------------
 1 files changed, 61 insertions(+), 112 deletions(-)

diff --git a/arch/m68k/kernel/signal.c b/arch/m68k/kernel/signal.c
index 16ea319..d5f4a82 100644
--- a/arch/m68k/kernel/signal.c
+++ b/arch/m68k/kernel/signal.c
@@ -286,36 +286,10 @@ out:
 	return err;
 }
 
-static inline int
-restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *usc, void __user *fp,
-		   int *pd0)
+static int mangle_kernel_stack(struct pt_regs *regs, int formatvec,
+			       void __user *fp)
 {
-	int fsize, formatvec;
-	struct sigcontext context;
-	int err;
-
-	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
-
-	/* get previous context */
-	if (copy_from_user(&context, usc, sizeof(context)))
-		goto badframe;
-
-	/* restore passed registers */
-	regs->d1 = context.sc_d1;
-	regs->a0 = context.sc_a0;
-	regs->a1 = context.sc_a1;
-	regs->sr = (regs->sr & 0xff00) | (context.sc_sr & 0xff);
-	regs->pc = context.sc_pc;
-	regs->orig_d0 = -1;		/* disable syscall checks */
-	wrusp(context.sc_usp);
-	formatvec = context.sc_formatvec;
-	regs->format = formatvec >> 12;
-	regs->vector = formatvec & 0xfff;
-
-	err = restore_fpu_state(&context);
-
-	fsize = frame_extra_sizes[regs->format];
+	int fsize = frame_extra_sizes[formatvec >> 12];
 	if (fsize < 0) {
 		/*
 		 * user process trying to return with weird frame format
@@ -323,16 +297,22 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *usc, void __u
 #ifdef DEBUG
 		printk("user process returning with weird frame format\n");
 #endif
-		goto badframe;
+		return 1;
 	}
+	if (!fsize) {
+		regs->format = formatvec >> 12;
+		regs->vector = formatvec & 0xfff;
+	} else {
+		struct switch_stack *sw = (struct switch_stack *)regs - 1;
+		unsigned long buf[fsize / 2]; /* yes, twice as much */
 
-	/* OK.	Make room on the supervisor stack for the extra junk,
-	 * if necessary.
-	 */
+		/* that'll make sure that expansion won't crap over data */
+		if (copy_from_user(buf + fsize / 4, fp, fsize))
+			return 1;
 
-	if (fsize) {
-		struct switch_stack *sw = (struct switch_stack *)regs - 1;
-		regs->d0 = context.sc_d0;
+		/* point of no return */
+		regs->format = formatvec >> 12;
+		regs->vector = formatvec & 0xfff;
 #define frame_offset (sizeof(struct pt_regs)+sizeof(struct switch_stack))
 		__asm__ __volatile__
 			("   movel %0,%/a0\n\t"
@@ -344,30 +324,50 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *usc, void __u
 			 "   lea %/sp@(%c3),%/a0\n\t" /* add offset of fmt */
 			 "   lsrl  #2,%1\n\t"
 			 "   subql #1,%1\n\t"
-			 "2: movesl %4@+,%2\n\t"
-			 "3: movel %2,%/a0@+\n\t"
+			 /* copy to the gap we'd made */
+			 "2: movel %4@+,%/a0@+\n\t"
 			 "   dbra %1,2b\n\t"
 			 "   bral ret_from_signal\n"
-			 "4:\n"
-			 ".section __ex_table,\"a\"\n"
-			 "   .align 4\n"
-			 "   .long 2b,4b\n"
-			 "   .long 3b,4b\n"
-			 ".previous"
 			 : /* no outputs, it doesn't ever return */
 			 : "a" (sw), "d" (fsize), "d" (frame_offset/4-1),
-			   "n" (frame_offset), "a" (fp)
+			   "n" (frame_offset), "a" (buf + fsize/4)
 			 : "a0");
 #undef frame_offset
-		/*
-		 * If we ever get here an exception occurred while
-		 * building the above stack-frame.
-		 */
-		goto badframe;
 	}
+	return 0;
+}
 
-	*pd0 = context.sc_d0;
-	return err;
+static inline int
+restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *usc, void __user *fp)
+{
+	int formatvec;
+	struct sigcontext context;
+	int err;
+
+	/* Always make any pending restarted system calls return -EINTR */
+	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+
+	/* get previous context */
+	if (copy_from_user(&context, usc, sizeof(context)))
+		goto badframe;
+
+	/* restore passed registers */
+	regs->d0 = context.sc_d0;
+	regs->d1 = context.sc_d1;
+	regs->a0 = context.sc_a0;
+	regs->a1 = context.sc_a1;
+	regs->sr = (regs->sr & 0xff00) | (context.sc_sr & 0xff);
+	regs->pc = context.sc_pc;
+	regs->orig_d0 = -1;		/* disable syscall checks */
+	wrusp(context.sc_usp);
+	formatvec = context.sc_formatvec;
+
+	err = restore_fpu_state(&context);
+
+	if (err || mangle_kernel_stack(regs, formatvec, fp))
+		goto badframe;
+
+	return 0;
 
 badframe:
 	return 1;
@@ -375,9 +375,9 @@ badframe:
 
 static inline int
 rt_restore_ucontext(struct pt_regs *regs, struct switch_stack *sw,
-		    struct ucontext __user *uc, int *pd0)
+		    struct ucontext __user *uc)
 {
-	int fsize, temp;
+	int temp;
 	greg_t __user *gregs = uc->uc_mcontext.gregs;
 	unsigned long usp;
 	int err;
@@ -411,65 +411,16 @@ rt_restore_ucontext(struct pt_regs *regs, struct switch_stack *sw,
 	regs->sr = (regs->sr & 0xff00) | (temp & 0xff);
 	regs->orig_d0 = -1;		/* disable syscall checks */
 	err |= __get_user(temp, &uc->uc_formatvec);
-	regs->format = temp >> 12;
-	regs->vector = temp & 0xfff;
 
 	err |= rt_restore_fpu_state(uc);
 
-	if (do_sigaltstack(&uc->uc_stack, NULL, usp) == -EFAULT)
+	if (err || do_sigaltstack(&uc->uc_stack, NULL, usp) == -EFAULT)
 		goto badframe;
 
-	fsize = frame_extra_sizes[regs->format];
-	if (fsize < 0) {
-		/*
-		 * user process trying to return with weird frame format
-		 */
-#ifdef DEBUG
-		printk("user process returning with weird frame format\n");
-#endif
+	if (mangle_kernel_stack(regs, temp, &uc->uc_extra))
 		goto badframe;
-	}
 
-	/* OK.	Make room on the supervisor stack for the extra junk,
-	 * if necessary.
-	 */
-
-	if (fsize) {
-#define frame_offset (sizeof(struct pt_regs)+sizeof(struct switch_stack))
-		__asm__ __volatile__
-			("   movel %0,%/a0\n\t"
-			 "   subl %1,%/a0\n\t"     /* make room on stack */
-			 "   movel %/a0,%/sp\n\t"  /* set stack pointer */
-			 /* move switch_stack and pt_regs */
-			 "1: movel %0@+,%/a0@+\n\t"
-			 "   dbra %2,1b\n\t"
-			 "   lea %/sp@(%c3),%/a0\n\t" /* add offset of fmt */
-			 "   lsrl  #2,%1\n\t"
-			 "   subql #1,%1\n\t"
-			 "2: movesl %4@+,%2\n\t"
-			 "3: movel %2,%/a0@+\n\t"
-			 "   dbra %1,2b\n\t"
-			 "   bral ret_from_signal\n"
-			 "4:\n"
-			 ".section __ex_table,\"a\"\n"
-			 "   .align 4\n"
-			 "   .long 2b,4b\n"
-			 "   .long 3b,4b\n"
-			 ".previous"
-			 : /* no outputs, it doesn't ever return */
-			 : "a" (sw), "d" (fsize), "d" (frame_offset/4-1),
-			   "n" (frame_offset), "a" (&uc->uc_extra)
-			 : "a0");
-#undef frame_offset
-		/*
-		 * If we ever get here an exception occurred while
-		 * building the above stack-frame.
-		 */
-		goto badframe;
-	}
-
-	*pd0 = regs->d0;
-	return err;
+	return 0;
 
 badframe:
 	return 1;
@@ -482,7 +433,6 @@ asmlinkage int do_sigreturn(unsigned long __unused)
 	unsigned long usp = rdusp();
 	struct sigframe __user *frame = (struct sigframe __user *)(usp - 4);
 	sigset_t set;
-	int d0;
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
@@ -496,9 +446,9 @@ asmlinkage int do_sigreturn(unsigned long __unused)
 	current->blocked = set;
 	recalc_sigpending();
 
-	if (restore_sigcontext(regs, &frame->sc, frame + 1, &d0))
+	if (restore_sigcontext(regs, &frame->sc, frame + 1))
 		goto badframe;
-	return d0;
+	return regs->d0;
 
 badframe:
 	force_sig(SIGSEGV, current);
@@ -512,7 +462,6 @@ asmlinkage int do_rt_sigreturn(unsigned long __unused)
 	unsigned long usp = rdusp();
 	struct rt_sigframe __user *frame = (struct rt_sigframe __user *)(usp - 4);
 	sigset_t set;
-	int d0;
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
@@ -523,9 +472,9 @@ asmlinkage int do_rt_sigreturn(unsigned long __unused)
 	current->blocked = set;
 	recalc_sigpending();
 
-	if (rt_restore_ucontext(regs, sw, &frame->uc, &d0))
+	if (rt_restore_ucontext(regs, sw, &frame->uc))
 		goto badframe;
-	return d0;
+	return regs->d0;
 
 badframe:
 	force_sig(SIGSEGV, current);
-- 
1.5.6.5


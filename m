Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab2BSW0n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 17:26:43 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56038 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab2BSW0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 17:26:42 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.68.75.79 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
Date: Sun, 19 Feb 2012 14:26:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@i5.linux-foundation.org
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
cc: x86@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] i387: use 'restore_fpu_checking()' directly in task
 switching code
In-Reply-To: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.02.1202191423270.3898@i5.linux-foundation.org>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 19 Feb 2012 11:48:44 -0800

This inlines what is usually just a couple of instructions, but more
importantly it also fixes the theoretical error case (can that FPU
restore really ever fail? Maybe we should remove the checking).

We can't start sending signals from within the scheduler, we're much too
deep in the kernel and are holding the runqueue lock etc.  So don't
bother even trying.

Also, make sure that we increment the fpu_counter even when we preload
the FP state, since that is also how we eventually decide to try not
preloading (when the byte counter overflows and becomes zero again).

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---

The fpu_counter part in switch_fpu_finish() is technically separate, but 
these are both bugs in the same preloading code, so I made it one patch.

Can that paranoid restore actually fail? We're loading from kernel state, 
stuff we saved there. But maybe you can mess things up on x86-32 by 
messing up the signal stack restore state, which gets copied by hand into 
the kernel buffer? Regardless, *if* it can fail, that signal sending from 
the scheduler is seriously wrong, afaik.

 arch/x86/include/asm/i387.h |   19 ++++++++++++++++---
 arch/x86/kernel/traps.c     |   40 ++++++++--------------------------------
 2 files changed, 24 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index a850b4d8d14d..251c366289b9 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -29,7 +29,6 @@ extern unsigned int sig_xstate_size;
 extern void fpu_init(void);
 extern void mxcsr_feature_mask_init(void);
 extern int init_fpu(struct task_struct *child);
-extern void __math_state_restore(struct task_struct *);
 extern void math_state_restore(void);
 extern int dump_fpu(struct pt_regs *, struct user_i387_struct *);
 
@@ -269,6 +268,16 @@ static inline int fpu_restore_checking(struct fpu *fpu)
 
 static inline int restore_fpu_checking(struct task_struct *tsk)
 {
+	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
+	   is pending.  Clear the x87 state here by setting it to fixed
+	   values. "m" is a random variable that should be in L1 */
+	alternative_input(
+		ASM_NOP8 ASM_NOP2,
+		"emms\n\t"	  	/* clear stack tags */
+		"fildl %P[addr]",	/* set F?P to defined value */
+		X86_FEATURE_FXSAVE_LEAK,
+		[addr] "m" (tsk->thread.has_fpu));
+
 	return fpu_restore_checking(&tsk->thread.fpu);
 }
 
@@ -377,8 +386,12 @@ static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct ta
  */
 static inline void switch_fpu_finish(struct task_struct *new, fpu_switch_t fpu)
 {
-	if (fpu.preload)
-		__math_state_restore(new);
+	if (fpu.preload) {
+		new->fpu_counter++;
+		if (unlikely(restore_fpu_checking(new))) {
+			__thread_fpu_end(new);
+		}
+	}
 }
 
 /*
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 77da5b475ad2..4bbe04d96744 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -571,37 +571,6 @@ asmlinkage void __attribute__((weak)) smp_threshold_interrupt(void)
 }
 
 /*
- * This gets called with the process already owning the
- * FPU state, and with CR0.TS cleared. It just needs to
- * restore the FPU register state.
- */
-void __math_state_restore(struct task_struct *tsk)
-{
-	/* We need a safe address that is cheap to find and that is already
-	   in L1. We've just brought in "tsk->thread.has_fpu", so use that */
-#define safe_address (tsk->thread.has_fpu)
-
-	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
-	   is pending.  Clear the x87 state here by setting it to fixed
-	   values. safe_address is a random variable that should be in L1 */
-	alternative_input(
-		ASM_NOP8 ASM_NOP2,
-		"emms\n\t"	  	/* clear stack tags */
-		"fildl %P[addr]",	/* set F?P to defined value */
-		X86_FEATURE_FXSAVE_LEAK,
-		[addr] "m" (safe_address));
-
-	/*
-	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
-	 */
-	if (unlikely(restore_fpu_checking(tsk))) {
-		__thread_fpu_end(tsk);
-		force_sig(SIGSEGV, tsk);
-		return;
-	}
-}
-
-/*
  * 'math_state_restore()' saves the current math information in the
  * old math state array, and gets the new ones from the current task
  *
@@ -631,7 +600,14 @@ void math_state_restore(void)
 	}
 
 	__thread_fpu_begin(tsk);
-	__math_state_restore(tsk);
+	/*
+	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
+	 */
+	if (unlikely(restore_fpu_checking(tsk))) {
+		__thread_fpu_end(tsk);
+		force_sig(SIGSEGV, tsk);
+		return;
+	}
 
 	tsk->fpu_counter++;
 }
-- 
1.7.9.188.g12766.dirty


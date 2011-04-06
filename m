Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab1DFWG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:06:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:50768 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132Ab1DFWG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:06:57 -0400
Date: Wed, 6 Apr 2011 22:06:47 GMT
From: tip-bot for Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: linux-kernel@vger.kernel.org, hans.rosenfeld@amd.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, hans.rosenfeld@amd.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1302018656-586370-9-git-send-email-hans.rosenfeld@amd.com>
References: <1302018656-586370-9-git-send-email-hans.rosenfeld@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86, xsave: remove lazy allocation of xstate area
Message-ID: <tip-66beba27e8b5c3f61818cc58bd6c9e0e3cfd7711@git.kernel.org>
Git-Commit-ID: 66beba27e8b5c3f61818cc58bd6c9e0e3cfd7711
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 06 Apr 2011 22:06:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  66beba27e8b5c3f61818cc58bd6c9e0e3cfd7711
Gitweb:     http://git.kernel.org/tip/66beba27e8b5c3f61818cc58bd6c9e0e3cfd7711
Author:     Hans Rosenfeld <hans.rosenfeld@amd.com>
AuthorDate: Tue, 5 Apr 2011 17:50:56 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 6 Apr 2011 14:15:21 -0700

x86, xsave: remove lazy allocation of xstate area

This patch completely removes lazy allocation of the xstate area. All
user tasks will always have an xstate area preallocated, just like they
already do when non-lazy features are present. The size of the xsave
area ranges from 112 to 960 bytes, depending on the xstates present and
enabled. Since it is common to use SSE etc. for optimization, the actual
overhead is expected to negligible.

This removes some of the special-case handling of non-lazy xstates. It
also greatly simplifies init_fpu() by removing the allocation code, the
check for presence of the xstate area or init_fpu() return value.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
Link: http://lkml.kernel.org/r/1302018656-586370-9-git-send-email-hans.rosenfeld@amd.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/i387.h   |   20 ++++++++------------
 arch/x86/kernel/i387.c        |   41 +++++++++--------------------------------
 arch/x86/kernel/traps.c       |   16 ++--------------
 arch/x86/kernel/xsave.c       |    8 ++------
 arch/x86/kvm/x86.c            |    4 ++--
 arch/x86/math-emu/fpu_entry.c |    8 ++------
 6 files changed, 25 insertions(+), 72 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index da55ab6..3ca900b 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -40,7 +40,7 @@
 extern unsigned int sig_xstate_size;
 extern void fpu_init(void);
 extern void mxcsr_feature_mask_init(void);
-extern int init_fpu(struct task_struct *child);
+extern void init_fpu(struct task_struct *child);
 extern asmlinkage void math_state_restore(void);
 extern int dump_fpu(struct pt_regs *, struct user_i387_struct *);
 
@@ -333,18 +333,14 @@ static union thread_xstate __init_xstate, *init_xstate = &__init_xstate;
 
 static inline void fpu_clear(struct fpu *fpu)
 {
-	if (pcntxt_mask & XCNTXT_NONLAZY) {
-		if (!fpu_allocated(fpu)) {
-			BUG_ON(init_xstate == NULL);
-			fpu->state = init_xstate;
-			init_xstate = NULL;
-		}
-		memset(fpu->state, 0, xstate_size);
-		fpu_finit(fpu);
-		set_used_math();
-	} else {
-		fpu_free(fpu);
+	if (!fpu_allocated(fpu)) {
+		BUG_ON(init_xstate == NULL);
+		fpu->state = init_xstate;
+		init_xstate = NULL;
 	}
+	memset(fpu->state, 0, xstate_size);
+	fpu_finit(fpu);
+	set_used_math();
 }
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index dd9644a..df0b139 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -127,9 +127,9 @@ EXPORT_SYMBOL_GPL(fpu_finit);
  * value at reset if we support XMM instructions and then
  * remember the current task has used the FPU.
  */
-int init_fpu(struct task_struct *tsk)
+void init_fpu(struct task_struct *tsk)
 {
-	int ret;
+	BUG_ON(tsk->flags & PF_KTHREAD);
 
 	if (tsk_used_math(tsk)) {
 		if (HAVE_HWFP && tsk == current) {
@@ -137,20 +137,12 @@ int init_fpu(struct task_struct *tsk)
 			save_xstates(tsk);
 			preempt_enable();
 		}
-		return 0;
+		return;
 	}
 
-	/*
-	 * Memory allocation at the first usage of the FPU and other state.
-	 */
-	ret = fpu_alloc(&tsk->thread.fpu);
-	if (ret)
-		return ret;
-
 	fpu_finit(&tsk->thread.fpu);
 
 	set_stopped_child_used_math(tsk);
-	return 0;
 }
 EXPORT_SYMBOL_GPL(init_fpu);
 
@@ -173,14 +165,10 @@ int xfpregs_get(struct task_struct *target, const struct user_regset *regset,
 		unsigned int pos, unsigned int count,
 		void *kbuf, void __user *ubuf)
 {
-	int ret;
-
 	if (!cpu_has_fxsr)
 		return -ENODEV;
 
-	ret = init_fpu(target);
-	if (ret)
-		return ret;
+	init_fpu(target);
 
 	if (use_xsaveopt())
 		sanitize_i387_state(target);
@@ -198,9 +186,7 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 	if (!cpu_has_fxsr)
 		return -ENODEV;
 
-	ret = init_fpu(target);
-	if (ret)
-		return ret;
+	init_fpu(target);
 
 	if (use_xsaveopt())
 		sanitize_i387_state(target);
@@ -232,9 +218,7 @@ int xstateregs_get(struct task_struct *target, const struct user_regset *regset,
 	if (!cpu_has_xsave)
 		return -ENODEV;
 
-	ret = init_fpu(target);
-	if (ret)
-		return ret;
+	init_fpu(target);
 
 	/*
 	 * Copy the 48bytes defined by the software first into the xstate
@@ -262,9 +246,7 @@ int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
 	if (!cpu_has_xsave)
 		return -ENODEV;
 
-	ret = init_fpu(target);
-	if (ret)
-		return ret;
+	init_fpu(target);
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
 				 &target->thread.fpu.state->xsave, 0, -1);
@@ -427,11 +409,8 @@ int fpregs_get(struct task_struct *target, const struct user_regset *regset,
 	       void *kbuf, void __user *ubuf)
 {
 	struct user_i387_ia32_struct env;
-	int ret;
 
-	ret = init_fpu(target);
-	if (ret)
-		return ret;
+	init_fpu(target);
 
 	if (!HAVE_HWFP)
 		return fpregs_soft_get(target, regset, pos, count, kbuf, ubuf);
@@ -462,9 +441,7 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 	struct user_i387_ia32_struct env;
 	int ret;
 
-	ret = init_fpu(target);
-	if (ret)
-		return ret;
+	init_fpu(target);
 
 	if (use_xsaveopt())
 		sanitize_i387_state(target);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 872fc78..c8fbd04 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -734,20 +734,8 @@ asmlinkage void math_state_restore(void)
 	struct thread_info *thread = current_thread_info();
 	struct task_struct *tsk = thread->task;
 
-	if (!tsk_used_math(tsk)) {
-		local_irq_enable();
-		/*
-		 * does a slab alloc which can sleep
-		 */
-		if (init_fpu(tsk)) {
-			/*
-			 * ran out of memory!
-			 */
-			do_group_exit(SIGKILL);
-			return;
-		}
-		local_irq_disable();
-	}
+	if (!tsk_used_math(tsk))
+		init_fpu(tsk);
 
 	restore_xstates(tsk, XCNTXT_LAZY);
 }
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index a188362..62f2df8 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -264,7 +264,6 @@ int restore_xstates_sigframe(void __user *buf, unsigned int size)
 	struct _fpstate_ia32 __user *fp = buf;
 	struct xsave_struct *xsave;
 	u64 xstate_mask = pcntxt_mask & XCNTXT_NONLAZY;
-	int err;
 
 	if (!buf) {
 		if (used_math()) {
@@ -277,11 +276,8 @@ int restore_xstates_sigframe(void __user *buf, unsigned int size)
 	if (!access_ok(VERIFY_READ, buf, size))
 		return -EACCES;
 
-	if (!used_math()) {
-		err = init_fpu(tsk);
-		if (err)
-			return err;
-	}
+	if (!used_math())
+		init_fpu(tsk);
 
 	if (!HAVE_HWFP) {
 		set_used_math();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bc04e15..17e52a9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5386,8 +5386,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	int r;
 	sigset_t sigsaved;
 
-	if (!tsk_used_math(current) && init_fpu(current))
-		return -ENOMEM;
+	if (!tsk_used_math(current))
+		init_fpu(current);
 
 	if (vcpu->sigset_active)
 		sigprocmask(SIG_SETMASK, &vcpu->sigset, &sigsaved);
diff --git a/arch/x86/math-emu/fpu_entry.c b/arch/x86/math-emu/fpu_entry.c
index 7718541..472e2b9 100644
--- a/arch/x86/math-emu/fpu_entry.c
+++ b/arch/x86/math-emu/fpu_entry.c
@@ -147,12 +147,8 @@ void math_emulate(struct math_emu_info *info)
 	unsigned long code_limit = 0;	/* Initialized to stop compiler warnings */
 	struct desc_struct code_descriptor;
 
-	if (!used_math()) {
-		if (init_fpu(current)) {
-			do_group_exit(SIGKILL);
-			return;
-		}
-	}
+	if (!used_math())
+		init_fpu(current);
 
 #ifdef RE_ENTRANT_CHECKING
 	if (emulating) {

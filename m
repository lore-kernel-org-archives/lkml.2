Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155Ab1CWP25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:28:57 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:10483
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933095Ab1CWP2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:28:06 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LIIOAK-02-7FD-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@elte.hu>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <brgerst@gmail.com>,
        <suresh.b.siddha@intel.com>, <eranian@google.com>,
        <robert.richter@amd.com>, <Andreas.Herrmann3@amd.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [RFC v2 8/8] x86, xsave: remove lazy allocation of xstate area
Date: Wed, 23 Mar 2011 16:27:47 +0100
Message-ID: <1300894067-604408-9-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299698102-972771-9-git-send-email-hans.rosenfeld@amd.com>
References: <1299698102-972771-9-git-send-email-hans.rosenfeld@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch completely removes lazy allocation of the xstate area. All
tasks will always have an xstate area preallocated, just like they
already do when non-lazy features are present. The size of the xsave
area ranges from 112 to 960 bytes, depending on the xstates present and
enabled. Since it is common to use SSE etc. for optimization, the actual
overhead is expected to negligible.

This removes some of the special-case handling of non-lazy xstates. It
also greatly simplifies init_fpu() by removing the allocation code, the
check for presence of the xstate area or init_fpu() return value.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/include/asm/i387.h   |   12 +++-------
 arch/x86/kernel/i387.c        |   46 +++++++++++-----------------------------
 arch/x86/kernel/traps.c       |   16 +------------
 arch/x86/kernel/xsave.c       |   21 ++----------------
 arch/x86/kvm/x86.c            |    4 +-
 arch/x86/math-emu/fpu_entry.c |    8 +-----
 6 files changed, 26 insertions(+), 81 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 22ad24c..0448f45 100644
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
 
@@ -332,13 +332,9 @@ extern void fpu_finit(struct fpu *fpu);
 
 static inline void fpu_clear(struct fpu *fpu)
 {
-	if (pcntxt_mask & XCNTXT_NONLAZY) {
-		memset(fpu->state, 0, xstate_size);
-		fpu_finit(fpu);
-		set_used_math();
-	} else {
-		fpu_free(fpu);
-	}
+	memset(fpu->state, 0, xstate_size);
+	fpu_finit(fpu);
+	set_used_math();
 }
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 88fefba..32b3c8d 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -42,6 +42,8 @@ void __cpuinit mxcsr_feature_mask_init(void)
 
 static void __cpuinit init_thread_xstate(void)
 {
+	static union thread_xstate x;
+
 	/*
 	 * Note that xstate_size might be overwriten later during
 	 * xsave_init().
@@ -62,6 +64,9 @@ static void __cpuinit init_thread_xstate(void)
 		xstate_size = sizeof(struct i387_fxsave_struct);
 	else
 		xstate_size = sizeof(struct i387_fsave_struct);
+
+	init_task.thread.fpu.state = &x;
+	fpu_finit(&init_task.thread.fpu);
 }
 
 /*
@@ -127,30 +132,20 @@ EXPORT_SYMBOL_GPL(fpu_finit);
  * value at reset if we support XMM instructions and then
  * remeber the current task has used the FPU.
  */
-int init_fpu(struct task_struct *tsk)
+void init_fpu(struct task_struct *tsk)
 {
-	int ret;
-
 	if (tsk_used_math(tsk)) {
 		if (HAVE_HWFP && tsk == current) {
 			preempt_disable();
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
 
@@ -173,14 +168,10 @@ int xfpregs_get(struct task_struct *target, const struct user_regset *regset,
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
@@ -198,9 +189,7 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 	if (!cpu_has_fxsr)
 		return -ENODEV;
 
-	ret = init_fpu(target);
-	if (ret)
-		return ret;
+	init_fpu(target);
 
 	if (use_xsaveopt())
 		sanitize_i387_state(target);
@@ -232,9 +221,7 @@ int xstateregs_get(struct task_struct *target, const struct user_regset *regset,
 	if (!cpu_has_xsave)
 		return -ENODEV;
 
-	ret = init_fpu(target);
-	if (ret)
-		return ret;
+	init_fpu(target);
 
 	/*
 	 * Copy the 48bytes defined by the software first into the xstate
@@ -262,9 +249,7 @@ int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
 	if (!cpu_has_xsave)
 		return -ENODEV;
 
-	ret = init_fpu(target);
-	if (ret)
-		return ret;
+	init_fpu(target);
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
 				 &target->thread.fpu.state->xsave, 0, -1);
@@ -427,11 +412,8 @@ int fpregs_get(struct task_struct *target, const struct user_regset *regset,
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
@@ -462,9 +444,7 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
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
index d3dc65e..81f54e9 100644
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
@@ -481,13 +477,8 @@ static void __init xstate_enable_boot_cpu(void)
 	       "cntxt size 0x%x\n",
 	       pcntxt_mask, xstate_size);
 
-	if (pcntxt_mask & XCNTXT_NONLAZY) {
-		static union thread_xstate x;
-
+	if (pcntxt_mask & XCNTXT_NONLAZY)
 		task_thread_info(&init_task)->xstate_mask |= XCNTXT_NONLAZY;
-		init_task.thread.fpu.state = &x;
-		fpu_finit(&init_task.thread.fpu);
-	}
 }
 
 /*
@@ -530,9 +521,6 @@ void save_xstates(struct task_struct *tsk)
 {
 	struct thread_info *ti = task_thread_info(tsk);
 
-	if (!fpu_allocated(&tsk->thread.fpu))
-		return;
-
 	xsave(&tsk->thread.fpu.state->xsave, ti->xstate_mask);
 
 	if (!(ti->xstate_mask & XCNTXT_LAZY))
@@ -566,9 +554,6 @@ void restore_xstates(struct task_struct *tsk, u64 mask)
 {
 	struct thread_info *ti = task_thread_info(tsk);
 
-	if (!fpu_allocated(&tsk->thread.fpu))
-		return;
-
 	xrstor(&tsk->thread.fpu.state->xsave, mask);
 
 	ti->xstate_mask |= mask;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 10aeb04..bd71b12 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5377,8 +5377,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
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
-- 
1.5.6.5



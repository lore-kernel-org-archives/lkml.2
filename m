Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab1K2MnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:43:06 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:58637
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755194Ab1K2Mmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:42:53 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVF9Z8-02-H4J-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>
CC: <tglx@linutronix.de>, <mingo@elte.hu>, <suresh.b.siddha@intel.com>,
        <eranian@google.com>, <brgerst@gmail.com>, <robert.richter@amd.com>,
        <Andreas.Herrmann3@amd.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 7/9] x86, xsave: remove lazy allocation of xstate area
Date: Tue, 29 Nov 2011 13:41:26 +0100
Message-ID: <1322570488-21798-8-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322570488-21798-1-git-send-email-hans.rosenfeld@amd.com>
References: <1322570488-21798-1-git-send-email-hans.rosenfeld@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes lazy allocation of the xstate area. All user tasks
will always have an xstate area preallocated. The size of the xsave area
ranges from 112 to 960 bytes, depending on the xstates present and
enabled. Since it is common to use SSE etc. for optimization, the actual
overhead is expected to negligible.

This greatly simplifies some code paths by removing the allocation code
from init_fpu(), the check for presence of the xstate area or the need
to check the init_fpu() return value.

v2:
A single static xsave area just for init is not enough, since there are
more user processes that are directly spawned by kernel threads. Add a
call to a new arch-specific function to flush_old_exec(), which will in
turn call fpu_alloc() to allocate the xsave area if necessary.

v3:
The new xsave area has to be cleared to avoid xrstor errors.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/include/asm/i387.h        |    9 +++++++-
 arch/x86/include/asm/thread_info.h |    2 +
 arch/x86/kernel/i387.c             |   41 ++++++++----------------------------
 arch/x86/kernel/process.c          |   14 ++++++++++++
 arch/x86/kernel/process_32.c       |    4 +-
 arch/x86/kernel/process_64.c       |    4 +-
 arch/x86/kernel/traps.c            |   16 +------------
 arch/x86/kernel/xsave.c            |    8 +-----
 arch/x86/kvm/x86.c                 |    4 +-
 arch/x86/math-emu/fpu_entry.c      |    8 +-----
 fs/exec.c                          |    8 +++++++
 11 files changed, 53 insertions(+), 65 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 3474267..6efe38a 100644
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
 
@@ -330,6 +330,13 @@ static inline void fpu_copy(struct fpu *dst, struct fpu *src)
 
 extern void fpu_finit(struct fpu *fpu);
 
+static inline void fpu_clear(struct fpu *fpu)
+{
+	memset(fpu->state, 0, xstate_size);
+	fpu_finit(fpu);
+	set_used_math();
+}
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_X86_I387_H */
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 02112a7..b886a47 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -265,6 +265,8 @@ static inline void set_restore_sigmask(void)
 extern void arch_task_cache_init(void);
 extern void free_thread_info(struct thread_info *ti);
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
+extern int arch_prealloc_fpu(struct task_struct *tsk);
+#define arch_prealloc_fpu arch_prealloc_fpu
 #define arch_task_cache_init arch_task_cache_init
 #endif
 #endif /* _ASM_X86_THREAD_INFO_H */
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index a1f4bc0..7f0004c 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -127,27 +127,19 @@ EXPORT_SYMBOL_GPL(fpu_finit);
  * value at reset if we support XMM instructions and then
  * remember the current task has used the FPU.
  */
-int init_fpu(struct task_struct *tsk)
+void init_fpu(struct task_struct *tsk)
 {
-	int ret;
+	BUG_ON(tsk->flags & PF_KTHREAD);
 
 	if (tsk_used_math(tsk)) {
 		if (HAVE_HWFP && tsk == current)
 			save_xstates(tsk);
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
 
@@ -170,14 +162,10 @@ int xfpregs_get(struct task_struct *target, const struct user_regset *regset,
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
@@ -195,9 +183,7 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 	if (!cpu_has_fxsr)
 		return -ENODEV;
 
-	ret = init_fpu(target);
-	if (ret)
-		return ret;
+	init_fpu(target);
 
 	if (use_xsaveopt())
 		sanitize_i387_state(target);
@@ -229,9 +215,7 @@ int xstateregs_get(struct task_struct *target, const struct user_regset *regset,
 	if (!cpu_has_xsave)
 		return -ENODEV;
 
-	ret = init_fpu(target);
-	if (ret)
-		return ret;
+	init_fpu(target);
 
 	/*
 	 * Copy the 48bytes defined by the software first into the xstate
@@ -259,9 +243,7 @@ int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
 	if (!cpu_has_xsave)
 		return -ENODEV;
 
-	ret = init_fpu(target);
-	if (ret)
-		return ret;
+	init_fpu(target);
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
 				 &target->thread.fpu.state->xsave, 0, -1);
@@ -424,11 +406,8 @@ int fpregs_get(struct task_struct *target, const struct user_regset *regset,
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
@@ -459,9 +438,7 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 	struct user_i387_ia32_struct env;
 	int ret;
 
-	ret = init_fpu(target);
-	if (ret)
-		return ret;
+	init_fpu(target);
 
 	if (use_xsaveopt())
 		sanitize_i387_state(target);
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e7e3b01..20c4e1c 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -26,6 +26,20 @@
 struct kmem_cache *task_xstate_cachep;
 EXPORT_SYMBOL_GPL(task_xstate_cachep);
 
+int arch_prealloc_fpu(struct task_struct *tsk)
+{
+	if (!fpu_allocated(&tsk->thread.fpu)) {
+		int err = fpu_alloc(&tsk->thread.fpu);
+
+		if (err)
+			return err;
+
+		fpu_clear(&tsk->thread.fpu);
+	}
+
+	return 0;
+}
+
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
 	int ret;
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 22d2bac..22d46f6 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -254,9 +254,9 @@ start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
 	regs->ip		= new_ip;
 	regs->sp		= new_sp;
 	/*
-	 * Free the old FP and other extended state
+	 * Clear the old FP and other extended state
 	 */
-	free_thread_xstate(current);
+	fpu_clear(&current->thread.fpu);
 }
 EXPORT_SYMBOL_GPL(start_thread);
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 2d1745c..436ed82 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -341,9 +341,9 @@ start_thread_common(struct pt_regs *regs, unsigned long new_ip,
 	regs->ss		= _ss;
 	regs->flags		= X86_EFLAGS_IF;
 	/*
-	 * Free the old FP and other extended state
+	 * Clear the old FP and other extended state
 	 */
-	free_thread_xstate(current);
+	fpu_clear(&current->thread.fpu);
 }
 
 void
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index f0946aa..1f04c70 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -733,20 +733,8 @@ asmlinkage void math_state_restore(void)
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
 
 	__restore_xstates(tsk, XCNTXT_LAZY);
 }
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 9d95d2f..1a11291 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -262,7 +262,6 @@ int restore_xstates_sigframe(void __user *buf, unsigned int size)
 	struct _fpstate_ia32 __user *fp = buf;
 	struct xsave_struct *xsave;
 	u64 xstate_mask = 0;
-	int err;
 
 	if (!buf) {
 		if (used_math()) {
@@ -275,11 +274,8 @@ int restore_xstates_sigframe(void __user *buf, unsigned int size)
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
index 36bc63d..b1abb1a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5836,8 +5836,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
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
diff --git a/fs/exec.c b/fs/exec.c
index 25dcbe5..af33562 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1071,10 +1071,18 @@ void set_task_comm(struct task_struct *tsk, char *buf)
 	perf_event_comm(tsk);
 }
 
+#if !defined(arch_prealloc_fpu)
+#define arch_prealloc_fpu(tsk) (0)
+#endif
+
 int flush_old_exec(struct linux_binprm * bprm)
 {
 	int retval;
 
+	retval = arch_prealloc_fpu(current);
+	if (retval)
+		goto out;
+
 	/*
 	 * Make sure we have a private signal table and that
 	 * we are unassociated from the previous thread group.
-- 
1.7.5.4



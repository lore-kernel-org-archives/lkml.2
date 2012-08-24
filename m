Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab2HXVQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 17:16:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:22751 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756445Ab2HXVPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 17:15:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,304,1344236400"; 
   d="scan'208";a="190967416"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        andreas.herrmann3@amd.com, bp@amd64.org, robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        NeilBrown <neilb@suse.de>, Avi Kivity <avi@redhat.com>
Subject: [PATCH 6/6] x86, fpu: use non-lazy fpu restore for processors supporting xsave
Date: Fri, 24 Aug 2012 14:13:02 -0700
Message-Id: <1345842782-24175-7-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com>
References: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fundamental model of the current Linux kernel is to lazily init and
restore FPU instead of restoring the task state during context switch.
This changes that fundamental lazy model to the non-lazy model for
the processors supporting xsave feature.

Reasons driving this model change are:

i. Newer processors support optimized state save/restore using xsaveopt and
xrstor by tracking the INIT state and MODIFIED state during context-switch.
This is faster than modifying the cr0.TS bit which has serializing semantics.

ii. Newer glibc versions use SSE for some of the optimized copy/clear routines.
With certain workloads (like boot, kernel-compilation etc), application
completes its work with in the first 5 task switches, thus taking upto 5 #DNA
traps with the kernel not getting a chance to apply the above mentioned
pre-load heuristic.

iii. Some xstate features (like AMD's LWP feature) don't honor the cr0.TS bit
and thus will not work correctly in the presence of lazy restore. Non-lazy
state restore is needed for enabling such features.

Some data on a two socket SNB system:
 * Saved 20K DNA exceptions during boot on a two socket SNB system.
 * Saved 50K DNA exceptions during kernel-compilation workload.
 * Improved throughput of the AVX based checksumming function inside the
   kernel by ~15% as xsave/xrstor is faster than the serializing clts/stts
   pair.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/fpu-internal.h |   96 +++++++++++++++++++++++------------
 arch/x86/include/asm/i387.h         |    1 +
 arch/x86/include/asm/xsave.h        |    1 +
 arch/x86/kernel/i387.c              |   20 ++++++-
 arch/x86/kernel/process.c           |   12 +++--
 arch/x86/kernel/process_32.c        |    4 --
 arch/x86/kernel/process_64.c        |    4 --
 arch/x86/kernel/traps.c             |    5 ++-
 arch/x86/kernel/xsave.c             |   57 +++++++++++++++++----
 9 files changed, 140 insertions(+), 60 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index fac39e9..e31cc6e 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -291,15 +291,48 @@ static inline void __thread_set_has_fpu(struct task_struct *tsk)
 static inline void __thread_fpu_end(struct task_struct *tsk)
 {
 	__thread_clear_has_fpu(tsk);
-	stts();
+	if (!use_xsave())
+		stts();
 }
 
 static inline void __thread_fpu_begin(struct task_struct *tsk)
 {
-	clts();
+	if (!use_xsave())
+		clts();
 	__thread_set_has_fpu(tsk);
 }
 
+static inline void __drop_fpu(struct task_struct *tsk)
+{
+	if (__thread_has_fpu(tsk)) {
+		/* Ignore delayed exceptions from user space */
+		asm volatile("1: fwait\n"
+			     "2:\n"
+			     _ASM_EXTABLE(1b, 2b));
+		__thread_fpu_end(tsk);
+	}
+}
+
+static inline void drop_fpu(struct task_struct *tsk)
+{
+	/*
+	 * Forget coprocessor state..
+	 */
+	preempt_disable();
+	tsk->fpu_counter = 0;
+	__drop_fpu(tsk);
+	clear_used_math();
+	preempt_enable();
+}
+
+static inline void drop_init_fpu(struct task_struct *tsk)
+{
+	if (!use_xsave())
+		drop_fpu(tsk);
+	else
+		xrstor_state(init_xstate_buf, -1);
+}
+
 /*
  * FPU state switching for scheduling.
  *
@@ -333,7 +366,12 @@ static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct ta
 {
 	fpu_switch_t fpu;
 
-	fpu.preload = tsk_used_math(new) && new->fpu_counter > 5;
+	/*
+	 * If the task has used the math, pre-load the FPU on xsave processors
+	 * or if the past 5 consecutive context-switches used math.
+	 */
+	fpu.preload = tsk_used_math(new) && (use_xsave() ||
+					     new->fpu_counter > 5);
 	if (__thread_has_fpu(old)) {
 		if (!__save_init_fpu(old))
 			cpu = ~0;
@@ -345,14 +383,14 @@ static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct ta
 			new->fpu_counter++;
 			__thread_set_has_fpu(new);
 			prefetch(new->thread.fpu.state);
-		} else
+		} else if (!use_xsave())
 			stts();
 	} else {
 		old->fpu_counter = 0;
 		old->thread.fpu.last_cpu = ~0;
 		if (fpu.preload) {
 			new->fpu_counter++;
-			if (fpu_lazy_restore(new, cpu))
+			if (!use_xsave() && fpu_lazy_restore(new, cpu))
 				fpu.preload = 0;
 			else
 				prefetch(new->thread.fpu.state);
@@ -372,7 +410,7 @@ static inline void switch_fpu_finish(struct task_struct *new, fpu_switch_t fpu)
 {
 	if (fpu.preload) {
 		if (unlikely(restore_fpu_checking(new)))
-			__thread_fpu_end(new);
+			drop_init_fpu(new);
 	}
 }
 
@@ -400,17 +438,6 @@ static inline int restore_xstate_sig(void __user *buf, int ia32_frame)
 	return __restore_xstate_sig(buf, buf_fx, size);
 }
 
-static inline void __drop_fpu(struct task_struct *tsk)
-{
-	if (__thread_has_fpu(tsk)) {
-		/* Ignore delayed exceptions from user space */
-		asm volatile("1: fwait\n"
-			     "2:\n"
-			     _ASM_EXTABLE(1b, 2b));
-		__thread_fpu_end(tsk);
-	}
-}
-
 /*
  * Need to be preemption-safe.
  *
@@ -431,24 +458,18 @@ static inline void user_fpu_begin(void)
 static inline void save_init_fpu(struct task_struct *tsk)
 {
 	WARN_ON_ONCE(!__thread_has_fpu(tsk));
+
+	if (use_xsave()) {
+		xsave_state(&tsk->thread.fpu.state->xsave, -1);
+		return;
+	}
+
 	preempt_disable();
 	__save_init_fpu(tsk);
 	__thread_fpu_end(tsk);
 	preempt_enable();
 }
 
-static inline void drop_fpu(struct task_struct *tsk)
-{
-	/*
-	 * Forget coprocessor state..
-	 */
-	tsk->fpu_counter = 0;
-	preempt_disable();
-	__drop_fpu(tsk);
-	preempt_enable();
-	clear_used_math();
-}
-
 /*
  * i387 state interaction
  */
@@ -503,12 +524,21 @@ static inline void fpu_free(struct fpu *fpu)
 	}
 }
 
-static inline void fpu_copy(struct fpu *dst, struct fpu *src)
+static inline void fpu_copy(struct task_struct *dst, struct task_struct *src)
 {
-	memcpy(dst->state, src->state, xstate_size);
-}
+	if (use_xsave()) {
+		struct xsave_struct *xsave = &dst->thread.fpu.state->xsave;
 
-extern void fpu_finit(struct fpu *fpu);
+		memset(&xsave->xsave_hdr, 0, sizeof(struct xsave_hdr_struct));
+		xsave_state(xsave, -1);
+	} else {
+		struct fpu *dfpu = &dst->thread.fpu;
+		struct fpu *sfpu = &src->thread.fpu;
+
+		unlazy_fpu(src);
+		memcpy(dfpu->state, sfpu->state, xstate_size);
+	}
+}
 
 static inline unsigned long
 alloc_mathframe(unsigned long sp, int ia32_frame, unsigned long *buf_fx,
diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 257d9cc..6c3bd37 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -19,6 +19,7 @@ struct pt_regs;
 struct user_i387_struct;
 
 extern int init_fpu(struct task_struct *child);
+extern void fpu_finit(struct fpu *fpu);
 extern int dump_fpu(struct pt_regs *, struct user_i387_struct *);
 extern void math_state_restore(void);
 
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index c1d989a..2ddee1b8 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -34,6 +34,7 @@
 extern unsigned int xstate_size;
 extern u64 pcntxt_mask;
 extern u64 xstate_fx_sw_bytes[USER_XSTATE_FX_SW_WORDS];
+extern struct xsave_struct *init_xstate_buf;
 
 extern void xsave_init(void);
 extern void update_regset_xstate_info(unsigned int size, u64 xstate_mask);
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index ab6a2e8..5285574 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -22,7 +22,15 @@
 /*
  * Were we in an interrupt that interrupted kernel mode?
  *
- * We can do a kernel_fpu_begin/end() pair *ONLY* if that
+ * For now, on xsave platforms we will return interrupted
+ * kernel FPU as not-idle. TBD: As we use non-lazy FPU restore
+ * for xsave platforms, ideally we can change the return value
+ * to something like __thread_has_fpu(current). But we need to
+ * be careful of doing __thread_clear_has_fpu() before saving
+ * the FPU etc for supporting nested uses etc. For now, take
+ * the simple route!
+ *
+ * On others, we can do a kernel_fpu_begin/end() pair *ONLY* if that
  * pair does nothing at all: the thread must not have fpu (so
  * that we don't try to save the FPU state), and TS must
  * be set (so that the clts/stts pair does nothing that is
@@ -30,6 +38,9 @@
  */
 static inline bool interrupted_kernel_fpu_idle(void)
 {
+	if (use_xsave())
+		return 0;
+
 	return !__thread_has_fpu(current) &&
 		(read_cr0() & X86_CR0_TS);
 }
@@ -73,7 +84,7 @@ void kernel_fpu_begin(void)
 		__save_init_fpu(me);
 		__thread_clear_has_fpu(me);
 		/* We do 'stts()' in kernel_fpu_end() */
-	} else {
+	} else if (!use_xsave()) {
 		this_cpu_write(fpu_owner_task, NULL);
 		clts();
 	}
@@ -82,7 +93,10 @@ EXPORT_SYMBOL(kernel_fpu_begin);
 
 void kernel_fpu_end(void)
 {
-	stts();
+	if (use_xsave())
+		math_state_restore();
+	else
+		stts();
 	preempt_enable();
 }
 EXPORT_SYMBOL(kernel_fpu_end);
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 30069d1..c21e30f 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -66,15 +66,13 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
 	int ret;
 
-	unlazy_fpu(src);
-
 	*dst = *src;
 	if (fpu_allocated(&src->thread.fpu)) {
 		memset(&dst->thread.fpu, 0, sizeof(dst->thread.fpu));
 		ret = fpu_alloc(&dst->thread.fpu);
 		if (ret)
 			return ret;
-		fpu_copy(&dst->thread.fpu, &src->thread.fpu);
+		fpu_copy(dst, src);
 	}
 	return 0;
 }
@@ -153,7 +151,13 @@ void flush_thread(void)
 
 	flush_ptrace_hw_breakpoint(tsk);
 	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
-	drop_fpu(tsk);
+	drop_init_fpu(tsk);
+	/*
+	 * Free the FPU state for non xsave platforms. They get reallocated
+	 * lazily at the first use.
+	 */
+	if (!use_xsave())
+		free_thread_xstate(tsk);
 }
 
 static void hard_disable_TSC(void)
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 516fa18..b9ff83c 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -190,10 +190,6 @@ start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
 	regs->cs		= __USER_CS;
 	regs->ip		= new_ip;
 	regs->sp		= new_sp;
-	/*
-	 * Free the old FP and other extended state
-	 */
-	free_thread_xstate(current);
 }
 EXPORT_SYMBOL_GPL(start_thread);
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 0a980c9..8a6d20c 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -232,10 +232,6 @@ start_thread_common(struct pt_regs *regs, unsigned long new_ip,
 	regs->cs		= _cs;
 	regs->ss		= _ss;
 	regs->flags		= X86_EFLAGS_IF;
-	/*
-	 * Free the old FP and other extended state
-	 */
-	free_thread_xstate(current);
 }
 
 void
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b481341..ac7d527 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -613,11 +613,12 @@ void math_state_restore(void)
 	}
 
 	__thread_fpu_begin(tsk);
+
 	/*
 	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
 	 */
 	if (unlikely(restore_fpu_checking(tsk))) {
-		__thread_fpu_end(tsk);
+		drop_init_fpu(tsk);
 		force_sig(SIGSEGV, tsk);
 		return;
 	}
@@ -629,6 +630,8 @@ EXPORT_SYMBOL_GPL(math_state_restore);
 dotraplinkage void __kprobes
 do_device_not_available(struct pt_regs *regs, long error_code)
 {
+	BUG_ON(use_xsave());
+
 #ifdef CONFIG_MATH_EMULATION
 	if (read_cr0() & X86_CR0_EM) {
 		struct math_emu_info info = { };
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index f0bb844..55bf571 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -21,7 +21,7 @@ u64 pcntxt_mask;
 /*
  * Represents init state for the supported extended state.
  */
-static struct xsave_struct *init_xstate_buf;
+struct xsave_struct *init_xstate_buf;
 
 static struct _fpx_sw_bytes fx_sw_reserved, fx_sw_reserved_ia32;
 static unsigned int *xstate_offsets, *xstate_sizes, xstate_features;
@@ -267,7 +267,7 @@ int save_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 	if (use_fxsr() && save_xstate_epilog(buf_fx, ia32_fxstate))
 		return -1;
 
-	drop_fpu(tsk);	/* trigger finit */
+	drop_init_fpu(tsk);	/* trigger finit */
 
 	return 0;
 }
@@ -339,7 +339,7 @@ int __restore_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 			 config_enabled(CONFIG_IA32_EMULATION));
 
 	if (!buf) {
-		drop_fpu(tsk);
+		drop_init_fpu(tsk);
 		return 0;
 	}
 
@@ -379,15 +379,30 @@ int __restore_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 		 */
 		struct xsave_struct *xsave = &tsk->thread.fpu.state->xsave;
 		struct user_i387_ia32_struct env;
+		int err = 0;
 
+		/*
+		 * Drop the current fpu which clears used_math(). This ensures
+		 * that any context-switch during the copy of the new state,
+		 * avoids the intermediate state from getting restored/saved.
+		 * Thus avoiding the new restored state from getting corrupted.
+		 * We will be ready to restore/save the state only after
+		 * set_used_math() is again set.
+		 */
 		drop_fpu(tsk);
 
 		if (__copy_from_user(xsave, buf_fx, state_size) ||
-		    __copy_from_user(&env, buf, sizeof(env)))
-			return -1;
+		    __copy_from_user(&env, buf, sizeof(env))) {
+			err = -1;
+		} else {
+			sanitize_restored_xstate(tsk, &env, xstate_bv, fx_only);
+			set_used_math();
+		}
 
-		sanitize_restored_xstate(tsk, &env, xstate_bv, fx_only);
-		set_used_math();
+		if (use_xsave())
+			math_state_restore();
+
+		return err;
 	} else {
 		/*
 		 * For 64-bit frames and 32-bit fsave frames, restore the user
@@ -395,7 +410,7 @@ int __restore_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 		 */
 		user_fpu_begin();
 		if (restore_user_xstate(buf_fx, xstate_bv, fx_only)) {
-			drop_fpu(tsk);
+			drop_init_fpu(tsk);
 			return -1;
 		}
 	}
@@ -434,11 +449,29 @@ static void prepare_fx_sw_frame(void)
  */
 static inline void xstate_enable(void)
 {
+	clts();
 	set_in_cr4(X86_CR4_OSXSAVE);
 	xsetbv(XCR_XFEATURE_ENABLED_MASK, pcntxt_mask);
 }
 
 /*
+ * This is same as math_state_restore(). But use_xsave() is not yet
+ * patched to use math_state_restore().
+ */
+static inline void init_restore_xstate(void)
+{
+	init_fpu(current);
+	__thread_fpu_begin(current);
+	xrstor_state(init_xstate_buf, -1);
+}
+
+static inline void xstate_enable_ap(void)
+{
+	xstate_enable();
+	init_restore_xstate();
+}
+
+/*
  * Record the offsets and sizes of different state managed by the xsave
  * memory layout.
  */
@@ -478,7 +511,6 @@ static void __init setup_xstate_init(void)
 					      __alignof__(struct xsave_struct));
 	init_xstate_buf->i387.mxcsr = MXCSR_DEFAULT;
 
-	clts();
 	/*
 	 * Init all the features state with header_bv being 0x0
 	 */
@@ -488,7 +520,6 @@ static void __init setup_xstate_init(void)
 	 * of any feature which is not represented by all zero's.
 	 */
 	xsave_state(init_xstate_buf, -1);
-	stts();
 }
 
 /*
@@ -532,6 +563,10 @@ static void __init xstate_enable_boot_cpu(void)
 
 	pr_info("enabled xstate_bv 0x%llx, cntxt size 0x%x\n",
 		pcntxt_mask, xstate_size);
+
+	current->thread.fpu.state =
+	     alloc_bootmem_align(xstate_size, __alignof__(struct xsave_struct));
+	init_restore_xstate();
 }
 
 /*
@@ -550,6 +585,6 @@ void __cpuinit xsave_init(void)
 		return;
 
 	this_func = next_func;
-	next_func = xstate_enable;
+	next_func = xstate_enable_ap;
 	this_func();
 }
-- 
1.7.6.5


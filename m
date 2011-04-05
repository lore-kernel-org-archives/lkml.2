Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab1DEPvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:51:46 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:2866 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab1DEPvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:51:44 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJ6S12-01-Q68-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>
CC: <brgerst@gmail.com>, <tglx@linutronix.de>, <mingo@elte.hu>,
        <suresh.b.siddha@intel.com>, <eranian@google.com>,
        <robert.richter@amd.com>, <Andreas.Herrmann3@amd.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [RFC v3 2/8] x86, xsave: rework fpu/xsave support
Date: Tue, 5 Apr 2011 17:50:50 +0200
Message-ID: <1302018656-586370-3-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <4D91FA76.1010908@zytor.com>
References: <4D91FA76.1010908@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a complete rework of the code that handles FPU and related
extended states. Since FPU, XMM and YMM states are just variants of what
xsave handles, all of the old FPU-specific state handling code will be
hidden behind a set of functions that resemble xsave and xrstor. For
hardware that does not support xsave, the code falls back to
fxsave/fxrstor or even fsave/frstor.

A xstate_mask member will be added to the thread_info structure that
will control which states are to be saved by xsave. It is set to include
all "lazy" states (that is, all states currently supported: FPU, XMM and
YMM) by the #NM handler when a lazy restore is triggered or by
switch_to() when the tasks FPU context is preloaded. Xstate_mask is
intended to completely replace TS_USEDFPU in a later cleanup patch.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/include/asm/i387.h        |   44 +++++++++++++++++++---
 arch/x86/include/asm/thread_info.h |    2 +
 arch/x86/include/asm/xsave.h       |   14 ++++++-
 arch/x86/kernel/i387.c             |   11 ++++--
 arch/x86/kernel/process_32.c       |   27 +++++---------
 arch/x86/kernel/process_64.c       |   26 ++++----------
 arch/x86/kernel/traps.c            |   11 +++---
 arch/x86/kernel/xsave.c            |   71 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c                 |    7 ++--
 drivers/lguest/x86/core.c          |    2 +-
 10 files changed, 158 insertions(+), 57 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index d908383..939af08 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -224,12 +224,46 @@ static inline void fpu_fxsave(struct fpu *fpu)
 /*
  * These must be called with preempt disabled
  */
+static inline void fpu_restore(struct fpu *fpu)
+{
+	fxrstor_checking(&fpu->state->fxsave);
+}
+
+static inline void fpu_save(struct fpu *fpu)
+{
+	if (use_fxsr()) {
+		fpu_fxsave(fpu);
+	} else {
+		asm volatile("fsave %[fx]; fwait"
+			     : [fx] "=m" (fpu->state->fsave));
+	}
+}
+
+static inline void fpu_clean(struct fpu *fpu)
+{
+	u32 swd = (use_fxsr() || use_xsave()) ?
+		fpu->state->fxsave.swd : fpu->state->fsave.swd;
+
+	if (unlikely(swd & X87_FSW_ES))
+		asm volatile("fnclex");
+
+	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
+	   is pending.  Clear the x87 state here by setting it to fixed
+	   values. safe_address is a random variable that should be in L1 */
+	alternative_input(
+		ASM_NOP8 ASM_NOP2,
+		"emms\n\t"	  	/* clear stack tags */
+		"fildl %P[addr]",	/* set F?P to defined value */
+		X86_FEATURE_FXSAVE_LEAK,
+		[addr] "m" (safe_address));
+}
+
 static inline void fpu_save_init(struct fpu *fpu)
 {
 	if (use_xsave()) {
 		struct xsave_struct *xstate = &fpu->state->xsave;
 
-		fpu_xsave(xstate);
+		fpu_xsave(xstate, -1);
 
 		/*
 		 * xsave header may indicate the init state of the FP.
@@ -295,18 +329,16 @@ static inline void __clear_fpu(struct task_struct *tsk)
 			     "2:\n"
 			     _ASM_EXTABLE(1b, 2b));
 		task_thread_info(tsk)->status &= ~TS_USEDFPU;
+		task_thread_info(tsk)->xstate_mask &= ~XCNTXT_LAZY;
 		stts();
 	}
 }
 
 static inline void kernel_fpu_begin(void)
 {
-	struct thread_info *me = current_thread_info();
 	preempt_disable();
-	if (me->status & TS_USEDFPU)
-		__save_init_fpu(me->task);
-	else
-		clts();
+	save_xstates(current_thread_info()->task);
+	clts();
 }
 
 static inline void kernel_fpu_end(void)
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 1f2e61e..ec12d62 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -26,6 +26,7 @@ struct exec_domain;
 struct thread_info {
 	struct task_struct	*task;		/* main task structure */
 	struct exec_domain	*exec_domain;	/* execution domain */
+	__u64			xstate_mask;	/* xstates in use */
 	__u32			flags;		/* low level flags */
 	__u32			status;		/* thread synchronous flags */
 	__u32			cpu;		/* current CPU */
@@ -47,6 +48,7 @@ struct thread_info {
 {						\
 	.task		= &tsk,			\
 	.exec_domain	= &default_exec_domain,	\
+	.xstate_mask	= 0,			\
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 8bcbbce..6052a84 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -25,6 +25,8 @@
  */
 #define XCNTXT_MASK	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
 
+#define XCNTXT_LAZY	XCNTXT_MASK
+
 #ifdef CONFIG_X86_64
 #define REX_PREFIX	"0x48, "
 #else
@@ -35,6 +37,11 @@ extern unsigned int xstate_size;
 extern u64 pcntxt_mask;
 extern u64 xstate_fx_sw_bytes[USER_XSTATE_FX_SW_WORDS];
 
+extern void xsave(struct fpu *, u64);
+extern void xrstor(struct fpu *, u64);
+extern void save_xstates(struct task_struct *);
+extern void restore_xstates(struct task_struct *, u64);
+
 extern void xsave_init(void);
 extern void update_regset_xstate_info(unsigned int size, u64 xstate_mask);
 extern int init_fpu(struct task_struct *child);
@@ -113,15 +120,18 @@ static inline void xsave_state(struct xsave_struct *fx, u64 mask)
 		     :   "memory");
 }
 
-static inline void fpu_xsave(struct xsave_struct *fx)
+static inline void fpu_xsave(struct xsave_struct *fx, u64 mask)
 {
+	u32 lmask = mask;
+	u32 hmask = mask >> 32;
+
 	/* This, however, we can work around by forcing the compiler to select
 	   an addressing mode that doesn't require extended registers. */
 	alternative_input(
 		".byte " REX_PREFIX "0x0f,0xae,0x27",
 		".byte " REX_PREFIX "0x0f,0xae,0x37",
 		X86_FEATURE_XSAVEOPT,
-		[fx] "D" (fx), "a" (-1), "d" (-1) :
+		[fx] "D" (fx), "a" (lmask), "d" (hmask) :
 		"memory");
 }
 #endif
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 12aff25..1088ac5 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -152,8 +152,11 @@ int init_fpu(struct task_struct *tsk)
 	int ret;
 
 	if (tsk_used_math(tsk)) {
-		if (HAVE_HWFP && tsk == current)
-			unlazy_fpu(tsk);
+		if (HAVE_HWFP && tsk == current) {
+			preempt_disable();
+			save_xstates(tsk);
+			preempt_enable();
+		}
 		return 0;
 	}
 
@@ -600,7 +603,9 @@ int save_i387_xstate_ia32(void __user *buf)
 				       NULL, fp) ? -1 : 1;
 	}
 
-	unlazy_fpu(tsk);
+	preempt_disable();
+	save_xstates(tsk);
+	preempt_enable();
 
 	if (cpu_has_xsave)
 		return save_i387_xsave(fp);
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 8d12878..8df07c3 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -185,7 +185,9 @@ void release_thread(struct task_struct *dead_task)
  */
 void prepare_to_copy(struct task_struct *tsk)
 {
-	unlazy_fpu(tsk);
+	preempt_disable();
+	save_xstates(tsk);
+	preempt_enable();
 }
 
 int copy_thread(unsigned long clone_flags, unsigned long sp,
@@ -294,21 +296,13 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 				 *next = &next_p->thread;
 	int cpu = smp_processor_id();
 	struct tss_struct *tss = &per_cpu(init_tss, cpu);
-	bool preload_fpu;
 
 	/* never put a printk in __switch_to... printk() calls wake_up*() indirectly */
 
-	/*
-	 * If the task has used fpu the last 5 timeslices, just do a full
-	 * restore of the math state immediately to avoid the trap; the
-	 * chances of needing FPU soon are obviously high now
-	 */
-	preload_fpu = tsk_used_math(next_p) && next_p->fpu_counter > 5;
-
-	__unlazy_fpu(prev_p);
+	save_xstates(prev_p);
 
 	/* we're going to use this soon, after a few expensive things */
-	if (preload_fpu)
+	if (task_thread_info(next_p)->xstate_mask)
 		prefetch(next->fpu.state);
 
 	/*
@@ -349,11 +343,6 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 		     task_thread_info(next_p)->flags & _TIF_WORK_CTXSW_NEXT))
 		__switch_to_xtra(prev_p, next_p, tss);
 
-	/* If we're going to preload the fpu context, make sure clts
-	   is run while we're batching the cpu state updates. */
-	if (preload_fpu)
-		clts();
-
 	/*
 	 * Leave lazy mode, flushing any hypercalls made here.
 	 * This must be done before restoring TLS segments so
@@ -363,8 +352,10 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 */
 	arch_end_context_switch(next_p);
 
-	if (preload_fpu)
-		__math_state_restore();
+	/*
+	 * Restore enabled extended states for the task.
+	 */
+	restore_xstates(next_p, task_thread_info(next_p)->xstate_mask);
 
 	/*
 	 * Restore %gs if needed (which is common)
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 6c9dd92..cbf1a67 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -249,7 +249,9 @@ static inline u32 read_32bit_tls(struct task_struct *t, int tls)
  */
 void prepare_to_copy(struct task_struct *tsk)
 {
-	unlazy_fpu(tsk);
+	preempt_disable();
+	save_xstates(tsk);
+	preempt_enable();
 }
 
 int copy_thread(unsigned long clone_flags, unsigned long sp,
@@ -378,17 +380,9 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	int cpu = smp_processor_id();
 	struct tss_struct *tss = &per_cpu(init_tss, cpu);
 	unsigned fsindex, gsindex;
-	bool preload_fpu;
-
-	/*
-	 * If the task has used fpu the last 5 timeslices, just do a full
-	 * restore of the math state immediately to avoid the trap; the
-	 * chances of needing FPU soon are obviously high now
-	 */
-	preload_fpu = tsk_used_math(next_p) && next_p->fpu_counter > 5;
 
 	/* we're going to use this soon, after a few expensive things */
-	if (preload_fpu)
+	if (task_thread_info(next_p)->xstate_mask)
 		prefetch(next->fpu.state);
 
 	/*
@@ -420,11 +414,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	load_TLS(next, cpu);
 
 	/* Must be after DS reload */
-	__unlazy_fpu(prev_p);
-
-	/* Make sure cpu is ready for new context */
-	if (preload_fpu)
-		clts();
+	save_xstates(prev_p);
 
 	/*
 	 * Leave lazy mode, flushing any hypercalls made here.
@@ -485,11 +475,9 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 		__switch_to_xtra(prev_p, next_p, tss);
 
 	/*
-	 * Preload the FPU context, now that we've determined that the
-	 * task is likely to be using it. 
+	 * Restore enabled extended states for the task.
 	 */
-	if (preload_fpu)
-		__math_state_restore();
+	restore_xstates(next_p, task_thread_info(next_p)->xstate_mask);
 
 	return prev_p;
 }
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 32f3043..072c30e 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -625,7 +625,10 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
 	/*
 	 * Save the info for the exception handler and clear the error.
 	 */
-	save_init_fpu(task);
+	preempt_disable();
+	save_xstates(task);
+	preempt_enable();
+
 	task->thread.trap_no = trapnr;
 	task->thread.error_code = error_code;
 	info.si_signo = SIGFPE;
@@ -734,7 +737,7 @@ void __math_state_restore(void)
 		return;
 	}
 
-	thread->status |= TS_USEDFPU;	/* So we fnsave on switch_to() */
+	thread->status |= TS_USEDFPU;   /* So we fnsave on switch_to() */
 	tsk->fpu_counter++;
 }
 
@@ -768,9 +771,7 @@ asmlinkage void math_state_restore(void)
 		local_irq_disable();
 	}
 
-	clts();				/* Allow maths ops (or we recurse) */
-
-	__math_state_restore();
+	restore_xstates(tsk, XCNTXT_LAZY);
 }
 EXPORT_SYMBOL_GPL(math_state_restore);
 
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 6b063d7..d9fa41f 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -5,6 +5,7 @@
  */
 #include <linux/bootmem.h>
 #include <linux/compat.h>
+#include <linux/module.h>
 #include <asm/i387.h>
 #ifdef CONFIG_IA32_EMULATION
 #include <asm/sigcontext32.h>
@@ -474,3 +475,73 @@ void __cpuinit xsave_init(void)
 	next_func = xstate_enable;
 	this_func();
 }
+
+void xsave(struct fpu *fpu, u64 mask)
+{
+	clts();
+
+	if (use_xsave())
+		fpu_xsave(&fpu->state->xsave, mask);
+	else if (mask & XCNTXT_LAZY)
+		fpu_save(fpu);
+
+	if (mask & XCNTXT_LAZY)
+		fpu_clean(fpu);
+
+	stts();
+}
+EXPORT_SYMBOL(xsave);
+
+void save_xstates(struct task_struct *tsk)
+{
+	struct thread_info *ti = task_thread_info(tsk);
+
+	if (!fpu_allocated(&tsk->thread.fpu))
+		return;
+
+	xsave(&tsk->thread.fpu, ti->xstate_mask);
+
+	if (!(ti->xstate_mask & XCNTXT_LAZY))
+		tsk->fpu_counter = 0;
+
+	/*
+	 * If the task hasn't used the fpu the last 5 timeslices,
+	 * force a lazy restore of the math states by clearing them
+	 * from xstate_mask.
+	 */
+	if (tsk->fpu_counter < 5)
+		ti->xstate_mask &= ~XCNTXT_LAZY;
+
+	ti->status &= ~TS_USEDFPU;
+}
+EXPORT_SYMBOL(save_xstates);
+
+void xrstor(struct fpu *fpu, u64 mask)
+{
+	clts();
+
+	if (use_xsave())
+		xrstor_state(&fpu->state->xsave, mask);
+	else if (mask & XCNTXT_LAZY)
+		fpu_restore(fpu);
+
+	if (!(mask & XCNTXT_LAZY))
+		stts();
+}
+EXPORT_SYMBOL(xrstor);
+
+void restore_xstates(struct task_struct *tsk, u64 mask)
+{
+	struct thread_info *ti = task_thread_info(tsk);
+
+	if (!fpu_allocated(&tsk->thread.fpu))
+		return;
+
+	xrstor(&tsk->thread.fpu, mask);
+
+	ti->xstate_mask |= mask;
+	ti->status |= TS_USEDFPU;
+	if (mask & XCNTXT_LAZY)
+		tsk->fpu_counter++;
+}
+EXPORT_SYMBOL(restore_xstates);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 58f517b..aae9e8f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -58,6 +58,7 @@
 #include <asm/xcr.h>
 #include <asm/pvclock.h>
 #include <asm/div64.h>
+#include <asm/xsave.h>
 
 #define MAX_IO_MSRS 256
 #define CR0_RESERVED_BITS						\
@@ -5803,8 +5804,8 @@ void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 	 */
 	kvm_put_guest_xcr0(vcpu);
 	vcpu->guest_fpu_loaded = 1;
-	unlazy_fpu(current);
-	fpu_restore_checking(&vcpu->arch.guest_fpu);
+	save_xstates(current);
+	xrstor(&vcpu->arch.guest_fpu, -1);
 	trace_kvm_fpu(1);
 }
 
@@ -5816,7 +5817,7 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 		return;
 
 	vcpu->guest_fpu_loaded = 0;
-	fpu_save_init(&vcpu->arch.guest_fpu);
+	xsave(&vcpu->arch.guest_fpu, -1);
 	++vcpu->stat.fpu_reload;
 	kvm_make_request(KVM_REQ_DEACTIVATE_FPU, vcpu);
 	trace_kvm_fpu(0);
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index 9f1659c..ef62289 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -204,7 +204,7 @@ void lguest_arch_run_guest(struct lg_cpu *cpu)
 	 * uses the FPU.
 	 */
 	if (cpu->ts)
-		unlazy_fpu(current);
+		save_xstates(current);
 
 	/*
 	 * SYSENTER is an optimized way of doing system calls.  We can't allow
-- 
1.5.6.5



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab0KWUmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 15:42:36 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:35480
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752547Ab0KWUmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 15:42:04 -0500
X-SpamScore: 4
X-BigFish: VPS4(zz853kzz1202hzz8275bhz32i668h67dh685h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCCUTW-02-40K-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, <brgerst@gmail.com>, <robert.richter@amd.com>,
        <andreas.herrmann3@amd.com>, Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [RFC 2/2] x86, xsave: rework xsave support
Date: Tue, 23 Nov 2010 21:41:53 +0100
Message-ID: <1290544913-489129-3-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <AANLkTinBsut0Csubh1N85jkydH7wCp3YniASE-vyf7MP@mail.gmail.com>
References: <AANLkTinBsut0Csubh1N85jkydH7wCp3YniASE-vyf7MP@mail.gmail.com>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b. Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach, Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr. 43632
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an attempt to rework the code that handles FPU and related
extended states. Since FPU, XMM and YMM states are just variants of what
xsave handles, all of the old FPU-specific state handling code will be
hidden behind a set of functions that resemble xsave and xrstor. For
hardware that does not support xsave, the code falls back to
fxsave/fxrstor or even fsave/frstor.

A xstate_mask member will be added to the thread_info structure that
will control which states are to be saved by xsave. It is set to include
all "lazy" states (that is, all states currently supported) by the #NM
handler when a lazy restore is triggered or by switch_to() when the
tasks FPU context is preloaded. Xstate_mask is intended to completely
replace TS_USEDFPU in a later cleanup patch.

When "non-lazy" states such as for LWP will be added later, the
corresponding bits in xstate_mask are supposed to be set for all threads
all the time. There will be no performance penalty for threads not using
these states, as xsave and xrstor will ignore unused states.

This patch is not complete and not final at all. Support for 32bit is
lacking, and the context handling for signals will probably change
again. I haven't benchmarked it yet, but I have tested it for both the
fxsave and xsave cases.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/include/asm/i387.h        |  103 +++++++---------------
 arch/x86/include/asm/thread_info.h |    2 +
 arch/x86/include/asm/xsave.h       |    7 ++
 arch/x86/kernel/i387.c             |   11 ++-
 arch/x86/kernel/process_64.c       |   24 +++---
 arch/x86/kernel/traps.c            |   31 +------
 arch/x86/kernel/xsave.c            |  174 +++++++++++++++++++-----------------
 arch/x86/kvm/x86.c                 |    7 +-
 8 files changed, 159 insertions(+), 200 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index d908383..53b62c5 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -159,7 +159,7 @@ static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
 	return err;
 }
 
-static inline void fpu_fxsave(struct fpu *fpu)
+static inline void fpu_fxsave(struct i387_fxsave_struct *fx)
 {
 	/* Using "rex64; fxsave %0" is broken because, if the memory operand
 	   uses any extended registers for addressing, a second REX prefix
@@ -170,7 +170,7 @@ static inline void fpu_fxsave(struct fpu *fpu)
 	/* Using "fxsaveq %0" would be the ideal choice, but is only supported
 	   starting with gas 2.16. */
 	__asm__ __volatile__("fxsaveq %0"
-			     : "=m" (fpu->state->fxsave));
+			     : "=m" (*fx));
 #else
 	/* Using, as a workaround, the properly prefixed form below isn't
 	   accepted by any binutils version so far released, complaining that
@@ -181,8 +181,8 @@ static inline void fpu_fxsave(struct fpu *fpu)
 	   This, however, we can work around by forcing the compiler to select
 	   an addressing mode that doesn't require extended registers. */
 	asm volatile("rex64/fxsave (%[fx])"
-		     : "=m" (fpu->state->fxsave)
-		     : [fx] "R" (&fpu->state->fxsave));
+		     : "=m" (*fx)
+		     : [fx] "R" (fx));
 #endif
 }
 
@@ -204,14 +204,34 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 	return 0;
 }
 
-static inline void fpu_fxsave(struct fpu *fpu)
+static inline void fpu_fxsave(struct i387_fxsave_struct *fx)
 {
 	asm volatile("fxsave %[fx]"
-		     : [fx] "=m" (fpu->state->fxsave));
+		     : [fx] "=m" (fx));
 }
 
 #endif	/* CONFIG_X86_64 */
 
+/*
+ * These must be called with preempt disabled
+ */
+
+static inline int fpu_restore(struct i387_fxsave_struct *fx)
+{
+	return fxrstor_checking(fx);
+}
+
+static inline void fpu_save(struct i387_fxsave_struct *fx)
+{
+	if (use_fxsr()) {
+		fpu_fxsave(fx);
+	} else {
+		asm volatile("fsave %[fx]; fwait"
+			     : [fx] "=m" (fx));
+		return;
+	}
+}
+
 /* We need a safe address that is cheap to find and that is already
    in L1 during context switch. The best choices are unfortunately
    different for UP and SMP */
@@ -221,30 +241,9 @@ static inline void fpu_fxsave(struct fpu *fpu)
 #define safe_address (kstat_cpu(0).cpustat.user)
 #endif
 
-/*
- * These must be called with preempt disabled
- */
-static inline void fpu_save_init(struct fpu *fpu)
+static inline void fpu_clean(struct i387_fxsave_struct *fx)
 {
-	if (use_xsave()) {
-		struct xsave_struct *xstate = &fpu->state->xsave;
-
-		fpu_xsave(xstate);
-
-		/*
-		 * xsave header may indicate the init state of the FP.
-		 */
-		if (!(xstate->xsave_hdr.xstate_bv & XSTATE_FP))
-			return;
-	} else if (use_fxsr()) {
-		fpu_fxsave(fpu);
-	} else {
-		asm volatile("fsave %[fx]; fwait"
-			     : [fx] "=m" (fpu->state->fsave));
-		return;
-	}
-
-	if (unlikely(fpu->state->fxsave.swd & X87_FSW_ES))
+	if (unlikely(fx->swd & X87_FSW_ES))
 		asm volatile("fnclex");
 
 	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
@@ -258,35 +257,12 @@ static inline void fpu_save_init(struct fpu *fpu)
 		[addr] "m" (safe_address));
 }
 
-static inline void __save_init_fpu(struct task_struct *tsk)
-{
-	fpu_save_init(&tsk->thread.fpu);
-	task_thread_info(tsk)->status &= ~TS_USEDFPU;
-}
-
-static inline int fpu_restore_checking(struct fpu *fpu)
-{
-	if (use_xsave())
-		return xrstor_checking(&fpu->state->xsave, -1);
-	else
-		return fxrstor_checking(&fpu->state->fxsave);
-}
-
 /*
  * Signal frame handlers...
  */
 extern int save_i387_xstate(void __user *buf);
 extern int restore_i387_xstate(void __user *buf);
 
-static inline void __unlazy_fpu(struct task_struct *tsk)
-{
-	if (task_thread_info(tsk)->status & TS_USEDFPU) {
-		__save_init_fpu(tsk);
-		stts();
-	} else
-		tsk->fpu_counter = 0;
-}
-
 static inline void __clear_fpu(struct task_struct *tsk)
 {
 	if (task_thread_info(tsk)->status & TS_USEDFPU) {
@@ -295,6 +271,7 @@ static inline void __clear_fpu(struct task_struct *tsk)
 			     "2:\n"
 			     _ASM_EXTABLE(1b, 2b));
 		task_thread_info(tsk)->status &= ~TS_USEDFPU;
+		task_thread_info(tsk)->status &= ~XCNTXT_LAZY;
 		stts();
 	}
 }
@@ -303,10 +280,9 @@ static inline void kernel_fpu_begin(void)
 {
 	struct thread_info *me = current_thread_info();
 	preempt_disable();
-	if (me->status & TS_USEDFPU)
-		__save_init_fpu(me->task);
-	else
-		clts();
+	/* XXX saves nonlazy unnecessarily? */
+	save_xstates(me->task);
+	clts();
 }
 
 static inline void kernel_fpu_end(void)
@@ -357,21 +333,6 @@ static inline void irq_ts_restore(int TS_state)
 /*
  * These disable preemption on their own and are safe
  */
-static inline void save_init_fpu(struct task_struct *tsk)
-{
-	preempt_disable();
-	__save_init_fpu(tsk);
-	stts();
-	preempt_enable();
-}
-
-static inline void unlazy_fpu(struct task_struct *tsk)
-{
-	preempt_disable();
-	__unlazy_fpu(tsk);
-	preempt_enable();
-}
-
 static inline void clear_fpu(struct task_struct *tsk)
 {
 	preempt_disable();
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index f0b6e5d..5c92d21 100644
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
index 8bcbbce..2eb019e 100644
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
 
+extern void xsave(struct xsave_struct *, u64);
+extern int  xrstor(struct xsave_struct *, u64);
+extern void save_xstates(struct task_struct *);
+extern void restore_xstates(struct task_struct *, u64);
+
 extern void xsave_init(void);
 extern void update_regset_xstate_info(unsigned int size, u64 xstate_mask);
 extern int init_fpu(struct task_struct *child);
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 58bb239..72bc6f0 100644
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
 
@@ -599,7 +602,9 @@ int save_i387_xstate_ia32(void __user *buf)
 				       NULL, fp) ? -1 : 1;
 	}
 
-	unlazy_fpu(tsk);
+	preempt_disable();
+	save_xstates(tsk);
+	preempt_enable();
 
 	if (cpu_has_xsave)
 		return save_i387_xsave(fp);
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index b3d7a3a..c95a9e5 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -253,7 +253,9 @@ static inline u32 read_32bit_tls(struct task_struct *t, int tls)
  */
 void prepare_to_copy(struct task_struct *tsk)
 {
-	unlazy_fpu(tsk);
+	preempt_disable();
+	save_xstates(tsk);
+	preempt_enable();
 }
 
 int copy_thread(unsigned long clone_flags, unsigned long sp,
@@ -382,18 +384,18 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	int cpu = smp_processor_id();
 	struct tss_struct *tss = &per_cpu(init_tss, cpu);
 	unsigned fsindex, gsindex;
-	bool preload_fpu;
+	u64 preload_lazy = 0;
 
 	/*
 	 * If the task has used fpu the last 5 timeslices, just do a full
 	 * restore of the math state immediately to avoid the trap; the
 	 * chances of needing FPU soon are obviously high now
 	 */
-	preload_fpu = tsk_used_math(next_p) && next_p->fpu_counter > 5;
-
-	/* we're going to use this soon, after a few expensive things */
-	if (preload_fpu)
+	if (tsk_used_math(next_p) && next_p->fpu_counter > 5) {
+		preload_lazy = XCNTXT_LAZY;
+		/* we're going to use this soon, after a few expensive things */
 		prefetch(next->fpu.state);
+	}
 
 	/*
 	 * Reload esp0, LDT and the page table pointer:
@@ -424,11 +426,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
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
@@ -492,8 +490,8 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 * Preload the FPU context, now that we've determined that the
 	 * task is likely to be using it. 
 	 */
-	if (preload_fpu)
-		__math_state_restore();
+	if (preload_lazy)
+		restore_xstates(next_p, preload_lazy);
 
 	return prev_p;
 }
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 1b0d148..b40691b 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -617,7 +617,10 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
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
@@ -709,28 +712,6 @@ asmlinkage void __attribute__((weak)) smp_threshold_interrupt(void)
 }
 
 /*
- * __math_state_restore assumes that cr0.TS is already clear and the
- * fpu state is all ready for use.  Used during context switch.
- */
-void __math_state_restore(void)
-{
-	struct thread_info *thread = current_thread_info();
-	struct task_struct *tsk = thread->task;
-
-	/*
-	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
-	 */
-	if (unlikely(fpu_restore_checking(&tsk->thread.fpu))) {
-		stts();
-		force_sig(SIGSEGV, tsk);
-		return;
-	}
-
-	thread->status |= TS_USEDFPU;	/* So we fnsave on switch_to() */
-	tsk->fpu_counter++;
-}
-
-/*
  * 'math_state_restore()' saves the current math information in the
  * old math state array, and gets the new ones from the current task
  *
@@ -760,9 +741,7 @@ asmlinkage void math_state_restore(void)
 		local_irq_disable();
 	}
 
-	clts();				/* Allow maths ops (or we recurse) */
-
-	__math_state_restore();
+	restore_xstates(tsk, XCNTXT_LAZY);
 }
 EXPORT_SYMBOL_GPL(math_state_restore);
 
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 5eb15d4..5457332 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -47,8 +47,6 @@ void __sanitize_i387_state(struct task_struct *tsk)
 	if (!fx)
 		return;
 
-	BUG_ON(task_thread_info(tsk)->status & TS_USEDFPU);
-
 	xstate_bv = tsk->thread.fpu.state->xsave.xsave_hdr.xstate_bv;
 
 	/*
@@ -168,22 +166,10 @@ int save_i387_xstate(void __user *buf)
 	if (!used_math())
 		return 0;
 
-	if (task_thread_info(tsk)->status & TS_USEDFPU) {
-		if (use_xsave())
-			err = xsave_checking(buf);
-		else
-			err = fxsave_user(buf);
-
-		if (err)
-			return err;
-		task_thread_info(tsk)->status &= ~TS_USEDFPU;
-		stts();
-	} else {
-		sanitize_i387_state(tsk);
-		if (__copy_to_user(buf, &tsk->thread.fpu.state->fxsave,
-				   xstate_size))
-			return -1;
-	}
+	save_xstates(tsk);
+	sanitize_i387_state(tsk);
+	if (__copy_to_user(buf, &tsk->thread.fpu.state->xsave, xstate_size))
+		return -1;
 
 	clear_used_math(); /* trigger finit */
 
@@ -229,62 +215,24 @@ int save_i387_xstate(void __user *buf)
 }
 
 /*
- * Restore the extended state if present. Otherwise, restore the FP/SSE
- * state.
- */
-static int restore_user_xstate(void __user *buf)
-{
-	struct _fpx_sw_bytes fx_sw_user;
-	u64 mask;
-	int err;
-
-	if (((unsigned long)buf % 64) ||
-	     check_for_xstate(buf, buf, &fx_sw_user))
-		goto fx_only;
-
-	mask = fx_sw_user.xstate_bv;
-
-	/*
-	 * restore the state passed by the user.
-	 */
-	err = xrstor_checking((__force struct xsave_struct *)buf, mask);
-	if (err)
-		return err;
-
-	/*
-	 * init the state skipped by the user.
-	 */
-	mask = pcntxt_mask & ~mask;
-	if (unlikely(mask))
-		xrstor_state(init_xstate_buf, mask);
-
-	return 0;
-
-fx_only:
-	/*
-	 * couldn't find the extended state information in the
-	 * memory layout. Restore just the FP/SSE and init all
-	 * the other extended state.
-	 */
-	xrstor_state(init_xstate_buf, pcntxt_mask & ~XSTATE_FPSSE);
-	return fxrstor_checking((__force struct i387_fxsave_struct *)buf);
-}
-
-/*
  * This restores directly out of user space. Exceptions are handled.
  */
 int restore_i387_xstate(void __user *buf)
 {
+	struct _fpx_sw_bytes fx_sw_user;
 	struct task_struct *tsk = current;
 	int err = 0;
 
 	if (!buf) {
-		if (used_math())
-			goto clear;
+		if (used_math()) {
+			clear_fpu(tsk);
+			clear_used_math();
+		}
 		return 0;
-	} else
-		if (!access_ok(VERIFY_READ, buf, sig_xstate_size))
-			return -EACCES;
+	}
+
+	if (!access_ok(VERIFY_READ, buf, sig_xstate_size))
+		return -EACCES;
 
 	if (!used_math()) {
 		err = init_fpu(tsk);
@@ -292,25 +240,21 @@ int restore_i387_xstate(void __user *buf)
 			return err;
 	}
 
-	if (!(task_thread_info(current)->status & TS_USEDFPU)) {
-		clts();
-		task_thread_info(current)->status |= TS_USEDFPU;
-	}
-	if (use_xsave())
-		err = restore_user_xstate(buf);
-	else
-		err = fxrstor_checking((__force struct i387_fxsave_struct *)
-				       buf);
-	if (unlikely(err)) {
-		/*
-		 * Encountered an error while doing the restore from the
-		 * user buffer, clear the fpu state.
-		 */
-clear:
-		clear_fpu(tsk);
-		clear_used_math();
-	}
-	return err;
+	if (__copy_from_user(&tsk->thread.fpu.state->xsave, buf, xstate_size))
+		return -1;
+
+	/*
+	 * Restore only states specified by the user. If there is anything wrong
+	 * with the xstate, restore only FP/SSE. XRSTOR will initialize all
+	 * other states.
+	 */
+	if (!check_for_xstate(buf, buf, &fx_sw_user))
+		tsk->thread.fpu.state->xsave.xsave_hdr.xstate_bv &= fx_sw_user.xstate_bv;
+	else if (use_xsave())
+		tsk->thread.fpu.state->xsave.xsave_hdr.xstate_bv = XSTATE_FPSSE;
+
+	restore_xstates(tsk, XCNTXT_LAZY);
+	return 0;
 }
 #endif
 
@@ -473,3 +417,65 @@ void __cpuinit xsave_init(void)
 	next_func = xstate_enable;
 	this_func();
 }
+
+void xsave(struct xsave_struct *x, u64 mask)
+{
+	clts();
+
+	if (use_xsave())
+		xsave_state(x, mask);
+	else if (mask & XCNTXT_LAZY)
+		fpu_save(&x->i387);
+
+	if (mask & XCNTXT_LAZY)
+		fpu_clean(&x->i387);
+
+	stts();
+}
+
+void save_xstates(struct task_struct *tsk)
+{
+	struct thread_info *ti = task_thread_info(tsk);
+
+	if (!fpu_allocated(&tsk->thread.fpu))
+		return;
+
+	xsave(&tsk->thread.fpu.state->xsave, ti->xstate_mask);
+
+	if (!(ti->xstate_mask & XCNTXT_LAZY))
+		tsk->fpu_counter = 0;
+
+	if (tsk->fpu_counter < 5)
+		ti->xstate_mask &= ~XCNTXT_LAZY;
+
+	ti->status &= ~TS_USEDFPU;
+}
+
+int xrstor(struct xsave_struct *x, u64 mask)
+{
+	clts();
+
+	if (use_xsave())
+		return xrstor_checking(x, mask);
+	else if (mask & XCNTXT_LAZY)
+		return fpu_restore(&x->i387);
+
+	return 0;
+}
+
+void restore_xstates(struct task_struct *tsk, u64 mask)
+{
+	struct thread_info *ti = task_thread_info(tsk);
+
+	if (!fpu_allocated(&tsk->thread.fpu))
+		return;
+
+	if (unlikely(xrstor(&tsk->thread.fpu.state->xsave, mask))) {
+		stts();
+		force_sig(SIGSEGV, tsk);
+	} else {
+		ti->xstate_mask |= mask;
+		ti->status |= TS_USEDFPU;
+		tsk->fpu_counter++;
+	}
+}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cdac9e5..771044d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -57,6 +57,7 @@
 #include <asm/xcr.h>
 #include <asm/pvclock.h>
 #include <asm/div64.h>
+#include <asm/xsave.h>
 
 #define MAX_IO_MSRS 256
 #define CR0_RESERVED_BITS						\
@@ -5712,8 +5713,8 @@ void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 	 */
 	kvm_put_guest_xcr0(vcpu);
 	vcpu->guest_fpu_loaded = 1;
-	unlazy_fpu(current);
-	fpu_restore_checking(&vcpu->arch.guest_fpu);
+	save_xstates(current);
+	xrstor(&vcpu->arch.guest_fpu.state->xsave, -1);
 	trace_kvm_fpu(1);
 }
 
@@ -5725,7 +5726,7 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 		return;
 
 	vcpu->guest_fpu_loaded = 0;
-	fpu_save_init(&vcpu->arch.guest_fpu);
+	xsave(&vcpu->arch.guest_fpu.state->xsave, -1);
 	++vcpu->stat.fpu_reload;
 	kvm_make_request(KVM_REQ_DEACTIVATE_FPU, vcpu);
 	trace_kvm_fpu(0);
-- 
1.5.6.5



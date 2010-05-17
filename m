Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab0EQXAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 19:00:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50889 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab0EQXAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 19:00:32 -0400
Date: Tue, 18 May 2010 01:00:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/fpu changes for v2.6.35
Message-ID: <20100517230001.GA3507@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fpu-for-linus

 Thanks,

	Ingo

------------------>
Avi Kivity (2):
      x86: Eliminate TS_XSAVE
      x86: Introduce 'struct fpu' and related API

Brian Gerst (4):
      x86-32: Rework cache flush denied handler
      x86: Merge simd_math_error() into math_error()
      x86: Merge kernel_math_error() into math_error()
      x86-32: Don't set ignore_fpu_irq in simd exception

H. Peter Anvin (4):
      x86, fpu: Unbreak FPU emulation
      x86, fpu: Use the proper asm constraint in use_xsave()
      x86: Add new static_cpu_has() function using alternatives
      x86, fpu: Use static_cpu_has() to implement use_xsave()


 arch/x86/Kconfig.cpu               |    4 +
 arch/x86/include/asm/cpufeature.h  |   57 ++++++++++++
 arch/x86/include/asm/i387.h        |  129 ++++++++++++++++++++-------
 arch/x86/include/asm/processor.h   |    6 +-
 arch/x86/include/asm/thread_info.h |    1 -
 arch/x86/include/asm/traps.h       |    2 +-
 arch/x86/include/asm/xsave.h       |    7 +-
 arch/x86/kernel/cpu/common.c       |    5 +-
 arch/x86/kernel/entry_32.S         |   19 ++++
 arch/x86/kernel/i387.c             |  107 +++++++++++-----------
 arch/x86/kernel/irqinit.c          |    2 +-
 arch/x86/kernel/process.c          |   21 ++---
 arch/x86/kernel/process_32.c       |    2 +-
 arch/x86/kernel/process_64.c       |    2 +-
 arch/x86/kernel/traps.c            |  173 ++++++++++--------------------------
 arch/x86/kernel/xsave.c            |    8 +-
 arch/x86/math-emu/fpu_aux.c        |    6 +-
 arch/x86/math-emu/fpu_entry.c      |    4 +-
 arch/x86/math-emu/fpu_system.h     |    2 +-
 19 files changed, 308 insertions(+), 249 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index a198293..6f6792c 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -338,6 +338,10 @@ config X86_F00F_BUG
 	def_bool y
 	depends on M586MMX || M586TSC || M586 || M486 || M386
 
+config X86_INVD_BUG
+	def_bool y
+	depends on M486 || M386
+
 config X86_WP_WORKS_OK
 	def_bool y
 	depends on !M386
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 0cd82d0..9b11a5c 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -175,6 +175,7 @@
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
+#include <asm/asm.h>
 #include <linux/bitops.h>
 
 extern const char * const x86_cap_flags[NCAPINTS*32];
@@ -283,6 +284,62 @@ extern const char * const x86_power_flags[32];
 
 #endif /* CONFIG_X86_64 */
 
+/*
+ * Static testing of CPU features.  Used the same as boot_cpu_has().
+ * These are only valid after alternatives have run, but will statically
+ * patch the target code for additional performance.
+ *
+ */
+static __always_inline __pure bool __static_cpu_has(u8 bit)
+{
+#if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 5)
+		asm goto("1: jmp %l[t_no]\n"
+			 "2:\n"
+			 ".section .altinstructions,\"a\"\n"
+			 _ASM_ALIGN "\n"
+			 _ASM_PTR "1b\n"
+			 _ASM_PTR "0\n" 	/* no replacement */
+			 " .byte %P0\n"		/* feature bit */
+			 " .byte 2b - 1b\n"	/* source len */
+			 " .byte 0\n"		/* replacement len */
+			 " .byte 0xff + 0 - (2b-1b)\n"	/* padding */
+			 ".previous\n"
+			 : : "i" (bit) : : t_no);
+		return true;
+	t_no:
+		return false;
+#else
+		u8 flag;
+		/* Open-coded due to __stringify() in ALTERNATIVE() */
+		asm volatile("1: movb $0,%0\n"
+			     "2:\n"
+			     ".section .altinstructions,\"a\"\n"
+			     _ASM_ALIGN "\n"
+			     _ASM_PTR "1b\n"
+			     _ASM_PTR "3f\n"
+			     " .byte %P1\n"		/* feature bit */
+			     " .byte 2b - 1b\n"		/* source len */
+			     " .byte 4f - 3f\n"		/* replacement len */
+			     " .byte 0xff + (4f-3f) - (2b-1b)\n" /* padding */
+			     ".previous\n"
+			     ".section .altinstr_replacement,\"ax\"\n"
+			     "3: movb $1,%0\n"
+			     "4:\n"
+			     ".previous\n"
+			     : "=qm" (flag) : "i" (bit));
+		return flag;
+#endif
+}
+
+#define static_cpu_has(bit)					\
+(								\
+	__builtin_constant_p(boot_cpu_has(bit)) ?		\
+		boot_cpu_has(bit) :				\
+	(__builtin_constant_p(bit) && !((bit) & ~0xff)) ?	\
+		__static_cpu_has(bit) :				\
+		boot_cpu_has(bit)				\
+)
+
 #endif /* defined(__KERNEL__) && !defined(__ASSEMBLY__) */
 
 #endif /* _ASM_X86_CPUFEATURE_H */
diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index da29309..c991b3a 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -16,7 +16,9 @@
 #include <linux/kernel_stat.h>
 #include <linux/regset.h>
 #include <linux/hardirq.h>
+#include <linux/slab.h>
 #include <asm/asm.h>
+#include <asm/cpufeature.h>
 #include <asm/processor.h>
 #include <asm/sigcontext.h>
 #include <asm/user.h>
@@ -56,6 +58,11 @@ extern int restore_i387_xstate_ia32(void __user *buf);
 
 #define X87_FSW_ES (1 << 7)	/* Exception Summary */
 
+static __always_inline __pure bool use_xsave(void)
+{
+	return static_cpu_has(X86_FEATURE_XSAVE);
+}
+
 #ifdef CONFIG_X86_64
 
 /* Ignore delayed exceptions from user space */
@@ -91,15 +98,15 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
    values. The kernel data segment can be sometimes 0 and sometimes
    new user value. Both should be ok.
    Use the PDA as safe address because it should be already in L1. */
-static inline void clear_fpu_state(struct task_struct *tsk)
+static inline void fpu_clear(struct fpu *fpu)
 {
-	struct xsave_struct *xstate = &tsk->thread.xstate->xsave;
-	struct i387_fxsave_struct *fx = &tsk->thread.xstate->fxsave;
+	struct xsave_struct *xstate = &fpu->state->xsave;
+	struct i387_fxsave_struct *fx = &fpu->state->fxsave;
 
 	/*
 	 * xsave header may indicate the init state of the FP.
 	 */
-	if ((task_thread_info(tsk)->status & TS_XSAVE) &&
+	if (use_xsave() &&
 	    !(xstate->xsave_hdr.xstate_bv & XSTATE_FP))
 		return;
 
@@ -111,6 +118,11 @@ static inline void clear_fpu_state(struct task_struct *tsk)
 			  X86_FEATURE_FXSAVE_LEAK);
 }
 
+static inline void clear_fpu_state(struct task_struct *tsk)
+{
+	fpu_clear(&tsk->thread.fpu);
+}
+
 static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
 {
 	int err;
@@ -135,7 +147,7 @@ static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
 	return err;
 }
 
-static inline void fxsave(struct task_struct *tsk)
+static inline void fpu_fxsave(struct fpu *fpu)
 {
 	/* Using "rex64; fxsave %0" is broken because, if the memory operand
 	   uses any extended registers for addressing, a second REX prefix
@@ -145,42 +157,45 @@ static inline void fxsave(struct task_struct *tsk)
 	/* Using "fxsaveq %0" would be the ideal choice, but is only supported
 	   starting with gas 2.16. */
 	__asm__ __volatile__("fxsaveq %0"
-			     : "=m" (tsk->thread.xstate->fxsave));
+			     : "=m" (fpu->state->fxsave));
 #elif 0
 	/* Using, as a workaround, the properly prefixed form below isn't
 	   accepted by any binutils version so far released, complaining that
 	   the same type of prefix is used twice if an extended register is
 	   needed for addressing (fix submitted to mainline 2005-11-21). */
 	__asm__ __volatile__("rex64/fxsave %0"
-			     : "=m" (tsk->thread.xstate->fxsave));
+			     : "=m" (fpu->state->fxsave));
 #else
 	/* This, however, we can work around by forcing the compiler to select
 	   an addressing mode that doesn't require extended registers. */
 	__asm__ __volatile__("rex64/fxsave (%1)"
-			     : "=m" (tsk->thread.xstate->fxsave)
-			     : "cdaSDb" (&tsk->thread.xstate->fxsave));
+			     : "=m" (fpu->state->fxsave)
+			     : "cdaSDb" (&fpu->state->fxsave));
 #endif
 }
 
-static inline void __save_init_fpu(struct task_struct *tsk)
+static inline void fpu_save_init(struct fpu *fpu)
 {
-	if (task_thread_info(tsk)->status & TS_XSAVE)
-		xsave(tsk);
+	if (use_xsave())
+		fpu_xsave(fpu);
 	else
-		fxsave(tsk);
+		fpu_fxsave(fpu);
+
+	fpu_clear(fpu);
+}
 
-	clear_fpu_state(tsk);
+static inline void __save_init_fpu(struct task_struct *tsk)
+{
+	fpu_save_init(&tsk->thread.fpu);
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
 #else  /* CONFIG_X86_32 */
 
 #ifdef CONFIG_MATH_EMULATION
-extern void finit_task(struct task_struct *tsk);
+extern void finit_soft_fpu(struct i387_soft_struct *soft);
 #else
-static inline void finit_task(struct task_struct *tsk)
-{
-}
+static inline void finit_soft_fpu(struct i387_soft_struct *soft) {}
 #endif
 
 static inline void tolerant_fwait(void)
@@ -216,13 +231,13 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 /*
  * These must be called with preempt disabled
  */
-static inline void __save_init_fpu(struct task_struct *tsk)
+static inline void fpu_save_init(struct fpu *fpu)
 {
-	if (task_thread_info(tsk)->status & TS_XSAVE) {
-		struct xsave_struct *xstate = &tsk->thread.xstate->xsave;
-		struct i387_fxsave_struct *fx = &tsk->thread.xstate->fxsave;
+	if (use_xsave()) {
+		struct xsave_struct *xstate = &fpu->state->xsave;
+		struct i387_fxsave_struct *fx = &fpu->state->fxsave;
 
-		xsave(tsk);
+		fpu_xsave(fpu);
 
 		/*
 		 * xsave header may indicate the init state of the FP.
@@ -246,8 +261,8 @@ static inline void __save_init_fpu(struct task_struct *tsk)
 		"fxsave %[fx]\n"
 		"bt $7,%[fsw] ; jnc 1f ; fnclex\n1:",
 		X86_FEATURE_FXSR,
-		[fx] "m" (tsk->thread.xstate->fxsave),
-		[fsw] "m" (tsk->thread.xstate->fxsave.swd) : "memory");
+		[fx] "m" (fpu->state->fxsave),
+		[fsw] "m" (fpu->state->fxsave.swd) : "memory");
 clear_state:
 	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
 	   is pending.  Clear the x87 state here by setting it to fixed
@@ -259,17 +274,34 @@ clear_state:
 		X86_FEATURE_FXSAVE_LEAK,
 		[addr] "m" (safe_address));
 end:
+	;
+}
+
+static inline void __save_init_fpu(struct task_struct *tsk)
+{
+	fpu_save_init(&tsk->thread.fpu);
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
+
 #endif	/* CONFIG_X86_64 */
 
-static inline int restore_fpu_checking(struct task_struct *tsk)
+static inline int fpu_fxrstor_checking(struct fpu *fpu)
 {
-	if (task_thread_info(tsk)->status & TS_XSAVE)
-		return xrstor_checking(&tsk->thread.xstate->xsave);
+	return fxrstor_checking(&fpu->state->fxsave);
+}
+
+static inline int fpu_restore_checking(struct fpu *fpu)
+{
+	if (use_xsave())
+		return fpu_xrstor_checking(fpu);
 	else
-		return fxrstor_checking(&tsk->thread.xstate->fxsave);
+		return fpu_fxrstor_checking(fpu);
+}
+
+static inline int restore_fpu_checking(struct task_struct *tsk)
+{
+	return fpu_restore_checking(&tsk->thread.fpu);
 }
 
 /*
@@ -397,30 +429,59 @@ static inline void clear_fpu(struct task_struct *tsk)
 static inline unsigned short get_fpu_cwd(struct task_struct *tsk)
 {
 	if (cpu_has_fxsr) {
-		return tsk->thread.xstate->fxsave.cwd;
+		return tsk->thread.fpu.state->fxsave.cwd;
 	} else {
-		return (unsigned short)tsk->thread.xstate->fsave.cwd;
+		return (unsigned short)tsk->thread.fpu.state->fsave.cwd;
 	}
 }
 
 static inline unsigned short get_fpu_swd(struct task_struct *tsk)
 {
 	if (cpu_has_fxsr) {
-		return tsk->thread.xstate->fxsave.swd;
+		return tsk->thread.fpu.state->fxsave.swd;
 	} else {
-		return (unsigned short)tsk->thread.xstate->fsave.swd;
+		return (unsigned short)tsk->thread.fpu.state->fsave.swd;
 	}
 }
 
 static inline unsigned short get_fpu_mxcsr(struct task_struct *tsk)
 {
 	if (cpu_has_xmm) {
-		return tsk->thread.xstate->fxsave.mxcsr;
+		return tsk->thread.fpu.state->fxsave.mxcsr;
 	} else {
 		return MXCSR_DEFAULT;
 	}
 }
 
+static bool fpu_allocated(struct fpu *fpu)
+{
+	return fpu->state != NULL;
+}
+
+static inline int fpu_alloc(struct fpu *fpu)
+{
+	if (fpu_allocated(fpu))
+		return 0;
+	fpu->state = kmem_cache_alloc(task_xstate_cachep, GFP_KERNEL);
+	if (!fpu->state)
+		return -ENOMEM;
+	WARN_ON((unsigned long)fpu->state & 15);
+	return 0;
+}
+
+static inline void fpu_free(struct fpu *fpu)
+{
+	if (fpu->state) {
+		kmem_cache_free(task_xstate_cachep, fpu->state);
+		fpu->state = NULL;
+	}
+}
+
+static inline void fpu_copy(struct fpu *dst, struct fpu *src)
+{
+	memcpy(dst->state, src->state, xstate_size);
+}
+
 #endif /* __ASSEMBLY__ */
 
 #define PSHUFB_XMM5_XMM0 .byte 0x66, 0x0f, 0x38, 0x00, 0xc5
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index b753ea5..b684f58 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -380,6 +380,10 @@ union thread_xstate {
 	struct xsave_struct		xsave;
 };
 
+struct fpu {
+	union thread_xstate *state;
+};
+
 #ifdef CONFIG_X86_64
 DECLARE_PER_CPU(struct orig_ist, orig_ist);
 
@@ -457,7 +461,7 @@ struct thread_struct {
 	unsigned long		trap_no;
 	unsigned long		error_code;
 	/* floating point and extended processor state */
-	union thread_xstate	*xstate;
+	struct fpu		fpu;
 #ifdef CONFIG_X86_32
 	/* Virtual 86 mode info */
 	struct vm86_struct __user *vm86_info;
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index e0d2890..e9e3415 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -244,7 +244,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TS_POLLING		0x0004	/* true if in idle loop
 					   and not sleeping */
 #define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal() */
-#define TS_XSAVE		0x0010	/* Use xsave/xrstor */
 
 #define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
 
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 4da91ad..f66cda5 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -79,7 +79,7 @@ static inline int get_si_code(unsigned long condition)
 
 extern int panic_on_unrecovered_nmi;
 
-void math_error(void __user *);
+void math_error(struct pt_regs *, int, int);
 void math_emulate(struct math_emu_info *);
 #ifndef CONFIG_X86_32
 asmlinkage void smp_thermal_interrupt(void);
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index ddc04cc..2c4390c 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -37,8 +37,9 @@ extern int check_for_xstate(struct i387_fxsave_struct __user *buf,
 			    void __user *fpstate,
 			    struct _fpx_sw_bytes *sw);
 
-static inline int xrstor_checking(struct xsave_struct *fx)
+static inline int fpu_xrstor_checking(struct fpu *fpu)
 {
+	struct xsave_struct *fx = &fpu->state->xsave;
 	int err;
 
 	asm volatile("1: .byte " REX_PREFIX "0x0f,0xae,0x2f\n\t"
@@ -110,12 +111,12 @@ static inline void xrstor_state(struct xsave_struct *fx, u64 mask)
 		     :   "memory");
 }
 
-static inline void xsave(struct task_struct *tsk)
+static inline void fpu_xsave(struct fpu *fpu)
 {
 	/* This, however, we can work around by forcing the compiler to select
 	   an addressing mode that doesn't require extended registers. */
 	__asm__ __volatile__(".byte " REX_PREFIX "0x0f,0xae,0x27"
-			     : : "D" (&(tsk->thread.xstate->xsave)),
+			     : : "D" (&(fpu->state->xsave)),
 				 "a" (-1), "d"(-1) : "memory");
 }
 #endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4868e4a..c1c00d0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1243,10 +1243,7 @@ void __cpuinit cpu_init(void)
 	/*
 	 * Force FPU initialization:
 	 */
-	if (cpu_has_xsave)
-		current_thread_info()->status = TS_XSAVE;
-	else
-		current_thread_info()->status = 0;
+	current_thread_info()->status = 0;
 	clear_used_math();
 	mxcsr_feature_mask_init();
 
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 44a8e0d..cd49141 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -53,6 +53,7 @@
 #include <asm/processor-flags.h>
 #include <asm/ftrace.h>
 #include <asm/irq_vectors.h>
+#include <asm/cpufeature.h>
 
 /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
 #include <linux/elf-em.h>
@@ -905,7 +906,25 @@ ENTRY(simd_coprocessor_error)
 	RING0_INT_FRAME
 	pushl $0
 	CFI_ADJUST_CFA_OFFSET 4
+#ifdef CONFIG_X86_INVD_BUG
+	/* AMD 486 bug: invd from userspace calls exception 19 instead of #GP */
+661:	pushl $do_general_protection
+662:
+.section .altinstructions,"a"
+	.balign 4
+	.long 661b
+	.long 663f
+	.byte X86_FEATURE_XMM
+	.byte 662b-661b
+	.byte 664f-663f
+.previous
+.section .altinstr_replacement,"ax"
+663:	pushl $do_simd_coprocessor_error
+664:
+.previous
+#else
 	pushl $do_simd_coprocessor_error
+#endif
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 54c31c2..86cef6b 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -102,65 +102,62 @@ void __cpuinit fpu_init(void)
 
 	mxcsr_feature_mask_init();
 	/* clean state in init */
-	if (cpu_has_xsave)
-		current_thread_info()->status = TS_XSAVE;
-	else
-		current_thread_info()->status = 0;
+	current_thread_info()->status = 0;
 	clear_used_math();
 }
 #endif	/* CONFIG_X86_64 */
 
-/*
- * The _current_ task is using the FPU for the first time
- * so initialize it and set the mxcsr to its default
- * value at reset if we support XMM instructions and then
- * remeber the current task has used the FPU.
- */
-int init_fpu(struct task_struct *tsk)
+static void fpu_finit(struct fpu *fpu)
 {
-	if (tsk_used_math(tsk)) {
-		if (HAVE_HWFP && tsk == current)
-			unlazy_fpu(tsk);
-		return 0;
-	}
-
-	/*
-	 * Memory allocation at the first usage of the FPU and other state.
-	 */
-	if (!tsk->thread.xstate) {
-		tsk->thread.xstate = kmem_cache_alloc(task_xstate_cachep,
-						      GFP_KERNEL);
-		if (!tsk->thread.xstate)
-			return -ENOMEM;
-	}
-
 #ifdef CONFIG_X86_32
 	if (!HAVE_HWFP) {
-		memset(tsk->thread.xstate, 0, xstate_size);
-		finit_task(tsk);
-		set_stopped_child_used_math(tsk);
-		return 0;
+		finit_soft_fpu(&fpu->state->soft);
+		return;
 	}
 #endif
 
 	if (cpu_has_fxsr) {
-		struct i387_fxsave_struct *fx = &tsk->thread.xstate->fxsave;
+		struct i387_fxsave_struct *fx = &fpu->state->fxsave;
 
 		memset(fx, 0, xstate_size);
 		fx->cwd = 0x37f;
 		if (cpu_has_xmm)
 			fx->mxcsr = MXCSR_DEFAULT;
 	} else {
-		struct i387_fsave_struct *fp = &tsk->thread.xstate->fsave;
+		struct i387_fsave_struct *fp = &fpu->state->fsave;
 		memset(fp, 0, xstate_size);
 		fp->cwd = 0xffff037fu;
 		fp->swd = 0xffff0000u;
 		fp->twd = 0xffffffffu;
 		fp->fos = 0xffff0000u;
 	}
+}
+
+/*
+ * The _current_ task is using the FPU for the first time
+ * so initialize it and set the mxcsr to its default
+ * value at reset if we support XMM instructions and then
+ * remeber the current task has used the FPU.
+ */
+int init_fpu(struct task_struct *tsk)
+{
+	int ret;
+
+	if (tsk_used_math(tsk)) {
+		if (HAVE_HWFP && tsk == current)
+			unlazy_fpu(tsk);
+		return 0;
+	}
+
 	/*
-	 * Only the device not available exception or ptrace can call init_fpu.
+	 * Memory allocation at the first usage of the FPU and other state.
 	 */
+	ret = fpu_alloc(&tsk->thread.fpu);
+	if (ret)
+		return ret;
+
+	fpu_finit(&tsk->thread.fpu);
+
 	set_stopped_child_used_math(tsk);
 	return 0;
 }
@@ -194,7 +191,7 @@ int xfpregs_get(struct task_struct *target, const struct user_regset *regset,
 		return ret;
 
 	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
-				   &target->thread.xstate->fxsave, 0, -1);
+				   &target->thread.fpu.state->fxsave, 0, -1);
 }
 
 int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
@@ -211,19 +208,19 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 		return ret;
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-				 &target->thread.xstate->fxsave, 0, -1);
+				 &target->thread.fpu.state->fxsave, 0, -1);
 
 	/*
 	 * mxcsr reserved bits must be masked to zero for security reasons.
 	 */
-	target->thread.xstate->fxsave.mxcsr &= mxcsr_feature_mask;
+	target->thread.fpu.state->fxsave.mxcsr &= mxcsr_feature_mask;
 
 	/*
 	 * update the header bits in the xsave header, indicating the
 	 * presence of FP and SSE state.
 	 */
 	if (cpu_has_xsave)
-		target->thread.xstate->xsave.xsave_hdr.xstate_bv |= XSTATE_FPSSE;
+		target->thread.fpu.state->xsave.xsave_hdr.xstate_bv |= XSTATE_FPSSE;
 
 	return ret;
 }
@@ -246,14 +243,14 @@ int xstateregs_get(struct task_struct *target, const struct user_regset *regset,
 	 * memory layout in the thread struct, so that we can copy the entire
 	 * xstateregs to the user using one user_regset_copyout().
 	 */
-	memcpy(&target->thread.xstate->fxsave.sw_reserved,
+	memcpy(&target->thread.fpu.state->fxsave.sw_reserved,
 	       xstate_fx_sw_bytes, sizeof(xstate_fx_sw_bytes));
 
 	/*
 	 * Copy the xstate memory layout.
 	 */
 	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
-				  &target->thread.xstate->xsave, 0, -1);
+				  &target->thread.fpu.state->xsave, 0, -1);
 	return ret;
 }
 
@@ -272,14 +269,14 @@ int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
 		return ret;
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-				 &target->thread.xstate->xsave, 0, -1);
+				 &target->thread.fpu.state->xsave, 0, -1);
 
 	/*
 	 * mxcsr reserved bits must be masked to zero for security reasons.
 	 */
-	target->thread.xstate->fxsave.mxcsr &= mxcsr_feature_mask;
+	target->thread.fpu.state->fxsave.mxcsr &= mxcsr_feature_mask;
 
-	xsave_hdr = &target->thread.xstate->xsave.xsave_hdr;
+	xsave_hdr = &target->thread.fpu.state->xsave.xsave_hdr;
 
 	xsave_hdr->xstate_bv &= pcntxt_mask;
 	/*
@@ -365,7 +362,7 @@ static inline u32 twd_fxsr_to_i387(struct i387_fxsave_struct *fxsave)
 static void
 convert_from_fxsr(struct user_i387_ia32_struct *env, struct task_struct *tsk)
 {
-	struct i387_fxsave_struct *fxsave = &tsk->thread.xstate->fxsave;
+	struct i387_fxsave_struct *fxsave = &tsk->thread.fpu.state->fxsave;
 	struct _fpreg *to = (struct _fpreg *) &env->st_space[0];
 	struct _fpxreg *from = (struct _fpxreg *) &fxsave->st_space[0];
 	int i;
@@ -405,7 +402,7 @@ static void convert_to_fxsr(struct task_struct *tsk,
 			    const struct user_i387_ia32_struct *env)
 
 {
-	struct i387_fxsave_struct *fxsave = &tsk->thread.xstate->fxsave;
+	struct i387_fxsave_struct *fxsave = &tsk->thread.fpu.state->fxsave;
 	struct _fpreg *from = (struct _fpreg *) &env->st_space[0];
 	struct _fpxreg *to = (struct _fpxreg *) &fxsave->st_space[0];
 	int i;
@@ -445,7 +442,7 @@ int fpregs_get(struct task_struct *target, const struct user_regset *regset,
 
 	if (!cpu_has_fxsr) {
 		return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
-					   &target->thread.xstate->fsave, 0,
+					   &target->thread.fpu.state->fsave, 0,
 					   -1);
 	}
 
@@ -475,7 +472,7 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 
 	if (!cpu_has_fxsr) {
 		return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-					  &target->thread.xstate->fsave, 0, -1);
+					  &target->thread.fpu.state->fsave, 0, -1);
 	}
 
 	if (pos > 0 || count < sizeof(env))
@@ -490,7 +487,7 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 	 * presence of FP.
 	 */
 	if (cpu_has_xsave)
-		target->thread.xstate->xsave.xsave_hdr.xstate_bv |= XSTATE_FP;
+		target->thread.fpu.state->xsave.xsave_hdr.xstate_bv |= XSTATE_FP;
 	return ret;
 }
 
@@ -501,7 +498,7 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 static inline int save_i387_fsave(struct _fpstate_ia32 __user *buf)
 {
 	struct task_struct *tsk = current;
-	struct i387_fsave_struct *fp = &tsk->thread.xstate->fsave;
+	struct i387_fsave_struct *fp = &tsk->thread.fpu.state->fsave;
 
 	fp->status = fp->swd;
 	if (__copy_to_user(buf, fp, sizeof(struct i387_fsave_struct)))
@@ -512,7 +509,7 @@ static inline int save_i387_fsave(struct _fpstate_ia32 __user *buf)
 static int save_i387_fxsave(struct _fpstate_ia32 __user *buf)
 {
 	struct task_struct *tsk = current;
-	struct i387_fxsave_struct *fx = &tsk->thread.xstate->fxsave;
+	struct i387_fxsave_struct *fx = &tsk->thread.fpu.state->fxsave;
 	struct user_i387_ia32_struct env;
 	int err = 0;
 
@@ -547,7 +544,7 @@ static int save_i387_xsave(void __user *buf)
 	 * header as well as change any contents in the memory layout.
 	 * xrestore as part of sigreturn will capture all the changes.
 	 */
-	tsk->thread.xstate->xsave.xsave_hdr.xstate_bv |= XSTATE_FPSSE;
+	tsk->thread.fpu.state->xsave.xsave_hdr.xstate_bv |= XSTATE_FPSSE;
 
 	if (save_i387_fxsave(fx) < 0)
 		return -1;
@@ -599,7 +596,7 @@ static inline int restore_i387_fsave(struct _fpstate_ia32 __user *buf)
 {
 	struct task_struct *tsk = current;
 
-	return __copy_from_user(&tsk->thread.xstate->fsave, buf,
+	return __copy_from_user(&tsk->thread.fpu.state->fsave, buf,
 				sizeof(struct i387_fsave_struct));
 }
 
@@ -610,10 +607,10 @@ static int restore_i387_fxsave(struct _fpstate_ia32 __user *buf,
 	struct user_i387_ia32_struct env;
 	int err;
 
-	err = __copy_from_user(&tsk->thread.xstate->fxsave, &buf->_fxsr_env[0],
+	err = __copy_from_user(&tsk->thread.fpu.state->fxsave, &buf->_fxsr_env[0],
 			       size);
 	/* mxcsr reserved bits must be masked to zero for security reasons */
-	tsk->thread.xstate->fxsave.mxcsr &= mxcsr_feature_mask;
+	tsk->thread.fpu.state->fxsave.mxcsr &= mxcsr_feature_mask;
 	if (err || __copy_from_user(&env, buf, sizeof(env)))
 		return 1;
 	convert_to_fxsr(tsk, &env);
@@ -629,7 +626,7 @@ static int restore_i387_xsave(void __user *buf)
 	struct i387_fxsave_struct __user *fx =
 		(struct i387_fxsave_struct __user *) &fx_user->_fxsr_env[0];
 	struct xsave_hdr_struct *xsave_hdr =
-				&current->thread.xstate->xsave.xsave_hdr;
+				&current->thread.fpu.state->xsave.xsave_hdr;
 	u64 mask;
 	int err;
 
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 0ed2d30..990ae7c 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -60,7 +60,7 @@ static irqreturn_t math_error_irq(int cpl, void *dev_id)
 	outb(0, 0xF0);
 	if (ignore_fpu_irq || !boot_cpu_data.hard_math)
 		return IRQ_NONE;
-	math_error((void __user *)get_irq_regs()->ip);
+	math_error(get_irq_regs(), 0, 16);
 	return IRQ_HANDLED;
 }
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 28ad9f4..f18fd9c 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -32,25 +32,22 @@ struct kmem_cache *task_xstate_cachep;
 
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
+	int ret;
+
 	*dst = *src;
-	if (src->thread.xstate) {
-		dst->thread.xstate = kmem_cache_alloc(task_xstate_cachep,
-						      GFP_KERNEL);
-		if (!dst->thread.xstate)
-			return -ENOMEM;
-		WARN_ON((unsigned long)dst->thread.xstate & 15);
-		memcpy(dst->thread.xstate, src->thread.xstate, xstate_size);
+	if (fpu_allocated(&src->thread.fpu)) {
+		memset(&dst->thread.fpu, 0, sizeof(dst->thread.fpu));
+		ret = fpu_alloc(&dst->thread.fpu);
+		if (ret)
+			return ret;
+		fpu_copy(&dst->thread.fpu, &src->thread.fpu);
 	}
 	return 0;
 }
 
 void free_thread_xstate(struct task_struct *tsk)
 {
-	if (tsk->thread.xstate) {
-		kmem_cache_free(task_xstate_cachep, tsk->thread.xstate);
-		tsk->thread.xstate = NULL;
-	}
-
+	fpu_free(&tsk->thread.fpu);
 	WARN(tsk->thread.ds_ctx, "leaking DS context\n");
 }
 
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index f6c6266..0a7a4f5 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -317,7 +317,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 
 	/* we're going to use this soon, after a few expensive things */
 	if (preload_fpu)
-		prefetch(next->xstate);
+		prefetch(next->fpu.state);
 
 	/*
 	 * Reload esp0.
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 17cb329..979215f 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -396,7 +396,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 
 	/* we're going to use this soon, after a few expensive things */
 	if (preload_fpu)
-		prefetch(next->xstate);
+		prefetch(next->fpu.state);
 
 	/*
 	 * Reload esp0, LDT and the page table pointer:
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 1168e44..00516e1 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -108,15 +108,6 @@ static inline void preempt_conditional_cli(struct pt_regs *regs)
 	dec_preempt_count();
 }
 
-#ifdef CONFIG_X86_32
-static inline void
-die_if_kernel(const char *str, struct pt_regs *regs, long err)
-{
-	if (!user_mode_vm(regs))
-		die(str, regs, err);
-}
-#endif
-
 static void __kprobes
 do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 	long error_code, siginfo_t *info)
@@ -585,55 +576,67 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	return;
 }
 
-#ifdef CONFIG_X86_64
-static int kernel_math_error(struct pt_regs *regs, const char *str, int trapnr)
-{
-	if (fixup_exception(regs))
-		return 1;
-
-	notify_die(DIE_GPF, str, regs, 0, trapnr, SIGFPE);
-	/* Illegal floating point operation in the kernel */
-	current->thread.trap_no = trapnr;
-	die(str, regs, 0);
-	return 0;
-}
-#endif
-
 /*
  * Note that we play around with the 'TS' bit in an attempt to get
  * the correct behaviour even in the presence of the asynchronous
  * IRQ13 behaviour
  */
-void math_error(void __user *ip)
+void math_error(struct pt_regs *regs, int error_code, int trapnr)
 {
-	struct task_struct *task;
+	struct task_struct *task = current;
 	siginfo_t info;
-	unsigned short cwd, swd, err;
+	unsigned short err;
+	char *str = (trapnr == 16) ? "fpu exception" : "simd exception";
+
+	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, SIGFPE) == NOTIFY_STOP)
+		return;
+	conditional_sti(regs);
+
+	if (!user_mode_vm(regs))
+	{
+		if (!fixup_exception(regs)) {
+			task->thread.error_code = error_code;
+			task->thread.trap_no = trapnr;
+			die(str, regs, error_code);
+		}
+		return;
+	}
 
 	/*
 	 * Save the info for the exception handler and clear the error.
 	 */
-	task = current;
 	save_init_fpu(task);
-	task->thread.trap_no = 16;
-	task->thread.error_code = 0;
+	task->thread.trap_no = trapnr;
+	task->thread.error_code = error_code;
 	info.si_signo = SIGFPE;
 	info.si_errno = 0;
-	info.si_addr = ip;
-	/*
-	 * (~cwd & swd) will mask out exceptions that are not set to unmasked
-	 * status.  0x3f is the exception bits in these regs, 0x200 is the
-	 * C1 reg you need in case of a stack fault, 0x040 is the stack
-	 * fault bit.  We should only be taking one exception at a time,
-	 * so if this combination doesn't produce any single exception,
-	 * then we have a bad program that isn't synchronizing its FPU usage
-	 * and it will suffer the consequences since we won't be able to
-	 * fully reproduce the context of the exception
-	 */
-	cwd = get_fpu_cwd(task);
-	swd = get_fpu_swd(task);
+	info.si_addr = (void __user *)regs->ip;
+	if (trapnr == 16) {
+		unsigned short cwd, swd;
+		/*
+		 * (~cwd & swd) will mask out exceptions that are not set to unmasked
+		 * status.  0x3f is the exception bits in these regs, 0x200 is the
+		 * C1 reg you need in case of a stack fault, 0x040 is the stack
+		 * fault bit.  We should only be taking one exception at a time,
+		 * so if this combination doesn't produce any single exception,
+		 * then we have a bad program that isn't synchronizing its FPU usage
+		 * and it will suffer the consequences since we won't be able to
+		 * fully reproduce the context of the exception
+		 */
+		cwd = get_fpu_cwd(task);
+		swd = get_fpu_swd(task);
 
-	err = swd & ~cwd;
+		err = swd & ~cwd;
+	} else {
+		/*
+		 * The SIMD FPU exceptions are handled a little differently, as there
+		 * is only a single status/control register.  Thus, to determine which
+		 * unmasked exception was caught we must mask the exception mask bits
+		 * at 0x1f80, and then use these to mask the exception bits at 0x3f.
+		 */
+		unsigned short mxcsr = get_fpu_mxcsr(task);
+		err = ~(mxcsr >> 7) & mxcsr;
+	}
 
 	if (err & 0x001) {	/* Invalid op */
 		/*
@@ -662,97 +665,17 @@ void math_error(void __user *ip)
 
 dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
 {
-	conditional_sti(regs);
-
 #ifdef CONFIG_X86_32
 	ignore_fpu_irq = 1;
-#else
-	if (!user_mode(regs) &&
-	    kernel_math_error(regs, "kernel x87 math error", 16))
-		return;
 #endif
 
-	math_error((void __user *)regs->ip);
-}
-
-static void simd_math_error(void __user *ip)
-{
-	struct task_struct *task;
-	siginfo_t info;
-	unsigned short mxcsr;
-
-	/*
-	 * Save the info for the exception handler and clear the error.
-	 */
-	task = current;
-	save_init_fpu(task);
-	task->thread.trap_no = 19;
-	task->thread.error_code = 0;
-	info.si_signo = SIGFPE;
-	info.si_errno = 0;
-	info.si_code = __SI_FAULT;
-	info.si_addr = ip;
-	/*
-	 * The SIMD FPU exceptions are handled a little differently, as there
-	 * is only a single status/control register.  Thus, to determine which
-	 * unmasked exception was caught we must mask the exception mask bits
-	 * at 0x1f80, and then use these to mask the exception bits at 0x3f.
-	 */
-	mxcsr = get_fpu_mxcsr(task);
-	switch (~((mxcsr & 0x1f80) >> 7) & (mxcsr & 0x3f)) {
-	case 0x000:
-	default:
-		break;
-	case 0x001: /* Invalid Op */
-		info.si_code = FPE_FLTINV;
-		break;
-	case 0x002: /* Denormalize */
-	case 0x010: /* Underflow */
-		info.si_code = FPE_FLTUND;
-		break;
-	case 0x004: /* Zero Divide */
-		info.si_code = FPE_FLTDIV;
-		break;
-	case 0x008: /* Overflow */
-		info.si_code = FPE_FLTOVF;
-		break;
-	case 0x020: /* Precision */
-		info.si_code = FPE_FLTRES;
-		break;
-	}
-	force_sig_info(SIGFPE, &info, task);
+	math_error(regs, error_code, 16);
 }
 
 dotraplinkage void
 do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 {
-	conditional_sti(regs);
-
-#ifdef CONFIG_X86_32
-	if (cpu_has_xmm) {
-		/* Handle SIMD FPU exceptions on PIII+ processors. */
-		ignore_fpu_irq = 1;
-		simd_math_error((void __user *)regs->ip);
-		return;
-	}
-	/*
-	 * Handle strange cache flush from user space exception
-	 * in all other cases.  This is undocumented behaviour.
-	 */
-	if (regs->flags & X86_VM_MASK) {
-		handle_vm86_fault((struct kernel_vm86_regs *)regs, error_code);
-		return;
-	}
-	current->thread.trap_no = 19;
-	current->thread.error_code = error_code;
-	die_if_kernel("cache flush denied", regs, error_code);
-	force_sig(SIGSEGV, current);
-#else
-	if (!user_mode(regs) &&
-			kernel_math_error(regs, "kernel simd math error", 19))
-		return;
-	simd_math_error((void __user *)regs->ip);
-#endif
+	math_error(regs, error_code, 19);
 }
 
 dotraplinkage void
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 782c3a3..37e68fc 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -99,7 +99,7 @@ int save_i387_xstate(void __user *buf)
 		if (err)
 			return err;
 
-		if (task_thread_info(tsk)->status & TS_XSAVE)
+		if (use_xsave())
 			err = xsave_user(buf);
 		else
 			err = fxsave_user(buf);
@@ -109,14 +109,14 @@ int save_i387_xstate(void __user *buf)
 		task_thread_info(tsk)->status &= ~TS_USEDFPU;
 		stts();
 	} else {
-		if (__copy_to_user(buf, &tsk->thread.xstate->fxsave,
+		if (__copy_to_user(buf, &tsk->thread.fpu.state->fxsave,
 				   xstate_size))
 			return -1;
 	}
 
 	clear_used_math(); /* trigger finit */
 
-	if (task_thread_info(tsk)->status & TS_XSAVE) {
+	if (use_xsave()) {
 		struct _fpstate __user *fx = buf;
 		struct _xstate __user *x = buf;
 		u64 xstate_bv;
@@ -225,7 +225,7 @@ int restore_i387_xstate(void __user *buf)
 		clts();
 		task_thread_info(current)->status |= TS_USEDFPU;
 	}
-	if (task_thread_info(tsk)->status & TS_XSAVE)
+	if (use_xsave())
 		err = restore_user_xstate(buf);
 	else
 		err = fxrstor_checking((__force struct i387_fxsave_struct *)
diff --git a/arch/x86/math-emu/fpu_aux.c b/arch/x86/math-emu/fpu_aux.c
index aa09870..dc8adad 100644
--- a/arch/x86/math-emu/fpu_aux.c
+++ b/arch/x86/math-emu/fpu_aux.c
@@ -30,10 +30,10 @@ static void fclex(void)
 }
 
 /* Needs to be externally visible */
-void finit_task(struct task_struct *tsk)
+void finit_soft_fpu(struct i387_soft_struct *soft)
 {
-	struct i387_soft_struct *soft = &tsk->thread.xstate->soft;
 	struct address *oaddr, *iaddr;
+	memset(soft, 0, sizeof(*soft));
 	soft->cwd = 0x037f;
 	soft->swd = 0;
 	soft->ftop = 0;	/* We don't keep top in the status word internally. */
@@ -52,7 +52,7 @@ void finit_task(struct task_struct *tsk)
 
 void finit(void)
 {
-	finit_task(current);
+	finit_soft_fpu(&current->thread.fpu.state->soft);
 }
 
 /*
diff --git a/arch/x86/math-emu/fpu_entry.c b/arch/x86/math-emu/fpu_entry.c
index 5d87f58..7718541 100644
--- a/arch/x86/math-emu/fpu_entry.c
+++ b/arch/x86/math-emu/fpu_entry.c
@@ -681,7 +681,7 @@ int fpregs_soft_set(struct task_struct *target,
 		    unsigned int pos, unsigned int count,
 		    const void *kbuf, const void __user *ubuf)
 {
-	struct i387_soft_struct *s387 = &target->thread.xstate->soft;
+	struct i387_soft_struct *s387 = &target->thread.fpu.state->soft;
 	void *space = s387->st_space;
 	int ret;
 	int offset, other, i, tags, regnr, tag, newtop;
@@ -733,7 +733,7 @@ int fpregs_soft_get(struct task_struct *target,
 		    unsigned int pos, unsigned int count,
 		    void *kbuf, void __user *ubuf)
 {
-	struct i387_soft_struct *s387 = &target->thread.xstate->soft;
+	struct i387_soft_struct *s387 = &target->thread.fpu.state->soft;
 	const void *space = s387->st_space;
 	int ret;
 	int offset = (S387->ftop & 7) * 10, other = 80 - offset;
diff --git a/arch/x86/math-emu/fpu_system.h b/arch/x86/math-emu/fpu_system.h
index 50fa0ec..2c61441 100644
--- a/arch/x86/math-emu/fpu_system.h
+++ b/arch/x86/math-emu/fpu_system.h
@@ -31,7 +31,7 @@
 #define SEG_EXPAND_DOWN(s)	(((s).b & ((1 << 11) | (1 << 10))) \
 				 == (1 << 10))
 
-#define I387			(current->thread.xstate)
+#define I387			(current->thread.fpu.state)
 #define FPU_info		(I387->soft.info)
 
 #define FPU_CS			(*(unsigned short *) &(FPU_info->regs->cs))

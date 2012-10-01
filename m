Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab2JAN72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:59:28 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39381 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab2JAN7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:59:23 -0400
Date: Mon, 1 Oct 2012 15:59:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/fpu changes for v3.7
Message-ID: <20121001135917.GA24594@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-fpu-for-linus

   HEAD: b1a74bf8212367be2b1d6685c11a84e056eaaaf1 x86, kvm: fix kvm's usage of kernel_fpu_begin/end()

The biggest change is the addition of the non-lazy (eager) FPU 
saving support model and enabling it on CPUs with optimized 
xsaveopt/xrstor FPU state saving instructions.

There's also various Sparse fixes.

out-of-topic modifications in x86-fpu-for-linus:
------------------------------------------------
drivers/lguest/x86/core.c          # 9c6ff8b: lguest, x86: handle guest TS bit 

 Thanks,

	Ingo

------------------>
Mathias Krause (7):
      x86: Fix __user annotations in asm/sys_ia32.h
      x86/vdso: Add __user annotation to VDSO32_SYMBOL
      x86/signals: ia32_signal.c: add __user casts to fix sparse warnings
      x86/pci/probe_roms: Add missing __iomem annotation to pci_map_biosrom()
      x86/fpu/xsave: Keep __user annotation in casts
      x86/iommu: Drop duplicate const in __IOMMU_INIT
      x86/iommu: Use NULL instead of plain 0 for __IOMMU_INIT

Suresh Siddha (14):
      x86, signal: Cleanup ifdefs and is_ia32, is_x32
      x86, fpu: Consolidate inline asm routines for saving/restoring fpu state
      x86, fpu: Unify signal handling code paths for x86 and x86_64 kernels
      x86, fpu: drop_fpu() before restoring new state from sigframe
      x86, fpu: remove unnecessary user_fpu_end() in save_xstate_sig()
      x86, kvm: use kernel_fpu_begin/end() in kvm_load/put_guest_fpu()
      x86, fpu: always use kernel_fpu_begin/end() for in-kernel FPU usage
      lguest, x86: handle guest TS bit for lazy/non-lazy fpu host models
      x86, fpu: use non-lazy fpu restore for processors supporting xsave
      x86, fpu: decouple non-lazy/eager fpu restore from xsave
      x86, fpu: enable eagerfpu by default for xsaveopt
      x86, fpu: make eagerfpu= boot param tri-state
      x86, fpu: remove cpu_has_xmm check in the fx_finit()
      x86, kvm: fix kvm's usage of kernel_fpu_begin/end()


 Documentation/kernel-parameters.txt |   6 +
 arch/x86/ia32/ia32_signal.c         |  20 +-
 arch/x86/ia32/sys_ia32.c            |   2 +-
 arch/x86/include/asm/cpufeature.h   |   3 +
 arch/x86/include/asm/fpu-internal.h | 390 +++++++++++++++------------
 arch/x86/include/asm/i387.h         |  29 +-
 arch/x86/include/asm/iommu_table.h  |   6 +-
 arch/x86/include/asm/signal.h       |   4 +
 arch/x86/include/asm/sys_ia32.h     |   2 +-
 arch/x86/include/asm/vdso.h         |   3 +-
 arch/x86/include/asm/xor_32.h       |  56 +---
 arch/x86/include/asm/xor_64.h       |  61 +----
 arch/x86/include/asm/xor_avx.h      |  54 +---
 arch/x86/include/asm/xsave.h        |  13 +-
 arch/x86/kernel/cpu/bugs.c          |   7 +-
 arch/x86/kernel/cpu/common.c        |   2 -
 arch/x86/kernel/i387.c              | 292 ++------------------
 arch/x86/kernel/probe_roms.c        |   2 +-
 arch/x86/kernel/process.c           |  22 +-
 arch/x86/kernel/process_32.c        |   4 -
 arch/x86/kernel/process_64.c        |   4 -
 arch/x86/kernel/ptrace.c            |   3 -
 arch/x86/kernel/signal.c            | 211 +++++++--------
 arch/x86/kernel/traps.c             |   5 +-
 arch/x86/kernel/xsave.c             | 517 +++++++++++++++++++++++-------------
 arch/x86/kvm/vmx.c                  |  10 +-
 arch/x86/kvm/x86.c                  |   3 +-
 drivers/lguest/x86/core.c           |  10 +-
 28 files changed, 805 insertions(+), 936 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index ad7e2e5..46a6a82 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1833,6 +1833,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			and restore using xsave. The kernel will fallback to
 			enabling legacy floating-point and sse state.
 
+	eagerfpu=	[X86]
+			on	enable eager fpu restore
+			off	disable eager fpu restore
+			auto	selects the default scheme, which automatically
+				enables eagerfpu restore for xsaveopt.
+
 	nohlt		[BUGS=ARM,SH] Tells the kernel that the sleep(SH) or
 			wfi(ARM) instruction doesn't work correctly and not to
 			use it. This is also useful when using JTAG debugger.
diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 673ac9b..8c77c64 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -162,7 +162,8 @@ asmlinkage long sys32_sigaltstack(const stack_ia32_t __user *uss_ptr,
 	}
 	seg = get_fs();
 	set_fs(KERNEL_DS);
-	ret = do_sigaltstack(uss_ptr ? &uss : NULL, &uoss, regs->sp);
+	ret = do_sigaltstack((stack_t __force __user *) (uss_ptr ? &uss : NULL),
+			     (stack_t __force __user *) &uoss, regs->sp);
 	set_fs(seg);
 	if (ret >= 0 && uoss_ptr)  {
 		if (!access_ok(VERIFY_WRITE, uoss_ptr, sizeof(stack_ia32_t)))
@@ -250,7 +251,7 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 
 		get_user_ex(tmp, &sc->fpstate);
 		buf = compat_ptr(tmp);
-		err |= restore_i387_xstate_ia32(buf);
+		err |= restore_xstate_sig(buf, 1);
 
 		get_user_ex(*pax, &sc->ax);
 	} get_user_catch(err);
@@ -361,7 +362,7 @@ static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
  */
 static void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
 				 size_t frame_size,
-				 void **fpstate)
+				 void __user **fpstate)
 {
 	unsigned long sp;
 
@@ -381,9 +382,12 @@ static void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
 		sp = (unsigned long) ka->sa.sa_restorer;
 
 	if (used_math()) {
-		sp = sp - sig_xstate_ia32_size;
-		*fpstate = (struct _fpstate_ia32 *) sp;
-		if (save_i387_xstate_ia32(*fpstate) < 0)
+		unsigned long fx_aligned, math_size;
+
+		sp = alloc_mathframe(sp, 1, &fx_aligned, &math_size);
+		*fpstate = (struct _fpstate_ia32 __user *) sp;
+		if (save_xstate_sig(*fpstate, (void __user *)fx_aligned,
+				    math_size) < 0)
 			return (void __user *) -1L;
 	}
 
@@ -448,7 +452,7 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 		 * These are actually not used anymore, but left because some
 		 * gdb versions depend on them as a marker.
 		 */
-		put_user_ex(*((u64 *)&code), (u64 *)frame->retcode);
+		put_user_ex(*((u64 *)&code), (u64 __user *)frame->retcode);
 	} put_user_catch(err);
 
 	if (err)
@@ -529,7 +533,7 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		 * Not actually used anymore, but left because some gdb
 		 * versions need it.
 		 */
-		put_user_ex(*((u64 *)&code), (u64 *)frame->retcode);
+		put_user_ex(*((u64 *)&code), (u64 __user *)frame->retcode);
 	} put_user_catch(err);
 
 	if (err)
diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 4540bec..c5b938d 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -287,7 +287,7 @@ asmlinkage long sys32_sigaction(int sig, struct old_sigaction32 __user *act,
 	return ret;
 }
 
-asmlinkage long sys32_waitpid(compat_pid_t pid, unsigned int *stat_addr,
+asmlinkage long sys32_waitpid(compat_pid_t pid, unsigned int __user *stat_addr,
 			      int options)
 {
 	return compat_sys_wait4(pid, stat_addr, options, NULL);
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 6b7ee5f..0debdb5 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -97,6 +97,7 @@
 #define X86_FEATURE_EXTD_APICID	(3*32+26) /* has extended APICID (8 bits) */
 #define X86_FEATURE_AMD_DCM     (3*32+27) /* multi-node processor */
 #define X86_FEATURE_APERFMPERF	(3*32+28) /* APERFMPERF */
+#define X86_FEATURE_EAGER_FPU	(3*32+29) /* "eagerfpu" Non lazy FPU restore */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
@@ -299,12 +300,14 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_xmm4_2		boot_cpu_has(X86_FEATURE_XMM4_2)
 #define cpu_has_x2apic		boot_cpu_has(X86_FEATURE_X2APIC)
 #define cpu_has_xsave		boot_cpu_has(X86_FEATURE_XSAVE)
+#define cpu_has_xsaveopt	boot_cpu_has(X86_FEATURE_XSAVEOPT)
 #define cpu_has_osxsave		boot_cpu_has(X86_FEATURE_OSXSAVE)
 #define cpu_has_hypervisor	boot_cpu_has(X86_FEATURE_HYPERVISOR)
 #define cpu_has_pclmulqdq	boot_cpu_has(X86_FEATURE_PCLMULQDQ)
 #define cpu_has_perfctr_core	boot_cpu_has(X86_FEATURE_PERFCTR_CORE)
 #define cpu_has_cx8		boot_cpu_has(X86_FEATURE_CX8)
 #define cpu_has_cx16		boot_cpu_has(X86_FEATURE_CX16)
+#define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1
diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 75f4c6d..92f3c6e 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -12,6 +12,7 @@
 
 #include <linux/kernel_stat.h>
 #include <linux/regset.h>
+#include <linux/compat.h>
 #include <linux/slab.h>
 #include <asm/asm.h>
 #include <asm/cpufeature.h>
@@ -21,42 +22,74 @@
 #include <asm/uaccess.h>
 #include <asm/xsave.h>
 
-extern unsigned int sig_xstate_size;
+#ifdef CONFIG_X86_64
+# include <asm/sigcontext32.h>
+# include <asm/user32.h>
+int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+			compat_sigset_t *set, struct pt_regs *regs);
+int ia32_setup_frame(int sig, struct k_sigaction *ka,
+		     compat_sigset_t *set, struct pt_regs *regs);
+#else
+# define user_i387_ia32_struct	user_i387_struct
+# define user32_fxsr_struct	user_fxsr_struct
+# define ia32_setup_frame	__setup_frame
+# define ia32_setup_rt_frame	__setup_rt_frame
+#endif
+
+extern unsigned int mxcsr_feature_mask;
 extern void fpu_init(void);
+extern void eager_fpu_init(void);
 
 DECLARE_PER_CPU(struct task_struct *, fpu_owner_task);
 
+extern void convert_from_fxsr(struct user_i387_ia32_struct *env,
+			      struct task_struct *tsk);
+extern void convert_to_fxsr(struct task_struct *tsk,
+			    const struct user_i387_ia32_struct *env);
+
 extern user_regset_active_fn fpregs_active, xfpregs_active;
 extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get,
 				xstateregs_get;
 extern user_regset_set_fn fpregs_set, xfpregs_set, fpregs_soft_set,
 				 xstateregs_set;
 
-
 /*
  * xstateregs_active == fpregs_active. Please refer to the comment
  * at the definition of fpregs_active.
  */
 #define xstateregs_active	fpregs_active
 
-extern struct _fpx_sw_bytes fx_sw_reserved;
-#ifdef CONFIG_IA32_EMULATION
-extern unsigned int sig_xstate_ia32_size;
-extern struct _fpx_sw_bytes fx_sw_reserved_ia32;
-struct _fpstate_ia32;
-struct _xstate_ia32;
-extern int save_i387_xstate_ia32(void __user *buf);
-extern int restore_i387_xstate_ia32(void __user *buf);
-#endif
-
 #ifdef CONFIG_MATH_EMULATION
+# define HAVE_HWFP		(boot_cpu_data.hard_math)
 extern void finit_soft_fpu(struct i387_soft_struct *soft);
 #else
+# define HAVE_HWFP		1
 static inline void finit_soft_fpu(struct i387_soft_struct *soft) {}
 #endif
 
+static inline int is_ia32_compat_frame(void)
+{
+	return config_enabled(CONFIG_IA32_EMULATION) &&
+	       test_thread_flag(TIF_IA32);
+}
+
+static inline int is_ia32_frame(void)
+{
+	return config_enabled(CONFIG_X86_32) || is_ia32_compat_frame();
+}
+
+static inline int is_x32_frame(void)
+{
+	return config_enabled(CONFIG_X86_X32_ABI) && test_thread_flag(TIF_X32);
+}
+
 #define X87_FSW_ES (1 << 7)	/* Exception Summary */
 
+static __always_inline __pure bool use_eager_fpu(void)
+{
+	return static_cpu_has(X86_FEATURE_EAGER_FPU);
+}
+
 static __always_inline __pure bool use_xsaveopt(void)
 {
 	return static_cpu_has(X86_FEATURE_XSAVEOPT);
@@ -72,6 +105,13 @@ static __always_inline __pure bool use_fxsr(void)
         return static_cpu_has(X86_FEATURE_FXSR);
 }
 
+static inline void fx_finit(struct i387_fxsave_struct *fx)
+{
+	memset(fx, 0, xstate_size);
+	fx->cwd = 0x37f;
+	fx->mxcsr = MXCSR_DEFAULT;
+}
+
 extern void __sanitize_i387_state(struct task_struct *);
 
 static inline void sanitize_i387_state(struct task_struct *tsk)
@@ -81,131 +121,88 @@ static inline void sanitize_i387_state(struct task_struct *tsk)
 	__sanitize_i387_state(tsk);
 }
 
-#ifdef CONFIG_X86_64
-static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
+#define check_insn(insn, output, input...)				\
+({									\
+	int err;							\
+	asm volatile("1:" #insn "\n\t"					\
+		     "2:\n"						\
+		     ".section .fixup,\"ax\"\n"				\
+		     "3:  movl $-1,%[err]\n"				\
+		     "    jmp  2b\n"					\
+		     ".previous\n"					\
+		     _ASM_EXTABLE(1b, 3b)				\
+		     : [err] "=r" (err), output				\
+		     : "0"(0), input);					\
+	err;								\
+})
+
+static inline int fsave_user(struct i387_fsave_struct __user *fx)
 {
-	int err;
-
-	/* See comment in fxsave() below. */
-#ifdef CONFIG_AS_FXSAVEQ
-	asm volatile("1:  fxrstorq %[fx]\n\t"
-		     "2:\n"
-		     ".section .fixup,\"ax\"\n"
-		     "3:  movl $-1,%[err]\n"
-		     "    jmp  2b\n"
-		     ".previous\n"
-		     _ASM_EXTABLE(1b, 3b)
-		     : [err] "=r" (err)
-		     : [fx] "m" (*fx), "0" (0));
-#else
-	asm volatile("1:  rex64/fxrstor (%[fx])\n\t"
-		     "2:\n"
-		     ".section .fixup,\"ax\"\n"
-		     "3:  movl $-1,%[err]\n"
-		     "    jmp  2b\n"
-		     ".previous\n"
-		     _ASM_EXTABLE(1b, 3b)
-		     : [err] "=r" (err)
-		     : [fx] "R" (fx), "m" (*fx), "0" (0));
-#endif
-	return err;
+	return check_insn(fnsave %[fx]; fwait,  [fx] "=m" (*fx), "m" (*fx));
 }
 
 static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
 {
-	int err;
+	if (config_enabled(CONFIG_X86_32))
+		return check_insn(fxsave %[fx], [fx] "=m" (*fx), "m" (*fx));
+	else if (config_enabled(CONFIG_AS_FXSAVEQ))
+		return check_insn(fxsaveq %[fx], [fx] "=m" (*fx), "m" (*fx));
 
-	/*
-	 * Clear the bytes not touched by the fxsave and reserved
-	 * for the SW usage.
-	 */
-	err = __clear_user(&fx->sw_reserved,
-			   sizeof(struct _fpx_sw_bytes));
-	if (unlikely(err))
-		return -EFAULT;
-
-	/* See comment in fxsave() below. */
-#ifdef CONFIG_AS_FXSAVEQ
-	asm volatile("1:  fxsaveq %[fx]\n\t"
-		     "2:\n"
-		     ".section .fixup,\"ax\"\n"
-		     "3:  movl $-1,%[err]\n"
-		     "    jmp  2b\n"
-		     ".previous\n"
-		     _ASM_EXTABLE(1b, 3b)
-		     : [err] "=r" (err), [fx] "=m" (*fx)
-		     : "0" (0));
-#else
-	asm volatile("1:  rex64/fxsave (%[fx])\n\t"
-		     "2:\n"
-		     ".section .fixup,\"ax\"\n"
-		     "3:  movl $-1,%[err]\n"
-		     "    jmp  2b\n"
-		     ".previous\n"
-		     _ASM_EXTABLE(1b, 3b)
-		     : [err] "=r" (err), "=m" (*fx)
-		     : [fx] "R" (fx), "0" (0));
-#endif
-	if (unlikely(err) &&
-	    __clear_user(fx, sizeof(struct i387_fxsave_struct)))
-		err = -EFAULT;
-	/* No need to clear here because the caller clears USED_MATH */
-	return err;
+	/* See comment in fpu_fxsave() below. */
+	return check_insn(rex64/fxsave (%[fx]), "=m" (*fx), [fx] "R" (fx));
 }
 
-static inline void fpu_fxsave(struct fpu *fpu)
+static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 {
-	/* Using "rex64; fxsave %0" is broken because, if the memory operand
-	   uses any extended registers for addressing, a second REX prefix
-	   will be generated (to the assembler, rex64 followed by semicolon
-	   is a separate instruction), and hence the 64-bitness is lost. */
+	if (config_enabled(CONFIG_X86_32))
+		return check_insn(fxrstor %[fx], "=m" (*fx), [fx] "m" (*fx));
+	else if (config_enabled(CONFIG_AS_FXSAVEQ))
+		return check_insn(fxrstorq %[fx], "=m" (*fx), [fx] "m" (*fx));
 
-#ifdef CONFIG_AS_FXSAVEQ
-	/* Using "fxsaveq %0" would be the ideal choice, but is only supported
-	   starting with gas 2.16. */
-	__asm__ __volatile__("fxsaveq %0"
-			     : "=m" (fpu->state->fxsave));
-#else
-	/* Using, as a workaround, the properly prefixed form below isn't
-	   accepted by any binutils version so far released, complaining that
-	   the same type of prefix is used twice if an extended register is
-	   needed for addressing (fix submitted to mainline 2005-11-21).
-	asm volatile("rex64/fxsave %0"
-		     : "=m" (fpu->state->fxsave));
-	   This, however, we can work around by forcing the compiler to select
-	   an addressing mode that doesn't require extended registers. */
-	asm volatile("rex64/fxsave (%[fx])"
-		     : "=m" (fpu->state->fxsave)
-		     : [fx] "R" (&fpu->state->fxsave));
-#endif
+	/* See comment in fpu_fxsave() below. */
+	return check_insn(rex64/fxrstor (%[fx]), "=m" (*fx), [fx] "R" (fx),
+			  "m" (*fx));
 }
 
-#else  /* CONFIG_X86_32 */
-
-/* perform fxrstor iff the processor has extended states, otherwise frstor */
-static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
+static inline int frstor_checking(struct i387_fsave_struct *fx)
 {
-	/*
-	 * The "nop" is needed to make the instructions the same
-	 * length.
-	 */
-	alternative_input(
-		"nop ; frstor %1",
-		"fxrstor %1",
-		X86_FEATURE_FXSR,
-		"m" (*fx));
-
-	return 0;
+	return check_insn(frstor %[fx], "=m" (*fx), [fx] "m" (*fx));
 }
 
 static inline void fpu_fxsave(struct fpu *fpu)
 {
-	asm volatile("fxsave %[fx]"
-		     : [fx] "=m" (fpu->state->fxsave));
+	if (config_enabled(CONFIG_X86_32))
+		asm volatile( "fxsave %[fx]" : [fx] "=m" (fpu->state->fxsave));
+	else if (config_enabled(CONFIG_AS_FXSAVEQ))
+		asm volatile("fxsaveq %0" : "=m" (fpu->state->fxsave));
+	else {
+		/* Using "rex64; fxsave %0" is broken because, if the memory
+		 * operand uses any extended registers for addressing, a second
+		 * REX prefix will be generated (to the assembler, rex64
+		 * followed by semicolon is a separate instruction), and hence
+		 * the 64-bitness is lost.
+		 *
+		 * Using "fxsaveq %0" would be the ideal choice, but is only
+		 * supported starting with gas 2.16.
+		 *
+		 * Using, as a workaround, the properly prefixed form below
+		 * isn't accepted by any binutils version so far released,
+		 * complaining that the same type of prefix is used twice if
+		 * an extended register is needed for addressing (fix submitted
+		 * to mainline 2005-11-21).
+		 *
+		 *  asm volatile("rex64/fxsave %0" : "=m" (fpu->state->fxsave));
+		 *
+		 * This, however, we can work around by forcing the compiler to
+		 * select an addressing mode that doesn't require extended
+		 * registers.
+		 */
+		asm volatile( "rex64/fxsave (%[fx])"
+			     : "=m" (fpu->state->fxsave)
+			     : [fx] "R" (&fpu->state->fxsave));
+	}
 }
 
-#endif	/* CONFIG_X86_64 */
-
 /*
  * These must be called with preempt disabled. Returns
  * 'true' if the FPU state is still intact.
@@ -248,17 +245,14 @@ static inline int __save_init_fpu(struct task_struct *tsk)
 	return fpu_save_init(&tsk->thread.fpu);
 }
 
-static inline int fpu_fxrstor_checking(struct fpu *fpu)
-{
-	return fxrstor_checking(&fpu->state->fxsave);
-}
-
 static inline int fpu_restore_checking(struct fpu *fpu)
 {
 	if (use_xsave())
-		return fpu_xrstor_checking(fpu);
+		return fpu_xrstor_checking(&fpu->state->xsave);
+	else if (use_fxsr())
+		return fxrstor_checking(&fpu->state->fxsave);
 	else
-		return fpu_fxrstor_checking(fpu);
+		return frstor_checking(&fpu->state->fsave);
 }
 
 static inline int restore_fpu_checking(struct task_struct *tsk)
@@ -310,15 +304,52 @@ static inline void __thread_set_has_fpu(struct task_struct *tsk)
 static inline void __thread_fpu_end(struct task_struct *tsk)
 {
 	__thread_clear_has_fpu(tsk);
-	stts();
+	if (!use_eager_fpu())
+		stts();
 }
 
 static inline void __thread_fpu_begin(struct task_struct *tsk)
 {
-	clts();
+	if (!use_eager_fpu())
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
+	if (!use_eager_fpu())
+		drop_fpu(tsk);
+	else {
+		if (use_xsave())
+			xrstor_state(init_xstate_buf, -1);
+		else
+			fxrstor_checking(&init_xstate_buf->i387);
+	}
+}
+
 /*
  * FPU state switching for scheduling.
  *
@@ -352,7 +383,12 @@ static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct ta
 {
 	fpu_switch_t fpu;
 
-	fpu.preload = tsk_used_math(new) && new->fpu_counter > 5;
+	/*
+	 * If the task has used the math, pre-load the FPU on xsave processors
+	 * or if the past 5 consecutive context-switches used math.
+	 */
+	fpu.preload = tsk_used_math(new) && (use_eager_fpu() ||
+					     new->fpu_counter > 5);
 	if (__thread_has_fpu(old)) {
 		if (!__save_init_fpu(old))
 			cpu = ~0;
@@ -364,14 +400,14 @@ static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct ta
 			new->fpu_counter++;
 			__thread_set_has_fpu(new);
 			prefetch(new->thread.fpu.state);
-		} else
+		} else if (!use_eager_fpu())
 			stts();
 	} else {
 		old->fpu_counter = 0;
 		old->thread.fpu.last_cpu = ~0;
 		if (fpu.preload) {
 			new->fpu_counter++;
-			if (fpu_lazy_restore(new, cpu))
+			if (!use_eager_fpu() && fpu_lazy_restore(new, cpu))
 				fpu.preload = 0;
 			else
 				prefetch(new->thread.fpu.state);
@@ -391,44 +427,40 @@ static inline void switch_fpu_finish(struct task_struct *new, fpu_switch_t fpu)
 {
 	if (fpu.preload) {
 		if (unlikely(restore_fpu_checking(new)))
-			__thread_fpu_end(new);
+			drop_init_fpu(new);
 	}
 }
 
 /*
  * Signal frame handlers...
  */
-extern int save_i387_xstate(void __user *buf);
-extern int restore_i387_xstate(void __user *buf);
+extern int save_xstate_sig(void __user *buf, void __user *fx, int size);
+extern int __restore_xstate_sig(void __user *buf, void __user *fx, int size);
 
-static inline void __clear_fpu(struct task_struct *tsk)
+static inline int xstate_sigframe_size(void)
 {
-	if (__thread_has_fpu(tsk)) {
-		/* Ignore delayed exceptions from user space */
-		asm volatile("1: fwait\n"
-			     "2:\n"
-			     _ASM_EXTABLE(1b, 2b));
-		__thread_fpu_end(tsk);
+	return use_xsave() ? xstate_size + FP_XSTATE_MAGIC2_SIZE : xstate_size;
+}
+
+static inline int restore_xstate_sig(void __user *buf, int ia32_frame)
+{
+	void __user *buf_fx = buf;
+	int size = xstate_sigframe_size();
+
+	if (ia32_frame && use_fxsr()) {
+		buf_fx = buf + sizeof(struct i387_fsave_struct);
+		size += sizeof(struct i387_fsave_struct);
 	}
+
+	return __restore_xstate_sig(buf, buf_fx, size);
 }
 
 /*
- * The actual user_fpu_begin/end() functions
- * need to be preemption-safe.
+ * Need to be preemption-safe.
  *
- * NOTE! user_fpu_end() must be used only after you
- * have saved the FP state, and user_fpu_begin() must
- * be used only immediately before restoring it.
- * These functions do not do any save/restore on
- * their own.
+ * NOTE! user_fpu_begin() must be used only immediately before restoring
+ * it. This function does not do any save/restore on their own.
  */
-static inline void user_fpu_end(void)
-{
-	preempt_disable();
-	__thread_fpu_end(current);
-	preempt_enable();
-}
-
 static inline void user_fpu_begin(void)
 {
 	preempt_disable();
@@ -437,25 +469,32 @@ static inline void user_fpu_begin(void)
 	preempt_enable();
 }
 
+static inline void __save_fpu(struct task_struct *tsk)
+{
+	if (use_xsave())
+		xsave_state(&tsk->thread.fpu.state->xsave, -1);
+	else
+		fpu_fxsave(&tsk->thread.fpu);
+}
+
 /*
  * These disable preemption on their own and are safe
  */
 static inline void save_init_fpu(struct task_struct *tsk)
 {
 	WARN_ON_ONCE(!__thread_has_fpu(tsk));
+
+	if (use_eager_fpu()) {
+		__save_fpu(tsk);
+		return;
+	}
+
 	preempt_disable();
 	__save_init_fpu(tsk);
 	__thread_fpu_end(tsk);
 	preempt_enable();
 }
 
-static inline void clear_fpu(struct task_struct *tsk)
-{
-	preempt_disable();
-	__clear_fpu(tsk);
-	preempt_enable();
-}
-
 /*
  * i387 state interaction
  */
@@ -510,11 +549,34 @@ static inline void fpu_free(struct fpu *fpu)
 	}
 }
 
-static inline void fpu_copy(struct fpu *dst, struct fpu *src)
+static inline void fpu_copy(struct task_struct *dst, struct task_struct *src)
 {
-	memcpy(dst->state, src->state, xstate_size);
+	if (use_eager_fpu()) {
+		memset(&dst->thread.fpu.state->xsave, 0, xstate_size);
+		__save_fpu(dst);
+	} else {
+		struct fpu *dfpu = &dst->thread.fpu;
+		struct fpu *sfpu = &src->thread.fpu;
+
+		unlazy_fpu(src);
+		memcpy(dfpu->state, sfpu->state, xstate_size);
+	}
 }
 
-extern void fpu_finit(struct fpu *fpu);
+static inline unsigned long
+alloc_mathframe(unsigned long sp, int ia32_frame, unsigned long *buf_fx,
+		unsigned long *size)
+{
+	unsigned long frame_size = xstate_sigframe_size();
+
+	*buf_fx = sp = round_down(sp - frame_size, 64);
+	if (ia32_frame && use_fxsr()) {
+		frame_size += sizeof(struct i387_fsave_struct);
+		sp -= sizeof(struct i387_fsave_struct);
+	}
+
+	*size = frame_size;
+	return sp;
+}
 
 #endif
diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 257d9cc..ed8089d 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -19,12 +19,37 @@ struct pt_regs;
 struct user_i387_struct;
 
 extern int init_fpu(struct task_struct *child);
+extern void fpu_finit(struct fpu *fpu);
 extern int dump_fpu(struct pt_regs *, struct user_i387_struct *);
 extern void math_state_restore(void);
 
 extern bool irq_fpu_usable(void);
-extern void kernel_fpu_begin(void);
-extern void kernel_fpu_end(void);
+
+/*
+ * Careful: __kernel_fpu_begin/end() must be called with preempt disabled
+ * and they don't touch the preempt state on their own.
+ * If you enable preemption after __kernel_fpu_begin(), preempt notifier
+ * should call the __kernel_fpu_end() to prevent the kernel/user FPU
+ * state from getting corrupted. KVM for example uses this model.
+ *
+ * All other cases use kernel_fpu_begin/end() which disable preemption
+ * during kernel FPU usage.
+ */
+extern void __kernel_fpu_begin(void);
+extern void __kernel_fpu_end(void);
+
+static inline void kernel_fpu_begin(void)
+{
+	WARN_ON_ONCE(!irq_fpu_usable());
+	preempt_disable();
+	__kernel_fpu_begin();
+}
+
+static inline void kernel_fpu_end(void)
+{
+	__kernel_fpu_end();
+	preempt_enable();
+}
 
 /*
  * Some instructions like VIA's padlock instructions generate a spurious
diff --git a/arch/x86/include/asm/iommu_table.h b/arch/x86/include/asm/iommu_table.h
index f229b13..f42a047 100644
--- a/arch/x86/include/asm/iommu_table.h
+++ b/arch/x86/include/asm/iommu_table.h
@@ -48,7 +48,7 @@ struct iommu_table_entry {
 
 
 #define __IOMMU_INIT(_detect, _depend, _early_init, _late_init, _finish)\
-	static const struct iommu_table_entry const			\
+	static const struct iommu_table_entry				\
 		__iommu_entry_##_detect __used				\
 	__attribute__ ((unused, __section__(".iommu_table"),		\
 			aligned((sizeof(void *)))))	\
@@ -63,10 +63,10 @@ struct iommu_table_entry {
  * to stop detecting the other IOMMUs after yours has been detected.
  */
 #define IOMMU_INIT_POST(_detect)					\
-	__IOMMU_INIT(_detect, pci_swiotlb_detect_4gb,  0, 0, 0)
+	__IOMMU_INIT(_detect, pci_swiotlb_detect_4gb,  NULL, NULL, 0)
 
 #define IOMMU_INIT_POST_FINISH(detect)					\
-	__IOMMU_INIT(_detect, pci_swiotlb_detect_4gb,  0, 0, 1)
+	__IOMMU_INIT(_detect, pci_swiotlb_detect_4gb,  NULL, NULL, 1)
 
 /*
  * A more sophisticated version of IOMMU_INIT. This variant requires:
diff --git a/arch/x86/include/asm/signal.h b/arch/x86/include/asm/signal.h
index 598457c..323973f 100644
--- a/arch/x86/include/asm/signal.h
+++ b/arch/x86/include/asm/signal.h
@@ -31,6 +31,10 @@ typedef struct {
 	unsigned long sig[_NSIG_WORDS];
 } sigset_t;
 
+#ifndef CONFIG_COMPAT
+typedef sigset_t compat_sigset_t;
+#endif
+
 #else
 /* Here we must cater to libcs that poke about in kernel headers.  */
 
diff --git a/arch/x86/include/asm/sys_ia32.h b/arch/x86/include/asm/sys_ia32.h
index 3fda9db4..4ca1c61 100644
--- a/arch/x86/include/asm/sys_ia32.h
+++ b/arch/x86/include/asm/sys_ia32.h
@@ -40,7 +40,7 @@ asmlinkage long sys32_sigaction(int, struct old_sigaction32 __user *,
 				struct old_sigaction32 __user *);
 asmlinkage long sys32_alarm(unsigned int);
 
-asmlinkage long sys32_waitpid(compat_pid_t, unsigned int *, int);
+asmlinkage long sys32_waitpid(compat_pid_t, unsigned int __user *, int);
 asmlinkage long sys32_sysfs(int, u32, u32);
 
 asmlinkage long sys32_sched_rr_get_interval(compat_pid_t,
diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index bb05228..fddb53d 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -11,7 +11,8 @@ extern const char VDSO32_PRELINK[];
 #define VDSO32_SYMBOL(base, name)					\
 ({									\
 	extern const char VDSO32_##name[];				\
-	(void *)(VDSO32_##name - VDSO32_PRELINK + (unsigned long)(base)); \
+	(void __user *)(VDSO32_##name - VDSO32_PRELINK +		\
+			(unsigned long)(base));				\
 })
 #endif
 
diff --git a/arch/x86/include/asm/xor_32.h b/arch/x86/include/asm/xor_32.h
index 4545708..aabd585 100644
--- a/arch/x86/include/asm/xor_32.h
+++ b/arch/x86/include/asm/xor_32.h
@@ -534,38 +534,6 @@ static struct xor_block_template xor_block_p5_mmx = {
  * Copyright (C) 1999 Zach Brown (with obvious credit due Ingo)
  */
 
-#define XMMS_SAVE				\
-do {						\
-	preempt_disable();			\
-	cr0 = read_cr0();			\
-	clts();					\
-	asm volatile(				\
-		"movups %%xmm0,(%0)	;\n\t"	\
-		"movups %%xmm1,0x10(%0)	;\n\t"	\
-		"movups %%xmm2,0x20(%0)	;\n\t"	\
-		"movups %%xmm3,0x30(%0)	;\n\t"	\
-		:				\
-		: "r" (xmm_save) 		\
-		: "memory");			\
-} while (0)
-
-#define XMMS_RESTORE				\
-do {						\
-	asm volatile(				\
-		"sfence			;\n\t"	\
-		"movups (%0),%%xmm0	;\n\t"	\
-		"movups 0x10(%0),%%xmm1	;\n\t"	\
-		"movups 0x20(%0),%%xmm2	;\n\t"	\
-		"movups 0x30(%0),%%xmm3	;\n\t"	\
-		:				\
-		: "r" (xmm_save)		\
-		: "memory");			\
-	write_cr0(cr0);				\
-	preempt_enable();			\
-} while (0)
-
-#define ALIGN16 __attribute__((aligned(16)))
-
 #define OFFS(x)		"16*("#x")"
 #define PF_OFFS(x)	"256+16*("#x")"
 #define	PF0(x)		"	prefetchnta "PF_OFFS(x)"(%1)		;\n"
@@ -587,10 +555,8 @@ static void
 xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
 {
 	unsigned long lines = bytes >> 8;
-	char xmm_save[16*4] ALIGN16;
-	int cr0;
 
-	XMMS_SAVE;
+	kernel_fpu_begin();
 
 	asm volatile(
 #undef BLOCK
@@ -633,7 +599,7 @@ xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
 	:
 	: "memory");
 
-	XMMS_RESTORE;
+	kernel_fpu_end();
 }
 
 static void
@@ -641,10 +607,8 @@ xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3)
 {
 	unsigned long lines = bytes >> 8;
-	char xmm_save[16*4] ALIGN16;
-	int cr0;
 
-	XMMS_SAVE;
+	kernel_fpu_begin();
 
 	asm volatile(
 #undef BLOCK
@@ -694,7 +658,7 @@ xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	:
 	: "memory" );
 
-	XMMS_RESTORE;
+	kernel_fpu_end();
 }
 
 static void
@@ -702,10 +666,8 @@ xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3, unsigned long *p4)
 {
 	unsigned long lines = bytes >> 8;
-	char xmm_save[16*4] ALIGN16;
-	int cr0;
 
-	XMMS_SAVE;
+	kernel_fpu_begin();
 
 	asm volatile(
 #undef BLOCK
@@ -762,7 +724,7 @@ xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	:
 	: "memory" );
 
-	XMMS_RESTORE;
+	kernel_fpu_end();
 }
 
 static void
@@ -770,10 +732,8 @@ xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3, unsigned long *p4, unsigned long *p5)
 {
 	unsigned long lines = bytes >> 8;
-	char xmm_save[16*4] ALIGN16;
-	int cr0;
 
-	XMMS_SAVE;
+	kernel_fpu_begin();
 
 	/* Make sure GCC forgets anything it knows about p4 or p5,
 	   such that it won't pass to the asm volatile below a
@@ -850,7 +810,7 @@ xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	   like assuming they have some legal value.  */
 	asm("" : "=r" (p4), "=r" (p5));
 
-	XMMS_RESTORE;
+	kernel_fpu_end();
 }
 
 static struct xor_block_template xor_block_pIII_sse = {
diff --git a/arch/x86/include/asm/xor_64.h b/arch/x86/include/asm/xor_64.h
index b9b2323..5fc06d0 100644
--- a/arch/x86/include/asm/xor_64.h
+++ b/arch/x86/include/asm/xor_64.h
@@ -34,41 +34,7 @@
  * no advantages to be gotten from x86-64 here anyways.
  */
 
-typedef struct {
-	unsigned long a, b;
-} __attribute__((aligned(16))) xmm_store_t;
-
-/* Doesn't use gcc to save the XMM registers, because there is no easy way to
-   tell it to do a clts before the register saving. */
-#define XMMS_SAVE				\
-do {						\
-	preempt_disable();			\
-	asm volatile(				\
-		"movq %%cr0,%0		;\n\t"	\
-		"clts			;\n\t"	\
-		"movups %%xmm0,(%1)	;\n\t"	\
-		"movups %%xmm1,0x10(%1)	;\n\t"	\
-		"movups %%xmm2,0x20(%1)	;\n\t"	\
-		"movups %%xmm3,0x30(%1)	;\n\t"	\
-		: "=&r" (cr0)			\
-		: "r" (xmm_save) 		\
-		: "memory");			\
-} while (0)
-
-#define XMMS_RESTORE				\
-do {						\
-	asm volatile(				\
-		"sfence			;\n\t"	\
-		"movups (%1),%%xmm0	;\n\t"	\
-		"movups 0x10(%1),%%xmm1	;\n\t"	\
-		"movups 0x20(%1),%%xmm2	;\n\t"	\
-		"movups 0x30(%1),%%xmm3	;\n\t"	\
-		"movq 	%0,%%cr0	;\n\t"	\
-		:				\
-		: "r" (cr0), "r" (xmm_save)	\
-		: "memory");			\
-	preempt_enable();			\
-} while (0)
+#include <asm/i387.h>
 
 #define OFFS(x)		"16*("#x")"
 #define PF_OFFS(x)	"256+16*("#x")"
@@ -91,10 +57,8 @@ static void
 xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
 {
 	unsigned int lines = bytes >> 8;
-	unsigned long cr0;
-	xmm_store_t xmm_save[4];
 
-	XMMS_SAVE;
+	kernel_fpu_begin();
 
 	asm volatile(
 #undef BLOCK
@@ -135,7 +99,7 @@ xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
 	: [inc] "r" (256UL)
 	: "memory");
 
-	XMMS_RESTORE;
+	kernel_fpu_end();
 }
 
 static void
@@ -143,11 +107,8 @@ xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3)
 {
 	unsigned int lines = bytes >> 8;
-	xmm_store_t xmm_save[4];
-	unsigned long cr0;
-
-	XMMS_SAVE;
 
+	kernel_fpu_begin();
 	asm volatile(
 #undef BLOCK
 #define BLOCK(i) \
@@ -194,7 +155,7 @@ xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3)
 	: [inc] "r" (256UL)
 	: "memory");
-	XMMS_RESTORE;
+	kernel_fpu_end();
 }
 
 static void
@@ -202,10 +163,8 @@ xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3, unsigned long *p4)
 {
 	unsigned int lines = bytes >> 8;
-	xmm_store_t xmm_save[4];
-	unsigned long cr0;
 
-	XMMS_SAVE;
+	kernel_fpu_begin();
 
 	asm volatile(
 #undef BLOCK
@@ -261,7 +220,7 @@ xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	: [inc] "r" (256UL)
 	: "memory" );
 
-	XMMS_RESTORE;
+	kernel_fpu_end();
 }
 
 static void
@@ -269,10 +228,8 @@ xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3, unsigned long *p4, unsigned long *p5)
 {
 	unsigned int lines = bytes >> 8;
-	xmm_store_t xmm_save[4];
-	unsigned long cr0;
 
-	XMMS_SAVE;
+	kernel_fpu_begin();
 
 	asm volatile(
 #undef BLOCK
@@ -336,7 +293,7 @@ xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	: [inc] "r" (256UL)
 	: "memory");
 
-	XMMS_RESTORE;
+	kernel_fpu_end();
 }
 
 static struct xor_block_template xor_block_sse = {
diff --git a/arch/x86/include/asm/xor_avx.h b/arch/x86/include/asm/xor_avx.h
index 2510d35..7ea79c5 100644
--- a/arch/x86/include/asm/xor_avx.h
+++ b/arch/x86/include/asm/xor_avx.h
@@ -20,32 +20,6 @@
 #include <linux/compiler.h>
 #include <asm/i387.h>
 
-#define ALIGN32 __aligned(32)
-
-#define YMM_SAVED_REGS 4
-
-#define YMMS_SAVE \
-do { \
-	preempt_disable(); \
-	cr0 = read_cr0(); \
-	clts(); \
-	asm volatile("vmovaps %%ymm0, %0" : "=m" (ymm_save[0]) : : "memory"); \
-	asm volatile("vmovaps %%ymm1, %0" : "=m" (ymm_save[32]) : : "memory"); \
-	asm volatile("vmovaps %%ymm2, %0" : "=m" (ymm_save[64]) : : "memory"); \
-	asm volatile("vmovaps %%ymm3, %0" : "=m" (ymm_save[96]) : : "memory"); \
-} while (0);
-
-#define YMMS_RESTORE \
-do { \
-	asm volatile("sfence" : : : "memory"); \
-	asm volatile("vmovaps %0, %%ymm3" : : "m" (ymm_save[96])); \
-	asm volatile("vmovaps %0, %%ymm2" : : "m" (ymm_save[64])); \
-	asm volatile("vmovaps %0, %%ymm1" : : "m" (ymm_save[32])); \
-	asm volatile("vmovaps %0, %%ymm0" : : "m" (ymm_save[0])); \
-	write_cr0(cr0); \
-	preempt_enable(); \
-} while (0);
-
 #define BLOCK4(i) \
 		BLOCK(32 * i, 0) \
 		BLOCK(32 * (i + 1), 1) \
@@ -60,10 +34,9 @@ do { \
 
 static void xor_avx_2(unsigned long bytes, unsigned long *p0, unsigned long *p1)
 {
-	unsigned long cr0, lines = bytes >> 9;
-	char ymm_save[32 * YMM_SAVED_REGS] ALIGN32;
+	unsigned long lines = bytes >> 9;
 
-	YMMS_SAVE
+	kernel_fpu_begin();
 
 	while (lines--) {
 #undef BLOCK
@@ -82,16 +55,15 @@ do { \
 		p1 = (unsigned long *)((uintptr_t)p1 + 512);
 	}
 
-	YMMS_RESTORE
+	kernel_fpu_end();
 }
 
 static void xor_avx_3(unsigned long bytes, unsigned long *p0, unsigned long *p1,
 	unsigned long *p2)
 {
-	unsigned long cr0, lines = bytes >> 9;
-	char ymm_save[32 * YMM_SAVED_REGS] ALIGN32;
+	unsigned long lines = bytes >> 9;
 
-	YMMS_SAVE
+	kernel_fpu_begin();
 
 	while (lines--) {
 #undef BLOCK
@@ -113,16 +85,15 @@ do { \
 		p2 = (unsigned long *)((uintptr_t)p2 + 512);
 	}
 
-	YMMS_RESTORE
+	kernel_fpu_end();
 }
 
 static void xor_avx_4(unsigned long bytes, unsigned long *p0, unsigned long *p1,
 	unsigned long *p2, unsigned long *p3)
 {
-	unsigned long cr0, lines = bytes >> 9;
-	char ymm_save[32 * YMM_SAVED_REGS] ALIGN32;
+	unsigned long lines = bytes >> 9;
 
-	YMMS_SAVE
+	kernel_fpu_begin();
 
 	while (lines--) {
 #undef BLOCK
@@ -147,16 +118,15 @@ do { \
 		p3 = (unsigned long *)((uintptr_t)p3 + 512);
 	}
 
-	YMMS_RESTORE
+	kernel_fpu_end();
 }
 
 static void xor_avx_5(unsigned long bytes, unsigned long *p0, unsigned long *p1,
 	unsigned long *p2, unsigned long *p3, unsigned long *p4)
 {
-	unsigned long cr0, lines = bytes >> 9;
-	char ymm_save[32 * YMM_SAVED_REGS] ALIGN32;
+	unsigned long lines = bytes >> 9;
 
-	YMMS_SAVE
+	kernel_fpu_begin();
 
 	while (lines--) {
 #undef BLOCK
@@ -184,7 +154,7 @@ do { \
 		p4 = (unsigned long *)((uintptr_t)p4 + 512);
 	}
 
-	YMMS_RESTORE
+	kernel_fpu_end();
 }
 
 static struct xor_block_template xor_block_avx = {
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 8a1b6f9..2ddee1b8 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -34,17 +34,14 @@
 extern unsigned int xstate_size;
 extern u64 pcntxt_mask;
 extern u64 xstate_fx_sw_bytes[USER_XSTATE_FX_SW_WORDS];
+extern struct xsave_struct *init_xstate_buf;
 
 extern void xsave_init(void);
 extern void update_regset_xstate_info(unsigned int size, u64 xstate_mask);
 extern int init_fpu(struct task_struct *child);
-extern int check_for_xstate(struct i387_fxsave_struct __user *buf,
-			    void __user *fpstate,
-			    struct _fpx_sw_bytes *sw);
 
-static inline int fpu_xrstor_checking(struct fpu *fpu)
+static inline int fpu_xrstor_checking(struct xsave_struct *fx)
 {
-	struct xsave_struct *fx = &fpu->state->xsave;
 	int err;
 
 	asm volatile("1: .byte " REX_PREFIX "0x0f,0xae,0x2f\n\t"
@@ -69,8 +66,7 @@ static inline int xsave_user(struct xsave_struct __user *buf)
 	 * Clear the xsave header first, so that reserved fields are
 	 * initialized to zero.
 	 */
-	err = __clear_user(&buf->xsave_hdr,
-			   sizeof(struct xsave_hdr_struct));
+	err = __clear_user(&buf->xsave_hdr, sizeof(buf->xsave_hdr));
 	if (unlikely(err))
 		return -EFAULT;
 
@@ -84,9 +80,6 @@ static inline int xsave_user(struct xsave_struct __user *buf)
 			     : [err] "=r" (err)
 			     : "D" (buf), "a" (-1), "d" (-1), "0" (0)
 			     : "memory");
-	if (unlikely(err) && __clear_user(buf, xstate_size))
-		err = -EFAULT;
-	/* No need to clear here because the caller clears USED_MATH */
 	return err;
 }
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index c97bb7b..d0e910d 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -165,10 +165,15 @@ void __init check_bugs(void)
 	print_cpu_info(&boot_cpu_data);
 #endif
 	check_config();
-	check_fpu();
 	check_hlt();
 	check_popad();
 	init_utsname()->machine[1] =
 		'0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
 	alternative_instructions();
+
+	/*
+	 * kernel_fpu_begin/end() in check_fpu() relies on the patched
+	 * alternative instructions.
+	 */
+	check_fpu();
 }
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a5fbc3c..b0fe078 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1297,7 +1297,6 @@ void __cpuinit cpu_init(void)
 	dbg_restore_debug_regs();
 
 	fpu_init();
-	xsave_init();
 
 	raw_local_save_flags(kernel_eflags);
 
@@ -1352,6 +1351,5 @@ void __cpuinit cpu_init(void)
 	dbg_restore_debug_regs();
 
 	fpu_init();
-	xsave_init();
 }
 #endif
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index f250431..675a050 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -19,24 +19,17 @@
 #include <asm/fpu-internal.h>
 #include <asm/user.h>
 
-#ifdef CONFIG_X86_64
-# include <asm/sigcontext32.h>
-# include <asm/user32.h>
-#else
-# define save_i387_xstate_ia32		save_i387_xstate
-# define restore_i387_xstate_ia32	restore_i387_xstate
-# define _fpstate_ia32		_fpstate
-# define _xstate_ia32		_xstate
-# define sig_xstate_ia32_size   sig_xstate_size
-# define fx_sw_reserved_ia32	fx_sw_reserved
-# define user_i387_ia32_struct	user_i387_struct
-# define user32_fxsr_struct	user_fxsr_struct
-#endif
-
 /*
  * Were we in an interrupt that interrupted kernel mode?
  *
- * We can do a kernel_fpu_begin/end() pair *ONLY* if that
+ * For now, with eagerfpu we will return interrupted kernel FPU
+ * state as not-idle. TBD: Ideally we can change the return value
+ * to something like __thread_has_fpu(current). But we need to
+ * be careful of doing __thread_clear_has_fpu() before saving
+ * the FPU etc for supporting nested uses etc. For now, take
+ * the simple route!
+ *
+ * On others, we can do a kernel_fpu_begin/end() pair *ONLY* if that
  * pair does nothing at all: the thread must not have fpu (so
  * that we don't try to save the FPU state), and TS must
  * be set (so that the clts/stts pair does nothing that is
@@ -44,6 +37,9 @@
  */
 static inline bool interrupted_kernel_fpu_idle(void)
 {
+	if (use_eager_fpu())
+		return 0;
+
 	return !__thread_has_fpu(current) &&
 		(read_cr0() & X86_CR0_TS);
 }
@@ -77,29 +73,29 @@ bool irq_fpu_usable(void)
 }
 EXPORT_SYMBOL(irq_fpu_usable);
 
-void kernel_fpu_begin(void)
+void __kernel_fpu_begin(void)
 {
 	struct task_struct *me = current;
 
-	WARN_ON_ONCE(!irq_fpu_usable());
-	preempt_disable();
 	if (__thread_has_fpu(me)) {
 		__save_init_fpu(me);
 		__thread_clear_has_fpu(me);
-		/* We do 'stts()' in kernel_fpu_end() */
-	} else {
+		/* We do 'stts()' in __kernel_fpu_end() */
+	} else if (!use_eager_fpu()) {
 		this_cpu_write(fpu_owner_task, NULL);
 		clts();
 	}
 }
-EXPORT_SYMBOL(kernel_fpu_begin);
+EXPORT_SYMBOL(__kernel_fpu_begin);
 
-void kernel_fpu_end(void)
+void __kernel_fpu_end(void)
 {
-	stts();
-	preempt_enable();
+	if (use_eager_fpu())
+		math_state_restore();
+	else
+		stts();
 }
-EXPORT_SYMBOL(kernel_fpu_end);
+EXPORT_SYMBOL(__kernel_fpu_end);
 
 void unlazy_fpu(struct task_struct *tsk)
 {
@@ -113,23 +109,15 @@ void unlazy_fpu(struct task_struct *tsk)
 }
 EXPORT_SYMBOL(unlazy_fpu);
 
-#ifdef CONFIG_MATH_EMULATION
-# define HAVE_HWFP		(boot_cpu_data.hard_math)
-#else
-# define HAVE_HWFP		1
-#endif
-
-static unsigned int		mxcsr_feature_mask __read_mostly = 0xffffffffu;
+unsigned int mxcsr_feature_mask __read_mostly = 0xffffffffu;
 unsigned int xstate_size;
 EXPORT_SYMBOL_GPL(xstate_size);
-unsigned int sig_xstate_ia32_size = sizeof(struct _fpstate_ia32);
 static struct i387_fxsave_struct fx_scratch __cpuinitdata;
 
 static void __cpuinit mxcsr_feature_mask_init(void)
 {
 	unsigned long mask = 0;
 
-	clts();
 	if (cpu_has_fxsr) {
 		memset(&fx_scratch, 0, sizeof(struct i387_fxsave_struct));
 		asm volatile("fxsave %0" : : "m" (fx_scratch));
@@ -138,7 +126,6 @@ static void __cpuinit mxcsr_feature_mask_init(void)
 			mask = 0x0000ffbf;
 	}
 	mxcsr_feature_mask &= mask;
-	stts();
 }
 
 static void __cpuinit init_thread_xstate(void)
@@ -192,9 +179,8 @@ void __cpuinit fpu_init(void)
 		init_thread_xstate();
 
 	mxcsr_feature_mask_init();
-	/* clean state in init */
-	current_thread_info()->status = 0;
-	clear_used_math();
+	xsave_init();
+	eager_fpu_init();
 }
 
 void fpu_finit(struct fpu *fpu)
@@ -205,12 +191,7 @@ void fpu_finit(struct fpu *fpu)
 	}
 
 	if (cpu_has_fxsr) {
-		struct i387_fxsave_struct *fx = &fpu->state->fxsave;
-
-		memset(fx, 0, xstate_size);
-		fx->cwd = 0x37f;
-		if (cpu_has_xmm)
-			fx->mxcsr = MXCSR_DEFAULT;
+		fx_finit(&fpu->state->fxsave);
 	} else {
 		struct i387_fsave_struct *fp = &fpu->state->fsave;
 		memset(fp, 0, xstate_size);
@@ -454,7 +435,7 @@ static inline u32 twd_fxsr_to_i387(struct i387_fxsave_struct *fxsave)
  * FXSR floating point environment conversions.
  */
 
-static void
+void
 convert_from_fxsr(struct user_i387_ia32_struct *env, struct task_struct *tsk)
 {
 	struct i387_fxsave_struct *fxsave = &tsk->thread.fpu.state->fxsave;
@@ -491,8 +472,8 @@ convert_from_fxsr(struct user_i387_ia32_struct *env, struct task_struct *tsk)
 		memcpy(&to[i], &from[i], sizeof(to[0]));
 }
 
-static void convert_to_fxsr(struct task_struct *tsk,
-			    const struct user_i387_ia32_struct *env)
+void convert_to_fxsr(struct task_struct *tsk,
+		     const struct user_i387_ia32_struct *env)
 
 {
 	struct i387_fxsave_struct *fxsave = &tsk->thread.fpu.state->fxsave;
@@ -589,223 +570,6 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 }
 
 /*
- * Signal frame handlers.
- */
-
-static inline int save_i387_fsave(struct _fpstate_ia32 __user *buf)
-{
-	struct task_struct *tsk = current;
-	struct i387_fsave_struct *fp = &tsk->thread.fpu.state->fsave;
-
-	fp->status = fp->swd;
-	if (__copy_to_user(buf, fp, sizeof(struct i387_fsave_struct)))
-		return -1;
-	return 1;
-}
-
-static int save_i387_fxsave(struct _fpstate_ia32 __user *buf)
-{
-	struct task_struct *tsk = current;
-	struct i387_fxsave_struct *fx = &tsk->thread.fpu.state->fxsave;
-	struct user_i387_ia32_struct env;
-	int err = 0;
-
-	convert_from_fxsr(&env, tsk);
-	if (__copy_to_user(buf, &env, sizeof(env)))
-		return -1;
-
-	err |= __put_user(fx->swd, &buf->status);
-	err |= __put_user(X86_FXSR_MAGIC, &buf->magic);
-	if (err)
-		return -1;
-
-	if (__copy_to_user(&buf->_fxsr_env[0], fx, xstate_size))
-		return -1;
-	return 1;
-}
-
-static int save_i387_xsave(void __user *buf)
-{
-	struct task_struct *tsk = current;
-	struct _fpstate_ia32 __user *fx = buf;
-	int err = 0;
-
-
-	sanitize_i387_state(tsk);
-
-	/*
-	 * For legacy compatible, we always set FP/SSE bits in the bit
-	 * vector while saving the state to the user context.
-	 * This will enable us capturing any changes(during sigreturn) to
-	 * the FP/SSE bits by the legacy applications which don't touch
-	 * xstate_bv in the xsave header.
-	 *
-	 * xsave aware applications can change the xstate_bv in the xsave
-	 * header as well as change any contents in the memory layout.
-	 * xrestore as part of sigreturn will capture all the changes.
-	 */
-	tsk->thread.fpu.state->xsave.xsave_hdr.xstate_bv |= XSTATE_FPSSE;
-
-	if (save_i387_fxsave(fx) < 0)
-		return -1;
-
-	err = __copy_to_user(&fx->sw_reserved, &fx_sw_reserved_ia32,
-			     sizeof(struct _fpx_sw_bytes));
-	err |= __put_user(FP_XSTATE_MAGIC2,
-			  (__u32 __user *) (buf + sig_xstate_ia32_size
-					    - FP_XSTATE_MAGIC2_SIZE));
-	if (err)
-		return -1;
-
-	return 1;
-}
-
-int save_i387_xstate_ia32(void __user *buf)
-{
-	struct _fpstate_ia32 __user *fp = (struct _fpstate_ia32 __user *) buf;
-	struct task_struct *tsk = current;
-
-	if (!used_math())
-		return 0;
-
-	if (!access_ok(VERIFY_WRITE, buf, sig_xstate_ia32_size))
-		return -EACCES;
-	/*
-	 * This will cause a "finit" to be triggered by the next
-	 * attempted FPU operation by the 'current' process.
-	 */
-	clear_used_math();
-
-	if (!HAVE_HWFP) {
-		return fpregs_soft_get(current, NULL,
-				       0, sizeof(struct user_i387_ia32_struct),
-				       NULL, fp) ? -1 : 1;
-	}
-
-	unlazy_fpu(tsk);
-
-	if (cpu_has_xsave)
-		return save_i387_xsave(fp);
-	if (cpu_has_fxsr)
-		return save_i387_fxsave(fp);
-	else
-		return save_i387_fsave(fp);
-}
-
-static inline int restore_i387_fsave(struct _fpstate_ia32 __user *buf)
-{
-	struct task_struct *tsk = current;
-
-	return __copy_from_user(&tsk->thread.fpu.state->fsave, buf,
-				sizeof(struct i387_fsave_struct));
-}
-
-static int restore_i387_fxsave(struct _fpstate_ia32 __user *buf,
-			       unsigned int size)
-{
-	struct task_struct *tsk = current;
-	struct user_i387_ia32_struct env;
-	int err;
-
-	err = __copy_from_user(&tsk->thread.fpu.state->fxsave, &buf->_fxsr_env[0],
-			       size);
-	/* mxcsr reserved bits must be masked to zero for security reasons */
-	tsk->thread.fpu.state->fxsave.mxcsr &= mxcsr_feature_mask;
-	if (err || __copy_from_user(&env, buf, sizeof(env)))
-		return 1;
-	convert_to_fxsr(tsk, &env);
-
-	return 0;
-}
-
-static int restore_i387_xsave(void __user *buf)
-{
-	struct _fpx_sw_bytes fx_sw_user;
-	struct _fpstate_ia32 __user *fx_user =
-			((struct _fpstate_ia32 __user *) buf);
-	struct i387_fxsave_struct __user *fx =
-		(struct i387_fxsave_struct __user *) &fx_user->_fxsr_env[0];
-	struct xsave_hdr_struct *xsave_hdr =
-				&current->thread.fpu.state->xsave.xsave_hdr;
-	u64 mask;
-	int err;
-
-	if (check_for_xstate(fx, buf, &fx_sw_user))
-		goto fx_only;
-
-	mask = fx_sw_user.xstate_bv;
-
-	err = restore_i387_fxsave(buf, fx_sw_user.xstate_size);
-
-	xsave_hdr->xstate_bv &= pcntxt_mask;
-	/*
-	 * These bits must be zero.
-	 */
-	xsave_hdr->reserved1[0] = xsave_hdr->reserved1[1] = 0;
-
-	/*
-	 * Init the state that is not present in the memory layout
-	 * and enabled by the OS.
-	 */
-	mask = ~(pcntxt_mask & ~mask);
-	xsave_hdr->xstate_bv &= mask;
-
-	return err;
-fx_only:
-	/*
-	 * Couldn't find the extended state information in the memory
-	 * layout. Restore the FP/SSE and init the other extended state
-	 * enabled by the OS.
-	 */
-	xsave_hdr->xstate_bv = XSTATE_FPSSE;
-	return restore_i387_fxsave(buf, sizeof(struct i387_fxsave_struct));
-}
-
-int restore_i387_xstate_ia32(void __user *buf)
-{
-	int err;
-	struct task_struct *tsk = current;
-	struct _fpstate_ia32 __user *fp = (struct _fpstate_ia32 __user *) buf;
-
-	if (HAVE_HWFP)
-		clear_fpu(tsk);
-
-	if (!buf) {
-		if (used_math()) {
-			clear_fpu(tsk);
-			clear_used_math();
-		}
-
-		return 0;
-	} else
-		if (!access_ok(VERIFY_READ, buf, sig_xstate_ia32_size))
-			return -EACCES;
-
-	if (!used_math()) {
-		err = init_fpu(tsk);
-		if (err)
-			return err;
-	}
-
-	if (HAVE_HWFP) {
-		if (cpu_has_xsave)
-			err = restore_i387_xsave(buf);
-		else if (cpu_has_fxsr)
-			err = restore_i387_fxsave(fp, sizeof(struct
-							   i387_fxsave_struct));
-		else
-			err = restore_i387_fsave(fp);
-	} else {
-		err = fpregs_soft_set(current, NULL,
-				      0, sizeof(struct user_i387_ia32_struct),
-				      NULL, fp) != 0;
-	}
-	set_used_math();
-
-	return err;
-}
-
-/*
  * FPU state for core dumps.
  * This is only used for a.out dumps now.
  * It is declared generically using elf_fpregset_t (which is
diff --git a/arch/x86/kernel/probe_roms.c b/arch/x86/kernel/probe_roms.c
index 0bc72e2..d5f15c3 100644
--- a/arch/x86/kernel/probe_roms.c
+++ b/arch/x86/kernel/probe_roms.c
@@ -150,7 +150,7 @@ static struct resource *find_oprom(struct pci_dev *pdev)
 	return oprom;
 }
 
-void *pci_map_biosrom(struct pci_dev *pdev)
+void __iomem *pci_map_biosrom(struct pci_dev *pdev)
 {
 	struct resource *oprom = find_oprom(pdev);
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ef6a845..dc3567e 100644
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
@@ -97,16 +95,6 @@ void arch_task_cache_init(void)
 				  SLAB_PANIC | SLAB_NOTRACK, NULL);
 }
 
-static inline void drop_fpu(struct task_struct *tsk)
-{
-	/*
-	 * Forget coprocessor state..
-	 */
-	tsk->fpu_counter = 0;
-	clear_fpu(tsk);
-	clear_used_math();
-}
-
 /*
  * Free current thread data structures etc..
  */
@@ -163,7 +151,13 @@ void flush_thread(void)
 
 	flush_ptrace_hw_breakpoint(tsk);
 	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
-	drop_fpu(tsk);
+	drop_init_fpu(tsk);
+	/*
+	 * Free the FPU state for non xsave platforms. They get reallocated
+	 * lazily at the first use.
+	 */
+	if (!use_eager_fpu())
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
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index c4c6a5c..861a9d1 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1332,9 +1332,6 @@ static const struct user_regset_view user_x86_64_view = {
 #define genregs32_get		genregs_get
 #define genregs32_set		genregs_set
 
-#define user_i387_ia32_struct	user_i387_struct
-#define user32_fxsr_struct	user_fxsr_struct
-
 #endif	/* CONFIG_X86_64 */
 
 #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index b280908..e10f96a 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -114,7 +114,7 @@ int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 		regs->orig_ax = -1;		/* disable syscall checks */
 
 		get_user_ex(buf, &sc->fpstate);
-		err |= restore_i387_xstate(buf);
+		err |= restore_xstate_sig(buf, config_enabled(CONFIG_X86_32));
 
 		get_user_ex(*pax, &sc->ax);
 	} get_user_catch(err);
@@ -206,35 +206,32 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 	     void __user **fpstate)
 {
 	/* Default to using normal stack */
+	unsigned long math_size = 0;
 	unsigned long sp = regs->sp;
+	unsigned long buf_fx = 0;
 	int onsigstack = on_sig_stack(sp);
 
-#ifdef CONFIG_X86_64
 	/* redzone */
-	sp -= 128;
-#endif /* CONFIG_X86_64 */
+	if (config_enabled(CONFIG_X86_64))
+		sp -= 128;
 
 	if (!onsigstack) {
 		/* This is the X/Open sanctioned signal stack switching.  */
 		if (ka->sa.sa_flags & SA_ONSTACK) {
 			if (current->sas_ss_size)
 				sp = current->sas_ss_sp + current->sas_ss_size;
-		} else {
-#ifdef CONFIG_X86_32
-			/* This is the legacy signal stack switching. */
-			if ((regs->ss & 0xffff) != __USER_DS &&
-				!(ka->sa.sa_flags & SA_RESTORER) &&
-					ka->sa.sa_restorer)
+		} else if (config_enabled(CONFIG_X86_32) &&
+			   (regs->ss & 0xffff) != __USER_DS &&
+			   !(ka->sa.sa_flags & SA_RESTORER) &&
+			   ka->sa.sa_restorer) {
+				/* This is the legacy signal stack switching. */
 				sp = (unsigned long) ka->sa.sa_restorer;
-#endif /* CONFIG_X86_32 */
 		}
 	}
 
 	if (used_math()) {
-		sp -= sig_xstate_size;
-#ifdef CONFIG_X86_64
-		sp = round_down(sp, 64);
-#endif /* CONFIG_X86_64 */
+		sp = alloc_mathframe(sp, config_enabled(CONFIG_X86_32),
+				     &buf_fx, &math_size);
 		*fpstate = (void __user *)sp;
 	}
 
@@ -247,8 +244,9 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 	if (onsigstack && !likely(on_sig_stack(sp)))
 		return (void __user *)-1L;
 
-	/* save i387 state */
-	if (used_math() && save_i387_xstate(*fpstate) < 0)
+	/* save i387 and extended state */
+	if (used_math() &&
+	    save_xstate_sig(*fpstate, (void __user *)buf_fx, math_size) < 0)
 		return (void __user *)-1L;
 
 	return (void __user *)sp;
@@ -474,6 +472,74 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 }
 #endif /* CONFIG_X86_32 */
 
+static int x32_setup_rt_frame(int sig, struct k_sigaction *ka,
+			      siginfo_t *info, compat_sigset_t *set,
+			      struct pt_regs *regs)
+{
+#ifdef CONFIG_X86_X32_ABI
+	struct rt_sigframe_x32 __user *frame;
+	void __user *restorer;
+	int err = 0;
+	void __user *fpstate = NULL;
+
+	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
+
+	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
+		return -EFAULT;
+
+	if (ka->sa.sa_flags & SA_SIGINFO) {
+		if (copy_siginfo_to_user32(&frame->info, info))
+			return -EFAULT;
+	}
+
+	put_user_try {
+		/* Create the ucontext.  */
+		if (cpu_has_xsave)
+			put_user_ex(UC_FP_XSTATE, &frame->uc.uc_flags);
+		else
+			put_user_ex(0, &frame->uc.uc_flags);
+		put_user_ex(0, &frame->uc.uc_link);
+		put_user_ex(current->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
+		put_user_ex(sas_ss_flags(regs->sp),
+			    &frame->uc.uc_stack.ss_flags);
+		put_user_ex(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
+		put_user_ex(0, &frame->uc.uc__pad0);
+		err |= setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
+					regs, set->sig[0]);
+		err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+
+		if (ka->sa.sa_flags & SA_RESTORER) {
+			restorer = ka->sa.sa_restorer;
+		} else {
+			/* could use a vstub here */
+			restorer = NULL;
+			err |= -EFAULT;
+		}
+		put_user_ex(restorer, &frame->pretcode);
+	} put_user_catch(err);
+
+	if (err)
+		return -EFAULT;
+
+	/* Set up registers for signal handler */
+	regs->sp = (unsigned long) frame;
+	regs->ip = (unsigned long) ka->sa.sa_handler;
+
+	/* We use the x32 calling convention here... */
+	regs->di = sig;
+	regs->si = (unsigned long) &frame->info;
+	regs->dx = (unsigned long) &frame->uc;
+
+	loadsegment(ds, __USER_DS);
+	loadsegment(es, __USER_DS);
+
+	regs->cs = __USER_CS;
+	regs->ss = __USER_DS;
+#endif	/* CONFIG_X86_X32_ABI */
+
+	return 0;
+}
+
 #ifdef CONFIG_X86_32
 /*
  * Atomically swap in the new signal mask, and wait for a signal.
@@ -612,55 +678,22 @@ static int signr_convert(int sig)
 	return sig;
 }
 
-#ifdef CONFIG_X86_32
-
-#define is_ia32	1
-#define ia32_setup_frame	__setup_frame
-#define ia32_setup_rt_frame	__setup_rt_frame
-
-#else /* !CONFIG_X86_32 */
-
-#ifdef CONFIG_IA32_EMULATION
-#define is_ia32	test_thread_flag(TIF_IA32)
-#else /* !CONFIG_IA32_EMULATION */
-#define is_ia32	0
-#endif /* CONFIG_IA32_EMULATION */
-
-#ifdef CONFIG_X86_X32_ABI
-#define is_x32	test_thread_flag(TIF_X32)
-
-static int x32_setup_rt_frame(int sig, struct k_sigaction *ka,
-			      siginfo_t *info, compat_sigset_t *set,
-			      struct pt_regs *regs);
-#else /* !CONFIG_X86_X32_ABI */
-#define is_x32	0
-#endif /* CONFIG_X86_X32_ABI */
-
-int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-		sigset_t *set, struct pt_regs *regs);
-int ia32_setup_frame(int sig, struct k_sigaction *ka,
-		sigset_t *set, struct pt_regs *regs);
-
-#endif /* CONFIG_X86_32 */
-
 static int
 setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		struct pt_regs *regs)
 {
 	int usig = signr_convert(sig);
 	sigset_t *set = sigmask_to_save();
+	compat_sigset_t *cset = (compat_sigset_t *) set;
 
 	/* Set up the stack frame */
-	if (is_ia32) {
+	if (is_ia32_frame()) {
 		if (ka->sa.sa_flags & SA_SIGINFO)
-			return ia32_setup_rt_frame(usig, ka, info, set, regs);
+			return ia32_setup_rt_frame(usig, ka, info, cset, regs);
 		else
-			return ia32_setup_frame(usig, ka, set, regs);
-#ifdef CONFIG_X86_X32_ABI
-	} else if (is_x32) {
-		return x32_setup_rt_frame(usig, ka, info,
-					 (compat_sigset_t *)set, regs);
-#endif
+			return ia32_setup_frame(usig, ka, cset, regs);
+	} else if (is_x32_frame()) {
+		return x32_setup_rt_frame(usig, ka, info, cset, regs);
 	} else {
 		return __setup_rt_frame(sig, ka, info, set, regs);
 	}
@@ -824,72 +857,6 @@ void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
 }
 
 #ifdef CONFIG_X86_X32_ABI
-static int x32_setup_rt_frame(int sig, struct k_sigaction *ka,
-			      siginfo_t *info, compat_sigset_t *set,
-			      struct pt_regs *regs)
-{
-	struct rt_sigframe_x32 __user *frame;
-	void __user *restorer;
-	int err = 0;
-	void __user *fpstate = NULL;
-
-	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
-
-	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		return -EFAULT;
-
-	if (ka->sa.sa_flags & SA_SIGINFO) {
-		if (copy_siginfo_to_user32(&frame->info, info))
-			return -EFAULT;
-	}
-
-	put_user_try {
-		/* Create the ucontext.  */
-		if (cpu_has_xsave)
-			put_user_ex(UC_FP_XSTATE, &frame->uc.uc_flags);
-		else
-			put_user_ex(0, &frame->uc.uc_flags);
-		put_user_ex(0, &frame->uc.uc_link);
-		put_user_ex(current->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
-		put_user_ex(sas_ss_flags(regs->sp),
-			    &frame->uc.uc_stack.ss_flags);
-		put_user_ex(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
-		put_user_ex(0, &frame->uc.uc__pad0);
-		err |= setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
-					regs, set->sig[0]);
-		err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
-
-		if (ka->sa.sa_flags & SA_RESTORER) {
-			restorer = ka->sa.sa_restorer;
-		} else {
-			/* could use a vstub here */
-			restorer = NULL;
-			err |= -EFAULT;
-		}
-		put_user_ex(restorer, &frame->pretcode);
-	} put_user_catch(err);
-
-	if (err)
-		return -EFAULT;
-
-	/* Set up registers for signal handler */
-	regs->sp = (unsigned long) frame;
-	regs->ip = (unsigned long) ka->sa.sa_handler;
-
-	/* We use the x32 calling convention here... */
-	regs->di = sig;
-	regs->si = (unsigned long) &frame->info;
-	regs->dx = (unsigned long) &frame->uc;
-
-	loadsegment(ds, __USER_DS);
-	loadsegment(es, __USER_DS);
-
-	regs->cs = __USER_CS;
-	regs->ss = __USER_DS;
-
-	return 0;
-}
-
 asmlinkage long sys32_x32_rt_sigreturn(struct pt_regs *regs)
 {
 	struct rt_sigframe_x32 __user *frame;
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b481341..4f4aba0 100644
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
+	BUG_ON(use_eager_fpu());
+
 #ifdef CONFIG_MATH_EMULATION
 	if (read_cr0() & X86_CR0_EM) {
 		struct math_emu_info info = { };
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 3d3e207..4e89b3d 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -10,9 +10,7 @@
 #include <linux/compat.h>
 #include <asm/i387.h>
 #include <asm/fpu-internal.h>
-#ifdef CONFIG_IA32_EMULATION
-#include <asm/sigcontext32.h>
-#endif
+#include <asm/sigframe.h>
 #include <asm/xcr.h>
 
 /*
@@ -23,13 +21,9 @@ u64 pcntxt_mask;
 /*
  * Represents init state for the supported extended state.
  */
-static struct xsave_struct *init_xstate_buf;
-
-struct _fpx_sw_bytes fx_sw_reserved;
-#ifdef CONFIG_IA32_EMULATION
-struct _fpx_sw_bytes fx_sw_reserved_ia32;
-#endif
+struct xsave_struct *init_xstate_buf;
 
+static struct _fpx_sw_bytes fx_sw_reserved, fx_sw_reserved_ia32;
 static unsigned int *xstate_offsets, *xstate_sizes, xstate_features;
 
 /*
@@ -44,9 +38,9 @@ static unsigned int *xstate_offsets, *xstate_sizes, xstate_features;
  */
 void __sanitize_i387_state(struct task_struct *tsk)
 {
-	u64 xstate_bv;
-	int feature_bit = 0x2;
 	struct i387_fxsave_struct *fx = &tsk->thread.fpu.state->fxsave;
+	int feature_bit = 0x2;
+	u64 xstate_bv;
 
 	if (!fx)
 		return;
@@ -104,213 +98,326 @@ void __sanitize_i387_state(struct task_struct *tsk)
  * Check for the presence of extended state information in the
  * user fpstate pointer in the sigcontext.
  */
-int check_for_xstate(struct i387_fxsave_struct __user *buf,
-		     void __user *fpstate,
-		     struct _fpx_sw_bytes *fx_sw_user)
+static inline int check_for_xstate(struct i387_fxsave_struct __user *buf,
+				   void __user *fpstate,
+				   struct _fpx_sw_bytes *fx_sw)
 {
 	int min_xstate_size = sizeof(struct i387_fxsave_struct) +
 			      sizeof(struct xsave_hdr_struct);
 	unsigned int magic2;
-	int err;
 
-	err = __copy_from_user(fx_sw_user, &buf->sw_reserved[0],
-			       sizeof(struct _fpx_sw_bytes));
-	if (err)
-		return -EFAULT;
+	if (__copy_from_user(fx_sw, &buf->sw_reserved[0], sizeof(*fx_sw)))
+		return -1;
 
-	/*
-	 * First Magic check failed.
-	 */
-	if (fx_sw_user->magic1 != FP_XSTATE_MAGIC1)
-		return -EINVAL;
+	/* Check for the first magic field and other error scenarios. */
+	if (fx_sw->magic1 != FP_XSTATE_MAGIC1 ||
+	    fx_sw->xstate_size < min_xstate_size ||
+	    fx_sw->xstate_size > xstate_size ||
+	    fx_sw->xstate_size > fx_sw->extended_size)
+		return -1;
 
 	/*
-	 * Check for error scenarios.
-	 */
-	if (fx_sw_user->xstate_size < min_xstate_size ||
-	    fx_sw_user->xstate_size > xstate_size ||
-	    fx_sw_user->xstate_size > fx_sw_user->extended_size)
-		return -EINVAL;
-
-	err = __get_user(magic2, (__u32 *) (((void *)fpstate) +
-					    fx_sw_user->extended_size -
-					    FP_XSTATE_MAGIC2_SIZE));
-	if (err)
-		return err;
-	/*
 	 * Check for the presence of second magic word at the end of memory
 	 * layout. This detects the case where the user just copied the legacy
 	 * fpstate layout with out copying the extended state information
 	 * in the memory layout.
 	 */
-	if (magic2 != FP_XSTATE_MAGIC2)
-		return -EFAULT;
+	if (__get_user(magic2, (__u32 __user *)(fpstate + fx_sw->xstate_size))
+	    || magic2 != FP_XSTATE_MAGIC2)
+		return -1;
 
 	return 0;
 }
 
-#ifdef CONFIG_X86_64
 /*
  * Signal frame handlers.
  */
-
-int save_i387_xstate(void __user *buf)
+static inline int save_fsave_header(struct task_struct *tsk, void __user *buf)
 {
-	struct task_struct *tsk = current;
-	int err = 0;
-
-	if (!access_ok(VERIFY_WRITE, buf, sig_xstate_size))
-		return -EACCES;
+	if (use_fxsr()) {
+		struct xsave_struct *xsave = &tsk->thread.fpu.state->xsave;
+		struct user_i387_ia32_struct env;
+		struct _fpstate_ia32 __user *fp = buf;
 
-	BUG_ON(sig_xstate_size < xstate_size);
+		convert_from_fxsr(&env, tsk);
 
-	if ((unsigned long)buf % 64)
-		pr_err("%s: bad fpstate %p\n", __func__, buf);
-
-	if (!used_math())
-		return 0;
-
-	if (user_has_fpu()) {
-		if (use_xsave())
-			err = xsave_user(buf);
-		else
-			err = fxsave_user(buf);
-
-		if (err)
-			return err;
-		user_fpu_end();
+		if (__copy_to_user(buf, &env, sizeof(env)) ||
+		    __put_user(xsave->i387.swd, &fp->status) ||
+		    __put_user(X86_FXSR_MAGIC, &fp->magic))
+			return -1;
 	} else {
-		sanitize_i387_state(tsk);
-		if (__copy_to_user(buf, &tsk->thread.fpu.state->fxsave,
-				   xstate_size))
+		struct i387_fsave_struct __user *fp = buf;
+		u32 swd;
+		if (__get_user(swd, &fp->swd) || __put_user(swd, &fp->status))
 			return -1;
 	}
 
-	clear_used_math(); /* trigger finit */
+	return 0;
+}
 
-	if (use_xsave()) {
-		struct _fpstate __user *fx = buf;
-		struct _xstate __user *x = buf;
-		u64 xstate_bv;
+static inline int save_xstate_epilog(void __user *buf, int ia32_frame)
+{
+	struct xsave_struct __user *x = buf;
+	struct _fpx_sw_bytes *sw_bytes;
+	u32 xstate_bv;
+	int err;
 
-		err = __copy_to_user(&fx->sw_reserved, &fx_sw_reserved,
-				     sizeof(struct _fpx_sw_bytes));
+	/* Setup the bytes not touched by the [f]xsave and reserved for SW. */
+	sw_bytes = ia32_frame ? &fx_sw_reserved_ia32 : &fx_sw_reserved;
+	err = __copy_to_user(&x->i387.sw_reserved, sw_bytes, sizeof(*sw_bytes));
 
-		err |= __put_user(FP_XSTATE_MAGIC2,
-				  (__u32 __user *) (buf + sig_xstate_size
-						    - FP_XSTATE_MAGIC2_SIZE));
+	if (!use_xsave())
+		return err;
 
-		/*
-		 * Read the xstate_bv which we copied (directly from the cpu or
-		 * from the state in task struct) to the user buffers and
-		 * set the FP/SSE bits.
-		 */
-		err |= __get_user(xstate_bv, &x->xstate_hdr.xstate_bv);
+	err |= __put_user(FP_XSTATE_MAGIC2, (__u32 *)(buf + xstate_size));
 
-		/*
-		 * For legacy compatible, we always set FP/SSE bits in the bit
-		 * vector while saving the state to the user context. This will
-		 * enable us capturing any changes(during sigreturn) to
-		 * the FP/SSE bits by the legacy applications which don't touch
-		 * xstate_bv in the xsave header.
-		 *
-		 * xsave aware apps can change the xstate_bv in the xsave
-		 * header as well as change any contents in the memory layout.
-		 * xrestore as part of sigreturn will capture all the changes.
-		 */
-		xstate_bv |= XSTATE_FPSSE;
+	/*
+	 * Read the xstate_bv which we copied (directly from the cpu or
+	 * from the state in task struct) to the user buffers.
+	 */
+	err |= __get_user(xstate_bv, (__u32 *)&x->xsave_hdr.xstate_bv);
 
-		err |= __put_user(xstate_bv, &x->xstate_hdr.xstate_bv);
+	/*
+	 * For legacy compatible, we always set FP/SSE bits in the bit
+	 * vector while saving the state to the user context. This will
+	 * enable us capturing any changes(during sigreturn) to
+	 * the FP/SSE bits by the legacy applications which don't touch
+	 * xstate_bv in the xsave header.
+	 *
+	 * xsave aware apps can change the xstate_bv in the xsave
+	 * header as well as change any contents in the memory layout.
+	 * xrestore as part of sigreturn will capture all the changes.
+	 */
+	xstate_bv |= XSTATE_FPSSE;
 
-		if (err)
-			return err;
-	}
+	err |= __put_user(xstate_bv, (__u32 *)&x->xsave_hdr.xstate_bv);
 
-	return 1;
+	return err;
+}
+
+static inline int save_user_xstate(struct xsave_struct __user *buf)
+{
+	int err;
+
+	if (use_xsave())
+		err = xsave_user(buf);
+	else if (use_fxsr())
+		err = fxsave_user((struct i387_fxsave_struct __user *) buf);
+	else
+		err = fsave_user((struct i387_fsave_struct __user *) buf);
+
+	if (unlikely(err) && __clear_user(buf, xstate_size))
+		err = -EFAULT;
+	return err;
 }
 
 /*
- * Restore the extended state if present. Otherwise, restore the FP/SSE
- * state.
+ * Save the fpu, extended register state to the user signal frame.
+ *
+ * 'buf_fx' is the 64-byte aligned pointer at which the [f|fx|x]save
+ *  state is copied.
+ *  'buf' points to the 'buf_fx' or to the fsave header followed by 'buf_fx'.
+ *
+ *	buf == buf_fx for 64-bit frames and 32-bit fsave frame.
+ *	buf != buf_fx for 32-bit frames with fxstate.
+ *
+ * If the fpu, extended register state is live, save the state directly
+ * to the user frame pointed by the aligned pointer 'buf_fx'. Otherwise,
+ * copy the thread's fpu state to the user frame starting at 'buf_fx'.
+ *
+ * If this is a 32-bit frame with fxstate, put a fsave header before
+ * the aligned state at 'buf_fx'.
+ *
+ * For [f]xsave state, update the SW reserved fields in the [f]xsave frame
+ * indicating the absence/presence of the extended state to the user.
  */
-static int restore_user_xstate(void __user *buf)
+int save_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 {
-	struct _fpx_sw_bytes fx_sw_user;
-	u64 mask;
-	int err;
+	struct xsave_struct *xsave = &current->thread.fpu.state->xsave;
+	struct task_struct *tsk = current;
+	int ia32_fxstate = (buf != buf_fx);
 
-	if (((unsigned long)buf % 64) ||
-	     check_for_xstate(buf, buf, &fx_sw_user))
-		goto fx_only;
+	ia32_fxstate &= (config_enabled(CONFIG_X86_32) ||
+			 config_enabled(CONFIG_IA32_EMULATION));
 
-	mask = fx_sw_user.xstate_bv;
+	if (!access_ok(VERIFY_WRITE, buf, size))
+		return -EACCES;
 
-	/*
-	 * restore the state passed by the user.
-	 */
-	err = xrestore_user(buf, mask);
-	if (err)
-		return err;
+	if (!HAVE_HWFP)
+		return fpregs_soft_get(current, NULL, 0,
+			sizeof(struct user_i387_ia32_struct), NULL,
+			(struct _fpstate_ia32 __user *) buf) ? -1 : 1;
 
-	/*
-	 * init the state skipped by the user.
-	 */
-	mask = pcntxt_mask & ~mask;
-	if (unlikely(mask))
-		xrstor_state(init_xstate_buf, mask);
+	if (user_has_fpu()) {
+		/* Save the live register state to the user directly. */
+		if (save_user_xstate(buf_fx))
+			return -1;
+		/* Update the thread's fxstate to save the fsave header. */
+		if (ia32_fxstate)
+			fpu_fxsave(&tsk->thread.fpu);
+	} else {
+		sanitize_i387_state(tsk);
+		if (__copy_to_user(buf_fx, xsave, xstate_size))
+			return -1;
+	}
+
+	/* Save the fsave header for the 32-bit frames. */
+	if ((ia32_fxstate || !use_fxsr()) && save_fsave_header(tsk, buf))
+		return -1;
+
+	if (use_fxsr() && save_xstate_epilog(buf_fx, ia32_fxstate))
+		return -1;
+
+	drop_init_fpu(tsk);	/* trigger finit */
 
 	return 0;
+}
 
-fx_only:
-	/*
-	 * couldn't find the extended state information in the
-	 * memory layout. Restore just the FP/SSE and init all
-	 * the other extended state.
-	 */
-	xrstor_state(init_xstate_buf, pcntxt_mask & ~XSTATE_FPSSE);
-	return fxrstor_checking((__force struct i387_fxsave_struct *)buf);
+static inline void
+sanitize_restored_xstate(struct task_struct *tsk,
+			 struct user_i387_ia32_struct *ia32_env,
+			 u64 xstate_bv, int fx_only)
+{
+	struct xsave_struct *xsave = &tsk->thread.fpu.state->xsave;
+	struct xsave_hdr_struct *xsave_hdr = &xsave->xsave_hdr;
+
+	if (use_xsave()) {
+		/* These bits must be zero. */
+		xsave_hdr->reserved1[0] = xsave_hdr->reserved1[1] = 0;
+
+		/*
+		 * Init the state that is not present in the memory
+		 * layout and not enabled by the OS.
+		 */
+		if (fx_only)
+			xsave_hdr->xstate_bv = XSTATE_FPSSE;
+		else
+			xsave_hdr->xstate_bv &= (pcntxt_mask & xstate_bv);
+	}
+
+	if (use_fxsr()) {
+		/*
+		 * mscsr reserved bits must be masked to zero for security
+		 * reasons.
+		 */
+		xsave->i387.mxcsr &= mxcsr_feature_mask;
+
+		convert_to_fxsr(tsk, ia32_env);
+	}
 }
 
 /*
- * This restores directly out of user space. Exceptions are handled.
+ * Restore the extended state if present. Otherwise, restore the FP/SSE state.
  */
-int restore_i387_xstate(void __user *buf)
+static inline int restore_user_xstate(void __user *buf, u64 xbv, int fx_only)
 {
+	if (use_xsave()) {
+		if ((unsigned long)buf % 64 || fx_only) {
+			u64 init_bv = pcntxt_mask & ~XSTATE_FPSSE;
+			xrstor_state(init_xstate_buf, init_bv);
+			return fxrstor_checking((__force void *) buf);
+		} else {
+			u64 init_bv = pcntxt_mask & ~xbv;
+			if (unlikely(init_bv))
+				xrstor_state(init_xstate_buf, init_bv);
+			return xrestore_user(buf, xbv);
+		}
+	} else if (use_fxsr()) {
+		return fxrstor_checking((__force void *) buf);
+	} else
+		return frstor_checking((__force void *) buf);
+}
+
+int __restore_xstate_sig(void __user *buf, void __user *buf_fx, int size)
+{
+	int ia32_fxstate = (buf != buf_fx);
 	struct task_struct *tsk = current;
-	int err = 0;
+	int state_size = xstate_size;
+	u64 xstate_bv = 0;
+	int fx_only = 0;
+
+	ia32_fxstate &= (config_enabled(CONFIG_X86_32) ||
+			 config_enabled(CONFIG_IA32_EMULATION));
 
 	if (!buf) {
-		if (used_math())
-			goto clear;
+		drop_init_fpu(tsk);
 		return 0;
-	} else
-		if (!access_ok(VERIFY_READ, buf, sig_xstate_size))
-			return -EACCES;
+	}
 
-	if (!used_math()) {
-		err = init_fpu(tsk);
-		if (err)
-			return err;
+	if (!access_ok(VERIFY_READ, buf, size))
+		return -EACCES;
+
+	if (!used_math() && init_fpu(tsk))
+		return -1;
+
+	if (!HAVE_HWFP) {
+		return fpregs_soft_set(current, NULL,
+				       0, sizeof(struct user_i387_ia32_struct),
+				       NULL, buf) != 0;
 	}
 
-	user_fpu_begin();
-	if (use_xsave())
-		err = restore_user_xstate(buf);
-	else
-		err = fxrstor_checking((__force struct i387_fxsave_struct *)
-				       buf);
-	if (unlikely(err)) {
+	if (use_xsave()) {
+		struct _fpx_sw_bytes fx_sw_user;
+		if (unlikely(check_for_xstate(buf_fx, buf_fx, &fx_sw_user))) {
+			/*
+			 * Couldn't find the extended state information in the
+			 * memory layout. Restore just the FP/SSE and init all
+			 * the other extended state.
+			 */
+			state_size = sizeof(struct i387_fxsave_struct);
+			fx_only = 1;
+		} else {
+			state_size = fx_sw_user.xstate_size;
+			xstate_bv = fx_sw_user.xstate_bv;
+		}
+	}
+
+	if (ia32_fxstate) {
+		/*
+		 * For 32-bit frames with fxstate, copy the user state to the
+		 * thread's fpu state, reconstruct fxstate from the fsave
+		 * header. Sanitize the copied state etc.
+		 */
+		struct xsave_struct *xsave = &tsk->thread.fpu.state->xsave;
+		struct user_i387_ia32_struct env;
+		int err = 0;
+
+		/*
+		 * Drop the current fpu which clears used_math(). This ensures
+		 * that any context-switch during the copy of the new state,
+		 * avoids the intermediate state from getting restored/saved.
+		 * Thus avoiding the new restored state from getting corrupted.
+		 * We will be ready to restore/save the state only after
+		 * set_used_math() is again set.
+		 */
+		drop_fpu(tsk);
+
+		if (__copy_from_user(xsave, buf_fx, state_size) ||
+		    __copy_from_user(&env, buf, sizeof(env))) {
+			err = -1;
+		} else {
+			sanitize_restored_xstate(tsk, &env, xstate_bv, fx_only);
+			set_used_math();
+		}
+
+		if (use_eager_fpu())
+			math_state_restore();
+
+		return err;
+	} else {
 		/*
-		 * Encountered an error while doing the restore from the
-		 * user buffer, clear the fpu state.
+		 * For 64-bit frames and 32-bit fsave frames, restore the user
+		 * state to the registers directly (with exceptions handled).
 		 */
-clear:
-		clear_fpu(tsk);
-		clear_used_math();
+		user_fpu_begin();
+		if (restore_user_xstate(buf_fx, xstate_bv, fx_only)) {
+			drop_init_fpu(tsk);
+			return -1;
+		}
 	}
-	return err;
+
+	return 0;
 }
-#endif
 
 /*
  * Prepare the SW reserved portion of the fxsave memory layout, indicating
@@ -321,31 +428,22 @@ clear:
  */
 static void prepare_fx_sw_frame(void)
 {
-	int size_extended = (xstate_size - sizeof(struct i387_fxsave_struct)) +
-			     FP_XSTATE_MAGIC2_SIZE;
+	int fsave_header_size = sizeof(struct i387_fsave_struct);
+	int size = xstate_size + FP_XSTATE_MAGIC2_SIZE;
 
-	sig_xstate_size = sizeof(struct _fpstate) + size_extended;
-
-#ifdef CONFIG_IA32_EMULATION
-	sig_xstate_ia32_size = sizeof(struct _fpstate_ia32) + size_extended;
-#endif
-
-	memset(&fx_sw_reserved, 0, sizeof(fx_sw_reserved));
+	if (config_enabled(CONFIG_X86_32))
+		size += fsave_header_size;
 
 	fx_sw_reserved.magic1 = FP_XSTATE_MAGIC1;
-	fx_sw_reserved.extended_size = sig_xstate_size;
+	fx_sw_reserved.extended_size = size;
 	fx_sw_reserved.xstate_bv = pcntxt_mask;
 	fx_sw_reserved.xstate_size = xstate_size;
-#ifdef CONFIG_IA32_EMULATION
-	memcpy(&fx_sw_reserved_ia32, &fx_sw_reserved,
-	       sizeof(struct _fpx_sw_bytes));
-	fx_sw_reserved_ia32.extended_size = sig_xstate_ia32_size;
-#endif
-}
 
-#ifdef CONFIG_X86_64
-unsigned int sig_xstate_size = sizeof(struct _fpstate);
-#endif
+	if (config_enabled(CONFIG_IA32_EMULATION)) {
+		fx_sw_reserved_ia32 = fx_sw_reserved;
+		fx_sw_reserved_ia32.extended_size += fsave_header_size;
+	}
+}
 
 /*
  * Enable the extended processor state save/restore feature
@@ -384,19 +482,21 @@ static void __init setup_xstate_features(void)
 /*
  * setup the xstate image representing the init state
  */
-static void __init setup_xstate_init(void)
+static void __init setup_init_fpu_buf(void)
 {
-	setup_xstate_features();
-
 	/*
 	 * Setup init_xstate_buf to represent the init state of
 	 * all the features managed by the xsave
 	 */
 	init_xstate_buf = alloc_bootmem_align(xstate_size,
 					      __alignof__(struct xsave_struct));
-	init_xstate_buf->i387.mxcsr = MXCSR_DEFAULT;
+	fx_finit(&init_xstate_buf->i387);
+
+	if (!cpu_has_xsave)
+		return;
+
+	setup_xstate_features();
 
-	clts();
 	/*
 	 * Init all the features state with header_bv being 0x0
 	 */
@@ -406,9 +506,21 @@ static void __init setup_xstate_init(void)
 	 * of any feature which is not represented by all zero's.
 	 */
 	xsave_state(init_xstate_buf, -1);
-	stts();
 }
 
+static enum { AUTO, ENABLE, DISABLE } eagerfpu = AUTO;
+static int __init eager_fpu_setup(char *s)
+{
+	if (!strcmp(s, "on"))
+		eagerfpu = ENABLE;
+	else if (!strcmp(s, "off"))
+		eagerfpu = DISABLE;
+	else if (!strcmp(s, "auto"))
+		eagerfpu = AUTO;
+	return 1;
+}
+__setup("eagerfpu=", eager_fpu_setup);
+
 /*
  * Enable and initialize the xsave feature.
  */
@@ -445,8 +557,11 @@ static void __init xstate_enable_boot_cpu(void)
 
 	update_regset_xstate_info(xstate_size, pcntxt_mask);
 	prepare_fx_sw_frame();
+	setup_init_fpu_buf();
 
-	setup_xstate_init();
+	/* Auto enable eagerfpu for xsaveopt */
+	if (cpu_has_xsaveopt && eagerfpu != DISABLE)
+		eagerfpu = ENABLE;
 
 	pr_info("enabled xstate_bv 0x%llx, cntxt size 0x%x\n",
 		pcntxt_mask, xstate_size);
@@ -471,3 +586,43 @@ void __cpuinit xsave_init(void)
 	next_func = xstate_enable;
 	this_func();
 }
+
+static inline void __init eager_fpu_init_bp(void)
+{
+	current->thread.fpu.state =
+	    alloc_bootmem_align(xstate_size, __alignof__(struct xsave_struct));
+	if (!init_xstate_buf)
+		setup_init_fpu_buf();
+}
+
+void __cpuinit eager_fpu_init(void)
+{
+	static __refdata void (*boot_func)(void) = eager_fpu_init_bp;
+
+	clear_used_math();
+	current_thread_info()->status = 0;
+
+	if (eagerfpu == ENABLE)
+		setup_force_cpu_cap(X86_FEATURE_EAGER_FPU);
+
+	if (!cpu_has_eager_fpu) {
+		stts();
+		return;
+	}
+
+	if (boot_func) {
+		boot_func();
+		boot_func = NULL;
+	}
+
+	/*
+	 * This is same as math_state_restore(). But use_xsave() is
+	 * not yet patched to use math_state_restore().
+	 */
+	init_fpu(current);
+	__thread_fpu_begin(current);
+	if (cpu_has_xsave)
+		xrstor_state(init_xstate_buf, -1);
+	else
+		fxrstor_checking(&init_xstate_buf->i387);
+}
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c00f03d..70dfcec 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1493,8 +1493,12 @@ static void __vmx_load_host_state(struct vcpu_vmx *vmx)
 #ifdef CONFIG_X86_64
 	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
 #endif
-	if (user_has_fpu())
-		clts();
+	/*
+	 * If the FPU is not active (through the host task or
+	 * the guest vcpu), then restore the cr0.TS bit.
+	 */
+	if (!user_has_fpu() && !vmx->vcpu.guest_fpu_loaded)
+		stts();
 	load_gdt(&__get_cpu_var(host_gdt));
 }
 
@@ -3730,7 +3734,7 @@ static void vmx_set_constant_host_state(void)
 	unsigned long tmpl;
 	struct desc_ptr dt;
 
-	vmcs_writel(HOST_CR0, read_cr0() | X86_CR0_TS);  /* 22.2.3 */
+	vmcs_writel(HOST_CR0, read_cr0() & ~X86_CR0_TS);  /* 22.2.3 */
 	vmcs_writel(HOST_CR4, read_cr4());  /* 22.2.3, 22.2.5 */
 	vmcs_writel(HOST_CR3, read_cr3());  /* 22.2.3  FIXME: shadow tables */
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 148ed66..02b2cd5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5972,7 +5972,7 @@ void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 	 */
 	kvm_put_guest_xcr0(vcpu);
 	vcpu->guest_fpu_loaded = 1;
-	unlazy_fpu(current);
+	__kernel_fpu_begin();
 	fpu_restore_checking(&vcpu->arch.guest_fpu);
 	trace_kvm_fpu(1);
 }
@@ -5986,6 +5986,7 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 
 	vcpu->guest_fpu_loaded = 0;
 	fpu_save_init(&vcpu->arch.guest_fpu);
+	__kernel_fpu_end();
 	++vcpu->stat.fpu_reload;
 	kvm_make_request(KVM_REQ_DEACTIVATE_FPU, vcpu);
 	trace_kvm_fpu(0);
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index 39809035..4af12e1 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -203,8 +203,8 @@ void lguest_arch_run_guest(struct lg_cpu *cpu)
 	 * we set it now, so we can trap and pass that trap to the Guest if it
 	 * uses the FPU.
 	 */
-	if (cpu->ts)
-		unlazy_fpu(current);
+	if (cpu->ts && user_has_fpu())
+		stts();
 
 	/*
 	 * SYSENTER is an optimized way of doing system calls.  We can't allow
@@ -234,6 +234,10 @@ void lguest_arch_run_guest(struct lg_cpu *cpu)
 	 if (boot_cpu_has(X86_FEATURE_SEP))
 		wrmsr(MSR_IA32_SYSENTER_CS, __KERNEL_CS, 0);
 
+	/* Clear the host TS bit if it was set above. */
+	if (cpu->ts && user_has_fpu())
+		clts();
+
 	/*
 	 * If the Guest page faulted, then the cr2 register will tell us the
 	 * bad virtual address.  We have to grab this now, because once we
@@ -249,7 +253,7 @@ void lguest_arch_run_guest(struct lg_cpu *cpu)
 	 * a different CPU. So all the critical stuff should be done
 	 * before this.
 	 */
-	else if (cpu->regs->trapnum == 7)
+	else if (cpu->regs->trapnum == 7 && !user_has_fpu())
 		math_state_restore();
 }
 

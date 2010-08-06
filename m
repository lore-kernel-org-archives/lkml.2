Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965829Ab0HFXDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 19:03:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:55045 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935903Ab0HFXC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 19:02:57 -0400
Date: Fri, 6 Aug 2010 23:02:25 GMT
Message-Id: <201008062302.o76N2Pl3016694@hera.kernel.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/xsave for 2.6.36
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 06 Aug 2010 23:02:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ This topic needs to be applied on top of x86/cpu ]

Hi Linus,

The following changes since commit e8c534ec068af1a0845aceda373a9bfd2de62030:

  x86: Fix keeping track of AMD C1E (2010-08-02 08:45:56 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-xsave-for-linus

H. Peter Anvin (1):
      x86, xsave: Make xstate_enable_boot_cpu() __init, protect on CPU 0

Robert Richter (8):
      x86, xsave: Do not include asm/i387.h in asm/xsave.h
      x86, xsave: 32/64 bit boot cpu check unification in initialization
      x86, xsave: Move boot cpu initialization to xsave_init()
      x86, xsave: Separate fpu and xsave initialization
      x86, xsave: Introduce xstate enable functions
      x86, xsave: Check cpuid level for XSTATE_CPUID (0x0d)
      x86, xsave: Make init_xstate_buf static
      x86, xsave: Add __init attribute to setup_xstate_features()

Suresh Siddha (3):
      x86, xsave: Track the offset, size of state in the xsave layout
      x86, xsave: Sync xsave memory layout with its header for user handling
      x86, xsave: Use xsaveopt in context-switch path when supported

 arch/x86/include/asm/i387.h  |   15 ++++-
 arch/x86/include/asm/xsave.h |   24 +++++--
 arch/x86/kernel/cpu/common.c |   16 +++--
 arch/x86/kernel/i387.c       |   39 +++++++---
 arch/x86/kernel/xsave.c      |  170 +++++++++++++++++++++++++++++++++++++-----
 5 files changed, 222 insertions(+), 42 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index c991b3a..509ddab 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -31,7 +31,6 @@ extern void mxcsr_feature_mask_init(void);
 extern int init_fpu(struct task_struct *child);
 extern asmlinkage void math_state_restore(void);
 extern void __math_state_restore(void);
-extern void init_thread_xstate(void);
 extern int dump_fpu(struct pt_regs *, struct user_i387_struct *);
 
 extern user_regset_active_fn fpregs_active, xfpregs_active;
@@ -58,11 +57,25 @@ extern int restore_i387_xstate_ia32(void __user *buf);
 
 #define X87_FSW_ES (1 << 7)	/* Exception Summary */
 
+static __always_inline __pure bool use_xsaveopt(void)
+{
+	return static_cpu_has(X86_FEATURE_XSAVEOPT);
+}
+
 static __always_inline __pure bool use_xsave(void)
 {
 	return static_cpu_has(X86_FEATURE_XSAVE);
 }
 
+extern void __sanitize_i387_state(struct task_struct *);
+
+static inline void sanitize_i387_state(struct task_struct *tsk)
+{
+	if (!use_xsaveopt())
+		return;
+	__sanitize_i387_state(tsk);
+}
+
 #ifdef CONFIG_X86_64
 
 /* Ignore delayed exceptions from user space */
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 2c4390c..0ae6b99 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -3,7 +3,8 @@
 
 #include <linux/types.h>
 #include <asm/processor.h>
-#include <asm/i387.h>
+
+#define XSTATE_CPUID		0x0000000d
 
 #define XSTATE_FP	0x1
 #define XSTATE_SSE	0x2
@@ -26,10 +27,8 @@
 
 extern unsigned int xstate_size;
 extern u64 pcntxt_mask;
-extern struct xsave_struct *init_xstate_buf;
 extern u64 xstate_fx_sw_bytes[USER_XSTATE_FX_SW_WORDS];
 
-extern void xsave_cntxt_init(void);
 extern void xsave_init(void);
 extern void update_regset_xstate_info(unsigned int size, u64 xstate_mask);
 extern int init_fpu(struct task_struct *child);
@@ -111,12 +110,25 @@ static inline void xrstor_state(struct xsave_struct *fx, u64 mask)
 		     :   "memory");
 }
 
+static inline void xsave_state(struct xsave_struct *fx, u64 mask)
+{
+	u32 lmask = mask;
+	u32 hmask = mask >> 32;
+
+	asm volatile(".byte " REX_PREFIX "0x0f,0xae,0x27\n\t"
+		     : : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
+		     :   "memory");
+}
+
 static inline void fpu_xsave(struct fpu *fpu)
 {
 	/* This, however, we can work around by forcing the compiler to select
 	   an addressing mode that doesn't require extended registers. */
-	__asm__ __volatile__(".byte " REX_PREFIX "0x0f,0xae,0x27"
-			     : : "D" (&(fpu->state->xsave)),
-				 "a" (-1), "d"(-1) : "memory");
+	alternative_input(
+		".byte " REX_PREFIX "0x0f,0xae,0x27",
+		".byte " REX_PREFIX "0x0f,0xae,0x37",
+		X86_FEATURE_XSAVEOPT,
+		[fx] "D" (&fpu->state->xsave), "a" (-1), "d" (-1) :
+		"memory");
 }
 #endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c735830..94c36c7a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -140,10 +140,18 @@ EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 static int __init x86_xsave_setup(char *s)
 {
 	setup_clear_cpu_cap(X86_FEATURE_XSAVE);
+	setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
 	return 1;
 }
 __setup("noxsave", x86_xsave_setup);
 
+static int __init x86_xsaveopt_setup(char *s)
+{
+	setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
+	return 1;
+}
+__setup("noxsaveopt", x86_xsaveopt_setup);
+
 #ifdef CONFIG_X86_32
 static int cachesize_override __cpuinitdata = -1;
 static int disable_x86_serial_nr __cpuinitdata = 1;
@@ -1202,6 +1210,7 @@ void __cpuinit cpu_init(void)
 	dbg_restore_debug_regs();
 
 	fpu_init();
+	xsave_init();
 
 	raw_local_save_flags(kernel_eflags);
 
@@ -1262,12 +1271,7 @@ void __cpuinit cpu_init(void)
 	clear_used_math();
 	mxcsr_feature_mask_init();
 
-	/*
-	 * Boot processor to setup the FP and extended state context info.
-	 */
-	if (smp_processor_id() == boot_cpu_id)
-		init_thread_xstate();
-
+	fpu_init();
 	xsave_init();
 }
 #endif
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 86cef6b..e73c54e 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -59,18 +59,18 @@ void __cpuinit mxcsr_feature_mask_init(void)
 	stts();
 }
 
-void __cpuinit init_thread_xstate(void)
+static void __cpuinit init_thread_xstate(void)
 {
+	/*
+	 * Note that xstate_size might be overwriten later during
+	 * xsave_init().
+	 */
+
 	if (!HAVE_HWFP) {
 		xstate_size = sizeof(struct i387_soft_struct);
 		return;
 	}
 
-	if (cpu_has_xsave) {
-		xsave_cntxt_init();
-		return;
-	}
-
 	if (cpu_has_fxsr)
 		xstate_size = sizeof(struct i387_fxsave_struct);
 #ifdef CONFIG_X86_32
@@ -84,6 +84,7 @@ void __cpuinit init_thread_xstate(void)
  * Called at bootup to set up the initial FPU state that is later cloned
  * into all processes.
  */
+
 void __cpuinit fpu_init(void)
 {
 	unsigned long oldcr0 = read_cr0();
@@ -93,19 +94,24 @@ void __cpuinit fpu_init(void)
 
 	write_cr0(oldcr0 & ~(X86_CR0_TS|X86_CR0_EM)); /* clear TS and EM */
 
-	/*
-	 * Boot processor to setup the FP and extended state context info.
-	 */
 	if (!smp_processor_id())
 		init_thread_xstate();
-	xsave_init();
 
 	mxcsr_feature_mask_init();
 	/* clean state in init */
 	current_thread_info()->status = 0;
 	clear_used_math();
 }
-#endif	/* CONFIG_X86_64 */
+
+#else	/* CONFIG_X86_64 */
+
+void __cpuinit fpu_init(void)
+{
+	if (!smp_processor_id())
+		init_thread_xstate();
+}
+
+#endif	/* CONFIG_X86_32 */
 
 static void fpu_finit(struct fpu *fpu)
 {
@@ -190,6 +196,8 @@ int xfpregs_get(struct task_struct *target, const struct user_regset *regset,
 	if (ret)
 		return ret;
 
+	sanitize_i387_state(target);
+
 	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
 				   &target->thread.fpu.state->fxsave, 0, -1);
 }
@@ -207,6 +215,8 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 	if (ret)
 		return ret;
 
+	sanitize_i387_state(target);
+
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
 				 &target->thread.fpu.state->fxsave, 0, -1);
 
@@ -446,6 +456,8 @@ int fpregs_get(struct task_struct *target, const struct user_regset *regset,
 					   -1);
 	}
 
+	sanitize_i387_state(target);
+
 	if (kbuf && pos == 0 && count == sizeof(env)) {
 		convert_from_fxsr(kbuf, target);
 		return 0;
@@ -467,6 +479,8 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 	if (ret)
 		return ret;
 
+	sanitize_i387_state(target);
+
 	if (!HAVE_HWFP)
 		return fpregs_soft_set(target, regset, pos, count, kbuf, ubuf);
 
@@ -533,6 +547,9 @@ static int save_i387_xsave(void __user *buf)
 	struct _fpstate_ia32 __user *fx = buf;
 	int err = 0;
 
+
+	sanitize_i387_state(tsk);
+
 	/*
 	 * For legacy compatible, we always set FP/SSE bits in the bit
 	 * vector while saving the state to the user context.
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 9801498..b2549c3 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -16,11 +16,88 @@
  */
 u64 pcntxt_mask;
 
+/*
+ * Represents init state for the supported extended state.
+ */
+static struct xsave_struct *init_xstate_buf;
+
 struct _fpx_sw_bytes fx_sw_reserved;
 #ifdef CONFIG_IA32_EMULATION
 struct _fpx_sw_bytes fx_sw_reserved_ia32;
 #endif
 
+static unsigned int *xstate_offsets, *xstate_sizes, xstate_features;
+
+/*
+ * If a processor implementation discern that a processor state component is
+ * in its initialized state it may modify the corresponding bit in the
+ * xsave_hdr.xstate_bv as '0', with out modifying the corresponding memory
+ * layout in the case of xsaveopt. While presenting the xstate information to
+ * the user, we always ensure that the memory layout of a feature will be in
+ * the init state if the corresponding header bit is zero. This is to ensure
+ * that the user doesn't see some stale state in the memory layout during
+ * signal handling, debugging etc.
+ */
+void __sanitize_i387_state(struct task_struct *tsk)
+{
+	u64 xstate_bv;
+	int feature_bit = 0x2;
+	struct i387_fxsave_struct *fx = &tsk->thread.fpu.state->fxsave;
+
+	if (!fx)
+		return;
+
+	BUG_ON(task_thread_info(tsk)->status & TS_USEDFPU);
+
+	xstate_bv = tsk->thread.fpu.state->xsave.xsave_hdr.xstate_bv;
+
+	/*
+	 * None of the feature bits are in init state. So nothing else
+	 * to do for us, as the memory layout is upto date.
+	 */
+	if ((xstate_bv & pcntxt_mask) == pcntxt_mask)
+		return;
+
+	/*
+	 * FP is in init state
+	 */
+	if (!(xstate_bv & XSTATE_FP)) {
+		fx->cwd = 0x37f;
+		fx->swd = 0;
+		fx->twd = 0;
+		fx->fop = 0;
+		fx->rip = 0;
+		fx->rdp = 0;
+		memset(&fx->st_space[0], 0, 128);
+	}
+
+	/*
+	 * SSE is in init state
+	 */
+	if (!(xstate_bv & XSTATE_SSE))
+		memset(&fx->xmm_space[0], 0, 256);
+
+	xstate_bv = (pcntxt_mask & ~xstate_bv) >> 2;
+
+	/*
+	 * Update all the other memory layouts for which the corresponding
+	 * header bit is in the init state.
+	 */
+	while (xstate_bv) {
+		if (xstate_bv & 0x1) {
+			int offset = xstate_offsets[feature_bit];
+			int size = xstate_sizes[feature_bit];
+
+			memcpy(((void *) fx) + offset,
+			       ((void *) init_xstate_buf) + offset,
+			       size);
+		}
+
+		xstate_bv >>= 1;
+		feature_bit++;
+	}
+}
+
 /*
  * Check for the presence of extended state information in the
  * user fpstate pointer in the sigcontext.
@@ -110,6 +187,7 @@ int save_i387_xstate(void __user *buf)
 		task_thread_info(tsk)->status &= ~TS_USEDFPU;
 		stts();
 	} else {
+		sanitize_i387_state(tsk);
 		if (__copy_to_user(buf, &tsk->thread.fpu.state->fxsave,
 				   xstate_size))
 			return -1;
@@ -275,11 +353,6 @@ static void prepare_fx_sw_frame(void)
 #endif
 }
 
-/*
- * Represents init state for the supported extended state.
- */
-struct xsave_struct *init_xstate_buf;
-
 #ifdef CONFIG_X86_64
 unsigned int sig_xstate_size = sizeof(struct _fpstate);
 #endif
@@ -287,37 +360,77 @@ unsigned int sig_xstate_size = sizeof(struct _fpstate);
 /*
  * Enable the extended processor state save/restore feature
  */
-void __cpuinit xsave_init(void)
+static inline void xstate_enable(void)
 {
-	if (!cpu_has_xsave)
-		return;
-
 	set_in_cr4(X86_CR4_OSXSAVE);
-
-	/*
-	 * Enable all the features that the HW is capable of
-	 * and the Linux kernel is aware of.
-	 */
 	xsetbv(XCR_XFEATURE_ENABLED_MASK, pcntxt_mask);
 }
 
 /*
+ * Record the offsets and sizes of different state managed by the xsave
+ * memory layout.
+ */
+static void __init setup_xstate_features(void)
+{
+	int eax, ebx, ecx, edx, leaf = 0x2;
+
+	xstate_features = fls64(pcntxt_mask);
+	xstate_offsets = alloc_bootmem(xstate_features * sizeof(int));
+	xstate_sizes = alloc_bootmem(xstate_features * sizeof(int));
+
+	do {
+		cpuid_count(XSTATE_CPUID, leaf, &eax, &ebx, &ecx, &edx);
+
+		if (eax == 0)
+			break;
+
+		xstate_offsets[leaf] = ebx;
+		xstate_sizes[leaf] = eax;
+
+		leaf++;
+	} while (1);
+}
+
+/*
  * setup the xstate image representing the init state
  */
 static void __init setup_xstate_init(void)
 {
+	setup_xstate_features();
+
+	/*
+	 * Setup init_xstate_buf to represent the init state of
+	 * all the features managed by the xsave
+	 */
 	init_xstate_buf = alloc_bootmem(xstate_size);
 	init_xstate_buf->i387.mxcsr = MXCSR_DEFAULT;
+
+	clts();
+	/*
+	 * Init all the features state with header_bv being 0x0
+	 */
+	xrstor_state(init_xstate_buf, -1);
+	/*
+	 * Dump the init state again. This is to identify the init state
+	 * of any feature which is not represented by all zero's.
+	 */
+	xsave_state(init_xstate_buf, -1);
+	stts();
 }
 
 /*
  * Enable and initialize the xsave feature.
  */
-void __ref xsave_cntxt_init(void)
+static void __init xstate_enable_boot_cpu(void)
 {
 	unsigned int eax, ebx, ecx, edx;
 
-	cpuid_count(0xd, 0, &eax, &ebx, &ecx, &edx);
+	if (boot_cpu_data.cpuid_level < XSTATE_CPUID) {
+		WARN(1, KERN_ERR "XSTATE_CPUID missing\n");
+		return;
+	}
+
+	cpuid_count(XSTATE_CPUID, 0, &eax, &ebx, &ecx, &edx);
 	pcntxt_mask = eax + ((u64)edx << 32);
 
 	if ((pcntxt_mask & XSTATE_FPSSE) != XSTATE_FPSSE) {
@@ -330,12 +443,13 @@ void __ref xsave_cntxt_init(void)
 	 * Support only the state known to OS.
 	 */
 	pcntxt_mask = pcntxt_mask & XCNTXT_MASK;
-	xsave_init();
+
+	xstate_enable();
 
 	/*
 	 * Recompute the context size for enabled features
 	 */
-	cpuid_count(0xd, 0, &eax, &ebx, &ecx, &edx);
+	cpuid_count(XSTATE_CPUID, 0, &eax, &ebx, &ecx, &edx);
 	xstate_size = ebx;
 
 	update_regset_xstate_info(xstate_size, pcntxt_mask);
@@ -347,3 +461,23 @@ void __ref xsave_cntxt_init(void)
 	       "cntxt size 0x%x\n",
 	       pcntxt_mask, xstate_size);
 }
+
+/*
+ * For the very first instance, this calls xstate_enable_boot_cpu();
+ * for all subsequent instances, this calls xstate_enable().
+ *
+ * This is somewhat obfuscated due to the lack of powerful enough
+ * overrides for the section checks.
+ */
+void __cpuinit xsave_init(void)
+{
+	static __refdata void (*next_func)(void) = xstate_enable_boot_cpu;
+	void (*this_func)(void);
+
+	if (!cpu_has_xsave)
+		return;
+
+	this_func = next_func;
+	next_func = xstate_enable;
+	this_func();
+}

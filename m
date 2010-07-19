Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936507Ab0GSShA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:37:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:25943 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934806Ab0GSSg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:36:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,228,1278313200"; 
   d="scan'208";a="819558092"
Message-Id: <20100719183240.153577808@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 19 Jul 2010 11:35:43 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/3] x86: sync xsave memory layout with its header for user handling
References: <20100719181941.971215286@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=fix_signal_handling_with_xsaveopt_init_optimization.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With xsaveopt, if a processor implementation discern that a processor state
component is in its initialized state it may modify the corresponding bit in
the xsave_hdr.xstate_bv as '0', with out modifying the corresponding memory
layout. Hence wHile presenting the xstate information to the user, we always
ensure that the memory layout of a feature will be in the init state if the
corresponding header bit is zero. This ensures the consistency and avoids the
condition of the user seeing some some stale state in the memory layout during
signal handling, debugging etc.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/i387.h  |   14 ++++++
 arch/x86/include/asm/xsave.h |   10 ++++
 arch/x86/kernel/i387.c       |   11 +++++
 arch/x86/kernel/xsave.c      |   89 ++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 123 insertions(+), 1 deletion(-)

Index: tip-linux-2.6/arch/x86/kernel/xsave.c
===================================================================
--- tip-linux-2.6.orig/arch/x86/kernel/xsave.c
+++ tip-linux-2.6/arch/x86/kernel/xsave.c
@@ -24,6 +24,76 @@ struct _fpx_sw_bytes fx_sw_reserved_ia32
 static unsigned int *xstate_offsets, *xstate_sizes, xstate_features;
 
 /*
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
+/*
  * Check for the presence of extended state information in the
  * user fpstate pointer in the sigcontext.
  */
@@ -104,6 +174,7 @@ int save_i387_xstate(void __user *buf)
 		task_thread_info(tsk)->status &= ~TS_USEDFPU;
 		stts();
 	} else {
+		sanitize_i387_state(tsk);
 		if (__copy_to_user(buf, &tsk->thread.fpu.state->fxsave,
 				   xstate_size))
 			return -1;
@@ -325,10 +396,26 @@ static void setup_xstate_features(void)
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
 
-	setup_xstate_features();
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
Index: tip-linux-2.6/arch/x86/kernel/i387.c
===================================================================
--- tip-linux-2.6.orig/arch/x86/kernel/i387.c
+++ tip-linux-2.6/arch/x86/kernel/i387.c
@@ -190,6 +190,8 @@ int xfpregs_get(struct task_struct *targ
 	if (ret)
 		return ret;
 
+	sanitize_i387_state(target);
+
 	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
 				   &target->thread.fpu.state->fxsave, 0, -1);
 }
@@ -207,6 +209,8 @@ int xfpregs_set(struct task_struct *targ
 	if (ret)
 		return ret;
 
+	sanitize_i387_state(target);
+
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
 				 &target->thread.fpu.state->fxsave, 0, -1);
 
@@ -446,6 +450,8 @@ int fpregs_get(struct task_struct *targe
 					   -1);
 	}
 
+	sanitize_i387_state(target);
+
 	if (kbuf && pos == 0 && count == sizeof(env)) {
 		convert_from_fxsr(kbuf, target);
 		return 0;
@@ -467,6 +473,8 @@ int fpregs_set(struct task_struct *targe
 	if (ret)
 		return ret;
 
+	sanitize_i387_state(target);
+
 	if (!HAVE_HWFP)
 		return fpregs_soft_set(target, regset, pos, count, kbuf, ubuf);
 
@@ -533,6 +541,9 @@ static int save_i387_xsave(void __user *
 	struct _fpstate_ia32 __user *fx = buf;
 	int err = 0;
 
+
+	sanitize_i387_state(tsk);
+
 	/*
 	 * For legacy compatible, we always set FP/SSE bits in the bit
 	 * vector while saving the state to the user context.
Index: tip-linux-2.6/arch/x86/include/asm/i387.h
===================================================================
--- tip-linux-2.6.orig/arch/x86/include/asm/i387.h
+++ tip-linux-2.6/arch/x86/include/asm/i387.h
@@ -58,11 +58,25 @@ extern int restore_i387_xstate_ia32(void
 
 #define X87_FSW_ES (1 << 7)	/* Exception Summary */
 
+static __always_inline __pure bool use_xsaveopt(void)
+{
+	return 0;
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
Index: tip-linux-2.6/arch/x86/include/asm/xsave.h
===================================================================
--- tip-linux-2.6.orig/arch/x86/include/asm/xsave.h
+++ tip-linux-2.6/arch/x86/include/asm/xsave.h
@@ -121,6 +121,16 @@ static inline void xrstor_state(struct x
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



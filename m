Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab0JESao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 14:30:44 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:24381
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753789Ab0JESam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:30:42 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9TY2X-02-OA1-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [RFC 3/3] Save/restore LWP state in context switches.
Date: Tue, 5 Oct 2010 20:30:29 +0200
Message-ID: <1286303429-415145-4-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20101005182739.GE173@escobedo.osrc.amd.com>
References: <20101005182739.GE173@escobedo.osrc.amd.com>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b. Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach, Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr. 43632
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LWP (Light-Weight Profiling) is a new per-thread profiling mechanism
that can be enabled by any thread at any time if the OS claims to
support it (by setting a bit in XCR0). A threads LWP state
(configuration & unsaved collected data) is supposed to be saved and
restored with xsave and xrstor by the OS.

Unfortunately, LWP does not support any kind of lazy switching, nor does
it use the TS bit in CR0. Since any thread can enable LWP at any time
without the kernel knowing, the context switch code is supposed to
save/restore LWP context unconditionally. This would require a valid
xsave state area for all threads, whether or not they use any FPU or LWP
functionality. It would also make the already complex lazy switching
code more complicated.

To avoid this memory overhead, especially for systems not supporting
LWP, and also to avoid more intrusive changes to the code that handles
FPU state, this patch handles LWP separately from the FPU. Only if a
system supports LWP, the context switch code checks whether LWP has been
used by the thread that is being taken off the CPU by reading the
LWP_CBADDR MSR, which is nonzero if LWP has been used by the thread.
Only in that case the LWP state is saved to the common xsave area in the
threads FPU context. This means, of course, that an FPU context has to
be allocated and initialized when a thread first uses LWP before using
the FPU.

Similarly, restoring the LWP state is only done when an FPU context
exists and the LWP bit in the xstate header is set.

To make things a little more complicated, xsave and xrstor _do_ use the
TS bit and trap when it is set. To avoid unwanted traps, the TS bit has
to be cleared before and restored after doing xsave or xrstor for LWP.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/include/asm/lwp.h        |   68 +++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/msr-index.h  |    1 +
 arch/x86/include/asm/processor.h  |   12 ++++++
 arch/x86/include/asm/sigcontext.h |   12 ++++++
 arch/x86/include/asm/xsave.h      |    5 ++-
 arch/x86/kernel/process_32.c      |   13 +++++++
 arch/x86/kernel/process_64.c      |   13 +++++++
 7 files changed, 122 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/include/asm/lwp.h

diff --git a/arch/x86/include/asm/lwp.h b/arch/x86/include/asm/lwp.h
new file mode 100644
index 0000000..6a8e348
--- /dev/null
+++ b/arch/x86/include/asm/lwp.h
@@ -0,0 +1,68 @@
+/*
+ * Copyright (C) 2010 Advanced Micro Devices, Inc.
+ * Contributed by Hans Rosenfeld <hans.rosenfeld@amd.com>
+ */
+
+#ifndef _ASM_X86_LWP_H
+#define _ASM_X86_LWP_H
+
+#ifndef __ASSEMBLY__
+
+#include <asm/i387.h>
+#include <asm/xsave.h>
+#include <asm/processor.h>
+#include <asm/msr-index.h>
+#include <asm/system.h>
+
+/*
+ * Save LWP state if it has been used by the task. Initializes the FPU
+ * state if necessary.
+ */
+static inline void save_lwp_state(struct task_struct *tsk)
+{
+	u64 lwpcb;
+	bool ts;
+
+	/* Has LWP been used? */
+	rdmsrl(MSR_AMD64_LWP_CBADDR, lwpcb);
+	if (!lwpcb)
+		return;
+
+	/* set up FPU state if necessary */
+	if (!fpu_allocated(&tsk->thread.fpu))
+		init_fpu(tsk);
+
+	/* Xsave traps when TS is set. Disable it temporarily. */
+	ts = read_cr0() & X86_CR0_TS;
+	clts();
+	fpu_xsave(&tsk->thread.fpu.state->xsave, XSTATE_LWP);
+	if (ts)
+		stts();
+
+	/* Disable LWP for next thread. */
+	wrmsrl(MSR_AMD64_LWP_CBADDR, 0);
+}
+
+/*
+ * Restore LWP state if present in the tasks xsave area.
+ */
+static inline void restore_lwp_state(struct task_struct *tsk)
+{
+	bool ts;
+
+	/* Don't do anything if there is no LWP state for this thread */
+	if (!fpu_allocated(&tsk->thread.fpu) ||
+	    !(tsk->thread.fpu.state->xsave.xsave_hdr.xstate_bv & XSTATE_LWP))
+		return;
+
+	/* Xrstor traps when TS is set. Disable it temporarily. */
+	ts = read_cr0() & X86_CR0_TS;
+	clts();
+	xrstor_state(&tsk->thread.fpu.state->xsave, XSTATE_LWP);
+	if (ts)
+		stts();
+}
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_X86_LWP_H */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 986f779..9183ecc 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -121,6 +121,7 @@
 #define MSR_AMD64_IBSDCLINAD		0xc0011038
 #define MSR_AMD64_IBSDCPHYSAD		0xc0011039
 #define MSR_AMD64_IBSCTL		0xc001103a
+#define MSR_AMD64_LWP_CBADDR		0xc0000106
 
 /* Fam 10h MSRs */
 #define MSR_FAM10H_MMIO_CONF_BASE	0xc0010058
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index cae9c3c..cbb5da9 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -358,6 +358,17 @@ struct ymmh_struct {
 	u32 ymmh_space[64];
 };
 
+struct lwp_struct {
+	u64 lwpcb_addr;
+	u32 flags;
+	u32 buf_head_offset;
+	u64 buf_base;
+	u32 buf_size;
+	u32 filters;
+	u64 saved_event_record[4];
+	u32 event_counter[16];
+};
+
 struct xsave_hdr_struct {
 	u64 xstate_bv;
 	u64 reserved1[2];
@@ -368,6 +379,7 @@ struct xsave_struct {
 	struct i387_fxsave_struct i387;
 	struct xsave_hdr_struct xsave_hdr;
 	struct ymmh_struct ymmh;
+	struct lwp_struct lwp;
 	/* new processor state extensions will go here */
 } __attribute__ ((packed, aligned (64)));
 
diff --git a/arch/x86/include/asm/sigcontext.h b/arch/x86/include/asm/sigcontext.h
index 04459d2..0a58b82 100644
--- a/arch/x86/include/asm/sigcontext.h
+++ b/arch/x86/include/asm/sigcontext.h
@@ -274,6 +274,17 @@ struct _ymmh_state {
 	__u32 ymmh_space[64];
 };
 
+struct _lwp_state {
+	__u64 lwpcb_addr;
+	__u32 flags;
+	__u32 buf_head_offset;
+	__u64 buf_base;
+	__u32 buf_size;
+	__u32 filters;
+	__u64 saved_event_record[4];
+	__u32 event_counter[16];
+};
+
 /*
  * Extended state pointed by the fpstate pointer in the sigcontext.
  * In addition to the fpstate, information encoded in the xstate_hdr
@@ -284,6 +295,7 @@ struct _xstate {
 	struct _fpstate fpstate;
 	struct _xsave_hdr xstate_hdr;
 	struct _ymmh_state ymmh;
+	struct _lwp_state lwp;
 	/* new processor state extensions go here */
 };
 
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 8820b57..ceb0b85 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -9,6 +9,7 @@
 #define XSTATE_FP	0x1
 #define XSTATE_SSE	0x2
 #define XSTATE_YMM	0x4
+#define XSTATE_LWP	(1ULL << 62)
 
 #define XSTATE_FPSSE	(XSTATE_FP | XSTATE_SSE)
 
@@ -23,12 +24,12 @@
 /*
  * These are the features that the OS can handle currently.
  */
-#define XCNTXT_SUPPORTED    (XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
+#define XCNTXT_SUPPORTED    (XSTATE_FP | XSTATE_SSE | XSTATE_YMM | XSTATE_LWP)
 
 /*
  * These are the features that the OS saves/restores by default.
  */
-#define XCNTXT_DEFAULT	    (-1)
+#define XCNTXT_DEFAULT	    (~XSTATE_LWP)
 
 #ifdef CONFIG_X86_64
 #define REX_PREFIX	"0x48, "
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 96586c3..69ced7d 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -44,6 +44,7 @@
 #include <asm/ldt.h>
 #include <asm/processor.h>
 #include <asm/i387.h>
+#include <asm/lwp.h>
 #include <asm/desc.h>
 #ifdef CONFIG_MATH_EMULATION
 #include <asm/math_emu.h>
@@ -311,6 +312,12 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 
 	__unlazy_fpu(prev_p);
 
+	/*
+	 * Save LWP state if LWP is available.
+	 */
+	if (static_cpu_has(X86_FEATURE_LWP))
+		save_lwp_state(prev_p);
+
 	/* we're going to use this soon, after a few expensive things */
 	if (preload_fpu)
 		prefetch(next->fpu.state);
@@ -353,6 +360,12 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 		     task_thread_info(next_p)->flags & _TIF_WORK_CTXSW_NEXT))
 		__switch_to_xtra(prev_p, next_p, tss);
 
+	/*
+	 * Restore LWP state if available.
+	 */
+	if (static_cpu_has(X86_FEATURE_LWP))
+		restore_lwp_state(next_p);
+
 	/* If we're going to preload the fpu context, make sure clts
 	   is run while we're batching the cpu state updates. */
 	if (preload_fpu)
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index b3d7a3a..a70c6cc 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -42,6 +42,7 @@
 #include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/i387.h>
+#include <asm/lwp.h>
 #include <asm/mmu_context.h>
 #include <asm/prctl.h>
 #include <asm/desc.h>
@@ -423,6 +424,12 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 
 	load_TLS(next, cpu);
 
+	/*
+	 * Save LWP state if LWP is available.
+	 */
+	if (static_cpu_has(X86_FEATURE_LWP))
+		save_lwp_state(prev_p);
+
 	/* Must be after DS reload */
 	__unlazy_fpu(prev_p);
 
@@ -489,6 +496,12 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 		__switch_to_xtra(prev_p, next_p, tss);
 
 	/*
+	 * Restore LWP state if available.
+	 */
+	if (static_cpu_has(X86_FEATURE_LWP))
+		restore_lwp_state(next_p);
+
+	/*
 	 * Preload the FPU context, now that we've determined that the
 	 * task is likely to be using it. 
 	 */
-- 
1.5.6.5



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358Ab1LGUFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 15:05:16 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:56517 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758317Ab1LGUFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 15:05:13 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LVUNOF-01-Q66-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>
CC: <tglx@linutronix.de>, <mingo@elte.hu>, <andi@firstfloor.org>,
        <suresh.b.siddha@intel.com>, <eranian@google.com>, <brgerst@gmail.com>,
        <robert.richter@amd.com>, <Andreas.Herrmann3@amd.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 7/8] x86, xsave: add support for non-lazy xstates
Date: Wed, 7 Dec 2011 21:00:22 +0100
Message-ID: <1323288023-26147-1-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20111207195753.GD665@escobedo.osrc.amd.com>
References: <20111207195753.GD665@escobedo.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Non-lazy xstates are, as the name suggests, extended states that cannot
be saved or restored lazily. The state for AMDs LWP feature is a
non-lazy state.

This patch adds support for this kind of xstates. If any such states are
present and supported on the running system, they will always be enabled
in xstate_mask so that they are always restored in switch_to. Also, all
processes will always have to have a xstate area preallocated, lazy
allocation will not work when non-lazy states are present.

v2:
A single static xsave area just for init is not enough, since there are
more user processes that are directly spawned by kernel threads. Add a
call to a new arch-specific function to flush_old_exec(), which will in
turn call fpu_alloc() to allocate the xsave area if necessary.

v3:
The new xsave area has to be cleared to avoid xrstor errors.

v4:
Add Kconfig option to disable support for non-lazy states.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/Kconfig                   |   18 ++++++++++++++++++
 arch/x86/include/asm/i387.h        |   11 +++++++++++
 arch/x86/include/asm/thread_info.h |    2 ++
 arch/x86/include/asm/xsave.h       |    9 +++++++--
 arch/x86/kernel/process.c          |   17 +++++++++++++++++
 arch/x86/kernel/process_32.c       |    4 ++--
 arch/x86/kernel/process_64.c       |    4 ++--
 arch/x86/kernel/xsave.c            |    3 ++-
 fs/exec.c                          |    8 ++++++++
 9 files changed, 69 insertions(+), 7 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6a47bb2..1f4d706 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1367,6 +1367,24 @@ config MATH_EMULATION
 	  If you are not sure, say Y; apart from resulting in a 66 KB bigger
 	  kernel, it won't hurt.
 
+config NONLAZY_XSTATES
+	def_bool y
+	prompt "Non-lazy extented process states "
+	---help---
+	  Non-lazy extended process states differ from other extended
+	  process states (such as FPU and SIMD states) in that they
+	  cannot be saved or restored lazily. The state for AMDs
+	  Lightweight Profiling (LWP) is currently the only such state.
+
+	  On systems that support non-lazy states, the kernel has to
+	  pre-allocate the extended state buffer for each user task.
+	  This implies that tasks that do not use the FPU or any SIMD
+	  optimizations will still use about 1kB of kernel memory for
+	  the extended state buffer.
+
+	  If this is unacceptable for your workload, say N to disable
+	  all support for non-lazy extended states.
+
 config MTRR
 	def_bool y
 	prompt "MTRR (Memory Type Range Register) support" if EXPERT
diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 3474267..7812d55 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -330,6 +330,17 @@ static inline void fpu_copy(struct fpu *dst, struct fpu *src)
 
 extern void fpu_finit(struct fpu *fpu);
 
+static inline void fpu_clear(struct fpu *fpu)
+{
+	if (pcntxt_mask & XCNTXT_NONLAZY) {
+		memset(fpu->state, 0, xstate_size);
+		fpu_finit(fpu);
+		set_used_math();
+	} else {
+		fpu_free(fpu);
+	}
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
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 12793b6..10e0e45 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -23,9 +23,14 @@
 /*
  * These are the features that the OS can handle currently.
  */
-#define XCNTXT_MASK	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
+#define XCNTXT_LAZY	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
+#define XCNTXT_NONLAZY	0
 
-#define XCNTXT_LAZY	XCNTXT_MASK
+#ifdef CONFIG_NONLAZY_XSTATES
+#define XCNTXT_MASK	(XCNTXT_LAZY | XCNTXT_NONLAZY)
+#else
+#define XCNTXT_MASK	(XCNTXT_LAZY)
+#endif
 
 #ifdef CONFIG_X86_64
 #define REX_PREFIX	"0x48, "
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e7e3b01..b43522d 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -26,6 +26,23 @@
 struct kmem_cache *task_xstate_cachep;
 EXPORT_SYMBOL_GPL(task_xstate_cachep);
 
+int arch_prealloc_fpu(struct task_struct *tsk)
+{
+	if ((pcntxt_mask & XCNTXT_NONLAZY) &&
+	    !fpu_allocated(&tsk->thread.fpu)) {
+		int err = fpu_alloc(&tsk->thread.fpu);
+
+		if (err)
+			return err;
+
+		fpu_clear(&tsk->thread.fpu);
+
+		task_thread_info(tsk)->xstate_mask |= (pcntxt_mask & XCNTXT_NONLAZY);
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
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 9d95d2f..ce329ff 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -16,6 +16,7 @@
  * Supported feature mask by the CPU and the kernel.
  */
 u64 pcntxt_mask;
+EXPORT_SYMBOL(pcntxt_mask);
 
 /*
  * Represents init state for the supported extended state.
@@ -261,7 +262,7 @@ int restore_xstates_sigframe(void __user *buf, unsigned int size)
 	struct task_struct *tsk = current;
 	struct _fpstate_ia32 __user *fp = buf;
 	struct xsave_struct *xsave;
-	u64 xstate_mask = 0;
+	u64 xstate_mask = pcntxt_mask & XCNTXT_NONLAZY;
 	int err;
 
 	if (!buf) {
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



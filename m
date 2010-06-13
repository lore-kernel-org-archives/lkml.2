Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab0FMPEm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 11:04:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab0FMPEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 11:04:15 -0400
From: Avi Kivity <avi@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] x86, fpu: Let the fpu remember which cpu it is active on
Date: Sun, 13 Jun 2010 18:03:46 +0300
Message-Id: <1276441427-31514-4-git-send-email-avi@redhat.com>
In-Reply-To: <1276441427-31514-1-git-send-email-avi@redhat.com>
References: <1276441427-31514-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a member fpu->cpu to struct fpu which contains which cpu has this fpu
register set loaded (or -1 if the registers were flushed to memory in
fpu->state).

The various fpu accesors are modified to IPI the loaded cpu if it
happens to be different from the current cpu.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/i387.h      |  115 +++++++++++++++++++++++++++++++++++--
 arch/x86/include/asm/processor.h |    4 +
 arch/x86/kernel/i387.c           |    3 +
 arch/x86/kernel/process.c        |    1 +
 4 files changed, 116 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index df5badf..124c89d 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -174,7 +174,7 @@ static inline void fpu_fxsave(struct fpu *fpu)
 #endif
 }
 
-static inline void fpu_save_init(struct fpu *fpu)
+static inline void __fpu_save_init(struct fpu *fpu)
 {
 	if (use_xsave())
 		fpu_xsave(fpu);
@@ -222,10 +222,7 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 #define safe_address (kstat_cpu(0).cpustat.user)
 #endif
 
-/*
- * These must be called with preempt disabled
- */
-static inline void fpu_save_init(struct fpu *fpu)
+static inline void __fpu_save_init(struct fpu *fpu)
 {
 	if (use_xsave()) {
 		struct xsave_struct *xstate = &fpu->state->xsave;
@@ -273,6 +270,33 @@ end:
 
 #endif	/* CONFIG_X86_64 */
 
+static inline bool fpu_loaded(struct fpu *fpu)
+{
+	return fpu->cpu == smp_processor_id();
+}
+
+static inline bool fpu_remote(struct fpu *fpu)
+{
+	return fpu->cpu != -1 && fpu->cpu != smp_processor_id();
+}
+
+/*
+ * These must be called with preempt disabled
+ */
+static inline void fpu_save_init(struct fpu *fpu)
+{
+	ulong flags;
+
+	if (__get_cpu_var(current_fpu) != fpu
+	    || fpu->cpu != smp_processor_id())
+		return;
+	local_irq_save(flags);
+	__fpu_save_init(fpu);
+	fpu->cpu = -1;
+	__get_cpu_var(current_fpu) = NULL;
+	local_irq_restore(flags);
+}
+
 static inline void __save_init_fpu(struct task_struct *tsk)
 {
 	fpu_save_init(&tsk->thread.fpu);
@@ -284,7 +308,7 @@ static inline int fpu_fxrstor_checking(struct fpu *fpu)
 	return fxrstor_checking(&fpu->state->fxsave);
 }
 
-static inline int fpu_restore_checking(struct fpu *fpu)
+static inline int __fpu_restore_checking(struct fpu *fpu)
 {
 	if (use_xsave())
 		return fpu_xrstor_checking(fpu);
@@ -292,6 +316,47 @@ static inline int fpu_restore_checking(struct fpu *fpu)
 		return fpu_fxrstor_checking(fpu);
 }
 
+static inline void __fpu_unload(void *_fpu)
+{
+	struct fpu *fpu = _fpu;
+	unsigned cr0 = read_cr0();
+
+	if (cr0 & X86_CR0_TS)
+		clts();
+	if (__get_cpu_var(current_fpu) == fpu)
+		fpu_save_init(fpu);
+	if (cr0 & X86_CR0_TS)
+		write_cr0(cr0);
+}
+
+static inline void fpu_unload(struct fpu *fpu)
+{
+	int cpu = ACCESS_ONCE(fpu->cpu);
+
+	if (cpu != -1)
+		smp_call_function_single(cpu, __fpu_unload, fpu, 1);
+}
+
+static inline int fpu_restore_checking(struct fpu *fpu)
+{
+	ulong flags;
+	struct fpu *oldfpu;
+	int ret;
+
+	if (fpu->cpu == smp_processor_id())
+		return 0;
+	fpu_unload(fpu);
+	local_irq_save(flags);
+	oldfpu = __get_cpu_var(current_fpu);
+	if (oldfpu)
+		fpu_save_init(oldfpu);
+	ret = __fpu_restore_checking(fpu);
+	fpu->cpu = smp_processor_id();
+	__get_cpu_var(current_fpu) = fpu;
+	local_irq_restore(flags);
+	return ret;
+}
+
 static inline int restore_fpu_checking(struct task_struct *tsk)
 {
 	return fpu_restore_checking(&tsk->thread.fpu);
@@ -451,18 +516,46 @@ static bool fpu_allocated(struct fpu *fpu)
 	return fpu->state != NULL;
 }
 
+static inline void fpu_init_empty(struct fpu *fpu)
+{
+	fpu->state = NULL;
+	fpu->cpu = -1;
+}
+
 static inline int fpu_alloc(struct fpu *fpu)
 {
 	if (fpu_allocated(fpu))
 		return 0;
 	fpu->state = kmem_cache_alloc(task_xstate_cachep, GFP_KERNEL);
+	fpu->cpu = -1;
 	if (!fpu->state)
 		return -ENOMEM;
 	WARN_ON((unsigned long)fpu->state & 15);
 	return 0;
 }
 
-static inline void fpu_free(struct fpu *fpu)
+static inline void __fpu_forget(void *_fpu)
+{
+	struct fpu *fpu = _fpu;
+
+	if (fpu->cpu == smp_processor_id()) {
+		fpu->cpu = -1;
+		__get_cpu_var(current_fpu) = NULL;
+	}
+}
+
+static inline void fpu_forget(struct fpu *fpu)
+{
+	int cpu;
+
+	preempt_disable();
+	cpu = ACCESS_ONCE(fpu->cpu);
+	if (cpu != -1)
+		smp_call_function_single(cpu, __fpu_forget, fpu, 1);
+	preempt_enable();
+}
+
+static inline void __fpu_free(struct fpu *fpu)
 {
 	if (fpu->state) {
 		kmem_cache_free(task_xstate_cachep, fpu->state);
@@ -470,8 +563,16 @@ static inline void fpu_free(struct fpu *fpu)
 	}
 }
 
+static inline void fpu_free(struct fpu *fpu)
+{
+	fpu_forget(fpu);
+	__fpu_free(fpu);
+}
+
 static inline void fpu_copy(struct fpu *dst, struct fpu *src)
 {
+	fpu_unload(src);
+	fpu_unload(dst);
 	memcpy(dst->state, src->state, xstate_size);
 }
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7e5c6a6..98996fe 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -378,8 +378,11 @@ union thread_xstate {
 
 struct fpu {
 	union thread_xstate *state;
+	int cpu;            /* -1 = unloaded */
 };
 
+DECLARE_PER_CPU(struct fpu *, current_fpu);
+
 #ifdef CONFIG_X86_64
 DECLARE_PER_CPU(struct orig_ist, orig_ist);
 
@@ -892,6 +895,7 @@ static inline void spin_lock_prefetch(const void *x)
 	.vm86_info		= NULL,					  \
 	.sysenter_cs		= __KERNEL_CS,				  \
 	.io_bitmap_ptr		= NULL,					  \
+	.fpu			= { .cpu = -1, },			  \
 }
 
 /*
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index c4444bc..e56f486 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -38,6 +38,9 @@
 # define HAVE_HWFP		1
 #endif
 
+DEFINE_PER_CPU(struct fpu *, current_fpu);
+EXPORT_PER_CPU_SYMBOL_GPL(current_fpu);
+
 static unsigned int		mxcsr_feature_mask __read_mostly = 0xffffffffu;
 unsigned int xstate_size;
 unsigned int sig_xstate_ia32_size = sizeof(struct _fpstate_ia32);
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ebcfcce..16a7a9b 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -35,6 +35,7 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 	int ret;
 
 	*dst = *src;
+	fpu_init_empty(&dst->thread.fpu);
 	if (fpu_allocated(&src->thread.fpu)) {
 		memset(&dst->thread.fpu, 0, sizeof(dst->thread.fpu));
 		ret = fpu_alloc(&dst->thread.fpu);
-- 
1.7.1


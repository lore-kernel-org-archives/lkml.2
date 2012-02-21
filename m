Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab2BUVkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 16:40:31 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33214 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000Ab2BUVk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 16:40:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.68.131.98 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
Date: Tue, 21 Feb 2012 13:40:24 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@i5.linux-foundation.org
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Josh Boyer <jwboyer@gmail.com>, Jongman Heo <jongman.heo@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] i387: uninline the generic FP helpers that we expose to
 kernel modules
In-Reply-To: <alpine.LFD.2.02.1202211338420.5354@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.02.1202211339590.5354@i5.linux-foundation.org>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org> <alpine.LFD.2.02.1202201145130.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201146450.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201147350.4237@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org> <CA+5PVA5Zkka6Q2kcvWbvA3xr9=5TZ+VWWsWzYcRQ1GpccpJHew@mail.gmail.com> <CA+55aFyqz-2ejsRpbRdYx7UHDBg3q=9nvmtrj2nLeuZonrkz1A@mail.gmail.com> <4F42FE08.5020309@zytor.com>
 <CA+55aFxKLvHXRkx-x+zOkHJk__uTJc90Z0i+00W-hqDaQb_HCQ@mail.gmail.com> <4F43DB69.9060509@zytor.com> <CA+55aFxap0zAAJOCcz0f+DKBuG6VQa7kq1j2JD1S4ysgmb62aA@mail.gmail.com> <4F440945.1020904@zytor.com>
 <alpine.LFD.2.02.1202211338420.5354@i5.linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Feb 2012 10:25:45 -0800
Subject: [PATCH 1/2] i387: uninline the generic FP helpers that we expose to kernel modules

Instead of exporting the very low-level internals of the FPU state
save/restore code (ie things like 'fpu_owner_task'), we should export
the higher-level interfaces.

Inlining these things is pointless anyway: sure, sometimes the end
result is small, but while 'stts()' can result in just three x86
instructions, those are not cheap instructions (writing %cr0 is a
serializing instruction and a very slow one at that).

So the overhead of a function call is not noticeable, and we really
don't want random modules mucking about with our internal state save
logic anyway.

So this unexports 'fpu_owner_task', and instead uninlines and exports
the actual functions that modules can use: fpu_kernel_begin/end() and
unlazy_fpu().

Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---

This is the same patch I already sent out earlier, now with a commit
message and Peter's ack added.

 arch/x86/include/asm/i387.h  |   78 ++--------------------------------------
 arch/x86/kernel/cpu/common.c |    2 -
 arch/x86/kernel/i387.c       |   80 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 84 insertions(+), 76 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 247904945d3f..0c1031d354f2 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -419,70 +419,9 @@ static inline void __clear_fpu(struct task_struct *tsk)
 	}
 }
 
-/*
- * Were we in an interrupt that interrupted kernel mode?
- *
- * We can do a kernel_fpu_begin/end() pair *ONLY* if that
- * pair does nothing at all: the thread must not have fpu (so
- * that we don't try to save the FPU state), and TS must
- * be set (so that the clts/stts pair does nothing that is
- * visible in the interrupted kernel thread).
- */
-static inline bool interrupted_kernel_fpu_idle(void)
-{
-	return !__thread_has_fpu(current) &&
-		(read_cr0() & X86_CR0_TS);
-}
-
-/*
- * Were we in user mode (or vm86 mode) when we were
- * interrupted?
- *
- * Doing kernel_fpu_begin/end() is ok if we are running
- * in an interrupt context from user mode - we'll just
- * save the FPU state as required.
- */
-static inline bool interrupted_user_mode(void)
-{
-	struct pt_regs *regs = get_irq_regs();
-	return regs && user_mode_vm(regs);
-}
-
-/*
- * Can we use the FPU in kernel mode with the
- * whole "kernel_fpu_begin/end()" sequence?
- *
- * It's always ok in process context (ie "not interrupt")
- * but it is sometimes ok even from an irq.
- */
-static inline bool irq_fpu_usable(void)
-{
-	return !in_interrupt() ||
-		interrupted_user_mode() ||
-		interrupted_kernel_fpu_idle();
-}
-
-static inline void kernel_fpu_begin(void)
-{
-	struct task_struct *me = current;
-
-	WARN_ON_ONCE(!irq_fpu_usable());
-	preempt_disable();
-	if (__thread_has_fpu(me)) {
-		__save_init_fpu(me);
-		__thread_clear_has_fpu(me);
-		/* We do 'stts()' in kernel_fpu_end() */
-	} else {
-		percpu_write(fpu_owner_task, NULL);
-		clts();
-	}
-}
-
-static inline void kernel_fpu_end(void)
-{
-	stts();
-	preempt_enable();
-}
+extern bool irq_fpu_usable(void);
+extern void kernel_fpu_begin(void);
+extern void kernel_fpu_end(void);
 
 /*
  * Some instructions like VIA's padlock instructions generate a spurious
@@ -566,16 +505,7 @@ static inline void save_init_fpu(struct task_struct *tsk)
 	preempt_enable();
 }
 
-static inline void unlazy_fpu(struct task_struct *tsk)
-{
-	preempt_disable();
-	if (__thread_has_fpu(tsk)) {
-		__save_init_fpu(tsk);
-		__thread_fpu_end(tsk);
-	} else
-		tsk->fpu_counter = 0;
-	preempt_enable();
-}
+extern void unlazy_fpu(struct task_struct *tsk);
 
 static inline void clear_fpu(struct task_struct *tsk)
 {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c0f7d68d318f..cb71b01ab66e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1045,7 +1045,6 @@ DEFINE_PER_CPU(char *, irq_stack_ptr) =
 DEFINE_PER_CPU(unsigned int, irq_count) = -1;
 
 DEFINE_PER_CPU(struct task_struct *, fpu_owner_task);
-EXPORT_PER_CPU_SYMBOL(fpu_owner_task);
 
 /*
  * Special IST stacks which the CPU switches to when it calls
@@ -1115,7 +1114,6 @@ void debug_stack_reset(void)
 DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
 EXPORT_PER_CPU_SYMBOL(current_task);
 DEFINE_PER_CPU(struct task_struct *, fpu_owner_task);
-EXPORT_PER_CPU_SYMBOL(fpu_owner_task);
 
 #ifdef CONFIG_CC_STACKPROTECTOR
 DEFINE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 739d8598f789..17b7549c4134 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -32,6 +32,86 @@
 # define user32_fxsr_struct	user_fxsr_struct
 #endif
 
+/*
+ * Were we in an interrupt that interrupted kernel mode?
+ *
+ * We can do a kernel_fpu_begin/end() pair *ONLY* if that
+ * pair does nothing at all: the thread must not have fpu (so
+ * that we don't try to save the FPU state), and TS must
+ * be set (so that the clts/stts pair does nothing that is
+ * visible in the interrupted kernel thread).
+ */
+static inline bool interrupted_kernel_fpu_idle(void)
+{
+	return !__thread_has_fpu(current) &&
+		(read_cr0() & X86_CR0_TS);
+}
+
+/*
+ * Were we in user mode (or vm86 mode) when we were
+ * interrupted?
+ *
+ * Doing kernel_fpu_begin/end() is ok if we are running
+ * in an interrupt context from user mode - we'll just
+ * save the FPU state as required.
+ */
+static inline bool interrupted_user_mode(void)
+{
+	struct pt_regs *regs = get_irq_regs();
+	return regs && user_mode_vm(regs);
+}
+
+/*
+ * Can we use the FPU in kernel mode with the
+ * whole "kernel_fpu_begin/end()" sequence?
+ *
+ * It's always ok in process context (ie "not interrupt")
+ * but it is sometimes ok even from an irq.
+ */
+bool irq_fpu_usable(void)
+{
+	return !in_interrupt() ||
+		interrupted_user_mode() ||
+		interrupted_kernel_fpu_idle();
+}
+EXPORT_SYMBOL(irq_fpu_usable);
+
+void kernel_fpu_begin(void)
+{
+	struct task_struct *me = current;
+
+	WARN_ON_ONCE(!irq_fpu_usable());
+	preempt_disable();
+	if (__thread_has_fpu(me)) {
+		__save_init_fpu(me);
+		__thread_clear_has_fpu(me);
+		/* We do 'stts()' in kernel_fpu_end() */
+	} else {
+		percpu_write(fpu_owner_task, NULL);
+		clts();
+	}
+}
+EXPORT_SYMBOL(kernel_fpu_begin);
+
+void kernel_fpu_end(void)
+{
+	stts();
+	preempt_enable();
+}
+EXPORT_SYMBOL(kernel_fpu_end);
+
+void unlazy_fpu(struct task_struct *tsk)
+{
+	preempt_disable();
+	if (__thread_has_fpu(tsk)) {
+		__save_init_fpu(tsk);
+		__thread_fpu_end(tsk);
+	} else
+		tsk->fpu_counter = 0;
+	preempt_enable();
+}
+EXPORT_SYMBOL(unlazy_fpu);
+
 #ifdef CONFIG_MATH_EMULATION
 # define HAVE_HWFP		(boot_cpu_data.hard_math)
 #else
-- 
1.7.9.188.g12766.dirty


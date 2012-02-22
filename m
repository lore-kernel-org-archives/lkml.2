Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab2BVU7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 15:59:30 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59769 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab2BVU73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 15:59:29 -0500
Date: Wed, 22 Feb 2012 12:59:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@i5.linux-foundation.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
cc: Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] i387: move TS_USEDFPU flag from thread_info to
 task_struct
In-Reply-To: <alpine.LFD.2.02.1202221257410.20522@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.02.1202221258180.20522@i5.linux-foundation.org>
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org> <alpine.LFD.2.02.1202221255150.20522@i5.linux-foundation.org> <alpine.LFD.2.02.1202221256130.20522@i5.linux-foundation.org> <alpine.LFD.2.02.1202221256450.20522@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202221257410.20522@i5.linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 16 Feb 2012 13:33:12 -0800

[ Upstream commits 6d59d7a9f5b723a7ac1925c136e93ec83c0c3043 and
  f94edacf998516ac9d849f7bc6949a703977a7f3 ]

This moves the bit that indicates whether a thread has ownership of the
FPU from the TS_USEDFPU bit in thread_info->status to a word of its own
(called 'has_fpu') in task_struct->thread.has_fpu.

This fixes two independent bugs at the same time:

 - changing 'thread_info->status' from the scheduler causes nasty
   problems for the other users of that variable, since it is defined to
   be thread-synchronous (that's what the "TS_" part of the naming was
   supposed to indicate).

   So perfectly valid code could (and did) do

	ti->status |= TS_RESTORE_SIGMASK;

   and the compiler was free to do that as separate load, or and store
   instructions.  Which can cause problems with preemption, since a task
   switch could happen in between, and change the TS_USEDFPU bit. The
   change to TS_USEDFPU would be overwritten by the final store.

   In practice, this seldom happened, though, because the 'status' field
   was seldom used more than once, so gcc would generally tend to
   generate code that used a read-modify-write instruction and thus
   happened to avoid this problem - RMW instructions are naturally low
   fat and preemption-safe.

 - On x86-32, the current_thread_info() pointer would, during interrupts
   and softirqs, point to a *copy* of the real thread_info, because
   x86-32 uses %esp to calculate the thread_info address, and thus the
   separate irq (and softirq) stacks would cause these kinds of odd
   thread_info copy aliases.

   This is normally not a problem, since interrupts aren't supposed to
   look at thread information anyway (what thread is running at
   interrupt time really isn't very well-defined), but it confused the
   heck out of irq_fpu_usable() and the code that tried to squirrel
   away the FPU state.

   (It also caused untold confusion for us poor kernel developers).

It also turns out that using 'task_struct' is actually much more natural
for most of the call sites that care about the FPU state, since they
tend to work with the task struct for other reasons anyway (ie
scheduling).  And the FPU data that we are going to save/restore is
found there too.

Thanks to Arjan Van De Ven <arjan@linux.intel.com> for pointing us to
the %esp issue.

Cc: Arjan van de Ven <arjan@linux.intel.com>
Reported-and-tested-by: Raphael Prevost <raphael@buro.asia>
Acked-and-tested-by: Suresh Siddha <suresh.b.siddha@intel.com>
Tested-by: Peter Anvin <hpa@zytor.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@kernel.org	# The main bugfix
---

This is the actual main bugfix.

 arch/x86/include/asm/i387.h        |   79 ++++++++++++++++++++++++++----------
 arch/x86/include/asm/processor.h   |    1 +
 arch/x86/include/asm/thread_info.h |    2 -
 arch/x86/kernel/traps.c            |    8 +--
 arch/x86/kernel/xsave.c            |    2 +-
 arch/x86/kvm/vmx.c                 |    2 +-
 6 files changed, 63 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 55fb3aa84b0d..1c485363a21e 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -280,6 +280,47 @@ static inline int restore_fpu_checking(struct task_struct *tsk)
 }
 
 /*
+ * Software FPU state helpers. Careful: these need to
+ * be preemption protection *and* they need to be
+ * properly paired with the CR0.TS changes!
+ */
+static inline int __thread_has_fpu(struct task_struct *tsk)
+{
+	return tsk->thread.has_fpu;
+}
+
+/* Must be paired with an 'stts' after! */
+static inline void __thread_clear_has_fpu(struct task_struct *tsk)
+{
+	tsk->thread.has_fpu = 0;
+}
+
+/* Must be paired with a 'clts' before! */
+static inline void __thread_set_has_fpu(struct task_struct *tsk)
+{
+	tsk->thread.has_fpu = 1;
+}
+
+/*
+ * Encapsulate the CR0.TS handling together with the
+ * software flag.
+ *
+ * These generally need preemption protection to work,
+ * do try to avoid using these on their own.
+ */
+static inline void __thread_fpu_end(struct task_struct *tsk)
+{
+	__thread_clear_has_fpu(tsk);
+	stts();
+}
+
+static inline void __thread_fpu_begin(struct task_struct *tsk)
+{
+	clts();
+	__thread_set_has_fpu(tsk);
+}
+
+/*
  * Signal frame handlers...
  */
 extern int save_i387_xstate(void __user *buf);
@@ -287,23 +328,21 @@ extern int restore_i387_xstate(void __user *buf);
 
 static inline void __unlazy_fpu(struct task_struct *tsk)
 {
-	if (task_thread_info(tsk)->status & TS_USEDFPU) {
+	if (__thread_has_fpu(tsk)) {
 		__save_init_fpu(tsk);
-		task_thread_info(tsk)->status &= ~TS_USEDFPU;
-		stts();
+		__thread_fpu_end(tsk);
 	} else
 		tsk->fpu_counter = 0;
 }
 
 static inline void __clear_fpu(struct task_struct *tsk)
 {
-	if (task_thread_info(tsk)->status & TS_USEDFPU) {
+	if (__thread_has_fpu(tsk)) {
 		/* Ignore delayed exceptions from user space */
 		asm volatile("1: fwait\n"
 			     "2:\n"
 			     _ASM_EXTABLE(1b, 2b));
-		task_thread_info(tsk)->status &= ~TS_USEDFPU;
-		stts();
+		__thread_fpu_end(tsk);
 	}
 }
 
@@ -311,14 +350,14 @@ static inline void __clear_fpu(struct task_struct *tsk)
  * Were we in an interrupt that interrupted kernel mode?
  *
  * We can do a kernel_fpu_begin/end() pair *ONLY* if that
- * pair does nothing at all: TS_USEDFPU must be clear (so
+ * pair does nothing at all: the thread must not have fpu (so
  * that we don't try to save the FPU state), and TS must
  * be set (so that the clts/stts pair does nothing that is
  * visible in the interrupted kernel thread).
  */
 static inline bool interrupted_kernel_fpu_idle(void)
 {
-	return !(current_thread_info()->status & TS_USEDFPU) &&
+	return !__thread_has_fpu(current) &&
 		(read_cr0() & X86_CR0_TS);
 }
 
@@ -352,13 +391,13 @@ static inline bool irq_fpu_usable(void)
 
 static inline void kernel_fpu_begin(void)
 {
-	struct thread_info *me = current_thread_info();
+	struct task_struct *me = current;
 
 	WARN_ON_ONCE(!irq_fpu_usable());
 	preempt_disable();
-	if (me->status & TS_USEDFPU) {
-		__save_init_fpu(me->task);
-		me->status &= ~TS_USEDFPU;
+	if (__thread_has_fpu(me)) {
+		__save_init_fpu(me);
+		__thread_clear_has_fpu(me);
 		/* We do 'stts()' in kernel_fpu_end() */
 	} else
 		clts();
@@ -422,24 +461,21 @@ static inline void irq_ts_restore(int TS_state)
  */
 static inline int user_has_fpu(void)
 {
-	return current_thread_info()->status & TS_USEDFPU;
+	return __thread_has_fpu(current);
 }
 
 static inline void user_fpu_end(void)
 {
 	preempt_disable();
-	current_thread_info()->status &= ~TS_USEDFPU;
-	stts();
+	__thread_fpu_end(current);
 	preempt_enable();
 }
 
 static inline void user_fpu_begin(void)
 {
 	preempt_disable();
-	if (!user_has_fpu()) {
-		clts();
-		current_thread_info()->status |= TS_USEDFPU;
-	}
+	if (!user_has_fpu())
+		__thread_fpu_begin(current);
 	preempt_enable();
 }
 
@@ -448,11 +484,10 @@ static inline void user_fpu_begin(void)
  */
 static inline void save_init_fpu(struct task_struct *tsk)
 {
-	WARN_ON_ONCE(!(task_thread_info(tsk)->status & TS_USEDFPU));
+	WARN_ON_ONCE(!__thread_has_fpu(tsk));
 	preempt_disable();
 	__save_init_fpu(tsk);
-	task_thread_info(tsk)->status &= ~TS_USEDFPU;
-	stts();
+	__thread_fpu_end(tsk);
 	preempt_enable();
 }
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index b650435ffb53..bb3ee3629a0f 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -456,6 +456,7 @@ struct thread_struct {
 	unsigned long		trap_no;
 	unsigned long		error_code;
 	/* floating point and extended processor state */
+	unsigned long		has_fpu;
 	struct fpu		fpu;
 #ifdef CONFIG_X86_32
 	/* Virtual 86 mode info */
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index a1fe5c127b52..d7ef849714a1 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -242,8 +242,6 @@ static inline struct thread_info *current_thread_info(void)
  * ever touches our thread-synchronous status, so we don't
  * have to worry about atomic accesses.
  */
-#define TS_USEDFPU		0x0001	/* FPU was used by this task
-					   this quantum (SMP) */
 #define TS_COMPAT		0x0002	/* 32bit syscall active (64BIT)*/
 #define TS_POLLING		0x0004	/* idle task polling need_resched,
 					   skip sending interrupt */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 727e6c16f294..a67d0a833a44 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -574,12 +574,11 @@ void __math_state_restore(void)
 	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
 	 */
 	if (unlikely(restore_fpu_checking(tsk))) {
-		stts();
+		__thread_fpu_end(tsk);
 		force_sig(SIGSEGV, tsk);
 		return;
 	}
 
-	thread->status |= TS_USEDFPU;	/* So we fnsave on switch_to() */
 	tsk->fpu_counter++;
 }
 
@@ -595,8 +594,7 @@ void __math_state_restore(void)
  */
 void math_state_restore(void)
 {
-	struct thread_info *thread = current_thread_info();
-	struct task_struct *tsk = thread->task;
+	struct task_struct *tsk = current;
 
 	if (!tsk_used_math(tsk)) {
 		local_irq_enable();
@@ -613,7 +611,7 @@ void math_state_restore(void)
 		local_irq_disable();
 	}
 
-	clts();				/* Allow maths ops (or we recurse) */
+	__thread_fpu_begin(tsk);
 
 	__math_state_restore();
 }
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 86f1f09a738a..711091114119 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -47,7 +47,7 @@ void __sanitize_i387_state(struct task_struct *tsk)
 	if (!fx)
 		return;
 
-	BUG_ON(task_thread_info(tsk)->status & TS_USEDFPU);
+	BUG_ON(__thread_has_fpu(tsk));
 
 	xstate_bv = tsk->thread.fpu.state->xsave.xsave_hdr.xstate_bv;
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 579a0b51696a..4ea76784fe65 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1456,7 +1456,7 @@ static void __vmx_load_host_state(struct vcpu_vmx *vmx)
 #ifdef CONFIG_X86_64
 	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
 #endif
-	if (current_thread_info()->status & TS_USEDFPU)
+	if (__thread_has_fpu(current))
 		clts();
 	load_gdt(&__get_cpu_var(host_gdt));
 }
-- 
1.7.9.188.g12766.dirty


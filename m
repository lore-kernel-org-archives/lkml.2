Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab2BSWhU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 17:37:20 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37128 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab2BSWhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 17:37:18 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.68.195.73 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
Date: Sun, 19 Feb 2012 14:37:14 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@i5.linux-foundation.org
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
cc: x86@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] i387: support lazy restore of FPU state
In-Reply-To: <alpine.LFD.2.02.1202191423270.3898@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.02.1202191426460.3898@i5.linux-foundation.org>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org> <alpine.LFD.2.02.1202191423270.3898@i5.linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 19 Feb 2012 13:27:00 -0800

This makes us recognize when we try to restore FPU state that matches
what we already have in the FPU on this CPU, and avoids the restore
entirely if so.

To do this, we add two new data fields:

 - a percpu 'fpu_owner_task' variable that gets written any time we
   update the "has_fpu" field, and thus acts as a kind of back-pointer
   to the task that owns the CPU.  The exception is when we save the FPU
   state as part of a context switch - if the save can keep the FPU
   state around, we leave the 'fpu_owner_task' variable pointing at the
   task whose FP state still remains on the CPU.

 - a per-thread "last cpu" field, that indicates which CPU that thread
   used its FPU on last.

These two fields together can be used when next switching back to the
task to see if the CPU still matches, and nobody else has taken over the
FPU state.  In that case, we can avoid the 'f[x]rstor' entirely, and
just clear the CR0.TS bit.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---

The argument why this is "obviously correct" goes as follows (but somebody 
*really* should double-check my logic):

 - on *every* task switch from task A, we write A->thread.fpu.last_cpu, 
   whether we owned the FPU or not. And we only write a real CPU number in 
   the case where we owned it, and the FPU save left the state untouched 
   in the FPU.

 - so when we switch into task A next time, comparing the current CPU 
   number with that 'last_cpu' field inarguably says "when I last switched 
   out, I really saved it on this CPU"

   That, together with verifying that the per-cpu "fpu_owner_task" matches 
   "task A", guarantees that the state is really valid. Because we will 
   clear (or set to another task) fpu_owner_task if it ever gets 
   switched to anything else.

But somebody should really validate this. Think through all the 
kernel_fpu_begin() etc cases. I think it looks pretty obvious, and it 
really does seem to work and improve task switching, but...

                  Linus

---
 arch/x86/include/asm/i387.h      |   35 +++++++++++++++++++++++------------
 arch/x86/include/asm/processor.h |    3 ++-
 arch/x86/kernel/cpu/common.c     |    2 ++
 arch/x86/kernel/process_32.c     |    2 +-
 arch/x86/kernel/process_64.c     |    2 +-
 5 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 251c366289b9..2a361ed26901 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -32,6 +32,8 @@ extern int init_fpu(struct task_struct *child);
 extern void math_state_restore(void);
 extern int dump_fpu(struct pt_regs *, struct user_i387_struct *);
 
+DECLARE_PER_CPU(struct task_struct *, fpu_owner_task);
+
 extern user_regset_active_fn fpregs_active, xfpregs_active;
 extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get,
 				xstateregs_get;
@@ -276,7 +278,7 @@ static inline int restore_fpu_checking(struct task_struct *tsk)
 		"emms\n\t"	  	/* clear stack tags */
 		"fildl %P[addr]",	/* set F?P to defined value */
 		X86_FEATURE_FXSAVE_LEAK,
-		[addr] "m" (tsk->thread.has_fpu));
+		[addr] "m" (tsk->thread.fpu.has_fpu));
 
 	return fpu_restore_checking(&tsk->thread.fpu);
 }
@@ -288,19 +290,21 @@ static inline int restore_fpu_checking(struct task_struct *tsk)
  */
 static inline int __thread_has_fpu(struct task_struct *tsk)
 {
-	return tsk->thread.has_fpu;
+	return tsk->thread.fpu.has_fpu;
 }
 
 /* Must be paired with an 'stts' after! */
 static inline void __thread_clear_has_fpu(struct task_struct *tsk)
 {
-	tsk->thread.has_fpu = 0;
+	tsk->thread.fpu.has_fpu = 0;
+	percpu_write(fpu_owner_task, NULL);
 }
 
 /* Must be paired with a 'clts' before! */
 static inline void __thread_set_has_fpu(struct task_struct *tsk)
 {
-	tsk->thread.has_fpu = 1;
+	tsk->thread.fpu.has_fpu = 1;
+	percpu_write(fpu_owner_task, tsk);
 }
 
 /*
@@ -345,19 +349,23 @@ typedef struct { int preload; } fpu_switch_t;
  * We don't do that yet, so "fpu_lazy_restore()" always returns
  * false, but some day..
  */
-#define fpu_lazy_restore(tsk) (0)
-#define fpu_lazy_state_intact(tsk) do { } while (0)
+static inline int fpu_lazy_restore(struct task_struct *new, unsigned int cpu)
+{
+	return new == percpu_read_stable(fpu_owner_task) &&
+		cpu == new->thread.fpu.last_cpu;
+}
 
-static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct task_struct *new)
+static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct task_struct *new, int cpu)
 {
 	fpu_switch_t fpu;
 
 	fpu.preload = tsk_used_math(new) && new->fpu_counter > 5;
 	if (__thread_has_fpu(old)) {
-		if (__save_init_fpu(old))
-			fpu_lazy_state_intact(old);
-		__thread_clear_has_fpu(old);
+		if (!__save_init_fpu(old))
+			cpu = ~0;
 		old->fpu_counter++;
+		old->thread.fpu.last_cpu = cpu;
+		old->thread.fpu.has_fpu = 0;	/* But leave fpu_owner_task! */
 
 		/* Don't change CR0.TS if we just switch! */
 		if (fpu.preload) {
@@ -367,8 +375,9 @@ static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct ta
 			stts();
 	} else {
 		old->fpu_counter = 0;
+		old->thread.fpu.last_cpu = ~0;
 		if (fpu.preload) {
-			if (fpu_lazy_restore(new))
+			if (fpu_lazy_restore(new, cpu))
 				fpu.preload = 0;
 			else
 				prefetch(new->thread.fpu.state);
@@ -464,8 +473,10 @@ static inline void kernel_fpu_begin(void)
 		__save_init_fpu(me);
 		__thread_clear_has_fpu(me);
 		/* We do 'stts()' in kernel_fpu_end() */
-	} else
+	} else {
+		percpu_write(fpu_owner_task, NULL);
 		clts();
+	}
 }
 
 static inline void kernel_fpu_end(void)
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index f7c89e231c6c..58545c97d071 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -374,6 +374,8 @@ union thread_xstate {
 };
 
 struct fpu {
+	unsigned int last_cpu;
+	unsigned int has_fpu;
 	union thread_xstate *state;
 };
 
@@ -454,7 +456,6 @@ struct thread_struct {
 	unsigned long		trap_no;
 	unsigned long		error_code;
 	/* floating point and extended processor state */
-	unsigned long		has_fpu;
 	struct fpu		fpu;
 #ifdef CONFIG_X86_32
 	/* Virtual 86 mode info */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d43cad74f166..b667148dfad7 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1044,6 +1044,8 @@ DEFINE_PER_CPU(char *, irq_stack_ptr) =
 
 DEFINE_PER_CPU(unsigned int, irq_count) = -1;
 
+DEFINE_PER_CPU(struct task_struct *, fpu_owner_task);
+
 /*
  * Special IST stacks which the CPU switches to when it calls
  * an IST-marked descriptor entry. Up to 7 stacks (hardware
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 80bfe1ab0031..15e6c6494e82 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -303,7 +303,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 
 	/* never put a printk in __switch_to... printk() calls wake_up*() indirectly */
 
-	fpu = switch_fpu_prepare(prev_p, next_p);
+	fpu = switch_fpu_prepare(prev_p, next_p, cpu);
 
 	/*
 	 * Reload esp0.
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 1fd94bc4279d..b6ba67d76402 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -388,7 +388,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	unsigned fsindex, gsindex;
 	fpu_switch_t fpu;
 
-	fpu = switch_fpu_prepare(prev_p, next_p);
+	fpu = switch_fpu_prepare(prev_p, next_p, cpu);
 
 	/*
 	 * Reload esp0, LDT and the page table pointer:
-- 
1.7.9.188.g12766.dirty


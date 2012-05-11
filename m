Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab2EKIB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:01:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:6295 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756955Ab2EKIBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:01:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="139414107"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, tj@kernel.org,
        cl@linux-foundation.org, tony.luck@intel.com, bp@amd64.org,
        davem@davemloft.net
Cc: akpm@linux-foundation.org, ebiederm@xmission.com, sfr@canb.auug.org.au,
        alex.shi@intel.com, luto@mit.edu, glommer@parallels.com,
        fernando@oss.ntt.co.jp, vapier@gentoo.org, eric.dumazet@gmail.com,
        dzickus@redhat.com, dhowells@redhat.com, cbouatmailru@gmail.com,
        fenghua.yu@intel.com, jkosina@suse.cz, ext-phil.2.carmody@nokia.com,
        dan.carpenter@oracle.com, len.brown@intel.com, fweisbec@gmail.com,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org, anton@samba.org,
        kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] x86: replace percpu_xxx funcs with this_cpu_xxx
Date: Fri, 11 May 2012 16:00:14 +0800
Message-Id: <1336723215-16660-3-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336723215-16660-1-git-send-email-alex.shi@intel.com>
References: <1336723215-16660-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since percpu_xxx() serial functions are duplicated with this_cpu_xxx().
Removing percpu_xxx() definition and replacing them by this_cpu_xxx()
in code. There is no function change in this patch, just preparation for
later percpu_xxx serial function removing.

On x86 machine the this_cpu_xxx() serial functions are same as
__this_cpu_xxx() without no unnecessary premmpt enable/disable.

Thanks for Stephen Rothwell, he found and fixed a i386 build error in
the patch.

Also thanks for Andrew Morton, he kept updating the patchset in Linus'
tree.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Acked-by: Christoph Lameter <cl@gentwo.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 arch/x86/include/asm/compat.h         |    2 +-
 arch/x86/include/asm/current.h        |    2 +-
 arch/x86/include/asm/desc.h           |    1 +
 arch/x86/include/asm/fpu-internal.h   |    6 +++---
 arch/x86/include/asm/hardirq.h        |    9 +++++----
 arch/x86/include/asm/irq_regs.h       |    4 ++--
 arch/x86/include/asm/mmu_context.h    |   12 ++++++------
 arch/x86/include/asm/percpu.h         |    8 ++++----
 arch/x86/include/asm/smp.h            |    4 ++--
 arch/x86/include/asm/stackprotector.h |    4 ++--
 arch/x86/include/asm/thread_info.h    |    2 +-
 arch/x86/include/asm/tlbflush.h       |    4 ++--
 arch/x86/kernel/cpu/common.c          |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c      |    4 ++--
 arch/x86/kernel/i387.c                |    2 +-
 arch/x86/kernel/nmi_selftest.c        |    1 +
 arch/x86/kernel/paravirt.c            |   12 ++++++------
 arch/x86/kernel/process.c             |    2 +-
 arch/x86/kernel/process_32.c          |    2 +-
 arch/x86/kernel/process_64.c          |   10 +++++-----
 arch/x86/mm/tlb.c                     |   10 +++++-----
 include/linux/topology.h              |    4 ++--
 22 files changed, 55 insertions(+), 52 deletions(-)

diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index d680579..7cf3f49 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -229,7 +229,7 @@ static inline void __user *arch_compat_alloc_user_space(long len)
 		sp = task_pt_regs(current)->sp;
 	} else {
 		/* -128 for the x32 ABI redzone */
-		sp = percpu_read(old_rsp) - 128;
+		sp = __this_cpu_read(old_rsp) - 128;
 	}
 
 	return (void __user *)round_down(sp - len, 16);
diff --git a/arch/x86/include/asm/current.h b/arch/x86/include/asm/current.h
index 4d447b7..9476c04 100644
--- a/arch/x86/include/asm/current.h
+++ b/arch/x86/include/asm/current.h
@@ -11,7 +11,7 @@ DECLARE_PER_CPU(struct task_struct *, current_task);
 
 static __always_inline struct task_struct *get_current(void)
 {
-	return percpu_read_stable(current_task);
+	return this_cpu_read_stable(current_task);
 }
 
 #define current get_current()
diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index e95822d..8bf1c06 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -6,6 +6,7 @@
 #include <asm/mmu.h>
 
 #include <linux/smp.h>
+#include <linux/percpu.h>
 
 static inline void fill_ldt(struct desc_struct *desc, const struct user_desc *info)
 {
diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 4fa8815..75f4c6d 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -290,14 +290,14 @@ static inline int __thread_has_fpu(struct task_struct *tsk)
 static inline void __thread_clear_has_fpu(struct task_struct *tsk)
 {
 	tsk->thread.fpu.has_fpu = 0;
-	percpu_write(fpu_owner_task, NULL);
+	this_cpu_write(fpu_owner_task, NULL);
 }
 
 /* Must be paired with a 'clts' before! */
 static inline void __thread_set_has_fpu(struct task_struct *tsk)
 {
 	tsk->thread.fpu.has_fpu = 1;
-	percpu_write(fpu_owner_task, tsk);
+	this_cpu_write(fpu_owner_task, tsk);
 }
 
 /*
@@ -344,7 +344,7 @@ typedef struct { int preload; } fpu_switch_t;
  */
 static inline int fpu_lazy_restore(struct task_struct *new, unsigned int cpu)
 {
-	return new == percpu_read_stable(fpu_owner_task) &&
+	return new == this_cpu_read_stable(fpu_owner_task) &&
 		cpu == new->thread.fpu.last_cpu;
 }
 
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 382f75d..d3895db 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -35,14 +35,15 @@ DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
 
 #define __ARCH_IRQ_STAT
 
-#define inc_irq_stat(member)	percpu_inc(irq_stat.member)
+#define inc_irq_stat(member)	this_cpu_inc(irq_stat.member)
 
-#define local_softirq_pending()	percpu_read(irq_stat.__softirq_pending)
+#define local_softirq_pending()	this_cpu_read(irq_stat.__softirq_pending)
 
 #define __ARCH_SET_SOFTIRQ_PENDING
 
-#define set_softirq_pending(x)	percpu_write(irq_stat.__softirq_pending, (x))
-#define or_softirq_pending(x)	percpu_or(irq_stat.__softirq_pending, (x))
+#define set_softirq_pending(x)	\
+		this_cpu_write(irq_stat.__softirq_pending, (x))
+#define or_softirq_pending(x)	this_cpu_or(irq_stat.__softirq_pending, (x))
 
 extern void ack_bad_irq(unsigned int irq);
 
diff --git a/arch/x86/include/asm/irq_regs.h b/arch/x86/include/asm/irq_regs.h
index 7784322..d82250b 100644
--- a/arch/x86/include/asm/irq_regs.h
+++ b/arch/x86/include/asm/irq_regs.h
@@ -15,7 +15,7 @@ DECLARE_PER_CPU(struct pt_regs *, irq_regs);
 
 static inline struct pt_regs *get_irq_regs(void)
 {
-	return percpu_read(irq_regs);
+	return this_cpu_read(irq_regs);
 }
 
 static inline struct pt_regs *set_irq_regs(struct pt_regs *new_regs)
@@ -23,7 +23,7 @@ static inline struct pt_regs *set_irq_regs(struct pt_regs *new_regs)
 	struct pt_regs *old_regs;
 
 	old_regs = get_irq_regs();
-	percpu_write(irq_regs, new_regs);
+	this_cpu_write(irq_regs, new_regs);
 
 	return old_regs;
 }
diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 6902152..cdbf367 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -25,8 +25,8 @@ void destroy_context(struct mm_struct *mm);
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
 #ifdef CONFIG_SMP
-	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
-		percpu_write(cpu_tlbstate.state, TLBSTATE_LAZY);
+	if (this_cpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
+		this_cpu_write(cpu_tlbstate.state, TLBSTATE_LAZY);
 #endif
 }
 
@@ -37,8 +37,8 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 
 	if (likely(prev != next)) {
 #ifdef CONFIG_SMP
-		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
-		percpu_write(cpu_tlbstate.active_mm, next);
+		this_cpu_write(cpu_tlbstate.state, TLBSTATE_OK);
+		this_cpu_write(cpu_tlbstate.active_mm, next);
 #endif
 		cpumask_set_cpu(cpu, mm_cpumask(next));
 
@@ -56,8 +56,8 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	}
 #ifdef CONFIG_SMP
 	else {
-		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
-		BUG_ON(percpu_read(cpu_tlbstate.active_mm) != next);
+		this_cpu_write(cpu_tlbstate.state, TLBSTATE_OK);
+		BUG_ON(this_cpu_read(cpu_tlbstate.active_mm) != next);
 
 		if (!cpumask_test_and_set_cpu(cpu, mm_cpumask(next))) {
 			/* We were in lazy tlb mode and leave_mm disabled
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 7a11910..967ee3b 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -46,7 +46,7 @@
 
 #ifdef CONFIG_SMP
 #define __percpu_prefix		"%%"__stringify(__percpu_seg)":"
-#define __my_cpu_offset		percpu_read(this_cpu_off)
+#define __my_cpu_offset		this_cpu_read(this_cpu_off)
 
 /*
  * Compared to the generic __my_cpu_offset version, the following
@@ -352,15 +352,15 @@ do {									\
 
 /*
  * percpu_read() makes gcc load the percpu variable every time it is
- * accessed while percpu_read_stable() allows the value to be cached.
- * percpu_read_stable() is more efficient and can be used if its value
+ * accessed while this_cpu_read_stable() allows the value to be cached.
+ * this_cpu_read_stable() is more efficient and can be used if its value
  * is guaranteed to be valid across cpus.  The current users include
  * get_current() and get_thread_info() both of which are actually
  * per-thread variables implemented as per-cpu variables and thus
  * stable for the duration of the respective task.
  */
 #define percpu_read(var)		percpu_from_op("mov", var, "m" (var))
-#define percpu_read_stable(var)		percpu_from_op("mov", var, "p" (&(var)))
+#define this_cpu_read_stable(var)	percpu_from_op("mov", var, "p" (&(var)))
 #define percpu_write(var, val)		percpu_to_op("mov", var, val)
 #define percpu_add(var, val)		percpu_add_op(var, val)
 #define percpu_sub(var, val)		percpu_add_op(var, -(val))
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 0434c40..e276f6b 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -188,11 +188,11 @@ extern unsigned disabled_cpus __cpuinitdata;
  * from the initial startup. We map APIC_BASE very early in page_setup(),
  * so this is correct in the x86 case.
  */
-#define raw_smp_processor_id() (percpu_read(cpu_number))
+#define raw_smp_processor_id() (this_cpu_read(cpu_number))
 extern int safe_smp_processor_id(void);
 
 #elif defined(CONFIG_X86_64_SMP)
-#define raw_smp_processor_id() (percpu_read(cpu_number))
+#define raw_smp_processor_id() (this_cpu_read(cpu_number))
 
 #define stack_smp_processor_id()					\
 ({								\
diff --git a/arch/x86/include/asm/stackprotector.h b/arch/x86/include/asm/stackprotector.h
index b5d9533..6a99859 100644
--- a/arch/x86/include/asm/stackprotector.h
+++ b/arch/x86/include/asm/stackprotector.h
@@ -75,9 +75,9 @@ static __always_inline void boot_init_stack_canary(void)
 
 	current->stack_canary = canary;
 #ifdef CONFIG_X86_64
-	percpu_write(irq_stack_union.stack_canary, canary);
+	this_cpu_write(irq_stack_union.stack_canary, canary);
 #else
-	percpu_write(stack_canary.canary, canary);
+	this_cpu_write(stack_canary.canary, canary);
 #endif
 }
 
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index ad6df8c..f67fd89 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -222,7 +222,7 @@ DECLARE_PER_CPU(unsigned long, kernel_stack);
 static inline struct thread_info *current_thread_info(void)
 {
 	struct thread_info *ti;
-	ti = (void *)(percpu_read_stable(kernel_stack) +
+	ti = (void *)(this_cpu_read_stable(kernel_stack) +
 		      KERNEL_STACK_OFFSET - THREAD_SIZE);
 	return ti;
 }
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index c0e108e..1620d23 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -156,8 +156,8 @@ DECLARE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate);
 
 static inline void reset_lazy_tlbstate(void)
 {
-	percpu_write(cpu_tlbstate.state, 0);
-	percpu_write(cpu_tlbstate.active_mm, &init_mm);
+	this_cpu_write(cpu_tlbstate.state, 0);
+	this_cpu_write(cpu_tlbstate.active_mm, &init_mm);
 }
 
 #endif	/* SMP */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cf79302..82f29e7 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1185,7 +1185,7 @@ void __cpuinit cpu_init(void)
 	oist = &per_cpu(orig_ist, cpu);
 
 #ifdef CONFIG_NUMA
-	if (cpu != 0 && percpu_read(numa_node) == 0 &&
+	if (cpu != 0 && this_cpu_read(numa_node) == 0 &&
 	    early_cpu_to_node(cpu) != NUMA_NO_NODE)
 		set_numa_node(early_cpu_to_node(cpu));
 #endif
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index d086a09..c0276d5 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -583,7 +583,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 	struct mce m;
 	int i;
 
-	percpu_inc(mce_poll_count);
+	this_cpu_inc(mce_poll_count);
 
 	mce_gather_info(&m, NULL);
 
@@ -1015,7 +1015,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 
 	atomic_inc(&mce_entry);
 
-	percpu_inc(mce_exception_count);
+	this_cpu_inc(mce_exception_count);
 
 	if (!banks)
 		goto out;
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 2d6e649..f250431 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -88,7 +88,7 @@ void kernel_fpu_begin(void)
 		__thread_clear_has_fpu(me);
 		/* We do 'stts()' in kernel_fpu_end() */
 	} else {
-		percpu_write(fpu_owner_task, NULL);
+		this_cpu_write(fpu_owner_task, NULL);
 		clts();
 	}
 }
diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
index 2c39dcd..ff36986 100644
--- a/arch/x86/kernel/nmi_selftest.c
+++ b/arch/x86/kernel/nmi_selftest.c
@@ -13,6 +13,7 @@
 #include <linux/cpumask.h>
 #include <linux/delay.h>
 #include <linux/init.h>
+#include <linux/percpu.h>
 
 #include <asm/apic.h>
 #include <asm/nmi.h>
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index ab13760..9ce8859 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -241,16 +241,16 @@ static DEFINE_PER_CPU(enum paravirt_lazy_mode, paravirt_lazy_mode) = PARAVIRT_LA
 
 static inline void enter_lazy(enum paravirt_lazy_mode mode)
 {
-	BUG_ON(percpu_read(paravirt_lazy_mode) != PARAVIRT_LAZY_NONE);
+	BUG_ON(this_cpu_read(paravirt_lazy_mode) != PARAVIRT_LAZY_NONE);
 
-	percpu_write(paravirt_lazy_mode, mode);
+	this_cpu_write(paravirt_lazy_mode, mode);
 }
 
 static void leave_lazy(enum paravirt_lazy_mode mode)
 {
-	BUG_ON(percpu_read(paravirt_lazy_mode) != mode);
+	BUG_ON(this_cpu_read(paravirt_lazy_mode) != mode);
 
-	percpu_write(paravirt_lazy_mode, PARAVIRT_LAZY_NONE);
+	this_cpu_write(paravirt_lazy_mode, PARAVIRT_LAZY_NONE);
 }
 
 void paravirt_enter_lazy_mmu(void)
@@ -267,7 +267,7 @@ void paravirt_start_context_switch(struct task_struct *prev)
 {
 	BUG_ON(preemptible());
 
-	if (percpu_read(paravirt_lazy_mode) == PARAVIRT_LAZY_MMU) {
+	if (this_cpu_read(paravirt_lazy_mode) == PARAVIRT_LAZY_MMU) {
 		arch_leave_lazy_mmu_mode();
 		set_ti_thread_flag(task_thread_info(prev), TIF_LAZY_MMU_UPDATES);
 	}
@@ -289,7 +289,7 @@ enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
 	if (in_interrupt())
 		return PARAVIRT_LAZY_NONE;
 
-	return percpu_read(paravirt_lazy_mode);
+	return this_cpu_read(paravirt_lazy_mode);
 }
 
 void arch_flush_lazy_mmu_mode(void)
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 1d92a5a..857adff 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -377,7 +377,7 @@ static inline void play_dead(void)
 #ifdef CONFIG_X86_64
 void enter_idle(void)
 {
-	percpu_write(is_idle, 1);
+	this_cpu_write(is_idle, 1);
 	atomic_notifier_call_chain(&idle_notifier, IDLE_START, NULL);
 }
 
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index ae68473..01d8d40 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -302,7 +302,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 
 	switch_fpu_finish(next_p, fpu);
 
-	percpu_write(current_task, next_p);
+	this_cpu_write(current_task, next_p);
 
 	return prev_p;
 }
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 43d8b48..28e8102 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -237,7 +237,7 @@ start_thread_common(struct pt_regs *regs, unsigned long new_ip,
 	current->thread.usersp	= new_sp;
 	regs->ip		= new_ip;
 	regs->sp		= new_sp;
-	percpu_write(old_rsp, new_sp);
+	this_cpu_write(old_rsp, new_sp);
 	regs->cs		= _cs;
 	regs->ss		= _ss;
 	regs->flags		= X86_EFLAGS_IF;
@@ -359,11 +359,11 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	/*
 	 * Switch the PDA and FPU contexts.
 	 */
-	prev->usersp = percpu_read(old_rsp);
-	percpu_write(old_rsp, next->usersp);
-	percpu_write(current_task, next_p);
+	prev->usersp = this_cpu_read(old_rsp);
+	this_cpu_write(old_rsp, next->usersp);
+	this_cpu_write(current_task, next_p);
 
-	percpu_write(kernel_stack,
+	this_cpu_write(kernel_stack,
 		  (unsigned long)task_stack_page(next_p) +
 		  THREAD_SIZE - KERNEL_STACK_OFFSET);
 
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index d6c0418..3804471 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -61,10 +61,10 @@ static DEFINE_PER_CPU_READ_MOSTLY(int, tlb_vector_offset);
  */
 void leave_mm(int cpu)
 {
-	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
+	if (this_cpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
 		BUG();
 	cpumask_clear_cpu(cpu,
-			  mm_cpumask(percpu_read(cpu_tlbstate.active_mm)));
+			  mm_cpumask(this_cpu_read(cpu_tlbstate.active_mm)));
 	load_cr3(swapper_pg_dir);
 }
 EXPORT_SYMBOL_GPL(leave_mm);
@@ -152,8 +152,8 @@ void smp_invalidate_interrupt(struct pt_regs *regs)
 		 * BUG();
 		 */
 
-	if (f->flush_mm == percpu_read(cpu_tlbstate.active_mm)) {
-		if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
+	if (f->flush_mm == this_cpu_read(cpu_tlbstate.active_mm)) {
+		if (this_cpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
 			if (f->flush_va == TLB_FLUSH_ALL)
 				local_flush_tlb();
 			else
@@ -322,7 +322,7 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
 static void do_flush_tlb_all(void *info)
 {
 	__flush_tlb_all();
-	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_LAZY)
+	if (this_cpu_read(cpu_tlbstate.state) == TLBSTATE_LAZY)
 		leave_mm(smp_processor_id());
 }
 
diff --git a/include/linux/topology.h b/include/linux/topology.h
index e26db03..9dc427c 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -239,7 +239,7 @@ static inline int cpu_to_node(int cpu)
 #ifndef set_numa_node
 static inline void set_numa_node(int node)
 {
-	percpu_write(numa_node, node);
+	this_cpu_write(numa_node, node);
 }
 #endif
 
@@ -274,7 +274,7 @@ DECLARE_PER_CPU(int, _numa_mem_);
 #ifndef set_numa_mem
 static inline void set_numa_mem(int node)
 {
-	percpu_write(_numa_mem_, node);
+	this_cpu_write(_numa_mem_, node);
 }
 #endif
 
-- 
1.7.5.4


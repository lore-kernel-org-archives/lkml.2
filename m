Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab1KUJKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 04:10:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:25617 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab1KUJK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 04:10:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="78282451"
Subject: Re: [PATCH 3/3] Code clean up for percpu_xxx() functions
From: "Alex,Shi" <alex.shi@intel.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "avi@redhat.com" <avi@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        "kaber@trash.net" <kaber@trash.net>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jeremy@xensource.com" <jeremy@xensource.com>,
        Andi Kleen <ak@linux.intel.com>
In-Reply-To: <1319096139.23426.184.camel@debian>
References: <1318237851.27949.190.camel@debian>
	 <alpine.DEB.2.00.1110101026080.16264@router.home>
	 <1318324774.27949.693.camel@debian>
	 <alpine.DEB.2.00.1110110910480.3388@router.home>
	 <1318382964.27949.782.camel@debian> <1318428673.29699.13.camel@debian>
	 <alpine.DEB.2.00.1110120910540.26610@router.home>
	 <1318908091.23426.52.camel@debian>
	 <alpine.DEB.2.00.1110180932330.687@router.home>
	 <1319016218.23426.104.camel@debian>
	 <alpine.DEB.2.00.1110191033480.24001@router.home>
	 <1319096139.23426.184.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Nov 2011 17:10:12 +0800
Message-ID: <1321866612.30341.572.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

refreshed the patch on latest upstream kernel. Any comments or picking
up are appreciated. 

===
>From 0dce61dc88b8ed2687b4d5c0633aa54d1f66fdc0 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Tue, 22 Nov 2011 00:05:37 +0800
Subject: [PATCH 3/3] Code clean up for percpu_xxx() functions

Since percpu_xxx() serial functions are duplicate with this_cpu_xxx().
Removing percpu_xxx() definition and replacing them by this_cpu_xxx() in
code.

And further more, as Christoph Lameter's requirement, I try to use
__this_cpu_xx to replace this_cpu_xxx if it is in preempt safe scenario.
The preempt safe scenarios include:
1, in irq/softirq/nmi handler
2, protected by preempt_disable
3, protected by spin_lock
4, if the code context imply that it is preempt safe, like the code is
follows or be followed a preempt safe code.

I left the xen code unchanged, since no idea of them.

BTW, In fact, this_cpu_xxx are same as __this_cpu_xxx since all funcs
implement in a single instruction for x86 machine. But it maybe
different for other platforms, so, doing this distinguish is helpful for
other platforms' performance.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Acked-by: Christoph Lameter <cl@gentwo.org>
---
 arch/x86/include/asm/current.h        |    2 +-
 arch/x86/include/asm/hardirq.h        |    9 +++--
 arch/x86/include/asm/irq_regs.h       |    4 +-
 arch/x86/include/asm/mmu_context.h    |   12 ++++----
 arch/x86/include/asm/percpu.h         |   24 ++++++---------
 arch/x86/include/asm/smp.h            |    4 +-
 arch/x86/include/asm/stackprotector.h |    4 +-
 arch/x86/include/asm/thread_info.h    |    2 +-
 arch/x86/include/asm/tlbflush.h       |    4 +-
 arch/x86/kernel/cpu/common.c          |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c      |    4 +-
 arch/x86/kernel/paravirt.c            |   12 ++++----
 arch/x86/kernel/process_32.c          |    2 +-
 arch/x86/kernel/process_64.c          |   12 ++++----
 arch/x86/mm/tlb.c                     |   10 +++---
 arch/x86/xen/enlighten.c              |    6 ++--
 arch/x86/xen/irq.c                    |    8 ++--
 arch/x86/xen/mmu.c                    |   20 ++++++------
 arch/x86/xen/multicalls.h             |    2 +-
 arch/x86/xen/smp.c                    |    2 +-
 include/linux/percpu.h                |   53 ---------------------------------
 include/linux/topology.h              |    4 +-
 22 files changed, 73 insertions(+), 129 deletions(-)

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
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 55e4de6..2890444 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -35,14 +35,15 @@ DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
 
 #define __ARCH_IRQ_STAT
 
-#define inc_irq_stat(member)	percpu_inc(irq_stat.member)
+#define inc_irq_stat(member)	__this_cpu_inc(irq_stat.member)
 
-#define local_softirq_pending()	percpu_read(irq_stat.__softirq_pending)
+#define local_softirq_pending()	__this_cpu_read(irq_stat.__softirq_pending)
 
 #define __ARCH_SET_SOFTIRQ_PENDING
 
-#define set_softirq_pending(x)	percpu_write(irq_stat.__softirq_pending, (x))
-#define or_softirq_pending(x)	percpu_or(irq_stat.__softirq_pending, (x))
+#define set_softirq_pending(x)	\
+		__this_cpu_write(irq_stat.__softirq_pending, (x))
+#define or_softirq_pending(x)	__this_cpu_or(irq_stat.__softirq_pending, (x))
 
 extern void ack_bad_irq(unsigned int irq);
 
diff --git a/arch/x86/include/asm/irq_regs.h b/arch/x86/include/asm/irq_regs.h
index 7784322..15639ed 100644
--- a/arch/x86/include/asm/irq_regs.h
+++ b/arch/x86/include/asm/irq_regs.h
@@ -15,7 +15,7 @@ DECLARE_PER_CPU(struct pt_regs *, irq_regs);
 
 static inline struct pt_regs *get_irq_regs(void)
 {
-	return percpu_read(irq_regs);
+	return __this_cpu_read(irq_regs);
 }
 
 static inline struct pt_regs *set_irq_regs(struct pt_regs *new_regs)
@@ -23,7 +23,7 @@ static inline struct pt_regs *set_irq_regs(struct pt_regs *new_regs)
 	struct pt_regs *old_regs;
 
 	old_regs = get_irq_regs();
-	percpu_write(irq_regs, new_regs);
+	__this_cpu_write(irq_regs, new_regs);
 
 	return old_regs;
 }
diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 6902152..02ca533 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -25,8 +25,8 @@ void destroy_context(struct mm_struct *mm);
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
 #ifdef CONFIG_SMP
-	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
-		percpu_write(cpu_tlbstate.state, TLBSTATE_LAZY);
+	if (__this_cpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
+		__this_cpu_write(cpu_tlbstate.state, TLBSTATE_LAZY);
 #endif
 }
 
@@ -37,8 +37,8 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 
 	if (likely(prev != next)) {
 #ifdef CONFIG_SMP
-		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
-		percpu_write(cpu_tlbstate.active_mm, next);
+		__this_cpu_write(cpu_tlbstate.state, TLBSTATE_OK);
+		__this_cpu_write(cpu_tlbstate.active_mm, next);
 #endif
 		cpumask_set_cpu(cpu, mm_cpumask(next));
 
@@ -56,8 +56,8 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	}
 #ifdef CONFIG_SMP
 	else {
-		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
-		BUG_ON(percpu_read(cpu_tlbstate.active_mm) != next);
+		__this_cpu_write(cpu_tlbstate.state, TLBSTATE_OK);
+		BUG_ON(__this_cpu_read(cpu_tlbstate.active_mm) != next);
 
 		if (!cpumask_test_and_set_cpu(cpu, mm_cpumask(next))) {
 			/* We were in lazy tlb mode and leave_mm disabled
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 3470c9d..520005e 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -46,7 +46,7 @@
 
 #ifdef CONFIG_SMP
 #define __percpu_prefix		"%%"__stringify(__percpu_seg)":"
-#define __my_cpu_offset		percpu_read(this_cpu_off)
+#define __my_cpu_offset		__this_cpu_read(this_cpu_off)
 
 /*
  * Compared to the generic __my_cpu_offset version, the following
@@ -351,23 +351,15 @@ do {									\
 })
 
 /*
- * percpu_read() makes gcc load the percpu variable every time it is
- * accessed while percpu_read_stable() allows the value to be cached.
- * percpu_read_stable() is more efficient and can be used if its value
+ * this_cpu_read() makes gcc load the percpu variable every time it is
+ * accessed while this_cpu_read_stable() allows the value to be cached.
+ * this_cpu_read_stable() is more efficient and can be used if its value
  * is guaranteed to be valid across cpus.  The current users include
  * get_current() and get_thread_info() both of which are actually
  * per-thread variables implemented as per-cpu variables and thus
  * stable for the duration of the respective task.
  */
-#define percpu_read(var)		percpu_from_op("mov", var, "m" (var))
-#define percpu_read_stable(var)		percpu_from_op("mov", var, "p" (&(var)))
-#define percpu_write(var, val)		percpu_to_op("mov", var, val)
-#define percpu_add(var, val)		percpu_add_op(var, val)
-#define percpu_sub(var, val)		percpu_add_op(var, -(val))
-#define percpu_and(var, val)		percpu_to_op("and", var, val)
-#define percpu_or(var, val)		percpu_to_op("or", var, val)
-#define percpu_xor(var, val)		percpu_to_op("xor", var, val)
-#define percpu_inc(var)		percpu_unary_op("inc", var)
+#define this_cpu_read_stable(var)	percpu_from_op("mov", var, "p" (&(var)))
 
 #define __this_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define __this_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
@@ -551,7 +543,11 @@ static __always_inline int x86_this_cpu_constant_test_bit(unsigned int nr,
 {
 	unsigned long __percpu *a = (unsigned long *)addr + nr / BITS_PER_LONG;
 
-	return ((1UL << (nr % BITS_PER_LONG)) & percpu_read(*a)) != 0;
+#ifdef CONFIG_X86_64
+	return ((1UL << (nr % BITS_PER_LONG)) & __this_cpu_read_8(*a)) != 0;
+#else
+	return ((1UL << (nr % BITS_PER_LONG)) & __this_cpu_read_4(*a)) != 0;
+#endif
 }
 
 static inline int x86_this_cpu_variable_test_bit(int nr,
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 73b11bc..dd5749b 100644
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
index 1575177..e8a60c9 100644
--- a/arch/x86/include/asm/stackprotector.h
+++ b/arch/x86/include/asm/stackprotector.h
@@ -76,9 +76,9 @@ static __always_inline void boot_init_stack_canary(void)
 
 	current->stack_canary = canary;
 #ifdef CONFIG_X86_64
-	percpu_write(irq_stack_union.stack_canary, canary);
+	__this_cpu_write(irq_stack_union.stack_canary, canary);
 #else
-	percpu_write(stack_canary.canary, canary);
+	__this_cpu_write(stack_canary.canary, canary);
 #endif
 }
 
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index a1fe5c1..8b19667 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -219,7 +219,7 @@ DECLARE_PER_CPU(unsigned long, kernel_stack);
 static inline struct thread_info *current_thread_info(void)
 {
 	struct thread_info *ti;
-	ti = (void *)(percpu_read_stable(kernel_stack) +
+	ti = (void *)(this_cpu_read_stable(kernel_stack) +
 		      KERNEL_STACK_OFFSET - THREAD_SIZE);
 	return ti;
 }
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 169be89..e90eec0 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -156,8 +156,8 @@ DECLARE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate);
 
 static inline void reset_lazy_tlbstate(void)
 {
-	percpu_write(cpu_tlbstate.state, 0);
-	percpu_write(cpu_tlbstate.active_mm, &init_mm);
+	__this_cpu_write(cpu_tlbstate.state, 0);
+	__this_cpu_write(cpu_tlbstate.active_mm, &init_mm);
 }
 
 #endif	/* SMP */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index aa003b1..d9b4fe7 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1163,7 +1163,7 @@ void __cpuinit cpu_init(void)
 	oist = &per_cpu(orig_ist, cpu);
 
 #ifdef CONFIG_NUMA
-	if (cpu != 0 && percpu_read(numa_node) == 0 &&
+	if (cpu != 0 && __this_cpu_read(numa_node) == 0 &&
 	    early_cpu_to_node(cpu) != NUMA_NO_NODE)
 		set_numa_node(early_cpu_to_node(cpu));
 #endif
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 2af127d..b7f3a1e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -514,7 +514,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 	struct mce m;
 	int i;
 
-	percpu_inc(mce_poll_count);
+	__this_cpu_inc(mce_poll_count);
 
 	mce_gather_info(&m, NULL);
 
@@ -906,7 +906,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 
 	atomic_inc(&mce_entry);
 
-	percpu_inc(mce_exception_count);
+	__this_cpu_inc(mce_exception_count);
 
 	if (!banks)
 		goto out;
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index d90272e..2f0c1d1 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -239,16 +239,16 @@ static DEFINE_PER_CPU(enum paravirt_lazy_mode, paravirt_lazy_mode) = PARAVIRT_LA
 
 static inline void enter_lazy(enum paravirt_lazy_mode mode)
 {
-	BUG_ON(percpu_read(paravirt_lazy_mode) != PARAVIRT_LAZY_NONE);
+	BUG_ON(__this_cpu_read(paravirt_lazy_mode) != PARAVIRT_LAZY_NONE);
 
-	percpu_write(paravirt_lazy_mode, mode);
+	__this_cpu_write(paravirt_lazy_mode, mode);
 }
 
 static void leave_lazy(enum paravirt_lazy_mode mode)
 {
-	BUG_ON(percpu_read(paravirt_lazy_mode) != mode);
+	BUG_ON(__this_cpu_read(paravirt_lazy_mode) != mode);
 
-	percpu_write(paravirt_lazy_mode, PARAVIRT_LAZY_NONE);
+	__this_cpu_write(paravirt_lazy_mode, PARAVIRT_LAZY_NONE);
 }
 
 void paravirt_enter_lazy_mmu(void)
@@ -265,7 +265,7 @@ void paravirt_start_context_switch(struct task_struct *prev)
 {
 	BUG_ON(preemptible());
 
-	if (percpu_read(paravirt_lazy_mode) == PARAVIRT_LAZY_MMU) {
+	if (__this_cpu_read(paravirt_lazy_mode) == PARAVIRT_LAZY_MMU) {
 		arch_leave_lazy_mmu_mode();
 		set_ti_thread_flag(task_thread_info(prev), TIF_LAZY_MMU_UPDATES);
 	}
@@ -287,7 +287,7 @@ enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
 	if (in_interrupt())
 		return PARAVIRT_LAZY_NONE;
 
-	return percpu_read(paravirt_lazy_mode);
+	return __this_cpu_read(paravirt_lazy_mode);
 }
 
 void arch_flush_lazy_mmu_mode(void)
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 795b79f..b383fe8 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -375,7 +375,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	if (prev->gs | next->gs)
 		lazy_load_gs(next->gs);
 
-	percpu_write(current_task, next_p);
+	__this_cpu_write(current_task, next_p);
 
 	return prev_p;
 }
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3bd7e6e..7b6edbb 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -74,7 +74,7 @@ EXPORT_SYMBOL_GPL(idle_notifier_unregister);
 
 void enter_idle(void)
 {
-	percpu_write(is_idle, 1);
+	__this_cpu_write(is_idle, 1);
 	atomic_notifier_call_chain(&idle_notifier, IDLE_START, NULL);
 }
 
@@ -338,7 +338,7 @@ start_thread_common(struct pt_regs *regs, unsigned long new_ip,
 	load_gs_index(0);
 	regs->ip		= new_ip;
 	regs->sp		= new_sp;
-	percpu_write(old_rsp, new_sp);
+	this_cpu_write(old_rsp, new_sp);
 	regs->cs		= _cs;
 	regs->ss		= _ss;
 	regs->flags		= X86_EFLAGS_IF;
@@ -472,11 +472,11 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	/*
 	 * Switch the PDA and FPU contexts.
 	 */
-	prev->usersp = percpu_read(old_rsp);
-	percpu_write(old_rsp, next->usersp);
-	percpu_write(current_task, next_p);
+	prev->usersp = __this_cpu_read(old_rsp);
+	__this_cpu_write(old_rsp, next->usersp);
+	__this_cpu_write(current_task, next_p);
 
-	percpu_write(kernel_stack,
+	__this_cpu_write(kernel_stack,
 		  (unsigned long)task_stack_page(next_p) +
 		  THREAD_SIZE - KERNEL_STACK_OFFSET);
 
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index d6c0418..e931db0 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -61,10 +61,10 @@ static DEFINE_PER_CPU_READ_MOSTLY(int, tlb_vector_offset);
  */
 void leave_mm(int cpu)
 {
-	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
+	if (__this_cpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
 		BUG();
 	cpumask_clear_cpu(cpu,
-			  mm_cpumask(percpu_read(cpu_tlbstate.active_mm)));
+			  mm_cpumask(__this_cpu_read(cpu_tlbstate.active_mm)));
 	load_cr3(swapper_pg_dir);
 }
 EXPORT_SYMBOL_GPL(leave_mm);
@@ -152,8 +152,8 @@ void smp_invalidate_interrupt(struct pt_regs *regs)
 		 * BUG();
 		 */
 
-	if (f->flush_mm == percpu_read(cpu_tlbstate.active_mm)) {
-		if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
+	if (f->flush_mm == __this_cpu_read(cpu_tlbstate.active_mm)) {
+		if (__this_cpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
 			if (f->flush_va == TLB_FLUSH_ALL)
 				local_flush_tlb();
 			else
@@ -322,7 +322,7 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
 static void do_flush_tlb_all(void *info)
 {
 	__flush_tlb_all();
-	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_LAZY)
+	if (__this_cpu_read(cpu_tlbstate.state) == TLBSTATE_LAZY)
 		leave_mm(smp_processor_id());
 }
 
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 1f92865..3622488 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -777,11 +777,11 @@ static DEFINE_PER_CPU(unsigned long, xen_cr0_value);
 
 static unsigned long xen_read_cr0(void)
 {
-	unsigned long cr0 = percpu_read(xen_cr0_value);
+	unsigned long cr0 = this_cpu_read(xen_cr0_value);
 
 	if (unlikely(cr0 == 0)) {
 		cr0 = native_read_cr0();
-		percpu_write(xen_cr0_value, cr0);
+		this_cpu_write(xen_cr0_value, cr0);
 	}
 
 	return cr0;
@@ -791,7 +791,7 @@ static void xen_write_cr0(unsigned long cr0)
 {
 	struct multicall_space mcs;
 
-	percpu_write(xen_cr0_value, cr0);
+	this_cpu_write(xen_cr0_value, cr0);
 
 	/* Only pay attention to cr0.TS; everything else is
 	   ignored. */
diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
index 8bbb465..1573376 100644
--- a/arch/x86/xen/irq.c
+++ b/arch/x86/xen/irq.c
@@ -26,7 +26,7 @@ static unsigned long xen_save_fl(void)
 	struct vcpu_info *vcpu;
 	unsigned long flags;
 
-	vcpu = percpu_read(xen_vcpu);
+	vcpu = this_cpu_read(xen_vcpu);
 
 	/* flag has opposite sense of mask */
 	flags = !vcpu->evtchn_upcall_mask;
@@ -50,7 +50,7 @@ static void xen_restore_fl(unsigned long flags)
 	   make sure we're don't switch CPUs between getting the vcpu
 	   pointer and updating the mask. */
 	preempt_disable();
-	vcpu = percpu_read(xen_vcpu);
+	vcpu = this_cpu_read(xen_vcpu);
 	vcpu->evtchn_upcall_mask = flags;
 	preempt_enable_no_resched();
 
@@ -72,7 +72,7 @@ static void xen_irq_disable(void)
 	   make sure we're don't switch CPUs between getting the vcpu
 	   pointer and updating the mask. */
 	preempt_disable();
-	percpu_read(xen_vcpu)->evtchn_upcall_mask = 1;
+	this_cpu_read(xen_vcpu)->evtchn_upcall_mask = 1;
 	preempt_enable_no_resched();
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_irq_disable);
@@ -86,7 +86,7 @@ static void xen_irq_enable(void)
 	   the caller is confused and is trying to re-enable interrupts
 	   on an indeterminate processor. */
 
-	vcpu = percpu_read(xen_vcpu);
+	vcpu = this_cpu_read(xen_vcpu);
 	vcpu->evtchn_upcall_mask = 0;
 
 	/* Doesn't matter if we get preempted here, because any
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 87f6673..426ff61 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1071,14 +1071,14 @@ static void drop_other_mm_ref(void *info)
 	struct mm_struct *mm = info;
 	struct mm_struct *active_mm;
 
-	active_mm = percpu_read(cpu_tlbstate.active_mm);
+	active_mm = this_cpu_read(cpu_tlbstate.active_mm);
 
-	if (active_mm == mm && percpu_read(cpu_tlbstate.state) != TLBSTATE_OK)
+	if (active_mm == mm && this_cpu_read(cpu_tlbstate.state) != TLBSTATE_OK)
 		leave_mm(smp_processor_id());
 
 	/* If this cpu still has a stale cr3 reference, then make sure
 	   it has been flushed. */
-	if (percpu_read(xen_current_cr3) == __pa(mm->pgd))
+	if (this_cpu_read(xen_current_cr3) == __pa(mm->pgd))
 		load_cr3(swapper_pg_dir);
 }
 
@@ -1185,17 +1185,17 @@ static void __init xen_pagetable_setup_done(pgd_t *base)
 
 static void xen_write_cr2(unsigned long cr2)
 {
-	percpu_read(xen_vcpu)->arch.cr2 = cr2;
+	this_cpu_read(xen_vcpu)->arch.cr2 = cr2;
 }
 
 static unsigned long xen_read_cr2(void)
 {
-	return percpu_read(xen_vcpu)->arch.cr2;
+	return this_cpu_read(xen_vcpu)->arch.cr2;
 }
 
 unsigned long xen_read_cr2_direct(void)
 {
-	return percpu_read(xen_vcpu_info.arch.cr2);
+	return this_cpu_read(xen_vcpu_info.arch.cr2);
 }
 
 static void xen_flush_tlb(void)
@@ -1278,12 +1278,12 @@ static void xen_flush_tlb_others(const struct cpumask *cpus,
 
 static unsigned long xen_read_cr3(void)
 {
-	return percpu_read(xen_cr3);
+	return this_cpu_read(xen_cr3);
 }
 
 static void set_current_cr3(void *v)
 {
-	percpu_write(xen_current_cr3, (unsigned long)v);
+	this_cpu_write(xen_current_cr3, (unsigned long)v);
 }
 
 static void __xen_write_cr3(bool kernel, unsigned long cr3)
@@ -1306,7 +1306,7 @@ static void __xen_write_cr3(bool kernel, unsigned long cr3)
 	xen_extend_mmuext_op(&op);
 
 	if (kernel) {
-		percpu_write(xen_cr3, cr3);
+		this_cpu_write(xen_cr3, cr3);
 
 		/* Update xen_current_cr3 once the batch has actually
 		   been submitted. */
@@ -1322,7 +1322,7 @@ static void xen_write_cr3(unsigned long cr3)
 
 	/* Update while interrupts are disabled, so its atomic with
 	   respect to ipis */
-	percpu_write(xen_cr3, cr3);
+	this_cpu_write(xen_cr3, cr3);
 
 	__xen_write_cr3(true, cr3);
 
diff --git a/arch/x86/xen/multicalls.h b/arch/x86/xen/multicalls.h
index dee79b7..9c2e74f 100644
--- a/arch/x86/xen/multicalls.h
+++ b/arch/x86/xen/multicalls.h
@@ -47,7 +47,7 @@ static inline void xen_mc_issue(unsigned mode)
 		xen_mc_flush();
 
 	/* restore flags saved in xen_mc_batch */
-	local_irq_restore(percpu_read(xen_mc_irq_flags));
+	local_irq_restore(this_cpu_read(xen_mc_irq_flags));
 }
 
 /* Set up a callback to be called when the current batch is flushed */
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 041d4fe..449f868 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -76,7 +76,7 @@ static void __cpuinit cpu_bringup(void)
 	xen_setup_cpu_clockevents();
 
 	set_cpu_online(cpu, true);
-	percpu_write(cpu_state, CPU_ONLINE);
+	this_cpu_write(cpu_state, CPU_ONLINE);
 	wmb();
 
 	/* We can take interrupts now: we're officially "up". */
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 9ca008f..aad7e1c 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -165,59 +165,6 @@ extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
 #define alloc_percpu(type)	\
 	(typeof(type) __percpu *)__alloc_percpu(sizeof(type), __alignof__(type))
 
-/*
- * Optional methods for optimized non-lvalue per-cpu variable access.
- *
- * @var can be a percpu variable or a field of it and its size should
- * equal char, int or long.  percpu_read() evaluates to a lvalue and
- * all others to void.
- *
- * These operations are guaranteed to be atomic w.r.t. preemption.
- * The generic versions use plain get/put_cpu_var().  Archs are
- * encouraged to implement single-instruction alternatives which don't
- * require preemption protection.
- */
-#ifndef percpu_read
-# define percpu_read(var)						\
-  ({									\
-	typeof(var) *pr_ptr__ = &(var);					\
-	typeof(var) pr_ret__;						\
-	pr_ret__ = get_cpu_var(*pr_ptr__);				\
-	put_cpu_var(*pr_ptr__);						\
-	pr_ret__;							\
-  })
-#endif
-
-#define __percpu_generic_to_op(var, val, op)				\
-do {									\
-	typeof(var) *pgto_ptr__ = &(var);				\
-	get_cpu_var(*pgto_ptr__) op val;				\
-	put_cpu_var(*pgto_ptr__);					\
-} while (0)
-
-#ifndef percpu_write
-# define percpu_write(var, val)		__percpu_generic_to_op(var, (val), =)
-#endif
-
-#ifndef percpu_add
-# define percpu_add(var, val)		__percpu_generic_to_op(var, (val), +=)
-#endif
-
-#ifndef percpu_sub
-# define percpu_sub(var, val)		__percpu_generic_to_op(var, (val), -=)
-#endif
-
-#ifndef percpu_and
-# define percpu_and(var, val)		__percpu_generic_to_op(var, (val), &=)
-#endif
-
-#ifndef percpu_or
-# define percpu_or(var, val)		__percpu_generic_to_op(var, (val), |=)
-#endif
-
-#ifndef percpu_xor
-# define percpu_xor(var, val)		__percpu_generic_to_op(var, (val), ^=)
-#endif
 
 /*
  * Branching function to split up a function into a set of functions that
diff --git a/include/linux/topology.h b/include/linux/topology.h
index e26db03..b480403 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -239,7 +239,7 @@ static inline int cpu_to_node(int cpu)
 #ifndef set_numa_node
 static inline void set_numa_node(int node)
 {
-	percpu_write(numa_node, node);
+	__this_cpu_write(numa_node, node);
 }
 #endif
 
@@ -274,7 +274,7 @@ DECLARE_PER_CPU(int, _numa_mem_);
 #ifndef set_numa_mem
 static inline void set_numa_mem(int node)
 {
-	percpu_write(_numa_mem_, node);
+	__this_cpu_write(_numa_mem_, node);
 }
 #endif
 
-- 
1.7.5.1




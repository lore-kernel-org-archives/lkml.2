Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab1JKJPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 05:15:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:27214 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab1JKJPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 05:15:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="62037534"
Subject: Re: [PATCH] Code clean up for percpu_xxx() functions
From: "Alex,Shi" <alex.shi@intel.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "Huang, Ying" <ying.huang@intel.com>
In-Reply-To: <alpine.DEB.2.00.1110101026080.16264@router.home>
References: <1318237851.27949.190.camel@debian>
	 <alpine.DEB.2.00.1110101026080.16264@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 17:19:34 +0800
Message-ID: <1318324774.27949.693.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-11 at 01:08 +0800, Christoph Lameter wrote:
> On Mon, 10 Oct 2011, Alex,Shi wrote:
> 
> > index 3470c9d..d1de56c 100644
> > --- a/arch/x86/include/asm/percpu.h
> > +++ b/arch/x86/include/asm/percpu.h
> > @@ -46,7 +46,7 @@
> >
> >  #ifdef CONFIG_SMP
> >  #define __percpu_prefix		"%%"__stringify(__percpu_seg)":"
> > -#define __my_cpu_offset		percpu_read(this_cpu_off)
> > +#define __my_cpu_offset		this_cpu_read(this_cpu_off)
> 
> Should this not be __this_cpu_read() instead?

OK. 
> 
> >   * per-thread variables implemented as per-cpu variables and thus
> >   * stable for the duration of the respective task.
> >   */
> > -#define percpu_read(var)		percpu_from_op("mov", var, "m" (var))
> > -#define percpu_read_stable(var)		percpu_from_op("mov", var, "p" (&(var)))
> > -#define percpu_write(var, val)		percpu_to_op("mov", var, val)
> > -#define percpu_add(var, val)		percpu_add_op(var, val)
> > -#define percpu_sub(var, val)		percpu_add_op(var, -(val))
> > -#define percpu_and(var, val)		percpu_to_op("and", var, val)
> > -#define percpu_or(var, val)		percpu_to_op("or", var, val)
> > -#define percpu_xor(var, val)		percpu_to_op("xor", var, val)
> > -#define percpu_inc(var)		percpu_unary_op("inc", var)
> > +#define this_cpu_read(var)		percpu_from_op("mov", var, "m" (var))
> > +#define this_cpu_read_stable(var)	percpu_from_op("mov", var, "p" (&(var)))
> > +#define this_cpu_write(var, val)	percpu_to_op("mov", var, val)
> > +#define this_cpu_add(var, val)		percpu_add_op(var, val)
> > +#define this_cpu_sub(var, val)		percpu_add_op(var, -(val))
> > +#define this_cpu_and(var, val)		percpu_to_op("and", var, val)
> > +#define this_cpu_or(var, val)		percpu_to_op("or", var, val)
> > +#define this_cpu_xor(var, val)		percpu_to_op("xor", var, val)
> > +#define this_cpu_inc(var)		percpu_unary_op("inc", var)
> 
> Why define these operations? They are already defined in the form of
> this_cpu_add_1/2/4/8 and include/linux/percpu.h branches out to them.

percpu_read() used in asm/percpu.h yet. Anyway, I removed definitions
here and do a work around for the function as following:

@@ -551,7 +544,11 @@ static __always_inline int x86_this_cpu_constant_test_bit(unsigned int nr,
 {
        unsigned long __percpu *a = (unsigned long *)addr + nr / BITS_PER_LONG;

-       return ((1UL << (nr % BITS_PER_LONG)) & percpu_read(*a)) != 0;
+#ifdef CONFIG_X86_64
+       return ((1UL << (nr % BITS_PER_LONG)) & this_cpu_read_8(*a)) != 0;
+#else
+       return ((1UL << (nr % BITS_PER_LONG)) & this_cpu_read_4(*a)) != 0;
+#endif

> 
> > @@ -522,7 +522,7 @@ void sock_release(struct socket *sock)
> >  	if (rcu_dereference_protected(sock->wq, 1)->fasync_list)
> >  		printk(KERN_ERR "sock_release: fasync list not empty!\n");
> >
> > -	percpu_sub(sockets_in_use, 1);
> > +	this_cpu_sub(sockets_in_use, 1);
> >  	if (!sock->file) {
> >  		iput(SOCK_INODE(sock));
> >  		return;
> 
> In general __this_cpu_xx operations can be used instead of this_cpu_xx
> operations if the context is already preempt safe. There is no change of
> the code generated for x86 in those cases. But the fallback code on other
> platforms can generate more efficient code.
> 


Good reminder! 
Currently, only x86 has specific percpu_xxx() definition. Other
platforms use generic version. And for this function, it is not preempt
safe.  So, it should be fine here. 

=========

Since percpu_xxx() serial functions are duplicate with this_cpu_xxx().
Removing percpu_xxx() definition and replacing them by this_cpu_xxx() in
using. This patch is just do code clean up, no function change.


Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/include/asm/current.h        |    2 +-
 arch/x86/include/asm/hardirq.h        |    8 ++--
 arch/x86/include/asm/irq_regs.h       |    4 +-
 arch/x86/include/asm/mmu_context.h    |   12 ++++----
 arch/x86/include/asm/percpu.h         |   25 +++++++---------
 arch/x86/include/asm/smp.h            |    4 +-
 arch/x86/include/asm/stackprotector.h |    4 +-
 arch/x86/include/asm/thread_info.h    |    2 +-
 arch/x86/include/asm/tlbflush.h       |    4 +-
 arch/x86/kernel/cpu/common.c          |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c      |    4 +-
 arch/x86/kernel/cpu/perf_event.c      |    4 +-
 arch/x86/kernel/paravirt.c            |   12 ++++----
 arch/x86/kernel/process_32.c          |    2 +-
 arch/x86/kernel/process_64.c          |   12 ++++----
 arch/x86/kvm/x86.c                    |   14 ++++----
 arch/x86/mm/tlb.c                     |   10 +++---
 arch/x86/xen/enlighten.c              |    6 ++--
 arch/x86/xen/irq.c                    |    8 ++--
 arch/x86/xen/mmu.c                    |   20 ++++++------
 arch/x86/xen/multicalls.h             |    2 +-
 arch/x86/xen/smp.c                    |    2 +-
 include/linux/percpu.h                |   53 ---------------------------------
 include/linux/topology.h              |    4 +-
 net/netfilter/xt_TEE.c                |   12 ++++----
 net/socket.c                          |    4 +-
 26 files changed, 90 insertions(+), 146 deletions(-)

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
index 55e4de6..fc594da 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -35,14 +35,14 @@ DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
 
 #define __ARCH_IRQ_STAT
 
-#define inc_irq_stat(member)	percpu_inc(irq_stat.member)
+#define inc_irq_stat(member)	this_cpu_inc(irq_stat.member)
 
-#define local_softirq_pending()	percpu_read(irq_stat.__softirq_pending)
+#define local_softirq_pending()	this_cpu_read(irq_stat.__softirq_pending)
 
 #define __ARCH_SET_SOFTIRQ_PENDING
 
-#define set_softirq_pending(x)	percpu_write(irq_stat.__softirq_pending, (x))
-#define or_softirq_pending(x)	percpu_or(irq_stat.__softirq_pending, (x))
+#define set_softirq_pending(x)	this_cpu_write(irq_stat.__softirq_pending, (x))
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
index 3470c9d..66b50cb 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -46,7 +46,7 @@
 
 #ifdef CONFIG_SMP
 #define __percpu_prefix		"%%"__stringify(__percpu_seg)":"
-#define __my_cpu_offset		percpu_read(this_cpu_off)
+#define __my_cpu_offset		__this_cpu_read(this_cpu_off)
 
 /*
  * Compared to the generic __my_cpu_offset version, the following
@@ -351,23 +351,16 @@ do {									\
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
+#define this_cpu_inc(var)		percpu_unary_op("inc", var)
 
 #define __this_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define __this_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
@@ -551,7 +544,11 @@ static __always_inline int x86_this_cpu_constant_test_bit(unsigned int nr,
 {
 	unsigned long __percpu *a = (unsigned long *)addr + nr / BITS_PER_LONG;
 
-	return ((1UL << (nr % BITS_PER_LONG)) & percpu_read(*a)) != 0;
+#ifdef CONFIG_X86_64
+	return ((1UL << (nr % BITS_PER_LONG)) & this_cpu_read_8(*a)) != 0;
+#else
+	return ((1UL << (nr % BITS_PER_LONG)) & this_cpu_read_4(*a)) != 0;
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
index 1575177..3d7a009 100644
--- a/arch/x86/include/asm/stackprotector.h
+++ b/arch/x86/include/asm/stackprotector.h
@@ -76,9 +76,9 @@ static __always_inline void boot_init_stack_canary(void)
 
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
index 169be89..200c09c 100644
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
index 6218439..10513ed 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1158,7 +1158,7 @@ void __cpuinit cpu_init(void)
 	oist = &per_cpu(orig_ist, cpu);
 
 #ifdef CONFIG_NUMA
-	if (cpu != 0 && percpu_read(numa_node) == 0 &&
+	if (cpu != 0 && this_cpu_read(numa_node) == 0 &&
 	    early_cpu_to_node(cpu) != NUMA_NO_NODE)
 		set_numa_node(early_cpu_to_node(cpu));
 #endif
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 08363b0..adbb598 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -512,7 +512,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 	struct mce m;
 	int i;
 
-	percpu_inc(mce_poll_count);
+	this_cpu_inc(mce_poll_count);
 
 	mce_gather_info(&m, NULL);
 
@@ -906,7 +906,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 
 	atomic_inc(&mce_entry);
 
-	percpu_inc(mce_exception_count);
+	this_cpu_inc(mce_exception_count);
 
 	if (notify_die(DIE_NMI, "machine check", regs, error_code,
 			   18, SIGKILL) == NOTIFY_STOP)
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index cfa62ec..ca037c0 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1389,7 +1389,7 @@ perf_event_nmi_handler(struct notifier_block *self,
 	case DIE_NMI:
 		break;
 	case DIE_NMIUNKNOWN:
-		this_nmi = percpu_read(irq_stat.__nmi_count);
+		this_nmi = this_cpu_read(irq_stat.__nmi_count);
 		if (this_nmi != __this_cpu_read(pmu_nmi.marked))
 			/* let the kernel handle the unknown nmi */
 			return NOTIFY_DONE;
@@ -1409,7 +1409,7 @@ perf_event_nmi_handler(struct notifier_block *self,
 	if (!handled)
 		return NOTIFY_DONE;
 
-	this_nmi = percpu_read(irq_stat.__nmi_count);
+	this_nmi = this_cpu_read(irq_stat.__nmi_count);
 	if ((handled > 1) ||
 		/* the next nmi could be a back-to-back nmi */
 	    ((__this_cpu_read(pmu_nmi.marked) == this_nmi) &&
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index d90272e..b098092 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -239,16 +239,16 @@ static DEFINE_PER_CPU(enum paravirt_lazy_mode, paravirt_lazy_mode) = PARAVIRT_LA
 
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
@@ -265,7 +265,7 @@ void paravirt_start_context_switch(struct task_struct *prev)
 {
 	BUG_ON(preemptible());
 
-	if (percpu_read(paravirt_lazy_mode) == PARAVIRT_LAZY_MMU) {
+	if (this_cpu_read(paravirt_lazy_mode) == PARAVIRT_LAZY_MMU) {
 		arch_leave_lazy_mmu_mode();
 		set_ti_thread_flag(task_thread_info(prev), TIF_LAZY_MMU_UPDATES);
 	}
@@ -287,7 +287,7 @@ enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
 	if (in_interrupt())
 		return PARAVIRT_LAZY_NONE;
 
-	return percpu_read(paravirt_lazy_mode);
+	return this_cpu_read(paravirt_lazy_mode);
 }
 
 void arch_flush_lazy_mmu_mode(void)
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 7a3b651..f286be1 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -373,7 +373,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	if (prev->gs | next->gs)
 		lazy_load_gs(next->gs);
 
-	percpu_write(current_task, next_p);
+	this_cpu_write(current_task, next_p);
 
 	return prev_p;
 }
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index f693e44..35fdc14 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -73,7 +73,7 @@ EXPORT_SYMBOL_GPL(idle_notifier_unregister);
 
 void enter_idle(void)
 {
-	percpu_write(is_idle, 1);
+	this_cpu_write(is_idle, 1);
 	atomic_notifier_call_chain(&idle_notifier, IDLE_START, NULL);
 }
 
@@ -336,7 +336,7 @@ start_thread_common(struct pt_regs *regs, unsigned long new_ip,
 	load_gs_index(0);
 	regs->ip		= new_ip;
 	regs->sp		= new_sp;
-	percpu_write(old_rsp, new_sp);
+	this_cpu_write(old_rsp, new_sp);
 	regs->cs		= _cs;
 	regs->ss		= _ss;
 	regs->flags		= X86_EFLAGS_IF;
@@ -470,11 +470,11 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
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
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 84a28ea..f46cb15 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5024,15 +5024,15 @@ static DEFINE_PER_CPU(struct kvm_vcpu *, current_vcpu);
 
 static int kvm_is_in_guest(void)
 {
-	return percpu_read(current_vcpu) != NULL;
+	return this_cpu_read(current_vcpu) != NULL;
 }
 
 static int kvm_is_user_mode(void)
 {
 	int user_mode = 3;
 
-	if (percpu_read(current_vcpu))
-		user_mode = kvm_x86_ops->get_cpl(percpu_read(current_vcpu));
+	if (this_cpu_read(current_vcpu))
+		user_mode = kvm_x86_ops->get_cpl(this_cpu_read(current_vcpu));
 
 	return user_mode != 0;
 }
@@ -5041,8 +5041,8 @@ static unsigned long kvm_get_guest_ip(void)
 {
 	unsigned long ip = 0;
 
-	if (percpu_read(current_vcpu))
-		ip = kvm_rip_read(percpu_read(current_vcpu));
+	if (this_cpu_read(current_vcpu))
+		ip = kvm_rip_read(this_cpu_read(current_vcpu));
 
 	return ip;
 }
@@ -5055,13 +5055,13 @@ static struct perf_guest_info_callbacks kvm_guest_cbs = {
 
 void kvm_before_handle_nmi(struct kvm_vcpu *vcpu)
 {
-	percpu_write(current_vcpu, vcpu);
+	this_cpu_write(current_vcpu, vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_before_handle_nmi);
 
 void kvm_after_handle_nmi(struct kvm_vcpu *vcpu)
 {
-	percpu_write(current_vcpu, NULL);
+	this_cpu_write(current_vcpu, NULL);
 }
 EXPORT_SYMBOL_GPL(kvm_after_handle_nmi);
 
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
 
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 2d69617..c4e362a 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -776,11 +776,11 @@ static DEFINE_PER_CPU(unsigned long, xen_cr0_value);
 
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
@@ -790,7 +790,7 @@ static void xen_write_cr0(unsigned long cr0)
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
index 3dd53f9..6a7aaac 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1106,14 +1106,14 @@ static void drop_other_mm_ref(void *info)
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
 
@@ -1220,17 +1220,17 @@ static void __init xen_pagetable_setup_done(pgd_t *base)
 
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
@@ -1313,12 +1313,12 @@ static void xen_flush_tlb_others(const struct cpumask *cpus,
 
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
@@ -1341,7 +1341,7 @@ static void __xen_write_cr3(bool kernel, unsigned long cr3)
 	xen_extend_mmuext_op(&op);
 
 	if (kernel) {
-		percpu_write(xen_cr3, cr3);
+		this_cpu_write(xen_cr3, cr3);
 
 		/* Update xen_current_cr3 once the batch has actually
 		   been submitted. */
@@ -1357,7 +1357,7 @@ static void xen_write_cr3(unsigned long cr3)
 
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
index fc839bf..bf64eac 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -235,7 +235,7 @@ static inline int cpu_to_node(int cpu)
 #ifndef set_numa_node
 static inline void set_numa_node(int node)
 {
-	percpu_write(numa_node, node);
+	this_cpu_write(numa_node, node);
 }
 #endif
 
@@ -270,7 +270,7 @@ DECLARE_PER_CPU(int, _numa_mem_);
 #ifndef set_numa_mem
 static inline void set_numa_mem(int node)
 {
-	percpu_write(_numa_mem_, node);
+	this_cpu_write(_numa_mem_, node);
 }
 #endif
 
diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index 5f054a0..e78103d 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -90,7 +90,7 @@ tee_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	const struct xt_tee_tginfo *info = par->targinfo;
 	struct iphdr *iph;
 
-	if (percpu_read(tee_active))
+	if (this_cpu_read(tee_active))
 		return XT_CONTINUE;
 	/*
 	 * Copy the skb, and route the copy. Will later return %XT_CONTINUE for
@@ -127,9 +127,9 @@ tee_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	ip_send_check(iph);
 
 	if (tee_tg_route4(skb, info)) {
-		percpu_write(tee_active, true);
+		this_cpu_write(tee_active, true);
 		ip_local_out(skb);
-		percpu_write(tee_active, false);
+		this_cpu_write(tee_active, false);
 	} else {
 		kfree_skb(skb);
 	}
@@ -170,7 +170,7 @@ tee_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_tee_tginfo *info = par->targinfo;
 
-	if (percpu_read(tee_active))
+	if (this_cpu_read(tee_active))
 		return XT_CONTINUE;
 	skb = pskb_copy(skb, GFP_ATOMIC);
 	if (skb == NULL)
@@ -188,9 +188,9 @@ tee_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 		--iph->hop_limit;
 	}
 	if (tee_tg_route6(skb, info)) {
-		percpu_write(tee_active, true);
+		this_cpu_write(tee_active, true);
 		ip6_local_out(skb);
-		percpu_write(tee_active, false);
+		this_cpu_write(tee_active, false);
 	} else {
 		kfree_skb(skb);
 	}
diff --git a/net/socket.c b/net/socket.c
index ffe92ca..4b62ca9 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -479,7 +479,7 @@ static struct socket *sock_alloc(void)
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();
 
-	percpu_add(sockets_in_use, 1);
+	this_cpu_add(sockets_in_use, 1);
 	return sock;
 }
 
@@ -522,7 +522,7 @@ void sock_release(struct socket *sock)
 	if (rcu_dereference_protected(sock->wq, 1)->fasync_list)
 		printk(KERN_ERR "sock_release: fasync list not empty!\n");
 
-	percpu_sub(sockets_in_use, 1);
+	this_cpu_sub(sockets_in_use, 1);
 	if (!sock->file) {
 		iput(SOCK_INODE(sock));
 		return;
-- 
1.7.5.1








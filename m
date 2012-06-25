Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab2FYGME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 02:12:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:27904 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936Ab2FYGLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 02:11:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="162133286"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com
Cc: jeremy@goop.org, alex.shi@intel.com, luto@mit.edu, yinghai@kernel.org,
        riel@redhat.com, avi@redhat.com, len.brown@intel.com, tj@kernel.org,
        akpm@linux-foundation.org, cl@gentwo.org, borislav.petkov@amd.com,
        ak@linux.intel.com, jbeulich@suse.com, eric.dumazet@gmail.com,
        akinobu.mita@gmail.com, vapier@gentoo.org, cpw@sgi.com,
        steiner@sgi.com, viro@zeniv.linux.org.uk,
        kamezawa.hiroyu@jp.fujitsu.com, rientjes@google.com,
        aarcange@redhat.com, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com
Subject: [PATCH v9 8/9] x86/tlb: replace INVALIDATE_TLB_VECTOR by CALL_FUNCTION_VECTOR
Date: Mon, 25 Jun 2012 14:08:26 +0800
Message-Id: <1340604507-11214-9-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1340604507-11214-1-git-send-email-alex.shi@intel.com>
References: <1340604507-11214-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 32 INVALIDATE_TLB_VECTOR now in kernel. That is quite big
amount of vector in IDT. But it is still not enough, since modern x86
sever has more cpu number. That still causes heavy lock contentation
in TLB flushing.

The patch using generic smp call function to replace it. That saved 32
vector number in IDT, and resolved the lock contentation in TLB
flushing on large system.

In the NHM EX machine 4P * 8cores * HT = 64 CPUs, hackbench pthread
has 3% performance increase.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/include/asm/entry_arch.h  |    9 --
 arch/x86/include/asm/irq_vectors.h |   11 --
 arch/x86/kernel/entry_64.S         |   18 ---
 arch/x86/kernel/irqinit.c          |   73 -----------
 arch/x86/mm/tlb.c                  |  238 +++++++-----------------------------
 5 files changed, 45 insertions(+), 304 deletions(-)

diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index 0baa628..40afa00 100644
--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -15,15 +15,6 @@ BUILD_INTERRUPT(call_function_interrupt,CALL_FUNCTION_VECTOR)
 BUILD_INTERRUPT(call_function_single_interrupt,CALL_FUNCTION_SINGLE_VECTOR)
 BUILD_INTERRUPT(irq_move_cleanup_interrupt,IRQ_MOVE_CLEANUP_VECTOR)
 BUILD_INTERRUPT(reboot_interrupt,REBOOT_VECTOR)
-
-.irp idx,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15, \
-	16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
-.if NUM_INVALIDATE_TLB_VECTORS > \idx
-BUILD_INTERRUPT3(invalidate_interrupt\idx,
-		 (INVALIDATE_TLB_VECTOR_START)+\idx,
-		 smp_invalidate_interrupt)
-.endif
-.endr
 #endif
 
 BUILD_INTERRUPT(x86_platform_ipi, X86_PLATFORM_IPI_VECTOR)
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 4b44487..1508e51 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -119,17 +119,6 @@
  */
 #define LOCAL_TIMER_VECTOR		0xef
 
-/* up to 32 vectors used for spreading out TLB flushes: */
-#if NR_CPUS <= 32
-# define NUM_INVALIDATE_TLB_VECTORS	(NR_CPUS)
-#else
-# define NUM_INVALIDATE_TLB_VECTORS	(32)
-#endif
-
-#define INVALIDATE_TLB_VECTOR_END	(0xee)
-#define INVALIDATE_TLB_VECTOR_START	\
-	(INVALIDATE_TLB_VECTOR_END-NUM_INVALIDATE_TLB_VECTORS+1)
-
 #define NR_VECTORS			 256
 
 #define FPU_IRQ				  13
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 7d65133..bcf28e1 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1048,24 +1048,6 @@ apicinterrupt LOCAL_TIMER_VECTOR \
 apicinterrupt X86_PLATFORM_IPI_VECTOR \
 	x86_platform_ipi smp_x86_platform_ipi
 
-#ifdef CONFIG_SMP
-	ALIGN
-	INTR_FRAME
-.irp idx,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15, \
-	16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
-.if NUM_INVALIDATE_TLB_VECTORS > \idx
-ENTRY(invalidate_interrupt\idx)
-	pushq_cfi $~(INVALIDATE_TLB_VECTOR_START+\idx)
-	jmp .Lcommon_invalidate_interrupt0
-	CFI_ADJUST_CFA_OFFSET -8
-END(invalidate_interrupt\idx)
-.endif
-.endr
-	CFI_ENDPROC
-apicinterrupt INVALIDATE_TLB_VECTOR_START, \
-	invalidate_interrupt0, smp_invalidate_interrupt
-#endif
-
 apicinterrupt THRESHOLD_APIC_VECTOR \
 	threshold_interrupt smp_threshold_interrupt
 apicinterrupt THERMAL_APIC_VECTOR \
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 252981a..6e03b0d 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -171,79 +171,6 @@ static void __init smp_intr_init(void)
 	 */
 	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
 
-	/* IPIs for invalidation */
-#define ALLOC_INVTLB_VEC(NR) \
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+NR, \
-		invalidate_interrupt##NR)
-
-	switch (NUM_INVALIDATE_TLB_VECTORS) {
-	default:
-		ALLOC_INVTLB_VEC(31);
-	case 31:
-		ALLOC_INVTLB_VEC(30);
-	case 30:
-		ALLOC_INVTLB_VEC(29);
-	case 29:
-		ALLOC_INVTLB_VEC(28);
-	case 28:
-		ALLOC_INVTLB_VEC(27);
-	case 27:
-		ALLOC_INVTLB_VEC(26);
-	case 26:
-		ALLOC_INVTLB_VEC(25);
-	case 25:
-		ALLOC_INVTLB_VEC(24);
-	case 24:
-		ALLOC_INVTLB_VEC(23);
-	case 23:
-		ALLOC_INVTLB_VEC(22);
-	case 22:
-		ALLOC_INVTLB_VEC(21);
-	case 21:
-		ALLOC_INVTLB_VEC(20);
-	case 20:
-		ALLOC_INVTLB_VEC(19);
-	case 19:
-		ALLOC_INVTLB_VEC(18);
-	case 18:
-		ALLOC_INVTLB_VEC(17);
-	case 17:
-		ALLOC_INVTLB_VEC(16);
-	case 16:
-		ALLOC_INVTLB_VEC(15);
-	case 15:
-		ALLOC_INVTLB_VEC(14);
-	case 14:
-		ALLOC_INVTLB_VEC(13);
-	case 13:
-		ALLOC_INVTLB_VEC(12);
-	case 12:
-		ALLOC_INVTLB_VEC(11);
-	case 11:
-		ALLOC_INVTLB_VEC(10);
-	case 10:
-		ALLOC_INVTLB_VEC(9);
-	case 9:
-		ALLOC_INVTLB_VEC(8);
-	case 8:
-		ALLOC_INVTLB_VEC(7);
-	case 7:
-		ALLOC_INVTLB_VEC(6);
-	case 6:
-		ALLOC_INVTLB_VEC(5);
-	case 5:
-		ALLOC_INVTLB_VEC(4);
-	case 4:
-		ALLOC_INVTLB_VEC(3);
-	case 3:
-		ALLOC_INVTLB_VEC(2);
-	case 2:
-		ALLOC_INVTLB_VEC(1);
-	case 1:
-		ALLOC_INVTLB_VEC(0);
-		break;
-	}
-
 	/* IPI for generic function call */
 	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
 
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 481737d..2b5f506 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -28,34 +28,14 @@ DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate)
  *
  *	More scalable flush, from Andi Kleen
  *
- *	To avoid global state use 8 different call vectors.
- *	Each CPU uses a specific vector to trigger flushes on other
- *	CPUs. Depending on the received vector the target CPUs look into
- *	the right array slot for the flush data.
- *
- *	With more than 8 CPUs they are hashed to the 8 available
- *	vectors. The limited global vector space forces us to this right now.
- *	In future when interrupts are split into per CPU domains this could be
- *	fixed, at the cost of triggering multiple IPIs in some cases.
+ *	Implement flush IPI by CALL_FUNCTION_VECTOR, Alex Shi
  */
 
-union smp_flush_state {
-	struct {
-		struct mm_struct *flush_mm;
-		unsigned long flush_start;
-		unsigned long flush_end;
-		raw_spinlock_t tlbstate_lock;
-		DECLARE_BITMAP(flush_cpumask, NR_CPUS);
-	};
-	char pad[INTERNODE_CACHE_BYTES];
-} ____cacheline_internodealigned_in_smp;
-
-/* State is put into the per CPU data section, but padded
-   to a full cache line because other CPUs can access it and we don't
-   want false sharing in the per cpu data segment. */
-static union smp_flush_state flush_state[NUM_INVALIDATE_TLB_VECTORS];
-
-static DEFINE_PER_CPU_READ_MOSTLY(int, tlb_vector_offset);
+struct flush_tlb_info {
+	struct mm_struct *flush_mm;
+	unsigned long flush_start;
+	unsigned long flush_end;
+};
 
 /*
  * We cannot call mmdrop() because we are in interrupt context,
@@ -74,28 +54,25 @@ void leave_mm(int cpu)
 EXPORT_SYMBOL_GPL(leave_mm);
 
 /*
- *
  * The flush IPI assumes that a thread switch happens in this order:
  * [cpu0: the cpu that switches]
  * 1) switch_mm() either 1a) or 1b)
  * 1a) thread switch to a different mm
- * 1a1) cpu_clear(cpu, old_mm->cpu_vm_mask);
- *	Stop ipi delivery for the old mm. This is not synchronized with
- *	the other cpus, but smp_invalidate_interrupt ignore flush ipis
- *	for the wrong mm, and in the worst case we perform a superfluous
- *	tlb flush.
- * 1a2) set cpu mmu_state to TLBSTATE_OK
- *	Now the smp_invalidate_interrupt won't call leave_mm if cpu0
- *	was in lazy tlb mode.
- * 1a3) update cpu active_mm
+ * 1a1) set cpu_tlbstate to TLBSTATE_OK
+ *	Now the tlb flush NMI handler flush_tlb_func won't call leave_mm
+ *	if cpu0 was in lazy tlb mode.
+ * 1a2) update cpu active_mm
  *	Now cpu0 accepts tlb flushes for the new mm.
- * 1a4) cpu_set(cpu, new_mm->cpu_vm_mask);
+ * 1a3) cpu_set(cpu, new_mm->cpu_vm_mask);
  *	Now the other cpus will send tlb flush ipis.
  * 1a4) change cr3.
+ * 1a5) cpu_clear(cpu, old_mm->cpu_vm_mask);
+ *	Stop ipi delivery for the old mm. This is not synchronized with
+ *	the other cpus, but flush_tlb_func ignore flush ipis for the wrong
+ *	mm, and in the worst case we perform a superfluous tlb flush.
  * 1b) thread switch without mm change
- *	cpu active_mm is correct, cpu0 already handles
- *	flush ipis.
- * 1b1) set cpu mmu_state to TLBSTATE_OK
+ *	cpu active_mm is correct, cpu0 already handles flush ipis.
+ * 1b1) set cpu_tlbstate to TLBSTATE_OK
  * 1b2) test_and_set the cpu bit in cpu_vm_mask.
  *	Atomically set the bit [other cpus will start sending flush ipis],
  *	and test the bit.
@@ -108,186 +85,61 @@ EXPORT_SYMBOL_GPL(leave_mm);
  *   runs in kernel space, the cpu could load tlb entries for user space
  *   pages.
  *
- * The good news is that cpu mmu_state is local to each cpu, no
+ * The good news is that cpu_tlbstate is local to each cpu, no
  * write/read ordering problems.
  */
 
 /*
- * TLB flush IPI:
- *
+ * TLB flush funcation:
  * 1) Flush the tlb entries if the cpu uses the mm that's being flushed.
  * 2) Leave the mm if we are in the lazy tlb mode.
- *
- * Interrupts are disabled.
- */
-
-/*
- * FIXME: use of asmlinkage is not consistent.  On x86_64 it's noop
- * but still used for documentation purpose but the usage is slightly
- * inconsistent.  On x86_32, asmlinkage is regparm(0) but interrupt
- * entry calls in with the first parameter in %eax.  Maybe define
- * intrlinkage?
  */
-#ifdef CONFIG_X86_64
-asmlinkage
-#endif
-void smp_invalidate_interrupt(struct pt_regs *regs)
+static void flush_tlb_func(void *info)
 {
-	unsigned int cpu;
-	unsigned int sender;
-	union smp_flush_state *f;
-
-	cpu = smp_processor_id();
-	/*
-	 * orig_rax contains the negated interrupt vector.
-	 * Use that to determine where the sender put the data.
-	 */
-	sender = ~regs->orig_ax - INVALIDATE_TLB_VECTOR_START;
-	f = &flush_state[sender];
-
-	if (!cpumask_test_cpu(cpu, to_cpumask(f->flush_cpumask)))
-		goto out;
-		/*
-		 * This was a BUG() but until someone can quote me the
-		 * line from the intel manual that guarantees an IPI to
-		 * multiple CPUs is retried _only_ on the erroring CPUs
-		 * its staying as a return
-		 *
-		 * BUG();
-		 */
-
-	if (f->flush_mm == this_cpu_read(cpu_tlbstate.active_mm)) {
-		if (this_cpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
-			if (f->flush_end == TLB_FLUSH_ALL
-					|| !cpu_has_invlpg)
-				local_flush_tlb();
-			else if (!f->flush_end)
-				__flush_tlb_single(f->flush_start);
-			else {
-				unsigned long addr;
-				addr = f->flush_start;
-				while (addr < f->flush_end) {
-					__flush_tlb_single(addr);
-					addr += PAGE_SIZE;
-				}
-			}
-		} else
-			leave_mm(cpu);
-	}
-out:
-	ack_APIC_irq();
-	smp_mb__before_clear_bit();
-	cpumask_clear_cpu(cpu, to_cpumask(f->flush_cpumask));
-	smp_mb__after_clear_bit();
-	inc_irq_stat(irq_tlb_count);
-}
+	struct flush_tlb_info *f = info;
 
-static void flush_tlb_others_ipi(const struct cpumask *cpumask,
-				 struct mm_struct *mm, unsigned long start,
-				 unsigned long end)
-{
-	unsigned int sender;
-	union smp_flush_state *f;
-
-	/* Caller has disabled preemption */
-	sender = this_cpu_read(tlb_vector_offset);
-	f = &flush_state[sender];
-
-	if (nr_cpu_ids > NUM_INVALIDATE_TLB_VECTORS)
-		raw_spin_lock(&f->tlbstate_lock);
-
-	f->flush_mm = mm;
-	f->flush_start = start;
-	f->flush_end = end;
-	if (cpumask_andnot(to_cpumask(f->flush_cpumask), cpumask, cpumask_of(smp_processor_id()))) {
-		/*
-		 * We have to send the IPI only to
-		 * CPUs affected.
-		 */
-		apic->send_IPI_mask(to_cpumask(f->flush_cpumask),
-			      INVALIDATE_TLB_VECTOR_START + sender);
-
-		while (!cpumask_empty(to_cpumask(f->flush_cpumask)))
-			cpu_relax();
-	}
+	if (f->flush_mm != this_cpu_read(cpu_tlbstate.active_mm))
+		return;
+
+	if (this_cpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
+		if (f->flush_end == TLB_FLUSH_ALL || !cpu_has_invlpg)
+			local_flush_tlb();
+		else if (!f->flush_end)
+			__flush_tlb_single(f->flush_start);
+		else {
+			unsigned long addr;
+			addr = f->flush_start;
+			while (addr < f->flush_end) {
+				__flush_tlb_single(addr);
+				addr += PAGE_SIZE;
+			}
+		}
+	} else
+		leave_mm(smp_processor_id());
 
-	f->flush_mm = NULL;
-	f->flush_start = 0;
-	f->flush_end = 0;
-	if (nr_cpu_ids > NUM_INVALIDATE_TLB_VECTORS)
-		raw_spin_unlock(&f->tlbstate_lock);
 }
 
 void native_flush_tlb_others(const struct cpumask *cpumask,
 				 struct mm_struct *mm, unsigned long start,
 				 unsigned long end)
 {
+	struct flush_tlb_info info;
+	info.flush_mm = mm;
+	info.flush_start = start;
+	info.flush_end = end;
+
 	if (is_uv_system()) {
 		unsigned int cpu;
 
 		cpu = smp_processor_id();
 		cpumask = uv_flush_tlb_others(cpumask, mm, start, end, cpu);
 		if (cpumask)
-			flush_tlb_others_ipi(cpumask, mm, start, end);
+			smp_call_function_many(cpumask, flush_tlb_func,
+								&info, 1);
 		return;
 	}
-	flush_tlb_others_ipi(cpumask, mm, start, end);
-}
-
-static void __cpuinit calculate_tlb_offset(void)
-{
-	int cpu, node, nr_node_vecs, idx = 0;
-	/*
-	 * we are changing tlb_vector_offset for each CPU in runtime, but this
-	 * will not cause inconsistency, as the write is atomic under X86. we
-	 * might see more lock contentions in a short time, but after all CPU's
-	 * tlb_vector_offset are changed, everything should go normal
-	 *
-	 * Note: if NUM_INVALIDATE_TLB_VECTORS % nr_online_nodes !=0, we might
-	 * waste some vectors.
-	 **/
-	if (nr_online_nodes > NUM_INVALIDATE_TLB_VECTORS)
-		nr_node_vecs = 1;
-	else
-		nr_node_vecs = NUM_INVALIDATE_TLB_VECTORS/nr_online_nodes;
-
-	for_each_online_node(node) {
-		int node_offset = (idx % NUM_INVALIDATE_TLB_VECTORS) *
-			nr_node_vecs;
-		int cpu_offset = 0;
-		for_each_cpu(cpu, cpumask_of_node(node)) {
-			per_cpu(tlb_vector_offset, cpu) = node_offset +
-				cpu_offset;
-			cpu_offset++;
-			cpu_offset = cpu_offset % nr_node_vecs;
-		}
-		idx++;
-	}
-}
-
-static int __cpuinit tlb_cpuhp_notify(struct notifier_block *n,
-		unsigned long action, void *hcpu)
-{
-	switch (action & 0xf) {
-	case CPU_ONLINE:
-	case CPU_DEAD:
-		calculate_tlb_offset();
-	}
-	return NOTIFY_OK;
-}
-
-static int __cpuinit init_smp_flush(void)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(flush_state); i++)
-		raw_spin_lock_init(&flush_state[i].tlbstate_lock);
-
-	calculate_tlb_offset();
-	hotcpu_notifier(tlb_cpuhp_notify, 0);
-	return 0;
+	smp_call_function_many(cpumask, flush_tlb_func, &info, 1);
 }
-core_initcall(init_smp_flush);
 
 void flush_tlb_current_task(void)
 {
-- 
1.7.5.4


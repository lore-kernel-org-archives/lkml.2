Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740Ab2D0QZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:25:14 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:42664 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760703Ab2D0QZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:25:11 -0400
Subject: [RFC PATCH v1 3/5] KVM: Add paravirt kvm_flush_tlb_others
To: peterz@infradead.org, mingo@elte.hu
From: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: jeremy@goop.org, mtosatti@redhat.com, kvm@vger.kernel.org, x86@kernel.org,
        vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, avi@redhat.com,
        hpa@zytor.com
Date: Fri, 27 Apr 2012 21:54:37 +0530
Message-ID: <20120427162401.27082.59387.stgit@abhimanyu>
In-Reply-To: <20120427161727.27082.43096.stgit@abhimanyu>
References: <20120427161727.27082.43096.stgit@abhimanyu>
User-Agent: StGit/0.16-2-g0d85
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12042716-2000-0000-0000-000007460C00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flush_tlb_others_ipi depends on lot of statics in tlb.c.  Replicated
the flush_tlb_others_ipi as kvm_flush_tlb_others to further adapt to
paravirtualization.

Use the vcpu state information inside the kvm_flush_tlb_others to
avoid sending ipi to pre-empted vcpus.

* Do not send ipi's to offline vcpus and set flush_on_enter flag
* For online vcpus: Wait for them to clear the flag

The approach was discussed here: https://lkml.org/lkml/2012/2/20/157

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>

--
Pseudo Algo:

   Write()
   ======

	   guest_exit()
		   flush_on_enter[i]=0;
		   running[i] = 0;

	   guest_enter()
		   running[i] = 1;
		   if(flush_on_enter[i]) {
			   tlb_flush()
			   flush_on_enter[i]=0;
		   }


   Read()
   ======

	   GUEST                                                KVM-HV

   f->flushcpumask = cpumask - me;

again:
   for_each_cpu(i, f->flushmask) {

	   if (!running[i]) {
						   case 1:

						   running[n]=1

						   (cpuN does not see
						   flush_on_enter set,
						   guest later finds it
						   running and sends ipi,
						   we are fine here, need
						   to clear the flag on
						   guest_exit)

		  flush_on_enter[i] = 1;
						   case2:

						   running[n]=1
						   (cpuN - will see flush
						   on enter and an IPI as
						   well - addressed in patch-4)

		  if (!running[i])
		     cpu_clear(f->flushmask);      All is well, vm_enter
						   will do the fixup
	   }
						   case 3:
						   running[n] = 0;

						   (cpuN went to sleep,
						   we saw it as awake,
						   ipi sent, but wait
						   will break without
						   zero_mask and goto
						   again will take care)

   }
   send_ipi(f->flushmask)

   wait_a_while_for_zero_mask();

   if (!zero_mask)
	   goto again;
---
 arch/x86/include/asm/kvm_para.h |    3 +-
 arch/x86/include/asm/tlbflush.h |    9 ++++++
 arch/x86/kernel/kvm.c           |    1 +
 arch/x86/kvm/x86.c              |    6 ++++
 arch/x86/mm/tlb.c               |   57 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 75 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index f57b5cc..684a285 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -55,7 +55,8 @@ struct kvm_steal_time {
 
 struct kvm_vcpu_state {
 	__u32 state;
-	__u32 pad[15];
+	__u32 flush_on_enter;
+	__u32 pad[14];
 };
 
 #define KVM_VCPU_STATE_ALIGN_BITS 5
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index c0e108e..29470bd 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -119,6 +119,12 @@ static inline void native_flush_tlb_others(const struct cpumask *cpumask,
 {
 }
 
+static inline void kvm_flush_tlb_others(const struct cpumask *cpumask,
+					struct mm_struct *mm,
+					unsigned long va)
+{
+}
+
 static inline void reset_lazy_tlbstate(void)
 {
 }
@@ -145,6 +151,9 @@ static inline void flush_tlb_range(struct vm_area_struct *vma,
 void native_flush_tlb_others(const struct cpumask *cpumask,
 			     struct mm_struct *mm, unsigned long va);
 
+void kvm_flush_tlb_others(const struct cpumask *cpumask,
+			  struct mm_struct *mm, unsigned long va);
+
 #define TLBSTATE_OK	1
 #define TLBSTATE_LAZY	2
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index bb686a6..66db54e 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -465,6 +465,7 @@ void __init kvm_guest_init(void)
 	}
 
 	has_vcpu_state = 1;
+	pv_mmu_ops.flush_tlb_others = kvm_flush_tlb_others;
 
 #ifdef CONFIG_SMP
 	smp_ops.smp_prepare_boot_cpu = kvm_smp_prepare_boot_cpu;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 60546e9..6c42056 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1549,6 +1549,11 @@ static void kvm_set_vcpu_state(struct kvm_vcpu *vcpu)
 		return;
 
 	vs->state = 1;
+	if (vs->flush_on_enter) {
+		kvm_mmu_flush_tlb(vcpu);
+		vs->flush_on_enter = 0;
+	}
+
 	kvm_write_guest_cached(vcpu->kvm, ghc, vs, 2*sizeof(__u32));
 	smp_wmb();
 }
@@ -1561,6 +1566,7 @@ static void kvm_clear_vcpu_state(struct kvm_vcpu *vcpu)
 	if (!(vcpu->arch.v_state.msr_val & KVM_MSR_ENABLED))
 		return;
 
+	vs->flush_on_enter = 0;
 	vs->state = 0;
 	kvm_write_guest_cached(vcpu->kvm, ghc, vs, 2*sizeof(__u32));
 	smp_wmb();
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index d6c0418..91ae34e 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -6,6 +6,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/cpu.h>
+#include <linux/kvm_para.h>
 
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
@@ -69,6 +70,7 @@ void leave_mm(int cpu)
 }
 EXPORT_SYMBOL_GPL(leave_mm);
 
+DECLARE_PER_CPU(struct kvm_vcpu_state, vcpu_state) __aligned(64);
 /*
  *
  * The flush IPI assumes that a thread switch happens in this order:
@@ -202,6 +204,61 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
 		raw_spin_unlock(&f->tlbstate_lock);
 }
 
+void kvm_flush_tlb_others(const struct cpumask *cpumask,
+			struct mm_struct *mm, unsigned long va)
+{
+	unsigned int sender;
+	union smp_flush_state *f;
+	int cpu, loop;
+	struct kvm_vcpu_state *v_state;
+
+	/* Caller has disabled preemption */
+	sender = this_cpu_read(tlb_vector_offset);
+	f = &flush_state[sender];
+
+	if (nr_cpu_ids > NUM_INVALIDATE_TLB_VECTORS)
+		raw_spin_lock(&f->tlbstate_lock);
+
+	f->flush_mm = mm;
+	f->flush_va = va;
+	if (cpumask_andnot(to_cpumask(f->flush_cpumask), cpumask, cpumask_of(smp_processor_id()))) {
+		/*
+		 * We have to send the IPI only to online vCPUs
+		 * affected. And queue flush_on_enter for pre-empted
+		 * vCPUs
+		 */
+again:
+		for_each_cpu(cpu, to_cpumask(f->flush_cpumask)) {
+			v_state = &per_cpu(vcpu_state, cpu);
+
+			if (!v_state->state) {
+				v_state->flush_on_enter = 1;
+				smp_mb();
+				if (!v_state->state)
+					cpumask_clear_cpu(cpu, to_cpumask(f->flush_cpumask));
+			}
+		}
+
+		if (cpumask_empty(to_cpumask(f->flush_cpumask)))
+			goto out;
+
+		apic->send_IPI_mask(to_cpumask(f->flush_cpumask),
+				    INVALIDATE_TLB_VECTOR_START + sender);
+
+		loop = 1000;
+		while (!cpumask_empty(to_cpumask(f->flush_cpumask)) && --loop)
+			cpu_relax();
+
+		if (!cpumask_empty(to_cpumask(f->flush_cpumask)))
+			goto again;
+	}
+out:
+	f->flush_mm = NULL;
+	f->flush_va = 0;
+	if (nr_cpu_ids > NUM_INVALIDATE_TLB_VECTORS)
+		raw_spin_unlock(&f->tlbstate_lock);
+}
+
 void native_flush_tlb_others(const struct cpumask *cpumask,
 			     struct mm_struct *mm, unsigned long va)
 {


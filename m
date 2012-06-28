Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab2F1GJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:09:48 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:48013 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335Ab2F1GJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:09:44 -0400
X-AuditID: 0ac90646-9b4c8ba000003485-0c-4febf4fda2cd
X-AuditID: 0ac90646-9b4c8ba000003485-0c-4febf4fda2cd
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC PATCH 18/18] x86: request TLB flush to slave CPU using NMI
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 28 Jun 2012 15:08:53 +0900
Message-ID: <20120628060853.19298.32233.stgit@localhost.localdomain>
In-Reply-To: <20120628060719.19298.43879.stgit@localhost.localdomain>
References: <20120628060719.19298.43879.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For slave CPUs, it is inapropriate to request TLB flush using IPI.
because the IPI may be sent to a KVM guest when the slave CPU is running
the guest with direct interrupt routing.

Instead, it registers a TLB flush request in per-cpu bitmask and send a NMI
to interrupt execution of the guest. Then, NMI handler will check the
requests and handles the requests.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/include/asm/mmu.h |    7 +++++
 arch/x86/kvm/x86.c         |   26 ++++++++++++++++++
 arch/x86/mm/tlb.c          |   63 ++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 90 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/mmu.h b/arch/x86/include/asm/mmu.h
index 5f55e69..25af7f1 100644
--- a/arch/x86/include/asm/mmu.h
+++ b/arch/x86/include/asm/mmu.h
@@ -29,4 +29,11 @@ static inline void leave_mm(int cpu)
 }
 #endif
 
+#ifdef CONFIG_SLAVE_CPU
+typedef void(slave_tlbf_notifier_t)(unsigned int cpu, unsigned int sender);
+extern void register_slave_tlbf_notifier(slave_tlbf_notifier_t *f,
+					  unsigned int cpu);
+extern void __smp_invalidate_tlb(unsigned int sender);
+#endif
+
 #endif /* _ASM_X86_MMU_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 90307f0..6ede776 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2636,6 +2636,7 @@ static int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
 
 #ifdef CONFIG_SLAVE_CPU
 
+static void add_slave_tlbf_request(unsigned int cpu, unsigned int sender);
 static int kvm_arch_kicked_by_nmi(unsigned int cmd, struct pt_regs *regs);
 
 static int kvm_arch_vcpu_ioctl_set_slave_cpu(struct kvm_vcpu *vcpu,
@@ -2663,6 +2664,7 @@ static int kvm_arch_vcpu_ioctl_set_slave_cpu(struct kvm_vcpu *vcpu,
 		if (r)
 			goto out;
 		BUG_ON(!cpu_slave(slave));
+		register_slave_tlbf_notifier(add_slave_tlbf_request, slave);
 	}
 
 	vcpu->arch.slave_cpu = slave;
@@ -5331,6 +5333,9 @@ static void process_nmi(struct kvm_vcpu *vcpu)
 /* vcpu currently running on each slave CPU */
 static DEFINE_PER_CPU(struct kvm_vcpu *, slave_vcpu);
 
+/* bitmask to store TLB flush sender sent to each CPU */
+static DEFINE_PER_CPU(unsigned long, slave_tlb_flush_requests);
+
 void kvm_get_slave_cpu_mask(struct kvm *kvm, struct cpumask *mask)
 {
 	int i;
@@ -5341,6 +5346,25 @@ void kvm_get_slave_cpu_mask(struct kvm *kvm, struct cpumask *mask)
 			cpumask_set_cpu(vcpu->arch.slave_cpu, mask);
 }
 
+static void add_slave_tlbf_request(unsigned int cpu, unsigned int sender)
+{
+	unsigned long *mask = &per_cpu(slave_tlb_flush_requests, cpu);
+
+	atomic_set_mask(1 << sender, mask);
+	apic->send_IPI_mask(get_cpu_mask(cpu), NMI_VECTOR);
+}
+
+static void handle_slave_tlb_flush_requests(int cpu)
+{
+	unsigned int sender;
+	unsigned long *mask = &per_cpu(slave_tlb_flush_requests, cpu);
+
+	for_each_set_bit(sender, mask, NUM_INVALIDATE_TLB_VECTORS) {
+		atomic_clear_mask(1 << sender, mask);
+		__smp_invalidate_tlb(sender);
+	}
+}
+
 static int kvm_arch_kicked_by_nmi(unsigned int cmd, struct pt_regs *regs)
 {
 	struct kvm_vcpu *vcpu;
@@ -5349,6 +5373,8 @@ static int kvm_arch_kicked_by_nmi(unsigned int cmd, struct pt_regs *regs)
 	if (!cpu_slave(cpu))
 		return NMI_DONE;
 
+	handle_slave_tlb_flush_requests(cpu);
+
 	/* if called from NMI handler after VM exit, no need to prevent run */
 	vcpu = __this_cpu_read(slave_vcpu);
 	if (!vcpu || vcpu->mode == OUTSIDE_GUEST_MODE || kvm_is_in_guest())
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 5e57e11..c53bd43 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -12,6 +12,7 @@
 #include <asm/cache.h>
 #include <asm/apic.h>
 #include <asm/uv/uv.h>
+#include <asm/cpu.h>
 
 DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate)
 			= { &init_mm, 0, };
@@ -55,6 +56,30 @@ static union smp_flush_state flush_state[NUM_INVALIDATE_TLB_VECTORS];
 
 static DEFINE_PER_CPU_READ_MOSTLY(int, tlb_vector_offset);
 
+#ifdef CONFIG_SLAVE_CPU
+
+static DEFINE_PER_CPU(slave_tlbf_notifier_t *, slave_tlbf_notifier);
+
+void register_slave_tlbf_notifier(slave_tlbf_notifier_t *f, unsigned int cpu)
+{
+	per_cpu(slave_tlbf_notifier, cpu) = f;
+}
+EXPORT_SYMBOL(register_slave_tlbf_notifier);
+
+void request_slave_tlb_flush(const struct cpumask *mask, unsigned int sender)
+{
+	int cpu;
+	slave_tlbf_notifier_t *f;
+
+	for_each_cpu_and(cpu, mask, cpu_slave_mask) {
+		f = per_cpu(slave_tlbf_notifier, cpu);
+		if (f)
+			f(cpu, sender);
+	}
+}
+
+#endif
+
 /*
  * We cannot call mmdrop() because we are in interrupt context,
  * instead update mm->cpu_vm_mask.
@@ -131,17 +156,22 @@ asmlinkage
 #endif
 void smp_invalidate_interrupt(struct pt_regs *regs)
 {
-	unsigned int cpu;
 	unsigned int sender;
-	union smp_flush_state *f;
 
-	cpu = smp_processor_id();
 	/*
 	 * orig_rax contains the negated interrupt vector.
 	 * Use that to determine where the sender put the data.
 	 */
 	sender = ~regs->orig_ax - INVALIDATE_TLB_VECTOR_START;
-	f = &flush_state[sender];
+	__smp_invalidate_tlb(sender);
+	ack_APIC_irq();
+	inc_irq_stat(irq_tlb_count);
+}
+
+void __smp_invalidate_tlb(unsigned int sender)
+{
+	union smp_flush_state *f = &flush_state[sender];
+	unsigned int cpu = smp_processor_id();
 
 	if (!cpumask_test_cpu(cpu, to_cpumask(f->flush_cpumask)))
 		goto out;
@@ -163,13 +193,13 @@ void smp_invalidate_interrupt(struct pt_regs *regs)
 		} else
 			leave_mm(cpu);
 	}
+
 out:
-	ack_APIC_irq();
 	smp_mb__before_clear_bit();
 	cpumask_clear_cpu(cpu, to_cpumask(f->flush_cpumask));
 	smp_mb__after_clear_bit();
-	inc_irq_stat(irq_tlb_count);
 }
+EXPORT_SYMBOL_GPL(__smp_invalidate_tlb);
 
 static void flush_tlb_others_ipi(const struct cpumask *cpumask,
 				 struct mm_struct *mm, unsigned long va)
@@ -191,8 +221,29 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
 		 * We have to send the IPI only to
 		 * CPUs affected.
 		 */
+#ifdef CONFIG_SLAVE_CPU
+		cpumask_var_t ipi_mask;
+
+		request_slave_tlb_flush(to_cpumask(f->flush_cpumask), sender);
+
+		/* send IPI only to online CPUs */
+		if (!alloc_cpumask_var(&ipi_mask, GFP_KERNEL))
+			/* insufficient memory... send IPI to all CPUs */
+			apic->send_IPI_mask(to_cpumask(f->flush_cpumask),
+					INVALIDATE_TLB_VECTOR_START + sender);
+		else {
+			cpumask_and(ipi_mask, to_cpumask(f->flush_cpumask),
+				    cpu_online_mask);
+			request_slave_tlb_flush(to_cpumask(f->flush_cpumask),
+						sender);
+			apic->send_IPI_mask(ipi_mask,
+					INVALIDATE_TLB_VECTOR_START + sender);
+			free_cpumask_var(ipi_mask);
+		}
+#else
 		apic->send_IPI_mask(to_cpumask(f->flush_cpumask),
 			      INVALIDATE_TLB_VECTOR_START + sender);
+#endif
 
 		while (!cpumask_empty(to_cpumask(f->flush_cpumask)))
 			cpu_relax();



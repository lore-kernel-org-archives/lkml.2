Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab2IFLew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:34:52 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:60237 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab2IFLet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:34:49 -0400
X-AuditID: b753bd60-932c5ba0000047ca-a6-504888fd8bae
X-AuditID: b753bd60-932c5ba0000047ca-a6-504888fd8bae
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC v2 PATCH 18/21] KVM: route assigned devices' MSI/MSI-X directly
 to guests on slave CPUs
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 06 Sep 2012 20:28:53 +0900
Message-ID: <20120906112853.13320.56851.stgit@kvmdev>
In-Reply-To: <20120906112718.13320.8231.stgit@kvmdev>
References: <20120906112718.13320.8231.stgit@kvmdev>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a PCI device is assigned to a guest running on slave CPUs, this
routes the device's MSI/MSI-X interrupts directly to the guest.

Because the guest uses a different interrupt vector from the host,
vector remapping is required. This is safe because slave CPUs only handles
interrupts for the assigned guest.

The slave CPU may receive interrupts for the guest while the guest is not
running. In that case, the host IRQ handler is invoked and the interrupt is
transfered as vIRQ.

If the guest receive the direct interrupt from the devices, EOI to physical
APIC is required. To handle this, if the guest issues EOI when there are no
in-service interrupts in the virtual APIC, physical EOI is issued.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/include/asm/kvm_host.h |   19 +++++
 arch/x86/kvm/irq.c              |  136 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/lapic.c            |    6 +-
 arch/x86/kvm/x86.c              |   12 +++
 virt/kvm/assigned-dev.c         |    8 ++
 5 files changed, 179 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 624e5ad..f43680e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1033,4 +1033,23 @@ void kvm_deliver_pmi(struct kvm_vcpu *vcpu);
 
 int kvm_arch_vcpu_run_prevented(struct kvm_vcpu *vcpu);
 
+#ifdef CONFIG_SLAVE_CPU
+void kvm_get_slave_cpu_mask(struct kvm *kvm, struct cpumask *mask);
+
+struct kvm_assigned_dev_kernel;
+extern void assign_slave_msi(struct kvm *kvm,
+			     struct kvm_assigned_dev_kernel *assigned_dev);
+extern void deassign_slave_msi(struct kvm *kvm,
+			       struct kvm_assigned_dev_kernel *assigned_dev);
+extern void assign_slave_msix(struct kvm *kvm,
+			      struct kvm_assigned_dev_kernel *assigned_dev);
+extern void deassign_slave_msix(struct kvm *kvm,
+				struct kvm_assigned_dev_kernel *assigned_dev);
+#else
+#define assign_slave_msi(kvm, assigned_dev)
+#define deassign_slave_msi(kvm, assigned_dev)
+#define assign_slave_msix(kvm, assigned_dev)
+#define deassign_slave_msix(kvm, assigned_dev)
+#endif
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 7e06ba1..128431a 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -22,6 +22,8 @@
 
 #include <linux/module.h>
 #include <linux/kvm_host.h>
+#include <linux/pci.h>
+#include <asm/msidef.h>
 
 #include "irq.h"
 #include "i8254.h"
@@ -94,3 +96,137 @@ void __kvm_migrate_timers(struct kvm_vcpu *vcpu)
 	__kvm_migrate_apic_timer(vcpu);
 	__kvm_migrate_pit_timer(vcpu);
 }
+
+
+#ifdef CONFIG_SLAVE_CPU
+
+static int kvm_lookup_msi_routing_entry(struct kvm *kvm, int irq)
+{
+	int vec = -1;
+	struct kvm_irq_routing_table *irq_rt;
+	struct kvm_kernel_irq_routing_entry *e;
+	struct hlist_node *n;
+
+	rcu_read_lock();
+	irq_rt = rcu_dereference(kvm->irq_routing);
+	if (irq < irq_rt->nr_rt_entries)
+		hlist_for_each_entry(e, n, &irq_rt->map[irq], link)
+			if (e->type == KVM_IRQ_ROUTING_MSI)
+				vec = (e->msi.data & MSI_DATA_VECTOR_MASK)
+					>> MSI_DATA_VECTOR_SHIFT;
+	rcu_read_unlock();
+
+	return vec;
+}
+
+void assign_slave_msi(struct kvm *kvm,
+		      struct kvm_assigned_dev_kernel *assigned_dev)
+{
+	int irq = assigned_dev->guest_irq;
+	int host_irq = assigned_dev->host_irq;
+	struct irq_data *data = irq_get_irq_data(host_irq);
+	int vec = kvm_lookup_msi_routing_entry(kvm, irq);
+	cpumask_var_t slave_mask;
+	char buffer[16];
+
+	BUG_ON(!data);
+
+	if (!zalloc_cpumask_var(&slave_mask, GFP_KERNEL)) {
+		pr_err("assign slave MSI failed: no memory\n");
+		return;
+	}
+	kvm_get_slave_cpu_mask(kvm, slave_mask);
+
+	bitmap_scnprintf(buffer, sizeof(buffer), cpu_slave_mask->bits, 32);
+	pr_info("assigned_device slave msi: irq:%d host:%d vec:%d mask:%s\n",
+		irq, host_irq, vec, buffer);
+
+	remap_slave_vector_irq(host_irq, vec, slave_mask);
+	data->chip->irq_set_affinity(data, slave_mask, 1);
+
+	free_cpumask_var(slave_mask);
+}
+
+void deassign_slave_msi(struct kvm *kvm,
+			struct kvm_assigned_dev_kernel *assigned_dev)
+{
+	int host_irq = assigned_dev->host_irq;
+	cpumask_var_t slave_mask;
+	char buffer[16];
+
+	if (!zalloc_cpumask_var(&slave_mask, GFP_KERNEL)) {
+		pr_err("deassign slave MSI failed: no memory\n");
+		return;
+	}
+	kvm_get_slave_cpu_mask(kvm, slave_mask);
+
+	bitmap_scnprintf(buffer, sizeof(buffer), cpu_slave_mask->bits, 32);
+	pr_info("deassigned_device slave msi: host:%d mask:%s\n",
+		host_irq, buffer);
+
+	revert_slave_vector_irq(host_irq, slave_mask);
+
+	free_cpumask_var(slave_mask);
+}
+
+void assign_slave_msix(struct kvm *kvm,
+		       struct kvm_assigned_dev_kernel *assigned_dev)
+{
+	int i;
+
+	for (i = 0; i < assigned_dev->entries_nr; i++) {
+		int irq = assigned_dev->guest_msix_entries[i].vector;
+		int host_irq = assigned_dev->host_msix_entries[i].vector;
+		struct irq_data *data = irq_get_irq_data(host_irq);
+		int vec = kvm_lookup_msi_routing_entry(kvm, irq);
+		cpumask_var_t slave_mask;
+		char buffer[16];
+
+		pr_info("assign_slave_msix: %d %d %x\n", irq, host_irq, vec);
+		BUG_ON(!data);
+
+		if (!zalloc_cpumask_var(&slave_mask, GFP_KERNEL)) {
+			pr_err("assign slave MSI-X failed: no memory\n");
+			return;
+		}
+		kvm_get_slave_cpu_mask(kvm, slave_mask);
+
+		bitmap_scnprintf(buffer, sizeof(buffer), cpu_slave_mask->bits,
+				 32);
+		pr_info("assigned_device slave msi-x: irq:%d host:%d vec:%d mask:%s\n",
+			irq, host_irq, vec, buffer);
+
+		remap_slave_vector_irq(host_irq, vec, slave_mask);
+		data->chip->irq_set_affinity(data, slave_mask, 1);
+
+		free_cpumask_var(slave_mask);
+	}
+}
+
+void deassign_slave_msix(struct kvm *kvm,
+			 struct kvm_assigned_dev_kernel *assigned_dev)
+{
+	int i;
+
+	for (i = 0; i < assigned_dev->entries_nr; i++) {
+		int host_irq = assigned_dev->host_msix_entries[i].vector;
+		cpumask_var_t slave_mask;
+		char buffer[16];
+
+		if (!zalloc_cpumask_var(&slave_mask, GFP_KERNEL)) {
+			pr_err("deassign slave MSI failed: no memory\n");
+			return;
+		}
+		kvm_get_slave_cpu_mask(kvm, slave_mask);
+
+		bitmap_scnprintf(buffer, sizeof(buffer), cpu_slave_mask->bits, 32);
+		pr_info("deassigned_device slave msi: host:%d mask:%s\n",
+			host_irq, buffer);
+
+		revert_slave_vector_irq(host_irq, slave_mask);
+
+		free_cpumask_var(slave_mask);
+	}
+}
+
+#endif
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 73f57f3..bf8e351 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -585,8 +585,12 @@ static int apic_set_eoi(struct kvm_lapic *apic)
 	 * Not every write EOI will has corresponding ISR,
 	 * one example is when Kernel check timer on setup_IO_APIC
 	 */
-	if (vector == -1)
+	if (vector == -1) {
+		/* On slave cpu, it can be EOI for a direct interrupt */
+		if (cpu_slave(smp_processor_id()))
+			ack_APIC_irq();
 		return vector;
+	}
 
 	apic_clear_isr(vector, apic);
 	apic_update_ppr(apic);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eb2e5c4..609ab62 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5349,6 +5349,17 @@ static void process_nmi(struct kvm_vcpu *vcpu)
 }
 
 #ifdef CONFIG_SLAVE_CPU
+
+void kvm_get_slave_cpu_mask(struct kvm *kvm, struct cpumask *mask)
+{
+	int i;
+	struct kvm_vcpu *vcpu;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		if (vcpu_has_slave_cpu(vcpu))
+			cpumask_set_cpu(vcpu->arch.slave_cpu, mask);
+}
+
 static int kvm_arch_kicked_by_nmi(unsigned int cmd, struct pt_regs *regs)
 {
 	struct kvm_vcpu *vcpu;
@@ -5372,6 +5383,7 @@ static int kvm_arch_kicked_by_nmi(unsigned int cmd, struct pt_regs *regs)
 	kvm_arch_vcpu_prevent_run(vcpu, 1);
 	return NMI_HANDLED;
 }
+
 #endif
 
 enum vcpu_enter_guest_slave_retval {
diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index 23a41a9..a3acc67 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -225,8 +225,12 @@ static void deassign_host_irq(struct kvm *kvm,
 
 		free_irq(assigned_dev->host_irq, assigned_dev);
 
-		if (assigned_dev->irq_requested_type & KVM_DEV_IRQ_HOST_MSI)
+		if (assigned_dev->irq_requested_type & KVM_DEV_IRQ_HOST_MSI) {
 			pci_disable_msi(assigned_dev->dev);
+			deassign_slave_msi(kvm, assigned_dev);
+		}
+		if (assigned_dev->irq_requested_type & KVM_DEV_IRQ_HOST_MSIX)
+			deassign_slave_msix(kvm, assigned_dev);
 	}
 
 	assigned_dev->irq_requested_type &= ~(KVM_DEV_IRQ_HOST_MASK);
@@ -417,6 +421,7 @@ static int assigned_device_enable_guest_msi(struct kvm *kvm,
 {
 	dev->guest_irq = irq->guest_irq;
 	dev->ack_notifier.gsi = -1;
+	assign_slave_msi(kvm, dev);
 	return 0;
 }
 #endif
@@ -428,6 +433,7 @@ static int assigned_device_enable_guest_msix(struct kvm *kvm,
 {
 	dev->guest_irq = irq->guest_irq;
 	dev->ack_notifier.gsi = -1;
+	assign_slave_msix(kvm, dev);
 	return 0;
 }
 #endif



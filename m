Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab1JKShX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:37:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755388Ab1JKShM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:37:12 -0400
Date: Tue, 11 Oct 2011 20:38:09 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 1/2] kvm: pass host irq number to set irq calls
Message-ID: <b53fb428f7b43cf1b59301dfff870898397027ca.1318358229.git.mst@redhat.com>
References: <cover.1318358229.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1318358229.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass host irq number to functions that set guest irq.
If unavailable, pass -1.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/kvm/i8254.c     |    4 ++--
 arch/x86/kvm/lapic.c     |    2 +-
 arch/x86/kvm/x86.c       |    2 +-
 include/linux/kvm_host.h |    7 ++++---
 virt/kvm/assigned-dev.c  |    9 +++++----
 virt/kvm/eventfd.c       |    7 ++++---
 virt/kvm/ioapic.c        |    2 +-
 virt/kvm/ioapic.h        |    2 +-
 virt/kvm/irq_comm.c      |   18 +++++++++++-------
 9 files changed, 30 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index efad723..6b1b47b 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -303,8 +303,8 @@ static void pit_do_work(struct work_struct *work)
 	}
 	spin_unlock(&ps->inject_lock);
 	if (inject) {
-		kvm_set_irq(kvm, kvm->arch.vpit->irq_source_id, 0, 1);
-		kvm_set_irq(kvm, kvm->arch.vpit->irq_source_id, 0, 0);
+		kvm_set_irq(kvm, kvm->arch.vpit->irq_source_id, 0, 1, -1);
+		kvm_set_irq(kvm, kvm->arch.vpit->irq_source_id, 0, 0, -1);
 
 		/*
 		 * Provides NMI watchdog support via Virtual Wire mode.
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 57dcbd4..a643a27 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -508,7 +508,7 @@ static void apic_send_ipi(struct kvm_lapic *apic)
 		   irq.trig_mode, irq.level, irq.dest_mode, irq.delivery_mode,
 		   irq.vector);
 
-	kvm_irq_delivery_to_apic(apic->vcpu->kvm, apic, &irq);
+	kvm_irq_delivery_to_apic(apic->vcpu->kvm, apic, &irq, -1);
 }
 
 static u32 apic_get_tmcct(struct kvm_lapic *apic)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 84a28ea..8e80bf3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3610,7 +3610,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		if (irqchip_in_kernel(kvm)) {
 			__s32 status;
 			status = kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID,
-					irq_event.irq, irq_event.level);
+					irq_event.irq, irq_event.level, -1);
 			if (ioctl == KVM_IRQ_LINE_STATUS) {
 				r = -EFAULT;
 				irq_event.status = status;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index eabb21a..9078b44 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -192,7 +192,7 @@ struct kvm_kernel_irq_routing_entry {
 	u32 gsi;
 	u32 type;
 	int (*set)(struct kvm_kernel_irq_routing_entry *e,
-		   struct kvm *kvm, int irq_source_id, int level);
+		   struct kvm *kvm, int irq_source_id, int level, int host_irq);
 	union {
 		struct {
 			unsigned irqchip;
@@ -546,9 +546,10 @@ void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
 				   union kvm_ioapic_redirect_entry *entry,
 				   unsigned long *deliver_bitmask);
 #endif
-int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level);
+int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level,
+		int host_irq);
 int kvm_set_msi(struct kvm_kernel_irq_routing_entry *irq_entry, struct kvm *kvm,
-		int irq_source_id, int level);
+		int irq_source_id, int level, int host_irq);
 void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin);
 void kvm_register_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian);
diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index 4e9eaeb..f89f138 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -74,11 +74,12 @@ static irqreturn_t kvm_assigned_dev_thread(int irq, void *dev_id)
 			vector = assigned_dev->
 					guest_msix_entries[index].vector;
 			kvm_set_irq(assigned_dev->kvm,
-				    assigned_dev->irq_source_id, vector, 1);
+				    assigned_dev->irq_source_id, vector, 1,
+				    irq);
 		}
 	} else
 		kvm_set_irq(assigned_dev->kvm, assigned_dev->irq_source_id,
-			    assigned_dev->guest_irq, 1);
+			    assigned_dev->guest_irq, 1, irq);
 
 	return IRQ_HANDLED;
 }
@@ -94,7 +95,7 @@ static void kvm_assigned_dev_ack_irq(struct kvm_irq_ack_notifier *kian)
 	dev = container_of(kian, struct kvm_assigned_dev_kernel,
 			   ack_notifier);
 
-	kvm_set_irq(dev->kvm, dev->irq_source_id, dev->guest_irq, 0);
+	kvm_set_irq(dev->kvm, dev->irq_source_id, dev->guest_irq, 0, -1);
 
 	/* The guest irq may be shared so this ack may be
 	 * from another device.
@@ -114,7 +115,7 @@ static void deassign_guest_irq(struct kvm *kvm,
 	assigned_dev->ack_notifier.gsi = -1;
 
 	kvm_set_irq(assigned_dev->kvm, assigned_dev->irq_source_id,
-		    assigned_dev->guest_irq, 0);
+		    assigned_dev->guest_irq, 0, -1);
 
 	if (assigned_dev->irq_source_id != -1)
 		kvm_free_irq_source_id(kvm, assigned_dev->irq_source_id);
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 73358d2..8fcec75 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -67,8 +67,8 @@ irqfd_inject(struct work_struct *work)
 	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
 	struct kvm *kvm = irqfd->kvm;
 
-	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
-	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
+	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1, -1);
+	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0, -1);
 }
 
 /*
@@ -138,7 +138,8 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
 		irq = rcu_dereference(irqfd->irq_entry);
 		/* An event has been signaled, inject an interrupt */
 		if (irq)
-			kvm_set_msi(irq, kvm, KVM_USERSPACE_IRQ_SOURCE_ID, 1);
+			kvm_set_msi(irq, kvm, KVM_USERSPACE_IRQ_SOURCE_ID, 1,
+				    -1);
 		else
 			schedule_work(&irqfd->inject);
 		rcu_read_unlock();
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 8df1ca1..adaa9d8 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -188,7 +188,7 @@ static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 		irqe.dest_id = ioapic->kvm->bsp_vcpu->vcpu_id;
 	}
 #endif
-	return kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe);
+	return kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe, -1);
 }
 
 int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level)
diff --git a/virt/kvm/ioapic.h b/virt/kvm/ioapic.h
index 0b190c3..1cca4b0 100644
--- a/virt/kvm/ioapic.h
+++ b/virt/kvm/ioapic.h
@@ -76,7 +76,7 @@ void kvm_ioapic_destroy(struct kvm *kvm);
 int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level);
 void kvm_ioapic_reset(struct kvm_ioapic *ioapic);
 int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
-		struct kvm_lapic_irq *irq);
+		struct kvm_lapic_irq *irq, int host_irq);
 int kvm_get_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
 int kvm_set_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
 
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 9f614b4..ac8b629 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -46,7 +46,8 @@ static inline int kvm_irq_line_state(unsigned long *irq_state,
 }
 
 static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
-			   struct kvm *kvm, int irq_source_id, int level)
+			   struct kvm *kvm, int irq_source_id, int level,
+			   int host_irq)
 {
 #ifdef CONFIG_X86
 	struct kvm_pic *pic = pic_irqchip(kvm);
@@ -59,7 +60,8 @@ static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
 }
 
 static int kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
-			      struct kvm *kvm, int irq_source_id, int level)
+			      struct kvm *kvm, int irq_source_id, int level,
+			      int host_irq)
 {
 	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
 	level = kvm_irq_line_state(&ioapic->irq_states[e->irqchip.pin],
@@ -79,7 +81,7 @@ inline static bool kvm_is_dm_lowest_prio(struct kvm_lapic_irq *irq)
 }
 
 int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
-		struct kvm_lapic_irq *irq)
+		struct kvm_lapic_irq *irq, int host_irq)
 {
 	int i, r = -1;
 	struct kvm_vcpu *vcpu, *lowest = NULL;
@@ -115,7 +117,7 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 }
 
 int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
-		struct kvm *kvm, int irq_source_id, int level)
+		struct kvm *kvm, int irq_source_id, int level, int host_irq)
 {
 	struct kvm_lapic_irq irq;
 
@@ -135,7 +137,7 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 	irq.shorthand = 0;
 
 	/* TODO Deal with RH bit of MSI message address */
-	return kvm_irq_delivery_to_apic(kvm, NULL, &irq);
+	return kvm_irq_delivery_to_apic(kvm, NULL, &irq, host_irq);
 }
 
 /*
@@ -144,7 +146,8 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
  *  = 0   Interrupt was coalesced (previous irq is still pending)
  *  > 0   Number of CPUs interrupt was delivered to
  */
-int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level)
+int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level,
+		int host_irq)
 {
 	struct kvm_kernel_irq_routing_entry *e, irq_set[KVM_NR_IRQCHIPS];
 	int ret = -1, i = 0;
@@ -166,7 +169,8 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level)
 
 	while(i--) {
 		int r;
-		r = irq_set[i].set(&irq_set[i], kvm, irq_source_id, level);
+		r = irq_set[i].set(&irq_set[i], kvm, irq_source_id, level,
+                                   host_irq);
 		if (r < 0)
 			continue;
 
-- 
1.7.5.53.gc233e


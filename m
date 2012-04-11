Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410Ab2DKPtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 11:49:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab2DKPtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 11:49:47 -0400
Date: Wed, 11 Apr 2012 18:49:55 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: kvm@vger.kernel.org
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kvm: dont clear TMR on EOI
Message-ID: <20120411154953.GA24008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel spec says that TMR needs to be set/cleared
when IRR is set, but kvm also clears it on  EOI.

I did some tests on a real (AMD based) system,
and I see same TMR values both before
and after EOI, so I think it's a minor bug in kvm.

This patch fixes TMR to be set/cleared on IRR set
only as per spec.

And now that we don't clear TMR, we can save
an atomic read of TMR on EOI that's not propagated
to ioapic, by checking whether ioapic needs
a specific vector first and calculating
the mode afterwards.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/kvm/lapic.c |   19 +++++++++++++------
 virt/kvm/ioapic.c    |   10 +++++++---
 virt/kvm/ioapic.h    |    1 +
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8584322..992b4ea 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -92,6 +92,11 @@ static inline int apic_test_and_clear_vector(int vec, void *bitmap)
 	return test_and_clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
 }
 
+static inline int apic_test_vector(int vec, void *bitmap)
+{
+	return test_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
+}
+
 static inline void apic_set_vector(int vec, void *bitmap)
 {
 	set_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
@@ -480,7 +485,6 @@ int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2)
 static void apic_set_eoi(struct kvm_lapic *apic)
 {
 	int vector = apic_find_highest_isr(apic);
-	int trigger_mode;
 	/*
 	 * Not every write EOI will has corresponding ISR,
 	 * one example is when Kernel check timer on setup_IO_APIC
@@ -491,12 +495,15 @@ static void apic_set_eoi(struct kvm_lapic *apic)
 	apic_clear_vector(vector, apic->regs + APIC_ISR);
 	apic_update_ppr(apic);
 
-	if (apic_test_and_clear_vector(vector, apic->regs + APIC_TMR))
-		trigger_mode = IOAPIC_LEVEL_TRIG;
-	else
-		trigger_mode = IOAPIC_EDGE_TRIG;
-	if (!(apic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI))
+	if (!(apic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI) &&
+	    kvm_ioapic_handles_vector(apic->vcpu->kvm, vector)) {
+		int trigger_mode;
+		if (apic_test_vector(vector, apic->regs + APIC_TMR))
+			trigger_mode = IOAPIC_LEVEL_TRIG;
+		else
+			trigger_mode = IOAPIC_EDGE_TRIG;
 		kvm_ioapic_update_eoi(apic->vcpu->kvm, vector, trigger_mode);
+	}
 	kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
 }
 
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index dcaf272c26..26fd54d 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -254,13 +254,17 @@ static void __kvm_ioapic_update_eoi(struct kvm_ioapic *ioapic, int vector,
 	}
 }
 
+bool kvm_ioapic_handles_vector(struct kvm *kvm, int vector)
+{
+	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
+	smp_rmb();
+	return test_bit(vector, ioapic->handled_vectors);
+}
+
 void kvm_ioapic_update_eoi(struct kvm *kvm, int vector, int trigger_mode)
 {
 	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
 
-	smp_rmb();
-	if (!test_bit(vector, ioapic->handled_vectors))
-		return;
 	spin_lock(&ioapic->lock);
 	__kvm_ioapic_update_eoi(ioapic, vector, trigger_mode);
 	spin_unlock(&ioapic->lock);
diff --git a/virt/kvm/ioapic.h b/virt/kvm/ioapic.h
index 0b190c3..32872a0 100644
--- a/virt/kvm/ioapic.h
+++ b/virt/kvm/ioapic.h
@@ -71,6 +71,7 @@ int kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 		int short_hand, int dest, int dest_mode);
 int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2);
 void kvm_ioapic_update_eoi(struct kvm *kvm, int vector, int trigger_mode);
+bool kvm_ioapic_handles_vector(struct kvm *kvm, int vector);
 int kvm_ioapic_init(struct kvm *kvm);
 void kvm_ioapic_destroy(struct kvm *kvm);
 int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level);
-- 
1.7.9.111.gf3fb0

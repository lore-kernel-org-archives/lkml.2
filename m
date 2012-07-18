Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab2GRG1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 02:27:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab2GRG1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 02:27:45 -0400
Date: Wed, 18 Jul 2012 09:27:42 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, avi@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v5 3/4] kvm: Create kvm_clear_irq()
Message-ID: <20120718062742.GH6479@redhat.com>
References: <1342533369.3229.4.camel@ul30vt>
 <20120717140858.GB10822@redhat.com>
 <1342534911.3229.26.camel@ul30vt>
 <20120717145313.GB11516@redhat.com>
 <1342538411.2229.106.camel@bling.home>
 <20120717153620.GB11849@redhat.com>
 <1342540301.2229.117.camel@bling.home>
 <20120717155701.GB12001@redhat.com>
 <1342541301.2229.125.camel@bling.home>
 <20120717161452.GA12114@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120717161452.GA12114@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 07:14:52PM +0300, Michael S. Tsirkin wrote:
> > _Seems_ racy, or _is_ racy?  Please identify the race.
> 
> Look at this:
> 
> static inline int kvm_irq_line_state(unsigned long *irq_state,
>                                      int irq_source_id, int level)
> {
>         /* Logical OR for level trig interrupt */
>         if (level)
>                 set_bit(irq_source_id, irq_state);
>         else
>                 clear_bit(irq_source_id, irq_state);
> 
>         return !!(*irq_state);
> }
> 
> 
> Now:
> If other CPU changes some other bit after the atomic change,
> it looks like !!(*irq_state) might return a stale value.
> 
> CPU 0 clears bit 0. CPU 1 sets bit 1. CPU 1 sets level to 1.
> If CPU 0 sees a stale value now it will return 0 here
> and interrupt will get cleared.
> 
This will hardly happen on x86 especially since bit is set with
serialized instruction. But there is actually a race here.
CPU 0 clears bit 0. CPU 0 read irq_state as 0. CPU 1 sets level to 1.
CPU 1 calls kvm_ioapic_set_irq(1). CPU 0 calls kvm_ioapic_set_irq(0).
No ioapic thinks the level is 0 but irq_state is not 0.

This untested and un-compiled patch should fix it.

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ef91d79..e22c78b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -825,7 +825,7 @@ int kvm_read_guest_page_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 void kvm_propagate_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
 bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl);
 
-int kvm_pic_set_irq(void *opaque, int irq, int level);
+int kvm_pic_set_irq(void *opaque, int irq);
 
 void kvm_inject_nmi(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 81cf4fa..0d6988f 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -188,12 +188,13 @@ void kvm_pic_update_irq(struct kvm_pic *s)
 	pic_unlock(s);
 }
 
-int kvm_pic_set_irq(void *opaque, int irq, int level)
+int kvm_pic_set_irq(void *opaque, int irq)
 {
 	struct kvm_pic *s = opaque;
-	int ret = -1;
+	int ret = -1, level;
 
 	pic_lock(s);
+	level = !!s->irq_states[irq];
 	if (irq >= 0 && irq < PIC_NUM_PINS) {
 		ret = pic_set_irq1(&s->pics[irq >> 3], irq & 7, level);
 		pic_update_irq(s);
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 26fd54d..6ad6a6b 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -191,14 +191,15 @@ static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 	return kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe);
 }
 
-int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level)
+int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq)
 {
 	u32 old_irr;
 	u32 mask = 1 << irq;
 	union kvm_ioapic_redirect_entry entry;
-	int ret = 1;
+	int ret = 1, level;
 
 	spin_lock(&ioapic->lock);
+	level = !!ioapic->irq_states[irq];
 	old_irr = ioapic->irr;
 	if (irq >= 0 && irq < IOAPIC_NUM_PINS) {
 		entry = ioapic->redirtbl[irq];
diff --git a/virt/kvm/ioapic.h b/virt/kvm/ioapic.h
index 32872a0..65894dd 100644
--- a/virt/kvm/ioapic.h
+++ b/virt/kvm/ioapic.h
@@ -74,7 +74,7 @@ void kvm_ioapic_update_eoi(struct kvm *kvm, int vector, int trigger_mode);
 bool kvm_ioapic_handles_vector(struct kvm *kvm, int vector);
 int kvm_ioapic_init(struct kvm *kvm);
 void kvm_ioapic_destroy(struct kvm *kvm);
-int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level);
+int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq);
 void kvm_ioapic_reset(struct kvm_ioapic *ioapic);
 int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq);
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index a6a0365..db0ccef 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -33,7 +33,7 @@
 
 #include "ioapic.h"
 
-static inline int kvm_irq_line_state(unsigned long *irq_state,
+static inline void kvm_irq_line_state(unsigned long *irq_state,
 				     int irq_source_id, int level)
 {
 	/* Logical OR for level trig interrupt */
@@ -41,8 +41,6 @@ static inline int kvm_irq_line_state(unsigned long *irq_state,
 		set_bit(irq_source_id, irq_state);
 	else
 		clear_bit(irq_source_id, irq_state);
-
-	return !!(*irq_state);
 }
 
 static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
@@ -50,9 +48,9 @@ static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
 {
 #ifdef CONFIG_X86
 	struct kvm_pic *pic = pic_irqchip(kvm);
-	level = kvm_irq_line_state(&pic->irq_states[e->irqchip.pin],
+	kvm_irq_line_state(&pic->irq_states[e->irqchip.pin],
 				   irq_source_id, level);
-	return kvm_pic_set_irq(pic, e->irqchip.pin, level);
+	return kvm_pic_set_irq(pic, e->irqchip.pin);
 #else
 	return -1;
 #endif
@@ -62,10 +60,10 @@ static int kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
 			      struct kvm *kvm, int irq_source_id, int level)
 {
 	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
-	level = kvm_irq_line_state(&ioapic->irq_states[e->irqchip.pin],
+	kvm_irq_line_state(&ioapic->irq_states[e->irqchip.pin],
 				   irq_source_id, level);
 
-	return kvm_ioapic_set_irq(ioapic, e->irqchip.pin, level);
+	return kvm_ioapic_set_irq(ioapic, e->irqchip.pin);
 }
 
 inline static bool kvm_is_dm_lowest_prio(struct kvm_lapic_irq *irq)

--
			Gleb.

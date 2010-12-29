Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab0L2FjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 00:39:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab0L2Fii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 00:38:38 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org
Subject: [KVM Clock Synchronization 3/4] Refactor KVM clock update code
Date: Tue, 28 Dec 2010 19:38:19 -1000
Message-Id: <1293601100-32109-4-git-send-email-zamsden@redhat.com>
In-Reply-To: <1293601100-32109-1-git-send-email-zamsden@redhat.com>
References: <1293601100-32109-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor this to make upcoming steps easier to follow.
This should be 100% code motion and renaming.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/x86.c              |   77 +++++++++++++++++++++++----------------
 2 files changed, 46 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 63a82b0..8d829b8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -444,7 +444,7 @@ struct kvm_arch {
 
 	unsigned long irq_sources_bitmap;
 	s64 kvmclock_offset;
-	spinlock_t tsc_write_lock;
+	spinlock_t clock_lock;
 	u64 last_tsc_nsec;
 	u64 last_tsc_offset;
 	u64 last_tsc_write;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b509c01..59d5999 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -996,7 +996,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 	s64 sdiff;
 	u64 delta;
 
-	spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
+	spin_lock_irqsave(&kvm->arch.clock_lock, flags);
 	offset = data - native_read_tsc();
 	ns = get_kernel_ns();
 	elapsed = ns - kvm->arch.last_tsc_nsec;
@@ -1034,7 +1034,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 		kvm->arch.last_tsc_offset = offset;
 	}
 	kvm_x86_ops->write_tsc_offset(vcpu, offset);
-	spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
+	spin_unlock_irqrestore(&kvm->arch.clock_lock, flags);
 
 	/* Reset of TSC must disable overshoot protection below */
 	vcpu->arch.hv_clock.tsc_timestamp = 0;
@@ -1043,22 +1043,50 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 }
 EXPORT_SYMBOL_GPL(kvm_write_tsc);
 
+static void update_pvclock(struct kvm_vcpu *v,
+			   struct pvclock_vcpu_time_info *pvclock,
+			   u64 tsc_timestamp,
+			   s64 kernel_ns,
+			   unsigned long tsc_khz)
+{
+	if (unlikely(v->arch.hw_tsc_khz != tsc_khz)) {
+		kvm_get_time_scale(NSEC_PER_SEC / 1000, tsc_khz,
+				   &pvclock->tsc_shift,
+				   &pvclock->tsc_to_system_mul);
+		v->arch.hw_tsc_khz = tsc_khz;
+	}
+	pvclock->tsc_timestamp = tsc_timestamp;
+	pvclock->system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
+	pvclock->flags = 0;
+}
+
+static void update_user_kvmclock(struct kvm_vcpu *v,
+				 struct pvclock_vcpu_time_info *pvclock)
+{
+	struct kvm_vcpu_arch *vcpu = &v->arch;
+	void *shared_kaddr;
+
+	shared_kaddr = kmap_atomic(vcpu->time_page, KM_USER0);
+	memcpy(shared_kaddr + vcpu->time_offset, pvclock, sizeof(*pvclock));
+	kunmap_atomic(shared_kaddr, KM_USER0);
+	mark_page_dirty(v->kvm, vcpu->time >> PAGE_SHIFT);
+}
+
 static int kvm_guest_time_update(struct kvm_vcpu *v)
 {
 	unsigned long flags;
 	struct kvm_vcpu_arch *vcpu = &v->arch;
-	void *shared_kaddr;
-	unsigned long this_tsc_khz;
-	s64 kernel_ns, max_kernel_ns;
+	unsigned long tsc_khz;
+	s64 kernel_ns;
 	u64 tsc_timestamp;
 
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
 	kvm_get_msr(v, MSR_IA32_TSC, &tsc_timestamp);
 	kernel_ns = get_kernel_ns();
-	this_tsc_khz = __get_cpu_var(cpu_tsc_khz);
+	tsc_khz = __get_cpu_var(cpu_tsc_khz);
 
-	if (unlikely(this_tsc_khz == 0)) {
+	if (unlikely(tsc_khz == 0)) {
 		local_irq_restore(flags);
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
 		return 1;
@@ -1108,32 +1136,23 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	 * guest.  To protect against this, we must compute the system time as
 	 * observed by the guest and ensure the new system time is greater.
 	 */
-	max_kernel_ns = 0;
 	if (vcpu->hv_clock.tsc_timestamp && vcpu->last_guest_tsc) {
-		max_kernel_ns = vcpu->last_guest_tsc -
-				vcpu->hv_clock.tsc_timestamp;
+		s64 max_kernel_ns = vcpu->last_guest_tsc -
+				    vcpu->hv_clock.tsc_timestamp;
 		max_kernel_ns = pvclock_scale_delta(max_kernel_ns,
 				    vcpu->hv_clock.tsc_to_system_mul,
 				    vcpu->hv_clock.tsc_shift);
 		max_kernel_ns += vcpu->last_kernel_ns;
+		if (max_kernel_ns > kernel_ns)
+			kernel_ns = max_kernel_ns;
 	}
 
-	if (unlikely(vcpu->hw_tsc_khz != this_tsc_khz)) {
-		kvm_get_time_scale(NSEC_PER_SEC / 1000, this_tsc_khz,
-				   &vcpu->hv_clock.tsc_shift,
-				   &vcpu->hv_clock.tsc_to_system_mul);
-		vcpu->hw_tsc_khz = this_tsc_khz;
-	}
-
-	if (max_kernel_ns > kernel_ns)
-		kernel_ns = max_kernel_ns;
-
-	/* With all the info we got, fill in the values */
-	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
-	vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
+	/* Record the last values observed for next time */
 	vcpu->last_kernel_ns = kernel_ns;
 	vcpu->last_guest_tsc = tsc_timestamp;
-	vcpu->hv_clock.flags = 0;
+
+	/* Compute new clock values */
+	update_pvclock(v, &vcpu->hv_clock, tsc_timestamp, kernel_ns, tsc_khz);
 
 	/*
 	 * The interface expects us to write an even number signaling that the
@@ -1142,14 +1161,8 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	 */
 	vcpu->hv_clock.version += 2;
 
-	shared_kaddr = kmap_atomic(vcpu->time_page, KM_USER0);
-
-	memcpy(shared_kaddr + vcpu->time_offset, &vcpu->hv_clock,
-	       sizeof(vcpu->hv_clock));
+	update_user_kvmclock(v, &vcpu->hv_clock);
 
-	kunmap_atomic(shared_kaddr, KM_USER0);
-
-	mark_page_dirty(v->kvm, vcpu->time >> PAGE_SHIFT);
 	return 0;
 }
 
@@ -5951,7 +5964,7 @@ struct  kvm *kvm_arch_create_vm(void)
 	/* Reserve bit 0 of irq_sources_bitmap for userspace irq source */
 	set_bit(KVM_USERSPACE_IRQ_SOURCE_ID, &kvm->arch.irq_sources_bitmap);
 
-	spin_lock_init(&kvm->arch.tsc_write_lock);
+	spin_lock_init(&kvm->arch.clock_lock);
 
 	return kvm;
 }
-- 
1.7.1


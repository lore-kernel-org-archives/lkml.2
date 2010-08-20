Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab0HTIKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:10:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab0HTIJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:09:22 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 32/35] Entry conditions for TSC trapping
Date: Thu, 19 Aug 2010 22:07:46 -1000
Message-Id: <1282291669-25709-33-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We must also handle the reverse condition; TSC can't go backwards
when trapping, and it's possible that bad hardware offsetting
makes this problem visible when entering trapping mode.

This is accomodated by adding a 'bump' field to the computed
TSC; it's not pleasant but it works.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +
 arch/x86/kvm/x86.c              |   58 +++++++++++++++++++++++++++++++++++---
 2 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 64569b0..950537c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -413,6 +413,8 @@ struct kvm_arch {
 	u32 virtual_tsc_khz;
 	u32 virtual_tsc_mult;
 	s8 virtual_tsc_shift;
+	s64 tsc_bump;
+	s64 last_tsc_bump_ns;
 
 	struct kvm_xen_hvm_config xen_hvm_config;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 33cb0f0..86f182a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -917,13 +917,48 @@ static void kvm_arch_set_tsc_khz(struct kvm *kvm, u32 this_tsc_khz)
 
 static u64 compute_guest_tsc(struct kvm_vcpu *vcpu, s64 kernel_ns)
 {
+	struct kvm_arch *arch = &vcpu->kvm->arch;
 	u64 tsc = pvclock_scale_delta(kernel_ns-vcpu->arch.last_tsc_nsec,
-				      vcpu->kvm->arch.virtual_tsc_mult,
-				      vcpu->kvm->arch.virtual_tsc_shift);
+				      arch->virtual_tsc_mult,
+				      arch->virtual_tsc_shift);
 	tsc += vcpu->arch.last_tsc_write;
+	if (unlikely(arch->tsc_bump)) {
+		s64 bump;
+
+		/*
+		 * Ugh.  There were a TSC bump.  See how much time elapsed
+		 * in cycles since last read, take it off the bump, but
+		 * ensure TSC advances by at least one.  We're serialized
+		 * by the TSC write lock until the bump is gone.
+		 */
+		spin_lock(&arch->tsc_write_lock);
+		bump = pvclock_scale_delta(kernel_ns - arch->last_tsc_bump_ns,
+					   arch->virtual_tsc_mult,
+					   arch->virtual_tsc_shift);
+		bump = arch->tsc_bump - bump + 1;
+		if (bump < 0) {
+			pr_debug("kvm: vpu%d zeroed TSC bump\n", vcpu->vcpu_id);
+			bump = 0;
+		}
+		arch->tsc_bump = bump;
+		arch->last_tsc_bump_ns = kernel_ns;
+		spin_unlock(&arch->tsc_write_lock);
+
+		tsc += bump;
+	}
 	return tsc;
 }
 
+static void bump_guest_tsc(struct kvm_vcpu *vcpu, s64 bump, s64 kernel_ns)
+{
+	struct kvm *kvm = vcpu->kvm;
+	spin_lock(&kvm->arch.tsc_write_lock);
+	kvm->arch.tsc_bump += bump;
+	kvm->arch.last_tsc_bump_ns = kernel_ns;
+	spin_unlock(&vcpu->kvm->arch.tsc_write_lock);
+	pr_debug("kvm: vcpu%d bumped TSC by %lld\n", vcpu->vcpu_id, bump);
+}
+
 void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -996,7 +1031,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	void *shared_kaddr;
 	unsigned long this_tsc_khz;
 	s64 kernel_ns, max_kernel_ns;
-	u64 tsc_timestamp;
+	u64 tsc_timestamp, tsc;
 	bool kvmclock = (vcpu->time_page != NULL);
 	bool catchup = !kvmclock;
 
@@ -1035,7 +1070,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	}
 
 	if (catchup) {
-		u64 tsc = compute_guest_tsc(v, kernel_ns);
+		tsc = compute_guest_tsc(v, kernel_ns);
 		if (tsc > tsc_timestamp)
 			kvm_x86_ops->adjust_tsc_offset(v, tsc-tsc_timestamp);
 	}
@@ -1048,8 +1083,21 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	if (!kvmclock) {
 		/* Now, see if we need to switch into trap mode */
 		if ((vcpu->tsc_mode == TSC_MODE_TRAP || vcpu->tsc_overrun) &&
-		    !vcpu->tsc_trapping)
+		    !vcpu->tsc_trapping) {
+			/*
+			 * Check for the (hopefully) unlikely event of the
+			 * computed virtual TSC being before the TSC we were
+			 * passing through in hardware.  This can happen if
+			 * the kernel has miscomputed tsc_khz, we miss an
+			 * overrun condition, or via bad SMP calibration.
+			 * If this is the case, we must add a bump to the
+			 * virtual TSC; this suck.
+			 */
+			if (unlikely(tsc < vcpu->last_guest_tsc))
+				bump_guest_tsc(v, vcpu->last_guest_tsc - tsc,
+					       kernel_ns);
 			kvm_x86_ops->set_tsc_trap(v, 1);
+		}
 
 		/* If we're falling behind and not trapping, re-trigger */
 		if (!vcpu->tsc_trapping &&
-- 
1.7.1


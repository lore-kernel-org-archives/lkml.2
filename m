Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab0HTIK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:10:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab0HTIJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:09:13 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 29/35] TSC overrun protection
Date: Thu, 19 Aug 2010 22:07:43 -1000
Message-Id: <1282291669-25709-30-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running on a TSC which runs at a higher rate than the guest
TSC, and not in KVM clock mode, we should not pass through the
TSC.  Add logic to detect this and switch into trap mode.

There are a few problems with this; first, the condition is not
detected at creation time.  This isn't currently an issue since the
clock will be set to the highest possible rate.

The second problem is that we don't have a way to exit this mode;
the underlying TSC will accelerate beyond our control, and so the
offset must be re-adjusted backwards if the overrun condition is
ever removed.

Even entry to this mode is problematic; some hardware errata or
other miscalibration may have exposed an accelerated TSC to the
guest, in which case, we have to preserve the 'bump' of accelerated
time to avoid having a backwards clock movement.

Another problem is that CPU frequency governors may be loaded
after KVM has already started, in which case our estimated CPU
frequency may be shown to be wrong.

These problems will be dealt with separately for clarity.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/x86.c              |   34 ++++++++++++++++++++++++++++------
 2 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 993d13d..9b2d231 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -345,6 +345,7 @@ struct kvm_vcpu_arch {
 	u64 last_tsc_write;
 	bool tsc_rebase;
 	bool tsc_trapping;
+	bool tsc_overrun;
 
 	bool nmi_pending;
 	bool nmi_injected;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 23d1d02..887e30f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1015,13 +1015,19 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 		u64 tsc = compute_guest_tsc(v, kernel_ns);
 		if (tsc > tsc_timestamp)
 			kvm_x86_ops->adjust_tsc_offset(v, tsc-tsc_timestamp);
-	}
-	local_irq_restore(flags);
-	if (catchup) {
-		if (this_tsc_khz < v->kvm->arch.virtual_tsc_khz)
+		local_irq_restore(flags);
+
+		/* Now, see if we need to switch into trap mode */
+		if (vcpu->tsc_overrun && !vcpu->tsc_trapping)
+			kvm_x86_ops->set_tsc_trap(v, 1);
+
+		/* If we're falling behind and not trapping, re-trigger */
+		if (!vcpu->tsc_trapping &&
+		    this_tsc_khz < v->kvm->arch.virtual_tsc_khz)
 			vcpu->tsc_rebase = 1;
 		return 0;
 	}
+	local_irq_restore(flags);
 
 	/*
 	 * Time as measured by the TSC may go backwards when resetting the base
@@ -1098,6 +1104,17 @@ static void kvm_update_tsc_trapping(struct kvm *kvm)
 	int trap, i;
 	struct kvm_vcpu *vcpu;
 
+	/*
+ 	 * Subtle point; we don't consider TSC rate here as part of
+ 	 * the decision to trap or not.  The reason for it is that
+ 	 * TSC rate changes happen asynchronously, and are thus racy.
+ 	 * The only safe place to check for this is above, in
+ 	 * kvm_guest_time_update, where we've read the HZ value and
+ 	 * the indication from the asynchronous notifier that TSC
+ 	 * is in an overrun condition.  Even that is racy, however that
+ 	 * code is guaranteed to be called again if the CPU frequency
+ 	 * changes yet another time before entering hardware virt.
+	 */
 	trap = check_tsc_unstable() && atomic_read(&kvm->online_vcpus) > 1;
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_x86_ops->set_tsc_trap(vcpu, trap && !vcpu->arch.time_page);
@@ -1977,8 +1994,11 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_put_guest_fpu(vcpu);
 	vcpu->arch.last_host_tsc = native_read_tsc();
 
-	/* For unstable TSC, force compensation and catchup on next CPU */
-	if (check_tsc_unstable()) {
+	/*
+	 * For unstable TSC, force compensation and catchup on next CPU
+	 * Don't need to do this if there is an overrun, as we'll trap.
+	 */
+	if (check_tsc_unstable() && !vcpu->arch.tsc_overrun) {
 		vcpu->arch.tsc_rebase = 1;
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 	}
@@ -4342,6 +4362,8 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 		kvm_for_each_vcpu(i, vcpu, kvm) {
 			if (vcpu->cpu != freq->cpu)
 				continue;
+			if (freq->new > kvm->arch.virtual_tsc_khz)
+				vcpu->arch.tsc_overrun = 1;
 			kvm_request_clock_update(vcpu);
 			if (vcpu->cpu != smp_processor_id())
 				send_ipi = 1;
-- 
1.7.1


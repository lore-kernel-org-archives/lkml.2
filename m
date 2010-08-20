Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab0HTIJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:09:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419Ab0HTIJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:09:21 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 31/35] Exit conditions for TSC trapping
Date: Thu, 19 Aug 2010 22:07:45 -1000
Message-Id: <1282291669-25709-32-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apply exit conditions for TSC trapping back to non-trap mode.
To simplify the logic, we use a few static decision functions
and move all the entry / exit to and from trap directly into the
clock update handler.

We pick up a slight benefit of not having to rebase the TSC at every
possible preemption point when we are trapping, which we now know
definitively because the transition points are all in one place.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    4 ++
 arch/x86/kvm/x86.c              |   93 ++++++++++++++++++++++++++++----------
 2 files changed, 72 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9b2d231..64569b0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -345,6 +345,7 @@ struct kvm_vcpu_arch {
 	u64 last_tsc_write;
 	bool tsc_rebase;
 	bool tsc_trapping;
+	bool tsc_mode;		/* 0 = passthrough, 1 = trap */
 	bool tsc_overrun;
 
 	bool nmi_pending;
@@ -373,6 +374,9 @@ struct kvm_vcpu_arch {
 	cpumask_var_t wbinvd_dirty_mask;
 };
 
+#define TSC_MODE_PASSTHROUGH	0
+#define TSC_MODE_TRAP		1
+
 struct kvm_arch {
 	unsigned int n_free_mmu_pages;
 	unsigned int n_requested_mmu_pages;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e618265..33cb0f0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -997,7 +997,8 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	unsigned long this_tsc_khz;
 	s64 kernel_ns, max_kernel_ns;
 	u64 tsc_timestamp;
-	bool catchup = (!vcpu->time_page);
+	bool kvmclock = (vcpu->time_page != NULL);
+	bool catchup = !kvmclock;
 
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
@@ -1011,18 +1012,43 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 		return 1;
 	}
 
+	/*
+	 * If we are trapping and no longer need to, use catchup to
+	 * ensure passthrough TSC will not be less than trapped TSC
+	 */
+	if (vcpu->tsc_mode == TSC_MODE_PASSTHROUGH && vcpu->tsc_trapping &&
+	    ((this_tsc_khz <= v->kvm->arch.virtual_tsc_khz || kvmclock))) {
+		catchup = 1;
+
+		/*
+		 * If there was an overrun condition, we reset the TSC back to
+		 * the last possible guest visible value to avoid unnecessary
+		 * forward leaps; it will catch up to real time below.
+		 */
+		if (unlikely(vcpu->tsc_overrun)) {
+			vcpu->tsc_overrun = 0;
+			if (vcpu->last_guest_tsc)
+				kvm_x86_ops->adjust_tsc_offset(v,
+					vcpu->last_guest_tsc - tsc_timestamp);
+		}
+		kvm_x86_ops->set_tsc_trap(v, 0);
+	}
+
 	if (catchup) {
 		u64 tsc = compute_guest_tsc(v, kernel_ns);
 		if (tsc > tsc_timestamp)
 			kvm_x86_ops->adjust_tsc_offset(v, tsc-tsc_timestamp);
-		local_irq_restore(flags);
-
-		/* hw_tsc_khz unknown at creation time, check for overrun */
-		if (this_tsc_khz > v->kvm->arch.virtual_tsc_khz)
-			vcpu->tsc_overrun = 1;
+	}
+	local_irq_restore(flags);
+ 
+	/* hw_tsc_khz unknown at creation time, check for overrun */
+	if (this_tsc_khz > v->kvm->arch.virtual_tsc_khz)
+		vcpu->tsc_overrun = 1;
 
+	if (!kvmclock) {
 		/* Now, see if we need to switch into trap mode */
-		if (vcpu->tsc_overrun && !vcpu->tsc_trapping)
+		if ((vcpu->tsc_mode == TSC_MODE_TRAP || vcpu->tsc_overrun) &&
+		    !vcpu->tsc_trapping)
 			kvm_x86_ops->set_tsc_trap(v, 1);
 
 		/* If we're falling behind and not trapping, re-trigger */
@@ -1031,7 +1057,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 			vcpu->tsc_rebase = 1;
 		return 0;
 	}
-	local_irq_restore(flags);
 
 	/*
 	 * Time as measured by the TSC may go backwards when resetting the base
@@ -1103,25 +1128,42 @@ static void kvm_request_clock_update(struct kvm_vcpu *v)
 	kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
 }
 
+static inline bool kvm_unstable_smp_clock(struct kvm *kvm)
+{
+	return check_tsc_unstable() && atomic_read(&kvm->online_vcpus) > 1;
+}
+
+static inline bool best_tsc_mode(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * When kvmclock is enabled (time_page is set), we should not trap;
+	 * otherwise, we trap for SMP VMs with unstable clocks.  We also
+	 * will trap for TSC overrun, but not because of this test; overrun
+	 * conditions may disappear with CPU frequency changes, and so
+	 * trapping is not the 'best' mode.  Further, they may also appear
+	 * asynchronously, and we don't want racy logic for tsc_mode, so
+	 * they only set tsc_overrun, not the tsc_mode field.
+	 */
+	return (!vcpu->arch.time_page) && kvm_unstable_smp_clock(vcpu->kvm);
+}
+
 static void kvm_update_tsc_trapping(struct kvm *kvm)
 {
-	int trap, i;
+	int i;
 	struct kvm_vcpu *vcpu;
 
 	/*
- 	 * Subtle point; we don't consider TSC rate here as part of
- 	 * the decision to trap or not.  The reason for it is that
- 	 * TSC rate changes happen asynchronously, and are thus racy.
- 	 * The only safe place to check for this is above, in
+ 	 * The only safe place to check for clock update is in
  	 * kvm_guest_time_update, where we've read the HZ value and
- 	 * the indication from the asynchronous notifier that TSC
- 	 * is in an overrun condition.  Even that is racy, however that
- 	 * code is guaranteed to be called again if the CPU frequency
+ 	 * possibly received indication from the asynchronous notifier that
+	 * the TSC is in an overrun condition.  Even that is racy, however
+	 * that code is guaranteed to be called again if the CPU frequency
  	 * changes yet another time before entering hardware virt.
 	 */
-	trap = check_tsc_unstable() && atomic_read(&kvm->online_vcpus) > 1;
-	kvm_for_each_vcpu(i, vcpu, kvm)
-		kvm_x86_ops->set_tsc_trap(vcpu, trap && !vcpu->arch.time_page);
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		vcpu->arch.tsc_mode = best_tsc_mode(vcpu);
+		kvm_request_clock_update(vcpu);
+	}
 }
 
 static bool msr_mtrr_valid(unsigned msr)
@@ -1445,9 +1487,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 			kvm_release_page_dirty(vcpu->arch.time_page);
 			vcpu->arch.time_page = NULL;
 		}
-
 		vcpu->arch.time = data;
-		kvm_request_clock_update(vcpu);
 
 		/* if the enable bit is set... */
 		if ((data & 1)) {
@@ -1460,7 +1500,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 				vcpu->arch.time_page = NULL;
 			}
 		}
-		kvm_update_tsc_trapping(vcpu->kvm);
+
+		/* Disable / enable trapping for kvmclock */
+		vcpu->arch.tsc_mode = best_tsc_mode(vcpu);
+		kvm_request_clock_update(vcpu);
 		break;
 	}
 	case MSR_IA32_MCG_CTL:
@@ -2000,10 +2043,10 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	vcpu->arch.last_host_tsc = native_read_tsc();
 
 	/*
-	 * For unstable TSC, force compensation and catchup on next CPU
-	 * Don't need to do this if there is an overrun, as we'll trap.
+	 * For unstable TSC, force compensation and catchup on next CPU.
+	 * Don't need to do this if we are trapping.
 	 */
-	if (check_tsc_unstable() && !vcpu->arch.tsc_overrun) {
+	if (check_tsc_unstable() && !vcpu->arch.tsc_trapping) {
 		vcpu->arch.tsc_rebase = 1;
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 	}
-- 
1.7.1


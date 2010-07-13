Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab0GMC10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 22:27:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756769Ab0GMC0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 22:26:14 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: KVM <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Subject: [PATCH 14/18] Fix a possible backwards warp of kvmclock
Date: Mon, 12 Jul 2010 16:25:34 -1000
Message-Id: <1278987938-23873-15-git-send-email-zamsden@redhat.com>
In-Reply-To: <1278987938-23873-1-git-send-email-zamsden@redhat.com>
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel time, which advances in discrete steps may progress much slower
than TSC.  As a result, when kvmclock is adjusted to a new base, the
apparent time to the guest, which runs at a much higher, nsec scaled
rate based on the current TSC, may have already been observed to have
a larger value (kernel_ns + scaled tsc) than the value to which we are
setting it (kernel_ns + 0).

We must instead compute the clock as potentially observed by the guest
for kernel_ns to make sure it does not go backwards.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +
 arch/x86/kvm/x86.c              |   43 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d9e0aa0..94dd16b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -340,6 +340,8 @@ struct kvm_vcpu_arch {
 	struct page *time_page;
 	u64 last_host_tsc;
 	u64 last_host_ns;
+	u64 last_guest_tsc;
+	u64 last_kernel_ns;
 
 	bool nmi_pending;
 	bool nmi_injected;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 08bd15b..f9994c3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -974,14 +974,15 @@ static int kvm_write_guest_time(struct kvm_vcpu *v)
 	struct kvm_vcpu_arch *vcpu = &v->arch;
 	void *shared_kaddr;
 	unsigned long this_tsc_khz;
-	s64 kernel_ns;
+	s64 kernel_ns, max_kernel_ns;
+	u64 tsc_timestamp;
 
 	if ((!vcpu->time_page))
 		return 0;
 
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
-	kvm_get_msr(v, MSR_IA32_TSC, &vcpu->hv_clock.tsc_timestamp);
+	kvm_get_msr(v, MSR_IA32_TSC, &tsc_timestamp);
 	kernel_ns = get_kernel_ns();
 	this_tsc_khz = __get_cpu_var(cpu_tsc_khz);
 	local_irq_restore(flags);
@@ -991,13 +992,49 @@ static int kvm_write_guest_time(struct kvm_vcpu *v)
 		return 1;
 	}
 
+	/*
+	 * Time as measured by the TSC may go backwards when resetting the base
+	 * tsc_timestamp.  The reason for this is that the TSC resolution is
+	 * higher than the resolution of the other clock scales.  Thus, many
+	 * possible measurments of the TSC correspond to one measurement of any
+	 * other clock, and so a spread of values is possible.  This is not a
+	 * problem for the computation of the nanosecond clock; with TSC rates
+	 * around 1GHZ, there can only be a few cycles which correspond to one
+	 * nanosecond value, and any path through this code will inevitably
+	 * take longer than that.  However, with the kernel_ns value itself,
+	 * the precision may be much lower, down to HZ granularity.  If the
+	 * first sampling of TSC against kernel_ns ends in the low part of the
+	 * range, and the second in the high end of the range, we can get:
+	 *
+	 * (TSC - offset_low) * S + kns_old > (TSC - offset_high) * S + kns_new
+	 *
+	 * As the sampling errors potentially range in the thousands of cycles,
+	 * it is possible such a time value has already been observed by the
+	 * guest.  To protect against this, we must compute the system time as
+	 * observed by the guest and ensure the new system time is greater.
+ 	 */
+	max_kernel_ns = 0;
+	if (vcpu->hv_clock.tsc_timestamp && vcpu->last_guest_tsc) {
+		max_kernel_ns = vcpu->last_guest_tsc -
+				vcpu->hv_clock.tsc_timestamp;
+		max_kernel_ns = pvclock_scale_delta(max_kernel_ns,
+				    vcpu->hv_clock.tsc_to_system_mul,
+				    vcpu->hv_clock.tsc_shift);
+		max_kernel_ns += vcpu->last_kernel_ns;
+	}
+
 	if (unlikely(vcpu->hw_tsc_khz != this_tsc_khz)) {
 		kvm_set_time_scale(this_tsc_khz, &vcpu->hv_clock);
 		vcpu->hw_tsc_khz = this_tsc_khz;
 	}
 
+	if (max_kernel_ns > kernel_ns)
+		kernel_ns = max_kernel_ns;
+
 	/* With all the info we got, fill in the values */
+	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
 	vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
+	vcpu->last_kernel_ns = kernel_ns;
 	vcpu->hv_clock.flags = 0;
 
 	/*
@@ -4918,6 +4955,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (hw_breakpoint_active())
 		hw_breakpoint_restore();
 
+	kvm_get_msr(vcpu, MSR_IA32_TSC, &vcpu->arch.last_guest_tsc);
+
 	atomic_set(&vcpu->guest_mode, 0);
 	smp_wmb();
 	local_irq_enable();
-- 
1.7.1


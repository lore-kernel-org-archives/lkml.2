Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab1EFA0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:26:24 -0400
Received: from kroah.org ([198.145.64.141]:37432 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932487Ab1EFA0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:26:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:19 2011
Message-Id: <20110506002219.202521963@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:22:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, avi@redhat.com
Subject: [142/143] KVM: x86: Fix a possible backwards warp of kvmclock
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Zachary Amsden <zamsden@redhat.com>

(backported from commit 1d5f066e0b63271b67eac6d3752f8aa96adcbddb)


Kernel time, which advances in discrete steps may progress much slower
than TSC.  As a result, when kvmclock is adjusted to a new base, the
apparent time to the guest, which runs at a much higher, nsec scaled
rate based on the current TSC, may have already been observed to have
a larger value (kernel_ns + scaled tsc) than the value to which we are
setting it (kernel_ns + 0).

We must instead compute the clock as potentially observed by the guest
for kernel_ns to make sure it does not go backwards.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

BugLink: http://bugs.launchpad.net/bugs/714335

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Reviewed-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/kvm_host.h |    3 ++
 arch/x86/kvm/x86.c              |   47 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 47 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -357,6 +357,9 @@ struct kvm_vcpu_arch {
 	struct page *time_page;
 
 	bool singlestep; /* guest is single stepped by KVM */
+	u64 last_guest_tsc;
+	u64 last_kernel_ns;
+
 	bool nmi_pending;
 	bool nmi_injected;
 
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -47,6 +47,7 @@
 #include <asm/desc.h>
 #include <asm/mtrr.h>
 #include <asm/mce.h>
+#include <asm/pvclock.h>
 
 #define MAX_IO_MSRS 256
 #define CR0_RESERVED_BITS						\
@@ -633,6 +634,8 @@ static void kvm_write_guest_time(struct
 	struct kvm_vcpu_arch *vcpu = &v->arch;
 	void *shared_kaddr;
 	unsigned long this_tsc_khz;
+	s64 kernel_ns, max_kernel_ns;
+	u64 tsc_timestamp;
 
 	if ((!vcpu->time_page))
 		return;
@@ -646,15 +649,51 @@ static void kvm_write_guest_time(struct
 
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
-	kvm_get_msr(v, MSR_IA32_TSC, &vcpu->hv_clock.tsc_timestamp);
+	kvm_get_msr(v, MSR_IA32_TSC, &tsc_timestamp);
 	ktime_get_ts(&ts);
 	monotonic_to_bootbased(&ts);
+	kernel_ns = timespec_to_ns(&ts);
 	local_irq_restore(flags);
 
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
+	 */
+	max_kernel_ns = 0;
+	if (vcpu->hv_clock.tsc_timestamp && vcpu->last_guest_tsc) {
+		max_kernel_ns = vcpu->last_guest_tsc -
+			vcpu->hv_clock.tsc_timestamp;
+		max_kernel_ns = pvclock_scale_delta(max_kernel_ns,
+				vcpu->hv_clock.tsc_to_system_mul,
+				vcpu->hv_clock.tsc_shift);
+		max_kernel_ns += vcpu->last_kernel_ns;
+	}
+
+	if (max_kernel_ns > kernel_ns)
+		kernel_ns = max_kernel_ns;
+
 	/* With all the info we got, fill in the values */
 
-	vcpu->hv_clock.system_time = ts.tv_nsec +
-				     (NSEC_PER_SEC * (u64)ts.tv_sec) + v->kvm->arch.kvmclock_offset;
+	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
+	vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
+	vcpu->last_kernel_ns = kernel_ns;
 
 	/*
 	 * The interface expects us to write an even number signaling that the
@@ -3695,6 +3734,8 @@ static int vcpu_enter_guest(struct kvm_v
 	kvm_x86_ops->prepare_guest_switch(vcpu);
 	kvm_load_guest_fpu(vcpu);
 
+	kvm_get_msr(vcpu, MSR_IA32_TSC, &vcpu->arch.last_guest_tsc);
+
 	local_irq_disable();
 
 	clear_bit(KVM_REQ_KICK, &vcpu->requests);



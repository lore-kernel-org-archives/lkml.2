Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab1FUAAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 20:00:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756282Ab1FUAAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 20:00:02 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, Frank Arnold <farnold@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, linux-kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@gmail.com>
Cc: Zachary Amsden <zamsden@redhat.com>, Zachary Amsden <zamsden@gmail.com>
Subject: [KVM TSC emulation 4/9] Fix last_guest_tsc / tsc_offset semantics
Date: Mon, 20 Jun 2011 16:59:32 -0700
Message-Id: <1308614377-18627-5-git-send-email-zamsden@redhat.com>
In-Reply-To: <1308614377-18627-1-git-send-email-zamsden@redhat.com>
References: <1308614377-18627-1-git-send-email-zamsden@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, Frank Arnold <farnold@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, linux-kvm@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable last_guest_tsc was being used as an ad-hoc indicator
that guest TSC has been initialized and recorded correctly.  However,
it may not have been, it could be that guest TSC has been set to some
large value, the back to a small value (by, say, a software reboot).

This defeats the logic and causes KVM to falsely assume that the
guest TSC has gone backwards, marking the host TSC unstable, which
is undesirable behavior.

In addition, rather than try to compute an offset adjustment for the
TSC on unstable platforms, just recompute the whole offset.  This
allows us to get rid of one callsite for adjust_tsc_offset, which
is problematic because the units it takes are in guest units, but
here, the computation was originally being done in host units.

Doing this, and also recording last_guest_tsc when the TSC is written
allow us to remove the tricky logic which depended on last_guest_tsc
being zero to indicate a reset of uninitialized value.

Instead, we now have the guarantee that the guest TSC offset is
always at least something which will get us last_guest_tsc.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2176714..3bd2ca3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1088,6 +1088,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 	vcpu->arch.hv_clock.tsc_timestamp = 0;
 	vcpu->arch.last_tsc_write = data;
 	vcpu->arch.last_tsc_nsec = ns;
+	vcpu->arch.last_guest_tsc = data;
 }
 EXPORT_SYMBOL_GPL(kvm_write_tsc);
 
@@ -1156,7 +1157,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	 * observed by the guest and ensure the new system time is greater.
 	 */
 	max_kernel_ns = 0;
-	if (vcpu->hv_clock.tsc_timestamp && vcpu->last_guest_tsc) {
+	if (vcpu->hv_clock.tsc_timestamp) {
 		max_kernel_ns = vcpu->last_guest_tsc -
 				vcpu->hv_clock.tsc_timestamp;
 		max_kernel_ns = pvclock_scale_delta(max_kernel_ns,
@@ -2157,13 +2158,13 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		u64 tsc;
 
 		kvm_get_msr(vcpu, MSR_IA32_TSC, &tsc);
-		tsc_delta = !vcpu->arch.last_guest_tsc ? 0 :
-			     tsc - vcpu->arch.last_guest_tsc;
-
+		tsc_delta = tsc - vcpu->arch.last_guest_tsc;
 		if (tsc_delta < 0)
 			mark_tsc_unstable("KVM discovered backwards TSC");
 		if (check_tsc_unstable()) {
-			kvm_x86_ops->adjust_tsc_offset(vcpu, -tsc_delta);
+			u64 offset = kvm_x86_ops->compute_tsc_offset(vcpu,
+					vcpu->arch.last_guest_tsc);
+			kvm_x86_ops->write_tsc_offset(vcpu, offset);
 			vcpu->arch.tsc_catchup = 1;
 		}
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
-- 
1.7.1


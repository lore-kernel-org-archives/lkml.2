Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab1FUABk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 20:01:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472Ab1FTX75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 19:59:57 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, Frank Arnold <farnold@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, linux-kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@gmail.com>
Cc: Zachary Amsden <zamsden@redhat.com>, Zachary Amsden <zamsden@gmail.com>
Subject: [KVM TSC emulation 2/9] Improve TSC offset matching
Date: Mon, 20 Jun 2011 16:59:30 -0700
Message-Id: <1308614377-18627-3-git-send-email-zamsden@redhat.com>
In-Reply-To: <1308614377-18627-1-git-send-email-zamsden@redhat.com>
References: <1308614377-18627-1-git-send-email-zamsden@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, Frank Arnold <farnold@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, linux-kvm@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a few improvements that can be made to the TSC offset
matching code.  First, we don't need to call the 128-bit multiply
(especially on a constant number), the code works much nicer to
do computation in nanosecond units.

Second, the way everything is setup with software TSC rate scaling,
we currently have per-cpu rates.  Obviously this isn't too desirable
to use in practice, but if for some reason we do change the rate of
all VCPUs at runtime, then reset the TSCs, we will only want to
match offsets for VCPUs running at the same rate.

Finally, for the case where we have an unstable host TSC, but
rate scaling is being done in hardware, we should call the platform
code to compute the TSC offset, so the math is reorganized to recompute
the base instead, then transform the base into an offset using the
existing API.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/x86.c              |   37 ++++++++++++++++++++++---------------
 2 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 184cd38..865f051 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -468,6 +468,7 @@ struct kvm_arch {
 	u64 last_tsc_nsec;
 	u64 last_tsc_offset;
 	u64 last_tsc_write;
+	u32 last_tsc_khz;
 
 	struct kvm_xen_hvm_config xen_hvm_config;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 776895a..457bd79 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1041,33 +1041,39 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 	struct kvm *kvm = vcpu->kvm;
 	u64 offset, ns, elapsed;
 	unsigned long flags;
-	s64 sdiff;
+	s64 nsdiff;
 
 	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
 	offset = kvm_x86_ops->compute_tsc_offset(vcpu, data);
 	ns = get_kernel_ns();
 	elapsed = ns - kvm->arch.last_tsc_nsec;
-	sdiff = data - kvm->arch.last_tsc_write;
-	if (sdiff < 0)
-		sdiff = -sdiff;
+
+	/* n.b - signed multiplication and division required */
+	nsdiff = data - kvm->arch.last_tsc_write;
+	nsdiff = (nsdiff * 1000) / vcpu->arch.virtual_tsc_khz;
+	nsdiff -= elapsed;
+	if (nsdiff < 0)
+		nsdiff = -nsdiff;
 
 	/*
-	 * Special case: close write to TSC within 5 seconds of
-	 * another CPU is interpreted as an attempt to synchronize
-	 * The 5 seconds is to accommodate host load / swapping as
-	 * well as any reset of TSC during the boot process.
-	 *
-	 * In that case, for a reliable TSC, we can match TSC offsets,
-	 * or make a best guest using elapsed value.
-	 */
-	if (sdiff < nsec_to_cycles(vcpu, 5ULL * NSEC_PER_SEC) &&
-	    elapsed < 5ULL * NSEC_PER_SEC) {
+	 * Special case: TSC write with a small delta (1 second) of virtual
+	 * cycle time against real time is interpreted as an attempt to
+	 * synchronize the CPU.
+         *
+	 * For a reliable TSC, we can match TSC offsets, and for an unstable
+	 * TSC, we add elapsed time in this computation.  We could let the
+	 * compensation code attempt to catch up if we fall behind, but
+	 * it's better to try to match offsets from the beginning.
+         */
+	if (nsdiff < NSEC_PER_SEC &&
+	    vcpu->arch.virtual_tsc_khz == kvm->arch.last_tsc_khz) {
 		if (!check_tsc_unstable()) {
 			offset = kvm->arch.last_tsc_offset;
 			pr_debug("kvm: matched tsc offset for %llu\n", data);
 		} else {
 			u64 delta = nsec_to_cycles(vcpu, elapsed);
-			offset += delta;
+			data += delta;
+			offset = kvm_x86_ops->compute_tsc_offset(vcpu, data);
 			pr_debug("kvm: adjusted tsc offset by %llu\n", delta);
 		}
 		ns = kvm->arch.last_tsc_nsec;
@@ -1075,6 +1081,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 	kvm->arch.last_tsc_nsec = ns;
 	kvm->arch.last_tsc_write = data;
 	kvm->arch.last_tsc_offset = offset;
+	kvm->arch.last_tsc_khz = vcpu->arch.virtual_tsc_khz;
 	kvm_x86_ops->write_tsc_offset(vcpu, offset);
 	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
-- 
1.7.1


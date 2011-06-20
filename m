Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab1FUAAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 20:00:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756569Ab1FUAAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 20:00:12 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, Frank Arnold <farnold@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, linux-kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@gmail.com>
Cc: Zachary Amsden <zamsden@redhat.com>, Zachary Amsden <zamsden@gmail.com>
Subject: [KVM TSC emulation 8/9] Track TSC synchronization in generations
Date: Mon, 20 Jun 2011 16:59:36 -0700
Message-Id: <1308614377-18627-9-git-send-email-zamsden@redhat.com>
In-Reply-To: <1308614377-18627-1-git-send-email-zamsden@redhat.com>
References: <1308614377-18627-1-git-send-email-zamsden@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, Frank Arnold <farnold@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, linux-kvm@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to track the original nanosecond and counter values
at each phase of TSC writing by the guest.  This gets us perfect
offset matching for stable TSC systems, and perfect software
computed TSC matching for machines with unstable TSC.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |   10 ++++++--
 arch/x86/kvm/x86.c              |   41 +++++++++++++++++++++++++++++++-------
 2 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 226897f..198ce8b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -391,10 +391,11 @@ struct kvm_vcpu_arch {
 	struct page *time_page;
 	u64 last_guest_tsc;
 	u64 last_kernel_ns;
-	u64 last_tsc_nsec;
-	u64 last_tsc_write;
 	u64 last_host_tsc;
 	u64 tsc_offset_adjustment;
+	u64 this_tsc_nsec;
+	u64 this_tsc_write;
+	u8  this_tsc_generation;
 	bool tsc_catchup;
 	bool tsc_always_catchup;
 	s8 virtual_tsc_shift;
@@ -468,9 +469,12 @@ struct kvm_arch {
 	s64 kvmclock_offset;
 	raw_spinlock_t tsc_write_lock;
 	u64 last_tsc_nsec;
-	u64 last_tsc_offset;
 	u64 last_tsc_write;
 	u32 last_tsc_khz;
+	u64 cur_tsc_nsec;
+	u64 cur_tsc_write;
+	u64 cur_tsc_offset;
+	u8  cur_tsc_generation;
 
 	struct kvm_xen_hvm_config xen_hvm_config;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cb8876b..09e67fb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1029,10 +1029,10 @@ static void kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 this_tsc_khz)
 
 static u64 compute_guest_tsc(struct kvm_vcpu *vcpu, s64 kernel_ns)
 {
-	u64 tsc = pvclock_scale_delta(kernel_ns-vcpu->arch.last_tsc_nsec,
+	u64 tsc = pvclock_scale_delta(kernel_ns-vcpu->arch.this_tsc_nsec,
 				      vcpu->arch.virtual_tsc_mult,
 				      vcpu->arch.virtual_tsc_shift);
-	tsc += vcpu->arch.last_tsc_write;
+	tsc += vcpu->arch.this_tsc_write;
 	return tsc;
 }
 
@@ -1068,7 +1068,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 	if (nsdiff < NSEC_PER_SEC &&
 	    vcpu->arch.virtual_tsc_khz == kvm->arch.last_tsc_khz) {
 		if (!check_tsc_unstable()) {
-			offset = kvm->arch.last_tsc_offset;
+			offset = kvm->arch.cur_tsc_offset;
 			pr_debug("kvm: matched tsc offset for %llu\n", data);
 		} else {
 			u64 delta = nsec_to_cycles(vcpu, elapsed);
@@ -1076,20 +1076,45 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 			offset = kvm_x86_ops->compute_tsc_offset(vcpu, data);
 			pr_debug("kvm: adjusted tsc offset by %llu\n", delta);
 		}
+	} else {
+		/*
+		 * We split periods of matched TSC writes into generations.
+		 * For each generation, we track the original measured
+		 * nanosecond time, offset, and write, so if TSCs are in
+		 * sync, we can match exact offset, and if not, we can match
+		 * exact software computaion in compute_guest_tsc()
+		 *
+		 * These values are tracked in kvm->arch.cur_xxx variables.
+		 */
+		kvm->arch.cur_tsc_generation++;
+		kvm->arch.cur_tsc_nsec = ns;
+		kvm->arch.cur_tsc_write = data;
+		kvm->arch.cur_tsc_offset = offset;
+		pr_debug("kvm: new tsc generation %u, clock %llu\n", 
+			 kvm->arch.cur_tsc_generation, data);
 	}
+
+	/*
+	 * We also track th most recent recorded KHZ, write and time to
+	 * allow the matching interval to be extended at each write.
+	 */
 	kvm->arch.last_tsc_nsec = ns;
 	kvm->arch.last_tsc_write = data;
-	kvm->arch.last_tsc_offset = offset;
 	kvm->arch.last_tsc_khz = vcpu->arch.virtual_tsc_khz;
-	kvm_x86_ops->write_tsc_offset(vcpu, offset);
-	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
 	/* Reset of TSC must disable overshoot protection below */
 	vcpu->arch.hv_clock.tsc_timestamp = 0;
-	vcpu->arch.last_tsc_write = data;
-	vcpu->arch.last_tsc_nsec = ns;
 	vcpu->arch.last_guest_tsc = data;
+
+	/* Keep track of which generation this VCPU has synchronized to */
+	vcpu->arch.this_tsc_generation = kvm->arch.cur_tsc_generation;
+	vcpu->arch.this_tsc_nsec = kvm->arch.cur_tsc_nsec;
+	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
+
+	kvm_x86_ops->write_tsc_offset(vcpu, offset);
+	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 }
+
 EXPORT_SYMBOL_GPL(kvm_write_tsc);
 
 static int kvm_guest_time_update(struct kvm_vcpu *v)
-- 
1.7.1


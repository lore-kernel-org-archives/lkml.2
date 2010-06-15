Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab0FOHfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 03:35:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755716Ab0FOHfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 03:35:01 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: avi@redhat.com, mtosatti@redhat.com, glommer@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>
Subject: [PATCH 16/17] TSC reset compensation
Date: Mon, 14 Jun 2010 21:34:18 -1000
Message-Id: <1276587259-32319-17-git-send-email-zamsden@redhat.com>
In-Reply-To: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attempt to synchronize TSCs which are reset to the same value.  In the
case of a reliable hardware TSC, we can just re-use the same offset, but
on non-reliable hardware, we can get closer by adjusting the offset to
match the elapsed time.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   34 ++++++++++++++++++++++++++++++++--
 1 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8e836e9..cedb71f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -937,14 +937,44 @@ static inline void kvm_request_guest_time_update(struct kvm_vcpu *v)
 	set_bit(KVM_REQ_CLOCK_SYNC, &v->requests);
 }
 
+static inline int kvm_tsc_reliable(void)
+{
+	return (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
+		boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
+		!check_tsc_unstable());
+}
+
 void guest_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm *kvm = vcpu->kvm;
-	u64 offset;
+	u64 offset, ns, elapsed;
 
 	spin_lock(&kvm->arch.tsc_write_lock);
 	offset = data - native_read_tsc();
-	kvm->arch.last_tsc_nsec = get_kernel_ns();
+	ns = get_kernel_ns();
+	elapsed = ns - kvm->arch.last_tsc_nsec;
+
+	/*
+	 * Special case: identical write to TSC within 5 seconds of
+	 * another CPU is interpreted as an attempt to synchronize
+	 * (the 5 seconds is to accomodate host load / swapping).
+	 *
+	 * In that case, for a reliable TSC, we can match TSC offsets,
+	 * or make a best guest using kernel_ns value.
+	 */
+	if (data == kvm->arch.last_tsc_write && elapsed < 5 * NSEC_PER_SEC) {
+		if (kvm_tsc_reliable()) {
+			offset = kvm->arch.last_tsc_offset;
+			pr_debug("kvm: matched tsc offset for %llu\n", data);
+		} else {
+			u64 tsc_delta = elapsed * __get_cpu_var(cpu_tsc_khz);
+			tsc_delta = tsc_delta / USEC_PER_SEC;
+			offset -= tsc_delta;
+			pr_debug("kvm: adjusted tsc offset by %llu\n", tsc_delta);
+		}
+		ns = kvm->arch.last_tsc_nsec;
+	}
+	kvm->arch.last_tsc_nsec = ns;
 	kvm->arch.last_tsc_write = data;
 	kvm->arch.last_tsc_offset = offset;
 	kvm_x86_ops->write_tsc_offset(vcpu, offset);
-- 
1.7.1


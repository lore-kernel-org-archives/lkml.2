Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab0HTIIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:08:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375Ab0HTIIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:08:15 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 06/35] TSC reset compensation
Date: Thu, 19 Aug 2010 22:07:20 -1000
Message-Id: <1282291669-25709-7-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attempt to synchronize TSCs which are reset to the same value.  In the
case of a reliable hardware TSC, we can just re-use the same offset, but
on non-reliable hardware, we can get closer by adjusting the offset to
match the elapsed time.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    3 +++
 arch/x86/kvm/x86.c              |   31 ++++++++++++++++++++++++++++++-
 2 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3b4efe2..4b42893 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -396,6 +396,9 @@ struct kvm_arch {
 	unsigned long irq_sources_bitmap;
 	s64 kvmclock_offset;
 	spinlock_t tsc_write_lock;
+	u64 last_tsc_nsec;
+	u64 last_tsc_offset;
+	u64 last_tsc_write;
 
 	struct kvm_xen_hvm_config xen_hvm_config;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 33e8208..62c58f9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -898,11 +898,40 @@ static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
 void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm *kvm = vcpu->kvm;
-	u64 offset;
+	u64 offset, ns, elapsed;
 	unsigned long flags;
+	struct timespec ts;
 
 	spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
 	offset = data - native_read_tsc();
+	ktime_get_ts(&ts);
+	monotonic_to_bootbased(&ts);
+	ns = timespec_to_ns(&ts);
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
+	if (data == kvm->arch.last_tsc_write && elapsed < 5ULL * NSEC_PER_SEC) {
+		if (!check_tsc_unstable()) {
+			offset = kvm->arch.last_tsc_offset;
+			pr_debug("kvm: matched tsc offset for %llu\n", data);
+		} else {
+			u64 tsc_delta = elapsed * __get_cpu_var(cpu_tsc_khz);
+			tsc_delta = tsc_delta / USEC_PER_SEC;
+			offset += tsc_delta;
+			pr_debug("kvm: adjusted tsc offset by %llu\n", tsc_delta);
+		}
+		ns = kvm->arch.last_tsc_nsec;
+	}
+	kvm->arch.last_tsc_nsec = ns;
+	kvm->arch.last_tsc_write = data;
+	kvm->arch.last_tsc_offset = offset;
 	kvm_x86_ops->write_tsc_offset(vcpu, offset);
 	spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750885Ab0L2Fie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 00:38:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808Ab0L2Fic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 00:38:32 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org
Subject: [KVM Clock Synchronization 1/4] Make cyc_to_nsec conversions more reliable
Date: Tue, 28 Dec 2010 19:38:17 -1000
Message-Id: <1293601100-32109-2-git-send-email-zamsden@redhat.com>
In-Reply-To: <1293601100-32109-1-git-send-email-zamsden@redhat.com>
References: <1293601100-32109-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than use the host CPU TSC rate, which can change, compute
cycle to nanosecond conversion in the guest TSC rate, which is
fixed.  This allows the math for write compensation detection
to be made more reliable.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   58 +++++++++++++++++++++------------------------------
 1 files changed, 24 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bfcf8fd..b9118f4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -964,26 +964,10 @@ static inline u64 get_kernel_ns(void)
 static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
 unsigned long max_tsc_khz;
 
-static inline int kvm_tsc_changes_freq(void)
+static inline u64 nsec_to_cycles(struct kvm *kvm, u64 nsec)
 {
-	int cpu = get_cpu();
-	int ret = !boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
-		  cpufreq_quick_get(cpu) != 0;
-	put_cpu();
-	return ret;
-}
-
-static inline u64 nsec_to_cycles(u64 nsec)
-{
-	u64 ret;
-
-	WARN_ON(preemptible());
-	if (kvm_tsc_changes_freq())
-		printk_once(KERN_WARNING
-		 "kvm: unreliable cycle conversion on adjustable rate TSC\n");
-	ret = nsec * __get_cpu_var(cpu_tsc_khz);
-	do_div(ret, USEC_PER_SEC);
-	return ret;
+	return pvclock_scale_delta(nsec, kvm->arch.virtual_tsc_mult,
+				   kvm->arch.virtual_tsc_shift);
 }
 
 static void kvm_arch_set_tsc_khz(struct kvm *kvm, u32 this_tsc_khz)
@@ -1010,6 +994,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 	u64 offset, ns, elapsed;
 	unsigned long flags;
 	s64 sdiff;
+	u64 delta;
 
 	spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
 	offset = data - native_read_tsc();
@@ -1020,29 +1005,34 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 		sdiff = -sdiff;
 
 	/*
-	 * Special case: close write to TSC within 5 seconds of
-	 * another CPU is interpreted as an attempt to synchronize
-	 * The 5 seconds is to accomodate host load / swapping as
-	 * well as any reset of TSC during the boot process.
+	 * Special case: TSC write with a small delta (1 second) of virtual
+	 * cycle time against real time is interpreted as an attempt
+	 * to synchronize the CPU.
 	 *
-	 * In that case, for a reliable TSC, we can match TSC offsets,
-	 * or make a best guest using elapsed value.
+	 * For a reliable TSC, we can match TSC offsets, and for an
+	 * unstable TSC, we will write the update, but ignore elapsed time
+	 * in this computation. The reason for this is that unstable TSC
+	 * will be compensated by the catchup code, and guest loops which
+	 * continually write the TSC could end up overshooting the TSC if
+	 * the elapsed time is factored in.
 	 */
-	if (sdiff < nsec_to_cycles(5ULL * NSEC_PER_SEC) &&
-	    elapsed < 5ULL * NSEC_PER_SEC) {
+	delta = nsec_to_cycles(kvm, elapsed);
+	sdiff -= delta;
+	if (sdiff < 0)
+		sdiff = -sdiff;
+	if (sdiff < nsec_to_cycles(kvm, NSEC_PER_SEC) ) {
 		if (!check_tsc_unstable()) {
 			offset = kvm->arch.last_tsc_offset;
 			pr_debug("kvm: matched tsc offset for %llu\n", data);
 		} else {
-			u64 delta = nsec_to_cycles(elapsed);
-			offset += delta;
-			pr_debug("kvm: adjusted tsc offset by %llu\n", delta);
+			/* Unstable write; don't add elapsed time */
+			pr_debug("kvm: matched write on unstable tsc\n");
 		}
-		ns = kvm->arch.last_tsc_nsec;
+	} else {
+		kvm->arch.last_tsc_nsec = ns;
+		kvm->arch.last_tsc_write = data;
+		kvm->arch.last_tsc_offset = offset;
 	}
-	kvm->arch.last_tsc_nsec = ns;
-	kvm->arch.last_tsc_write = data;
-	kvm->arch.last_tsc_offset = offset;
 	kvm_x86_ops->write_tsc_offset(vcpu, offset);
 	spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
-- 
1.7.1


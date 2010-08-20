Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab0HTILU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:11:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab0HTIJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:09:11 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 28/35] Unstable TSC write compensation
Date: Thu, 19 Aug 2010 22:07:42 -1000
Message-Id: <1282291669-25709-29-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have trapping and catchup mode, based off guest virtual
TSC khz, we can accomodate writes to unstable TSCs by doing computation
in guest HZ rather than the transient host HZ.  Instead of a large
window of approximate elapsed time, we use a narrower (1 second) window of
delta time between the guest TSC and system time.

With this change, guests no longer exhibit pathological behavior
during guest initiatied TSC recalibration.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   51 +++++++++++++++++++++------------------------------
 1 files changed, 21 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 839e3fd..23d1d02 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -900,22 +900,10 @@ static void kvm_get_time_scale(uint32_t scaled_khz, uint32_t base_khz,
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
-	WARN_ON(preemptible());
-	if (kvm_tsc_changes_freq())
-		printk_once(KERN_WARNING
-		 "kvm: unreliable cycle conversion on adjustable rate TSC\n");
-	return (nsec * __get_cpu_var(cpu_tsc_khz)) / USEC_PER_SEC;
+	return pvclock_scale_delta(nsec, kvm->arch.virtual_tsc_mult,
+				   kvm->arch.virtual_tsc_shift);
 }
 
 static void kvm_arch_set_tsc_khz(struct kvm *kvm, u32 this_tsc_khz)
@@ -942,6 +930,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 	u64 offset, ns, elapsed;
 	unsigned long flags;
 	s64 sdiff;
+	u64 delta;
 
 	spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
 	offset = data - native_read_tsc();
@@ -952,29 +941,31 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 		sdiff = -sdiff;
 
 	/*
-	 * Special case: close write to TSC within 5 seconds of
-	 * another CPU is interpreted as an attempt to synchronize
-	 * The 5 seconds is to accomodate host load / swapping as
-	 * well as any reset of TSC during the boot process.
+	 * Special case: TSC write with a small delta of virtual
+	 * cycle time against real time is interpreted as an attempt
+	 * to synchronize the CPU.
 	 *
-	 * In that case, for a reliable TSC, we can match TSC offsets,
-	 * or make a best guest using elapsed value.
+	 * For a reliable TSC, we can match TSC offsets, and for an
+	 * unreliable TSC, we will trap and match the last_nsec value.
+	 * In either case, we will have near perfect synchronization.
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
+			/* Unstable write; allow offset, preserve last write */
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


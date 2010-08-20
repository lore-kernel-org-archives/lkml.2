Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab0HTIIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:08:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab0HTIIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:08:46 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 18/35] Use getnsboottime in KVM
Date: Thu, 19 Aug 2010 22:07:32 -1000
Message-Id: <1282291669-25709-19-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   18 ++++--------------
 1 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fe74b42..ce03c2c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -893,16 +893,6 @@ static void kvm_set_time_scale(uint32_t tsc_khz, struct pvclock_vcpu_time_info *
 		 hv_clock->tsc_to_system_mul);
 }
 
-static inline u64 get_kernel_ns(void)
-{
-	struct timespec ts;
-
-	WARN_ON(preemptible());
-	ktime_get_ts(&ts);
-	monotonic_to_bootbased(&ts);
-	return timespec_to_ns(&ts);
-}
-
 static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
 
 static inline int kvm_tsc_changes_freq(void)
@@ -932,7 +922,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 
 	spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
 	offset = data - native_read_tsc();
-	ns = get_kernel_ns();
+	ns = getnsboottime();
 	elapsed = ns - kvm->arch.last_tsc_nsec;
 	sdiff = data - kvm->arch.last_tsc_write;
 	if (sdiff < 0)
@@ -985,7 +975,7 @@ static int kvm_write_guest_time(struct kvm_vcpu *v)
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
 	kvm_get_msr(v, MSR_IA32_TSC, &tsc_timestamp);
-	kernel_ns = get_kernel_ns();
+	kernel_ns = getnsboottime();
 	this_tsc_khz = __get_cpu_var(cpu_tsc_khz);
 	local_irq_restore(flags);
 
@@ -3331,7 +3321,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			goto out;
 
 		r = 0;
-		now_ns = get_kernel_ns();
+		now_ns = getnsboottime();
 		delta = user_ns.clock - now_ns;
 		kvm->arch.kvmclock_offset = delta;
 		break;
@@ -3340,7 +3330,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		struct kvm_clock_data user_ns;
 		u64 now_ns;
 
-		now_ns = get_kernel_ns();
+		now_ns = getnsboottime();
 		user_ns.clock = kvm->arch.kvmclock_offset + now_ns;
 		user_ns.flags = 0;
 
-- 
1.7.1


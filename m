Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab0GMC07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 22:26:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756793Ab0GMC0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 22:26:19 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: KVM <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Subject: [PATCH 16/18] Use getnsboottime in KVM
Date: Mon, 12 Jul 2010 16:25:36 -1000
Message-Id: <1278987938-23873-17-git-send-email-zamsden@redhat.com>
In-Reply-To: <1278987938-23873-1-git-send-email-zamsden@redhat.com>
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   22 ++++++----------------
 1 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f9994c3..e73ddf6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -891,16 +891,6 @@ static void kvm_set_time_scale(uint32_t tsc_khz, struct pvclock_vcpu_time_info *
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
@@ -930,7 +920,7 @@ void guest_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 
 	spin_lock(&kvm->arch.tsc_write_lock);
 	offset = data - native_read_tsc();
-	ns = get_kernel_ns();
+	ns = getnsboottime();
 	elapsed = ns - kvm->arch.last_tsc_nsec;
 	sdiff = data - kvm->arch.last_tsc_write;
 	if (sdiff < 0)
@@ -983,7 +973,7 @@ static int kvm_write_guest_time(struct kvm_vcpu *v)
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
 	kvm_get_msr(v, MSR_IA32_TSC, &tsc_timestamp);
-	kernel_ns = get_kernel_ns();
+	kernel_ns = getnsboottime();
 	this_tsc_khz = __get_cpu_var(cpu_tsc_khz);
 	local_irq_restore(flags);
 
@@ -1928,7 +1918,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		if (check_tsc_unstable()) {
 			/* Subtract elapsed cycle time */
 			u64 ns = !vcpu->arch.last_host_ns ? 0 :
-				  get_kernel_ns() - vcpu->arch.last_host_ns;
+				  getnsboottime() - vcpu->arch.last_host_ns;
 			tsc_delta -= nsec_to_cycles(ns);
 			kvm_x86_ops->adjust_tsc_offset(vcpu, -tsc_delta);
 		}
@@ -1943,7 +1933,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->vcpu_put(vcpu);
 	kvm_put_guest_fpu(vcpu);
 	vcpu->arch.last_host_tsc = native_read_tsc();
-	vcpu->arch.last_host_ns = get_kernel_ns();
+	vcpu->arch.last_host_ns = getnsboottime();
 }
 
 static int is_efer_nx(void)
@@ -3336,7 +3326,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			goto out;
 
 		r = 0;
-		now_ns = get_kernel_ns();
+		now_ns = getnsboottime();
 		delta = user_ns.clock - now_ns;
 		kvm->arch.kvmclock_offset = delta;
 		break;
@@ -3345,7 +3335,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		struct kvm_clock_data user_ns;
 		u64 now_ns;
 
-		now_ns = get_kernel_ns();
+		now_ns = getnsboottime();
 		user_ns.clock = kvm->arch.kvmclock_offset + now_ns;
 		user_ns.flags = 0;
 
-- 
1.7.1


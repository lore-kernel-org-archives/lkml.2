Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab0FOHez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 03:34:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544Ab0FOHev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 03:34:51 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: avi@redhat.com, mtosatti@redhat.com, glommer@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>
Subject: [PATCH 12/17] Add helper function get_kernel_ns
Date: Mon, 14 Jun 2010 21:34:14 -1000
Message-Id: <1276587259-32319-13-git-send-email-zamsden@redhat.com>
In-Reply-To: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a helper function for the multiple places this is used.  Note that it
must not be called in preemptible context, as that would mean the kernel
could enter software suspend state, which would cause non-atomic operation
of the monotonic_to_bootbased computation.

Open question: should the KVM_SET_CLOCK / KVM_GET_CLOCK ioctls use this
as well?  Currently, they are not bootbased (but perhaps should be).

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 703ea43..15c7317 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -915,6 +915,16 @@ static void kvm_get_time_scale(uint32_t scaled_khz, uint32_t base_khz,
 		 __func__, base_khz, scaled_khz, shift, *pmultiplier);
 }
 
+static inline u64 get_kernel_ns(void)
+{
+	struct timespec ts;
+
+	WARN_ON(preemptible());
+	ktime_get_ts(&ts);
+	monotonic_to_bootbased(&ts);
+	return timespec_to_ns(&ts);
+}
+
 static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
 
 static inline void kvm_request_guest_time_update(struct kvm_vcpu *v)
@@ -924,7 +934,6 @@ static inline void kvm_request_guest_time_update(struct kvm_vcpu *v)
 
 static int kvm_recompute_guest_time(struct kvm_vcpu *v)
 {
-	struct timespec ts;
 	unsigned long flags;
 	struct kvm_vcpu_arch *vcpu = &v->arch;
 	void *shared_kaddr;
@@ -944,9 +953,7 @@ static int kvm_recompute_guest_time(struct kvm_vcpu *v)
 	local_irq_save(flags);
 	this_tsc_khz = __get_cpu_var(cpu_tsc_khz);
 	kvm_get_msr(v, MSR_IA32_TSC, &tsc_timestamp);
-	ktime_get_ts(&ts);
-	monotonic_to_bootbased(&ts);
-	kernel_ns = timespec_to_ns(&ts);
+	kernel_ns = get_kernel_ns();
 	local_irq_restore(flags);
 
 	if (unlikely(this_tsc_khz == 0)) {
@@ -1865,11 +1872,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 		/* Subtract elapsed cycle time from the delta computation */
 		if (check_tsc_unstable() && vcpu->arch.last_host_ns) {
-			s64 delta;
-			struct timespec ts;
-			ktime_get_ts(&ts);
-			monotonic_to_bootbased(&ts);
-			delta = timespec_to_ns(&ts) - vcpu->arch.last_host_ns;
+			s64 delta = get_kernel_ns() - vcpu->arch.last_host_ns;
 			delta = delta * per_cpu(cpu_tsc_khz, cpu);
 			delta = delta / USEC_PER_SEC;
 			tsc_delta -= delta;
@@ -1898,10 +1901,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	 * vcpu->cpu = -1 to force the recalibration above.
 	 */
 	if (check_tsc_unstable()) {
-		struct timespec ts;
-		ktime_get_ts(&ts);
-		monotonic_to_bootbased(&ts);
-		vcpu->arch.last_host_ns = timespec_to_ns(&ts);
+		vcpu->arch.last_host_ns = get_kernel_ns();
 		vcpu->cpu = -1;
 	}
 }
-- 
1.7.1


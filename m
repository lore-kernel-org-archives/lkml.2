Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab0FOHel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 03:34:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924Ab0FOHei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 03:34:38 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: avi@redhat.com, mtosatti@redhat.com, glommer@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>
Subject: [PATCH 06/17] Rename KVM_REQ_KVMCLOCK_UPDATE
Date: Mon, 14 Jun 2010 21:34:08 -1000
Message-Id: <1276587259-32319-7-git-send-email-zamsden@redhat.com>
In-Reply-To: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bit will be used to track all clock synchronization events,
so rename it KVM_REQ_CLOCK_SYNC.  Also it makes some spacing better.

As prep for using it for all synchronization, we can't skip
setting the bit in the event there is no vcpu time page.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c       |   26 ++++++++++----------------
 include/linux/kvm_host.h |    2 +-
 2 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b1bdf05..4b15d03 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -911,7 +911,12 @@ static void kvm_set_time_scale(uint32_t tsc_khz, struct pvclock_vcpu_time_info *
 
 static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
 
-static int kvm_write_guest_time(struct kvm_vcpu *v)
+static inline void kvm_request_guest_time_update(struct kvm_vcpu *v)
+{
+	set_bit(KVM_REQ_CLOCK_SYNC, &v->requests);
+}
+
+static int kvm_recompute_guest_time(struct kvm_vcpu *v)
 {
 	struct timespec ts;
 	unsigned long flags;
@@ -925,7 +930,7 @@ static int kvm_write_guest_time(struct kvm_vcpu *v)
 	this_tsc_khz = get_cpu_var(cpu_tsc_khz);
 	put_cpu_var(cpu_tsc_khz);
 	if (unlikely(this_tsc_khz == 0)) {
-		set_bit(KVM_REQ_KVMCLOCK_UPDATE, &v->requests);
+		kvm_request_guest_time_update(v);
 		return 1;
 	}
 
@@ -966,16 +971,6 @@ static int kvm_write_guest_time(struct kvm_vcpu *v)
 	return 0;
 }
 
-static int kvm_request_guest_time_update(struct kvm_vcpu *v)
-{
-	struct kvm_vcpu_arch *vcpu = &v->arch;
-
-	if (!vcpu->time_page)
-		return 0;
-	set_bit(KVM_REQ_KVMCLOCK_UPDATE, &v->requests);
-	return 1;
-}
-
 static bool msr_mtrr_valid(unsigned msr)
 {
 	switch (msr) {
@@ -4166,8 +4161,7 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 		kvm_for_each_vcpu(i, vcpu, kvm) {
 			if (vcpu->cpu != freq->cpu)
 				continue;
-			if (!kvm_request_guest_time_update(vcpu))
-				continue;
+			kvm_request_guest_time_update(vcpu);
 			if (vcpu->cpu != smp_processor_id())
 				send_ipi = 1;
 		}
@@ -4752,8 +4746,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (vcpu->requests) {
 		if (test_and_clear_bit(KVM_REQ_MIGRATE_TIMER, &vcpu->requests))
 			__kvm_migrate_timers(vcpu);
-		if (test_and_clear_bit(KVM_REQ_KVMCLOCK_UPDATE, &vcpu->requests)) {
-			r = kvm_write_guest_time(vcpu);
+		if (test_and_clear_bit(KVM_REQ_CLOCK_SYNC, &vcpu->requests)) {
+			r = kvm_recompute_guest_time(vcpu);
 			if (unlikely(r))
 				goto out;
 		}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2d96555..142d025 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -36,7 +36,7 @@
 #define KVM_REQ_PENDING_TIMER      5
 #define KVM_REQ_UNHALT             6
 #define KVM_REQ_MMU_SYNC           7
-#define KVM_REQ_KVMCLOCK_UPDATE    8
+#define KVM_REQ_CLOCK_SYNC         8
 #define KVM_REQ_KICK               9
 #define KVM_REQ_DEACTIVATE_FPU    10
 
-- 
1.7.1


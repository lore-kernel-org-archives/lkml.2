Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab0HTIJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:09:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211Ab0HTIJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:09:26 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 34/35] Remove dead code
Date: Thu, 19 Aug 2010 22:07:48 -1000
Message-Id: <1282291669-25709-35-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is basically almost completely totally useless.

N.B.  The hardware_enable code is not redundant; we could have an old
VCPU thread hanging around that was not rescheduled during a
CPU hotremove / hotadd event.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a7fa24e..23d5138 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1179,11 +1179,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	return 0;
 }
 
-static void kvm_request_clock_update(struct kvm_vcpu *v)
-{
-	kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
-}
-
 static inline bool kvm_unstable_smp_clock(struct kvm *kvm)
 {
 	return check_tsc_unstable() && atomic_read(&kvm->online_vcpus) > 1;
@@ -1218,7 +1213,7 @@ static void kvm_update_tsc_trapping(struct kvm *kvm)
 	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		vcpu->arch.tsc_mode = best_tsc_mode(vcpu);
-		kvm_request_clock_update(vcpu);
+		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 	}
 }
 
@@ -1559,7 +1554,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 
 		/* Disable / enable trapping for kvmclock */
 		vcpu->arch.tsc_mode = best_tsc_mode(vcpu);
-		kvm_request_clock_update(vcpu);
+		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 		break;
 	}
 	case MSR_IA32_MCG_CTL:
@@ -4499,7 +4494,7 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 				continue;
 			if (freq->new > kvm->arch.virtual_tsc_khz)
 				vcpu->arch.tsc_overrun = 1;
-			kvm_request_clock_update(vcpu);
+			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 			if (vcpu->cpu != smp_processor_id())
 				send_ipi = 1;
 		}
@@ -5197,7 +5192,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	/* Running on slower TSC without kvmclock, we must bump TSC */
 	if (vcpu->arch.tsc_rebase)
-		kvm_request_clock_update(vcpu);
+		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 
 	preempt_enable();
 
@@ -5791,7 +5786,7 @@ int kvm_arch_hardware_enable(void *garbage)
 	list_for_each_entry(kvm, &vm_list, vm_list)
 		kvm_for_each_vcpu(i, vcpu, kvm)
 			if (vcpu->cpu == smp_processor_id())
-				kvm_request_clock_update(vcpu);
+				kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 	return kvm_x86_ops->hardware_enable(garbage);
 }
 
-- 
1.7.1


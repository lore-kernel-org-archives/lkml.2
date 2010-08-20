Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab0HTIJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:09:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab0HTIJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:09:30 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 35/35] Add some debug stuff
Date: Thu, 19 Aug 2010 22:07:49 -1000
Message-Id: <1282291669-25709-36-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very useful, debug-only output

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   33 +++++++++++++++++++++++++++++++--
 1 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 23d5138..c74a087 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -967,6 +967,9 @@ static void bump_guest_tsc(struct kvm_vcpu *vcpu, s64 bump, s64 kernel_ns)
 	pr_debug("kvm: vcpu%d bumped TSC by %lld\n", vcpu->vcpu_id, bump);
 }
 
+static int tsc_read_log;
+static int tsc_read_cpu = -1;
+
 void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -983,6 +986,12 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 	if (sdiff < 0)
 		sdiff = -sdiff;
 
+#ifdef DEBUG
+	pr_debug("kvm: tsc%d write %llu (ofs %llu)\n", vcpu->vcpu_id, data,
+		 offset);
+	tsc_read_log += 2;
+#endif
+
 	/*
 	 * Special case: TSC write with a small delta of virtual
 	 * cycle time against real time is interpreted as an attempt
@@ -999,7 +1008,8 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 	if (sdiff < nsec_to_cycles(kvm, NSEC_PER_SEC) ) {
 		if (!check_tsc_unstable()) {
 			offset = kvm->arch.last_tsc_offset;
-			pr_debug("kvm: matched tsc offset for %llu\n", data);
+			pr_debug("kvm: matched tsc%d offset for %llu\n", 
+				 vcpu->vcpu_id, data);
 		} else {
 			/* Unstable write; allow offset, preserve last write */
 			pr_debug("kvm: matched write on unstable tsc\n");
@@ -1029,6 +1039,16 @@ void kvm_read_tsc(struct kvm_vcpu *vcpu)
 	kvm_register_write(vcpu, VCPU_REGS_RDX, tsc >> 32);
 	vcpu->arch.last_guest_tsc = tsc;
 	kvm_x86_ops->skip_emulated_instruction(vcpu);
+
+#ifdef DEBUG
+	if (tsc_read_log > 0 && vcpu->vcpu_id != tsc_read_cpu) {
+		--tsc_read_log;
+		tsc_read_cpu = vcpu->vcpu_id;
+		pr_debug("kvm_read_tsc: cpu%d [TRAP] %llu\n",vcpu->vcpu_id,tsc);
+		kvm_get_msr(vcpu, MSR_IA32_TSC, &tsc);
+		pr_debug("kvm_read_tsc: cpu%d [PASS] %llu\n",vcpu->vcpu_id,tsc);
+	}
+#endif
 }
 EXPORT_SYMBOL_GPL(kvm_read_tsc);
 
@@ -1070,11 +1090,16 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 		 */
 		if (unlikely(vcpu->tsc_overrun)) {
 			vcpu->tsc_overrun = 0;
-			if (vcpu->last_guest_tsc)
+			if (vcpu->last_guest_tsc) {
+				pr_debug("kvm: corrected TSC overrun of %llu\n",
+					vcpu->last_guest_tsc - tsc_timestamp);
 				kvm_x86_ops->adjust_tsc_offset(v,
 					vcpu->last_guest_tsc - tsc_timestamp);
+			}
 		}
 		kvm_x86_ops->set_tsc_trap(v, 0);
+		pr_debug("kvm: passing TSC vcpu%d tsc_mode: %d time_page %p\n",
+			 v->vcpu_id, vcpu->tsc_mode, vcpu->time_page);
 	}
 
 	if (catchup) {
@@ -1105,6 +1130,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 				bump_guest_tsc(v, vcpu->last_guest_tsc - tsc,
 					       kernel_ns);
 			kvm_x86_ops->set_tsc_trap(v, 1);
+			pr_debug("kvm: trapping TSC on vcpu%d\n", v->vcpu_id);
 		}
 
 		/* If we're falling behind and not trapping, re-trigger */
@@ -1214,6 +1240,9 @@ static void kvm_update_tsc_trapping(struct kvm *kvm)
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		vcpu->arch.tsc_mode = best_tsc_mode(vcpu);
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
+		pr_debug("kvm: vcpu%d tsc_mode: %d time_page %p\n",
+			 vcpu->vcpu_id, vcpu->arch.tsc_mode,
+			 vcpu->arch.time_page);
 	}
 }
 
-- 
1.7.1


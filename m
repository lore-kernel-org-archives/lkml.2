Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab1BIRat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 12:30:49 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:3313 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab1BIR3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 12:29:55 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LGD1XO-02-4UN-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/6] KVM: X86: Delegate tsc-offset calculation to architecture code
Date: Wed, 9 Feb 2011 18:29:43 +0100
Message-ID: <1297272584-22689-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297272584-22689-1-git-send-email-joerg.roedel@amd.com>
References: <1297272584-22689-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With TSC scaling in SVM the tsc-offset needs to be
calculated differently. This patch propagates this
calculation into the architecture specific modules so that
this complexity can be handled there.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/svm.c              |   11 ++++++++++-
 arch/x86/kvm/vmx.c              |    6 ++++++
 arch/x86/kvm/x86.c              |   10 +++++-----
 4 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9686950..8c40425 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -593,6 +593,7 @@ struct kvm_x86_ops {
 	void (*write_tsc_offset)(struct kvm_vcpu *vcpu, u64 offset);
 
 	bool (*use_virtual_tsc_khz)(struct kvm_vcpu *vcpu);
+	u64 (*compute_tsc_offset)(struct kvm_vcpu *vcpu, u64 target_tsc);
 
 	void (*get_exit_info)(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2);
 	const struct trace_print_flags *exit_reasons_str;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 29833a7..f938585 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -881,7 +881,6 @@ static u64 svm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc)
 
 static bool svm_vcpu_init_tsc(struct kvm *kvm, struct vcpu_svm *svm)
 {
-	u64 raw_tsc, tsc, new_tsc;
 	u64 ratio;
 	u64 khz;
 
@@ -941,6 +940,15 @@ static bool svm_use_virtual_tsc_khz(struct kvm_vcpu *vcpu)
 	return svm->tsc_scale.enabled;
 }
 
+static u64 svm_compute_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
+{
+	u64 tsc;
+
+	tsc = svm_scale_tsc(vcpu, native_read_tsc());
+
+	return target_tsc - tsc;
+}
+
 static void init_vmcb(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -4016,6 +4024,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.write_tsc_offset = svm_write_tsc_offset,
 	.adjust_tsc_offset = svm_adjust_tsc_offset,
 	.use_virtual_tsc_khz = svm_use_virtual_tsc_khz,
+	.compute_tsc_offset = svm_compute_tsc_offset,
 
 	.set_tdp_cr3 = set_tdp_cr3,
 };
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c227a6b..9bbdf1f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1169,6 +1169,11 @@ static bool vmx_use_virtual_tsc_khz(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+static u64 vmx_compute_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
+{
+	return target_tsc - native_read_tsc();
+}
+
 /*
  * Reads an msr value (of 'msr_index') into 'pdata'.
  * Returns 0 on success, non-0 otherwise.
@@ -4449,6 +4454,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.write_tsc_offset = vmx_write_tsc_offset,
 	.adjust_tsc_offset = vmx_adjust_tsc_offset,
 	.use_virtual_tsc_khz = vmx_use_virtual_tsc_khz,
+	.compute_tsc_offset = vmx_compute_tsc_offset,
 
 	.set_tdp_cr3 = vmx_set_cr3,
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 597abc8..6caaf4b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -987,7 +987,7 @@ static u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu)
 		return __this_cpu_read(cpu_tsc_khz);
 }
 
-static inline u64 nsec_to_cycles(u64 nsec)
+static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
 {
 	u64 ret;
 
@@ -995,7 +995,7 @@ static inline u64 nsec_to_cycles(u64 nsec)
 	if (kvm_tsc_changes_freq())
 		printk_once(KERN_WARNING
 		 "kvm: unreliable cycle conversion on adjustable rate TSC\n");
-	ret = nsec * __this_cpu_read(cpu_tsc_khz);
+	ret = nsec * vcpu_tsc_khz(vcpu);
 	do_div(ret, USEC_PER_SEC);
 	return ret;
 }
@@ -1027,7 +1027,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 	s64 sdiff;
 
 	spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
-	offset = data - native_read_tsc();
+	offset = kvm_x86_ops->compute_tsc_offset(vcpu, data);
 	ns = get_kernel_ns();
 	elapsed = ns - kvm->arch.last_tsc_nsec;
 	sdiff = data - kvm->arch.last_tsc_write;
@@ -1043,13 +1043,13 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 	 * In that case, for a reliable TSC, we can match TSC offsets,
 	 * or make a best guest using elapsed value.
 	 */
-	if (sdiff < nsec_to_cycles(5ULL * NSEC_PER_SEC) &&
+	if (sdiff < nsec_to_cycles(vcpu, 5ULL * NSEC_PER_SEC) &&
 	    elapsed < 5ULL * NSEC_PER_SEC) {
 		if (!check_tsc_unstable()) {
 			offset = kvm->arch.last_tsc_offset;
 			pr_debug("kvm: matched tsc offset for %llu\n", data);
 		} else {
-			u64 delta = nsec_to_cycles(elapsed);
+			u64 delta = nsec_to_cycles(vcpu, elapsed);
 			offset += delta;
 			pr_debug("kvm: adjusted tsc offset by %llu\n", delta);
 		}
-- 
1.7.1



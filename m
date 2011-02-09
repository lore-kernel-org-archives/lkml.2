Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab1BIRar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 12:30:47 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:59767 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab1BIR3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 12:29:55 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LGD1XP-01-3VM-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/6] KVM: X86: Let kvm-clock report the right tsc frequency
Date: Wed, 9 Feb 2011 18:29:41 +0100
Message-ID: <1297272584-22689-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297272584-22689-1-git-send-email-joerg.roedel@amd.com>
References: <1297272584-22689-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the kvm_guest_time_update function to use
TSC frequency the guest actually has for updating its clock.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    2 ++
 arch/x86/kvm/svm.c              |    8 ++++++++
 arch/x86/kvm/vmx.c              |    6 ++++++
 arch/x86/kvm/x86.c              |   12 ++++++++++--
 4 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ffd7f8d..9686950 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -592,6 +592,8 @@ struct kvm_x86_ops {
 
 	void (*write_tsc_offset)(struct kvm_vcpu *vcpu, u64 offset);
 
+	bool (*use_virtual_tsc_khz)(struct kvm_vcpu *vcpu);
+
 	void (*get_exit_info)(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2);
 	const struct trace_print_flags *exit_reasons_str;
 };
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c96c0a6..f51f757 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -905,6 +905,13 @@ static void svm_adjust_tsc_offset(struct kvm_vcpu *vcpu, s64 adjustment)
 	mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
 }
 
+static bool svm_use_virtual_tsc_khz(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	return svm->tsc_scale.enabled;
+}
+
 static void init_vmcb(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3976,6 +3983,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 
 	.write_tsc_offset = svm_write_tsc_offset,
 	.adjust_tsc_offset = svm_adjust_tsc_offset,
+	.use_virtual_tsc_khz = svm_use_virtual_tsc_khz,
 
 	.set_tdp_cr3 = set_tdp_cr3,
 };
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ae4f02d..c227a6b 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1164,6 +1164,11 @@ static void vmx_adjust_tsc_offset(struct kvm_vcpu *vcpu, s64 adjustment)
 	vmcs_write64(TSC_OFFSET, offset + adjustment);
 }
 
+static bool vmx_use_virtual_tsc_khz(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 /*
  * Reads an msr value (of 'msr_index') into 'pdata'.
  * Returns 0 on success, non-0 otherwise.
@@ -4443,6 +4448,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 
 	.write_tsc_offset = vmx_write_tsc_offset,
 	.adjust_tsc_offset = vmx_adjust_tsc_offset,
+	.use_virtual_tsc_khz = vmx_use_virtual_tsc_khz,
 
 	.set_tdp_cr3 = vmx_set_cr3,
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8575d85..597abc8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -979,6 +979,14 @@ static inline int kvm_tsc_changes_freq(void)
 	return ret;
 }
 
+static u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu)
+{
+	if (kvm_x86_ops->use_virtual_tsc_khz(vcpu))
+		return vcpu->kvm->arch.virtual_tsc_khz;
+	else
+		return __this_cpu_read(cpu_tsc_khz);
+}
+
 static inline u64 nsec_to_cycles(u64 nsec)
 {
 	u64 ret;
@@ -1010,6 +1018,7 @@ static u64 compute_guest_tsc(struct kvm_vcpu *vcpu, s64 kernel_ns)
 	return tsc;
 }
 
+
 void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -1072,8 +1081,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	local_irq_save(flags);
 	kvm_get_msr(v, MSR_IA32_TSC, &tsc_timestamp);
 	kernel_ns = get_kernel_ns();
-	this_tsc_khz = __this_cpu_read(cpu_tsc_khz);
-
+	this_tsc_khz = vcpu_tsc_khz(v);
 	if (unlikely(this_tsc_khz == 0)) {
 		local_irq_restore(flags);
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
-- 
1.7.1



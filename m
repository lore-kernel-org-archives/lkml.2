Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab1BIRbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 12:31:41 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:29929 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab1BIR3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 12:29:54 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LGD1XN-02-4UK-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/6] KVM: SVM: Implement infrastructure for TSC_RATE_MSR
Date: Wed, 9 Feb 2011 18:29:40 +0100
Message-ID: <1297272584-22689-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297272584-22689-1-git-send-email-joerg.roedel@amd.com>
References: <1297272584-22689-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enhances the kvm_amd module with functions to
support the TSC_RATE_MSR which can be used to set a given
tsc frequency for the guest vcpu.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/msr-index.h |    1 +
 arch/x86/kvm/svm.c               |   37 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 5bfafb6..fdac548 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -106,6 +106,7 @@
    complete list. */
 
 #define MSR_AMD64_PATCH_LEVEL		0x0000008b
+#define MSR_AMD64_TSC_RATIO		0xc0000104
 #define MSR_AMD64_NB_CFG		0xc001001f
 #define MSR_AMD64_PATCH_LOADER		0xc0010020
 #define MSR_AMD64_OSVW_ID_LENGTH	0xc0010140
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index bfb4948..c96c0a6 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -63,6 +63,8 @@ MODULE_LICENSE("GPL");
 
 #define DEBUGCTL_RESERVED_BITS (~(0x3fULL))
 
+#define TSC_RATIO_RSVD          0xffffff0000000000ULL
+
 static bool erratum_383_found __read_mostly;
 
 static const u32 host_save_user_msrs[] = {
@@ -142,6 +144,12 @@ struct vcpu_svm {
 	unsigned int3_injected;
 	unsigned long int3_rip;
 	u32 apf_reason;
+
+	struct {
+		bool enabled;
+		u64  ratio;
+	} tsc_scale;
+
 };
 
 #define MSR_INVALID			0xffffffffU
@@ -852,6 +860,25 @@ static void init_sys_seg(struct vmcb_seg *seg, uint32_t type)
 	seg->base = 0;
 }
 
+static u64 svm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	u64 _tsc = tsc;
+
+	if (svm->tsc_scale.enabled) {
+		u64 mult, frac;
+
+		mult  = svm->tsc_scale.ratio >> 32;
+		frac  = svm->tsc_scale.ratio & ((1ULL << 32) - 1);
+
+		_tsc *= mult;
+		_tsc += (tsc >> 32) * frac;
+		_tsc += ((tsc & ((1ULL << 32) - 1)) * frac) >> 32;
+	}
+
+	return _tsc;
+}
+
 static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -2808,7 +2835,9 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 	case MSR_IA32_TSC: {
 		struct vmcb *vmcb = get_host_vmcb(svm);
 
-		*data = vmcb->control.tsc_offset + native_read_tsc();
+		*data = vmcb->control.tsc_offset +
+			svm_scale_tsc(vcpu, native_read_tsc());
+
 		break;
 	}
 	case MSR_STAR:
@@ -3564,6 +3593,9 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	clgi();
 
+	if (static_cpu_has(X86_FEATURE_TSCRATEMSR) && svm->tsc_scale.enabled)
+		wrmsrl(MSR_AMD64_TSC_RATIO, svm->tsc_scale.ratio);
+
 	local_irq_enable();
 
 	asm volatile (
@@ -3647,6 +3679,9 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	local_irq_disable();
 
+	if (static_cpu_has(X86_FEATURE_TSCRATEMSR) && svm->tsc_scale.enabled)
+		wrmsr(MSR_AMD64_TSC_RATIO, 0, 1);
+
 	vcpu->arch.cr2 = svm->vmcb->save.cr2;
 	vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
 	vcpu->arch.regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
-- 
1.7.1



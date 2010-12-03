Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab0LCKrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 05:47:14 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:41320
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932397Ab0LCKq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 05:46:26 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCULX0-01-H0F-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/12] KVM: SVM: Add clean-bit for control registers
Date: Fri, 3 Dec 2010 11:45:54 +0100
Message-ID: <1291373159-4822-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
References: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the CRx clean-bit for the vmcb. This
bit covers cr0, cr3, cr4, and efer.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 3b5d894..1b35969 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -192,6 +192,7 @@ enum {
 	VMCB_ASID,	 /* ASID */
 	VMCB_INTR,	 /* int_ctl, int_vector */
 	VMCB_NPT,        /* npt_en, nCR3, gPAT */
+	VMCB_CR,	 /* CR0, CR3, CR4, EFER */
 	VMCB_DIRTY_MAX,
 };
 
@@ -441,6 +442,7 @@ static void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 		efer &= ~EFER_LME;
 
 	to_svm(vcpu)->vmcb->save.efer = efer | EFER_SVME;
+	mark_dirty(to_svm(vcpu)->vmcb, VMCB_CR);
 }
 
 static int is_external_interrupt(u32 info)
@@ -1338,6 +1340,7 @@ static void update_cr0_intercept(struct vcpu_svm *svm)
 		*hcr0 = (*hcr0 & ~SVM_CR0_SELECTIVE_MASK)
 			| (gcr0 & SVM_CR0_SELECTIVE_MASK);
 
+	mark_dirty(svm->vmcb, VMCB_CR);
 
 	if (gcr0 == *hcr0 && svm->vcpu.fpu_active) {
 		clr_cr_intercept(svm, INTERCEPT_CR0_READ);
@@ -1404,6 +1407,7 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	 */
 	cr0 &= ~(X86_CR0_CD | X86_CR0_NW);
 	svm->vmcb->save.cr0 = cr0;
+	mark_dirty(svm->vmcb, VMCB_CR);
 	update_cr0_intercept(svm);
 }
 
@@ -1420,6 +1424,7 @@ static void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		cr4 |= X86_CR4_PAE;
 	cr4 |= host_cr4_mce;
 	to_svm(vcpu)->vmcb->save.cr4 = cr4;
+	mark_dirty(to_svm(vcpu)->vmcb, VMCB_CR);
 }
 
 static void svm_set_segment(struct kvm_vcpu *vcpu,
@@ -3546,6 +3551,7 @@ static void svm_set_cr3(struct kvm_vcpu *vcpu, unsigned long root)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb->save.cr3 = root;
+	mark_dirty(svm->vmcb, VMCB_CR);
 	force_new_asid(vcpu);
 }
 
@@ -3558,6 +3564,7 @@ static void set_tdp_cr3(struct kvm_vcpu *vcpu, unsigned long root)
 
 	/* Also sync guest cr3 here in case we live migrate */
 	svm->vmcb->save.cr3 = vcpu->arch.cr3;
+	mark_dirty(svm->vmcb, VMCB_CR);
 
 	force_new_asid(vcpu);
 }
-- 
1.7.1



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613Ab0LCOZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:25:53 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:30138
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758456Ab0LCOZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:25:49 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCUW28-02-9F0-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/3] KVM: SVM: Use svm_flush_tlb instead of force_new_asid
Date: Fri, 3 Dec 2010 15:25:15 +0100
Message-ID: <1291386316-6885-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291386316-6885-1-git-send-email-joerg.roedel@amd.com>
References: <1291386316-6885-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces all calls to force_new_asid which are
intended to flush the guest-tlb by the more appropriate
function svm_flush_tlb. As a side-effect the force_new_asid
function is removed.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 772d48e..b70a1e8 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -384,11 +384,6 @@ static inline void invlpga(unsigned long addr, u32 asid)
 	asm volatile (__ex(SVM_INVLPGA) : : "a"(addr), "c"(asid));
 }
 
-static inline void force_new_asid(struct kvm_vcpu *vcpu)
-{
-	to_svm(vcpu)->asid_generation--;
-}
-
 static int get_npt_level(void)
 {
 #ifdef CONFIG_X86_64
@@ -958,7 +953,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 		save->cr3 = 0;
 		save->cr4 = 0;
 	}
-	force_new_asid(&svm->vcpu);
+	svm->asid_generation = 0;
 
 	svm->nested.vmcb = 0;
 	svm->vcpu.arch.hflags = 0;
@@ -1371,7 +1366,7 @@ static void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	unsigned long old_cr4 = to_svm(vcpu)->vmcb->save.cr4;
 
 	if (npt_enabled && ((old_cr4 ^ cr4) & X86_CR4_PGE))
-		force_new_asid(vcpu);
+		svm_flush_tlb(vcpu);
 
 	vcpu->arch.cr4 = cr4;
 	if (!npt_enabled)
@@ -1706,7 +1701,7 @@ static void nested_svm_set_tdp_cr3(struct kvm_vcpu *vcpu,
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb->control.nested_cr3 = root;
-	force_new_asid(vcpu);
+	svm_flush_tlb(vcpu);
 }
 
 static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu)
@@ -2307,7 +2302,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	svm->nested.intercept_exceptions = nested_vmcb->control.intercept_exceptions;
 	svm->nested.intercept            = nested_vmcb->control.intercept;
 
-	force_new_asid(&svm->vcpu);
+	svm_flush_tlb(&svm->vcpu);
 	svm->vmcb->control.int_ctl = nested_vmcb->control.int_ctl | V_INTR_MASKING_MASK;
 	if (nested_vmcb->control.int_ctl & V_INTR_MASKING_MASK)
 		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
@@ -3242,7 +3237,7 @@ static int svm_set_tss_addr(struct kvm *kvm, unsigned int addr)
 
 static void svm_flush_tlb(struct kvm_vcpu *vcpu)
 {
-	force_new_asid(vcpu);
+	to_svm(vcpu)->asid_generation--;
 }
 
 static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
@@ -3491,7 +3486,7 @@ static void svm_set_cr3(struct kvm_vcpu *vcpu, unsigned long root)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb->save.cr3 = root;
-	force_new_asid(vcpu);
+	svm_flush_tlb(vcpu);
 }
 
 static void set_tdp_cr3(struct kvm_vcpu *vcpu, unsigned long root)
@@ -3503,7 +3498,7 @@ static void set_tdp_cr3(struct kvm_vcpu *vcpu, unsigned long root)
 	/* Also sync guest cr3 here in case we live migrate */
 	svm->vmcb->save.cr3 = vcpu->arch.cr3;
 
-	force_new_asid(vcpu);
+	svm_flush_tlb(vcpu);
 }
 
 static int is_disabled(void)
-- 
1.7.1



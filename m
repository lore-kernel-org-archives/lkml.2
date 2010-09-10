Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab0IJPdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:33:11 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:34777 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab0IJPdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:33:07 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8JF43-01-7OZ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 26/29] KVM: SVM: Initialize Nested Nested MMU context on VMRUN
Date: Fri, 10 Sep 2010 17:31:03 +0200
Message-ID: <1284132667-18620-27-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
References: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code to initialize the Nested Nested Paging
MMU context when the L1 guest executes a VMRUN instruction
and has nested paging enabled in its VMCB.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c |    1 +
 arch/x86/kvm/svm.c |   50 +++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 95cbeed..6e248d8 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2962,6 +2962,7 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 {
 	mmu_free_roots(vcpu);
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_unload);
 
 static void mmu_pte_write_zap_pte(struct kvm_vcpu *vcpu,
 				  struct kvm_mmu_page *sp,
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a483aa9..9df60c3 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -294,6 +294,15 @@ static inline void flush_guest_tlb(struct kvm_vcpu *vcpu)
 	force_new_asid(vcpu);
 }
 
+static int get_npt_level(void)
+{
+#ifdef CONFIG_X86_64
+	return PT64_ROOT_LEVEL;
+#else
+	return PT32E_ROOT_LEVEL;
+#endif
+}
+
 static void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
 	vcpu->arch.efer = efer;
@@ -1630,6 +1639,26 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu)
 	nested_svm_vmexit(svm);
 }
 
+static int nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
+{
+	int r;
+
+	r = kvm_init_shadow_mmu(vcpu, &vcpu->arch.mmu);
+
+	vcpu->arch.mmu.set_cr3           = nested_svm_set_tdp_cr3;
+	vcpu->arch.mmu.get_cr3           = nested_svm_get_tdp_cr3;
+	vcpu->arch.mmu.inject_page_fault = nested_svm_inject_npf_exit;
+	vcpu->arch.mmu.shadow_root_level = get_npt_level();
+	vcpu->arch.walk_mmu              = &vcpu->arch.nested_mmu;
+
+	return r;
+}
+
+static void nested_svm_uninit_mmu_context(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.walk_mmu = &vcpu->arch.mmu;
+}
+
 static int nested_svm_check_permissions(struct vcpu_svm *svm)
 {
 	if (!(svm->vcpu.arch.efer & EFER_SVME)
@@ -1998,6 +2027,8 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	kvm_clear_exception_queue(&svm->vcpu);
 	kvm_clear_interrupt_queue(&svm->vcpu);
 
+	svm->nested.nested_cr3 = 0;
+
 	/* Restore selected save entries */
 	svm->vmcb->save.es = hsave->save.es;
 	svm->vmcb->save.cs = hsave->save.cs;
@@ -2024,6 +2055,7 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	nested_svm_unmap(page);
 
+	nested_svm_uninit_mmu_context(&svm->vcpu);
 	kvm_mmu_reset_context(&svm->vcpu);
 	kvm_mmu_load(&svm->vcpu);
 
@@ -2071,6 +2103,9 @@ static bool nested_vmcb_checks(struct vmcb *vmcb)
 	if (vmcb->control.asid == 0)
 		return false;
 
+	if (vmcb->control.nested_ctl && !npt_enabled)
+		return false;
+
 	return true;
 }
 
@@ -2143,6 +2178,12 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	else
 		svm->vcpu.arch.hflags &= ~HF_HIF_MASK;
 
+	if (nested_vmcb->control.nested_ctl) {
+		kvm_mmu_unload(&svm->vcpu);
+		svm->nested.nested_cr3 = nested_vmcb->control.nested_cr3;
+		nested_svm_init_mmu_context(&svm->vcpu);
+	}
+
 	/* Load the nested guest state */
 	svm->vmcb->save.es = nested_vmcb->save.es;
 	svm->vmcb->save.cs = nested_vmcb->save.cs;
@@ -3410,15 +3451,6 @@ static bool svm_cpu_has_accelerated_tpr(void)
 	return false;
 }
 
-static int get_npt_level(void)
-{
-#ifdef CONFIG_X86_64
-	return PT64_ROOT_LEVEL;
-#else
-	return PT32E_ROOT_LEVEL;
-#endif
-}
-
 static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	return 0;
-- 
1.7.0.4



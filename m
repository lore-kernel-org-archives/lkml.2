Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab0D0KmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:42:25 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:47523 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab0D0Ki7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:38:59 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzz6ff19h6d525hz32i2a8h87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1J6WO-02-NP2-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 20/22] KVM: SVM: Initialize Nested Nested MMU context on VMRUN
Date: Tue, 27 Apr 2010 12:38:30 +0200
Message-ID: <1272364712-17425-21-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Apr 2010 10:38:36.0214 (UTC) FILETIME=[CA974560:01CAE5F5]
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
 arch/x86/kvm/svm.c |   56 ++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index af89e71..e5dc853 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2569,6 +2569,7 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 {
 	mmu_free_roots(vcpu);
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_unload);
 
 static void mmu_pte_write_zap_pte(struct kvm_vcpu *vcpu,
 				  struct kvm_mmu_page *sp,
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e31f601..266b1d4 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -94,7 +94,6 @@ struct nested_state {
 
 	/* Nested Paging related state */
 	u64 nested_cr3;
-
 };
 
 #define MSRPM_OFFSETS	16
@@ -283,6 +282,15 @@ static inline void flush_guest_tlb(struct kvm_vcpu *vcpu)
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
 	if (!npt_enabled && !(efer & EFER_LMA))
@@ -1523,6 +1531,27 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
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
+	vcpu->arch.nested_mmu.gva_to_gpa = vcpu->arch.mmu.gva_to_gpa;
+	vcpu->arch.mmu.nested            = true;
+
+	return r;
+}
+
+static void nested_svm_uninit_mmu_context(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.mmu.nested = false;
+}
+
 static int nested_svm_check_permissions(struct vcpu_svm *svm)
 {
 	if (!(svm->vcpu.arch.efer & EFER_SVME)
@@ -1889,6 +1918,8 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	kvm_clear_exception_queue(&svm->vcpu);
 	kvm_clear_interrupt_queue(&svm->vcpu);
 
+	svm->nested.nested_cr3 = 0;
+
 	/* Restore selected save entries */
 	svm->vmcb->save.es = hsave->save.es;
 	svm->vmcb->save.cs = hsave->save.cs;
@@ -1915,6 +1946,7 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	nested_svm_unmap(page);
 
+	nested_svm_uninit_mmu_context(&svm->vcpu);
 	kvm_mmu_reset_context(&svm->vcpu);
 	kvm_mmu_load(&svm->vcpu);
 
@@ -1968,6 +2000,13 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	if (!nested_vmcb)
 		return false;
 
+	/* Do check if nested paging is allowed for the guest */
+	if (nested_vmcb->control.nested_ctl && !npt_enabled) {
+		nested_vmcb->control.exit_code = SVM_EXIT_ERR;
+		nested_svm_unmap(page);
+		return false;
+	}
+
 	trace_kvm_nested_vmrun(svm->vmcb->save.rip - 3, vmcb_gpa,
 			       nested_vmcb->save.rip,
 			       nested_vmcb->control.int_ctl,
@@ -2012,6 +2051,12 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
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
@@ -3171,15 +3216,6 @@ static bool svm_cpu_has_accelerated_tpr(void)
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



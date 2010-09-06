Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab0IFPEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:04:43 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:31256 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab0IFPC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:02:56 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8BZ2R-02-4XA-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <"http://kvm.qumranet.com"@osrc.amd.com>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 25/27] KVM: SVM: Initialize Nested Nested MMU context on VMRUN
Date: Mon, 6 Sep 2010 17:02:00 +0200
Message-ID: <1283785322-26898-26-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
References: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
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
index ea8ed8b..cf4474b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2945,6 +2945,7 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 {
 	mmu_free_roots(vcpu);
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_unload);
 
 static void mmu_pte_write_zap_pte(struct kvm_vcpu *vcpu,
 				  struct kvm_mmu_page *sp,
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 6e72ba9..949e10d 100644
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
@@ -1632,6 +1641,26 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
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
@@ -2000,6 +2029,8 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	kvm_clear_exception_queue(&svm->vcpu);
 	kvm_clear_interrupt_queue(&svm->vcpu);
 
+	svm->nested.nested_cr3 = 0;
+
 	/* Restore selected save entries */
 	svm->vmcb->save.es = hsave->save.es;
 	svm->vmcb->save.cs = hsave->save.cs;
@@ -2026,6 +2057,7 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	nested_svm_unmap(page);
 
+	nested_svm_uninit_mmu_context(&svm->vcpu);
 	kvm_mmu_reset_context(&svm->vcpu);
 	kvm_mmu_load(&svm->vcpu);
 
@@ -2073,6 +2105,9 @@ static bool nested_vmcb_checks(struct vmcb *vmcb)
 	if (vmcb->control.asid == 0)
 		return false;
 
+	if (vmcb->control.nested_ctl && !npt_enabled)
+		return false;
+
 	return true;
 }
 
@@ -2145,6 +2180,12 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
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
@@ -3412,15 +3453,6 @@ static bool svm_cpu_has_accelerated_tpr(void)
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



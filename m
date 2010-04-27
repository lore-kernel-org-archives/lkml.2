Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab0D0Kjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:39:43 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:7801 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab0D0Kjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:39:39 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzz6ff19hz32i87h2a8h66h)
X-Spam-TCS-SCL: 5:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1J6WE-02-NOM-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/22] KVM: X86: Introduce a tdp_set_cr3 function
Date: Tue, 27 Apr 2010 12:38:14 +0200
Message-ID: <1272364712-17425-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Apr 2010 10:38:35.0574 (UTC) FILETIME=[CA359D60:01CAE5F5]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a special set_tdp_cr3 function pointer
in kvm_x86_ops which is only used for tpd enabled mmu
contexts. This allows to remove some hacks from svm code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |    2 +-
 arch/x86/kvm/svm.c              |   23 ++++++++++++++---------
 arch/x86/kvm/vmx.c              |    3 +++
 4 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 04834b0..5c74269 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -531,6 +531,7 @@ struct kvm_x86_ops {
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 	int (*get_lpage_level)(void);
 	bool (*rdtscp_supported)(void);
+	void (*set_tdp_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
 
 	void (*set_supported_cpuid)(u32 func, struct kvm_cpuid_entry2 *entry);
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 6eedcdd..f1fac9a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2386,7 +2386,7 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->shadow_root_level = kvm_x86_ops->get_tdp_level();
 	context->root_hpa = INVALID_PAGE;
 	vcpu->arch.mmu.direct_map = true;
-	vcpu->arch.mmu.set_cr3 = kvm_x86_ops->set_cr3;
+	vcpu->arch.mmu.set_cr3 = kvm_x86_ops->set_tdp_cr3;
 
 	if (!is_paging(vcpu)) {
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 889f660..4aae4be 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2982,9 +2982,6 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	gs_selector = kvm_read_gs();
 	ldt_selector = kvm_read_ldt();
 	svm->vmcb->save.cr2 = vcpu->arch.cr2;
-	/* required for live migration with NPT */
-	if (npt_enabled)
-		svm->vmcb->save.cr3 = vcpu->arch.cr3;
 
 	clgi();
 
@@ -3093,16 +3090,22 @@ static void svm_set_cr3(struct kvm_vcpu *vcpu, unsigned long root)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (npt_enabled) {
-		svm->vmcb->control.nested_cr3 = root;
-		force_new_asid(vcpu);
-		return;
-	}
-
 	svm->vmcb->save.cr3 = root;
 	force_new_asid(vcpu);
 }
 
+static void set_tdp_cr3(struct kvm_vcpu *vcpu, unsigned long root)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->vmcb->control.nested_cr3 = root;
+
+	/* Also sync guest cr3 here in case we live migrate */
+	svm->vmcb->save.cr3 = vcpu->arch.cr3;
+
+	force_new_asid(vcpu);
+}
+
 static int is_disabled(void)
 {
 	u64 vm_cr;
@@ -3314,6 +3317,8 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.rdtscp_supported = svm_rdtscp_supported,
 
 	.set_supported_cpuid = svm_set_supported_cpuid,
+
+	.set_tdp_cr3 = set_tdp_cr3,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 875b785..d6377f0 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4191,6 +4191,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.get_mt_mask = vmx_get_mt_mask,
 
 	.exit_reasons_str = vmx_exit_reasons_str,
+
 	.get_lpage_level = vmx_get_lpage_level,
 
 	.cpuid_update = vmx_cpuid_update,
@@ -4198,6 +4199,8 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.rdtscp_supported = vmx_rdtscp_supported,
 
 	.set_supported_cpuid = vmx_set_supported_cpuid,
+
+	.set_tdp_cr3 = vmx_set_cr3,
 };
 
 static int __init vmx_init(void)
-- 
1.7.0.4



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab0IJPiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:38:20 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:57198 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab0IJPcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:32:41 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8JF3Z-02-JPT-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/29] KVM: X86: Introduce a tdp_set_cr3 function
Date: Fri, 10 Sep 2010 17:30:41 +0200
Message-ID: <1284132667-18620-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
References: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
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
 arch/x86/include/asm/kvm_host.h |    2 ++
 arch/x86/kvm/mmu.c              |    2 +-
 arch/x86/kvm/svm.c              |   23 ++++++++++++++---------
 arch/x86/kvm/vmx.c              |    2 ++
 4 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 43c8db0..aeeea9c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -526,6 +526,8 @@ struct kvm_x86_ops {
 	bool (*rdtscp_supported)(void);
 	void (*adjust_tsc_offset)(struct kvm_vcpu *vcpu, s64 adjustment);
 
+	void (*set_tdp_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
+
 	void (*set_supported_cpuid)(u32 func, struct kvm_cpuid_entry2 *entry);
 
 	bool (*has_wbinvd_exit)(void);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c8acb96..a55f8d5 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2714,7 +2714,7 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->shadow_root_level = kvm_x86_ops->get_tdp_level();
 	context->root_hpa = INVALID_PAGE;
 	context->direct_map = true;
-	context->set_cr3 = kvm_x86_ops->set_cr3;
+	context->set_cr3 = kvm_x86_ops->set_tdp_cr3;
 
 	if (!is_paging(vcpu)) {
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 6808f64..094df31 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3216,9 +3216,6 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	gs_selector = kvm_read_gs();
 	ldt_selector = kvm_read_ldt();
 	svm->vmcb->save.cr2 = vcpu->arch.cr2;
-	/* required for live migration with NPT */
-	if (npt_enabled)
-		svm->vmcb->save.cr3 = vcpu->arch.cr3;
 
 	clgi();
 
@@ -3335,16 +3332,22 @@ static void svm_set_cr3(struct kvm_vcpu *vcpu, unsigned long root)
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
@@ -3571,6 +3574,8 @@ static struct kvm_x86_ops svm_x86_ops = {
 
 	.write_tsc_offset = svm_write_tsc_offset,
 	.adjust_tsc_offset = svm_adjust_tsc_offset,
+
+	.set_tdp_cr3 = set_tdp_cr3,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 676555c..0e62d8a 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4347,6 +4347,8 @@ static struct kvm_x86_ops vmx_x86_ops = {
 
 	.write_tsc_offset = vmx_write_tsc_offset,
 	.adjust_tsc_offset = vmx_adjust_tsc_offset,
+
+	.set_tdp_cr3 = vmx_set_cr3,
 };
 
 static int __init vmx_init(void)
-- 
1.7.0.4



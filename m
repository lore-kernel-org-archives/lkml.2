Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab0IJPfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:35:22 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:33667 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab0IJPcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:32:51 -0400
X-SpamScore: 9
X-BigFish: VS9(zz78fbpzz1202hzz8275bhz32i2a8h87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8JF40-02-JPX-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/29] KVM: MMU: Introduce get_cr3 function pointer
Date: Fri, 10 Sep 2010 17:30:42 +0200
Message-ID: <1284132667-18620-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
References: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function pointer in the MMU context is required to
implement Nested Nested Paging.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |    9 ++++++++-
 arch/x86/kvm/paging_tmpl.h      |    4 ++--
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index aeeea9c..ab708ee 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -237,6 +237,7 @@ struct kvm_pio_request {
 struct kvm_mmu {
 	void (*new_cr3)(struct kvm_vcpu *vcpu);
 	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long root);
+	unsigned long (*get_cr3)(struct kvm_vcpu *vcpu);
 	int (*page_fault)(struct kvm_vcpu *vcpu, gva_t gva, u32 err);
 	void (*free)(struct kvm_vcpu *vcpu);
 	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t gva, u32 access,
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a55f8d5..e4a7de4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2365,7 +2365,7 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
 	int direct = 0;
 	u64 pdptr;
 
-	root_gfn = vcpu->arch.cr3 >> PAGE_SHIFT;
+	root_gfn = vcpu->arch.mmu.get_cr3(vcpu) >> PAGE_SHIFT;
 
 	if (vcpu->arch.mmu.shadow_root_level == PT64_ROOT_LEVEL) {
 		hpa_t root = vcpu->arch.mmu.root_hpa;
@@ -2562,6 +2562,11 @@ static void paging_new_cr3(struct kvm_vcpu *vcpu)
 	mmu_free_roots(vcpu);
 }
 
+static unsigned long get_cr3(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.cr3;
+}
+
 static void inject_page_fault(struct kvm_vcpu *vcpu,
 			      u64 addr,
 			      u32 err_code)
@@ -2715,6 +2720,7 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->root_hpa = INVALID_PAGE;
 	context->direct_map = true;
 	context->set_cr3 = kvm_x86_ops->set_tdp_cr3;
+	context->get_cr3 = get_cr3;
 
 	if (!is_paging(vcpu)) {
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
@@ -2755,6 +2761,7 @@ static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu.base_role.cr4_pae = !!is_pae(vcpu);
 	vcpu->arch.mmu.base_role.cr0_wp  = is_write_protection(vcpu);
 	vcpu->arch.mmu.set_cr3           = kvm_x86_ops->set_cr3;
+	vcpu->arch.mmu.get_cr3           = get_cr3;
 
 	return r;
 }
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index e4ad3dc..13d0c06 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -130,7 +130,7 @@ walk:
 	present = true;
 	eperm = rsvd_fault = false;
 	walker->level = vcpu->arch.mmu.root_level;
-	pte = vcpu->arch.cr3;
+	pte = vcpu->arch.mmu.get_cr3(vcpu);
 #if PTTYPE == 64
 	if (vcpu->arch.mmu.root_level == PT32E_ROOT_LEVEL) {
 		pte = kvm_pdptr_read(vcpu, (addr >> 30) & 3);
@@ -143,7 +143,7 @@ walk:
 	}
 #endif
 	ASSERT((!is_long_mode(vcpu) && is_pae(vcpu)) ||
-	       (vcpu->arch.cr3 & CR3_NONPAE_RESERVED_BITS) == 0);
+	       (vcpu->arch.mmu.get_cr3(vcpu) & CR3_NONPAE_RESERVED_BITS) == 0);
 
 	pt_access = ACC_ALL;
 
-- 
1.7.0.4



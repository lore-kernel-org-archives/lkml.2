Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab0INPqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 11:46:10 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:13630
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753095Ab0INPqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 11:46:00 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i2a8h87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8QUGC-02-AFR-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/2] KVM: MMU: Use base_role.nxe for mmu.nx
Date: Tue, 14 Sep 2010 17:46:13 +0200
Message-ID: <1284479173-4515-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284479173-4515-1-git-send-email-joerg.roedel@amd.com>
References: <1284479173-4515-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the mmu.nx field and uses the equivalent
field mmu.base_role.nxe instead.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    2 --
 arch/x86/kvm/mmu.c              |   27 +++++++++++++--------------
 arch/x86/kvm/paging_tmpl.h      |    4 ++--
 arch/x86/kvm/x86.c              |    3 ---
 4 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8a83177..50506be 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -259,8 +259,6 @@ struct kvm_mmu {
 	u64 *lm_root;
 	u64 rsvd_bits_mask[2][4];
 
-	bool nx;
-
 	u64 pdptrs[4]; /* pae */
 };
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3ce56bf..21d2983 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -238,7 +238,7 @@ static int is_cpuid_PSE36(void)
 
 static int is_nx(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.efer & EFER_NX;
+	return !!(vcpu->arch.efer & EFER_NX);
 }
 
 static int is_shadow_present_pte(u64 pte)
@@ -2634,7 +2634,7 @@ static int nonpaging_init_context(struct kvm_vcpu *vcpu,
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
 	context->root_hpa = INVALID_PAGE;
 	context->direct_map = true;
-	context->nx = false;
+	context->base_role.nxe = 0;
 	return 0;
 }
 
@@ -2688,7 +2688,7 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 	int maxphyaddr = cpuid_maxphyaddr(vcpu);
 	u64 exb_bit_rsvd = 0;
 
-	if (!context->nx)
+	if (!context->base_role.nxe)
 		exb_bit_rsvd = rsvd_bits(63, 63);
 	switch (level) {
 	case PT32_ROOT_LEVEL:
@@ -2747,7 +2747,7 @@ static int paging64_init_context_common(struct kvm_vcpu *vcpu,
 					struct kvm_mmu *context,
 					int level)
 {
-	context->nx = is_nx(vcpu);
+	context->base_role.nxe = is_nx(vcpu);
 
 	reset_rsvds_bits_mask(vcpu, context, level);
 
@@ -2775,7 +2775,7 @@ static int paging64_init_context(struct kvm_vcpu *vcpu,
 static int paging32_init_context(struct kvm_vcpu *vcpu,
 				 struct kvm_mmu *context)
 {
-	context->nx = false;
+	context->base_role.nxe = 0;
 
 	reset_rsvds_bits_mask(vcpu, context, PT32_ROOT_LEVEL);
 
@@ -2815,24 +2815,23 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->set_cr3 = kvm_x86_ops->set_tdp_cr3;
 	context->get_cr3 = get_cr3;
 	context->inject_page_fault = kvm_inject_page_fault;
-	context->nx = is_nx(vcpu);
 
 	if (!is_paging(vcpu)) {
-		context->nx = false;
+		context->base_role.nxe = 0;
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
 		context->root_level = 0;
 	} else if (is_long_mode(vcpu)) {
-		context->nx = is_nx(vcpu);
+		context->base_role.nxe = is_nx(vcpu);
 		reset_rsvds_bits_mask(vcpu, context, PT64_ROOT_LEVEL);
 		context->gva_to_gpa = paging64_gva_to_gpa;
 		context->root_level = PT64_ROOT_LEVEL;
 	} else if (is_pae(vcpu)) {
-		context->nx = is_nx(vcpu);
+		context->base_role.nxe = is_nx(vcpu);
 		reset_rsvds_bits_mask(vcpu, context, PT32E_ROOT_LEVEL);
 		context->gva_to_gpa = paging64_gva_to_gpa;
 		context->root_level = PT32E_ROOT_LEVEL;
 	} else {
-		context->nx = false;
+		context->base_role.nxe = 0;
 		reset_rsvds_bits_mask(vcpu, context, PT32_ROOT_LEVEL);
 		context->gva_to_gpa = paging32_gva_to_gpa;
 		context->root_level = PT32_ROOT_LEVEL;
@@ -2888,21 +2887,21 @@ static int init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 	 * functions between mmu and nested_mmu are swapped.
 	 */
 	if (!is_paging(vcpu)) {
-		g_context->nx = false;
+		g_context->base_role.nxe = 0;
 		g_context->root_level = 0;
 		g_context->gva_to_gpa = nonpaging_gva_to_gpa_nested;
 	} else if (is_long_mode(vcpu)) {
-		g_context->nx = is_nx(vcpu);
+		g_context->base_role.nxe = is_nx(vcpu);
 		reset_rsvds_bits_mask(vcpu, g_context, PT64_ROOT_LEVEL);
 		g_context->root_level = PT64_ROOT_LEVEL;
 		g_context->gva_to_gpa = paging64_gva_to_gpa_nested;
 	} else if (is_pae(vcpu)) {
-		g_context->nx = is_nx(vcpu);
+		g_context->base_role.nxe = is_nx(vcpu);
 		reset_rsvds_bits_mask(vcpu, g_context, PT32E_ROOT_LEVEL);
 		g_context->root_level = PT32E_ROOT_LEVEL;
 		g_context->gva_to_gpa = paging64_gva_to_gpa_nested;
 	} else {
-		g_context->nx = false;
+		g_context->base_role.nxe = false;
 		reset_rsvds_bits_mask(vcpu, g_context, PT32_ROOT_LEVEL);
 		g_context->root_level = PT32_ROOT_LEVEL;
 		g_context->gva_to_gpa = paging32_gva_to_gpa_nested;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 2bdd843..9e85736 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -105,7 +105,7 @@ static unsigned FNAME(gpte_access)(struct kvm_vcpu *vcpu, pt_element_t gpte)
 
 	access = (gpte & (PT_WRITABLE_MASK | PT_USER_MASK)) | ACC_EXEC_MASK;
 #if PTTYPE == 64
-	if (vcpu->arch.mmu.nx)
+	if (vcpu->arch.mmu.base_role.nxe)
 		access &= ~(gpte >> PT64_NX_SHIFT);
 #endif
 	return access;
@@ -272,7 +272,7 @@ error:
 		walker->error_code |= PFERR_WRITE_MASK;
 	if (user_fault)
 		walker->error_code |= PFERR_USER_MASK;
-	if (fetch_fault && mmu->nx)
+	if (fetch_fault && mmu->base_role.nxe)
 		walker->error_code |= PFERR_FETCH_MASK;
 	if (rsvd_fault)
 		walker->error_code |= PFERR_RSVD_MASK;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 335519f..5464f31 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -831,9 +831,6 @@ static int set_efer(struct kvm_vcpu *vcpu, u64 efer)
 
 	kvm_x86_ops->set_efer(vcpu, efer);
 
-	vcpu->arch.mmu.base_role.nxe = (efer & EFER_NX) && !tdp_enabled;
-	kvm_mmu_reset_context(vcpu);
-
 	/* Update reserved bits */
 	if ((efer ^ old_efer) & EFER_NX)
 		kvm_mmu_reset_context(vcpu);
-- 
1.7.0.4



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab0IJPc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:32:56 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:33667 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab0IJPcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:32:51 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8JF42-02-JQ8-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 24/29] KVM: MMU: Track NX state in struct kvm_mmu
Date: Fri, 10 Sep 2010 17:31:01 +0200
Message-ID: <1284132667-18620-25-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
References: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With Nested Paging emulation the NX state between the two
MMU contexts may differ. To make sure that always the right
fault error code is recorded this patch moves the NX state
into struct kvm_mmu so that the code can distinguish between
L1 and L2 NX state.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    2 ++
 arch/x86/kvm/mmu.c              |   16 +++++++++++++++-
 arch/x86/kvm/paging_tmpl.h      |    4 ++--
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8647578..fca8470 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -259,6 +259,8 @@ struct kvm_mmu {
 	u64 *lm_root;
 	u64 rsvd_bits_mask[2][4];
 
+	bool nx;
+
 	u64 pdptrs[4]; /* pae */
 };
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index dd76765..95cbeed 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2634,6 +2634,7 @@ static int nonpaging_init_context(struct kvm_vcpu *vcpu,
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
 	context->root_hpa = INVALID_PAGE;
 	context->direct_map = true;
+	context->nx = false;
 	return 0;
 }
 
@@ -2687,7 +2688,7 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 	int maxphyaddr = cpuid_maxphyaddr(vcpu);
 	u64 exb_bit_rsvd = 0;
 
-	if (!is_nx(vcpu))
+	if (!context->nx)
 		exb_bit_rsvd = rsvd_bits(63, 63);
 	switch (level) {
 	case PT32_ROOT_LEVEL:
@@ -2746,6 +2747,8 @@ static int paging64_init_context_common(struct kvm_vcpu *vcpu,
 					struct kvm_mmu *context,
 					int level)
 {
+	context->nx = is_nx(vcpu);
+
 	reset_rsvds_bits_mask(vcpu, context, level);
 
 	ASSERT(is_pae(vcpu));
@@ -2772,6 +2775,8 @@ static int paging64_init_context(struct kvm_vcpu *vcpu,
 static int paging32_init_context(struct kvm_vcpu *vcpu,
 				 struct kvm_mmu *context)
 {
+	context->nx = false;
+
 	reset_rsvds_bits_mask(vcpu, context, PT32_ROOT_LEVEL);
 
 	context->new_cr3 = paging_new_cr3;
@@ -2810,19 +2815,24 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->set_cr3 = kvm_x86_ops->set_tdp_cr3;
 	context->get_cr3 = get_cr3;
 	context->inject_page_fault = kvm_inject_page_fault;
+	context->nx = is_nx(vcpu);
 
 	if (!is_paging(vcpu)) {
+		context->nx = false;
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
 		context->root_level = 0;
 	} else if (is_long_mode(vcpu)) {
+		context->nx = is_nx(vcpu);
 		reset_rsvds_bits_mask(vcpu, context, PT64_ROOT_LEVEL);
 		context->gva_to_gpa = paging64_gva_to_gpa;
 		context->root_level = PT64_ROOT_LEVEL;
 	} else if (is_pae(vcpu)) {
+		context->nx = is_nx(vcpu);
 		reset_rsvds_bits_mask(vcpu, context, PT32E_ROOT_LEVEL);
 		context->gva_to_gpa = paging64_gva_to_gpa;
 		context->root_level = PT32E_ROOT_LEVEL;
 	} else {
+		context->nx = false;
 		reset_rsvds_bits_mask(vcpu, context, PT32_ROOT_LEVEL);
 		context->gva_to_gpa = paging32_gva_to_gpa;
 		context->root_level = PT32_ROOT_LEVEL;
@@ -2878,17 +2888,21 @@ static int init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 	 * functions between mmu and nested_mmu are swapped.
 	 */
 	if (!is_paging(vcpu)) {
+		g_context->nx = false;
 		g_context->root_level = 0;
 		g_context->gva_to_gpa = nonpaging_gva_to_gpa_nested;
 	} else if (is_long_mode(vcpu)) {
+		g_context->nx = is_nx(vcpu);
 		reset_rsvds_bits_mask(vcpu, g_context, PT64_ROOT_LEVEL);
 		g_context->root_level = PT64_ROOT_LEVEL;
 		g_context->gva_to_gpa = paging64_gva_to_gpa_nested;
 	} else if (is_pae(vcpu)) {
+		g_context->nx = is_nx(vcpu);
 		reset_rsvds_bits_mask(vcpu, g_context, PT32E_ROOT_LEVEL);
 		g_context->root_level = PT32E_ROOT_LEVEL;
 		g_context->gva_to_gpa = paging64_gva_to_gpa_nested;
 	} else {
+		g_context->nx = false;
 		reset_rsvds_bits_mask(vcpu, g_context, PT32_ROOT_LEVEL);
 		g_context->root_level = PT32_ROOT_LEVEL;
 		g_context->gva_to_gpa = paging32_gva_to_gpa_nested;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index a28f09b..2bdd843 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -105,7 +105,7 @@ static unsigned FNAME(gpte_access)(struct kvm_vcpu *vcpu, pt_element_t gpte)
 
 	access = (gpte & (PT_WRITABLE_MASK | PT_USER_MASK)) | ACC_EXEC_MASK;
 #if PTTYPE == 64
-	if (is_nx(vcpu))
+	if (vcpu->arch.mmu.nx)
 		access &= ~(gpte >> PT64_NX_SHIFT);
 #endif
 	return access;
@@ -272,7 +272,7 @@ error:
 		walker->error_code |= PFERR_WRITE_MASK;
 	if (user_fault)
 		walker->error_code |= PFERR_USER_MASK;
-	if (fetch_fault && is_nx(vcpu))
+	if (fetch_fault && mmu->nx)
 		walker->error_code |= PFERR_FETCH_MASK;
 	if (rsvd_fault)
 		walker->error_code |= PFERR_RSVD_MASK;
-- 
1.7.0.4



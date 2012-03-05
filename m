Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab2CEPxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:53:12 -0500
Received: from mailbigip.dreamhost.com ([208.97.132.5]:39667 "EHLO
	homiemail-a5.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750977Ab2CEPxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:53:10 -0500
Subject: [PATCH] kvm: mmu: make use of ->root_level in reset_rsvds_bits_mask
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Mon, 05 Mar 2012 16:53:06 +0100
Message-ID: <1330962786.2953.1.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

The reset_rsvds_bits_mask() function can use the guest walker's root level number
instead of using a separate 'level' variable.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 arch/x86/kvm/mmu.c |   31 +++++++++++++++----------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ff053ca..4cb1642 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3185,15 +3185,14 @@ static bool sync_mmio_spte(u64 *sptep, gfn_t gfn, unsigned access,
 #undef PTTYPE
 
 static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
-				  struct kvm_mmu *context,
-				  int level)
+				  struct kvm_mmu *context)
 {
 	int maxphyaddr = cpuid_maxphyaddr(vcpu);
 	u64 exb_bit_rsvd = 0;
 
 	if (!context->nx)
 		exb_bit_rsvd = rsvd_bits(63, 63);
-	switch (level) {
+	switch (context->root_level) {
 	case PT32_ROOT_LEVEL:
 		/* no rsvd bits for 2 level 4K page table entries */
 		context->rsvd_bits_mask[0][1] = 0;
@@ -3251,8 +3250,9 @@ static int paging64_init_context_common(struct kvm_vcpu *vcpu,
 					int level)
 {
 	context->nx = is_nx(vcpu);
+	context->root_level = level;
 
-	reset_rsvds_bits_mask(vcpu, context, level);
+	reset_rsvds_bits_mask(vcpu, context);
 
 	ASSERT(is_pae(vcpu));
 	context->new_cr3 = paging_new_cr3;
@@ -3262,7 +3262,6 @@ static int paging64_init_context_common(struct kvm_vcpu *vcpu,
 	context->invlpg = paging64_invlpg;
 	context->update_pte = paging64_update_pte;
 	context->free = paging_free;
-	context->root_level = level;
 	context->shadow_root_level = level;
 	context->root_hpa = INVALID_PAGE;
 	context->direct_map = false;
@@ -3279,8 +3278,9 @@ static int paging32_init_context(struct kvm_vcpu *vcpu,
 				 struct kvm_mmu *context)
 {
 	context->nx = false;
+	context->root_level = PT32_ROOT_LEVEL;
 
-	reset_rsvds_bits_mask(vcpu, context, PT32_ROOT_LEVEL);
+	reset_rsvds_bits_mask(vcpu, context);
 
 	context->new_cr3 = paging_new_cr3;
 	context->page_fault = paging32_page_fault;
@@ -3289,7 +3289,6 @@ static int paging32_init_context(struct kvm_vcpu *vcpu,
 	context->sync_page = paging32_sync_page;
 	context->invlpg = paging32_invlpg;
 	context->update_pte = paging32_update_pte;
-	context->root_level = PT32_ROOT_LEVEL;
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
 	context->root_hpa = INVALID_PAGE;
 	context->direct_map = false;
@@ -3327,19 +3326,19 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 		context->root_level = 0;
 	} else if (is_long_mode(vcpu)) {
 		context->nx = is_nx(vcpu);
-		reset_rsvds_bits_mask(vcpu, context, PT64_ROOT_LEVEL);
-		context->gva_to_gpa = paging64_gva_to_gpa;
 		context->root_level = PT64_ROOT_LEVEL;
+		reset_rsvds_bits_mask(vcpu, context);
+		context->gva_to_gpa = paging64_gva_to_gpa;
 	} else if (is_pae(vcpu)) {
 		context->nx = is_nx(vcpu);
-		reset_rsvds_bits_mask(vcpu, context, PT32E_ROOT_LEVEL);
-		context->gva_to_gpa = paging64_gva_to_gpa;
 		context->root_level = PT32E_ROOT_LEVEL;
+		reset_rsvds_bits_mask(vcpu, context);
+		context->gva_to_gpa = paging64_gva_to_gpa;
 	} else {
 		context->nx = false;
-		reset_rsvds_bits_mask(vcpu, context, PT32_ROOT_LEVEL);
-		context->gva_to_gpa = paging32_gva_to_gpa;
 		context->root_level = PT32_ROOT_LEVEL;
+		reset_rsvds_bits_mask(vcpu, context);
+		context->gva_to_gpa = paging32_gva_to_gpa;
 	}
 
 	return 0;
@@ -3402,18 +3401,18 @@ static int init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 		g_context->gva_to_gpa = nonpaging_gva_to_gpa_nested;
 	} else if (is_long_mode(vcpu)) {
 		g_context->nx = is_nx(vcpu);
-		reset_rsvds_bits_mask(vcpu, g_context, PT64_ROOT_LEVEL);
 		g_context->root_level = PT64_ROOT_LEVEL;
+		reset_rsvds_bits_mask(vcpu, g_context);
 		g_context->gva_to_gpa = paging64_gva_to_gpa_nested;
 	} else if (is_pae(vcpu)) {
 		g_context->nx = is_nx(vcpu);
-		reset_rsvds_bits_mask(vcpu, g_context, PT32E_ROOT_LEVEL);
 		g_context->root_level = PT32E_ROOT_LEVEL;
+		reset_rsvds_bits_mask(vcpu, g_context);
 		g_context->gva_to_gpa = paging64_gva_to_gpa_nested;
 	} else {
 		g_context->nx = false;
-		reset_rsvds_bits_mask(vcpu, g_context, PT32_ROOT_LEVEL);
 		g_context->root_level = PT32_ROOT_LEVEL;
+		reset_rsvds_bits_mask(vcpu, g_context);
 		g_context->gva_to_gpa = paging32_gva_to_gpa_nested;
 	}
 
-- 
1.7.4.1




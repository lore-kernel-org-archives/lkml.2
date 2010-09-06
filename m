Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105Ab0IFP6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:58:13 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:48074
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754386Ab0IFP53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:57:29 -0400
X-SpamScore: 9
X-BigFish: VS9(zz78fbpzz1202hzz8275bhz32i87h2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8C1L8-01-D1E-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, <joro@8bytes.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/27] KVM: MMU: Introduce kvm_init_shadow_mmu helper function
Date: Mon, 6 Sep 2010 17:55:46 +0200
Message-ID: <1283788566-29186-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
References: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some logic of the init_kvm_softmmu function is required to
build the Nested Nested Paging context. So factor the
required logic into a seperate function and export it.
Also make the whole init path suitable for more than one mmu
context.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c |   60 ++++++++++++++++++++++++++++++---------------------
 arch/x86/kvm/mmu.h |    1 +
 2 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5b55451..787540d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2532,10 +2532,9 @@ static void nonpaging_free(struct kvm_vcpu *vcpu)
 	mmu_free_roots(vcpu);
 }
 
-static int nonpaging_init_context(struct kvm_vcpu *vcpu)
+static int nonpaging_init_context(struct kvm_vcpu *vcpu,
+				  struct kvm_mmu *context)
 {
-	struct kvm_mmu *context = &vcpu->arch.mmu;
-
 	context->new_cr3 = nonpaging_new_cr3;
 	context->page_fault = nonpaging_page_fault;
 	context->gva_to_gpa = nonpaging_gva_to_gpa;
@@ -2594,9 +2593,10 @@ static bool is_rsvd_bits_set(struct kvm_vcpu *vcpu, u64 gpte, int level)
 #include "paging_tmpl.h"
 #undef PTTYPE
 
-static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu, int level)
+static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
+				  struct kvm_mmu *context,
+				  int level)
 {
-	struct kvm_mmu *context = &vcpu->arch.mmu;
 	int maxphyaddr = cpuid_maxphyaddr(vcpu);
 	u64 exb_bit_rsvd = 0;
 
@@ -2655,9 +2655,11 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu, int level)
 	}
 }
 
-static int paging64_init_context_common(struct kvm_vcpu *vcpu, int level)
+static int paging64_init_context_common(struct kvm_vcpu *vcpu,
+					struct kvm_mmu *context,
+					int level)
 {
-	struct kvm_mmu *context = &vcpu->arch.mmu;
+	reset_rsvds_bits_mask(vcpu, context, level);
 
 	ASSERT(is_pae(vcpu));
 	context->new_cr3 = paging_new_cr3;
@@ -2673,17 +2675,17 @@ static int paging64_init_context_common(struct kvm_vcpu *vcpu, int level)
 	return 0;
 }
 
-static int paging64_init_context(struct kvm_vcpu *vcpu)
+static int paging64_init_context(struct kvm_vcpu *vcpu,
+				 struct kvm_mmu *context)
 {
-	reset_rsvds_bits_mask(vcpu, PT64_ROOT_LEVEL);
-	return paging64_init_context_common(vcpu, PT64_ROOT_LEVEL);
+	return paging64_init_context_common(vcpu, context, PT64_ROOT_LEVEL);
 }
 
-static int paging32_init_context(struct kvm_vcpu *vcpu)
+static int paging32_init_context(struct kvm_vcpu *vcpu,
+				 struct kvm_mmu *context)
 {
-	struct kvm_mmu *context = &vcpu->arch.mmu;
+	reset_rsvds_bits_mask(vcpu, context, PT32_ROOT_LEVEL);
 
-	reset_rsvds_bits_mask(vcpu, PT32_ROOT_LEVEL);
 	context->new_cr3 = paging_new_cr3;
 	context->page_fault = paging32_page_fault;
 	context->gva_to_gpa = paging32_gva_to_gpa;
@@ -2697,10 +2699,10 @@ static int paging32_init_context(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static int paging32E_init_context(struct kvm_vcpu *vcpu)
+static int paging32E_init_context(struct kvm_vcpu *vcpu,
+				  struct kvm_mmu *context)
 {
-	reset_rsvds_bits_mask(vcpu, PT32E_ROOT_LEVEL);
-	return paging64_init_context_common(vcpu, PT32E_ROOT_LEVEL);
+	return paging64_init_context_common(vcpu, context, PT32E_ROOT_LEVEL);
 }
 
 static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
@@ -2724,15 +2726,15 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
 		context->root_level = 0;
 	} else if (is_long_mode(vcpu)) {
-		reset_rsvds_bits_mask(vcpu, PT64_ROOT_LEVEL);
+		reset_rsvds_bits_mask(vcpu, context, PT64_ROOT_LEVEL);
 		context->gva_to_gpa = paging64_gva_to_gpa;
 		context->root_level = PT64_ROOT_LEVEL;
 	} else if (is_pae(vcpu)) {
-		reset_rsvds_bits_mask(vcpu, PT32E_ROOT_LEVEL);
+		reset_rsvds_bits_mask(vcpu, context, PT32E_ROOT_LEVEL);
 		context->gva_to_gpa = paging64_gva_to_gpa;
 		context->root_level = PT32E_ROOT_LEVEL;
 	} else {
-		reset_rsvds_bits_mask(vcpu, PT32_ROOT_LEVEL);
+		reset_rsvds_bits_mask(vcpu, context, PT32_ROOT_LEVEL);
 		context->gva_to_gpa = paging32_gva_to_gpa;
 		context->root_level = PT32_ROOT_LEVEL;
 	}
@@ -2740,25 +2742,33 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
+int kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
 {
 	int r;
-
 	ASSERT(vcpu);
 	ASSERT(!VALID_PAGE(vcpu->arch.mmu.root_hpa));
 
 	if (!is_paging(vcpu))
-		r = nonpaging_init_context(vcpu);
+		r = nonpaging_init_context(vcpu, context);
 	else if (is_long_mode(vcpu))
-		r = paging64_init_context(vcpu);
+		r = paging64_init_context(vcpu, context);
 	else if (is_pae(vcpu))
-		r = paging32E_init_context(vcpu);
+		r = paging32E_init_context(vcpu, context);
 	else
-		r = paging32_init_context(vcpu);
+		r = paging32_init_context(vcpu, context);
 
 	vcpu->arch.mmu.base_role.cr4_pae = !!is_pae(vcpu);
 	vcpu->arch.mmu.base_role.cr0_wp = is_write_protection(vcpu);
 	vcpu->arch.mmu.direct_map        = false;
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(kvm_init_shadow_mmu);
+
+static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
+{
+	int r = kvm_init_shadow_mmu(vcpu, &vcpu->arch.mmu);
+
 	vcpu->arch.mmu.set_cr3           = kvm_x86_ops->set_cr3;
 	vcpu->arch.mmu.get_cr3           = get_cr3;
 	vcpu->arch.mmu.inject_page_fault = kvm_inject_page_fault;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index f05a03d..7086ca8 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -49,6 +49,7 @@
 #define PFERR_FETCH_MASK (1U << 4)
 
 int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4]);
+int kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
 
 static inline unsigned int kvm_mmu_available_pages(struct kvm *kvm)
 {
-- 
1.7.0.4



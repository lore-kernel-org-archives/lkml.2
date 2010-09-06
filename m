Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab0IFP6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:58:48 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:18477
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754788Ab0IFP5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:57:42 -0400
X-SpamScore: 9
X-BigFish: VS9(zz78fbpzz1202hzz8275bhz32i2a8h87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8C1L6-02-79V-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, <joro@8bytes.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/27] KVM: MMU: Make tdp_enabled a mmu-context parameter
Date: Mon, 6 Sep 2010 17:55:41 +0200
Message-ID: <1283788566-29186-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
References: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the tdp_enabled flag from its global
meaning to the mmu-context and renames it to direct_map
there. This is necessary for Nested SVM with emulation of
Nested Paging where we need an extra MMU context to shadow
the Nested Nested Page Table.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |   20 ++++++++++++--------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9b30285..53cdf39 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -249,6 +249,7 @@ struct kvm_mmu {
 	int root_level;
 	int shadow_root_level;
 	union kvm_mmu_page_role base_role;
+	bool direct_map;
 
 	u64 *pae_root;
 	u64 rsvd_bits_mask[2][4];
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b2136f9..bfb3f23 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1448,7 +1448,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	if (role.direct)
 		role.cr4_pae = 0;
 	role.access = access;
-	if (!tdp_enabled && vcpu->arch.mmu.root_level <= PT32_ROOT_LEVEL) {
+	if (!vcpu->arch.mmu.direct_map
+	    && vcpu->arch.mmu.root_level <= PT32_ROOT_LEVEL) {
 		quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
 		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
 		role.quadrant = quadrant;
@@ -1973,7 +1974,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		spte |= shadow_user_mask;
 	if (level > PT_PAGE_TABLE_LEVEL)
 		spte |= PT_PAGE_SIZE_MASK;
-	if (tdp_enabled)
+	if (vcpu->arch.mmu.direct_map)
 		spte |= kvm_x86_ops->get_mt_mask(vcpu, gfn,
 			kvm_is_mmio_pfn(pfn));
 
@@ -1983,8 +1984,8 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	spte |= (u64)pfn << PAGE_SHIFT;
 
 	if ((pte_access & ACC_WRITE_MASK)
-	    || (!tdp_enabled && write_fault && !is_write_protection(vcpu)
-		&& !user_fault)) {
+	    || (!vcpu->arch.mmu.direct_map && write_fault
+		&& !is_write_protection(vcpu) && !user_fault)) {
 
 		if (level > PT_PAGE_TABLE_LEVEL &&
 		    has_wrprotected_page(vcpu->kvm, gfn, level)) {
@@ -1995,7 +1996,8 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 
 		spte |= PT_WRITABLE_MASK;
 
-		if (!tdp_enabled && !(pte_access & ACC_WRITE_MASK))
+		if (!vcpu->arch.mmu.direct_map
+		    && !(pte_access & ACC_WRITE_MASK))
 			spte &= ~PT_USER_MASK;
 
 		/*
@@ -2371,7 +2373,7 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
 		ASSERT(!VALID_PAGE(root));
 		if (mmu_check_root(vcpu, root_gfn))
 			return 1;
-		if (tdp_enabled) {
+		if (vcpu->arch.mmu.direct_map) {
 			direct = 1;
 			root_gfn = 0;
 		}
@@ -2406,7 +2408,7 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
 				return 1;
 		} else if (vcpu->arch.mmu.root_level == 0)
 			root_gfn = 0;
-		if (tdp_enabled) {
+		if (vcpu->arch.mmu.direct_map) {
 			direct = 1;
 			root_gfn = i << 30;
 		}
@@ -2708,6 +2710,7 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->invlpg = nonpaging_invlpg;
 	context->shadow_root_level = kvm_x86_ops->get_tdp_level();
 	context->root_hpa = INVALID_PAGE;
+	context->direct_map = true;
 
 	if (!is_paging(vcpu)) {
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
@@ -2747,6 +2750,7 @@ static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.mmu.base_role.cr4_pae = !!is_pae(vcpu);
 	vcpu->arch.mmu.base_role.cr0_wp = is_write_protection(vcpu);
+	vcpu->arch.mmu.direct_map        = false;
 
 	return r;
 }
@@ -3060,7 +3064,7 @@ int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 	gpa_t gpa;
 	int r;
 
-	if (tdp_enabled)
+	if (vcpu->arch.mmu.direct_map)
 		return 0;
 
 	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
-- 
1.7.0.4



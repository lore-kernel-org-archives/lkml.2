Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab0D0Kkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:40:35 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:53050
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754744Ab0D0KjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:39:18 -0400
X-SpamScore: 9
X-BigFish: VPS9(zzab9bh78fbpzz1202hzz6ff19hz32i2a8h87h43h65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1J6WJ-01-32O-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/22] KVM: MMU: Make tdp_enabled a mmu-context parameter
Date: Tue, 27 Apr 2010 12:38:12 +0200
Message-ID: <1272364712-17425-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Apr 2010 10:38:35.0558 (UTC) FILETIME=[CA332C60:01CAE5F5]
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
 arch/x86/kvm/mmu.c              |    8 +++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3f0007b..44eda9b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -246,6 +246,7 @@ struct kvm_mmu {
 	int root_level;
 	int shadow_root_level;
 	union kvm_mmu_page_role base_role;
+	bool direct_map;
 
 	u64 *pae_root;
 	u64 rsvd_bits_mask[2][4];
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ddfa865..618d25f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1794,7 +1794,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		spte |= shadow_user_mask;
 	if (level > PT_PAGE_TABLE_LEVEL)
 		spte |= PT_PAGE_SIZE_MASK;
-	if (tdp_enabled)
+	if (vcpu->arch.mmu.direct_map)
 		spte |= kvm_x86_ops->get_mt_mask(vcpu, gfn,
 			kvm_is_mmio_pfn(pfn));
 
@@ -2059,7 +2059,7 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
 		hpa_t root = vcpu->arch.mmu.root_hpa;
 
 		ASSERT(!VALID_PAGE(root));
-		if (tdp_enabled)
+		if (vcpu->arch.mmu.direct_map)
 			direct = 1;
 		if (mmu_check_root(vcpu, root_gfn))
 			return 1;
@@ -2072,7 +2072,7 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 	direct = !is_paging(vcpu);
-	if (tdp_enabled)
+	if (vcpu->arch.mmu.direct_map)
 		direct = 1;
 	for (i = 0; i < 4; ++i) {
 		hpa_t root = vcpu->arch.mmu.pae_root[i];
@@ -2385,6 +2385,7 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->invlpg = nonpaging_invlpg;
 	context->shadow_root_level = kvm_x86_ops->get_tdp_level();
 	context->root_hpa = INVALID_PAGE;
+	vcpu->arch.mmu.direct_map = true;
 
 	if (!is_paging(vcpu)) {
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
@@ -2423,6 +2424,7 @@ static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
 		r = paging32_init_context(vcpu);
 
 	vcpu->arch.mmu.base_role.cr4_pae = !!is_pae(vcpu);
+	vcpu->arch.mmu.direct_map        = false;
 
 	return r;
 }
-- 
1.7.0.4



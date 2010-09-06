Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab0IFPEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:04:22 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:20610 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab0IFPDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:03:01 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8BZ2Q-02-4X5-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <"http://kvm.qumranet.com"@osrc.amd.com>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 23/27] KVM: MMU: Allow long mode shadows for legacy page tables
Date: Mon, 6 Sep 2010 17:01:58 +0200
Message-ID: <1283785322-26898-24-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
References: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the KVM softmmu implementation can not shadow a 32
bit legacy or PAE page table with a long mode page table.
This is a required feature for nested paging emulation
because the nested page table must alway be in host format.
So this patch implements the missing pieces to allow long
mode page tables for page table types.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |   60 +++++++++++++++++++++++++++++++++-----
 2 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1080c0f..475fc70 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -258,6 +258,7 @@ struct kvm_mmu {
 	bool direct_map;
 
 	u64 *pae_root;
+	u64 *lm_root;
 	u64 rsvd_bits_mask[2][4];
 
 	u64 pdptrs[4]; /* pae */
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e7e5527..ea8ed8b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1504,6 +1504,12 @@ static void shadow_walk_init(struct kvm_shadow_walk_iterator *iterator,
 	iterator->addr = addr;
 	iterator->shadow_addr = vcpu->arch.mmu.root_hpa;
 	iterator->level = vcpu->arch.mmu.shadow_root_level;
+
+	if (iterator->level == PT64_ROOT_LEVEL &&
+	    vcpu->arch.mmu.root_level < PT64_ROOT_LEVEL &&
+	    !vcpu->arch.mmu.direct_map)
+		--iterator->level;
+
 	if (iterator->level == PT32E_ROOT_LEVEL) {
 		iterator->shadow_addr
 			= vcpu->arch.mmu.pae_root[(addr >> 30) & 3];
@@ -2314,7 +2320,9 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
 		return;
 	spin_lock(&vcpu->kvm->mmu_lock);
-	if (vcpu->arch.mmu.shadow_root_level == PT64_ROOT_LEVEL) {
+	if (vcpu->arch.mmu.shadow_root_level == PT64_ROOT_LEVEL &&
+	    (vcpu->arch.mmu.root_level == PT64_ROOT_LEVEL ||
+	     vcpu->arch.mmu.direct_map)) {
 		hpa_t root = vcpu->arch.mmu.root_hpa;
 
 		sp = page_header(root);
@@ -2394,10 +2402,10 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 
 static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 {
-	int i;
-	gfn_t root_gfn;
 	struct kvm_mmu_page *sp;
-	u64 pdptr;
+	u64 pdptr, pm_mask;
+	gfn_t root_gfn;
+	int i;
 
 	root_gfn = vcpu->arch.mmu.get_cr3(vcpu) >> PAGE_SHIFT;
 
@@ -2426,8 +2434,13 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 
 	/*
 	 * We shadow a 32 bit page table. This may be a legacy 2-level
-	 * or a PAE 3-level page table.
+	 * or a PAE 3-level page table. In either case we need to be aware that
+	 * the shadow page table may be a PAE or a long mode page table.
 	 */
+	pm_mask = PT_PRESENT_MASK;
+	if (vcpu->arch.mmu.shadow_root_level == PT64_ROOT_LEVEL)
+		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
+
 	for (i = 0; i < 4; ++i) {
 		hpa_t root = vcpu->arch.mmu.pae_root[i];
 
@@ -2451,9 +2464,35 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		++sp->root_count;
 		spin_unlock(&vcpu->kvm->mmu_lock);
 
-		vcpu->arch.mmu.pae_root[i] = root | PT_PRESENT_MASK;
+		vcpu->arch.mmu.pae_root[i] = root | pm_mask;
+		vcpu->arch.mmu.root_hpa = __pa(vcpu->arch.mmu.pae_root);
 	}
-	vcpu->arch.mmu.root_hpa = __pa(vcpu->arch.mmu.pae_root);
+
+	/*
+	 * If we shadow a 32 bit page table with a long mode page
+	 * table we enter this path.
+	 */
+	if (vcpu->arch.mmu.shadow_root_level == PT64_ROOT_LEVEL) {
+		if (vcpu->arch.mmu.lm_root == NULL) {
+			/*
+			 * The additional page necessary for this is only
+			 * allocated on demand.
+			 */
+
+			u64 *lm_root;
+
+			lm_root = (void*)get_zeroed_page(GFP_KERNEL);
+			if (lm_root == NULL)
+				return 1;
+
+			lm_root[0] = __pa(vcpu->arch.mmu.pae_root) | pm_mask;
+
+			vcpu->arch.mmu.lm_root = lm_root;
+		}
+
+		vcpu->arch.mmu.root_hpa = __pa(vcpu->arch.mmu.lm_root);
+	}
+
 	return 0;
 }
 
@@ -2470,9 +2509,12 @@ static void mmu_sync_roots(struct kvm_vcpu *vcpu)
 	int i;
 	struct kvm_mmu_page *sp;
 
+	if (vcpu->arch.mmu.direct_map)
+		return;
+
 	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
 		return;
-	if (vcpu->arch.mmu.shadow_root_level == PT64_ROOT_LEVEL) {
+	if (vcpu->arch.mmu.root_level == PT64_ROOT_LEVEL) {
 		hpa_t root = vcpu->arch.mmu.root_hpa;
 		sp = page_header(root);
 		mmu_sync_children(vcpu, sp);
@@ -3250,6 +3292,8 @@ EXPORT_SYMBOL_GPL(kvm_disable_tdp);
 static void free_mmu_pages(struct kvm_vcpu *vcpu)
 {
 	free_page((unsigned long)vcpu->arch.mmu.pae_root);
+	if (vcpu->arch.mmu.lm_root != NULL)
+		free_page((unsigned long)vcpu->arch.mmu.lm_root);
 }
 
 static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
-- 
1.7.0.4



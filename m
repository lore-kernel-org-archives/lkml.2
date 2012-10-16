Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab2JPMJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 08:09:44 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:42795 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab2JPMJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 08:09:42 -0400
Message-ID: <507D4E80.8000203@linux.vnet.ibm.com>
Date: Tue, 16 Oct 2012 20:09:36 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v5 4/6] KVM: MMU: move prefetch_invalid_gpte out of pagaing_tmp.h
References: <507D4DE7.5080708@linux.vnet.ibm.com>
In-Reply-To: <507D4DE7.5080708@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12101612-1396-0000-0000-00000200D7F1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function does not depend on guest mmu mode, move it out from
paging_tmpl.h

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c         |   36 ++++++++++++++++++++++++++++--------
 arch/x86/kvm/paging_tmpl.h |   26 +++-----------------------
 2 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b8d13d7..56c0e39 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2505,6 +2505,14 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 	mmu_free_roots(vcpu);
 }

+static bool is_rsvd_bits_set(struct kvm_mmu *mmu, u64 gpte, int level)
+{
+	int bit7;
+
+	bit7 = (gpte >> 7) & 1;
+	return (gpte & mmu->rsvd_bits_mask[bit7][level-1]) != 0;
+}
+
 static pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
 				     bool no_dirty_log)
 {
@@ -2517,6 +2525,26 @@ static pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return gfn_to_pfn_memslot_atomic(slot, gfn);
 }

+static bool prefetch_invalid_gpte(struct kvm_vcpu *vcpu,
+				  struct kvm_mmu_page *sp, u64 *spte,
+				  u64 gpte)
+{
+	if (is_rsvd_bits_set(&vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL))
+		goto no_present;
+
+	if (!is_present_gpte(gpte))
+		goto no_present;
+
+	if (!(gpte & PT_ACCESSED_MASK))
+		goto no_present;
+
+	return false;
+
+no_present:
+	drop_spte(vcpu->kvm, spte);
+	return true;
+}
+
 static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 				    struct kvm_mmu_page *sp,
 				    u64 *start, u64 *end)
@@ -3394,14 +3422,6 @@ static void paging_free(struct kvm_vcpu *vcpu)
 	nonpaging_free(vcpu);
 }

-static bool is_rsvd_bits_set(struct kvm_mmu *mmu, u64 gpte, int level)
-{
-	int bit7;
-
-	bit7 = (gpte >> 7) & 1;
-	return (gpte & mmu->rsvd_bits_mask[bit7][level-1]) != 0;
-}
-
 static inline void protect_clean_gpte(unsigned *access, unsigned gpte)
 {
 	unsigned mask;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index c555532..36a80ed 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -305,26 +305,6 @@ static int FNAME(walk_addr_nested)(struct guest_walker *walker,
 					addr, access);
 }

-static bool FNAME(prefetch_invalid_gpte)(struct kvm_vcpu *vcpu,
-				    struct kvm_mmu_page *sp, u64 *spte,
-				    pt_element_t gpte)
-{
-	if (is_rsvd_bits_set(&vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL))
-		goto no_present;
-
-	if (!is_present_gpte(gpte))
-		goto no_present;
-
-	if (!(gpte & PT_ACCESSED_MASK))
-		goto no_present;
-
-	return false;
-
-no_present:
-	drop_spte(vcpu->kvm, spte);
-	return true;
-}
-
 static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			      u64 *spte, const void *pte)
 {
@@ -333,7 +313,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	pfn_t pfn;

 	gpte = *(const pt_element_t *)pte;
-	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
+	if (prefetch_invalid_gpte(vcpu, sp, spte, gpte))
 		return;

 	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
@@ -408,7 +388,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,

 		gpte = gptep[i];

-		if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
+		if (prefetch_invalid_gpte(vcpu, sp, spte, gpte))
 			continue;

 		pte_access = sp->role.access & gpte_access(vcpu, gpte);
@@ -751,7 +731,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 					  sizeof(pt_element_t)))
 			return -EINVAL;

-		if (FNAME(prefetch_invalid_gpte)(vcpu, sp, &sp->spt[i], gpte)) {
+		if (prefetch_invalid_gpte(vcpu, sp, &sp->spt[i], gpte)) {
 			vcpu->kvm->tlbs_dirty++;
 			continue;
 		}
-- 
1.7.7.6


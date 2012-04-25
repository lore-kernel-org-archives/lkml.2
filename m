Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab2DYEEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 00:04:42 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:46279 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2DYEEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 00:04:40 -0400
Message-ID: <4F9777C2.4090106@linux.vnet.ibm.com>
Date: Wed, 25 Apr 2012 12:04:18 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v4 07/10] KVM: MMU: lockless update spte on fast page fault
 path
References: <4F9776D2.7020506@linux.vnet.ibm.com>
In-Reply-To: <4F9776D2.7020506@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12042417-1618-0000-0000-000001651B69
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the information we need on the fast page fault path is
SPTE_HOST_WRITEABLE bit, SPTE_MMU_WRITEABLE bit and SPTE_WRITE_PROTECT bit
on spte, actually, all these bits can be protected by cmpxchg

But, we need carefully handle the paths which depend on spte.W bit, it will
be documented in locking.txt in the next patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |  104 +++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 79 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 96a9d5b..15f01a3 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -446,6 +446,15 @@ static bool __check_direct_spte_mmio_pf(u64 spte)
 }
 #endif

+static bool spte_wp_by_dirty_log(u64 spte)
+{
+	u64 mask = SPTE_HOST_WRITEABLE | SPTE_MMU_WRITEABLE;
+
+	WARN_ON(is_writable_pte(spte));
+
+	return ((spte & mask) == mask) && !(spte & SPTE_WRITE_PROTECT);
+}
+
 static bool spte_has_volatile_bits(u64 spte)
 {
 	if (!shadow_accessed_mask)
@@ -454,9 +463,18 @@ static bool spte_has_volatile_bits(u64 spte)
 	if (!is_shadow_present_pte(spte))
 		return false;

-	if ((spte & shadow_accessed_mask) &&
-	      (!is_writable_pte(spte) || (spte & shadow_dirty_mask)))
-		return false;
+	if (spte & shadow_accessed_mask) {
+		if (is_writable_pte(spte))
+			return !(spte & shadow_dirty_mask);
+
+		/*
+		 * If the spte is write-protected by dirty-log, it may
+		 * be marked writable on fast page fault path, then CPU
+		 * can modify the Dirty bit.
+		 */
+		if (!spte_wp_by_dirty_log(spte))
+			return false;
+	}

 	return true;
 }
@@ -1043,15 +1061,6 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 		rmap_remove(kvm, sptep);
 }

-static bool spte_wp_by_dirty_log(u64 spte)
-{
-	u64 mask = SPTE_HOST_WRITEABLE | SPTE_MMU_WRITEABLE;
-
-	WARN_ON(is_writable_pte(spte));
-
-	return ((spte & mask) == mask) && !(spte & SPTE_WRITE_PROTECT);
-}
-
 /* Return true if the spte is dropped. */
 static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool large,
 			       bool *flush, bool page_table_protect)
@@ -1059,13 +1068,12 @@ static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool large,
 	u64 spte = *sptep;

 	if (is_writable_pte(spte)) {
-		*flush |= true;
-
 		if (large) {
 			pgprintk("rmap_write_protect(large): spte %p %llx\n",
 				 spte, *spte);
 			BUG_ON(!is_large_pte(spte));

+			*flush |= true;
 			drop_spte(kvm, sptep);
 			--kvm->stat.lpages;
 			return true;
@@ -1074,6 +1082,10 @@ static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool large,
 		goto reset_spte;
 	}

+	/*
+	 * We need flush tlbs in this case: the fast page fault path
+	 * can mark the spte writable after we read the sptep.
+	 */
 	if (page_table_protect && spte_wp_by_dirty_log(spte))
 		goto reset_spte;

@@ -1081,6 +1093,8 @@ static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool large,

 reset_spte:
 	rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
+
+	*flush |= true;
 	spte = spte & ~PT_WRITABLE_MASK;
 	if (page_table_protect)
 		spte |= SPTE_WRITE_PROTECT;
@@ -2699,24 +2713,60 @@ static bool page_fault_can_be_fast(struct kvm_vcpu *vcpu, gfn_t gfn,
 }

 static bool
-fast_pf_fix_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-		  u64 *sptep, u64 spte)
+fast_pf_fix_indirect_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+			  u64 *sptep, u64 spte, gfn_t gfn)
 {
-	gfn_t gfn;
+	pfn_t pfn;
+	bool ret = false;

-	spin_lock(&vcpu->kvm->mmu_lock);
+	/*
+	 * For the indirect spte, it is hard to get a stable gfn since
+	 * we just use a cmpxchg to avoid all the races which is not
+	 * enough to avoid the ABA problem: the host can arbitrarily
+	 * change spte and the mapping from gfn to pfn.
+	 *
+	 * What we do is call gfn_to_pfn_atomic to bind the gfn and the
+	 * pfn because after the call:
+	 * - we have held the refcount of pfn that means the pfn can not
+	 *   be freed and be reused for another gfn.
+	 * - the pfn is writable that means it can not be shared by different
+	 *   gfn.
+	 */
+	pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);

-	/* The spte has been changed. */
-	if (*sptep != spte)
+	/* The host page is swapped out or merged. */
+	if (mmu_invalid_pfn(pfn))
 		goto exit;

-	gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
+	ret = true;
+
+	if (pfn != spte_to_pfn(spte))
+		goto exit;

-	*sptep = spte | PT_WRITABLE_MASK;
-	mark_page_dirty(vcpu->kvm, gfn);
+	if (cmpxchg64(sptep, spte, spte | PT_WRITABLE_MASK) == spte)
+		mark_page_dirty(vcpu->kvm, gfn);

 exit:
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	kvm_release_pfn_clean(pfn);
+	return ret;
+}
+
+static bool
+fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+			u64 *sptep, u64 spte)
+{
+	gfn_t gfn;
+
+	WARN_ON(!sp->role.direct);
+
+	/*
+	 * The gfn of direct spte is stable since it is calculated
+	 * by sp->gfn.
+	 */
+	gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
+
+	if (cmpxchg64(sptep, spte, spte | PT_WRITABLE_MASK) == spte)
+		mark_page_dirty(vcpu->kvm, gfn);

 	return true;
 }
@@ -2774,7 +2824,11 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,

 	sp = page_header(__pa(iterator.sptep));

-	ret = fast_pf_fix_spte(vcpu, sp, iterator.sptep, spte);
+	if (sp->role.direct)
+		ret = fast_pf_fix_direct_spte(vcpu, sp, iterator.sptep, spte);
+	else
+		ret = fast_pf_fix_indirect_spte(vcpu, sp, iterator.sptep,
+						spte, gfn);

 exit:
 	walk_shadow_page_lockless_end(vcpu);
-- 
1.7.7.6


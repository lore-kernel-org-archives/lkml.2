Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab2E2Guv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 02:50:51 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:45019 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab2E2Gut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 02:50:49 -0400
Message-ID: <4FC471B8.3070204@linux.vnet.ibm.com>
Date: Tue, 29 May 2012 14:50:32 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v6 6/9] KVM: MMU: fast path of handling guest page fault
References: <4FC470C7.5040700@linux.vnet.ibm.com>
In-Reply-To: <4FC470C7.5040700@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12052820-7014-0000-0000-00000142433C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the the present bit of page fault error code is set, it indicates
the shadow page is populated on all levels, it means what we do is
only modify the access bit which can be done out of mmu-lock

Currently, in order to simplify the code, we only fix the page fault
caused by write-protect on the fast path

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |  126 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 114 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 150c5ad..d6101a8 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -445,6 +445,11 @@ static bool __check_direct_spte_mmio_pf(u64 spte)
 }
 #endif

+static bool spte_can_be_writable(u64 spte)
+{
+	return !(~spte & (SPTE_HOST_WRITEABLE | SPTE_MMU_WRITEABLE));
+}
+
 static bool spte_has_volatile_bits(u64 spte)
 {
 	if (!shadow_accessed_mask)
@@ -454,7 +459,7 @@ static bool spte_has_volatile_bits(u64 spte)
 		return false;

 	if ((spte & shadow_accessed_mask) &&
-	      (!is_writable_pte(spte) || (spte & shadow_dirty_mask)))
+	      (!spte_can_be_writable(spte) || (spte & shadow_dirty_mask)))
 		return false;

 	return true;
@@ -501,7 +506,7 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
 	new_spte |= old_spte & shadow_dirty_mask;

 	mask = shadow_accessed_mask;
-	if (is_writable_pte(old_spte))
+	if (spte_can_be_writable(old_spte))
 		mask |= shadow_dirty_mask;

 	if (!spte_has_volatile_bits(old_spte) || (new_spte & mask) == mask)
@@ -509,7 +514,7 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
 	else
 		old_spte = __update_clear_spte_slow(sptep, new_spte);

-	if (is_writable_pte(old_spte) && !is_writable_pte(new_spte))
+	if (spte_can_be_writable(old_spte) && !is_writable_pte(new_spte))
 		ret = true;

 	if (!shadow_accessed_mask)
@@ -1066,11 +1071,6 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 		rmap_remove(kvm, sptep);
 }

-static bool spte_can_be_writable(u64 spte)
-{
-	return !(~spte & (SPTE_HOST_WRITEABLE | SPTE_MMU_WRITEABLE));
-}
-
 /* Return true if the spte is dropped. */
 static bool
 spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush, bool pt_protect)
@@ -2659,18 +2659,114 @@ exit:
 	return ret;
 }

+static bool page_fault_can_be_fast(struct kvm_vcpu *vcpu, u32 error_code)
+{
+	/*
+	 * #PF can be fast only if the shadow page table is present and it
+	 * is caused by write-protect, that means we just need change the
+	 * W bit of the spte which can be done out of mmu-lock.
+	 */
+	if (!(error_code & PFERR_PRESENT_MASK) ||
+	      !(error_code & PFERR_WRITE_MASK))
+		return false;
+
+	return true;
+}
+
+static bool
+fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 spte)
+{
+	struct kvm_mmu_page *sp = page_header(__pa(sptep));
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
+
+	return true;
+}
+
+/*
+ * Return value:
+ * - true: let the vcpu to access on the same address again.
+ * - false: let the real page fault path to fix it.
+ */
+static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
+			    u32 error_code)
+{
+	struct kvm_shadow_walk_iterator iterator;
+	bool ret = false;
+	u64 spte = 0ull;
+
+	if (!page_fault_can_be_fast(vcpu, error_code))
+		return false;
+
+	walk_shadow_page_lockless_begin(vcpu);
+	for_each_shadow_entry_lockless(vcpu, gva, iterator, spte)
+		if (!is_shadow_present_pte(spte) || iterator.level < level)
+			break;
+
+	/*
+	 * If the mapping has been changed, let the vcpu fault on the
+	 * same address again.
+	 */
+	if (!is_rmap_spte(spte)) {
+		ret = true;
+		goto exit;
+	}
+
+	if (!is_last_spte(spte, level))
+		goto exit;
+
+	/*
+	 * Check if it is a spurious fault caused by TLB lazily flushed.
+	 *
+	 * Need not check the access of upper level table entries since
+	 * they are always ACC_ALL.
+	 */
+	 if (is_writable_pte(spte)) {
+		ret = true;
+		goto exit;
+	}
+
+	/*
+	 * Currently, to simplify the code, only the spte write-protected
+	 * by dirty-log can be fast fixed.
+	 */
+	if (!spte_can_be_writable(spte))
+		goto exit;
+
+	/*
+	 * Currently, fast page fault only works for direct mapping since
+	 * the gfn is not stable for indirect shadow page.
+	 * See Documentation/virtual/kvm/locking.txt to get more detail.
+	 */
+	ret = fast_pf_fix_direct_spte(vcpu, iterator.sptep, spte);
+exit:
+	walk_shadow_page_lockless_end(vcpu);
+
+	return ret;
+}
+
 static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			 gva_t gva, pfn_t *pfn, bool write, bool *writable);

-static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn,
-			 bool prefault)
+static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, u32 error_code,
+			 gfn_t gfn, bool prefault)
 {
 	int r;
 	int level;
 	int force_pt_level;
 	pfn_t pfn;
 	unsigned long mmu_seq;
-	bool map_writable;
+	bool map_writable, write = error_code & PFERR_WRITE_MASK;

 	force_pt_level = mapping_level_dirty_bitmap(vcpu, gfn);
 	if (likely(!force_pt_level)) {
@@ -2687,6 +2783,9 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn,
 	} else
 		level = PT_PAGE_TABLE_LEVEL;

+	if (fast_page_fault(vcpu, v, level, error_code))
+		return 0;
+
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();

@@ -3075,7 +3174,7 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 	gfn = gva >> PAGE_SHIFT;

 	return nonpaging_map(vcpu, gva & PAGE_MASK,
-			     error_code & PFERR_WRITE_MASK, gfn, prefault);
+			     error_code, gfn, prefault);
 }

 static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
@@ -3155,6 +3254,9 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 	} else
 		level = PT_PAGE_TABLE_LEVEL;

+	if (fast_page_fault(vcpu, gpa, level, error_code))
+		return 0;
+
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();

-- 
1.7.7.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935166Ab2DMKQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:16:43 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:51835 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758299Ab2DMKQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:16:41 -0400
Message-ID: <4F87FD01.1010600@linux.vnet.ibm.com>
Date: Fri, 13 Apr 2012 18:16:33 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 14/16] KVM: MMU: fast path of handling guest page fault
References: <4F87FA69.5060106@linux.vnet.ibm.com>
In-Reply-To: <4F87FA69.5060106@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041300-0260-0000-0000-000000DCF928
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
 arch/x86/kvm/mmu.c         |  205 ++++++++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/paging_tmpl.h |    3 +
 2 files changed, 192 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index efa5d59..fc91667 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -446,6 +446,13 @@ static bool __check_direct_spte_mmio_pf(u64 spte)
 }
 #endif

+static bool spte_wp_by_dirty_log(u64 spte)
+{
+	WARN_ON(is_writable_pte(spte));
+
+	return (spte & SPTE_ALLOW_WRITE) && !(spte & SPTE_WRITE_PROTECT);
+}
+
 static bool spte_has_volatile_bits(u64 spte)
 {
 	if (!shadow_accessed_mask)
@@ -454,9 +461,18 @@ static bool spte_has_volatile_bits(u64 spte)
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
@@ -1109,26 +1125,18 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 		rmap_remove(kvm, sptep);
 }

-static bool spte_wp_by_dirty_log(u64 spte)
-{
-	WARN_ON(is_writable_pte(spte));
-
-	return (spte & SPTE_ALLOW_WRITE) && !(spte & SPTE_WRITE_PROTECT);
-}
-
 static void spte_write_protect(struct kvm *kvm, u64 *sptep, bool large,
 			       bool *flush, bool page_table_protect)
 {
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
 			return;
@@ -1137,6 +1145,9 @@ static void spte_write_protect(struct kvm *kvm, u64 *sptep, bool large,
 		goto reset_spte;
 	}

+	/* We need flush tlbs in this case: the fast page fault path
+	 * can mark the spte writable after we read the sptep.
+	 */
 	if (page_table_protect && spte_wp_by_dirty_log(spte))
 		goto reset_spte;

@@ -1144,6 +1155,8 @@ static void spte_write_protect(struct kvm *kvm, u64 *sptep, bool large,

 reset_spte:
 	rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
+
+	*flush |= true;
 	spte = spte & ~PT_WRITABLE_MASK;
 	if (page_table_protect)
 		spte |= SPTE_WRITE_PROTECT;
@@ -2767,18 +2780,172 @@ exit:
 	return ret;
 }

+static bool page_fault_can_be_fast(struct kvm_vcpu *vcpu, gfn_t gfn,
+				   u32 error_code)
+{
+	unsigned long *rmap;
+
+	/*
+	 * #PF can be fast only if the shadow page table is present and it
+	 * is caused by write-protect, that means we just need change the
+	 * W bit of the spte which can be done out of mmu-lock.
+	 */
+	if (!(error_code & PFERR_PRESENT_MASK) ||
+	      !(error_code & PFERR_WRITE_MASK))
+		return false;
+
+	rmap = gfn_to_rmap(vcpu->kvm, gfn, PT_PAGE_TABLE_LEVEL);
+
+	/* Quickly check the page can be writable. */
+	if (test_bit(PTE_LIST_WP_BIT, ACCESS_ONCE(rmap)))
+		return false;
+
+	return true;
+}
+
+static bool
+fast_pf_fix_indirect_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+			  u64 *sptep, u64 spte, gfn_t gfn)
+{
+	pfn_t pfn;
+	bool ret = false;
+
+	/*
+	 * For the indirect spte, it is hard to get a stable gfn since
+	 * we just use a cmpxchg to avoid all the races which is not
+	 * enough to avoid the ABA problem: the host can arbitrarily
+	 * change spte and the mapping from gfn to pfh.
+	 *
+	 * What we do is call gfn_to_pfn_atomic to bind the gfn and the
+	 * pfn because after the call:
+	 * - we have held the refcount of pfn that means the pfn can not
+	 *   be freed and be reused for another gfn.
+	 * - the pfn is writable that means it can not be shared by different
+	 *   gfn.
+	 */
+	pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);
+
+	/* The host page is swapped out or merged. */
+	if (mmu_invalid_pfn(pfn))
+		goto exit;
+
+	ret = true;
+
+	if (pfn != spte_to_pfn(spte))
+		goto exit;
+
+	if (cmpxchg64(sptep, spte, spte | PT_WRITABLE_MASK) == spte)
+		mark_page_dirty(vcpu->kvm, gfn);
+
+exit:
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
+
+	return true;
+}
+
+/*
+ * Return value:
+ * - true: let the vcpu to access on the same address again.
+ * - false: let the real page fault path to fix it.
+ */
+static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
+			    int level, u32 error_code)
+{
+	struct kvm_shadow_walk_iterator iterator;
+	struct kvm_mmu_page *sp;
+	bool ret = false;
+	u64 spte = 0ull;
+
+	if (!page_fault_can_be_fast(vcpu, gfn, error_code))
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
+	 * If the page fault is caused by write but host do not allow
+	 * to write the page, we need cow the host page.
+	 */
+	if (!(spte & SPTE_ALLOW_WRITE))
+		goto exit;
+
+	/*
+	 * Currently, to simplify the code, only the spte write-protected
+	 * by dirty-log can be fast fixed.
+	 */
+	if (!spte_wp_by_dirty_log(spte))
+		goto exit;
+
+	sp = page_header(__pa(iterator.sptep));
+
+	if (sp->role.direct)
+		ret = fast_pf_fix_direct_spte(vcpu, sp, iterator.sptep, spte);
+	else
+		ret = fast_pf_fix_indirect_spte(vcpu, sp, iterator.sptep,
+						spte, gfn);
+
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
@@ -2795,6 +2962,9 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn,
 	} else
 		level = PT_PAGE_TABLE_LEVEL;

+	if (fast_page_fault(vcpu, v, gfn, level, error_code))
+		return 0;
+
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();

@@ -3183,7 +3353,7 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 	gfn = gva >> PAGE_SHIFT;

 	return nonpaging_map(vcpu, gva & PAGE_MASK,
-			     error_code & PFERR_WRITE_MASK, gfn, prefault);
+			     error_code, gfn, prefault);
 }

 static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
@@ -3263,6 +3433,9 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 	} else
 		level = PT_PAGE_TABLE_LEVEL;

+	if (fast_page_fault(vcpu, gpa, gfn, level, error_code))
+		return 0;
+
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index e3cf43b..c85dbbe 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -615,6 +615,9 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 		walker.gfn = walker.gfn & ~(KVM_PAGES_PER_HPAGE(level) - 1);
 	}

+	if (fast_page_fault(vcpu, addr, walker.gfn, level, error_code))
+		return 0;
+
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();

-- 
1.7.7.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab0HDDhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 23:37:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50191 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758008Ab0HDDho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 23:37:44 -0400
Message-ID: <4C58DF89.4080404@cn.fujitsu.com>
Date: Wed, 04 Aug 2010 11:33:29 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: [PATCH v6 3/3] KVM: MMU: prefetch ptes when intercepted guest #PF
References: <4C58DE49.1020705@cn.fujitsu.com> <4C58DF26.3060305@cn.fujitsu.com>
In-Reply-To: <4C58DF26.3060305@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support prefetch ptes when intercept guest #PF, avoid to #PF by later
access

If we meet any failure in the prefetch path, we will exit it and
not try other ptes to avoid become heavy path

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |  107 +++++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/paging_tmpl.h |   81 ++++++++++++++++++++++++++++++++-
 2 files changed, 184 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9c69725..4501734 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -89,6 +89,8 @@ module_param(oos_shadow, bool, 0644);
 	}
 #endif
 
+#define PTE_PREFETCH_NUM		8
+
 #define PT_FIRST_AVAIL_BITS_SHIFT 9
 #define PT64_SECOND_AVAIL_BITS_SHIFT 52
 
@@ -403,7 +405,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 	if (r)
 		goto out;
 	r = mmu_topup_memory_cache(&vcpu->arch.mmu_rmap_desc_cache,
-				   rmap_desc_cache, 4);
+				   rmap_desc_cache, 4 + PTE_PREFETCH_NUM);
 	if (r)
 		goto out;
 	r = mmu_topup_memory_cache_page(&vcpu->arch.mmu_page_cache, 8);
@@ -2090,6 +2092,108 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 {
 }
 
+static struct kvm_memory_slot *
+pte_prefetch_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn, bool no_dirty_log)
+{
+	struct kvm_memory_slot *slot;
+
+	slot = gfn_to_memslot(vcpu->kvm, gfn);
+	if (!slot || slot->flags & KVM_MEMSLOT_INVALID ||
+	      (no_dirty_log && slot->dirty_bitmap))
+		slot = NULL;
+
+	return slot;
+}
+
+static pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
+				     bool no_dirty_log)
+{
+	struct kvm_memory_slot *slot;
+	unsigned long hva;
+
+	slot = pte_prefetch_gfn_to_memslot(vcpu, gfn, no_dirty_log);
+	if (!slot) {
+		get_page(bad_page);
+		return page_to_pfn(bad_page);
+	}
+
+	hva = gfn_to_hva_memslot(slot, gfn);
+
+	return hva_to_pfn_atomic(vcpu->kvm, hva);
+}
+
+static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
+				    struct kvm_mmu_page *sp,
+				    u64 *start, u64 *end)
+{
+	struct page *pages[PTE_PREFETCH_NUM];
+	struct kvm_memory_slot *slot;
+	unsigned hva, access = sp->role.access;
+	int i, ret, npages = end - start;
+	gfn_t gfn;
+
+	gfn = kvm_mmu_page_get_gfn(sp, start - sp->spt);
+	slot = pte_prefetch_gfn_to_memslot(vcpu, gfn, access & ACC_WRITE_MASK);
+	if (!slot || slot->npages - (gfn - slot->base_gfn) != npages)
+		return -1;
+
+	hva = gfn_to_hva_memslot(slot, gfn);
+	ret = __get_user_pages_fast(hva, npages, 1, pages);
+	if (ret <= 0)
+		return -1;
+
+	for (i = 0; i < ret; i++, gfn++, start++)
+		mmu_set_spte(vcpu, start, ACC_ALL,
+			     access, 0, 0, 1, NULL,
+			     sp->role.level, gfn,
+			     page_to_pfn(pages[i]), true, true);
+
+	return ret == npages ? 0 : -1;
+}
+
+static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
+				  struct kvm_mmu_page *sp, u64 *sptep)
+{
+	u64 *spte, *start = NULL;
+	int i;
+
+	WARN_ON(!sp->role.direct);
+
+	i = (sptep - sp->spt) & ~(PTE_PREFETCH_NUM - 1);
+	spte = sp->spt + i;
+
+	for (i = 0; i < PTE_PREFETCH_NUM; i++, spte++) {
+		if (*spte != shadow_trap_nonpresent_pte || spte == sptep) {
+			if (!start)
+				continue;
+			if (direct_pte_prefetch_many(vcpu, sp, start, spte) < 0)
+				break;
+			start = NULL;
+		} else if (!start)
+			start = spte;
+	}
+}
+
+static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
+{
+	struct kvm_mmu_page *sp;
+
+	/*
+	 * Since it's no accessed bit on EPT, it's no way to
+	 * distinguish between actually accessed translations
+	 * and prefetched, so disable pte prefetch if EPT is
+	 * enabled.
+	 */
+	if (!shadow_accessed_mask)
+		return;
+
+	sp = page_header(__pa(sptep));
+	if (sp->role.level > PT_PAGE_TABLE_LEVEL)
+		return;
+
+	__direct_pte_prefetch(vcpu, sp, sptep);
+}
+
 static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 			int level, gfn_t gfn, pfn_t pfn)
 {
@@ -2103,6 +2207,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL, ACC_ALL,
 				     0, write, 1, &pt_write,
 				     level, gfn, pfn, false, true);
+			direct_pte_prefetch(vcpu, iterator.sptep);
 			++vcpu->stat.pf_fixed;
 			break;
 		}
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 51ef909..114c17d 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -67,6 +67,7 @@ struct guest_walker {
 	int level;
 	gfn_t table_gfn[PT_MAX_FULL_LEVELS];
 	pt_element_t ptes[PT_MAX_FULL_LEVELS];
+	pt_element_t prefetch_ptes[PTE_PREFETCH_NUM];
 	gpa_t pte_gpa[PT_MAX_FULL_LEVELS];
 	unsigned pt_access;
 	unsigned pte_access;
@@ -302,14 +303,87 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 static bool FNAME(gpte_changed)(struct kvm_vcpu *vcpu,
 				struct guest_walker *gw, int level)
 {
-	int r;
 	pt_element_t curr_pte;
-
-	r = kvm_read_guest_atomic(vcpu->kvm, gw->pte_gpa[level - 1],
+	gpa_t base_gpa, pte_gpa = gw->pte_gpa[level - 1];
+	u64 mask;
+	int r, index;
+
+	if (level == PT_PAGE_TABLE_LEVEL) {
+		mask = PTE_PREFETCH_NUM * sizeof(pt_element_t) - 1;
+		base_gpa = pte_gpa & ~mask;
+		index = (pte_gpa - base_gpa) / sizeof(pt_element_t);
+
+		r = kvm_read_guest_atomic(vcpu->kvm, base_gpa,
+				gw->prefetch_ptes, sizeof(gw->prefetch_ptes));
+		curr_pte = gw->prefetch_ptes[index];
+	} else
+		r = kvm_read_guest_atomic(vcpu->kvm, pte_gpa,
 				  &curr_pte, sizeof(curr_pte));
+
 	return r || curr_pte != gw->ptes[level - 1];
 }
 
+static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
+				u64 *sptep)
+{
+	struct kvm_mmu_page *sp;
+	pt_element_t *gptep = gw->prefetch_ptes;
+	u64 *spte;
+	int i;
+
+	sp = page_header(__pa(sptep));
+
+	if (sp->role.level > PT_PAGE_TABLE_LEVEL)
+		return;
+
+	if (sp->role.direct)
+		return __direct_pte_prefetch(vcpu, sp, sptep);
+
+	i = (sptep - sp->spt) & ~(PTE_PREFETCH_NUM - 1);
+	spte = sp->spt + i;
+
+	for (i = 0; i < PTE_PREFETCH_NUM; i++, spte++) {
+		pt_element_t gpte;
+		unsigned pte_access;
+		gfn_t gfn;
+		pfn_t pfn;
+		bool dirty;
+
+		if (spte == sptep)
+			continue;
+
+		if (*spte != shadow_trap_nonpresent_pte)
+			continue;
+
+		gpte = gptep[i];
+
+
+		if (!is_present_gpte(gpte) ||
+		      is_rsvd_bits_set(vcpu, gpte, PT_PAGE_TABLE_LEVEL)) {
+			if (!sp->unsync)
+				__set_spte(spte, shadow_notrap_nonpresent_pte);
+			continue;
+		}
+
+		if (!(gpte & PT_ACCESSED_MASK))
+			continue;
+
+		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
+		gfn = gpte_to_gfn(gpte);
+		dirty =  is_dirty_gpte(gpte);
+		pfn = pte_prefetch_gfn_to_pfn(vcpu, gfn,
+				      (pte_access & ACC_WRITE_MASK) && dirty);
+		if (is_error_pfn(pfn)) {
+			kvm_release_pfn_clean(pfn);
+			break;
+		}
+
+		mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
+			     dirty, NULL, PT_PAGE_TABLE_LEVEL, gfn,
+			     pfn, true, true);
+	}
+}
+
 /*
  * Fetch a shadow pte for a specific level in the paging hierarchy.
  */
@@ -391,6 +465,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	mmu_set_spte(vcpu, it.sptep, access, gw->pte_access & access,
 		     user_fault, write_fault, dirty, ptwrite, it.level,
 		     gw->gfn, pfn, false, true);
+	FNAME(pte_prefetch)(vcpu, gw, it.sptep);
 
 	return it.sptep;
 
-- 
1.6.1.2



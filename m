Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab0GFKyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 06:54:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65246 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab0GFKyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 06:54:10 -0400
Message-ID: <4C330A65.50708@cn.fujitsu.com>
Date: Tue, 06 Jul 2010 18:50:13 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH v5 7/9] KVM: MMU: prefetch ptes when intercepted guest #PF
References: <4C330918.6040709@cn.fujitsu.com>
In-Reply-To: <4C330918.6040709@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support prefetch ptes when intercept guest #PF, avoid to #PF by later
access

If we meet any failure in the prefetch path, we will exit it and
not try other ptes to avoid become heavy path

Will do: fix dirty bit tracking in the speculative path

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |   79 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/paging_tmpl.h |   76 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 155 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index cda4587..66e225d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2038,6 +2038,84 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 {
 }
 
+static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
+				    struct kvm_mmu_page *sp,
+				    u64 *start, u64 *end)
+{
+	gfn_t gfn;
+	struct page *pages[PTE_PREFETCH_NUM];
+
+	gfn = sp->gfn + start - sp->spt;
+	while (start < end) {
+		int j, ret;
+		bool enough;
+
+		ret = gfn_to_page_many_atomic(vcpu->kvm, gfn, pages,
+						end - start, &enough);
+		if (ret <= 0)
+			return -1;
+
+		for (j = 0; j < ret; j++, gfn++, start++)
+			mmu_set_spte(vcpu, start, ACC_ALL,
+				     sp->role.access, 0, 0, 1, NULL,
+				     sp->role.level, gfn,
+				     page_to_pfn(pages[j]), true, true);
+
+		if (!enough)
+			return -1;
+	}
+	return 0;
+}
+
+static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
+				  struct kvm_mmu_page *sp, u64 *sptep)
+{
+	u64 *start = NULL;
+	int index, i, max;
+
+	WARN_ON(!sp->role.direct);
+
+	if (pte_prefetch_topup_memory_cache(vcpu))
+		return;
+
+	index = sptep - sp->spt;
+	i = index & ~(PTE_PREFETCH_NUM - 1);
+	max = index | (PTE_PREFETCH_NUM - 1);
+
+	for (; i < max; i++) {
+		u64 *spte = sp->spt + i;
+
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
@@ -2051,6 +2129,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL, ACC_ALL,
 				     0, write, 1, &pt_write,
 				     level, gfn, pfn, false, true);
+			direct_pte_prefetch(vcpu, iterator.sptep);
 			++vcpu->stat.pf_fixed;
 			break;
 		}
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index f58a5c4..e04c1a4 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -291,6 +291,81 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		     gpte_to_gfn(gpte), pfn, true, true);
 }
 
+static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, u64 *sptep)
+{
+	struct kvm_mmu_page *sp;
+	pt_element_t gptep[PTE_PREFETCH_NUM];
+	gpa_t first_pte_gpa;
+	int offset = 0, index, i, j, max;
+
+	sp = page_header(__pa(sptep));
+	index = sptep - sp->spt;
+
+	if (sp->role.level > PT_PAGE_TABLE_LEVEL)
+		return;
+
+	if (sp->role.direct)
+		return __direct_pte_prefetch(vcpu, sp, sptep);
+
+	index = sptep - sp->spt;
+	i = index & ~(PTE_PREFETCH_NUM - 1);
+	max = index | (PTE_PREFETCH_NUM - 1);
+
+	if (PTTYPE == 32)
+		offset = sp->role.quadrant << PT64_LEVEL_BITS;
+
+	first_pte_gpa = gfn_to_gpa(sp->gfn) +
+				(offset + i) * sizeof(pt_element_t);
+
+	if (kvm_read_guest_atomic(vcpu->kvm, first_pte_gpa, gptep,
+					sizeof(gptep)) < 0)
+		return;
+
+	if (pte_prefetch_topup_memory_cache(vcpu))
+		return;
+
+	for (j = 0; i < max; i++, j++) {
+		pt_element_t gpte;
+		unsigned pte_access;
+		u64 *spte = sp->spt + i;
+		gfn_t gfn;
+		pfn_t pfn;
+
+		if (spte == sptep)
+			continue;
+
+		if (*spte != shadow_trap_nonpresent_pte)
+			continue;
+
+		gpte = gptep[j];
+
+		if (is_rsvd_bits_set(vcpu, gpte, PT_PAGE_TABLE_LEVEL))
+			break;
+
+		if (!(gpte & PT_ACCESSED_MASK))
+			continue;
+
+		if (!is_present_gpte(gpte)) {
+			if (!sp->unsync)
+				__set_spte(spte, shadow_notrap_nonpresent_pte);
+			continue;
+		}
+
+		gfn = gpte_to_gfn(gpte);
+
+		pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);
+		if (is_error_pfn(pfn)) {
+			kvm_release_pfn_clean(pfn);
+			break;
+		}
+
+		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
+		mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
+			     is_dirty_gpte(gpte), NULL, sp->role.level, gfn,
+			     pfn, true, true);
+	}
+}
+
 /*
  * Fetch a shadow pte for a specific level in the paging hierarchy.
  */
@@ -401,6 +476,7 @@ check_set_spte:
 				     user_fault, write_fault,
 				     dirty, ptwrite, level,
 				     gw->gfn, pfn, false, true);
+			FNAME(pte_prefetch)(vcpu, sptep);
 			break;
 		}
 	}
-- 
1.6.1.2



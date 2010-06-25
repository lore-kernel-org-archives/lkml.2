Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab0FYMLH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 08:11:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57534 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755829Ab0FYMLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 08:11:01 -0400
Message-ID: <4C249BEA.1030908@cn.fujitsu.com>
Date: Fri, 25 Jun 2010 20:07:06 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH v2 8/10] KVM: MMU: prefetch ptes when intercepted guest #PF
References: <4C2498EC.2010006@cn.fujitsu.com>
In-Reply-To: <4C2498EC.2010006@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support prefetch ptes when intercept guest #PF, avoid to #PF by later
access

If we meet any failure in the prefetch path, we will exit it and
not try other ptes to avoid become heavy path

Note: this speculative will mark page become dirty but it not really
accessed, the same issue is in other speculative paths like invlpg,
pte write, fortunately, it just affect host memory management. After
Avi's patchset named "[PATCH v2 1/4] KVM: MMU: Introduce drop_spte()"
merged, we will easily fix it. Will do it in the future.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |   69 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/paging_tmpl.h |   74 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 143 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 6c06666..b2ad723 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -89,6 +89,8 @@ module_param(oos_shadow, bool, 0644);
 	}
 #endif
 
+#define PTE_PREFETCH_NUM	16
+
 #define PT_FIRST_AVAIL_BITS_SHIFT 9
 #define PT64_SECOND_AVAIL_BITS_SHIFT 52
 
@@ -1998,6 +2000,72 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 {
 }
 
+static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
+				    struct kvm_mmu_page *sp,
+				    u64 *start, u64 *end)
+{
+	gfn_t gfn;
+	struct page *pages[PTE_PREFETCH_NUM];
+
+	if (pte_prefetch_topup_memory_cache(vcpu, end - start))
+		return -1;
+
+	gfn = sp->gfn + start - sp->spt;
+	while (start < end) {
+		unsigned long addr;
+		int entry, j, ret;
+
+		addr = gfn_to_hva_many(vcpu->kvm, gfn, &entry);
+		if (kvm_is_error_hva(addr))
+			return -1;
+
+		entry = min(entry, (int)(end - start));
+		ret = __get_user_pages_fast(addr, entry, 1, pages);
+		if (ret <= 0)
+			return -1;
+
+		for (j = 0; j < ret; j++, gfn++, start++)
+			mmu_set_spte(vcpu, start, ACC_ALL,
+				     sp->role.access, 0, 0, 1, NULL,
+				     sp->role.level, gfn,
+				     page_to_pfn(pages[j]), true, false);
+
+		if (ret < entry)
+			return -1;
+	}
+	return 0;
+}
+
+static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
+{
+	struct kvm_mmu_page *sp;
+	u64 *start = NULL;
+	int index, i, max;
+
+	sp = page_header(__pa(sptep));
+	WARN_ON(!sp->role.direct);
+
+	if (sp->role.level > PT_PAGE_TABLE_LEVEL)
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
 static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 			int level, gfn_t gfn, pfn_t pfn)
 {
@@ -2012,6 +2080,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 				     0, write, 1, &pt_write,
 				     level, gfn, pfn, false, true);
 			++vcpu->stat.pf_fixed;
+			direct_pte_prefetch(vcpu, iterator.sptep);
 			break;
 		}
 
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index fdba751..134f031 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -291,6 +291,79 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
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
+		return direct_pte_prefetch(vcpu, sptep);
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
+		if (is_error_pfn(pfn) ||
+			pte_prefetch_topup_memory_cache(vcpu, 1)) {
+			kvm_release_pfn_clean(pfn);
+			break;
+		}
+
+		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
+		mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
+			     is_dirty_gpte(gpte), NULL, sp->role.level, gfn,
+			     pfn, true, false);
+	}
+}
+
 /*
  * Fetch a shadow pte for a specific level in the paging hierarchy.
  */
@@ -322,6 +395,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 				     user_fault, write_fault,
 				     dirty, ptwrite, level,
 				     gw->gfn, pfn, false, true);
+			FNAME(pte_prefetch)(vcpu, sptep);
 			break;
 		}
 
-- 
1.6.1.2




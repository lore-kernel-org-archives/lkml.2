Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab0FOCun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 22:50:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50557 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756369Ab0FOCuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 22:50:39 -0400
Message-ID: <4C16E9A8.10409@cn.fujitsu.com>
Date: Tue, 15 Jun 2010 10:47:04 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 5/6] KVM: MMU: prefetch ptes when intercepted guest #PF
References: <4C16E6ED.7020009@cn.fujitsu.com> <4C16E75F.6020003@cn.fujitsu.com> <4C16E7AD.1060101@cn.fujitsu.com> <4C16E7F4.5060801@cn.fujitsu.com> <4C16E82E.5010306@cn.fujitsu.com>
In-Reply-To: <4C16E82E.5010306@cn.fujitsu.com>
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
 arch/x86/kvm/mmu.c         |   36 +++++++++++++++++++++
 arch/x86/kvm/paging_tmpl.h |   76 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 112 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 92ff099..941c86b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -89,6 +89,8 @@ module_param(oos_shadow, bool, 0644);
 	}
 #endif
 
+#define PTE_PREFETCH_NUM	16
+
 #define PT_FIRST_AVAIL_BITS_SHIFT 9
 #define PT64_SECOND_AVAIL_BITS_SHIFT 52
 
@@ -2041,6 +2043,39 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 {
 }
 
+static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
+{
+	struct kvm_mmu_page *sp;
+	int index, i;
+
+	sp = page_header(__pa(sptep));
+	WARN_ON(!sp->role.direct);
+	index = sptep - sp->spt;
+
+	for (i = index + 1; i < min(PT64_ENT_PER_PAGE,
+				      index + PTE_PREFETCH_NUM); i++) {
+		gfn_t gfn;
+		pfn_t pfn;
+		u64 *spte = sp->spt + i;
+
+		if (*spte != shadow_trap_nonpresent_pte)
+			continue;
+
+		gfn = sp->gfn + (i << ((sp->role.level - 1) * PT64_LEVEL_BITS));
+
+		pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);
+		if (is_error_pfn(pfn)) {
+			kvm_release_pfn_clean(pfn);
+			break;
+		}
+		if (pte_prefetch_topup_memory_cache(vcpu))
+			break;
+
+		mmu_set_spte(vcpu, spte, ACC_ALL, ACC_ALL, 0, 0, 1, NULL,
+			     sp->role.level, gfn, pfn, true, false);
+	}
+}
+
 static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 			int level, gfn_t gfn, pfn_t pfn)
 {
@@ -2055,6 +2090,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 				     0, write, 1, &pt_write,
 				     level, gfn, pfn, false, true);
 			++vcpu->stat.pf_fixed;
+			direct_pte_prefetch(vcpu, iterator.sptep);
 			break;
 		}
 
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index eb47148..af4e041 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -291,6 +291,81 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		     gpte_to_gfn(gpte), pfn, true, true);
 }
 
+static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, u64 *sptep)
+{
+	struct kvm_mmu_page *sp;
+	pt_element_t *table = NULL;
+	int offset = 0, shift, index, i;
+
+	sp = page_header(__pa(sptep));
+	index = sptep - sp->spt;
+
+	if (PTTYPE == 32) {
+		shift = PAGE_SHIFT - (PT_LEVEL_BITS -
+					PT64_LEVEL_BITS) * sp->role.level;
+		offset = sp->role.quadrant << shift;
+	}
+
+	for (i = index + 1; i < min(PT64_ENT_PER_PAGE,
+				      index + PTE_PREFETCH_NUM); i++) {
+		struct page *page;
+		pt_element_t gpte;
+		unsigned pte_access;
+		u64 *spte = sp->spt + i;
+		gfn_t gfn;
+		pfn_t pfn;
+		int dirty;
+
+		if (*spte != shadow_trap_nonpresent_pte)
+			continue;
+
+		pte_access = sp->role.access;
+		if (sp->role.direct) {
+			dirty = 1;
+			gfn = sp->gfn + (i << ((sp->role.level - 1) *
+					      PT64_LEVEL_BITS));
+			goto gfn_mapping;
+		}
+
+		if (!table) {
+			page = gfn_to_page_atomic(vcpu->kvm, sp->gfn);
+			if (is_error_page(page)) {
+				kvm_release_page_clean(page);
+				break;
+			}
+			table = kmap_atomic(page, KM_USER0);
+			table = (pt_element_t *)((char *)table + offset);
+		}
+
+		gpte = table[i];
+		if (!(gpte & PT_ACCESSED_MASK))
+			continue;
+
+		if (!is_present_gpte(gpte)) {
+			if (!sp->unsync)
+				*spte = shadow_notrap_nonpresent_pte;
+			continue;
+		}
+		dirty = is_dirty_gpte(gpte);
+		gfn = (gpte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
+		pte_access = pte_access & FNAME(gpte_access)(vcpu, gpte);
+gfn_mapping:
+		pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);
+		if (is_error_pfn(pfn)) {
+			kvm_release_pfn_clean(pfn);
+			break;
+		}
+
+		if (pte_prefetch_topup_memory_cache(vcpu))
+			break;
+		mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
+			     dirty, NULL, sp->role.level, gfn, pfn,
+			     true, false);
+	}
+	if (table)
+		kunmap_atomic((char *)table - offset, KM_USER0);
+}
+
 /*
  * Fetch a shadow pte for a specific level in the paging hierarchy.
  */
@@ -322,6 +397,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 				     is_dirty_gpte(gw->ptes[gw->level-1]),
 				     ptwrite, level,
 				     gw->gfn, pfn, false, true);
+			FNAME(pte_prefetch)(vcpu, sptep);
 			break;
 		}
 
-- 
1.6.1.2




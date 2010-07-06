Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab0GFKzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 06:55:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64420 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754910Ab0GFKzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 06:55:00 -0400
Message-ID: <4C330A9A.9030106@cn.fujitsu.com>
Date: Tue, 06 Jul 2010 18:51:06 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH v5 8/9] KVM: MMU: combine guest pte read between fetch and
 pte prefetch
References: <4C330918.6040709@cn.fujitsu.com>
In-Reply-To: <4C330918.6040709@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Combine guest pte read between guest pte check in the fetch path and pte prefetch

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |   69 ++++++++++++++++++++++++++-----------------
 1 files changed, 42 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index e04c1a4..a1e6d91 100644
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
@@ -291,12 +292,12 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		     gpte_to_gfn(gpte), pfn, true, true);
 }
 
-static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, u64 *sptep)
+static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
+				u64 *sptep)
 {
 	struct kvm_mmu_page *sp;
-	pt_element_t gptep[PTE_PREFETCH_NUM];
-	gpa_t first_pte_gpa;
-	int offset = 0, index, i, j, max;
+	pt_element_t *gptep;
+	int index, i, j, max;
 
 	sp = page_header(__pa(sptep));
 	index = sptep - sp->spt;
@@ -311,15 +312,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, u64 *sptep)
 	i = index & ~(PTE_PREFETCH_NUM - 1);
 	max = index | (PTE_PREFETCH_NUM - 1);
 
-	if (PTTYPE == 32)
-		offset = sp->role.quadrant << PT64_LEVEL_BITS;
-
-	first_pte_gpa = gfn_to_gpa(sp->gfn) +
-				(offset + i) * sizeof(pt_element_t);
-
-	if (kvm_read_guest_atomic(vcpu->kvm, first_pte_gpa, gptep,
-					sizeof(gptep)) < 0)
-		return;
+	gptep = gw->prefetch_ptes;
 
 	if (pte_prefetch_topup_memory_cache(vcpu))
 		return;
@@ -366,6 +359,35 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, u64 *sptep)
 	}
 }
 
+static bool FNAME(check_gpte_level)(struct kvm_vcpu *vcpu,
+				    struct guest_walker *gw, int level)
+{
+	pt_element_t curr_pte;
+	int index, ret;
+	u64 mask;
+	gpa_t base_gpa, pte_gpa = gw->pte_gpa[level - 1];
+
+	if (level < gw->level)
+		return true;
+
+	if (level == PT_PAGE_TABLE_LEVEL) {
+		mask = PTE_PREFETCH_NUM * sizeof(pt_element_t) - 1;
+		base_gpa = pte_gpa & ~mask;
+		index = (pte_gpa - base_gpa) / sizeof(pt_element_t);
+
+		ret = kvm_read_guest_atomic(vcpu->kvm, base_gpa,
+				gw->prefetch_ptes, sizeof(gw->prefetch_ptes));
+		curr_pte = gw->prefetch_ptes[index];
+	} else
+		ret = kvm_read_guest_atomic(vcpu->kvm, pte_gpa, &curr_pte,
+						sizeof(curr_pte));
+
+	if (ret || curr_pte != gw->ptes[level - 1])
+		return false;
+
+	return true;
+}
+
 /*
  * Fetch a shadow pte for a specific level in the paging hierarchy.
  */
@@ -379,11 +401,9 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	u64 spte, *sptep = NULL;
 	int direct;
 	gfn_t table_gfn;
-	int r;
 	int level;
 	bool dirty = is_dirty_gpte(gw->ptes[gw->level - 1]);
 	unsigned direct_access;
-	pt_element_t curr_pte;
 	struct kvm_shadow_walk_iterator iterator;
 
 	if (!is_present_gpte(gw->ptes[gw->level - 1]))
@@ -449,17 +469,12 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		sp = kvm_mmu_get_page(vcpu, table_gfn, addr, level-1,
 					       direct, access, sptep);
 check_set_spte:
-		if (level >= gw->level) {
-			r = kvm_read_guest_atomic(vcpu->kvm,
-						  gw->pte_gpa[level - 1],
-						  &curr_pte, sizeof(curr_pte));
-			if (r || curr_pte != gw->ptes[level - 1]) {
-				if (nonpresent)
-					kvm_mmu_put_page(sp, sptep);
-				kvm_release_pfn_clean(pfn);
-				sptep = NULL;
-				break;
-			}
+		if (!FNAME(check_gpte_level)(vcpu, gw, level)) {
+			if (nonpresent)
+				kvm_mmu_put_page(sp, sptep);
+			kvm_release_pfn_clean(pfn);
+			sptep = NULL;
+			break;
 		}
 
 		if (nonpresent) {
@@ -476,7 +491,7 @@ check_set_spte:
 				     user_fault, write_fault,
 				     dirty, ptwrite, level,
 				     gw->gfn, pfn, false, true);
-			FNAME(pte_prefetch)(vcpu, sptep);
+			FNAME(pte_prefetch)(vcpu, gw, sptep);
 			break;
 		}
 	}
-- 
1.6.1.2



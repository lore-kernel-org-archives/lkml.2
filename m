Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab0F3IMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 04:12:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51695 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab0F3IM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 04:12:29 -0400
Message-ID: <4C2AFB8A.1050104@cn.fujitsu.com>
Date: Wed, 30 Jun 2010 16:08:42 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 10/11] KVM: MMU: combine guest pte read between walk and pte
 prefetch
References: <4C2AF9FA.9020601@cn.fujitsu.com>
In-Reply-To: <4C2AF9FA.9020601@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Combine guest pte read between guest pte walk and pte prefetch

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |   48 ++++++++++++++++++++++++++++++-------------
 1 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index d8c3be8..3e047b4 100644
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
@@ -110,6 +111,31 @@ static unsigned FNAME(gpte_access)(struct kvm_vcpu *vcpu, pt_element_t gpte)
 	return access;
 }
 
+static int FNAME(read_guest_pte)(struct kvm_vcpu *vcpu,
+				 struct guest_walker *walker,
+				 gpa_t pte_gpa, pt_element_t *pte)
+{
+	int index, ret;
+	u64 mask;
+	gpa_t base_gpa;
+
+	if (walker->level > PT_PAGE_TABLE_LEVEL)
+		return kvm_read_guest(vcpu->kvm, pte_gpa, pte,
+					sizeof(*pte));
+
+	mask = PTE_PREFETCH_NUM * sizeof(*pte) - 1;
+	base_gpa = pte_gpa & ~mask;
+	index = (pte_gpa - base_gpa) / sizeof(*pte);
+
+	ret = kvm_read_guest(vcpu->kvm, base_gpa, walker->prefetch_ptes,
+				sizeof(walker->prefetch_ptes));
+	if (ret)
+		return ret;
+
+	*pte = walker->prefetch_ptes[index];
+	return 0;
+}
+
 /*
  * Fetch a guest pte for a guest virtual address
  */
@@ -151,7 +177,7 @@ walk:
 		walker->table_gfn[walker->level - 1] = table_gfn;
 		walker->pte_gpa[walker->level - 1] = pte_gpa;
 
-		if (kvm_read_guest(vcpu->kvm, pte_gpa, &pte, sizeof(pte)))
+		if (FNAME(read_guest_pte)(vcpu, walker, pte_gpa, &pte))
 			goto not_present;
 
 		trace_kvm_mmu_paging_element(pte, walker->level);
@@ -291,12 +317,12 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		     gpte_to_gfn(gpte), pfn, true, true);
 }
 
-static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, u64 *sptep)
+static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu,
+				struct guest_walker *gw, u64 *sptep)
 {
 	struct kvm_mmu_page *sp;
-	pt_element_t gptep[PTE_PREFETCH_NUM];
-	gpa_t first_pte_gpa;
-	int offset = 0, index, i, j, max;
+	pt_element_t *gptep;
+	int index, i, j, max;
 
 	sp = page_header(__pa(sptep));
 	index = sptep - sp->spt;
@@ -311,15 +337,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, u64 *sptep)
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
@@ -402,7 +420,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 				     user_fault, write_fault,
 				     dirty, ptwrite, level,
 				     gw->gfn, pfn, false, true);
-			FNAME(pte_prefetch)(vcpu, sptep);
+			FNAME(pte_prefetch)(vcpu, gw, sptep);
 			break;
 		}
 
-- 
1.6.1.2



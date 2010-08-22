Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab0HULJY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 07:09:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62853 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751751Ab0HULJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 07:09:22 -0400
Message-ID: <4C71065D.80806@cn.fujitsu.com>
Date: Sun, 22 Aug 2010 19:13:33 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 5/5] KVM: MMU: combine guest pte read between fetch and
 pte prefetch
References: <4C710549.9090704@cn.fujitsu.com>
In-Reply-To: <4C710549.9090704@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Combine guest pte read between guest pte check in the fetch path and pte prefetch

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |   40 +++++++++++++++++++++-------------------
 1 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 9e6acc9..2f4925e 100644
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
@@ -302,21 +303,33 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
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
 
-static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, u64 *sptep)
+static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
+				u64 *sptep)
 {
 	struct kvm_mmu_page *sp;
-	pt_element_t gptep[PTE_PREFETCH_NUM];
-	gpa_t first_pte_gpa;
-	int offset = 0, i;
+	pt_element_t *gptep = gw->prefetch_ptes;
 	u64 *spte;
+	int i;
 
 	sp = page_header(__pa(sptep));
 
@@ -327,17 +340,6 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, u64 *sptep)
 		return __direct_pte_prefetch(vcpu, sp, sptep);
 
 	i = (sptep - sp->spt) & ~(PTE_PREFETCH_NUM - 1);
-
-	if (PTTYPE == 32)
-		offset = sp->role.quadrant << PT64_LEVEL_BITS;
-
-	first_pte_gpa = gfn_to_gpa(sp->gfn) +
-				(offset + i) * sizeof(pt_element_t);
-
-	if (kvm_read_guest_atomic(vcpu->kvm, first_pte_gpa, gptep,
-					sizeof(gptep)) < 0)
-		return;
-
 	spte = sp->spt + i;
 
 	for (i = 0; i < PTE_PREFETCH_NUM; i++, spte++) {
@@ -462,7 +464,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	mmu_set_spte(vcpu, it.sptep, access, gw->pte_access & access,
 		     user_fault, write_fault, dirty, ptwrite, it.level,
 		     gw->gfn, pfn, false, true);
-	FNAME(pte_prefetch)(vcpu, it.sptep);
+	FNAME(pte_prefetch)(vcpu, gw, it.sptep);
 
 	return it.sptep;
 
-- 
1.7.0.4


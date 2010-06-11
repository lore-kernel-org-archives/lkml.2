Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290Ab0FKNbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 09:31:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54990 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756353Ab0FKNbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 09:31:48 -0400
Message-ID: <4C1239EE.3090904@cn.fujitsu.com>
Date: Fri, 11 Jun 2010 21:28:14 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 1/7] KVM: MMU: rename 'page' and 'shadow_page' to 'sp'
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename 'page' and 'shadow_page' to 'sp' to better fit the context

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 6cd318d..8d00bb2 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -253,7 +253,7 @@ err:
 	return 0;
 }
 
-static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
+static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			      u64 *spte, const void *pte)
 {
 	pt_element_t gpte;
@@ -264,7 +264,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 	gpte = *(const pt_element_t *)pte;
 	if (~gpte & (PT_PRESENT_MASK | PT_ACCESSED_MASK)) {
 		if (!is_present_gpte(gpte)) {
-			if (page->unsync)
+			if (sp->unsync)
 				new_spte = shadow_trap_nonpresent_pte;
 			else
 				new_spte = shadow_notrap_nonpresent_pte;
@@ -273,7 +273,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 		return;
 	}
 	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
-	pte_access = page->role.access & FNAME(gpte_access)(vcpu, gpte);
+	pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
 	if (gpte_to_gfn(gpte) != vcpu->arch.update_pte.gfn)
 		return;
 	pfn = vcpu->arch.update_pte.pfn;
@@ -286,7 +286,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 	 * we call mmu_set_spte() with reset_host_protection = true beacuse that
 	 * vcpu->arch.update_pte.pfn was fetched from get_user_pages(write = 1).
 	 */
-	mmu_set_spte(vcpu, spte, page->role.access, pte_access, 0, 0,
+	mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
 		     gpte & PT_DIRTY_MASK, NULL, PT_PAGE_TABLE_LEVEL,
 		     gpte_to_gfn(gpte), pfn, true, true);
 }
@@ -300,7 +300,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			 int *ptwrite, pfn_t pfn)
 {
 	unsigned access = gw->pt_access;
-	struct kvm_mmu_page *shadow_page;
+	struct kvm_mmu_page *sp;
 	u64 spte, *sptep = NULL;
 	int direct;
 	gfn_t table_gfn;
@@ -341,30 +341,30 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 				access &= ~ACC_WRITE_MASK;
 			/*
 			 * It is a large guest pages backed by small host pages,
-			 * So we set @direct(@shadow_page->role.direct)=1, and
-			 * set @table_gfn(@shadow_page->gfn)=the base page frame
-			 * for linear translations.
+			 * So we set @direct(@sp->role.direct)=1, and set
+			 * @table_gfn(@sp->gfn)=the base page frame for linear
+			 * translations.
 			 */
 			table_gfn = gw->gfn & ~(KVM_PAGES_PER_HPAGE(level) - 1);
 		} else {
 			direct = 0;
 			table_gfn = gw->table_gfn[level - 2];
 		}
-		shadow_page = kvm_mmu_get_page(vcpu, table_gfn, addr, level-1,
+		sp = kvm_mmu_get_page(vcpu, table_gfn, addr, level-1,
 					       direct, access, sptep);
 		if (!direct) {
 			r = kvm_read_guest_atomic(vcpu->kvm,
 						  gw->pte_gpa[level - 2],
 						  &curr_pte, sizeof(curr_pte));
 			if (r || curr_pte != gw->ptes[level - 2]) {
-				kvm_mmu_put_page(shadow_page, sptep);
+				kvm_mmu_put_page(sp, sptep);
 				kvm_release_pfn_clean(pfn);
 				sptep = NULL;
 				break;
 			}
 		}
 
-		spte = __pa(shadow_page->spt)
+		spte = __pa(sp->spt)
 			| PT_PRESENT_MASK | PT_ACCESSED_MASK
 			| PT_WRITABLE_MASK | PT_USER_MASK;
 		*sptep = spte;
-- 
1.6.1.2


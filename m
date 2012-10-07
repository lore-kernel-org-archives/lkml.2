Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab2JGMFX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 08:05:23 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:50756 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2JGMFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 08:05:17 -0400
Message-ID: <50716FF7.1060704@linux.vnet.ibm.com>
Date: Sun, 07 Oct 2012 20:05:11 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v4 5/5] KVM: MMU: introduce FNAME(prefetch_gpte)
References: <50716EE0.6010504@linux.vnet.ibm.com>
In-Reply-To: <50716EE0.6010504@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12100712-0260-0000-0000-000001F1F0A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only difference between FNAME(update_pte) and FNAME(pte_prefetch)
is that the former is allowed to prefetch gfn from dirty logged slot,
so introduce a common function to prefetch spte

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/paging_tmpl.h |   55 +++++++++++++++++++------------------------
 1 files changed, 24 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 36a80ed..f887e4c 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -305,31 +305,43 @@ static int FNAME(walk_addr_nested)(struct guest_walker *walker,
 					addr, access);
 }

-static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			      u64 *spte, const void *pte)
+static bool
+FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+		     u64 *spte, pt_element_t gpte, bool no_dirty_log)
 {
-	pt_element_t gpte;
 	unsigned pte_access;
+	gfn_t gfn;
 	pfn_t pfn;

-	gpte = *(const pt_element_t *)pte;
 	if (prefetch_invalid_gpte(vcpu, sp, spte, gpte))
-		return;
+		return false;

 	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
+
+	gfn = gpte_to_gfn(gpte);
 	pte_access = sp->role.access & gpte_access(vcpu, gpte);
 	protect_clean_gpte(&pte_access, gpte);
-	pfn = gfn_to_pfn_atomic(vcpu->kvm, gpte_to_gfn(gpte));
+	pfn = pte_prefetch_gfn_to_pfn(vcpu, gfn,
+			no_dirty_log && (pte_access & ACC_WRITE_MASK));
 	if (is_invalid_pfn(pfn))
-		return;
+		return false;

 	/*
-	 * we call mmu_set_spte() with host_writable = true because that
-	 * vcpu->arch.update_pte.pfn was fetched from get_user_pages(write = 1).
+	 * we call mmu_set_spte() with host_writable = true because
+	 * pte_prefetch_gfn_to_pfn always gets a writable pfn.
 	 */
 	mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
-		     NULL, PT_PAGE_TABLE_LEVEL,
-		     gpte_to_gfn(gpte), pfn, true, true);
+		     NULL, PT_PAGE_TABLE_LEVEL, gfn, pfn, true, true);
+
+	return true;
+}
+
+static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+			      u64 *spte, const void *pte)
+{
+	pt_element_t gpte = *(const pt_element_t *)pte;
+
+	FNAME(prefetch_gpte)(vcpu, sp, spte, gpte, false);
 }

 static bool FNAME(gpte_changed)(struct kvm_vcpu *vcpu,
@@ -375,33 +387,14 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 	spte = sp->spt + i;

 	for (i = 0; i < PTE_PREFETCH_NUM; i++, spte++) {
-		pt_element_t gpte;
-		unsigned pte_access;
-		gfn_t gfn;
-		pfn_t pfn;
-
 		if (spte == sptep)
 			continue;

 		if (is_shadow_present_pte(*spte))
 			continue;

-		gpte = gptep[i];
-
-		if (prefetch_invalid_gpte(vcpu, sp, spte, gpte))
-			continue;
-
-		pte_access = sp->role.access & gpte_access(vcpu, gpte);
-		protect_clean_gpte(&pte_access, gpte);
-		gfn = gpte_to_gfn(gpte);
-		pfn = pte_prefetch_gfn_to_pfn(vcpu, gfn,
-				      pte_access & ACC_WRITE_MASK);
-		if (is_invalid_pfn(pfn))
+		if (!FNAME(prefetch_gpte)(vcpu, sp, spte, gptep[i], true))
 			break;
-
-		mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
-			     NULL, PT_PAGE_TABLE_LEVEL, gfn,
-			     pfn, true, true);
 	}
 }

-- 
1.7.7.6


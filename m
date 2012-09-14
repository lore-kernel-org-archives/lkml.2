Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab2INJ7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 05:59:53 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:48407 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab2INJ7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 05:59:51 -0400
Message-ID: <5053000E.3050303@linux.vnet.ibm.com>
Date: Fri, 14 Sep 2012 17:59:42 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 5/5] KVM: MMU: introduce FNAME(prefetch_gpte)
References: <5052FF61.3070600@linux.vnet.ibm.com>
In-Reply-To: <5052FF61.3070600@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12091409-5564-0000-0000-000004765685
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only different thing between FNAME(update_pte) and FNAME(pte_prefetch)
is that the former is allowed to prefetch gfn from dirty logged slot, so
introduce a common function to prefetch spte

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/paging_tmpl.h |   50 ++++++++++++++++---------------------------
 1 files changed, 19 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 1a738c5..9742eab 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -356,35 +356,45 @@ no_present:
 	return true;
 }

-static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			      u64 *spte, const void *pte)
+static void
+FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+		     u64 *spte, pt_element_t gpte, bool no_dirty_log)
 {
-	pt_element_t gpte;
 	unsigned pte_access;
+	gfn_t gfn;
 	pfn_t pfn;

-	gpte = *(const pt_element_t *)pte;
 	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
 		return;

 	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
+
+	gfn = gpte_to_gfn(gpte);
 	pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte, true);
-	pfn = gfn_to_pfn_atomic(vcpu->kvm, gpte_to_gfn(gpte));
+	pfn = pte_prefetch_gfn_to_pfn(vcpu, gfn,
+			no_dirty_log && (pte_access & ACC_WRITE_MASK));
 	if (mmu_invalid_pfn(pfn))
 		return;

 	/*
 	 * we call mmu_set_spte() with host_writable = true because that
-	 * vcpu->arch.update_pte.pfn was fetched from get_user_pages(write = 1).
+	 * pte_prefetch_gfn_to_pfn always gets a writable pfn.
 	 */
 	mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
-		     NULL, PT_PAGE_TABLE_LEVEL,
-		     gpte_to_gfn(gpte), pfn, true, true);
+		     NULL, PT_PAGE_TABLE_LEVEL, gfn, pfn, true, true);

 	if (!is_error_pfn(pfn))
 		kvm_release_pfn_clean(pfn);
 }

+static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+			      u64 *spte, const void *pte)
+{
+	pt_element_t gpte = *(const pt_element_t *)pte;
+
+	return FNAME(prefetch_gpte)(vcpu, sp, spte, gpte, false);
+}
+
 static bool FNAME(gpte_changed)(struct kvm_vcpu *vcpu,
 				struct guest_walker *gw, int level)
 {
@@ -428,35 +438,13 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
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
-		if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
-			continue;
-
-		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte,
-								  true);
-		gfn = gpte_to_gfn(gpte);
-		pfn = pte_prefetch_gfn_to_pfn(vcpu, gfn,
-				      pte_access & ACC_WRITE_MASK);
-		if (mmu_invalid_pfn(pfn))
-			break;
-
-		mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
-			     NULL, PT_PAGE_TABLE_LEVEL, gfn,
-			     pfn, true, true);
-		if (!is_error_pfn(pfn))
-			kvm_release_pfn_clean(pfn);
+		return FNAME(prefetch_gpte)(vcpu, sp, spte, gptep[i], true);
 	}
 }

-- 
1.7.7.6


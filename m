Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779Ab2C2JWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:22:36 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:47613 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab2C2JW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:22:28 -0400
Message-ID: <4F7429C7.9030307@linux.vnet.ibm.com>
Date: Thu, 29 Mar 2012 17:22:15 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 03/13] KVM: MMU: split FNAME(prefetch_invalid_gpte)
References: <4F742951.7080003@linux.vnet.ibm.com>
In-Reply-To: <4F742951.7080003@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12032909-2000-0000-0000-000006F452E2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split FNAME(prefetch_invalid_gpte) to check gpte independently which will
be used in the later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/paging_tmpl.h |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 1561028..b9fd1c4 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -337,24 +337,29 @@ static int FNAME(walk_addr_nested)(struct guest_walker *walker,
 					addr, access);
 }

-static bool FNAME(prefetch_invalid_gpte)(struct kvm_vcpu *vcpu,
-				    struct kvm_mmu_page *sp, u64 *spte,
-				    pt_element_t gpte)
+static bool FNAME(invalid_gpte)(struct kvm_vcpu *vcpu, pt_element_t gpte)
 {
 	if (is_rsvd_bits_set(&vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL))
-		goto no_present;
+		return true;

 	if (!is_present_gpte(gpte))
-		goto no_present;
+		return true;

 	if (!(gpte & PT_ACCESSED_MASK))
-		goto no_present;
+		return true;

 	return false;
+}

-no_present:
-	drop_spte(vcpu->kvm, spte);
-	return true;
+static bool FNAME(prefetch_invalid_gpte)(struct kvm_vcpu *vcpu,
+					 u64 *spte, pt_element_t gpte)
+{
+	if (FNAME(invalid_gpte)(vcpu, gpte)) {
+		drop_spte(vcpu->kvm, spte);
+		return true;
+	}
+
+	return false;
 }

 static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
@@ -365,7 +370,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	pfn_t pfn;

 	gpte = *(const pt_element_t *)pte;
-	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
+	if (FNAME(prefetch_invalid_gpte)(vcpu, spte, gpte))
 		return;

 	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
@@ -441,7 +446,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,

 		gpte = gptep[i];

-		if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
+		if (FNAME(prefetch_invalid_gpte)(vcpu, spte, gpte))
 			continue;

 		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte,
@@ -792,7 +797,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 					  sizeof(pt_element_t)))
 			return -EINVAL;

-		if (FNAME(prefetch_invalid_gpte)(vcpu, sp, &sp->spt[i], gpte)) {
+		if (FNAME(prefetch_invalid_gpte)(vcpu, &sp->spt[i], gpte)) {
 			vcpu->kvm->tlbs_dirty++;
 			continue;
 		}
-- 
1.7.7.6


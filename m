Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab2IUHAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 03:00:00 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:42609 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab2IUG76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 02:59:58 -0400
Message-ID: <505C1066.2010208@linux.vnet.ibm.com>
Date: Fri, 21 Sep 2012 14:59:50 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 6/7] KVM: MMU: move prefetch_invalid_gpte out of pagaing_tmp.h
References: <505C0FA8.5070007@linux.vnet.ibm.com>
In-Reply-To: <505C0FA8.5070007@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12092106-5564-0000-0000-0000048EB8BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function does not depend on guest mmu mode, move it out from
paging_tmpl.h

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c         |   36 ++++++++++++++++++++++++++++--------
 arch/x86/kvm/paging_tmpl.h |   24 ++----------------------
 2 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index bc1cda4..a455c0d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2503,6 +2503,14 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 	mmu_free_roots(vcpu);
 }

+static bool is_rsvd_bits_set(struct kvm_mmu *mmu, u64 gpte, int level)
+{
+	int bit7;
+
+	bit7 = (gpte >> 7) & 1;
+	return (gpte & mmu->rsvd_bits_mask[bit7][level-1]) != 0;
+}
+
 static pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
 				     bool no_dirty_log)
 {
@@ -2515,6 +2523,26 @@ static pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return gfn_to_pfn_memslot_atomic(slot, gfn);
 }

+static bool prefetch_invalid_gpte(struct kvm_vcpu *vcpu,
+				  struct kvm_mmu_page *sp, u64 *spte,
+				  u64 gpte)
+{
+	if (is_rsvd_bits_set(&vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL))
+		goto no_present;
+
+	if (!is_present_gpte(gpte))
+		goto no_present;
+
+	if (!(gpte & PT_ACCESSED_MASK))
+		goto no_present;
+
+	return false;
+
+no_present:
+	drop_spte(vcpu->kvm, spte);
+	return true;
+}
+
 static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 				    struct kvm_mmu_page *sp,
 				    u64 *start, u64 *end)
@@ -3396,14 +3424,6 @@ static void paging_free(struct kvm_vcpu *vcpu)
 	nonpaging_free(vcpu);
 }

-static bool is_rsvd_bits_set(struct kvm_mmu *mmu, u64 gpte, int level)
-{
-	int bit7;
-
-	bit7 = (gpte >> 7) & 1;
-	return (gpte & mmu->rsvd_bits_mask[bit7][level-1]) != 0;
-}
-
 static bool sync_mmio_spte(u64 *sptep, gfn_t gfn, unsigned access,
 			   int *nr_present)
 {
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 5b1af72..298e5c2 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -336,26 +336,6 @@ static int FNAME(walk_addr_nested)(struct guest_walker *walker,
 					addr, access);
 }

-static bool FNAME(prefetch_invalid_gpte)(struct kvm_vcpu *vcpu,
-				    struct kvm_mmu_page *sp, u64 *spte,
-				    pt_element_t gpte)
-{
-	if (is_rsvd_bits_set(&vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL))
-		goto no_present;
-
-	if (!is_present_gpte(gpte))
-		goto no_present;
-
-	if (!(gpte & PT_ACCESSED_MASK))
-		goto no_present;
-
-	return false;
-
-no_present:
-	drop_spte(vcpu->kvm, spte);
-	return true;
-}
-
 static bool
 FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		     u64 *spte, pt_element_t gpte, bool no_dirty_log)
@@ -364,7 +344,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	gfn_t gfn;
 	pfn_t pfn;

-	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
+	if (prefetch_invalid_gpte(vcpu, sp, spte, gpte))
 		return false;

 	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
@@ -778,7 +758,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 					  sizeof(pt_element_t)))
 			return -EINVAL;

-		if (FNAME(prefetch_invalid_gpte)(vcpu, sp, &sp->spt[i], gpte)) {
+		if (prefetch_invalid_gpte(vcpu, sp, &sp->spt[i], gpte)) {
 			vcpu->kvm->tlbs_dirty++;
 			continue;
 		}
-- 
1.7.7.6


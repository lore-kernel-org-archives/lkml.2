Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab2G2ITM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 04:19:12 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:57183 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab2G2ITF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 04:19:05 -0400
Message-ID: <5014F1F2.3020202@linux.vnet.ibm.com>
Date: Sun, 29 Jul 2012 16:18:58 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 8/9] KVM: do not release the error pfn
References: <5014F053.8020305@linux.vnet.ibm.com>
In-Reply-To: <5014F053.8020305@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072908-5816-0000-0000-000003C63233
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit a2766325cf9f9, the error pfn is replaced by the
error code, it need not be released anymore

[ The patch is compiling tested for powerpc ]

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/powerpc/kvm/e500_tlb.c |    1 -
 arch/x86/kvm/mmu.c          |    6 +++---
 arch/x86/kvm/mmu_audit.c    |    4 +---
 arch/x86/kvm/paging_tmpl.h  |    8 ++------
 virt/kvm/iommu.c            |    1 -
 virt/kvm/kvm_main.c         |   14 ++++++++------
 6 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/kvm/e500_tlb.c b/arch/powerpc/kvm/e500_tlb.c
index c8f6c58..09ce5ac 100644
--- a/arch/powerpc/kvm/e500_tlb.c
+++ b/arch/powerpc/kvm/e500_tlb.c
@@ -524,7 +524,6 @@ static inline void kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 		if (is_error_pfn(pfn)) {
 			printk(KERN_ERR "Couldn't get real page for gfn %lx!\n",
 					(long)gfn);
-			kvm_release_pfn_clean(pfn);
 			return;
 		}

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 320a781..949a5b8 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2498,7 +2498,9 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 				rmap_recycle(vcpu, sptep, gfn);
 		}
 	}
-	kvm_release_pfn_clean(pfn);
+
+	if (!is_error_pfn(pfn))
+		kvm_release_pfn_clean(pfn);
 }

 static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
@@ -3275,8 +3277,6 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 	if (!async)
 		return false; /* *pfn has correct page already */

-	kvm_release_pfn_clean(*pfn);
-
 	if (!prefault && can_do_async_pf(vcpu)) {
 		trace_kvm_try_async_get_page(gva, gfn);
 		if (kvm_find_async_pf_gfn(vcpu, gfn)) {
diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index 7d7d0b9..bac5fa4 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -116,10 +116,8 @@ static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 	gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
 	pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);

-	if (is_error_pfn(pfn)) {
-		kvm_release_pfn_clean(pfn);
+	if (is_error_pfn(pfn))
 		return;
-	}

 	hpa =  pfn << PAGE_SHIFT;
 	if ((*sptep & PT64_BASE_ADDR_MASK) != hpa)
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index bb7cf01..bf8c42b 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -370,10 +370,8 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
 	pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte, true);
 	pfn = gfn_to_pfn_atomic(vcpu->kvm, gpte_to_gfn(gpte));
-	if (mmu_invalid_pfn(pfn)) {
-		kvm_release_pfn_clean(pfn);
+	if (mmu_invalid_pfn(pfn))
 		return;
-	}

 	/*
 	 * we call mmu_set_spte() with host_writable = true because that
@@ -448,10 +446,8 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 		gfn = gpte_to_gfn(gpte);
 		pfn = pte_prefetch_gfn_to_pfn(vcpu, gfn,
 				      pte_access & ACC_WRITE_MASK);
-		if (mmu_invalid_pfn(pfn)) {
-			kvm_release_pfn_clean(pfn);
+		if (mmu_invalid_pfn(pfn))
 			break;
-		}

 		mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
 			     NULL, PT_PAGE_TABLE_LEVEL, gfn,
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 6a67bea..037cb67 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -107,7 +107,6 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 		 */
 		pfn = kvm_pin_pages(slot, gfn, page_size);
 		if (is_error_pfn(pfn)) {
-			kvm_release_pfn_clean(pfn);
 			gfn += 1;
 			continue;
 		}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f09f48a..0c29714 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -102,9 +102,6 @@ static bool largepages_enabled = true;

 bool kvm_is_mmio_pfn(pfn_t pfn)
 {
-	if (is_error_pfn(pfn))
-		return false;
-
 	if (pfn_valid(pfn)) {
 		int reserved;
 		struct page *tail = pfn_to_page(pfn);
@@ -1174,10 +1171,13 @@ EXPORT_SYMBOL_GPL(gfn_to_page_many_atomic);

 static struct page *kvm_pfn_to_page(pfn_t pfn)
 {
-	WARN_ON(kvm_is_mmio_pfn(pfn));
+	if (is_error_pfn(pfn))
+		return kvm_bad_page;

-	if (is_error_pfn(pfn) || kvm_is_mmio_pfn(pfn))
+	if (kvm_is_mmio_pfn(pfn)) {
+		WARN_ON(1);
 		return kvm_bad_page;
+	}

 	return pfn_to_page(pfn);
 }
@@ -1202,7 +1202,9 @@ EXPORT_SYMBOL_GPL(kvm_release_page_clean);

 void kvm_release_pfn_clean(pfn_t pfn)
 {
-	if (!is_error_pfn(pfn) && !kvm_is_mmio_pfn(pfn))
+	WARN_ON(is_error_pfn(pfn));
+
+	if (!kvm_is_mmio_pfn(pfn))
 		put_page(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);
-- 
1.7.7.6


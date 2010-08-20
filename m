Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab0HTBLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 21:11:14 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58946 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab0HTBLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 21:11:13 -0400
From: "Tim Pepper" <lnxninja@linux.vnet.ibm.com>
Date: Thu, 19 Aug 2010 18:11:05 -0700
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: [PATCH 1/4 v2] kvm: abstract kvm x86 mmu->n_free_mmu_pages
Message-ID: <20100820011104.GB11297@tpepper-t61p.dolavim.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Hansen <dave@linux.vnet.ibm.com>

[PATCH 1/4 v2] kvm: abstract kvm x86 mmu->n_free_mmu_pages

First of all, I think "free" is a poor name for this value.  In
this context, it means, "the number of mmu pages which this kvm
instance should be able to allocate."  To me, "free" implies
much more that the objects are there and ready for use.  I think
"available" is a much better description, especially when you
see how it is calculated.

In this patch, we abstract its use into a function.  We'll soon
replace the function's contents by calculating the value in a
different way.

All of the reads of n_free_mmu_pages are taken care of in this
patch.  The modification sites will be handled in a patch
later in the series.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---

  arch/x86/kvm/mmu.c              |   11 ++++-------
  arch/x86/kvm/mmu.h              |    7 ++++++-
  2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 311f6da..3c15d10 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1672,7 +1672,7 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages)
 	int used_pages;
 	LIST_HEAD(invalid_list);
 
-	used_pages = kvm->arch.n_alloc_mmu_pages - kvm->arch.n_free_mmu_pages;
+	used_pages = kvm->arch.n_alloc_mmu_pages - kvm_mmu_available_pages(kvm);
 	used_pages = max(0, used_pages);
 
 	/*
@@ -2937,18 +2937,15 @@ EXPORT_SYMBOL_GPL(kvm_mmu_unprotect_page_virt);
 
 void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 {
-	int free_pages;
 	LIST_HEAD(invalid_list);
 
-	free_pages = vcpu->kvm->arch.n_free_mmu_pages;
-	while (free_pages < KVM_REFILL_PAGES &&
+	while (kvm_mmu_available_pages(vcpu->kvm) < KVM_REFILL_PAGES &&
 	       !list_empty(&vcpu->kvm->arch.active_mmu_pages)) {
 		struct kvm_mmu_page *sp;
 
 		sp = container_of(vcpu->kvm->arch.active_mmu_pages.prev,
 				  struct kvm_mmu_page, link);
-		free_pages += kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
-						       &invalid_list);
+		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, &invalid_list);
 		++vcpu->kvm->stat.mmu_recycled;
 	}
 	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
@@ -3123,7 +3120,7 @@ static int mmu_shrink(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask)
 		idx = srcu_read_lock(&kvm->srcu);
 		spin_lock(&kvm->mmu_lock);
 		npages = kvm->arch.n_alloc_mmu_pages -
-			 kvm->arch.n_free_mmu_pages;
+			 kvm_mmu_available_pages(kvm);
 		cache_count += npages;
 		if (!kvm_freed && nr_to_scan > 0 && npages > 0) {
 			freed_pages = kvm_mmu_remove_some_alloc_mmu_pages(kvm,
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index be66759..c3a689a 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -50,9 +50,14 @@
 
 int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4]);
 
+static inline unsigned int kvm_mmu_available_pages(struct kvm *kvm)
+{
+	return kvm->arch.n_free_mmu_pages;
+}
+
 static inline void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(vcpu->kvm->arch.n_free_mmu_pages < KVM_MIN_FREE_MMU_PAGES))
+	if (unlikely(kvm_mmu_available_pages(vcpu->kvm)< KVM_MIN_FREE_MMU_PAGES))
 		__kvm_mmu_free_some_pages(vcpu);
 }
 

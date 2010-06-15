Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab0FONzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:55:33 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:42602 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab0FONza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:55:30 -0400
Subject: [RFC][PATCH 1/9] abstract kvm x86 mmu->n_free_mmu_pages
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Tue, 15 Jun 2010 06:55:19 -0700
References: <20100615135518.BC244431@kernel.beaverton.ibm.com>
In-Reply-To: <20100615135518.BC244431@kernel.beaverton.ibm.com>
Message-Id: <20100615135519.00781795@kernel.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


First of all, I think "free" is a poor name for this value.  In
this context, it means, "the number of mmu pages which this kvm
instance should be able to allocate."  To me, "free" implies
much more that the objects are there and ready for use.  I think
"available" is a much better description, especially when you
see how it is calculated.

In this patch, we abstract its use into a function.  We'll soon
replace the function's contents by calculating the value in a
different way.


Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/x86/kvm/mmu.c |    6 +++---
 linux-2.6.git-dave/arch/x86/kvm/mmu.h |    7 ++++++-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff -puN arch/x86/kvm/mmu.c~abstract_kvm_free_mmu_pages arch/x86/kvm/mmu.c
--- linux-2.6.git/arch/x86/kvm/mmu.c~abstract_kvm_free_mmu_pages	2010-06-09 15:14:28.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/kvm/mmu.c	2010-06-09 15:14:28.000000000 -0700
@@ -1522,7 +1522,7 @@ void kvm_mmu_change_mmu_pages(struct kvm
 {
 	int used_pages;
 
-	used_pages = kvm->arch.n_alloc_mmu_pages - kvm->arch.n_free_mmu_pages;
+	used_pages = kvm->arch.n_alloc_mmu_pages - kvm_mmu_available_pages(kvm);
 	used_pages = max(0, used_pages);
 
 	/*
@@ -2752,7 +2752,7 @@ EXPORT_SYMBOL_GPL(kvm_mmu_unprotect_page
 
 void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 {
-	while (vcpu->kvm->arch.n_free_mmu_pages < KVM_REFILL_PAGES &&
+	while (kvm_mmu_available_pages(vcpu->kvm) < KVM_REFILL_PAGES &&
 	       !list_empty(&vcpu->kvm->arch.active_mmu_pages)) {
 		struct kvm_mmu_page *sp;
 
@@ -2933,7 +2933,7 @@ static int mmu_shrink(int nr_to_scan, gf
 		idx = srcu_read_lock(&kvm->srcu);
 		spin_lock(&kvm->mmu_lock);
 		npages = kvm->arch.n_alloc_mmu_pages -
-			 kvm->arch.n_free_mmu_pages;
+			 kvm_mmu_available_pages(kvm);
 		cache_count += npages;
 		if (!kvm_freed && nr_to_scan > 0 && npages > 0) {
 			freed_pages = kvm_mmu_remove_some_alloc_mmu_pages(kvm);
diff -puN arch/x86/kvm/mmu.h~abstract_kvm_free_mmu_pages arch/x86/kvm/mmu.h
--- linux-2.6.git/arch/x86/kvm/mmu.h~abstract_kvm_free_mmu_pages	2010-06-09 15:14:28.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/kvm/mmu.h	2010-06-09 15:14:28.000000000 -0700
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
 
_

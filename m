Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab0FONza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:55:30 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36268 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab0FONz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:55:27 -0400
Subject: [RFC][PATCH 5/9] break out some mmu_skrink() code
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Tue, 15 Jun 2010 06:55:24 -0700
References: <20100615135518.BC244431@kernel.beaverton.ibm.com>
In-Reply-To: <20100615135518.BC244431@kernel.beaverton.ibm.com>
Message-Id: <20100615135524.8C3300E8@kernel.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This basically takes the loop contents and sticks it in
its own function for readability.  Don't pay too much
attention to the use of nr_scanned in here.  It's a bit
wonky but it'll change in a minute anyway.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/x86/kvm/mmu.c |   35 ++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff -puN arch/x86/kvm/mmu.c~optimize_shrinker arch/x86/kvm/mmu.c
--- linux-2.6.git/arch/x86/kvm/mmu.c~optimize_shrinker	2010-06-09 15:14:30.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/kvm/mmu.c	2010-06-09 15:14:30.000000000 -0700
@@ -2923,6 +2923,26 @@ static int kvm_mmu_remove_some_alloc_mmu
 	return kvm_mmu_zap_page(kvm, page) + 1;
 }
 
+static int shrink_kvm_mmu(struct kvm *kvm, int nr_to_scan)
+{
+	int idx, freed_pages;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	spin_lock(&kvm->mmu_lock);
+	if (kvm->arch.n_used_mmu_pages > 0)
+		freed_pages = kvm_mmu_remove_some_alloc_mmu_pages(kvm);
+
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	/*
+	 * This should optimally return the number of objects (mmu pages)
+	 * that we have scanned.  But, for now, just return the number
+	 * that we were able to free.
+	 */
+	return freed_pages;
+}
+
 static int mmu_shrink(int nr_to_scan, gfp_t gfp_mask)
 {
 	struct kvm *kvm;
@@ -2934,20 +2954,15 @@ static int mmu_shrink(int nr_to_scan, gf
 	spin_lock(&kvm_lock);
 
 	list_for_each_entry(kvm, &vm_list, vm_list) {
-		int idx, freed_pages;
+		if (nr_to_scan <= 0)
+			break;
 
-		idx = srcu_read_lock(&kvm->srcu);
-		spin_lock(&kvm->mmu_lock);
-		if (!kvm_freed && nr_to_scan > 0 &&
-		    kvm->arch.n_used_mmu_pages > 0) {
-			freed_pages = kvm_mmu_remove_some_alloc_mmu_pages(kvm);
+		shrink_kvm_mmu(kvm, nr_to_scan);
+		if (!kvm_freed)
 			kvm_freed = kvm;
-		}
 		nr_to_scan--;
-
-		spin_unlock(&kvm->mmu_lock);
-		srcu_read_unlock(&kvm->srcu, idx);
 	}
+
 	if (kvm_freed)
 		list_move_tail(&kvm_freed->vm_list, &vm_list);
 
_

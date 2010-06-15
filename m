Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774Ab0FONzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:55:46 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:38008 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757742Ab0FONzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:55:43 -0400
Subject: [RFC][PATCH 4/9] create aggregate kvm_total_used_mmu_pages value
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Tue, 15 Jun 2010 06:55:23 -0700
References: <20100615135518.BC244431@kernel.beaverton.ibm.com>
In-Reply-To: <20100615135518.BC244431@kernel.beaverton.ibm.com>
Message-Id: <20100615135523.25D24A73@kernel.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Note: this is the real meat of the patch set.  It can be applied up
to this point, and everything will probably be improved, at least
a bit.

Of slab shrinkers, the VM code says:

 * Note that 'shrink' will be passed nr_to_scan == 0 when the VM is
 * querying the cache size, so a fastpath for that case is appropriate.

and it *means* it.  Look at how it calls the shrinkers:

	nr_before = (*shrinker->shrink)(0, gfp_mask);
	shrink_ret = (*shrinker->shrink)(this_scan, gfp_mask);

So, if you do anything stupid in your shrinker, the VM will doubly
punish you.

The mmu_shrink() function takes the global kvm_lock, then acquires
every VM's kvm->mmu_lock in sequence.  If we have 100 VMs, then
we're going to take 101 locks.  We do it twice, so each call takes
202 locks.  If we're under memory pressure, we can have each cpu
trying to do this.  It can get really hairy, and we've seen lock
spinning in mmu_shrink() be the dominant entry in profiles.

This is guaranteed to optimize at least half of those lock
aquisitions away.  It removes the need to take any of the locks
when simply trying to count objects.


Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/x86/kvm/mmu.c |   33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff -puN arch/x86/kvm/mmu.c~make_global_used_value arch/x86/kvm/mmu.c
--- linux-2.6.git/arch/x86/kvm/mmu.c~make_global_used_value	2010-06-09 15:14:30.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/kvm/mmu.c	2010-06-09 15:14:30.000000000 -0700
@@ -891,6 +891,19 @@ static int is_empty_shadow_page(u64 *spt
 }
 #endif
 
+/*
+ * This value is the sum of all of the kvm instances's
+ * kvm->arch.n_used_mmu_pages values.  We need a global,
+ * aggregate version in order to make the slab shrinker
+ * faster
+ */
+static unsigned int kvm_total_used_mmu_pages;
+static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
+{
+	kvm->arch.n_used_mmu_pages += nr;
+	kvm_total_used_mmu_pages += nr;
+}
+
 static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	ASSERT(is_empty_shadow_page(sp->spt));
@@ -898,7 +911,7 @@ static void kvm_mmu_free_page(struct kvm
 	__free_page(virt_to_page(sp->spt));
 	__free_page(virt_to_page(sp->gfns));
 	kfree(sp);
-	--kvm->arch.n_used_mmu_pages;
+	kvm_mod_used_mmu_pages(kvm, -1);
 }
 
 static unsigned kvm_page_table_hashfn(gfn_t gfn)
@@ -919,7 +932,7 @@ static struct kvm_mmu_page *kvm_mmu_allo
 	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
 	sp->multimapped = 0;
 	sp->parent_pte = parent_pte;
-	++vcpu->kvm->arch.n_used_mmu_pages;
+	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
 	return sp;
 }
 
@@ -2914,21 +2927,20 @@ static int mmu_shrink(int nr_to_scan, gf
 {
 	struct kvm *kvm;
 	struct kvm *kvm_freed = NULL;
-	int cache_count = 0;
+
+	if (nr_to_scan == 0)
+		goto out;
 
 	spin_lock(&kvm_lock);
 
 	list_for_each_entry(kvm, &vm_list, vm_list) {
-		int npages, idx, freed_pages;
+		int idx, freed_pages;
 
 		idx = srcu_read_lock(&kvm->srcu);
 		spin_lock(&kvm->mmu_lock);
-		npages = kvm->arch.n_max_mmu_pages -
-			 kvm_mmu_available_pages(kvm);
-		cache_count += npages;
-		if (!kvm_freed && nr_to_scan > 0 && npages > 0) {
+		if (!kvm_freed && nr_to_scan > 0 &&
+		    kvm->arch.n_used_mmu_pages > 0) {
 			freed_pages = kvm_mmu_remove_some_alloc_mmu_pages(kvm);
-			cache_count -= freed_pages;
 			kvm_freed = kvm;
 		}
 		nr_to_scan--;
@@ -2941,7 +2953,8 @@ static int mmu_shrink(int nr_to_scan, gf
 
 	spin_unlock(&kvm_lock);
 
-	return cache_count;
+out:
+	return kvm_total_used_mmu_pages;
 }
 
 static struct shrinker mmu_shrinker = {
_

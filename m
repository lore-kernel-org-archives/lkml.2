Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab0HTBLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 21:11:44 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50608 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab0HTBLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 21:11:41 -0400
From: "Tim Pepper" <lnxninja@linux.vnet.ibm.com>
Date: Thu, 19 Aug 2010 18:11:37 -0700
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: [PATCH 4/4 v2] kvm: create aggregate kvm_total_used_mmu_pages value
Message-ID: <20100820011136.GE11297@tpepper-t61p.dolavim.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Hansen <dave@linux.vnet.ibm.com>

[PATCH 4/4 v2] kvm: create aggregate kvm_total_used_mmu_pages value

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

A 'percpu_counter' can be a large object, but we only have one
of these for the entire system.  There are not any better
alternatives at the moment, especially ones that handle CPU
hotplug.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---

  arch/x86/kvm/mmu.c |   34 ++++++++++++++++++++++++----------
  1 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e890c6e..f83b941 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -178,6 +178,7 @@ typedef void (*mmu_parent_walk_fn) (struct kvm_mmu_page *sp, u64 *spte);
 static struct kmem_cache *pte_chain_cache;
 static struct kmem_cache *rmap_desc_cache;
 static struct kmem_cache *mmu_page_header_cache;
+static struct percpu_counter kvm_total_used_mmu_pages;
 
 static u64 __read_mostly shadow_trap_nonpresent_pte;
 static u64 __read_mostly shadow_notrap_nonpresent_pte;
@@ -947,6 +948,18 @@ static int is_empty_shadow_page(u64 *spt)
 }
 #endif
 
+/*
+ * This value is the sum of all of the kvm instances's
+ * kvm->arch.n_used_mmu_pages values.  We need a global,
+ * aggregate version in order to make the slab shrinker
+ * faster
+ */
+static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
+{
+	kvm->arch.n_used_mmu_pages += nr;
+	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
+}
+
 static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	ASSERT(is_empty_shadow_page(sp->spt));
@@ -956,7 +969,7 @@ static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	if (!sp->role.direct)
 		__free_page(virt_to_page(sp->gfns));
 	kmem_cache_free(mmu_page_header_cache, sp);
-	--kvm->arch.n_used_mmu_pages;
+	kvm_mod_used_mmu_pages(kvm, -1);
 }
 
 static unsigned kvm_page_table_hashfn(gfn_t gfn)
@@ -979,7 +992,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
 	sp->multimapped = 0;
 	sp->parent_pte = parent_pte;
-	++vcpu->kvm->arch.n_used_mmu_pages;
+	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
 	return sp;
 }
 
@@ -3100,23 +3113,22 @@ static int mmu_shrink(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask)
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
 		LIST_HEAD(invalid_list);
 
 		idx = srcu_read_lock(&kvm->srcu);
 		spin_lock(&kvm->mmu_lock);
-		npages = kvm->arch.n_max_mmu_pages -
-			 kvm_mmu_available_pages(kvm);
-		cache_count += npages;
-		if (!kvm_freed && nr_to_scan > 0 && npages > 0) {
+		if (!kvm_freed && nr_to_scan > 0 &&
+		    kvm->arch.n_used_mmu_pages > 0) {
 			freed_pages = kvm_mmu_remove_some_alloc_mmu_pages(kvm,
 							  &invalid_list);
-			cache_count -= freed_pages;
 			kvm_freed = kvm;
 		}
 		nr_to_scan--;
@@ -3130,7 +3142,8 @@ static int mmu_shrink(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask)
 
 	spin_unlock(&kvm_lock);
 
-	return cache_count;
+out:
+	return percpu_counter_read_positive(&kvm_total_used_mmu_pages);
 }
 
 static struct shrinker mmu_shrinker = {
@@ -3173,6 +3186,7 @@ int kvm_mmu_module_init(void)
 	if (!mmu_page_header_cache)
 		goto nomem;
 
+	percpu_counter_init(&kvm_total_used_mmu_pages, 0);
 	register_shrinker(&mmu_shrinker);
 
 	return 0;

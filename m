Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab0HTBLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 21:11:36 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34042 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab0HTBLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 21:11:32 -0400
From: "Tim Pepper" <lnxninja@linux.vnet.ibm.com>
Date: Thu, 19 Aug 2010 18:11:28 -0700
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: [PATCH 3/4 v2] kvm: replace x86 kvm n_free_mmu_pages with
 n_used_mmu_pages
Message-ID: <20100820011127.GD11297@tpepper-t61p.dolavim.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Hansen <dave@linux.vnet.ibm.com>

[PATCH 3/4 v2] kvm: replace x86 kvm n_free_mmu_pages with n_used_mmu_pages

I think doing this makes the code much more readable.  That's
borne out by the fact that this patch removes code.  "used"
also happens to be the number that we need to return back to
the slab code when our shrinker gets called.  Keeping this
value as opposed to free makes the next patch simpler.

So, 'struct kvm' is kzalloc()'d.  'struct kvm_arch' is a
structure member (and not a pointer) of 'struct kvm'.  That
means they start out zeroed.  I _think_ they get initialized
properly by kvm_mmu_change_mmu_pages().  But, that only happens
via kvm ioctls.

I have a suspicion that they values are actually inconsistent
until those ioctls get called; "free" and "alloc" are both zero.
But, the VM can't really get run until these ioctl()s get called
anyway.  There are also some checks for negative "used_pages"
values which confused me.  It might all tie together.

Anyway, another benefit of storing 'used' intead of 'free' is
that the values are consistent from the moment the structure is
allocated: no negative "used" value.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---

  arch/x86/include/asm/kvm_host.h |    2 +-
  arch/x86/kvm/mmu.c              |   27 +++++++++------------------
  arch/x86/kvm/mmu.h              |    3 ++-
  3 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f0f02cf..87eb392 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -367,7 +367,7 @@ struct kvm_vcpu_arch {
 };
 
 struct kvm_arch {
-	unsigned int n_free_mmu_pages;
+	unsigned int n_used_mmu_pages;
 	unsigned int n_requested_mmu_pages;
 	unsigned int n_max_mmu_pages;
 	atomic_t invlpg_counter;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 02e414d..e890c6e 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -956,7 +956,7 @@ static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	if (!sp->role.direct)
 		__free_page(virt_to_page(sp->gfns));
 	kmem_cache_free(mmu_page_header_cache, sp);
-	++kvm->arch.n_free_mmu_pages;
+	--kvm->arch.n_used_mmu_pages;
 }
 
 static unsigned kvm_page_table_hashfn(gfn_t gfn)
@@ -979,7 +979,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
 	sp->multimapped = 0;
 	sp->parent_pte = parent_pte;
-	--vcpu->kvm->arch.n_free_mmu_pages;
+	++vcpu->kvm->arch.n_used_mmu_pages;
 	return sp;
 }
 
@@ -1665,41 +1665,32 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 
 /*
  * Changing the number of mmu pages allocated to the vm
- * Note: if kvm_nr_mmu_pages is too small, you will get dead lock
+ * Note: if goal_nr_mmu_pages is too small, you will get dead lock
  */
-void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages)
+void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int goal_nr_mmu_pages)
 {
-	int used_pages;
 	LIST_HEAD(invalid_list);
-
-	used_pages = kvm->arch.n_max_mmu_pages - kvm_mmu_available_pages(kvm);
-	used_pages = max(0, used_pages);
-
 	/*
 	 * If we set the number of mmu pages to be smaller be than the
 	 * number of actived pages , we must to free some mmu pages before we
 	 * change the value
 	 */
 
-	if (used_pages > kvm_nr_mmu_pages) {
-		while (used_pages > kvm_nr_mmu_pages &&
+	if (kvm->arch.n_used_mmu_pages > goal_nr_mmu_pages) {
+		while (kvm->arch.n_used_mmu_pages > goal_nr_mmu_pages &&
 			!list_empty(&kvm->arch.active_mmu_pages)) {
 			struct kvm_mmu_page *page;
 
 			page = container_of(kvm->arch.active_mmu_pages.prev,
 					    struct kvm_mmu_page, link);
-			used_pages -= kvm_mmu_prepare_zap_page(kvm, page,
+			kvm_mmu_prepare_zap_page(kvm, page,
 							       &invalid_list);
 		}
 		kvm_mmu_commit_zap_page(kvm, &invalid_list);
-		kvm_nr_mmu_pages = used_pages;
-		kvm->arch.n_free_mmu_pages = 0;
+		goal_nr_mmu_pages = kvm->arch.n_used_mmu_pages;
 	}
-	else
-		kvm->arch.n_free_mmu_pages += kvm_nr_mmu_pages
-					 - kvm->arch.n_max_mmu_pages;
 
-	kvm->arch.n_max_mmu_pages = kvm_nr_mmu_pages;
+	kvm->arch.n_max_mmu_pages = goal_nr_mmu_pages;
 }
 
 static int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index c3a689a..f05a03d 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -52,7 +52,8 @@ int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4]);
 
 static inline unsigned int kvm_mmu_available_pages(struct kvm *kvm)
 {
-	return kvm->arch.n_free_mmu_pages;
+	return kvm->arch.n_max_mmu_pages -
+		kvm->arch.n_used_mmu_pages;
 }
 
 static inline void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)

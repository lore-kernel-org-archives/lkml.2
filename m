Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744Ab0FONzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:55:43 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:56254 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157Ab0FONzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:55:36 -0400
Subject: [RFC][PATCH 3/9] replace x86 kvm n_free_mmu_pages with n_used_mmu_pages
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Tue, 15 Jun 2010 06:55:22 -0700
References: <20100615135518.BC244431@kernel.beaverton.ibm.com>
In-Reply-To: <20100615135518.BC244431@kernel.beaverton.ibm.com>
Message-Id: <20100615135522.892D6BFE@kernel.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
---

 linux-2.6.git-dave/arch/x86/include/asm/kvm_host.h |    2 -
 linux-2.6.git-dave/arch/x86/kvm/mmu.c              |   29 +++++++--------------
 linux-2.6.git-dave/arch/x86/kvm/mmu.h              |    3 +-
 3 files changed, 13 insertions(+), 21 deletions(-)

diff -puN arch/x86/include/asm/kvm_host.h~replace-free-with-used arch/x86/include/asm/kvm_host.h
--- linux-2.6.git/arch/x86/include/asm/kvm_host.h~replace-free-with-used	2010-06-09 15:14:29.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/include/asm/kvm_host.h	2010-06-09 15:14:29.000000000 -0700
@@ -380,7 +380,7 @@ struct kvm_mem_aliases {
 struct kvm_arch {
 	struct kvm_mem_aliases *aliases;
 
-	unsigned int n_free_mmu_pages;
+	unsigned int n_used_mmu_pages;
 	unsigned int n_requested_mmu_pages;
 	unsigned int n_max_mmu_pages;
 	atomic_t invlpg_counter;
diff -puN arch/x86/kvm/mmu.c~replace-free-with-used arch/x86/kvm/mmu.c
--- linux-2.6.git/arch/x86/kvm/mmu.c~replace-free-with-used	2010-06-09 15:14:29.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/kvm/mmu.c	2010-06-09 15:14:29.000000000 -0700
@@ -898,7 +898,7 @@ static void kvm_mmu_free_page(struct kvm
 	__free_page(virt_to_page(sp->spt));
 	__free_page(virt_to_page(sp->gfns));
 	kfree(sp);
-	++kvm->arch.n_free_mmu_pages;
+	--kvm->arch.n_used_mmu_pages;
 }
 
 static unsigned kvm_page_table_hashfn(gfn_t gfn)
@@ -919,7 +919,7 @@ static struct kvm_mmu_page *kvm_mmu_allo
 	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
 	sp->multimapped = 0;
 	sp->parent_pte = parent_pte;
-	--vcpu->kvm->arch.n_free_mmu_pages;
+	++vcpu->kvm->arch.n_used_mmu_pages;
 	return sp;
 }
 
@@ -1516,39 +1516,30 @@ static int kvm_mmu_zap_page(struct kvm *
 
 /*
  * Changing the number of mmu pages allocated to the vm
- * Note: if kvm_nr_mmu_pages is too small, you will get dead lock
+ * Note: if goal_nr_mmu_pages is too small, you will get dead lock
  */
-void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages)
+void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int goal_nr_mmu_pages)
 {
-	int used_pages;
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
-			used_pages -= kvm_mmu_zap_page(kvm, page);
-			used_pages--;
+			kvm->arch.n_used_mmu_pages -= kvm_mmu_zap_page(kvm, page);
+			kvm->arch.n_used_mmu_pages--;
 		}
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
diff -puN arch/x86/kvm/mmu.h~replace-free-with-used arch/x86/kvm/mmu.h
--- linux-2.6.git/arch/x86/kvm/mmu.h~replace-free-with-used	2010-06-09 15:14:29.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/kvm/mmu.h	2010-06-09 15:14:29.000000000 -0700
@@ -52,7 +52,8 @@ int kvm_mmu_get_spte_hierarchy(struct kv
 
 static inline unsigned int kvm_mmu_available_pages(struct kvm *kvm)
 {
-	return kvm->arch.n_free_mmu_pages;
+	return kvm->arch.n_max_mmu_pages -
+		kvm->arch.n_used_mmu_pages;
 }
 
 static inline void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
_

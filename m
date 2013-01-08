Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab3AHKoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 05:44:55 -0500
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:36793 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab3AHKox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 05:44:53 -0500
Date: Tue, 8 Jan 2013 19:45:28 +0900
From: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
To: mtosatti@redhat.com, gleb@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] KVM: Remove unused slot_bitmap from kvm_mmu_page
Message-Id: <20130108194528.bed5eaaf.yoshikawa_takuya_b1@lab.ntt.co.jp>
In-Reply-To: <20130108194238.09ebc8bd.yoshikawa_takuya_b1@lab.ntt.co.jp>
References: <20130108194238.09ebc8bd.yoshikawa_takuya_b1@lab.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not needed any more.

Signed-off-by: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
---
 Documentation/virtual/kvm/mmu.txt |    7 -------
 arch/x86/include/asm/kvm_host.h   |    5 -----
 arch/x86/kvm/mmu.c                |   10 ----------
 3 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
index fa5f1db..43fcb76 100644
--- a/Documentation/virtual/kvm/mmu.txt
+++ b/Documentation/virtual/kvm/mmu.txt
@@ -187,13 +187,6 @@ Shadow pages contain the following information:
     perform a reverse map from a pte to a gfn. When role.direct is set, any
     element of this array can be calculated from the gfn field when used, in
     this case, the array of gfns is not allocated. See role.direct and gfn.
-  slot_bitmap:
-    A bitmap containing one bit per memory slot.  If the page contains a pte
-    mapping a page from memory slot n, then bit n of slot_bitmap will be set
-    (if a page is aliased among several slots, then it is not guaranteed that
-    all slots will be marked).
-    Used during dirty logging to avoid scanning a shadow page if none if its
-    pages need tracking.
   root_count:
     A counter keeping track of how many hardware registers (guest cr3 or
     pdptrs) are now pointing at the page.  While this counter is nonzero, the
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c431b33..f75e1fe 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -219,11 +219,6 @@ struct kvm_mmu_page {
 	u64 *spt;
 	/* hold the gfn of each spte inside spt */
 	gfn_t *gfns;
-	/*
-	 * One bit set per slot which has memory
-	 * in this shadow page.
-	 */
-	DECLARE_BITMAP(slot_bitmap, KVM_MEM_SLOTS_NUM);
 	bool unsync;
 	int root_count;          /* Currently serving as active root */
 	unsigned int unsync_children;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b4d4fd1..bb964b3 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1522,7 +1522,6 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 		sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
-	bitmap_zero(sp->slot_bitmap, KVM_MEM_SLOTS_NUM);
 	sp->parent_ptes = 0;
 	mmu_page_add_parent_pte(vcpu, sp, parent_pte);
 	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
@@ -2183,14 +2182,6 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_unprotect_page);
 
-static void page_header_update_slot(struct kvm *kvm, void *pte, gfn_t gfn)
-{
-	int slot = memslot_id(kvm, gfn);
-	struct kvm_mmu_page *sp = page_header(__pa(pte));
-
-	__set_bit(slot, sp->slot_bitmap);
-}
-
 /*
  * The function is based on mtrr_type_lookup() in
  * arch/x86/kernel/cpu/mtrr/generic.c
@@ -2497,7 +2488,6 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		++vcpu->kvm->stat.lpages;
 
 	if (is_shadow_present_pte(*sptep)) {
-		page_header_update_slot(vcpu->kvm, sptep, gfn);
 		if (!was_rmapped) {
 			rmap_count = rmap_add(vcpu, sptep, gfn);
 			if (rmap_count > RMAP_RECYCLE_THRESHOLD)
-- 
1.7.5.4


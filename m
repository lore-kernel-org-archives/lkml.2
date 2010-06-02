Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab0FBIxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 04:53:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51987 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755447Ab0FBIxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 04:53:37 -0400
Message-ID: <4C061C16.9040208@cn.fujitsu.com>
Date: Wed, 02 Jun 2010 16:53:42 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: [PATCH] kvm: rework remove-write-access for a slot
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code uses slot_bitmap to find ptes who map a page
from the memory slot, it is not precise: some ptes in the shadow page
are not map any page from the memory slot.

This patch uses rmap to find the ptes precisely, and remove
the unused slot_bitmap.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/Documentation/kvm/mmu.txt b/Documentation/kvm/mmu.txt
index 1e7ecdd..d749399 100644
--- a/Documentation/kvm/mmu.txt
+++ b/Documentation/kvm/mmu.txt
@@ -183,13 +183,6 @@ Shadow pages contain the following information:
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
index 0cd0f29..bf4f198 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -197,11 +197,6 @@ struct kvm_mmu_page {
 	u64 *spt;
 	/* hold the gfn of each spte inside spt */
 	gfn_t *gfns;
-	/*
-	 * One bit set per slot which has memory
-	 * in this shadow page.
-	 */
-	DECLARE_BITMAP(slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
 	bool multimapped;         /* More than one parent_pte? */
 	bool unsync;
 	int root_count;          /* Currently serving as active root */
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c16c4ca..e097e81 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -941,7 +941,6 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 						  PAGE_SIZE);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
-	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
 	sp->multimapped = 0;
 	sp->parent_pte = parent_pte;
 	--vcpu->kvm->arch.n_free_mmu_pages;
@@ -1660,14 +1659,6 @@ restart:
 	}
 }
 
-static void page_header_update_slot(struct kvm *kvm, void *pte, gfn_t gfn)
-{
-	int slot = memslot_id(kvm, gfn);
-	struct kvm_mmu_page *sp = page_header(__pa(pte));
-
-	__set_bit(slot, sp->slot_bitmap);
-}
-
 static void mmu_convert_notrap(struct kvm_mmu_page *sp)
 {
 	int i;
@@ -1979,7 +1970,6 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (!was_rmapped && is_large_pte(*sptep))
 		++vcpu->kvm->stat.lpages;
 
-	page_header_update_slot(vcpu->kvm, sptep, gfn);
 	if (!was_rmapped) {
 		rmap_count = rmap_add(vcpu, sptep, gfn);
 		kvm_release_pfn_clean(pfn);
@@ -2975,22 +2965,38 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 	mmu_free_memory_caches(vcpu);
 }
 
+static void rmapp_remove_write_access(struct kvm *kvm, unsigned long *rmapp)
+{
+	u64 *spte = rmap_next(kvm, rmapp, NULL);
+
+	while (spte) {
+		/* avoid RMW */
+		if (is_writable_pte(*spte))
+			*spte &= ~PT_WRITABLE_MASK;
+		spte = rmap_next(kvm, rmapp, spte);
+	}
+}
+
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 {
-	struct kvm_mmu_page *sp;
+	int i;
+	unsigned long gfn_offset;
+	struct kvm_memslots *slots = kvm_memslots(kvm);
+	struct kvm_memory_slot *memslot = &slots->memslots[slot];
 
-	list_for_each_entry(sp, &kvm->arch.active_mmu_pages, link) {
-		int i;
-		u64 *pt;
+	for (gfn_offset = 0; gfn_offset < memslot->npages; gfn_offset++) {
+		rmapp_remove_write_access(kvm, &memslot->rmap[gfn_offset]);
 
-		if (!test_bit(slot, sp->slot_bitmap))
-			continue;
+		for (i = 0; i < KVM_NR_PAGE_SIZES - 1; i++) {
+			unsigned long gfn = memslot->base_gfn + gfn_offset;
+			unsigned long huge = KVM_PAGES_PER_HPAGE(i + 2);
+			int idx = gfn / huge - memslot->base_gfn / huge;
 
-		pt = sp->spt;
-		for (i = 0; i < PT64_ENT_PER_PAGE; ++i)
-			/* avoid RMW */
-			if (is_writable_pte(pt[i]))
-				pt[i] &= ~PT_WRITABLE_MASK;
+			if (!(gfn_offset || (gfn % huge)))
+				break;
+			rmapp_remove_write_access(kvm,
+					&memslot->lpage_info[i][idx].rmap_pde);
+		}
 	}
 	kvm_flush_remote_tlbs(kvm);
 }

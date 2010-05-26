Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934280Ab0EZIuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 04:50:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61899 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934048Ab0EZIuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 04:50:07 -0400
Message-ID: <4BFCE0B7.1090105@cn.fujitsu.com>
Date: Wed, 26 May 2010 16:49:59 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: [RESEND PATCH 3/3 V2] kvm mmu: reduce 50% memory usage
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I think users will enable tdp when their hardwares support ept or npt.
This patch can reduce about 50% kvm mmu memory usage for they.

This simple patch use the fact that:

When sp->role.direct is set, sp->gfns does not contain any essential
information, leaf sptes reachable from this sp are for a continuate
guest physical memory range(a linear range).
So sp->gfns[i](if it was set) equals to sp->gfn + i. (PT_PAGE_TABLE_LEVEL)
Obviously, it is not essential information, we can calculate it when need.

It means we don't need sp->gfns when sp->role.direct=1,
Thus we can save one page usage for every kvm_mmu_page.

Note:
Access to sp->gfns must be wrapped by kvm_mmu_page_get_gfn()
or kvm_mmu_page_set_gfn().
It is only exposed in FNAME(sync_page).

Changed from v1:
 Add comments for @gfns in Documentation/kvm/mmu.txt

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 mmu.c         |   38 +++++++++++++++++++++++++++++---------
 paging_tmpl.h |    3 +++
 2 files changed, 32 insertions(+), 9 deletions(-)
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ddfa865..a5c6719 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -393,6 +393,22 @@ static void mmu_free_rmap_desc(struct kvm_rmap_desc *rd)
 	kfree(rd);
 }
 
+static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
+{
+	if (!sp->role.direct)
+		return sp->gfns[index];
+
+	return sp->gfn + (index << ((sp->role.level - 1) * PT64_LEVEL_BITS));
+}
+
+static void kvm_mmu_page_set_gfn(struct kvm_mmu_page *sp, int index, gfn_t gfn)
+{
+	if (sp->role.direct)
+		BUG_ON(gfn != kvm_mmu_page_get_gfn(sp, index));
+	else
+		sp->gfns[index] = gfn;
+}
+
 /*
  * Return the pointer to the largepage write count for a given
  * gfn, handling slots that are not large page aligned.
@@ -543,7 +559,7 @@ static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 		return count;
 	gfn = unalias_gfn(vcpu->kvm, gfn);
 	sp = page_header(__pa(spte));
-	sp->gfns[spte - sp->spt] = gfn;
+	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
 	rmapp = gfn_to_rmap(vcpu->kvm, gfn, sp->role.level);
 	if (!*rmapp) {
 		rmap_printk("rmap_add: %p %llx 0->1\n", spte, *spte);
@@ -601,6 +617,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	struct kvm_rmap_desc *prev_desc;
 	struct kvm_mmu_page *sp;
 	pfn_t pfn;
+	gfn_t gfn;
 	unsigned long *rmapp;
 	int i;
 
@@ -612,7 +629,8 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 		kvm_set_pfn_accessed(pfn);
 	if (is_writable_pte(*spte))
 		kvm_set_pfn_dirty(pfn);
-	rmapp = gfn_to_rmap(kvm, sp->gfns[spte - sp->spt], sp->role.level);
+	gfn = kvm_mmu_page_get_gfn(sp, spte - sp->spt);
+	rmapp = gfn_to_rmap(kvm, gfn, sp->role.level);
 	if (!*rmapp) {
 		printk(KERN_ERR "rmap_remove: %p %llx 0->BUG\n", spte, *spte);
 		BUG();
@@ -896,7 +914,8 @@ static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	ASSERT(is_empty_shadow_page(sp->spt));
 	list_del(&sp->link);
 	__free_page(virt_to_page(sp->spt));
-	__free_page(virt_to_page(sp->gfns));
+	if (!sp->role.direct)
+		__free_page(virt_to_page(sp->gfns));
 	kfree(sp);
 	++kvm->arch.n_free_mmu_pages;
 }
@@ -907,13 +926,15 @@ static unsigned kvm_page_table_hashfn(gfn_t gfn)
 }
 
 static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
-					       u64 *parent_pte)
+					       u64 *parent_pte, int direct)
 {
 	struct kvm_mmu_page *sp;
 
 	sp = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache, sizeof *sp);
 	sp->spt = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache, PAGE_SIZE);
-	sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache, PAGE_SIZE);
+	if (!direct)
+		sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache,
+						  PAGE_SIZE);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
 	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
@@ -1347,7 +1368,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			return sp;
 		}
 	++vcpu->kvm->stat.mmu_cache_miss;
-	sp = kvm_mmu_alloc_page(vcpu, parent_pte);
+	sp = kvm_mmu_alloc_page(vcpu, parent_pte, direct);
 	if (!sp)
 		return sp;
 	sp->gfn = gfn;
@@ -3314,7 +3335,7 @@ void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
 
 	if (*sptep & PT_WRITABLE_MASK) {
 		rev_sp = page_header(__pa(sptep));
-		gfn = rev_sp->gfns[sptep - rev_sp->spt];
+		gfn = kvm_mmu_page_get_gfn(rev_sp, sptep - rev_sp->spt);
 
 		if (!gfn_to_memslot(kvm, gfn)) {
 			if (!printk_ratelimit())
@@ -3328,8 +3349,7 @@ void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
 			return;
 		}
 
-		rmapp = gfn_to_rmap(kvm, rev_sp->gfns[sptep - rev_sp->spt],
-				    rev_sp->role.level);
+		rmapp = gfn_to_rmap(kvm, gfn, rev_sp->role.level);
 		if (!*rmapp) {
 			if (!printk_ratelimit())
 				return;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index d0cc07e..702c016 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -576,6 +576,9 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 
 	offset = nr_present = 0;
 
+	/* direct kvm_mmu_page can not be unsync. */
+	BUG_ON(sp->role.direct);
+
 	if (PTTYPE == 32)
 		offset = sp->role.quadrant << PT64_LEVEL_BITS;
 
diff --git a/Documentation/kvm/mmu.txt b/Documentation/kvm/mmu.txt
index da04671..aec19ae 100644
--- a/Documentation/kvm/mmu.txt
+++ b/Documentation/kvm/mmu.txt
@@ -178,7 +178,9 @@ Shadow pages contain the following information:
     guest pages as leaves.
   gfns:
     An array of 512 guest frame numbers, one for each present pte.  Used to
-    perform a reverse map from a pte to a gfn.
+    perform a reverse map from a pte to a gfn. When role.direct is set, any
+    element of this array can be calculated from the gfn field when used, in
+    this case, the array of gfns is not allocated. See role.direct and gfn.
   slot_bitmap:
     A bitmap containing one bit per memory slot.  If the page contains a pte
     mapping a page from memory slot n, then bit n of slot_bitmap will be set




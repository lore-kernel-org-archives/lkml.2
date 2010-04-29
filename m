Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933857Ab0D3S1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:27:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933165Ab0D3RWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:22:09 -0400
Date: Thu, 29 Apr 2010 15:09:55 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [PATCH] kvm mmu: reduce 50% memory usage
Message-ID: <20100429180955.GA17909@amt.cnet>
References: <4BD8228D.7090708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD8228D.7090708@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 07:57:01PM +0800, Lai Jiangshan wrote:
> 
> I think users will enable tdp when their hardwares support ept or npt.
> This patch can reduce about 50% kvm mmu memory usage for they.
> 
> This simple patch use the fact that:
> 
> When sp->role.direct is set, sp->gfns does not contain any essential
> information, leaf sptes reachable from this sp are for a continuate
> guest physical memory range(a linear range).
> So sp->gfns[i](if it was set) equals to sp->gfn + i. (PT_PAGE_TABLE_LEVEL)
> Obviously, it is not essential information, we can calculate it when need.
> 
> It means we don't need sp->gfns when sp->role.direct=1,
> Thus we can save one page usage for every kvm_mmu_page.
> 
> Note:
> Access to sp->gfns must be wrapped by kvm_mmu_page_get_gfn()
> or kvm_mmu_page_set_gfn().
> It is only exposed in FNAME(sync_page).

Lai,

You missed quadrant on 4mb large page emulation with shadow (see updated
patch below). Also for some reason i can't understand the assumption
does not hold for large sptes with TDP, so reverted for now.

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3266d73..a9edfdb 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -393,6 +393,27 @@ static void mmu_free_rmap_desc(struct kvm_rmap_desc *rd)
 	kfree(rd);
 }
 
+static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
+{
+	gfn_t gfn;
+
+	if (!sp->role.direct)
+		return sp->gfns[index];
+
+	gfn = sp->gfn + index * (1 << (sp->role.level - 1) * PT64_LEVEL_BITS);
+	gfn += sp->role.quadrant << PT64_LEVEL_BITS;
+
+	return gfn;
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
@@ -543,7 +564,7 @@ static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 		return count;
 	gfn = unalias_gfn(vcpu->kvm, gfn);
 	sp = page_header(__pa(spte));
-	sp->gfns[spte - sp->spt] = gfn;
+	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
 	rmapp = gfn_to_rmap(vcpu->kvm, gfn, sp->role.level);
 	if (!*rmapp) {
 		rmap_printk("rmap_add: %p %llx 0->1\n", spte, *spte);
@@ -601,6 +622,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	struct kvm_rmap_desc *prev_desc;
 	struct kvm_mmu_page *sp;
 	pfn_t pfn;
+	gfn_t gfn;
 	unsigned long *rmapp;
 	int i;
 
@@ -612,7 +634,8 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 		kvm_set_pfn_accessed(pfn);
 	if (is_writable_pte(*spte))
 		kvm_set_pfn_dirty(pfn);
-	rmapp = gfn_to_rmap(kvm, sp->gfns[spte - sp->spt], sp->role.level);
+	gfn = kvm_mmu_page_get_gfn(sp, spte - sp->spt);
+	rmapp = gfn_to_rmap(kvm, gfn, sp->role.level);
 	if (!*rmapp) {
 		printk(KERN_ERR "rmap_remove: %p %llx 0->BUG\n", spte, *spte);
 		BUG();
@@ -896,7 +919,8 @@ static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	ASSERT(is_empty_shadow_page(sp->spt));
 	list_del(&sp->link);
 	__free_page(virt_to_page(sp->spt));
-	__free_page(virt_to_page(sp->gfns));
+	if (!sp->role.direct)
+		__free_page(virt_to_page(sp->gfns));
 	kfree(sp);
 	++kvm->arch.n_free_mmu_pages;
 }
@@ -907,13 +931,15 @@ static unsigned kvm_page_table_hashfn(gfn_t gfn)
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
@@ -1352,7 +1378,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	if (role.direct)
 		role.cr4_pae = 0;
 	role.access = access;
-	if (vcpu->arch.mmu.root_level <= PT32_ROOT_LEVEL) {
+	if (vcpu->arch.mmu.root_level == PT32_ROOT_LEVEL) {
 		quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
 		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
 		role.quadrant = quadrant;
@@ -1379,7 +1405,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			return sp;
 		}
 	++vcpu->kvm->stat.mmu_cache_miss;
-	sp = kvm_mmu_alloc_page(vcpu, parent_pte);
+	sp = kvm_mmu_alloc_page(vcpu, parent_pte, direct);
 	if (!sp)
 		return sp;
 	sp->gfn = gfn;
@@ -3371,7 +3399,7 @@ void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
 
 	if (*sptep & PT_WRITABLE_MASK) {
 		rev_sp = page_header(__pa(sptep));
-		gfn = rev_sp->gfns[sptep - rev_sp->spt];
+		gfn = kvm_mmu_page_get_gfn(rev_sp, sptep - rev_sp->spt);
 
 		if (!gfn_to_memslot(kvm, gfn)) {
 			if (!printk_ratelimit())
@@ -3385,8 +3413,7 @@ void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
 			return;
 		}
 
-		rmapp = gfn_to_rmap(kvm, rev_sp->gfns[sptep - rev_sp->spt],
-				    rev_sp->role.level);
+		rmapp = gfn_to_rmap(kvm, gfn, rev_sp->role.level);
 		if (!*rmapp) {
 			if (!printk_ratelimit())
 				return;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 624b38f..2091590 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -592,6 +592,9 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 
 	offset = nr_present = 0;
 
+	/* direct kvm_mmu_page can not be unsync. */
+	BUG_ON(sp->role.direct);
+
 	if (PTTYPE == 32)
 		offset = sp->role.quadrant << PT64_LEVEL_BITS;
 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254Ab1ENVms (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 17:42:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63934 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754689Ab1ENVmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 17:42:46 -0400
Message-ID: <4DCEF7C2.401@cn.fujitsu.com>
Date: Sun, 15 May 2011 05:44:34 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 5/7] KVM: MMU: remove the arithmetic of parent pte rmap
References: <4DCEF5B1.3050706@cn.fujitsu.com>
In-Reply-To: <4DCEF5B1.3050706@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-15 05:42:57,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-15 05:42:57,
	Serialize complete at 2011-05-15 05:42:57
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parent pte rmap and page rmap are very similar, so use the same arithmetic for
them

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    7 +--
 arch/x86/kvm/mmu.c              |  178 ++++++++++-----------------------------
 2 files changed, 45 insertions(+), 140 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d2e5fb8..71c0b86 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -227,14 +227,10 @@ struct kvm_mmu_page {
 	 * in this shadow page.
 	 */
 	DECLARE_BITMAP(slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
-	bool multimapped;         /* More than one parent_pte? */
 	bool unsync;
 	int root_count;          /* Currently serving as active root */
 	unsigned int unsync_children;
-	union {
-		u64 *parent_pte;               /* !multimapped */
-		struct hlist_head parent_ptes; /* multimapped, kvm_pte_chain */
-	};
+	unsigned long rmap;	/* Rmap for parent_pte */
 	DECLARE_BITMAP(unsync_child_bitmap, 512);
 };
 
@@ -346,7 +342,6 @@ struct kvm_vcpu_arch {
 	 * put it here to avoid allocation */
 	struct kvm_pv_mmu_op_buffer mmu_op_buffer;
 
-	struct kvm_mmu_memory_cache mmu_pte_chain_cache;
 	struct kvm_mmu_memory_cache mmu_rmap_desc_cache;
 	struct kvm_mmu_memory_cache mmu_page_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8da77b3..b68f42c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -182,8 +182,6 @@ struct kvm_shadow_walk_iterator {
 	     shadow_walk_okay(&(_walker));			\
 	     shadow_walk_next(&(_walker)))
 
-typedef void (*mmu_parent_walk_fn) (struct kvm_mmu_page *sp, u64 *spte);
-
 static struct kmem_cache *pte_chain_cache;
 static struct kmem_cache *rmap_desc_cache;
 static struct kmem_cache *mmu_page_header_cache;
@@ -397,12 +395,8 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 {
 	int r;
 
-	r = mmu_topup_memory_cache(&vcpu->arch.mmu_pte_chain_cache,
-				   pte_chain_cache, 4);
-	if (r)
-		goto out;
 	r = mmu_topup_memory_cache(&vcpu->arch.mmu_rmap_desc_cache,
-				   rmap_desc_cache, 4 + PTE_PREFETCH_NUM);
+				   rmap_desc_cache, 8 + PTE_PREFETCH_NUM);
 	if (r)
 		goto out;
 	r = mmu_topup_memory_cache_page(&vcpu->arch.mmu_page_cache, 8);
@@ -416,7 +410,6 @@ out:
 
 static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
-	mmu_free_memory_cache(&vcpu->arch.mmu_pte_chain_cache, pte_chain_cache);
 	mmu_free_memory_cache(&vcpu->arch.mmu_rmap_desc_cache, rmap_desc_cache);
 	mmu_free_memory_cache_page(&vcpu->arch.mmu_page_cache);
 	mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache,
@@ -433,17 +426,6 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc,
 	return p;
 }
 
-static struct kvm_pte_chain *mmu_alloc_pte_chain(struct kvm_vcpu *vcpu)
-{
-	return mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_chain_cache,
-				      sizeof(struct kvm_pte_chain));
-}
-
-static void mmu_free_pte_chain(struct kvm_pte_chain *pc)
-{
-	kmem_cache_free(pte_chain_cache, pc);
-}
-
 static struct kvm_rmap_desc *mmu_alloc_rmap_desc(struct kvm_vcpu *vcpu)
 {
 	return mmu_memory_cache_alloc(&vcpu->arch.mmu_rmap_desc_cache,
@@ -634,6 +616,26 @@ static int __rmap_add(struct kvm_vcpu *vcpu, u64 *spte, unsigned long *rmapp)
 	return count;
 }
 
+typedef void (*__rmap_walk_fn) (u64 *spte);
+static void __rmap_walk(unsigned long *rmapp, __rmap_walk_fn fn)
+{
+	struct kvm_rmap_desc *desc;
+	int i;
+
+	if (!*rmapp)
+		return;
+
+	if (!(*rmapp & 1))
+		return fn((u64 *)*rmapp);
+
+	desc = (struct kvm_rmap_desc *)(*rmapp & ~1ul);
+	while (desc) {
+		for (i = 0; i < RMAP_EXT && desc->sptes[i]; ++i)
+			fn(desc->sptes[i]);
+		desc = desc->more;
+	}
+}
+
 static u64 *__rmap_next(unsigned long *rmapp, u64 *spte)
 {
 	struct kvm_rmap_desc *desc;
@@ -1067,134 +1069,52 @@ static unsigned kvm_page_table_hashfn(gfn_t gfn)
 	return gfn & ((1 << KVM_MMU_HASH_SHIFT) - 1);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
-					       u64 *parent_pte, int direct)
-{
-	struct kvm_mmu_page *sp;
-
-	sp = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache, sizeof *sp);
-	sp->spt = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache, PAGE_SIZE);
-	if (!direct)
-		sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache,
-						  PAGE_SIZE);
-	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
-	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
-	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
-	sp->multimapped = 0;
-	sp->parent_pte = parent_pte;
-	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
-	return sp;
-}
-
 static void mmu_page_add_parent_pte(struct kvm_vcpu *vcpu,
 				    struct kvm_mmu_page *sp, u64 *parent_pte)
 {
-	struct kvm_pte_chain *pte_chain;
-	struct hlist_node *node;
-	int i;
-
 	if (!parent_pte)
 		return;
-	if (!sp->multimapped) {
-		u64 *old = sp->parent_pte;
 
-		if (!old) {
-			sp->parent_pte = parent_pte;
-			return;
-		}
-		sp->multimapped = 1;
-		pte_chain = mmu_alloc_pte_chain(vcpu);
-		INIT_HLIST_HEAD(&sp->parent_ptes);
-		hlist_add_head(&pte_chain->link, &sp->parent_ptes);
-		pte_chain->parent_ptes[0] = old;
-	}
-	hlist_for_each_entry(pte_chain, node, &sp->parent_ptes, link) {
-		if (pte_chain->parent_ptes[NR_PTE_CHAIN_ENTRIES-1])
-			continue;
-		for (i = 0; i < NR_PTE_CHAIN_ENTRIES; ++i)
-			if (!pte_chain->parent_ptes[i]) {
-				pte_chain->parent_ptes[i] = parent_pte;
-				return;
-			}
-	}
-	pte_chain = mmu_alloc_pte_chain(vcpu);
-	BUG_ON(!pte_chain);
-	hlist_add_head(&pte_chain->link, &sp->parent_ptes);
-	pte_chain->parent_ptes[0] = parent_pte;
+	__rmap_add(vcpu, parent_pte, &sp->rmap);
 }
 
 static void mmu_page_remove_parent_pte(struct kvm_mmu_page *sp,
 				       u64 *parent_pte)
 {
-	struct kvm_pte_chain *pte_chain;
-	struct hlist_node *node;
-	int i;
-
-	if (!sp->multimapped) {
-		BUG_ON(sp->parent_pte != parent_pte);
-		sp->parent_pte = NULL;
-		return;
-	}
-	hlist_for_each_entry(pte_chain, node, &sp->parent_ptes, link)
-		for (i = 0; i < NR_PTE_CHAIN_ENTRIES; ++i) {
-			if (!pte_chain->parent_ptes[i])
-				break;
-			if (pte_chain->parent_ptes[i] != parent_pte)
-				continue;
-			while (i + 1 < NR_PTE_CHAIN_ENTRIES
-				&& pte_chain->parent_ptes[i + 1]) {
-				pte_chain->parent_ptes[i]
-					= pte_chain->parent_ptes[i + 1];
-				++i;
-			}
-			pte_chain->parent_ptes[i] = NULL;
-			if (i == 0) {
-				hlist_del(&pte_chain->link);
-				mmu_free_pte_chain(pte_chain);
-				if (hlist_empty(&sp->parent_ptes)) {
-					sp->multimapped = 0;
-					sp->parent_pte = NULL;
-				}
-			}
-			return;
-		}
-	BUG();
+	__rmap_remove(parent_pte, &sp->rmap);
 }
 
-static void mmu_parent_walk(struct kvm_mmu_page *sp, mmu_parent_walk_fn fn)
+static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
+					       u64 *parent_pte, int direct)
 {
-	struct kvm_pte_chain *pte_chain;
-	struct hlist_node *node;
-	struct kvm_mmu_page *parent_sp;
-	int i;
-
-	if (!sp->multimapped && sp->parent_pte) {
-		parent_sp = page_header(__pa(sp->parent_pte));
-		fn(parent_sp, sp->parent_pte);
-		return;
-	}
-
-	hlist_for_each_entry(pte_chain, node, &sp->parent_ptes, link)
-		for (i = 0; i < NR_PTE_CHAIN_ENTRIES; ++i) {
-			u64 *spte = pte_chain->parent_ptes[i];
+	struct kvm_mmu_page *sp;
 
-			if (!spte)
-				break;
-			parent_sp = page_header(__pa(spte));
-			fn(parent_sp, spte);
-		}
+	sp = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache, sizeof *sp);
+	sp->spt = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache, PAGE_SIZE);
+	if (!direct)
+		sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache,
+						  PAGE_SIZE);
+	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
+	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
+	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
+	sp->rmap = 0;
+	mmu_page_add_parent_pte(vcpu, sp, parent_pte);
+	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
+	return sp;
 }
 
-static void mark_unsync(struct kvm_mmu_page *sp, u64 *spte);
+static void mark_unsync(u64 *spte);
 static void kvm_mmu_mark_parents_unsync(struct kvm_mmu_page *sp)
 {
-	mmu_parent_walk(sp, mark_unsync);
+	__rmap_walk(&sp->rmap, mark_unsync);
 }
 
-static void mark_unsync(struct kvm_mmu_page *sp, u64 *spte)
+static void mark_unsync(u64 *spte)
 {
+	struct kvm_mmu_page *sp;
 	unsigned int index;
 
+	sp = page_header(__pa(spte));
 	index = spte - sp->spt;
 	if (__test_and_set_bit(index, sp->unsync_child_bitmap))
 		return;
@@ -1692,17 +1612,7 @@ static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	u64 *parent_pte;
 
-	while (sp->multimapped || sp->parent_pte) {
-		if (!sp->multimapped)
-			parent_pte = sp->parent_pte;
-		else {
-			struct kvm_pte_chain *chain;
-
-			chain = container_of(sp->parent_ptes.first,
-					     struct kvm_pte_chain, link);
-			parent_pte = chain->parent_ptes[0];
-		}
-		BUG_ON(!parent_pte);
+	while ((parent_pte = __rmap_next(&sp->rmap, NULL))) {
 		kvm_mmu_put_page(sp, parent_pte);
 		__set_spte(parent_pte, shadow_trap_nonpresent_pte);
 	}
-- 
1.7.4.4


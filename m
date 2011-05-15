Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760085Ab1EOPZW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 11:25:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53093 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756507Ab1EOPZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 11:25:20 -0400
Message-ID: <4DCFF0CC.1000805@cn.fujitsu.com>
Date: Sun, 15 May 2011 23:27:08 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 5/7] KVM: MMU: remove the arithmetic of parent pte rmap
References: <4DCFEF3B.5060806@cn.fujitsu.com>
In-Reply-To: <4DCFEF3B.5060806@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-15 23:25:28,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-15 23:25:29,
	Serialize complete at 2011-05-15 23:25:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parent pte rmap and page rmap are very similar, so use the same arithmetic
for them

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    7 +--
 arch/x86/kvm/mmu.c              |  189 +++++++++-----------------------------
 2 files changed, 46 insertions(+), 150 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0d824e4..e8a68f8 100644
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
+	unsigned long parent_ptes;	/* Reverse mapping for parent_pte */
 	DECLARE_BITMAP(unsync_child_bitmap, 512);
 };
 
@@ -346,7 +342,6 @@ struct kvm_vcpu_arch {
 	 * put it here to avoid allocation */
 	struct kvm_pv_mmu_op_buffer mmu_op_buffer;
 
-	struct kvm_mmu_memory_cache mmu_pte_chain_cache;
 	struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
 	struct kvm_mmu_memory_cache mmu_page_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5ba347b..c0b16dd 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -182,9 +182,6 @@ struct kvm_shadow_walk_iterator {
 	     shadow_walk_okay(&(_walker));			\
 	     shadow_walk_next(&(_walker)))
 
-typedef void (*mmu_parent_walk_fn) (struct kvm_mmu_page *sp, u64 *spte);
-
-static struct kmem_cache *pte_chain_cache;
 static struct kmem_cache *pte_list_desc_cache;
 static struct kmem_cache *mmu_page_header_cache;
 static struct percpu_counter kvm_total_used_mmu_pages;
@@ -397,12 +394,8 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 {
 	int r;
 
-	r = mmu_topup_memory_cache(&vcpu->arch.mmu_pte_chain_cache,
-				   pte_chain_cache, 4);
-	if (r)
-		goto out;
 	r = mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
-				   pte_list_desc_cache, 4 + PTE_PREFETCH_NUM);
+				   pte_list_desc_cache, 8 + PTE_PREFETCH_NUM);
 	if (r)
 		goto out;
 	r = mmu_topup_memory_cache_page(&vcpu->arch.mmu_page_cache, 8);
@@ -416,8 +409,6 @@ out:
 
 static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
-	mmu_free_memory_cache(&vcpu->arch.mmu_pte_chain_cache,
-				pte_chain_cache);
 	mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
 				pte_list_desc_cache);
 	mmu_free_memory_cache_page(&vcpu->arch.mmu_page_cache);
@@ -435,17 +426,6 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc,
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
 static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
 {
 	return mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache,
@@ -721,6 +701,26 @@ static void pte_list_remove(u64 *spte, unsigned long *pte_list)
 	}
 }
 
+typedef void (*pte_list_walk_fn) (u64 *spte);
+static void pte_list_walk(unsigned long *pte_list, pte_list_walk_fn fn)
+{
+	struct pte_list_desc *desc;
+	int i;
+
+	if (!*pte_list)
+		return;
+
+	if (!(*pte_list & 1))
+		return fn((u64 *)*pte_list);
+
+	desc = (struct pte_list_desc *)(*pte_list & ~1ul);
+	while (desc) {
+		for (i = 0; i < PTE_LIST_EXT && desc->sptes[i]; ++i)
+			fn(desc->sptes[i]);
+		desc = desc->more;
+	}
+}
+
 /*
  * Take gfn and return the reverse mapping to it.
  */
@@ -1069,134 +1069,52 @@ static unsigned kvm_page_table_hashfn(gfn_t gfn)
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
+	pte_list_add(vcpu, parent_pte, &sp->parent_ptes);
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
+	pte_list_remove(parent_pte, &sp->parent_ptes);
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
-
-			if (!spte)
-				break;
-			parent_sp = page_header(__pa(spte));
-			fn(parent_sp, spte);
-		}
+	struct kvm_mmu_page *sp;
+	sp = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache,
+					sizeof *sp);
+	sp->spt = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache, PAGE_SIZE);
+	if (!direct)
+		sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache,
+						  PAGE_SIZE);
+	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
+	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
+	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
+	sp->parent_ptes = 0;
+	mmu_page_add_parent_pte(vcpu, sp, parent_pte);
+	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
+	return sp;
 }
 
-static void mark_unsync(struct kvm_mmu_page *sp, u64 *spte);
+static void mark_unsync(u64 *spte);
 static void kvm_mmu_mark_parents_unsync(struct kvm_mmu_page *sp)
 {
-	mmu_parent_walk(sp, mark_unsync);
+	pte_list_walk(&sp->parent_ptes, mark_unsync);
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
@@ -1694,17 +1612,7 @@ static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
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
+	while ((parent_pte = pte_list_next(&sp->parent_ptes, NULL))) {
 		kvm_mmu_put_page(sp, parent_pte);
 		__set_spte(parent_pte, shadow_trap_nonpresent_pte);
 	}
@@ -3616,8 +3524,6 @@ static struct shrinker mmu_shrinker = {
 
 static void mmu_destroy_caches(void)
 {
-	if (pte_chain_cache)
-		kmem_cache_destroy(pte_chain_cache);
 	if (pte_list_desc_cache)
 		kmem_cache_destroy(pte_list_desc_cache);
 	if (mmu_page_header_cache)
@@ -3626,11 +3532,6 @@ static void mmu_destroy_caches(void)
 
 int kvm_mmu_module_init(void)
 {
-	pte_chain_cache = kmem_cache_create("kvm_pte_chain",
-					    sizeof(struct kvm_pte_chain),
-					    0, 0, NULL);
-	if (!pte_chain_cache)
-		goto nomem;
 	pte_list_desc_cache = kmem_cache_create("pte_list_desc",
 					    sizeof(struct pte_list_desc),
 					    0, 0, NULL);
-- 
1.7.4.4


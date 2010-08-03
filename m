Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab0HCC0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 22:26:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62578 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab0HCC0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 22:26:41 -0400
Message-ID: <4C577F45.9030208@cn.fujitsu.com>
Date: Tue, 03 Aug 2010 10:30:29 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: [PATCH] kvm cleanup: Introduce sibling_pte and do cleanup for reverse
 map and parent_pte
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is just a big cleanup. it reduces 220 lines of code.

It introduces sibling_pte array for tracking identical sptes, so the
identical sptes can be linked as a single linked list by their
corresponding sibling_pte. A reverse map or a parent_pte points at
the head of this single linked list. So we can do cleanup for
reverse map and parent_pte VERY LARGELY.

BAD:
  If most rmap have only one entry or most sp have only one parent,
  this patch may use more memory than before.

GOOD:
  1) Reduce a lot of code, The functions which are in hot path becomes
     very very simple and terrifically fast.
  2) rmap_next(): O(N) -> O(1). traveling a ramp: O(N*N) -> O(N)
  3) Remove the ugly interlayer: struct kvm_rmap_desc, struct kvm_pte_chain
  4) We don't need to allocate any thing when we change the mappings.
     So we can avoid allocation when we have held kvm mmu spin lock.
     (this feature is very helpful in future).
  5) better readability.

Signed-of-by: Lai Jiangshan <laijs@cn.fujitsu.com>
 Documentation/kvm/mmu.txt       |   16 +
 arch/x86/include/asm/kvm_host.h |   16 -
 arch/x86/kvm/mmu.c              |  343 +++++++---------------------------------
 3 files changed, 78 insertions(+), 297 deletions(-)
diff --git a/Documentation/kvm/mmu.txt b/Documentation/kvm/mmu.txt
index 142cc51..a8ee119 100644
--- a/Documentation/kvm/mmu.txt
+++ b/Documentation/kvm/mmu.txt
@@ -178,8 +178,13 @@ Shadow pages contain the following information:
     at __pa(sp2->spt).  sp2 will point back at sp1 through parent_pte.
     The spt array forms a DAG structure with the shadow page as a node, and
     guest pages as leaves.
+  sibling_pte:
+    An array of 512 pointers, one for each present pte, every pointer points at
+    a next spte with identical spte. Several identical sptes are linked as
+    a single linked list by their corresponding sibling_pte. A reverse map or
+    a parent_pte points at the head spte of this single linked list.
   gfns:
-    An array of 512 guest frame numbers, one for each present pte.  Used to
+    An array of 512 guest frame numbers, one for each last present pte.  Used to
     perform a reverse map from a pte to a gfn. When role.direct is set, any
     element of this array can be calculated from the gfn field when used, in
     this case, the array of gfns is not allocated. See role.direct and gfn.
@@ -194,12 +199,9 @@ Shadow pages contain the following information:
     A counter keeping track of how many hardware registers (guest cr3 or
     pdptrs) are now pointing at the page.  While this counter is nonzero, the
     page cannot be destroyed.  See role.invalid.
-  multimapped:
-    Whether there exist multiple sptes pointing at this page.
-  parent_pte/parent_ptes:
-    If multimapped is zero, parent_pte points at the single spte that points at
-    this page's spt.  Otherwise, parent_ptes points at a data structure
-    with a list of parent_ptes.
+  parent_pte:
+    parent_pte points at the head spte of sptes that point at this page's spt.
+    See sibling_pte.
   unsync:
     If true, then the translations in this page may not match the guest's
     translation.  This is equivalent to the state of the tlb when a pte is
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 502e53f..e0aba97 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -153,13 +153,6 @@ struct kvm_mmu_memory_cache {
 	void *objects[KVM_NR_MEM_OBJS];
 };
 
-#define NR_PTE_CHAIN_ENTRIES 5
-
-struct kvm_pte_chain {
-	u64 *parent_ptes[NR_PTE_CHAIN_ENTRIES];
-	struct hlist_node link;
-};
-
 /*
  * kvm_mmu_page_role, below, is defined as:
  *
@@ -197,6 +190,7 @@ struct kvm_mmu_page {
 	union kvm_mmu_page_role role;
 
 	u64 *spt;
+	u64 **sibling_pte;
 	/* hold the gfn of each spte inside spt */
 	gfn_t *gfns;
 	/*
@@ -204,14 +198,10 @@ struct kvm_mmu_page {
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
+	u64 *parent_pte;
 	DECLARE_BITMAP(unsync_child_bitmap, 512);
 };
 
@@ -287,8 +277,6 @@ struct kvm_vcpu_arch {
 	 * put it here to avoid allocation */
 	struct kvm_pv_mmu_op_buffer mmu_op_buffer;
 
-	struct kvm_mmu_memory_cache mmu_pte_chain_cache;
-	struct kvm_mmu_memory_cache mmu_rmap_desc_cache;
 	struct kvm_mmu_memory_cache mmu_page_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 56da796..3345476 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -139,8 +139,6 @@ module_param(oos_shadow, bool, 0644);
 #define PT64_PERM_MASK (PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK \
 			| PT64_NX_MASK)
 
-#define RMAP_EXT 4
-
 #define ACC_EXEC_MASK    1
 #define ACC_WRITE_MASK   PT_WRITABLE_MASK
 #define ACC_USER_MASK    PT_USER_MASK
@@ -155,11 +153,6 @@ module_param(oos_shadow, bool, 0644);
 
 #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
 
-struct kvm_rmap_desc {
-	u64 *sptes[RMAP_EXT];
-	struct kvm_rmap_desc *more;
-};
-
 struct kvm_shadow_walk_iterator {
 	u64 addr;
 	hpa_t shadow_addr;
@@ -175,8 +168,6 @@ struct kvm_shadow_walk_iterator {
 
 typedef void (*mmu_parent_walk_fn) (struct kvm_mmu_page *sp, u64 *spte);
 
-static struct kmem_cache *pte_chain_cache;
-static struct kmem_cache *rmap_desc_cache;
 static struct kmem_cache *mmu_page_header_cache;
 
 static u64 __read_mostly shadow_trap_nonpresent_pte;
@@ -366,15 +357,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 {
 	int r;
 
-	r = mmu_topup_memory_cache(&vcpu->arch.mmu_pte_chain_cache,
-				   pte_chain_cache, 4);
-	if (r)
-		goto out;
-	r = mmu_topup_memory_cache(&vcpu->arch.mmu_rmap_desc_cache,
-				   rmap_desc_cache, 4);
-	if (r)
-		goto out;
-	r = mmu_topup_memory_cache_page(&vcpu->arch.mmu_page_cache, 8);
+	r = mmu_topup_memory_cache_page(&vcpu->arch.mmu_page_cache, 12);
 	if (r)
 		goto out;
 	r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
@@ -385,8 +368,6 @@ out:
 
 static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
-	mmu_free_memory_cache(&vcpu->arch.mmu_pte_chain_cache, pte_chain_cache);
-	mmu_free_memory_cache(&vcpu->arch.mmu_rmap_desc_cache, rmap_desc_cache);
 	mmu_free_memory_cache_page(&vcpu->arch.mmu_page_cache);
 	mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache,
 				mmu_page_header_cache);
@@ -402,28 +383,6 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc,
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
-static struct kvm_rmap_desc *mmu_alloc_rmap_desc(struct kvm_vcpu *vcpu)
-{
-	return mmu_memory_cache_alloc(&vcpu->arch.mmu_rmap_desc_cache,
-				      sizeof(struct kvm_rmap_desc));
-}
-
-static void mmu_free_rmap_desc(struct kvm_rmap_desc *rd)
-{
-	kmem_cache_free(rmap_desc_cache, rd);
-}
-
 static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
 {
 	if (!sp->role.direct)
@@ -561,14 +520,27 @@ static unsigned long *gfn_to_rmap(struct kvm *kvm, gfn_t gfn, int level)
 	return &slot->lpage_info[level - 2][idx].rmap_pde;
 }
 
+#define __sibling_pte(sp, spte) ((sp)->sibling_pte[(spte) - (sp)->spt])
+#define sibling_pte(spte) (*({						\
+	struct kvm_mmu_page *________sp = page_header(__pa(spte));	\
+	&__sibling_pte(________sp, (spte));				\
+}))
+
+static int rmap_count(u64 **rmapp)
+{
+	int count = 0;
+	u64 *spte = *rmapp;
+
+	while (spte) {
+		count++;
+		spte = sibling_pte(spte);
+	}
+
+	return count;
+}
+
 /*
- * Reverse mapping data structures:
- *
- * If rmapp bit zero is zero, then rmapp point to the shadw page table entry
- * that points to page_address(page).
- *
- * If rmapp bit zero is one, (then rmap & ~1) points to a struct kvm_rmap_desc
- * containing more mappings.
+ * Reverse mapping add new spte.
  *
  * Returns the number of rmap entries before the spte was added or zero if
  * the spte was not added.
@@ -577,105 +549,37 @@ static unsigned long *gfn_to_rmap(struct kvm *kvm, gfn_t gfn, int level)
 static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
-	struct kvm_rmap_desc *desc;
-	unsigned long *rmapp;
-	int i, count = 0;
+	u64 **p;
 
 	if (!is_rmap_spte(*spte))
-		return count;
+		return 0;
+
 	sp = page_header(__pa(spte));
 	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
-	rmapp = gfn_to_rmap(vcpu->kvm, gfn, sp->role.level);
-	if (!*rmapp) {
-		rmap_printk("rmap_add: %p %llx 0->1\n", spte, *spte);
-		*rmapp = (unsigned long)spte;
-	} else if (!(*rmapp & 1)) {
-		rmap_printk("rmap_add: %p %llx 1->many\n", spte, *spte);
-		desc = mmu_alloc_rmap_desc(vcpu);
-		desc->sptes[0] = (u64 *)*rmapp;
-		desc->sptes[1] = spte;
-		*rmapp = (unsigned long)desc | 1;
-	} else {
-		rmap_printk("rmap_add: %p %llx many->many\n", spte, *spte);
-		desc = (struct kvm_rmap_desc *)(*rmapp & ~1ul);
-		while (desc->sptes[RMAP_EXT-1] && desc->more) {
-			desc = desc->more;
-			count += RMAP_EXT;
-		}
-		if (desc->sptes[RMAP_EXT-1]) {
-			desc->more = mmu_alloc_rmap_desc(vcpu);
-			desc = desc->more;
-		}
-		for (i = 0; desc->sptes[i]; ++i)
-			;
-		desc->sptes[i] = spte;
-	}
-	return count;
-}
-
-static void rmap_desc_remove_entry(unsigned long *rmapp,
-				   struct kvm_rmap_desc *desc,
-				   int i,
-				   struct kvm_rmap_desc *prev_desc)
-{
-	int j;
+	p = (u64 **)(void *)gfn_to_rmap(vcpu->kvm, gfn, sp->role.level);
+	__sibling_pte(sp, spte) = *p;
+	*p = spte;
 
-	for (j = RMAP_EXT - 1; !desc->sptes[j] && j > i; --j)
-		;
-	desc->sptes[i] = desc->sptes[j];
-	desc->sptes[j] = NULL;
-	if (j != 0)
-		return;
-	if (!prev_desc && !desc->more)
-		*rmapp = (unsigned long)desc->sptes[0];
-	else
-		if (prev_desc)
-			prev_desc->more = desc->more;
-		else
-			*rmapp = (unsigned long)desc->more | 1;
-	mmu_free_rmap_desc(desc);
+	return rmap_count(p) - 1;
 }
 
 static void rmap_remove(struct kvm *kvm, u64 *spte)
 {
-	struct kvm_rmap_desc *desc;
-	struct kvm_rmap_desc *prev_desc;
 	struct kvm_mmu_page *sp;
 	gfn_t gfn;
-	unsigned long *rmapp;
-	int i;
+	u64 **p;
 
 	sp = page_header(__pa(spte));
 	gfn = kvm_mmu_page_get_gfn(sp, spte - sp->spt);
-	rmapp = gfn_to_rmap(kvm, gfn, sp->role.level);
-	if (!*rmapp) {
-		printk(KERN_ERR "rmap_remove: %p 0->BUG\n", spte);
-		BUG();
-	} else if (!(*rmapp & 1)) {
-		rmap_printk("rmap_remove:  %p 1->0\n", spte);
-		if ((u64 *)*rmapp != spte) {
-			printk(KERN_ERR "rmap_remove:  %p 1->BUG\n", spte);
-			BUG();
-		}
-		*rmapp = 0;
-	} else {
-		rmap_printk("rmap_remove:  %p many->many\n", spte);
-		desc = (struct kvm_rmap_desc *)(*rmapp & ~1ul);
-		prev_desc = NULL;
-		while (desc) {
-			for (i = 0; i < RMAP_EXT && desc->sptes[i]; ++i)
-				if (desc->sptes[i] == spte) {
-					rmap_desc_remove_entry(rmapp,
-							       desc, i,
-							       prev_desc);
-					return;
-				}
-			prev_desc = desc;
-			desc = desc->more;
+	p = (u64 **)(void *)gfn_to_rmap(kvm, gfn, sp->role.level);
+	while (*p) {
+		if (*p == spte) {
+			*p = sibling_pte(*p);
+			return;
 		}
-		pr_err("rmap_remove: %p many->many\n", spte);
-		BUG();
+		p = &sibling_pte(*p);
 	}
+	BUG();
 }
 
 static void set_spte_track_bits(u64 *sptep, u64 new_spte)
@@ -706,28 +610,9 @@ static void drop_spte(struct kvm *kvm, u64 *sptep, u64 new_spte)
 
 static u64 *rmap_next(struct kvm *kvm, unsigned long *rmapp, u64 *spte)
 {
-	struct kvm_rmap_desc *desc;
-	u64 *prev_spte;
-	int i;
-
-	if (!*rmapp)
-		return NULL;
-	else if (!(*rmapp & 1)) {
-		if (!spte)
-			return (u64 *)*rmapp;
-		return NULL;
-	}
-	desc = (struct kvm_rmap_desc *)(*rmapp & ~1ul);
-	prev_spte = NULL;
-	while (desc) {
-		for (i = 0; i < RMAP_EXT && desc->sptes[i]; ++i) {
-			if (prev_spte == spte)
-				return desc->sptes[i];
-			prev_spte = desc->sptes[i];
-		}
-		desc = desc->more;
-	}
-	return NULL;
+	if (!spte)
+		return (u64 *)*rmapp;
+	return  sibling_pte(spte);
 }
 
 static int rmap_write_protect(struct kvm *kvm, u64 gfn)
@@ -956,7 +841,8 @@ static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	hlist_del(&sp->hash_link);
 	list_del(&sp->link);
 	__free_page(virt_to_page(sp->spt));
-	if (!sp->role.direct)
+	__free_page(virt_to_page(sp->sibling_pte));
+	if (!sp->role.direct && (sizeof(gfn_t) == 8 || sizeof(u64 *) == 8))
 		__free_page(virt_to_page(sp->gfns));
 	kmem_cache_free(mmu_page_header_cache, sp);
 	++kvm->arch.n_free_mmu_pages;
@@ -974,13 +860,18 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 
 	sp = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache, sizeof *sp);
 	sp->spt = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache, PAGE_SIZE);
-	if (!direct)
+	sp->sibling_pte = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache,
+						 PAGE_SIZE);
+	if (!direct && (sizeof(gfn_t) == 8 || sizeof(u64 *) == 8))
 		sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache,
 						  PAGE_SIZE);
+	if (!direct && (sizeof(gfn_t) == 4 && sizeof(u64 *) == 4))
+		sp->gfns = (void *)(sp->sibling_pte + (1 << PT64_LEVEL_BITS));
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
 	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
-	sp->multimapped = 0;
+	if (parent_pte)
+		sibling_pte(parent_pte) = NULL;
 	sp->parent_pte = parent_pte;
 	--vcpu->kvm->arch.n_free_mmu_pages;
 	return sp;
@@ -989,100 +880,38 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
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
+	sibling_pte(parent_pte) = sp->parent_pte;
+	sp->parent_pte = parent_pte;
 }
 
 static void mmu_page_remove_parent_pte(struct kvm_mmu_page *sp,
 				       u64 *parent_pte)
 {
-	struct kvm_pte_chain *pte_chain;
-	struct hlist_node *node;
-	int i;
+	u64 **p = &sp->parent_pte;
 
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
+	while (*p) {
+		if (*p == parent_pte) {
+			*p = sibling_pte(*p);
 			return;
 		}
+		p = &sibling_pte(*p);
+	}
 	BUG();
 }
 
 static void mmu_parent_walk(struct kvm_mmu_page *sp, mmu_parent_walk_fn fn)
 {
-	struct kvm_pte_chain *pte_chain;
-	struct hlist_node *node;
+	u64 *parent_pte = sp->parent_pte;
 	struct kvm_mmu_page *parent_sp;
-	int i;
 
-	if (!sp->multimapped && sp->parent_pte) {
-		parent_sp = page_header(__pa(sp->parent_pte));
-		fn(parent_sp, sp->parent_pte);
-		return;
+	while (parent_pte) {
+		parent_sp = page_header(__pa(parent_pte));
+		fn(parent_sp, parent_pte);
+		parent_pte = __sibling_pte(parent_sp, parent_pte);
 	}
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
 }
 
 static void mark_unsync(struct kvm_mmu_page *sp, u64 *spte);
@@ -1576,22 +1405,14 @@ static void kvm_mmu_reset_last_pte_updated(struct kvm *kvm)
 
 static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	u64 *parent_pte;
-
-	while (sp->multimapped || sp->parent_pte) {
-		if (!sp->multimapped)
-			parent_pte = sp->parent_pte;
-		else {
-			struct kvm_pte_chain *chain;
+	u64 *parent_pte = sp->parent_pte;
 
-			chain = container_of(sp->parent_ptes.first,
-					     struct kvm_pte_chain, link);
-			parent_pte = chain->parent_ptes[0];
-		}
-		BUG_ON(!parent_pte);
-		kvm_mmu_put_page(sp, parent_pte);
+	while (parent_pte) {
 		__set_spte(parent_pte, shadow_trap_nonpresent_pte);
+		parent_pte = sibling_pte(parent_pte);
 	}
+
+	sp->parent_pte = NULL;
 }
 
 static int mmu_zap_unsync_children(struct kvm *kvm,
@@ -3155,10 +2976,6 @@ static struct shrinker mmu_shrinker = {
 
 static void mmu_destroy_caches(void)
 {
-	if (pte_chain_cache)
-		kmem_cache_destroy(pte_chain_cache);
-	if (rmap_desc_cache)
-		kmem_cache_destroy(rmap_desc_cache);
 	if (mmu_page_header_cache)
 		kmem_cache_destroy(mmu_page_header_cache);
 }
@@ -3171,17 +2988,6 @@ void kvm_mmu_module_exit(void)
 
 int kvm_mmu_module_init(void)
 {
-	pte_chain_cache = kmem_cache_create("kvm_pte_chain",
-					    sizeof(struct kvm_pte_chain),
-					    0, 0, NULL);
-	if (!pte_chain_cache)
-		goto nomem;
-	rmap_desc_cache = kmem_cache_create("kvm_rmap_desc",
-					    sizeof(struct kvm_rmap_desc),
-					    0, 0, NULL);
-	if (!rmap_desc_cache)
-		goto nomem;
-
 	mmu_page_header_cache = kmem_cache_create("kvm_mmu_page_header",
 						  sizeof(struct kvm_mmu_page),
 						  0, 0, NULL);
@@ -3487,26 +3293,11 @@ static int count_rmaps(struct kvm_vcpu *vcpu)
 	slots = kvm_memslots(kvm);
 	for (i = 0; i < KVM_MEMORY_SLOTS; ++i) {
 		struct kvm_memory_slot *m = &slots->memslots[i];
-		struct kvm_rmap_desc *d;
 
 		for (j = 0; j < m->npages; ++j) {
 			unsigned long *rmapp = &m->rmap[j];
 
-			if (!*rmapp)
-				continue;
-			if (!(*rmapp & 1)) {
-				++nmaps;
-				continue;
-			}
-			d = (struct kvm_rmap_desc *)(*rmapp & ~1ul);
-			while (d) {
-				for (k = 0; k < RMAP_EXT; ++k)
-					if (d->sptes[k])
-						++nmaps;
-					else
-						break;
-				d = d->more;
-			}
+			nmaps += rmap_count((u64 **)rmapp);
 		}
 	}
 	srcu_read_unlock(&kvm->srcu, idx);

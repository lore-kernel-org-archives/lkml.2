Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072Ab1EOPYe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 11:24:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57183 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760047Ab1EOPYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 11:24:32 -0400
Message-ID: <4DCFF09C.50006@cn.fujitsu.com>
Date: Sun, 15 May 2011 23:26:20 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 4/7] KVM: MMU: abstract the operation of rmap
References: <4DCFEF3B.5060806@cn.fujitsu.com>
In-Reply-To: <4DCFEF3B.5060806@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-15 23:24:41,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-15 23:24:41,
	Serialize complete at 2011-05-15 23:24:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abstract the operation of rmap to spte_list, then we can use it for the
reverse mapping of parent pte in the later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/mmu.c              |  260 +++++++++++++++++++++------------------
 2 files changed, 140 insertions(+), 122 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 152601a..0d824e4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -347,7 +347,7 @@ struct kvm_vcpu_arch {
 	struct kvm_pv_mmu_op_buffer mmu_op_buffer;
 
 	struct kvm_mmu_memory_cache mmu_pte_chain_cache;
-	struct kvm_mmu_memory_cache mmu_rmap_desc_cache;
+	struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
 	struct kvm_mmu_memory_cache mmu_page_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ad520d4..5ba347b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -148,7 +148,7 @@ module_param(oos_shadow, bool, 0644);
 #define PT64_PERM_MASK (PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK \
 			| PT64_NX_MASK)
 
-#define RMAP_EXT 4
+#define PTE_LIST_EXT 4
 
 #define ACC_EXEC_MASK    1
 #define ACC_WRITE_MASK   PT_WRITABLE_MASK
@@ -164,9 +164,9 @@ module_param(oos_shadow, bool, 0644);
 
 #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
 
-struct kvm_rmap_desc {
-	u64 *sptes[RMAP_EXT];
-	struct kvm_rmap_desc *more;
+struct pte_list_desc {
+	u64 *sptes[PTE_LIST_EXT];
+	struct pte_list_desc *more;
 };
 
 struct kvm_shadow_walk_iterator {
@@ -185,7 +185,7 @@ struct kvm_shadow_walk_iterator {
 typedef void (*mmu_parent_walk_fn) (struct kvm_mmu_page *sp, u64 *spte);
 
 static struct kmem_cache *pte_chain_cache;
-static struct kmem_cache *rmap_desc_cache;
+static struct kmem_cache *pte_list_desc_cache;
 static struct kmem_cache *mmu_page_header_cache;
 static struct percpu_counter kvm_total_used_mmu_pages;
 
@@ -401,8 +401,8 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 				   pte_chain_cache, 4);
 	if (r)
 		goto out;
-	r = mmu_topup_memory_cache(&vcpu->arch.mmu_rmap_desc_cache,
-				   rmap_desc_cache, 4 + PTE_PREFETCH_NUM);
+	r = mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
+				   pte_list_desc_cache, 4 + PTE_PREFETCH_NUM);
 	if (r)
 		goto out;
 	r = mmu_topup_memory_cache_page(&vcpu->arch.mmu_page_cache, 8);
@@ -416,8 +416,10 @@ out:
 
 static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
-	mmu_free_memory_cache(&vcpu->arch.mmu_pte_chain_cache, pte_chain_cache);
-	mmu_free_memory_cache(&vcpu->arch.mmu_rmap_desc_cache, rmap_desc_cache);
+	mmu_free_memory_cache(&vcpu->arch.mmu_pte_chain_cache,
+				pte_chain_cache);
+	mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
+				pte_list_desc_cache);
 	mmu_free_memory_cache_page(&vcpu->arch.mmu_page_cache);
 	mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache,
 				mmu_page_header_cache);
@@ -444,15 +446,15 @@ static void mmu_free_pte_chain(struct kvm_pte_chain *pc)
 	kmem_cache_free(pte_chain_cache, pc);
 }
 
-static struct kvm_rmap_desc *mmu_alloc_rmap_desc(struct kvm_vcpu *vcpu)
+static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
 {
-	return mmu_memory_cache_alloc(&vcpu->arch.mmu_rmap_desc_cache,
-				      sizeof(struct kvm_rmap_desc));
+	return mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache,
+				      sizeof(struct pte_list_desc));
 }
 
-static void mmu_free_rmap_desc(struct kvm_rmap_desc *rd)
+static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
 {
-	kmem_cache_free(rmap_desc_cache, rd);
+	kmem_cache_free(pte_list_desc_cache, pte_list_desc);
 }
 
 static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
@@ -590,67 +592,42 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
 }
 
 /*
- * Take gfn and return the reverse mapping to it.
- */
-
-static unsigned long *gfn_to_rmap(struct kvm *kvm, gfn_t gfn, int level)
-{
-	struct kvm_memory_slot *slot;
-	struct kvm_lpage_info *linfo;
-
-	slot = gfn_to_memslot(kvm, gfn);
-	if (likely(level == PT_PAGE_TABLE_LEVEL))
-		return &slot->rmap[gfn - slot->base_gfn];
-
-	linfo = lpage_info_slot(gfn, slot, level);
-
-	return &linfo->rmap_pde;
-}
-
-/*
- * Reverse mapping data structures:
+ * Pte mapping structures:
  *
- * If rmapp bit zero is zero, then rmapp point to the shadw page table entry
- * that points to page_address(page).
+ * If pte_list bit zero is zero, then pte_list point to the spte.
  *
- * If rmapp bit zero is one, (then rmap & ~1) points to a struct kvm_rmap_desc
- * containing more mappings.
+ * If pte_list bit zero is one, (then pte_list & ~1) points to a struct
+ * pte_list_desc containing more mappings.
  *
- * Returns the number of rmap entries before the spte was added or zero if
+ * Returns the number of pte entries before the spte was added or zero if
  * the spte was not added.
  *
  */
-static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
+static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
+			unsigned long *pte_list)
 {
-	struct kvm_mmu_page *sp;
-	struct kvm_rmap_desc *desc;
-	unsigned long *rmapp;
+	struct pte_list_desc *desc;
 	int i, count = 0;
 
-	if (!is_rmap_spte(*spte))
-		return count;
-	sp = page_header(__pa(spte));
-	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
-	rmapp = gfn_to_rmap(vcpu->kvm, gfn, sp->role.level);
-	if (!*rmapp) {
-		rmap_printk("rmap_add: %p %llx 0->1\n", spte, *spte);
-		*rmapp = (unsigned long)spte;
-	} else if (!(*rmapp & 1)) {
-		rmap_printk("rmap_add: %p %llx 1->many\n", spte, *spte);
-		desc = mmu_alloc_rmap_desc(vcpu);
-		desc->sptes[0] = (u64 *)*rmapp;
+	if (!*pte_list) {
+		rmap_printk("pte_list_add: %p %llx 0->1\n", spte, *spte);
+		*pte_list = (unsigned long)spte;
+	} else if (!(*pte_list & 1)) {
+		rmap_printk("pte_list_add: %p %llx 1->many\n", spte, *spte);
+		desc = mmu_alloc_pte_list_desc(vcpu);
+		desc->sptes[0] = (u64 *)*pte_list;
 		desc->sptes[1] = spte;
-		*rmapp = (unsigned long)desc | 1;
+		*pte_list = (unsigned long)desc | 1;
 		++count;
 	} else {
-		rmap_printk("rmap_add: %p %llx many->many\n", spte, *spte);
-		desc = (struct kvm_rmap_desc *)(*rmapp & ~1ul);
-		while (desc->sptes[RMAP_EXT-1] && desc->more) {
+		rmap_printk("pte_list_add: %p %llx many->many\n", spte, *spte);
+		desc = (struct pte_list_desc *)(*pte_list & ~1ul);
+		while (desc->sptes[PTE_LIST_EXT-1] && desc->more) {
 			desc = desc->more;
-			count += RMAP_EXT;
+			count += PTE_LIST_EXT;
 		}
-		if (desc->sptes[RMAP_EXT-1]) {
-			desc->more = mmu_alloc_rmap_desc(vcpu);
+		if (desc->sptes[PTE_LIST_EXT-1]) {
+			desc->more = mmu_alloc_pte_list_desc(vcpu);
 			desc = desc->more;
 		}
 		for (i = 0; desc->sptes[i]; ++i)
@@ -660,59 +637,78 @@ static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 	return count;
 }
 
-static void rmap_desc_remove_entry(unsigned long *rmapp,
-				   struct kvm_rmap_desc *desc,
-				   int i,
-				   struct kvm_rmap_desc *prev_desc)
+static u64 *pte_list_next(unsigned long *pte_list, u64 *spte)
+{
+	struct pte_list_desc *desc;
+	u64 *prev_spte;
+	int i;
+
+	if (!*pte_list)
+		return NULL;
+	else if (!(*pte_list & 1)) {
+		if (!spte)
+			return (u64 *)*pte_list;
+		return NULL;
+	}
+	desc = (struct pte_list_desc *)(*pte_list & ~1ul);
+	prev_spte = NULL;
+	while (desc) {
+		for (i = 0; i < PTE_LIST_EXT && desc->sptes[i]; ++i) {
+			if (prev_spte == spte)
+				return desc->sptes[i];
+			prev_spte = desc->sptes[i];
+		}
+		desc = desc->more;
+	}
+	return NULL;
+}
+
+static void
+pte_list_desc_remove_entry(unsigned long *pte_list, struct pte_list_desc *desc,
+			   int i, struct pte_list_desc *prev_desc)
 {
 	int j;
 
-	for (j = RMAP_EXT - 1; !desc->sptes[j] && j > i; --j)
+	for (j = PTE_LIST_EXT - 1; !desc->sptes[j] && j > i; --j)
 		;
 	desc->sptes[i] = desc->sptes[j];
 	desc->sptes[j] = NULL;
 	if (j != 0)
 		return;
 	if (!prev_desc && !desc->more)
-		*rmapp = (unsigned long)desc->sptes[0];
+		*pte_list = (unsigned long)desc->sptes[0];
 	else
 		if (prev_desc)
 			prev_desc->more = desc->more;
 		else
-			*rmapp = (unsigned long)desc->more | 1;
-	mmu_free_rmap_desc(desc);
+			*pte_list = (unsigned long)desc->more | 1;
+	mmu_free_pte_list_desc(desc);
 }
 
-static void rmap_remove(struct kvm *kvm, u64 *spte)
+static void pte_list_remove(u64 *spte, unsigned long *pte_list)
 {
-	struct kvm_rmap_desc *desc;
-	struct kvm_rmap_desc *prev_desc;
-	struct kvm_mmu_page *sp;
-	gfn_t gfn;
-	unsigned long *rmapp;
+	struct pte_list_desc *desc;
+	struct pte_list_desc *prev_desc;
 	int i;
 
-	sp = page_header(__pa(spte));
-	gfn = kvm_mmu_page_get_gfn(sp, spte - sp->spt);
-	rmapp = gfn_to_rmap(kvm, gfn, sp->role.level);
-	if (!*rmapp) {
-		printk(KERN_ERR "rmap_remove: %p 0->BUG\n", spte);
+	if (!*pte_list) {
+		printk(KERN_ERR "pte_list_remove: %p 0->BUG\n", spte);
 		BUG();
-	} else if (!(*rmapp & 1)) {
-		rmap_printk("rmap_remove:  %p 1->0\n", spte);
-		if ((u64 *)*rmapp != spte) {
-			printk(KERN_ERR "rmap_remove:  %p 1->BUG\n", spte);
+	} else if (!(*pte_list & 1)) {
+		rmap_printk("pte_list_remove:  %p 1->0\n", spte);
+		if ((u64 *)*pte_list != spte) {
+			printk(KERN_ERR "pte_list_remove:  %p 1->BUG\n", spte);
 			BUG();
 		}
-		*rmapp = 0;
+		*pte_list = 0;
 	} else {
-		rmap_printk("rmap_remove:  %p many->many\n", spte);
-		desc = (struct kvm_rmap_desc *)(*rmapp & ~1ul);
+		rmap_printk("pte_list_remove:  %p many->many\n", spte);
+		desc = (struct pte_list_desc *)(*pte_list & ~1ul);
 		prev_desc = NULL;
 		while (desc) {
-			for (i = 0; i < RMAP_EXT && desc->sptes[i]; ++i)
+			for (i = 0; i < PTE_LIST_EXT && desc->sptes[i]; ++i)
 				if (desc->sptes[i] == spte) {
-					rmap_desc_remove_entry(rmapp,
+					pte_list_desc_remove_entry(pte_list,
 							       desc, i,
 							       prev_desc);
 					return;
@@ -720,11 +716,59 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 			prev_desc = desc;
 			desc = desc->more;
 		}
-		pr_err("rmap_remove: %p many->many\n", spte);
+		pr_err("pte_list_remove: %p many->many\n", spte);
 		BUG();
 	}
 }
 
+/*
+ * Take gfn and return the reverse mapping to it.
+ */
+static unsigned long *gfn_to_rmap(struct kvm *kvm, gfn_t gfn, int level)
+{
+	struct kvm_memory_slot *slot;
+	struct kvm_lpage_info *linfo;
+
+	slot = gfn_to_memslot(kvm, gfn);
+	if (likely(level == PT_PAGE_TABLE_LEVEL))
+		return &slot->rmap[gfn - slot->base_gfn];
+
+	linfo = lpage_info_slot(gfn, slot, level);
+
+	return &linfo->rmap_pde;
+}
+
+static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
+{
+	struct kvm_mmu_page *sp;
+	unsigned long *rmapp;
+
+	if (!is_rmap_spte(*spte))
+		return 0;
+
+	sp = page_header(__pa(spte));
+	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
+	rmapp = gfn_to_rmap(vcpu->kvm, gfn, sp->role.level);
+	return pte_list_add(vcpu, spte, rmapp);
+}
+
+static u64 *rmap_next(struct kvm *kvm, unsigned long *rmapp, u64 *spte)
+{
+	return pte_list_next(rmapp, spte);
+}
+
+static void rmap_remove(struct kvm *kvm, u64 *spte)
+{
+	struct kvm_mmu_page *sp;
+	gfn_t gfn;
+	unsigned long *rmapp;
+
+	sp = page_header(__pa(spte));
+	gfn = kvm_mmu_page_get_gfn(sp, spte - sp->spt);
+	rmapp = gfn_to_rmap(kvm, gfn, sp->role.level);
+	pte_list_remove(spte, rmapp);
+}
+
 static int set_spte_track_bits(u64 *sptep, u64 new_spte)
 {
 	pfn_t pfn;
@@ -752,32 +796,6 @@ static void drop_spte(struct kvm *kvm, u64 *sptep, u64 new_spte)
 		rmap_remove(kvm, sptep);
 }
 
-static u64 *rmap_next(struct kvm *kvm, unsigned long *rmapp, u64 *spte)
-{
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
-}
-
 static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 {
 	unsigned long *rmapp;
@@ -3600,8 +3618,8 @@ static void mmu_destroy_caches(void)
 {
 	if (pte_chain_cache)
 		kmem_cache_destroy(pte_chain_cache);
-	if (rmap_desc_cache)
-		kmem_cache_destroy(rmap_desc_cache);
+	if (pte_list_desc_cache)
+		kmem_cache_destroy(pte_list_desc_cache);
 	if (mmu_page_header_cache)
 		kmem_cache_destroy(mmu_page_header_cache);
 }
@@ -3613,10 +3631,10 @@ int kvm_mmu_module_init(void)
 					    0, 0, NULL);
 	if (!pte_chain_cache)
 		goto nomem;
-	rmap_desc_cache = kmem_cache_create("kvm_rmap_desc",
-					    sizeof(struct kvm_rmap_desc),
+	pte_list_desc_cache = kmem_cache_create("pte_list_desc",
+					    sizeof(struct pte_list_desc),
 					    0, 0, NULL);
-	if (!rmap_desc_cache)
+	if (!pte_list_desc_cache)
 		goto nomem;
 
 	mmu_page_header_cache = kmem_cache_create("kvm_mmu_page_header",
-- 
1.7.4.4


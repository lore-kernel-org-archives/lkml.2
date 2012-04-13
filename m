Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935100Ab2DMKMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:12:50 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:52377 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934930Ab2DMKMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:12:49 -0400
Message-ID: <4F87FC19.8080404@linux.vnet.ibm.com>
Date: Fri, 13 Apr 2012 18:12:41 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 07/16] KVM: MMU: introduce for_each_pte_list_spte
References: <4F87FA69.5060106@linux.vnet.ibm.com>
In-Reply-To: <4F87FA69.5060106@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041300-7014-0000-0000-000000E5DB8D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is used to walk all the sptes of the specified pte_list, after
this, the code of pte_list_walk can be removed

And it can restart the walking automatically if the spte is zapped

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c       |  233 +++++++++++++++++++++++-----------------------
 arch/x86/kvm/mmu_audit.c |    6 +-
 2 files changed, 118 insertions(+), 121 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a1c3628..4e91e94 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -900,26 +900,110 @@ static void pte_list_remove(u64 *spte, unsigned long *pte_list)
 	}
 }

-typedef void (*pte_list_walk_fn) (u64 *spte);
-static void pte_list_walk(unsigned long *pte_list, pte_list_walk_fn fn)
-{
+/*
+ * Used by the following functions to iterate through the sptes linked by a
+ * pte_list. All fields are private and not assumed to be used outside.
+ */
+struct spte_iterator {
+	/* private fields */
+	unsigned long *pte_list;
+	/* holds the sptep if not NULL */
 	struct pte_list_desc *desc;
-	int i;
+	/* index of the sptep, -1 means the walking does not start. */
+	int pos;
+};

-	if (!*pte_list)
-		return;
+static void pte_list_walk_init(struct spte_iterator *iter,
+			       unsigned long *pte_list)
+{
+	iter->pte_list = pte_list;
+	iter->pos = -1;
+}
+
+static void pte_list_walk_check_restart(struct spte_iterator *iter, u64 *spte)
+{
+	/*
+	 * If the spte is zapped, we should set 'iter->pos = -1' to restart
+	 * the walk.
+	 */
+	if (!is_shadow_present_pte(*spte))
+		iter->pos = -1;
+}
+
+static u64 *pte_list_first(struct spte_iterator *iter)
+{
+	unsigned long pte_list = *iter->pte_list;
+	u64 *sptep;
+
+	if (!pte_list)
+		return NULL;
+
+	if (!(pte_list & 1)) {
+		iter->desc = NULL;
+		iter->pos = 0;
+		sptep = (u64 *)pte_list;
+
+		goto exit;
+	}
+
+	iter->desc = (struct pte_list_desc *)(pte_list & ~1ul);
+	iter->pos = 0;
+	sptep = iter->desc->sptes[iter->pos];
+
+exit:
+	WARN_ON(sptep && !is_shadow_present_pte(*sptep));
+	return sptep;
+}

-	if (!(*pte_list & 1))
-		return fn((u64 *)*pte_list);
+static u64 *pte_list_next(struct spte_iterator *iter)
+{
+	u64 *sptep = NULL;

-	desc = (struct pte_list_desc *)(*pte_list & ~1ul);
-	while (desc) {
-		for (i = 0; i < PTE_LIST_EXT && desc->sptes[i]; ++i)
-			fn(desc->sptes[i]);
-		desc = desc->more;
+	if (iter->pos < 0)
+		return pte_list_first(iter);
+
+	if (iter->desc) {
+		if (iter->pos < PTE_LIST_EXT - 1) {
+			++iter->pos;
+			sptep = iter->desc->sptes[iter->pos];
+			if (sptep)
+				goto exit;
+		}
+
+		iter->desc = iter->desc->more;
+
+		if (iter->desc) {
+			iter->pos = 0;
+			/* desc->sptes[0] cannot be NULL */
+			sptep = iter->desc->sptes[iter->pos];
+			goto exit;
+		}
 	}
+
+exit:
+	WARN_ON(sptep && !is_shadow_present_pte(*sptep));
+	return sptep;
 }

+
+#define for_each_pte_list_spte(pte_list, iter, spte)	\
+	for (pte_list_walk_init(iter, pte_list);	\
+	      (spte = pte_list_next(iter)) != NULL;	\
+		pte_list_walk_check_restart(iter, spte))
+
+typedef void (*pte_list_walk_fn) (u64 *spte);
+static void pte_list_walk(unsigned long *pte_list, pte_list_walk_fn fn)
+{
+	struct spte_iterator iter;
+	u64 *spte;
+
+	for_each_pte_list_spte(pte_list, &iter, spte)
+		fn(spte);
+}
+
+#define for_each_rmap_spte(rmap, iter, spte)	\
+		for_each_pte_list_spte(rmap, iter, spte)
+
 static unsigned long *__gfn_to_rmap(gfn_t gfn, int level,
 				    struct kvm_memory_slot *slot)
 {
@@ -974,92 +1058,19 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	pte_list_remove(spte, rmapp);
 }

-/*
- * Used by the following functions to iterate through the sptes linked by a
- * rmap.  All fields are private and not assumed to be used outside.
- */
-struct rmap_iterator {
-	/* private fields */
-	struct pte_list_desc *desc;	/* holds the sptep if not NULL */
-	int pos;			/* index of the sptep */
-};
-
-/*
- * Iteration must be started by this function.  This should also be used after
- * removing/dropping sptes from the rmap link because in such cases the
- * information in the itererator may not be valid.
- *
- * Returns sptep if found, NULL otherwise.
- */
-static u64 *rmap_get_first(unsigned long rmap, struct rmap_iterator *iter)
-{
-	u64 *sptep;
-
-	if (!rmap)
-		return NULL;
-
-	if (!(rmap & 1)) {
-		iter->desc = NULL;
-		sptep = (u64 *)rmap;
-
-		goto exit;
-	}
-
-	iter->desc = (struct pte_list_desc *)(rmap & ~1ul);
-	iter->pos = 0;
-	sptep = iter->desc->sptes[iter->pos];
-
-exit:
-	WARN_ON(sptep && !is_shadow_present_pte(*sptep));
-	return sptep;
-}
-
-/*
- * Must be used with a valid iterator: e.g. after rmap_get_first().
- *
- * Returns sptep if found, NULL otherwise.
- */
-static u64 *rmap_get_next(struct rmap_iterator *iter)
-{
-	u64 *sptep = NULL;
-
-	if (iter->desc) {
-		if (iter->pos < PTE_LIST_EXT - 1) {
-			++iter->pos;
-			sptep = iter->desc->sptes[iter->pos];
-			if (sptep)
-				goto exit;
-		}
-
-		iter->desc = iter->desc->more;
-
-		if (iter->desc) {
-			iter->pos = 0;
-			/* desc->sptes[0] cannot be NULL */
-			sptep = iter->desc->sptes[iter->pos];
-			goto exit;
-		}
-	}
-
-exit:
-	WARN_ON(sptep && !is_shadow_present_pte(*sptep));
-	return sptep;
-}
-
 static void drop_spte(struct kvm *kvm, u64 *sptep)
 {
 	if (mmu_spte_clear_track_bits(sptep))
 		rmap_remove(kvm, sptep);
 }

-/* Return true if the spte is dropped. */
-static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool large,
+static void spte_write_protect(struct kvm *kvm, u64 *sptep, bool large,
 			       bool *flush)
 {
 	u64 spte = *sptep;

 	if (!is_writable_pte(spte))
-		return false;
+		return;

 	*flush |= true;

@@ -1070,32 +1081,24 @@ static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool large,

 		drop_spte(kvm, sptep);
 		--kvm->stat.lpages;
-		return true;
+		return;
 	}

 	rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
 	spte = spte & ~PT_WRITABLE_MASK;
 	mmu_spte_update(sptep, spte);
-
-	return false;
 }

 static bool
 __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)
 {
 	u64 *sptep;
-	struct rmap_iterator iter;
+	struct spte_iterator iter;
 	bool write_protected = false;

-	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
-		if (spte_write_protect(kvm, sptep, level > PT_PAGE_TABLE_LEVEL,
-			  &write_protected)) {
-			sptep = rmap_get_first(*rmapp, &iter);
-			continue;
-		}
-
-		sptep = rmap_get_next(&iter);
-	}
+	for_each_rmap_spte(rmapp, &iter, sptep)
+		spte_write_protect(kvm, sptep, level > PT_PAGE_TABLE_LEVEL,
+			  &write_protected);

 	return write_protected;
 }
@@ -1147,10 +1150,10 @@ static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp,
 			   unsigned long data)
 {
 	u64 *sptep;
-	struct rmap_iterator iter;
+	struct spte_iterator iter;
 	int need_tlb_flush = 0;

-	while ((sptep = rmap_get_first(*rmapp, &iter))) {
+	for_each_rmap_spte(rmapp, &iter, sptep) {
 		rmap_printk("kvm_rmap_unmap_hva: spte %p %llx\n", sptep, *sptep);

 		drop_spte(kvm, sptep);
@@ -1164,7 +1167,7 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 			     unsigned long data)
 {
 	u64 *sptep;
-	struct rmap_iterator iter;
+	struct spte_iterator iter;
 	int need_flush = 0;
 	u64 new_spte;
 	pte_t *ptep = (pte_t *)data;
@@ -1173,15 +1176,14 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 	WARN_ON(pte_huge(*ptep));
 	new_pfn = pte_pfn(*ptep);

-	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
+	for_each_rmap_spte(rmapp, &iter, sptep) {
 		rmap_printk("kvm_set_pte_rmapp: spte %p %llx\n", sptep, *sptep);

 		need_flush = 1;

-		if (pte_write(*ptep)) {
+		if (pte_write(*ptep))
 			drop_spte(kvm, sptep);
-			sptep = rmap_get_first(*rmapp, &iter);
-		} else {
+		else {
 			new_spte = *sptep & ~PT64_BASE_ADDR_MASK;
 			new_spte |= (u64)new_pfn << PAGE_SHIFT;

@@ -1191,7 +1193,6 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,

 			mmu_spte_clear_track_bits(sptep);
 			mmu_spte_set(sptep, new_spte);
-			sptep = rmap_get_next(&iter);
 		}
 	}

@@ -1254,7 +1255,7 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 			 unsigned long data)
 {
 	u64 *sptep;
-	struct rmap_iterator iter;
+	struct spte_iterator iter;
 	int young = 0;

 	/*
@@ -1267,8 +1268,7 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 	if (!shadow_accessed_mask)
 		return kvm_unmap_rmapp(kvm, rmapp, data);

-	for (sptep = rmap_get_first(*rmapp, &iter); sptep;
-	     sptep = rmap_get_next(&iter))
+	for_each_rmap_spte(rmapp, &iter, sptep)
 		if (*sptep & PT_ACCESSED_MASK) {
 			young = 1;
 			clear_bit(PT_ACCESSED_SHIFT, (unsigned long *)sptep);
@@ -1281,7 +1281,7 @@ static int kvm_test_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 			      unsigned long data)
 {
 	u64 *sptep;
-	struct rmap_iterator iter;
+	struct spte_iterator iter;
 	int young = 0;

 	/*
@@ -1292,8 +1292,7 @@ static int kvm_test_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 	if (!shadow_accessed_mask)
 		goto out;

-	for (sptep = rmap_get_first(*rmapp, &iter); sptep;
-	     sptep = rmap_get_next(&iter))
+	for_each_rmap_spte(rmapp, &iter, sptep)
 		if (*sptep & PT_ACCESSED_MASK) {
 			young = 1;
 			break;
@@ -1955,9 +1954,9 @@ static void kvm_mmu_page_unlink_children(struct kvm *kvm,
 static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	u64 *sptep;
-	struct rmap_iterator iter;
+	struct spte_iterator iter;

-	while ((sptep = rmap_get_first(sp->parent_ptes, &iter)))
+	for_each_pte_list_spte(&sp->parent_ptes, &iter, sptep)
 		drop_parent_pte(sp, sptep);
 }

diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index 7d7d0b9..a42bd85 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -193,7 +193,7 @@ static void audit_write_protection(struct kvm *kvm, struct kvm_mmu_page *sp)
 	struct kvm_memory_slot *slot;
 	unsigned long *rmapp;
 	u64 *sptep;
-	struct rmap_iterator iter;
+	struct spte_iterator iter;

 	if (sp->role.direct || sp->unsync || sp->role.invalid)
 		return;
@@ -201,13 +201,11 @@ static void audit_write_protection(struct kvm *kvm, struct kvm_mmu_page *sp)
 	slot = gfn_to_memslot(kvm, sp->gfn);
 	rmapp = &slot->rmap[sp->gfn - slot->base_gfn];

-	for (sptep = rmap_get_first(*rmapp, &iter); sptep;
-	     sptep = rmap_get_next(&iter)) {
+	for_each_rmap_spte(rmapp, &iter, sptep)
 		if (is_writable_pte(*sptep))
 			audit_printk(kvm, "shadow page has writable "
 				     "mappings: gfn %llx role %x\n",
 				     sp->gfn, sp->role.word);
-	}
 }

 static void audit_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
-- 
1.7.7.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab0DLIHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 04:07:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58784 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab0DLIHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 04:07:49 -0400
Message-ID: <4BC2D43A.5020003@cn.fujitsu.com>
Date: Mon, 12 Apr 2010 16:05:14 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/6] KVM MMU: reduce kvm_mmu_page size
References: <4BC2D2E2.1030604@cn.fujitsu.com>
In-Reply-To: <4BC2D2E2.1030604@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'multimapped' and 'unsync' in 'struct kvm_mmu_page' are just indication
field, we can use flag bits instand of them

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    5 ++-
 arch/x86/kvm/mmu.c              |   65 ++++++++++++++++++++++++++++-----------
 arch/x86/kvm/mmutrace.h         |    7 ++--
 arch/x86/kvm/paging_tmpl.h      |    2 +-
 4 files changed, 55 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0c49c88..d463bc6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -202,9 +202,10 @@ struct kvm_mmu_page {
 	 * in this shadow page.
 	 */
 	DECLARE_BITMAP(slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
-	int multimapped;         /* More than one parent_pte? */
 	int root_count;          /* Currently serving as active root */
-	bool unsync;
+	#define MMU_PAGE_MULTIMAPPED 0x1        /* More than one parent_pte? */
+	#define MMU_PAGE_UNSYNC 0x2
+	unsigned int flags;
 	unsigned int unsync_children;
 	union {
 		u64 *parent_pte;               /* !multimapped */
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5154d70..18eceb2 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -266,6 +266,36 @@ static int is_last_spte(u64 pte, int level)
 	return 0;
 }
 
+static bool mmu_page_is_multimapped(struct kvm_mmu_page *sp)
+{
+	return !!(sp->flags & MMU_PAGE_MULTIMAPPED);
+}
+
+static void mmu_page_mark_multimapped(struct kvm_mmu_page *sp)
+{
+	sp->flags |= MMU_PAGE_MULTIMAPPED;
+}
+
+static void mmu_page_clear_multimapped(struct kvm_mmu_page *sp)
+{
+	sp->flags &= ~MMU_PAGE_MULTIMAPPED;
+}
+
+static bool mmu_page_is_unsync(struct kvm_mmu_page *sp)
+{
+	return !!(sp->flags & MMU_PAGE_UNSYNC);
+}
+
+static void mmu_page_mark_unsync(struct kvm_mmu_page *sp)
+{
+	sp->flags |= MMU_PAGE_UNSYNC;
+}
+
+static void mmu_page_clear_unsync(struct kvm_mmu_page *sp)
+{
+	sp->flags &= ~MMU_PAGE_UNSYNC;
+}
+
 static pfn_t spte_to_pfn(u64 pte)
 {
 	return (pte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
@@ -918,7 +948,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
 	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
-	sp->multimapped = 0;
+	sp->flags = 0;
 	sp->parent_pte = parent_pte;
 	--vcpu->kvm->arch.n_free_mmu_pages;
 	return sp;
@@ -933,14 +963,14 @@ static void mmu_page_add_parent_pte(struct kvm_vcpu *vcpu,
 
 	if (!parent_pte)
 		return;
-	if (!sp->multimapped) {
+	if (!mmu_page_is_multimapped(sp)) {
 		u64 *old = sp->parent_pte;
 
 		if (!old) {
 			sp->parent_pte = parent_pte;
 			return;
 		}
-		sp->multimapped = 1;
+		mmu_page_mark_multimapped(sp);
 		pte_chain = mmu_alloc_pte_chain(vcpu);
 		INIT_HLIST_HEAD(&sp->parent_ptes);
 		hlist_add_head(&pte_chain->link, &sp->parent_ptes);
@@ -968,7 +998,7 @@ static void mmu_page_remove_parent_pte(struct kvm_mmu_page *sp,
 	struct hlist_node *node;
 	int i;
 
-	if (!sp->multimapped) {
+	if (!mmu_page_is_multimapped(sp)) {
 		BUG_ON(sp->parent_pte != parent_pte);
 		sp->parent_pte = NULL;
 		return;
@@ -990,7 +1020,7 @@ static void mmu_page_remove_parent_pte(struct kvm_mmu_page *sp,
 				hlist_del(&pte_chain->link);
 				mmu_free_pte_chain(pte_chain);
 				if (hlist_empty(&sp->parent_ptes)) {
-					sp->multimapped = 0;
+					mmu_page_clear_multimapped(sp);
 					sp->parent_pte = NULL;
 				}
 			}
@@ -1010,7 +1040,7 @@ static void mmu_parent_walk(struct kvm_mmu_page *sp, mmu_parent_walk_fn fn)
 	if (!sp->parent_pte)
 		return;
 
-	if (!sp->multimapped) {
+	if (!mmu_page_is_multimapped(sp)) {
 		parent_sp = page_header(__pa(sp->parent_pte));
 		if (fn(parent_sp, sp->parent_pte))
 			mmu_parent_walk(parent_sp, fn);
@@ -1086,7 +1116,7 @@ static int mmu_pages_add(struct kvm_mmu_pages *pvec, struct kvm_mmu_page *sp,
 {
 	int i;
 
-	if (sp->unsync)
+	if (mmu_page_is_unsync(sp))
 		for (i=0; i < pvec->nr; i++)
 			if (pvec->page[i].sp == sp)
 				return 0;
@@ -1122,7 +1152,7 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 					return ret;
 			}
 
-			if (child->unsync) {
+			if (mmu_page_is_unsync(child)) {
 				nr_unsync_leaf++;
 				if (mmu_pages_add(pvec, child, i))
 					return -ENOSPC;
@@ -1168,8 +1198,8 @@ static struct kvm_mmu_page *kvm_mmu_lookup_page(struct kvm *kvm, gfn_t gfn)
 
 static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	WARN_ON(!sp->unsync);
-	sp->unsync = 0;
+	WARN_ON(!mmu_page_is_unsync(sp));
+	mmu_page_clear_unsync(sp);
 	--kvm->stat.mmu_unsync;
 }
 
@@ -1311,7 +1341,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	bucket = &vcpu->kvm->arch.mmu_page_hash[index];
 	hlist_for_each_entry_safe(sp, node, tmp, bucket, hash_link)
 		if (sp->gfn == gfn) {
-			if (sp->unsync)
+			if (mmu_page_is_unsync(sp))
 				if (kvm_sync_page(vcpu, sp))
 					continue;
 
@@ -1427,8 +1457,8 @@ static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	u64 *parent_pte;
 
-	while (sp->multimapped || sp->parent_pte) {
-		if (!sp->multimapped)
+	while (mmu_page_is_multimapped(sp) || sp->parent_pte) {
+		if (!mmu_page_is_multimapped(sp))
 			parent_pte = sp->parent_pte;
 		else {
 			struct kvm_pte_chain *chain;
@@ -1480,7 +1510,7 @@ static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	kvm_flush_remote_tlbs(kvm);
 	if (!sp->role.invalid && !sp->role.direct)
 		unaccount_shadowed(kvm, sp->gfn);
-	if (sp->unsync)
+	if (mmu_page_is_unsync(sp))
 		kvm_unlink_unsync_page(kvm, sp);
 	if (!sp->root_count) {
 		hlist_del(&sp->hash_link);
@@ -1731,8 +1761,7 @@ static int kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 			return 1;
 	}
 	++vcpu->kvm->stat.mmu_unsync;
-	sp->unsync = 1;
-
+	mmu_page_mark_unsync(sp);
 	kvm_mmu_mark_parents_unsync(sp);
 
 	mmu_convert_notrap(sp);
@@ -1748,7 +1777,7 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 	if (shadow) {
 		if (shadow->role.level != PT_PAGE_TABLE_LEVEL)
 			return 1;
-		if (shadow->unsync)
+		 if (mmu_page_is_unsync(shadow))
 			return 0;
 		if (can_unsync && oos_shadow)
 			return kvm_unsync_page(vcpu, shadow);
@@ -3373,7 +3402,7 @@ static void audit_write_protection(struct kvm_vcpu *vcpu)
 	list_for_each_entry(sp, &vcpu->kvm->arch.active_mmu_pages, link) {
 		if (sp->role.direct)
 			continue;
-		if (sp->unsync)
+		if (mmu_page_is_unsync(sp))
 			continue;
 
 		gfn = unalias_gfn(vcpu->kvm, sp->gfn);
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 1fe956a..63a7d9d 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -11,13 +11,13 @@
 	__field(__u64, gfn) \
 	__field(__u32, role) \
 	__field(__u32, root_count) \
-	__field(__u32, unsync)
+	__field(__u32, flags)
 
 #define KVM_MMU_PAGE_ASSIGN(sp)			     \
 	__entry->gfn = sp->gfn;			     \
 	__entry->role = sp->role.word;		     \
 	__entry->root_count = sp->root_count;        \
-	__entry->unsync = sp->unsync;
+	__entry->flags = sp->flags;
 
 #define KVM_MMU_PAGE_PRINTK() ({				        \
 	const char *ret = p->buffer + p->len;				\
@@ -38,7 +38,8 @@
 			 role.cr4_pge ? "" : "!",			\
 			 role.nxe ? "" : "!",				\
 			 __entry->root_count,				\
-			 __entry->unsync ? "unsync" : "sync", 0);	\
+			 __entry->flags & MMU_PAGE_UNSYNC ?		\
+						"unsync" : "sync", 0);	\
 	ret;								\
 		})
 
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index d9dea28..f6de555 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -263,7 +263,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 	gpte = *(const pt_element_t *)pte;
 	if (~gpte & (PT_PRESENT_MASK | PT_ACCESSED_MASK)) {
 		if (!is_present_gpte(gpte)) {
-			if (page->unsync)
+			if (mmu_page_is_unsync(page))
 				new_spte = shadow_trap_nonpresent_pte;
 			else
 				new_spte = shadow_notrap_nonpresent_pte;
-- 
1.6.1.2




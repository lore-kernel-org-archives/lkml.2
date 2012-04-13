Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934824Ab2DMKK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:10:29 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:49700 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab2DMKK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:10:26 -0400
Message-ID: <4F87FB8B.5010205@linux.vnet.ibm.com>
Date: Fri, 13 Apr 2012 18:10:19 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 02/16] KVM: MMU: introduce mmu_spte_establish
References: <4F87FA69.5060106@linux.vnet.ibm.com>
In-Reply-To: <4F87FA69.5060106@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041300-1618-0000-0000-0000014CB13A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is used to establish the spte if it is not present to cleanup the
code, it also marks spte present before linking it to the sp's
parent_list, then we can integrate the code between rmap walking and
parent_lisk walking in the later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c         |   68 +++++++++++++++++++++----------------------
 arch/x86/kvm/paging_tmpl.h |   16 ++++------
 2 files changed, 40 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 151fcddc..aee13c6 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1368,9 +1368,6 @@ static unsigned kvm_page_table_hashfn(gfn_t gfn)
 static void mmu_page_add_parent_pte(struct kvm_vcpu *vcpu,
 				    struct kvm_mmu_page *sp, u64 *parent_pte)
 {
-	if (!parent_pte)
-		return;
-
 	pte_list_add(vcpu, parent_pte, &sp->parent_ptes);
 }

@@ -1401,7 +1398,6 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
 	bitmap_zero(sp->slot_bitmap, KVM_MEM_SLOTS_NUM);
 	sp->parent_ptes = 0;
-	mmu_page_add_parent_pte(vcpu, sp, parent_pte);
 	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
 	return sp;
 }
@@ -1765,12 +1761,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		if (sp->unsync && kvm_sync_page_transient(vcpu, sp))
 			break;

-		mmu_page_add_parent_pte(vcpu, sp, parent_pte);
-		if (sp->unsync_children) {
+		if (sp->unsync_children)
 			kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
-			kvm_mmu_mark_parents_unsync(sp);
-		} else if (sp->unsync)
-			kvm_mmu_mark_parents_unsync(sp);

 		__clear_sp_write_flooding_count(sp);
 		trace_kvm_mmu_get_page(sp, false);
@@ -1797,6 +1789,35 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	return sp;
 }

+static void link_shadow_page(u64 *sptep, struct kvm_mmu_page *sp)
+{
+	u64 spte;
+
+	spte = __pa(sp->spt) | PT_PRESENT_MASK | PT_WRITABLE_MASK |
+	       shadow_user_mask | shadow_x_mask | shadow_accessed_mask;
+
+	mmu_spte_set(sptep, spte);
+}
+
+static struct kvm_mmu_page *
+mmu_spte_establish(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn, gva_t gaddr,
+		   unsigned level, int direct, unsigned access)
+{
+	struct kvm_mmu_page *sp;
+
+	WARN_ON(is_shadow_present_pte(*spte));
+
+	sp = kvm_mmu_get_page(vcpu, gfn, gaddr, level, direct, access, spte);
+
+	link_shadow_page(spte, sp);
+	mmu_page_add_parent_pte(vcpu, sp, spte);
+
+	if (sp->unsync_children || sp->unsync)
+		kvm_mmu_mark_parents_unsync(sp);
+
+	return sp;
+}
+
 static void shadow_walk_init(struct kvm_shadow_walk_iterator *iterator,
 			     struct kvm_vcpu *vcpu, u64 addr)
 {
@@ -1846,16 +1867,6 @@ static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
 	return __shadow_walk_next(iterator, *iterator->sptep);
 }

-static void link_shadow_page(u64 *sptep, struct kvm_mmu_page *sp)
-{
-	u64 spte;
-
-	spte = __pa(sp->spt) | PT_PRESENT_MASK | PT_WRITABLE_MASK |
-	       shadow_user_mask | shadow_x_mask | shadow_accessed_mask;
-
-	mmu_spte_set(sptep, spte);
-}
-
 static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
 {
 	if (is_large_pte(*sptep)) {
@@ -1921,11 +1932,6 @@ static void kvm_mmu_page_unlink_children(struct kvm *kvm,
 		mmu_page_zap_pte(kvm, sp, sp->spt + i);
 }

-static void kvm_mmu_put_page(struct kvm_mmu_page *sp, u64 *parent_pte)
-{
-	mmu_page_remove_parent_pte(sp, parent_pte);
-}
-
 static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	u64 *sptep;
@@ -2511,7 +2517,6 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 			bool prefault)
 {
 	struct kvm_shadow_walk_iterator iterator;
-	struct kvm_mmu_page *sp;
 	int emulate = 0;
 	gfn_t pseudo_gfn;

@@ -2532,16 +2537,9 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,

 			base_addr &= PT64_LVL_ADDR_MASK(iterator.level);
 			pseudo_gfn = base_addr >> PAGE_SHIFT;
-			sp = kvm_mmu_get_page(vcpu, pseudo_gfn, iterator.addr,
-					      iterator.level - 1,
-					      1, ACC_ALL, iterator.sptep);
-			if (!sp) {
-				pgprintk("nonpaging_map: ENOMEM\n");
-				kvm_release_pfn_clean(pfn);
-				return -ENOMEM;
-			}
-
-			link_shadow_page(iterator.sptep, sp);
+			mmu_spte_establish(vcpu, iterator.sptep, pseudo_gfn,
+					   iterator.addr, iterator.level - 1,
+					   1, ACC_ALL);
 		}
 	}
 	return emulate;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index df5a703..e3cf43b 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -503,8 +503,9 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		sp = NULL;
 		if (!is_shadow_present_pte(*it.sptep)) {
 			table_gfn = gw->table_gfn[it.level - 2];
-			sp = kvm_mmu_get_page(vcpu, table_gfn, addr, it.level-1,
-					      false, access, it.sptep);
+			sp = mmu_spte_establish(vcpu, it.sptep, table_gfn,
+						addr, it.level-1, false,
+						access);
 		}

 		/*
@@ -513,9 +514,6 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		 */
 		if (FNAME(gpte_changed)(vcpu, gw, it.level - 1))
 			goto out_gpte_changed;
-
-		if (sp)
-			link_shadow_page(it.sptep, sp);
 	}

 	for (;
@@ -533,9 +531,8 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,

 		direct_gfn = gw->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);

-		sp = kvm_mmu_get_page(vcpu, direct_gfn, addr, it.level-1,
-				      true, direct_access, it.sptep);
-		link_shadow_page(it.sptep, sp);
+		mmu_spte_establish(vcpu, it.sptep, direct_gfn, addr, it.level-1,
+				      true, direct_access);
 	}

 	clear_sp_write_flooding_count(it.sptep);
@@ -548,7 +545,8 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,

 out_gpte_changed:
 	if (sp)
-		kvm_mmu_put_page(sp, it.sptep);
+		drop_parent_pte(sp, it.sptep);
+
 	kvm_release_pfn_clean(pfn);
 	return NULL;
 }
-- 
1.7.7.6


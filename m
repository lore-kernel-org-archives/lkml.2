Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab1LPKPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 05:15:46 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:35563 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab1LPKPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 05:15:37 -0500
Message-ID: <4EEB1A41.7090902@linux.vnet.ibm.com>
Date: Fri, 16 Dec 2011 18:15:29 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 3/8] KVM: MMU: do not add a nonpresent spte to rmaps of its
 child
References: <4EEB19AF.5070501@linux.vnet.ibm.com>
In-Reply-To: <4EEB19AF.5070501@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11121610-5816-0000-0000-000000794F1E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the spte before adding it to the rmap of its child so that all parent
spte are valid when propagate unsync bit from a usnync page / children page

And this feature is needed by the later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c         |   74 +++++++++++++++----------------------------
 arch/x86/kvm/mmutrace.h    |    2 +-
 arch/x86/kvm/paging_tmpl.h |   14 +++-----
 3 files changed, 32 insertions(+), 58 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a2d28aa..89202f4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1321,12 +1321,14 @@ static unsigned kvm_page_table_hashfn(gfn_t gfn)
 	return gfn & ((1 << KVM_MMU_HASH_SHIFT) - 1);
 }

-static void mmu_page_add_parent_pte(struct kvm_vcpu *vcpu,
-				    struct kvm_mmu_page *sp, u64 *parent_pte)
+static void mmu_page_add_set_parent_pte(struct kvm_vcpu *vcpu,
+					struct kvm_mmu_page *sp,
+					u64 *parent_pte)
 {
 	if (!parent_pte)
 		return;

+	mmu_spte_set(parent_pte, __pa(sp->spt) | SHADOW_PAGE_TABLE);
 	pte_list_add(vcpu, parent_pte, &sp->parent_ptes);
 }

@@ -1357,7 +1359,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
 	bitmap_zero(sp->slot_bitmap, KVM_MEM_SLOTS_NUM);
 	sp->parent_ptes = 0;
-	mmu_page_add_parent_pte(vcpu, sp, parent_pte);
+	mmu_page_add_set_parent_pte(vcpu, sp, parent_pte);
 	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
 	return sp;
 }
@@ -1690,13 +1692,10 @@ static void clear_sp_write_flooding_count(u64 *spte)
 	__clear_sp_write_flooding_count(sp);
 }

-static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
-					     gfn_t gfn,
-					     gva_t gaddr,
-					     unsigned level,
-					     int direct,
-					     unsigned access,
-					     u64 *parent_pte)
+static struct kvm_mmu_page *
+kvm_mmu_get_set_page(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gaddr,
+		     unsigned level, int direct, unsigned access,
+		     u64 *parent_pte)
 {
 	union kvm_mmu_page_role role;
 	unsigned quadrant;
@@ -1726,7 +1725,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		if (sp_is_unsync(sp) && kvm_sync_page_transient(vcpu, sp))
 			break;

-		mmu_page_add_parent_pte(vcpu, sp, parent_pte);
+		mmu_page_add_set_parent_pte(vcpu, sp, parent_pte);
 		if (sp_unsync_children_num(sp)) {
 			kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
 			kvm_mmu_mark_parents_unsync(sp);
@@ -1734,7 +1733,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			kvm_mmu_mark_parents_unsync(sp);

 		__clear_sp_write_flooding_count(sp);
-		trace_kvm_mmu_get_page(sp, false);
+		trace_kvm_mmu_get_set_page(sp, false);
 		return sp;
 	}
 	++vcpu->kvm->stat.mmu_cache_miss;
@@ -1754,7 +1753,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		account_shadowed(vcpu->kvm, gfn);
 	}
 	init_shadow_page_table(sp);
-	trace_kvm_mmu_get_page(sp, true);
+	trace_kvm_mmu_get_set_page(sp, true);
 	return sp;
 }

@@ -1807,14 +1806,6 @@ static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
 	return __shadow_walk_next(iterator, *iterator->sptep);
 }

-static void link_shadow_page(u64 *sptep, struct kvm_mmu_page *sp)
-{
-	u64 spte;
-
-	spte = __pa(sp->spt) | SHADOW_PAGE_TABLE;
-	mmu_spte_set(sptep, spte);
-}
-
 static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
 {
 	if (is_large_pte(*sptep)) {
@@ -1879,11 +1870,6 @@ static void kvm_mmu_page_unlink_children(struct kvm *kvm,
 		mmu_page_zap_pte(kvm, sp, sp->spt + i);
 }

-static void kvm_mmu_put_page(struct kvm_mmu_page *sp, u64 *parent_pte)
-{
-	mmu_page_remove_parent_pte(sp, parent_pte);
-}
-
 static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	u64 *parent_pte;
@@ -2468,7 +2454,6 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 			bool prefault)
 {
 	struct kvm_shadow_walk_iterator iterator;
-	struct kvm_mmu_page *sp;
 	int emulate = 0;
 	gfn_t pseudo_gfn;

@@ -2489,16 +2474,9 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,

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
+			kvm_mmu_get_set_page(vcpu, pseudo_gfn, iterator.addr,
+					     iterator.level - 1,
+					     1, ACC_ALL, iterator.sptep);
 		}
 	}
 	return emulate;
@@ -2713,8 +2691,8 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.mmu.shadow_root_level == PT64_ROOT_LEVEL) {
 		spin_lock(&vcpu->kvm->mmu_lock);
 		kvm_mmu_free_some_pages(vcpu);
-		sp = kvm_mmu_get_page(vcpu, 0, 0, PT64_ROOT_LEVEL,
-				      1, ACC_ALL, NULL);
+		sp = kvm_mmu_get_set_page(vcpu, 0, 0, PT64_ROOT_LEVEL,
+					  1, ACC_ALL, NULL);
 		++sp->root_count;
 		spin_unlock(&vcpu->kvm->mmu_lock);
 		vcpu->arch.mmu.root_hpa = __pa(sp->spt);
@@ -2725,10 +2703,10 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 			ASSERT(!VALID_PAGE(root));
 			spin_lock(&vcpu->kvm->mmu_lock);
 			kvm_mmu_free_some_pages(vcpu);
-			sp = kvm_mmu_get_page(vcpu, i << (30 - PAGE_SHIFT),
-					      i << 30,
-					      PT32_ROOT_LEVEL, 1, ACC_ALL,
-					      NULL);
+			sp = kvm_mmu_get_set_page(vcpu, i << (30 - PAGE_SHIFT),
+						  i << 30,
+						  PT32_ROOT_LEVEL, 1, ACC_ALL,
+						  NULL);
 			root = __pa(sp->spt);
 			++sp->root_count;
 			spin_unlock(&vcpu->kvm->mmu_lock);
@@ -2764,8 +2742,8 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)

 		spin_lock(&vcpu->kvm->mmu_lock);
 		kvm_mmu_free_some_pages(vcpu);
-		sp = kvm_mmu_get_page(vcpu, root_gfn, 0, PT64_ROOT_LEVEL,
-				      0, ACC_ALL, NULL);
+		sp = kvm_mmu_get_set_page(vcpu, root_gfn, 0, PT64_ROOT_LEVEL,
+					  0, ACC_ALL, NULL);
 		root = __pa(sp->spt);
 		++sp->root_count;
 		spin_unlock(&vcpu->kvm->mmu_lock);
@@ -2798,9 +2776,9 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		}
 		spin_lock(&vcpu->kvm->mmu_lock);
 		kvm_mmu_free_some_pages(vcpu);
-		sp = kvm_mmu_get_page(vcpu, root_gfn, i << 30,
-				      PT32_ROOT_LEVEL, 0,
-				      ACC_ALL, NULL);
+		sp = kvm_mmu_get_set_page(vcpu, root_gfn, i << 30,
+					  PT32_ROOT_LEVEL, 0,
+					  ACC_ALL, NULL);
 		root = __pa(sp->spt);
 		++sp->root_count;
 		spin_unlock(&vcpu->kvm->mmu_lock);
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 7fe9562..f100078 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -145,7 +145,7 @@ TRACE_EVENT(
 );

 TRACE_EVENT(
-	kvm_mmu_get_page,
+	kvm_mmu_get_set_page,
 	TP_PROTO(struct kvm_mmu_page *sp, bool created),
 	TP_ARGS(sp, created),

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 7dacc80..c79c503 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -503,8 +503,8 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		sp = NULL;
 		if (!is_shadow_present_pte(*it.sptep)) {
 			table_gfn = gw->table_gfn[it.level - 2];
-			sp = kvm_mmu_get_page(vcpu, table_gfn, addr, it.level-1,
-					      false, access, it.sptep);
+			sp = kvm_mmu_get_set_page(vcpu, table_gfn, addr,
+					it.level - 1, false, access, it.sptep);
 		}

 		/*
@@ -513,9 +513,6 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		 */
 		if (FNAME(gpte_changed)(vcpu, gw, it.level - 1))
 			goto out_gpte_changed;
-
-		if (sp)
-			link_shadow_page(it.sptep, sp);
 	}

 	for (;
@@ -533,9 +530,8 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,

 		direct_gfn = gw->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);

-		sp = kvm_mmu_get_page(vcpu, direct_gfn, addr, it.level-1,
-				      true, direct_access, it.sptep);
-		link_shadow_page(it.sptep, sp);
+		kvm_mmu_get_set_page(vcpu, direct_gfn, addr, it.level - 1,
+				     true, direct_access, it.sptep);
 	}

 	clear_sp_write_flooding_count(it.sptep);
@@ -548,7 +544,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,

 out_gpte_changed:
 	if (sp)
-		kvm_mmu_put_page(sp, it.sptep);
+		drop_parent_pte(sp, it.sptep);
 	kvm_release_pfn_clean(pfn);
 	return NULL;
 }
-- 
1.7.7.4


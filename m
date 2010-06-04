Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab0FDN7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 09:59:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60395 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756034Ab0FDN7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 09:59:13 -0400
Message-ID: <4C0905D1.3090104@cn.fujitsu.com>
Date: Fri, 04 Jun 2010 21:55:29 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH v2 5/7] KVM: MMU: gather remote tlb flush which occurs during
 page zapped
References: <4C090511.60206@cn.fujitsu.com>
In-Reply-To: <4C090511.60206@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using kvm_mmu_prepare_zap_page() and kvm_mmu_zap_page() instead of
kvm_mmu_zap_page() that can reduce remote tlb flush IPI

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   84 ++++++++++++++++++++++++++++++++-------------------
 1 files changed, 53 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 77bc4ba..6544d8e 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1200,7 +1200,6 @@ static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	--kvm->stat.mmu_unsync;
 }
 
-static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 				    struct list_head *invalid_list);
 static void kvm_mmu_commit_zap_page(struct kvm *kvm,
@@ -1218,10 +1217,10 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 			(sp)->role.invalid) {} else
 
 static int __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			   bool clear_unsync)
+			   struct list_head *invalid_list, bool clear_unsync)
 {
 	if (sp->role.cr4_pae != !!is_pae(vcpu)) {
-		kvm_mmu_zap_page(vcpu->kvm, sp);
+		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
 		return 1;
 	}
 
@@ -1232,7 +1231,7 @@ static int __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	}
 
 	if (vcpu->arch.mmu.sync_page(vcpu, sp)) {
-		kvm_mmu_zap_page(vcpu->kvm, sp);
+		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
 		return 1;
 	}
 
@@ -1244,17 +1243,22 @@ static void mmu_convert_notrap(struct kvm_mmu_page *sp);
 static int kvm_sync_page_transient(struct kvm_vcpu *vcpu,
 				   struct kvm_mmu_page *sp)
 {
+	LIST_HEAD(invalid_list);
 	int ret;
 
-	ret = __kvm_sync_page(vcpu, sp, false);
+	ret = __kvm_sync_page(vcpu, sp, &invalid_list, false);
 	if (!ret)
 		mmu_convert_notrap(sp);
+	else
+		kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
+
 	return ret;
 }
 
-static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+			 struct list_head *invalid_list)
 {
-	return __kvm_sync_page(vcpu, sp, true);
+	return __kvm_sync_page(vcpu, sp, invalid_list, true);
 }
 
 /* @gfn should be write-protected at the call site */
@@ -1262,6 +1266,7 @@ static void kvm_sync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
 {
 	struct kvm_mmu_page *s;
 	struct hlist_node *node, *n;
+	LIST_HEAD(invalid_list);
 	bool flush = false;
 
 	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node, n) {
@@ -1271,13 +1276,14 @@ static void kvm_sync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
 		WARN_ON(s->role.level != PT_PAGE_TABLE_LEVEL);
 		if ((s->role.cr4_pae != !!is_pae(vcpu)) ||
 			(vcpu->arch.mmu.sync_page(vcpu, s))) {
-			kvm_mmu_zap_page(vcpu->kvm, s);
+			kvm_mmu_prepare_zap_page(vcpu->kvm, s, &invalid_list);
 			continue;
 		}
 		kvm_unlink_unsync_page(vcpu->kvm, s);
 		flush = true;
 	}
 
+	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
 	if (flush)
 		kvm_mmu_flush_tlb(vcpu);
 }
@@ -1348,6 +1354,7 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
 	struct kvm_mmu_page *sp;
 	struct mmu_page_path parents;
 	struct kvm_mmu_pages pages;
+	LIST_HEAD(invalid_list);
 
 	kvm_mmu_pages_init(parent, &parents, &pages);
 	while (mmu_unsync_walk(parent, &pages)) {
@@ -1360,9 +1367,10 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
 			kvm_flush_remote_tlbs(vcpu->kvm);
 
 		for_each_sp(pages, sp, parents, i) {
-			kvm_sync_page(vcpu, sp);
+			kvm_sync_page(vcpu, sp, &invalid_list);
 			mmu_pages_clear_parents(&parents);
 		}
+		kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
 		cond_resched_lock(&vcpu->kvm->mmu_lock);
 		kvm_mmu_pages_init(parent, &parents, &pages);
 	}
@@ -1606,16 +1614,6 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 
 }
 
-static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
-{
-	LIST_HEAD(invalid_list);
-	int ret;
-
-	ret = kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
-	kvm_mmu_commit_zap_page(kvm, &invalid_list);
-	return ret;
-}
-
 /*
  * Changing the number of mmu pages allocated to the vm
  * Note: if kvm_nr_mmu_pages is too small, you will get dead lock
@@ -1623,6 +1621,7 @@ static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages)
 {
 	int used_pages;
+	LIST_HEAD(invalid_list);
 
 	used_pages = kvm->arch.n_alloc_mmu_pages - kvm->arch.n_free_mmu_pages;
 	used_pages = max(0, used_pages);
@@ -1640,8 +1639,10 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages)
 
 			page = container_of(kvm->arch.active_mmu_pages.prev,
 					    struct kvm_mmu_page, link);
-			used_pages -= kvm_mmu_zap_page(kvm, page);
+			used_pages -= kvm_mmu_prepare_zap_page(kvm, page,
+							       &invalid_list);
 		}
+		kvm_mmu_commit_zap_page(kvm, &invalid_list);
 		kvm_nr_mmu_pages = used_pages;
 		kvm->arch.n_free_mmu_pages = 0;
 	}
@@ -1656,6 +1657,7 @@ static int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
 	struct hlist_node *node, *n;
+	LIST_HEAD(invalid_list);
 	int r;
 
 	pgprintk("%s: looking for gfn %lx\n", __func__, gfn);
@@ -1665,9 +1667,10 @@ restart:
 		pgprintk("%s: gfn %lx role %x\n", __func__, gfn,
 			 sp->role.word);
 		r = 1;
-		if (kvm_mmu_zap_page(kvm, sp))
+		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
 			goto restart;
 	}
+	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 	return r;
 }
 
@@ -1675,14 +1678,16 @@ static void mmu_unshadow(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
 	struct hlist_node *node, *nn;
+	LIST_HEAD(invalid_list);
 
 restart:
 	for_each_gfn_indirect_valid_sp(kvm, sp, gfn, node, nn) {
 		pgprintk("%s: zap %lx %x\n",
 			 __func__, gfn, sp->role.word);
-		if (kvm_mmu_zap_page(kvm, sp))
+		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
 			goto restart;
 	}
+	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 }
 
 static void page_header_update_slot(struct kvm *kvm, void *pte, gfn_t gfn)
@@ -2121,6 +2126,7 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 {
 	int i;
 	struct kvm_mmu_page *sp;
+	LIST_HEAD(invalid_list);
 
 	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
 		return;
@@ -2130,8 +2136,10 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 
 		sp = page_header(root);
 		--sp->root_count;
-		if (!sp->root_count && sp->role.invalid)
-			kvm_mmu_zap_page(vcpu->kvm, sp);
+		if (!sp->root_count && sp->role.invalid) {
+			kvm_mmu_prepare_zap_page(vcpu->kvm, sp, &invalid_list);
+			kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
+		}
 		vcpu->arch.mmu.root_hpa = INVALID_PAGE;
 		spin_unlock(&vcpu->kvm->mmu_lock);
 		return;
@@ -2144,10 +2152,12 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 			sp = page_header(root);
 			--sp->root_count;
 			if (!sp->root_count && sp->role.invalid)
-				kvm_mmu_zap_page(vcpu->kvm, sp);
+				kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
+							 &invalid_list);
 		}
 		vcpu->arch.mmu.pae_root[i] = INVALID_PAGE;
 	}
+	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	vcpu->arch.mmu.root_hpa = INVALID_PAGE;
 }
@@ -2713,6 +2723,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	struct kvm_mmu_page *sp;
 	struct hlist_node *node, *n;
+	LIST_HEAD(invalid_list);
 	u64 entry, gentry;
 	u64 *spte;
 	unsigned offset = offset_in_page(gpa);
@@ -2799,7 +2810,8 @@ restart:
 			 */
 			pgprintk("misaligned: gpa %llx bytes %d role %x\n",
 				 gpa, bytes, sp->role.word);
-			if (kvm_mmu_zap_page(vcpu->kvm, sp))
+			if (kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
+						     &invalid_list))
 				goto restart;
 			++vcpu->kvm->stat.mmu_flooded;
 			continue;
@@ -2834,6 +2846,7 @@ restart:
 			++spte;
 		}
 	}
+	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
 	kvm_mmu_audit(vcpu, "post pte write");
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	if (!is_error_pfn(vcpu->arch.update_pte.pfn)) {
@@ -2862,6 +2875,7 @@ EXPORT_SYMBOL_GPL(kvm_mmu_unprotect_page_virt);
 void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 {
 	int free_pages;
+	LIST_HEAD(invalid_list);
 
 	free_pages = vcpu->kvm->arch.n_free_mmu_pages;
 	while (free_pages < KVM_REFILL_PAGES &&
@@ -2870,9 +2884,11 @@ void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 
 		sp = container_of(vcpu->kvm->arch.active_mmu_pages.prev,
 				  struct kvm_mmu_page, link);
-		free_pages += kvm_mmu_zap_page(vcpu->kvm, sp);
+		free_pages += kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
+						       &invalid_list);
 		++vcpu->kvm->stat.mmu_recycled;
 	}
+	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
 }
 
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code)
@@ -3007,25 +3023,28 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 void kvm_mmu_zap_all(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
+	LIST_HEAD(invalid_list);
 
 	spin_lock(&kvm->mmu_lock);
 restart:
 	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link)
-		if (kvm_mmu_zap_page(kvm, sp))
+		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
 			goto restart;
 
+	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 	spin_unlock(&kvm->mmu_lock);
 
 	kvm_flush_remote_tlbs(kvm);
 }
 
-static int kvm_mmu_remove_some_alloc_mmu_pages(struct kvm *kvm)
+static int kvm_mmu_remove_some_alloc_mmu_pages(struct kvm *kvm,
+					       struct list_head *invalid_list)
 {
 	struct kvm_mmu_page *page;
 
 	page = container_of(kvm->arch.active_mmu_pages.prev,
 			    struct kvm_mmu_page, link);
-	return kvm_mmu_zap_page(kvm, page);
+	return kvm_mmu_prepare_zap_page(kvm, page, invalid_list);
 }
 
 static int mmu_shrink(int nr_to_scan, gfp_t gfp_mask)
@@ -3038,6 +3057,7 @@ static int mmu_shrink(int nr_to_scan, gfp_t gfp_mask)
 
 	list_for_each_entry(kvm, &vm_list, vm_list) {
 		int npages, idx, freed_pages;
+		LIST_HEAD(invalid_list);
 
 		idx = srcu_read_lock(&kvm->srcu);
 		spin_lock(&kvm->mmu_lock);
@@ -3045,12 +3065,14 @@ static int mmu_shrink(int nr_to_scan, gfp_t gfp_mask)
 			 kvm->arch.n_free_mmu_pages;
 		cache_count += npages;
 		if (!kvm_freed && nr_to_scan > 0 && npages > 0) {
-			freed_pages = kvm_mmu_remove_some_alloc_mmu_pages(kvm);
+			freed_pages = kvm_mmu_remove_some_alloc_mmu_pages(kvm,
+							  &invalid_list);
 			cache_count -= freed_pages;
 			kvm_freed = kvm;
 		}
 		nr_to_scan--;
 
+		kvm_mmu_commit_zap_page(kvm, &invalid_list);
 		spin_unlock(&kvm->mmu_lock);
 		srcu_read_unlock(&kvm->srcu, idx);
 	}
-- 
1.6.1.2



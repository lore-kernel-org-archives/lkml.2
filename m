Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab0E3MnY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 08:43:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49384 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab0E3MnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 08:43:23 -0400
Message-ID: <4C025C95.5000307@cn.fujitsu.com>
Date: Sun, 30 May 2010 20:39:49 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 3/5] KVM: MMU: gather remote tlb flush which occurs during
 page zapped
References: <4C025BDC.1020304@cn.fujitsu.com>
In-Reply-To: <4C025BDC.1020304@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using kvm_mmu_prepare_zap_page() and kvm_mmu_zap_page() instead of
kvm_mmu_zap_page() that can reduce remote tlb flush IPI

Have tested with xp/vista64, fedora12 32/64 guests, and it not broken

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c      |   75 +++++++++++++++++++----------------------------
 arch/x86/kvm/mmutrace.h |    2 +-
 2 files changed, 31 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0c957bf..e2b1020 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1199,7 +1199,8 @@ static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	--kvm->stat.mmu_unsync;
 }
 
-static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+static void kvm_mmu_commit_zap_page(struct kvm *kvm);
 
 #define for_each_gfn_sp(kvm, sp, gfn, pos, n)				\
   hlist_for_each_entry_safe(sp, pos, n,					\
@@ -1221,7 +1222,7 @@ static int __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			   bool clear_unsync)
 {
 	if (sp->role.cr4_pae != !!is_pae(vcpu)) {
-		kvm_mmu_zap_page(vcpu->kvm, sp);
+		kvm_mmu_prepare_zap_page(vcpu->kvm, sp);
 		return 1;
 	}
 
@@ -1232,7 +1233,7 @@ static int __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	}
 
 	if (vcpu->arch.mmu.sync_page(vcpu, sp)) {
-		kvm_mmu_zap_page(vcpu->kvm, sp);
+		kvm_mmu_prepare_zap_page(vcpu->kvm, sp);
 		return 1;
 	}
 
@@ -1249,6 +1250,7 @@ static int kvm_sync_page_transient(struct kvm_vcpu *vcpu,
 	ret = __kvm_sync_page(vcpu, sp, false);
 	if (!ret)
 		mmu_convert_notrap(sp);
+	kvm_mmu_commit_zap_page(vcpu->kvm);
 	return ret;
 }
 
@@ -1271,13 +1273,13 @@ static void kvm_sync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
 		WARN_ON(s->role.level != PT_PAGE_TABLE_LEVEL);
 		if ((s->role.cr4_pae != !!is_pae(vcpu)) ||
 			(vcpu->arch.mmu.sync_page(vcpu, s))) {
-			kvm_mmu_zap_page(vcpu->kvm, s);
+			kvm_mmu_prepare_zap_page(vcpu->kvm, s);
 			continue;
 		}
 		kvm_unlink_unsync_page(vcpu->kvm, s);
 		flush = true;
 	}
-
+	kvm_mmu_commit_zap_page(vcpu->kvm);
 	if (flush)
 		kvm_mmu_flush_tlb(vcpu);
 }
@@ -1363,6 +1365,7 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
 			kvm_sync_page(vcpu, sp);
 			mmu_pages_clear_parents(&parents);
 		}
+		kvm_mmu_commit_zap_page(vcpu->kvm);
 		cond_resched_lock(&vcpu->kvm->mmu_lock);
 		kvm_mmu_pages_init(parent, &parents, &pages);
 	}
@@ -1551,7 +1554,7 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
 		struct kvm_mmu_page *sp;
 
 		for_each_sp(pages, sp, parents, i) {
-			kvm_mmu_zap_page(kvm, sp);
+			kvm_mmu_prepare_zap_page(kvm, sp);
 			mmu_pages_clear_parents(&parents);
 			zapped++;
 		}
@@ -1565,7 +1568,7 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	int ret;
 
-	trace_kvm_mmu_zap_page(sp);
+	trace_kvm_mmu_prepare_zap_page(sp);
 	++kvm->stat.mmu_shadow_zapped;
 	ret = mmu_zap_unsync_children(kvm, sp);
 	kvm_mmu_page_unlink_children(kvm, sp);
@@ -1601,33 +1604,6 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm)
 	}
 }
 
-static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
-{
-	int ret;
-
-	trace_kvm_mmu_zap_page(sp);
-	++kvm->stat.mmu_shadow_zapped;
-	ret = mmu_zap_unsync_children(kvm, sp);
-	kvm_mmu_page_unlink_children(kvm, sp);
-	kvm_mmu_unlink_parents(kvm, sp);
-	kvm_flush_remote_tlbs(kvm);
-	if (!sp->role.invalid && !sp->role.direct)
-		unaccount_shadowed(kvm, sp->gfn);
-	if (sp->unsync)
-		kvm_unlink_unsync_page(kvm, sp);
-	if (!sp->root_count) {
-		/* Count self */
-		ret++;
-		kvm_mmu_free_page(kvm, sp);
-	} else {
-		sp->role.invalid = 1;
-		list_move(&sp->link, &kvm->arch.active_mmu_pages);
-		kvm_reload_remote_mmus(kvm);
-	}
-	kvm_mmu_reset_last_pte_updated(kvm);
-	return ret;
-}
-
 /*
  * Changing the number of mmu pages allocated to the vm
  * Note: if kvm_nr_mmu_pages is too small, you will get dead lock
@@ -1652,8 +1628,9 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages)
 
 			page = container_of(kvm->arch.active_mmu_pages.prev,
 					    struct kvm_mmu_page, link);
-			used_pages -= kvm_mmu_zap_page(kvm, page);
+			used_pages -= kvm_mmu_prepare_zap_page(kvm, page);
 		}
+		kvm_mmu_commit_zap_page(kvm);
 		kvm_nr_mmu_pages = used_pages;
 		kvm->arch.n_free_mmu_pages = 0;
 	}
@@ -1677,9 +1654,10 @@ restart:
 		pgprintk("%s: gfn %lx role %x\n", __func__, gfn,
 			 sp->role.word);
 		r = 1;
-		if (kvm_mmu_zap_page(kvm, sp))
+		if (kvm_mmu_prepare_zap_page(kvm, sp))
 			goto restart;
 	}
+	kvm_mmu_commit_zap_page(kvm);
 	return r;
 }
 
@@ -1692,9 +1670,10 @@ restart:
 	for_each_gfn_indirect_valid_sp(kvm, sp, gfn, node, nn) {
 		pgprintk("%s: zap %lx %x\n",
 			 __func__, gfn, sp->role.word);
-		if (kvm_mmu_zap_page(kvm, sp))
+		if (kvm_mmu_prepare_zap_page(kvm, sp))
 			goto restart;
 	}
+	kvm_mmu_commit_zap_page(kvm);
 }
 
 static void page_header_update_slot(struct kvm *kvm, void *pte, gfn_t gfn)
@@ -2121,8 +2100,10 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 
 		sp = page_header(root);
 		--sp->root_count;
-		if (!sp->root_count && sp->role.invalid)
-			kvm_mmu_zap_page(vcpu->kvm, sp);
+		if (!sp->root_count && sp->role.invalid) {
+			kvm_mmu_prepare_zap_page(vcpu->kvm, sp);
+			kvm_mmu_commit_zap_page(vcpu->kvm);
+		}
 		vcpu->arch.mmu.root_hpa = INVALID_PAGE;
 		spin_unlock(&vcpu->kvm->mmu_lock);
 		return;
@@ -2135,10 +2116,11 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 			sp = page_header(root);
 			--sp->root_count;
 			if (!sp->root_count && sp->role.invalid)
-				kvm_mmu_zap_page(vcpu->kvm, sp);
+				kvm_mmu_prepare_zap_page(vcpu->kvm, sp);
 		}
 		vcpu->arch.mmu.pae_root[i] = INVALID_PAGE;
 	}
+	kvm_mmu_commit_zap_page(vcpu->kvm);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	vcpu->arch.mmu.root_hpa = INVALID_PAGE;
 }
@@ -2792,7 +2774,7 @@ restart:
 			 */
 			pgprintk("misaligned: gpa %llx bytes %d role %x\n",
 				 gpa, bytes, sp->role.word);
-			if (kvm_mmu_zap_page(vcpu->kvm, sp))
+			if (kvm_mmu_prepare_zap_page(vcpu->kvm, sp))
 				goto restart;
 			++vcpu->kvm->stat.mmu_flooded;
 			continue;
@@ -2827,6 +2809,7 @@ restart:
 			++spte;
 		}
 	}
+	kvm_mmu_commit_zap_page(vcpu->kvm);
 	kvm_mmu_audit(vcpu, "post pte write");
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	if (!is_error_pfn(vcpu->arch.update_pte.pfn)) {
@@ -2860,9 +2843,10 @@ void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 
 		sp = container_of(vcpu->kvm->arch.active_mmu_pages.prev,
 				  struct kvm_mmu_page, link);
-		kvm_mmu_zap_page(vcpu->kvm, sp);
+		kvm_mmu_prepare_zap_page(vcpu->kvm, sp);
 		++vcpu->kvm->stat.mmu_recycled;
 	}
+	kvm_mmu_commit_zap_page(vcpu->kvm);
 }
 
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code)
@@ -3001,9 +2985,10 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	spin_lock(&kvm->mmu_lock);
 restart:
 	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link)
-		if (kvm_mmu_zap_page(kvm, sp))
+		if (kvm_mmu_prepare_zap_page(kvm, sp))
 			goto restart;
 
+	kvm_mmu_commit_zap_page(kvm);
 	spin_unlock(&kvm->mmu_lock);
 
 	kvm_flush_remote_tlbs(kvm);
@@ -3015,7 +3000,7 @@ static int kvm_mmu_remove_some_alloc_mmu_pages(struct kvm *kvm)
 
 	page = container_of(kvm->arch.active_mmu_pages.prev,
 			    struct kvm_mmu_page, link);
-	return kvm_mmu_zap_page(kvm, page);
+	return kvm_mmu_prepare_zap_page(kvm, page);
 }
 
 static int mmu_shrink(int nr_to_scan, gfp_t gfp_mask)
@@ -3040,7 +3025,7 @@ static int mmu_shrink(int nr_to_scan, gfp_t gfp_mask)
 			kvm_freed = kvm;
 		}
 		nr_to_scan--;
-
+		kvm_mmu_commit_zap_page(kvm);
 		spin_unlock(&kvm->mmu_lock);
 		srcu_read_unlock(&kvm->srcu, idx);
 	}
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 42f07b1..3aab0f0 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -190,7 +190,7 @@ DEFINE_EVENT(kvm_mmu_page_class, kvm_mmu_unsync_page,
 	TP_ARGS(sp)
 );
 
-DEFINE_EVENT(kvm_mmu_page_class, kvm_mmu_zap_page,
+DEFINE_EVENT(kvm_mmu_page_class, kvm_mmu_prepare_zap_page,
 	TP_PROTO(struct kvm_mmu_page *sp),
 
 	TP_ARGS(sp)
-- 
1.6.1.2



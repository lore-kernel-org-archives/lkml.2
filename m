Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab0DLIJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 04:09:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57671 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752548Ab0DLIJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 04:09:00 -0400
Message-ID: <4BC2D481.9060101@cn.fujitsu.com>
Date: Mon, 12 Apr 2010 16:06:25 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] KVM MMU: optimize synchronization shadow pages
References: <4BC2D2E2.1030604@cn.fujitsu.com>
In-Reply-To: <4BC2D2E2.1030604@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- chain all unsync shadow pages then we can fetch them quickly
- flush local/remote tlb after all shadow page synced

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |   82 ++++++++++++++++++---------------------
 2 files changed, 39 insertions(+), 44 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d463bc6..ae543fb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -207,6 +207,7 @@ struct kvm_mmu_page {
 	#define MMU_PAGE_UNSYNC 0x2
 	unsigned int flags;
 	unsigned int unsync_children;
+	struct list_head unsync_link;
 	union {
 		u64 *parent_pte;               /* !multimapped */
 		struct hlist_head parent_ptes; /* multimapped, kvm_pte_chain */
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 18eceb2..fcb6299 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -177,6 +177,8 @@ typedef int (*mmu_parent_walk_fn) (struct kvm_mmu_page *sp, u64 *spte);
 static struct kmem_cache *pte_chain_cache;
 static struct kmem_cache *rmap_desc_cache;
 static struct kmem_cache *mmu_page_header_cache;
+static struct list_head unsync_mmu_page_list =
+			LIST_HEAD_INIT(unsync_mmu_page_list);
 
 static u64 __read_mostly shadow_trap_nonpresent_pte;
 static u64 __read_mostly shadow_notrap_nonpresent_pte;
@@ -950,6 +952,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
 	sp->flags = 0;
 	sp->parent_pte = parent_pte;
+	INIT_LIST_HEAD(&sp->unsync_link);
 	--vcpu->kvm->arch.n_free_mmu_pages;
 	return sp;
 }
@@ -1200,12 +1203,14 @@ static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	WARN_ON(!mmu_page_is_unsync(sp));
 	mmu_page_clear_unsync(sp);
+	list_del(&sp->unsync_link);
 	--kvm->stat.mmu_unsync;
 }
 
 static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
-static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+static int __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+			   bool *flush_local_tlb, bool *flush_remote_tlb)
 {
 	if (sp->role.glevels != vcpu->arch.mmu.root_level) {
 		kvm_mmu_zap_page(vcpu->kvm, sp);
@@ -1214,17 +1219,31 @@ static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 
 	trace_kvm_mmu_sync_page(sp);
 	if (rmap_write_protect(vcpu->kvm, sp->gfn))
-		kvm_flush_remote_tlbs(vcpu->kvm);
+		*flush_remote_tlb = true;
 	kvm_unlink_unsync_page(vcpu->kvm, sp);
 	if (vcpu->arch.mmu.sync_page(vcpu, sp)) {
 		kvm_mmu_zap_page(vcpu->kvm, sp);
 		return 1;
 	}
 
-	kvm_mmu_flush_tlb(vcpu);
+	*flush_local_tlb = true;
 	return 0;
 }
 
+static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+{
+	bool flush_local_tlb = false, flush_remote_tlb = false;
+	int ret;
+
+	ret = __kvm_sync_page(vcpu, sp, &flush_local_tlb, &flush_remote_tlb);
+	if (flush_local_tlb)
+		kvm_mmu_flush_tlb(vcpu);
+	if (flush_remote_tlb)
+		kvm_flush_remote_tlbs(vcpu->kvm);
+
+       return ret;
+}
+
 struct mmu_page_path {
 	struct kvm_mmu_page *parent[PT64_ROOT_LEVEL-1];
 	unsigned int idx[PT64_ROOT_LEVEL-1];
@@ -1284,31 +1303,24 @@ static void kvm_mmu_pages_init(struct kvm_mmu_page *parent,
 	pvec->nr = 0;
 }
 
-static void mmu_sync_children(struct kvm_vcpu *vcpu,
-			      struct kvm_mmu_page *parent)
+static void mmu_sync_pages(struct kvm_vcpu *vcpu)
 {
-	int i;
-	struct kvm_mmu_page *sp;
-	struct mmu_page_path parents;
-	struct kvm_mmu_pages pages;
-
-	kvm_mmu_pages_init(parent, &parents, &pages);
-	while (mmu_unsync_walk(parent, &pages)) {
-		int protected = 0;
-
-		for_each_sp(pages, sp, parents, i)
-			protected |= rmap_write_protect(vcpu->kvm, sp->gfn);
+	struct list_head *p, *next;
+	bool flush_local_tlb = false, flush_remote_tlb = false;
 
-		if (protected)
-			kvm_flush_remote_tlbs(vcpu->kvm);
+	if (list_empty(&unsync_mmu_page_list))
+		return;
 
-		for_each_sp(pages, sp, parents, i) {
-			kvm_sync_page(vcpu, sp);
-			mmu_pages_clear_parents(&parents);
-		}
-		cond_resched_lock(&vcpu->kvm->mmu_lock);
-		kvm_mmu_pages_init(parent, &parents, &pages);
+	list_for_each_safe(p, next, &unsync_mmu_page_list) {
+		struct kvm_mmu_page *sp;
+		sp = list_entry(p, struct kvm_mmu_page, unsync_link);
+		__kvm_sync_page(vcpu, sp, &flush_local_tlb, &flush_remote_tlb);
 	}
+
+	if (flush_local_tlb)
+		kvm_mmu_flush_tlb(vcpu);
+	if (flush_remote_tlb)
+		kvm_flush_remote_tlbs(vcpu->kvm);
 }
 
 static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
@@ -1762,6 +1774,7 @@ static int kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	}
 	++vcpu->kvm->stat.mmu_unsync;
 	mmu_page_mark_unsync(sp);
+	list_add(&sp->unsync_link, &unsync_mmu_page_list);
 	kvm_mmu_mark_parents_unsync(sp);
 
 	mmu_convert_notrap(sp);
@@ -2121,26 +2134,7 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
 
 static void mmu_sync_roots(struct kvm_vcpu *vcpu)
 {
-	int i;
-	struct kvm_mmu_page *sp;
-
-	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
-		return;
-	if (vcpu->arch.mmu.shadow_root_level == PT64_ROOT_LEVEL) {
-		hpa_t root = vcpu->arch.mmu.root_hpa;
-		sp = page_header(root);
-		mmu_sync_children(vcpu, sp);
-		return;
-	}
-	for (i = 0; i < 4; ++i) {
-		hpa_t root = vcpu->arch.mmu.pae_root[i];
-
-		if (root && VALID_PAGE(root)) {
-			root &= PT64_BASE_ADDR_MASK;
-			sp = page_header(root);
-			mmu_sync_children(vcpu, sp);
-		}
-	}
+	mmu_sync_pages(vcpu);
 }
 
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
-- 
1.6.1.2



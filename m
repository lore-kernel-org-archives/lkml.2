Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab0DLIFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 04:05:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50714 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab0DLIE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 04:04:59 -0400
Message-ID: <4BC2D390.7050708@cn.fujitsu.com>
Date: Mon, 12 Apr 2010 16:02:24 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/6] KVM MMU: optimize/cleanup for marking parent unsync
References: <4BC2D2E2.1030604@cn.fujitsu.com>
In-Reply-To: <4BC2D2E2.1030604@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- 'vcpu' is not used while mark parent unsync, so remove it
- if it has alread marked unsync, no need to walk it's parent

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   69 +++++++++++++++++----------------------------------
 1 files changed, 23 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8f4f781..5154d70 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -172,7 +172,7 @@ struct kvm_shadow_walk_iterator {
 	     shadow_walk_okay(&(_walker));			\
 	     shadow_walk_next(&(_walker)))
 
-typedef int (*mmu_parent_walk_fn) (struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp);
+typedef int (*mmu_parent_walk_fn) (struct kvm_mmu_page *sp, u64 *spte);
 
 static struct kmem_cache *pte_chain_cache;
 static struct kmem_cache *rmap_desc_cache;
@@ -1000,74 +1000,51 @@ static void mmu_page_remove_parent_pte(struct kvm_mmu_page *sp,
 }
 
 
-static void mmu_parent_walk(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			    mmu_parent_walk_fn fn)
+static void mmu_parent_walk(struct kvm_mmu_page *sp, mmu_parent_walk_fn fn)
 {
 	struct kvm_pte_chain *pte_chain;
 	struct hlist_node *node;
 	struct kvm_mmu_page *parent_sp;
 	int i;
 
-	if (!sp->multimapped && sp->parent_pte) {
+	if (!sp->parent_pte)
+		return;
+
+	if (!sp->multimapped) {
 		parent_sp = page_header(__pa(sp->parent_pte));
-		fn(vcpu, parent_sp);
-		mmu_parent_walk(vcpu, parent_sp, fn);
+		if (fn(parent_sp, sp->parent_pte))
+			mmu_parent_walk(parent_sp, fn);
 		return;
 	}
+
 	hlist_for_each_entry(pte_chain, node, &sp->parent_ptes, link)
 		for (i = 0; i < NR_PTE_CHAIN_ENTRIES; ++i) {
-			if (!pte_chain->parent_ptes[i])
+			u64 *spte = pte_chain->parent_ptes[i];
+			if (!spte)
 				break;
-			parent_sp = page_header(__pa(pte_chain->parent_ptes[i]));
-			fn(vcpu, parent_sp);
-			mmu_parent_walk(vcpu, parent_sp, fn);
+			parent_sp = page_header(__pa(spte));
+			if (fn(parent_sp, spte))
+				mmu_parent_walk(parent_sp, fn);
 		}
 }
 
-static void kvm_mmu_update_unsync_bitmap(u64 *spte)
+static int mark_unsync(struct kvm_mmu_page *sp, u64 *spte)
 {
 	unsigned int index;
-	struct kvm_mmu_page *sp = page_header(__pa(spte));
 
 	index = spte - sp->spt;
-	if (!__test_and_set_bit(index, sp->unsync_child_bitmap))
-		sp->unsync_children++;
-	WARN_ON(!sp->unsync_children);
-}
-
-static void kvm_mmu_update_parents_unsync(struct kvm_mmu_page *sp)
-{
-	struct kvm_pte_chain *pte_chain;
-	struct hlist_node *node;
-	int i;
-
-	if (!sp->parent_pte)
-		return;
-
-	if (!sp->multimapped) {
-		kvm_mmu_update_unsync_bitmap(sp->parent_pte);
-		return;
-	}
+	if (__test_and_set_bit(index, sp->unsync_child_bitmap))
+		return 0;
 
-	hlist_for_each_entry(pte_chain, node, &sp->parent_ptes, link)
-		for (i = 0; i < NR_PTE_CHAIN_ENTRIES; ++i) {
-			if (!pte_chain->parent_ptes[i])
-				break;
-			kvm_mmu_update_unsync_bitmap(pte_chain->parent_ptes[i]);
-		}
-}
+	if (sp->unsync_children++)
+		return 0;
 
-static int unsync_walk_fn(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
-{
-	kvm_mmu_update_parents_unsync(sp);
 	return 1;
 }
 
-static void kvm_mmu_mark_parents_unsync(struct kvm_vcpu *vcpu,
-					struct kvm_mmu_page *sp)
+static void kvm_mmu_mark_parents_unsync(struct kvm_mmu_page *sp)
 {
-	mmu_parent_walk(vcpu, sp, unsync_walk_fn);
-	kvm_mmu_update_parents_unsync(sp);
+	mmu_parent_walk(sp, mark_unsync);
 }
 
 static void nonpaging_prefetch_page(struct kvm_vcpu *vcpu,
@@ -1344,7 +1321,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			mmu_page_add_parent_pte(vcpu, sp, parent_pte);
 			if (sp->unsync_children) {
 				set_bit(KVM_REQ_MMU_SYNC, &vcpu->requests);
-				kvm_mmu_mark_parents_unsync(vcpu, sp);
+				kvm_mmu_mark_parents_unsync(sp);
 			}
 			trace_kvm_mmu_get_page(sp, false);
 			return sp;
@@ -1756,7 +1733,7 @@ static int kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	++vcpu->kvm->stat.mmu_unsync;
 	sp->unsync = 1;
 
-	kvm_mmu_mark_parents_unsync(vcpu, sp);
+	kvm_mmu_mark_parents_unsync(sp);
 
 	mmu_convert_notrap(sp);
 	return 0;
-- 
1.6.1.2



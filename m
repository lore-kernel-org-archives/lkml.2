Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760374Ab0FKNiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 09:38:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50875 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760314Ab0FKNit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 09:38:49 -0400
Message-ID: <4C123B93.7060803@cn.fujitsu.com>
Date: Fri, 11 Jun 2010 21:35:15 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 7/7] KVM: MMU: don't walk every parent pages while mark unsync
References: <4C1239EE.3090904@cn.fujitsu.com>
In-Reply-To: <4C1239EE.3090904@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While we mark the parent's unsync_child_bitmap, if the parent is already
unsynced, it no need walk it's parent, it can reduce some unnecessary
workload

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   61 ++++++++++++++-------------------------------------
 1 files changed, 17 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index eb20682..a92863f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -175,7 +175,7 @@ struct kvm_shadow_walk_iterator {
 	     shadow_walk_okay(&(_walker));			\
 	     shadow_walk_next(&(_walker)))
 
-typedef int (*mmu_parent_walk_fn) (struct kvm_mmu_page *sp);
+typedef void (*mmu_parent_walk_fn) (struct kvm_mmu_page *sp, u64 *spte);
 
 static struct kmem_cache *pte_chain_cache;
 static struct kmem_cache *rmap_desc_cache;
@@ -1024,7 +1024,6 @@ static void mmu_page_remove_parent_pte(struct kvm_mmu_page *sp,
 	BUG();
 }
 
-
 static void mmu_parent_walk(struct kvm_mmu_page *sp, mmu_parent_walk_fn fn)
 {
 	struct kvm_pte_chain *pte_chain;
@@ -1034,63 +1033,37 @@ static void mmu_parent_walk(struct kvm_mmu_page *sp, mmu_parent_walk_fn fn)
 
 	if (!sp->multimapped && sp->parent_pte) {
 		parent_sp = page_header(__pa(sp->parent_pte));
-		fn(parent_sp);
-		mmu_parent_walk(parent_sp, fn);
+		fn(parent_sp, sp->parent_pte);
 		return;
 	}
+
 	hlist_for_each_entry(pte_chain, node, &sp->parent_ptes, link)
 		for (i = 0; i < NR_PTE_CHAIN_ENTRIES; ++i) {
-			if (!pte_chain->parent_ptes[i])
+			u64 *spte = pte_chain->parent_ptes[i];
+
+			if (!spte)
 				break;
-			parent_sp = page_header(__pa(pte_chain->parent_ptes[i]));
-			fn(parent_sp);
-			mmu_parent_walk(parent_sp, fn);
+			parent_sp = page_header(__pa(spte));
+			fn(parent_sp, spte);
 		}
 }
 
-static void kvm_mmu_update_unsync_bitmap(u64 *spte)
+static void mark_unsync(struct kvm_mmu_page *sp, u64 *spte);
+static void kvm_mmu_mark_parents_unsync(struct kvm_mmu_page *sp)
 {
-	unsigned int index;
-	struct kvm_mmu_page *sp = page_header(__pa(spte));
-
-	index = spte - sp->spt;
-	if (!__test_and_set_bit(index, sp->unsync_child_bitmap))
-		sp->unsync_children++;
-	WARN_ON(!sp->unsync_children);
+	mmu_parent_walk(sp, mark_unsync);
 }
 
-static void kvm_mmu_update_parents_unsync(struct kvm_mmu_page *sp)
+static void mark_unsync(struct kvm_mmu_page *sp, u64 *spte)
 {
-	struct kvm_pte_chain *pte_chain;
-	struct hlist_node *node;
-	int i;
+	unsigned int index;
 
-	if (!sp->parent_pte)
+	index = spte - sp->spt;
+	if (__test_and_set_bit(index, sp->unsync_child_bitmap))
 		return;
-
-	if (!sp->multimapped) {
-		kvm_mmu_update_unsync_bitmap(sp->parent_pte);
+	if (sp->unsync_children++)
 		return;
-	}
-
-	hlist_for_each_entry(pte_chain, node, &sp->parent_ptes, link)
-		for (i = 0; i < NR_PTE_CHAIN_ENTRIES; ++i) {
-			if (!pte_chain->parent_ptes[i])
-				break;
-			kvm_mmu_update_unsync_bitmap(pte_chain->parent_ptes[i]);
-		}
-}
-
-static int unsync_walk_fn(struct kvm_mmu_page *sp)
-{
-	kvm_mmu_update_parents_unsync(sp);
-	return 1;
-}
-
-static void kvm_mmu_mark_parents_unsync(struct kvm_mmu_page *sp)
-{
-	mmu_parent_walk(sp, unsync_walk_fn);
-	kvm_mmu_update_parents_unsync(sp);
+	kvm_mmu_mark_parents_unsync(sp);
 }
 
 static void nonpaging_prefetch_page(struct kvm_vcpu *vcpu,
-- 
1.6.1.2



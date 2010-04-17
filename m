Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab0DQIuK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 04:50:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55344 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab0DQIuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 04:50:08 -0400
Message-ID: <4BC97645.8050009@cn.fujitsu.com>
Date: Sat, 17 Apr 2010 16:50:13 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: [PATCH] kvm x86 mmu: simplify kvm_mmu_unlink_parents()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mmu_page_remove_parent_pte() does much maintenance works,
but kvm_mmu_unlink_parents() unlink all parents, so
such maintenance works are not need.

This patch simplifies the works of kvm_mmu_unlink_parents()
by unlinking parents without so many maintenance works.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 90f666e..71faa04 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1453,22 +1453,33 @@ static void kvm_mmu_reset_last_pte_updated(struct kvm *kvm)
 
 static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	u64 *parent_pte;
+	if (!sp->multimapped) {
+		if (!sp->parent_pte)
+			return;
 
-	while (sp->multimapped || sp->parent_pte) {
-		if (!sp->multimapped)
-			parent_pte = sp->parent_pte;
-		else {
-			struct kvm_pte_chain *chain;
+		__set_spte(sp->parent_pte, shadow_trap_nonpresent_pte);
+		sp->parent_pte = NULL;
+		return;
+	}
 
-			chain = container_of(sp->parent_ptes.first,
-					     struct kvm_pte_chain, link);
-			parent_pte = chain->parent_ptes[0];
+	while (!hlist_empty(&sp->parent_ptes)) {
+		struct kvm_pte_chain *chain;
+		u64 *parent_pte;
+		int i;
+
+		chain = hlist_entry(sp->parent_ptes.first,
+				    struct kvm_pte_chain, link);
+		for (i = 0; i < NR_PTE_CHAIN_ENTRIES; ++i) {
+			parent_pte = chain->parent_ptes[i];
+			if (!parent_pte)
+				break;
+			__set_spte(parent_pte, shadow_trap_nonpresent_pte);
 		}
-		BUG_ON(!parent_pte);
-		kvm_mmu_put_page(sp, parent_pte);
-		__set_spte(parent_pte, shadow_trap_nonpresent_pte);
+		hlist_del(&chain->link);
+		mmu_free_pte_chain(chain);
 	}
+	sp->multimapped = 0;
+	sp->parent_pte = NULL;
 }
 
 static int mmu_zap_unsync_children(struct kvm *kvm,


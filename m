Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab0DONcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 09:32:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60590 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753567Ab0DONcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 09:32:11 -0400
Message-ID: <4BC8662D.8010001@cn.fujitsu.com>
Date: Fri, 16 Apr 2010 21:29:17 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 5/5] KVM MMU: remove unused parameter in mmu_parent_walk()
References: <4BC864DD.3000606@cn.fujitsu.com> <4BC8652F.5010006@cn.fujitsu.com> <4BC86591.3050803@cn.fujitsu.com> <4BC865DA.8020705@cn.fujitsu.com>
In-Reply-To: <4BC865DA.8020705@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'vcpu' is unused, remove it

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a32c60c..2f8ae9e 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -172,7 +172,7 @@ struct kvm_shadow_walk_iterator {
 	     shadow_walk_okay(&(_walker));			\
 	     shadow_walk_next(&(_walker)))
 
-typedef int (*mmu_parent_walk_fn) (struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp);
+typedef int (*mmu_parent_walk_fn) (struct kvm_mmu_page *sp);
 
 static struct kmem_cache *pte_chain_cache;
 static struct kmem_cache *rmap_desc_cache;
@@ -1000,8 +1000,7 @@ static void mmu_page_remove_parent_pte(struct kvm_mmu_page *sp,
 }
 
 
-static void mmu_parent_walk(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			    mmu_parent_walk_fn fn)
+static void mmu_parent_walk(struct kvm_mmu_page *sp, mmu_parent_walk_fn fn)
 {
 	struct kvm_pte_chain *pte_chain;
 	struct hlist_node *node;
@@ -1010,8 +1009,8 @@ static void mmu_parent_walk(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 
 	if (!sp->multimapped && sp->parent_pte) {
 		parent_sp = page_header(__pa(sp->parent_pte));
-		fn(vcpu, parent_sp);
-		mmu_parent_walk(vcpu, parent_sp, fn);
+		fn(parent_sp);
+		mmu_parent_walk(parent_sp, fn);
 		return;
 	}
 	hlist_for_each_entry(pte_chain, node, &sp->parent_ptes, link)
@@ -1019,8 +1018,8 @@ static void mmu_parent_walk(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			if (!pte_chain->parent_ptes[i])
 				break;
 			parent_sp = page_header(__pa(pte_chain->parent_ptes[i]));
-			fn(vcpu, parent_sp);
-			mmu_parent_walk(vcpu, parent_sp, fn);
+			fn(parent_sp);
+			mmu_parent_walk(parent_sp, fn);
 		}
 }
 
@@ -1057,16 +1056,15 @@ static void kvm_mmu_update_parents_unsync(struct kvm_mmu_page *sp)
 		}
 }
 
-static int unsync_walk_fn(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+static int unsync_walk_fn(struct kvm_mmu_page *sp)
 {
 	kvm_mmu_update_parents_unsync(sp);
 	return 1;
 }
 
-static void kvm_mmu_mark_parents_unsync(struct kvm_vcpu *vcpu,
-					struct kvm_mmu_page *sp)
+static void kvm_mmu_mark_parents_unsync(struct kvm_mmu_page *sp)
 {
-	mmu_parent_walk(vcpu, sp, unsync_walk_fn);
+	mmu_parent_walk(sp, unsync_walk_fn);
 	kvm_mmu_update_parents_unsync(sp);
 }
 
@@ -1344,7 +1342,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			mmu_page_add_parent_pte(vcpu, sp, parent_pte);
 			if (sp->unsync_children) {
 				set_bit(KVM_REQ_MMU_SYNC, &vcpu->requests);
-				kvm_mmu_mark_parents_unsync(vcpu, sp);
+				kvm_mmu_mark_parents_unsync(sp);
 			}
 			trace_kvm_mmu_get_page(sp, false);
 			return sp;
@@ -1761,7 +1759,7 @@ static int kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	++vcpu->kvm->stat.mmu_unsync;
 	sp->unsync = 1;
 
-	kvm_mmu_mark_parents_unsync(vcpu, sp);
+	kvm_mmu_mark_parents_unsync(sp);
 
 	mmu_convert_notrap(sp);
 	return 0;
-- 
1.6.1.2


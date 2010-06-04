Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab0FDN5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 09:57:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57344 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755911Ab0FDN53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 09:57:29 -0400
Message-ID: <4C090572.5010109@cn.fujitsu.com>
Date: Fri, 04 Jun 2010 21:53:54 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH v2 3/7] KVM: MMU: split the operations of kvm_mmu_zap_page()
References: <4C090511.60206@cn.fujitsu.com>
In-Reply-To: <4C090511.60206@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using kvm_mmu_prepare_zap_page() and kvm_mmu_commit_zap_page() to
split kvm_mmu_zap_page() function, then we can:

- traverse hlist safely
- easily to gather remote tlb flush which occurs during page zapped

Those feature can be used in the later patches

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c      |   52 ++++++++++++++++++++++++++++++++++++++--------
 arch/x86/kvm/mmutrace.h |    2 +-
 2 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 75bd6df..a64c0e0 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -916,6 +916,7 @@ static int is_empty_shadow_page(u64 *spt)
 static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	ASSERT(is_empty_shadow_page(sp->spt));
+	hlist_del(&sp->hash_link);
 	list_del(&sp->link);
 	__free_page(virt_to_page(sp->spt));
 	if (!sp->role.direct)
@@ -1200,6 +1201,10 @@ static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 }
 
 static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+				    struct list_head *invalid_list);
+static void kvm_mmu_commit_zap_page(struct kvm *kvm,
+				    struct list_head *invalid_list);
 
 #define for_each_gfn_sp(kvm, sp, gfn, pos, n)				\
   hlist_for_each_entry_safe(sp, pos, n,					\
@@ -1530,7 +1535,8 @@ static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
 }
 
 static int mmu_zap_unsync_children(struct kvm *kvm,
-				   struct kvm_mmu_page *parent)
+				   struct kvm_mmu_page *parent,
+				   struct list_head *invalid_list)
 {
 	int i, zapped = 0;
 	struct mmu_page_path parents;
@@ -1544,7 +1550,7 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
 		struct kvm_mmu_page *sp;
 
 		for_each_sp(pages, sp, parents, i) {
-			kvm_mmu_zap_page(kvm, sp);
+			kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
 			mmu_pages_clear_parents(&parents);
 			zapped++;
 		}
@@ -1554,16 +1560,16 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
 	return zapped;
 }
 
-static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+				    struct list_head *invalid_list)
 {
 	int ret;
 
-	trace_kvm_mmu_zap_page(sp);
+	trace_kvm_mmu_prepare_zap_page(sp);
 	++kvm->stat.mmu_shadow_zapped;
-	ret = mmu_zap_unsync_children(kvm, sp);
+	ret = mmu_zap_unsync_children(kvm, sp, invalid_list);
 	kvm_mmu_page_unlink_children(kvm, sp);
 	kvm_mmu_unlink_parents(kvm, sp);
-	kvm_flush_remote_tlbs(kvm);
 	if (!sp->role.invalid && !sp->role.direct)
 		unaccount_shadowed(kvm, sp->gfn);
 	if (sp->unsync)
@@ -1571,17 +1577,45 @@ static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	if (!sp->root_count) {
 		/* Count self */
 		ret++;
-		hlist_del(&sp->hash_link);
-		kvm_mmu_free_page(kvm, sp);
+		list_move(&sp->link, invalid_list);
 	} else {
-		sp->role.invalid = 1;
 		list_move(&sp->link, &kvm->arch.active_mmu_pages);
 		kvm_reload_remote_mmus(kvm);
 	}
+
+	sp->role.invalid = 1;
 	kvm_mmu_reset_last_pte_updated(kvm);
 	return ret;
 }
 
+static void kvm_mmu_commit_zap_page(struct kvm *kvm,
+				    struct list_head *invalid_list)
+{
+	struct kvm_mmu_page *sp;
+
+	if (list_empty(invalid_list))
+		return;
+
+	kvm_flush_remote_tlbs(kvm);
+
+	do {
+		sp = list_first_entry(invalid_list, struct kvm_mmu_page, link);
+		WARN_ON(!sp->role.invalid || sp->root_count);
+		kvm_mmu_free_page(kvm, sp);
+	} while (!list_empty(invalid_list));
+
+}
+
+static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	LIST_HEAD(invalid_list);
+	int ret;
+
+	ret = kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
+	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+	return ret;
+}
+
 /*
  * Changing the number of mmu pages allocated to the vm
  * Note: if kvm_nr_mmu_pages is too small, you will get dead lock
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



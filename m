Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab0ITOOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 10:14:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52988 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756449Ab0ITOOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 10:14:33 -0400
Message-ID: <4C976D48.6020400@cn.fujitsu.com>
Date: Mon, 20 Sep 2010 22:18:48 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/4] KVM: MMU: rename 'sp->root_count' to 'sp->active_count'
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, sp->root_count is only used by the root sp, in the later patch, we will increase
it to keep unsync sp alive while it's out of 'kvm->mmu_lock''s protection, so rename the
name to fits its use

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    7 ++++++-
 arch/x86/kvm/mmu.c              |   20 ++++++++++----------
 arch/x86/kvm/mmutrace.h         |    8 ++++----
 3 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8c5779d..55abc76 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -206,7 +206,12 @@ struct kvm_mmu_page {
 	DECLARE_BITMAP(slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
 	bool multimapped;         /* More than one parent_pte? */
 	bool unsync;
-	int root_count;          /* Currently serving as active root */
+	/*
+	 * if active_count > 0, it means that this page is not freed
+	 * immediately, it's used by active root and unsync pages which
+	 * out of kvm->mmu_lock's protection currently.
+	 */
+	int active_count;
 	unsigned int unsync_children;
 	union {
 		u64 *parent_pte;               /* !multimapped */
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3ce56bf..839852d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1683,7 +1683,7 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 		unaccount_shadowed(kvm, sp->gfn);
 	if (sp->unsync)
 		kvm_unlink_unsync_page(kvm, sp);
-	if (!sp->root_count) {
+	if (!sp->active_count) {
 		/* Count self */
 		ret++;
 		list_move(&sp->link, invalid_list);
@@ -1709,7 +1709,7 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 
 	do {
 		sp = list_first_entry(invalid_list, struct kvm_mmu_page, link);
-		WARN_ON(!sp->role.invalid || sp->root_count);
+		WARN_ON(!sp->role.invalid || sp->active_count);
 		kvm_mmu_free_page(kvm, sp);
 	} while (!list_empty(invalid_list));
 
@@ -2326,8 +2326,8 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 		hpa_t root = vcpu->arch.mmu.root_hpa;
 
 		sp = page_header(root);
-		--sp->root_count;
-		if (!sp->root_count && sp->role.invalid) {
+		--sp->active_count;
+		if (!sp->active_count && sp->role.invalid) {
 			kvm_mmu_prepare_zap_page(vcpu->kvm, sp, &invalid_list);
 			kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
 		}
@@ -2341,8 +2341,8 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 		if (root) {
 			root &= PT64_BASE_ADDR_MASK;
 			sp = page_header(root);
-			--sp->root_count;
-			if (!sp->root_count && sp->role.invalid)
+			--sp->active_count;
+			if (!sp->active_count && sp->role.invalid)
 				kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
 							 &invalid_list);
 		}
@@ -2375,7 +2375,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		kvm_mmu_free_some_pages(vcpu);
 		sp = kvm_mmu_get_page(vcpu, 0, 0, PT64_ROOT_LEVEL,
 				      1, ACC_ALL, NULL);
-		++sp->root_count;
+		++sp->active_count;
 		spin_unlock(&vcpu->kvm->mmu_lock);
 		vcpu->arch.mmu.root_hpa = __pa(sp->spt);
 	} else if (vcpu->arch.mmu.shadow_root_level == PT32E_ROOT_LEVEL) {
@@ -2389,7 +2389,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 					      PT32_ROOT_LEVEL, 1, ACC_ALL,
 					      NULL);
 			root = __pa(sp->spt);
-			++sp->root_count;
+			++sp->active_count;
 			spin_unlock(&vcpu->kvm->mmu_lock);
 			vcpu->arch.mmu.pae_root[i] = root | PT_PRESENT_MASK;
 			vcpu->arch.mmu.root_hpa = __pa(vcpu->arch.mmu.pae_root);
@@ -2426,7 +2426,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		sp = kvm_mmu_get_page(vcpu, root_gfn, 0, PT64_ROOT_LEVEL,
 				      0, ACC_ALL, NULL);
 		root = __pa(sp->spt);
-		++sp->root_count;
+		++sp->active_count;
 		spin_unlock(&vcpu->kvm->mmu_lock);
 		vcpu->arch.mmu.root_hpa = root;
 		return 0;
@@ -2461,7 +2461,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 				      PT32_ROOT_LEVEL, 0,
 				      ACC_ALL, NULL);
 		root = __pa(sp->spt);
-		++sp->root_count;
+		++sp->active_count;
 		spin_unlock(&vcpu->kvm->mmu_lock);
 
 		vcpu->arch.mmu.pae_root[i] = root | pm_mask;
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index b60b4fd..70c8bfd 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -10,13 +10,13 @@
 #define KVM_MMU_PAGE_FIELDS \
 	__field(__u64, gfn) \
 	__field(__u32, role) \
-	__field(__u32, root_count) \
+	__field(__u32, active_count) \
 	__field(bool, unsync)
 
 #define KVM_MMU_PAGE_ASSIGN(sp)			     \
 	__entry->gfn = sp->gfn;			     \
 	__entry->role = sp->role.word;		     \
-	__entry->root_count = sp->root_count;        \
+	__entry->active_count = sp->active_count;        \
 	__entry->unsync = sp->unsync;
 
 #define KVM_MMU_PAGE_PRINTK() ({				        \
@@ -29,7 +29,7 @@
 	role.word = __entry->role;					\
 									\
 	trace_seq_printf(p, "sp gfn %llx %u%s q%u%s %s%s"		\
-			 " %snxe root %u %s%c",				\
+			 " %snxe active %u %s%c",			\
 			 __entry->gfn, role.level,			\
 			 role.cr4_pae ? " pae" : "",			\
 			 role.quadrant,					\
@@ -37,7 +37,7 @@
 			 access_str[role.access],			\
 			 role.invalid ? " invalid" : "",		\
 			 role.nxe ? "" : "!",				\
-			 __entry->root_count,				\
+			 __entry->active_count,				\
 			 __entry->unsync ? "unsync" : "sync", 0);	\
 	ret;								\
 		})
-- 
1.7.0.4

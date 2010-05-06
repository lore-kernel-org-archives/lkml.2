Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab0EFJeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 05:34:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57877 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756568Ab0EFJeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 05:34:21 -0400
Message-ID: <4BE28C5F.7020104@cn.fujitsu.com>
Date: Thu, 06 May 2010 17:31:11 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       KVM list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 5/9] KVM MMU: rename 'root_count' to 'active_count'
References: <4BE2818A.5000301@cn.fujitsu.com>
In-Reply-To: <4BE2818A.5000301@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename 'root_count' to 'active_count' in kvm_mmu_page, since the unsync pages
also will use it in later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    7 ++++++-
 arch/x86/kvm/mmu.c              |   14 +++++++-------
 arch/x86/kvm/mmutrace.h         |    6 +++---
 3 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ed48904..86a8550 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -203,7 +203,12 @@ struct kvm_mmu_page {
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
index 26edc11..58cf0f1 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1539,7 +1539,7 @@ static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 		unaccount_shadowed(kvm, sp->gfn);
 	if (sp->unsync)
 		kvm_unlink_unsync_page(kvm, sp);
-	if (!sp->root_count) {
+	if (!sp->active_count) {
 		hlist_del(&sp->hash_link);
 		kvm_mmu_free_page(kvm, sp);
 	} else {
@@ -2060,8 +2060,8 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 		hpa_t root = vcpu->arch.mmu.root_hpa;
 
 		sp = page_header(root);
-		--sp->root_count;
-		if (!sp->root_count && sp->role.invalid)
+		--sp->active_count;
+		if (!sp->active_count && sp->role.invalid)
 			kvm_mmu_zap_page(vcpu->kvm, sp);
 		vcpu->arch.mmu.root_hpa = INVALID_PAGE;
 		spin_unlock(&vcpu->kvm->mmu_lock);
@@ -2073,8 +2073,8 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 		if (root) {
 			root &= PT64_BASE_ADDR_MASK;
 			sp = page_header(root);
-			--sp->root_count;
-			if (!sp->root_count && sp->role.invalid)
+			--sp->active_count;
+			if (!sp->active_count && sp->role.invalid)
 				kvm_mmu_zap_page(vcpu->kvm, sp);
 		}
 		vcpu->arch.mmu.pae_root[i] = INVALID_PAGE;
@@ -2120,7 +2120,7 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
 				      PT64_ROOT_LEVEL, direct,
 				      ACC_ALL, NULL);
 		root = __pa(sp->spt);
-		++sp->root_count;
+		++sp->active_count;
 		spin_unlock(&vcpu->kvm->mmu_lock);
 		vcpu->arch.mmu.root_hpa = root;
 		return 0;
@@ -2150,7 +2150,7 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
 				      PT32_ROOT_LEVEL, direct,
 				      ACC_ALL, NULL);
 		root = __pa(sp->spt);
-		++sp->root_count;
+		++sp->active_count;
 		spin_unlock(&vcpu->kvm->mmu_lock);
 
 		vcpu->arch.mmu.pae_root[i] = root | PT_PRESENT_MASK;
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 42f07b1..8c8d265 100644
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
1.6.1.2






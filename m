Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750891Ab0EGEA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 00:00:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61940 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab0EGEAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 00:00:25 -0400
Message-ID: <4BE38F9A.8070209@cn.fujitsu.com>
Date: Fri, 07 May 2010 11:57:14 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 5/9] KVM MMU: rename 'root_count' to 'active_count'
References: <4BE2818A.5000301@cn.fujitsu.com> <4BE28C5F.7020104@cn.fujitsu.com>
In-Reply-To: <4BE28C5F.7020104@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename 'root_count' to 'active_count' in kvm_mmu_page, since the unsync pages
also will use it in later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    8 +++++++-
 arch/x86/kvm/mmu.c              |   14 +++++++-------
 arch/x86/kvm/mmutrace.h         |    6 +++---
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ed48904..2f61543 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -203,7 +203,13 @@ struct kvm_mmu_page {
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
+
 	unsigned int unsync_children;
 	union {
 		u64 *parent_pte;               /* !multimapped */
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e202b0d..4077a9c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1539,7 +1539,7 @@ static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 		unaccount_shadowed(kvm, sp->gfn);
 	if (sp->unsync)
 		kvm_unlink_unsync_page(kvm, sp);
-	if (!sp->root_count) {
+	if (!sp->active_count) {
 		/* Count self */
 		ret++;
 		hlist_del(&sp->hash_link);
@@ -2061,8 +2061,8 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 		hpa_t root = vcpu->arch.mmu.root_hpa;
 
 		sp = page_header(root);
-		--sp->root_count;
-		if (!sp->root_count && sp->role.invalid)
+		--sp->active_count;
+		if (!sp->active_count && sp->role.invalid)
 			kvm_mmu_zap_page(vcpu->kvm, sp);
 		vcpu->arch.mmu.root_hpa = INVALID_PAGE;
 		spin_unlock(&vcpu->kvm->mmu_lock);
@@ -2074,8 +2074,8 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
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
@@ -2121,7 +2121,7 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
 				      PT64_ROOT_LEVEL, direct,
 				      ACC_ALL, NULL);
 		root = __pa(sp->spt);
-		++sp->root_count;
+		++sp->active_count;
 		spin_unlock(&vcpu->kvm->mmu_lock);
 		vcpu->arch.mmu.root_hpa = root;
 		return 0;
@@ -2151,7 +2151,7 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
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



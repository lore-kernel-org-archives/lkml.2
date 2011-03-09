Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab1CIHm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 02:42:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61817 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab1CIHmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 02:42:55 -0500
Message-ID: <4D772FB7.8060007@cn.fujitsu.com>
Date: Wed, 09 Mar 2011 15:43:51 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 4/4] KVM: MMU: cleanup pte write path
References: <4D772F10.3020302@cn.fujitsu.com>
In-Reply-To: <4D772F10.3020302@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-09 15:41:40,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-09 15:41:40,
	Serialize complete at 2011-03-09 15:41:40
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does:
- call vcpu->arch.mmu.update_pte directly
- use gfn_to_pfn_atomic in update_pte path

The suggestion is from Avi.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    7 +---
 arch/x86/kvm/mmu.c              |   69 +++++++++++++--------------------------
 arch/x86/kvm/paging_tmpl.h      |   12 ++++---
 3 files changed, 32 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f08314f..c8af099 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -255,6 +255,8 @@ struct kvm_mmu {
 	int (*sync_page)(struct kvm_vcpu *vcpu,
 			 struct kvm_mmu_page *sp);
 	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva);
+	void (*update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+			u64 *spte, const void *pte, unsigned long mmu_seq);
 	hpa_t root_hpa;
 	int root_level;
 	int shadow_root_level;
@@ -335,11 +337,6 @@ struct kvm_vcpu_arch {
 	u64  *last_pte_updated;
 	gfn_t last_pte_gfn;
 
-	struct {
-		pfn_t pfn;	/* pfn corresponding to that gfn */
-		unsigned long mmu_seq;
-	} update_pte;
-
 	struct fpu guest_fpu;
 	u64 xcr0;
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 83171fd..22fae75 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1204,6 +1204,13 @@ static void nonpaging_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 {
 }
 
+static void nonpaging_update_pte(struct kvm_vcpu *vcpu,
+				 struct kvm_mmu_page *sp, u64 *spte,
+				 const void *pte, unsigned long mmu_seq)
+{
+	WARN_ON(1);
+}
+
 #define KVM_PAGE_ARRAY_NR 16
 
 struct kvm_mmu_pages {
@@ -2796,6 +2803,7 @@ static int nonpaging_init_context(struct kvm_vcpu *vcpu,
 	context->prefetch_page = nonpaging_prefetch_page;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = nonpaging_invlpg;
+	context->update_pte = nonpaging_update_pte;
 	context->root_level = 0;
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
 	context->root_hpa = INVALID_PAGE;
@@ -2925,6 +2933,7 @@ static int paging64_init_context_common(struct kvm_vcpu *vcpu,
 	context->prefetch_page = paging64_prefetch_page;
 	context->sync_page = paging64_sync_page;
 	context->invlpg = paging64_invlpg;
+	context->update_pte = paging64_update_pte;
 	context->free = paging_free;
 	context->root_level = level;
 	context->shadow_root_level = level;
@@ -2953,6 +2962,7 @@ static int paging32_init_context(struct kvm_vcpu *vcpu,
 	context->prefetch_page = paging32_prefetch_page;
 	context->sync_page = paging32_sync_page;
 	context->invlpg = paging32_invlpg;
+	context->update_pte = paging32_update_pte;
 	context->root_level = PT32_ROOT_LEVEL;
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
 	context->root_hpa = INVALID_PAGE;
@@ -2977,6 +2987,7 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->prefetch_page = nonpaging_prefetch_page;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = nonpaging_invlpg;
+	context->update_pte = nonpaging_update_pte;
 	context->shadow_root_level = kvm_x86_ops->get_tdp_level();
 	context->root_hpa = INVALID_PAGE;
 	context->direct_map = true;
@@ -3081,8 +3092,6 @@ static int init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 
 static int init_kvm_mmu(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.update_pte.pfn = bad_pfn;
-
 	if (mmu_is_nested(vcpu))
 		return init_kvm_nested_mmu(vcpu);
 	else if (tdp_enabled)
@@ -3156,7 +3165,7 @@ static void mmu_pte_write_zap_pte(struct kvm_vcpu *vcpu,
 static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
 				  struct kvm_mmu_page *sp,
 				  u64 *spte,
-				  const void *new)
+				  const void *new, unsigned long mmu_seq)
 {
 	if (sp->role.level != PT_PAGE_TABLE_LEVEL) {
 		++vcpu->kvm->stat.mmu_pde_zapped;
@@ -3164,10 +3173,7 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
         }
 
 	++vcpu->kvm->stat.mmu_pte_updated;
-	if (!sp->role.cr4_pae)
-		paging32_update_pte(vcpu, sp, spte, new);
-	else
-		paging64_update_pte(vcpu, sp, spte, new);
+	vcpu->arch.mmu.update_pte(vcpu, sp, spte, new, mmu_seq);
 }
 
 static bool need_remote_flush(u64 old, u64 new)
@@ -3202,27 +3208,6 @@ static bool last_updated_pte_accessed(struct kvm_vcpu *vcpu)
 	return !!(spte && (*spte & shadow_accessed_mask));
 }
 
-static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
-					  u64 gpte)
-{
-	gfn_t gfn;
-	pfn_t pfn;
-
-	if (!is_present_gpte(gpte))
-		return;
-	gfn = (gpte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
-
-	vcpu->arch.update_pte.mmu_seq = vcpu->kvm->mmu_notifier_seq;
-	smp_rmb();
-	pfn = gfn_to_pfn(vcpu->kvm, gfn);
-
-	if (is_error_pfn(pfn)) {
-		kvm_release_pfn_clean(pfn);
-		return;
-	}
-	vcpu->arch.update_pte.pfn = pfn;
-}
-
 static void kvm_mmu_access_page(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 	u64 *spte = vcpu->arch.last_pte_updated;
@@ -3244,21 +3229,14 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	struct kvm_mmu_page *sp;
 	struct hlist_node *node;
 	LIST_HEAD(invalid_list);
-	u64 entry, gentry;
-	u64 *spte;
-	unsigned offset = offset_in_page(gpa);
-	unsigned pte_size;
-	unsigned page_offset;
-	unsigned misaligned;
-	unsigned quadrant;
-	int level;
-	int flooded = 0;
-	int npte;
-	int r;
-	int invlpg_counter;
+	unsigned long mmu_seq;
+	u64 entry, gentry, *spte;
+	unsigned pte_size, page_offset, misaligned, quadrant, offset;
+	int level, npte, invlpg_counter, r, flooded = 0;
 	bool remote_flush, local_flush, zap_page;
 
 	zap_page = remote_flush = local_flush = false;
+	offset = offset_in_page(gpa);
 
 	pgprintk("%s: gpa %llx bytes %d\n", __func__, gpa, bytes);
 
@@ -3293,7 +3271,9 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		break;
 	}
 
-	mmu_guess_page_from_pte_write(vcpu, gpa, gentry);
+	mmu_seq = vcpu->kvm->mmu_notifier_seq;
+	smp_rmb();
+
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) != invlpg_counter)
 		gentry = 0;
@@ -3365,7 +3345,8 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 			if (gentry &&
 			      !((sp->role.word ^ vcpu->arch.mmu.base_role.word)
 			      & mask.word))
-				mmu_pte_write_new_pte(vcpu, sp, spte, &gentry);
+				mmu_pte_write_new_pte(vcpu, sp, spte, &gentry,
+						      mmu_seq);
 			if (!remote_flush && need_remote_flush(entry, *spte))
 				remote_flush = true;
 			++spte;
@@ -3375,10 +3356,6 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
 	trace_kvm_mmu_audit(vcpu, AUDIT_POST_PTE_WRITE);
 	spin_unlock(&vcpu->kvm->mmu_lock);
-	if (!is_error_pfn(vcpu->arch.update_pte.pfn)) {
-		kvm_release_pfn_clean(vcpu->arch.update_pte.pfn);
-		vcpu->arch.update_pte.pfn = bad_pfn;
-	}
 }
 
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 86eb816..7514050 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -325,7 +325,7 @@ no_present:
 }
 
 static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			      u64 *spte, const void *pte)
+			      u64 *spte, const void *pte, unsigned long mmu_seq)
 {
 	pt_element_t gpte;
 	unsigned pte_access;
@@ -337,12 +337,14 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 
 	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
 	pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
-	pfn = vcpu->arch.update_pte.pfn;
-	if (is_error_pfn(pfn))
+	pfn = gfn_to_pfn_atomic(vcpu->kvm, gpte_to_gfn(gpte));
+	if (is_error_pfn(pfn)) {
+		kvm_release_pfn_clean(pfn);
 		return;
-	if (mmu_notifier_retry(vcpu, vcpu->arch.update_pte.mmu_seq))
+	}
+	if (mmu_notifier_retry(vcpu, mmu_seq))
 		return;
-	kvm_get_pfn(pfn);
+
 	/*
 	 * we call mmu_set_spte() with host_writable = true beacuse that
 	 * vcpu->arch.update_pte.pfn was fetched from get_user_pages(write = 1).
-- 
1.7.4


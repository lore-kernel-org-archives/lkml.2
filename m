Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab1H3CgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 22:36:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63768 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab1H3CgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 22:36:03 -0400
Message-ID: <4E5C4D17.2080700@cn.fujitsu.com>
Date: Tue, 30 Aug 2011 10:38:15 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 11/11] KVM: MMU: improve write flooding detected
References: <4E5C4C20.3000403@cn.fujitsu.com>
In-Reply-To: <4E5C4C20.3000403@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-30 10:35:03,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-30 10:35:03,
	Serialize complete at 2011-08-30 10:35:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detecting write-flooding does not work well, when we handle page written, if
the last speculative spte is not accessed, we treat the page is
write-flooding, however, we can speculative spte on many path, such as pte
prefetch, page synced, that means the last speculative spte may be not point
to the written page and the written page can be accessed via other sptes, so
depends on the Accessed bit of the last speculative spte is not enough

Instead of detected page accessed, we can detect whether the spte is accessed
after it is written, if the spte is not accessed but it is written frequently,
we treat is not a page table or it not used for a long time

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    6 +---
 arch/x86/kvm/mmu.c              |   57 +++++++++++++--------------------------
 arch/x86/kvm/paging_tmpl.h      |   12 +++-----
 3 files changed, 26 insertions(+), 49 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 927ba73..9d17238 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -239,6 +239,8 @@ struct kvm_mmu_page {
 	int clear_spte_count;
 #endif
 
+	int write_flooding_count;
+
 	struct rcu_head rcu;
 };
 
@@ -353,10 +355,6 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu_memory_cache mmu_page_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
 
-	gfn_t last_pt_write_gfn;
-	int   last_pt_write_count;
-	u64  *last_pte_updated;
-
 	struct fpu guest_fpu;
 	u64 xcr0;
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index adaa160..fd5b389 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1652,6 +1652,18 @@ static void init_shadow_page_table(struct kvm_mmu_page *sp)
 		sp->spt[i] = 0ull;
 }
 
+static void __clear_sp_write_flooding_count(struct kvm_mmu_page *sp)
+{
+	sp->write_flooding_count = 0;
+}
+
+static void clear_sp_write_flooding_count(u64 *spte)
+{
+	struct kvm_mmu_page *sp =  page_header(__pa(spte));
+
+	__clear_sp_write_flooding_count(sp);
+}
+
 static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     gfn_t gfn,
 					     gva_t gaddr,
@@ -1695,6 +1707,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		} else if (sp->unsync)
 			kvm_mmu_mark_parents_unsync(sp);
 
+		__clear_sp_write_flooding_count(sp);
 		trace_kvm_mmu_get_page(sp, false);
 		return sp;
 	}
@@ -1847,15 +1860,6 @@ static void kvm_mmu_put_page(struct kvm_mmu_page *sp, u64 *parent_pte)
 	mmu_page_remove_parent_pte(sp, parent_pte);
 }
 
-static void kvm_mmu_reset_last_pte_updated(struct kvm *kvm)
-{
-	int i;
-	struct kvm_vcpu *vcpu;
-
-	kvm_for_each_vcpu(i, vcpu, kvm)
-		vcpu->arch.last_pte_updated = NULL;
-}
-
 static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	u64 *parent_pte;
@@ -1915,7 +1919,6 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 	}
 
 	sp->role.invalid = 1;
-	kvm_mmu_reset_last_pte_updated(kvm);
 	return ret;
 }
 
@@ -2360,8 +2363,6 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		}
 	}
 	kvm_release_pfn_clean(pfn);
-	if (speculative)
-		vcpu->arch.last_pte_updated = sptep;
 }
 
 static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
@@ -3522,13 +3523,6 @@ static void mmu_pte_write_flush_tlb(struct kvm_vcpu *vcpu, bool zap_page,
 		kvm_mmu_flush_tlb(vcpu);
 }
 
-static bool last_updated_pte_accessed(struct kvm_vcpu *vcpu)
-{
-	u64 *spte = vcpu->arch.last_pte_updated;
-
-	return !!(spte && (*spte & shadow_accessed_mask));
-}
-
 static u64 mmu_pte_write_fetch_gpte(struct kvm_vcpu *vcpu, gpa_t *gpa,
 				    const u8 *new, int *bytes)
 {
@@ -3569,22 +3563,9 @@ static u64 mmu_pte_write_fetch_gpte(struct kvm_vcpu *vcpu, gpa_t *gpa,
  * If we're seeing too many writes to a page, it may no longer be a page table,
  * or we may be forking, in which case it is better to unmap the page.
  */
-static bool detect_write_flooding(struct kvm_vcpu *vcpu, gfn_t gfn)
+static bool detect_write_flooding(struct kvm_mmu_page *sp, u64 *spte)
 {
-	bool flooded = false;
-
-	if (gfn == vcpu->arch.last_pt_write_gfn
-	    && !last_updated_pte_accessed(vcpu)) {
-		++vcpu->arch.last_pt_write_count;
-		if (vcpu->arch.last_pt_write_count >= 3)
-			flooded = true;
-	} else {
-		vcpu->arch.last_pt_write_gfn = gfn;
-		vcpu->arch.last_pt_write_count = 1;
-		vcpu->arch.last_pte_updated = NULL;
-	}
-
-	return flooded;
+	return ++sp->write_flooding_count >= 3;
 }
 
 /*
@@ -3656,7 +3637,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	LIST_HEAD(invalid_list);
 	u64 entry, gentry, *spte;
 	int npte;
-	bool remote_flush, local_flush, zap_page, flooded, misaligned;
+	bool remote_flush, local_flush, zap_page;
 
 	/*
 	 * If we don't have indirect shadow pages, it means no page is
@@ -3675,12 +3656,12 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	++vcpu->kvm->stat.mmu_pte_write;
 	trace_kvm_mmu_audit(vcpu, AUDIT_PRE_PTE_WRITE);
 
-	flooded = detect_write_flooding(vcpu, gfn);
 	mask.cr0_wp = mask.cr4_pae = mask.nxe = 1;
 	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn, node) {
-		misaligned = detect_write_misaligned(sp, gpa, bytes);
+		spte = get_written_sptes(sp, gpa, &npte);
 
-		if (misaligned || flooded) {
+		if (detect_write_misaligned(sp, gpa, bytes) ||
+		      detect_write_flooding(sp, spte)) {
 			zap_page |= !!kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
 						     &invalid_list);
 			++vcpu->kvm->stat.mmu_flooded;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 3395ab2..379a795 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -497,6 +497,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	     shadow_walk_next(&it)) {
 		gfn_t table_gfn;
 
+		clear_sp_write_flooding_count(it.sptep);
 		drop_large_spte(vcpu, it.sptep);
 
 		sp = NULL;
@@ -522,6 +523,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	     shadow_walk_next(&it)) {
 		gfn_t direct_gfn;
 
+		clear_sp_write_flooding_count(it.sptep);
 		validate_direct_spte(vcpu, it.sptep, direct_access);
 
 		drop_large_spte(vcpu, it.sptep);
@@ -536,6 +538,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		link_shadow_page(it.sptep, sp);
 	}
 
+	clear_sp_write_flooding_count(it.sptep);
 	mmu_set_spte(vcpu, it.sptep, access, gw->pte_access,
 		     user_fault, write_fault, emulate, it.level,
 		     gw->gfn, pfn, prefault, map_writable);
@@ -599,11 +602,9 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 	 */
 	if (!r) {
 		pgprintk("%s: guest page fault\n", __func__);
-		if (!prefault) {
+		if (!prefault)
 			inject_page_fault(vcpu, &walker.fault);
-			/* reset fork detector */
-			vcpu->arch.last_pt_write_count = 0;
-		}
+
 		return 0;
 	}
 
@@ -641,9 +642,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 	pgprintk("%s: shadow pte %p %llx emulate %d\n", __func__,
 		 sptep, *sptep, emulate);
 
-	if (!emulate)
-		vcpu->arch.last_pt_write_count = 0; /* reset fork detector */
-
 	++vcpu->stat.pf_fixed;
 	trace_kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
 	spin_unlock(&vcpu->kvm->mmu_lock);
-- 
1.7.5.4


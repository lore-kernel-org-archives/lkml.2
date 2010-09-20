Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab0ITORk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 10:17:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60751 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754256Ab0ITORj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 10:17:39 -0400
Message-ID: <4C976DF6.1020905@cn.fujitsu.com>
Date: Mon, 20 Sep 2010 22:21:42 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 4/4] KVM: MMU: Don't touch unsync sp in kvm_mmu_pte_write()
References: <4C976D48.6020400@cn.fujitsu.com>
In-Reply-To: <4C976D48.6020400@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gfn may have many shadow pages, when one sp need be synced, we write
protected sp->gfn and sync this sp but we keep other shadow pages
asynchronous

So, while gfn happen page fault, let it not touches unsync page, the unsync
page only updated at invlpg/flush TLB time

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/mmu.c              |   25 ++++++++++++++++---------
 arch/x86/kvm/paging_tmpl.h      |   34 ++++++++++++++++++++++++++++------
 3 files changed, 45 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 55abc76..b685ecf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -420,7 +420,7 @@ struct kvm_arch {
 	unsigned int n_used_mmu_pages;
 	unsigned int n_requested_mmu_pages;
 	unsigned int n_max_mmu_pages;
-	atomic_t invlpg_counter;
+	unsigned int invlpg_counter;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	/*
 	 * Hash table of struct kvm_mmu_page.
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4b7af3f..0ccb67f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2677,6 +2677,10 @@ static bool is_rsvd_bits_set(struct kvm_mmu *mmu, u64 gpte, int level)
 	return (gpte & mmu->rsvd_bits_mask[bit7][level-1]) != 0;
 }
 
+static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
+					  u64 gpte);
+static void mmu_release_page_from_pte_write(struct kvm_vcpu *vcpu);
+
 #define PTTYPE 64
 #include "paging_tmpl.h"
 #undef PTTYPE
@@ -3063,6 +3067,14 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	vcpu->arch.update_pte.pfn = pfn;
 }
 
+static void mmu_release_page_from_pte_write(struct kvm_vcpu *vcpu)
+{
+	if (!is_error_pfn(vcpu->arch.update_pte.pfn)) {
+		kvm_release_pfn_clean(vcpu->arch.update_pte.pfn);
+		vcpu->arch.update_pte.pfn = bad_pfn;
+	}
+}
+
 static void kvm_mmu_access_page(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 	u64 *spte = vcpu->arch.last_pte_updated;
@@ -3095,15 +3107,12 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	int flooded = 0;
 	int npte;
 	int r;
-	int invlpg_counter;
 	bool remote_flush, local_flush, zap_page;
 
 	zap_page = remote_flush = local_flush = false;
 
 	pgprintk("%s: gpa %llx bytes %d\n", __func__, gpa, bytes);
 
-	invlpg_counter = atomic_read(&vcpu->kvm->arch.invlpg_counter);
-
 	/*
 	 * Assume that the pte write on a page table of the same type
 	 * as the current vcpu paging mode.  This is nearly always true
@@ -3136,8 +3145,6 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 	mmu_guess_page_from_pte_write(vcpu, gpa, gentry);
 	spin_lock(&vcpu->kvm->mmu_lock);
-	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) != invlpg_counter)
-		gentry = 0;
 	kvm_mmu_access_page(vcpu, gfn);
 	kvm_mmu_free_some_pages(vcpu);
 	++vcpu->kvm->stat.mmu_pte_write;
@@ -3157,6 +3164,9 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 	mask.cr0_wp = mask.cr4_pae = mask.nxe = 1;
 	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn, node) {
+		if (sp->unsync)
+			continue;
+
 		pte_size = sp->role.cr4_pae ? 8 : 4;
 		misaligned = (offset ^ (offset + bytes - 1)) & ~(pte_size - 1);
 		misaligned |= bytes < 4;
@@ -3216,10 +3226,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
 	trace_kvm_mmu_audit(vcpu, AUDIT_POST_PTE_WRITE);
 	spin_unlock(&vcpu->kvm->mmu_lock);
-	if (!is_error_pfn(vcpu->arch.update_pte.pfn)) {
-		kvm_release_pfn_clean(vcpu->arch.update_pte.pfn);
-		vcpu->arch.update_pte.pfn = bad_pfn;
-	}
+	mmu_release_page_from_pte_write(vcpu);
 }
 
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 2bdd843..ab9a594 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -609,11 +609,13 @@ out_unlock:
 static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	struct kvm_shadow_walk_iterator iterator;
-	struct kvm_mmu_page *sp;
+	struct kvm_mmu_page *sp = NULL;
+	unsigned int invlpg_counter;
 	gpa_t pte_gpa = -1;
 	int level;
-	u64 *sptep;
+	u64 gentry, *sptep = NULL;
 	int need_flush = 0;
+	bool prefetch = true;
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 
@@ -643,6 +645,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 				need_flush = 1;
 			} else
 				__set_spte(sptep, shadow_trap_nonpresent_pte);
+			sp->active_count++;
 			break;
 		}
 
@@ -653,16 +656,35 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 	if (need_flush)
 		kvm_flush_remote_tlbs(vcpu->kvm);
 
-	atomic_inc(&vcpu->kvm->arch.invlpg_counter);
+	invlpg_counter = ++vcpu->kvm->arch.invlpg_counter;
 
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 	if (pte_gpa == -1)
 		return;
 
-	if (mmu_topup_memory_caches(vcpu))
-		return;
-	kvm_mmu_pte_write(vcpu, pte_gpa, NULL, sizeof(pt_element_t), 0);
+	if (mmu_topup_memory_caches(vcpu) ||
+	  kvm_read_guest(vcpu->kvm, pte_gpa, &gentry, sizeof(pt_element_t)))
+		prefetch = false;
+	else
+		mmu_guess_page_from_pte_write(vcpu, pte_gpa, gentry);
+
+	spin_lock(&vcpu->kvm->mmu_lock);
+	sp->active_count--;
+	if (sp->role.invalid) {
+		if (!sp->active_count)
+			kvm_mmu_free_page(vcpu->kvm, sp);
+		goto unlock_exit;
+	}
+
+	if (prefetch && vcpu->kvm->arch.invlpg_counter == invlpg_counter) {
+		++vcpu->kvm->stat.mmu_pte_updated;
+		FNAME(update_pte)(vcpu, sp, sptep, &gentry);
+	}
+
+unlock_exit:
+	spin_unlock(&vcpu->kvm->mmu_lock);
+	mmu_release_page_from_pte_write(vcpu);
 }
 
 static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr, u32 access,
-- 
1.7.0.4


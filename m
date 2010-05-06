Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164Ab0EFJem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 05:34:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52551 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756965Ab0EFJek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 05:34:40 -0400
Message-ID: <4BE28C72.7040206@cn.fujitsu.com>
Date: Thu, 06 May 2010 17:31:30 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 7/9] KVM MMU: separate invlpg code form kvm_mmu_pte_write()
References: <4BE2818A.5000301@cn.fujitsu.com>
In-Reply-To: <4BE2818A.5000301@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let invlpg not depends on kvm_mmu_pte_write path, later patch will need
this feature

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |   22 +++++++++++++---------
 arch/x86/kvm/paging_tmpl.h |   44 +++++++++++++++++++++++++++++++-------------
 2 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8ab1a49..5e32751 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2318,6 +2318,10 @@ static bool is_rsvd_bits_set(struct kvm_vcpu *vcpu, u64 gpte, int level)
 	return (gpte & vcpu->arch.mmu.rsvd_bits_mask[bit7][level-1]) != 0;
 }
 
+static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
+					  u64 gpte);
+static void mmu_release_page_from_pte_write(struct kvm_vcpu *vcpu);
+
 #define PTTYPE 64
 #include "paging_tmpl.h"
 #undef PTTYPE
@@ -2631,6 +2635,14 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
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
@@ -2663,12 +2675,9 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	int flooded = 0;
 	int npte;
 	int r;
-	int invlpg_counter;
 
 	pgprintk("%s: gpa %llx bytes %d\n", __func__, gpa, bytes);
 
-	invlpg_counter = atomic_read(&vcpu->kvm->arch.invlpg_counter);
-
 	/*
 	 * Assume that the pte write on a page table of the same type
 	 * as the current vcpu paging mode.  This is nearly always true
@@ -2701,8 +2710,6 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 	mmu_guess_page_from_pte_write(vcpu, gpa, gentry);
 	spin_lock(&vcpu->kvm->mmu_lock);
-	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) != invlpg_counter)
-		gentry = 0;
 	kvm_mmu_access_page(vcpu, gfn);
 	kvm_mmu_free_some_pages(vcpu);
 	++vcpu->kvm->stat.mmu_pte_write;
@@ -2779,10 +2786,7 @@ restart:
 	}
 	kvm_mmu_audit(vcpu, "post pte write");
 	spin_unlock(&vcpu->kvm->mmu_lock);
-	if (!is_error_pfn(vcpu->arch.update_pte.pfn)) {
-		kvm_release_pfn_clean(vcpu->arch.update_pte.pfn);
-		vcpu->arch.update_pte.pfn = bad_pfn;
-	}
+	mmu_release_page_from_pte_write(vcpu);
 }
 
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 89d66ca..93ee2d9 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -462,11 +462,11 @@ out_unlock:
 
 static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 {
+	struct kvm_mmu_page *sp = NULL;
 	struct kvm_shadow_walk_iterator iterator;
-	gpa_t pte_gpa = -1;
-	int level;
-	u64 *sptep;
-	int need_flush = 0;
+	gfn_t gfn = -1;
+	u64 *sptep = NULL, gentry;
+	int invlpg_counter, level, offset = 0, need_flush = 0;
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 
@@ -475,15 +475,14 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 		sptep = iterator.sptep;
 
 		if (is_last_spte(*sptep, level)) {
-			struct kvm_mmu_page *sp = page_header(__pa(sptep));
-			int offset, shift;
+			int shift;
 
+			sp = page_header(__pa(sptep));
 			shift = PAGE_SHIFT -
 				  (PT_LEVEL_BITS - PT64_LEVEL_BITS) * level;
+			gfn = sp->gfn;
 			offset = sp->role.quadrant << shift;
-
-			pte_gpa = (sp->gfn << PAGE_SHIFT) + offset;
-			pte_gpa += (sptep - sp->spt) * sizeof(pt_element_t);
+			offset += (sptep - sp->spt) * sizeof(pt_element_t);
 
 			if (is_shadow_present_pte(*sptep)) {
 				rmap_remove(vcpu->kvm, sptep);
@@ -492,6 +491,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 				need_flush = 1;
 			}
 			__set_spte(sptep, shadow_trap_nonpresent_pte);
+			sp->active_count++;
 			break;
 		}
 
@@ -502,16 +502,34 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 	if (need_flush)
 		kvm_flush_remote_tlbs(vcpu->kvm);
 
-	atomic_inc(&vcpu->kvm->arch.invlpg_counter);
-
+	invlpg_counter = atomic_add_return(1, &vcpu->kvm->arch.invlpg_counter);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
-	if (pte_gpa == -1)
+	if (gfn == -1)
 		return;
 
 	if (mmu_topup_memory_caches(vcpu))
 		return;
-	kvm_mmu_pte_write(vcpu, pte_gpa, NULL, sizeof(pt_element_t), 0);
+	if (kvm_read_guest_page(vcpu->kvm, gfn, &gentry, offset,
+			sizeof(pt_element_t)))
+		return;
+
+	mmu_guess_page_from_pte_write(vcpu, gfn_to_gpa(gfn) + offset, gentry);
+	spin_lock(&vcpu->kvm->mmu_lock);
+	sp->active_count--;
+	if (sp->role.invalid) {
+		if (!sp->active_count)
+			kvm_mmu_free_page(vcpu->kvm, sp);
+		goto unlock_exit;
+	}
+	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) == invlpg_counter &&
+			sp->role.level == PT_PAGE_TABLE_LEVEL) {
+		++vcpu->kvm->stat.mmu_pte_updated;
+		FNAME(update_pte)(vcpu, sp, sptep, &gentry);
+	}
+unlock_exit:
+	spin_unlock(&vcpu->kvm->mmu_lock);
+	mmu_release_page_from_pte_write(vcpu);
 }
 
 static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr, u32 access,
-- 
1.6.1.2






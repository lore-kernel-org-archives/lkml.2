Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab0DYHFP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 03:05:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58022 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752401Ab0DYHFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 03:05:11 -0400
Message-ID: <4BD3E8EB.1010006@cn.fujitsu.com>
Date: Sun, 25 Apr 2010 15:02:03 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 9/10] KVM MMU: separate invlpg code form kvm_mmu_pte_write()
References: <4BD3E306.4020202@cn.fujitsu.com>
In-Reply-To: <4BD3E306.4020202@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let invlpg not depends on kvm_mmu_pte_write path, later patch will need
this feature

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |   12 +++++++-----
 arch/x86/kvm/paging_tmpl.h |   33 ++++++++++++++++++++++-----------
 2 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 81a1945..add4658 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2291,6 +2291,13 @@ static bool is_rsvd_bits_set(struct kvm_vcpu *vcpu, u64 gpte, int level)
 	return (gpte & vcpu->arch.mmu.rsvd_bits_mask[bit7][level-1]) != 0;
 }
 
+static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
+					  u64 gpte);
+static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
+				  struct kvm_mmu_page *sp,
+				  u64 *spte,
+				  const void *new);
+
 #define PTTYPE 64
 #include "paging_tmpl.h"
 #undef PTTYPE
@@ -2634,12 +2641,9 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
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
@@ -2672,8 +2676,6 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 	mmu_guess_page_from_pte_write(vcpu, gpa, gentry);
 	spin_lock(&vcpu->kvm->mmu_lock);
-	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) != invlpg_counter)
-		gentry = 0;
 	kvm_mmu_access_page(vcpu, gfn);
 	kvm_mmu_free_some_pages(vcpu);
 	++vcpu->kvm->stat.mmu_pte_write;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 8eb98eb..38b4d23 100644
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
 
@@ -475,8 +475,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 		sptep = iterator.sptep;
 
 		if (is_last_spte(*sptep, level)) {
-			struct kvm_mmu_page *sp = page_header(__pa(sptep));
-			int offset = 0;
+			sp = page_header(__pa(sptep));
 
 			if (PTTYPE == 32) {
 				if (level == PT_DIRECTORY_LEVEL)
@@ -485,8 +484,8 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 					offset = PT64_LEVEL_BITS;
 				offset = sp->role.quadrant << offset;
 			}
-			pte_gpa = (sp->gfn << PAGE_SHIFT);
-			pte_gpa += (sptep - sp->spt + offset) *
+			gfn = sp->gfn;
+			offset = (sptep - sp->spt + offset) *
 					sizeof(pt_element_t);
 
 			if (is_shadow_present_pte(*sptep)) {
@@ -506,16 +505,28 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 	if (need_flush)
 		kvm_flush_remote_tlbs(vcpu->kvm);
 
-	atomic_inc(&vcpu->kvm->arch.invlpg_counter);
+	invlpg_counter = atomic_add_return(1, &vcpu->kvm->arch.invlpg_counter);
 
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
-	if (pte_gpa == -1)
+	if (gfn == -1)
 		return;
 
 	if (mmu_topup_memory_caches(vcpu))
 		return;
-	kvm_mmu_pte_write(vcpu, pte_gpa, NULL, sizeof(pt_element_t), 0);
+
+	kvm_read_guest_page(vcpu->kvm, gfn, &gentry, offset,
+				sizeof(pt_element_t));
+
+	mmu_guess_page_from_pte_write(vcpu, gfn_to_gpa(gfn) + offset, gentry);
+	spin_lock(&vcpu->kvm->mmu_lock);
+	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) == invlpg_counter &&
+		sp->role.level == PT_PAGE_TABLE_LEVEL) {
+		++vcpu->kvm->stat.mmu_pte_updated;
+		FNAME(update_pte)(vcpu, sp, sptep, &gentry);
+	}
+
+	spin_unlock(&vcpu->kvm->mmu_lock);
 }
 
 static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr, u32 access,
-- 
1.6.1.2



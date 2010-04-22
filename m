Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab0DVGRE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 02:17:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58774 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752704Ab0DVGQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 02:16:58 -0400
Message-ID: <4BCFE921.5050008@cn.fujitsu.com>
Date: Thu, 22 Apr 2010 14:13:53 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 9/10] KVM MMU: separate invlpg code form kvm_mmu_pte_write()
References: <4BCFE581.8050305@cn.fujitsu.com>
In-Reply-To: <4BCFE581.8050305@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let invlpg not depends on kvm_mmu_pte_write path, later patch will need
this feature

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   40 ++++++++++++++++++++++++----------------
 1 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e0bb4d8..f092e71 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2278,14 +2278,21 @@ static bool is_rsvd_bits_set(struct kvm_vcpu *vcpu, u64 gpte, int level)
 	return (gpte & vcpu->arch.mmu.rsvd_bits_mask[bit7][level-1]) != 0;
 }
 
+static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
+					  u64 gpte);
+static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
+				  struct kvm_mmu_page *sp,
+				  u64 *spte,
+				  const void *new);
+
 static void paging_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 {
+	struct kvm_mmu_page *sp = NULL;
 	struct kvm_shadow_walk_iterator iterator;
-	gpa_t pte_gpa = -1;
-	int level;
-	u64 *sptep;
-	int need_flush = 0;
+	gfn_t gfn = -1;
+	u64 *sptep = NULL,  gentry;
 	unsigned pte_size = 0;
+	int invlpg_counter, level, offset = 0, need_flush = 0;
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 
@@ -2294,14 +2301,14 @@ static void paging_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 		sptep = iterator.sptep;
 
 		if (is_last_spte(*sptep, level)) {
-			struct kvm_mmu_page *sp = page_header(__pa(sptep));
-			int offset = 0;
+
+			sp = page_header(__pa(sptep));
 
 			if (!sp->role.cr4_pae)
 				offset = sp->role.quadrant << PT64_LEVEL_BITS;;
 			pte_size = sp->role.cr4_pae ? 8 : 4;
-			pte_gpa = (sp->gfn << PAGE_SHIFT);
-			pte_gpa += (sptep - sp->spt + offset) * pte_size;
+			gfn = (sp->gfn << PAGE_SHIFT);
+			offset = (sptep - sp->spt + offset) * pte_size;
 
 			if (is_shadow_present_pte(*sptep)) {
 				rmap_remove(vcpu->kvm, sptep);
@@ -2320,16 +2327,22 @@ static void paging_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
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
-	kvm_mmu_pte_write(vcpu, pte_gpa, NULL, pte_size, 0);
+
+	kvm_read_guest_page(vcpu->kvm, gfn, &gentry, offset, pte_size);
+	mmu_guess_page_from_pte_write(vcpu, gfn_to_gpa(gfn) + offset, gentry);
+	spin_lock(&vcpu->kvm->mmu_lock);
+	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) == invlpg_counter)
+		mmu_pte_write_new_pte(vcpu, sp, sptep, &gentry);
+	spin_unlock(&vcpu->kvm->mmu_lock);
 }
 
 #define PTTYPE 64
@@ -2675,12 +2688,9 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
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
@@ -2713,8 +2723,6 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 	mmu_guess_page_from_pte_write(vcpu, gpa, gentry);
 	spin_lock(&vcpu->kvm->mmu_lock);
-	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) != invlpg_counter)
-		gentry = 0;
 	kvm_mmu_access_page(vcpu, gfn);
 	kvm_mmu_free_some_pages(vcpu);
 	++vcpu->kvm->stat.mmu_pte_write;
-- 
1.6.1.2



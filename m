Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1HPGmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 02:42:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64081 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab1HPGmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 02:42:11 -0400
Message-ID: <4E4A11B6.9070909@cn.fujitsu.com>
Date: Tue, 16 Aug 2011 14:44:06 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 06/11] KVM: MMU: cleanup FNAME(invlpg)
References: <4E4A10E8.5090705@cn.fujitsu.com>
In-Reply-To: <4E4A10E8.5090705@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-16 14:40:55,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-16 14:40:56,
	Serialize complete at 2011-08-16 14:40:56
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Directly use mmu_page_zap_pte to zap spte in FNAME(invlpg), also remove the
same code between FNAME(invlpg) and FNAME(sync_page)

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |   16 ++++++++++------
 arch/x86/kvm/paging_tmpl.h |   42 +++++++++++++++---------------------------
 2 files changed, 25 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 7ec2a6a..ed3e778 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1808,7 +1808,7 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	}
 }
 
-static void mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
+static bool mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 			     u64 *spte)
 {
 	u64 pte;
@@ -1816,17 +1816,21 @@ static void mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 
 	pte = *spte;
 	if (is_shadow_present_pte(pte)) {
-		if (is_last_spte(pte, sp->role.level))
+		if (is_last_spte(pte, sp->role.level)) {
 			drop_spte(kvm, spte);
-		else {
+			if (is_large_pte(pte))
+				--kvm->stat.lpages;
+		} else {
 			child = page_header(pte & PT64_BASE_ADDR_MASK);
 			drop_parent_pte(child, spte);
 		}
-	} else if (is_mmio_spte(pte))
+		return true;
+	}
+
+	if (is_mmio_spte(pte))
 		mmu_spte_clear_no_track(spte);
 
-	if (is_large_pte(pte))
-		--kvm->stat.lpages;
+	return false;
 }
 
 static void kvm_mmu_page_unlink_children(struct kvm *kvm,
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 9299410..7862c05 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -656,6 +656,16 @@ out_unlock:
 	return 0;
 }
 
+static gpa_t FNAME(get_first_pte_gpa)(struct kvm_mmu_page *sp)
+{
+	int offset = 0;
+
+	if (PTTYPE == 32)
+		offset = sp->role.quadrant << PT64_LEVEL_BITS;
+
+	return gfn_to_gpa(sp->gfn) + offset * sizeof(pt_element_t);
+}
+
 static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	struct kvm_shadow_walk_iterator iterator;
@@ -663,7 +673,6 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 	gpa_t pte_gpa = -1;
 	int level;
 	u64 *sptep;
-	int need_flush = 0;
 
 	vcpu_clear_mmio_info(vcpu, gva);
 
@@ -675,36 +684,20 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 
 		sp = page_header(__pa(sptep));
 		if (is_last_spte(*sptep, level)) {
-			int offset, shift;
-
 			if (!sp->unsync)
 				break;
 
-			shift = PAGE_SHIFT -
-				  (PT_LEVEL_BITS - PT64_LEVEL_BITS) * level;
-			offset = sp->role.quadrant << shift;
-
-			pte_gpa = (sp->gfn << PAGE_SHIFT) + offset;
+			pte_gpa = FNAME(get_first_pte_gpa)(sp);
 			pte_gpa += (sptep - sp->spt) * sizeof(pt_element_t);
 
-			if (is_shadow_present_pte(*sptep)) {
-				if (is_large_pte(*sptep))
-					--vcpu->kvm->stat.lpages;
-				drop_spte(vcpu->kvm, sptep);
-				need_flush = 1;
-			} else if (is_mmio_spte(*sptep))
-				mmu_spte_clear_no_track(sptep);
-
-			break;
+			if (mmu_page_zap_pte(vcpu->kvm, sp, sptep))
+				kvm_flush_remote_tlbs(vcpu->kvm);
 		}
 
 		if (!is_shadow_present_pte(*sptep) || !sp->unsync_children)
 			break;
 	}
 
-	if (need_flush)
-		kvm_flush_remote_tlbs(vcpu->kvm);
-
 	atomic_inc(&vcpu->kvm->arch.invlpg_counter);
 
 	spin_unlock(&vcpu->kvm->mmu_lock);
@@ -769,19 +762,14 @@ static gpa_t FNAME(gva_to_gpa_nested)(struct kvm_vcpu *vcpu, gva_t vaddr,
  */
 static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
-	int i, offset, nr_present;
+	int i, nr_present = 0;
 	bool host_writable;
 	gpa_t first_pte_gpa;
 
-	offset = nr_present = 0;
-
 	/* direct kvm_mmu_page can not be unsync. */
 	BUG_ON(sp->role.direct);
 
-	if (PTTYPE == 32)
-		offset = sp->role.quadrant << PT64_LEVEL_BITS;
-
-	first_pte_gpa = gfn_to_gpa(sp->gfn) + offset * sizeof(pt_element_t);
+	first_pte_gpa = FNAME(get_first_pte_gpa)(sp);
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
 		unsigned pte_access;
-- 
1.7.5.4


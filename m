Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab0DVGP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 02:15:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58168 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab0DVGP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 02:15:56 -0400
Message-ID: <4BCFE8E2.8080302@cn.fujitsu.com>
Date: Thu, 22 Apr 2010 14:12:50 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/10] KVM MMU: Move invlpg code out of paging_tmpl.h
References: <4BCFE3D5.5070105@cn.fujitsu.com>
In-Reply-To: <4BCFE3D5.5070105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using '!sp->role.cr4_pae' replaces 'PTTYPE == 32' and using
'pte_size = sp->role.cr4_pae ? 8 : 4' replaces sizeof(pt_element_t)

Then no need compile twice for this code

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |   60 ++++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/paging_tmpl.h |   56 -----------------------------------------
 2 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index abf8bd4..fac7c09 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2256,6 +2256,62 @@ static bool is_rsvd_bits_set(struct kvm_vcpu *vcpu, u64 gpte, int level)
 	return (gpte & vcpu->arch.mmu.rsvd_bits_mask[bit7][level-1]) != 0;
 }
 
+static void paging_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
+{
+	struct kvm_shadow_walk_iterator iterator;
+	gpa_t pte_gpa = -1;
+	int level;
+	u64 *sptep;
+	int need_flush = 0;
+	unsigned pte_size = 0;
+
+	spin_lock(&vcpu->kvm->mmu_lock);
+
+	for_each_shadow_entry(vcpu, gva, iterator) {
+		level = iterator.level;
+		sptep = iterator.sptep;
+
+		if (level == PT_PAGE_TABLE_LEVEL  ||
+		    ((level == PT_DIRECTORY_LEVEL && is_large_pte(*sptep))) ||
+		    ((level == PT_PDPE_LEVEL && is_large_pte(*sptep)))) {
+			struct kvm_mmu_page *sp = page_header(__pa(sptep));
+			int offset = 0;
+
+			if (!sp->role.cr4_pae)
+				offset = sp->role.quadrant << PT64_LEVEL_BITS;;
+			pte_size = sp->role.cr4_pae ? 8 : 4;
+			pte_gpa = (sp->gfn << PAGE_SHIFT);
+			pte_gpa += (sptep - sp->spt + offset) * pte_size;
+
+			if (is_shadow_present_pte(*sptep)) {
+				rmap_remove(vcpu->kvm, sptep);
+				if (is_large_pte(*sptep))
+					--vcpu->kvm->stat.lpages;
+				need_flush = 1;
+			}
+			__set_spte(sptep, shadow_trap_nonpresent_pte);
+			break;
+		}
+
+		if (!is_shadow_present_pte(*sptep))
+			break;
+	}
+
+	if (need_flush)
+		kvm_flush_remote_tlbs(vcpu->kvm);
+
+	atomic_inc(&vcpu->kvm->arch.invlpg_counter);
+
+	spin_unlock(&vcpu->kvm->mmu_lock);
+
+	if (pte_gpa == -1)
+		return;
+
+	if (mmu_topup_memory_caches(vcpu))
+		return;
+	kvm_mmu_pte_write(vcpu, pte_gpa, NULL, pte_size, 0);
+}
+
 #define PTTYPE 64
 #include "paging_tmpl.h"
 #undef PTTYPE
@@ -2335,7 +2391,7 @@ static int paging64_init_context_common(struct kvm_vcpu *vcpu, int level)
 	context->gva_to_gpa = paging64_gva_to_gpa;
 	context->prefetch_page = paging64_prefetch_page;
 	context->sync_page = paging64_sync_page;
-	context->invlpg = paging64_invlpg;
+	context->invlpg = paging_invlpg;
 	context->free = paging_free;
 	context->root_level = level;
 	context->shadow_root_level = level;
@@ -2360,7 +2416,7 @@ static int paging32_init_context(struct kvm_vcpu *vcpu)
 	context->free = paging_free;
 	context->prefetch_page = paging32_prefetch_page;
 	context->sync_page = paging32_sync_page;
-	context->invlpg = paging32_invlpg;
+	context->invlpg = paging_invlpg;
 	context->root_level = PT32_ROOT_LEVEL;
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
 	context->root_hpa = INVALID_PAGE;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 46d80d6..d0df9cd 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -460,62 +460,6 @@ out_unlock:
 	return 0;
 }
 
-static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
-{
-	struct kvm_shadow_walk_iterator iterator;
-	gpa_t pte_gpa = -1;
-	int level;
-	u64 *sptep;
-	int need_flush = 0;
-
-	spin_lock(&vcpu->kvm->mmu_lock);
-
-	for_each_shadow_entry(vcpu, gva, iterator) {
-		level = iterator.level;
-		sptep = iterator.sptep;
-
-		if (level == PT_PAGE_TABLE_LEVEL  ||
-		    ((level == PT_DIRECTORY_LEVEL && is_large_pte(*sptep))) ||
-		    ((level == PT_PDPE_LEVEL && is_large_pte(*sptep)))) {
-			struct kvm_mmu_page *sp = page_header(__pa(sptep));
-			int offset = 0;
-
-			if (PTTYPE == 32)
-				offset = sp->role.quadrant << PT64_LEVEL_BITS;;
-
-			pte_gpa = (sp->gfn << PAGE_SHIFT);
-			pte_gpa += (sptep - sp->spt + offset) *
-					sizeof(pt_element_t);
-
-			if (is_shadow_present_pte(*sptep)) {
-				rmap_remove(vcpu->kvm, sptep);
-				if (is_large_pte(*sptep))
-					--vcpu->kvm->stat.lpages;
-				need_flush = 1;
-			}
-			__set_spte(sptep, shadow_trap_nonpresent_pte);
-			break;
-		}
-
-		if (!is_shadow_present_pte(*sptep))
-			break;
-	}
-
-	if (need_flush)
-		kvm_flush_remote_tlbs(vcpu->kvm);
-
-	atomic_inc(&vcpu->kvm->arch.invlpg_counter);
-
-	spin_unlock(&vcpu->kvm->mmu_lock);
-
-	if (pte_gpa == -1)
-		return;
-
-	if (mmu_topup_memory_caches(vcpu))
-		return;
-	kvm_mmu_pte_write(vcpu, pte_gpa, NULL, sizeof(pt_element_t), 0);
-}
-
 static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr, u32 access,
 			       u32 *error)
 {
-- 
1.6.1.2



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606Ab0KQEJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:09:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61423 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758341Ab0KQEJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:09:41 -0500
Message-ID: <4CE35687.1020109@cn.fujitsu.com>
Date: Wed, 17 Nov 2010 12:13:59 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 6/6] KVM: MMU: cleanup update_pte, pte_prefetch and sync_page
 functions
References: <4CE355A0.6020907@cn.fujitsu.com>
In-Reply-To: <4CE355A0.6020907@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-17 12:10:02,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-17 12:10:03,
	Serialize complete at 2010-11-17 12:10:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abstract the same operation to cleanup them

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |    3 --
 arch/x86/kvm/paging_tmpl.h |   70 ++++++++++++++++++++++---------------------
 2 files changed, 36 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0668f4b..c513afc 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3082,9 +3082,6 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
 		return;
         }
 
-	if (is_rsvd_bits_set(&vcpu->arch.mmu, *(u64 *)new, PT_PAGE_TABLE_LEVEL))
-		return;
-
 	++vcpu->kvm->stat.mmu_pte_updated;
 	if (!sp->role.cr4_pae)
 		paging32_update_pte(vcpu, sp, spte, new);
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 60f00db..01a00b0 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -299,25 +299,43 @@ static int FNAME(walk_addr_nested)(struct guest_walker *walker,
 					addr, access);
 }
 
+static bool FNAME(map_invalid_gpte)(struct kvm_vcpu *vcpu,
+				    struct kvm_mmu_page *sp, u64 *spte,
+				    pt_element_t gpte)
+{
+	u64 nonpresent = shadow_trap_nonpresent_pte;
+
+	if (is_rsvd_bits_set(&vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL))
+		goto no_present;
+
+	if (!is_present_gpte(gpte)) {
+		if (!sp->unsync)
+			nonpresent = shadow_notrap_nonpresent_pte;
+		goto no_present;
+	}
+
+	if (!(gpte & PT_ACCESSED_MASK))
+		goto no_present;
+
+	return false;
+
+no_present:
+	if (drop_spte(vcpu->kvm, spte, nonpresent))
+		kvm_flush_remote_tlbs(vcpu->kvm);
+	return true;
+}
+
 static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			      u64 *spte, const void *pte)
 {
 	pt_element_t gpte;
 	unsigned pte_access;
 	pfn_t pfn;
-	u64 new_spte;
 
 	gpte = *(const pt_element_t *)pte;
-	if (~gpte & (PT_PRESENT_MASK | PT_ACCESSED_MASK)) {
-		if (!is_present_gpte(gpte)) {
-			if (sp->unsync)
-				new_spte = shadow_trap_nonpresent_pte;
-			else
-				new_spte = shadow_notrap_nonpresent_pte;
-			__set_spte(spte, new_spte);
-		}
+	if (FNAME(map_invalid_gpte)(vcpu, sp, spte, gpte))
 		return;
-	}
+
 	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
 	pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
 	if (gpte_to_gfn(gpte) != vcpu->arch.update_pte.gfn)
@@ -364,7 +382,6 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 				u64 *sptep)
 {
 	struct kvm_mmu_page *sp;
-	struct kvm_mmu *mmu = &vcpu->arch.mmu;
 	pt_element_t *gptep = gw->prefetch_ptes;
 	u64 *spte;
 	int i;
@@ -395,16 +412,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 
 		gpte = gptep[i];
 
-		if (is_rsvd_bits_set(mmu, gpte, PT_PAGE_TABLE_LEVEL))
-			continue;
-
-		if (!is_present_gpte(gpte)) {
-			if (!sp->unsync)
-				__set_spte(spte, shadow_notrap_nonpresent_pte);
-			continue;
-		}
-
-		if (!(gpte & PT_ACCESSED_MASK))
+		if (FNAME(map_invalid_gpte)(vcpu, sp, spte, gpte))
 			continue;
 
 		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
@@ -761,7 +769,6 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		pt_element_t gpte;
 		gpa_t pte_gpa;
 		gfn_t gfn;
-		bool rsvd_bits_set;
 
 		if (!is_shadow_present_pte(sp->spt[i]))
 			continue;
@@ -773,18 +780,13 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 			return -EINVAL;
 
 		gfn = gpte_to_gfn(gpte);
-		rsvd_bits_set = is_rsvd_bits_set(&vcpu->arch.mmu, gpte,
-						 PT_PAGE_TABLE_LEVEL);
-		if (rsvd_bits_set || gfn != sp->gfns[i] ||
-		      !is_present_gpte(gpte) || !(gpte & PT_ACCESSED_MASK)) {
-			u64 nonpresent;
-
-			if (rsvd_bits_set || is_present_gpte(gpte) ||
-			      sp->unsync)
-				nonpresent = shadow_trap_nonpresent_pte;
-			else
-				nonpresent = shadow_notrap_nonpresent_pte;
-			drop_spte(vcpu->kvm, &sp->spt[i], nonpresent);
+
+		if (FNAME(map_invalid_gpte)(vcpu, sp, &sp->spt[i], gpte))
+			continue;
+
+		if (gfn != sp->gfns[i]) {
+			drop_spte(vcpu->kvm, &sp->spt[i],
+				      shadow_trap_nonpresent_pte);
 			kvm_flush_remote_tlbs(vcpu->kvm);
 			continue;
 		}
-- 
1.7.0.4


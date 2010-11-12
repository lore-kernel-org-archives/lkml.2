Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab0KLKbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:31:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63194 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755949Ab0KLKbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:31:22 -0500
Message-ID: <4CDD187A.9010609@cn.fujitsu.com>
Date: Fri, 12 Nov 2010 18:35:38 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 4/4] KVM: MMU: cleanup update_pte, pte_prefetch and sync_page
 functions
References: <4CDD173E.8010706@cn.fujitsu.com>
In-Reply-To: <4CDD173E.8010706@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-12 18:31:45,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-12 18:31:46,
	Serialize complete at 2010-11-12 18:31:46
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some operation of these functions is very similar, so introduce a
common function to cleanup them

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |    3 -
 arch/x86/kvm/paging_tmpl.h |  191 ++++++++++++++++++++++++-------------------
 2 files changed, 107 insertions(+), 87 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 94d157f..d0bcca2 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3108,9 +3108,6 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
 		return;
         }
 
-	if (is_rsvd_bits_set(&vcpu->arch.mmu, *(u64 *)new, PT_PAGE_TABLE_LEVEL))
-		return;
-
 	++vcpu->kvm->stat.mmu_pte_updated;
 	if (!sp->role.cr4_pae)
 		paging32_update_pte(vcpu, sp, spte, new);
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 952357a..1a1a0b9 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -299,42 +299,90 @@ static int FNAME(walk_addr_nested)(struct guest_walker *walker,
 					addr, access);
 }
 
-static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			      u64 *spte, const void *pte)
+static bool FNAME(fetch_guest_pte)(struct kvm_vcpu *vcpu,
+				   struct kvm_mmu_page *sp, u64 *spte,
+				   bool clear_unsync, pt_element_t gpte,
+				   pfn_t (get_pfn)(struct kvm_vcpu *, u64 *,
+					  pt_element_t, unsigned, bool *))
 {
-	pt_element_t gpte;
 	unsigned pte_access;
+	u64 nonpresent = shadow_trap_nonpresent_pte;
+	gfn_t gfn;
 	pfn_t pfn;
-	u64 new_spte;
+	bool dirty, host_writeable;
 
-	gpte = *(const pt_element_t *)pte;
-	if (~gpte & (PT_PRESENT_MASK | PT_ACCESSED_MASK)) {
-		if (!is_present_gpte(gpte)) {
-			if (sp->unsync)
-				new_spte = shadow_trap_nonpresent_pte;
-			else
-				new_spte = shadow_notrap_nonpresent_pte;
-			__set_spte(spte, new_spte);
-		}
-		return;
+	if (!is_present_gpte(gpte) ||
+	      is_rsvd_bits_set(&vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL)) {
+		if (!sp->unsync && !clear_unsync)
+			nonpresent = shadow_notrap_nonpresent_pte;
+		goto no_present;
 	}
-	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
+
+	if (!(gpte & PT_ACCESSED_MASK))
+		goto no_present;
+
 	pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
+	gfn = gpte_to_gfn(gpte);
+	dirty = is_dirty_gpte(gpte);
+	pfn = get_pfn(vcpu, spte, gpte, pte_access, &host_writeable);
+
+	if (is_error_pfn(pfn))
+		goto no_present;
+
+	if (!host_writeable)
+		pte_access &= ~ACC_WRITE_MASK;
+
+	if (spte_to_pfn(*spte) == pfn)
+		set_spte(vcpu, spte, pte_access, 0, 0,
+			 dirty, PT_PAGE_TABLE_LEVEL, gfn,
+			 pfn, true, false, host_writeable);
+	else
+		mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
+			     dirty, NULL, PT_PAGE_TABLE_LEVEL, gfn,
+			     pfn, true, host_writeable);
+
+	return true;
+
+no_present:
+	drop_spte(vcpu->kvm, spte, nonpresent);
+	return false;
+}
+
+static pfn_t FNAME(get_update_pfn)(struct kvm_vcpu *vcpu, u64 *spte,
+				   pt_element_t gpte, unsigned access,
+				   bool *host_writeable)
+{
+	pfn_t pfn = bad_pfn;
+
 	if (gpte_to_gfn(gpte) != vcpu->arch.update_pte.gfn)
-		return;
+		goto exit;
+
 	pfn = vcpu->arch.update_pte.pfn;
 	if (is_error_pfn(pfn))
-		return;
-	if (mmu_notifier_retry(vcpu, vcpu->arch.update_pte.mmu_seq))
-		return;
-	kvm_get_pfn(pfn);
+		goto exit;
+
+	if (mmu_notifier_retry(vcpu, vcpu->arch.update_pte.mmu_seq)) {
+		pfn = bad_pfn;
+		goto exit;
+	}
+
+	
 	/*
-	 * we call mmu_set_spte() with host_writeable = true beacuse that
+	 * we can set *host_writeable = true beacuse that
 	 * vcpu->arch.update_pte.pfn was fetched from get_user_pages(write = 1).
 	 */
-	mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
-		     is_dirty_gpte(gpte), NULL, PT_PAGE_TABLE_LEVEL,
-		     gpte_to_gfn(gpte), pfn, true, true);
+	*host_writeable = true;
+	kvm_get_pfn(pfn);
+
+exit:
+	return pfn;
+}
+
+static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+			      u64 *spte, const void *pte)
+{
+	FNAME(fetch_guest_pte)(vcpu, sp, spte, false, *(pt_element_t *)pte,
+			       FNAME(get_update_pfn));
 }
 
 static bool FNAME(gpte_changed)(struct kvm_vcpu *vcpu,
@@ -360,11 +408,26 @@ static bool FNAME(gpte_changed)(struct kvm_vcpu *vcpu,
 	return r || curr_pte != gw->ptes[level - 1];
 }
 
+static pfn_t FNAME(get_prefetch_pfn)(struct kvm_vcpu *vcpu, u64 *spte,
+				     pt_element_t gpte, unsigned access,
+				     bool *host_writeable)
+{
+	pfn_t pfn;
+	bool dirty = is_dirty_gpte(gpte);
+
+	*host_writeable = true;
+	pfn = pte_prefetch_gfn_to_pfn(vcpu, gpte_to_gfn(gpte),
+				      (access & ACC_WRITE_MASK) && dirty);
+	if (is_error_pfn(pfn))
+		kvm_release_pfn_clean(pfn);
+
+	return pfn;
+}
+
 static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 				u64 *sptep)
 {
 	struct kvm_mmu_page *sp;
-	struct kvm_mmu *mmu = &vcpu->arch.mmu;
 	pt_element_t *gptep = gw->prefetch_ptes;
 	u64 *spte;
 	int i;
@@ -382,10 +445,6 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 
 	for (i = 0; i < PTE_PREFETCH_NUM; i++, spte++) {
 		pt_element_t gpte;
-		unsigned pte_access;
-		gfn_t gfn;
-		pfn_t pfn;
-		bool dirty;
 
 		if (spte == sptep)
 			continue;
@@ -394,30 +453,8 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 			continue;
 
 		gpte = gptep[i];
-
-		if (!is_present_gpte(gpte) ||
-		      is_rsvd_bits_set(mmu, gpte, PT_PAGE_TABLE_LEVEL)) {
-			if (!sp->unsync)
-				__set_spte(spte, shadow_notrap_nonpresent_pte);
-			continue;
-		}
-
-		if (!(gpte & PT_ACCESSED_MASK))
-			continue;
-
-		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
-		gfn = gpte_to_gfn(gpte);
-		dirty = is_dirty_gpte(gpte);
-		pfn = pte_prefetch_gfn_to_pfn(vcpu, gfn,
-				      (pte_access & ACC_WRITE_MASK) && dirty);
-		if (is_error_pfn(pfn)) {
-			kvm_release_pfn_clean(pfn);
-			break;
-		}
-
-		mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
-			     dirty, NULL, PT_PAGE_TABLE_LEVEL, gfn,
-			     pfn, true, true);
+		FNAME(fetch_guest_pte)(vcpu, sp, spte, false, gpte,
+		      FNAME(get_prefetch_pfn));
 	}
 }
 
@@ -733,6 +770,20 @@ static void FNAME(prefetch_page)(struct kvm_vcpu *vcpu,
 	}
 }
 
+static pfn_t FNAME(get_sync_pfn)(struct kvm_vcpu *vcpu, u64 *spte,
+				 pt_element_t gpte, unsigned access,
+				 bool *host_writeable)
+{
+	struct kvm_mmu_page *sp = page_header(__pa(spte));
+
+	if (gpte_to_gfn(gpte) != sp->gfns[spte - sp->spt])
+		return bad_pfn;
+
+	*host_writeable = !!(*spte & SPTE_HOST_WRITEABLE);
+
+	return spte_to_pfn(*spte);
+}
+
 /*
  * Using the cached information from sp->gfns is safe because:
  * - The spte has a reference to the struct page, so the pfn for a given gfn
@@ -742,7 +793,6 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			    bool clear_unsync)
 {
 	int i, offset, nr_present;
-	bool host_writeable;
 	gpa_t first_pte_gpa;
 
 	offset = nr_present = 0;
@@ -756,11 +806,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	first_pte_gpa = gfn_to_gpa(sp->gfn) + offset * sizeof(pt_element_t);
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
-		unsigned pte_access;
 		pt_element_t gpte;
 		gpa_t pte_gpa;
-		gfn_t gfn;
-		bool gpte_invalid;
 
 		if (!is_shadow_present_pte(sp->spt[i]))
 			continue;
@@ -771,33 +818,9 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 					  sizeof(pt_element_t)))
 			return -EINVAL;
 
-		gfn = gpte_to_gfn(gpte);
-		gpte_invalid = is_present_gpte(gpte) ||
-		   is_rsvd_bits_set(&vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL);
-		if (gpte_invalid || gfn != sp->gfns[i] ||
-		      !(gpte & PT_ACCESSED_MASK)) {
-			u64 nonpresent;
-
-			if (gpte_invalid || !clear_unsync)
-				nonpresent = shadow_trap_nonpresent_pte;
-			else
-				nonpresent = shadow_notrap_nonpresent_pte;
-			drop_spte(vcpu->kvm, &sp->spt[i], nonpresent);
-			continue;
-		}
-
-		nr_present++;
-		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
-		if (!(sp->spt[i] & SPTE_HOST_WRITEABLE)) {
-			pte_access &= ~ACC_WRITE_MASK;
-			host_writeable = 0;
-		} else {
-			host_writeable = 1;
-		}
-		set_spte(vcpu, &sp->spt[i], pte_access, 0, 0,
-			 is_dirty_gpte(gpte), PT_PAGE_TABLE_LEVEL, gfn,
-			 spte_to_pfn(sp->spt[i]), true, false,
-			 host_writeable);
+		if (FNAME(fetch_guest_pte)(vcpu, sp, &sp->spt[i], clear_unsync,
+		    gpte, FNAME(get_sync_pfn)))
+			nr_present++;
 	}
 
 	return !nr_present;
-- 
1.7.0.4


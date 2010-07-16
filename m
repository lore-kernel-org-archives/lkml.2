Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935474Ab0GPCMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 22:12:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50267 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935423Ab0GPCMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 22:12:41 -0400
Message-ID: <4C3FC030.2050301@cn.fujitsu.com>
Date: Fri, 16 Jul 2010 10:13:04 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 4/6] kvm: add host_writable parameter
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add host_writable parameter for some functions,
no functionality changed, prepare for using RO pages.


Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0867ced..8ba9b0d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1861,7 +1861,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		    unsigned pte_access, int user_fault,
 		    int write_fault, int dirty, int level,
 		    gfn_t gfn, pfn_t pfn, bool speculative,
-		    bool can_unsync, bool reset_host_protection)
+		    bool can_unsync, bool host_writable)
 {
 	u64 spte;
 	int ret = 0;
@@ -1888,8 +1888,10 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		spte |= kvm_x86_ops->get_mt_mask(vcpu, gfn,
 			kvm_is_mmio_pfn(pfn));
 
-	if (reset_host_protection)
+	if (host_writable)
 		spte |= SPTE_HOST_WRITEABLE;
+	else
+		pte_access &= ~ACC_WRITE_MASK;
 
 	spte |= (u64)pfn << PAGE_SHIFT;
 
@@ -1942,7 +1944,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			 int user_fault, int write_fault, int dirty,
 			 int *ptwrite, int level, gfn_t gfn,
 			 pfn_t pfn, bool speculative,
-			 bool reset_host_protection)
+			 bool host_writable)
 {
 	int was_rmapped = 0;
 	int was_writable = is_writable_pte(*sptep);
@@ -1978,7 +1980,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	if (set_spte(vcpu, sptep, pte_access, user_fault, write_fault,
 		      dirty, level, gfn, pfn, speculative, true,
-		      reset_host_protection)) {
+		      host_writable)) {
 		if (write_fault)
 			*ptwrite = 1;
 		kvm_mmu_flush_tlb(vcpu);
@@ -2015,7 +2017,7 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 }
 
 static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
-			int level, gfn_t gfn, pfn_t pfn)
+			int level, gfn_t gfn, pfn_t pfn, bool host_writable)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
@@ -2026,7 +2028,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 		if (iterator.level == level) {
 			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL, ACC_ALL,
 				     0, write, 1, &pt_write,
-				     level, gfn, pfn, false, true);
+				     level, gfn, pfn, false, host_writable);
 			++vcpu->stat.pf_fixed;
 			break;
 		}
@@ -2107,7 +2109,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 	if (mmu_notifier_retry(vcpu, mmu_seq))
 		goto out_unlock;
 	kvm_mmu_free_some_pages(vcpu);
-	r = __direct_map(vcpu, v, write, level, gfn, pfn);
+	r = __direct_map(vcpu, v, write, level, gfn, pfn, true);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 
@@ -2327,7 +2329,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
 		goto out_unlock;
 	kvm_mmu_free_some_pages(vcpu);
 	r = __direct_map(vcpu, gpa, error_code & PFERR_WRITE_MASK,
-			 level, gfn, pfn);
+			 level, gfn, pfn, true);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 	return r;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index ac24158..a9dbaa0 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -291,7 +291,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		return;
 	kvm_get_pfn(pfn);
 	/*
-	 * we call mmu_set_spte() with reset_host_protection = true beacuse that
+	 * we call mmu_set_spte() with host_writable = true beacuse that
 	 * vcpu->arch.update_pte.pfn was fetched from get_user_pages(write = 1).
 	 */
 	mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
@@ -305,7 +305,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			 struct guest_walker *gw,
 			 int user_fault, int write_fault, int hlevel,
-			 int *ptwrite, pfn_t pfn)
+			 int *ptwrite, pfn_t pfn, bool host_writable)
 {
 	unsigned access = gw->pt_access;
 	struct kvm_mmu_page *sp;
@@ -334,7 +334,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 				     gw->pte_access & access,
 				     user_fault, write_fault,
 				     dirty, ptwrite, level,
-				     gw->gfn, pfn, false, true);
+				     gw->gfn, pfn, false, host_writable);
 			break;
 		}
 
@@ -472,7 +472,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 		goto out_unlock;
 	kvm_mmu_free_some_pages(vcpu);
 	sptep = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
-			     level, &write_pt, pfn);
+			     level, &write_pt, pfn, true);
 	(void)sptep;
 	pgprintk("%s: shadow pte %p %llx ptwrite %d\n", __func__,
 		 sptep, *sptep, write_pt);
@@ -611,7 +611,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			    bool clear_unsync)
 {
 	int i, offset, nr_present;
-	bool reset_host_protection;
+	bool host_writable;
 	gpa_t first_pte_gpa;
 
 	offset = nr_present = 0;
@@ -655,15 +655,14 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		nr_present++;
 		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
 		if (!(sp->spt[i] & SPTE_HOST_WRITEABLE)) {
-			pte_access &= ~ACC_WRITE_MASK;
-			reset_host_protection = 0;
+			host_writable = false;
 		} else {
-			reset_host_protection = 1;
+			host_writable = true;
 		}
 		set_spte(vcpu, &sp->spt[i], pte_access, 0, 0,
 			 is_dirty_gpte(gpte), PT_PAGE_TABLE_LEVEL, gfn,
 			 spte_to_pfn(sp->spt[i]), true, false,
-			 reset_host_protection);
+			 host_writable);
 	}
 
 	return !nr_present;

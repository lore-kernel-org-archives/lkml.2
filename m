Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab1FGM66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 08:58:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59601 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab1FGM64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 08:58:56 -0400
Message-ID: <4DEE210E.2000404@cn.fujitsu.com>
Date: Tue, 07 Jun 2011 21:01:02 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 05/15] KVM: MMU: optimize to handle dirty bit
References: <4DEE205E.8000601@cn.fujitsu.com>
In-Reply-To: <4DEE205E.8000601@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-07 20:58:44,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-07 20:58:45,
	Serialize complete at 2011-06-07 20:58:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If dirty bit is not set, we can make the pte access read-only to avoid handing
dirty bit everywhere

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |   13 ++++++-------
 arch/x86/kvm/paging_tmpl.h |   30 ++++++++++--------------------
 2 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 415030e..a10afd4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1923,7 +1923,7 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 
 static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		    unsigned pte_access, int user_fault,
-		    int write_fault, int dirty, int level,
+		    int write_fault, int level,
 		    gfn_t gfn, pfn_t pfn, bool speculative,
 		    bool can_unsync, bool host_writable)
 {
@@ -1938,8 +1938,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	spte = PT_PRESENT_MASK;
 	if (!speculative)
 		spte |= shadow_accessed_mask;
-	if (!dirty)
-		pte_access &= ~ACC_WRITE_MASK;
+
 	if (pte_access & ACC_EXEC_MASK)
 		spte |= shadow_x_mask;
 	else
@@ -2014,7 +2013,7 @@ done:
 
 static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			 unsigned pt_access, unsigned pte_access,
-			 int user_fault, int write_fault, int dirty,
+			 int user_fault, int write_fault,
 			 int *ptwrite, int level, gfn_t gfn,
 			 pfn_t pfn, bool speculative,
 			 bool host_writable)
@@ -2050,7 +2049,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	}
 
 	if (set_spte(vcpu, sptep, pte_access, user_fault, write_fault,
-		      dirty, level, gfn, pfn, speculative, true,
+		      level, gfn, pfn, speculative, true,
 		      host_writable)) {
 		if (write_fault)
 			*ptwrite = 1;
@@ -2120,7 +2119,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 
 	for (i = 0; i < ret; i++, gfn++, start++)
 		mmu_set_spte(vcpu, start, ACC_ALL,
-			     access, 0, 0, 1, NULL,
+			     access, 0, 0, NULL,
 			     sp->role.level, gfn,
 			     page_to_pfn(pages[i]), true, true);
 
@@ -2184,7 +2183,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 			unsigned pte_access = ACC_ALL;
 
 			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL, pte_access,
-				     0, write, 1, &pt_write,
+				     0, write, &pt_write,
 				     level, gfn, pfn, prefault, map_writable);
 			direct_pte_prefetch(vcpu, iterator.sptep);
 			++vcpu->stat.pf_fixed;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index b0c8184..67971da 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -106,6 +106,9 @@ static unsigned FNAME(gpte_access)(struct kvm_vcpu *vcpu, pt_element_t gpte)
 	unsigned access;
 
 	access = (gpte & (PT_WRITABLE_MASK | PT_USER_MASK)) | ACC_EXEC_MASK;
+	if (!is_dirty_gpte(gpte))
+		access &= ~ACC_WRITE_MASK;
+
 #if PTTYPE == 64
 	if (vcpu->arch.mmu.nx)
 		access &= ~(gpte >> PT64_NX_SHIFT);
@@ -378,7 +381,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	 * vcpu->arch.update_pte.pfn was fetched from get_user_pages(write = 1).
 	 */
 	mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
-		     is_dirty_gpte(gpte), NULL, PT_PAGE_TABLE_LEVEL,
+		     NULL, PT_PAGE_TABLE_LEVEL,
 		     gpte_to_gfn(gpte), pfn, true, true);
 }
 
@@ -429,7 +432,6 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 		unsigned pte_access;
 		gfn_t gfn;
 		pfn_t pfn;
-		bool dirty;
 
 		if (spte == sptep)
 			continue;
@@ -444,16 +446,15 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 
 		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
 		gfn = gpte_to_gfn(gpte);
-		dirty = is_dirty_gpte(gpte);
 		pfn = pte_prefetch_gfn_to_pfn(vcpu, gfn,
-				      (pte_access & ACC_WRITE_MASK) && dirty);
+				      pte_access & ACC_WRITE_MASK);
 		if (is_error_pfn(pfn)) {
 			kvm_release_pfn_clean(pfn);
 			break;
 		}
 
 		mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
-			     dirty, NULL, PT_PAGE_TABLE_LEVEL, gfn,
+			     NULL, PT_PAGE_TABLE_LEVEL, gfn,
 			     pfn, true, true);
 	}
 }
@@ -469,7 +470,6 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 {
 	unsigned access = gw->pt_access;
 	struct kvm_mmu_page *sp = NULL;
-	bool dirty = is_dirty_gpte(gw->ptes[gw->level - 1]);
 	int top_level;
 	unsigned direct_access;
 	struct kvm_shadow_walk_iterator it;
@@ -478,8 +478,6 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		return NULL;
 
 	direct_access = gw->pt_access & gw->pte_access;
-	if (!dirty)
-		direct_access &= ~ACC_WRITE_MASK;
 
 	top_level = vcpu->arch.mmu.root_level;
 	if (top_level == PT32E_ROOT_LEVEL)
@@ -538,7 +536,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	}
 
 	mmu_set_spte(vcpu, it.sptep, access, gw->pte_access & access,
-		     user_fault, write_fault, dirty, ptwrite, it.level,
+		     user_fault, write_fault, ptwrite, it.level,
 		     gw->gfn, pfn, prefault, map_writable);
 	FNAME(pte_prefetch)(vcpu, gw, it.sptep);
 
@@ -621,17 +619,9 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 		return 0;
 
 	/* mmio */
-	if (is_error_pfn(pfn)) {
-		unsigned access = walker.pte_access;
-		bool dirty = is_dirty_gpte(walker.ptes[walker.level - 1]);
-
-		if (dirty)
-			access &= ~ACC_WRITE_MASK;
-
+	if (is_error_pfn(pfn))
 		return kvm_handle_bad_page(vcpu, mmu_is_nested(vcpu) ? 0 :
-					   addr, access, walker.gfn, pfn);
-	}
-
+				      addr, walker.pte_access, walker.gfn, pfn);
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu, mmu_seq))
 		goto out_unlock;
@@ -852,7 +842,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		host_writable = sp->spt[i] & SPTE_HOST_WRITEABLE;
 
 		set_spte(vcpu, &sp->spt[i], pte_access, 0, 0,
-			 is_dirty_gpte(gpte), PT_PAGE_TABLE_LEVEL, gfn,
+			 PT_PAGE_TABLE_LEVEL, gfn,
 			 spte_to_pfn(sp->spt[i]), true, false,
 			 host_writable);
 	}
-- 
1.7.4.4


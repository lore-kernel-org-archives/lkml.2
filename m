Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab2JPMIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 08:08:51 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:37477 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab2JPMIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 08:08:49 -0400
Message-ID: <507D4E4B.6050509@linux.vnet.ibm.com>
Date: Tue, 16 Oct 2012 20:08:43 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v5 3/6] KVM: MMU: cleanup FNAME(page_fault)
References: <507D4DE7.5080708@linux.vnet.ibm.com>
In-Reply-To: <507D4DE7.5080708@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12101612-5490-0000-0000-0000024B9A27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let it return emulate state instead of spte like __direct_map

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/paging_tmpl.h |   32 +++++++++++++-------------------
 1 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 045d31a..c555532 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -427,21 +427,21 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,

 /*
  * Fetch a shadow pte for a specific level in the paging hierarchy.
+ * If the guest tries to write a write-protected page, we need to
+ * emulate this operation, return 1 to indicate this case.
  */
-static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
+static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			 struct guest_walker *gw,
 			 int user_fault, int write_fault, int hlevel,
-			 int *emulate, pfn_t pfn, bool map_writable,
-			 bool prefault)
+			 pfn_t pfn, bool map_writable, bool prefault)
 {
-	unsigned access = gw->pt_access;
 	struct kvm_mmu_page *sp = NULL;
-	int top_level;
-	unsigned direct_access;
 	struct kvm_shadow_walk_iterator it;
+	unsigned direct_access, access = gw->pt_access;
+	int top_level, emulate = 0;

 	if (!is_present_gpte(gw->ptes[gw->level - 1]))
-		return NULL;
+		return 0;

 	direct_access = gw->pte_access;

@@ -505,17 +505,17 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,

 	clear_sp_write_flooding_count(it.sptep);
 	mmu_set_spte(vcpu, it.sptep, access, gw->pte_access,
-		     user_fault, write_fault, emulate, it.level,
+		     user_fault, write_fault, &emulate, it.level,
 		     gw->gfn, pfn, prefault, map_writable);
 	FNAME(pte_prefetch)(vcpu, gw, it.sptep);

-	return it.sptep;
+	return emulate;

 out_gpte_changed:
 	if (sp)
 		kvm_mmu_put_page(sp, it.sptep);
 	kvm_release_pfn_clean(pfn);
-	return NULL;
+	return 0;
 }

 /*
@@ -538,8 +538,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 	int write_fault = error_code & PFERR_WRITE_MASK;
 	int user_fault = error_code & PFERR_USER_MASK;
 	struct guest_walker walker;
-	u64 *sptep;
-	int emulate = 0;
 	int r;
 	pfn_t pfn;
 	int level = PT_PAGE_TABLE_LEVEL;
@@ -601,17 +599,13 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 	kvm_mmu_free_some_pages(vcpu);
 	if (!force_pt_level)
 		transparent_hugepage_adjust(vcpu, &walker.gfn, &pfn, &level);
-	sptep = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
-			     level, &emulate, pfn, map_writable, prefault);
-	(void)sptep;
-	pgprintk("%s: shadow pte %p %llx emulate %d\n", __func__,
-		 sptep, *sptep, emulate);
-
+	r = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
+			 level, pfn, map_writable, prefault);
 	++vcpu->stat.pf_fixed;
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
 	spin_unlock(&vcpu->kvm->mmu_lock);

-	return emulate;
+	return r;

 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
-- 
1.7.7.6


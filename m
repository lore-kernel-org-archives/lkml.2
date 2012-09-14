Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab2INJ6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 05:58:36 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:42876 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab2INJ6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 05:58:34 -0400
Message-ID: <5052FFC2.6060405@linux.vnet.ibm.com>
Date: Fri, 14 Sep 2012 17:58:26 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 3/5] KVM: MMU: cleanup FNAME(page_fault)
References: <5052FF61.3070600@linux.vnet.ibm.com>
In-Reply-To: <5052FF61.3070600@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12091409-8256-0000-0000-0000042C0629
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let it return emulate state instead of spte like __direct_map

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/paging_tmpl.h |   28 ++++++++++------------------
 1 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 92f466c..0adf376 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -463,20 +463,18 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 /*
  * Fetch a shadow pte for a specific level in the paging hierarchy.
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

@@ -540,17 +538,17 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,

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

-	return NULL;
+	return 0;
 }

 /*
@@ -573,8 +571,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 	int write_fault = error_code & PFERR_WRITE_MASK;
 	int user_fault = error_code & PFERR_USER_MASK;
 	struct guest_walker walker;
-	u64 *sptep;
-	int emulate = 0;
 	int r;
 	pfn_t pfn;
 	int level = PT_PAGE_TABLE_LEVEL;
@@ -638,15 +634,11 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 	kvm_mmu_free_some_pages(vcpu);
 	if (!force_pt_level)
 		transparent_hugepage_adjust(vcpu, &walker.gfn, &pfn, &level);
-	sptep = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
-			     level, &emulate, pfn, map_writable, prefault);
-	(void)sptep;
-	pgprintk("%s: shadow pte %p %llx emulate %d\n", __func__,
-		 sptep, *sptep, emulate);
+	r = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
+			 level, pfn, map_writable, prefault);

 	++vcpu->stat.pf_fixed;
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
-	r = emulate;

 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
-- 
1.7.7.6


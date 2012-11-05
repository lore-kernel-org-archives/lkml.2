Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab2KEMM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:12:58 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:44516 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab2KEMM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:12:56 -0500
Message-ID: <5097AD3F.7090309@linux.vnet.ibm.com>
Date: Mon, 05 Nov 2012 20:12:47 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 5/5] KVM: MMU: remove pt_access in mmu_set_spte
References: <5097AC70.1080904@linux.vnet.ibm.com>
In-Reply-To: <5097AC70.1080904@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12110512-1618-0000-0000-000002C9BC50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is only used in debug code, so drop it

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c         |   16 +++++++---------
 arch/x86/kvm/paging_tmpl.h |    9 ++++-----
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4229e78..1faded1 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2422,15 +2422,14 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 }

 static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
-			 unsigned pt_access, unsigned pte_access,
-			 int write_fault, int *emulate, int level,
-			 gfn_t gfn, pfn_t pfn, bool speculative,
+			 unsigned pte_access, int write_fault, int *emulate,
+			 int level, gfn_t gfn, pfn_t pfn, bool speculative,
 			 bool host_writable)
 {
 	bool was_rmapped = false;

 	pgprintk("%s: spte %llx access %x write_fault %d gfn %llx\n",
-		 __func__, *sptep, pt_access, write_fault, gfn);
+		 __func__, *sptep, write_fault, gfn);

 	if (is_rmap_spte(*sptep)) {
 		if (pfn != spte_to_pfn(*sptep)) {
@@ -2535,8 +2534,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 		return -1;

 	for (i = 0; i < ret; i++, gfn++, start++)
-		mmu_set_spte(vcpu, start, ACC_ALL,
-			     access, 0, NULL,
+		mmu_set_spte(vcpu, start, access, 0, NULL,
 			     sp->role.level, gfn,
 			     page_to_pfn(pages[i]), true, true);

@@ -2599,9 +2597,9 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 		if (iterator.level == level) {
 			unsigned pte_access = ACC_ALL;

-			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL, pte_access,
-				     write, &emulate,
-				     level, gfn, pfn, prefault, map_writable);
+			mmu_set_spte(vcpu, iterator.sptep, pte_access,
+				     write, &emulate, level, gfn, pfn,
+				     prefault, map_writable);
 			direct_pte_prefetch(vcpu, iterator.sptep);
 			++vcpu->stat.pf_fixed;
 			break;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index b1bcd68..d6b9c59 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -330,8 +330,8 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	 * we call mmu_set_spte() with host_writable = true because
 	 * pte_prefetch_gfn_to_pfn always gets a writable pfn.
 	 */
-	mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0,
-		     NULL, PT_PAGE_TABLE_LEVEL, gfn, pfn, true, true);
+	mmu_set_spte(vcpu, spte, pte_access, 0, NULL, PT_PAGE_TABLE_LEVEL,
+		     gfn, pfn, true, true);

 	return true;
 }
@@ -477,9 +477,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	}

 	clear_sp_write_flooding_count(it.sptep);
-	mmu_set_spte(vcpu, it.sptep, access, gw->pte_access,
-		     write_fault, &emulate, it.level,
-		     gw->gfn, pfn, prefault, map_writable);
+	mmu_set_spte(vcpu, it.sptep, gw->pte_access, write_fault, &emulate,
+		     it.level, gw->gfn, pfn, prefault, map_writable);
 	FNAME(pte_prefetch)(vcpu, gw, it.sptep);

 	return emulate;
-- 
1.7.7.6


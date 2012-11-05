Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab2KEMMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:12:19 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:44929 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab2KEMMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:12:16 -0500
Message-ID: <5097AD17.4010001@linux.vnet.ibm.com>
Date: Mon, 05 Nov 2012 20:12:07 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 4/5] KVM: MMU: move adjusting softmmu pte access to FNAME(page_fault)
References: <5097AC70.1080904@linux.vnet.ibm.com>
In-Reply-To: <5097AC70.1080904@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12110512-0260-0000-0000-00000219F7EA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Then, no mmu specified code exists in the common function and drop two
parameters in set_spte

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c         |   42 +++++++++++-------------------------------
 arch/x86/kvm/paging_tmpl.h |   25 ++++++++++++++++++++-----
 2 files changed, 31 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 49957df..4229e78 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2351,8 +2351,7 @@ static bool gfn_need_write_protect(struct kvm_vcpu *vcpu, u64 *sptep,

 /* The return value indicates whether the @gfn need to be write protected. */
 static bool vcpu_adjust_access(struct kvm_vcpu *vcpu, u64 *sptep,
-			       unsigned *pte_access, int user_fault,
-			       int write_fault, int level, gfn_t gfn,
+			       unsigned *pte_access, int level, gfn_t gfn,
 			       bool can_unsync, bool host_writable)
 {
 	bool ret = false;
@@ -2361,21 +2360,6 @@ static bool vcpu_adjust_access(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (!host_writable)
 		access &= ~ACC_WRITE_MASK;

-	if (!(access & ACC_WRITE_MASK) && (!vcpu->arch.mmu.direct_map &&
-	      write_fault && !is_write_protection(vcpu) && !user_fault)) {
-		access |= ACC_WRITE_MASK;
-		access &= ~ACC_USER_MASK;
-
-		/*
-		 * If we converted a user page to a kernel page,
-		 * so that the kernel can write to it when cr0.wp=0,
-		 * then we should prevent the kernel from executing it
-		 * if SMEP is enabled.
-		 */
-		if (kvm_read_cr4_bits(vcpu, X86_CR4_SMEP))
-			access &= ~ACC_EXEC_MASK;
-	}
-
 	if ((access & ACC_WRITE_MASK) &&
 		  gfn_need_write_protect(vcpu, sptep, level, gfn, can_unsync)) {
 		access &= ~ACC_WRITE_MASK;
@@ -2387,8 +2371,7 @@ static bool vcpu_adjust_access(struct kvm_vcpu *vcpu, u64 *sptep,
 }

 static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
-		    unsigned pte_access, int user_fault,
-		    int write_fault, int level,
+		    unsigned pte_access, int level,
 		    gfn_t gfn, pfn_t pfn, bool speculative,
 		    bool can_unsync, bool host_writable)
 {
@@ -2398,8 +2381,8 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (set_mmio_spte(sptep, gfn, pfn, pte_access))
 		return 0;

-	ret = vcpu_adjust_access(vcpu, sptep, &pte_access, user_fault,
-		      write_fault, level, gfn, can_unsync, host_writable);
+	ret = vcpu_adjust_access(vcpu, sptep, &pte_access, level, gfn,
+				 can_unsync, host_writable);

 	spte = PT_PRESENT_MASK;
 	if (!speculative)
@@ -2440,17 +2423,14 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,

 static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			 unsigned pt_access, unsigned pte_access,
-			 int user_fault, int write_fault,
-			 int *emulate, int level, gfn_t gfn,
-			 pfn_t pfn, bool speculative,
+			 int write_fault, int *emulate, int level,
+			 gfn_t gfn, pfn_t pfn, bool speculative,
 			 bool host_writable)
 {
 	bool was_rmapped = false;

-	pgprintk("%s: spte %llx access %x write_fault %d"
-		 " user_fault %d gfn %llx\n",
-		 __func__, *sptep, pt_access,
-		 write_fault, user_fault, gfn);
+	pgprintk("%s: spte %llx access %x write_fault %d gfn %llx\n",
+		 __func__, *sptep, pt_access, write_fault, gfn);

 	if (is_rmap_spte(*sptep)) {
 		if (pfn != spte_to_pfn(*sptep)) {
@@ -2462,7 +2442,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			was_rmapped = true;
 	}

-	if (set_spte(vcpu, sptep, pte_access, user_fault, write_fault,
+	if (set_spte(vcpu, sptep, pte_access,
 		      level, gfn, pfn, speculative, true,
 		      host_writable)) {
 		if (write_fault)
@@ -2556,7 +2536,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,

 	for (i = 0; i < ret; i++, gfn++, start++)
 		mmu_set_spte(vcpu, start, ACC_ALL,
-			     access, 0, 0, NULL,
+			     access, 0, NULL,
 			     sp->role.level, gfn,
 			     page_to_pfn(pages[i]), true, true);

@@ -2620,7 +2600,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 			unsigned pte_access = ACC_ALL;

 			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL, pte_access,
-				     0, write, &emulate,
+				     write, &emulate,
 				     level, gfn, pfn, prefault, map_writable);
 			direct_pte_prefetch(vcpu, iterator.sptep);
 			++vcpu->stat.pf_fixed;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 891eb6d..b1bcd68 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -330,7 +330,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	 * we call mmu_set_spte() with host_writable = true because
 	 * pte_prefetch_gfn_to_pfn always gets a writable pfn.
 	 */
-	mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
+	mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0,
 		     NULL, PT_PAGE_TABLE_LEVEL, gfn, pfn, true, true);

 	return true;
@@ -405,7 +405,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
  */
 static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			 struct guest_walker *gw,
-			 int user_fault, int write_fault, int hlevel,
+			 int write_fault, int hlevel,
 			 pfn_t pfn, bool map_writable, bool prefault)
 {
 	struct kvm_mmu_page *sp = NULL;
@@ -478,7 +478,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,

 	clear_sp_write_flooding_count(it.sptep);
 	mmu_set_spte(vcpu, it.sptep, access, gw->pte_access,
-		     user_fault, write_fault, &emulate, it.level,
+		     write_fault, &emulate, it.level,
 		     gw->gfn, pfn, prefault, map_writable);
 	FNAME(pte_prefetch)(vcpu, gw, it.sptep);

@@ -544,6 +544,21 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 		return 0;
 	}

+	if (write_fault && !(walker.pte_access & ACC_WRITE_MASK) &&
+	      !is_write_protection(vcpu) && !user_fault) {
+		walker.pte_access |= ACC_WRITE_MASK;
+		walker.pte_access &= ~ACC_USER_MASK;
+
+		/*
+		 * If we converted a user page to a kernel page,
+		 * so that the kernel can write to it when cr0.wp=0,
+		 * then we should prevent the kernel from executing it
+		 * if SMEP is enabled.
+		 */
+		if (kvm_read_cr4_bits(vcpu, X86_CR4_SMEP))
+			walker.pte_access &= ~ACC_EXEC_MASK;
+	}
+
 	if (walker.level >= PT_DIRECTORY_LEVEL)
 		force_pt_level = mapping_level_dirty_bitmap(vcpu, walker.gfn);
 	else
@@ -572,7 +587,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 	kvm_mmu_free_some_pages(vcpu);
 	if (!force_pt_level)
 		transparent_hugepage_adjust(vcpu, &walker.gfn, &pfn, &level);
-	r = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
+	r = FNAME(fetch)(vcpu, addr, &walker, write_fault,
 			 level, pfn, map_writable, prefault);
 	++vcpu->stat.pf_fixed;
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
@@ -747,7 +762,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)

 		host_writable = sp->spt[i] & SPTE_HOST_WRITEABLE;

-		set_spte(vcpu, &sp->spt[i], pte_access, 0, 0,
+		set_spte(vcpu, &sp->spt[i], pte_access,
 			 PT_PAGE_TABLE_LEVEL, gfn,
 			 spte_to_pfn(sp->spt[i]), true, false,
 			 host_writable);
-- 
1.7.7.6


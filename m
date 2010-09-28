Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034Ab0I1I6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 04:58:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57052 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753707Ab0I1I6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 04:58:48 -0400
Message-ID: <4CA1AF52.5080209@cn.fujitsu.com>
Date: Tue, 28 Sep 2010 17:03:14 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH] KVM: MMU: move access code parsing  to FNAME(walk_addr) function
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move access code parsing from caller site to FNAME(walk_addr) function

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |   40 ++++++++++++++++------------------------
 1 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index a83ff37..9a5f7bb 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -116,16 +116,18 @@ static unsigned FNAME(gpte_access)(struct kvm_vcpu *vcpu, pt_element_t gpte)
  */
 static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 				    struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-				    gva_t addr, int write_fault,
-				    int user_fault, int fetch_fault)
+				    gva_t addr, u32 access)
 {
 	pt_element_t pte;
 	gfn_t table_gfn;
 	unsigned index, pt_access, uninitialized_var(pte_access);
 	gpa_t pte_gpa;
 	bool eperm, present, rsvd_fault;
-	int offset;
-	u32 access = 0;
+	int offset, write_fault, user_fault, fetch_fault;
+
+	write_fault = access & PFERR_WRITE_MASK;
+	user_fault = access & PFERR_USER_MASK;
+	fetch_fault = access & PFERR_FETCH_MASK;
 
 	trace_kvm_mmu_pagetable_walk(addr, write_fault, user_fault,
 				     fetch_fault);
@@ -215,6 +217,7 @@ walk:
 			int lvl = walker->level;
 			gpa_t real_gpa;
 			gfn_t gfn;
+			u32 ac;
 
 			gfn = gpte_to_gfn_lvl(pte, lvl);
 			gfn += (addr & PT_LVL_OFFSET_MASK(lvl)) >> PAGE_SHIFT;
@@ -224,10 +227,10 @@ walk:
 			    is_cpuid_PSE36())
 				gfn += pse36_gfn_delta(pte);
 
-			access |= write_fault | fetch_fault | user_fault;
+			ac = write_fault | fetch_fault | user_fault;
 
 			real_gpa = mmu->translate_gpa(vcpu, gfn_to_gpa(gfn),
-						      access);
+						      ac);
 			if (real_gpa == UNMAPPED_GVA)
 				return 0;
 
@@ -282,21 +285,18 @@ error:
 }
 
 static int FNAME(walk_addr)(struct guest_walker *walker,
-			    struct kvm_vcpu *vcpu, gva_t addr,
-			    int write_fault, int user_fault, int fetch_fault)
+			    struct kvm_vcpu *vcpu, gva_t addr, u32 access)
 {
 	return FNAME(walk_addr_generic)(walker, vcpu, &vcpu->arch.mmu, addr,
-					write_fault, user_fault, fetch_fault);
+					access);
 }
 
 static int FNAME(walk_addr_nested)(struct guest_walker *walker,
 				   struct kvm_vcpu *vcpu, gva_t addr,
-				   int write_fault, int user_fault,
-				   int fetch_fault)
+				   u32 access)
 {
 	return FNAME(walk_addr_generic)(walker, vcpu, &vcpu->arch.nested_mmu,
-					addr, write_fault, user_fault,
-					fetch_fault);
+					addr, access);
 }
 
 static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
@@ -532,7 +532,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 {
 	int write_fault = error_code & PFERR_WRITE_MASK;
 	int user_fault = error_code & PFERR_USER_MASK;
-	int fetch_fault = error_code & PFERR_FETCH_MASK;
 	struct guest_walker walker;
 	u64 *sptep;
 	int write_pt = 0;
@@ -550,8 +549,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	/*
 	 * Look up the guest pte for the faulting address.
 	 */
-	r = FNAME(walk_addr)(&walker, vcpu, addr, write_fault, user_fault,
-			     fetch_fault);
+	r = FNAME(walk_addr)(&walker, vcpu, addr, error_code);
 
 	/*
 	 * The page is not mapped by the guest.  Let the guest handle it.
@@ -669,10 +667,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr, u32 access,
 	gpa_t gpa = UNMAPPED_GVA;
 	int r;
 
-	r = FNAME(walk_addr)(&walker, vcpu, vaddr,
-			     access & PFERR_WRITE_MASK,
-			     access & PFERR_USER_MASK,
-			     access & PFERR_FETCH_MASK);
+	r = FNAME(walk_addr)(&walker, vcpu, vaddr, access);
 
 	if (r) {
 		gpa = gfn_to_gpa(walker.gfn);
@@ -690,10 +685,7 @@ static gpa_t FNAME(gva_to_gpa_nested)(struct kvm_vcpu *vcpu, gva_t vaddr,
 	gpa_t gpa = UNMAPPED_GVA;
 	int r;
 
-	r = FNAME(walk_addr_nested)(&walker, vcpu, vaddr,
-				    access & PFERR_WRITE_MASK,
-				    access & PFERR_USER_MASK,
-				    access & PFERR_FETCH_MASK);
+	r = FNAME(walk_addr_nested)(&walker, vcpu, vaddr, access);
 
 	if (r) {
 		gpa = gfn_to_gpa(walker.gfn);
-- 
1.7.0.4

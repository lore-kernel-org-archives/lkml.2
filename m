Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab0LBJma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 04:42:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61651 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755207Ab0LBJm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 04:42:29 -0500
Message-ID: <4CF76B06.6050708@cn.fujitsu.com>
Date: Thu, 02 Dec 2010 17:46:46 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v4 3/3] KVM: MMU: retry #PF for softmmu
References: <4CF76A8B.2040102@cn.fujitsu.com>
In-Reply-To: <4CF76A8B.2040102@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-02 17:42:36,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-02 17:42:37,
	Serialize complete at 2010-12-02 17:42:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Retry #PF for softmmu only when the current vcpu has the same cr3 as the time
when #PF occurs

Changelog:
  Just compare cr3 value since It's harmless to instantiate an spte for an
  unused translation from Marcelo's comment

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |    2 ++
 arch/x86/kvm/paging_tmpl.h      |   34 +++++++++++++++++++++++-----------
 arch/x86/kvm/x86.c              |    6 +++++-
 4 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a0c066e..1e876e5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -602,6 +602,7 @@ struct kvm_x86_ops {
 struct kvm_arch_async_pf {
 	u32 token;
 	gfn_t gfn;
+	unsigned long cr3;
 	bool direct_map;
 };
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c6bb449..3f0d9a0 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2607,9 +2607,11 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
 {
 	struct kvm_arch_async_pf arch;
+
 	arch.token = (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
 	arch.gfn = gfn;
 	arch.direct_map = vcpu->arch.mmu.direct_map;
+	arch.cr3 = vcpu->arch.mmu.get_cr3(vcpu);
 
 	return kvm_setup_async_pf(vcpu, gva, gfn, &arch);
 }
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 23275d0..437e11a 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -116,7 +116,7 @@ static unsigned FNAME(gpte_access)(struct kvm_vcpu *vcpu, pt_element_t gpte)
  */
 static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 				    struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-				    gva_t addr, u32 access)
+				    gva_t addr, u32 access, bool prefault)
 {
 	pt_element_t pte;
 	gfn_t table_gfn;
@@ -194,6 +194,13 @@ walk:
 #endif
 
 		if (!eperm && !rsvd_fault && !(pte & PT_ACCESSED_MASK)) {
+			/*
+			 * Don't set gpte accessed bit if it's on
+			 * speculative path.
+			 */
+			if (prefault)
+				goto error;
+
 			trace_kvm_mmu_set_accessed_bit(table_gfn, index,
 						       sizeof(pte));
 			if (FNAME(cmpxchg_gpte)(vcpu->kvm, table_gfn,
@@ -287,10 +294,11 @@ error:
 }
 
 static int FNAME(walk_addr)(struct guest_walker *walker,
-			    struct kvm_vcpu *vcpu, gva_t addr, u32 access)
+			    struct kvm_vcpu *vcpu, gva_t addr,
+			    u32 access, bool prefault)
 {
 	return FNAME(walk_addr_generic)(walker, vcpu, &vcpu->arch.mmu, addr,
-					access);
+					access, prefault);
 }
 
 static int FNAME(walk_addr_nested)(struct guest_walker *walker,
@@ -298,7 +306,7 @@ static int FNAME(walk_addr_nested)(struct guest_walker *walker,
 				   u32 access)
 {
 	return FNAME(walk_addr_generic)(walker, vcpu, &vcpu->arch.nested_mmu,
-					addr, access);
+					addr, access, false);
 }
 
 static bool FNAME(prefetch_invalid_gpte)(struct kvm_vcpu *vcpu,
@@ -438,7 +446,8 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			 struct guest_walker *gw,
 			 int user_fault, int write_fault, int hlevel,
-			 int *ptwrite, pfn_t pfn, bool map_writable)
+			 int *ptwrite, pfn_t pfn, bool map_writable,
+			 bool prefault)
 {
 	unsigned access = gw->pt_access;
 	struct kvm_mmu_page *sp = NULL;
@@ -512,7 +521,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 
 	mmu_set_spte(vcpu, it.sptep, access, gw->pte_access & access,
 		     user_fault, write_fault, dirty, ptwrite, it.level,
-		     gw->gfn, pfn, false, map_writable);
+		     gw->gfn, pfn, prefault, map_writable);
 	FNAME(pte_prefetch)(vcpu, gw, it.sptep);
 
 	return it.sptep;
@@ -561,15 +570,18 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 	/*
 	 * Look up the guest pte for the faulting address.
 	 */
-	r = FNAME(walk_addr)(&walker, vcpu, addr, error_code);
+	r = FNAME(walk_addr)(&walker, vcpu, addr, error_code, prefault);
 
 	/*
 	 * The page is not mapped by the guest.  Let the guest handle it.
 	 */
 	if (!r) {
 		pgprintk("%s: guest page fault\n", __func__);
-		inject_page_fault(vcpu);
-		vcpu->arch.last_pt_write_count = 0; /* reset fork detector */
+		if (!prefault) {
+			inject_page_fault(vcpu);
+			/* reset fork detector */
+			vcpu->arch.last_pt_write_count = 0;
+		}
 		return 0;
 	}
 
@@ -599,7 +611,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 	trace_kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
 	kvm_mmu_free_some_pages(vcpu);
 	sptep = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
-			     level, &write_pt, pfn, map_writable);
+			     level, &write_pt, pfn, map_writable, prefault);
 	(void)sptep;
 	pgprintk("%s: shadow pte %p %llx ptwrite %d\n", __func__,
 		 sptep, *sptep, write_pt);
@@ -685,7 +697,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr, u32 access,
 	gpa_t gpa = UNMAPPED_GVA;
 	int r;
 
-	r = FNAME(walk_addr)(&walker, vcpu, vaddr, access);
+	r = FNAME(walk_addr)(&walker, vcpu, vaddr, access, false);
 
 	if (r) {
 		gpa = gfn_to_gpa(walker.gfn);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bfd2878..de5e57b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6183,7 +6183,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 {
 	int r;
 
-	if (!vcpu->arch.mmu.direct_map || !work->arch.direct_map ||
+	if ((vcpu->arch.mmu.direct_map != work->arch.direct_map) ||
 	      is_error_page(work->page))
 		return;
 
@@ -6191,6 +6191,10 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	if (unlikely(r))
 		return;
 
+	if (!vcpu->arch.mmu.direct_map &&
+	      work->arch.cr3 != vcpu->arch.mmu.get_cr3(vcpu))
+		return;
+
 	vcpu->arch.mmu.page_fault(vcpu, work->gva, 0, true);
 }
 
-- 
1.7.0.4


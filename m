Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab0K3JdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 04:33:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57134 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab0K3JdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 04:33:12 -0500
Message-ID: <4CF4C5E0.2020301@cn.fujitsu.com>
Date: Tue, 30 Nov 2010 17:37:36 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 3/3] KVM: MMU: retry #PF for softmmu
References: <4CF4C535.8080405@cn.fujitsu.com>
In-Reply-To: <4CF4C535.8080405@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-30 17:33:20,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-30 17:33:21,
	Serialize complete at 2010-11-30 17:33:21
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Retry #PF for softmmu only when the current vcpu has the same root shadow page
as the time when #PF occurs. it means they have same paging environment

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    5 +++++
 arch/x86/kvm/mmu.c              |   33 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/paging_tmpl.h      |   34 +++++++++++++++++++++++-----------
 arch/x86/kvm/x86.c              |   13 ++++++++++++-
 virt/kvm/async_pf.c             |    1 +
 5 files changed, 73 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 209da89..5acbcab 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -191,6 +191,7 @@ union kvm_mmu_page_role {
 struct kvm_mmu_page {
 	struct list_head link;
 	struct hlist_node hash_link;
+	struct kref apfs_counter;
 
 	/*
 	 * The following two entries are used to key the shadow page in the
@@ -602,6 +603,7 @@ struct kvm_x86_ops {
 struct kvm_arch_async_pf {
 	u32 token;
 	gfn_t gfn;
+	struct kvm_mmu_page *root_sp;
 	bool direct_map;
 };
 
@@ -701,6 +703,8 @@ void kvm_inject_nmi(struct kvm_vcpu *vcpu);
 
 int fx_init(struct kvm_vcpu *vcpu);
 
+struct kvm_mmu_page *get_vcpu_root_sp(struct kvm_vcpu *vcpu, gva_t gva);
+void kvm_mmu_release_apf_sp(struct kvm_mmu_page *sp);
 void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu);
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		       const u8 *new, int bytes,
@@ -819,6 +823,7 @@ void kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
 
 bool kvm_is_linear_rip(struct kvm_vcpu *vcpu, unsigned long linear_rip);
 
+void kvm_arch_clear_async_pf(struct kvm_async_pf *work);
 void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 				     struct kvm_async_pf *work);
 void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f34987d..b9e1681 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -993,6 +993,19 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }
 
+static void free_shadow_page(struct kref *kref)
+{
+	struct kvm_mmu_page *sp;
+
+	sp = container_of(kref, struct kvm_mmu_page, apfs_counter);
+	kmem_cache_free(mmu_page_header_cache, sp);
+}
+
+void kvm_mmu_release_apf_sp(struct kvm_mmu_page *sp)
+{
+	kref_put(&sp->apfs_counter, free_shadow_page);
+}
+
 static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	ASSERT(is_empty_shadow_page(sp->spt));
@@ -1001,7 +1014,7 @@ static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	__free_page(virt_to_page(sp->spt));
 	if (!sp->role.direct)
 		__free_page(virt_to_page(sp->gfns));
-	kmem_cache_free(mmu_page_header_cache, sp);
+	kvm_mmu_release_apf_sp(sp);
 	kvm_mod_used_mmu_pages(kvm, -1);
 }
 
@@ -1025,6 +1038,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
 	sp->multimapped = 0;
 	sp->parent_pte = parent_pte;
+	kref_init(&sp->apfs_counter);
 	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
 	return sp;
 }
@@ -2603,12 +2617,29 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 			     error_code & PFERR_WRITE_MASK, gfn, prefault);
 }
 
+struct kvm_mmu_page *get_vcpu_root_sp(struct kvm_vcpu *vcpu, gva_t gva)
+{
+	struct kvm_shadow_walk_iterator iterator;
+	bool ret;
+
+	shadow_walk_init(&iterator, vcpu, gva);
+	ret = shadow_walk_okay(&iterator);
+	WARN_ON(!ret);
+
+	return page_header(__pa(iterator.sptep));
+}
+
 static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
 {
 	struct kvm_arch_async_pf arch;
+
 	arch.token = (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
 	arch.gfn = gfn;
 	arch.direct_map = vcpu->arch.mmu.direct_map;
+	if (!arch.direct_map) {
+		arch.root_sp = get_vcpu_root_sp(vcpu, gva);
+		kref_get(&arch.root_sp->apfs_counter);
+	}
 
 	return kvm_setup_async_pf(vcpu, gva, gfn, &arch);
 }
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index f04162d..2ca0b67 100644
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
@@ -285,10 +292,11 @@ error:
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
@@ -296,7 +304,7 @@ static int FNAME(walk_addr_nested)(struct guest_walker *walker,
 				   u32 access)
 {
 	return FNAME(walk_addr_generic)(walker, vcpu, &vcpu->arch.nested_mmu,
-					addr, access);
+					addr, access, false);
 }
 
 static bool FNAME(prefetch_invalid_gpte)(struct kvm_vcpu *vcpu,
@@ -436,7 +444,8 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			 struct guest_walker *gw,
 			 int user_fault, int write_fault, int hlevel,
-			 int *ptwrite, pfn_t pfn, bool map_writable)
+			 int *ptwrite, pfn_t pfn, bool map_writable,
+			 bool prefault)
 {
 	unsigned access = gw->pt_access;
 	struct kvm_mmu_page *sp = NULL;
@@ -510,7 +519,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 
 	mmu_set_spte(vcpu, it.sptep, access, gw->pte_access & access,
 		     user_fault, write_fault, dirty, ptwrite, it.level,
-		     gw->gfn, pfn, false, map_writable);
+		     gw->gfn, pfn, prefault, map_writable);
 	FNAME(pte_prefetch)(vcpu, gw, it.sptep);
 
 	return it.sptep;
@@ -559,15 +568,18 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
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
 
@@ -597,7 +609,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 	trace_kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
 	kvm_mmu_free_some_pages(vcpu);
 	sptep = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
-			     level, &write_pt, pfn, map_writable);
+			     level, &write_pt, pfn, map_writable, prefault);
 	(void)sptep;
 	pgprintk("%s: shadow pte %p %llx ptwrite %d\n", __func__,
 		 sptep, *sptep, write_pt);
@@ -683,7 +695,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr, u32 access,
 	gpa_t gpa = UNMAPPED_GVA;
 	int r;
 
-	r = FNAME(walk_addr)(&walker, vcpu, vaddr, access);
+	r = FNAME(walk_addr)(&walker, vcpu, vaddr, access, false);
 
 	if (r) {
 		gpa = gfn_to_gpa(walker.gfn);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83ed55f..33dcbce 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6181,7 +6181,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	if (!shadow_accessed_mask)
 		return;
 
-	if (!vcpu->arch.mmu.direct_map || !work->arch.direct_map ||
+	if ((vcpu->arch.mmu.direct_map != work->arch.direct_map) ||
 	      is_error_page(work->page))
 		return;
 
@@ -6189,6 +6189,10 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	if (unlikely(r))
 		return;
 
+	if (!vcpu->arch.mmu.direct_map &&
+	      get_vcpu_root_sp(vcpu, work->gva) != work->arch.root_sp)
+		return;
+
 	vcpu->arch.mmu.page_fault(vcpu, work->gva, 0, true);
 }
 
@@ -6260,6 +6264,12 @@ static int apf_put_user(struct kvm_vcpu *vcpu, u32 val)
 				      sizeof(val));
 }
 
+void kvm_arch_clear_async_pf(struct kvm_async_pf *work)
+{
+	if (!work->arch.direct_map)
+		kvm_mmu_release_apf_sp(work->arch.root_sp);
+}
+
 void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 				     struct kvm_async_pf *work)
 {
@@ -6281,6 +6291,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 				 struct kvm_async_pf *work)
 {
 	trace_kvm_async_pf_ready(work->arch.token, work->gva);
+	kvm_arch_clear_async_pf(work);
 	if (is_error_page(work->page))
 		work->arch.token = ~0; /* broadcast wakeup */
 	else
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 74268b4..c3d4788 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -101,6 +101,7 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 				   typeof(*work), queue);
 		cancel_work_sync(&work->work);
 		list_del(&work->queue);
+		kvm_arch_clear_async_pf(work);
 		if (!work->done) /* work was canceled */
 			kmem_cache_free(async_pf_cache, work);
 	}
-- 
1.7.0.4

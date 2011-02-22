Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab1BVIPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:15:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57871 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752025Ab1BVIPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:15:44 -0500
Message-ID: <4D6370E8.6080008@cn.fujitsu.com>
Date: Tue, 22 Feb 2011 16:16:40 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 7/7] KVM: MMU: cache guest page number to guest frame number
References: <4D636EF8.60800@cn.fujitsu.com>
In-Reply-To: <4D636EF8.60800@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-22 16:14:40,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-22 16:14:41,
	Serialize complete at 2011-02-22 16:14:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cache guest page number to guest frame number to avoid walk guest page table
frequently, the 'vtlb' idea is from Xen.

Note:
we can't use vtlb in ept guests since the guest tlb invalid operation is not
intercept(reload CR3, invlpg), also can't used in L2 nnpt guest for the same
reason, but we can used it to cache L1's npt page table.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |   10 ++++-
 arch/x86/kvm/mmu.c              |   94 +++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/mmutrace.h         |   79 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/paging_tmpl.h      |   19 +++++++-
 4 files changed, 196 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 178d658..b05ad8f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -234,6 +234,13 @@ struct kvm_pio_request {
 	int size;
 };
 
+#define VTLB_ENTRIES	(1 << 4)
+struct vtlb_entry {
+	gfn_t page_number;
+	gfn_t frame_number;
+	u32 access;
+};
+
 /*
  * x86 supports 3 paging modes (4-level 64-bit, 3-level 64-bit, and 2-level
  * 32-bit).  The kvm_mmu structure abstracts the details of the current mmu
@@ -267,8 +274,9 @@ struct kvm_mmu {
 	u64 rsvd_bits_mask[2][4];
 
 	bool nx;
-
+	bool vtlb_enabled;
 	u64 pdptrs[4]; /* pae */
+	struct vtlb_entry vtlb[VTLB_ENTRIES];
 };
 
 struct kvm_vcpu_arch {
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0d6e7b1..e45c0d6 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2644,8 +2644,87 @@ static void mmu_sync_roots(struct kvm_vcpu *vcpu)
 	trace_kvm_mmu_audit(vcpu, AUDIT_POST_SYNC);
 }
 
+static int vtlb_hash(gva_t page)
+{
+	return page & (VTLB_ENTRIES - 1);
+}
+
+static struct vtlb_entry *get_vtlb_entry(struct kvm_mmu *mmu, gfn_t page_number)
+{
+	return &mmu->vtlb[vtlb_hash(page_number)];
+}
+
+static void vtlb_flush(struct kvm_mmu *mmu)
+{
+	int i;
+
+	if (!mmu->vtlb_enabled)
+		return;
+
+	for (i = 0; i < VTLB_ENTRIES; i++)
+		mmu->vtlb[i].frame_number = INVALID_PAGE;
+
+	trace_vtlb_flush(mmu);
+}
+
+static void vtlb_insert(struct kvm_mmu *mmu, gva_t va, gfn_t frame, u32 access)
+{
+	gfn_t page_number;
+	struct vtlb_entry *entry;
+
+	if (!mmu->vtlb_enabled)
+		return;
+
+	page_number = gpa_to_gfn(va);
+	entry = get_vtlb_entry(mmu, page_number);
+	entry->page_number = page_number;
+	entry->frame_number = frame;
+	entry->access = access;
+
+	trace_vtlb_insert(mmu, page_number, frame, access);
+}
+
+static gfn_t vtlb_lookup(struct kvm_mmu *mmu, gva_t va, u32 access)
+{
+	gfn_t page_number;
+	gfn_t frame_number = INVALID_PAGE;
+	struct vtlb_entry *entry;
+
+	if (!mmu->vtlb_enabled)
+		return INVALID_PAGE;
+
+	page_number = gpa_to_gfn(va);
+	entry = get_vtlb_entry(mmu, page_number);
+
+	if (entry->frame_number != INVALID_PAGE &&
+	      entry->page_number == page_number &&
+	      (entry->access & access) == access)
+		frame_number = entry->frame_number;
+
+	trace_vtlb_lookup(mmu, page_number, frame_number != INVALID_PAGE);
+	return frame_number;
+}
+
+static void vtlb_invalid_gfn(struct kvm_mmu *mmu, gva_t va)
+{
+	gfn_t page_number;
+	struct vtlb_entry *entry;
+
+	if (!mmu->vtlb_enabled)
+		return;
+
+	page_number = gpa_to_gfn(va);
+	entry = get_vtlb_entry(mmu, page_number);
+
+	if (entry->page_number == page_number)
+		entry->frame_number = INVALID_PAGE;
+
+	trace_vtlb_invalid_gfn(mmu, page_number);
+}
+
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 {
+	vtlb_flush(&vcpu->arch.mmu);
 	spin_lock(&vcpu->kvm->mmu_lock);
 	mmu_sync_roots(vcpu);
 	spin_unlock(&vcpu->kvm->mmu_lock);
@@ -2809,6 +2888,7 @@ static int nonpaging_init_context(struct kvm_vcpu *vcpu,
 	context->root_hpa = INVALID_PAGE;
 	context->direct_map = true;
 	context->nx = false;
+	context->vtlb_enabled = false;
 	return 0;
 }
 
@@ -2938,6 +3018,7 @@ static int paging64_init_context_common(struct kvm_vcpu *vcpu,
 	context->shadow_root_level = level;
 	context->root_hpa = INVALID_PAGE;
 	context->direct_map = false;
+	context->vtlb_enabled = true;
 	return 0;
 }
 
@@ -2965,6 +3046,7 @@ static int paging32_init_context(struct kvm_vcpu *vcpu,
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
 	context->root_hpa = INVALID_PAGE;
 	context->direct_map = false;
+	context->vtlb_enabled = true;
 	return 0;
 }
 
@@ -2992,6 +3074,7 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->get_cr3 = get_cr3;
 	context->inject_page_fault = kvm_inject_page_fault;
 	context->nx = is_nx(vcpu);
+	context->vtlb_enabled = false;
 
 	if (!is_paging(vcpu)) {
 		context->nx = false;
@@ -3056,6 +3139,7 @@ static int init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 
 	g_context->get_cr3           = get_cr3;
 	g_context->inject_page_fault = kvm_inject_page_fault;
+	g_context->vtlb_enabled = false;
 
 	/*
 	 * Note that arch.mmu.gva_to_gpa translates l2_gva to l1_gpa. The
@@ -3092,11 +3176,14 @@ static int init_kvm_mmu(struct kvm_vcpu *vcpu)
 	vcpu->arch.update_pte.pfn = bad_pfn;
 
 	if (mmu_is_nested(vcpu))
-		return init_kvm_nested_mmu(vcpu);
+		init_kvm_nested_mmu(vcpu);
 	else if (tdp_enabled)
-		return init_kvm_tdp_mmu(vcpu);
+		init_kvm_tdp_mmu(vcpu);
 	else
-		return init_kvm_softmmu(vcpu);
+		init_kvm_softmmu(vcpu);
+
+	vtlb_flush(&vcpu->arch.mmu);
+	return 0;
 }
 
 static void destroy_kvm_mmu(struct kvm_vcpu *vcpu)
@@ -3463,6 +3550,7 @@ EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
 
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 {
+	vtlb_invalid_gfn(&vcpu->arch.mmu, gva);
 	vcpu->arch.mmu.invlpg(vcpu, gva);
 	kvm_mmu_flush_tlb(vcpu);
 	++vcpu->stat.invlpg;
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index b60b4fd..2bacc3f 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -214,6 +214,85 @@ TRACE_EVENT(
 	TP_printk("vcpu:%d %s", __entry->vcpu->cpu,
 		  audit_point_name[__entry->audit_point])
 );
+
+TRACE_EVENT(
+	vtlb_flush,
+	TP_PROTO(struct kvm_mmu *mmu),
+	TP_ARGS(mmu),
+
+	TP_STRUCT__entry(
+		__field(struct kvm_mmu *, mmu)
+	),
+
+	TP_fast_assign(
+		__entry->mmu = mmu;
+	),
+
+	TP_printk("mmu:%p", __entry->mmu)
+);
+
+TRACE_EVENT(
+	vtlb_insert,
+	TP_PROTO(struct kvm_mmu *mmu, gfn_t page, gfn_t frame, u32 access),
+	TP_ARGS(mmu, page, frame, access),
+
+	TP_STRUCT__entry(
+		__field(struct kvm_mmu *, mmu)
+		__field(gfn_t, page)
+		__field(gfn_t, frame)
+		__field(u32, access)
+	),
+
+	TP_fast_assign(
+		__entry->mmu = mmu;
+		__entry->page = page;
+		__entry->frame = frame;
+		__entry->access = access;
+	),
+
+	TP_printk("mmu:%p page_number:%llx frame_number:%llx access:%x",
+		  __entry->mmu, __entry->page, __entry->frame, __entry->access)
+);
+
+TRACE_EVENT(
+	vtlb_lookup,
+	TP_PROTO(struct kvm_mmu *mmu, gfn_t page, bool hit),
+	TP_ARGS(mmu, page, hit),
+
+	TP_STRUCT__entry(
+		__field(struct kvm_mmu *, mmu)
+		__field(gfn_t, page)
+		__field(bool, hit)
+	),
+
+	TP_fast_assign(
+		__entry->mmu = mmu;
+		__entry->page = page;
+		__entry->hit = hit;
+	),
+
+	TP_printk("mmu:%p page_number:%llx %s", __entry->mmu, __entry->page,
+		  __entry->hit ? "hit" : "miss")
+);
+
+TRACE_EVENT(
+	vtlb_invalid_gfn,
+	TP_PROTO(struct kvm_mmu *mmu, gfn_t page),
+	TP_ARGS(mmu, page),
+
+	TP_STRUCT__entry(
+		__field(struct kvm_mmu *, mmu)
+		__field(gfn_t, page)
+	),
+
+	TP_fast_assign(
+		__entry->mmu = mmu;
+		__entry->page = page;
+	),
+
+	TP_printk("mmu:%p page_number:%llx", __entry->mmu, __entry->page)
+);
+
 #endif /* _TRACE_KVMMMU_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 6bccc24..a7da29e 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -261,6 +261,7 @@ walk:
 
 	walker->pt_access = pt_access;
 	walker->pte_access = pte_access;
+	vtlb_insert(mmu, addr, walker->gfn, pte_access);
 	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
 		 __func__, (u64)pte, pte_access, pt_access);
 	return 1;
@@ -691,12 +692,19 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr, u32 access,
 {
 	struct guest_walker walker;
 	gpa_t gpa = UNMAPPED_GVA;
+	gfn_t gfn;
 	int r;
 
+	gfn = vtlb_lookup(&vcpu->arch.mmu, vaddr, access);
+	if (gfn != INVALID_PAGE)
+		goto success;
+
 	r = FNAME(walk_addr)(&walker, vcpu, vaddr, access);
 
 	if (r) {
-		gpa = gfn_to_gpa(walker.gfn);
+		gfn = walker.gfn;
+success:
+		gpa = gfn_to_gpa(gfn);
 		gpa |= vaddr & ~PAGE_MASK;
 	} else if (exception)
 		*exception = walker.fault;
@@ -710,12 +718,19 @@ static gpa_t FNAME(gva_to_gpa_nested)(struct kvm_vcpu *vcpu, gva_t vaddr,
 {
 	struct guest_walker walker;
 	gpa_t gpa = UNMAPPED_GVA;
+	gfn_t gfn;
 	int r;
 
+	gfn = vtlb_lookup(&vcpu->arch.nested_mmu, vaddr, access);
+	if (gfn != INVALID_PAGE)
+		goto success;
+
 	r = FNAME(walk_addr_nested)(&walker, vcpu, vaddr, access);
 
 	if (r) {
-		gpa = gfn_to_gpa(walker.gfn);
+		gfn = walker.gfn;
+success:
+		gpa = gfn_to_gpa(gfn);
 		gpa |= vaddr & ~PAGE_MASK;
 	} else if (exception)
 		*exception = walker.fault;
-- 
1.7.4


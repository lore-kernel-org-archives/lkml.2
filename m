Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab0FYMLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 08:11:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55205 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755843Ab0FYMLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 08:11:07 -0400
Message-ID: <4C249BF5.90707@cn.fujitsu.com>
Date: Fri, 25 Jun 2010 20:07:17 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH v2 10/10] KVM: MMU: trace pte prefetch
References: <4C2498EC.2010006@cn.fujitsu.com>
In-Reply-To: <4C2498EC.2010006@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace pte prefetch, it can help us to improve the prefetch's performance

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |   42 +++++++++++++++++++++++++++++++++---------
 arch/x86/kvm/mmutrace.h    |   33 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/paging_tmpl.h |   29 ++++++++++++++++++++++-------
 3 files changed, 88 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b2ad723..bcf4626 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -91,6 +91,12 @@ module_param(oos_shadow, bool, 0644);
 
 #define PTE_PREFETCH_NUM	16
 
+#define PREFETCH_SUCCESS		0
+#define PREFETCH_ERR_GFN2PFN		1
+#define PREFETCH_ERR_ALLOC_MEM		2
+#define PREFETCH_ERR_RSVD_BITS_SET	3
+#define PREFETCH_ERR_MMIO		4
+
 #define PT_FIRST_AVAIL_BITS_SHIFT 9
 #define PT64_SECOND_AVAIL_BITS_SHIFT 52
 
@@ -2002,13 +2008,16 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 
 static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 				    struct kvm_mmu_page *sp,
-				    u64 *start, u64 *end)
+				    u64 *start, u64 *end, u64 address)
 {
 	gfn_t gfn;
 	struct page *pages[PTE_PREFETCH_NUM];
 
-	if (pte_prefetch_topup_memory_cache(vcpu, end - start))
+	if (pte_prefetch_topup_memory_cache(vcpu, end - start)) {
+		trace_pte_prefetch(true, address, 0,
+				   PREFETCH_ERR_ALLOC_MEM);
 		return -1;
+	}
 
 	gfn = sp->gfn + start - sp->spt;
 	while (start < end) {
@@ -2016,27 +2025,40 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 		int entry, j, ret;
 
 		addr = gfn_to_hva_many(vcpu->kvm, gfn, &entry);
-		if (kvm_is_error_hva(addr))
+		if (kvm_is_error_hva(addr)) {
+			trace_pte_prefetch(true, address, 0,
+					   PREFETCH_ERR_MMIO);
 			return -1;
+		}
 
 		entry = min(entry, (int)(end - start));
 		ret = __get_user_pages_fast(addr, entry, 1, pages);
-		if (ret <= 0)
+		if (ret <= 0) {
+			trace_pte_prefetch(true, address, 0,
+					   PREFETCH_ERR_GFN2PFN);
 			return -1;
+		}
 
-		for (j = 0; j < ret; j++, gfn++, start++)
+		for (j = 0; j < ret; j++, gfn++, start++) {
+			trace_pte_prefetch(true, address, 0,
+					   PREFETCH_SUCCESS);
 			mmu_set_spte(vcpu, start, ACC_ALL,
 				     sp->role.access, 0, 0, 1, NULL,
 				     sp->role.level, gfn,
 				     page_to_pfn(pages[j]), true, false);
+		}
 
-		if (ret < entry)
+		if (ret < entry) {
+			trace_pte_prefetch(true, address, 0,
+					   PREFETCH_ERR_GFN2PFN);
 			return -1;
+		}
 	}
 	return 0;
 }
 
-static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
+static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep,
+				u64 addr)
 {
 	struct kvm_mmu_page *sp;
 	u64 *start = NULL;
@@ -2058,7 +2080,8 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 		if (*spte != shadow_trap_nonpresent_pte || spte == sptep) {
 			if (!start)
 				continue;
-			if (direct_pte_prefetch_many(vcpu, sp, start, spte) < 0)
+			if (direct_pte_prefetch_many(vcpu, sp, start,
+							spte, addr) < 0)
 				break;
 			start = NULL;
 		} else if (!start)
@@ -2080,7 +2103,8 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 				     0, write, 1, &pt_write,
 				     level, gfn, pfn, false, true);
 			++vcpu->stat.pf_fixed;
-			direct_pte_prefetch(vcpu, iterator.sptep);
+			direct_pte_prefetch(vcpu, iterator.sptep,
+						gfn << PAGE_SHIFT);
 			break;
 		}
 
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 3aab0f0..c07b6a6 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -195,6 +195,39 @@ DEFINE_EVENT(kvm_mmu_page_class, kvm_mmu_prepare_zap_page,
 
 	TP_ARGS(sp)
 );
+
+#define pte_prefetch_err					\
+	{PREFETCH_SUCCESS,		"SUCCESS"	},	\
+	{PREFETCH_ERR_GFN2PFN,		"ERR_GFN2PFN"	},	\
+	{PREFETCH_ERR_ALLOC_MEM,	"ERR_ALLOC_MEM"	},	\
+	{PREFETCH_ERR_RSVD_BITS_SET,	"ERR_RSVD_BITS_SET"},	\
+	{PREFETCH_ERR_MMIO,		"ERR_MMIO"	}
+
+TRACE_EVENT(
+	pte_prefetch,
+	TP_PROTO(bool direct, u64 addr, u64 gpte, int err_code),
+
+	TP_ARGS(direct, addr, gpte, err_code),
+
+	TP_STRUCT__entry(
+		__field(bool, direct)
+		__field(u64, addr)
+		__field(u64, gpte)
+		__field(int, err_code)
+	),
+
+	TP_fast_assign(
+		__entry->direct = direct;
+		__entry->addr = addr;
+		__entry->gpte = gpte;
+		__entry->err_code = err_code;
+	),
+
+	TP_printk("%s address:%llx gpte:%llx %s",
+		  __entry->direct ? "direct" : "indirect",
+		  __entry->addr, __entry->gpte,
+		  __print_symbolic(__entry->err_code, pte_prefetch_err))
+	);
 #endif /* _TRACE_KVMMMU_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 641c2ca..7256a10 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -318,7 +318,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 }
 
 static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu,
-				struct guest_walker *gw, u64 *sptep)
+				struct guest_walker *gw, u64 *sptep, u64 addr)
 {
 	struct kvm_mmu_page *sp;
 	pt_element_t *gptep;
@@ -331,7 +331,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu,
 		return;
 
 	if (sp->role.direct)
-		return direct_pte_prefetch(vcpu, sptep);
+		return direct_pte_prefetch(vcpu, sptep, addr);
 
 	index = sptep - sp->spt;
 	i = index & ~(PTE_PREFETCH_NUM - 1);
@@ -354,27 +354,42 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu,
 
 		gpte = gptep[j];
 
-		if (is_rsvd_bits_set(vcpu, gpte, PT_PAGE_TABLE_LEVEL))
+		if (is_rsvd_bits_set(vcpu, gpte, PT_PAGE_TABLE_LEVEL)) {
+			trace_pte_prefetch(false, addr, gpte,
+						PREFETCH_ERR_RSVD_BITS_SET);
 			break;
+		}
 
 		if (!(gpte & PT_ACCESSED_MASK))
 			continue;
 
 		if (!is_present_gpte(gpte)) {
-			if (!sp->unsync)
+			if (!sp->unsync) {
+				trace_pte_prefetch(false, addr, gpte,
+							PREFETCH_SUCCESS);
 				__set_spte(spte, shadow_notrap_nonpresent_pte);
+			}
 			continue;
 		}
 
 		gfn = gpte_to_gfn(gpte);
 
 		pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);
-		if (is_error_pfn(pfn) ||
-			pte_prefetch_topup_memory_cache(vcpu, 1)) {
+		if (is_error_pfn(pfn)) {
+			trace_pte_prefetch(false, addr, gpte,
+						PREFETCH_ERR_GFN2PFN);
+			kvm_release_pfn_clean(pfn);
+			break;
+		}
+
+		if (pte_prefetch_topup_memory_cache(vcpu, 1)) {
+			trace_pte_prefetch(false, addr, gpte,
+						PREFETCH_ERR_ALLOC_MEM);
 			kvm_release_pfn_clean(pfn);
 			break;
 		}
 
+		trace_pte_prefetch(false, addr, gpte, PREFETCH_SUCCESS);
 		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
 		mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
 			     is_dirty_gpte(gpte), NULL, sp->role.level, gfn,
@@ -413,7 +428,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 				     user_fault, write_fault,
 				     dirty, ptwrite, level,
 				     gw->gfn, pfn, false, true);
-			FNAME(pte_prefetch)(vcpu, gw, sptep);
+			FNAME(pte_prefetch)(vcpu, gw, sptep, addr);
 			break;
 		}
 
-- 
1.6.1.2




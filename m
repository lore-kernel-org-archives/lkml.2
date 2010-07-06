Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab0GFKz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 06:55:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59263 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754731Ab0GFKzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 06:55:55 -0400
Message-ID: <4C330AD3.7090402@cn.fujitsu.com>
Date: Tue, 06 Jul 2010 18:52:03 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH v5 9/9] KVM: MMU: trace pte prefetch
References: <4C330918.6040709@cn.fujitsu.com>
In-Reply-To: <4C330918.6040709@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace pte prefetch, it can help us to improve the prefetch's performance

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |   40 ++++++++++++++++++++++++++++++----------
 arch/x86/kvm/mmutrace.h    |   33 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/paging_tmpl.h |   23 +++++++++++++++++------
 3 files changed, 80 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 66e225d..9e3bc13 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -90,6 +90,11 @@ module_param(oos_shadow, bool, 0644);
 #endif
 
 #define PTE_PREFETCH_NUM		16
+#define PREFETCH_SUCCESS		0
+#define PREFETCH_ERR_GFN2PFN		1
+#define PREFETCH_ERR_ALLOC_MEM		2
+#define PREFETCH_ERR_RSVD_BITS_SET	3
+#define PREFETCH_ERR_MMIO		4
 
 #define PT_FIRST_AVAIL_BITS_SHIFT 9
 #define PT64_SECOND_AVAIL_BITS_SHIFT 52
@@ -2040,7 +2045,7 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 
 static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 				    struct kvm_mmu_page *sp,
-				    u64 *start, u64 *end)
+				    u64 *start, u64 *end, u64 address)
 {
 	gfn_t gfn;
 	struct page *pages[PTE_PREFETCH_NUM];
@@ -2052,31 +2057,44 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 
 		ret = gfn_to_page_many_atomic(vcpu->kvm, gfn, pages,
 						end - start, &enough);
-		if (ret <= 0)
+		if (ret <= 0) {
+			trace_pte_prefetch(true, address, 0, ret == -1 ?
+				PREFETCH_ERR_MMIO : PREFETCH_ERR_GFN2PFN);
 			return -1;
+		}
 
-		for (j = 0; j < ret; j++, gfn++, start++)
+		for (j = 0; j < ret; j++, gfn++, start++) {
+			trace_pte_prefetch(true, address, 0,
+					   PREFETCH_SUCCESS);
 			mmu_set_spte(vcpu, start, ACC_ALL,
 				     sp->role.access, 0, 0, 1, NULL,
 				     sp->role.level, gfn,
 				     page_to_pfn(pages[j]), true, true);
+		}
 
-		if (!enough)
+		if (!enough) {
+			trace_pte_prefetch(true, address, 0,
+					   PREFETCH_ERR_GFN2PFN);
 			return -1;
+		}
 	}
 	return 0;
 }
 
 static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
-				  struct kvm_mmu_page *sp, u64 *sptep)
+				  struct kvm_mmu_page *sp, u64 *sptep,
+				  u64 addr)
 {
 	u64 *start = NULL;
 	int index, i, max;
 
 	WARN_ON(!sp->role.direct);
 
-	if (pte_prefetch_topup_memory_cache(vcpu))
+	if (pte_prefetch_topup_memory_cache(vcpu)) {
+		trace_pte_prefetch(true, addr, 0,
+				   PREFETCH_ERR_ALLOC_MEM);
 		return;
+	}
 
 	index = sptep - sp->spt;
 	i = index & ~(PTE_PREFETCH_NUM - 1);
@@ -2088,7 +2106,8 @@ static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
 		if (*spte != shadow_trap_nonpresent_pte || spte == sptep) {
 			if (!start)
 				continue;
-			if (direct_pte_prefetch_many(vcpu, sp, start, spte) < 0)
+			if (direct_pte_prefetch_many(vcpu, sp, start, spte,
+							addr) < 0)
 				break;
 			start = NULL;
 		} else if (!start)
@@ -2096,7 +2115,7 @@ static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
 	}
 }
 
-static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
+static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep, u64 addr)
 {
 	struct kvm_mmu_page *sp;
 
@@ -2113,7 +2132,7 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 	if (sp->role.level > PT_PAGE_TABLE_LEVEL)
 		return;
 
-	__direct_pte_prefetch(vcpu, sp, sptep);
+	__direct_pte_prefetch(vcpu, sp, sptep, addr);
 }
 
 static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
@@ -2129,7 +2148,8 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL, ACC_ALL,
 				     0, write, 1, &pt_write,
 				     level, gfn, pfn, false, true);
-			direct_pte_prefetch(vcpu, iterator.sptep);
+			direct_pte_prefetch(vcpu, iterator.sptep,
+						gfn << PAGE_SHIFT);
 			++vcpu->stat.pf_fixed;
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
index a1e6d91..e7fe5fe 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -293,7 +293,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 }
 
 static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
-				u64 *sptep)
+				u64 *sptep, u64 addr)
 {
 	struct kvm_mmu_page *sp;
 	pt_element_t *gptep;
@@ -306,7 +306,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 		return;
 
 	if (sp->role.direct)
-		return __direct_pte_prefetch(vcpu, sp, sptep);
+		return __direct_pte_prefetch(vcpu, sp, sptep, addr);
 
 	index = sptep - sp->spt;
 	i = index & ~(PTE_PREFETCH_NUM - 1);
@@ -314,8 +314,10 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 
 	gptep = gw->prefetch_ptes;
 
-	if (pte_prefetch_topup_memory_cache(vcpu))
+	if (pte_prefetch_topup_memory_cache(vcpu)) {
+		trace_pte_prefetch(false, addr, 0, PREFETCH_ERR_ALLOC_MEM);
 		return;
+	}
 
 	for (j = 0; i < max; i++, j++) {
 		pt_element_t gpte;
@@ -332,15 +334,21 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 
 		gpte = gptep[j];
 
-		if (is_rsvd_bits_set(vcpu, gpte, PT_PAGE_TABLE_LEVEL))
+		if (is_rsvd_bits_set(vcpu, gpte, PT_PAGE_TABLE_LEVEL)) {
+			trace_pte_prefetch(false, addr, gpte,
+					   PREFETCH_ERR_RSVD_BITS_SET);
 			break;
+		}
 
 		if (!(gpte & PT_ACCESSED_MASK))
 			continue;
 
 		if (!is_present_gpte(gpte)) {
-			if (!sp->unsync)
+			if (!sp->unsync) {
+				trace_pte_prefetch(false, addr, gpte,
+						   PREFETCH_SUCCESS);
 				__set_spte(spte, shadow_notrap_nonpresent_pte);
+			}
 			continue;
 		}
 
@@ -348,10 +356,13 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 
 		pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);
 		if (is_error_pfn(pfn)) {
+			trace_pte_prefetch(false, addr, gpte,
+					   PREFETCH_ERR_GFN2PFN);
 			kvm_release_pfn_clean(pfn);
 			break;
 		}
 
+		trace_pte_prefetch(false, addr, gpte, PREFETCH_SUCCESS);
 		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
 		mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
 			     is_dirty_gpte(gpte), NULL, sp->role.level, gfn,
@@ -491,7 +502,7 @@ check_set_spte:
 				     user_fault, write_fault,
 				     dirty, ptwrite, level,
 				     gw->gfn, pfn, false, true);
-			FNAME(pte_prefetch)(vcpu, gw, sptep);
+			FNAME(pte_prefetch)(vcpu, gw, sptep, addr);
 			break;
 		}
 	}
-- 
1.6.1.2



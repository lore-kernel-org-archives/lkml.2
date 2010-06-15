Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab0FOCut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 22:50:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64480 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756578Ab0FOCup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 22:50:45 -0400
Message-ID: <4C16E9AF.2090501@cn.fujitsu.com>
Date: Tue, 15 Jun 2010 10:47:11 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 6/6] KVM: MMU: trace pte prefetch
References: <4C16E6ED.7020009@cn.fujitsu.com> <4C16E75F.6020003@cn.fujitsu.com> <4C16E7AD.1060101@cn.fujitsu.com> <4C16E7F4.5060801@cn.fujitsu.com> <4C16E82E.5010306@cn.fujitsu.com> <4C16E867.8040606@cn.fujitsu.com>
In-Reply-To: <4C16E867.8040606@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace pte prefetch to see what trouble we meet, if can help us to
improve the prefetch

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |   12 +++++++++++-
 arch/x86/kvm/mmutrace.h    |   26 ++++++++++++++++++++++++++
 arch/x86/kvm/paging_tmpl.h |    9 ++++++++-
 3 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 941c86b..0aaa18d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -91,6 +91,11 @@ module_param(oos_shadow, bool, 0644);
 
 #define PTE_PREFETCH_NUM	16
 
+#define PREFETCH_SUCCESS	0
+#define PREFETCH_ERR_GFN2PFN	1
+#define PREFETCH_ERR_ALLOC_MEM	2
+#define PREFETCH_ERR_READ_GPTE	3
+
 #define PT_FIRST_AVAIL_BITS_SHIFT 9
 #define PT64_SECOND_AVAIL_BITS_SHIFT 52
 
@@ -2066,11 +2071,16 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 		pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);
 		if (is_error_pfn(pfn)) {
 			kvm_release_pfn_clean(pfn);
+			trace_pte_prefetch(true, PREFETCH_ERR_GFN2PFN);
 			break;
 		}
-		if (pte_prefetch_topup_memory_cache(vcpu))
+
+		if (pte_prefetch_topup_memory_cache(vcpu)) {
+			trace_pte_prefetch(true, PREFETCH_ERR_ALLOC_MEM);
 			break;
+		}
 
+		trace_pte_prefetch(true, PREFETCH_SUCCESS);
 		mmu_set_spte(vcpu, spte, ACC_ALL, ACC_ALL, 0, 0, 1, NULL,
 			     sp->role.level, gfn, pfn, true, false);
 	}
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 3aab0f0..1c3e84e 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -195,6 +195,32 @@ DEFINE_EVENT(kvm_mmu_page_class, kvm_mmu_prepare_zap_page,
 
 	TP_ARGS(sp)
 );
+
+#define pte_prefetch_err					\
+	{PREFETCH_SUCCESS,		"SUCCESS"	},	\
+	{PREFETCH_ERR_GFN2PFN,		"ERR_GFN2PFN"	},	\
+	{PREFETCH_ERR_ALLOC_MEM,	"ERR_ALLOC_MEM"	},	\
+	{PREFETCH_ERR_READ_GPTE,	"ERR_READ_GPTE"	}
+
+TRACE_EVENT(
+	pte_prefetch,
+	TP_PROTO(bool direct, int err_code),
+	TP_ARGS(direct, err_code),
+
+	TP_STRUCT__entry(
+		__field(bool, direct)
+		__field(int, err_code)
+	),
+
+	TP_fast_assign(
+		__entry->direct = direct;
+		__entry->err_code = err_code;
+	),
+
+	TP_printk("%s %s", __entry->direct ? "direct" : "no-direct",
+		  __print_symbolic(__entry->err_code, pte_prefetch_err))
+);
+
 #endif /* _TRACE_KVMMMU_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index af4e041..64f2acb 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -331,6 +331,8 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, u64 *sptep)
 			page = gfn_to_page_atomic(vcpu->kvm, sp->gfn);
 			if (is_error_page(page)) {
 				kvm_release_page_clean(page);
+				trace_pte_prefetch(false,
+						PREFETCH_ERR_READ_GPTE);
 				break;
 			}
 			table = kmap_atomic(page, KM_USER0);
@@ -353,11 +355,16 @@ gfn_mapping:
 		pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);
 		if (is_error_pfn(pfn)) {
 			kvm_release_pfn_clean(pfn);
+			trace_pte_prefetch(false, PREFETCH_ERR_GFN2PFN);
 			break;
 		}
 
-		if (pte_prefetch_topup_memory_cache(vcpu))
+		if (pte_prefetch_topup_memory_cache(vcpu)) {
+			trace_pte_prefetch(false, PREFETCH_ERR_ALLOC_MEM);
 			break;
+		}
+
+		trace_pte_prefetch(false, PREFETCH_SUCCESS);
 		mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
 			     dirty, NULL, sp->role.level, gfn, pfn,
 			     true, false);
-- 
1.6.1.2




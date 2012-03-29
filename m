Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935Ab2C2J1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:27:45 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:47965 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758469Ab2C2J1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:27:38 -0400
Message-ID: <4F742B03.3040800@linux.vnet.ibm.com>
Date: Thu, 29 Mar 2012 17:27:31 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 12/13] KVM: MMU: trace fast page fault
References: <4F742951.7080003@linux.vnet.ibm.com>
In-Reply-To: <4F742951.7080003@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12032909-9574-0000-0000-00000204AE0E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To see what happen on this path and help us to optimize it

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c      |    2 ++
 arch/x86/kvm/mmutrace.h |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4a01be4..94cd31d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3011,6 +3011,8 @@ fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn, int level,
 				       expected_access, fn);

 exit:
+	trace_fast_page_fault(vcpu, gva, gfn, error_code, iterator.sptep,
+			      spte, ret);
 	walk_shadow_page_lockless_end(vcpu);

 	return ret;
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 89fb0e8..a81c8a7 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -243,6 +243,49 @@ TRACE_EVENT(
 	TP_printk("addr:%llx gfn %llx access %x", __entry->addr, __entry->gfn,
 		  __entry->access)
 );
+
+static u32 page_fault_expected_access(u32 error_code);
+static bool spte_satisfied(u64 spte, u32 access);
+#define __spte_satisfied(__spte)				\
+	(__entry->success && spte_satisfied(__entry->__spte,	\
+	      page_fault_expected_access(__entry->error_code)))
+TRACE_EVENT(
+	fast_page_fault,
+	TP_PROTO(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn, u32 error_code,
+		 u64 *sptep, u64 old_spte, bool retry),
+	TP_ARGS(vcpu, gva, gfn, error_code, sptep, old_spte, retry),
+
+	TP_STRUCT__entry(
+		__field(int, vcpu_id)
+		__field(gva_t, gva)
+		__field(gfn_t, gfn)
+		__field(u32, error_code)
+		__field(u64 *, sptep)
+		__field(u64, old_spte)
+		__field(u64, new_spte)
+		__field(bool, success)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id = vcpu->vcpu_id;
+		__entry->gva = gva;
+		__entry->gfn = gfn;
+		__entry->error_code = error_code;
+		__entry->sptep = sptep;
+		__entry->old_spte = old_spte;
+		__entry->new_spte = *sptep;
+		__entry->success = retry;
+	),
+
+	TP_printk("vcpu %d gva %lx gfn %llx error_code %s sptep %p "
+		  "old %#llx new %llx spurious %d fixed %d", __entry->vcpu_id,
+		  __entry->gva, __entry->gfn,
+		  __print_flags(__entry->error_code, "|",
+				kvm_mmu_trace_pferr_flags),
+		  __entry->sptep, __entry->old_spte, __entry->new_spte,
+		  __spte_satisfied(old_spte), __spte_satisfied(new_spte)
+	)
+);
 #endif /* _TRACE_KVMMMU_H */

 #undef TRACE_INCLUDE_PATH
-- 
1.7.7.6


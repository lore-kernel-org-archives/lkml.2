Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab2E2GvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 02:51:15 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:45057 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab2E2GvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 02:51:13 -0400
Message-ID: <4FC471D5.6090101@linux.vnet.ibm.com>
Date: Tue, 29 May 2012 14:51:01 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v6 7/9] KVM: MMU: trace fast page fault
References: <4FC470C7.5040700@linux.vnet.ibm.com>
In-Reply-To: <4FC470C7.5040700@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12052820-7014-0000-0000-000001424367
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To see what happen on this path and help us to optimize it

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c      |    2 ++
 arch/x86/kvm/mmutrace.h |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d6101a8..1a2a0df 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2750,6 +2750,8 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 	 */
 	ret = fast_pf_fix_direct_spte(vcpu, iterator.sptep, spte);
 exit:
+	trace_fast_page_fault(vcpu, gva, error_code, iterator.sptep,
+			      spte, ret);
 	walk_shadow_page_lockless_end(vcpu);

 	return ret;
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 89fb0e8..c364abc 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -243,6 +243,44 @@ TRACE_EVENT(
 	TP_printk("addr:%llx gfn %llx access %x", __entry->addr, __entry->gfn,
 		  __entry->access)
 );
+
+#define __spte_satisfied(__spte)				\
+	(__entry->retry && is_writable_pte(__entry->__spte))
+
+TRACE_EVENT(
+	fast_page_fault,
+	TP_PROTO(struct kvm_vcpu *vcpu, gva_t gva, u32 error_code,
+		 u64 *sptep, u64 old_spte, bool retry),
+	TP_ARGS(vcpu, gva, error_code, sptep, old_spte, retry),
+
+	TP_STRUCT__entry(
+		__field(int, vcpu_id)
+		__field(gva_t, gva)
+		__field(u32, error_code)
+		__field(u64 *, sptep)
+		__field(u64, old_spte)
+		__field(u64, new_spte)
+		__field(bool, retry)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id = vcpu->vcpu_id;
+		__entry->gva = gva;
+		__entry->error_code = error_code;
+		__entry->sptep = sptep;
+		__entry->old_spte = old_spte;
+		__entry->new_spte = *sptep;
+		__entry->retry = retry;
+	),
+
+	TP_printk("vcpu %d gva %lx error_code %s sptep %p old %#llx"
+		  " new %llx spurious %d fixed %d", __entry->vcpu_id,
+		  __entry->gva, __print_flags(__entry->error_code, "|",
+		  kvm_mmu_trace_pferr_flags), __entry->sptep,
+		  __entry->old_spte, __entry->new_spte,
+		  __spte_satisfied(old_spte), __spte_satisfied(new_spte)
+	)
+);
 #endif /* _TRACE_KVMMMU_H */

 #undef TRACE_INCLUDE_PATH
-- 
1.7.7.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935180Ab2DMKRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:17:11 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:33613 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934572Ab2DMKRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:17:09 -0400
Message-ID: <4F87FD1C.3040803@linux.vnet.ibm.com>
Date: Fri, 13 Apr 2012 18:17:00 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 15/16] KVM: MMU: trace fast page fault
References: <4F87FA69.5060106@linux.vnet.ibm.com>
In-Reply-To: <4F87FA69.5060106@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041310-3864-0000-0000-000002407FBC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To see what happen on this path and help us to optimize it

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c      |    2 ++
 arch/x86/kvm/mmutrace.h |   41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index fc91667..589b507 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2929,6 +2929,8 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
 						spte, gfn);

 exit:
+	trace_fast_page_fault(vcpu, gva, gfn, error_code, iterator.sptep,
+			      spte, ret);
 	walk_shadow_page_lockless_end(vcpu);

 	return ret;
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 89fb0e8..84da94f 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -243,6 +243,47 @@ TRACE_EVENT(
 	TP_printk("addr:%llx gfn %llx access %x", __entry->addr, __entry->gfn,
 		  __entry->access)
 );
+
+#define __spte_satisfied(__spte)				\
+	(__entry->retry && is_writable_pte(__entry->__spte))
+
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
+		__field(bool, retry)
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
+		__entry->retry = retry;
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


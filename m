Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab1FGNFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:05:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55137 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753200Ab1FGNFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:05:37 -0400
Message-ID: <4DEE229E.9060305@cn.fujitsu.com>
Date: Tue, 07 Jun 2011 21:07:42 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 15/15] KVM: MMU: trace mmio page fault
References: <4DEE205E.8000601@cn.fujitsu.com>
In-Reply-To: <4DEE205E.8000601@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-07 21:05:25,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-07 21:05:25,
	Serialize complete at 2011-06-07 21:05:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tracepoints to trace mmio page fault

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |    4 +++
 arch/x86/kvm/mmutrace.h    |   48 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c         |    5 +++-
 include/trace/events/kvm.h |   24 ++++++++++++++++++++++
 4 files changed, 80 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 227cf10..aff8f52 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -207,6 +207,7 @@ static void mark_mmio_spte(u64 *sptep, u64 gfn, unsigned access)
 {
 	access &= ACC_WRITE_MASK | ACC_USER_MASK;
 
+	trace_mark_mmio_spte(sptep, gfn, access);
 	__set_spte(sptep, shadow_mmio_mask | access | gfn << PAGE_SHIFT);
 }
 
@@ -1752,6 +1753,7 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 		free_mmu_pages_unlock_parts(invalid_list);
 		sp = list_first_entry(invalid_list, struct kvm_mmu_page, link);
 		list_del_init(invalid_list);
+		trace_kvm_mmu_delay_free_pages(sp);
 		call_rcu(&sp->rcu, free_invalid_pages_rcu);
 		return;
 	}
@@ -2765,6 +2767,8 @@ int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr,
 
 		if (direct)
 			addr = 0;
+
+		trace_handle_mmio_page_fault(addr, gfn, access);
 		vcpu_cache_mmio_info(vcpu, addr, gfn, access);
 		return 1;
 	}
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index b60b4fd..eed67f3 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -196,6 +196,54 @@ DEFINE_EVENT(kvm_mmu_page_class, kvm_mmu_prepare_zap_page,
 	TP_ARGS(sp)
 );
 
+DEFINE_EVENT(kvm_mmu_page_class, kvm_mmu_delay_free_pages,
+	TP_PROTO(struct kvm_mmu_page *sp),
+
+	TP_ARGS(sp)
+);
+
+TRACE_EVENT(
+	mark_mmio_spte,
+	TP_PROTO(u64 *sptep, gfn_t gfn, unsigned access),
+	TP_ARGS(sptep, gfn, access),
+
+	TP_STRUCT__entry(
+		__field(void *, sptep)
+		__field(gfn_t, gfn)
+		__field(unsigned, access)
+	),
+
+	TP_fast_assign(
+		__entry->sptep = sptep;
+		__entry->gfn = gfn;
+		__entry->access = access;
+	),
+
+	TP_printk("sptep:%p gfn %llx access %x", __entry->sptep, __entry->gfn,
+		  __entry->access)
+);
+
+TRACE_EVENT(
+	handle_mmio_page_fault,
+	TP_PROTO(u64 addr, gfn_t gfn, unsigned access),
+	TP_ARGS(addr, gfn, access),
+
+	TP_STRUCT__entry(
+		__field(u64, addr)
+		__field(gfn_t, gfn)
+		__field(unsigned, access)
+	),
+
+	TP_fast_assign(
+		__entry->addr = addr;
+		__entry->gfn = gfn;
+		__entry->access = access;
+	),
+
+	TP_printk("addr:%llx gfn %llx access %x", __entry->addr, __entry->gfn,
+		  __entry->access)
+);
+
 TRACE_EVENT(
 	kvm_mmu_audit,
 	TP_PROTO(struct kvm_vcpu *vcpu, int audit_point),
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a136181..c75f845 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3914,6 +3914,7 @@ static int vcpu_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 	      vcpu->arch.access)) {
 		*gpa = vcpu->arch.mmio_gfn << PAGE_SHIFT |
 					(gva & (PAGE_SIZE - 1));
+		trace_vcpu_match_mmio(gva, *gpa, write, false);
 		return 1;
 	}
 
@@ -3929,8 +3930,10 @@ static int vcpu_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 	if ((*gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
 		return 1;
 
-	if (vcpu_match_mmio_gpa(vcpu, *gpa))
+	if (vcpu_match_mmio_gpa(vcpu, *gpa)) {
+		trace_vcpu_match_mmio(gva, *gpa, write, true);
 		return 1;
+	}
 
 	return 0;
 }
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 46e3cd8..571e972 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -306,6 +306,30 @@ TRACE_EVENT(
 
 #endif
 
+TRACE_EVENT(
+	vcpu_match_mmio,
+	TP_PROTO(gva_t gva, gpa_t gpa, bool write, bool gpa_match),
+	TP_ARGS(gva, gpa, write, gpa_match),
+
+	TP_STRUCT__entry(
+		__field(gva_t, gva)
+		__field(gpa_t, gpa)
+		__field(bool, write)
+		__field(bool, gpa_match)
+		),
+
+	TP_fast_assign(
+		__entry->gva = gva;
+		__entry->gpa = gpa;
+		__entry->write = write;
+		__entry->gpa_match = gpa_match
+		),
+
+	TP_printk("gva %#lx gpa %#llx %s %s", __entry->gva, __entry->gpa,
+		  __entry->write ? "Write" : "Read",
+		  __entry->gpa_match ? "GPA" : "GVA")
+);
+
 #endif /* _TRACE_KVM_MAIN_H */
 
 /* This part must be outside protection */
-- 
1.7.4.4


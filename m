Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab2HUJwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:52:01 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:35476 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374Ab2HUJv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:51:58 -0400
Message-ID: <50335A27.2070306@linux.vnet.ibm.com>
Date: Tue, 21 Aug 2012 17:51:35 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH] KVM: trace the events of mmu_notifier
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12082109-5816-0000-0000-00000415C279
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmu_notifier is the interface to broadcast the mm events to KVM, the
tracepoints introduced in this patch can trace all these events, it is
very helpful for us to notice and fix the bug caused by mm

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 include/trace/events/kvm.h |  121 ++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c        |   19 +++++++
 2 files changed, 140 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 7ef9e75..a855ff9 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -309,6 +309,127 @@ TRACE_EVENT(

 #endif

+#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
+DECLARE_EVENT_CLASS(mmu_notifier_address_class,
+
+	TP_PROTO(struct kvm *kvm, unsigned long address),
+
+	TP_ARGS(kvm, address),
+
+	TP_STRUCT__entry(
+		__field(struct kvm *, kvm)
+		__field(unsigned long, address)
+	),
+
+	TP_fast_assign(
+		__entry->kvm = kvm;
+		__entry->address = address;
+	),
+
+	TP_printk("kvm %p address %lx", __entry->kvm, __entry->address)
+
+);
+
+DEFINE_EVENT(mmu_notifier_address_class, kvm_mmu_notifier_invalidate_page,
+
+	TP_PROTO(struct kvm *kvm, unsigned long address),
+
+	TP_ARGS(kvm, address)
+);
+
+DEFINE_EVENT(mmu_notifier_address_class, kvm_mmu_notifier_clear_flush_young,
+
+	TP_PROTO(struct kvm *kvm, unsigned long address),
+
+	TP_ARGS(kvm, address)
+);
+
+DEFINE_EVENT(mmu_notifier_address_class, kvm_mmu_notifier_test_young,
+
+	TP_PROTO(struct kvm *kvm, unsigned long address),
+
+	TP_ARGS(kvm, address)
+);
+
+DECLARE_EVENT_CLASS(mmu_notifier_range_class,
+
+	TP_PROTO(struct kvm *kvm, unsigned long start, unsigned long end),
+
+	TP_ARGS(kvm, start, end),
+
+	TP_STRUCT__entry(
+		__field(struct kvm *, kvm)
+		__field(unsigned long, start)
+		__field(unsigned long, end)
+	),
+
+	TP_fast_assign(
+		__entry->kvm = kvm;
+		__entry->start = start;
+		__entry->end = end;
+	),
+
+	TP_printk("kvm %p start %lx end %lx", __entry->kvm, __entry->start,
+		  __entry->end)
+
+);
+
+DEFINE_EVENT(mmu_notifier_range_class, kvm_mmu_notifier_invalidate_range_start,
+
+	TP_PROTO(struct kvm *kvm, unsigned long start, unsigned long end),
+
+	TP_ARGS(kvm, start, end)
+);
+
+DEFINE_EVENT(mmu_notifier_range_class, kvm_mmu_notifier_invalidate_range_end,
+
+	TP_PROTO(struct kvm *kvm, unsigned long start, unsigned long end),
+
+	TP_ARGS(kvm, start, end)
+);
+
+TRACE_EVENT(kvm_mmu_notifier_change_pte,
+
+	TP_PROTO(struct kvm *kvm, unsigned long address, pte_t pte),
+
+	TP_ARGS(kvm, address, pte),
+
+	TP_STRUCT__entry(
+		__field(struct kvm *, kvm)
+		__field(unsigned long, address)
+		__field(unsigned long, pte)
+	),
+
+	TP_fast_assign(
+		__entry->kvm = kvm;
+		__entry->address = address;
+		__entry->pte = pte.pte;
+	),
+
+	TP_printk("kvm %p address %lx pte %lx", __entry->kvm, __entry->address,
+		  __entry->pte)
+
+);
+
+TRACE_EVENT(kvm_mmu_notifier_release,
+
+	TP_PROTO(struct kvm *kvm),
+
+	TP_ARGS(kvm),
+
+	TP_STRUCT__entry(
+		__field(struct kvm *, kvm)
+	),
+
+	TP_fast_assign(
+		__entry->kvm = kvm;
+	),
+
+	TP_printk("kvm %p", __entry->kvm)
+
+);
+#endif
+
 #endif /* _TRACE_KVM_MAIN_H */

 /* This part must be outside protection */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ec970f4..3491865 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -287,6 +287,8 @@ static void kvm_mmu_notifier_invalidate_page(struct mmu_notifier *mn,
 	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);

+	trace_kvm_mmu_notifier_invalidate_page(kvm, address);
+
 	kvm->mmu_notifier_seq++;
 	need_tlb_flush = kvm_unmap_hva(kvm, address) | kvm->tlbs_dirty;
 	/* we've to flush the tlb before the pages can be freed */
@@ -307,6 +309,9 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,

 	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
+
+	trace_kvm_mmu_notifier_change_pte(kvm, address, pte);
+
 	kvm->mmu_notifier_seq++;
 	kvm_set_spte_hva(kvm, address, pte);
 	spin_unlock(&kvm->mmu_lock);
@@ -323,6 +328,9 @@ static void kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,

 	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
+
+	trace_kvm_mmu_notifier_invalidate_range_start(kvm, start, end);
+
 	/*
 	 * The count increase must become visible at unlock time as no
 	 * spte can be established without taking the mmu_lock and
@@ -347,6 +355,9 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);

 	spin_lock(&kvm->mmu_lock);
+
+	trace_kvm_mmu_notifier_invalidate_range_end(kvm, start, end);
+
 	/*
 	 * This sequence increase will notify the kvm page fault that
 	 * the page that is going to be mapped in the spte could have
@@ -375,6 +386,8 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);

+	trace_kvm_mmu_notifier_clear_flush_young(kvm, address);
+
 	young = kvm_age_hva(kvm, address);
 	if (young)
 		kvm_flush_remote_tlbs(kvm);
@@ -394,6 +407,9 @@ static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,

 	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
+
+	trace_kvm_mmu_notifier_test_young(kvm, address);
+
 	young = kvm_test_age_hva(kvm, address);
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -408,6 +424,9 @@ static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
 	int idx;

 	idx = srcu_read_lock(&kvm->srcu);
+
+	trace_kvm_mmu_notifier_release(kvm);
+
 	kvm_arch_flush_shadow(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
-- 
1.7.7.6


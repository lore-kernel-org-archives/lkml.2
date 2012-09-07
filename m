Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab2IGGQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:16:17 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:57610 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab2IGGQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:16:12 -0400
Message-ID: <50499123.70609@linux.vnet.ibm.com>
Date: Fri, 07 Sep 2012 14:16:03 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2] KVM: trace the events of mmu_notifier
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12090706-5140-0000-0000-0000020A5A43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmu_notifier is the interface to broadcast the mm events to KVM, the
tracepoints introduced in this patch can trace all these events, it is
very helpful for us to notice and fix the bug caused by mm

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 include/trace/events/kvm.h |  129 ++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c        |   19 +++++++
 2 files changed, 148 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 7ef9e75..5d082b7 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -309,6 +309,135 @@ TRACE_EVENT(

 #endif

+#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
+TRACE_EVENT(kvm_mmu_notifier_invalidate_page,
+
+	TP_PROTO(unsigned long hva),
+
+	TP_ARGS(hva),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, hva)
+	),
+
+	TP_fast_assign(
+		__entry->hva = hva;
+	),
+
+	TP_printk("hva %lx", __entry->hva)
+);
+
+DECLARE_EVENT_CLASS(mmu_notifier_young_class,
+
+	TP_PROTO(unsigned long hva, int young),
+
+	TP_ARGS(hva, young),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, hva)
+		__field(int, young)
+	),
+
+	TP_fast_assign(
+		__entry->hva = hva;
+		__entry->young = young;
+	),
+
+	TP_printk("hva %lx young %x", __entry->hva, __entry->young)
+);
+
+DEFINE_EVENT(mmu_notifier_young_class, kvm_mmu_notifier_clear_flush_young,
+
+	TP_PROTO(unsigned long hva, int young),
+
+	TP_ARGS(hva, young)
+);
+
+DEFINE_EVENT(mmu_notifier_young_class, kvm_mmu_notifier_test_young,
+
+	TP_PROTO(unsigned long hva, int young),
+
+	TP_ARGS(hva, young)
+);
+
+DECLARE_EVENT_CLASS(mmu_notifier_range_class,
+
+	TP_PROTO(unsigned long start, unsigned long end),
+
+	TP_ARGS(start, end),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, start)
+		__field(unsigned long, end)
+	),
+
+	TP_fast_assign(
+		__entry->start = start;
+		__entry->end = end;
+	),
+
+	TP_printk("start %lx end %lx", __entry->start, __entry->end)
+);
+
+DEFINE_EVENT(mmu_notifier_range_class, kvm_mmu_notifier_invalidate_range_start,
+
+	TP_PROTO(unsigned long start, unsigned long end),
+
+	TP_ARGS(start, end)
+);
+
+DEFINE_EVENT(mmu_notifier_range_class, kvm_mmu_notifier_invalidate_range_end,
+
+	TP_PROTO(unsigned long start, unsigned long end),
+
+	TP_ARGS(start, end)
+);
+
+#define pte_bit(func, bit)	\
+	(pte_##func(__pte(__entry->pteval)) ? bit : '-')
+
+TRACE_EVENT(kvm_mmu_notifier_change_pte,
+
+	TP_PROTO(unsigned long hva, pte_t pte),
+
+	TP_ARGS(hva, pte),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, hva)
+		__field(unsigned long long, pteval)
+		__field(pfn_t, pfn)
+		__field(bool, writable)
+	),
+
+	TP_fast_assign(
+		__entry->hva = hva;
+		__entry->pteval = (long long)pte_val(pte);
+	),
+
+	TP_printk("hva %lx pte %llx pfn %lx bits %c%c%c%c", __entry->hva,
+		  __entry->pteval, pte_pfn(__pte(__entry->pteval)),
+		  pte_bit(present, 'p'), pte_bit(write, 'w'),
+		  pte_bit(dirty, 'd'), pte_bit(young, 'a'))
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
+);
+#endif
+
 #endif /* _TRACE_KVM_MAIN_H */

 /* This part must be outside protection */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0cbc809..9604f4c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -287,6 +287,8 @@ static void kvm_mmu_notifier_invalidate_page(struct mmu_notifier *mn,
 	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);

+	trace_kvm_mmu_notifier_invalidate_page(address);
+
 	kvm->mmu_notifier_seq++;
 	need_tlb_flush = kvm_unmap_hva(kvm, address) | kvm->tlbs_dirty;
 	/* we've to flush the tlb before the pages can be freed */
@@ -307,6 +309,9 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,

 	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
+
+	trace_kvm_mmu_notifier_change_pte(address, pte);
+
 	kvm->mmu_notifier_seq++;
 	kvm_set_spte_hva(kvm, address, pte);
 	spin_unlock(&kvm->mmu_lock);
@@ -323,6 +328,9 @@ static void kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,

 	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
+
+	trace_kvm_mmu_notifier_invalidate_range_start(start, end);
+
 	/*
 	 * The count increase must become visible at unlock time as no
 	 * spte can be established without taking the mmu_lock and
@@ -347,6 +355,9 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);

 	spin_lock(&kvm->mmu_lock);
+
+	trace_kvm_mmu_notifier_invalidate_range_end(start, end);
+
 	/*
 	 * This sequence increase will notify the kvm page fault that
 	 * the page that is going to be mapped in the spte could have
@@ -379,6 +390,8 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 	if (young)
 		kvm_flush_remote_tlbs(kvm);

+	trace_kvm_mmu_notifier_clear_flush_young(address, young);
+
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);

@@ -395,6 +408,9 @@ static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
 	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
 	young = kvm_test_age_hva(kvm, address);
+
+	trace_kvm_mmu_notifier_test_young(address, young);
+
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


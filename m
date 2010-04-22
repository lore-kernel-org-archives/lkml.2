Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab0DVGPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 02:15:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50254 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab0DVGPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 02:15:32 -0400
Message-ID: <4BCFE8CC.1040901@cn.fujitsu.com>
Date: Thu, 22 Apr 2010 14:12:28 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/10] KVM MMU: convert mmu tracepoints
References: <4BCFE3D5.5070105@cn.fujitsu.com>
In-Reply-To: <4BCFE3D5.5070105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert mmu tracepoints by using DECLARE_EVENT_CLASS

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmutrace.h |   69 +++++++++++++++++-----------------------------
 1 files changed, 26 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index bc4f7f0..d860a03 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -92,15 +92,15 @@ TRACE_EVENT(
 	TP_printk("pte %llx level %u", __entry->pte, __entry->level)
 );
 
-/* We set a pte accessed bit */
-TRACE_EVENT(
-	kvm_mmu_set_accessed_bit,
+DECLARE_EVENT_CLASS(kvm_mmu_set_bit_class,
+
 	TP_PROTO(unsigned long table_gfn, unsigned index, unsigned size),
+
 	TP_ARGS(table_gfn, index, size),
 
 	TP_STRUCT__entry(
 		__field(__u64, gpa)
-		),
+	),
 
 	TP_fast_assign(
 		__entry->gpa = ((u64)table_gfn << PAGE_SHIFT)
@@ -110,22 +110,20 @@ TRACE_EVENT(
 	TP_printk("gpa %llx", __entry->gpa)
 );
 
-/* We set a pte dirty bit */
-TRACE_EVENT(
-	kvm_mmu_set_dirty_bit,
+/* We set a pte accessed bit */
+DEFINE_EVENT(kvm_mmu_set_bit_class, kvm_mmu_set_accessed_bit,
+
 	TP_PROTO(unsigned long table_gfn, unsigned index, unsigned size),
-	TP_ARGS(table_gfn, index, size),
 
-	TP_STRUCT__entry(
-		__field(__u64, gpa)
-		),
+	TP_ARGS(table_gfn, index, size)
+);
 
-	TP_fast_assign(
-		__entry->gpa = ((u64)table_gfn << PAGE_SHIFT)
-				+ index * size;
-		),
+/* We set a pte dirty bit */
+DEFINE_EVENT(kvm_mmu_set_bit_class, kvm_mmu_set_dirty_bit,
 
-	TP_printk("gpa %llx", __entry->gpa)
+	TP_PROTO(unsigned long table_gfn, unsigned index, unsigned size),
+
+	TP_ARGS(table_gfn, index, size)
 );
 
 TRACE_EVENT(
@@ -164,54 +162,39 @@ TRACE_EVENT(
 		  __entry->created ? "new" : "existing")
 );
 
-TRACE_EVENT(
-	kvm_mmu_sync_page,
+DECLARE_EVENT_CLASS(kvm_mmu_page_class,
+
 	TP_PROTO(struct kvm_mmu_page *sp),
 	TP_ARGS(sp),
 
 	TP_STRUCT__entry(
 		KVM_MMU_PAGE_FIELDS
-		),
+	),
 
 	TP_fast_assign(
 		KVM_MMU_PAGE_ASSIGN(sp)
-		),
+	),
 
 	TP_printk("%s", KVM_MMU_PAGE_PRINTK())
 );
 
-TRACE_EVENT(
-	kvm_mmu_unsync_page,
+DEFINE_EVENT(kvm_mmu_page_class, kvm_mmu_sync_page,
 	TP_PROTO(struct kvm_mmu_page *sp),
-	TP_ARGS(sp),
-
-	TP_STRUCT__entry(
-		KVM_MMU_PAGE_FIELDS
-		),
-
-	TP_fast_assign(
-		KVM_MMU_PAGE_ASSIGN(sp)
-		),
 
-	TP_printk("%s", KVM_MMU_PAGE_PRINTK())
+	TP_ARGS(sp)
 );
 
-TRACE_EVENT(
-	kvm_mmu_zap_page,
+DEFINE_EVENT(kvm_mmu_page_class, kvm_mmu_unsync_page,
 	TP_PROTO(struct kvm_mmu_page *sp),
-	TP_ARGS(sp),
 
-	TP_STRUCT__entry(
-		KVM_MMU_PAGE_FIELDS
-		),
+	TP_ARGS(sp)
+);
 
-	TP_fast_assign(
-		KVM_MMU_PAGE_ASSIGN(sp)
-		),
+DEFINE_EVENT(kvm_mmu_page_class, kvm_mmu_zap_page,
+	TP_PROTO(struct kvm_mmu_page *sp),
 
-	TP_printk("%s", KVM_MMU_PAGE_PRINTK())
+	TP_ARGS(sp)
 );
-
 #endif /* _TRACE_KVMMMU_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.6.1.2



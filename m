Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab1K2D4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 22:56:23 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:53025 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab1K2D4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 22:56:22 -0500
Message-ID: <4ED457D0.3010400@linux.vnet.ibm.com>
Date: Tue, 29 Nov 2011 11:56:00 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/5] KVM: MMU: audit: replace mmu audit tracepoint with
 jump-lable
References: <4ED3811F.1070101@linux.vnet.ibm.com> <4ED3815C.9060901@linux.vnet.ibm.com> <20111128223305.GB2519@redhat.com>
In-Reply-To: <20111128223305.GB2519@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11112903-3864-0000-0000-0000004A380C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2011 06:33 AM, Jason Baron wrote:

 
> hmmm..this always going to do a call to 'kvm_mmu_audit' and then return.
> I think you want to avoid the function call altogether. You could do
> something like:
> 
> #define kvm_mmu_audit()
> 	if (static_branch((&mmu_audit_key))) {
> 		__kvm_mmu_audit();
> 	}
> 
> and s/kvm_mmu_audit/__kvm_mmu_audit
> 
> That should give you a single nop for the case where kvm_mmu_audit is
> disabled instead of a function call.


Good point, thanks Jason!

Avi, could you please apply the following patch instead?

Subject: [PATCH v2 2/5] KVM: MMU: audit: replace mmu audit tracepoint with jump-lable

The tracepoint is only used to audit mmu code, it should not be exposed to
user, let us replace it with jump-lable

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c         |   23 ++++++++++++-----------
 arch/x86/kvm/mmu_audit.c   |   17 +++++++++--------
 arch/x86/kvm/mmutrace.h    |   19 -------------------
 arch/x86/kvm/paging_tmpl.h |    4 ++--
 4 files changed, 23 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d737443..34bc3fc 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2840,6 +2840,13 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
 		return mmu_alloc_shadow_roots(vcpu);
 }

+#ifdef CONFIG_KVM_MMU_AUDIT
+#include "mmu_audit.c"
+#else
+static void kvm_mmu_audit(struct kvm_vcpu *vcpu, int point) { }
+static void mmu_audit_disable(void) { }
+#endif
+
 static void mmu_sync_roots(struct kvm_vcpu *vcpu)
 {
 	int i;
@@ -2852,12 +2859,12 @@ static void mmu_sync_roots(struct kvm_vcpu *vcpu)
 		return;

 	vcpu_clear_mmio_info(vcpu, ~0ul);
-	trace_kvm_mmu_audit(vcpu, AUDIT_PRE_SYNC);
+	kvm_mmu_audit(vcpu, AUDIT_PRE_SYNC);
 	if (vcpu->arch.mmu.root_level == PT64_ROOT_LEVEL) {
 		hpa_t root = vcpu->arch.mmu.root_hpa;
 		sp = page_header(root);
 		mmu_sync_children(vcpu, sp);
-		trace_kvm_mmu_audit(vcpu, AUDIT_POST_SYNC);
+		kvm_mmu_audit(vcpu, AUDIT_POST_SYNC);
 		return;
 	}
 	for (i = 0; i < 4; ++i) {
@@ -2869,7 +2876,7 @@ static void mmu_sync_roots(struct kvm_vcpu *vcpu)
 			mmu_sync_children(vcpu, sp);
 		}
 	}
-	trace_kvm_mmu_audit(vcpu, AUDIT_POST_SYNC);
+	kvm_mmu_audit(vcpu, AUDIT_POST_SYNC);
 }

 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
@@ -3667,7 +3674,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,

 	spin_lock(&vcpu->kvm->mmu_lock);
 	++vcpu->kvm->stat.mmu_pte_write;
-	trace_kvm_mmu_audit(vcpu, AUDIT_PRE_PTE_WRITE);
+	kvm_mmu_audit(vcpu, AUDIT_PRE_PTE_WRITE);

 	mask.cr0_wp = mask.cr4_pae = mask.nxe = 1;
 	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn, node) {
@@ -3700,7 +3707,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	}
 	mmu_pte_write_flush_tlb(vcpu, zap_page, remote_flush, local_flush);
 	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
-	trace_kvm_mmu_audit(vcpu, AUDIT_POST_PTE_WRITE);
+	kvm_mmu_audit(vcpu, AUDIT_POST_PTE_WRITE);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 }

@@ -4030,12 +4037,6 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 	mmu_free_memory_caches(vcpu);
 }

-#ifdef CONFIG_KVM_MMU_AUDIT
-#include "mmu_audit.c"
-#else
-static void mmu_audit_disable(void) { }
-#endif
-
 void kvm_mmu_module_exit(void)
 {
 	mmu_destroy_caches();
diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index 746ec25..967a535 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -224,7 +224,7 @@ static void audit_vcpu_spte(struct kvm_vcpu *vcpu)
 	mmu_spte_walk(vcpu, audit_spte);
 }

-static void kvm_mmu_audit(void *ignore, struct kvm_vcpu *vcpu, int point)
+static void __kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
 {
 	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 10);

@@ -237,17 +237,19 @@ static void kvm_mmu_audit(void *ignore, struct kvm_vcpu *vcpu, int point)
 }

 static bool mmu_audit;
+static struct jump_label_key mmu_audit_key;
+
+#define kvm_mmu_audit(vcpu, point)		\
+	if (static_branch((&mmu_audit_key))) {	\
+		__kvm_mmu_audit(vcpu, point);	\
+	}

 static void mmu_audit_enable(void)
 {
-	int ret;
-
 	if (mmu_audit)
 		return;

-	ret = register_trace_kvm_mmu_audit(kvm_mmu_audit, NULL);
-	WARN_ON(ret);
-
+	jump_label_inc(&mmu_audit_key);
 	mmu_audit = true;
 }

@@ -256,8 +258,7 @@ static void mmu_audit_disable(void)
 	if (!mmu_audit)
 		return;

-	unregister_trace_kvm_mmu_audit(kvm_mmu_audit, NULL);
-	tracepoint_synchronize_unregister();
+	jump_label_dec(&mmu_audit_key);
 	mmu_audit = false;
 }

diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index eed67f3..89fb0e8 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -243,25 +243,6 @@ TRACE_EVENT(
 	TP_printk("addr:%llx gfn %llx access %x", __entry->addr, __entry->gfn,
 		  __entry->access)
 );
-
-TRACE_EVENT(
-	kvm_mmu_audit,
-	TP_PROTO(struct kvm_vcpu *vcpu, int audit_point),
-	TP_ARGS(vcpu, audit_point),
-
-	TP_STRUCT__entry(
-		__field(struct kvm_vcpu *, vcpu)
-		__field(int, audit_point)
-	),
-
-	TP_fast_assign(
-		__entry->vcpu = vcpu;
-		__entry->audit_point = audit_point;
-	),
-
-	TP_printk("vcpu:%d %s", __entry->vcpu->cpu,
-		  audit_point_name[__entry->audit_point])
-);
 #endif /* _TRACE_KVMMMU_H */

 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 52e9d58..1561028 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -632,7 +632,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 	if (mmu_notifier_retry(vcpu, mmu_seq))
 		goto out_unlock;

-	trace_kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
+	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
 	kvm_mmu_free_some_pages(vcpu);
 	if (!force_pt_level)
 		transparent_hugepage_adjust(vcpu, &walker.gfn, &pfn, &level);
@@ -643,7 +643,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 		 sptep, *sptep, emulate);

 	++vcpu->stat.pf_fixed;
-	trace_kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
+	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
 	spin_unlock(&vcpu->kvm->mmu_lock);

 	return emulate;
-- 
1.7.7.3


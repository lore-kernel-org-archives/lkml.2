Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab1K1MlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 07:41:08 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:51994 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab1K1MlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 07:41:06 -0500
Message-ID: <4ED3815C.9060901@linux.vnet.ibm.com>
Date: Mon, 28 Nov 2011 20:41:00 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/5] KVM: MMU: audit: replace mmu audit tracepoint with jump-lable
References: <4ED3811F.1070101@linux.vnet.ibm.com>
In-Reply-To: <4ED3811F.1070101@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11112802-6102-0000-0000-00000046A4DE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tracepoint is only used to audit mmu code, it should not be exposed to
user, let us replace it with jump-lable

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c         |   16 +++++++++++-----
 arch/x86/kvm/mmu_audit.c   |   28 +++++++++++++---------------
 arch/x86/kvm/mmutrace.h    |   19 -------------------
 arch/x86/kvm/paging_tmpl.h |    4 ++--
 4 files changed, 26 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d737443..62f69db 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -68,6 +68,12 @@ char *audit_point_name[] = {
 	"post sync"
 };

+#ifdef CONFIG_KVM_MMU_AUDIT
+static void kvm_mmu_audit(struct kvm_vcpu *vcpu, int point);
+#else
+static void kvm_mmu_audit(struct kvm_vcpu *vcpu, int point) { }
+#endif
+
 #undef MMU_DEBUG

 #ifdef MMU_DEBUG
@@ -2852,12 +2858,12 @@ static void mmu_sync_roots(struct kvm_vcpu *vcpu)
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
@@ -2869,7 +2875,7 @@ static void mmu_sync_roots(struct kvm_vcpu *vcpu)
 			mmu_sync_children(vcpu, sp);
 		}
 	}
-	trace_kvm_mmu_audit(vcpu, AUDIT_POST_SYNC);
+	kvm_mmu_audit(vcpu, AUDIT_POST_SYNC);
 }

 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
@@ -3667,7 +3673,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,

 	spin_lock(&vcpu->kvm->mmu_lock);
 	++vcpu->kvm->stat.mmu_pte_write;
-	trace_kvm_mmu_audit(vcpu, AUDIT_PRE_PTE_WRITE);
+	kvm_mmu_audit(vcpu, AUDIT_PRE_PTE_WRITE);

 	mask.cr0_wp = mask.cr4_pae = mask.nxe = 1;
 	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn, node) {
@@ -3700,7 +3706,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	}
 	mmu_pte_write_flush_tlb(vcpu, zap_page, remote_flush, local_flush);
 	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
-	trace_kvm_mmu_audit(vcpu, AUDIT_POST_PTE_WRITE);
+	kvm_mmu_audit(vcpu, AUDIT_POST_PTE_WRITE);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 }

diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index 746ec25..5df6736 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -224,30 +224,29 @@ static void audit_vcpu_spte(struct kvm_vcpu *vcpu)
 	mmu_spte_walk(vcpu, audit_spte);
 }

-static void kvm_mmu_audit(void *ignore, struct kvm_vcpu *vcpu, int point)
+static bool mmu_audit;
+static struct jump_label_key mmu_audit_key;
+
+static void kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
 {
 	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 10);

-	if (!__ratelimit(&ratelimit_state))
-		return;
+	if (static_branch((&mmu_audit_key))) {
+		if (!__ratelimit(&ratelimit_state))
+			return;

-	vcpu->kvm->arch.audit_point = point;
-	audit_all_active_sps(vcpu->kvm);
-	audit_vcpu_spte(vcpu);
+		vcpu->kvm->arch.audit_point = point;
+		audit_all_active_sps(vcpu->kvm);
+		audit_vcpu_spte(vcpu);
+	}
 }

-static bool mmu_audit;
-
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

@@ -256,8 +255,7 @@ static void mmu_audit_disable(void)
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


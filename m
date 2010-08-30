Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0H3KSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 06:18:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51467 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755146Ab0H3KSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 06:18:39 -0400
Message-ID: <4C7B867D.9080500@cn.fujitsu.com>
Date: Mon, 30 Aug 2010 18:22:53 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 1/5] KVM: MMU: support disable/enable mmu audit dynamicly
References: <4C78FA00.8090606@cn.fujitsu.com>
In-Reply-To: <4C78FA00.8090606@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a r/w module parameter named 'mmu_audit', it can control audit enable/disable:

enable:
echo 1 > /sys/module/kvm/parameters/mmu_audit 

disable:
echo 0 > /sys/module/kvm/parameters/mmu_audit

This patch not change the logic

V2:
  Using r/w module parameter instead of debugfs file

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/Kconfig       |    7 +++
 arch/x86/kvm/mmu.c         |   91 +++++++++++++++++++++++++++++++++++---------
 arch/x86/kvm/mmutrace.h    |   19 +++++++++
 arch/x86/kvm/paging_tmpl.h |    4 +-
 4 files changed, 101 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 970bbd4..ddc131f 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -64,6 +64,13 @@ config KVM_AMD
 	  To compile this as a module, choose M here: the module
 	  will be called kvm-amd.
 
+config KVM_MMU_AUDIT
+	bool "Audit KVM MMU"
+	depends on KVM && TRACEPOINTS
+	---help---
+	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
+	 audit  KVM MMU at runtime.
+
 # OK, it's a little counter-intuitive to do this, but it puts it neatly under
 # the virtualization menu.
 source drivers/vhost/Kconfig
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0bff4d5..8b750ff 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -49,15 +49,21 @@
  */
 bool tdp_enabled = false;
 
-#undef MMU_DEBUG
+enum {
+	AUDIT_PRE_PAGE_FAULT,
+	AUDIT_POST_PAGE_FAULT,
+	AUDIT_PRE_PTE_WRITE,
+	AUDIT_POST_PTE_WRITE
+};
 
-#undef AUDIT
+char *audit_point_name[] = {
+	"pre page fault",
+	"post page fault",
+	"pre pte write",
+	"post pte write"
+};
 
-#ifdef AUDIT
-static void kvm_mmu_audit(struct kvm_vcpu *vcpu, const char *msg);
-#else
-static void kvm_mmu_audit(struct kvm_vcpu *vcpu, const char *msg) {}
-#endif
+#undef MMU_DEBUG
 
 #ifdef MMU_DEBUG
 
@@ -71,7 +77,7 @@ static void kvm_mmu_audit(struct kvm_vcpu *vcpu, const char *msg) {}
 
 #endif
 
-#if defined(MMU_DEBUG) || defined(AUDIT)
+#ifdef MMU_DEBUG
 static int dbg = 0;
 module_param(dbg, bool, 0644);
 #endif
@@ -2964,7 +2970,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	kvm_mmu_access_page(vcpu, gfn);
 	kvm_mmu_free_some_pages(vcpu);
 	++vcpu->kvm->stat.mmu_pte_write;
-	kvm_mmu_audit(vcpu, "pre pte write");
+	trace_kvm_mmu_audit(vcpu, AUDIT_PRE_PTE_WRITE);
 	if (guest_initiated) {
 		if (gfn == vcpu->arch.last_pt_write_gfn
 		    && !last_updated_pte_accessed(vcpu)) {
@@ -3037,7 +3043,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	}
 	mmu_pte_write_flush_tlb(vcpu, zap_page, remote_flush, local_flush);
 	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
-	kvm_mmu_audit(vcpu, "post pte write");
+	trace_kvm_mmu_audit(vcpu, AUDIT_POST_PTE_WRITE);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	if (!is_error_pfn(vcpu->arch.update_pte.pfn)) {
 		kvm_release_pfn_clean(vcpu->arch.update_pte.pfn);
@@ -3483,8 +3489,7 @@ int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4])
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_get_spte_hierarchy);
 
-#ifdef AUDIT
-
+#ifdef CONFIG_KVM_MMU_AUDIT
 static const char *audit_msg;
 
 typedef void (*inspect_spte_fn) (struct kvm *kvm, u64 *sptep);
@@ -3699,18 +3704,68 @@ static void audit_write_protection(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void kvm_mmu_audit(struct kvm_vcpu *vcpu, const char *msg)
+static void kvm_mmu_audit(void *ignore, struct kvm_vcpu *vcpu, int audit_point)
 {
-	int olddbg = dbg;
-
-	dbg = 0;
-	audit_msg = msg;
+	audit_msg = audit_point_name[audit_point];
 	audit_rmap(vcpu);
 	audit_write_protection(vcpu);
 	if (strcmp("pre pte write", audit_msg) != 0)
 		audit_mappings(vcpu);
 	audit_sptes_have_rmaps(vcpu);
-	dbg = olddbg;
 }
 
+static bool mmu_audit;
+
+static void mmu_audit_enable(void)
+{
+	int ret;
+
+	if (mmu_audit)
+		return;
+
+	ret = register_trace_kvm_mmu_audit(kvm_mmu_audit, NULL);
+	WARN_ON(ret);
+
+	mmu_audit = true;
+}
+
+static void mmu_audit_disable(void)
+{
+	if (!mmu_audit)
+		return;
+
+	unregister_trace_kvm_mmu_audit(kvm_mmu_audit, NULL);
+	tracepoint_synchronize_unregister();
+	mmu_audit = false;
+}
+
+static int mmu_audit_set(const char *val, const struct kernel_param *kp)
+{
+	int ret;
+	unsigned long enable;
+
+	ret = strict_strtoul(val, 10, &enable);
+	if (ret < 0)
+		return -EINVAL;
+
+	switch (enable) {
+	case 0:
+		mmu_audit_disable();
+		break;
+	case 1:
+		mmu_audit_enable();
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct kernel_param_ops audit_param_ops = {
+	.set = mmu_audit_set,
+	.get = param_get_bool,
+};
+
+module_param_cb(mmu_audit, &audit_param_ops, &mmu_audit, 0644);
 #endif
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 3aab0f0..b60b4fd 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -195,6 +195,25 @@ DEFINE_EVENT(kvm_mmu_page_class, kvm_mmu_prepare_zap_page,
 
 	TP_ARGS(sp)
 );
+
+TRACE_EVENT(
+	kvm_mmu_audit,
+	TP_PROTO(struct kvm_vcpu *vcpu, int audit_point),
+	TP_ARGS(vcpu, audit_point),
+
+	TP_STRUCT__entry(
+		__field(struct kvm_vcpu *, vcpu)
+		__field(int, audit_point)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu = vcpu;
+		__entry->audit_point = audit_point;
+	),
+
+	TP_printk("vcpu:%d %s", __entry->vcpu->cpu,
+		  audit_point_name[__entry->audit_point])
+);
 #endif /* _TRACE_KVMMMU_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index a0f2feb..debe770 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -542,7 +542,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	if (mmu_notifier_retry(vcpu, mmu_seq))
 		goto out_unlock;
 
-	kvm_mmu_audit(vcpu, "pre page fault");
+	trace_kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
 	kvm_mmu_free_some_pages(vcpu);
 	sptep = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
 			     level, &write_pt, pfn);
@@ -554,7 +554,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 		vcpu->arch.last_pt_write_count = 0; /* reset fork detector */
 
 	++vcpu->stat.pf_fixed;
-	kvm_mmu_audit(vcpu, "post page fault (fixed)");
+	trace_kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 	return write_pt;
-- 
1.7.0.4


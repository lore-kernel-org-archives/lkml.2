Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab0LMK21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 05:28:27 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50729 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756935Ab0LMK2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 05:28:25 -0500
Message-ID: <4D05F654.9080400@cn.fujitsu.com>
Date: Mon, 13 Dec 2010 18:32:52 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/2] KVM: MMU: audit: allow audit more guests at the same
 time
References: <4D05F5F6.3070909@cn.fujitsu.com>
In-Reply-To: <4D05F5F6.3070909@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-13 18:28:21,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-13 18:28:21,
	Serialize complete at 2010-12-13 18:28:21
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It only allows to audit one guest in the system since:
- 'audit_point' is a glob variable
- mmu_audit_disable() is called in kvm_mmu_destroy(), so audit is disabled
  after a guest exited

this patch fix those issues then allow to audit more guests at the same time

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    4 ++++
 arch/x86/kvm/mmu.c              |   27 ++++++++++++++-------------
 arch/x86/kvm/mmu_audit.c        |   39 ++++++++++++++++++++++-----------------
 3 files changed, 40 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b55d789..6244958 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -460,6 +460,10 @@ struct kvm_arch {
 	/* fields used by HYPER-V emulation */
 	u64 hv_guest_os_id;
 	u64 hv_hypercall;
+
+	#ifdef CONFIG_KVM_MMU_AUDIT
+	int audit_point;
+	#endif
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0c5cad0..daa36ba 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3532,13 +3532,6 @@ static void mmu_destroy_caches(void)
 		kmem_cache_destroy(mmu_page_header_cache);
 }
 
-void kvm_mmu_module_exit(void)
-{
-	mmu_destroy_caches();
-	percpu_counter_destroy(&kvm_total_used_mmu_pages);
-	unregister_shrinker(&mmu_shrinker);
-}
-
 int kvm_mmu_module_init(void)
 {
 	pte_chain_cache = kmem_cache_create("kvm_pte_chain",
@@ -3731,12 +3724,6 @@ int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4])
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_get_spte_hierarchy);
 
-#ifdef CONFIG_KVM_MMU_AUDIT
-#include "mmu_audit.c"
-#else
-static void mmu_audit_disable(void) { }
-#endif
-
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
 	ASSERT(vcpu);
@@ -3744,5 +3731,19 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 	destroy_kvm_mmu(vcpu);
 	free_mmu_pages(vcpu);
 	mmu_free_memory_caches(vcpu);
+}
+
+#ifdef CONFIG_KVM_MMU_AUDIT
+#include "mmu_audit.c"
+#else
+static void mmu_audit_disable(void) { }
+#endif
+
+void kvm_mmu_module_exit(void)
+{
+	mmu_destroy_caches();
+	percpu_counter_destroy(&kvm_total_used_mmu_pages);
+	unregister_shrinker(&mmu_shrinker);
 	mmu_audit_disable();
 }
+
diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index ba2bcdd..5f6223b 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -19,11 +19,9 @@
 
 #include <linux/ratelimit.h>
 
-static int audit_point;
-
-#define audit_printk(fmt, args...)		\
+#define audit_printk(kvm, fmt, args...)		\
 	printk(KERN_ERR "audit: (%s) error: "	\
-		fmt, audit_point_name[audit_point], ##args)
+		fmt, audit_point_name[kvm->arch.audit_point], ##args)
 
 typedef void (*inspect_spte_fn) (struct kvm_vcpu *vcpu, u64 *sptep, int level);
 
@@ -97,18 +95,21 @@ static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 
 	if (sp->unsync) {
 		if (level != PT_PAGE_TABLE_LEVEL) {
-			audit_printk("unsync sp: %p level = %d\n", sp, level);
+			audit_printk(vcpu->kvm, "unsync sp: %p "
+				     "level = %d\n", sp, level);
 			return;
 		}
 
 		if (*sptep == shadow_notrap_nonpresent_pte) {
-			audit_printk("notrap spte in unsync sp: %p\n", sp);
+			audit_printk(vcpu->kvm, "notrap spte in unsync "
+				     "sp: %p\n", sp);
 			return;
 		}
 	}
 
 	if (sp->role.direct && *sptep == shadow_notrap_nonpresent_pte) {
-		audit_printk("notrap spte in direct sp: %p\n", sp);
+		audit_printk(vcpu->kvm, "notrap spte in direct sp: %p\n",
+			     sp);
 		return;
 	}
 
@@ -125,8 +126,9 @@ static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 
 	hpa =  pfn << PAGE_SHIFT;
 	if ((*sptep & PT64_BASE_ADDR_MASK) != hpa)
-		audit_printk("levels %d pfn %llx hpa %llx ent %llxn",
-				   vcpu->arch.mmu.root_level, pfn, hpa, *sptep);
+		audit_printk(vcpu->kvm, "levels %d pfn %llx hpa %llx "
+			     "ent %llxn", vcpu->arch.mmu.root_level, pfn,
+			     hpa, *sptep);
 }
 
 static void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
@@ -142,8 +144,8 @@ static void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
 	if (!gfn_to_memslot(kvm, gfn)) {
 		if (!printk_ratelimit())
 			return;
-		audit_printk("no memslot for gfn %llx\n", gfn);
-		audit_printk("index %ld of sp (gfn=%llx)\n",
+		audit_printk(kvm, "no memslot for gfn %llx\n", gfn);
+		audit_printk(kvm, "index %ld of sp (gfn=%llx)\n",
 		       (long int)(sptep - rev_sp->spt), rev_sp->gfn);
 		dump_stack();
 		return;
@@ -153,7 +155,8 @@ static void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
 	if (!*rmapp) {
 		if (!printk_ratelimit())
 			return;
-		audit_printk("no rmap for writable spte %llx\n", *sptep);
+		audit_printk(kvm, "no rmap for writable spte %llx\n",
+			     *sptep);
 		dump_stack();
 	}
 }
@@ -168,8 +171,9 @@ static void audit_spte_after_sync(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 {
 	struct kvm_mmu_page *sp = page_header(__pa(sptep));
 
-	if (audit_point == AUDIT_POST_SYNC && sp->unsync)
-		audit_printk("meet unsync sp(%p) after sync root.\n", sp);
+	if (vcpu->kvm->arch.audit_point == AUDIT_POST_SYNC && sp->unsync)
+		audit_printk(vcpu->kvm, "meet unsync sp(%p) after sync "
+			     "root.\n", sp);
 }
 
 static void check_mappings_rmap(struct kvm *kvm, struct kvm_mmu_page *sp)
@@ -202,8 +206,9 @@ static void audit_write_protection(struct kvm *kvm, struct kvm_mmu_page *sp)
 	spte = rmap_next(kvm, rmapp, NULL);
 	while (spte) {
 		if (is_writable_pte(*spte))
-			audit_printk("shadow page has writable mappings: gfn "
-				     "%llx role %x\n", sp->gfn, sp->role.word);
+			audit_printk(kvm, "shadow page has writable "
+				     "mappings: gfn %llx role %x\n",
+				     sp->gfn, sp->role.word);
 		spte = rmap_next(kvm, rmapp, spte);
 	}
 }
@@ -238,7 +243,7 @@ static void kvm_mmu_audit(void *ignore, struct kvm_vcpu *vcpu, int point)
 	if (!__ratelimit(&ratelimit_state))
 		return;
 
-	audit_point = point;
+	vcpu->kvm->arch.audit_point = point;
 	audit_all_active_sps(vcpu->kvm);
 	audit_vcpu_spte(vcpu);
 }
-- 
1.7.0.4


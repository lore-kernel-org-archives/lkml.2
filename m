Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab0H1L4i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 07:56:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63613 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab0H1L4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 07:56:36 -0400
Message-ID: <4C78FA5B.8070008@cn.fujitsu.com>
Date: Sat, 28 Aug 2010 20:00:27 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/4] KVM: MMU: support disable/enable mmu audit dynamicly
References: <4C78FA00.8090606@cn.fujitsu.com>
In-Reply-To: <4C78FA00.8090606@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the debugfs file named 'mmu-debug', we can disable/enable mmu audit by
this file:

enable:
echo 1 > debugfs/kvm/mmu-debug

disable:
echo 0 > debugfs/kvm/mmu-debug

This patch not change the logic

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/Kconfig       |    6 +
 arch/x86/kvm/mmu.c         |  250 ++--------------------------------
 arch/x86/kvm/mmu_debug.c   |  329 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu_debug.h   |   12 ++
 arch/x86/kvm/mmutrace.h    |   19 +++
 arch/x86/kvm/paging_tmpl.h |    4 +-
 virt/kvm/kvm_main.c        |    6 +-
 7 files changed, 380 insertions(+), 246 deletions(-)
 create mode 100644 arch/x86/kvm/mmu_debug.c
 create mode 100644 arch/x86/kvm/mmu_debug.h

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 970bbd4..67a941d 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -64,6 +64,12 @@ config KVM_AMD
 	  To compile this as a module, choose M here: the module
 	  will be called kvm-amd.
 
+config KVM_MMU_DEBUG
+	bool "Debug KVM MMU"
+	depends on KVM && TRACEPOINTS
+	---help---
+	 This feature allows debug KVM MMU at runtime.
+
 # OK, it's a little counter-intuitive to do this, but it puts it neatly under
 # the virtualization menu.
 source drivers/vhost/Kconfig
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0bff4d5..8609249 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -19,6 +19,7 @@
  */
 
 #include "mmu.h"
+#include "mmu_debug.h"
 #include "x86.h"
 #include "kvm_cache_regs.h"
 
@@ -51,14 +52,6 @@ bool tdp_enabled = false;
 
 #undef MMU_DEBUG
 
-#undef AUDIT
-
-#ifdef AUDIT
-static void kvm_mmu_audit(struct kvm_vcpu *vcpu, const char *msg);
-#else
-static void kvm_mmu_audit(struct kvm_vcpu *vcpu, const char *msg) {}
-#endif
-
 #ifdef MMU_DEBUG
 
 #define pgprintk(x...) do { if (dbg) printk(x); } while (0)
@@ -71,7 +64,7 @@ static void kvm_mmu_audit(struct kvm_vcpu *vcpu, const char *msg) {}
 
 #endif
 
-#if defined(MMU_DEBUG) || defined(AUDIT)
+#if defined MMU_DEBUG
 static int dbg = 0;
 module_param(dbg, bool, 0644);
 #endif
@@ -2964,7 +2957,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	kvm_mmu_access_page(vcpu, gfn);
 	kvm_mmu_free_some_pages(vcpu);
 	++vcpu->kvm->stat.mmu_pte_write;
-	kvm_mmu_audit(vcpu, "pre pte write");
+	trace_kvm_mmu_audit(vcpu, "pre pte write");
 	if (guest_initiated) {
 		if (gfn == vcpu->arch.last_pt_write_gfn
 		    && !last_updated_pte_accessed(vcpu)) {
@@ -3037,7 +3030,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	}
 	mmu_pte_write_flush_tlb(vcpu, zap_page, remote_flush, local_flush);
 	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
-	kvm_mmu_audit(vcpu, "post pte write");
+	trace_kvm_mmu_audit(vcpu, "post pte write");
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	if (!is_error_pfn(vcpu->arch.update_pte.pfn)) {
 		kvm_release_pfn_clean(vcpu->arch.update_pte.pfn);
@@ -3289,6 +3282,7 @@ void kvm_mmu_module_exit(void)
 	mmu_destroy_caches();
 	percpu_counter_destroy(&kvm_total_used_mmu_pages);
 	unregister_shrinker(&mmu_shrinker);
+	mmu_debug_cleanup();
 }
 
 int kvm_mmu_module_init(void)
@@ -3315,6 +3309,8 @@ int kvm_mmu_module_init(void)
 
 	register_shrinker(&mmu_shrinker);
 
+	mmu_debug_init();
+
 	return 0;
 
 nomem:
@@ -3483,234 +3479,6 @@ int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4])
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_get_spte_hierarchy);
 
-#ifdef AUDIT
-
-static const char *audit_msg;
-
-typedef void (*inspect_spte_fn) (struct kvm *kvm, u64 *sptep);
-
-static void __mmu_spte_walk(struct kvm *kvm, struct kvm_mmu_page *sp,
-			    inspect_spte_fn fn)
-{
-	int i;
-
-	for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
-		u64 ent = sp->spt[i];
-
-		if (is_shadow_present_pte(ent)) {
-			if (!is_last_spte(ent, sp->role.level)) {
-				struct kvm_mmu_page *child;
-				child = page_header(ent & PT64_BASE_ADDR_MASK);
-				__mmu_spte_walk(kvm, child, fn);
-			} else
-				fn(kvm, &sp->spt[i]);
-		}
-	}
-}
-
-static void mmu_spte_walk(struct kvm_vcpu *vcpu, inspect_spte_fn fn)
-{
-	int i;
-	struct kvm_mmu_page *sp;
-
-	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
-		return;
-	if (vcpu->arch.mmu.shadow_root_level == PT64_ROOT_LEVEL) {
-		hpa_t root = vcpu->arch.mmu.root_hpa;
-		sp = page_header(root);
-		__mmu_spte_walk(vcpu->kvm, sp, fn);
-		return;
-	}
-	for (i = 0; i < 4; ++i) {
-		hpa_t root = vcpu->arch.mmu.pae_root[i];
-
-		if (root && VALID_PAGE(root)) {
-			root &= PT64_BASE_ADDR_MASK;
-			sp = page_header(root);
-			__mmu_spte_walk(vcpu->kvm, sp, fn);
-		}
-	}
-	return;
-}
-
-static void audit_mappings_page(struct kvm_vcpu *vcpu, u64 page_pte,
-				gva_t va, int level)
-{
-	u64 *pt = __va(page_pte & PT64_BASE_ADDR_MASK);
-	int i;
-	gva_t va_delta = 1ul << (PAGE_SHIFT + 9 * (level - 1));
-
-	for (i = 0; i < PT64_ENT_PER_PAGE; ++i, va += va_delta) {
-		u64 *sptep = pt + i;
-		struct kvm_mmu_page *sp;
-		gfn_t gfn;
-		pfn_t pfn;
-		hpa_t hpa;
-
-		sp = page_header(__pa(sptep));
-
-		if (sp->unsync) {
-			if (level != PT_PAGE_TABLE_LEVEL) {
-				printk(KERN_ERR "audit: (%s) error: unsync sp: %p level = %d\n",
-						audit_msg, sp, level);
-				return;
-			}
-
-			if (*sptep == shadow_notrap_nonpresent_pte) {
-				printk(KERN_ERR "audit: (%s) error: notrap spte in unsync sp: %p\n",
-						audit_msg, sp);
-				return;
-			}
-		}
-
-		if (sp->role.direct && *sptep == shadow_notrap_nonpresent_pte) {
-			printk(KERN_ERR "audit: (%s) error: notrap spte in direct sp: %p\n",
-					audit_msg, sp);
-			return;
-		}
-
-		if (!is_shadow_present_pte(*sptep) ||
-		      !is_last_spte(*sptep, level))
-			return;
-
-		gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
-		pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);
-
-		if (is_error_pfn(pfn)) {
-			kvm_release_pfn_clean(pfn);
-			return;
-		}
-
-		hpa =  pfn << PAGE_SHIFT;
-
-		if ((*sptep & PT64_BASE_ADDR_MASK) != hpa)
-			printk(KERN_ERR "xx audit error: (%s) levels %d"
-					   " gva %lx pfn %llx hpa %llx ent %llxn",
-					   audit_msg, vcpu->arch.mmu.root_level,
-					   va, pfn, hpa, *sptep);
-	}
-}
-
-static void audit_mappings(struct kvm_vcpu *vcpu)
-{
-	unsigned i;
-
-	if (vcpu->arch.mmu.root_level == 4)
-		audit_mappings_page(vcpu, vcpu->arch.mmu.root_hpa, 0, 4);
-	else
-		for (i = 0; i < 4; ++i)
-			if (vcpu->arch.mmu.pae_root[i] & PT_PRESENT_MASK)
-				audit_mappings_page(vcpu,
-						    vcpu->arch.mmu.pae_root[i],
-						    i << 30,
-						    2);
-}
-
-void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
-{
-	unsigned long *rmapp;
-	struct kvm_mmu_page *rev_sp;
-	gfn_t gfn;
-
-
-	rev_sp = page_header(__pa(sptep));
-	gfn = kvm_mmu_page_get_gfn(rev_sp, sptep - rev_sp->spt);
-
-	if (!gfn_to_memslot(kvm, gfn)) {
-		if (!printk_ratelimit())
-			return;
-		printk(KERN_ERR "%s: no memslot for gfn %llx\n",
-				 audit_msg, gfn);
-		printk(KERN_ERR "%s: index %ld of sp (gfn=%llx)\n",
-		       audit_msg, (long int)(sptep - rev_sp->spt),
-				rev_sp->gfn);
-		dump_stack();
-		return;
-	}
-
-	rmapp = gfn_to_rmap(kvm, gfn, rev_sp->role.level);
-	if (!*rmapp) {
-		if (!printk_ratelimit())
-			return;
-		printk(KERN_ERR "%s: no rmap for writable spte %llx\n",
-				 audit_msg, *sptep);
-		dump_stack();
-	}
-}
-
-void audit_sptes_have_rmaps(struct kvm_vcpu *vcpu)
-{
-	mmu_spte_walk(vcpu, inspect_spte_has_rmap);
-}
-
-static void check_mappings_rmap(struct kvm_vcpu *vcpu)
-{
-	struct kvm_mmu_page *sp;
-	int i;
-
-	list_for_each_entry(sp, &vcpu->kvm->arch.active_mmu_pages, link) {
-		u64 *pt = sp->spt;
-
-		if (sp->role.level != PT_PAGE_TABLE_LEVEL)
-			continue;
-
-		for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
-			if (!is_rmap_spte(pt[i]))
-				continue;
-
-			inspect_spte_has_rmap(vcpu->kvm, &pt[i]);
-		}
-	}
-	return;
-}
-
-static void audit_rmap(struct kvm_vcpu *vcpu)
-{
-	check_mappings_rmap(vcpu);
-}
-
-static void audit_write_protection(struct kvm_vcpu *vcpu)
-{
-	struct kvm_mmu_page *sp;
-	struct kvm_memory_slot *slot;
-	unsigned long *rmapp;
-	u64 *spte;
-
-	list_for_each_entry(sp, &vcpu->kvm->arch.active_mmu_pages, link) {
-		if (sp->role.direct)
-			continue;
-		if (sp->unsync)
-			continue;
-		if (sp->role.invalid)
-			continue;
-
-		slot = gfn_to_memslot(vcpu->kvm, sp->gfn);
-		rmapp = &slot->rmap[sp->gfn - slot->base_gfn];
-
-		spte = rmap_next(vcpu->kvm, rmapp, NULL);
-		while (spte) {
-			if (is_writable_pte(*spte))
-				printk(KERN_ERR "%s: (%s) shadow page has "
-				"writable mappings: gfn %llx role %x\n",
-			       __func__, audit_msg, sp->gfn,
-			       sp->role.word);
-			spte = rmap_next(vcpu->kvm, rmapp, spte);
-		}
-	}
-}
-
-static void kvm_mmu_audit(struct kvm_vcpu *vcpu, const char *msg)
-{
-	int olddbg = dbg;
-
-	dbg = 0;
-	audit_msg = msg;
-	audit_rmap(vcpu);
-	audit_write_protection(vcpu);
-	if (strcmp("pre pte write", audit_msg) != 0)
-		audit_mappings(vcpu);
-	audit_sptes_have_rmaps(vcpu);
-	dbg = olddbg;
-}
-
+#ifdef CONFIG_KVM_MMU_DEBUG
+#include "mmu_debug.c"
 #endif
diff --git a/arch/x86/kvm/mmu_debug.c b/arch/x86/kvm/mmu_debug.c
new file mode 100644
index 0000000..d2c0048
--- /dev/null
+++ b/arch/x86/kvm/mmu_debug.c
@@ -0,0 +1,329 @@
+/*
+ * mmu_debug.c:
+ *
+ * Debug code for KVM MMU
+ *
+ * Copyright (C) 2006 Qumranet, Inc.
+ * Copyright 2010 Red Hat, Inc. and/or its affilates.
+ *
+ * Authors:
+ *   Yaniv Kamay  <yaniv@qumranet.com>
+ *   Avi Kivity   <avi@qumranet.com>
+ *   Marcelo Tosatti <mtosatti@redhat.com>
+ *   Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ */
+
+#include <linux/debugfs.h>
+
+static struct dentry *debugfs_file;
+static bool mmu_debug;
+
+static const char *audit_msg;
+
+typedef void (*inspect_spte_fn) (struct kvm *kvm, u64 *sptep);
+
+static void __mmu_spte_walk(struct kvm *kvm, struct kvm_mmu_page *sp,
+			    inspect_spte_fn fn)
+{
+	int i;
+
+	for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
+		u64 ent = sp->spt[i];
+
+		if (is_shadow_present_pte(ent)) {
+			if (!is_last_spte(ent, sp->role.level)) {
+				struct kvm_mmu_page *child;
+				child = page_header(ent & PT64_BASE_ADDR_MASK);
+				__mmu_spte_walk(kvm, child, fn);
+			} else
+				fn(kvm, &sp->spt[i]);
+		}
+	}
+}
+
+static void mmu_spte_walk(struct kvm_vcpu *vcpu, inspect_spte_fn fn)
+{
+	int i;
+	struct kvm_mmu_page *sp;
+
+	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
+		return;
+	if (vcpu->arch.mmu.shadow_root_level == PT64_ROOT_LEVEL) {
+		hpa_t root = vcpu->arch.mmu.root_hpa;
+		sp = page_header(root);
+		__mmu_spte_walk(vcpu->kvm, sp, fn);
+		return;
+	}
+	for (i = 0; i < 4; ++i) {
+		hpa_t root = vcpu->arch.mmu.pae_root[i];
+
+		if (root && VALID_PAGE(root)) {
+			root &= PT64_BASE_ADDR_MASK;
+			sp = page_header(root);
+			__mmu_spte_walk(vcpu->kvm, sp, fn);
+		}
+	}
+	return;
+}
+
+static void audit_mappings_page(struct kvm_vcpu *vcpu, u64 page_pte,
+				gva_t va, int level)
+{
+	u64 *pt = __va(page_pte & PT64_BASE_ADDR_MASK);
+	int i;
+	gva_t va_delta = 1ul << (PAGE_SHIFT + 9 * (level - 1));
+
+	for (i = 0; i < PT64_ENT_PER_PAGE; ++i, va += va_delta) {
+		u64 *sptep = pt + i;
+		struct kvm_mmu_page *sp;
+		gfn_t gfn;
+		pfn_t pfn;
+		hpa_t hpa;
+
+		sp = page_header(__pa(sptep));
+
+		if (sp->unsync) {
+			if (level != PT_PAGE_TABLE_LEVEL) {
+				printk(KERN_ERR "audit: (%s) error: unsync sp: %p level = %d\n",
+						audit_msg, sp, level);
+				return;
+			}
+
+			if (*sptep == shadow_notrap_nonpresent_pte) {
+				printk(KERN_ERR "audit: (%s) error: notrap spte in unsync sp: %p\n",
+						audit_msg, sp);
+				return;
+			}
+		}
+
+		if (sp->role.direct && *sptep == shadow_notrap_nonpresent_pte) {
+			printk(KERN_ERR "audit: (%s) error: notrap spte in direct sp: %p\n",
+					audit_msg, sp);
+			return;
+		}
+
+		if (!is_shadow_present_pte(*sptep) ||
+		      !is_last_spte(*sptep, level))
+			return;
+
+		gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
+		pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);
+
+		if (is_error_pfn(pfn)) {
+			kvm_release_pfn_clean(pfn);
+			return;
+		}
+
+		hpa =  pfn << PAGE_SHIFT;
+
+		if ((*sptep & PT64_BASE_ADDR_MASK) != hpa)
+			printk(KERN_ERR "xx audit error: (%s) levels %d"
+					   " gva %lx pfn %llx hpa %llx ent %llxn",
+					   audit_msg, vcpu->arch.mmu.root_level,
+					   va, pfn, hpa, *sptep);
+	}
+}
+
+static void audit_mappings(struct kvm_vcpu *vcpu)
+{
+	unsigned i;
+
+	if (vcpu->arch.mmu.root_level == 4)
+		audit_mappings_page(vcpu, vcpu->arch.mmu.root_hpa, 0, 4);
+	else
+		for (i = 0; i < 4; ++i)
+			if (vcpu->arch.mmu.pae_root[i] & PT_PRESENT_MASK)
+				audit_mappings_page(vcpu,
+						    vcpu->arch.mmu.pae_root[i],
+						    i << 30,
+						    2);
+}
+
+void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
+{
+	unsigned long *rmapp;
+	struct kvm_mmu_page *rev_sp;
+	gfn_t gfn;
+
+
+	rev_sp = page_header(__pa(sptep));
+	gfn = kvm_mmu_page_get_gfn(rev_sp, sptep - rev_sp->spt);
+
+	if (!gfn_to_memslot(kvm, gfn)) {
+		if (!printk_ratelimit())
+			return;
+		printk(KERN_ERR "%s: no memslot for gfn %llx\n",
+				 audit_msg, gfn);
+		printk(KERN_ERR "%s: index %ld of sp (gfn=%llx)\n",
+		       audit_msg, (long int)(sptep - rev_sp->spt),
+				rev_sp->gfn);
+		dump_stack();
+		return;
+	}
+
+	rmapp = gfn_to_rmap(kvm, gfn, rev_sp->role.level);
+	if (!*rmapp) {
+		if (!printk_ratelimit())
+			return;
+		printk(KERN_ERR "%s: no rmap for writable spte %llx\n",
+				 audit_msg, *sptep);
+		dump_stack();
+	}
+}
+
+void audit_sptes_have_rmaps(struct kvm_vcpu *vcpu)
+{
+	mmu_spte_walk(vcpu, inspect_spte_has_rmap);
+}
+
+static void check_mappings_rmap(struct kvm_vcpu *vcpu)
+{
+	struct kvm_mmu_page *sp;
+	int i;
+
+	list_for_each_entry(sp, &vcpu->kvm->arch.active_mmu_pages, link) {
+		u64 *pt = sp->spt;
+
+		if (sp->role.level != PT_PAGE_TABLE_LEVEL)
+			continue;
+
+		for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
+			if (!is_rmap_spte(pt[i]))
+				continue;
+
+			inspect_spte_has_rmap(vcpu->kvm, &pt[i]);
+		}
+	}
+	return;
+}
+
+static void audit_rmap(struct kvm_vcpu *vcpu)
+{
+	check_mappings_rmap(vcpu);
+}
+
+static void audit_write_protection(struct kvm_vcpu *vcpu)
+{
+	struct kvm_mmu_page *sp;
+	struct kvm_memory_slot *slot;
+	unsigned long *rmapp;
+	u64 *spte;
+
+	list_for_each_entry(sp, &vcpu->kvm->arch.active_mmu_pages, link) {
+		if (sp->role.direct)
+			continue;
+		if (sp->unsync)
+			continue;
+		if (sp->role.invalid)
+			continue;
+
+		slot = gfn_to_memslot(vcpu->kvm, sp->gfn);
+		rmapp = &slot->rmap[sp->gfn - slot->base_gfn];
+
+		spte = rmap_next(vcpu->kvm, rmapp, NULL);
+		while (spte) {
+			if (is_writable_pte(*spte))
+				printk(KERN_ERR "%s: (%s) shadow page has "
+				"writable mappings: gfn %llx role %x\n",
+			       __func__, audit_msg, sp->gfn,
+			       sp->role.word);
+			spte = rmap_next(vcpu->kvm, rmapp, spte);
+		}
+	}
+}
+
+static void kvm_mmu_audit(void *ignore, struct kvm_vcpu *vcpu, const char *msg)
+{
+	audit_msg = msg;
+	audit_rmap(vcpu);
+	audit_write_protection(vcpu);
+	if (strcmp("pre pte write", audit_msg) != 0)
+		audit_mappings(vcpu);
+	audit_sptes_have_rmaps(vcpu);
+}
+
+static void mmu_debug_enable(void)
+{
+	int ret;
+
+	if (mmu_debug)
+		return;
+
+	ret = register_trace_kvm_mmu_audit(kvm_mmu_audit, NULL);
+	WARN_ON(ret);
+
+	mmu_debug = true;
+}
+
+static void mmu_debug_disable(void)
+{
+	if (!mmu_debug)
+		return;
+
+	unregister_trace_kvm_mmu_audit(kvm_mmu_audit, NULL);
+	tracepoint_synchronize_unregister();
+	mmu_debug = false;
+}
+
+static ssize_t mmu_debug_write(struct file *filp, const char __user *ubuf,
+			       size_t cnt, loff_t *ppos)
+{
+	char buf[64];
+	unsigned long val;
+	int ret;
+
+	if (cnt >= sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret < 0)
+		return ret;
+
+	switch (val) {
+	case 0:
+		mmu_debug_disable();
+		break;
+	case 1:
+		mmu_debug_enable();
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return cnt;
+}
+
+static ssize_t mmu_debug_read(struct file *filp, char __user *ubuf, size_t cnt,
+			      loff_t *ppos)
+{
+		char buf[64];
+		int r;
+
+		r = sprintf(buf, "%d\n", mmu_debug);
+		return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static const struct file_operations mmu_debug_ops = {
+	.write	= mmu_debug_write,
+	.read	= mmu_debug_read,
+};
+
+void mmu_debug_init(void)
+{
+	debugfs_file = debugfs_create_file("mmu-debug", 0644, kvm_debugfs_dir,
+					   NULL, &mmu_debug_ops);
+}
+
+void mmu_debug_cleanup(void)
+{
+	debugfs_remove(debugfs_file);
+}
diff --git a/arch/x86/kvm/mmu_debug.h b/arch/x86/kvm/mmu_debug.h
new file mode 100644
index 0000000..23f634f
--- /dev/null
+++ b/arch/x86/kvm/mmu_debug.h
@@ -0,0 +1,12 @@
+#ifndef _LINUX_MMU_DEBUG_H
+#define _LINUX_MMU_DEBUG_H
+
+#ifdef CONFIG_KVM_MMU_DEBUG
+void mmu_debug_init(void);
+void mmu_debug_cleanup(void);
+#else
+static inline void mmu_debug_init(void) {};
+static inline void mmu_debug_cleanup(void) {};
+#endif
+
+#endif
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 3aab0f0..28a0e1f 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -195,6 +195,25 @@ DEFINE_EVENT(kvm_mmu_page_class, kvm_mmu_prepare_zap_page,
 
 	TP_ARGS(sp)
 );
+
+TRACE_EVENT(
+	kvm_mmu_audit,
+	TP_PROTO(struct kvm_vcpu *vcpu, const char *msg),
+	TP_ARGS(vcpu, msg),
+
+	TP_STRUCT__entry(
+		__field(struct kvm_vcpu *, vcpu)
+		__field(const char *, msg)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu = vcpu;
+		__entry->msg = msg;
+	),
+
+	TP_printk("%s", __entry->msg)
+);
+
 #endif /* _TRACE_KVMMMU_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index a0f2feb..d6f348b 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -542,7 +542,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	if (mmu_notifier_retry(vcpu, mmu_seq))
 		goto out_unlock;
 
-	kvm_mmu_audit(vcpu, "pre page fault");
+	trace_kvm_mmu_audit(vcpu, "pre page fault");
 	kvm_mmu_free_some_pages(vcpu);
 	sptep = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
 			     level, &write_pt, pfn);
@@ -554,7 +554,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 		vcpu->arch.last_pt_write_count = 0; /* reset fork detector */
 
 	++vcpu->stat.pf_fixed;
-	kvm_mmu_audit(vcpu, "post page fault (fixed)");
+	trace_kvm_mmu_audit(vcpu, "post page fault (fixed)");
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 	return write_pt;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9a73b98..cc7b624 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2262,6 +2262,8 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	int r;
 	int cpu;
 
+	kvm_init_debug();
+
 	r = kvm_arch_init(opaque);
 	if (r)
 		goto out_fail;
@@ -2346,8 +2348,6 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	kvm_preempt_ops.sched_in = kvm_sched_in;
 	kvm_preempt_ops.sched_out = kvm_sched_out;
 
-	kvm_init_debug();
-
 	return 0;
 
 out_free:
@@ -2379,7 +2379,6 @@ EXPORT_SYMBOL_GPL(kvm_init);
 
 void kvm_exit(void)
 {
-	kvm_exit_debug();
 	misc_deregister(&kvm_dev);
 	kmem_cache_destroy(kvm_vcpu_cache);
 	sysdev_unregister(&kvm_sysdev);
@@ -2389,6 +2388,7 @@ void kvm_exit(void)
 	on_each_cpu(hardware_disable, NULL, 1);
 	kvm_arch_hardware_unsetup();
 	kvm_arch_exit();
+	kvm_exit_debug();
 	free_cpumask_var(cpus_hardware_enabled);
 	__free_page(hwpoison_page);
 	__free_page(bad_page);
-- 
1.7.0.4


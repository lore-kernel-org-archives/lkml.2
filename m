Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab0H3KVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 06:21:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55087 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754889Ab0H3KVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 06:21:37 -0400
Message-ID: <4C7B872F.9050700@cn.fujitsu.com>
Date: Mon, 30 Aug 2010 18:25:51 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 4/5] KVM: MMU: improve spte audit
References: <4C78FA00.8090606@cn.fujitsu.com> <4C7B867D.9080500@cn.fujitsu.com>
In-Reply-To: <4C7B867D.9080500@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both audit_mappings() and audit_sptes_have_rmaps() need to walk vcpu's page table, so we can do
these checking in a spte walking

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu_audit.c |  148 +++++++++++++++++++++------------------------
 1 files changed, 69 insertions(+), 79 deletions(-)

diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index 8becb86..3bde186 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -19,23 +19,24 @@
 
 static const char *audit_msg;
 
-typedef void (*inspect_spte_fn) (struct kvm *kvm, u64 *sptep);
+typedef void (*inspect_spte_fn) (struct kvm_vcpu *vcpu, u64 *sptep, int level);
 
-static void __mmu_spte_walk(struct kvm *kvm, struct kvm_mmu_page *sp,
-			    inspect_spte_fn fn)
+static void __mmu_spte_walk(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+			    inspect_spte_fn fn, int level)
 {
 	int i;
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
-		u64 ent = sp->spt[i];
-
-		if (is_shadow_present_pte(ent)) {
-			if (!is_last_spte(ent, sp->role.level)) {
-				struct kvm_mmu_page *child;
-				child = page_header(ent & PT64_BASE_ADDR_MASK);
-				__mmu_spte_walk(kvm, child, fn);
-			} else
-				fn(kvm, &sp->spt[i]);
+		u64 *ent = sp->spt;
+
+		fn(vcpu, ent + i, level);
+
+		if (is_shadow_present_pte(ent[i]) &&
+		      !is_last_spte(ent[i], level)) {
+			struct kvm_mmu_page *child;
+
+			child = page_header(ent[i] & PT64_BASE_ADDR_MASK);
+			__mmu_spte_walk(vcpu, child, fn, level - 1);
 		}
 	}
 }
@@ -47,21 +48,25 @@ static void mmu_spte_walk(struct kvm_vcpu *vcpu, inspect_spte_fn fn)
 
 	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
 		return;
+
 	if (vcpu->arch.mmu.shadow_root_level == PT64_ROOT_LEVEL) {
 		hpa_t root = vcpu->arch.mmu.root_hpa;
+
 		sp = page_header(root);
-		__mmu_spte_walk(vcpu->kvm, sp, fn);
+		__mmu_spte_walk(vcpu, sp, fn, PT64_ROOT_LEVEL);
 		return;
 	}
+
 	for (i = 0; i < 4; ++i) {
 		hpa_t root = vcpu->arch.mmu.pae_root[i];
 
 		if (root && VALID_PAGE(root)) {
 			root &= PT64_BASE_ADDR_MASK;
 			sp = page_header(root);
-			__mmu_spte_walk(vcpu->kvm, sp, fn);
+			__mmu_spte_walk(vcpu, sp, fn, 2);
 		}
 	}
+
 	return;
 }
 
@@ -75,80 +80,55 @@ static void walk_all_active_sps(struct kvm *kvm, sp_handler fn)
 		fn(kvm, sp);
 }
 
-static void audit_mappings_page(struct kvm_vcpu *vcpu, u64 page_pte,
-				gva_t va, int level)
+static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 {
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
+	struct kvm_mmu_page *sp;
+	gfn_t gfn;
+	pfn_t pfn;
+	hpa_t hpa;
 
-		if (sp->role.direct && *sptep == shadow_notrap_nonpresent_pte) {
-			printk(KERN_ERR "audit: (%s) error: notrap spte in direct sp: %p\n",
-					audit_msg, sp);
+	sp = page_header(__pa(sptep));
+
+	if (sp->unsync) {
+		if (level != PT_PAGE_TABLE_LEVEL) {
+			printk(KERN_ERR "audit: (%s) error: unsync sp: %p level = %d\n",
+				audit_msg, sp, level);
 			return;
 		}
 
-		if (!is_shadow_present_pte(*sptep) ||
-		      !is_last_spte(*sptep, level))
+		if (*sptep == shadow_notrap_nonpresent_pte) {
+			printk(KERN_ERR "audit: (%s) error: notrap spte in unsync sp: %p\n",
+				audit_msg, sp);
 			return;
+		}
+	}
 
-		gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
-		pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);
+	if (sp->role.direct && *sptep == shadow_notrap_nonpresent_pte) {
+		printk(KERN_ERR "audit: (%s) error: notrap spte in direct sp: %p\n",
+			audit_msg, sp);
+		return;
+	}
 
-		if (is_error_pfn(pfn)) {
-			kvm_release_pfn_clean(pfn);
-			return;
-		}
+	if (!is_shadow_present_pte(*sptep) || !is_last_spte(*sptep, level))
+		return;
 
-		hpa =  pfn << PAGE_SHIFT;
+	gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
+	pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);
 
-		if ((*sptep & PT64_BASE_ADDR_MASK) != hpa)
-			printk(KERN_ERR "xx audit error: (%s) levels %d"
-					   " gva %lx pfn %llx hpa %llx ent %llxn",
-					   audit_msg, vcpu->arch.mmu.root_level,
-					   va, pfn, hpa, *sptep);
+	if (is_error_pfn(pfn)) {
+		kvm_release_pfn_clean(pfn);
+		return;
 	}
-}
 
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
+	hpa =  pfn << PAGE_SHIFT;
+	if ((*sptep & PT64_BASE_ADDR_MASK) != hpa)
+		printk(KERN_ERR "xx audit error: (%s) levels %d"
+				   "pfn %llx hpa %llx ent %llxn",
+				   audit_msg, vcpu->arch.mmu.root_level,
+				   pfn, hpa, *sptep);
 }
 
-void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
+static void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
 {
 	unsigned long *rmapp;
 	struct kvm_mmu_page *rev_sp;
@@ -180,9 +160,10 @@ void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
 	}
 }
 
-void audit_sptes_have_rmaps(struct kvm_vcpu *vcpu)
+static void audit_sptes_have_rmaps(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 {
-	mmu_spte_walk(vcpu, inspect_spte_has_rmap);
+	if (is_shadow_present_pte(*sptep) && is_last_spte(*sptep, level))
+		inspect_spte_has_rmap(vcpu->kvm, sptep);
 }
 
 static void check_mappings_rmap(struct kvm *kvm, struct kvm_mmu_page *sp)
@@ -234,13 +215,22 @@ static void audit_all_active_sps(struct kvm *kvm)
 	walk_all_active_sps(kvm, audit_sp);
 }
 
+static void audit_spte(struct kvm_vcpu *vcpu, u64 *sptep, int level)
+{
+	audit_sptes_have_rmaps(vcpu, sptep, level);
+	audit_mappings(vcpu, sptep, level);
+}
+
+static void audit_vcpu_spte(struct kvm_vcpu *vcpu)
+{
+	mmu_spte_walk(vcpu, audit_spte);
+}
+
 static void kvm_mmu_audit(void *ignore, struct kvm_vcpu *vcpu, int audit_point)
 {
 	audit_msg = audit_point_name[audit_point];
 	audit_all_active_sps(vcpu->kvm);
-	if (strcmp("pre pte write", audit_msg) != 0)
-		audit_mappings(vcpu);
-	audit_sptes_have_rmaps(vcpu);
+	audit_vcpu_spte(vcpu);
 }
 
 static bool mmu_audit;
-- 
1.7.0.4


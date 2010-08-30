Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab0H3KUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 06:20:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53347 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754883Ab0H3KUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 06:20:49 -0400
Message-ID: <4C7B86FF.1000805@cn.fujitsu.com>
Date: Mon, 30 Aug 2010 18:25:03 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 3/5] KVM: MMU: improve active sp audit
References: <4C78FA00.8090606@cn.fujitsu.com> <4C7B867D.9080500@cn.fujitsu.com>
In-Reply-To: <4C7B867D.9080500@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both audit_rmap() and audit_write_protection() need to walk all active sp, so we can do
these checking in a sp walking

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu_audit.c |   74 +++++++++++++++++++++++----------------------
 1 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index fb8a461..8becb86 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -65,6 +65,16 @@ static void mmu_spte_walk(struct kvm_vcpu *vcpu, inspect_spte_fn fn)
 	return;
 }
 
+typedef void (*sp_handler) (struct kvm *kvm, struct kvm_mmu_page *sp);
+
+static void walk_all_active_sps(struct kvm *kvm, sp_handler fn)
+{
+	struct kvm_mmu_page *sp;
+
+	list_for_each_entry(sp, &kvm->arch.active_mmu_pages, link)
+		fn(kvm, sp);
+}
+
 static void audit_mappings_page(struct kvm_vcpu *vcpu, u64 page_pte,
 				gva_t va, int level)
 {
@@ -175,67 +185,59 @@ void audit_sptes_have_rmaps(struct kvm_vcpu *vcpu)
 	mmu_spte_walk(vcpu, inspect_spte_has_rmap);
 }
 
-static void check_mappings_rmap(struct kvm_vcpu *vcpu)
+static void check_mappings_rmap(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	struct kvm_mmu_page *sp;
 	int i;
 
-	list_for_each_entry(sp, &vcpu->kvm->arch.active_mmu_pages, link) {
-		u64 *pt = sp->spt;
+	if (sp->role.level != PT_PAGE_TABLE_LEVEL)
+		return;
 
-		if (sp->role.level != PT_PAGE_TABLE_LEVEL)
+	for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
+		if (!is_rmap_spte(sp->spt[i]))
 			continue;
 
-		for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
-			if (!is_rmap_spte(pt[i]))
-				continue;
-
-			inspect_spte_has_rmap(vcpu->kvm, &pt[i]);
-		}
+		inspect_spte_has_rmap(kvm, sp->spt + i);
 	}
-	return;
 }
 
-static void audit_rmap(struct kvm_vcpu *vcpu)
+void audit_write_protection(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	check_mappings_rmap(vcpu);
-}
-
-static void audit_write_protection(struct kvm_vcpu *vcpu)
-{
-	struct kvm_mmu_page *sp;
 	struct kvm_memory_slot *slot;
 	unsigned long *rmapp;
 	u64 *spte;
 
-	list_for_each_entry(sp, &vcpu->kvm->arch.active_mmu_pages, link) {
-		if (sp->role.direct)
-			continue;
-		if (sp->unsync)
-			continue;
-		if (sp->role.invalid)
-			continue;
+	if (sp->role.direct || sp->unsync || sp->role.invalid)
+		return;
 
-		slot = gfn_to_memslot(vcpu->kvm, sp->gfn);
-		rmapp = &slot->rmap[sp->gfn - slot->base_gfn];
+	slot = gfn_to_memslot(kvm, sp->gfn);
+	rmapp = &slot->rmap[sp->gfn - slot->base_gfn];
 
-		spte = rmap_next(vcpu->kvm, rmapp, NULL);
-		while (spte) {
-			if (is_writable_pte(*spte))
-				printk(KERN_ERR "%s: (%s) shadow page has "
+	spte = rmap_next(kvm, rmapp, NULL);
+	while (spte) {
+		if (is_writable_pte(*spte))
+			printk(KERN_ERR "%s: (%s) shadow page has "
 				"writable mappings: gfn %llx role %x\n",
 			       __func__, audit_msg, sp->gfn,
 			       sp->role.word);
-			spte = rmap_next(vcpu->kvm, rmapp, spte);
-		}
+		spte = rmap_next(kvm, rmapp, spte);
 	}
 }
 
+static void audit_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	check_mappings_rmap(kvm, sp);
+	audit_write_protection(kvm, sp);
+}
+
+static void audit_all_active_sps(struct kvm *kvm)
+{
+	walk_all_active_sps(kvm, audit_sp);
+}
+
 static void kvm_mmu_audit(void *ignore, struct kvm_vcpu *vcpu, int audit_point)
 {
 	audit_msg = audit_point_name[audit_point];
-	audit_rmap(vcpu);
-	audit_write_protection(vcpu);
+	audit_all_active_sps(vcpu->kvm);
 	if (strcmp("pre pte write", audit_msg) != 0)
 		audit_mappings(vcpu);
 	audit_sptes_have_rmaps(vcpu);
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052Ab0I0KDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:03:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64410 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932188Ab0I0KDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:03:33 -0400
Message-ID: <4CA06CFF.6090105@cn.fujitsu.com>
Date: Mon, 27 Sep 2010 18:07:59 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 6/7] KVM: MMU: audit: introduce audit_printk to cleanup audit
 code
References: <4CA06BA4.4090303@cn.fujitsu.com>
In-Reply-To: <4CA06BA4.4090303@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce audit_printk, and record audit point instead audit name

Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu_audit.c |   42 ++++++++++++++++++------------------------
 1 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index dcca3e7..66219af 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -19,7 +19,11 @@
 
 #include <linux/ratelimit.h>
 
-static const char *audit_msg;
+static int audit_point;
+
+#define audit_printk(fmt, args...)		\
+	printk(KERN_ERR "audit: (%s) error: "	\
+		fmt, audit_point_name[audit_point], ##args)
 
 typedef void (*inspect_spte_fn) (struct kvm_vcpu *vcpu, u64 *sptep, int level);
 
@@ -93,21 +97,18 @@ static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 
 	if (sp->unsync) {
 		if (level != PT_PAGE_TABLE_LEVEL) {
-			printk(KERN_ERR "audit: (%s) error: unsync sp: %p level = %d\n",
-				audit_msg, sp, level);
+			audit_printk("unsync sp: %p level = %d\n", sp, level);
 			return;
 		}
 
 		if (*sptep == shadow_notrap_nonpresent_pte) {
-			printk(KERN_ERR "audit: (%s) error: notrap spte in unsync sp: %p\n",
-				audit_msg, sp);
+			audit_printk("notrap spte in unsync sp: %p\n", sp);
 			return;
 		}
 	}
 
 	if (sp->role.direct && *sptep == shadow_notrap_nonpresent_pte) {
-		printk(KERN_ERR "audit: (%s) error: notrap spte in direct sp: %p\n",
-			audit_msg, sp);
+		audit_printk("notrap spte in direct sp: %p\n", sp);
 		return;
 	}
 
@@ -124,10 +125,8 @@ static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 
 	hpa =  pfn << PAGE_SHIFT;
 	if ((*sptep & PT64_BASE_ADDR_MASK) != hpa)
-		printk(KERN_ERR "xx audit error: (%s) levels %d"
-				   "pfn %llx hpa %llx ent %llxn",
-				   audit_msg, vcpu->arch.mmu.root_level,
-				   pfn, hpa, *sptep);
+		audit_printk("levels %d pfn %llx hpa %llx ent %llxn",
+				   vcpu->arch.mmu.root_level, pfn, hpa, *sptep);
 }
 
 static void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
@@ -143,11 +142,9 @@ static void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
 	if (!gfn_to_memslot(kvm, gfn)) {
 		if (!printk_ratelimit())
 			return;
-		printk(KERN_ERR "%s: no memslot for gfn %llx\n",
-				 audit_msg, gfn);
-		printk(KERN_ERR "%s: index %ld of sp (gfn=%llx)\n",
-		       audit_msg, (long int)(sptep - rev_sp->spt),
-				rev_sp->gfn);
+		audit_printk("no memslot for gfn %llx\n", gfn);
+		audit_printk("index %ld of sp (gfn=%llx)\n",
+		       (long int)(sptep - rev_sp->spt), rev_sp->gfn);
 		dump_stack();
 		return;
 	}
@@ -156,8 +153,7 @@ static void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
 	if (!*rmapp) {
 		if (!printk_ratelimit())
 			return;
-		printk(KERN_ERR "%s: no rmap for writable spte %llx\n",
-				 audit_msg, *sptep);
+		audit_printk("no rmap for writable spte %llx\n", *sptep);
 		dump_stack();
 	}
 }
@@ -198,10 +194,8 @@ void audit_write_protection(struct kvm *kvm, struct kvm_mmu_page *sp)
 	spte = rmap_next(kvm, rmapp, NULL);
 	while (spte) {
 		if (is_writable_pte(*spte))
-			printk(KERN_ERR "%s: (%s) shadow page has "
-				"writable mappings: gfn %llx role %x\n",
-			       __func__, audit_msg, sp->gfn,
-			       sp->role.word);
+			audit_printk("shadow page has writable mappings: gfn "
+				     "%llx role %x\n", sp->gfn, sp->role.word);
 		spte = rmap_next(kvm, rmapp, spte);
 	}
 }
@@ -228,14 +222,14 @@ static void audit_vcpu_spte(struct kvm_vcpu *vcpu)
 	mmu_spte_walk(vcpu, audit_spte);
 }
 
-static void kvm_mmu_audit(void *ignore, struct kvm_vcpu *vcpu, int audit_point)
+static void kvm_mmu_audit(void *ignore, struct kvm_vcpu *vcpu, int point)
 {
 	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 10);
 
 	if (!__ratelimit(&ratelimit_state))
 		return;
 
-	audit_msg = audit_point_name[audit_point];
+	audit_point = point;
 	audit_all_active_sps(vcpu->kvm);
 	audit_vcpu_spte(vcpu);
 }
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab0H1LQs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 07:16:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62525 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab0H1LQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 07:16:47 -0400
Message-ID: <4C78F10F.5010603@cn.fujitsu.com>
Date: Sat, 28 Aug 2010 19:20:47 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/5] KVM: MMU: check rmap for every spte
References: <4C78F07E.1040709@cn.fujitsu.com>
In-Reply-To: <4C78F07E.1040709@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The read-only spte also has reverse mapping, so fix the code to check them,
also modify the function name to fit its doing

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   57 +++++++++++++++++++++++----------------------------
 1 files changed, 26 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 59bf1d9..1c784b9 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3644,40 +3644,38 @@ void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
 	struct kvm_mmu_page *rev_sp;
 	gfn_t gfn;
 
-	if (is_writable_pte(*sptep)) {
-		rev_sp = page_header(__pa(sptep));
-		gfn = kvm_mmu_page_get_gfn(rev_sp, sptep - rev_sp->spt);
 
-		if (!gfn_to_memslot(kvm, gfn)) {
-			if (!printk_ratelimit())
-				return;
-			printk(KERN_ERR "%s: no memslot for gfn %llx\n",
-					 audit_msg, gfn);
-			printk(KERN_ERR "%s: index %ld of sp (gfn=%llx)\n",
-			       audit_msg, (long int)(sptep - rev_sp->spt),
-					rev_sp->gfn);
-			dump_stack();
-			return;
-		}
+	rev_sp = page_header(__pa(sptep));
+	gfn = kvm_mmu_page_get_gfn(rev_sp, sptep - rev_sp->spt);
 
-		rmapp = gfn_to_rmap(kvm, gfn, rev_sp->role.level);
-		if (!*rmapp) {
-			if (!printk_ratelimit())
-				return;
-			printk(KERN_ERR "%s: no rmap for writable spte %llx\n",
-					 audit_msg, *sptep);
-			dump_stack();
-		}
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
 	}
 
+	rmapp = gfn_to_rmap(kvm, gfn, rev_sp->role.level);
+	if (!*rmapp) {
+		if (!printk_ratelimit())
+			return;
+		printk(KERN_ERR "%s: no rmap for writable spte %llx\n",
+				 audit_msg, *sptep);
+		dump_stack();
+	}
 }
 
-void audit_writable_sptes_have_rmaps(struct kvm_vcpu *vcpu)
+void audit_sptes_have_rmaps(struct kvm_vcpu *vcpu)
 {
 	mmu_spte_walk(vcpu, inspect_spte_has_rmap);
 }
 
-static void check_writable_mappings_rmap(struct kvm_vcpu *vcpu)
+static void check_mappings_rmap(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_page *sp;
 	int i;
@@ -3689,12 +3687,9 @@ static void check_writable_mappings_rmap(struct kvm_vcpu *vcpu)
 			continue;
 
 		for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
-			u64 ent = pt[i];
-
-			if (!(ent & PT_PRESENT_MASK))
-				continue;
-			if (!is_writable_pte(ent))
+			if (!is_rmap_spte(pt[i]))
 				continue;
+
 			inspect_spte_has_rmap(vcpu->kvm, &pt[i]);
 		}
 	}
@@ -3703,7 +3698,7 @@ static void check_writable_mappings_rmap(struct kvm_vcpu *vcpu)
 
 static void audit_rmap(struct kvm_vcpu *vcpu)
 {
-	check_writable_mappings_rmap(vcpu);
+	check_mappings_rmap(vcpu);
 	count_rmaps(vcpu);
 }
 
@@ -3746,7 +3741,7 @@ static void kvm_mmu_audit(struct kvm_vcpu *vcpu, const char *msg)
 	audit_write_protection(vcpu);
 	if (strcmp("pre pte write", audit_msg) != 0)
 		audit_mappings(vcpu);
-	audit_writable_sptes_have_rmaps(vcpu);
+	audit_sptes_have_rmaps(vcpu);
 	dbg = olddbg;
 }
 
-- 
1.7.0.4


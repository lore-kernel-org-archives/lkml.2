Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab0FOCt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 22:49:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57466 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756615Ab0FOCty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 22:49:54 -0400
Message-ID: <4C16E97B.9000801@cn.fujitsu.com>
Date: Tue, 15 Jun 2010 10:46:19 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 1/6] KVM: MMU: fix gfn got in kvm_mmu_page_get_gfn()
References: <4C16E6ED.7020009@cn.fujitsu.com>
In-Reply-To: <4C16E6ED.7020009@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm_mmu_page_get_gfn() should return the unalias gfn not mapping gfn

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 56cbe45..734b106 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -397,18 +397,23 @@ static void mmu_free_rmap_desc(struct kvm_rmap_desc *rd)
 	kmem_cache_free(rmap_desc_cache, rd);
 }
 
-static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
+static gfn_t kvm_mmu_page_get_gfn(struct kvm *kvm, struct kvm_mmu_page *sp,
+				  int index)
 {
+	gfn_t gfn;
+
 	if (!sp->role.direct)
 		return sp->gfns[index];
+	gfn = sp->gfn + (index << ((sp->role.level - 1) * PT64_LEVEL_BITS));
 
-	return sp->gfn + (index << ((sp->role.level - 1) * PT64_LEVEL_BITS));
+	return unalias_gfn(kvm, gfn);
 }
 
-static void kvm_mmu_page_set_gfn(struct kvm_mmu_page *sp, int index, gfn_t gfn)
+static void kvm_mmu_page_set_gfn(struct kvm *kvm, struct kvm_mmu_page *sp,
+				 int index, gfn_t gfn)
 {
 	if (sp->role.direct)
-		BUG_ON(gfn != kvm_mmu_page_get_gfn(sp, index));
+		BUG_ON(gfn != kvm_mmu_page_get_gfn(kvm, sp, index));
 	else
 		sp->gfns[index] = gfn;
 }
@@ -563,7 +568,7 @@ static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 		return count;
 	gfn = unalias_gfn(vcpu->kvm, gfn);
 	sp = page_header(__pa(spte));
-	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
+	kvm_mmu_page_set_gfn(vcpu->kvm, sp, spte - sp->spt, gfn);
 	rmapp = gfn_to_rmap(vcpu->kvm, gfn, sp->role.level);
 	if (!*rmapp) {
 		rmap_printk("rmap_add: %p %llx 0->1\n", spte, *spte);
@@ -633,7 +638,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 		kvm_set_pfn_accessed(pfn);
 	if (is_writable_pte(*spte))
 		kvm_set_pfn_dirty(pfn);
-	gfn = kvm_mmu_page_get_gfn(sp, spte - sp->spt);
+	gfn = kvm_mmu_page_get_gfn(kvm, sp, spte - sp->spt);
 	rmapp = gfn_to_rmap(kvm, gfn, sp->role.level);
 	if (!*rmapp) {
 		printk(KERN_ERR "rmap_remove: %p %llx 0->BUG\n", spte, *spte);
@@ -3460,7 +3465,7 @@ void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
 
 	if (is_writable_pte(*sptep)) {
 		rev_sp = page_header(__pa(sptep));
-		gfn = kvm_mmu_page_get_gfn(rev_sp, sptep - rev_sp->spt);
+		gfn = kvm_mmu_page_get_gfn(kvm, rev_sp, sptep - rev_sp->spt);
 
 		if (!gfn_to_memslot(kvm, gfn)) {
 			if (!printk_ratelimit())
-- 
1.6.1.2




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab0H1LPw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 07:15:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53401 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab0H1LPu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 07:15:50 -0400
Message-ID: <4C78F0CE.9050900@cn.fujitsu.com>
Date: Sat, 28 Aug 2010 19:19:42 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/5] KVM: MMU: fix compile warning in audit code
References: <4C78F07E.1040709@cn.fujitsu.com>
In-Reply-To: <4C78F07E.1040709@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix:

arch/x86/kvm/mmu.c: In function ‘kvm_mmu_unprotect_page’:
arch/x86/kvm/mmu.c:1741: warning: format ‘%lx’ expects type ‘long unsigned int’, but argument 3 has type ‘gfn_t’
arch/x86/kvm/mmu.c:1745: warning: format ‘%lx’ expects type ‘long unsigned int’, but argument 3 has type ‘gfn_t’
arch/x86/kvm/mmu.c: In function ‘mmu_unshadow’:
arch/x86/kvm/mmu.c:1761: warning: format ‘%lx’ expects type ‘long unsigned int’, but argument 3 has type ‘gfn_t’
arch/x86/kvm/mmu.c: In function ‘set_spte’:
arch/x86/kvm/mmu.c:2005: warning: format ‘%lx’ expects type ‘long unsigned int’, but argument 3 has type ‘gfn_t’
arch/x86/kvm/mmu.c: In function ‘mmu_set_spte’:
arch/x86/kvm/mmu.c:2033: warning: format ‘%lx’ expects type ‘long unsigned int’, but argument 7 has type ‘gfn_t’

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b0037a7..59bf1d9 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1738,11 +1738,11 @@ static int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 	LIST_HEAD(invalid_list);
 	int r;
 
-	pgprintk("%s: looking for gfn %lx\n", __func__, gfn);
+	pgprintk("%s: looking for gfn %llx\n", __func__, gfn);
 	r = 0;
 
 	for_each_gfn_indirect_valid_sp(kvm, sp, gfn, node) {
-		pgprintk("%s: gfn %lx role %x\n", __func__, gfn,
+		pgprintk("%s: gfn %llx role %x\n", __func__, gfn,
 			 sp->role.word);
 		r = 1;
 		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
@@ -1758,7 +1758,7 @@ static void mmu_unshadow(struct kvm *kvm, gfn_t gfn)
 	LIST_HEAD(invalid_list);
 
 	for_each_gfn_indirect_valid_sp(kvm, sp, gfn, node) {
-		pgprintk("%s: zap %lx %x\n",
+		pgprintk("%s: zap %llx %x\n",
 			 __func__, gfn, sp->role.word);
 		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 	}
@@ -2002,7 +2002,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			goto set_pte;
 
 		if (mmu_need_write_protect(vcpu, gfn, can_unsync)) {
-			pgprintk("%s: found shadow page for %lx, marking ro\n",
+			pgprintk("%s: found shadow page for %llx, marking ro\n",
 				 __func__, gfn);
 			ret = 1;
 			pte_access &= ~ACC_WRITE_MASK;
@@ -2031,7 +2031,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	int rmap_count;
 
 	pgprintk("%s: spte %llx access %x write_fault %d"
-		 " user_fault %d gfn %lx\n",
+		 " user_fault %d gfn %llx\n",
 		 __func__, *sptep, pt_access,
 		 write_fault, user_fault, gfn);
 
@@ -2050,7 +2050,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			__set_spte(sptep, shadow_trap_nonpresent_pte);
 			kvm_flush_remote_tlbs(vcpu->kvm);
 		} else if (pfn != spte_to_pfn(*sptep)) {
-			pgprintk("hfn old %lx new %lx\n",
+			pgprintk("hfn old %llx new %llx\n",
 				 spte_to_pfn(*sptep), pfn);
 			drop_spte(vcpu->kvm, sptep, shadow_trap_nonpresent_pte);
 			kvm_flush_remote_tlbs(vcpu->kvm);
@@ -2067,7 +2067,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	}
 
 	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
-	pgprintk("instantiating %s PTE (%s) at %ld (%llx) addr %p\n",
+	pgprintk("instantiating %s PTE (%s) at %llx (%llx) addr %p\n",
 		 is_large_pte(*sptep)? "2MB" : "4kB",
 		 *sptep & PT_PRESENT_MASK ?"RW":"R", gfn,
 		 *sptep, sptep);
@@ -3651,9 +3651,9 @@ void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
 		if (!gfn_to_memslot(kvm, gfn)) {
 			if (!printk_ratelimit())
 				return;
-			printk(KERN_ERR "%s: no memslot for gfn %ld\n",
+			printk(KERN_ERR "%s: no memslot for gfn %llx\n",
 					 audit_msg, gfn);
-			printk(KERN_ERR "%s: index %ld of sp (gfn=%lx)\n",
+			printk(KERN_ERR "%s: index %ld of sp (gfn=%llx)\n",
 			       audit_msg, (long int)(sptep - rev_sp->spt),
 					rev_sp->gfn);
 			dump_stack();
@@ -3728,7 +3728,7 @@ static void audit_write_protection(struct kvm_vcpu *vcpu)
 		while (spte) {
 			if (is_writable_pte(*spte))
 				printk(KERN_ERR "%s: (%s) shadow page has "
-				"writable mappings: gfn %lx role %x\n",
+				"writable mappings: gfn %llx role %x\n",
 			       __func__, audit_msg, sp->gfn,
 			       sp->role.word);
 			spte = rmap_next(vcpu->kvm, rmapp, spte);
-- 
1.7.0.4


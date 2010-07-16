Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935505Ab0GPDX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 23:23:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49892 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935392Ab0GPDXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 23:23:55 -0400
Message-ID: <4C3FCFD7.5070005@cn.fujitsu.com>
Date: Fri, 16 Jul 2010 11:19:51 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: [PATCH v2 1/6] KVM: MMU: fix forgot reserved bits check in speculative
 path
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the speculative path, we should check guest pte's reserved bits just as
the real processor does

Reported-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |    9 ++++++++-
 arch/x86/kvm/paging_tmpl.h |    5 +++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d16efbe..1a4b42e 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2693,6 +2693,9 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
 		return;
         }
 
+	if (is_rsvd_bits_set(vcpu, *(u64 *)new, PT_PAGE_TABLE_LEVEL))
+		return;
+
 	++vcpu->kvm->stat.mmu_pte_updated;
 	if (!sp->role.cr4_pae)
 		paging32_update_pte(vcpu, sp, spte, new);
@@ -2771,6 +2774,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		       bool guest_initiated)
 {
 	gfn_t gfn = gpa >> PAGE_SHIFT;
+	union kvm_mmu_page_role mask = { .word = 0 };
 	struct kvm_mmu_page *sp;
 	struct hlist_node *node;
 	LIST_HEAD(invalid_list);
@@ -2845,6 +2849,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		}
 	}
 
+	mask.cr0_wp = mask.cr4_pae = mask.nxe = 1;
 	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn, node) {
 		pte_size = sp->role.cr4_pae ? 8 : 4;
 		misaligned = (offset ^ (offset + bytes - 1)) & ~(pte_size - 1);
@@ -2892,7 +2897,9 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		while (npte--) {
 			entry = *spte;
 			mmu_pte_write_zap_pte(vcpu, sp, spte);
-			if (gentry)
+			if (gentry &&
+			      !(sp->role.word ^ vcpu->arch.mmu.base_role.word)
+			      & mask.word)
 				mmu_pte_write_new_pte(vcpu, sp, spte, &gentry);
 			if (!remote_flush && need_remote_flush(entry, *spte))
 				remote_flush = true;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index a09e04c..231fce1 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -638,8 +638,9 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			return -EINVAL;
 
 		gfn = gpte_to_gfn(gpte);
-		if (gfn != sp->gfns[i] ||
-		      !is_present_gpte(gpte) || !(gpte & PT_ACCESSED_MASK)) {
+		if (is_rsvd_bits_set(vcpu, gpte, PT_PAGE_TABLE_LEVEL)
+		      || gfn != sp->gfns[i] || !is_present_gpte(gpte)
+		      || !(gpte & PT_ACCESSED_MASK)) {
 			u64 nonpresent;
 
 			if (is_present_gpte(gpte) || !clear_unsync)
-- 
1.6.1.2


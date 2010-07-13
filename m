Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab0GMJqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 05:46:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56647 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab0GMJqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 05:46:48 -0400
Message-ID: <4C3C3518.7080505@cn.fujitsu.com>
Date: Tue, 13 Jul 2010 17:42:48 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 1/4] KVM: MMU: fix forgot reserved bits check in speculative
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
 arch/x86/kvm/mmu.c         |    8 ++++++++
 arch/x86/kvm/paging_tmpl.h |    5 +++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b93b94f..9fc1524 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2783,6 +2783,9 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		break;
 	}
 
+	if (is_rsvd_bits_set(vcpu, gentry, PT_PAGE_TABLE_LEVEL))
+		gentry = 0;
+
 	mmu_guess_page_from_pte_write(vcpu, gpa, gentry);
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) != invlpg_counter)
@@ -2851,6 +2854,11 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		while (npte--) {
 			entry = *spte;
 			mmu_pte_write_zap_pte(vcpu, sp, spte);
+
+			if (!!is_pae(vcpu) != sp->role.cr4_pae ||
+			      is_nx(vcpu) != sp->role.nxe)
+				continue;
+
 			if (gentry)
 				mmu_pte_write_new_pte(vcpu, sp, spte, &gentry);
 			if (!remote_flush && need_remote_flush(entry, *spte))
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 6daeacf..d32484f 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -640,8 +640,9 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			return -EINVAL;
 
 		gfn = gpte_to_gfn(gpte);
-		if (gfn != sp->gfns[i] ||
-		      !is_present_gpte(gpte) || !(gpte & PT_ACCESSED_MASK)) {
+		if (is_rsvd_bits_set(vcpu, gpte, PT_PAGE_TABLE_LEVEL) ||
+		      gfn != sp->gfns[i] || !is_present_gpte(gpte) ||
+		      !(gpte & PT_ACCESSED_MASK)) {
 			u64 nonpresent;
 
 			if (is_present_gpte(gpte) || !clear_unsync)
-- 
1.6.1.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827Ab0KQEIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:08:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50874 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932681Ab0KQEIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:08:21 -0500
Message-ID: <4CE35636.4040501@cn.fujitsu.com>
Date: Wed, 17 Nov 2010 12:12:38 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH v2 4/6] KVM: MMU: rename 'reset_host_protection' to 'host_writable'
References: <4CE355A0.6020907@cn.fujitsu.com>
In-Reply-To: <4CE355A0.6020907@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-17 12:08:42,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-17 12:08:43,
	Serialize complete at 2010-11-17 12:08:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Rename it to fix the sense better 

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |    8 ++++----
 arch/x86/kvm/paging_tmpl.h |   10 +++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9bad960..c4531a3 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1964,7 +1964,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		    unsigned pte_access, int user_fault,
 		    int write_fault, int dirty, int level,
 		    gfn_t gfn, pfn_t pfn, bool speculative,
-		    bool can_unsync, bool reset_host_protection)
+		    bool can_unsync, bool host_writable)
 {
 	u64 spte, entry = *sptep;
 	int ret = 0;
@@ -1991,7 +1991,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		spte |= kvm_x86_ops->get_mt_mask(vcpu, gfn,
 			kvm_is_mmio_pfn(pfn));
 
-	if (reset_host_protection)
+	if (host_writable)
 		spte |= SPTE_HOST_WRITEABLE;
 
 	spte |= (u64)pfn << PAGE_SHIFT;
@@ -2056,7 +2056,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			 int user_fault, int write_fault, int dirty,
 			 int *ptwrite, int level, gfn_t gfn,
 			 pfn_t pfn, bool speculative,
-			 bool reset_host_protection)
+			 bool host_writable)
 {
 	int was_rmapped = 0;
 	int rmap_count;
@@ -2091,7 +2091,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	if (set_spte(vcpu, sptep, pte_access, user_fault, write_fault,
 		      dirty, level, gfn, pfn, speculative, true,
-		      reset_host_protection)) {
+		      host_writable)) {
 		if (write_fault)
 			*ptwrite = 1;
 		kvm_mmu_flush_tlb(vcpu);
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index ca0e5e8..57619ed 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -329,7 +329,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		return;
 	kvm_get_pfn(pfn);
 	/*
-	 * we call mmu_set_spte() with reset_host_protection = true beacuse that
+	 * we call mmu_set_spte() with host_writable = true beacuse that
 	 * vcpu->arch.update_pte.pfn was fetched from get_user_pages(write = 1).
 	 */
 	mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
@@ -744,7 +744,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			    bool clear_unsync)
 {
 	int i, offset, nr_present;
-	bool reset_host_protection;
+	bool host_writable;
 	gpa_t first_pte_gpa;
 
 	offset = nr_present = 0;
@@ -794,14 +794,14 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
 		if (!(sp->spt[i] & SPTE_HOST_WRITEABLE)) {
 			pte_access &= ~ACC_WRITE_MASK;
-			reset_host_protection = 0;
+			host_writable = 0;
 		} else {
-			reset_host_protection = 1;
+			host_writable = 1;
 		}
 		set_spte(vcpu, &sp->spt[i], pte_access, 0, 0,
 			 is_dirty_gpte(gpte), PT_PAGE_TABLE_LEVEL, gfn,
 			 spte_to_pfn(sp->spt[i]), true, false,
-			 reset_host_protection);
+			 host_writable);
 	}
 
 	return !nr_present;
-- 
1.7.0.4


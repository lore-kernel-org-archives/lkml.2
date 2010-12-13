Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab0LMK0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 05:26:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49210 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753200Ab0LMK0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 05:26:48 -0500
Message-ID: <4D05F5F6.3070909@cn.fujitsu.com>
Date: Mon, 13 Dec 2010 18:31:18 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/2] KVM: MMU: don't make direct sp read-only if !map_writable
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-13 18:26:47,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-13 18:26:47,
	Serialize complete at 2010-12-13 18:26:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if the page is not allowed to write, then it can drop
ACC_WRITE_MASK in pte_access, and the direct sp's access is:
	gw->pt_access & gw->pte_access
so, it also removes the write access in the direct sp. 

There is a problem: if the access of those pages which map thought the same
mapping in guest is different in host, it causes host switch direct sp very
frequently.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |    4 ++--
 arch/x86/kvm/paging_tmpl.h |   11 ++---------
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1a953ac..0c5cad0 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1987,6 +1987,8 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	if (host_writable)
 		spte |= SPTE_HOST_WRITEABLE;
+	else
+		pte_access &= ~ACC_WRITE_MASK;
 
 	spte |= (u64)pfn << PAGE_SHIFT;
 
@@ -2226,8 +2228,6 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 		if (iterator.level == level) {
 			unsigned pte_access = ACC_ALL;
 
-			if (!map_writable)
-				pte_access &= ~ACC_WRITE_MASK;
 			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL, pte_access,
 				     0, write, 1, &pt_write,
 				     level, gfn, pfn, prefault, map_writable);
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 146b681..6ed2c5e 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -593,9 +593,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 	if (is_error_pfn(pfn))
 		return kvm_handle_bad_page(vcpu->kvm, walker.gfn, pfn);
 
-	if (!map_writable)
-		walker.pte_access &= ~ACC_WRITE_MASK;
-
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu, mmu_seq))
 		goto out_unlock;
@@ -809,12 +806,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 
 		nr_present++;
 		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
-		if (!(sp->spt[i] & SPTE_HOST_WRITEABLE)) {
-			pte_access &= ~ACC_WRITE_MASK;
-			host_writable = 0;
-		} else {
-			host_writable = 1;
-		}
+		host_writable = !!(sp->spt[i] & SPTE_HOST_WRITEABLE);
+
 		set_spte(vcpu, &sp->spt[i], pte_access, 0, 0,
 			 is_dirty_gpte(gpte), PT_PAGE_TABLE_LEVEL, gfn,
 			 spte_to_pfn(sp->spt[i]), true, false,
-- 
1.7.0.4

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab0LWIFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 03:05:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63272 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab0LWIFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 03:05:24 -0500
Message-ID: <4D1303B9.3080801@cn.fujitsu.com>
Date: Thu, 23 Dec 2010 16:09:29 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] KVM: MMU: handle 'map_writable' in set_spte() function
References: <4D130383.30406@cn.fujitsu.com>
In-Reply-To: <4D130383.30406@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-23 16:05:08,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-23 16:05:10,
	Serialize complete at 2010-12-23 16:05:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the operation of 'writable' to set_spte() to clean up code

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |    4 ++--
 arch/x86/kvm/paging_tmpl.h |   11 ++---------
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4e49e24..4a8df5f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1983,6 +1983,8 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	if (host_writable)
 		spte |= SPTE_HOST_WRITEABLE;
+	else
+		pte_access &= ~ACC_WRITE_MASK;
 
 	spte |= (u64)pfn << PAGE_SHIFT;
 
@@ -2222,8 +2224,6 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 		if (iterator.level == level) {
 			unsigned pte_access = ACC_ALL;
 
-			if (!map_writable)
-				pte_access &= ~ACC_WRITE_MASK;
 			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL, pte_access,
 				     0, write, 1, &pt_write,
 				     level, gfn, pfn, prefault, map_writable);
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 5ca9426..6ed2c5e 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -511,9 +511,6 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		link_shadow_page(it.sptep, sp);
 	}
 
-	if (!map_writable)
-		access &= ~ACC_WRITE_MASK;
-
 	mmu_set_spte(vcpu, it.sptep, access, gw->pte_access & access,
 		     user_fault, write_fault, dirty, ptwrite, it.level,
 		     gw->gfn, pfn, prefault, map_writable);
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


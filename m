Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810Ab2C2JXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:23:05 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:34321 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab2C2JW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:22:59 -0400
Message-ID: <4F7429E7.3010801@linux.vnet.ibm.com>
Date: Thu, 29 Mar 2012 17:22:47 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 04/13] KVM: MMU: introduce FNAME(get_sp_gpa)
References: <4F742951.7080003@linux.vnet.ibm.com>
In-Reply-To: <4F742951.7080003@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12032909-5564-0000-0000-000002034C30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It can calculate the base gpa of the specified shadow page on any level,
let it instead of FNAME(get_level1_sp_gpa)

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/paging_tmpl.h |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index b9fd1c4..f0fbde3 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -558,6 +558,16 @@ out_gpte_changed:
 	return NULL;
 }

+static gpa_t FNAME(get_sp_gpa)(struct kvm_mmu_page *sp)
+{
+	int offset, shift;
+
+	shift = PAGE_SHIFT - (PT_LEVEL_BITS - PT64_LEVEL_BITS) * sp->role.level;
+	offset = sp->role.quadrant << shift;
+
+	return gfn_to_gpa(sp->gfn) + offset;
+}
+
 /*
  * Page fault handler.  There are several causes for a page fault:
  *   - there is no shadow pte for the guest pte
@@ -659,18 +669,6 @@ out_unlock:
 	return 0;
 }

-static gpa_t FNAME(get_level1_sp_gpa)(struct kvm_mmu_page *sp)
-{
-	int offset = 0;
-
-	WARN_ON(sp->role.level != 1);
-
-	if (PTTYPE == 32)
-		offset = sp->role.quadrant << PT64_LEVEL_BITS;
-
-	return gfn_to_gpa(sp->gfn) + offset * sizeof(pt_element_t);
-}
-
 static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	struct kvm_shadow_walk_iterator iterator;
@@ -699,7 +697,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 			if (!sp->unsync)
 				break;

-			pte_gpa = FNAME(get_level1_sp_gpa)(sp);
+			pte_gpa = FNAME(get_sp_gpa)(sp);
 			pte_gpa += (sptep - sp->spt) * sizeof(pt_element_t);

 			if (mmu_page_zap_pte(vcpu->kvm, sp, sptep))
@@ -780,7 +778,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	/* direct kvm_mmu_page can not be unsync. */
 	BUG_ON(sp->role.direct);

-	first_pte_gpa = FNAME(get_level1_sp_gpa)(sp);
+	first_pte_gpa = FNAME(get_sp_gpa)(sp);

 	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
 		unsigned pte_access;
-- 
1.7.7.6


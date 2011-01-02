Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab1ABHcJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:32:09 -0500
Received: from mail.windriver.com ([147.11.1.11]:37138 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab1ABHZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:43 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 233/260] KVM: MMU: fix direct sp's access corrupted
Date: Sun,  2 Jan 2011 02:18:49 -0500
Message-Id: <1293952756-15010-234-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:25.0011 (UTC) FILETIME=[15344830:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

commit 9e7b0e7fba45ca3c6357aeb7091ebc281f1de365 upstream.

If the mapping is writable but the dirty flag is not set, we will find
the read-only direct sp and setup the mapping, then if the write #PF
occur, we will mark this mapping writable in the read-only direct sp,
now, other real read-only mapping will happily write it without #PF.

It may hurt guest's COW

Fixed by re-install the mapping when write #PF occur.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kvm/paging_tmpl.h |   28 ++++++++++++++++++++++++++--
 1 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 81eab9a..a535c87 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -318,8 +318,32 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			break;
 		}
 
-		if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep))
-			continue;
+		if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep)) {
+			struct kvm_mmu_page *child;
+			unsigned direct_access;
+
+			if (level != gw->level)
+				continue;
+
+			/*
+			 * For the direct sp, if the guest pte's dirty bit
+			 * changed form clean to dirty, it will corrupt the
+			 * sp's access: allow writable in the read-only sp,
+			 * so we should update the spte at this point to get
+			 * a new sp with the correct access.
+			 */
+			direct_access = gw->pt_access & gw->pte_access;
+			if (!is_dirty_gpte(gw->ptes[gw->level - 1]))
+				direct_access &= ~ACC_WRITE_MASK;
+
+			child = page_header(*sptep & PT64_BASE_ADDR_MASK);
+			if (child->role.access == direct_access)
+				continue;
+
+			mmu_page_remove_parent_pte(child, sptep);
+			__set_spte(sptep, shadow_trap_nonpresent_pte);
+			kvm_flush_remote_tlbs(vcpu->kvm);
+		}
 
 		if (is_large_pte(*sptep)) {
 			rmap_remove(vcpu->kvm, sptep);
-- 
1.7.3.3


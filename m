Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab0F3IHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 04:07:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51585 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751830Ab0F3IHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 04:07:15 -0400
Message-ID: <4C2AFA50.1070502@cn.fujitsu.com>
Date: Wed, 30 Jun 2010 16:03:28 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH v3 3/11] KVM: MMU: fix direct sp's access corruptted
References: <4C2AF9FA.9020601@cn.fujitsu.com>
In-Reply-To: <4C2AF9FA.9020601@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the mapping is writable but the dirty flag is not set, we will find
the read-only direct sp and setup the mapping, then if the write #PF
occur, we will mark this mapping writable in the read-only direct sp,
now, other real read-only mapping will happily write it without #PF.

It may hurt guest's COW

Fixed by re-install the mapping when write #PF occur.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |   28 ++++++++++++++++++++++++++--
 1 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 28c8493..f28f09d 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -325,8 +325,32 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
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
1.6.1.2



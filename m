Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab0IXQdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:33:54 -0400
Received: from kroah.org ([198.145.64.141]:38465 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932762Ab0IXQ2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:43 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:19 2010
Message-Id: <20100924162619.748639015@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
        mtosatti@redhat.com, Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [56/80] KVM: MMU: fix direct sps access corrupted
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/paging_tmpl.h |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -324,8 +324,32 @@ static u64 *FNAME(fetch)(struct kvm_vcpu
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



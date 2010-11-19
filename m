Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab0KSVwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:52:33 -0500
Received: from kroah.org ([198.145.64.141]:51764 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757242Ab0KSVp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:45:28 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:44:10 2010
Message-Id: <20101119214410.741293356@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:42:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [16/45] KVM: MMU: fix direct sps access corrupted
In-Reply-To: <20101119214439.GA26350@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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
@@ -318,8 +318,32 @@ static u64 *FNAME(fetch)(struct kvm_vcpu
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



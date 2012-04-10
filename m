Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab2DJQ0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 12:26:14 -0400
Received: from smtp.citrix.com ([66.165.176.89]:37184 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab2DJQZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 12:25:59 -0400
X-IronPort-AV: E=Sophos;i="4.75,399,1330923600"; 
   d="scan'208";a="24030726"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: konrad.wilk@oracle.com
CC: Stefano.Stabellini@eu.citrix.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v3 1/2] xen: enter/exit lazy_mmu_mode around m2p_override calls
Date: Tue, 10 Apr 2012 17:29:34 +0100
Message-ID: <1334075375-25442-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a significant performance improvement for the
m2p_override: about 6% using the gntdev device.

Each m2p_add/remove_override call issues a MULTI_grant_table_op and a
__flush_tlb_single if kmap_op != NULL.  Batching all the calls together
is a great performance benefit because it means issuing one hypercall
total rather than two hypercall per page.
If paravirt_lazy_mode is set PARAVIRT_LAZY_MMU, all these calls are
going to be batched together, otherwise they are issued one at a time.

Adding arch_enter_lazy_mmu_mode/arch_leave_lazy_mmu_mode around the
m2p_add/remove_override calls forces paravirt_lazy_mode to
PARAVIRT_LAZY_MMU, therefore makes sure that they are always batched.


Changes in v3:
- do not call arch_enter/leave_lazy_mmu_mode in xen_blkbk_unmap, that
can be called in interrupt context.


Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/block/xen-blkback/blkback.c |    2 ++
 drivers/xen/grant-table.c           |    8 ++++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 0088bf6..0453695 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -386,6 +386,7 @@ static int xen_blkbk_map(struct blkif_request *req,
 	 * so that when we access vaddr(pending_req,i) it has the contents of
 	 * the page from the other domain.
 	 */
+	arch_enter_lazy_mmu_mode();
 	for (i = 0; i < nseg; i++) {
 		if (unlikely(map[i].status != 0)) {
 			pr_debug(DRV_PFX "invalid buffer -- could not remap it\n");
@@ -410,6 +411,7 @@ static int xen_blkbk_map(struct blkif_request *req,
 		seg[i].buf  = map[i].dev_bus_addr |
 			(req->u.rw.seg[i].first_sect << 9);
 	}
+	arch_leave_lazy_mmu_mode();
 	return ret;
 }
 
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index b4d4eac..c7dc2d6 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -751,6 +751,8 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return ret;
 
+	arch_enter_lazy_mmu_mode();
+
 	for (i = 0; i < count; i++) {
 		/* Do not add to override if the map failed. */
 		if (map_ops[i].status)
@@ -769,6 +771,8 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 			return ret;
 	}
 
+	arch_leave_lazy_mmu_mode();
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(gnttab_map_refs);
@@ -785,12 +789,16 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return ret;
 
+	arch_enter_lazy_mmu_mode();
+
 	for (i = 0; i < count; i++) {
 		ret = m2p_remove_override(pages[i], clear_pte);
 		if (ret)
 			return ret;
 	}
 
+	arch_leave_lazy_mmu_mode();
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(gnttab_unmap_refs);
-- 
1.7.2.5


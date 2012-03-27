Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab2C0Nvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 09:51:51 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:22176 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab2C0Nvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 09:51:39 -0400
X-IronPort-AV: E=Sophos;i="4.75,326,1330923600"; 
   d="scan'208";a="187740884"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: konrad.wilk@oracle.com
CC: Stefano.Stabellini@eu.citrix.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 1/2] xen: enter/exit lazy_mmu_mode around m2p_override calls
Date: Tue, 27 Mar 2012 14:52:43 +0100
Message-ID: <1332856364-29995-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a significant performance improvement for the
m2p_override.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/block/xen-blkback/blkback.c |    4 ++++
 drivers/xen/grant-table.c           |    8 ++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 0088bf6..60abff6 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -342,6 +342,7 @@ static void xen_blkbk_unmap(struct pending_req *req)
 	 * Note, we use invcount, so nr->pages, so we can't index
 	 * using vaddr(req, i).
 	 */
+	arch_enter_lazy_mmu_mode();
 	for (i = 0; i < invcount; i++) {
 		ret = m2p_remove_override(
 			virt_to_page(unmap[i].host_addr), false);
@@ -351,6 +352,7 @@ static void xen_blkbk_unmap(struct pending_req *req)
 			continue;
 		}
 	}
+	arch_leave_lazy_mmu_mode();
 }
 
 static int xen_blkbk_map(struct blkif_request *req,
@@ -386,6 +388,7 @@ static int xen_blkbk_map(struct blkif_request *req,
 	 * so that when we access vaddr(pending_req,i) it has the contents of
 	 * the page from the other domain.
 	 */
+	arch_enter_lazy_mmu_mode();
 	for (i = 0; i < nseg; i++) {
 		if (unlikely(map[i].status != 0)) {
 			pr_debug(DRV_PFX "invalid buffer -- could not remap it\n");
@@ -410,6 +413,7 @@ static int xen_blkbk_map(struct blkif_request *req,
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


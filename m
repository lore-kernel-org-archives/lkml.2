Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab1JTKqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 06:46:15 -0400
Received: from smtp.citrix.com ([66.165.176.89]:37231 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756445Ab1JTKqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 06:46:12 -0400
X-IronPort-AV: E=Sophos;i="4.69,378,1315195200"; 
   d="scan'208";a="18393808"
From: David Vrabel <david.vrabel@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH 2/4] block: xen-blkback: use API provided by xenbus module to map rings
Date: Thu, 20 Oct 2011 11:45:17 +0100
Message-ID: <1319107519-2253-3-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1319107519-2253-1-git-send-email-david.vrabel@citrix.com>
References: <1319107519-2253-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The xenbus module provides xenbus_map_ring_valloc() and
xenbus_map_ring_vfree().  Use these to map the ring pages granted by
the frontend.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 drivers/block/xen-blkback/common.h |    5 +--
 drivers/block/xen-blkback/xenbus.c |   54 ++++-------------------------------
 2 files changed, 8 insertions(+), 51 deletions(-)

diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index 00c57c9..7ec0e88 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -139,7 +139,7 @@ struct xen_blkif {
 	/* Comms information. */
 	enum blkif_protocol	blk_protocol;
 	union blkif_back_rings	blk_rings;
-	struct vm_struct	*blk_ring_area;
+	void			*blk_ring;
 	/* The VBD attached to this interface. */
 	struct xen_vbd		vbd;
 	/* Back pointer to the backend_info. */
@@ -163,9 +163,6 @@ struct xen_blkif {
 	int			st_wr_sect;
 
 	wait_queue_head_t	waiting_to_free;
-
-	grant_handle_t		shmem_handle;
-	grant_ref_t		shmem_ref;
 };
 
 
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 5fd2010..69233dd 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -120,38 +120,6 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 	return blkif;
 }
 
-static int map_frontend_page(struct xen_blkif *blkif, unsigned long shared_page)
-{
-	struct gnttab_map_grant_ref op;
-
-	gnttab_set_map_op(&op, (unsigned long)blkif->blk_ring_area->addr,
-			  GNTMAP_host_map, shared_page, blkif->domid);
-
-	if (HYPERVISOR_grant_table_op(GNTTABOP_map_grant_ref, &op, 1))
-		BUG();
-
-	if (op.status) {
-		DPRINTK("Grant table operation failure !\n");
-		return op.status;
-	}
-
-	blkif->shmem_ref = shared_page;
-	blkif->shmem_handle = op.handle;
-
-	return 0;
-}
-
-static void unmap_frontend_page(struct xen_blkif *blkif)
-{
-	struct gnttab_unmap_grant_ref op;
-
-	gnttab_set_unmap_op(&op, (unsigned long)blkif->blk_ring_area->addr,
-			    GNTMAP_host_map, blkif->shmem_handle);
-
-	if (HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, &op, 1))
-		BUG();
-}
-
 static int xen_blkif_map(struct xen_blkif *blkif, unsigned long shared_page,
 			 unsigned int evtchn)
 {
@@ -161,35 +129,29 @@ static int xen_blkif_map(struct xen_blkif *blkif, unsigned long shared_page,
 	if (blkif->irq)
 		return 0;
 
-	blkif->blk_ring_area = alloc_vm_area(PAGE_SIZE);
-	if (!blkif->blk_ring_area)
-		return -ENOMEM;
-
-	err = map_frontend_page(blkif, shared_page);
-	if (err) {
-		free_vm_area(blkif->blk_ring_area);
+	err = xenbus_map_ring_valloc(blkif->be->dev, shared_page, &blkif->blk_ring);
+	if (err < 0)
 		return err;
-	}
 
 	switch (blkif->blk_protocol) {
 	case BLKIF_PROTOCOL_NATIVE:
 	{
 		struct blkif_sring *sring;
-		sring = (struct blkif_sring *)blkif->blk_ring_area->addr;
+		sring = (struct blkif_sring *)blkif->blk_ring;
 		BACK_RING_INIT(&blkif->blk_rings.native, sring, PAGE_SIZE);
 		break;
 	}
 	case BLKIF_PROTOCOL_X86_32:
 	{
 		struct blkif_x86_32_sring *sring_x86_32;
-		sring_x86_32 = (struct blkif_x86_32_sring *)blkif->blk_ring_area->addr;
+		sring_x86_32 = (struct blkif_x86_32_sring *)blkif->blk_ring;
 		BACK_RING_INIT(&blkif->blk_rings.x86_32, sring_x86_32, PAGE_SIZE);
 		break;
 	}
 	case BLKIF_PROTOCOL_X86_64:
 	{
 		struct blkif_x86_64_sring *sring_x86_64;
-		sring_x86_64 = (struct blkif_x86_64_sring *)blkif->blk_ring_area->addr;
+		sring_x86_64 = (struct blkif_x86_64_sring *)blkif->blk_ring;
 		BACK_RING_INIT(&blkif->blk_rings.x86_64, sring_x86_64, PAGE_SIZE);
 		break;
 	}
@@ -201,8 +163,7 @@ static int xen_blkif_map(struct xen_blkif *blkif, unsigned long shared_page,
 						    xen_blkif_be_int, 0,
 						    "blkif-backend", blkif);
 	if (err < 0) {
-		unmap_frontend_page(blkif);
-		free_vm_area(blkif->blk_ring_area);
+		xenbus_unmap_ring_vfree(blkif->be->dev, blkif->blk_ring);
 		blkif->blk_rings.common.sring = NULL;
 		return err;
 	}
@@ -228,8 +189,7 @@ static void xen_blkif_disconnect(struct xen_blkif *blkif)
 	}
 
 	if (blkif->blk_rings.common.sring) {
-		unmap_frontend_page(blkif);
-		free_vm_area(blkif->blk_ring_area);
+		xenbus_unmap_ring_vfree(blkif->be->dev, blkif->blk_ring);
 		blkif->blk_rings.common.sring = NULL;
 	}
 }
-- 
1.7.2.5


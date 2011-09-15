Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933619Ab1IOMk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:40:57 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:27875 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab1IOMky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:40:54 -0400
X-IronPort-AV: E=Sophos;i="4.68,387,1312171200"; 
   d="scan'208";a="163268205"
From: David Vrabel <david.vrabel@citrix.com>
To: xen-devel@lists.xensource.com
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org,
        "Andrew Morton" <akpm@linux-foundation.org>,
        David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 3/6] net: xen-netback: use API provided by xenbus module to map rings
Date: Thu, 15 Sep 2011 13:40:08 +0100
Message-ID: <1316090411-22608-4-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1316090411-22608-1-git-send-email-david.vrabel@citrix.com>
References: <1316090411-22608-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

The xenbus module provides xenbus_map_ring_page() and
xenbus_map_ring_page().  Use these to map the ring pages granted by
the frontend.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/net/xen-netback/common.h  |   13 +++---
 drivers/net/xen-netback/netback.c |   79 +++++++-----------------------------
 2 files changed, 23 insertions(+), 69 deletions(-)

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 161f207..05e0a8e 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -58,10 +58,6 @@ struct xenvif {
 	u8               fe_dev_addr[6];
 
 	/* Physical parameters of the comms window. */
-	grant_handle_t   tx_shmem_handle;
-	grant_ref_t      tx_shmem_ref;
-	grant_handle_t   rx_shmem_handle;
-	grant_ref_t      rx_shmem_ref;
 	unsigned int     irq;
 
 	/* List of frontends to notify after a batch of frames sent. */
@@ -70,8 +66,8 @@ struct xenvif {
 	/* The shared rings and indexes. */
 	struct xen_netif_tx_back_ring tx;
 	struct xen_netif_rx_back_ring rx;
-	struct vm_struct *tx_comms_area;
-	struct vm_struct *rx_comms_area;
+	struct page *tx_ring_page;
+	struct page *rx_ring_page;
 
 	/* Frontend feature information. */
 	u8 can_sg:1;
@@ -106,6 +102,11 @@ struct xenvif {
 	wait_queue_head_t waiting_to_free;
 };
 
+static inline struct xenbus_device *xenvif_to_xenbus_device(struct xenvif *vif)
+{
+	return to_xenbus_device(vif->dev->dev.parent);
+}
+
 #define XEN_NETIF_TX_RING_SIZE __CONST_RING_SIZE(xen_netif_tx, PAGE_SIZE)
 #define XEN_NETIF_RX_RING_SIZE __CONST_RING_SIZE(xen_netif_rx, PAGE_SIZE)
 
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index fd00f25..2a017b28 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1577,88 +1577,41 @@ static int xen_netbk_kthread(void *data)
 
 void xen_netbk_unmap_frontend_rings(struct xenvif *vif)
 {
-	struct gnttab_unmap_grant_ref op;
-
-	if (vif->tx.sring) {
-		gnttab_set_unmap_op(&op, (unsigned long)vif->tx_comms_area->addr,
-				    GNTMAP_host_map, vif->tx_shmem_handle);
-
-		if (HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, &op, 1))
-			BUG();
-	}
-
-	if (vif->rx.sring) {
-		gnttab_set_unmap_op(&op, (unsigned long)vif->rx_comms_area->addr,
-				    GNTMAP_host_map, vif->rx_shmem_handle);
-
-		if (HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, &op, 1))
-			BUG();
-	}
-	if (vif->rx_comms_area)
-		free_vm_area(vif->rx_comms_area);
-	if (vif->tx_comms_area)
-		free_vm_area(vif->tx_comms_area);
+	if (vif->tx.sring)
+		xenbus_unmap_ring_page(xenvif_to_xenbus_device(vif),
+				       vif->tx_ring_page);
+	if (vif->rx.sring)
+		xenbus_unmap_ring_page(xenvif_to_xenbus_device(vif),
+				       vif->rx_ring_page);
 }
 
 int xen_netbk_map_frontend_rings(struct xenvif *vif,
 				 grant_ref_t tx_ring_ref,
 				 grant_ref_t rx_ring_ref)
 {
-	struct gnttab_map_grant_ref op;
 	struct xen_netif_tx_sring *txs;
 	struct xen_netif_rx_sring *rxs;
 
 	int err = -ENOMEM;
 
-	vif->tx_comms_area = alloc_vm_area(PAGE_SIZE);
-	if (vif->tx_comms_area == NULL)
+	err = xenbus_map_ring_page(xenvif_to_xenbus_device(vif),
+				   tx_ring_ref, &vif->tx_ring_page);
+	if (err)
 		goto err;
 
-	vif->rx_comms_area = alloc_vm_area(PAGE_SIZE);
-	if (vif->rx_comms_area == NULL)
-		goto err;
-
-	gnttab_set_map_op(&op, (unsigned long)vif->tx_comms_area->addr,
-			  GNTMAP_host_map, tx_ring_ref, vif->domid);
-
-	if (HYPERVISOR_grant_table_op(GNTTABOP_map_grant_ref, &op, 1))
-		BUG();
-
-	if (op.status) {
-		netdev_warn(vif->dev,
-			    "failed to map tx ring. err=%d status=%d\n",
-			    err, op.status);
-		err = op.status;
-		goto err;
-	}
-
-	vif->tx_shmem_ref    = tx_ring_ref;
-	vif->tx_shmem_handle = op.handle;
-
-	txs = (struct xen_netif_tx_sring *)vif->tx_comms_area->addr;
+	txs = page_address(vif->tx_ring_page);
 	BACK_RING_INIT(&vif->tx, txs, PAGE_SIZE);
 
-	gnttab_set_map_op(&op, (unsigned long)vif->rx_comms_area->addr,
-			  GNTMAP_host_map, rx_ring_ref, vif->domid);
-
-	if (HYPERVISOR_grant_table_op(GNTTABOP_map_grant_ref, &op, 1))
-		BUG();
-
-	if (op.status) {
-		netdev_warn(vif->dev,
-			    "failed to map rx ring. err=%d status=%d\n",
-			    err, op.status);
-		err = op.status;
+	err = xenbus_map_ring_page(xenvif_to_xenbus_device(vif),
+				   rx_ring_ref, &vif->rx_ring_page);
+	if (err)
 		goto err;
-	}
-
-	vif->rx_shmem_ref     = rx_ring_ref;
-	vif->rx_shmem_handle  = op.handle;
-	vif->rx_req_cons_peek = 0;
 
-	rxs = (struct xen_netif_rx_sring *)vif->rx_comms_area->addr;
+	rxs = page_address(vif->rx_ring_page);
 	BACK_RING_INIT(&vif->rx, rxs, PAGE_SIZE);
 
+	vif->rx_req_cons_peek = 0;
+
 	return 0;
 
 err:
-- 
1.7.2.5


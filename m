Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1KHJcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 04:32:07 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53884 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266Ab1KHJcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 04:32:05 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: davem@davemloft.net, ian.campbell@citrix.com, eric.dumazet@gmail.com,
        jeffrey.t.kirsher@intel.com, jpirko@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] net/temac: FIX segfault when process old irqs
Date: Tue,  8 Nov 2011 10:31:58 +0100
Message-Id: <1320744718-10916-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not enable the irq until the scatter gather registers are ready to
handle the data. Otherwise an irq from a packet send/received before
last close can lead to an access to an invalid memory region on the irq
handler.

Also, stop the dma engine on close.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 4d1658e..c8db76a 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -203,6 +203,9 @@ static void temac_dma_bd_release(struct net_device *ndev)
 	struct temac_local *lp = netdev_priv(ndev);
 	int i;
 
+	/* Reset Local Link (DMA) */
+	lp->dma_out(lp, DMA_CONTROL_REG, DMA_CONTROL_RST);
+
 	for (i = 0; i < RX_BD_NUM; i++) {
 		if (!lp->rx_skb[i])
 			break;
@@ -860,6 +863,8 @@ static int temac_open(struct net_device *ndev)
 		phy_start(lp->phy_dev);
 	}
 
+	temac_device_reset(ndev);
+
 	rc = request_irq(lp->tx_irq, ll_temac_tx_irq, 0, ndev->name, ndev);
 	if (rc)
 		goto err_tx_irq;
@@ -867,7 +872,6 @@ static int temac_open(struct net_device *ndev)
 	if (rc)
 		goto err_rx_irq;
 
-	temac_device_reset(ndev);
 	return 0;
 
  err_rx_irq:
-- 
1.7.7.1


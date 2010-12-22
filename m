Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab0LVM6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 07:58:21 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:34653 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751531Ab0LVM6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 07:58:20 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: wg@grandegger.com, socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH] pch_can: Fix array miss-pointing issue
Date: Wed, 22 Dec 2010 22:00:39 +0900
Message-Id: <1293022839-3202-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/net/can/pch_can.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index 8d45fdd..c42e972 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -1078,15 +1078,17 @@ static int pch_can_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	/* Save Tx buffer enable state */
 	for (i = PCH_TX_OBJ_START; i <= PCH_TX_OBJ_END; i++)
-		priv->tx_enable[i] = pch_can_get_rxtx_ir(priv, i, PCH_TX_IFREG);
+		priv->tx_enable[i - 1] = pch_can_get_rxtx_ir(priv, i,
+							     PCH_TX_IFREG);
 
 	/* Disable all Transmit buffers */
 	pch_can_set_tx_all(priv, 0);
 
 	/* Save Rx buffer enable state */
 	for (i = PCH_RX_OBJ_START; i <= PCH_RX_OBJ_END; i++) {
-		priv->rx_enable[i] = pch_can_get_rxtx_ir(priv, i, PCH_RX_IFREG);
-		priv->rx_link[i] = pch_can_get_rx_buffer_link(priv, i);
+		priv->rx_enable[i - 1] = pch_can_get_rxtx_ir(priv, i,
+							     PCH_RX_IFREG);
+		priv->rx_link[i - 1] = pch_can_get_rx_buffer_link(priv, i);
 	}
 
 	/* Disable all Receive buffers */
@@ -1139,15 +1141,15 @@ static int pch_can_resume(struct pci_dev *pdev)
 
 	/* Enabling the transmit buffer. */
 	for (i = PCH_TX_OBJ_START; i <= PCH_TX_OBJ_END; i++)
-		pch_can_set_rxtx(priv, i, priv->tx_enable[i], PCH_TX_IFREG);
+		pch_can_set_rxtx(priv, i, priv->tx_enable[i - 1], PCH_TX_IFREG);
 
 	/* Configuring the receive buffer and enabling them. */
 	for (i = PCH_RX_OBJ_START; i <= PCH_RX_OBJ_END; i++) {
 		/* Restore buffer link */
-		pch_can_set_rx_buffer_link(priv, i, priv->rx_link[i]);
+		pch_can_set_rx_buffer_link(priv, i, priv->rx_link[i - 1]);
 
 		/* Restore buffer enables */
-		pch_can_set_rxtx(priv, i, priv->rx_enable[i], PCH_RX_IFREG);
+		pch_can_set_rxtx(priv, i, priv->rx_enable[i - 1], PCH_RX_IFREG);
 	}
 
 	/* Enable CAN Interrupts */
-- 
1.6.0.6


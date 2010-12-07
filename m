Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0LGK6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 05:58:07 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:33182 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856Ab0LGK6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 05:58:05 -0500
Message-ID: <4CFE13E4.2020707@dsn.okisemi.com>
Date: Tue, 07 Dec 2010 20:00:52 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>, socketcan-core@lists.berlios.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
CC: qi.wang@intel.com, yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com, margie.foster@intel.com
Subject: [PATCH net-next-2.6 v8 01/20] CAN : Add flow control processing.
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there is no flow control processing.
Thus, Add flow control processing as
when there is no empty of tx buffer,
netif_stop_queue is called.
When there is empty buffer, netif_wake_queue is called.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/net/can/pch_can.c |   31 ++++++++++++-------------------
 1 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index a9b6a65..f0f1404 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -102,6 +102,10 @@
 
 #define PCH_FIFO_THRESH		16
 
+/* TxRqst2 show status of MsgObjNo.17~32 */
+#define PCH_TREQ2_TX_MASK	(((1 << PCH_TX_OBJ_NUM) - 1) <<\
+							(PCH_RX_OBJ_END - 16))
+
 enum pch_ifreg {
 	PCH_RX_IFREG,
 	PCH_TX_IFREG,
@@ -871,6 +875,8 @@ MSG_OBJ:
 			dlc = 8;
 		stats->tx_bytes += dlc;
 		stats->tx_packets++;
+		if (int_stat == PCH_TX_OBJ_END)
+			netif_wake_queue(ndev);
 	}
 
 	int_stat = pch_can_int_pending(priv);
@@ -1009,18 +1015,6 @@ static int pch_close(struct net_device *ndev)
 	return 0;
 }
 
-static int pch_get_msg_obj_sts(struct net_device *ndev, u32 obj_id)
-{
-	u32 buffer_status = 0;
-	struct pch_can_priv *priv = netdev_priv(ndev);
-
-	/* Getting the message object status. */
-	buffer_status = (u32) pch_can_get_buffer_status(priv);
-
-	return buffer_status & obj_id;
-}
-
-
 static netdev_tx_t pch_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	int i, j;
@@ -1031,17 +1025,16 @@ static netdev_tx_t pch_xmit(struct sk_buff *skb, struct net_device *ndev)
 	if (can_dropped_invalid_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
-	if (priv->tx_obj == PCH_TX_OBJ_END) { /* Point tail Obj */
-		while (pch_get_msg_obj_sts(ndev, (((1 << PCH_TX_OBJ_NUM)-1) <<
-					   PCH_RX_OBJ_NUM)))
-			udelay(500);
+	if (priv->tx_obj == PCH_TX_OBJ_END) {
+		if (ioread32(&priv->regs->treq2) & PCH_TREQ2_TX_MASK)
+			netif_stop_queue(ndev);
 
-		priv->tx_obj = PCH_TX_OBJ_START; /* Point head of Tx Obj ID */
-		tx_buffer_avail = priv->tx_obj; /* Point Tail of Tx Obj */
+		tx_buffer_avail = priv->tx_obj;
+		priv->tx_obj = PCH_TX_OBJ_START;
 	} else {
 		tx_buffer_avail = priv->tx_obj;
+		priv->tx_obj++;
 	}
-	priv->tx_obj++;
 
 	/* Reading the Msg Obj from the Msg RAM to the Interface register. */
 	iowrite32(PCH_CMASK_RX_TX_GET, &priv->regs->ifregs[1].cmask);
-- 
1.6.0.6

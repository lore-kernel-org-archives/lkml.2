Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab0LGLI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 06:08:56 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:34351 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752057Ab0LGLIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 06:08:55 -0500
Message-ID: <4CFE166D.8040805@dsn.okisemi.com>
Date: Tue, 07 Dec 2010 20:11:41 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>, socketcan-core@lists.berlios.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
CC: qi.wang@intel.com, yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com, margie.foster@intel.com
Subject: [PATCH net-next-2.6 v8 18/20] CAN : Optimize "if" condition in rx/tx
 processing
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For reduce "if" condition, easy to read/understand the code,
optimize "if" condition in rx/tx processing.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/net/can/pch_can.c |   26 ++++++++++----------------
 1 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index 8efbe35..dcd8f00 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -746,19 +746,16 @@ static int pch_can_poll(struct napi_struct *napi, int quota)
 
 	if (int_stat == PCH_STATUS_INT) {
 		reg_stat = ioread32(&priv->regs->stat);
-		if (reg_stat & (PCH_BUS_OFF | PCH_LEC_ALL)) {
-			if (reg_stat & PCH_BUS_OFF ||
-			   (reg_stat & PCH_LEC_ALL) != PCH_LEC_ALL) {
-				pch_can_error(ndev, reg_stat);
-				quota--;
-			}
-		}
 
-		if (reg_stat & PCH_TX_OK)
-			pch_can_bit_clear(&priv->regs->stat, PCH_TX_OK);
+		if ((reg_stat & (PCH_BUS_OFF | PCH_LEC_ALL)) &&
+		   ((reg_stat & PCH_LEC_ALL) != PCH_LEC_ALL)) {
+			pch_can_error(ndev, reg_stat);
+			quota--;
+		}
 
-		if (reg_stat & PCH_RX_OK)
-			pch_can_bit_clear(&priv->regs->stat, PCH_RX_OK);
+		if (reg_stat & (PCH_TX_OK | PCH_RX_OK))
+			pch_can_bit_clear(&priv->regs->stat,
+					  reg_stat & (PCH_TX_OK | PCH_RX_OK));
 
 		int_stat = pch_can_int_pending(priv);
 	}
@@ -900,14 +897,13 @@ static netdev_tx_t pch_xmit(struct sk_buff *skb, struct net_device *ndev)
 	if (can_dropped_invalid_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
+	tx_obj_no = priv->tx_obj;
 	if (priv->tx_obj == PCH_TX_OBJ_END) {
 		if (ioread32(&priv->regs->treq2) & PCH_TREQ2_TX_MASK)
 			netif_stop_queue(ndev);
 
-		tx_obj_no = priv->tx_obj;
 		priv->tx_obj = PCH_TX_OBJ_START;
 	} else {
-		tx_obj_no = priv->tx_obj;
 		priv->tx_obj++;
 	}
 
@@ -926,9 +922,7 @@ static netdev_tx_t pch_xmit(struct sk_buff *skb, struct net_device *ndev)
 	id2 |= PCH_ID_MSGVAL;
 
 	/* If remote frame has to be transmitted.. */
-	if (cf->can_id & CAN_RTR_FLAG)
-		id2 &= ~PCH_ID2_DIR;
-	else
+	if (!(cf->can_id & CAN_RTR_FLAG))
 		id2 |= PCH_ID2_DIR;
 
 	iowrite32(id2, &priv->regs->ifregs[1].id2);
-- 
1.6.0.6

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab0LMG1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:27:32 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:24390 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751430Ab0LMGV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:21:58 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: wg@grandegger.com, w.sang@pengutronix.de, chripell@fsfe.org,
        21cnbao@gmail.com, sameo@linux.intel.com,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Cc: qi.wang@intel.com, yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com, margie.foster@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH net-next-2.6 v9 03/20] pch_can: Fix endianness issue
Date: Mon, 13 Dec 2010 15:24:09 +0900
Message-Id: <1292221467-8039-3-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1292221467-8039-2-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1292221467-8039-1-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-2-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

there is endianness issue both Tx and Rx.
Currently, data is set like below.
Register:
MSB--LSB
x x D0 D1
x x D2 D3
x x D4 D5
x x D6 D7

But Data to be sent must be set like below.
Register:
MSB--LSB
x x D1 D0
x x D3 D2
x x D5 D4
x x D7 D6  (x means reserved area.)

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/net/can/pch_can.c |   47 +++++++++++++++++++-------------------------
 1 files changed, 20 insertions(+), 27 deletions(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index 0b6d4f4..210957f 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -138,10 +138,7 @@ struct pch_can_if_regs {
 	u32 id1;
 	u32 id2;
 	u32 mcont;
-	u32 dataa1;
-	u32 dataa2;
-	u32 datab1;
-	u32 datab2;
+	u32 data[4];
 	u32 rsv[13];
 };
 
@@ -424,10 +421,10 @@ static void pch_can_clear_buffers(struct pch_can_priv *priv)
 		iowrite32(0x0, &priv->regs->ifregs[0].id1);
 		iowrite32(0x0, &priv->regs->ifregs[0].id2);
 		iowrite32(0x0, &priv->regs->ifregs[0].mcont);
-		iowrite32(0x0, &priv->regs->ifregs[0].dataa1);
-		iowrite32(0x0, &priv->regs->ifregs[0].dataa2);
-		iowrite32(0x0, &priv->regs->ifregs[0].datab1);
-		iowrite32(0x0, &priv->regs->ifregs[0].datab2);
+		iowrite32(0x0, &priv->regs->ifregs[0].data[0]);
+		iowrite32(0x0, &priv->regs->ifregs[0].data[1]);
+		iowrite32(0x0, &priv->regs->ifregs[0].data[2]);
+		iowrite32(0x0, &priv->regs->ifregs[0].data[3]);
 		iowrite32(PCH_CMASK_RDWR | PCH_CMASK_MASK |
 			  PCH_CMASK_ARB | PCH_CMASK_CTRL,
 			  &priv->regs->ifregs[0].cmask);
@@ -441,10 +438,10 @@ static void pch_can_clear_buffers(struct pch_can_priv *priv)
 		iowrite32(0x0, &priv->regs->ifregs[1].id1);
 		iowrite32(0x0, &priv->regs->ifregs[1].id2);
 		iowrite32(0x0, &priv->regs->ifregs[1].mcont);
-		iowrite32(0x0, &priv->regs->ifregs[1].dataa1);
-		iowrite32(0x0, &priv->regs->ifregs[1].dataa2);
-		iowrite32(0x0, &priv->regs->ifregs[1].datab1);
-		iowrite32(0x0, &priv->regs->ifregs[1].datab2);
+		iowrite32(0x0, &priv->regs->ifregs[1].data[0]);
+		iowrite32(0x0, &priv->regs->ifregs[1].data[1]);
+		iowrite32(0x0, &priv->regs->ifregs[1].data[2]);
+		iowrite32(0x0, &priv->regs->ifregs[1].data[3]);
 		iowrite32(PCH_CMASK_RDWR | PCH_CMASK_MASK |
 			  PCH_CMASK_ARB | PCH_CMASK_CTRL,
 			  &priv->regs->ifregs[1].cmask);
@@ -707,12 +704,13 @@ static int pch_can_rx_normal(struct net_device *ndev, u32 int_stat)
 	canid_t id;
 	u32 ide;
 	u32 rtr;
-	int i, j, k;
+	int i, k;
 	int rcv_pkts = 0;
 	struct sk_buff *skb;
 	struct can_frame *cf;
 	struct pch_can_priv *priv = netdev_priv(ndev);
 	struct net_device_stats *stats = &(priv->ndev->stats);
+	u16 data_reg;
 
 	/* Reading the messsage object from the Message RAM */
 	iowrite32(PCH_CMASK_RX_TX_GET, &priv->regs->ifregs[0].cmask);
@@ -778,12 +776,10 @@ static int pch_can_rx_normal(struct net_device *ndev, u32 int_stat)
 			      ((ioread32(&priv->regs->ifregs[0].mcont)) & 0x0f);
 		}
 
-		for (i = 0, j = 0; i < cf->can_dlc; j++) {
-			reg = ioread32(&priv->regs->ifregs[0].dataa1 + j*4);
-			cf->data[i++] = cpu_to_le32(reg & 0xff);
-			if (i == cf->can_dlc)
-				break;
-			cf->data[i++] = cpu_to_le32((reg >> 8) & 0xff);
+		for (i = 0; i < cf->can_dlc; i += 2) {
+			data_reg = ioread16(&priv->regs->ifregs[0].data[i / 2]);
+			cf->data[i] = data_reg;
+			cf->data[i + 1] = data_reg >> 8;
 		}
 
 		netif_receive_skb(skb);
@@ -1016,10 +1012,10 @@ static int pch_close(struct net_device *ndev)
 
 static netdev_tx_t pch_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
-	int i, j;
 	struct pch_can_priv *priv = netdev_priv(ndev);
 	struct can_frame *cf = (struct can_frame *)skb->data;
 	int tx_buffer_avail = 0;
+	int i;
 
 	if (can_dropped_invalid_skb(ndev, skb))
 		return NETDEV_TX_OK;
@@ -1060,13 +1056,10 @@ static netdev_tx_t pch_xmit(struct sk_buff *skb, struct net_device *ndev)
 	if (cf->can_id & CAN_RTR_FLAG)
 		pch_can_bit_clear(&priv->regs->ifregs[1].id2, PCH_ID2_DIR);
 
-	for (i = 0, j = 0; i < cf->can_dlc; j++) {
-		iowrite32(le32_to_cpu(cf->data[i++]),
-			 (&priv->regs->ifregs[1].dataa1) + j*4);
-		if (i == cf->can_dlc)
-			break;
-		iowrite32(le32_to_cpu(cf->data[i++] << 8),
-			 (&priv->regs->ifregs[1].dataa1) + j*4);
+	/* Copy data to register */
+	for (i = 0; i < cf->can_dlc; i += 2) {
+		iowrite16(cf->data[i] | (cf->data[i + 1] << 8),
+			  &priv->regs->ifregs[1].data[i / 2]);
 	}
 
 	can_put_echo_skb(skb, ndev, tx_buffer_avail - PCH_RX_OBJ_END - 1);
-- 
1.6.0.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab0KSFsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 00:48:54 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:30752 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512Ab0KSFsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 00:48:52 -0500
Message-ID: <4CE60FB1.5060808@dsn.okisemi.com>
Date: Fri, 19 Nov 2010 14:48:33 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        Barry Song <21cnbao@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
CC: qi.wang@intel.com, yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com, margie.foster@intel.com
Subject: [PATCH net-next-2.6 11/17] can: EG20T PCH: Delete unnecessary/redundant
 code
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete unnecessary/redundant code

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/net/can/pch_can.c |   86 ++++++++++++++++++++-------------------------
 1 files changed, 38 insertions(+), 48 deletions(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index 318eb1f..7342030 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -447,11 +447,6 @@ static void pch_can_release(struct pch_can_priv *priv)
 /* This function clears interrupt(s) from the CAN device. */
 static void pch_can_int_clr(struct pch_can_priv *priv, u32 mask)
 {
-	if (mask == PCH_STATUS_INT) {
-		ioread32(&priv->regs->stat);
-		return;
-	}
-
 	/* Clear interrupt for transmit object */
 	if ((mask >= PCH_RX_OBJ_START) && (mask <= PCH_RX_OBJ_END)) {
 		/* Setting CMASK for clearing the reception interrupts. */
@@ -518,8 +513,6 @@ static void pch_can_error(struct net_device *ndev, u32 status)
 		state = CAN_STATE_BUS_OFF;
 		cf->can_id |= CAN_ERR_BUSOFF;
 		can_bus_off(ndev);
-		pch_can_set_run_mode(priv, PCH_CAN_RUN);
-		dev_err(&ndev->dev, "%s -> Bus Off occurres.\n", __func__);
 	}
 
 	errc = ioread32(&priv->regs->errc);
@@ -658,7 +651,6 @@ static int pch_can_rx_normal(struct net_device *ndev, u32 obj_num, int quota)
 	canid_t id;
 	int rcv_pkts = 0;
 	int rtn;
-	int next_flag = 0;
 	struct sk_buff *skb;
 	struct can_frame *cf;
 	struct pch_can_priv *priv = netdev_priv(ndev);
@@ -685,50 +677,48 @@ static int pch_can_rx_normal(struct net_device *ndev, u32 obj_num, int quota)
 				return rtn;
 			rcv_pkts++;
 			quota--;
-			next_flag = 1;
-		} else if (!(reg & PCH_IF_MCONT_NEWDAT))
-			next_flag = 1;
-
-		if (!next_flag) {
-			skb = alloc_can_skb(priv->ndev, &cf);
-			if (!skb)
-				return -ENOMEM;
-
-			/* Get Received data */
-			id2 = ioread32(&priv->regs->ifregs[0].id2);
-			if (id2 & PCH_ID2_XTD) {
-				id = (ioread32(&priv->regs->ifregs[0].id1) &
-					       0xffff);
-				id |= (((id2) & 0x1fff) << 16);
-				cf->can_id = id | CAN_EFF_FLAG;
-			} else {
-				id = ((id2 & (CAN_SFF_MASK << 2)) >> 2);
-				cf->can_id = id;
-			}
-
-			if (id2 & PCH_ID2_DIR)
-				cf->can_id |= CAN_RTR_FLAG;
+			obj_num++;
+			continue;
+		} else if (!(reg & PCH_IF_MCONT_NEWDAT)) {
+			obj_num++;
+			continue;
+		}
 
-			cf->can_dlc = get_can_dlc((ioread32(&priv->regs->
-						   ifregs[0].mcont)) & 0xF);
+		skb = alloc_can_skb(priv->ndev, &cf);
+		if (!skb)
+			return -ENOMEM;
+
+		/* Get Received data */
+		id2 = ioread32(&priv->regs->ifregs[0].id2);
+		if (id2 & PCH_ID2_XTD) {
+			id = (ioread32(&priv->regs->ifregs[0].id1) & 0xffff);
+			id |= (((id2) & 0x1fff) << 16);
+			cf->can_id = id | CAN_EFF_FLAG;
+		} else {
+			id = ((id2 & (CAN_SFF_MASK << 2)) >> 2);
+			cf->can_id = id;
+		}
 
-			for (i = 0; i < cf->can_dlc; i += 2) {
-				data_reg = ioread16(&priv->regs->ifregs[0].
-						    data[i / 2]);
-				cf->data[i] = data_reg & 0xff;
-				cf->data[i + 1] = (data_reg >> 8) & 0xff;
-			}
+		if (id2 & PCH_ID2_DIR)
+			cf->can_id |= CAN_RTR_FLAG;
 
-			netif_receive_skb(skb);
-			rcv_pkts++;
-			stats->rx_packets++;
-			quota--;
-			stats->rx_bytes += cf->can_dlc;
+		cf->can_dlc = get_can_dlc((ioread32(&priv->regs->
+						    ifregs[0].mcont)) & 0xF);
 
-			pch_fifo_thresh(priv, obj_num);
+		for (i = 0; i < cf->can_dlc; i += 2) {
+			data_reg = ioread16(&priv->regs->ifregs[0].data[i / 2]);
+			cf->data[i] = data_reg & 0xff;
+			cf->data[i + 1] = data_reg >> 8;
 		}
+
+		netif_receive_skb(skb);
+		rcv_pkts++;
+		stats->rx_packets++;
+		quota--;
+		stats->rx_bytes += cf->can_dlc;
+
+		pch_fifo_thresh(priv, obj_num);
 		obj_num++;
-		next_flag = 0;
 	} while (quota > 0);
 
 	return rcv_pkts;
@@ -764,7 +754,7 @@ static int pch_can_poll(struct napi_struct *napi, int quota)
 	if (!int_stat)
 		goto end;
 
-	if ((int_stat == PCH_STATUS_INT) && (quota > 0)) {
+	if (int_stat == PCH_STATUS_INT) {
 		reg_stat = ioread32(&priv->regs->stat);
 		if (reg_stat & (PCH_BUS_OFF | PCH_LEC_ALL)) {
 			if (reg_stat & PCH_BUS_OFF ||
@@ -932,7 +922,7 @@ static netdev_tx_t pch_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct pch_can_priv *priv = netdev_priv(ndev);
 	struct can_frame *cf = (struct can_frame *)skb->data;
-	int tx_obj_no = 0;
+	int tx_obj_no;
 	int i;
 	u32 id2;
 
-- 
1.6.0.6


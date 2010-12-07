Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab0LGLI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 06:08:27 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:34320 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755337Ab0LGLI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 06:08:26 -0500
Message-ID: <4CFE1651.9040405@dsn.okisemi.com>
Date: Tue, 07 Dec 2010 20:11:13 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>, socketcan-core@lists.berlios.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
CC: qi.wang@intel.com, yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com, margie.foster@intel.com
Subject: [PATCH net-next-2.6 v8 17/20] CAN : Fix incorrect return processing
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix incorrect return processing.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/net/can/pch_can.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index ace1fe7..8efbe35 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -580,9 +580,11 @@ static irqreturn_t pch_can_interrupt(int irq, void *dev_id)
 	struct net_device *ndev = (struct net_device *)dev_id;
 	struct pch_can_priv *priv = netdev_priv(ndev);
 
+	if (!pch_can_int_pending(priv))
+		return IRQ_NONE;
+
 	pch_can_set_int_enables(priv, PCH_CAN_NONE);
 	napi_schedule(&priv->napi);
-
 	return IRQ_HANDLED;
 }
 
@@ -671,8 +673,10 @@ static int pch_can_rx_normal(struct net_device *ndev, u32 obj_num, int quota)
 		}
 
 		skb = alloc_can_skb(priv->ndev, &cf);
-		if (!skb)
-			return -ENOMEM;
+		if (!skb) {
+			netdev_err(ndev, "alloc_can_skb Failed\n");
+			return rcv_pkts;
+		}
 
 		/* Get Received data */
 		id2 = ioread32(&priv->regs->ifregs[0].id2);
@@ -733,8 +737,8 @@ static int pch_can_poll(struct napi_struct *napi, int quota)
 	struct net_device *ndev = napi->dev;
 	struct pch_can_priv *priv = netdev_priv(ndev);
 	u32 int_stat;
-	int rcv_pkts = 0;
 	u32 reg_stat;
+	int quota_save = quota;
 
 	int_stat = pch_can_int_pending(priv);
 	if (!int_stat)
@@ -763,10 +767,7 @@ static int pch_can_poll(struct napi_struct *napi, int quota)
 		goto end;
 
 	if ((int_stat >= PCH_RX_OBJ_START) && (int_stat <= PCH_RX_OBJ_END)) {
-		rcv_pkts += pch_can_rx_normal(ndev, int_stat, quota);
-		quota -= rcv_pkts;
-		if (quota < 0)
-			goto end;
+		quota -= pch_can_rx_normal(ndev, int_stat, quota);
 	} else if ((int_stat >= PCH_TX_OBJ_START) &&
 		   (int_stat <= PCH_TX_OBJ_END)) {
 		/* Handle transmission interrupt */
@@ -777,7 +778,7 @@ end:
 	napi_complete(napi);
 	pch_can_set_int_enables(priv, PCH_CAN_ALL);
 
-	return rcv_pkts;
+	return quota_save - quota;
 }
 
 static int pch_set_bittiming(struct net_device *ndev)
-- 
1.6.0.6

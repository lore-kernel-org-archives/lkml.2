Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab0LMGXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:23:43 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:24502 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752466Ab0LMGWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:22:08 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: wg@grandegger.com, w.sang@pengutronix.de, chripell@fsfe.org,
        21cnbao@gmail.com, sameo@linux.intel.com,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Cc: qi.wang@intel.com, yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com, margie.foster@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH net-next-2.6 v9 17/20] pch_can: Fix incorrect return processing
Date: Mon, 13 Dec 2010 15:24:23 +0900
Message-Id: <1292221467-8039-17-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1292221467-8039-16-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1292221467-8039-1-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-2-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-3-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-4-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-5-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-6-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-7-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-8-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-9-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-10-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-11-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-12-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-13-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-14-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-15-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-16-git-send-email-tomoya-linux@dsn.okisemi.com>
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


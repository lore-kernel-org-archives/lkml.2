Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab0LMGZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:25:30 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:24416 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752081Ab0LMGWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:22:01 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: wg@grandegger.com, w.sang@pengutronix.de, chripell@fsfe.org,
        21cnbao@gmail.com, sameo@linux.intel.com,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Cc: qi.wang@intel.com, yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com, margie.foster@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH net-next-2.6 v9 07/20] pch_can: Change functions type
Date: Mon, 13 Dec 2010 15:24:13 +0900
Message-Id: <1292221467-8039-7-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1292221467-8039-6-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1292221467-8039-1-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-2-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-3-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-4-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-5-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-6-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, these two functions spec(returned value) is unnatural.
Thus, change the return value's spec

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/net/can/pch_can.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index dd9ce16..c6c0842 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -1025,10 +1025,10 @@ static void pch_can_set_int_custom(struct pch_can_priv *priv)
 }
 
 /* This function retrieves interrupt enabled for the CAN device. */
-static void pch_can_get_int_enables(struct pch_can_priv *priv, u32 *enables)
+static u32 pch_can_get_int_enables(struct pch_can_priv *priv)
 {
 	/* Obtaining the status of IE, SIE and EIE interrupt bits. */
-	*enables = ((ioread32(&priv->regs->cont) & PCH_CTRL_IE_SIE_EIE) >> 1);
+	return (ioread32(&priv->regs->cont) & PCH_CTRL_IE_SIE_EIE) >> 1;
 }
 
 static u32 pch_can_get_rxtx_ir(struct pch_can_priv *priv, u32 buff_num,
@@ -1069,16 +1069,18 @@ static void pch_can_set_rx_buffer_link(struct pch_can_priv *priv,
 	pch_can_rw_msg_obj(&priv->regs->ifregs[0].creq, buffer_num);
 }
 
-static void pch_can_get_rx_buffer_link(struct pch_can_priv *priv,
-				       u32 buffer_num, u32 *link)
+static u32 pch_can_get_rx_buffer_link(struct pch_can_priv *priv, u32 buffer_num)
 {
+	u32 link;
+
 	iowrite32(PCH_CMASK_RX_TX_GET, &priv->regs->ifregs[0].cmask);
 	pch_can_rw_msg_obj(&priv->regs->ifregs[0].creq, buffer_num);
 
 	if (ioread32(&priv->regs->ifregs[0].mcont) & PCH_IF_MCONT_EOB)
-		*link = 0;
+		link = 0;
 	else
-		*link = 1;
+		link = 1;
+	return link;
 }
 
 static int pch_can_get_buffer_status(struct pch_can_priv *priv)
@@ -1115,7 +1117,7 @@ static int pch_can_suspend(struct pci_dev *pdev, pm_message_t state)
 		dev_err(&pdev->dev, "%s -> Transmission time out.\n", __func__);
 
 	/* Save interrupt configuration and then disable them */
-	pch_can_get_int_enables(priv, &(priv->int_enables));
+	priv->int_enables = pch_can_get_int_enables(priv);
 	pch_can_set_int_enables(priv, PCH_CAN_DISABLE);
 
 	/* Save Tx buffer enable state */
@@ -1128,7 +1130,7 @@ static int pch_can_suspend(struct pci_dev *pdev, pm_message_t state)
 	/* Save Rx buffer enable state */
 	for (i = PCH_RX_OBJ_START; i <= PCH_RX_OBJ_END; i++) {
 		priv->rx_enable[i] = pch_can_get_rxtx_ir(priv, i, PCH_RX_IFREG);
-		pch_can_get_rx_buffer_link(priv, i, &priv->rx_link[i]);
+		priv->rx_link[i] = pch_can_get_rx_buffer_link(priv, i);
 	}
 
 	/* Disable all Receive buffers */
-- 
1.6.0.6


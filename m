Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab0LMGWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:22:03 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:24416 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096Ab0LMGWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:22:00 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: wg@grandegger.com, w.sang@pengutronix.de, chripell@fsfe.org,
        21cnbao@gmail.com, sameo@linux.intel.com,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Cc: qi.wang@intel.com, yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com, margie.foster@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH net-next-2.6 v9 05/20] pch_can: Fix warnings
Date: Mon, 13 Dec 2010 15:24:11 +0900
Message-Id: <1292221467-8039-5-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1292221467-8039-4-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1292221467-8039-1-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-2-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-3-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-4-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, in case CONFIG_PM is disabled, compiler outputs warnings.
Move six functions which are used only CONFIG_PM is enabled,
into "#ifdef CONFIG_PM" area.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/net/can/pch_can.c |  146 ++++++++++++++++++++++----------------------
 1 files changed, 73 insertions(+), 73 deletions(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index d646fbc..5fc99cb 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -245,23 +245,6 @@ static void pch_can_set_optmode(struct pch_can_priv *priv)
 	iowrite32(reg_val, &priv->regs->opt);
 }
 
-static void pch_can_set_int_custom(struct pch_can_priv *priv)
-{
-	/* Clearing the IE, SIE and EIE bits of Can control register. */
-	pch_can_bit_clear(&priv->regs->cont, PCH_CTRL_IE_SIE_EIE);
-
-	/* Appropriately setting them. */
-	pch_can_bit_set(&priv->regs->cont,
-			((priv->int_enables & PCH_MSK_CTRL_IE_SIE_EIE) << 1));
-}
-
-/* This function retrieves interrupt enabled for the CAN device. */
-static void pch_can_get_int_enables(struct pch_can_priv *priv, u32 *enables)
-{
-	/* Obtaining the status of IE, SIE and EIE interrupt bits. */
-	*enables = ((ioread32(&priv->regs->cont) & PCH_CTRL_IE_SIE_EIE) >> 1);
-}
-
 static void pch_can_set_int_enables(struct pch_can_priv *priv,
 				    enum pch_can_mode interrupt_no)
 {
@@ -355,61 +338,11 @@ static void pch_can_set_tx_all(struct pch_can_priv *priv, u32 set)
 		pch_can_set_rxtx(priv, i, set, PCH_TX_IFREG);
 }
 
-static u32 pch_can_get_rxtx_ir(struct pch_can_priv *priv, u32 buff_num,
-			       enum pch_ifreg dir)
-{
-	u32 ie, enable;
-
-	if (dir)
-		ie = PCH_IF_MCONT_RXIE;
-	else
-		ie = PCH_IF_MCONT_TXIE;
-
-	iowrite32(PCH_CMASK_RX_TX_GET, &priv->regs->ifregs[dir].cmask);
-	pch_can_check_if_busy(&priv->regs->ifregs[dir].creq, buff_num);
-
-	if (((ioread32(&priv->regs->ifregs[dir].id2)) & PCH_ID_MSGVAL) &&
-			((ioread32(&priv->regs->ifregs[dir].mcont)) & ie)) {
-		enable = 1;
-	} else {
-		enable = 0;
-	}
-	return enable;
-}
-
 static int pch_can_int_pending(struct pch_can_priv *priv)
 {
 	return ioread32(&priv->regs->intr) & 0xffff;
 }
 
-static void pch_can_set_rx_buffer_link(struct pch_can_priv *priv,
-				       u32 buffer_num, u32 set)
-{
-	iowrite32(PCH_CMASK_RX_TX_GET, &priv->regs->ifregs[0].cmask);
-	pch_can_check_if_busy(&priv->regs->ifregs[0].creq, buffer_num);
-	iowrite32(PCH_CMASK_RDWR | PCH_CMASK_CTRL,
-		  &priv->regs->ifregs[0].cmask);
-	if (set == PCH_ENABLE)
-		pch_can_bit_clear(&priv->regs->ifregs[0].mcont,
-				  PCH_IF_MCONT_EOB);
-	else
-		pch_can_bit_set(&priv->regs->ifregs[0].mcont, PCH_IF_MCONT_EOB);
-
-	pch_can_check_if_busy(&priv->regs->ifregs[0].creq, buffer_num);
-}
-
-static void pch_can_get_rx_buffer_link(struct pch_can_priv *priv,
-				       u32 buffer_num, u32 *link)
-{
-	iowrite32(PCH_CMASK_RX_TX_GET, &priv->regs->ifregs[0].cmask);
-	pch_can_check_if_busy(&priv->regs->ifregs[0].creq, buffer_num);
-
-	if (ioread32(&priv->regs->ifregs[0].mcont) & PCH_IF_MCONT_EOB)
-		*link = PCH_DISABLE;
-	else
-		*link = PCH_ENABLE;
-}
-
 static void pch_can_clear_buffers(struct pch_can_priv *priv)
 {
 	int i;
@@ -583,12 +516,6 @@ static void pch_can_int_clr(struct pch_can_priv *priv, u32 mask)
 	}
 }
 
-static int pch_can_get_buffer_status(struct pch_can_priv *priv)
-{
-	return (ioread32(&priv->regs->treq1) & 0xffff) |
-	       ((ioread32(&priv->regs->treq2) & 0xffff) << 16);
-}
-
 static void pch_can_reset(struct pch_can_priv *priv)
 {
 	/* write to sw reset register */
@@ -1109,6 +1036,79 @@ static void __devexit pch_can_remove(struct pci_dev *pdev)
 }
 
 #ifdef CONFIG_PM
+static void pch_can_set_int_custom(struct pch_can_priv *priv)
+{
+	/* Clearing the IE, SIE and EIE bits of Can control register. */
+	pch_can_bit_clear(&priv->regs->cont, PCH_CTRL_IE_SIE_EIE);
+
+	/* Appropriately setting them. */
+	pch_can_bit_set(&priv->regs->cont,
+			((priv->int_enables & PCH_MSK_CTRL_IE_SIE_EIE) << 1));
+}
+
+/* This function retrieves interrupt enabled for the CAN device. */
+static void pch_can_get_int_enables(struct pch_can_priv *priv, u32 *enables)
+{
+	/* Obtaining the status of IE, SIE and EIE interrupt bits. */
+	*enables = ((ioread32(&priv->regs->cont) & PCH_CTRL_IE_SIE_EIE) >> 1);
+}
+
+static u32 pch_can_get_rxtx_ir(struct pch_can_priv *priv, u32 buff_num,
+			       enum pch_ifreg dir)
+{
+	u32 ie, enable;
+
+	if (dir)
+		ie = PCH_IF_MCONT_RXIE;
+	else
+		ie = PCH_IF_MCONT_TXIE;
+
+	iowrite32(PCH_CMASK_RX_TX_GET, &priv->regs->ifregs[dir].cmask);
+	pch_can_check_if_busy(&priv->regs->ifregs[dir].creq, buff_num);
+
+	if (((ioread32(&priv->regs->ifregs[dir].id2)) & PCH_ID_MSGVAL) &&
+			((ioread32(&priv->regs->ifregs[dir].mcont)) & ie)) {
+		enable = 1;
+	} else {
+		enable = 0;
+	}
+	return enable;
+}
+
+static void pch_can_set_rx_buffer_link(struct pch_can_priv *priv,
+				       u32 buffer_num, u32 set)
+{
+	iowrite32(PCH_CMASK_RX_TX_GET, &priv->regs->ifregs[0].cmask);
+	pch_can_check_if_busy(&priv->regs->ifregs[0].creq, buffer_num);
+	iowrite32(PCH_CMASK_RDWR | PCH_CMASK_CTRL,
+		  &priv->regs->ifregs[0].cmask);
+	if (set == PCH_ENABLE)
+		pch_can_bit_clear(&priv->regs->ifregs[0].mcont,
+				  PCH_IF_MCONT_EOB);
+	else
+		pch_can_bit_set(&priv->regs->ifregs[0].mcont, PCH_IF_MCONT_EOB);
+
+	pch_can_check_if_busy(&priv->regs->ifregs[0].creq, buffer_num);
+}
+
+static void pch_can_get_rx_buffer_link(struct pch_can_priv *priv,
+				       u32 buffer_num, u32 *link)
+{
+	iowrite32(PCH_CMASK_RX_TX_GET, &priv->regs->ifregs[0].cmask);
+	pch_can_check_if_busy(&priv->regs->ifregs[0].creq, buffer_num);
+
+	if (ioread32(&priv->regs->ifregs[0].mcont) & PCH_IF_MCONT_EOB)
+		*link = PCH_DISABLE;
+	else
+		*link = PCH_ENABLE;
+}
+
+static int pch_can_get_buffer_status(struct pch_can_priv *priv)
+{
+	return (ioread32(&priv->regs->treq1) & 0xffff) |
+	       ((ioread32(&priv->regs->treq2) & 0xffff) << 16);
+}
+
 static int pch_can_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	int i;			/* Counter variable. */
-- 
1.6.0.6


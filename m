Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466Ab2ILNEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:04:37 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:16819 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045Ab2ILMzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:55:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqECACCFUFBbdWObgWdsb2JhbABFu0AiAQEWJieCIAEBBSdSECAxVwYTiBG8YpFSA5VfiTOJVA
X-IronPort-AV: E=Sophos;i="4.80,410,1344204000"; 
   d="scan'208";a="950511733"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 07/24] Staging: ipack/devices/ipoctal: Store isr masks in ipoctal_channel
Date: Wed, 12 Sep 2012 14:55:29 +0200
Message-Id: <1347454546-23236-7-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

This way interrupt handling becomes independent of the channel number.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 70dc7a2..56e810b 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -44,6 +44,8 @@ struct ipoctal_channel {
 	union scc2698_block __iomem	*block_regs;
 	unsigned int			board_id;
 	unsigned char			*board_write;
+	u8				isr_rx_rdy_mask;
+	u8				isr_tx_rdy_mask;
 };
 
 struct ipoctal {
@@ -166,7 +168,6 @@ static int ipoctal_irq_handler(void *arg)
 	unsigned int ichannel;
 	unsigned char isr;
 	unsigned char sr;
-	unsigned char isr_tx_rdy, isr_rx_rdy;
 	unsigned char value;
 	unsigned char flag;
 	struct tty_struct *tty;
@@ -191,14 +192,6 @@ static int ipoctal_irq_handler(void *arg)
 		isr = ioread8(&channel->block_regs->r.isr);
 		sr = ioread8(&channel->regs->r.sr);
 
-		if ((ichannel % 2) == 1) {
-			isr_tx_rdy = isr & ISR_TxRDY_B;
-			isr_rx_rdy = isr & ISR_RxRDY_FFULL_B;
-		} else {
-			isr_tx_rdy = isr & ISR_TxRDY_A;
-			isr_rx_rdy = isr & ISR_RxRDY_FFULL_A;
-		}
-
 		/* In case of RS-485, change from TX to RX when finishing TX.
 		 * Half-duplex.
 		 */
@@ -213,7 +206,7 @@ static int ipoctal_irq_handler(void *arg)
 		}
 
 		/* RX data */
-		if (isr_rx_rdy && (sr & SR_RX_READY)) {
+		if ((isr && channel->isr_rx_rdy_mask) && (sr & SR_RX_READY)) {
 			value = ioread8(&channel->regs->r.rhr);
 			flag = TTY_NORMAL;
 
@@ -244,7 +237,7 @@ static int ipoctal_irq_handler(void *arg)
 		}
 
 		/* TX of each character */
-		if (isr_tx_rdy && (sr & SR_TX_READY)) {
+		if ((isr & channel->isr_tx_rdy_mask) && (sr & SR_TX_READY)) {
 			unsigned int *pointer_write = &channel->pointer_write;
 
 			if (channel->nb_bytes <= 0) {
@@ -365,6 +358,13 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 		channel->block_regs = block_regs + (i >> 1);
 		channel->board_write = &ipoctal->write;
 		channel->board_id = ipoctal->board_id;
+		if (i & 1) {
+			channel->isr_tx_rdy_mask = ISR_TxRDY_B;
+			channel->isr_rx_rdy_mask = ISR_RxRDY_FFULL_B;
+		} else {
+			channel->isr_tx_rdy_mask = ISR_TxRDY_A;
+			channel->isr_rx_rdy_mask = ISR_RxRDY_FFULL_A;
+		}
 
 		iowrite8(CR_DISABLE_RX | CR_DISABLE_TX, &channel->regs->w.cr);
 		iowrite8(CR_CMD_RESET_RX, &channel->regs->w.cr);
-- 
1.7.10.4


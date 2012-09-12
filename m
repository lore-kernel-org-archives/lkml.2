Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169Ab2ILNFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:05:30 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:52874 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab2ILMzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:55:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqECACCFUFBbdWObgWdsb2JhbABFu0AiAQEWJieCIAEBBSdSECAxVwYTiBG8YpFSA5Vfkwc
X-IronPort-AV: E=Sophos;i="4.80,410,1344204000"; 
   d="scan'208";a="950511721"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 05/24] Staging: ipack/devices/ipoctal: Directly use ioread/iowrite function.
Date: Wed, 12 Sep 2012 14:55:27 +0200
Message-Id: <1347454546-23236-5-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |  151 +++++++++----------------------
 1 file changed, 41 insertions(+), 110 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 9ab0e80..c963456 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -56,26 +56,6 @@ struct ipoctal {
 /* Linked list to save the registered devices */
 static LIST_HEAD(ipoctal_list);
 
-static inline void ipoctal_write_io_reg(struct ipoctal *ipoctal,
-					u8 __iomem *dest,
-					u8 value)
-{
-	iowrite8(value, dest);
-}
-
-static inline void ipoctal_write_cr_cmd(struct ipoctal *ipoctal,
-					u8 __iomem *dest,
-					u8 value)
-{
-	ipoctal_write_io_reg(ipoctal, dest, value);
-}
-
-static inline unsigned char ipoctal_read_io_reg(struct ipoctal *ipoctal,
-						u8 __iomem *src)
-{
-	return ioread8(src);
-}
-
 static struct ipoctal *ipoctal_find_board(struct tty_struct *tty)
 {
 	struct ipoctal *p;
@@ -102,8 +82,7 @@ static int ipoctal_port_activate(struct tty_port *port, struct tty_struct *tty)
 	}
 	channel = &ipoctal->channel[tty->index];
 
-	ipoctal_write_io_reg(ipoctal, &channel->regs->w.cr,
-			     CR_ENABLE_RX);
+	iowrite8(CR_ENABLE_RX, &channel->regs->w.cr);
 	return 0;
 }
 
@@ -216,10 +195,8 @@ static int ipoctal_irq_handler(void *arg)
 		 * The HW is organized in pair of channels.
 		 * See which register we need to read from
 		 */
-		isr = ipoctal_read_io_reg(ipoctal,
-					  &channel->block_regs->r.isr);
-		sr = ipoctal_read_io_reg(ipoctal,
-					 &channel->regs->r.sr);
+		isr = ioread8(&channel->block_regs->r.isr);
+		sr = ioread8(&channel->regs->r.sr);
 
 		if ((ichannel % 2) == 1) {
 			isr_tx_rdy = isr & ISR_TxRDY_B;
@@ -235,30 +212,21 @@ static int ipoctal_irq_handler(void *arg)
 		if ((ipoctal->board_id == IPACK1_DEVICE_ID_SBS_OCTAL_485) &&
 		    (sr & SR_TX_EMPTY) &&
 		    (channel->nb_bytes == 0)) {
-			ipoctal_write_io_reg(ipoctal,
-					     &channel->regs->w.cr,
-					     CR_DISABLE_TX);
-			ipoctal_write_cr_cmd(ipoctal,
-					     &channel->regs->w.cr,
-					     CR_CMD_NEGATE_RTSN);
-			ipoctal_write_io_reg(ipoctal,
-					     &channel->regs->w.cr,
-					     CR_ENABLE_RX);
+			iowrite8(CR_DISABLE_TX, &channel->regs->w.cr);
+			iowrite8(CR_CMD_NEGATE_RTSN, &channel->regs->w.cr);
+			iowrite8(CR_ENABLE_RX, &channel->regs->w.cr);
 			ipoctal->write = 1;
 			wake_up_interruptible(&channel->queue);
 		}
 
 		/* RX data */
 		if (isr_rx_rdy && (sr & SR_RX_READY)) {
-			value = ipoctal_read_io_reg(ipoctal,
-						    &channel->regs->r.rhr);
+			value = ioread8(&channel->regs->r.rhr);
 			flag = TTY_NORMAL;
 
 			/* Error: count statistics */
 			if (sr & SR_ERROR) {
-				ipoctal_write_cr_cmd(ipoctal,
-						     &channel->regs->w.cr,
-						     CR_CMD_RESET_ERR_STATUS);
+				iowrite8(CR_CMD_RESET_ERR_STATUS, &channel->regs->w.cr);
 
 				if (sr & SR_OVERRUN_ERROR) {
 					channel->stats.overrun_err++;
@@ -292,9 +260,7 @@ static int ipoctal_irq_handler(void *arg)
 			}
 
 			value = channel->tty_port.xmit_buf[*pointer_write];
-			ipoctal_write_io_reg(ipoctal,
-					     &channel->regs->w.thr,
-					     value);
+			iowrite8(value, &channel->regs->w.thr);
 			channel->stats.tx++;
 			channel->count_wr++;
 			(*pointer_write)++;
@@ -405,37 +371,22 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 		channel->regs = chan_regs + i;
 		channel->block_regs = block_regs + (i >> 1);
 
-		ipoctal_write_io_reg(ipoctal, &channel->regs->w.cr,
-				     CR_DISABLE_RX | CR_DISABLE_TX);
-		ipoctal_write_cr_cmd(ipoctal, &channel->regs->w.cr,
-				     CR_CMD_RESET_RX);
-		ipoctal_write_cr_cmd(ipoctal, &channel->regs->w.cr,
-				     CR_CMD_RESET_TX);
-		ipoctal_write_io_reg(ipoctal,
-				     &channel->regs->w.mr,
-				     MR1_CHRL_8_BITS | MR1_ERROR_CHAR |
-				     MR1_RxINT_RxRDY); /* mr1 */
-		ipoctal_write_io_reg(ipoctal,
-				     &channel->regs->w.mr,
-				     0); /* mr2 */
-		ipoctal_write_io_reg(ipoctal,
-				     &channel->regs->w.csr,
-				     TX_CLK_9600  | RX_CLK_9600);
+		iowrite8(CR_DISABLE_RX | CR_DISABLE_TX, &channel->regs->w.cr);
+		iowrite8(CR_CMD_RESET_RX, &channel->regs->w.cr);
+		iowrite8(CR_CMD_RESET_TX, &channel->regs->w.cr);
+		iowrite8(MR1_CHRL_8_BITS | MR1_ERROR_CHAR | MR1_RxINT_RxRDY,
+			 &channel->regs->w.mr); /* mr1 */
+		iowrite8(0, &channel->regs->w.mr); /* mr2 */
+		iowrite8(TX_CLK_9600  | RX_CLK_9600, &channel->regs->w.csr);
 	}
 
 	for (i = 0; i < IP_OCTAL_NB_BLOCKS; i++) {
-		ipoctal_write_io_reg(ipoctal,
-				     &block_regs[i].w.acr,
-				     ACR_BRG_SET2);
-		ipoctal_write_io_reg(ipoctal,
-				     &block_regs[i].w.opcr,
-				     OPCR_MPP_OUTPUT | OPCR_MPOa_RTSN |
-				     OPCR_MPOb_RTSN);
-		ipoctal_write_io_reg(ipoctal,
-				     &block_regs[i].w.imr,
-				     IMR_TxRDY_A | IMR_RxRDY_FFULL_A |
-				     IMR_DELTA_BREAK_A | IMR_TxRDY_B |
-				     IMR_RxRDY_FFULL_B | IMR_DELTA_BREAK_B);
+		iowrite8(ACR_BRG_SET2, &block_regs[i].w.acr);
+		iowrite8(OPCR_MPP_OUTPUT | OPCR_MPOa_RTSN | OPCR_MPOb_RTSN,
+			 &block_regs[i].w.opcr);
+		iowrite8(IMR_TxRDY_A | IMR_RxRDY_FFULL_A | IMR_DELTA_BREAK_A |
+			 IMR_TxRDY_B | IMR_RxRDY_FFULL_B | IMR_DELTA_BREAK_B,
+			 &block_regs[i].w.imr);
 	}
 
 	/*
@@ -504,8 +455,7 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 		 * Enable again the RX. TX will be enabled when
 		 * there is something to send
 		 */
-		ipoctal_write_io_reg(ipoctal, &channel->regs->w.cr,
-				     CR_ENABLE_RX);
+		iowrite8(CR_ENABLE_RX, &channel->regs->w.cr);
 	}
 
 	return 0;
@@ -553,25 +503,17 @@ static int ipoctal_write(struct ipoctal *ipoctal, unsigned int ichannel,
 
 	/* As the IP-OCTAL 485 only supports half duplex, do it manually */
 	if (ipoctal->board_id == IPACK1_DEVICE_ID_SBS_OCTAL_485) {
-		ipoctal_write_io_reg(ipoctal,
-				     &channel->regs->w.cr,
-				     CR_DISABLE_RX);
-		ipoctal_write_cr_cmd(ipoctal,
-				     &channel->regs->w.cr,
-				     CR_CMD_ASSERT_RTSN);
+		iowrite8(CR_DISABLE_RX, &channel->regs->w.cr);
+		iowrite8(CR_CMD_ASSERT_RTSN, &channel->regs->w.cr);
 	}
 
 	/*
 	 * Send a packet and then disable TX to avoid failure after several send
 	 * operations
 	 */
-	ipoctal_write_io_reg(ipoctal,
-			     &channel->regs->w.cr,
-			     CR_ENABLE_TX);
+	iowrite8(CR_ENABLE_TX, &channel->regs->w.cr);
 	wait_event_interruptible(channel->queue, ipoctal->write);
-	ipoctal_write_io_reg(ipoctal,
-			     &channel->regs->w.cr,
-			     CR_DISABLE_TX);
+	iowrite8(CR_DISABLE_TX, &channel->regs->w.cr);
 
 	ipoctal->write = 0;
 	return channel->count_wr;
@@ -615,16 +557,11 @@ static void ipoctal_set_termios(struct tty_struct *tty,
 	cflag = tty->termios->c_cflag;
 
 	/* Disable and reset everything before change the setup */
-	ipoctal_write_io_reg(ipoctal, &channel->regs->w.cr,
-			     CR_DISABLE_RX | CR_DISABLE_TX);
-	ipoctal_write_cr_cmd(ipoctal, &channel->regs->w.cr,
-			     CR_CMD_RESET_RX);
-	ipoctal_write_cr_cmd(ipoctal, &channel->regs->w.cr,
-			     CR_CMD_RESET_TX);
-	ipoctal_write_cr_cmd(ipoctal, &channel->regs->w.cr,
-			     CR_CMD_RESET_ERR_STATUS);
-	ipoctal_write_cr_cmd(ipoctal, &channel->regs->w.cr,
-			     CR_CMD_RESET_MR);
+	iowrite8(CR_DISABLE_RX | CR_DISABLE_TX, &channel->regs->w.cr);
+	iowrite8(CR_CMD_RESET_RX, &channel->regs->w.cr);
+	iowrite8(CR_CMD_RESET_TX, &channel->regs->w.cr);
+	iowrite8(CR_CMD_RESET_ERR_STATUS, &channel->regs->w.cr);
+	iowrite8(CR_CMD_RESET_MR, &channel->regs->w.cr);
 
 	/* Set Bits per chars */
 	switch (cflag & CSIZE) {
@@ -737,13 +674,12 @@ static void ipoctal_set_termios(struct tty_struct *tty,
 	mr1 |= MR1_RxINT_RxRDY;
 
 	/* Write the control registers */
-	ipoctal_write_io_reg(ipoctal, &channel->regs->w.mr, mr1);
-	ipoctal_write_io_reg(ipoctal, &channel->regs->w.mr, mr2);
-	ipoctal_write_io_reg(ipoctal, &channel->regs->w.csr, csr);
+	iowrite8(mr1, &channel->regs->w.mr);
+	iowrite8(mr2, &channel->regs->w.mr);
+	iowrite8(csr, &channel->regs->w.csr);
 
 	/* Enable again the RX */
-	ipoctal_write_io_reg(ipoctal, &channel->regs->w.cr,
-			     CR_ENABLE_RX);
+	iowrite8(CR_ENABLE_RX, &channel->regs->w.cr);
 }
 
 static void ipoctal_hangup(struct tty_struct *tty)
@@ -763,16 +699,11 @@ static void ipoctal_hangup(struct tty_struct *tty)
 
 	tty_port_hangup(&channel->tty_port);
 
-	ipoctal_write_io_reg(ipoctal, &channel->regs->w.cr,
-			     CR_DISABLE_RX | CR_DISABLE_TX);
-	ipoctal_write_cr_cmd(ipoctal, &channel->regs->w.cr,
-			     CR_CMD_RESET_RX);
-	ipoctal_write_cr_cmd(ipoctal, &channel->regs->w.cr,
-			     CR_CMD_RESET_TX);
-	ipoctal_write_cr_cmd(ipoctal, &channel->regs->w.cr,
-			     CR_CMD_RESET_ERR_STATUS);
-	ipoctal_write_cr_cmd(ipoctal, &channel->regs->w.cr,
-			     CR_CMD_RESET_MR);
+	iowrite8(CR_DISABLE_RX | CR_DISABLE_TX, &channel->regs->w.cr);
+	iowrite8(CR_CMD_RESET_RX, &channel->regs->w.cr);
+	iowrite8(CR_CMD_RESET_TX, &channel->regs->w.cr);
+	iowrite8(CR_CMD_RESET_ERR_STATUS, &channel->regs->w.cr);
+	iowrite8(CR_CMD_RESET_MR, &channel->regs->w.cr);
 
 	clear_bit(ASYNCB_INITIALIZED, &channel->tty_port.flags);
 	wake_up_interruptible(&channel->tty_port.open_wait);
-- 
1.7.10.4


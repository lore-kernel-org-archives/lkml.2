Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab2IDPKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:10:47 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:34934 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932431Ab2IDPKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:10:40 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Sep 2012 11:10:17 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkCAGIWRlBbdWObgWdsb2JhbABFhgW1JSIBARYmJ4IgAQEFIwQLAUYQIAUCJgICVwYThhGCAKd7kmCBIZAMgRIDlVmSf4Ff
X-IronPort-AV: E=Sophos;i="4.80,367,1344204000"; 
   d="scan'208";a="561821817"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 07/16] Staging: ipack/devices/ipoctal: Tidy up ipoctal some more.
Date: Tue,  4 Sep 2012 17:01:12 +0200
Message-Id: <1346770881-4723-8-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
References: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

No need to have a struct when it has only one field.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |   82 +++++++++++-----------
 drivers/staging/ipack/devices/scc2698.h |  116 +++++++++++++++----------------
 2 files changed, 97 insertions(+), 101 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 76f8427..c1d0c00 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -40,8 +40,8 @@ struct ipoctal {
 	struct list_head		list;
 	struct ipack_device		*dev;
 	unsigned int			board_id;
-	struct scc2698_channel __iomem	*chan_regs;
-	struct scc2698_block __iomem	*block_regs;
+	union scc2698_channel __iomem	*chan_regs;
+	union scc2698_block __iomem	*block_regs;
 	struct ipoctal_stats		chan_stats[NR_CHANNELS];
 	unsigned int			nb_bytes[NR_CHANNELS];
 	unsigned int			count_wr[NR_CHANNELS];
@@ -103,7 +103,7 @@ static int ipoctal_port_activate(struct tty_port *port, struct tty_struct *tty)
 		return -ENODEV;
 	}
 
-	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
+	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].w.cr,
 			     CR_ENABLE_RX);
 	return 0;
 }
@@ -216,9 +216,9 @@ static int ipoctal_irq_handler(void *arg)
 		 */
 		block = channel / 2;
 		isr = ipoctal_read_io_reg(ipoctal,
-					  &ipoctal->block_regs[block].u.r.isr);
+					  &ipoctal->block_regs[block].r.isr);
 		sr = ipoctal_read_io_reg(ipoctal,
-					 &ipoctal->chan_regs[channel].u.r.sr);
+					 &ipoctal->chan_regs[channel].r.sr);
 
 		if ((channel % 2) == 1) {
 			isr_tx_rdy = isr & ISR_TxRDY_B;
@@ -235,13 +235,13 @@ static int ipoctal_irq_handler(void *arg)
 		    (sr & SR_TX_EMPTY) &&
 		    (ipoctal->nb_bytes[channel] == 0)) {
 			ipoctal_write_io_reg(ipoctal,
-					     &ipoctal->chan_regs[channel].u.w.cr,
+					     &ipoctal->chan_regs[channel].w.cr,
 					     CR_DISABLE_TX);
 			ipoctal_write_cr_cmd(ipoctal,
-					     &ipoctal->chan_regs[channel].u.w.cr,
+					     &ipoctal->chan_regs[channel].w.cr,
 					     CR_CMD_NEGATE_RTSN);
 			ipoctal_write_io_reg(ipoctal,
-					     &ipoctal->chan_regs[channel].u.w.cr,
+					     &ipoctal->chan_regs[channel].w.cr,
 					     CR_ENABLE_RX);
 			ipoctal->write = 1;
 			wake_up_interruptible(&ipoctal->queue[channel]);
@@ -250,13 +250,13 @@ static int ipoctal_irq_handler(void *arg)
 		/* RX data */
 		if (isr_rx_rdy && (sr & SR_RX_READY)) {
 			value = ipoctal_read_io_reg(ipoctal,
-						    &ipoctal->chan_regs[channel].u.r.rhr);
+						    &ipoctal->chan_regs[channel].r.rhr);
 			flag = TTY_NORMAL;
 
 			/* Error: count statistics */
 			if (sr & SR_ERROR) {
 				ipoctal_write_cr_cmd(ipoctal,
-						     &ipoctal->chan_regs[channel].u.w.cr,
+						     &ipoctal->chan_regs[channel].w.cr,
 						     CR_CMD_RESET_ERR_STATUS);
 
 				if (sr & SR_OVERRUN_ERROR) {
@@ -293,7 +293,7 @@ static int ipoctal_irq_handler(void *arg)
 
 			value = ipoctal->tty_port[channel].xmit_buf[*pointer_write];
 			ipoctal_write_io_reg(ipoctal,
-					     &ipoctal->chan_regs[channel].u.w.thr,
+					     &ipoctal->chan_regs[channel].w.thr,
 					     value);
 			ipoctal->chan_stats[channel].tx++;
 			ipoctal->count_wr[channel]++;
@@ -391,40 +391,40 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 
 	/* Save the virtual address to access the registers easily */
 	ipoctal->chan_regs =
-		(struct scc2698_channel __iomem *) ipoctal->dev->io_space.address;
+		(union scc2698_channel __iomem *) ipoctal->dev->io_space.address;
 	ipoctal->block_regs =
-		(struct scc2698_block __iomem *) ipoctal->dev->io_space.address;
+		(union scc2698_block __iomem *) ipoctal->dev->io_space.address;
 
 	/* Disable RX and TX before touching anything */
 	for (i = 0; i < NR_CHANNELS ; i++) {
-		ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[i].u.w.cr,
+		ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[i].w.cr,
 				     CR_DISABLE_RX | CR_DISABLE_TX);
-		ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[i].u.w.cr,
+		ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[i].w.cr,
 				     CR_CMD_RESET_RX);
-		ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[i].u.w.cr,
+		ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[i].w.cr,
 				     CR_CMD_RESET_TX);
 		ipoctal_write_io_reg(ipoctal,
-				     &ipoctal->chan_regs[i].u.w.mr,
+				     &ipoctal->chan_regs[i].w.mr,
 				     MR1_CHRL_8_BITS | MR1_ERROR_CHAR |
 				     MR1_RxINT_RxRDY); /* mr1 */
 		ipoctal_write_io_reg(ipoctal,
-				     &ipoctal->chan_regs[i].u.w.mr,
+				     &ipoctal->chan_regs[i].w.mr,
 				     0); /* mr2 */
 		ipoctal_write_io_reg(ipoctal,
-				     &ipoctal->chan_regs[i].u.w.csr,
+				     &ipoctal->chan_regs[i].w.csr,
 				     TX_CLK_9600  | RX_CLK_9600);
 	}
 
 	for (i = 0; i < IP_OCTAL_NB_BLOCKS; i++) {
 		ipoctal_write_io_reg(ipoctal,
-				     &ipoctal->block_regs[i].u.w.acr,
+				     &ipoctal->block_regs[i].w.acr,
 				     ACR_BRG_SET2);
 		ipoctal_write_io_reg(ipoctal,
-				     &ipoctal->block_regs[i].u.w.opcr,
+				     &ipoctal->block_regs[i].w.opcr,
 				     OPCR_MPP_OUTPUT | OPCR_MPOa_RTSN |
 				     OPCR_MPOb_RTSN);
 		ipoctal_write_io_reg(ipoctal,
-				     &ipoctal->block_regs[i].u.w.imr,
+				     &ipoctal->block_regs[i].w.imr,
 				     IMR_TxRDY_A | IMR_RxRDY_FFULL_A |
 				     IMR_DELTA_BREAK_A | IMR_TxRDY_B |
 				     IMR_RxRDY_FFULL_B | IMR_DELTA_BREAK_B);
@@ -495,7 +495,7 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 		 * Enable again the RX. TX will be enabled when
 		 * there is something to send
 		 */
-		ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[i].u.w.cr,
+		ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[i].w.cr,
 				     CR_ENABLE_RX);
 	}
 
@@ -545,10 +545,10 @@ static int ipoctal_write(struct ipoctal *ipoctal, unsigned int channel,
 	/* As the IP-OCTAL 485 only supports half duplex, do it manually */
 	if (ipoctal->board_id == IP_OCTAL_485_ID) {
 		ipoctal_write_io_reg(ipoctal,
-				     &ipoctal->chan_regs[channel].u.w.cr,
+				     &ipoctal->chan_regs[channel].w.cr,
 				     CR_DISABLE_RX);
 		ipoctal_write_cr_cmd(ipoctal,
-				     &ipoctal->chan_regs[channel].u.w.cr,
+				     &ipoctal->chan_regs[channel].w.cr,
 				     CR_CMD_ASSERT_RTSN);
 	}
 
@@ -557,11 +557,11 @@ static int ipoctal_write(struct ipoctal *ipoctal, unsigned int channel,
 	 * operations
 	 */
 	ipoctal_write_io_reg(ipoctal,
-			     &ipoctal->chan_regs[channel].u.w.cr,
+			     &ipoctal->chan_regs[channel].w.cr,
 			     CR_ENABLE_TX);
 	wait_event_interruptible(ipoctal->queue[channel], ipoctal->write);
 	ipoctal_write_io_reg(ipoctal,
-			     &ipoctal->chan_regs[channel].u.w.cr,
+			     &ipoctal->chan_regs[channel].w.cr,
 			     CR_DISABLE_TX);
 
 	ipoctal->write = 0;
@@ -607,15 +607,15 @@ static void ipoctal_set_termios(struct tty_struct *tty,
 	cflag = tty->termios->c_cflag;
 
 	/* Disable and reset everything before change the setup */
-	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
+	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].w.cr,
 			     CR_DISABLE_RX | CR_DISABLE_TX);
-	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
+	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].w.cr,
 			     CR_CMD_RESET_RX);
-	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
+	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].w.cr,
 			     CR_CMD_RESET_TX);
-	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
+	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].w.cr,
 			     CR_CMD_RESET_ERR_STATUS);
-	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
+	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].w.cr,
 			     CR_CMD_RESET_MR);
 
 	/* Set Bits per chars */
@@ -729,12 +729,12 @@ static void ipoctal_set_termios(struct tty_struct *tty,
 	mr1 |= MR1_RxINT_RxRDY;
 
 	/* Write the control registers */
-	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.mr, mr1);
-	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.mr, mr2);
-	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.csr, csr);
+	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].w.mr, mr1);
+	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].w.mr, mr2);
+	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].w.csr, csr);
 
 	/* Enable again the RX */
-	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
+	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].w.cr,
 			     CR_ENABLE_RX);
 }
 
@@ -755,15 +755,15 @@ static void ipoctal_hangup(struct tty_struct *tty)
 
 	tty_port_hangup(&ipoctal->tty_port[channel]);
 
-	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
+	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].w.cr,
 			     CR_DISABLE_RX | CR_DISABLE_TX);
-	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
+	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].w.cr,
 			     CR_CMD_RESET_RX);
-	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
+	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].w.cr,
 			     CR_CMD_RESET_TX);
-	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
+	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].w.cr,
 			     CR_CMD_RESET_ERR_STATUS);
-	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
+	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].w.cr,
 			     CR_CMD_RESET_MR);
 
 	clear_bit(ASYNCB_INITIALIZED, &ipoctal->tty_port[channel].flags);
diff --git a/drivers/staging/ipack/devices/scc2698.h b/drivers/staging/ipack/devices/scc2698.h
index fcab427..223838a 100644
--- a/drivers/staging/ipack/devices/scc2698.h
+++ b/drivers/staging/ipack/devices/scc2698.h
@@ -15,78 +15,74 @@
 #define SCC2698_H_
 
 /*
- * struct scc2698_channel - Channel access to scc2698 IO
+ * union scc2698_channel - Channel access to scc2698 IO
  *
  * dn value are only spacer.
  *
  */
-struct scc2698_channel {
-	union {
-		struct {
-			u8 d0, mr;  /* Mode register 1/2*/
-			u8 d1, sr;  /* Status register */
-			u8 d2, r1;  /* reserved */
-			u8 d3, rhr; /* Receive holding register (R) */
-			u8 junk[8]; /* other crap for block control */
-		} __packed r; /* Read access */
-		struct {
-			u8 d0, mr;  /* Mode register 1/2 */
-			u8 d1, csr; /* Clock select register */
-			u8 d2, cr;  /* Command register */
-			u8 d3, thr; /* Transmit holding register */
-			u8 junk[8]; /* other crap for block control */
-		} __packed w; /* Write access */
-	} u;
-} __packed;
+union scc2698_channel {
+	struct {
+		u8 d0, mr;  /* Mode register 1/2*/
+		u8 d1, sr;  /* Status register */
+		u8 d2, r1;  /* reserved */
+		u8 d3, rhr; /* Receive holding register (R) */
+		u8 junk[8]; /* other crap for block control */
+	} __packed r; /* Read access */
+	struct {
+		u8 d0, mr;  /* Mode register 1/2 */
+		u8 d1, csr; /* Clock select register */
+		u8 d2, cr;  /* Command register */
+		u8 d3, thr; /* Transmit holding register */
+		u8 junk[8]; /* other crap for block control */
+	} __packed w; /* Write access */
+};
 
 /*
- * struct scc2698_block - Block access to scc2698 IO
+ * union scc2698_block - Block access to scc2698 IO
  *
  * The scc2698 contain 4 block.
  * Each block containt two channel a and b.
  * dn value are only spacer.
  *
  */
-struct scc2698_block {
-	union {
-		struct {
-			u8 d0, mra;  /* Mode register 1/2 (a) */
-			u8 d1, sra;  /* Status register (a) */
-			u8 d2, r1;   /* reserved */
-			u8 d3, rhra; /* Receive holding register (a) */
-			u8 d4, ipcr; /* Input port change register of block */
-			u8 d5, isr;  /* Interrupt status register of block */
-			u8 d6, ctur; /* Counter timer upper register of block */
-			u8 d7, ctlr; /* Counter timer lower register of block */
-			u8 d8, mrb;  /* Mode register 1/2 (b) */
-			u8 d9, srb;  /* Status register (b) */
-			u8 da, r2;   /* reserved */
-			u8 db, rhrb; /* Receive holding register (b) */
-			u8 dc, r3;   /* reserved */
-			u8 dd, ip;   /* Input port register of block */
-			u8 de, ctg;  /* Start counter timer of block */
-			u8 df, cts;  /* Stop counter timer of block */
-		} __packed r; /* Read access */
-		struct {
-			u8 d0, mra;  /* Mode register 1/2 (a) */
-			u8 d1, csra; /* Clock select register (a) */
-			u8 d2, cra;  /* Command register (a) */
-			u8 d3, thra; /* Transmit holding register (a) */
-			u8 d4, acr;  /* Auxiliary control register of block */
-			u8 d5, imr;  /* Interrupt mask register of block  */
-			u8 d6, ctu;  /* Counter timer upper register of block */
-			u8 d7, ctl;  /* Counter timer lower register of block */
-			u8 d8, mrb;  /* Mode register 1/2 (b) */
-			u8 d9, csrb; /* Clock select register (a) */
-			u8 da, crb;  /* Command register (b) */
-			u8 db, thrb; /* Transmit holding register (b) */
-			u8 dc, r1;   /* reserved */
-			u8 dd, opcr; /* Output port configuration register of block */
-			u8 de, r2;   /* reserved */
-			u8 df, r3;   /* reserved */
-		} __packed w; /* Write access */
-	} u;
-} __packed;
+union scc2698_block {
+	struct {
+		u8 d0, mra;  /* Mode register 1/2 (a) */
+		u8 d1, sra;  /* Status register (a) */
+		u8 d2, r1;   /* reserved */
+		u8 d3, rhra; /* Receive holding register (a) */
+		u8 d4, ipcr; /* Input port change register of block */
+		u8 d5, isr;  /* Interrupt status register of block */
+		u8 d6, ctur; /* Counter timer upper register of block */
+		u8 d7, ctlr; /* Counter timer lower register of block */
+		u8 d8, mrb;  /* Mode register 1/2 (b) */
+		u8 d9, srb;  /* Status register (b) */
+		u8 da, r2;   /* reserved */
+		u8 db, rhrb; /* Receive holding register (b) */
+		u8 dc, r3;   /* reserved */
+		u8 dd, ip;   /* Input port register of block */
+		u8 de, ctg;  /* Start counter timer of block */
+		u8 df, cts;  /* Stop counter timer of block */
+	} __packed r; /* Read access */
+	struct {
+		u8 d0, mra;  /* Mode register 1/2 (a) */
+		u8 d1, csra; /* Clock select register (a) */
+		u8 d2, cra;  /* Command register (a) */
+		u8 d3, thra; /* Transmit holding register (a) */
+		u8 d4, acr;  /* Auxiliary control register of block */
+		u8 d5, imr;  /* Interrupt mask register of block  */
+		u8 d6, ctu;  /* Counter timer upper register of block */
+		u8 d7, ctl;  /* Counter timer lower register of block */
+		u8 d8, mrb;  /* Mode register 1/2 (b) */
+		u8 d9, csrb; /* Clock select register (a) */
+		u8 da, crb;  /* Command register (b) */
+		u8 db, thrb; /* Transmit holding register (b) */
+		u8 dc, r1;   /* reserved */
+		u8 dd, opcr; /* Output port configuration register of block */
+		u8 de, r2;   /* reserved */
+		u8 df, r3;   /* reserved */
+	} __packed w; /* Write access */
+};
 
 #define MR1_CHRL_5_BITS             (0x0 << 0)
 #define MR1_CHRL_6_BITS             (0x1 << 0)
-- 
1.7.10.4


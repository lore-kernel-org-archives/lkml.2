Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583Ab2ILNFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:05:33 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:15608 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758043Ab2ILMzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:55:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqECACCFUFBbdWObgWdsb2JhbABFu0AiAQEWJieCIAEBBSdSECAxVwYTiBG8YpFSA5VfiTOJVA
X-IronPort-AV: E=Sophos;i="4.80,410,1344204000"; 
   d="scan'208";a="950511720"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 04/24] Staging: ipack/devices/ipoctal: split ipoctal_channel from ipoctal.
Date: Wed, 12 Sep 2012 14:55:26 +0200
Message-Id: <1347454546-23236-4-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

By moving everything channel related into a separate struct we will be
able to clean up a lot of code.  In the end tty->driver_data will no
longer need to point to ipoctal but instead can point to the respective
channel.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |  286 ++++++++++++++++---------------
 1 file changed, 150 insertions(+), 136 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 35513d9..9ab0e80 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -30,22 +30,26 @@
 
 static const struct tty_operations ipoctal_fops;
 
+struct ipoctal_channel {
+	struct ipoctal_stats		stats;
+	unsigned int			nb_bytes;
+	unsigned int			count_wr;
+	wait_queue_head_t		queue;
+	spinlock_t			lock;
+	unsigned int			pointer_read;
+	unsigned int			pointer_write;
+	atomic_t			open;
+	struct tty_port			tty_port;
+	union scc2698_channel __iomem	*regs;
+	union scc2698_block __iomem	*block_regs;
+};
+
 struct ipoctal {
 	struct list_head		list;
 	struct ipack_device		*dev;
 	unsigned int			board_id;
-	union scc2698_channel __iomem	*chan_regs;
-	union scc2698_block __iomem	*block_regs;
-	struct ipoctal_stats		chan_stats[NR_CHANNELS];
-	unsigned int			nb_bytes[NR_CHANNELS];
-	unsigned int			count_wr[NR_CHANNELS];
-	wait_queue_head_t		queue[NR_CHANNELS];
-	spinlock_t			lock[NR_CHANNELS];
-	unsigned int			pointer_read[NR_CHANNELS];
-	unsigned int			pointer_write[NR_CHANNELS];
-	atomic_t			open[NR_CHANNELS];
+	struct ipoctal_channel		channel[NR_CHANNELS];
 	unsigned char			write;
-	struct tty_port			tty_port[NR_CHANNELS];
 	struct tty_driver		*tty_drv;
 };
 
@@ -87,7 +91,7 @@ static struct ipoctal *ipoctal_find_board(struct tty_struct *tty)
 static int ipoctal_port_activate(struct tty_port *port, struct tty_struct *tty)
 {
 	struct ipoctal *ipoctal;
-	int channel = tty->index;
+	struct ipoctal_channel *channel;
 
 	ipoctal = ipoctal_find_board(tty);
 
@@ -96,17 +100,18 @@ static int ipoctal_port_activate(struct tty_port *port, struct tty_struct *tty)
 			tty->driver->major);
 		return -ENODEV;
 	}
+	channel = &ipoctal->channel[tty->index];
 
-	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].w.cr,
+	ipoctal_write_io_reg(ipoctal, &channel->regs->w.cr,
 			     CR_ENABLE_RX);
 	return 0;
 }
 
 static int ipoctal_open(struct tty_struct *tty, struct file *file)
 {
-	int channel = tty->index;
 	int res;
 	struct ipoctal *ipoctal;
+	struct ipoctal_channel *channel;
 
 	ipoctal = ipoctal_find_board(tty);
 
@@ -115,17 +120,18 @@ static int ipoctal_open(struct tty_struct *tty, struct file *file)
 			tty->driver->major);
 		return -ENODEV;
 	}
+	channel = &ipoctal->channel[tty->index];
 
-	if (atomic_read(&ipoctal->open[channel]))
+	if (atomic_read(&channel->open))
 		return -EBUSY;
 
 	tty->driver_data = ipoctal;
 
-	res = tty_port_open(&ipoctal->tty_port[channel], tty, file);
+	res = tty_port_open(&channel->tty_port, tty, file);
 	if (res)
 		return res;
 
-	atomic_inc(&ipoctal->open[channel]);
+	atomic_inc(&channel->open);
 	return 0;
 }
 
@@ -141,26 +147,27 @@ static void ipoctal_reset_stats(struct ipoctal_stats *stats)
 
 static void ipoctal_free_channel(struct tty_struct *tty)
 {
-	int channel = tty->index;
 	struct ipoctal *ipoctal = tty->driver_data;
+	struct ipoctal_channel *channel;
 
 	if (ipoctal == NULL)
 		return;
+	channel = &ipoctal->channel[tty->index];
 
-	ipoctal_reset_stats(&ipoctal->chan_stats[channel]);
-	ipoctal->pointer_read[channel] = 0;
-	ipoctal->pointer_write[channel] = 0;
-	ipoctal->nb_bytes[channel] = 0;
+	ipoctal_reset_stats(&channel->stats);
+	channel->pointer_read = 0;
+	channel->pointer_write = 0;
+	channel->nb_bytes = 0;
 }
 
 static void ipoctal_close(struct tty_struct *tty, struct file *filp)
 {
-	int channel = tty->index;
 	struct ipoctal *ipoctal = tty->driver_data;
+	struct ipoctal_channel *channel = &ipoctal->channel[tty->index];
 
-	tty_port_close(&ipoctal->tty_port[channel], tty, filp);
+	tty_port_close(&channel->tty_port, tty, filp);
 
-	if (atomic_dec_and_test(&ipoctal->open[channel]))
+	if (atomic_dec_and_test(&channel->open))
 		ipoctal_free_channel(tty);
 }
 
@@ -168,24 +175,23 @@ static int ipoctal_get_icount(struct tty_struct *tty,
 			      struct serial_icounter_struct *icount)
 {
 	struct ipoctal *ipoctal = tty->driver_data;
-	int channel = tty->index;
+	struct ipoctal_channel *channel = &ipoctal->channel[tty->index];
 
 	icount->cts = 0;
 	icount->dsr = 0;
 	icount->rng = 0;
 	icount->dcd = 0;
-	icount->rx = ipoctal->chan_stats[channel].rx;
-	icount->tx = ipoctal->chan_stats[channel].tx;
-	icount->frame = ipoctal->chan_stats[channel].framing_err;
-	icount->parity = ipoctal->chan_stats[channel].parity_err;
-	icount->brk = ipoctal->chan_stats[channel].rcv_break;
+	icount->rx = channel->stats.rx;
+	icount->tx = channel->stats.tx;
+	icount->frame = channel->stats.framing_err;
+	icount->parity = channel->stats.parity_err;
+	icount->brk = channel->stats.rcv_break;
 	return 0;
 }
 
 static int ipoctal_irq_handler(void *arg)
 {
-	unsigned int channel;
-	unsigned int block;
+	unsigned int ichannel;
 	unsigned char isr;
 	unsigned char sr;
 	unsigned char isr_tx_rdy, isr_rx_rdy;
@@ -193,14 +199,16 @@ static int ipoctal_irq_handler(void *arg)
 	unsigned char flag;
 	struct tty_struct *tty;
 	struct ipoctal *ipoctal = (struct ipoctal *) arg;
+	struct ipoctal_channel *channel;
 
 	/* Check all channels */
-	for (channel = 0; channel < NR_CHANNELS; channel++) {
+	for (ichannel = 0; ichannel < NR_CHANNELS; ichannel++) {
+		channel = &ipoctal->channel[ichannel];
 		/* If there is no client, skip the check */
-		if (!atomic_read(&ipoctal->open[channel]))
+		if (!atomic_read(&channel->open))
 			continue;
 
-		tty = tty_port_tty_get(&ipoctal->tty_port[channel]);
+		tty = tty_port_tty_get(&channel->tty_port);
 		if (!tty)
 			continue;
 
@@ -208,13 +216,12 @@ static int ipoctal_irq_handler(void *arg)
 		 * The HW is organized in pair of channels.
 		 * See which register we need to read from
 		 */
-		block = channel / 2;
 		isr = ipoctal_read_io_reg(ipoctal,
-					  &ipoctal->block_regs[block].r.isr);
+					  &channel->block_regs->r.isr);
 		sr = ipoctal_read_io_reg(ipoctal,
-					 &ipoctal->chan_regs[channel].r.sr);
+					 &channel->regs->r.sr);
 
-		if ((channel % 2) == 1) {
+		if ((ichannel % 2) == 1) {
 			isr_tx_rdy = isr & ISR_TxRDY_B;
 			isr_rx_rdy = isr & ISR_RxRDY_FFULL_B;
 		} else {
@@ -227,47 +234,47 @@ static int ipoctal_irq_handler(void *arg)
 		 */
 		if ((ipoctal->board_id == IPACK1_DEVICE_ID_SBS_OCTAL_485) &&
 		    (sr & SR_TX_EMPTY) &&
-		    (ipoctal->nb_bytes[channel] == 0)) {
+		    (channel->nb_bytes == 0)) {
 			ipoctal_write_io_reg(ipoctal,
-					     &ipoctal->chan_regs[channel].w.cr,
+					     &channel->regs->w.cr,
 					     CR_DISABLE_TX);
 			ipoctal_write_cr_cmd(ipoctal,
-					     &ipoctal->chan_regs[channel].w.cr,
+					     &channel->regs->w.cr,
 					     CR_CMD_NEGATE_RTSN);
 			ipoctal_write_io_reg(ipoctal,
-					     &ipoctal->chan_regs[channel].w.cr,
+					     &channel->regs->w.cr,
 					     CR_ENABLE_RX);
 			ipoctal->write = 1;
-			wake_up_interruptible(&ipoctal->queue[channel]);
+			wake_up_interruptible(&channel->queue);
 		}
 
 		/* RX data */
 		if (isr_rx_rdy && (sr & SR_RX_READY)) {
 			value = ipoctal_read_io_reg(ipoctal,
-						    &ipoctal->chan_regs[channel].r.rhr);
+						    &channel->regs->r.rhr);
 			flag = TTY_NORMAL;
 
 			/* Error: count statistics */
 			if (sr & SR_ERROR) {
 				ipoctal_write_cr_cmd(ipoctal,
-						     &ipoctal->chan_regs[channel].w.cr,
+						     &channel->regs->w.cr,
 						     CR_CMD_RESET_ERR_STATUS);
 
 				if (sr & SR_OVERRUN_ERROR) {
-					ipoctal->chan_stats[channel].overrun_err++;
+					channel->stats.overrun_err++;
 					/* Overrun doesn't affect the current character*/
 					tty_insert_flip_char(tty, 0, TTY_OVERRUN);
 				}
 				if (sr & SR_PARITY_ERROR) {
-					ipoctal->chan_stats[channel].parity_err++;
+					channel->stats.parity_err++;
 					flag = TTY_PARITY;
 				}
 				if (sr & SR_FRAMING_ERROR) {
-					ipoctal->chan_stats[channel].framing_err++;
+					channel->stats.framing_err++;
 					flag = TTY_FRAME;
 				}
 				if (sr & SR_RECEIVED_BREAK) {
-					ipoctal->chan_stats[channel].rcv_break++;
+					channel->stats.rcv_break++;
 					flag = TTY_BREAK;
 				}
 			}
@@ -277,30 +284,29 @@ static int ipoctal_irq_handler(void *arg)
 
 		/* TX of each character */
 		if (isr_tx_rdy && (sr & SR_TX_READY)) {
-			unsigned int *pointer_write =
-				&ipoctal->pointer_write[channel];
+			unsigned int *pointer_write = &channel->pointer_write;
 
-			if (ipoctal->nb_bytes[channel] <= 0) {
-				ipoctal->nb_bytes[channel] = 0;
+			if (channel->nb_bytes <= 0) {
+				channel->nb_bytes = 0;
 				continue;
 			}
 
-			value = ipoctal->tty_port[channel].xmit_buf[*pointer_write];
+			value = channel->tty_port.xmit_buf[*pointer_write];
 			ipoctal_write_io_reg(ipoctal,
-					     &ipoctal->chan_regs[channel].w.thr,
+					     &channel->regs->w.thr,
 					     value);
-			ipoctal->chan_stats[channel].tx++;
-			ipoctal->count_wr[channel]++;
+			channel->stats.tx++;
+			channel->count_wr++;
 			(*pointer_write)++;
 			*pointer_write = *pointer_write % PAGE_SIZE;
-			ipoctal->nb_bytes[channel]--;
+			channel->nb_bytes--;
 
-			if ((ipoctal->nb_bytes[channel] == 0) &&
-			    (waitqueue_active(&ipoctal->queue[channel]))) {
+			if ((channel->nb_bytes == 0) &&
+			    (waitqueue_active(&channel->queue))) {
 
 				if (ipoctal->board_id != IPACK1_DEVICE_ID_SBS_OCTAL_485) {
 					ipoctal->write = 1;
-					wake_up_interruptible(&ipoctal->queue[channel]);
+					wake_up_interruptible(&channel->queue);
 				}
 			}
 		}
@@ -348,6 +354,9 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	struct tty_driver *tty;
 	char name[20];
 	unsigned char board_id;
+	struct ipoctal_channel *channel;
+	union scc2698_channel __iomem *chan_regs;
+	union scc2698_block __iomem *block_regs;
 
 	res = ipoctal->dev->bus->ops->map_space(ipoctal->dev, 0,
 						IPACK_ID_SPACE);
@@ -385,41 +394,45 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	}
 
 	/* Save the virtual address to access the registers easily */
-	ipoctal->chan_regs =
+	chan_regs =
 		(union scc2698_channel __iomem *) ipoctal->dev->io_space.address;
-	ipoctal->block_regs =
+	block_regs =
 		(union scc2698_block __iomem *) ipoctal->dev->io_space.address;
 
 	/* Disable RX and TX before touching anything */
 	for (i = 0; i < NR_CHANNELS ; i++) {
-		ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[i].w.cr,
+		struct ipoctal_channel *channel = &ipoctal->channel[i];
+		channel->regs = chan_regs + i;
+		channel->block_regs = block_regs + (i >> 1);
+
+		ipoctal_write_io_reg(ipoctal, &channel->regs->w.cr,
 				     CR_DISABLE_RX | CR_DISABLE_TX);
-		ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[i].w.cr,
+		ipoctal_write_cr_cmd(ipoctal, &channel->regs->w.cr,
 				     CR_CMD_RESET_RX);
-		ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[i].w.cr,
+		ipoctal_write_cr_cmd(ipoctal, &channel->regs->w.cr,
 				     CR_CMD_RESET_TX);
 		ipoctal_write_io_reg(ipoctal,
-				     &ipoctal->chan_regs[i].w.mr,
+				     &channel->regs->w.mr,
 				     MR1_CHRL_8_BITS | MR1_ERROR_CHAR |
 				     MR1_RxINT_RxRDY); /* mr1 */
 		ipoctal_write_io_reg(ipoctal,
-				     &ipoctal->chan_regs[i].w.mr,
+				     &channel->regs->w.mr,
 				     0); /* mr2 */
 		ipoctal_write_io_reg(ipoctal,
-				     &ipoctal->chan_regs[i].w.csr,
+				     &channel->regs->w.csr,
 				     TX_CLK_9600  | RX_CLK_9600);
 	}
 
 	for (i = 0; i < IP_OCTAL_NB_BLOCKS; i++) {
 		ipoctal_write_io_reg(ipoctal,
-				     &ipoctal->block_regs[i].w.acr,
+				     &block_regs[i].w.acr,
 				     ACR_BRG_SET2);
 		ipoctal_write_io_reg(ipoctal,
-				     &ipoctal->block_regs[i].w.opcr,
+				     &block_regs[i].w.opcr,
 				     OPCR_MPP_OUTPUT | OPCR_MPOa_RTSN |
 				     OPCR_MPOb_RTSN);
 		ipoctal_write_io_reg(ipoctal,
-				     &ipoctal->block_regs[i].w.imr,
+				     &block_regs[i].w.imr,
 				     IMR_TxRDY_A | IMR_RxRDY_FFULL_A |
 				     IMR_DELTA_BREAK_A | IMR_TxRDY_B |
 				     IMR_RxRDY_FFULL_B | IMR_DELTA_BREAK_B);
@@ -472,25 +485,26 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	ipoctal->tty_drv = tty;
 
 	for (i = 0; i < NR_CHANNELS; i++) {
-		tty_port_init(&ipoctal->tty_port[i]);
-		tty_port_alloc_xmit_buf(&ipoctal->tty_port[i]);
-		ipoctal->tty_port[i].ops = &ipoctal_tty_port_ops;
-
-		ipoctal_reset_stats(&ipoctal->chan_stats[i]);
-		ipoctal->nb_bytes[i] = 0;
-		init_waitqueue_head(&ipoctal->queue[i]);
-
-		spin_lock_init(&ipoctal->lock[i]);
-		ipoctal->pointer_read[i] = 0;
-		ipoctal->pointer_write[i] = 0;
-		ipoctal->nb_bytes[i] = 0;
+		channel = &ipoctal->channel[i];
+		tty_port_init(&channel->tty_port);
+		tty_port_alloc_xmit_buf(&channel->tty_port);
+		channel->tty_port.ops = &ipoctal_tty_port_ops;
+
+		ipoctal_reset_stats(&channel->stats);
+		channel->nb_bytes = 0;
+		init_waitqueue_head(&channel->queue);
+
+		spin_lock_init(&channel->lock);
+		channel->pointer_read = 0;
+		channel->pointer_write = 0;
+		channel->nb_bytes = 0;
 		tty_register_device(tty, i, NULL);
 
 		/*
 		 * Enable again the RX. TX will be enabled when
 		 * there is something to send
 		 */
-		ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[i].w.cr,
+		ipoctal_write_io_reg(ipoctal, &channel->regs->w.cr,
 				     CR_ENABLE_RX);
 	}
 
@@ -505,23 +519,22 @@ out_unregister_id_space:
 	return res;
 }
 
-static inline int ipoctal_copy_write_buffer(struct ipoctal *ipoctal,
-					    unsigned int channel,
+static inline int ipoctal_copy_write_buffer(struct ipoctal_channel *channel,
 					    const unsigned char *buf,
 					    int count)
 {
 	unsigned long flags;
 	int i;
-	unsigned int *pointer_read = &ipoctal->pointer_read[channel];
+	unsigned int *pointer_read = &channel->pointer_read;
 
 	/* Copy the bytes from the user buffer to the internal one */
 	for (i = 0; i < count; i++) {
-		if (i <= (PAGE_SIZE - ipoctal->nb_bytes[channel])) {
-			spin_lock_irqsave(&ipoctal->lock[channel], flags);
-			ipoctal->tty_port[channel].xmit_buf[*pointer_read] = buf[i];
+		if (i <= (PAGE_SIZE - channel->nb_bytes)) {
+			spin_lock_irqsave(&channel->lock, flags);
+			channel->tty_port.xmit_buf[*pointer_read] = buf[i];
 			*pointer_read = (*pointer_read + 1) % PAGE_SIZE;
-			ipoctal->nb_bytes[channel]++;
-			spin_unlock_irqrestore(&ipoctal->lock[channel], flags);
+			channel->nb_bytes++;
+			spin_unlock_irqrestore(&channel->lock, flags);
 		} else {
 			break;
 		}
@@ -529,21 +542,22 @@ static inline int ipoctal_copy_write_buffer(struct ipoctal *ipoctal,
 	return i;
 }
 
-static int ipoctal_write(struct ipoctal *ipoctal, unsigned int channel,
+static int ipoctal_write(struct ipoctal *ipoctal, unsigned int ichannel,
 			 const unsigned char *buf, int count)
 {
-	ipoctal->nb_bytes[channel] = 0;
-	ipoctal->count_wr[channel] = 0;
+	struct ipoctal_channel *channel = &ipoctal->channel[ichannel];
+	channel->nb_bytes = 0;
+	channel->count_wr = 0;
 
-	ipoctal_copy_write_buffer(ipoctal, channel, buf, count);
+	ipoctal_copy_write_buffer(channel, buf, count);
 
 	/* As the IP-OCTAL 485 only supports half duplex, do it manually */
 	if (ipoctal->board_id == IPACK1_DEVICE_ID_SBS_OCTAL_485) {
 		ipoctal_write_io_reg(ipoctal,
-				     &ipoctal->chan_regs[channel].w.cr,
+				     &channel->regs->w.cr,
 				     CR_DISABLE_RX);
 		ipoctal_write_cr_cmd(ipoctal,
-				     &ipoctal->chan_regs[channel].w.cr,
+				     &channel->regs->w.cr,
 				     CR_CMD_ASSERT_RTSN);
 	}
 
@@ -552,40 +566,39 @@ static int ipoctal_write(struct ipoctal *ipoctal, unsigned int channel,
 	 * operations
 	 */
 	ipoctal_write_io_reg(ipoctal,
-			     &ipoctal->chan_regs[channel].w.cr,
+			     &channel->regs->w.cr,
 			     CR_ENABLE_TX);
-	wait_event_interruptible(ipoctal->queue[channel], ipoctal->write);
+	wait_event_interruptible(channel->queue, ipoctal->write);
 	ipoctal_write_io_reg(ipoctal,
-			     &ipoctal->chan_regs[channel].w.cr,
+			     &channel->regs->w.cr,
 			     CR_DISABLE_TX);
 
 	ipoctal->write = 0;
-	return ipoctal->count_wr[channel];
+	return channel->count_wr;
 }
 
 static int ipoctal_write_tty(struct tty_struct *tty,
 			     const unsigned char *buf, int count)
 {
-	unsigned int channel = tty->index;
 	struct ipoctal *ipoctal = tty->driver_data;
 
-	return ipoctal_write(ipoctal, channel, buf, count);
+	return ipoctal_write(ipoctal, tty->index, buf, count);
 }
 
 static int ipoctal_write_room(struct tty_struct *tty)
 {
-	int channel = tty->index;
 	struct ipoctal *ipoctal = tty->driver_data;
+	struct ipoctal_channel *channel = &ipoctal->channel[tty->index];
 
-	return PAGE_SIZE - ipoctal->nb_bytes[channel];
+	return PAGE_SIZE - channel->nb_bytes;
 }
 
 static int ipoctal_chars_in_buffer(struct tty_struct *tty)
 {
-	int channel = tty->index;
 	struct ipoctal *ipoctal = tty->driver_data;
+	struct ipoctal_channel *channel = &ipoctal->channel[tty->index];
 
-	return ipoctal->nb_bytes[channel];
+	return channel->nb_bytes;
 }
 
 static void ipoctal_set_termios(struct tty_struct *tty,
@@ -595,22 +608,22 @@ static void ipoctal_set_termios(struct tty_struct *tty,
 	unsigned char mr1 = 0;
 	unsigned char mr2 = 0;
 	unsigned char csr = 0;
-	unsigned int channel = tty->index;
 	struct ipoctal *ipoctal = tty->driver_data;
+	struct ipoctal_channel *channel = &ipoctal->channel[tty->index];
 	speed_t baud;
 
 	cflag = tty->termios->c_cflag;
 
 	/* Disable and reset everything before change the setup */
-	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].w.cr,
+	ipoctal_write_io_reg(ipoctal, &channel->regs->w.cr,
 			     CR_DISABLE_RX | CR_DISABLE_TX);
-	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].w.cr,
+	ipoctal_write_cr_cmd(ipoctal, &channel->regs->w.cr,
 			     CR_CMD_RESET_RX);
-	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].w.cr,
+	ipoctal_write_cr_cmd(ipoctal, &channel->regs->w.cr,
 			     CR_CMD_RESET_TX);
-	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].w.cr,
+	ipoctal_write_cr_cmd(ipoctal, &channel->regs->w.cr,
 			     CR_CMD_RESET_ERR_STATUS);
-	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].w.cr,
+	ipoctal_write_cr_cmd(ipoctal, &channel->regs->w.cr,
 			     CR_CMD_RESET_MR);
 
 	/* Set Bits per chars */
@@ -724,45 +737,45 @@ static void ipoctal_set_termios(struct tty_struct *tty,
 	mr1 |= MR1_RxINT_RxRDY;
 
 	/* Write the control registers */
-	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].w.mr, mr1);
-	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].w.mr, mr2);
-	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].w.csr, csr);
+	ipoctal_write_io_reg(ipoctal, &channel->regs->w.mr, mr1);
+	ipoctal_write_io_reg(ipoctal, &channel->regs->w.mr, mr2);
+	ipoctal_write_io_reg(ipoctal, &channel->regs->w.csr, csr);
 
 	/* Enable again the RX */
-	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].w.cr,
+	ipoctal_write_io_reg(ipoctal, &channel->regs->w.cr,
 			     CR_ENABLE_RX);
 }
 
 static void ipoctal_hangup(struct tty_struct *tty)
 {
 	unsigned long flags;
-	int channel = tty->index;
 	struct ipoctal *ipoctal = tty->driver_data;
+	struct ipoctal_channel *channel = &ipoctal->channel[tty->index];
 
 	if (ipoctal == NULL)
 		return;
 
-	spin_lock_irqsave(&ipoctal->lock[channel], flags);
-	ipoctal->nb_bytes[channel] = 0;
-	ipoctal->pointer_read[channel] = 0;
-	ipoctal->pointer_write[channel] = 0;
-	spin_unlock_irqrestore(&ipoctal->lock[channel], flags);
+	spin_lock_irqsave(&channel->lock, flags);
+	channel->nb_bytes = 0;
+	channel->pointer_read = 0;
+	channel->pointer_write = 0;
+	spin_unlock_irqrestore(&channel->lock, flags);
 
-	tty_port_hangup(&ipoctal->tty_port[channel]);
+	tty_port_hangup(&channel->tty_port);
 
-	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].w.cr,
+	ipoctal_write_io_reg(ipoctal, &channel->regs->w.cr,
 			     CR_DISABLE_RX | CR_DISABLE_TX);
-	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].w.cr,
+	ipoctal_write_cr_cmd(ipoctal, &channel->regs->w.cr,
 			     CR_CMD_RESET_RX);
-	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].w.cr,
+	ipoctal_write_cr_cmd(ipoctal, &channel->regs->w.cr,
 			     CR_CMD_RESET_TX);
-	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].w.cr,
+	ipoctal_write_cr_cmd(ipoctal, &channel->regs->w.cr,
 			     CR_CMD_RESET_ERR_STATUS);
-	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].w.cr,
+	ipoctal_write_cr_cmd(ipoctal, &channel->regs->w.cr,
 			     CR_CMD_RESET_MR);
 
-	clear_bit(ASYNCB_INITIALIZED, &ipoctal->tty_port[channel].flags);
-	wake_up_interruptible(&ipoctal->tty_port[channel].open_wait);
+	clear_bit(ASYNCB_INITIALIZED, &channel->tty_port.flags);
+	wake_up_interruptible(&channel->tty_port.open_wait);
 }
 
 static const struct tty_operations ipoctal_fops = {
@@ -806,8 +819,9 @@ static void __ipoctal_remove(struct ipoctal *ipoctal)
 	ipoctal->dev->bus->ops->free_irq(ipoctal->dev);
 
 	for (i = 0; i < NR_CHANNELS; i++) {
+		struct ipoctal_channel *channel = &ipoctal->channel[i];
 		tty_unregister_device(ipoctal->tty_drv, i);
-		tty_port_free_xmit_buf(&ipoctal->tty_port[i]);
+		tty_port_free_xmit_buf(&channel->tty_port);
 	}
 
 	tty_unregister_driver(ipoctal->tty_drv);
-- 
1.7.10.4


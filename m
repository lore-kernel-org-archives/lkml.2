Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411Ab2ILND6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:03:58 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:15608 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758053Ab2ILMzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:55:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqECACCFUFBbdWObgWdsb2JhbABFu0AiAQEWJieCIAEBBSdSECAxVwYTiBG8YpFSA5Vfkwc
X-IronPort-AV: E=Sophos;i="4.80,410,1344204000"; 
   d="scan'208";a="950511738"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 08/24] Staging: ipack/devices/ipoctal: Split interrupt service routine.
Date: Wed, 12 Sep 2012 14:55:30 +0200
Message-Id: <1347454546-23236-8-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Split the IRQ service routing in TX part and RX part.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |  188 ++++++++++++++++---------------
 1 file changed, 97 insertions(+), 91 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 56e810b..e0be660 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -163,109 +163,115 @@ static int ipoctal_get_icount(struct tty_struct *tty,
 	return 0;
 }
 
-static int ipoctal_irq_handler(void *arg)
+static void ipoctal_irq_rx(struct ipoctal_channel *channel,
+			   struct tty_struct *tty, u8 sr)
+{
+	unsigned char value = ioread8(&channel->regs->r.rhr);
+	unsigned char flag = TTY_NORMAL;
+
+	/* Error: count statistics */
+	if (sr & SR_ERROR) {
+		iowrite8(CR_CMD_RESET_ERR_STATUS, &channel->regs->w.cr);
+
+		if (sr & SR_OVERRUN_ERROR) {
+			channel->stats.overrun_err++;
+			/* Overrun doesn't affect the current character*/
+			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+		}
+		if (sr & SR_PARITY_ERROR) {
+			channel->stats.parity_err++;
+			flag = TTY_PARITY;
+		}
+		if (sr & SR_FRAMING_ERROR) {
+			channel->stats.framing_err++;
+			flag = TTY_FRAME;
+		}
+		if (sr & SR_RECEIVED_BREAK) {
+			channel->stats.rcv_break++;
+			flag = TTY_BREAK;
+		}
+	}
+
+	tty_insert_flip_char(tty, value, flag);
+}
+
+static void ipoctal_irq_tx(struct ipoctal_channel *channel)
 {
-	unsigned int ichannel;
-	unsigned char isr;
-	unsigned char sr;
 	unsigned char value;
-	unsigned char flag;
-	struct tty_struct *tty;
-	struct ipoctal *ipoctal = (struct ipoctal *) arg;
-	struct ipoctal_channel *channel;
+	unsigned int *pointer_write = &channel->pointer_write;
 
-	/* Check all channels */
-	for (ichannel = 0; ichannel < NR_CHANNELS; ichannel++) {
-		channel = &ipoctal->channel[ichannel];
-		/* If there is no client, skip the check */
-		if (!atomic_read(&channel->open))
-			continue;
+	if (channel->nb_bytes <= 0) {
+		channel->nb_bytes = 0;
+		return;
+	}
 
-		tty = tty_port_tty_get(&channel->tty_port);
-		if (!tty)
-			continue;
+	value = channel->tty_port.xmit_buf[*pointer_write];
+	iowrite8(value, &channel->regs->w.thr);
+	channel->stats.tx++;
+	channel->count_wr++;
+	(*pointer_write)++;
+	*pointer_write = *pointer_write % PAGE_SIZE;
+	channel->nb_bytes--;
 
-		/*
-		 * The HW is organized in pair of channels.
-		 * See which register we need to read from
-		 */
-		isr = ioread8(&channel->block_regs->r.isr);
-		sr = ioread8(&channel->regs->r.sr);
+	if ((channel->nb_bytes == 0) &&
+	    (waitqueue_active(&channel->queue))) {
 
-		/* In case of RS-485, change from TX to RX when finishing TX.
-		 * Half-duplex.
-		 */
-		if ((ipoctal->board_id == IPACK1_DEVICE_ID_SBS_OCTAL_485) &&
-		    (sr & SR_TX_EMPTY) &&
-		    (channel->nb_bytes == 0)) {
-			iowrite8(CR_DISABLE_TX, &channel->regs->w.cr);
-			iowrite8(CR_CMD_NEGATE_RTSN, &channel->regs->w.cr);
-			iowrite8(CR_ENABLE_RX, &channel->regs->w.cr);
-			ipoctal->write = 1;
+		if (channel->board_id != IPACK1_DEVICE_ID_SBS_OCTAL_485) {
+			*channel->board_write = 1;
 			wake_up_interruptible(&channel->queue);
 		}
+	}
+}
 
-		/* RX data */
-		if ((isr && channel->isr_rx_rdy_mask) && (sr & SR_RX_READY)) {
-			value = ioread8(&channel->regs->r.rhr);
-			flag = TTY_NORMAL;
-
-			/* Error: count statistics */
-			if (sr & SR_ERROR) {
-				iowrite8(CR_CMD_RESET_ERR_STATUS, &channel->regs->w.cr);
-
-				if (sr & SR_OVERRUN_ERROR) {
-					channel->stats.overrun_err++;
-					/* Overrun doesn't affect the current character*/
-					tty_insert_flip_char(tty, 0, TTY_OVERRUN);
-				}
-				if (sr & SR_PARITY_ERROR) {
-					channel->stats.parity_err++;
-					flag = TTY_PARITY;
-				}
-				if (sr & SR_FRAMING_ERROR) {
-					channel->stats.framing_err++;
-					flag = TTY_FRAME;
-				}
-				if (sr & SR_RECEIVED_BREAK) {
-					channel->stats.rcv_break++;
-					flag = TTY_BREAK;
-				}
-			}
-
-			tty_insert_flip_char(tty, value, flag);
-		}
+static void ipoctal_irq_channel(struct ipoctal_channel *channel)
+{
+	u8 isr, sr;
+	struct tty_struct *tty;
 
-		/* TX of each character */
-		if ((isr & channel->isr_tx_rdy_mask) && (sr & SR_TX_READY)) {
-			unsigned int *pointer_write = &channel->pointer_write;
-
-			if (channel->nb_bytes <= 0) {
-				channel->nb_bytes = 0;
-				continue;
-			}
-
-			value = channel->tty_port.xmit_buf[*pointer_write];
-			iowrite8(value, &channel->regs->w.thr);
-			channel->stats.tx++;
-			channel->count_wr++;
-			(*pointer_write)++;
-			*pointer_write = *pointer_write % PAGE_SIZE;
-			channel->nb_bytes--;
-
-			if ((channel->nb_bytes == 0) &&
-			    (waitqueue_active(&channel->queue))) {
-
-				if (ipoctal->board_id != IPACK1_DEVICE_ID_SBS_OCTAL_485) {
-					ipoctal->write = 1;
-					wake_up_interruptible(&channel->queue);
-				}
-			}
-		}
+	/* If there is no client, skip the check */
+	if (!atomic_read(&channel->open))
+		return;
 
-		tty_flip_buffer_push(tty);
-		tty_kref_put(tty);
+	tty = tty_port_tty_get(&channel->tty_port);
+	if (!tty)
+		return;
+	/* The HW is organized in pair of channels.  See which register we need
+	 * to read from */
+	isr = ioread8(&channel->block_regs->r.isr);
+	sr = ioread8(&channel->regs->r.sr);
+
+	/* In case of RS-485, change from TX to RX when finishing TX.
+	 * Half-duplex. */
+	if ((channel->board_id == IPACK1_DEVICE_ID_SBS_OCTAL_485) &&
+	    (sr & SR_TX_EMPTY) && (channel->nb_bytes == 0)) {
+		iowrite8(CR_DISABLE_TX, &channel->regs->w.cr);
+		iowrite8(CR_CMD_NEGATE_RTSN, &channel->regs->w.cr);
+		iowrite8(CR_ENABLE_RX, &channel->regs->w.cr);
+		*channel->board_write = 1;
+		wake_up_interruptible(&channel->queue);
 	}
+
+	/* RX data */
+	if ((isr & channel->isr_rx_rdy_mask) && (sr & SR_RX_READY))
+		ipoctal_irq_rx(channel, tty, sr);
+
+	/* TX of each character */
+	if ((isr & channel->isr_tx_rdy_mask) && (sr & SR_TX_READY))
+		ipoctal_irq_tx(channel);
+
+	tty_flip_buffer_push(tty);
+	tty_kref_put(tty);
+}
+
+static int ipoctal_irq_handler(void *arg)
+{
+	unsigned int i;
+	struct ipoctal *ipoctal = (struct ipoctal *) arg;
+
+	/* Check all channels */
+	for (i = 0; i < NR_CHANNELS; i++)
+		ipoctal_irq_channel(&ipoctal->channel[i]);
+
 	return IRQ_HANDLED;
 }
 
-- 
1.7.10.4


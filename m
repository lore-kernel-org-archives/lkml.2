Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab2ILMzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:55:52 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:16819 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013Ab2ILMzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:55:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqECACCFUFBbdWObgWdsb2JhbABFu0AiAQEWJieCIAEBBSdSECAxVwYTiBG8YpFSA5VfiTOJVA
X-IronPort-AV: E=Sophos;i="4.80,410,1344204000"; 
   d="scan'208";a="950511723"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 06/24] Staging: ipack/devices/ipoctal: put ipoctal_channel into tty->driver_data.
Date: Wed, 12 Sep 2012 14:55:28 +0200
Message-Id: <1347454546-23236-6-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Each tty's driver_data is now pointing to the channel it is talking to.  struct
ipoctal_channel contains all the information the callbacks require to do their
work.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |   52 +++++++++++++------------------
 1 file changed, 21 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index c963456..70dc7a2 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -42,6 +42,8 @@ struct ipoctal_channel {
 	struct tty_port			tty_port;
 	union scc2698_channel __iomem	*regs;
 	union scc2698_block __iomem	*block_regs;
+	unsigned int			board_id;
+	unsigned char			*board_write;
 };
 
 struct ipoctal {
@@ -104,7 +106,7 @@ static int ipoctal_open(struct tty_struct *tty, struct file *file)
 	if (atomic_read(&channel->open))
 		return -EBUSY;
 
-	tty->driver_data = ipoctal;
+	tty->driver_data = channel;
 
 	res = tty_port_open(&channel->tty_port, tty, file);
 	if (res)
@@ -124,15 +126,8 @@ static void ipoctal_reset_stats(struct ipoctal_stats *stats)
 	stats->parity_err = 0;
 }
 
-static void ipoctal_free_channel(struct tty_struct *tty)
+static void ipoctal_free_channel(struct ipoctal_channel *channel)
 {
-	struct ipoctal *ipoctal = tty->driver_data;
-	struct ipoctal_channel *channel;
-
-	if (ipoctal == NULL)
-		return;
-	channel = &ipoctal->channel[tty->index];
-
 	ipoctal_reset_stats(&channel->stats);
 	channel->pointer_read = 0;
 	channel->pointer_write = 0;
@@ -141,20 +136,18 @@ static void ipoctal_free_channel(struct tty_struct *tty)
 
 static void ipoctal_close(struct tty_struct *tty, struct file *filp)
 {
-	struct ipoctal *ipoctal = tty->driver_data;
-	struct ipoctal_channel *channel = &ipoctal->channel[tty->index];
+	struct ipoctal_channel *channel = tty->driver_data;
 
 	tty_port_close(&channel->tty_port, tty, filp);
 
 	if (atomic_dec_and_test(&channel->open))
-		ipoctal_free_channel(tty);
+		ipoctal_free_channel(channel);
 }
 
 static int ipoctal_get_icount(struct tty_struct *tty,
 			      struct serial_icounter_struct *icount)
 {
-	struct ipoctal *ipoctal = tty->driver_data;
-	struct ipoctal_channel *channel = &ipoctal->channel[tty->index];
+	struct ipoctal_channel *channel = tty->driver_data;
 
 	icount->cts = 0;
 	icount->dsr = 0;
@@ -370,6 +363,8 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 		struct ipoctal_channel *channel = &ipoctal->channel[i];
 		channel->regs = chan_regs + i;
 		channel->block_regs = block_regs + (i >> 1);
+		channel->board_write = &ipoctal->write;
+		channel->board_id = ipoctal->board_id;
 
 		iowrite8(CR_DISABLE_RX | CR_DISABLE_TX, &channel->regs->w.cr);
 		iowrite8(CR_CMD_RESET_RX, &channel->regs->w.cr);
@@ -492,17 +487,16 @@ static inline int ipoctal_copy_write_buffer(struct ipoctal_channel *channel,
 	return i;
 }
 
-static int ipoctal_write(struct ipoctal *ipoctal, unsigned int ichannel,
+static int ipoctal_write(struct ipoctal_channel *channel,
 			 const unsigned char *buf, int count)
 {
-	struct ipoctal_channel *channel = &ipoctal->channel[ichannel];
 	channel->nb_bytes = 0;
 	channel->count_wr = 0;
 
 	ipoctal_copy_write_buffer(channel, buf, count);
 
 	/* As the IP-OCTAL 485 only supports half duplex, do it manually */
-	if (ipoctal->board_id == IPACK1_DEVICE_ID_SBS_OCTAL_485) {
+	if (channel->board_id == IPACK1_DEVICE_ID_SBS_OCTAL_485) {
 		iowrite8(CR_DISABLE_RX, &channel->regs->w.cr);
 		iowrite8(CR_CMD_ASSERT_RTSN, &channel->regs->w.cr);
 	}
@@ -512,33 +506,31 @@ static int ipoctal_write(struct ipoctal *ipoctal, unsigned int ichannel,
 	 * operations
 	 */
 	iowrite8(CR_ENABLE_TX, &channel->regs->w.cr);
-	wait_event_interruptible(channel->queue, ipoctal->write);
+	wait_event_interruptible(channel->queue, *channel->board_write);
 	iowrite8(CR_DISABLE_TX, &channel->regs->w.cr);
 
-	ipoctal->write = 0;
+	*channel->board_write = 0;
 	return channel->count_wr;
 }
 
 static int ipoctal_write_tty(struct tty_struct *tty,
 			     const unsigned char *buf, int count)
 {
-	struct ipoctal *ipoctal = tty->driver_data;
+	struct ipoctal_channel *channel = tty->driver_data;
 
-	return ipoctal_write(ipoctal, tty->index, buf, count);
+	return ipoctal_write(channel, buf, count);
 }
 
 static int ipoctal_write_room(struct tty_struct *tty)
 {
-	struct ipoctal *ipoctal = tty->driver_data;
-	struct ipoctal_channel *channel = &ipoctal->channel[tty->index];
+	struct ipoctal_channel *channel = tty->driver_data;
 
 	return PAGE_SIZE - channel->nb_bytes;
 }
 
 static int ipoctal_chars_in_buffer(struct tty_struct *tty)
 {
-	struct ipoctal *ipoctal = tty->driver_data;
-	struct ipoctal_channel *channel = &ipoctal->channel[tty->index];
+	struct ipoctal_channel *channel = tty->driver_data;
 
 	return channel->nb_bytes;
 }
@@ -550,8 +542,7 @@ static void ipoctal_set_termios(struct tty_struct *tty,
 	unsigned char mr1 = 0;
 	unsigned char mr2 = 0;
 	unsigned char csr = 0;
-	struct ipoctal *ipoctal = tty->driver_data;
-	struct ipoctal_channel *channel = &ipoctal->channel[tty->index];
+	struct ipoctal_channel *channel = tty->driver_data;
 	speed_t baud;
 
 	cflag = tty->termios->c_cflag;
@@ -598,7 +589,7 @@ static void ipoctal_set_termios(struct tty_struct *tty,
 		mr2 |= MR2_STOP_BITS_LENGTH_1;
 
 	/* Set the flow control */
-	switch (ipoctal->board_id) {
+	switch (channel->board_id) {
 	case IPACK1_DEVICE_ID_SBS_OCTAL_232:
 		if (cflag & CRTSCTS) {
 			mr1 |= MR1_RxRTS_CONTROL_ON;
@@ -685,10 +676,9 @@ static void ipoctal_set_termios(struct tty_struct *tty,
 static void ipoctal_hangup(struct tty_struct *tty)
 {
 	unsigned long flags;
-	struct ipoctal *ipoctal = tty->driver_data;
-	struct ipoctal_channel *channel = &ipoctal->channel[tty->index];
+	struct ipoctal_channel *channel = tty->driver_data;
 
-	if (ipoctal == NULL)
+	if (channel == NULL)
 		return;
 
 	spin_lock_irqsave(&channel->lock, flags);
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab3ACOyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 09:54:53 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:60976 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab3ACOxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 09:53:17 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 01/10] TTY: switch tty_buffer_request_room to tty_port
Date: Thu,  3 Jan 2013 15:53:01 +0100
Message-Id: <1357224789-2853-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
References: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, we start converting tty buffer functions to actually use
tty_port. This will allow us to get rid of the need of tty pointer in
many call sites. Only tty_port will be needed and hence no more
tty_port_tty_get calls in those paths.

Here we start with tty_buffer_request_room.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/mn10300/kernel/mn10300-serial.c        |  5 +++--
 arch/um/drivers/chan_kern.c                 |  3 ++-
 drivers/char/pcmcia/synclink_cs.c           |  3 ++-
 drivers/isdn/i4l/isdn_common.c              |  3 ++-
 drivers/isdn/i4l/isdn_tty.c                 | 12 +++++++-----
 drivers/staging/dgrp/dgrp_net_ops.c         |  4 ++--
 drivers/tty/cyclades.c                      | 13 ++++++++-----
 drivers/tty/ehv_bytechan.c                  |  2 +-
 drivers/tty/hvc/hvc_console.c               |  2 +-
 drivers/tty/hvc/hvcs.c                      |  2 +-
 drivers/tty/serial/cpm_uart/cpm_uart_core.c |  5 +++--
 drivers/tty/serial/ioc4_serial.c            |  2 +-
 drivers/tty/serial/jsm/jsm_tty.c            |  6 ++++--
 drivers/tty/serial/mpsc.c                   |  6 +++---
 drivers/tty/serial/mrst_max3110.c           |  6 ++++--
 drivers/tty/serial/pch_uart.c               |  5 +++--
 drivers/tty/serial/sh-sci.c                 |  8 +++++---
 drivers/tty/serial/ucc_uart.c               |  5 +++--
 drivers/tty/tty_buffer.c                    |  5 ++---
 drivers/usb/serial/quatech2.c               |  4 ++--
 include/linux/tty_flip.h                    |  2 +-
 21 files changed, 60 insertions(+), 43 deletions(-)

diff --git a/arch/mn10300/kernel/mn10300-serial.c b/arch/mn10300/kernel/mn10300-serial.c
index 81d5cb9..9b2232a 100644
--- a/arch/mn10300/kernel/mn10300-serial.c
+++ b/arch/mn10300/kernel/mn10300-serial.c
@@ -524,7 +524,8 @@ static int mask_test_and_clear(volatile u8 *ptr, u8 mask)
 static void mn10300_serial_receive_interrupt(struct mn10300_serial_port *port)
 {
 	struct uart_icount *icount = &port->uart.icount;
-	struct tty_struct *tty = port->uart.state->port.tty;
+	struct tty_port *port = &port->uart.state->port;
+	struct tty_struct *tty = port->tty;
 	unsigned ix;
 	int count;
 	u8 st, ch, push, status, overrun;
@@ -534,7 +535,7 @@ static void mn10300_serial_receive_interrupt(struct mn10300_serial_port *port)
 	push = 0;
 
 	count = CIRC_CNT(port->rx_inp, port->rx_outp, MNSC_BUFFER_SIZE);
-	count = tty_buffer_request_room(tty, count);
+	count = tty_buffer_request_room(port, count);
 	if (count == 0) {
 		if (!tty->low_latency)
 			tty_flip_buffer_push(tty);
diff --git a/arch/um/drivers/chan_kern.c b/arch/um/drivers/chan_kern.c
index e9a0abc..4ff2503 100644
--- a/arch/um/drivers/chan_kern.c
+++ b/arch/um/drivers/chan_kern.c
@@ -554,6 +554,7 @@ int parse_chan_pair(char *str, struct line *line, int device,
 
 void chan_interrupt(struct line *line, struct tty_struct *tty, int irq)
 {
+	struct tty_port *port = &line->port;
 	struct chan *chan = line->chan_in;
 	int err;
 	char c;
@@ -562,7 +563,7 @@ void chan_interrupt(struct line *line, struct tty_struct *tty, int irq)
 		goto out;
 
 	do {
-		if (tty && !tty_buffer_request_room(tty, 1)) {
+		if (!tty_buffer_request_room(port, 1)) {
 			schedule_delayed_work(&line->task, 1);
 			goto out;
 		}
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index b66eaa0..7a4370c 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -888,6 +888,7 @@ static void rx_ready_hdlc(MGSLPC_INFO *info, int eom)
 
 static void rx_ready_async(MGSLPC_INFO *info, int tcd, struct tty_struct *tty)
 {
+	struct tty_port *port = &info->port;
 	unsigned char data, status, flag;
 	int fifo_count;
 	int work = 0;
@@ -913,7 +914,7 @@ static void rx_ready_async(MGSLPC_INFO *info, int tcd, struct tty_struct *tty)
 	} else
 		fifo_count = 32;
 
-	tty_buffer_request_room(tty, fifo_count);
+	tty_buffer_request_room(port, fifo_count);
 	/* Flush received async data to receive data buffer. */
 	while (fifo_count) {
 		data   = read_reg(info, CHA + RXFIFO);
diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index e2a945e..7093169 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -878,6 +878,7 @@ isdn_readbchan(int di, int channel, u_char *buf, u_char *fp, int len, wait_queue
 int
 isdn_readbchan_tty(int di, int channel, struct tty_struct *tty, int cisco_hack)
 {
+	struct tty_port *port = tty->port;
 	int count;
 	int count_pull;
 	int count_put;
@@ -891,7 +892,7 @@ isdn_readbchan_tty(int di, int channel, struct tty_struct *tty, int cisco_hack)
 	if (skb_queue_empty(&dev->drv[di]->rpqueue[channel]))
 		return 0;
 
-	len = tty_buffer_request_room(tty, dev->drv[di]->rcvcount[channel]);
+	len = tty_buffer_request_room(port, dev->drv[di]->rcvcount[channel]);
 	if (len == 0)
 		return len;
 
diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index e09dc8a..4f5bcee 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -60,6 +60,7 @@ static int si2bit[8] =
 static int
 isdn_tty_try_read(modem_info *info, struct sk_buff *skb)
 {
+	struct tty_port *port = &info->port;
 	int c;
 	int len;
 	struct tty_struct *tty;
@@ -68,7 +69,7 @@ isdn_tty_try_read(modem_info *info, struct sk_buff *skb)
 	if (!info->online)
 		return 0;
 
-	tty = info->port.tty;
+	tty = port->tty;
 	if (!tty)
 		return 0;
 
@@ -81,7 +82,7 @@ isdn_tty_try_read(modem_info *info, struct sk_buff *skb)
 #endif
 		;
 
-	c = tty_buffer_request_room(tty, len);
+	c = tty_buffer_request_room(port, len);
 	if (c < len)
 		return 0;
 
@@ -2230,6 +2231,7 @@ void
 isdn_tty_at_cout(char *msg, modem_info *info)
 {
 	struct tty_struct *tty;
+	struct tty_port *port = &info->port;
 	atemu *m = &info->emu;
 	char *p;
 	char c;
@@ -2246,15 +2248,15 @@ isdn_tty_at_cout(char *msg, modem_info *info)
 	l = strlen(msg);
 
 	spin_lock_irqsave(&info->readlock, flags);
-	tty = info->port.tty;
-	if ((info->port.flags & ASYNC_CLOSING) || (!tty)) {
+	tty = port->tty;
+	if ((port->flags & ASYNC_CLOSING) || (!tty)) {
 		spin_unlock_irqrestore(&info->readlock, flags);
 		return;
 	}
 
 	/* use queue instead of direct, if online and */
 	/* data is in queue or buffer is full */
-	if (info->online && ((tty_buffer_request_room(tty, l) < l) ||
+	if (info->online && ((tty_buffer_request_room(port, l) < l) ||
 			     !skb_queue_empty(&dev->drv[info->isdn_driver]->rpqueue[info->isdn_channel]))) {
 		skb = alloc_skb(l, GFP_ATOMIC);
 		if (!skb) {
diff --git a/drivers/staging/dgrp/dgrp_net_ops.c b/drivers/staging/dgrp/dgrp_net_ops.c
index 2d1bbfd..c0aeaaa 100644
--- a/drivers/staging/dgrp/dgrp_net_ops.c
+++ b/drivers/staging/dgrp/dgrp_net_ops.c
@@ -211,7 +211,7 @@ static void dgrp_input(struct ch_struct *ch)
 	data_len = (ch->ch_rin - ch->ch_rout) & RBUF_MASK;
 
 	/* len is the amount of data we are going to transfer here */
-	len = tty_buffer_request_room(tty, data_len);
+	len = tty_buffer_request_room(&ch->port, data_len);
 
 	/* Check DPA flow control */
 	if ((nd->nd_dpa_debug) &&
@@ -2956,7 +2956,7 @@ check_query:
 			    I_BRKINT(ch->ch_tun.un_tty) &&
 			    !(I_IGNBRK(ch->ch_tun.un_tty))) {
 
-				tty_buffer_request_room(ch->ch_tun.un_tty, 1);
+				tty_buffer_request_room(&ch->port, 1);
 				tty_insert_flip_char(ch->ch_tun.un_tty, 0, TTY_BREAK);
 				tty_flip_buffer_push(ch->ch_tun.un_tty);
 
diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index b09c8d1f..b85acc7 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -442,6 +442,7 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 {
 	struct cyclades_port *info;
 	struct tty_struct *tty;
+	struct tty_port *port;
 	int len, index = cinfo->bus_index;
 	u8 ivr, save_xir, channel, save_car, data, char_count;
 
@@ -452,11 +453,12 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 	save_xir = readb(base_addr + (CyRIR << index));
 	channel = save_xir & CyIRChannel;
 	info = &cinfo->ports[channel + chip * 4];
+	port = &info->port;
 	save_car = cyy_readb(info, CyCAR);
 	cyy_writeb(info, CyCAR, save_xir);
 	ivr = cyy_readb(info, CyRIVR) & CyIVRMask;
 
-	tty = tty_port_tty_get(&info->port);
+	tty = tty_port_tty_get(port);
 	/* if there is nowhere to put the data, discard it */
 	if (tty == NULL) {
 		if (ivr == CyIVRRxEx) {	/* exception */
@@ -487,14 +489,14 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 			tty_kref_put(tty);
 			return;
 		}
-		if (tty_buffer_request_room(tty, 1)) {
+		if (tty_buffer_request_room(port, 1)) {
 			if (data & info->read_status_mask) {
 				if (data & CyBREAK) {
 					tty_insert_flip_char(tty,
 						cyy_readb(info, CyRDSR),
 						TTY_BREAK);
 					info->icount.rx++;
-					if (info->port.flags & ASYNC_SAK)
+					if (port->flags & ASYNC_SAK)
 						do_SAK(tty);
 				} else if (data & CyFRAME) {
 					tty_insert_flip_char(tty,
@@ -552,7 +554,7 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 			info->mon.char_max = char_count;
 		info->mon.char_last = char_count;
 #endif
-		len = tty_buffer_request_room(tty, char_count);
+		len = tty_buffer_request_room(port, char_count);
 		while (len--) {
 			data = cyy_readb(info, CyRDSR);
 			tty_insert_flip_char(tty, data, TTY_NORMAL);
@@ -928,6 +930,7 @@ static void cyz_handle_rx(struct cyclades_port *info, struct tty_struct *tty)
 {
 	struct BUF_CTRL __iomem *buf_ctrl = info->u.cyz.buf_ctrl;
 	struct cyclades_card *cinfo = info->card;
+	struct tty_port *port = &info->port;
 	unsigned int char_count;
 	int len;
 #ifdef BLOCKMOVE
@@ -983,7 +986,7 @@ static void cyz_handle_rx(struct cyclades_port *info, struct tty_struct *tty)
 				info->idle_stats.recv_bytes += len;
 			}
 #else
-			len = tty_buffer_request_room(tty, char_count);
+			len = tty_buffer_request_room(port, char_count);
 			while (len--) {
 				data = readb(cinfo->base_addr + rx_bufaddr +
 						new_rx_get);
diff --git a/drivers/tty/ehv_bytechan.c b/drivers/tty/ehv_bytechan.c
index c117d77..af97e39 100644
--- a/drivers/tty/ehv_bytechan.c
+++ b/drivers/tty/ehv_bytechan.c
@@ -386,7 +386,7 @@ static irqreturn_t ehv_bc_tty_rx_isr(int irq, void *data)
 	 * read from the byte channel will be accepted by the TTY layer.
 	 */
 	ev_byte_channel_poll(bc->handle, &rx_count, &tx_count);
-	count = tty_buffer_request_room(ttys, rx_count);
+	count = tty_buffer_request_room(&bc->port, rx_count);
 
 	/* 'count' is the maximum amount of data the TTY layer can accept at
 	 * this time.  However, during testing, I was never able to get 'count'
diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index 13ee53b..3d2ea92 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -629,7 +629,7 @@ int hvc_poll(struct hvc_struct *hp)
 
 	/* Read data if any */
 	for (;;) {
-		int count = tty_buffer_request_room(tty, N_INBUF);
+		int count = tty_buffer_request_room(&hp->port, N_INBUF);
 
 		/* If flip is full, just reschedule a later read */
 		if (count == 0) {
diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
index 8776357..4a0ab98 100644
--- a/drivers/tty/hvc/hvcs.c
+++ b/drivers/tty/hvc/hvcs.c
@@ -609,7 +609,7 @@ static int hvcs_io(struct hvcs_struct *hvcsd)
 	/* remove the read masks */
 	hvcsd->todo_mask &= ~(HVCS_READ_MASK);
 
-	if (tty_buffer_request_room(tty, HVCS_BUFF_LEN) >= HVCS_BUFF_LEN) {
+	if (tty_buffer_request_room(&hvcsd->port, HVCS_BUFF_LEN) >= HVCS_BUFF_LEN) {
 		got = hvc_get_chars(unit_address,
 				&buf[0],
 				HVCS_BUFF_LEN);
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_core.c b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
index ad0caf1..42d5eb0 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -245,7 +245,8 @@ static void cpm_uart_int_rx(struct uart_port *port)
 	int i;
 	unsigned char ch;
 	u8 *cp;
-	struct tty_struct *tty = port->state->port.tty;
+	struct tty_port *tport = &port->state->port;
+	struct tty_struct *tty = tport->tty;
 	struct uart_cpm_port *pinfo = (struct uart_cpm_port *)port;
 	cbd_t __iomem *bdp;
 	u16 status;
@@ -276,7 +277,7 @@ static void cpm_uart_int_rx(struct uart_port *port)
 		/* If we have not enough room in tty flip buffer, then we try
 		 * later, which will be the next rx-interrupt or a timeout
 		 */
-		if(tty_buffer_request_room(tty, i) < i) {
+		if (tty_buffer_request_room(tport, i) < i) {
 			printk(KERN_WARNING "No room in flip buffer\n");
 			return;
 		}
diff --git a/drivers/tty/serial/ioc4_serial.c b/drivers/tty/serial/ioc4_serial.c
index 3e7da10..555aeb2 100644
--- a/drivers/tty/serial/ioc4_serial.c
+++ b/drivers/tty/serial/ioc4_serial.c
@@ -2356,7 +2356,7 @@ static void receive_chars(struct uart_port *the_port)
 	spin_lock_irqsave(&the_port->lock, pflags);
 	tty = state->port.tty;
 
-	request_count = tty_buffer_request_room(tty, IOC4_MAX_CHARS);
+	request_count = tty_buffer_request_room(&state->port, IOC4_MAX_CHARS);
 
 	if (request_count > 0) {
 		icount = &the_port->icount;
diff --git a/drivers/tty/serial/jsm/jsm_tty.c b/drivers/tty/serial/jsm/jsm_tty.c
index 4c00c55..3969e54 100644
--- a/drivers/tty/serial/jsm/jsm_tty.c
+++ b/drivers/tty/serial/jsm/jsm_tty.c
@@ -521,6 +521,7 @@ void jsm_input(struct jsm_channel *ch)
 {
 	struct jsm_board *bd;
 	struct tty_struct *tp;
+	struct tty_port *port;
 	u32 rmask;
 	u16 head;
 	u16 tail;
@@ -536,7 +537,8 @@ void jsm_input(struct jsm_channel *ch)
 	if (!ch)
 		return;
 
-	tp = ch->uart_port.state->port.tty;
+	port = &ch->uart_port.state->port;
+	tp = port->tty;
 
 	bd = ch->ch_bd;
 	if(!bd)
@@ -600,7 +602,7 @@ void jsm_input(struct jsm_channel *ch)
 		return;
 	}
 
-	len = tty_buffer_request_room(tp, data_len);
+	len = tty_buffer_request_room(port, data_len);
 	n = len;
 
 	/*
diff --git a/drivers/tty/serial/mpsc.c b/drivers/tty/serial/mpsc.c
index 6a9c660..5036686 100644
--- a/drivers/tty/serial/mpsc.c
+++ b/drivers/tty/serial/mpsc.c
@@ -937,7 +937,8 @@ static int serial_polled;
 static int mpsc_rx_intr(struct mpsc_port_info *pi)
 {
 	struct mpsc_rx_desc *rxre;
-	struct tty_struct *tty = pi->port.state->port.tty;
+	struct tty_port *port = &pi->port.state->port;
+	struct tty_struct *tty = port->tty;
 	u32	cmdstat, bytes_in, i;
 	int	rc = 0;
 	u8	*bp;
@@ -968,8 +969,7 @@ static int mpsc_rx_intr(struct mpsc_port_info *pi)
 		}
 #endif
 		/* Following use of tty struct directly is deprecated */
-		if (unlikely(tty_buffer_request_room(tty, bytes_in)
-					< bytes_in)) {
+		if (tty_buffer_request_room(port, bytes_in) < bytes_in) {
 			if (tty->low_latency)
 				tty_flip_buffer_push(tty);
 			/*
diff --git a/drivers/tty/serial/mrst_max3110.c b/drivers/tty/serial/mrst_max3110.c
index 58734d7..776431f 100644
--- a/drivers/tty/serial/mrst_max3110.c
+++ b/drivers/tty/serial/mrst_max3110.c
@@ -339,6 +339,7 @@ static int
 receive_chars(struct uart_max3110 *max, unsigned short *str, int len)
 {
 	struct uart_port *port = &max->port;
+	struct tty_port *tport;
 	struct tty_struct *tty;
 	char buf[M3110_RX_FIFO_DEPTH];
 	int r, w, usable;
@@ -347,7 +348,8 @@ receive_chars(struct uart_max3110 *max, unsigned short *str, int len)
 	if (!port->state)
 		return 0;
 
-	tty = tty_port_tty_get(&port->state->port);
+	tport = &port->state->port;
+	tty = tty_port_tty_get(tport);
 	if (!tty)
 		return 0;
 
@@ -370,7 +372,7 @@ receive_chars(struct uart_max3110 *max, unsigned short *str, int len)
 	}
 
 	for (r = 0; w; r += usable, w -= usable) {
-		usable = tty_buffer_request_room(tty, w);
+		usable = tty_buffer_request_room(tport, w);
 		if (usable) {
 			tty_insert_flip_string(tty, buf + r, usable);
 			port->icount.rx += usable;
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 8318925..4f1774b 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -629,15 +629,16 @@ static int dma_push_rx(struct eg20t_port *priv, int size)
 	struct tty_struct *tty;
 	int room;
 	struct uart_port *port = &priv->port;
+	struct tty_port *tport = &port->state->port;
 
 	port = &priv->port;
-	tty = tty_port_tty_get(&port->state->port);
+	tty = tty_port_tty_get(tport);
 	if (!tty) {
 		dev_dbg(priv->port.dev, "%s:tty is busy now", __func__);
 		return 0;
 	}
 
-	room = tty_buffer_request_room(tty, size);
+	room = tty_buffer_request_room(tport, size);
 
 	if (room < size)
 		dev_warn(port->dev, "Rx overrun: dropping %u bytes\n",
diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 6147756..cf96314 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -596,7 +596,8 @@ static void sci_transmit_chars(struct uart_port *port)
 static void sci_receive_chars(struct uart_port *port)
 {
 	struct sci_port *sci_port = to_sci_port(port);
-	struct tty_struct *tty = port->state->port.tty;
+	struct tty_port *tport = &port->state->port;
+	struct tty_struct *tty = tport->tty;
 	int i, count, copied = 0;
 	unsigned short status;
 	unsigned char flag;
@@ -607,7 +608,7 @@ static void sci_receive_chars(struct uart_port *port)
 
 	while (1) {
 		/* Don't copy more bytes than there is room for in the buffer */
-		count = tty_buffer_request_room(tty, sci_rxfill(port));
+		count = tty_buffer_request_room(tport, sci_rxfill(port));
 
 		/* If for any reason we can't copy more data, we're done! */
 		if (count == 0)
@@ -1263,9 +1264,10 @@ static int sci_dma_rx_push(struct sci_port *s, struct tty_struct *tty,
 			   size_t count)
 {
 	struct uart_port *port = &s->port;
+	struct tty_port *tport = &port->state->port;
 	int i, active, room;
 
-	room = tty_buffer_request_room(tty, count);
+	room = tty_buffer_request_room(tport, count);
 
 	if (s->active_rx == s->cookie_rx[0]) {
 		active = 0;
diff --git a/drivers/tty/serial/ucc_uart.c b/drivers/tty/serial/ucc_uart.c
index f99b0c9..ed047d9 100644
--- a/drivers/tty/serial/ucc_uart.c
+++ b/drivers/tty/serial/ucc_uart.c
@@ -469,7 +469,8 @@ static void qe_uart_int_rx(struct uart_qe_port *qe_port)
 	int i;
 	unsigned char ch, *cp;
 	struct uart_port *port = &qe_port->port;
-	struct tty_struct *tty = port->state->port.tty;
+	struct tty_port *tport = &port->state->port;
+	struct tty_struct *tty = tport->tty;
 	struct qe_bd *bdp;
 	u16 status;
 	unsigned int flg;
@@ -491,7 +492,7 @@ static void qe_uart_int_rx(struct uart_qe_port *qe_port)
 		/* If we don't have enough room in RX buffer for the entire BD,
 		 * then we try later, which will be the next RX interrupt.
 		 */
-		if (tty_buffer_request_room(tty, i) < i) {
+		if (tty_buffer_request_room(tport, i) < i) {
 			dev_dbg(port->dev, "ucc-uart: no room in RX buffer\n");
 			return;
 		}
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 45d9161..f897332 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -235,7 +235,7 @@ static int __tty_buffer_request_room(struct tty_port *port, size_t size)
 
 /**
  *	tty_buffer_request_room		-	grow tty buffer if needed
- *	@tty: tty structure
+ *	@port: tty port structure
  *	@size: size desired
  *
  *	Make at least size bytes of linear space available for the tty
@@ -243,9 +243,8 @@ static int __tty_buffer_request_room(struct tty_port *port, size_t size)
  *
  *	Locking: Takes port->buf.lock
  */
-int tty_buffer_request_room(struct tty_struct *tty, size_t size)
+int tty_buffer_request_room(struct tty_port *port, size_t size)
 {
-	struct tty_port *port = tty->port;
 	unsigned long flags;
 	int length;
 
diff --git a/drivers/usb/serial/quatech2.c b/drivers/usb/serial/quatech2.c
index d152be9..1e67fd8 100644
--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -697,7 +697,7 @@ void qt2_process_read_urb(struct urb *urb)
 				escapeflag = true;
 				break;
 			case QT2_CONTROL_ESCAPE:
-				tty_buffer_request_room(tty, 2);
+				tty_buffer_request_room(&port->port, 2);
 				tty_insert_flip_string(tty, ch, 2);
 				i += 2;
 				escapeflag = true;
@@ -713,7 +713,7 @@ void qt2_process_read_urb(struct urb *urb)
 		}
 
 		if (tty) {
-			tty_buffer_request_room(tty, 1);
+			tty_buffer_request_room(&port->port, 1);
 			tty_insert_flip_string(tty, ch, 1);
 		}
 	}
diff --git a/include/linux/tty_flip.h b/include/linux/tty_flip.h
index 2002344..78207ca 100644
--- a/include/linux/tty_flip.h
+++ b/include/linux/tty_flip.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_TTY_FLIP_H
 #define _LINUX_TTY_FLIP_H
 
-extern int tty_buffer_request_room(struct tty_struct *tty, size_t size);
+extern int tty_buffer_request_room(struct tty_port *port, size_t size);
 extern int tty_insert_flip_string_flags(struct tty_struct *tty, const unsigned char *chars, const char *flags, size_t size);
 extern int tty_insert_flip_string_fixed_flag(struct tty_struct *tty, const unsigned char *chars, char flag, size_t size);
 extern int tty_prepare_flip_string(struct tty_struct *tty, unsigned char **chars, size_t size);
-- 
1.8.1



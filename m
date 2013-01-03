Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab3ACOy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 09:54:58 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:60980 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab3ACOxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 09:53:17 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 05/10] TTY: move low_latency to tty_port
Date: Thu,  3 Jan 2013 15:53:05 +0100
Message-Id: <1357224789-2853-6-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
References: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One point is to have less places where we actually need tty pointer.
The other is that low_latency is bound to buffer processing and
buffers are now in tty_port. So it makes sense to move low_latency to
tty_port too.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/ia64/hp/sim/simserial.c                | 2 +-
 arch/mn10300/kernel/mn10300-serial.c        | 6 +++---
 drivers/char/pcmcia/synclink_cs.c           | 2 +-
 drivers/isdn/gigaset/interface.c            | 2 +-
 drivers/net/caif/caif_serial.c              | 2 +-
 drivers/net/irda/irtty-sir.c                | 2 +-
 drivers/s390/char/con3215.c                 | 2 +-
 drivers/s390/char/sclp_tty.c                | 2 +-
 drivers/s390/char/sclp_vt220.c              | 2 +-
 drivers/s390/char/tty3270.c                 | 4 ++--
 drivers/tty/amiserial.c                     | 4 ++--
 drivers/tty/ipwireless/tty.c                | 2 +-
 drivers/tty/mxser.c                         | 2 +-
 drivers/tty/serial/cpm_uart/cpm_uart_core.c | 2 +-
 drivers/tty/serial/crisv10.c                | 4 ++--
 drivers/tty/serial/ifx6x60.c                | 2 +-
 drivers/tty/serial/ioc3_serial.c            | 2 +-
 drivers/tty/serial/ioc4_serial.c            | 2 +-
 drivers/tty/serial/max3100.c                | 2 +-
 drivers/tty/serial/mpsc.c                   | 2 +-
 drivers/tty/serial/mrst_max3110.c           | 2 +-
 drivers/tty/serial/msm_serial_hs.c          | 2 +-
 drivers/tty/serial/serial_core.c            | 7 +++----
 drivers/tty/synclink.c                      | 2 +-
 drivers/tty/synclink_gt.c                   | 2 +-
 drivers/tty/synclinkmp.c                    | 2 +-
 drivers/tty/tty_buffer.c                    | 9 +++++----
 include/linux/tty.h                         | 5 +++--
 net/irda/ircomm/ircomm_tty.c                | 2 +-
 29 files changed, 42 insertions(+), 41 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index f8ae5d8..942022a 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -436,7 +436,7 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 	struct tty_port *port = &info->port;
 
 	tty->driver_data = info;
-	tty->low_latency = (port->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	port->low_latency = (port->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	/*
 	 * figure out which console to use (should be one already)
diff --git a/arch/mn10300/kernel/mn10300-serial.c b/arch/mn10300/kernel/mn10300-serial.c
index 54ef40c..ae61bd6 100644
--- a/arch/mn10300/kernel/mn10300-serial.c
+++ b/arch/mn10300/kernel/mn10300-serial.c
@@ -537,7 +537,7 @@ static void mn10300_serial_receive_interrupt(struct mn10300_serial_port *port)
 	count = CIRC_CNT(port->rx_inp, port->rx_outp, MNSC_BUFFER_SIZE);
 	count = tty_buffer_request_room(port, count);
 	if (count == 0) {
-		if (!tty->low_latency)
+		if (!port->low_latency)
 			tty_flip_buffer_push(tty);
 		return;
 	}
@@ -546,7 +546,7 @@ try_again:
 	/* pull chars out of the hat */
 	ix = ACCESS_ONCE(port->rx_outp);
 	if (CIRC_CNT(port->rx_inp, ix, MNSC_BUFFER_SIZE) == 0) {
-		if (push && !tty->low_latency)
+		if (push && !port->low_latency)
 			tty_flip_buffer_push(tty);
 		return;
 	}
@@ -678,7 +678,7 @@ insert:
 
 	count--;
 	if (count <= 0) {
-		if (!tty->low_latency)
+		if (!port->low_latency)
 			tty_flip_buffer_push(tty);
 		return;
 	}
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index f125f35..47cbacf 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -2522,7 +2522,7 @@ static int mgslpc_open(struct tty_struct *tty, struct file * filp)
 		goto cleanup;
 	}
 
-	tty->low_latency = (port->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	port->low_latency = (port->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	spin_lock_irqsave(&info->netlock, flags);
 	if (info->netcount) {
diff --git a/drivers/isdn/gigaset/interface.c b/drivers/isdn/gigaset/interface.c
index dd2a57e..6dcecd4 100644
--- a/drivers/isdn/gigaset/interface.c
+++ b/drivers/isdn/gigaset/interface.c
@@ -164,7 +164,7 @@ static int if_open(struct tty_struct *tty, struct file *filp)
 
 	if (cs->port.count == 1) {
 		tty_port_tty_set(&cs->port, tty);
-		tty->low_latency = 1;
+		cs->port.low_latency = 1;
 	}
 
 	mutex_unlock(&cs->mutex);
diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index 5de74e7..666891a 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -91,7 +91,7 @@ static inline void update_tty_status(struct ser_device *ser)
 		ser->tty->hw_stopped << 4 |
 		ser->tty->flow_stopped << 3 |
 		ser->tty->packet << 2 |
-		ser->tty->low_latency << 1 |
+		ser->tty->port->low_latency << 1 |
 		ser->tty->warned;
 }
 static inline void debugfs_init(struct ser_device *ser, struct tty_struct *tty)
diff --git a/drivers/net/irda/irtty-sir.c b/drivers/net/irda/irtty-sir.c
index 6e4d4b6..a412671 100644
--- a/drivers/net/irda/irtty-sir.c
+++ b/drivers/net/irda/irtty-sir.c
@@ -210,7 +210,7 @@ static int irtty_do_write(struct sir_dev *dev, const unsigned char *ptr, size_t
  *    been received, which can now be decapsulated and delivered for
  *    further processing 
  *
- * calling context depends on underlying driver and tty->low_latency!
+ * calling context depends on underlying driver and tty->port->low_latency!
  * for example (low_latency: 1 / 0):
  * serial.c:	uart-interrupt / softint
  * usbserial:	urb-complete-interrupt / softint
diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 4c6743d..41b75c5 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -968,7 +968,7 @@ static int tty3215_open(struct tty_struct *tty, struct file * filp)
 
 	tty_port_tty_set(&raw->port, tty);
 
-	tty->low_latency = 0;  /* don't use bottom half for pushing chars */
+	raw->port.low_latency = 0; /* don't use bottom half for pushing chars */
 	/*
 	 * Start up 3215 device
 	 */
diff --git a/drivers/s390/char/sclp_tty.c b/drivers/s390/char/sclp_tty.c
index 3ffddbb..19b7c51 100644
--- a/drivers/s390/char/sclp_tty.c
+++ b/drivers/s390/char/sclp_tty.c
@@ -65,7 +65,7 @@ sclp_tty_open(struct tty_struct *tty, struct file *filp)
 {
 	tty_port_tty_set(&sclp_port, tty);
 	tty->driver_data = NULL;
-	tty->low_latency = 0;
+	sclp_port.low_latency = 0;
 	return 0;
 }
 
diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index b5507f1..0eca99b 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -495,7 +495,7 @@ sclp_vt220_open(struct tty_struct *tty, struct file *filp)
 {
 	if (tty->count == 1) {
 		tty_port_tty_set(&sclp_vt220_port, tty);
-		tty->low_latency = 0;
+		sclp_vt220_port.low_latency = 0;
 		if (!tty->winsize.ws_row && !tty->winsize.ws_col) {
 			tty->winsize.ws_row = 24;
 			tty->winsize.ws_col = 80;
diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index 43ea059..3860e79 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -860,7 +860,7 @@ static int tty3270_install(struct tty_driver *driver, struct tty_struct *tty)
 		tty->driver_data = tp;
 		tty->winsize.ws_row = tp->view.rows - 2;
 		tty->winsize.ws_col = tp->view.cols;
-		tty->low_latency = 0;
+		tp->port.low_latency = 0;
 		/* why to reassign? */
 		tty_port_tty_set(&tp->port, tty);
 		tp->inattr = TF_INPUT;
@@ -893,7 +893,7 @@ static int tty3270_install(struct tty_driver *driver, struct tty_struct *tty)
 	}
 
 	tty_port_tty_set(&tp->port, tty);
-	tty->low_latency = 0;
+	tp->port.low_latency = 0;
 	tty->winsize.ws_row = tp->view.rows - 2;
 	tty->winsize.ws_col = tp->view.cols;
 
diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 2e670d0..2d1357a 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1099,7 +1099,7 @@ static int set_serial_info(struct tty_struct *tty, struct serial_state *state,
 	state->custom_divisor = new_serial.custom_divisor;
 	port->close_delay = new_serial.close_delay * HZ/100;
 	port->closing_wait = new_serial.closing_wait * HZ/100;
-	tty->low_latency = (port->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	port->low_latency = (port->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 check_and_exit:
 	if (port->flags & ASYNC_INITIALIZED) {
@@ -1528,7 +1528,7 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 	if (serial_paranoia_check(info, tty->name, "rs_open"))
 		return -ENODEV;
 
-	tty->low_latency = (port->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	port->low_latency = (port->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	retval = startup(tty, info);
 	if (retval) {
diff --git a/drivers/tty/ipwireless/tty.c b/drivers/tty/ipwireless/tty.c
index a3ad5e1..c43da74 100644
--- a/drivers/tty/ipwireless/tty.c
+++ b/drivers/tty/ipwireless/tty.c
@@ -106,7 +106,7 @@ static int ipw_open(struct tty_struct *linux_tty, struct file *filp)
 
 	tty->port.tty = linux_tty;
 	linux_tty->driver_data = tty;
-	linux_tty->low_latency = 1;
+	tty->port.low_latency = 1;
 
 	if (tty->tty_type == TTYTYPE_MODEM)
 		ipwireless_ppp_open(tty->network);
diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 450c450..e9cdfdf 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -1264,7 +1264,7 @@ static int mxser_set_serial_info(struct tty_struct *tty,
 				(new_serial.flags & ASYNC_FLAGS));
 		port->close_delay = new_serial.close_delay * HZ / 100;
 		port->closing_wait = new_serial.closing_wait * HZ / 100;
-		tty->low_latency = (port->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+		port->low_latency = (port->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 		if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST &&
 				(new_serial.baud_base != info->baud_base ||
 				new_serial.custom_divisor !=
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_core.c b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
index 108122f..0bb2437 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -508,7 +508,7 @@ static void cpm_uart_set_termios(struct uart_port *port,
 
 	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk / 16);
 	if (baud < HW_BUF_SPD_THRESHOLD ||
-	    (pinfo->port.state && pinfo->port.state->port.tty->low_latency))
+	    (pinfo->port.state && pinfo->port.state->port.low_latency))
 		pinfo->rx_fifosize = 1;
 	else
 		pinfo->rx_fifosize = RX_BUF_SIZE;
diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index c82601d..52449ad 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -3462,7 +3462,7 @@ set_serial_info(struct e100_serial *info,
 	info->type = new_serial.type;
 	info->close_delay = new_serial.close_delay;
 	info->closing_wait = new_serial.closing_wait;
-	info->port.tty->low_latency = (info->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	info->port.low_latency = (info->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
  check_and_exit:
 	if (info->flags & ASYNC_INITIALIZED) {
@@ -4106,7 +4106,7 @@ rs_open(struct tty_struct *tty, struct file * filp)
 	tty->driver_data = info;
 	info->port.tty = tty;
 
-	tty->low_latency = !!(info->flags & ASYNC_LOW_LATENCY);
+	info->port.low_latency = !!(info->flags & ASYNC_LOW_LATENCY);
 
 	/*
 	 * If the port is in the middle of closing, bail out now
diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index bfb634e..4bc6e47 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -615,7 +615,7 @@ static int ifx_port_activate(struct tty_port *port, struct tty_struct *tty)
 	tty->driver_data = ifx_dev;
 
 	/* allows flip string push from int context */
-	tty->low_latency = 1;
+	port->low_latency = 1;
 
 	/* set flag to allows data transfer */
 	set_bit(IFX_SPI_STATE_IO_AVAILABLE, &ifx_dev->flags);
diff --git a/drivers/tty/serial/ioc3_serial.c b/drivers/tty/serial/ioc3_serial.c
index 0f25ce4..edbdc4e 100644
--- a/drivers/tty/serial/ioc3_serial.c
+++ b/drivers/tty/serial/ioc3_serial.c
@@ -1000,7 +1000,7 @@ ioc3_change_speed(struct uart_port *the_port,
 
 	the_port->ignore_status_mask = N_ALL_INPUT;
 
-	state->port.tty->low_latency = 1;
+	state->port.low_latency = 1;
 
 	if (iflag & IGNPAR)
 		the_port->ignore_status_mask &= ~(N_PARITY_ERROR
diff --git a/drivers/tty/serial/ioc4_serial.c b/drivers/tty/serial/ioc4_serial.c
index 22343da..bd53669 100644
--- a/drivers/tty/serial/ioc4_serial.c
+++ b/drivers/tty/serial/ioc4_serial.c
@@ -1740,7 +1740,7 @@ ioc4_change_speed(struct uart_port *the_port,
 
 	the_port->ignore_status_mask = N_ALL_INPUT;
 
-	state->port.tty->low_latency = 1;
+	state->port.low_latency = 1;
 
 	if (iflag & IGNPAR)
 		the_port->ignore_status_mask &= ~(N_PARITY_ERROR
diff --git a/drivers/tty/serial/max3100.c b/drivers/tty/serial/max3100.c
index dd6277e..cdc74bc 100644
--- a/drivers/tty/serial/max3100.c
+++ b/drivers/tty/serial/max3100.c
@@ -529,7 +529,7 @@ max3100_set_termios(struct uart_port *port, struct ktermios *termios,
 			MAX3100_STATUS_OE;
 
 	/* we are sending char from a workqueue so enable */
-	s->port.state->port.tty->low_latency = 1;
+	s->port.state->port.low_latency = 1;
 
 	if (s->poll_time > 0)
 		del_timer_sync(&s->timer);
diff --git a/drivers/tty/serial/mpsc.c b/drivers/tty/serial/mpsc.c
index 4bcbc66..6f2d2ce 100644
--- a/drivers/tty/serial/mpsc.c
+++ b/drivers/tty/serial/mpsc.c
@@ -970,7 +970,7 @@ static int mpsc_rx_intr(struct mpsc_port_info *pi)
 #endif
 		/* Following use of tty struct directly is deprecated */
 		if (tty_buffer_request_room(port, bytes_in) < bytes_in) {
-			if (tty->low_latency)
+			if (port->low_latency)
 				tty_flip_buffer_push(tty);
 			/*
 			 * If this failed then we will throw away the bytes
diff --git a/drivers/tty/serial/mrst_max3110.c b/drivers/tty/serial/mrst_max3110.c
index 3b8df7b..4632db7 100644
--- a/drivers/tty/serial/mrst_max3110.c
+++ b/drivers/tty/serial/mrst_max3110.c
@@ -495,7 +495,7 @@ static int serial_m3110_startup(struct uart_port *port)
 			| WC_BAUD_DR2;
 
 	/* as we use thread to handle tx/rx, need set low latency */
-	port->state->port.tty->low_latency = 1;
+	port->state->port.low_latency = 1;
 
 	if (max->irq) {
 		max->read_thread = NULL;
diff --git a/drivers/tty/serial/msm_serial_hs.c b/drivers/tty/serial/msm_serial_hs.c
index 11b7f5b..c356fff 100644
--- a/drivers/tty/serial/msm_serial_hs.c
+++ b/drivers/tty/serial/msm_serial_hs.c
@@ -1400,7 +1400,7 @@ static int msm_hs_startup(struct uart_port *uport)
 
 	/* do not let tty layer execute RX in global workqueue, use a
 	 * dedicated workqueue managed by this driver */
-	uport->state->port.tty->low_latency = 1;
+	uport->state->port.low_latency = 1;
 
 	/* turn on uart clk */
 	ret = msm_hs_init_clk_locked(uport);
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 7805609..da8a025 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -866,9 +866,7 @@ static int uart_set_info(struct tty_struct *tty, struct tty_port *port,
 	port->closing_wait    = closing_wait;
 	if (new_info->xmit_fifo_size)
 		uport->fifosize = new_info->xmit_fifo_size;
-	if (port->tty)
-		port->tty->low_latency =
-			(uport->flags & UPF_LOW_LATENCY) ? 1 : 0;
+	port->low_latency = (uport->flags & UPF_LOW_LATENCY) ? 1 : 0;
 
  check_and_exit:
 	retval = 0;
@@ -1564,7 +1562,8 @@ static int uart_open(struct tty_struct *tty, struct file *filp)
 	 */
 	tty->driver_data = state;
 	state->uart_port->state = state;
-	tty->low_latency = (state->uart_port->flags & UPF_LOW_LATENCY) ? 1 : 0;
+	state->port.low_latency =
+		(state->uart_port->flags & UPF_LOW_LATENCY) ? 1 : 0;
 	tty_port_tty_set(port, tty);
 
 	/*
diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index b5686b5..a1891ef 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -3416,7 +3416,7 @@ static int mgsl_open(struct tty_struct *tty, struct file * filp)
 		goto cleanup;
 	}
 	
-	info->port.tty->low_latency = (info->port.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	info->port.low_latency = (info->port.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	spin_lock_irqsave(&info->netlock, flags);
 	if (info->netcount) {
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index a0639a0..a7790b5 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -683,7 +683,7 @@ static int open(struct tty_struct *tty, struct file *filp)
 	}
 
 	mutex_lock(&info->port.mutex);
-	info->port.tty->low_latency = (info->port.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	info->port.low_latency = (info->port.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	spin_lock_irqsave(&info->netlock, flags);
 	if (info->netcount) {
diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index 0afabc0..27a29b5 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -762,7 +762,7 @@ static int open(struct tty_struct *tty, struct file *filp)
 		goto cleanup;
 	}
 
-	info->port.tty->low_latency = (info->port.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	info->port.low_latency = (info->port.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	spin_lock_irqsave(&info->netlock, flags);
 	if (info->netcount) {
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 31873e4..1bfe97a 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -364,7 +364,7 @@ void tty_schedule_flip(struct tty_struct *tty)
 {
 	struct tty_bufhead *buf = &tty->port->buf;
 	unsigned long flags;
-	WARN_ON(tty->low_latency);
+	WARN_ON(tty->port->low_latency);
 
 	spin_lock_irqsave(&buf->lock, flags);
 	if (buf->tail != NULL)
@@ -538,7 +538,7 @@ static void flush_to_ldisc(struct work_struct *work)
  */
 void tty_flush_to_ldisc(struct tty_struct *tty)
 {
-	if (!tty->low_latency)
+	if (!tty->port->low_latency)
 		flush_work(&tty->port->buf.work);
 }
 
@@ -547,7 +547,8 @@ void tty_flush_to_ldisc(struct tty_struct *tty)
  *	@tty: tty to push
  *
  *	Queue a push of the terminal flip buffers to the line discipline. This
- *	function must not be called from IRQ context if tty->low_latency is set.
+ *	function must not be called from IRQ context if port->low_latency is
+ *	set.
  *
  *	In the event of the queue being busy for flipping the work will be
  *	held off and retried later.
@@ -565,7 +566,7 @@ void tty_flip_buffer_push(struct tty_struct *tty)
 		buf->tail->commit = buf->tail->used;
 	spin_unlock_irqrestore(&buf->lock, flags);
 
-	if (tty->low_latency)
+	if (tty->port->low_latency)
 		flush_to_ldisc(&buf->work);
 	else
 		schedule_work(&buf->work);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 8db1b56..f16a47a 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -202,7 +202,8 @@ struct tty_port {
 	unsigned long		iflags;		/* TTYP_ internal flags */
 #define TTYP_FLUSHING			1  /* Flushing to ldisc in progress */
 #define TTYP_FLUSHPENDING		2  /* Queued buffer flush pending */
-	unsigned char		console:1;	/* port is a console */
+	unsigned char		console:1,	/* port is a console */
+				low_latency:1;	/* direct buffer flush */
 	struct mutex		mutex;		/* Locking */
 	struct mutex		buf_mutex;	/* Buffer alloc lock */
 	unsigned char		*xmit_buf;	/* Optional buffer */
@@ -254,7 +255,7 @@ struct tty_struct {
 	int count;
 	struct winsize winsize;		/* termios mutex */
 	unsigned char stopped:1, hw_stopped:1, flow_stopped:1, packet:1;
-	unsigned char low_latency:1, warned:1;
+	unsigned char warned:1;
 	unsigned char ctrl_status;	/* ctrl_lock */
 	unsigned int receive_room;	/* Bytes free for queue */
 
diff --git a/net/irda/ircomm/ircomm_tty.c b/net/irda/ircomm/ircomm_tty.c
index 14b08e3..2491f6f 100644
--- a/net/irda/ircomm/ircomm_tty.c
+++ b/net/irda/ircomm/ircomm_tty.c
@@ -452,7 +452,7 @@ static int ircomm_tty_open(struct tty_struct *tty, struct file *filp)
 		   self->line, self->port.count);
 
 	/* Not really used by us, but lets do it anyway */
-	tty->low_latency = (self->port.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	self->port.low_latency = (self->port.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	/*
 	 * If the port is the middle of closing, bail out now
-- 
1.8.1



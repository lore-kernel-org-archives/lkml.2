Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab3ACOxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 09:53:41 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:60983 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab3ACOxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 09:53:17 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 07/10] TTY: switch tty_schedule_flip
Date: Thu,  3 Jan 2013 15:53:07 +0100
Message-Id: <1357224789-2853-8-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
References: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, we start converting tty buffer functions to actually use
tty_port. This will allow us to get rid of the need of tty in many
call sites. Only tty_port will needed and hence no more
tty_port_tty_get in those paths.

This is the last one: tty_schedule_flip

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/alpha/kernel/srmcons.c             | 17 ++++++++---------
 drivers/s390/char/keyboard.h            | 12 ++----------
 drivers/staging/serqt_usb2/serqt_usb2.c | 19 ++++++-------------
 drivers/tty/cyclades.c                  | 33 ++++++++++++---------------------
 drivers/tty/moxa.c                      |  4 ++--
 drivers/tty/serial/68328serial.c        | 15 ++++-----------
 drivers/tty/serial/lpc32xx_hs.c         |  6 +-----
 drivers/tty/tty_buffer.c                |  8 ++++----
 drivers/tty/vt/keyboard.c               | 19 +++----------------
 drivers/tty/vt/vt.c                     | 16 ++++++++--------
 include/linux/tty_flip.h                |  2 +-
 11 files changed, 51 insertions(+), 100 deletions(-)

diff --git a/arch/alpha/kernel/srmcons.c b/arch/alpha/kernel/srmcons.c
index 21b57a6..6f01d9a 100644
--- a/arch/alpha/kernel/srmcons.c
+++ b/arch/alpha/kernel/srmcons.c
@@ -44,9 +44,8 @@ typedef union _srmcons_result {
 
 /* called with callback_lock held */
 static int
-srmcons_do_receive_chars(struct tty_struct *tty)
+srmcons_do_receive_chars(struct tty_port *port)
 {
-	struct tty_port *port = tty->port;
 	srmcons_result result;
 	int count = 0, loops = 0;
 
@@ -59,7 +58,7 @@ srmcons_do_receive_chars(struct tty_struct *tty)
 	} while((result.bits.status & 1) && (++loops < 10));
 
 	if (count)
-		tty_schedule_flip(tty);
+		tty_schedule_flip(port);
 
 	return count;
 }
@@ -74,7 +73,7 @@ srmcons_receive_chars(unsigned long data)
 
 	local_irq_save(flags);
 	if (spin_trylock(&srmcons_callback_lock)) {
-		if (!srmcons_do_receive_chars(port->tty))
+		if (!srmcons_do_receive_chars(port))
 			incr = 100;
 		spin_unlock(&srmcons_callback_lock);
 	} 
@@ -89,7 +88,7 @@ srmcons_receive_chars(unsigned long data)
 
 /* called with callback_lock held */
 static int
-srmcons_do_write(struct tty_struct *tty, const char *buf, int count)
+srmcons_do_write(struct tty_port *port, const char *buf, int count)
 {
 	static char str_cr[1] = "\r";
 	long c, remaining = count;
@@ -114,10 +113,10 @@ srmcons_do_write(struct tty_struct *tty, const char *buf, int count)
 			cur += result.bits.c;
 
 			/*
-			 * Check for pending input iff a tty was provided
+			 * Check for pending input iff a tty port was provided
 			 */
-			if (tty)
-				srmcons_do_receive_chars(tty);
+			if (port)
+				srmcons_do_receive_chars(port);
 		}
 
 		while (need_cr) {
@@ -136,7 +135,7 @@ srmcons_write(struct tty_struct *tty,
 	unsigned long flags;
 
 	spin_lock_irqsave(&srmcons_callback_lock, flags);
-	srmcons_do_write(tty, (const char *) buf, count);
+	srmcons_do_write(tty->port, (const char *) buf, count);
 	spin_unlock_irqrestore(&srmcons_callback_lock, flags);
 
 	return count;
diff --git a/drivers/s390/char/keyboard.h b/drivers/s390/char/keyboard.h
index acab28d..a31f339 100644
--- a/drivers/s390/char/keyboard.h
+++ b/drivers/s390/char/keyboard.h
@@ -43,22 +43,14 @@ int kbd_ioctl(struct kbd_data *, unsigned int, unsigned long);
 static inline void
 kbd_put_queue(struct tty_port *port, int ch)
 {
-	struct tty_struct *tty = tty_port_tty_get(port);
-	if (!tty)
-		return;
 	tty_insert_flip_char(port, ch, 0);
-	tty_schedule_flip(tty);
-	tty_kref_put(tty);
+	tty_schedule_flip(port);
 }
 
 static inline void
 kbd_puts_queue(struct tty_port *port, char *cp)
 {
-	struct tty_struct *tty = tty_port_tty_get(port);
-	if (!tty)
-		return;
 	while (*cp)
 		tty_insert_flip_char(port, *cp++, 0);
-	tty_schedule_flip(tty);
-	tty_kref_put(tty);
+	tty_schedule_flip(port);
 }
diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index df29a3d..b1bb1a6 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -356,7 +356,6 @@ static void qt_read_bulk_callback(struct urb *urb)
 	struct usb_serial_port *port = urb->context;
 	struct usb_serial *serial = get_usb_serial(port, __func__);
 	struct quatech_port *qt_port = qt_get_port_private(port);
-	struct tty_struct *tty;
 	int result;
 
 	if (urb->status) {
@@ -367,27 +366,23 @@ static void qt_read_bulk_callback(struct urb *urb)
 		return;
 	}
 
-	tty = tty_port_tty_get(&port->port);
-	if (!tty)
-		return;
-
 	dev_dbg(&port->dev,
 		"%s - port->RxHolding = %d\n", __func__, qt_port->RxHolding);
 
 	if (port_paranoia_check(port, __func__) != 0) {
 		qt_port->ReadBulkStopped = 1;
-		goto exit;
+		return;
 	}
 
 	if (!serial)
-		goto exit;
+		return;
 
 	if (qt_port->closePending == 1) {
 		/* Were closing , stop reading */
 		dev_dbg(&port->dev,
 			"%s - (qt_port->closepending == 1\n", __func__);
 		qt_port->ReadBulkStopped = 1;
-		goto exit;
+		return;
 	}
 
 	/*
@@ -397,7 +392,7 @@ static void qt_read_bulk_callback(struct urb *urb)
 	 */
 	if (qt_port->RxHolding == 1) {
 		qt_port->ReadBulkStopped = 1;
-		goto exit;
+		return;
 	}
 
 	if (urb->status) {
@@ -406,7 +401,7 @@ static void qt_read_bulk_callback(struct urb *urb)
 		dev_dbg(&port->dev,
 			"%s - nonzero read bulk status received: %d\n",
 			__func__, urb->status);
-		goto exit;
+		return;
 	}
 
 	if (urb->actual_length)
@@ -427,13 +422,11 @@ static void qt_read_bulk_callback(struct urb *urb)
 	else {
 		if (urb->actual_length) {
 			tty_flip_buffer_push(&port->port);
-			tty_schedule_flip(tty);
+			tty_schedule_flip(&port->port);
 		}
 	}
 
 	schedule_work(&port->work);
-exit:
-	tty_kref_put(tty);
 }
 
 /*
diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index d1fe9a1..42a329b 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -441,7 +441,6 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 		void __iomem *base_addr)
 {
 	struct cyclades_port *info;
-	struct tty_struct *tty;
 	struct tty_port *port;
 	int len, index = cinfo->bus_index;
 	u8 ivr, save_xir, channel, save_car, data, char_count;
@@ -458,18 +457,6 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 	cyy_writeb(info, CyCAR, save_xir);
 	ivr = cyy_readb(info, CyRIVR) & CyIVRMask;
 
-	tty = tty_port_tty_get(port);
-	/* if there is nowhere to put the data, discard it */
-	if (tty == NULL) {
-		if (ivr == CyIVRRxEx) {	/* exception */
-			data = cyy_readb(info, CyRDSR);
-		} else {	/* normal character reception */
-			char_count = cyy_readb(info, CyRDCR);
-			while (char_count--)
-				data = cyy_readb(info, CyRDSR);
-		}
-		goto end;
-	}
 	/* there is an open port for this data */
 	if (ivr == CyIVRRxEx) {	/* exception */
 		data = cyy_readb(info, CyRDSR);
@@ -486,7 +473,6 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 
 		if (data & info->ignore_status_mask) {
 			info->icount.rx++;
-			tty_kref_put(tty);
 			return;
 		}
 		if (tty_buffer_request_room(port, 1)) {
@@ -496,8 +482,14 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 						cyy_readb(info, CyRDSR),
 						TTY_BREAK);
 					info->icount.rx++;
-					if (port->flags & ASYNC_SAK)
-						do_SAK(tty);
+					if (port->flags & ASYNC_SAK) {
+						struct tty_struct *tty =
+							tty_port_tty_get(port);
+						if (tty) {
+							do_SAK(tty);
+							tty_kref_put(tty);
+						}
+					}
 				} else if (data & CyFRAME) {
 					tty_insert_flip_char(port,
 						cyy_readb(info, CyRDSR),
@@ -566,9 +558,8 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 		}
 		info->idle_stats.recv_idle = jiffies;
 	}
-	tty_schedule_flip(tty);
-	tty_kref_put(tty);
-end:
+	tty_schedule_flip(port);
+
 	/* end of service */
 	cyy_writeb(info, CyRIR, save_xir & 0x3f);
 	cyy_writeb(info, CyCAR, save_car);
@@ -1012,7 +1003,7 @@ static void cyz_handle_rx(struct cyclades_port *info, struct tty_struct *tty)
 						jiffies + 1);
 #endif
 			info->idle_stats.recv_idle = jiffies;
-			tty_schedule_flip(tty);
+			tty_schedule_flip(&info->port);
 		}
 		/* Update rx_get */
 		cy_writel(&buf_ctrl->rx_get, new_rx_get);
@@ -1191,7 +1182,7 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
 		if (delta_count)
 			wake_up_interruptible(&info->port.delta_msr_wait);
 		if (special_count)
-			tty_schedule_flip(tty);
+			tty_schedule_flip(&info->port);
 		tty_kref_put(tty);
 	}
 }
diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index f42492d..adeac25 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -1405,7 +1405,7 @@ static int moxa_poll_port(struct moxa_port *p, unsigned int handle,
 		if (inited && !test_bit(TTY_THROTTLED, &tty->flags) &&
 				MoxaPortRxQueue(p) > 0) { /* RX */
 			MoxaPortReadData(p);
-			tty_schedule_flip(tty);
+			tty_schedule_flip(&p->port);
 		}
 	} else {
 		clear_bit(EMPTYWAIT, &p->statusflags);
@@ -1430,7 +1430,7 @@ static int moxa_poll_port(struct moxa_port *p, unsigned int handle,
 
 	if (tty && (intr & IntrBreak) && !I_IGNBRK(tty)) { /* BREAK */
 		tty_insert_flip_char(&p->port, 0, TTY_BREAK);
-		tty_schedule_flip(tty);
+		tty_schedule_flip(&p->port);
 	}
 
 	if (intr & IntrLine)
diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
index 3719273..641a5a4 100644
--- a/drivers/tty/serial/68328serial.c
+++ b/drivers/tty/serial/68328serial.c
@@ -262,8 +262,7 @@ static void rs_start(struct tty_struct *tty)
 	local_irq_restore(flags);
 }
 
-static void receive_chars(struct m68k_serial *info, struct tty_struct *tty,
-		unsigned short rx)
+static void receive_chars(struct m68k_serial *info, unsigned short rx)
 {
 	m68328_uart *uart = &uart_addr[info->line];
 	unsigned char ch, flag;
@@ -293,9 +292,6 @@ static void receive_chars(struct m68k_serial *info, struct tty_struct *tty,
 			}
 		}
 
-		if(!tty)
-			goto clear_and_exit;
-		
 		flag = TTY_NORMAL;
 
 		if (rx & URX_PARITY_ERROR)
@@ -310,10 +306,7 @@ static void receive_chars(struct m68k_serial *info, struct tty_struct *tty,
 	} while((rx = uart->urx.w) & URX_DATA_READY);
 #endif
 
-	tty_schedule_flip(tty);
-
-clear_and_exit:
-	return;
+	tty_schedule_flip(&info->tport);
 }
 
 static void transmit_chars(struct m68k_serial *info, struct tty_struct *tty)
@@ -367,11 +360,11 @@ irqreturn_t rs_interrupt(int irq, void *dev_id)
 	tx = uart->utx.w;
 
 	if (rx & URX_DATA_READY)
-		receive_chars(info, tty, rx);
+		receive_chars(info, rx);
 	if (tx & UTX_TX_AVAIL)
 		transmit_chars(info, tty);
 #else
-	receive_chars(info, tty, rx);
+	receive_chars(info, rx);
 #endif
 	tty_kref_put(tty);
 
diff --git a/drivers/tty/serial/lpc32xx_hs.c b/drivers/tty/serial/lpc32xx_hs.c
index c8448e6..c01b58f 100644
--- a/drivers/tty/serial/lpc32xx_hs.c
+++ b/drivers/tty/serial/lpc32xx_hs.c
@@ -323,7 +323,6 @@ static irqreturn_t serial_lpc32xx_interrupt(int irq, void *dev_id)
 {
 	struct uart_port *port = dev_id;
 	struct tty_port *port = &port->state->port;
-	struct tty_struct *tty = tty_port_tty_get(tport);
 	u32 status;
 
 	spin_lock(&port->lock);
@@ -348,9 +347,7 @@ static irqreturn_t serial_lpc32xx_interrupt(int irq, void *dev_id)
 		       LPC32XX_HSUART_IIR(port->membase));
 		port->icount.overrun++;
 		tty_insert_flip_char(tport, 0, TTY_OVERRUN);
-		if (tty) {
-			tty_schedule_flip(tty);
-		}
+		tty_schedule_flip(tport);
 	}
 
 	/* Data received? */
@@ -366,7 +363,6 @@ static irqreturn_t serial_lpc32xx_interrupt(int irq, void *dev_id)
 	}
 
 	spin_unlock(&port->lock);
-	tty_kref_put(tty);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index b6efaca..d6969f6 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -349,7 +349,7 @@ EXPORT_SYMBOL(tty_insert_flip_string_flags);
 
 /**
  *	tty_schedule_flip	-	push characters to ldisc
- *	@tty: tty to push from
+ *	@port: tty port to push from
  *
  *	Takes any pending buffers and transfers their ownership to the
  *	ldisc side of the queue. It then schedules those characters for
@@ -360,11 +360,11 @@ EXPORT_SYMBOL(tty_insert_flip_string_flags);
  *	Locking: Takes port->buf.lock
  */
 
-void tty_schedule_flip(struct tty_struct *tty)
+void tty_schedule_flip(struct tty_port *port)
 {
-	struct tty_bufhead *buf = &tty->port->buf;
+	struct tty_bufhead *buf = &port->buf;
 	unsigned long flags;
-	WARN_ON(tty->port->low_latency);
+	WARN_ON(port->low_latency);
 
 	spin_lock_irqsave(&buf->lock, flags);
 	if (buf->tail != NULL)
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index 5aace4d..a9af1b9a 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -307,26 +307,17 @@ int kbd_rate(struct kbd_repeat *rep)
  */
 static void put_queue(struct vc_data *vc, int ch)
 {
-	struct tty_struct *tty = vc->port.tty;
-
 	tty_insert_flip_char(&vc->port, ch, 0);
-	if (tty) {
-		tty_schedule_flip(tty);
-	}
+	tty_schedule_flip(&vc->port);
 }
 
 static void puts_queue(struct vc_data *vc, char *cp)
 {
-	struct tty_struct *tty = vc->port.tty;
-
-	if (!tty)
-		return;
-
 	while (*cp) {
 		tty_insert_flip_char(&vc->port, *cp, 0);
 		cp++;
 	}
-	tty_schedule_flip(tty);
+	tty_schedule_flip(&vc->port);
 }
 
 static void applkey(struct vc_data *vc, int key, char mode)
@@ -582,12 +573,8 @@ static void fn_inc_console(struct vc_data *vc)
 
 static void fn_send_intr(struct vc_data *vc)
 {
-	struct tty_struct *tty = vc->port.tty;
-
-	if (!tty)
-		return;
 	tty_insert_flip_char(&vc->port, 0, TTY_BREAK);
-	tty_schedule_flip(tty);
+	tty_schedule_flip(&vc->port);
 }
 
 static void fn_scroll_forw(struct vc_data *vc)
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 2c465bb..37699d8 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1333,13 +1333,13 @@ static void csi_m(struct vc_data *vc)
 	update_attr(vc);
 }
 
-static void respond_string(const char *p, struct tty_struct *tty)
+static void respond_string(const char *p, struct tty_port *port)
 {
 	while (*p) {
-		tty_insert_flip_char(tty->port, *p, 0);
+		tty_insert_flip_char(port, *p, 0);
 		p++;
 	}
-	tty_schedule_flip(tty);
+	tty_schedule_flip(port);
 }
 
 static void cursor_report(struct vc_data *vc, struct tty_struct *tty)
@@ -1347,17 +1347,17 @@ static void cursor_report(struct vc_data *vc, struct tty_struct *tty)
 	char buf[40];
 
 	sprintf(buf, "\033[%d;%dR", vc->vc_y + (vc->vc_decom ? vc->vc_top + 1 : 1), vc->vc_x + 1);
-	respond_string(buf, tty);
+	respond_string(buf, tty->port);
 }
 
 static inline void status_report(struct tty_struct *tty)
 {
-	respond_string("\033[0n", tty);	/* Terminal ok */
+	respond_string("\033[0n", tty->port);	/* Terminal ok */
 }
 
-static inline void respond_ID(struct tty_struct * tty)
+static inline void respond_ID(struct tty_struct *tty)
 {
-	respond_string(VT102ID, tty);
+	respond_string(VT102ID, tty->port);
 }
 
 void mouse_report(struct tty_struct *tty, int butt, int mrx, int mry)
@@ -1366,7 +1366,7 @@ void mouse_report(struct tty_struct *tty, int butt, int mrx, int mry)
 
 	sprintf(buf, "\033[M%c%c%c", (char)(' ' + butt), (char)('!' + mrx),
 		(char)('!' + mry));
-	respond_string(buf, tty);
+	respond_string(buf, tty->port);
 }
 
 /* invoked via ioctl(TIOCLINUX) and through set_selection */
diff --git a/include/linux/tty_flip.h b/include/linux/tty_flip.h
index c557280..e0f2526 100644
--- a/include/linux/tty_flip.h
+++ b/include/linux/tty_flip.h
@@ -11,7 +11,7 @@ extern int tty_prepare_flip_string(struct tty_port *port,
 extern int tty_prepare_flip_string_flags(struct tty_port *port,
 		unsigned char **chars, char **flags, size_t size);
 extern void tty_flip_buffer_push(struct tty_port *port);
-void tty_schedule_flip(struct tty_struct *tty);
+void tty_schedule_flip(struct tty_port *port);
 
 static inline int tty_insert_flip_char(struct tty_port *port,
 					unsigned char ch, char flag)
-- 
1.8.1



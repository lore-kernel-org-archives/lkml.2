Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3ACOxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 09:53:43 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:60979 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab3ACOxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 09:53:17 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 02/10] TTY: convert more flipping functions
Date: Thu,  3 Jan 2013 15:53:02 +0100
Message-Id: <1357224789-2853-3-git-send-email-jslaby@suse.cz>
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

Now 4 string flipping ones are on turn:
* tty_insert_flip_string_flags
* tty_insert_flip_string_fixed_flag
* tty_prepare_flip_string
* tty_prepare_flip_string_flags

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/staging/dgrp/dgrp_net_ops.c  |  2 +-
 drivers/staging/fwserial/fwserial.c  |  8 +++++---
 drivers/tty/cyclades.c               |  2 +-
 drivers/tty/isicom.c                 |  4 ++--
 drivers/tty/moxa.c                   |  4 ++--
 drivers/tty/rocket.c                 |  2 +-
 drivers/tty/serial/msm_smd_tty.c     |  2 +-
 drivers/tty/tty_buffer.c             | 32 ++++++++++++++++----------------
 drivers/usb/serial/ark3116.c         |  2 +-
 drivers/usb/serial/belkin_sa.c       |  2 +-
 drivers/usb/serial/cypress_m8.c      |  2 +-
 drivers/usb/serial/digi_acceleport.c |  4 ++--
 drivers/usb/serial/f81232.c          |  2 +-
 drivers/usb/serial/ftdi_sio.c        |  2 +-
 drivers/usb/serial/pl2303.c          |  2 +-
 drivers/usb/serial/spcp8x5.c         |  2 +-
 drivers/usb/serial/ssu100.c          |  2 +-
 include/linux/tty_flip.h             | 16 ++++++++++------
 18 files changed, 49 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/dgrp/dgrp_net_ops.c b/drivers/staging/dgrp/dgrp_net_ops.c
index c0aeaaa..df3ebcd 100644
--- a/drivers/staging/dgrp/dgrp_net_ops.c
+++ b/drivers/staging/dgrp/dgrp_net_ops.c
@@ -232,7 +232,7 @@ static void dgrp_input(struct ch_struct *ch)
 		    (nd->nd_dpa_port == PORT_NUM(MINOR(tty_devnum(tty)))))
 			dgrp_dpa_data(nd, 1, myflipbuf, len);
 
-		tty_insert_flip_string_flags(tty, myflipbuf,
+		tty_insert_flip_string_flags(&ch->port, myflipbuf,
 					     myflipflagbuf, len);
 		tty_flip_buffer_push(tty);
 
diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index 61ee290..85dbdc1 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -507,7 +507,8 @@ static void fwtty_emit_breaks(struct work_struct *work)
 
 	while (n) {
 		t = min(n, 16);
-		c = tty_insert_flip_string_fixed_flag(tty, buf, TTY_BREAK, t);
+		c = tty_insert_flip_string_fixed_flag(&port->port, buf,
+				TTY_BREAK, t);
 		n -= c;
 		brk += c;
 		if (c < t)
@@ -535,7 +536,7 @@ static void fwtty_pushrx(struct work_struct *work)
 
 	spin_lock_bh(&port->lock);
 	list_for_each_entry_safe(buf, next, &port->buf_list, list) {
-		n = tty_insert_flip_string_fixed_flag(tty, buf->data,
+		n = tty_insert_flip_string_fixed_flag(&port->port, buf->data,
 						      TTY_NORMAL, buf->n);
 		c += n;
 		port->buffered -= n;
@@ -630,7 +631,8 @@ static int fwtty_rx(struct fwtty_port *port, unsigned char *data, size_t len)
 	}
 
 	if (!test_bit(BUFFERING_RX, &port->flags)) {
-		c = tty_insert_flip_string_fixed_flag(tty, data, TTY_NORMAL, n);
+		c = tty_insert_flip_string_fixed_flag(&port->port, data,
+				TTY_NORMAL, n);
 		if (c > 0)
 			tty_flip_buffer_push(tty);
 		n -= c;
diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index b85acc7..0b7573d 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -968,7 +968,7 @@ static void cyz_handle_rx(struct cyclades_port *info, struct tty_struct *tty)
 		   for performance, but because of buffer boundaries, there
 		   may be several steps to the operation */
 			while (1) {
-				len = tty_prepare_flip_string(tty, &buf,
+				len = tty_prepare_flip_string(port, &buf,
 						char_count);
 				if (!len)
 					break;
diff --git a/drivers/tty/isicom.c b/drivers/tty/isicom.c
index 3205b2e..e9fc15f 100644
--- a/drivers/tty/isicom.c
+++ b/drivers/tty/isicom.c
@@ -650,8 +650,8 @@ static irqreturn_t isicom_interrupt(int irq, void *dev_id)
 			break;
 		}
 	} else {				/* Data   Packet */
-
-		count = tty_prepare_flip_string(tty, &rp, byte_count & ~1);
+		count = tty_prepare_flip_string(&port->port, &rp,
+				byte_count & ~1);
 		pr_debug("%s: Can rx %d of %d bytes.\n",
 			 __func__, count, byte_count);
 		word_count = count >> 1;
diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index f9d2850..fcaac48 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -1966,7 +1966,7 @@ static int MoxaPortReadData(struct moxa_port *port)
 			ofs = baseAddr + DynPage_addr + bufhead + head;
 			len = (tail >= head) ? (tail - head) :
 					(rx_mask + 1 - head);
-			len = tty_prepare_flip_string(tty, &dst,
+			len = tty_prepare_flip_string(&port->port, &dst,
 					min(len, count));
 			memcpy_fromio(dst, ofs, len);
 			head = (head + len) & rx_mask;
@@ -1978,7 +1978,7 @@ static int MoxaPortReadData(struct moxa_port *port)
 		while (count > 0) {
 			writew(pageno, baseAddr + Control_reg);
 			ofs = baseAddr + DynPage_addr + pageofs;
-			len = tty_prepare_flip_string(tty, &dst,
+			len = tty_prepare_flip_string(&port->port, &dst,
 					min(Page_size - pageofs, count));
 			memcpy_fromio(dst, ofs, len);
 
diff --git a/drivers/tty/rocket.c b/drivers/tty/rocket.c
index e42009a..77d7bc9 100644
--- a/drivers/tty/rocket.c
+++ b/drivers/tty/rocket.c
@@ -399,7 +399,7 @@ static void rp_do_receive(struct r_port *info,
 		 * characters at time by doing repeated word IO
 		 * transfer.
 		 */
-		space = tty_prepare_flip_string(tty, &cbuf, ToRecv);
+		space = tty_prepare_flip_string(&info->port, &cbuf, ToRecv);
 		if (space < ToRecv) {
 #ifdef ROCKET_DEBUG_RECEIVE
 			printk(KERN_INFO "rp_do_receive:insufficient space ToRecv=%d space=%d\n", ToRecv, space);
diff --git a/drivers/tty/serial/msm_smd_tty.c b/drivers/tty/serial/msm_smd_tty.c
index 925d1fa..b43b4ec 100644
--- a/drivers/tty/serial/msm_smd_tty.c
+++ b/drivers/tty/serial/msm_smd_tty.c
@@ -70,7 +70,7 @@ static void smd_tty_notify(void *priv, unsigned event)
 		if (avail == 0)
 			break;
 
-		avail = tty_prepare_flip_string(tty, &ptr, avail);
+		avail = tty_prepare_flip_string(&info->port, &ptr, avail);
 
 		if (smd_read(info->ch, ptr, avail) != avail) {
 			/* shouldn't be possible since we're in interrupt
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index f897332..31873e4 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -257,7 +257,7 @@ EXPORT_SYMBOL_GPL(tty_buffer_request_room);
 
 /**
  *	tty_insert_flip_string_fixed_flag - Add characters to the tty buffer
- *	@tty: tty structure
+ *	@port: tty port
  *	@chars: characters
  *	@flag: flag value for each character
  *	@size: size
@@ -268,10 +268,10 @@ EXPORT_SYMBOL_GPL(tty_buffer_request_room);
  *	Locking: Called functions may take port->buf.lock
  */
 
-int tty_insert_flip_string_fixed_flag(struct tty_struct *tty,
+int tty_insert_flip_string_fixed_flag(struct tty_port *port,
 		const unsigned char *chars, char flag, size_t size)
 {
-	struct tty_bufhead *buf = &tty->port->buf;
+	struct tty_bufhead *buf = &port->buf;
 	int copied = 0;
 	do {
 		int goal = min_t(size_t, size - copied, TTY_BUFFER_PAGE);
@@ -280,7 +280,7 @@ int tty_insert_flip_string_fixed_flag(struct tty_struct *tty,
 		struct tty_buffer *tb;
 
 		spin_lock_irqsave(&buf->lock, flags);
-		space = __tty_buffer_request_room(tty->port, goal);
+		space = __tty_buffer_request_room(port, goal);
 		tb = buf->tail;
 		/* If there is no space then tb may be NULL */
 		if (unlikely(space == 0)) {
@@ -302,7 +302,7 @@ EXPORT_SYMBOL(tty_insert_flip_string_fixed_flag);
 
 /**
  *	tty_insert_flip_string_flags	-	Add characters to the tty buffer
- *	@tty: tty structure
+ *	@port: tty port
  *	@chars: characters
  *	@flags: flag bytes
  *	@size: size
@@ -314,10 +314,10 @@ EXPORT_SYMBOL(tty_insert_flip_string_fixed_flag);
  *	Locking: Called functions may take port->buf.lock
  */
 
-int tty_insert_flip_string_flags(struct tty_struct *tty,
+int tty_insert_flip_string_flags(struct tty_port *port,
 		const unsigned char *chars, const char *flags, size_t size)
 {
-	struct tty_bufhead *buf = &tty->port->buf;
+	struct tty_bufhead *buf = &port->buf;
 	int copied = 0;
 	do {
 		int goal = min_t(size_t, size - copied, TTY_BUFFER_PAGE);
@@ -326,7 +326,7 @@ int tty_insert_flip_string_flags(struct tty_struct *tty,
 		struct tty_buffer *tb;
 
 		spin_lock_irqsave(&buf->lock, __flags);
-		space = __tty_buffer_request_room(tty->port, goal);
+		space = __tty_buffer_request_room(port, goal);
 		tb = buf->tail;
 		/* If there is no space then tb may be NULL */
 		if (unlikely(space == 0)) {
@@ -376,7 +376,7 @@ EXPORT_SYMBOL(tty_schedule_flip);
 
 /**
  *	tty_prepare_flip_string		-	make room for characters
- *	@tty: tty
+ *	@port: tty port
  *	@chars: return pointer for character write area
  *	@size: desired size
  *
@@ -389,16 +389,16 @@ EXPORT_SYMBOL(tty_schedule_flip);
  *	Locking: May call functions taking port->buf.lock
  */
 
-int tty_prepare_flip_string(struct tty_struct *tty, unsigned char **chars,
+int tty_prepare_flip_string(struct tty_port *port, unsigned char **chars,
 		size_t size)
 {
-	struct tty_bufhead *buf = &tty->port->buf;
+	struct tty_bufhead *buf = &port->buf;
 	int space;
 	unsigned long flags;
 	struct tty_buffer *tb;
 
 	spin_lock_irqsave(&buf->lock, flags);
-	space = __tty_buffer_request_room(tty->port, size);
+	space = __tty_buffer_request_room(port, size);
 
 	tb = buf->tail;
 	if (likely(space)) {
@@ -413,7 +413,7 @@ EXPORT_SYMBOL_GPL(tty_prepare_flip_string);
 
 /**
  *	tty_prepare_flip_string_flags	-	make room for characters
- *	@tty: tty
+ *	@port: tty port
  *	@chars: return pointer for character write area
  *	@flags: return pointer for status flag write area
  *	@size: desired size
@@ -427,16 +427,16 @@ EXPORT_SYMBOL_GPL(tty_prepare_flip_string);
  *	Locking: May call functions taking port->buf.lock
  */
 
-int tty_prepare_flip_string_flags(struct tty_struct *tty,
+int tty_prepare_flip_string_flags(struct tty_port *port,
 			unsigned char **chars, char **flags, size_t size)
 {
-	struct tty_bufhead *buf = &tty->port->buf;
+	struct tty_bufhead *buf = &port->buf;
 	int space;
 	unsigned long __flags;
 	struct tty_buffer *tb;
 
 	spin_lock_irqsave(&buf->lock, __flags);
-	space = __tty_buffer_request_room(tty->port, size);
+	space = __tty_buffer_request_room(port, size);
 
 	tb = buf->tail;
 	if (likely(space)) {
diff --git a/drivers/usb/serial/ark3116.c b/drivers/usb/serial/ark3116.c
index a88882c..e2d653d 100644
--- a/drivers/usb/serial/ark3116.c
+++ b/drivers/usb/serial/ark3116.c
@@ -705,7 +705,7 @@ static void ark3116_process_read_urb(struct urb *urb)
 		if (lsr & UART_LSR_OE)
 			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
 	}
-	tty_insert_flip_string_fixed_flag(tty, data, tty_flag,
+	tty_insert_flip_string_fixed_flag(&port->port, data, tty_flag,
 							urb->actual_length);
 	tty_flip_buffer_push(tty);
 	tty_kref_put(tty);
diff --git a/drivers/usb/serial/belkin_sa.c b/drivers/usb/serial/belkin_sa.c
index b72a4c1..a213d1b 100644
--- a/drivers/usb/serial/belkin_sa.c
+++ b/drivers/usb/serial/belkin_sa.c
@@ -279,7 +279,7 @@ static void belkin_sa_process_read_urb(struct urb *urb)
 			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
 	}
 
-	tty_insert_flip_string_fixed_flag(tty, data, tty_flag,
+	tty_insert_flip_string_fixed_flag(&port->port, data, tty_flag,
 							urb->actual_length);
 	tty_flip_buffer_push(tty);
 	tty_kref_put(tty);
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index fd8c35f..ac14e3e 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -1215,7 +1215,7 @@ static void cypress_read_int_callback(struct urb *urb)
 
 	/* process read if there is data other than line status */
 	if (tty && bytes > i) {
-		tty_insert_flip_string_fixed_flag(tty, data + i,
+		tty_insert_flip_string_fixed_flag(&port->port, data + i,
 				tty_flag, bytes - i);
 		tty_flip_buffer_push(tty);
 	}
diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index 45d4af6..efbc403 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -1455,8 +1455,8 @@ static int digi_read_inb_callback(struct urb *urb)
 		/* data length is len-1 (one byte of len is port_status) */
 		--len;
 		if (len > 0) {
-			tty_insert_flip_string_fixed_flag(tty, data, flag,
-									len);
+			tty_insert_flip_string_fixed_flag(&port->port, data,
+					flag, len);
 			tty_flip_buffer_push(tty);
 		}
 	}
diff --git a/drivers/usb/serial/f81232.c b/drivers/usb/serial/f81232.c
index 6e4eb57..a8c6430 100644
--- a/drivers/usb/serial/f81232.c
+++ b/drivers/usb/serial/f81232.c
@@ -140,7 +140,7 @@ static void f81232_process_read_urb(struct urb *urb)
 			if (!usb_serial_handle_sysrq_char(port, data[i]))
 				tty_insert_flip_char(tty, data[i], tty_flag);
 	} else {
-		tty_insert_flip_string_fixed_flag(tty, data, tty_flag,
+		tty_insert_flip_string_fixed_flag(&port->port, data, tty_flag,
 							urb->actual_length);
 	}
 
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 0a373b3..0416d95 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2032,7 +2032,7 @@ static int ftdi_process_packet(struct tty_struct *tty,
 				tty_insert_flip_char(tty, *ch, flag);
 		}
 	} else {
-		tty_insert_flip_string_fixed_flag(tty, ch, flag, len);
+		tty_insert_flip_string_fixed_flag(&port->port, ch, flag, len);
 	}
 
 	return len;
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 6002419..86789b0 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -812,7 +812,7 @@ static void pl2303_process_read_urb(struct urb *urb)
 			if (!usb_serial_handle_sysrq_char(port, data[i]))
 				tty_insert_flip_char(tty, data[i], tty_flag);
 	} else {
-		tty_insert_flip_string_fixed_flag(tty, data, tty_flag,
+		tty_insert_flip_string_fixed_flag(&port->port, data, tty_flag,
 							urb->actual_length);
 	}
 
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index a42536a..fa42f1b 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -505,7 +505,7 @@ static void spcp8x5_process_read_urb(struct urb *urb)
 				   priv->line_status & MSR_STATUS_LINE_DCD);
 	}
 
-	tty_insert_flip_string_fixed_flag(tty, data, tty_flag,
+	tty_insert_flip_string_fixed_flag(&port->port, data, tty_flag,
 							urb->actual_length);
 	tty_flip_buffer_push(tty);
 	tty_kref_put(tty);
diff --git a/drivers/usb/serial/ssu100.c b/drivers/usb/serial/ssu100.c
index 4543ea3..37476c6 100644
--- a/drivers/usb/serial/ssu100.c
+++ b/drivers/usb/serial/ssu100.c
@@ -617,7 +617,7 @@ static int ssu100_process_packet(struct urb *urb,
 				tty_insert_flip_char(tty, *ch, flag);
 		}
 	} else
-		tty_insert_flip_string_fixed_flag(tty, ch, flag, len);
+		tty_insert_flip_string_fixed_flag(&port->port, ch, flag, len);
 
 	return len;
 }
diff --git a/include/linux/tty_flip.h b/include/linux/tty_flip.h
index 78207ca..743f1d0 100644
--- a/include/linux/tty_flip.h
+++ b/include/linux/tty_flip.h
@@ -2,10 +2,14 @@
 #define _LINUX_TTY_FLIP_H
 
 extern int tty_buffer_request_room(struct tty_port *port, size_t size);
-extern int tty_insert_flip_string_flags(struct tty_struct *tty, const unsigned char *chars, const char *flags, size_t size);
-extern int tty_insert_flip_string_fixed_flag(struct tty_struct *tty, const unsigned char *chars, char flag, size_t size);
-extern int tty_prepare_flip_string(struct tty_struct *tty, unsigned char **chars, size_t size);
-extern int tty_prepare_flip_string_flags(struct tty_struct *tty, unsigned char **chars, char **flags, size_t size);
+extern int tty_insert_flip_string_flags(struct tty_port *port,
+		const unsigned char *chars, const char *flags, size_t size);
+extern int tty_insert_flip_string_fixed_flag(struct tty_port *port,
+		const unsigned char *chars, char flag, size_t size);
+extern int tty_prepare_flip_string(struct tty_port *port,
+		unsigned char **chars, size_t size);
+extern int tty_prepare_flip_string_flags(struct tty_port *port,
+		unsigned char **chars, char **flags, size_t size);
 void tty_schedule_flip(struct tty_struct *tty);
 
 static inline int tty_insert_flip_char(struct tty_struct *tty,
@@ -17,12 +21,12 @@ static inline int tty_insert_flip_char(struct tty_struct *tty,
 		tb->char_buf_ptr[tb->used++] = ch;
 		return 1;
 	}
-	return tty_insert_flip_string_flags(tty, &ch, &flag, 1);
+	return tty_insert_flip_string_flags(tty->port, &ch, &flag, 1);
 }
 
 static inline int tty_insert_flip_string(struct tty_struct *tty, const unsigned char *chars, size_t size)
 {
-	return tty_insert_flip_string_fixed_flag(tty, chars, TTY_NORMAL, size);
+	return tty_insert_flip_string_fixed_flag(tty->port, chars, TTY_NORMAL, size);
 }
 
 #endif /* _LINUX_TTY_FLIP_H */
-- 
1.8.1



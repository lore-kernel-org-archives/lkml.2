Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568Ab1C3WJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:09:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:35488 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933161Ab1C3VGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903733774"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: lpechacek@suse.cz, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [12/275] USB: serial: handle Data Carrier Detect changes
Message-Id: <20110330210406.54AAF3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Libor Pechacek <lpechacek@suse.cz>

commit d14fc1a74e846d7851f24fc9519fe87dc12a1231 upstream.

Alan's commit 335f8514f200e63d689113d29cb7253a5c282967 introduced
.carrier_raised function in several drivers.  That also means
tty_port_block_til_ready can now suspend the process trying to open the serial
port when Carrier Detect is low and put it into tty_port.open_wait queue.  We
need to wake up the process when Carrier Detect goes high and trigger TTY
hangup when CD goes low.

Some of the devices do not report modem status line changes, or at least we
don't understand the status message, so for those we remove .carrier_raised
again.

Signed-off-by: Libor Pechacek <lpechacek@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/ch341.c           |   10 ++++++++++
 drivers/usb/serial/cp210x.c          |   11 -----------
 drivers/usb/serial/digi_acceleport.c |   10 ----------
 drivers/usb/serial/generic.c         |   20 ++++++++++++++++++++
 drivers/usb/serial/keyspan_pda.c     |   17 -----------------
 drivers/usb/serial/pl2303.c          |   11 +++++++++++
 drivers/usb/serial/spcp8x5.c         |    5 ++++-
 include/linux/usb/serial.h           |    3 +++
 8 files changed, 48 insertions(+), 39 deletions(-)

Index: linux-2.6.35.y/drivers/usb/serial/ch341.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/ch341.c	2011-03-29 22:52:03.062109567 -0700
+++ linux-2.6.35.y/drivers/usb/serial/ch341.c	2011-03-29 23:54:12.689677728 -0700
@@ -486,12 +486,22 @@
 	if (actual_length >= 4) {
 		struct ch341_private *priv = usb_get_serial_port_data(port);
 		unsigned long flags;
+		u8 prev_line_status = priv->line_status;
 
 		spin_lock_irqsave(&priv->lock, flags);
 		priv->line_status = (~(data[2])) & CH341_BITS_MODEM_STAT;
 		if ((data[1] & CH341_MULT_STAT))
 			priv->multi_status_change = 1;
 		spin_unlock_irqrestore(&priv->lock, flags);
+
+		if ((priv->line_status ^ prev_line_status) & CH341_BIT_DCD) {
+			struct tty_struct *tty = tty_port_tty_get(&port->port);
+			if (tty)
+				usb_serial_handle_dcd_change(port, tty,
+					    priv->line_status & CH341_BIT_DCD);
+			tty_kref_put(tty);
+		}
+
 		wake_up_interruptible(&priv->delta_msr_wait);
 	}
 
Index: linux-2.6.35.y/drivers/usb/serial/cp210x.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/cp210x.c	2011-03-29 22:52:03.062109567 -0700
+++ linux-2.6.35.y/drivers/usb/serial/cp210x.c	2011-03-29 23:55:34.182592529 -0700
@@ -49,7 +49,6 @@
 static void cp210x_break_ctl(struct tty_struct *, int);
 static int cp210x_startup(struct usb_serial *);
 static void cp210x_dtr_rts(struct usb_serial_port *p, int on);
-static int cp210x_carrier_raised(struct usb_serial_port *p);
 
 static int debug;
 
@@ -165,7 +164,6 @@
 	.tiocmset		= cp210x_tiocmset,
 	.attach			= cp210x_startup,
 	.dtr_rts		= cp210x_dtr_rts,
-	.carrier_raised		= cp210x_carrier_raised
 };
 
 /* Config request types */
@@ -764,15 +762,6 @@
 	return result;
 }
 
-static int cp210x_carrier_raised(struct usb_serial_port *p)
-{
-	unsigned int control;
-	cp210x_get_config(p, CP210X_GET_MDMSTS, &control, 1);
-	if (control & CONTROL_DCD)
-		return 1;
-	return 0;
-}
-
 static void cp210x_break_ctl (struct tty_struct *tty, int break_state)
 {
 	struct usb_serial_port *port = tty->driver_data;
Index: linux-2.6.35.y/drivers/usb/serial/digi_acceleport.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/digi_acceleport.c	2011-03-29 22:52:03.063109542 -0700
+++ linux-2.6.35.y/drivers/usb/serial/digi_acceleport.c	2011-03-29 23:02:58.480339055 -0700
@@ -455,7 +455,6 @@
 static int digi_chars_in_buffer(struct tty_struct *tty);
 static int digi_open(struct tty_struct *tty, struct usb_serial_port *port);
 static void digi_close(struct usb_serial_port *port);
-static int digi_carrier_raised(struct usb_serial_port *port);
 static void digi_dtr_rts(struct usb_serial_port *port, int on);
 static int digi_startup_device(struct usb_serial *serial);
 static int digi_startup(struct usb_serial *serial);
@@ -511,7 +510,6 @@
 	.open =				digi_open,
 	.close =			digi_close,
 	.dtr_rts =			digi_dtr_rts,
-	.carrier_raised =		digi_carrier_raised,
 	.write =			digi_write,
 	.write_room =			digi_write_room,
 	.write_bulk_callback = 		digi_write_bulk_callback,
@@ -1337,14 +1335,6 @@
 	digi_set_modem_signals(port, on * (TIOCM_DTR|TIOCM_RTS), 1);
 }
 
-static int digi_carrier_raised(struct usb_serial_port *port)
-{
-	struct digi_port *priv = usb_get_serial_port_data(port);
-	if (priv->dp_modem_signals & TIOCM_CD)
-		return 1;
-	return 0;
-}
-
 static int digi_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
 	int ret;
Index: linux-2.6.35.y/drivers/usb/serial/generic.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/generic.c	2011-03-29 22:52:03.062109567 -0700
+++ linux-2.6.35.y/drivers/usb/serial/generic.c	2011-03-29 23:02:58.482339003 -0700
@@ -481,6 +481,26 @@
 }
 EXPORT_SYMBOL_GPL(usb_serial_handle_break);
 
+/**
+ *	usb_serial_handle_dcd_change - handle a change of carrier detect state
+ *	@port: usb_serial_port structure for the open port
+ *	@tty: tty_struct structure for the port
+ *	@status: new carrier detect status, nonzero if active
+ */
+void usb_serial_handle_dcd_change(struct usb_serial_port *usb_port,
+				struct tty_struct *tty, unsigned int status)
+{
+	struct tty_port *port = &usb_port->port;
+
+	dbg("%s - port %d, status %d", __func__, usb_port->number, status);
+
+	if (status)
+		wake_up_interruptible(&port->open_wait);
+	else if (tty && !C_CLOCAL(tty))
+		tty_hangup(tty);
+}
+EXPORT_SYMBOL_GPL(usb_serial_handle_dcd_change);
+
 int usb_serial_generic_resume(struct usb_serial *serial)
 {
 	struct usb_serial_port *port;
Index: linux-2.6.35.y/drivers/usb/serial/keyspan_pda.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/keyspan_pda.c	2011-03-29 22:52:03.063109542 -0700
+++ linux-2.6.35.y/drivers/usb/serial/keyspan_pda.c	2011-03-29 23:02:58.483338977 -0700
@@ -680,22 +680,6 @@
 	}
 }
 
-static int keyspan_pda_carrier_raised(struct usb_serial_port *port)
-{
-	struct usb_serial *serial = port->serial;
-	unsigned char modembits;
-
-	/* If we can read the modem status and the DCD is low then
-	   carrier is not raised yet */
-	if (keyspan_pda_get_modem_info(serial, &modembits) >= 0) {
-		if (!(modembits & (1>>6)))
-			return 0;
-	}
-	/* Carrier raised, or we failed (eg disconnected) so
-	   progress accordingly */
-	return 1;
-}
-
 
 static int keyspan_pda_open(struct tty_struct *tty,
 					struct usb_serial_port *port)
@@ -882,7 +866,6 @@
 	.id_table =		id_table_std,
 	.num_ports =		1,
 	.dtr_rts =		keyspan_pda_dtr_rts,
-	.carrier_raised	=	keyspan_pda_carrier_raised,
 	.open =			keyspan_pda_open,
 	.close =		keyspan_pda_close,
 	.write =		keyspan_pda_write,
Index: linux-2.6.35.y/drivers/usb/serial/pl2303.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/pl2303.c	2011-03-29 22:52:03.062109567 -0700
+++ linux-2.6.35.y/drivers/usb/serial/pl2303.c	2011-03-29 23:55:15.808062688 -0700
@@ -677,9 +677,11 @@
 {
 
 	struct pl2303_private *priv = usb_get_serial_port_data(port);
+	struct tty_struct *tty;
 	unsigned long flags;
 	u8 status_idx = UART_STATE;
 	u8 length = UART_STATE + 1;
+	u8 prev_line_status;
 	u16 idv, idp;
 
 	idv = le16_to_cpu(port->serial->dev->descriptor.idVendor);
@@ -701,11 +703,20 @@
 
 	/* Save off the uart status for others to look at */
 	spin_lock_irqsave(&priv->lock, flags);
+	prev_line_status = priv->line_status;
 	priv->line_status = data[status_idx];
 	spin_unlock_irqrestore(&priv->lock, flags);
 	if (priv->line_status & UART_BREAK_ERROR)
 		usb_serial_handle_break(port);
 	wake_up_interruptible(&priv->delta_msr_wait);
+
+	tty = tty_port_tty_get(&port->port);
+	if (!tty)
+		return;
+	if ((priv->line_status ^ prev_line_status) & UART_DCD)
+		usb_serial_handle_dcd_change(port, tty,
+				priv->line_status & UART_DCD);
+	tty_kref_put(tty);
 }
 
 static void pl2303_read_int_callback(struct urb *urb)
Index: linux-2.6.35.y/drivers/usb/serial/spcp8x5.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/spcp8x5.c	2011-03-29 22:52:03.063109542 -0700
+++ linux-2.6.35.y/drivers/usb/serial/spcp8x5.c	2011-03-29 23:02:58.486338902 -0700
@@ -133,7 +133,7 @@
 
 /* how come ??? */
 #define UART_STATE			0x08
-#define UART_STATE_TRANSIENT_MASK	0x74
+#define UART_STATE_TRANSIENT_MASK	0x75
 #define UART_DCD			0x01
 #define UART_DSR			0x02
 #define UART_BREAK_ERROR		0x04
@@ -531,6 +531,9 @@
 	tty_insert_flip_string_fixed_flag(tty, data, tty_flag,
 							urb->actual_length);
 	tty_flip_buffer_push(tty);
+	if (status & UART_DCD)
+		usb_serial_handle_dcd_change(port, tty,
+			   priv->line_status & MSR_STATUS_LINE_DCD);
 	tty_kref_put(tty);
 }
 
Index: linux-2.6.35.y/include/linux/usb/serial.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/usb/serial.h	2011-03-29 22:52:03.062109567 -0700
+++ linux-2.6.35.y/include/linux/usb/serial.h	2011-03-29 23:02:58.487338876 -0700
@@ -346,6 +346,9 @@
 					struct usb_serial_port *port,
 					unsigned int ch);
 extern int usb_serial_handle_break(struct usb_serial_port *port);
+extern void usb_serial_handle_dcd_change(struct usb_serial_port *usb_port,
+					 struct tty_struct *tty,
+					 unsigned int status);
 
 
 extern int usb_serial_bus_register(struct usb_serial_driver *device);

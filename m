Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab0LQPe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:34:59 -0500
Received: from cantor.suse.de ([195.135.220.2]:33990 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381Ab0LQPey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:34:54 -0500
Date: Fri, 17 Dec 2010 16:34:23 +0100
From: Libor Pechacek <lpechacek@suse.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: Peter Berger <pberger@brimson.com>,
        Al Borchers <alborchers@steinerpoint.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.36-rc3] USB: serial: handle Data Carrier Detect changes
Message-ID: <20101217153422.GE20400@fm.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18-muttng (2008-05-17-r1399)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan's commit 335f8514f200e63d689113d29cb7253a5c282967 introduced
.carrier_raised function in several drivers.  That also means
tty_port_block_til_ready can now suspend the process trying to open the serial
port when Carrier Detect is low and put it into tty_port.open_wait queue.  We
need to wake up the process when the Carrier Detect goes high.

Signed-off-by: Libor Pechacek <lpechacek@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Peter Berger <pberger@brimson.com>
Cc: Al Borchers <alborchers@steinerpoint.com>
---
Hi Alan,

This is an amendment of your patch referenced above.  Please review and comment
on the changes.

@Greg: There are two drivers left to be fixed - drivers/usb/serial/cp210x.c and
drivers/usb/serial/keyspan_pda.c.  cp210x device does not seem to have an
interrupt endpoint to report the changes so a polling thread seems to be needed
to detect DCD changes.  I can implement the polling for cp210x if you don't
have a better idea.

The keyspan_pda can report the changes asynchronously, but I haven't found the
message format description anywhere.  Any idea how that driver can be fixed
besides dropping .carrier_raised?

 drivers/usb/serial/ch341.c           |    4 ++++
 drivers/usb/serial/digi_acceleport.c |   17 +++++++++++------
 drivers/usb/serial/generic.c         |   20 ++++++++++++++++++++
 drivers/usb/serial/pl2303.c          |    4 ++++
 drivers/usb/serial/spcp8x5.c         |    5 +++++
 include/linux/usb/serial.h           |    2 ++
 6 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 63f7cc4..caa1f8d 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -486,12 +486,16 @@ static void ch341_read_int_callback(struct urb *urb)
 	if (actual_length >= 4) {
 		struct ch341_private *priv = usb_get_serial_port_data(port);
 		unsigned long flags;
+		u8 prev_line_status = priv->line_status;
 
 		spin_lock_irqsave(&priv->lock, flags);
 		priv->line_status = (~(data[2])) & CH341_BITS_MODEM_STAT;
 		if ((data[1] & CH341_MULT_STAT))
 			priv->multi_status_change = 1;
 		spin_unlock_irqrestore(&priv->lock, flags);
+		if ((priv->line_status ^ prev_line_status) & CH341_BIT_DCD)
+			usb_serial_handle_dcd_change(port,
+					priv->line_status & CH341_BIT_DCD);
 		wake_up_interruptible(&priv->delta_msr_wait);
 	}
 
diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index b92070c..396c2c5 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -1738,9 +1738,9 @@ static int digi_read_oob_callback(struct urb *urb)
 	struct usb_serial *serial = port->serial;
 	struct tty_struct *tty;
 	struct digi_port *priv = usb_get_serial_port_data(port);
-	int opcode, line, status, val;
+	int opcode, line, status, val, new_dcd_val;
 	int i;
-	unsigned int rts;
+	unsigned int rts, dcd;
 
 	dbg("digi_read_oob_callback: port=%d, len=%d",
 			priv->dp_port_num, urb->actual_length);
@@ -1794,10 +1794,15 @@ static int digi_read_oob_callback(struct urb *urb)
 				priv->dp_modem_signals |= TIOCM_RI;
 			else
 				priv->dp_modem_signals &= ~TIOCM_RI;
-			if (val & DIGI_READ_INPUT_SIGNALS_DCD)
-				priv->dp_modem_signals |= TIOCM_CD;
-			else
-				priv->dp_modem_signals &= ~TIOCM_CD;
+
+			dcd = priv->dp_modem_signals & TIOCM_CD;
+			new_dcd_val = val & DIGI_READ_INPUT_SIGNALS_DCD;
+			if (!!new_dcd_val != !!dcd) {
+				priv->dp_modem_signals = new_dcd_val ?
+					    priv->dp_modem_signals | TIOCM_CD :
+					    priv->dp_modem_signals & ~TIOCM_CD;
+				usb_serial_handle_dcd_change(port, dcd);
+			}
 
 			wake_up_interruptible(&priv->dp_modem_change_wait);
 			spin_unlock(&priv->dp_port_lock);
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index e6833e2..a877767 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -479,6 +479,26 @@ int usb_serial_handle_break(struct usb_serial_port *port)
 }
 EXPORT_SYMBOL_GPL(usb_serial_handle_break);
 
+/**
+ *	usb_serial_handle_dcd_change - handle a change of carrier detect state
+ *	@port: usb_serial_port structure for the open port
+ *	@status: new carrier detect status, nonzero if active
+ */
+void usb_serial_handle_dcd_change(struct usb_serial_port *usb_port,
+						unsigned int status)
+{
+	struct tty_port *port = &usb_port->port;
+	struct tty_struct *tty = port->tty;
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
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 8ae4c6c..9b4f21b 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -680,6 +680,7 @@ static void pl2303_update_line_status(struct usb_serial_port *port,
 	unsigned long flags;
 	u8 status_idx = UART_STATE;
 	u8 length = UART_STATE + 1;
+	u8 prev_line_status = priv->line_status;
 	u16 idv, idp;
 
 	idv = le16_to_cpu(port->serial->dev->descriptor.idVendor);
@@ -705,6 +706,9 @@ static void pl2303_update_line_status(struct usb_serial_port *port,
 	spin_unlock_irqrestore(&priv->lock, flags);
 	if (priv->line_status & UART_BREAK_ERROR)
 		usb_serial_handle_break(port);
+	if ((priv->line_status ^ prev_line_status) & UART_DCD)
+		usb_serial_handle_dcd_change(port,
+				priv->line_status & UART_DCD);
 	wake_up_interruptible(&priv->delta_msr_wait);
 }
 
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index 765aa98..42bdb6b 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -452,6 +452,7 @@ static int spcp8x5_open(struct tty_struct *tty, struct usb_serial_port *port)
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
 	int ret;
 	unsigned long flags;
+	u8 prev_line_status = priv->line_status;
 	u8 status = 0x30;
 	/* status 0x30 means DSR and CTS = 1 other CDC RI and delta = 0 */
 
@@ -479,6 +480,10 @@ static int spcp8x5_open(struct tty_struct *tty, struct usb_serial_port *port)
 	priv->line_status = status & 0xf0 ;
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	if ((priv->line_status ^ prev_line_status) & MSR_STATUS_LINE_DCD)
+		usb_serial_handle_dcd_change(port,
+				priv->line_status & MSR_STATUS_LINE_DCD);
+
 	port->port.drain_delay = 256;
 
 	return usb_serial_generic_open(tty, port);
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 16d682f..7fe31a9 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -347,6 +347,8 @@ extern int usb_serial_generic_prepare_write_buffer(struct usb_serial_port *port,
 extern int usb_serial_handle_sysrq_char(struct usb_serial_port *port,
 					unsigned int ch);
 extern int usb_serial_handle_break(struct usb_serial_port *port);
+extern void usb_serial_handle_dcd_change(struct usb_serial_port *usb_port,
+					 unsigned int status);
 
 
 extern int usb_serial_bus_register(struct usb_serial_driver *device);
-- 
1.6.0.2


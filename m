Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab2JJNT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:19:26 -0400
Received: from cpsmtp-fia04.kpnxchange.com ([195.121.247.8]:3879 "EHLO
	cpsmtp-fia04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756025Ab2JJNTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:19:22 -0400
X-Greylist: delayed 851 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Oct 2012 09:19:22 EDT
Date: Wed, 10 Oct 2012 15:05:06 +0200
From: Jarkko Huijts <jarkko.huijts@recoresystems.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3.6.1] usb: serial: ftdi_sio: Add missing chars_in_buffer function
Message-ID: <20121010130506.GA5876@cora.recoresystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-OriginalArrivalTime: 10 Oct 2012 13:05:10.0453 (UTC) FILETIME=[E0E76650:01CDA6E7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarkko Huijts <jarkko.huijts@gmail.com>

The driver does not wait until the hardware buffer (for data from the PC to the
UART line) is drained when tcdrain or close is called in an application.
Solution: Implement a chars_in_buffer function that checks both the software
and hardware buffer. If the TEMT (TX empty) bit of the line status register
indicates the hw buffer is not empty, let the function return at least 1. This
has been verified to work correctly with an FT232RL. The check on the hw buffer
can not be done for the original SIO device.

Signed-off-by: Jarkko Huijts <jarkko.huijts@gmail.com>
---
 drivers/usb/serial/ftdi_sio.c |   60 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index b71ee32..0c6a149 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -928,6 +928,7 @@ static int ftdi_get_icount(struct tty_struct *tty,
 static int  ftdi_ioctl(struct tty_struct *tty,
 			unsigned int cmd, unsigned long arg);
 static void ftdi_break_ctl(struct tty_struct *tty, int break_state);
+static int ftdi_chars_in_buffer(struct tty_struct *tty);
 
 static unsigned short int ftdi_232am_baud_base_to_divisor(int baud, int base);
 static unsigned short int ftdi_232am_baud_to_divisor(int baud);
@@ -962,6 +963,7 @@ static struct usb_serial_driver ftdi_sio_device = {
 	.ioctl =		ftdi_ioctl,
 	.set_termios =		ftdi_set_termios,
 	.break_ctl =		ftdi_break_ctl,
+	.chars_in_buffer =      ftdi_chars_in_buffer,
 };
 
 static struct usb_serial_driver * const serial_drivers[] = {
@@ -2095,6 +2097,64 @@ static void ftdi_break_ctl(struct tty_struct *tty, int break_state)
 
 }
 
+static int ftdi_chars_in_buffer(struct tty_struct *tty)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	struct ftdi_private *priv = usb_get_serial_port_data(port);
+	unsigned long flags;
+	int chars;
+	unsigned char *buf;
+	int ret;
+
+	/* Check software buffer (code from
+	 * usb_serial_generic_chars_in_buffer()) */
+	spin_lock_irqsave(&port->lock, flags);
+	chars = kfifo_len(&port->write_fifo) + port->tx_bytes;
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	/* Check hardware buffer */
+	switch (priv->chip_type) {
+	case FT8U232AM:
+	case FT232BM:
+	case FT2232C:
+	case FT232RL:
+	case FT2232H:
+	case FT4232H:
+	case FT232H:
+	case FTX:
+		break;
+	case SIO:
+	default:
+		return chars;
+	}
+
+	buf = kmalloc(2, GFP_KERNEL);
+	if (!buf) {
+		dev_err(&port->dev, "kmalloc failed");
+		return chars;
+	}
+
+	ret = usb_control_msg(port->serial->dev,
+				usb_rcvctrlpipe(port->serial->dev, 0),
+				FTDI_SIO_GET_MODEM_STATUS_REQUEST,
+				FTDI_SIO_GET_MODEM_STATUS_REQUEST_TYPE,
+				0, priv->interface,
+				buf, 2, WDR_TIMEOUT);
+
+	if (ret < 2) {
+		dev_err(&port->dev, "Unable to read modem and line status: "
+			"%i\n", ret);
+		goto chars_in_buffer_out;
+	}
+
+	if (!(buf[1] & FTDI_RS_TEMT))
+		chars++;
+
+chars_in_buffer_out:
+	kfree(buf);
+	return chars;
+}
+
 /* old_termios contains the original termios settings and tty->termios contains
  * the new setting to be used
  * WARNING: set_termios calls this with old_termios in kernel space
-- 
1.7.4.1


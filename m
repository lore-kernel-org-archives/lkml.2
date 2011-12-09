Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab1LIRHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:07:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49427 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab1LIRHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:07:35 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Matthias Fuchs <mfuchs@ma-fu.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH RESEND 2/8] serial: 8250: Add ioctl to enable auto rs485 mode with some Exar UARTs
Date: Fri,  9 Dec 2011 18:07:14 +0100
Message-Id: <1323450440-414-3-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323450440-414-1-git-send-email-w.sang@pengutronix.de>
References: <1323450440-414-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthias Fuchs <mfuchs@ma-fu.de>

Some Exar UARTs support an auto rs485 mode. In this mode
the UART's RTS# pin is activated during transmitting and
can be used to enable a rs485 line driver. This has nothing
to do with attempts to do this by manually asserting/
deasserting handshake lines in software.

Signed-off-by: Matthias Fuchs <mfuchs@ma-fu.de>

[wsa] Replaced 0xbf with define, saved some line-breaks.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/tty/serial/8250.c  |   68 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/serial_reg.h |    1 +
 2 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index f8f2320..920b4df 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -38,6 +38,7 @@
 #include <linux/nmi.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/uaccess.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -2698,6 +2699,72 @@ serial8250_type(struct uart_port *port)
 	return uart_config[type].name;
 }
 
+static int serial8250_ioctl_port(struct uart_port *port,
+		      unsigned int cmd, unsigned long arg)
+{
+	struct uart_8250_port *up = (struct uart_8250_port *)port;
+	unsigned long flags;
+
+	switch (cmd) {
+	case TIOCSRS485:
+	{
+		struct serial_rs485 rs485ctrl;
+		unsigned char fctr, lcr;
+
+		if (port->type != PORT_16850)
+			return -ENOTTY;
+
+		if (copy_from_user(&rs485ctrl, (struct serial_rs485 *)arg,
+				   sizeof(rs485ctrl)))
+			return -EFAULT;
+
+		spin_lock_irqsave(&up->port.lock, flags);
+		lcr = serial_inp(up, UART_LCR);
+		serial_outp(up, UART_LCR, UART_LCR_CONF_MODE_B);
+		fctr = serial_inp(up, UART_FCTR);
+		if (rs485ctrl.flags & SER_RS485_ENABLED)
+			fctr |= UART_FCTR_RS485;
+		else
+			fctr &= ~UART_FCTR_RS485;
+		serial_outp(up, UART_FCTR, fctr);
+		serial_outp(up, UART_LCR, lcr);
+		spin_unlock_irqrestore(&up->port.lock, flags);
+		return 0;
+	}
+
+	case TIOCGRS485:
+	{
+		struct serial_rs485 rs485ctrl;
+		unsigned char lcr;
+
+		if (port->type != PORT_16850)
+			return -ENOTTY;
+
+		memset(&rs485ctrl, 0, sizeof(rs485ctrl));
+
+		spin_lock_irqsave(&up->port.lock, flags);
+		lcr = serial_inp(up, UART_LCR);
+		serial_outp(up, UART_LCR, UART_LCR_CONF_MODE_B);
+		if (serial_inp(up, UART_FCTR) & UART_FCTR_RS485)
+			rs485ctrl.flags = SER_RS485_ENABLED;
+		else
+			rs485ctrl.flags = 0;
+		serial_outp(up, UART_LCR, lcr);
+		spin_unlock_irqrestore(&up->port.lock, flags);
+
+		if (copy_to_user((struct serial_rs485 *)arg, &rs485ctrl,
+				 sizeof(rs485ctrl)))
+			return -EFAULT;
+		return 0;
+	}
+
+	default:
+		return -ENOIOCTLCMD;
+	}
+
+	return 0;
+}
+
 static struct uart_ops serial8250_pops = {
 	.tx_empty	= serial8250_tx_empty,
 	.set_mctrl	= serial8250_set_mctrl,
@@ -2717,6 +2784,7 @@ static struct uart_ops serial8250_pops = {
 	.request_port	= serial8250_request_port,
 	.config_port	= serial8250_config_port,
 	.verify_port	= serial8250_verify_port,
+	.ioctl		= serial8250_ioctl_port,
 #ifdef CONFIG_CONSOLE_POLL
 	.poll_get_char = serial8250_get_poll_char,
 	.poll_put_char = serial8250_put_poll_char,
diff --git a/include/linux/serial_reg.h b/include/linux/serial_reg.h
index 8ce70d7..fb37c4f 100644
--- a/include/linux/serial_reg.h
+++ b/include/linux/serial_reg.h
@@ -201,6 +201,7 @@
 #define UART_FCTR_RTS_8DELAY	0x03
 #define UART_FCTR_IRDA		0x04  /* IrDa data encode select */
 #define UART_FCTR_TX_INT	0x08  /* Tx interrupt type select */
+#define UART_FCTR_RS485		0x08  /* Auto RS485 mode */
 #define UART_FCTR_TRGA		0x00  /* Tx/Rx 550 trigger table select */
 #define UART_FCTR_TRGB		0x10  /* Tx/Rx 650 trigger table select */
 #define UART_FCTR_TRGC		0x20  /* Tx/Rx 654 trigger table select */
-- 
1.7.7.3


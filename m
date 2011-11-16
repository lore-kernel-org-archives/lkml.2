Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab1KPQZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:25:00 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32992 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204Ab1KPQY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:24:58 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Juergen Beisert <jbe@pengutronix.de>, Matthias Fuchs <mfuchs@ma-fu.de>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 3/8] serial: 8250: save rs485_flags per instance
Date: Wed, 16 Nov 2011 17:24:40 +0100
Message-Id: <1321460685-15753-4-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321460685-15753-1-git-send-email-w.sang@pengutronix.de>
References: <1321460685-15753-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids mangling with registers when reading the RS485 status via IOCTL.
Also, features can check their configuration at runtime which will be needed
for a later patch.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/tty/serial/8250.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index 920b4df..b5d3248 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -154,6 +154,7 @@ struct uart_8250_port {
 	unsigned char		lsr_saved_flags;
 #define MSR_SAVE_FLAGS UART_MSR_ANY_DELTA
 	unsigned char		msr_saved_flags;
+	__u32			rs485_flags;	/* copied from IOCTL */
 };
 
 struct irq_info {
@@ -2729,28 +2730,21 @@ static int serial8250_ioctl_port(struct uart_port *port,
 		serial_outp(up, UART_FCTR, fctr);
 		serial_outp(up, UART_LCR, lcr);
 		spin_unlock_irqrestore(&up->port.lock, flags);
+
+		up->rs485_flags = rs485ctrl.flags;
+
 		return 0;
 	}
 
 	case TIOCGRS485:
 	{
 		struct serial_rs485 rs485ctrl;
-		unsigned char lcr;
 
 		if (port->type != PORT_16850)
 			return -ENOTTY;
 
 		memset(&rs485ctrl, 0, sizeof(rs485ctrl));
-
-		spin_lock_irqsave(&up->port.lock, flags);
-		lcr = serial_inp(up, UART_LCR);
-		serial_outp(up, UART_LCR, UART_LCR_CONF_MODE_B);
-		if (serial_inp(up, UART_FCTR) & UART_FCTR_RS485)
-			rs485ctrl.flags = SER_RS485_ENABLED;
-		else
-			rs485ctrl.flags = 0;
-		serial_outp(up, UART_LCR, lcr);
-		spin_unlock_irqrestore(&up->port.lock, flags);
+		rs485ctrl.flags = up->rs485_flags;
 
 		if (copy_to_user((struct serial_rs485 *)arg, &rs485ctrl,
 				 sizeof(rs485ctrl)))
-- 
1.7.7.1


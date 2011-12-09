Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab1LIRIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:08:46 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49440 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab1LIRHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:07:35 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Juergen Beisert <jbe@pengutronix.de>
Subject: [PATCH RESEND 4/8] serial: 8250: add RX_DURING_TX capability to RS485 mode
Date: Fri,  9 Dec 2011 18:07:16 +0100
Message-Id: <1323450440-414-5-git-send-email-w.sang@pengutronix.de>
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

To prevent echo in some configurations, make sure we do not read back
when we are sending if RS485 is configured this way. We need to shuffle
stop_rx() around, implement start_rx() and call it in apropriate places.

Signed-off-by: Juergen Beisert <jbe@pengutronix.de>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/tty/serial/8250.c |   34 +++++++++++++++++++++++++---------
 1 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index b5d3248..6a2f47f 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -1304,6 +1304,26 @@ static void autoconfig_irq(struct uart_8250_port *up)
 	up->port.irq = (irq > 0) ? irq : 0;
 }
 
+static void serial8250_stop_rx(struct uart_port *port)
+{
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
+
+	up->ier &= ~UART_IER_RLSI;
+	up->port.read_status_mask &= ~UART_LSR_DR;
+	serial_out(up, UART_IER, up->ier);
+}
+
+static void serial8250_start_rx(struct uart_port *port)
+{
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
+
+	up->ier |= UART_IER_RLSI;
+	up->port.read_status_mask |= UART_LSR_DR;
+	serial_out(up, UART_IER, up->ier);
+}
+
 static inline void __stop_tx(struct uart_8250_port *p)
 {
 	if (p->ier & UART_IER_THRI) {
@@ -1326,6 +1346,9 @@ static void serial8250_stop_tx(struct uart_port *port)
 		up->acr |= UART_ACR_TXDIS;
 		serial_icr_write(up, UART_ACR, up->acr);
 	}
+
+	if (!(up->rs485_flags & SER_RS485_RX_DURING_TX))
+		serial8250_start_rx(port);
 }
 
 static void transmit_chars(struct uart_8250_port *up);
@@ -1357,16 +1380,9 @@ static void serial8250_start_tx(struct uart_port *port)
 		up->acr &= ~UART_ACR_TXDIS;
 		serial_icr_write(up, UART_ACR, up->acr);
 	}
-}
 
-static void serial8250_stop_rx(struct uart_port *port)
-{
-	struct uart_8250_port *up =
-		container_of(port, struct uart_8250_port, port);
-
-	up->ier &= ~UART_IER_RLSI;
-	up->port.read_status_mask &= ~UART_LSR_DR;
-	serial_out(up, UART_IER, up->ier);
+	if (!(up->rs485_flags & SER_RS485_RX_DURING_TX))
+		serial8250_stop_rx(port);
 }
 
 static void serial8250_enable_ms(struct uart_port *port)
-- 
1.7.7.3


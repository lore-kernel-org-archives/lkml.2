Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab2IRTVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 15:21:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011Ab2IRTVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 15:21:41 -0400
From: Flavio Leitner <fbl@redhat.com>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Flavio Leitner <fbl@redhat.com>
Subject: [PATCH] 8250: fix autoconfig to work with serial console
Date: Tue, 18 Sep 2012 16:21:32 -0300
Message-Id: <1347996092-30957-1-git-send-email-fbl@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The autoconfig prints messages while holding the
port's spinlock and that causes a deadlock when
using serial console.

Signed-off-by: Flavio Leitner <fbl@redhat.com>
---
 drivers/tty/serial/8250/8250.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index 8123f78..17e0c3f 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -1037,6 +1037,7 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 	unsigned char save_lcr, save_mcr;
 	struct uart_port *port = &up->port;
 	unsigned long flags;
+	unsigned int old_capabilities;
 
 	if (!port->iobase && !port->mapbase && !port->membase)
 		return;
@@ -1087,6 +1088,7 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 			/*
 			 * We failed; there's nothing here
 			 */
+			spin_unlock_irqrestore(&port->lock, flags);
 			DEBUG_AUTOCONF("IER test failed (%02x, %02x) ",
 				       scratch2, scratch3);
 			goto out;
@@ -1110,6 +1112,7 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 		status1 = serial_in(up, UART_MSR) & 0xF0;
 		serial_out(up, UART_MCR, save_mcr);
 		if (status1 != 0x90) {
+			spin_unlock_irqrestore(&port->lock, flags);
 			DEBUG_AUTOCONF("LOOP test failed (%02x) ",
 				       status1);
 			goto out;
@@ -1132,8 +1135,6 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 	serial_out(up, UART_FCR, UART_FCR_ENABLE_FIFO);
 	scratch = serial_in(up, UART_IIR) >> 6;
 
-	DEBUG_AUTOCONF("iir=%d ", scratch);
-
 	switch (scratch) {
 	case 0:
 		autoconfig_8250(up);
@@ -1167,19 +1168,13 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 
 	serial_out(up, UART_LCR, save_lcr);
 
-	if (up->capabilities != uart_config[port->type].flags) {
-		printk(KERN_WARNING
-		       "ttyS%d: detected caps %08x should be %08x\n",
-		       serial_index(port), up->capabilities,
-		       uart_config[port->type].flags);
-	}
-
 	port->fifosize = uart_config[up->port.type].fifo_size;
+	old_capabilities = up->capabilities; 
 	up->capabilities = uart_config[port->type].flags;
 	up->tx_loadsz = uart_config[port->type].tx_loadsz;
 
 	if (port->type == PORT_UNKNOWN)
-		goto out;
+		goto out_lock;
 
 	/*
 	 * Reset the UART.
@@ -1196,8 +1191,16 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 	else
 		serial_out(up, UART_IER, 0);
 
- out:
+out_lock:
 	spin_unlock_irqrestore(&port->lock, flags);
+	if (up->capabilities != old_capabilities) {
+		printk(KERN_WARNING
+		       "ttyS%d: detected caps %08x should be %08x\n",
+		       serial_index(port), old_capabilities,
+		       up->capabilities);
+	}
+out:
+	DEBUG_AUTOCONF("iir=%d ", scratch);
 	DEBUG_AUTOCONF("type=%s\n", uart_config[port->type].name);
 }
 
-- 
1.7.11.4


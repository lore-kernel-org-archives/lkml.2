Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab0I1Nfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 09:35:32 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47083 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab0I1Nfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:35:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=puQiWMEgEmebcJXKgvWgV0joQWxJhNxkFa3fUYc05S3gdsxnFdAujzGJ2xV8SKeRmP
         GjMBJuRqKikitJsJcq0qVgPNQGhBEcwDzKV3ZNBxx5uz8apACkjBn2iK1xBBh17O0QqT
         YEJSIuYG/fsSprDXeP/iyVmPFALOw/9oR3tWQ=
Date: Tue, 28 Sep 2010 17:35:26 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Tobias Klauser <tklauser@distanz.ch>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] altera_uart: Add support for polling mode (IRQ-less)
Message-ID: <20100928133526.GB8289@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Altera UART implementations doesn't route the IRQ line, so we have
to work in polling mode.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 drivers/serial/altera_uart.c |   38 +++++++++++++++++++++++++++++---------
 1 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/serial/altera_uart.c b/drivers/serial/altera_uart.c
index f8d8a00..2603f59 100644
--- a/drivers/serial/altera_uart.c
+++ b/drivers/serial/altera_uart.c
@@ -15,6 +15,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/timer.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/console.h>
@@ -76,6 +77,7 @@
  */
 struct altera_uart {
 	struct uart_port port;
+	struct timer_list tmr;
 	unsigned int sigs;	/* Local copy of line sigs */
 	unsigned short imr;	/* Local IMR mirror */
 };
@@ -168,6 +170,7 @@ static void altera_uart_set_termios(struct uart_port *port,
 	tty_termios_encode_baud_rate(termios, baud, baud);
 
 	spin_lock_irqsave(&port->lock, flags);
+	uart_update_timeout(port, termios->c_cflag, baud);
 	writel(baudclk, port->membase + ALTERA_UART_DIVISOR_REG);
 	spin_unlock_irqrestore(&port->lock, flags);
 }
@@ -268,6 +271,15 @@ static irqreturn_t altera_uart_interrupt(int irq, void *data)
 	return IRQ_RETVAL(isr);
 }
 
+static void altera_uart_timer(unsigned long data)
+{
+	struct uart_port *port = (void *)data;
+	struct altera_uart *pp = container_of(port, struct altera_uart, port);
+
+	altera_uart_interrupt(0, port);
+	mod_timer(&pp->tmr, jiffies + uart_poll_timeout(port));
+}
+
 static void altera_uart_config_port(struct uart_port *port, int flags)
 {
 	port->type = PORT_ALTERA_UART;
@@ -284,14 +296,6 @@ static int altera_uart_startup(struct uart_port *port)
 	unsigned long flags;
 	int ret;
 
-	ret = request_irq(port->irq, altera_uart_interrupt, IRQF_DISABLED,
-			DRV_NAME, port);
-	if (ret) {
-		pr_err(DRV_NAME ": unable to attach Altera UART %d "
-		       "interrupt vector=%d\n", port->line, port->irq);
-		return ret;
-	}
-
 	spin_lock_irqsave(&port->lock, flags);
 
 	/* Enable RX interrupts now */
@@ -300,6 +304,19 @@ static int altera_uart_startup(struct uart_port *port)
 
 	spin_unlock_irqrestore(&port->lock, flags);
 
+	if (port->irq) {
+		ret = request_irq(port->irq, altera_uart_interrupt,
+				  IRQF_DISABLED, DRV_NAME, port);
+		if (ret) {
+			pr_err(DRV_NAME ": unable to attach Altera UART %d "
+			       "interrupt vector=%d\n", port->line, port->irq);
+			return ret;
+		}
+	} else {
+		setup_timer(&pp->tmr, altera_uart_timer, (unsigned long)port);
+		mod_timer(&pp->tmr, jiffies + uart_poll_timeout(port));
+	}
+
 	return 0;
 }
 
@@ -316,7 +333,10 @@ static void altera_uart_shutdown(struct uart_port *port)
 
 	spin_unlock_irqrestore(&port->lock, flags);
 
-	free_irq(port->irq, port);
+	if (port->irq)
+		free_irq(port->irq, port);
+	else
+		del_timer_sync(&pp->tmr);
 }
 
 static const char *altera_uart_type(struct uart_port *port)
-- 
1.7.0.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab0I1Nfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 09:35:38 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50315 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab0I1Nfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:35:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=YtRiSGkVMDICSjhPvX7KxlX/U1FBan42XUMAmZIJq8R37nc5raqCnORLlQFBPNfGdx
         KhsGSjX9KTPV4e6XINN5HSCimIAaMwEcFLugYzEJzcbyhwOUdF4PX+npzMwCwgKJSAh6
         V2WPg9tUMGNQKkTaD5+CuL4YLd3dpOO9r0n7c=
Date: Tue, 28 Sep 2010 17:35:31 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Tobias Klauser <tklauser@distanz.ch>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] altera_uart: Add support for getting mapbase and IRQ
 from resources
Message-ID: <20100928133531.GC8289@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it much easier to integrate the driver with the rest of
the Linux (e.g. MFD subsystem).

The old method is still supported though.

Also, from now on, there is one platform device per port (no
changes are needed for the platform code, as no one registers
the devices anywhere in-tree yet).

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 drivers/serial/altera_uart.c |   57 +++++++++++++++++++++++++----------------
 1 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/drivers/serial/altera_uart.c b/drivers/serial/altera_uart.c
index 2603f59..7686aaa 100644
--- a/drivers/serial/altera_uart.c
+++ b/drivers/serial/altera_uart.c
@@ -497,38 +497,51 @@ static int __devinit altera_uart_probe(struct platform_device *pdev)
 {
 	struct altera_uart_platform_uart *platp = pdev->dev.platform_data;
 	struct uart_port *port;
-	int i;
+	struct resource *res_mem;
+	struct resource *res_irq;
+	int i = pdev->id;
 
-	for (i = 0; i < CONFIG_SERIAL_ALTERA_UART_MAXPORTS && platp[i].mapbase; i++) {
-		port = &altera_uart_ports[i].port;
+	/* -1 emphasizes that the platform must have one port, no .N suffix */
+	if (i == -1)
+		i = 0;
 
-		port->line = i;
-		port->type = PORT_ALTERA_UART;
-		port->mapbase = platp[i].mapbase;
-		port->membase = ioremap(port->mapbase, ALTERA_UART_SIZE);
-		port->iotype = SERIAL_IO_MEM;
-		port->irq = platp[i].irq;
-		port->uartclk = platp[i].uartclk;
-		port->ops = &altera_uart_ops;
-		port->flags = ASYNC_BOOT_AUTOCONF;
+	if (i >= CONFIG_SERIAL_ALTERA_UART_MAXPORTS)
+		return -EINVAL;
 
-		uart_add_one_port(&altera_uart_driver, port);
-	}
+	port = &altera_uart_ports[i].port;
+
+	res_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res_mem)
+		port->mapbase = res_mem->start;
+	else if (platp->mapbase)
+		port->mapbase = platp->mapbase;
+	else
+		return -EINVAL;
+
+	res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (res_irq)
+		port->irq = res_irq->start;
+	else if (platp->irq)
+		port->irq = platp->irq;
+
+	port->line = i;
+	port->type = PORT_ALTERA_UART;
+	port->membase = ioremap(port->mapbase, ALTERA_UART_SIZE);
+	port->iotype = SERIAL_IO_MEM;
+	port->uartclk = platp->uartclk;
+	port->ops = &altera_uart_ops;
+	port->flags = ASYNC_BOOT_AUTOCONF;
+
+	uart_add_one_port(&altera_uart_driver, port);
 
 	return 0;
 }
 
 static int __devexit altera_uart_remove(struct platform_device *pdev)
 {
-	struct uart_port *port;
-	int i;
-
-	for (i = 0; i < CONFIG_SERIAL_ALTERA_UART_MAXPORTS; i++) {
-		port = &altera_uart_ports[i].port;
-		if (port)
-			uart_remove_one_port(&altera_uart_driver, port);
-	}
+	struct uart_port *port = &altera_uart_ports[pdev->id].port;
 
+	uart_remove_one_port(&altera_uart_driver, port);
 	return 0;
 }
 
-- 
1.7.0.5


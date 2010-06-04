Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab0FDUtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 16:49:52 -0400
Received: from kroah.org ([198.145.64.141]:44030 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171Ab0FDUsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 16:48:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tobias Klauser <tklauser@distanz.ch>, Thomas Chou <thomas@wytron.com.tw>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/11] altera_uart: Simplify altera_uart_console_putc
Date: Fri,  4 Jun 2010 13:47:53 -0700
Message-Id: <1275684477-20172-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100604204445.GB19761@kroah.com>
References: <20100604204445.GB19761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tobias Klauser <tklauser@distanz.ch>

The check for the TRDY flag after writing the character is not needed.
Also do a cpu_relax() inside the loop.

Pass a struct uart_port to altera_uart_console_putc, so we do not need
to get it (and dereference pointers) for every character.

Cc: Thomas Chou <thomas@wytron.com.tw>
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/altera_uart.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/serial/altera_uart.c b/drivers/serial/altera_uart.c
index b1609cc..7d6afc9 100644
--- a/drivers/serial/altera_uart.c
+++ b/drivers/serial/altera_uart.c
@@ -391,31 +391,24 @@ int __init early_altera_uart_setup(struct altera_uart_platform_uart *platp)
 	return 0;
 }
 
-static void altera_uart_console_putc(struct console *co, const char c)
+static void altera_uart_console_putc(struct uart_port *port, const char c)
 {
-	struct uart_port *port = &(altera_uart_ports + co->index)->port;
-	int i;
+	while (!(readl(port->membase + ALTERA_UART_STATUS_REG) &
+	         ALTERA_UART_STATUS_TRDY_MSK))
+		cpu_relax();
 
-	for (i = 0; i < 0x10000; i++) {
-		if (readl(port->membase + ALTERA_UART_STATUS_REG) &
-		    ALTERA_UART_STATUS_TRDY_MSK)
-			break;
-	}
 	writel(c, port->membase + ALTERA_UART_TXDATA_REG);
-	for (i = 0; i < 0x10000; i++) {
-		if (readl(port->membase + ALTERA_UART_STATUS_REG) &
-		    ALTERA_UART_STATUS_TRDY_MSK)
-			break;
-	}
 }
 
 static void altera_uart_console_write(struct console *co, const char *s,
 				      unsigned int count)
 {
+	struct uart_port *port = &(altera_uart_ports + co->index)->port;
+
 	for (; count; count--, s++) {
-		altera_uart_console_putc(co, *s);
+		altera_uart_console_putc(port, *s);
 		if (*s == '\n')
-			altera_uart_console_putc(co, '\r');
+			altera_uart_console_putc(port, '\r');
 	}
 }
 
-- 
1.7.1


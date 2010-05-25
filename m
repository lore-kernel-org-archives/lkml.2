Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab0EYPAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:00:17 -0400
Received: from mx1.zhaw.ch ([160.85.104.50]:49496 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932338Ab0EYPAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:00:13 -0400
From: Tobias Klauser <tklauser@distanz.ch>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Tobias Klauser <tklauser@distanz.ch>,
       Thomas Chou <thomas@wytron.com.tw>
Subject: [PATCH 2/2] altera_uart: Simplify altera_uart_console_putc
Date: Tue, 25 May 2010 17:00:08 +0200
Message-Id: <1274799608-4200-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.6.3.3
X-PMX-Version: 5.5.9.395186, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.5.25.145116
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1800_1899 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, TO_NO_NAME 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check for the TRDY flag after writing the character is not needed.
Also do a cpu_relax() inside the loop.

Pass a struct uart_port to altera_uart_console_putc, so we do not need
to get it (and dereference pointers) for every character.

Cc: Thomas Chou <thomas@wytron.com.tw>
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
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
1.6.3.3


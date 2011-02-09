Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab1BIJ5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 04:57:08 -0500
Received: from mx1.zhaw.ch ([160.85.104.50]:64711 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab1BIJ5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 04:57:05 -0500
From: Tobias Klauser <tklauser@distanz.ch>
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org
Cc: nios2-dev@sopc.et.ntust.edu.tw, linux-kernel@vger.kernel.org,
        Anton Vorontsov <cbouatmailru@gmail.com>
Subject: [PATCH 2/4] tty: serial: altera_uart: Use port->regshift to store bus shift
Date: Wed,  9 Feb 2011 10:57:04 +0100
Message-Id: <6ced1dcb96fc56fcdc8fb0daab898a773a7a320c.1297245277.git.tklauser@distanz.ch>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1297245277.git.tklauser@distanz.ch>
References: <cover.1297245277.git.tklauser@distanz.ch>
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.2.9.94515
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1800_1899 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __FRAUD_BODY_WEBMAIL 0, __FRAUD_WEBMAIL 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the regshift member of struct uart_port to store the address stride
from platform data. This way we can save one dereference per call of
altera_uart_readl and altera_uart_writel.

This also allows us to use the driver without platform data, which is
needed for device tree support in the Nios2 port.

Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/tty/serial/altera_uart.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/altera_uart.c b/drivers/tty/serial/altera_uart.c
index dee7a0e..3a57352 100644
--- a/drivers/tty/serial/altera_uart.c
+++ b/drivers/tty/serial/altera_uart.c
@@ -86,16 +86,12 @@ struct altera_uart {
 
 static u32 altera_uart_readl(struct uart_port *port, int reg)
 {
-	struct altera_uart_platform_uart *platp = port->private_data;
-
-	return readl(port->membase + (reg << platp->bus_shift));
+	return readl(port->membase + (reg << port->regshift));
 }
 
 static void altera_uart_writel(struct uart_port *port, u32 dat, int reg)
 {
-	struct altera_uart_platform_uart *platp = port->private_data;
-
-	writel(dat, port->membase + (reg << platp->bus_shift));
+	writel(dat, port->membase + (reg << port->regshift));
 }
 
 static unsigned int altera_uart_tx_empty(struct uart_port *port)
@@ -546,13 +542,17 @@ static int __devinit altera_uart_probe(struct platform_device *pdev)
 	if (!port->membase)
 		return -ENOMEM;
 
+	if (platp)
+		port->regshift = platp->bus_shift;
+	else
+		port->regshift = 0;
+
 	port->line = i;
 	port->type = PORT_ALTERA_UART;
 	port->iotype = SERIAL_IO_MEM;
 	port->uartclk = platp->uartclk;
 	port->ops = &altera_uart_ops;
 	port->flags = UPF_BOOT_AUTOCONF;
-	port->private_data = platp;
 
 	uart_add_one_port(&altera_uart_driver, port);
 
-- 
1.7.0.4


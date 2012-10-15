Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab2JOUNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:13:24 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:42319 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab2JOUNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:13:22 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Philip Blundell <philb@gnu.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] serial/8250_hp300: Missing 8250 register interface conversion bits
Date: Mon, 15 Oct 2012 22:13:12 +0200
Message-Id: <1350331992-15119-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 2655a2c76f80d91da34faa8f4e114d1793435ed3 ("8250: use the 8250
register interface not the legacy one") forgot to fully switch one
instance of struct uart_port to struct uart_8250_port, causing the
following compile failure:

drivers/tty/serial/8250/8250_hp300.c: In function ‘hpdca_init_one’:
drivers/tty/serial/8250/8250_hp300.c:174: error: ‘uart’ undeclared (first use in this function)
drivers/tty/serial/8250/8250_hp300.c:174: error: (Each undeclared identifier is reported only once
drivers/tty/serial/8250/8250_hp300.c:174: error: for each function it appears in.)

This went unnoticed in -next, as CONFIG_HPDCA is not set to y by
allmodconfig.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Only compile-tested, due to lack of hardware

 drivers/tty/serial/8250/8250_hp300.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_hp300.c b/drivers/tty/serial/8250/8250_hp300.c
index 8f1dd2c..f3d0edf 100644
--- a/drivers/tty/serial/8250/8250_hp300.c
+++ b/drivers/tty/serial/8250/8250_hp300.c
@@ -162,7 +162,7 @@ int __init hp300_setup_serial_console(void)
 static int __devinit hpdca_init_one(struct dio_dev *d,
 				const struct dio_device_id *ent)
 {
-	struct uart_port port;
+	struct uart_8250_port uart;
 	int line;
 
 #ifdef CONFIG_SERIAL_8250_CONSOLE
@@ -174,19 +174,19 @@ static int __devinit hpdca_init_one(struct dio_dev *d,
 	memset(&uart, 0, sizeof(uart));
 
 	/* Memory mapped I/O */
-	port.iotype = UPIO_MEM;
-	port.flags = UPF_SKIP_TEST | UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF;
-	port.irq = d->ipl;
-	port.uartclk = HPDCA_BAUD_BASE * 16;
-	port.mapbase = (d->resource.start + UART_OFFSET);
-	port.membase = (char *)(port.mapbase + DIO_VIRADDRBASE);
-	port.regshift = 1;
-	port.dev = &d->dev;
+	uart.port.iotype = UPIO_MEM;
+	uart.port.flags = UPF_SKIP_TEST | UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF;
+	uart.port.irq = d->ipl;
+	uart.port.uartclk = HPDCA_BAUD_BASE * 16;
+	uart.port.mapbase = (d->resource.start + UART_OFFSET);
+	uart.port.membase = (char *)(uart.port.mapbase + DIO_VIRADDRBASE);
+	uart.port.regshift = 1;
+	uart.port.dev = &d->dev;
 	line = serial8250_register_8250_port(&uart);
 
 	if (line < 0) {
 		printk(KERN_NOTICE "8250_hp300: register_serial() DCA scode %d"
-		       " irq %d failed\n", d->scode, port.irq);
+		       " irq %d failed\n", d->scode, uart.port.irq);
 		return -ENOMEM;
 	}
 
-- 
1.7.0.4


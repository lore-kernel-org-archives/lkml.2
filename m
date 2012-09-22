Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab2IVGXB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 02:23:01 -0400
Received: from mail-we0-f202.google.com ([74.125.82.202]:39043 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab2IVGW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 02:22:58 -0400
From: Doug Anderson <dianders@chromium.org>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Julien Pichon <pichon.jln@gmail.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kgene.kim@samsung.com,
        GNUtoo@no-log.org, heiko@sntech.de, ben-linux@fluff.org,
        Doug Anderson <dianders@chromium.org>
Subject: [PATCH] serial: samsung: Add poll_get_char & poll_put_char
Date: Fri, 21 Sep 2012 23:22:31 -0700
Message-Id: <1348294951-28617-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <20120212182201.GA17975@debian>
References: <20120212182201.GA17975@debian>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julien Pichon <pichon.jln@gmail.com>

The following patch allows users to use KGDB over serial console on
board based on Samsung SOC. It has been tested on a board using
exynos5.

Signed-off-by: Julien Pichon <pichon.jln@gmail.com>
Signed-off-by: Doug Anderson <dianders@chromium.org>
(dianders changed poll to return NO_POLL_CHAR, which appears to
fix 'help' in kgdb; also updated commit message)
---
This is pulled from an email on <linux-samsung-soc@vger.kernel.org>
from Feb 18, 2012. It's never landed anywhere. I've made a small modification
that make it so that kgdb's "help" doesn't crash.

See: http://comments.gmane.org/gmane.linux.kernel.samsung-soc/9477

 drivers/tty/serial/samsung.c |   47 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 8eef114..7f04717 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -876,11 +876,24 @@ s3c24xx_serial_verify_port(struct uart_port *port, struct serial_struct *ser)
 
 static struct console s3c24xx_serial_console;
 
+static int __init s3c24xx_serial_console_init(void)
+{
+	register_console(&s3c24xx_serial_console);
+	return 0;
+}
+console_initcall(s3c24xx_serial_console_init);
+
 #define S3C24XX_SERIAL_CONSOLE &s3c24xx_serial_console
 #else
 #define S3C24XX_SERIAL_CONSOLE NULL
 #endif
 
+#ifdef CONFIG_CONSOLE_POLL
+static int s3c24xx_serial_get_poll_char(struct uart_port *port);
+static void s3c24xx_serial_put_poll_char(struct uart_port *port,
+			 unsigned char c);
+#endif
+
 static struct uart_ops s3c24xx_serial_ops = {
 	.pm		= s3c24xx_serial_pm,
 	.tx_empty	= s3c24xx_serial_tx_empty,
@@ -899,6 +912,10 @@ static struct uart_ops s3c24xx_serial_ops = {
 	.request_port	= s3c24xx_serial_request_port,
 	.config_port	= s3c24xx_serial_config_port,
 	.verify_port	= s3c24xx_serial_verify_port,
+#ifdef CONFIG_CONSOLE_POLL
+	.poll_get_char = s3c24xx_serial_get_poll_char,
+	.poll_put_char = s3c24xx_serial_put_poll_char,
+#endif
 };
 
 static struct uart_driver s3c24xx_uart_drv = {
@@ -1316,6 +1333,36 @@ s3c24xx_serial_console_txrdy(struct uart_port *port, unsigned int ufcon)
 	return (utrstat & S3C2410_UTRSTAT_TXE) ? 1 : 0;
 }
 
+#ifdef CONFIG_CONSOLE_POLL
+/*
+ * Console polling routines for writing and reading from the uart while
+ * in an interrupt or debug context.
+ */
+
+static int s3c24xx_serial_get_poll_char(struct uart_port *port)
+{
+	struct s3c24xx_uart_port *ourport = to_ourport(port);
+	unsigned int ufstat;
+
+	ufstat = rd_regl(port, S3C2410_UFSTAT);
+	if (s3c24xx_serial_rx_fifocnt(ourport, ufstat) == 0)
+		return NO_POLL_CHAR;
+
+	return rd_regb(port, S3C2410_URXH);
+}
+
+static void s3c24xx_serial_put_poll_char(struct uart_port *port,
+		unsigned char c)
+{
+	unsigned int ufcon = rd_regl(cons_uart, S3C2410_UFCON);
+
+	while (!s3c24xx_serial_console_txrdy(port, ufcon))
+		cpu_relax();
+	wr_regb(cons_uart, S3C2410_UTXH, c);
+}
+
+#endif /* CONFIG_CONSOLE_POLL */
+
 static void
 s3c24xx_serial_console_putchar(struct uart_port *port, int ch)
 {
-- 
1.7.7.3


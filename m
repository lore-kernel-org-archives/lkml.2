Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab2KIQ6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:58:33 -0500
Received: from smtp.infotech.no ([82.134.31.41]:41004 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881Ab2KIQ6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:58:31 -0500
Message-ID: <509D362D.3040605@interlog.com>
Date: Fri, 09 Nov 2012 11:58:21 -0500
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
CC: linux-arm-kernel@lists.infradead.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Robert Nelson <Robert.Nelson@digikey.com>
Subject: [PATCH] atmel_serial oops when peripheral clock misconfigured
Content-Type: multipart/mixed;
 boundary="------------040209040209090600050900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040209040209090600050900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

In lk 3.7.0-rc4 when a peripheral clock is not found for
a serial port the atmel_serial driver brings down the
kernel with an oops during boot-up. This impacts the
Atmel AT91 family of MCUs.

For example, arch/arm/mach-at91/at91sam9x5.c does not
specify properly the peripheral clocks for the UTXD0/URXD0
and UTXD1/URXD1 serial ports. Selecting either of those
ports in a dts file will crash the kernel. at91sam9x5.c needs
to be fixed but stopping atmel_serial crashing the kernel is
more urgent.

Patch attached for your consideration.

Signed-of-by: Douglas Gilbert <dgilbert@interlog.com>

--------------040209040209090600050900
Content-Type: text/x-patch;
 name="atmel_serial_clk_oops.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="atmel_serial_clk_oops.patch"

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 3d7e1ee..cc385e0 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1457,8 +1457,9 @@ static void __devinit atmel_of_init_port(struct atmel_uart_port *atmel_port,
 
 /*
  * Configure the port from the platform device resource info.
+ * Returns 0 for success or 1 in case of error.
  */
-static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
+static int __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
 				      struct platform_device *pdev)
 {
 	struct uart_port *port = &atmel_port->uart;
@@ -1496,6 +1497,8 @@ static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
 	/* for console, the clock could already be configured */
 	if (!atmel_port->clk) {
 		atmel_port->clk = clk_get(&pdev->dev, "usart");
+		if (IS_ERR(atmel_port->clk))
+			return 1;	/* peripheral clock not found */
 		clk_enable(atmel_port->clk);
 		port->uartclk = clk_get_rate(atmel_port->clk);
 		clk_disable(atmel_port->clk);
@@ -1511,6 +1514,7 @@ static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
 	} else {
 		atmel_port->tx_done_mask = ATMEL_US_TXRDY;
 	}
+	return 0;
 }
 
 /*
@@ -1666,13 +1670,18 @@ static int __init atmel_console_init(void)
 		struct atmel_uart_data *pdata =
 			atmel_default_console_device->dev.platform_data;
 		int id = pdata->num;
+		int ret;
 		struct atmel_uart_port *port = &atmel_ports[id];
 
 		port->backup_imr = 0;
 		port->uart.line = id;
 
 		add_preferred_console(ATMEL_DEVICENAME, id, NULL);
-		atmel_init_port(port, atmel_default_console_device);
+		ret = atmel_init_port(port, atmel_default_console_device);
+		if (ret) {
+			pr_err("No peripheral clock for Atmel console ??\n");
+			return -EINVAL;
+		}
 		register_console(&atmel_console);
 	}
 
@@ -1803,7 +1812,12 @@ static int __devinit atmel_serial_probe(struct platform_device *pdev)
 	port->backup_imr = 0;
 	port->uart.line = ret;
 
-	atmel_init_port(port, pdev);
+	ret = atmel_init_port(port, pdev);
+	if (ret) {
+		ret = -EINVAL;
+		pr_err("peripheral clock not found for serial port\n");
+		goto err;
+	}
 
 	if (!atmel_use_dma_rx(&port->uart)) {
 		ret = -ENOMEM;

--------------040209040209090600050900--

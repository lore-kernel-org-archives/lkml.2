Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab2BQBE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:04:26 -0500
Received: from mga14.intel.com ([143.182.124.37]:42498 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756517Ab2BQBAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 20:00:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="67503921"
Message-ID: <4F3DA617.5030805@linux.intel.com>
Date: Thu, 16 Feb 2012 16:57:59 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: pch_uart and pch_phub clock selection
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm working on a tunnel creek (atom e6xx + topcliff PCH) development platform
that uses a 48MHz or 64MHz clock to drive the pch_uart. I've found that if I
force the uart_clock to 48MHz (or 64MHz on the latest rev) I can get the kernel
messages and getty on the serial port.

I see that the the CM-iTC board is special-cased to set a 192MHz uart_clock.
This is done in pch_uart.c code, but there is some register manipulation done in
the pch_phub.c driver and I don't understand the connection. How are the two
related?

Is the pch_phub.c register manipulation required for proper related? It seems to
work without touching those registers if I just force the clock.

The device I'm working with is EFI, and the dmi_get_system_info(DMI_BOARD_NAME)
returns "(null)", so I can't use the same test to identify this board. Is there
another common mechanism I might be able to use?

The following patch (by way of example, not meant for inclusion) gets things
working for this particular board with this command line:

console=ttyPCH1,115200 pch_uart.clock_param=48000000

I believe the right thing to do here is to discover a way to identify the board
and special case the clock as is done for the CM-iTC, but I would like to
understand the purpose of the pch_phub register manipulation code. Does this
make sense?

Thanks,

Darren


>From f83fa6cb575844d8e37f136890fe32258eb88dd2 Mon Sep 17 00:00:00 2001
Message-Id: <f83fa6cb575844d8e37f136890fe32258eb88dd2.1329439822.git.dvhart@linux.intel.com>
From: Darren Hart <dvhart@linux.intel.com>
Date: Wed, 15 Feb 2012 15:44:18 -0800
Subject: [PATCH] pch_uart: Add clock parameter

Allow for the specification of the clock as a module parameter. This is useful
when a board uses a non-standard clock, or when different versions of a board
use different clocks, and that board name or the version are not available to
the kernel.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
---
 drivers/tty/serial/pch_uart.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 17ae657..8f192b9 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -203,7 +203,7 @@ enum {
 
 #define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
 
-#define DEFAULT_BAUD_RATE 1843200 /* 1.8432MHz */
+#define DEFAULT_UART_CLOCK 1843200 /* 1.8432MHz */
 
 struct pch_uart_buffer {
 	unsigned char *buf;
@@ -218,7 +218,7 @@ struct eg20t_port {
 	unsigned int iobase;
 	struct pci_dev *pdev;
 	int fifo_size;
-	int base_baud;
+	int uart_clock;
 	int start_tx;
 	int start_rx;
 	int tx_empty;
@@ -287,13 +287,14 @@ static struct pch_uart_driver_data drv_dat[] = {
 static struct eg20t_port *pch_uart_ports[PCH_UART_NR];
 #endif
 static unsigned int default_baud = 9600;
+static unsigned int clock_param = 0;
 static const int trigger_level_256[4] = { 1, 64, 128, 224 };
 static const int trigger_level_64[4] = { 1, 16, 32, 56 };
 static const int trigger_level_16[4] = { 1, 4, 8, 14 };
 static const int trigger_level_1[4] = { 1, 1, 1, 1 };
 
 static void pch_uart_hal_request(struct pci_dev *pdev, int fifosize,
-				 int base_baud)
+				 int uart_clock)
 {
 	struct eg20t_port *priv = pci_get_drvdata(pdev);
 
@@ -332,7 +333,7 @@ static int pch_uart_hal_set_line(struct eg20t_port *priv, int baud,
 	unsigned int dll, dlm, lcr;
 	int div;
 
-	div = DIV_ROUND_CLOSEST(priv->base_baud / 16, baud);
+	div = DIV_ROUND_CLOSEST(priv->uart_clock / 16, baud);
 	if (div < 0 || USHRT_MAX <= div) {
 		dev_err(priv->port.dev, "Invalid Baud(div=0x%x)\n", div);
 		return -EINVAL;
@@ -1153,9 +1154,9 @@ static int pch_uart_startup(struct uart_port *port)
 	priv->tx_empty = 1;
 
 	if (port->uartclk)
-		priv->base_baud = port->uartclk;
+		priv->uart_clock = port->uartclk;
 	else
-		port->uartclk = priv->base_baud;
+		port->uartclk = priv->uart_clock;
 
 	pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_ALL_INT);
 	ret = pch_uart_hal_set_line(priv, default_baud,
@@ -1507,7 +1508,7 @@ static int __init pch_console_setup(struct console *co, char *options)
 		return -ENODEV;
 
 	/* setup uartclock */
-	port->uartclk = DEFAULT_BAUD_RATE;
+	port->uartclk = clock_param ? clock_param : DEFAULT_UART_CLOCK;
 
 	if (options)
 		uart_parse_options(options, &baud, &parity, &bits, &flow);
@@ -1550,7 +1551,7 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	unsigned int iobase;
 	unsigned int mapbase;
 	unsigned char *rxbuf;
-	int fifosize, base_baud;
+	int fifosize, uart_clock;
 	int port_type;
 	struct pch_uart_driver_data *board;
 	const char *board_name;
@@ -1566,12 +1567,15 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	if (!rxbuf)
 		goto init_port_free_txbuf;
 
-	base_baud = DEFAULT_BAUD_RATE;
+	uart_clock = DEFAULT_UART_CLOCK;
 
 	/* quirk for CM-iTC board */
 	board_name = dmi_get_system_info(DMI_BOARD_NAME);
 	if (board_name && strstr(board_name, "CM-iTC"))
-		base_baud = 192000000; /* 192.0MHz */
+		uart_clock = 192000000; /* 192.0MHz */
+
+	/* The module parameter overrides default and system quirks. */
+	uart_clock = clock_param ? clock_param : uart_clock;
 
 	switch (port_type) {
 	case PORT_UNKNOWN:
@@ -1597,7 +1601,7 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	priv->rxbuf.size = PAGE_SIZE;
 
 	priv->fifo_size = fifosize;
-	priv->base_baud = base_baud;
+	priv->uart_clock = uart_clock;
 	priv->port_type = PORT_MAX_8250 + port_type + 1;
 	priv->port.dev = &pdev->dev;
 	priv->port.iobase = iobase;
@@ -1614,7 +1618,7 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	spin_lock_init(&priv->port.lock);
 
 	pci_set_drvdata(pdev, priv);
-	pch_uart_hal_request(pdev, fifosize, base_baud);
+	pch_uart_hal_request(pdev, fifosize, uart_clock);
 
 #ifdef CONFIG_SERIAL_PCH_UART_CONSOLE
 	pch_uart_ports[board->line_no] = priv;
@@ -1785,3 +1789,4 @@ module_exit(pch_uart_module_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Intel EG20T PCH UART PCI Driver");
 module_param(default_baud, uint, S_IRUGO);
+module_param(clock_param, uint, S_IRUGO);
-- 
1.7.6.5


-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel

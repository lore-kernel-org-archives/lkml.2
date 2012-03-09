Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab2CIRxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:53:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:24905 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455Ab2CIRxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:53:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="119478332"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Feng Tang <feng.tang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: [PATCH 1/5] pch_uart: Use uartclk instead of base_baud
Date: Fri,  9 Mar 2012 09:51:48 -0800
Message-Id: <ae0029b9e1131467232389e4dfa630f50e159de0.1331315372.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <cover.1331315372.git.dvhart@linux.intel.com>
References: <cover.1331315372.git.dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The term "base baud" refers to the fastest baud rate the device can communicate
at. This is clock/16. pch_uart is using base_baud as the clock itself. Rename
the variables to be semantically correct.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
CC: Tomoya MORINAGA <tomoya.rohm@gmail.com>
CC: Feng Tang <feng.tang@intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alan Cox <alan@linux.intel.com>
CC: linux-serial@vger.kernel.org
---
 drivers/tty/serial/pch_uart.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index aa4d07b..5178213 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -206,7 +206,7 @@ enum {
 
 #define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
 
-#define DEFAULT_BAUD_RATE 1843200 /* 1.8432MHz */
+#define DEFAULT_UARTCLK 1843200 /* 1.8432MHz */
 
 struct pch_uart_buffer {
 	unsigned char *buf;
@@ -221,7 +221,7 @@ struct eg20t_port {
 	unsigned int iobase;
 	struct pci_dev *pdev;
 	int fifo_size;
-	int base_baud;
+	int uartclk;
 	int start_tx;
 	int start_rx;
 	int tx_empty;
@@ -387,7 +387,7 @@ static int pch_uart_hal_set_line(struct eg20t_port *priv, int baud,
 	unsigned int dll, dlm, lcr;
 	int div;
 
-	div = DIV_ROUND_CLOSEST(priv->base_baud / 16, baud);
+	div = DIV_ROUND_CLOSEST(priv->uartclk / 16, baud);
 	if (div < 0 || USHRT_MAX <= div) {
 		dev_err(priv->port.dev, "Invalid Baud(div=0x%x)\n", div);
 		return -EINVAL;
@@ -1205,9 +1205,9 @@ static int pch_uart_startup(struct uart_port *port)
 	priv->tx_empty = 1;
 
 	if (port->uartclk)
-		priv->base_baud = port->uartclk;
+		priv->uartclk = port->uartclk;
 	else
-		port->uartclk = priv->base_baud;
+		port->uartclk = priv->uartclk;
 
 	pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_ALL_INT);
 	ret = pch_uart_hal_set_line(priv, default_baud,
@@ -1557,7 +1557,7 @@ static int __init pch_console_setup(struct console *co, char *options)
 		return -ENODEV;
 
 	/* setup uartclock */
-	port->uartclk = DEFAULT_BAUD_RATE;
+	port->uartclk = DEFAULT_UARTCLK;
 
 	if (options)
 		uart_parse_options(options, &baud, &parity, &bits, &flow);
@@ -1600,7 +1600,7 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	unsigned int iobase;
 	unsigned int mapbase;
 	unsigned char *rxbuf;
-	int fifosize, base_baud;
+	int fifosize, uartclk;
 	int port_type;
 	struct pch_uart_driver_data *board;
 	const char *board_name;
@@ -1617,12 +1617,12 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	if (!rxbuf)
 		goto init_port_free_txbuf;
 
-	base_baud = DEFAULT_BAUD_RATE;
+	uartclk = DEFAULT_UARTCLK;
 
 	/* quirk for CM-iTC board */
 	board_name = dmi_get_system_info(DMI_BOARD_NAME);
 	if (board_name && strstr(board_name, "CM-iTC"))
-		base_baud = 192000000; /* 192.0MHz */
+		uartclk = 192000000; /* 192.0MHz */
 
 	switch (port_type) {
 	case PORT_UNKNOWN:
@@ -1648,7 +1648,7 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	priv->rxbuf.size = PAGE_SIZE;
 
 	priv->fifo_size = fifosize;
-	priv->base_baud = base_baud;
+	priv->uartclk = uartclk;
 	priv->port_type = PORT_MAX_8250 + port_type + 1;
 	priv->port.dev = &pdev->dev;
 	priv->port.iobase = iobase;
-- 
1.7.6.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab2CIRyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:54:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:24905 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab2CIRxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:53:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="116263170"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Feng Tang <feng.tang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: [PATCH 2/5] pch_uart: Add Fish River Island II uart clock quirks
Date: Fri,  9 Mar 2012 09:51:49 -0800
Message-Id: <d300c2195b9903a64b114e1bd38b02a03f19b230.1331315372.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <ae0029b9e1131467232389e4dfa630f50e159de0.1331315372.git.dvhart@linux.intel.com>
References: <ae0029b9e1131467232389e4dfa630f50e159de0.1331315372.git.dvhart@linux.intel.com>
In-Reply-To: <cover.1331315372.git.dvhart@linux.intel.com>
References: <cover.1331315372.git.dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the Fish River Island II (FRI2) UART clock following the CM-iTC
quirk handling mechanism. Depending on the firmware installed on the device, the
FRI2 uses a 48MHz or a 64MHz UART clock. This is detected with DMI strings.

Add similar UART clock quirk handling to the pch_console_setup() function to
enable kernel messages on boards with non-standard UART clocks.

Per Alan's suggestion, abstract out UART clock selection into
pch_uart_get_uartclk() to avoid code duplication.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
CC: Tomoya MORINAGA <tomoya.rohm@gmail.com>
CC: Feng Tang <feng.tang@intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alan Cox <alan@linux.intel.com>
CC: linux-serial@vger.kernel.org
---
 drivers/tty/serial/pch_uart.c |   40 +++++++++++++++++++++++++++-------------
 1 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 5178213..88a1be0 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -206,7 +206,10 @@ enum {
 
 #define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
 
-#define DEFAULT_UARTCLK 1843200 /* 1.8432MHz */
+#define DEFAULT_UARTCLK   1843200 /*   1.8432 MHz */
+#define CMITC_UARTCLK   192000000 /* 192.0000 MHz */
+#define FRI2_64_UARTCLK  64000000 /*  64.0000 MHz */
+#define FRI2_48_UARTCLK  48000000 /*  48.0000 MHz */
 
 struct pch_uart_buffer {
 	unsigned char *buf;
@@ -364,6 +367,26 @@ static const struct file_operations port_regs_ops = {
 };
 #endif	/* CONFIG_DEBUG_FS */
 
+/* Return UART clock, checking for board specific clocks. */
+static int pch_uart_get_uartclk(void)
+{
+	const char *cmp;
+
+	cmp = dmi_get_system_info(DMI_BOARD_NAME);
+	if (cmp && strstr(cmp, "CM-iTC"))
+		return CMITC_UARTCLK;
+
+	cmp = dmi_get_system_info(DMI_BIOS_VERSION);
+	if (cmp && strnstr(cmp, "FRI2", 4))
+		return FRI2_64_UARTCLK;
+
+	cmp = dmi_get_system_info(DMI_PRODUCT_NAME);
+	if (cmp && strstr(cmp, "Fish River Island II"))
+		return FRI2_48_UARTCLK;
+
+	return DEFAULT_UARTCLK;
+}
+
 static void pch_uart_hal_enable_interrupt(struct eg20t_port *priv,
 					  unsigned int flag)
 {
@@ -1556,8 +1579,7 @@ static int __init pch_console_setup(struct console *co, char *options)
 	if (!port || (!port->iobase && !port->membase))
 		return -ENODEV;
 
-	/* setup uartclock */
-	port->uartclk = DEFAULT_UARTCLK;
+	port->uartclk = pch_uart_get_uartclk();
 
 	if (options)
 		uart_parse_options(options, &baud, &parity, &bits, &flow);
@@ -1600,10 +1622,9 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	unsigned int iobase;
 	unsigned int mapbase;
 	unsigned char *rxbuf;
-	int fifosize, uartclk;
+	int fifosize;
 	int port_type;
 	struct pch_uart_driver_data *board;
-	const char *board_name;
 	char name[32];	/* for debugfs file name */
 
 	board = &drv_dat[id->driver_data];
@@ -1617,13 +1638,6 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	if (!rxbuf)
 		goto init_port_free_txbuf;
 
-	uartclk = DEFAULT_UARTCLK;
-
-	/* quirk for CM-iTC board */
-	board_name = dmi_get_system_info(DMI_BOARD_NAME);
-	if (board_name && strstr(board_name, "CM-iTC"))
-		uartclk = 192000000; /* 192.0MHz */
-
 	switch (port_type) {
 	case PORT_UNKNOWN:
 		fifosize = 256; /* EG20T/ML7213: UART0 */
@@ -1648,7 +1662,7 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	priv->rxbuf.size = PAGE_SIZE;
 
 	priv->fifo_size = fifosize;
-	priv->uartclk = uartclk;
+	priv->uartclk = pch_uart_get_uartclk();
 	priv->port_type = PORT_MAX_8250 + port_type + 1;
 	priv->port.dev = &pdev->dev;
 	priv->port.iobase = iobase;
-- 
1.7.6.5


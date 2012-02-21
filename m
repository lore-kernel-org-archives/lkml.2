Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab2BUE4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 23:56:05 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65389 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab2BUE4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 23:56:02 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, feng.tang@intel.com, dvhart@linux.intel.com,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH] pch_uart: Change default UART clock setting 192MHz
Date: Tue, 21 Feb 2012 13:55:40 +0900
Message-Id: <1329800140-4279-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, PCH_UART uses 1843200Hz as default clock.
However, in case of using high baud rate, users need to modify
clock setting.

This patch uses 192MHz setting as default UART clock setting.
Using this clock, users can use almost high baud rate without modifying
clock settings.

This setting is the same as quirk for CM-iTC board.
So, delete the quirk.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
Related patch is 
http://marc.info/?l=linux-kernel&m=132979974907774&w=2
---
 drivers/tty/serial/pch_uart.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 17ae657..d068c34 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -203,7 +203,7 @@ enum {
 
 #define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
 
-#define DEFAULT_BAUD_RATE 1843200 /* 1.8432MHz */
+#define DEFAULT_UART_CLOCK 192000000 /* 192.0MHz */
 
 struct pch_uart_buffer {
 	unsigned char *buf;
@@ -287,6 +287,7 @@ static struct pch_uart_driver_data drv_dat[] = {
 static struct eg20t_port *pch_uart_ports[PCH_UART_NR];
 #endif
 static unsigned int default_baud = 9600;
+static unsigned int clock_param;
 static const int trigger_level_256[4] = { 1, 64, 128, 224 };
 static const int trigger_level_64[4] = { 1, 16, 32, 56 };
 static const int trigger_level_16[4] = { 1, 4, 8, 14 };
@@ -1507,7 +1508,7 @@ static int __init pch_console_setup(struct console *co, char *options)
 		return -ENODEV;
 
 	/* setup uartclock */
-	port->uartclk = DEFAULT_BAUD_RATE;
+	port->uartclk = clock_param ? clock_param : DEFAULT_UART_CLOCK;
 
 	if (options)
 		uart_parse_options(options, &baud, &parity, &bits, &flow);
@@ -1553,7 +1554,6 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	int fifosize, base_baud;
 	int port_type;
 	struct pch_uart_driver_data *board;
-	const char *board_name;
 
 	board = &drv_dat[id->driver_data];
 	port_type = board->port_type;
@@ -1566,12 +1566,8 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	if (!rxbuf)
 		goto init_port_free_txbuf;
 
-	base_baud = DEFAULT_BAUD_RATE;
-
-	/* quirk for CM-iTC board */
-	board_name = dmi_get_system_info(DMI_BOARD_NAME);
-	if (board_name && strstr(board_name, "CM-iTC"))
-		base_baud = 192000000; /* 192.0MHz */
+	/* The module parameter overrides default. */
+	base_baud = clock_param ? clock_param : DEFAULT_UART_CLOCK;
 
 	switch (port_type) {
 	case PORT_UNKNOWN:
@@ -1785,3 +1781,4 @@ module_exit(pch_uart_module_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Intel EG20T PCH UART PCI Driver");
 module_param(default_baud, uint, S_IRUGO);
+module_param(clock_param, uint, (S_IRUSR | S_IWUSR));
-- 
1.7.7.6


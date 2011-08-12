Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab1HLDW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 23:22:27 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:59450 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab1HLDWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 23:22:25 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz2ei87h2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Alan Cox <alan@linux.intel.com>
CC: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH v3] serial:bfin_uart: Put TX IRQ in individual platform resource.
Date: Fri, 12 Aug 2011 11:15:51 +0800
Message-ID: <1313118951-27886-1-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Serial TX IRQ is not RX IRQ plus 1 in some blackfin chips.
Give individual platform resources to both TX and RX irqs.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/tty/serial/bfin_uart.c |   36 ++++++++++++++++++++++--------------
 1 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/serial/bfin_uart.c b/drivers/tty/serial/bfin_uart.c
index e08bc04..c7e592d 100644
--- a/drivers/tty/serial/bfin_uart.c
+++ b/drivers/tty/serial/bfin_uart.c
@@ -667,17 +667,17 @@ static int bfin_serial_startup(struct uart_port *port)
 		kgdboc_break_enabled = 0;
 	else {
 # endif
-	if (request_irq(uart->port.irq, bfin_serial_rx_int, IRQF_DISABLED,
+	if (request_irq(uart->rx_irq, bfin_serial_rx_int, IRQF_DISABLED,
 	     "BFIN_UART_RX", uart)) {
 		printk(KERN_NOTICE "Unable to attach BlackFin UART RX interrupt\n");
 		return -EBUSY;
 	}
 
 	if (request_irq
-	    (uart->port.irq+1, bfin_serial_tx_int, IRQF_DISABLED,
+	    (uart->tx_irq, bfin_serial_tx_int, IRQF_DISABLED,
 	     "BFIN_UART_TX", uart)) {
 		printk(KERN_NOTICE "Unable to attach BlackFin UART TX interrupt\n");
-		free_irq(uart->port.irq, uart);
+		free_irq(uart->rx_irq, uart);
 		return -EBUSY;
 	}
 
@@ -692,7 +692,7 @@ static int bfin_serial_startup(struct uart_port *port)
 		 */
 		unsigned uart_dma_ch_rx, uart_dma_ch_tx;
 
-		switch (uart->port.irq) {
+		switch (uart->rx_irq) {
 		case IRQ_UART3_RX:
 			uart_dma_ch_rx = CH_UART3_RX;
 			uart_dma_ch_tx = CH_UART3_TX;
@@ -709,16 +709,16 @@ static int bfin_serial_startup(struct uart_port *port)
 		if (uart_dma_ch_rx &&
 			request_dma(uart_dma_ch_rx, "BFIN_UART_RX") < 0) {
 			printk(KERN_NOTICE"Fail to attach UART interrupt\n");
-			free_irq(uart->port.irq, uart);
-			free_irq(uart->port.irq + 1, uart);
+			free_irq(uart->rx_irq, uart);
+			free_irq(uart->tx_irq, uart);
 			return -EBUSY;
 		}
 		if (uart_dma_ch_tx &&
 			request_dma(uart_dma_ch_tx, "BFIN_UART_TX") < 0) {
 			printk(KERN_NOTICE "Fail to attach UART interrupt\n");
 			free_dma(uart_dma_ch_rx);
-			free_irq(uart->port.irq, uart);
-			free_irq(uart->port.irq + 1, uart);
+			free_irq(uart->rx_irq, uart);
+			free_irq(uart->tx_irq, uart);
 			return -EBUSY;
 		}
 	}
@@ -785,8 +785,8 @@ static void bfin_serial_shutdown(struct uart_port *port)
 		break;
 	};
 #endif
-	free_irq(uart->port.irq, uart);
-	free_irq(uart->port.irq+1, uart);
+	free_irq(uart->rx_irq, uart);
+	free_irq(uart->tx_irq, uart);
 #endif
 
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
@@ -1319,14 +1319,22 @@ static int bfin_serial_probe(struct platform_device *pdev)
 		}
 		uart->port.mapbase = res->start;
 
-		uart->port.irq = platform_get_irq(pdev, 0);
-		if (uart->port.irq < 0) {
-			dev_err(&pdev->dev, "No uart RX/TX IRQ specified\n");
+		uart->tx_irq = platform_get_irq(pdev, 0);
+		if (uart->tx_irq < 0) {
+			dev_err(&pdev->dev, "No uart TX IRQ specified\n");
 			ret = -ENOENT;
 			goto out_error_unmap;
 		}
 
-		uart->status_irq = platform_get_irq(pdev, 1);
+		uart->rx_irq = platform_get_irq(pdev, 1);
+		if (uart->rx_irq < 0) {
+			dev_err(&pdev->dev, "No uart RX IRQ specified\n");
+			ret = -ENOENT;
+			goto out_error_unmap;
+		}
+		uart->port.irq = uart->rx_irq;
+
+		uart->status_irq = platform_get_irq(pdev, 2);
 		if (uart->status_irq < 0) {
 			dev_err(&pdev->dev, "No uart status IRQ specified\n");
 			ret = -ENOENT;
-- 
1.7.0.4



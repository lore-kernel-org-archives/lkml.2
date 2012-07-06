Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab2GFITi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 04:19:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44122 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2GFITa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 04:19:30 -0400
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 1/2] pch_uart: Fix rx error interrupt setting issue
Date: Fri,  6 Jul 2012 17:19:42 +0900
Message-Id: <1341562783-5571-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rx Error interrupt(E.G. parity error) is not enabled.
So, when parity error occurs, error interrupt is not occurred.
As a result, the received data is not dropped.

This patch adds enable/disable rx error interrupt code.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/tty/serial/pch_uart.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 4fdec6a..4d84ad0 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -754,7 +754,8 @@ static void pch_dma_rx_complete(void *arg)
 		tty_flip_buffer_push(tty);
 	tty_kref_put(tty);
 	async_tx_ack(priv->desc_rx);
-	pch_uart_hal_enable_interrupt(priv, PCH_UART_HAL_RX_INT);
+	pch_uart_hal_enable_interrupt(priv, PCH_UART_HAL_RX_INT |
+					    PCH_UART_HAL_RX_ERR_INT);
 }
 
 static void pch_dma_tx_complete(void *arg)
@@ -809,7 +810,8 @@ static int handle_rx_to(struct eg20t_port *priv)
 	int rx_size;
 	int ret;
 	if (!priv->start_rx) {
-		pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_RX_INT);
+		pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_RX_INT |
+						     PCH_UART_HAL_RX_ERR_INT);
 		return 0;
 	}
 	buf = &priv->rxbuf;
@@ -1078,11 +1080,13 @@ static irqreturn_t pch_uart_interrupt(int irq, void *dev_id)
 		case PCH_UART_IID_RDR:	/* Received Data Ready */
 			if (priv->use_dma) {
 				pch_uart_hal_disable_interrupt(priv,
-							PCH_UART_HAL_RX_INT);
+						PCH_UART_HAL_RX_INT |
+						PCH_UART_HAL_RX_ERR_INT);
 				ret = dma_handle_rx(priv);
 				if (!ret)
 					pch_uart_hal_enable_interrupt(priv,
-							PCH_UART_HAL_RX_INT);
+						PCH_UART_HAL_RX_INT |
+						PCH_UART_HAL_RX_ERR_INT);
 			} else {
 				ret = handle_rx(priv);
 			}
@@ -1208,7 +1212,8 @@ static void pch_uart_stop_rx(struct uart_port *port)
 	struct eg20t_port *priv;
 	priv = container_of(port, struct eg20t_port, port);
 	priv->start_rx = 0;
-	pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_RX_INT);
+	pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_RX_INT |
+					     PCH_UART_HAL_RX_ERR_INT);
 }
 
 /* Enable the modem status interrupts. */
@@ -1300,7 +1305,8 @@ static int pch_uart_startup(struct uart_port *port)
 		pch_request_dma(port);
 
 	priv->start_rx = 1;
-	pch_uart_hal_enable_interrupt(priv, PCH_UART_HAL_RX_INT);
+	pch_uart_hal_enable_interrupt(priv, PCH_UART_HAL_RX_INT |
+					    PCH_UART_HAL_RX_ERR_INT);
 	uart_update_timeout(port, CS8, default_baud);
 
 	return 0;
-- 
1.7.4.4


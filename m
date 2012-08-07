Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab2HGDiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:38:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59680 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757248Ab2HGDiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:19 -0400
Message-Id: <20120807032806.105738540@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:29:04 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 69/70] pch_uart: Fix rx error interrupt setting issue
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya.rohm@gmail.com>

commit 9539dfb7ac1c84522fe1f79bb7dac2990f3de44a upstream.

Rx Error interrupt(E.G. parity error) is not enabled.
So, when parity error occurs, error interrupt is not occurred.
As a result, the received data is not dropped.

This patch adds enable/disable rx error interrupt code.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Backported by Tomoya MORINGA: adjusted context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/pch_uart.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index c5bc23d..2cc9b46 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -757,7 +757,8 @@ static void pch_dma_rx_complete(void *arg)
 		tty_flip_buffer_push(tty);
 	tty_kref_put(tty);
 	async_tx_ack(priv->desc_rx);
-	pch_uart_hal_enable_interrupt(priv, PCH_UART_HAL_RX_INT);
+	pch_uart_hal_enable_interrupt(priv, PCH_UART_HAL_RX_INT |
+					    PCH_UART_HAL_RX_ERR_INT);
 }
 
 static void pch_dma_tx_complete(void *arg)
@@ -812,7 +813,8 @@ static int handle_rx_to(struct eg20t_port *priv)
 	int rx_size;
 	int ret;
 	if (!priv->start_rx) {
-		pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_RX_INT);
+		pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_RX_INT |
+						     PCH_UART_HAL_RX_ERR_INT);
 		return 0;
 	}
 	buf = &priv->rxbuf;
@@ -1081,11 +1083,13 @@ static irqreturn_t pch_uart_interrupt(int irq, void *dev_id)
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
@@ -1211,7 +1215,8 @@ static void pch_uart_stop_rx(struct uart_port *port)
 	struct eg20t_port *priv;
 	priv = container_of(port, struct eg20t_port, port);
 	priv->start_rx = 0;
-	pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_RX_INT);
+	pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_RX_INT |
+					     PCH_UART_HAL_RX_ERR_INT);
 	priv->int_dis_flag = 1;
 }
 
@@ -1304,7 +1309,8 @@ static int pch_uart_startup(struct uart_port *port)
 		pch_request_dma(port);
 
 	priv->start_rx = 1;
-	pch_uart_hal_enable_interrupt(priv, PCH_UART_HAL_RX_INT);
+	pch_uart_hal_enable_interrupt(priv, PCH_UART_HAL_RX_INT |
+					    PCH_UART_HAL_RX_ERR_INT);
 	uart_update_timeout(port, CS8, default_baud);
 
 	return 0;



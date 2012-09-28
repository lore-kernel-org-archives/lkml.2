Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161067Ab2I1UtK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:49:10 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44212 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945951Ab2I1Usz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:48:55 -0400
X-Sasl-enc: qJEgWNEWEKiimjgTNFX9PULTKikdprHT+IFSSXMNN1zn 1348865335
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [ 116/127] pch_uart: Fix rx error interrupt setting issue
Date: Fri, 28 Sep 2012 13:34:49 -0700
Message-Id: <20120928203059.482595350@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/tty/serial/pch_uart.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -658,7 +658,8 @@ static void pch_dma_rx_complete(void *ar
 		tty_flip_buffer_push(tty);
 	tty_kref_put(tty);
 	async_tx_ack(priv->desc_rx);
-	pch_uart_hal_enable_interrupt(priv, PCH_UART_HAL_RX_INT);
+	pch_uart_hal_enable_interrupt(priv, PCH_UART_HAL_RX_INT |
+					    PCH_UART_HAL_RX_ERR_INT);
 }
 
 static void pch_dma_tx_complete(void *arg)
@@ -713,7 +714,8 @@ static int handle_rx_to(struct eg20t_por
 	int rx_size;
 	int ret;
 	if (!priv->start_rx) {
-		pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_RX_INT);
+		pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_RX_INT |
+						     PCH_UART_HAL_RX_ERR_INT);
 		return 0;
 	}
 	buf = &priv->rxbuf;
@@ -975,11 +977,13 @@ static irqreturn_t pch_uart_interrupt(in
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
@@ -1105,7 +1109,8 @@ static void pch_uart_stop_rx(struct uart
 	struct eg20t_port *priv;
 	priv = container_of(port, struct eg20t_port, port);
 	priv->start_rx = 0;
-	pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_RX_INT);
+	pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_RX_INT |
+					     PCH_UART_HAL_RX_ERR_INT);
 	priv->int_dis_flag = 1;
 }
 
@@ -1199,7 +1204,8 @@ static int pch_uart_startup(struct uart_
 		pch_request_dma(port);
 
 	priv->start_rx = 1;
-	pch_uart_hal_enable_interrupt(priv, PCH_UART_HAL_RX_INT);
+	pch_uart_hal_enable_interrupt(priv, PCH_UART_HAL_RX_INT |
+					    PCH_UART_HAL_RX_ERR_INT);
 	uart_update_timeout(port, CS8, default_baud);
 
 	return 0;



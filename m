Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab1BWBFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:05:53 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:17350 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754387Ab1BWBEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:04:48 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Jesper Juhl <jj@chaosbits.net>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH linux-next 3/8] pch_uart : Reduce memcpy
Date: Wed, 23 Feb 2011 10:03:14 +0900
Message-Id: <1298422999-4050-3-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1298422999-4050-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1298422999-4050-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce memcpy for performance improvement.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/tty/serial/pch_uart.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 9c631ab..d4bcbce 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -389,7 +389,7 @@ static u8 pch_uart_hal_get_modem(struct eg20t_port *priv)
 	return get_msr(priv, priv->membase);
 }
 
-static int pch_uart_hal_write(struct eg20t_port *priv,
+static void pch_uart_hal_write(struct eg20t_port *priv,
 			      const unsigned char *buf, int tx_size)
 {
 	int i;
@@ -399,7 +399,6 @@ static int pch_uart_hal_write(struct eg20t_port *priv,
 		thr = buf[i++];
 		iowrite8(thr, priv->membase + PCH_UART_THR);
 	}
-	return i;
 }
 
 static int pch_uart_hal_read(struct eg20t_port *priv, unsigned char *buf,
@@ -633,7 +632,7 @@ static void pch_dma_tx_complete(void *arg)
 		pch_uart_hal_enable_interrupt(priv, PCH_UART_HAL_TX_INT);
 }
 
-static int pop_tx(struct eg20t_port *priv, unsigned char *buf, int size)
+static int pop_tx(struct eg20t_port *priv, int size)
 {
 	int count = 0;
 	struct uart_port *port = &priv->port;
@@ -646,7 +645,7 @@ static int pop_tx(struct eg20t_port *priv, unsigned char *buf, int size)
 		int cnt_to_end =
 		    CIRC_CNT_TO_END(xmit->head, xmit->tail, UART_XMIT_SIZE);
 		int sz = min(size - count, cnt_to_end);
-		memcpy(&buf[count], &xmit->buf[xmit->tail], sz);
+		pch_uart_hal_write(priv, &xmit->buf[xmit->tail], sz);
 		xmit->tail = (xmit->tail + sz) & (UART_XMIT_SIZE - 1);
 		count += sz;
 	} while (!uart_circ_empty(xmit) && count < size);
@@ -722,7 +721,6 @@ static unsigned int handle_tx(struct eg20t_port *priv)
 {
 	struct uart_port *port = &priv->port;
 	struct circ_buf *xmit = &port->state->xmit;
-	int ret;
 	int fifo_size;
 	int tx_size;
 	int size;
@@ -747,10 +745,9 @@ static unsigned int handle_tx(struct eg20t_port *priv)
 	if (size < 0)
 		size = fifo_size;
 
-	tx_size = pop_tx(priv, xmit->buf, size);
+	tx_size = pop_tx(priv, size);
 	if (tx_size > 0) {
-		ret = pch_uart_hal_write(priv, xmit->buf, tx_size);
-		port->icount.tx += ret;
+		port->icount.tx += tx_size;
 		tx_empty = 0;
 	}
 
-- 
1.7.3.4


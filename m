Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab1BWBEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:04:52 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:17361 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751517Ab1BWBEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:04:49 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Jesper Juhl <jj@chaosbits.net>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH linux-next 6/8] pch_uart: fix auto flow control miss-setting issue
Date: Wed, 23 Feb 2011 10:03:17 +0900
Message-Id: <1298422999-4050-6-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1298422999-4050-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1298422999-4050-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, auto-flow control setting processing is not set correctly.
This patch fixes the issue.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/tty/serial/pch_uart.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 7179202..d937157 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -217,6 +217,7 @@ struct eg20t_port {
 	struct pch_uart_buffer rxbuf;
 	unsigned int dmsr;
 	unsigned int fcr;
+	unsigned int mcr;
 	unsigned int use_dma;
 	unsigned int use_dma_flag;
 	struct dma_async_tx_descriptor	*desc_tx;
@@ -1006,7 +1007,6 @@ static unsigned int pch_uart_get_mctrl(struct uart_port *port)
 static void pch_uart_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
 	u32 mcr = 0;
-	unsigned int dat;
 	struct eg20t_port *priv = container_of(port, struct eg20t_port, port);
 
 	if (mctrl & TIOCM_DTR)
@@ -1016,11 +1016,11 @@ static void pch_uart_set_mctrl(struct uart_port *port, unsigned int mctrl)
 	if (mctrl & TIOCM_LOOP)
 		mcr |= UART_MCR_LOOP;
 
-	if (mctrl) {
-		dat = pch_uart_get_mctrl(port);
-		dat |= mcr;
-		iowrite8(dat, priv->membase + UART_MCR);
-	}
+	if (priv->mcr & UART_MCR_AFE)
+		mcr |= UART_MCR_AFE;
+
+	if (mctrl)
+		iowrite8(mcr, priv->membase + UART_MCR);
 }
 
 static void pch_uart_stop_tx(struct uart_port *port)
@@ -1214,6 +1214,13 @@ static void pch_uart_set_termios(struct uart_port *port,
 	} else {
 		parity = PCH_UART_HAL_PARITY_NONE;
 	}
+
+	/* Only UART0 has auto hardware flow function */
+	if ((termios->c_cflag & CRTSCTS) && (priv->fifo_size == 256))
+		priv->mcr |= UART_MCR_AFE;
+	else
+		priv->mcr &= ~UART_MCR_AFE;
+
 	termios->c_cflag &= ~CMSPAR; /* Mark/Space parity is not supported */
 
 	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk / 16);
-- 
1.7.3.4


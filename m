Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab1BRCXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 21:23:48 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:19454 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754010Ab1BRCXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 21:23:14 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 6/8] pch_uart: fix auto flow control miss-setting issue
Date: Fri, 18 Feb 2011 11:24:02 +0900
Message-Id: <1297995844-11282-6-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1297995844-11282-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1297995844-11282-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, auto-flow control setting processing is not set correctly.
This patch fixes the issue.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/serial/pch_uart.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/serial/pch_uart.c b/drivers/serial/pch_uart.c
index 1898861..0c95051 100644
--- a/drivers/serial/pch_uart.c
+++ b/drivers/serial/pch_uart.c
@@ -218,6 +218,7 @@ struct eg20t_port {
 	struct pch_uart_buffer rxbuf;
 	unsigned int dmsr;
 	unsigned int fcr;
+	unsigned int mcr;
 	unsigned int use_dma;
 	unsigned int use_dma_flag;
 	struct dma_async_tx_descriptor	*desc_tx;
@@ -1007,7 +1008,6 @@ static unsigned int pch_uart_get_mctrl(struct uart_port *port)
 static void pch_uart_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
 	u32 mcr = 0;
-	unsigned int dat;
 	struct eg20t_port *priv = container_of(port, struct eg20t_port, port);
 
 	if (mctrl & TIOCM_DTR)
@@ -1017,11 +1017,11 @@ static void pch_uart_set_mctrl(struct uart_port *port, unsigned int mctrl)
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
@@ -1215,6 +1215,13 @@ static void pch_uart_set_termios(struct uart_port *port,
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


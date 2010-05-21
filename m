Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199Ab0EUQxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:53:41 -0400
Received: from kroah.org ([198.145.64.141]:50339 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934123Ab0EUQwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:52:12 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Richard=20R=C3=B6jfors?= <richard.rojfors@pelagicore.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/25] serial: timbuart: make sure last byte is sent when port is closed
Date: Fri, 21 May 2010 09:51:48 -0700
Message-Id: <1274460714-11277-19-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165113.GB11216@kroah.com>
References: <20100521165113.GB11216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Röjfors <richard.rojfors@pelagicore.com>

Fix a problem in early versions of the FPGA IP.

In certain situations the IP reports that the FIFO is empty, but a byte is
still clocked out.  If a flush is done at that point the currently clocked
byte is canceled.

This causes incompatibilities with the upper layers when a port is closed,
it waits until the FIFO is empty and then closes the port.  During close
the FIFO is flushed -> the last byte is not sent properly.

Now the FIFO is only flushed if it is reported to be non-empty.  Which
makes the currently clocked out byte to finish.

[akpm@linux-foundation.org: fix build]
Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/timbuart.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/serial/timbuart.c b/drivers/serial/timbuart.c
index 62f389f..67ca642 100644
--- a/drivers/serial/timbuart.c
+++ b/drivers/serial/timbuart.c
@@ -68,12 +68,22 @@ static void timbuart_start_tx(struct uart_port *port)
 	tasklet_schedule(&uart->tasklet);
 }
 
+static unsigned int timbuart_tx_empty(struct uart_port *port)
+{
+	u32 isr = ioread32(port->membase + TIMBUART_ISR);
+
+	return (isr & TXBE) ? TIOCSER_TEMT : 0;
+}
+
 static void timbuart_flush_buffer(struct uart_port *port)
 {
-	u8 ctl = ioread8(port->membase + TIMBUART_CTRL) | TIMBUART_CTRL_FLSHTX;
+	if (!timbuart_tx_empty(port)) {
+		u8 ctl = ioread8(port->membase + TIMBUART_CTRL) |
+			TIMBUART_CTRL_FLSHTX;
 
-	iowrite8(ctl, port->membase + TIMBUART_CTRL);
-	iowrite32(TXBF, port->membase + TIMBUART_ISR);
+		iowrite8(ctl, port->membase + TIMBUART_CTRL);
+		iowrite32(TXBF, port->membase + TIMBUART_ISR);
+	}
 }
 
 static void timbuart_rx_chars(struct uart_port *port)
@@ -195,13 +205,6 @@ void timbuart_tasklet(unsigned long arg)
 	dev_dbg(uart->port.dev, "%s leaving\n", __func__);
 }
 
-static unsigned int timbuart_tx_empty(struct uart_port *port)
-{
-	u32 isr = ioread32(port->membase + TIMBUART_ISR);
-
-	return (isr & TXBE) ? TIOCSER_TEMT : 0;
-}
-
 static unsigned int timbuart_get_mctrl(struct uart_port *port)
 {
 	u8 cts = ioread8(port->membase + TIMBUART_CTRL);
-- 
1.7.0.3


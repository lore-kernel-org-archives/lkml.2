Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab2HUJWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:22:08 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:33046 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755369Ab2HUJUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:20:25 -0400
From: Felipe Balbi <balbi@ti.com>
To: alan@linux.intel.com
Cc: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [RFC/PATCH 09/13] serial: omap: move THRE check to transmit_chars()
Date: Tue, 21 Aug 2012 12:15:51 +0300
Message-Id: <1345540555-24359-10-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1345540555-24359-1-git-send-email-balbi@ti.com>
References: <1345540555-24359-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

since all other IRQ types now do all necessary
checks inside their handlers, transmit_chars()
was the only one left expecting serial_omap_irq()
to check THRE for it. We can move THRE check to
transmit_chars() in order to make serial_omap_irq()
more uniform.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 74a4f0a..6ea24c5 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -195,11 +195,14 @@ static void serial_omap_stop_rx(struct uart_port *port)
 	pm_runtime_put_autosuspend(up->dev);
 }
 
-static void transmit_chars(struct uart_omap_port *up)
+static void transmit_chars(struct uart_omap_port *up, unsigned int lsr)
 {
 	struct circ_buf *xmit = &up->port.state->xmit;
 	int count;
 
+	if (!(lsr & UART_LSR_THRE))
+		return;
+
 	if (up->port.x_char) {
 		serial_out(up, UART_TX, up->port.x_char);
 		up->port.icount.tx++;
@@ -367,8 +370,7 @@ static inline irqreturn_t serial_omap_irq(int irq, void *dev_id)
 			check_modem_status(up);
 			break;
 		case UART_IIR_THRI:
-			if (lsr & UART_LSR_THRE)
-				transmit_chars(up);
+			transmit_chars(up, lsr);
 			break;
 		case UART_IIR_RX_TIMEOUT:
 			/* FALLTHROUGH */
-- 
1.7.12.rc3


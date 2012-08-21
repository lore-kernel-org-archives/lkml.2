Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab2HUMUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:20:48 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:56084 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756593Ab2HUMUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:20:34 -0400
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
Subject: [PATCH v2 06/13] serial: omap: simplify IRQ handling
Date: Tue, 21 Aug 2012 15:16:04 +0300
Message-Id: <1345551371-18862-7-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1345551371-18862-1-git-send-email-balbi@ti.com>
References: <1345540555-24359-1-git-send-email-balbi@ti.com>
 <1345551371-18862-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

quite a few changes here, though they are
pretty obvious. In summary we're making sure
to detect which interrupt type we need to
handle before calling the underlying interrupt
handling procedure.

Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 48 +++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 16808b6..2d3e64e 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -350,33 +350,59 @@ static inline irqreturn_t serial_omap_irq(int irq, void *dev_id)
 {
 	struct uart_omap_port *up = dev_id;
 	unsigned int iir, lsr;
+	unsigned int type;
 	unsigned long flags;
+	irqreturn_t ret = IRQ_HANDLED;
 
+	spin_lock_irqsave(&up->port.lock, flags);
 	pm_runtime_get_sync(up->dev);
 	iir = serial_in(up, UART_IIR);
+again:
 	if (iir & UART_IIR_NO_INT) {
-		pm_runtime_mark_last_busy(up->dev);
-		pm_runtime_put_autosuspend(up->dev);
-		return IRQ_NONE;
+		ret = IRQ_NONE;
+		goto out;
 	}
 
-	spin_lock_irqsave(&up->port.lock, flags);
 	lsr = serial_in(up, UART_LSR);
-	if (iir & UART_IIR_RLSI) {
+
+	/* extract IRQ type from IIR register */
+	type = iir & 0x3e;
+
+	switch (type) {
+	case UART_IIR_MSI:
+		check_modem_status(up);
+		break;
+	case UART_IIR_THRI:
+		if (lsr & UART_LSR_THRE)
+			transmit_chars(up);
+		break;
+	case UART_IIR_RDI:
 		if (lsr & UART_LSR_DR)
 			receive_chars(up, &lsr);
+		break;
+	case UART_IIR_RLSI:
+		if (lsr & UART_LSR_BRK_ERROR_BITS)
+			receive_chars(up, &lsr);
+		break;
+	case UART_IIR_RX_TIMEOUT:
+		receive_chars(up, &lsr);
+		break;
+	case UART_IIR_CTS_RTS_DSR:
+		iir = serial_in(up, UART_IIR);
+		goto again;
+	case UART_IIR_XOFF:
+		/* FALLTHROUGH */
+	default:
+		break;
 	}
 
-	check_modem_status(up);
-	if ((lsr & UART_LSR_THRE) && (iir & UART_IIR_THRI))
-		transmit_chars(up);
-
+out:
 	spin_unlock_irqrestore(&up->port.lock, flags);
 	pm_runtime_mark_last_busy(up->dev);
 	pm_runtime_put_autosuspend(up->dev);
-
 	up->port_activity = jiffies;
-	return IRQ_HANDLED;
+
+	return ret;
 }
 
 static unsigned int serial_omap_tx_empty(struct uart_port *port)
-- 
1.7.12.rc3


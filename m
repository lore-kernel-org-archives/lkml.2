Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab2IFMub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 08:50:31 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:55059 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754841Ab2IFMuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 08:50:25 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: alan@linux.intel.com, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v4 05/21] serial: omap: refactor receive_chars() into rdi/rlsi handlers
Date: Thu,  6 Sep 2012 15:45:24 +0300
Message-Id: <1346935540-1792-6-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1346935540-1792-1-git-send-email-balbi@ti.com>
References: <20120906122948.GC29202@arwen.pp.htv.fi>
 <1346935540-1792-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

receive_chars() was getting too big and too difficult
to follow. By splitting it into separate RDI and RSLI
handlers, we have smaller functions which are easy
to understand and only touch the pieces which they need
to touch.

Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 205 +++++++++++++++++++--------------------
 1 file changed, 101 insertions(+), 104 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index d5a08cb..9c0a4ae 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -196,74 +196,6 @@ static void serial_omap_stop_rx(struct uart_port *port)
 	pm_runtime_put_autosuspend(up->dev);
 }
 
-static inline void receive_chars(struct uart_omap_port *up,
-		unsigned int *status)
-{
-	struct tty_struct *tty = up->port.state->port.tty;
-	unsigned int flag, lsr = *status;
-	unsigned char ch = 0;
-	int max_count = 256;
-
-	do {
-		if (likely(lsr & UART_LSR_DR))
-			ch = serial_in(up, UART_RX);
-		flag = TTY_NORMAL;
-		up->port.icount.rx++;
-
-		if (unlikely(lsr & UART_LSR_BRK_ERROR_BITS)) {
-			/*
-			 * For statistics only
-			 */
-			if (lsr & UART_LSR_BI) {
-				lsr &= ~(UART_LSR_FE | UART_LSR_PE);
-				up->port.icount.brk++;
-				/*
-				 * We do the SysRQ and SAK checking
-				 * here because otherwise the break
-				 * may get masked by ignore_status_mask
-				 * or read_status_mask.
-				 */
-				if (uart_handle_break(&up->port))
-					goto ignore_char;
-			} else if (lsr & UART_LSR_PE) {
-				up->port.icount.parity++;
-			} else if (lsr & UART_LSR_FE) {
-				up->port.icount.frame++;
-			}
-
-			if (lsr & UART_LSR_OE)
-				up->port.icount.overrun++;
-
-			/*
-			 * Mask off conditions which should be ignored.
-			 */
-			lsr &= up->port.read_status_mask;
-
-#ifdef CONFIG_SERIAL_OMAP_CONSOLE
-			if (up->port.line == up->port.cons->index) {
-				/* Recover the break flag from console xmit */
-				lsr |= up->lsr_break_flag;
-			}
-#endif
-			if (lsr & UART_LSR_BI)
-				flag = TTY_BREAK;
-			else if (lsr & UART_LSR_PE)
-				flag = TTY_PARITY;
-			else if (lsr & UART_LSR_FE)
-				flag = TTY_FRAME;
-		}
-
-		if (uart_handle_sysrq_char(&up->port, ch))
-			goto ignore_char;
-		uart_insert_char(&up->port, lsr, UART_LSR_OE, ch, flag);
-ignore_char:
-		lsr = serial_in(up, UART_LSR);
-	} while ((lsr & (UART_LSR_DR | UART_LSR_BI)) && (max_count-- > 0));
-	spin_unlock(&up->port.lock);
-	tty_flip_buffer_push(tty);
-	spin_lock(&up->port.lock);
-}
-
 static void transmit_chars(struct uart_omap_port *up)
 {
 	struct circ_buf *xmit = &up->port.state->xmit;
@@ -342,6 +274,68 @@ static unsigned int check_modem_status(struct uart_omap_port *up)
 	return status;
 }
 
+static void serial_omap_rlsi(struct uart_omap_port *up, unsigned int lsr)
+{
+	unsigned int flag;
+
+	up->port.icount.rx++;
+	flag = TTY_NORMAL;
+
+	if (lsr & UART_LSR_BI) {
+		flag = TTY_BREAK;
+		lsr &= ~(UART_LSR_FE | UART_LSR_PE);
+		up->port.icount.brk++;
+		/*
+		 * We do the SysRQ and SAK checking
+		 * here because otherwise the break
+		 * may get masked by ignore_status_mask
+		 * or read_status_mask.
+		 */
+		if (uart_handle_break(&up->port))
+			return;
+
+	}
+
+	if (lsr & UART_LSR_PE) {
+		flag = TTY_PARITY;
+		up->port.icount.parity++;
+	}
+
+	if (lsr & UART_LSR_FE) {
+		flag = TTY_FRAME;
+		up->port.icount.frame++;
+	}
+
+	if (lsr & UART_LSR_OE)
+		up->port.icount.overrun++;
+
+#ifdef CONFIG_SERIAL_OMAP_CONSOLE
+	if (up->port.line == up->port.cons->index) {
+		/* Recover the break flag from console xmit */
+		lsr |= up->lsr_break_flag;
+	}
+#endif
+	uart_insert_char(&up->port, lsr, UART_LSR_OE, 0, flag);
+}
+
+static void serial_omap_rdi(struct uart_omap_port *up, unsigned int lsr)
+{
+	unsigned char ch = 0;
+	unsigned int flag;
+
+	if (!(lsr & UART_LSR_DR))
+		return;
+
+	ch = serial_in(up, UART_RX);
+	flag = TTY_NORMAL;
+	up->port.icount.rx++;
+
+	if (uart_handle_sysrq_char(&up->port, ch))
+		return;
+
+	uart_insert_char(&up->port, lsr, UART_LSR_OE, ch, flag);
+}
+
 /**
  * serial_omap_irq() - This handles the interrupt from one port
  * @irq: uart port irq number
@@ -350,54 +344,57 @@ static unsigned int check_modem_status(struct uart_omap_port *up)
 static inline irqreturn_t serial_omap_irq(int irq, void *dev_id)
 {
 	struct uart_omap_port *up = dev_id;
+	struct tty_struct *tty = up->port.state->port.tty;
 	unsigned int iir, lsr;
 	unsigned int type;
 	unsigned long flags;
 	irqreturn_t ret = IRQ_NONE;
+	int max_count = 256;
 
 	spin_lock_irqsave(&up->port.lock, flags);
 	pm_runtime_get_sync(up->dev);
-	iir = serial_in(up, UART_IIR);
-again:
-	if (iir & UART_IIR_NO_INT)
-		goto out;
 
-	ret = IRQ_HANDLED;
-	lsr = serial_in(up, UART_LSR);
+	do {
+		iir = serial_in(up, UART_IIR);
+		if (iir & UART_IIR_NO_INT)
+			break;
 
-	/* extract IRQ type from IIR register */
-	type = iir & 0x3e;
+		ret = IRQ_HANDLED;
+		lsr = serial_in(up, UART_LSR);
 
-	switch (type) {
-	case UART_IIR_MSI:
-		check_modem_status(up);
-		break;
-	case UART_IIR_THRI:
-		if (lsr & UART_LSR_THRE)
-			transmit_chars(up);
-		break;
-	case UART_IIR_RDI:
-		if (lsr & UART_LSR_DR)
-			receive_chars(up, &lsr);
-		break;
-	case UART_IIR_RLSI:
-		if (lsr & UART_LSR_BRK_ERROR_BITS)
-			receive_chars(up, &lsr);
-		break;
-	case UART_IIR_RX_TIMEOUT:
-		receive_chars(up, &lsr);
-		break;
-	case UART_IIR_CTS_RTS_DSR:
-		iir = serial_in(up, UART_IIR);
-		goto again;
-	case UART_IIR_XOFF:
-		/* FALLTHROUGH */
-	default:
-		break;
-	}
+		/* extract IRQ type from IIR register */
+		type = iir & 0x3e;
+
+		switch (type) {
+		case UART_IIR_MSI:
+			check_modem_status(up);
+			break;
+		case UART_IIR_THRI:
+			if (lsr & UART_LSR_THRE)
+				transmit_chars(up);
+			break;
+		case UART_IIR_RX_TIMEOUT:
+			/* FALLTHROUGH */
+		case UART_IIR_RDI:
+			serial_omap_rdi(up, lsr);
+			break;
+		case UART_IIR_RLSI:
+			serial_omap_rlsi(up, lsr);
+			break;
+		case UART_IIR_CTS_RTS_DSR:
+			/* simply try again */
+			break;
+		case UART_IIR_XOFF:
+			/* FALLTHROUGH */
+		default:
+			break;
+		}
+	} while (!(iir & UART_IIR_NO_INT) && max_count--);
 
-out:
 	spin_unlock_irqrestore(&up->port.lock, flags);
+
+	tty_flip_buffer_push(tty);
+
 	pm_runtime_mark_last_busy(up->dev);
 	pm_runtime_put_autosuspend(up->dev);
 	up->port_activity = jiffies;
-- 
1.7.12.rc3


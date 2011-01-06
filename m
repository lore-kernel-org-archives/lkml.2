Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab1AFWX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:23:56 -0500
Received: from kroah.org ([198.145.64.141]:55685 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564Ab1AFWXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:23:54 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 25/36] 8250: add a UPIO_DWAPB32 for 32 bit accesses
Date: Thu,  6 Jan 2011 14:23:14 -0800
Message-Id: <1294352605-31906-25-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jamie Iles <jamie@jamieiles.com>

Some platforms contain a Synopsys DesignWare APB UART that is attached
to a 32-bit APB bus where sub-word accesses are not allowed. Add a new
IO type (UPIO_DWAPB32) that performs 32 bit acccesses to the UART.

v2:
	- don't test for 32 bit in the output fast path, provide a
	  separate dwabp32_serial_out() function. Refactor
	  dwabp_serial_out() so that we can reuse the LCR saving
	  code.
v3:
	- rebased on top of "8250: use container_of() instead of
	  casting"

Signed-off-by: Jamie Iles <jamie@jamieiles.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/8250.c        |   51 ++++++++++++++++++++++++++++++++----------
 drivers/serial/serial_core.c |    2 +
 include/linux/serial_core.h  |    1 +
 3 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 0b4ce47..9839199 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -454,22 +454,40 @@ static void tsi_serial_out(struct uart_port *p, int offset, int value)
 		writeb(value, p->membase + offset);
 }
 
+/* Save the LCR value so it can be re-written when a Busy Detect IRQ occurs. */
+static inline void dwapb_save_out_value(struct uart_port *p, int offset,
+					int value)
+{
+	struct uart_8250_port *up =
+		container_of(p, struct uart_8250_port, port);
+
+	if (offset == UART_LCR)
+		up->lcr = value;
+}
+
+/* Read the IER to ensure any interrupt is cleared before returning from ISR. */
+static inline void dwapb_check_clear_ier(struct uart_port *p, int offset)
+{
+	if (offset == UART_TX || offset == UART_IER)
+		p->serial_in(p, UART_IER);
+}
+
 static void dwapb_serial_out(struct uart_port *p, int offset, int value)
 {
 	int save_offset = offset;
 	offset = map_8250_out_reg(p, offset) << p->regshift;
-	/* Save the LCR value so it can be re-written when a
-	 * Busy Detect interrupt occurs. */
-	if (save_offset == UART_LCR) {
-		struct uart_8250_port *up =
-			container_of(p, struct uart_8250_port, port);
-		up->lcr = value;
-	}
+	dwapb_save_out_value(p, save_offset, value);
 	writeb(value, p->membase + offset);
-	/* Read the IER to ensure any interrupt is cleared before
-	 * returning from ISR. */
-	if (save_offset == UART_TX || save_offset == UART_IER)
-		value = p->serial_in(p, UART_IER);
+	dwapb_check_clear_ier(p, save_offset);
+}
+
+static void dwapb32_serial_out(struct uart_port *p, int offset, int value)
+{
+	int save_offset = offset;
+	offset = map_8250_out_reg(p, offset) << p->regshift;
+	dwapb_save_out_value(p, save_offset, value);
+	writel(value, p->membase + offset);
+	dwapb_check_clear_ier(p, save_offset);
 }
 
 static unsigned int io_serial_in(struct uart_port *p, int offset)
@@ -520,6 +538,11 @@ static void set_io_from_upio(struct uart_port *p)
 		p->serial_out = dwapb_serial_out;
 		break;
 
+	case UPIO_DWAPB32:
+		p->serial_in = mem32_serial_in;
+		p->serial_out = dwapb32_serial_out;
+		break;
+
 	default:
 		p->serial_in = io_serial_in;
 		p->serial_out = io_serial_out;
@@ -538,6 +561,7 @@ serial_out_sync(struct uart_8250_port *up, int offset, int value)
 	case UPIO_MEM32:
 	case UPIO_AU:
 	case UPIO_DWAPB:
+	case UPIO_DWAPB32:
 		p->serial_out(p, offset, value);
 		p->serial_in(p, UART_LCR);	/* safe, no side-effects */
 		break;
@@ -1587,7 +1611,8 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 			handled = 1;
 
 			end = NULL;
-		} else if (up->port.iotype == UPIO_DWAPB &&
+		} else if ((up->port.iotype == UPIO_DWAPB ||
+			    up->port.iotype == UPIO_DWAPB32) &&
 			  (iir & UART_IIR_BUSY) == UART_IIR_BUSY) {
 			/* The DesignWare APB UART has an Busy Detect (0x07)
 			 * interrupt meaning an LCR write attempt occured while the
@@ -2492,6 +2517,7 @@ static int serial8250_request_std_resource(struct uart_8250_port *up)
 	case UPIO_MEM32:
 	case UPIO_MEM:
 	case UPIO_DWAPB:
+	case UPIO_DWAPB32:
 		if (!up->port.mapbase)
 			break;
 
@@ -2529,6 +2555,7 @@ static void serial8250_release_std_resource(struct uart_8250_port *up)
 	case UPIO_MEM32:
 	case UPIO_MEM:
 	case UPIO_DWAPB:
+	case UPIO_DWAPB32:
 		if (!up->port.mapbase)
 			break;
 
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index c4ea146..2835e29 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2135,6 +2135,7 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
 	case UPIO_AU:
 	case UPIO_TSI:
 	case UPIO_DWAPB:
+	case UPIO_DWAPB32:
 		snprintf(address, sizeof(address),
 			 "MMIO 0x%llx", (unsigned long long)port->mapbase);
 		break;
@@ -2555,6 +2556,7 @@ int uart_match_port(struct uart_port *port1, struct uart_port *port2)
 	case UPIO_AU:
 	case UPIO_TSI:
 	case UPIO_DWAPB:
+	case UPIO_DWAPB32:
 		return (port1->mapbase == port2->mapbase);
 	}
 	return 0;
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 9ff9b7d..7a6daf1 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -314,6 +314,7 @@ struct uart_port {
 #define UPIO_TSI		(5)			/* Tsi108/109 type IO */
 #define UPIO_DWAPB		(6)			/* DesignWare APB UART */
 #define UPIO_RM9000		(7)			/* RM9000 type IO */
+#define UPIO_DWAPB32		(8)			/* DesignWare APB UART (32 bit accesses) */
 
 	unsigned int		read_status_mask;	/* driver specific */
 	unsigned int		ignore_status_mask;	/* driver specific */
-- 
1.7.3.2


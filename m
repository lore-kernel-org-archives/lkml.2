Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab2LCLRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 06:17:14 -0500
Received: from mga03.intel.com ([143.182.124.21]:53155 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013Ab2LCLQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 06:16:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,205,1355126400"; 
   d="scan'208";a="175377286"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@linux.intel.com>, Jamie Iles <jamie@jamieiles.com>,
        linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 5/5] serial: 8250_dw: Set FIFO size dynamically
Date: Mon,  3 Dec 2012 13:17:59 +0200
Message-Id: <1354533479-27306-6-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354533479-27306-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1354533479-27306-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Designware UART provides optional Component Parameter
Register that lists most of the capabilities of the UART,
including FIFO size. This uses that register to set FIFO
size for the port before registering it.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/tty/serial/8250/8250_dw.c |   57 ++++++++++++++++++++++++++++++++++---
 1 file changed, 53 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index c4e28df..e834d41 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -25,6 +25,28 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
+/* Offsets for the DesignWare specific registers */
+#define DW_UART_USR	0x1f /* UART Status Register */
+#define DW_UART_CPR	0xf4 /* Component Parameter Register */
+#define DW_UART_UCV	0xf8 /* UART Component Version */
+
+/* Component Parameter Register bits */
+#define DW_UART_CPR_ABP_DATA_WIDTH	(3 << 0)
+#define DW_UART_CPR_AFCE_MODE		(1 << 4)
+#define DW_UART_CPR_THRE_MODE		(1 << 5)
+#define DW_UART_CPR_SIR_MODE		(1 << 6)
+#define DW_UART_CPR_SIR_LP_MODE		(1 << 7)
+#define DW_UART_CPR_ADDITIONAL_FEATURES	(1 << 8)
+#define DW_UART_CPR_FIFO_ACCESS		(1 << 9)
+#define DW_UART_CPR_FIFO_STAT		(1 << 10)
+#define DW_UART_CPR_SHADOW		(1 << 11)
+#define DW_UART_CPR_ENCODED_PARMS	(1 << 12)
+#define DW_UART_CPR_DMA_EXTRA		(1 << 13)
+#define DW_UART_CPR_FIFO_MODE		(0xff << 16)
+/* Helper for fifo size calculation */
+#define DW_UART_CPR_FIFO_SIZE(a)	(((a >> 16) & 0xff) * 16)
+
+
 struct dw8250_data {
 	int	last_lcr;
 	int	line;
@@ -66,9 +88,6 @@ static unsigned int dw8250_serial_in32(struct uart_port *p, int offset)
 	return readl(p->membase + offset);
 }
 
-/* Offset for the DesignWare's UART Status Register. */
-#define UART_USR	0x1f
-
 static int dw8250_handle_irq(struct uart_port *p)
 {
 	struct dw8250_data *d = p->private_data;
@@ -78,7 +97,7 @@ static int dw8250_handle_irq(struct uart_port *p)
 		return 1;
 	} else if ((iir & UART_IIR_BUSY) == UART_IIR_BUSY) {
 		/* Clear the USR and write the LCR again. */
-		(void)p->serial_in(p, UART_USR);
+		(void)p->serial_in(p, DW_UART_USR);
 		p->serial_out(p, d->last_lcr, UART_LCR);
 
 		return 1;
@@ -119,6 +138,34 @@ static int dw8250_probe_of(struct uart_port *p)
 	return 0;
 }
 
+static void dw8250_setup_port(struct uart_8250_port *up)
+{
+	struct uart_port	*p = &up->port;
+	u32			reg = readl(p->membase + DW_UART_UCV);
+
+	/*
+	 * If the Component Version Register returns zero, we know that
+	 * ADDITIONAL_FEATURES are not enabled. No need to go any further.
+	 */
+	if (!reg)
+		return;
+
+	dev_dbg_ratelimited(p->dev, "Designware UART version %c.%c%c\n",
+		(reg >> 24) & 0xff, (reg >> 16) & 0xff, (reg >> 8) & 0xff);
+
+	reg = readl(p->membase + DW_UART_CPR);
+	if (!reg)
+		return;
+
+	/* Select the type based on fifo */
+	if (reg & DW_UART_CPR_FIFO_MODE) {
+		p->type = PORT_16550A;
+		p->flags |= UPF_FIXED_TYPE;
+		p->fifosize = DW_UART_CPR_FIFO_SIZE(reg);
+		up->tx_loadsz = p->fifosize;
+	}
+}
+
 static int dw8250_probe(struct platform_device *pdev)
 {
 	struct uart_8250_port uart = {};
@@ -156,6 +203,8 @@ static int dw8250_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	dw8250_setup_port(&uart);
+
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
-- 
1.7.10.4


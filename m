Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab1ASD0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 22:26:31 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23690 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab1ASD03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 22:26:29 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6230"; a="70813647"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: davidb@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, rlove@google.com,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 2/2] serial: msm: Add support for UARTDM cores
Date: Tue, 18 Jan 2011 19:26:25 -0800
Message-Id: <1295407585-18386-1-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the next-generation version of the MSM UART
to the msm_serial driver. This version of the hardware is
similar to the original version, but has some DMA
capabilities that are used in PIO mode in this driver.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 drivers/serial/msm_serial.c |  289 +++++++++++++++++++++++++++++++++++++------
 drivers/serial/msm_serial.h |   28 ++++-
 2 files changed, 274 insertions(+), 43 deletions(-)

diff --git a/drivers/serial/msm_serial.c b/drivers/serial/msm_serial.c
index 8e43a7b..5027415 100644
--- a/drivers/serial/msm_serial.c
+++ b/drivers/serial/msm_serial.c
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2007 Google, Inc.
  * Author: Robert Love <rlove@google.com>
+ * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -31,6 +32,7 @@
 #include <linux/serial.h>
 #include <linux/clk.h>
 #include <linux/platform_device.h>
+#include <linux/delay.h>

 #include "msm_serial.h"

@@ -38,9 +40,20 @@ struct msm_port {
 	struct uart_port	uart;
 	char			name[16];
 	struct clk		*clk;
+	struct clk		*pclk;
 	unsigned int		imr;
+	unsigned int            *gsbi_base;
+	int			is_dm;
+	unsigned int		old_snap_state;
 };

+static inline void wait_for_xmitr(struct uart_port *port, int bits)
+{
+	if (!(msm_read(port, UART_SR) & UART_SR_TX_EMPTY))
+		while ((msm_read(port, UART_ISR) & bits) != bits)
+			cpu_relax();
+}
+
 static void msm_stop_tx(struct uart_port *port)
 {
 	struct msm_port *msm_port = UART_TO_MSM(port);
@@ -73,6 +86,68 @@ static void msm_enable_ms(struct uart_port *port)
 	msm_write(port, msm_port->imr, UART_IMR);
 }

+static void handle_rx_dm(struct uart_port *port, unsigned int misr)
+{
+	struct tty_struct *tty = port->state->port.tty;
+	unsigned int sr;
+	int count = 0;
+	struct msm_port *msm_port = UART_TO_MSM(port);
+
+	if ((msm_read(port, UART_SR) & UART_SR_OVERRUN)) {
+		port->icount.overrun++;
+		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+		msm_write(port, UART_CR_CMD_RESET_ERR, UART_CR);
+	}
+
+	if (misr & UART_IMR_RXSTALE) {
+		count = msm_read(port, UARTDM_RX_TOTAL_SNAP) -
+			msm_port->old_snap_state;
+		msm_port->old_snap_state = 0;
+	} else {
+		count = 4 * (msm_read(port, UART_RFWR));
+		msm_port->old_snap_state += count;
+	}
+
+	while (count > 0) {
+		unsigned int c;
+		char flag = TTY_NORMAL;
+
+		sr = msm_read(port, UART_SR);
+		if ((sr & UART_SR_RX_READY) == 0) {
+			msm_port->old_snap_state -= count;
+			break;
+		}
+		c = msm_read(port, UARTDM_RF);
+		if (sr & UART_SR_RX_BREAK) {
+			port->icount.brk++;
+			if (uart_handle_break(port))
+				continue;
+		} else if (sr & UART_SR_PAR_FRAME_ERR) {
+			port->icount.frame++;
+		} else {
+			port->icount.rx++;
+		}
+
+		/* Mask conditions we're ignorning. */
+		sr &= port->read_status_mask;
+		if (sr & UART_SR_RX_BREAK)
+			flag = TTY_BREAK;
+		else if (sr & UART_SR_PAR_FRAME_ERR)
+			flag = TTY_FRAME;
+
+		/* TODO: handle sysrq */
+		tty_insert_flip_string(tty, (char *) &c,
+				       (count > 4) ? 4 : count);
+		count -= 4;
+	}
+
+	tty_flip_buffer_push(tty);
+	if (misr & (UART_IMR_RXSTALE))
+		msm_write(port, UART_CR_CMD_RESET_STALE_INT, UART_CR);
+	msm_write(port, 0xFFFFFF, UARTDM_DMRX);
+	msm_write(port, UART_CR_CMD_STALE_EVENT_ENABLE, UART_CR);
+}
+
 static void handle_rx(struct uart_port *port)
 {
 	struct tty_struct *tty = port->state->port.tty;
@@ -121,6 +196,12 @@ static void handle_rx(struct uart_port *port)
 	tty_flip_buffer_push(tty);
 }

+static void reset_dm_count(struct uart_port *port)
+{
+	wait_for_xmitr(port, UART_ISR_TX_READY);
+	msm_write(port, 1, UARTDM_NCF_TX);
+}
+
 static void handle_tx(struct uart_port *port)
 {
 	struct circ_buf *xmit = &port->state->xmit;
@@ -128,11 +209,18 @@ static void handle_tx(struct uart_port *port)
 	int sent_tx;

 	if (port->x_char) {
-		msm_write(port, port->x_char, UART_TF);
+		if (msm_port->is_dm)
+			reset_dm_count(port);
+
+		msm_write(port, port->x_char,
+			  msm_port->is_dm ? UARTDM_TF : UART_TF);
 		port->icount.tx++;
 		port->x_char = 0;
 	}

+	if (msm_port->is_dm)
+		reset_dm_count(port);
+
 	while (msm_read(port, UART_SR) & UART_SR_TX_READY) {
 		if (uart_circ_empty(xmit)) {
 			/* disable tx interrupts */
@@ -140,8 +228,11 @@ static void handle_tx(struct uart_port *port)
 			msm_write(port, msm_port->imr, UART_IMR);
 			break;
 		}
+		msm_write(port, xmit->buf[xmit->tail],
+			  msm_port->is_dm ? UARTDM_TF : UART_TF);

-		msm_write(port, xmit->buf[xmit->tail], UART_TF);
+		if (msm_port->is_dm)
+			reset_dm_count(port);

 		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
 		port->icount.tx++;
@@ -169,8 +260,12 @@ static irqreturn_t msm_irq(int irq, void *dev_id)
 	misr = msm_read(port, UART_MISR);
 	msm_write(port, 0, UART_IMR); /* disable interrupt */

-	if (misr & (UART_IMR_RXLEV | UART_IMR_RXSTALE))
-		handle_rx(port);
+	if (misr & (UART_IMR_RXLEV | UART_IMR_RXSTALE)) {
+		if (msm_port->is_dm)
+			handle_rx_dm(port, misr);
+		else
+			handle_rx(port);
+	}
 	if (misr & UART_IMR_TXLEV)
 		handle_tx(port);
 	if (misr & UART_IMR_DELTA_CTS)
@@ -192,10 +287,21 @@ static unsigned int msm_get_mctrl(struct uart_port *port)
 	return TIOCM_CAR | TIOCM_CTS | TIOCM_DSR | TIOCM_RTS;
 }

-static void msm_set_mctrl(struct uart_port *port, unsigned int mctrl)
+
+static void msm_reset(struct uart_port *port)
 {
-	unsigned int mr;
+	/* reset everything */
+	msm_write(port, UART_CR_CMD_RESET_RX, UART_CR);
+	msm_write(port, UART_CR_CMD_RESET_TX, UART_CR);
+	msm_write(port, UART_CR_CMD_RESET_ERR, UART_CR);
+	msm_write(port, UART_CR_CMD_RESET_BREAK_INT, UART_CR);
+	msm_write(port, UART_CR_CMD_RESET_CTS, UART_CR);
+	msm_write(port, UART_CR_CMD_SET_RFR, UART_CR);
+}

+void msm_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+	unsigned int mr;
 	mr = msm_read(port, UART_MR1);

 	if (!(mctrl & TIOCM_RTS)) {
@@ -219,6 +325,7 @@ static void msm_break_ctl(struct uart_port *port, int break_ctl)
 static int msm_set_baud_rate(struct uart_port *port, unsigned int baud)
 {
 	unsigned int baud_code, rxstale, watermark;
+	struct msm_port *msm_port = UART_TO_MSM(port);

 	switch (baud) {
 	case 300:
@@ -273,6 +380,9 @@ static int msm_set_baud_rate(struct uart_port *port, unsigned int baud)
 		break;
 	}

+	if (msm_port->is_dm)
+		msm_write(port, UART_CR_CMD_RESET_RX, UART_CR);
+
 	msm_write(port, baud_code, UART_CSR);

 	/* RX stale watermark */
@@ -288,25 +398,23 @@ static int msm_set_baud_rate(struct uart_port *port, unsigned int baud)
 	/* set TX watermark */
 	msm_write(port, 10, UART_TFWR);

+	if (msm_port->is_dm) {
+		msm_write(port, UART_CR_CMD_RESET_STALE_INT, UART_CR);
+		msm_write(port, 0xFFFFFF, UARTDM_DMRX);
+		msm_write(port, UART_CR_CMD_STALE_EVENT_ENABLE, UART_CR);
+	}
+
 	return baud;
 }

-static void msm_reset(struct uart_port *port)
-{
-	/* reset everything */
-	msm_write(port, UART_CR_CMD_RESET_RX, UART_CR);
-	msm_write(port, UART_CR_CMD_RESET_TX, UART_CR);
-	msm_write(port, UART_CR_CMD_RESET_ERR, UART_CR);
-	msm_write(port, UART_CR_CMD_RESET_BREAK_INT, UART_CR);
-	msm_write(port, UART_CR_CMD_RESET_CTS, UART_CR);
-	msm_write(port, UART_CR_CMD_SET_RFR, UART_CR);
-}

 static void msm_init_clock(struct uart_port *port)
 {
 	struct msm_port *msm_port = UART_TO_MSM(port);

 	clk_enable(msm_port->clk);
+	if (msm_port->pclk)
+		clk_enable(msm_port->pclk);
 	msm_serial_set_mnd_regs(port);
 }

@@ -347,15 +455,32 @@ static int msm_startup(struct uart_port *port)
 		msm_write(port, data, UART_IPR);
 	}

-	msm_reset(port);
+	data = 0;
+	if ((!port->cons) ||
+	    (port->cons && (!(port->cons->flags & CON_ENABLED)))) {
+		msm_write(port, UART_CR_CMD_PROTECTION_EN, UART_CR);
+		msm_reset(port);
+		data = UART_CR_TX_ENABLE;
+	}
+
+	data |= UART_CR_RX_ENABLE;
+	msm_write(port, data, UART_CR);	/* enable TX & RX */

-	msm_write(port, 0x05, UART_CR);	/* enable TX & RX */
+	/* Make sure IPR is not 0 to start with*/
+	if (msm_port->is_dm)
+		msm_write(port, UART_IPR_STALE_LSB, UART_IPR);

 	/* turn on RX and CTS interrupts */
 	msm_port->imr = UART_IMR_RXLEV | UART_IMR_RXSTALE |
 			UART_IMR_CURRENT_CTS;
-	msm_write(port, msm_port->imr, UART_IMR);

+	if (msm_port->is_dm) {
+		msm_write(port, 0xFFFFFF, UARTDM_DMRX);
+		msm_write(port, UART_CR_CMD_RESET_STALE_INT, UART_CR);
+		msm_write(port, UART_CR_CMD_STALE_EVENT_ENABLE, UART_CR);
+	}
+
+	msm_write(port, msm_port->imr, UART_IMR);
 	return 0;
 }

@@ -384,7 +509,7 @@ static void msm_set_termios(struct uart_port *port, struct ktermios *termios,
 	baud = msm_set_baud_rate(port, baud);
 	if (tty_termios_baud_rate(termios))
 		tty_termios_encode_baud_rate(termios, baud, baud);
-
+
 	/* calculate parity */
 	mr = msm_read(port, UART_MR2);
 	mr &= ~UART_MR2_PARITY_MODE;
@@ -454,48 +579,105 @@ static const char *msm_type(struct uart_port *port)
 static void msm_release_port(struct uart_port *port)
 {
 	struct platform_device *pdev = to_platform_device(port->dev);
-	struct resource *resource;
+	struct msm_port *msm_port = UART_TO_MSM(port);
+	struct resource *uart_resource;
+	struct resource *gsbi_resource;
 	resource_size_t size;

-	resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (unlikely(!resource))
+	uart_resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (unlikely(!uart_resource))
 		return;
-	size = resource->end - resource->start + 1;
+	size = uart_resource->end - uart_resource->start + 1;

 	release_mem_region(port->mapbase, size);
 	iounmap(port->membase);
 	port->membase = NULL;
+
+	if (msm_port->gsbi_base) {
+		iowrite32(GSBI_PROTOCOL_IDLE, msm_port->gsbi_base +
+			  GSBI_CONTROL);
+
+		gsbi_resource = platform_get_resource_byname(pdev,
+							     IORESOURCE_MEM,
+							     "gsbi_resource");
+
+		if (unlikely(!gsbi_resource))
+			return;
+
+		size = gsbi_resource->end - gsbi_resource->start + 1;
+		release_mem_region(gsbi_resource->start, size);
+		iounmap(msm_port->gsbi_base);
+		msm_port->gsbi_base = NULL;
+	}
 }

 static int msm_request_port(struct uart_port *port)
 {
+	struct msm_port *msm_port = UART_TO_MSM(port);
 	struct platform_device *pdev = to_platform_device(port->dev);
-	struct resource *resource;
+	struct resource *uart_resource;
+	struct resource *gsbi_resource;
 	resource_size_t size;
+	int ret;

-	resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (unlikely(!resource))
+	uart_resource = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						     "uart_resource");
+	if (unlikely(!uart_resource))
 		return -ENXIO;
-	size = resource->end - resource->start + 1;
+
+	size = uart_resource->end - uart_resource->start + 1;

 	if (unlikely(!request_mem_region(port->mapbase, size, "msm_serial")))
 		return -EBUSY;

 	port->membase = ioremap(port->mapbase, size);
 	if (!port->membase) {
-		release_mem_region(port->mapbase, size);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto fail_release_port;
+	}
+
+	gsbi_resource = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						     "gsbi_resource");
+	/* Is this a GSBI-based port? */
+	if (gsbi_resource) {
+		size = gsbi_resource->end - gsbi_resource->start + 1;
+
+		if (unlikely(!request_mem_region(gsbi_resource->start, size,
+						 "msm_serial"))) {
+			ret = -EBUSY;
+			goto fail_release_port;
+		}
+
+		msm_port->gsbi_base = ioremap(gsbi_resource->start, size);
+		if (!msm_port->gsbi_base) {
+			ret = -EBUSY;
+			goto fail_release_gsbi;
+		}
 	}

 	return 0;
+
+fail_release_gsbi:
+	release_mem_region(gsbi_resource->start, size);
+fail_release_port:
+	release_mem_region(port->mapbase, size);
+	return ret;
 }

 static void msm_config_port(struct uart_port *port, int flags)
 {
+	struct msm_port *msm_port = UART_TO_MSM(port);
+	int ret;
 	if (flags & UART_CONFIG_TYPE) {
 		port->type = PORT_MSM;
-		msm_request_port(port);
+		ret = msm_request_port(port);
+		if (ret)
+			return;
 	}
+
+	if (msm_port->is_dm)
+		iowrite32(GSBI_PROTOCOL_UART, msm_port->gsbi_base +
+			  GSBI_CONTROL);
 }

 static int msm_verify_port(struct uart_port *port, struct serial_struct *ser)
@@ -515,9 +697,13 @@ static void msm_power(struct uart_port *port, unsigned int state,
 	switch (state) {
 	case 0:
 		clk_enable(msm_port->clk);
+		if (msm_port->pclk)
+			clk_enable(msm_port->pclk);
 		break;
 	case 3:
 		clk_disable(msm_port->clk);
+		if (msm_port->pclk)
+			clk_disable(msm_port->pclk);
 		break;
 	default:
 		printk(KERN_ERR "msm_serial: Unknown PM state %d\n", state);
@@ -550,7 +736,7 @@ static struct msm_port msm_uart_ports[] = {
 			.iotype = UPIO_MEM,
 			.ops = &msm_uart_pops,
 			.flags = UPF_BOOT_AUTOCONF,
-			.fifosize = 512,
+			.fifosize = 64,
 			.line = 0,
 		},
 	},
@@ -559,7 +745,7 @@ static struct msm_port msm_uart_ports[] = {
 			.iotype = UPIO_MEM,
 			.ops = &msm_uart_pops,
 			.flags = UPF_BOOT_AUTOCONF,
-			.fifosize = 512,
+			.fifosize = 64,
 			.line = 1,
 		},
 	},
@@ -585,9 +771,14 @@ static inline struct uart_port *get_port_from_line(unsigned int line)

 static void msm_console_putchar(struct uart_port *port, int c)
 {
+	struct msm_port *msm_port = UART_TO_MSM(port);
+
+	if (msm_port->is_dm)
+		reset_dm_count(port);
+
 	while (!(msm_read(port, UART_SR) & UART_SR_TX_READY))
 		;
-	msm_write(port, c, UART_TF);
+	msm_write(port, c, msm_port->is_dm ? UARTDM_TF : UART_TF);
 }

 static void msm_console_write(struct console *co, const char *s,
@@ -609,12 +800,14 @@ static void msm_console_write(struct console *co, const char *s,
 static int __init msm_console_setup(struct console *co, char *options)
 {
 	struct uart_port *port;
+	struct msm_port *msm_port;
 	int baud, flow, bits, parity;

 	if (unlikely(co->index >= UART_NR || co->index < 0))
 		return -ENXIO;

 	port = get_port_from_line(co->index);
+	msm_port = UART_TO_MSM(port);

 	if (unlikely(!port->membase))
 		return -ENXIO;
@@ -638,6 +831,11 @@ static int __init msm_console_setup(struct console *co, char *options)

 	msm_reset(port);

+	if (msm_port->is_dm) {
+		msm_write(port, UART_CR_CMD_PROTECTION_EN, UART_CR);
+		msm_write(port, UART_CR_TX_ENABLE, UART_CR);
+	}
+
 	printk(KERN_INFO "msm_serial: console setup on port #%d\n", port->line);

 	return uart_set_options(port, co, baud, parity, bits, flow);
@@ -685,14 +883,31 @@ static int __init msm_serial_probe(struct platform_device *pdev)
 	port->dev = &pdev->dev;
 	msm_port = UART_TO_MSM(port);

-	msm_port->clk = clk_get(&pdev->dev, "uart_clk");
-	if (IS_ERR(msm_port->clk))
+	if (platform_get_resource_byname(pdev, IORESOURCE_MEM, "gsbi_resource"))
+		msm_port->is_dm = 1;
+	else
+		msm_port->is_dm = 0;
+
+	if (msm_port->is_dm) {
+		msm_port->clk = clk_get(&pdev->dev, "gsbi_uart_clk");
+		msm_port->pclk = clk_get(&pdev->dev, "gsbi_pclk");
+	} else {
+		msm_port->clk = clk_get(&pdev->dev, "uart_clk");
+		msm_port->pclk = NULL;
+	}
+
+	if (unlikely(IS_ERR(msm_port->clk) || IS_ERR(msm_port->pclk)))
 		return PTR_ERR(msm_port->clk);
+
+	if (msm_port->is_dm)
+		clk_set_rate(msm_port->clk, 7372800);
+
 	port->uartclk = clk_get_rate(msm_port->clk);
 	printk(KERN_INFO "uartclk = %d\n", port->uartclk);


-	resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	resource = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						     "uart_resource");
 	if (unlikely(!resource))
 		return -ENXIO;
 	port->mapbase = resource->start;
diff --git a/drivers/serial/msm_serial.h b/drivers/serial/msm_serial.h
index f6ca9ca..9b8dc5d 100644
--- a/drivers/serial/msm_serial.h
+++ b/drivers/serial/msm_serial.h
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2007 Google, Inc.
  * Author: Robert Love <rlove@google.com>
+ * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -54,6 +55,7 @@
 #define UART_CSR_300	0x22

 #define UART_TF		0x000C
+#define UARTDM_TF	0x0070

 #define UART_CR				0x0010
 #define UART_CR_CMD_NULL		(0 << 4)
@@ -64,14 +66,17 @@
 #define UART_CR_CMD_START_BREAK		(5 << 4)
 #define UART_CR_CMD_STOP_BREAK		(6 << 4)
 #define UART_CR_CMD_RESET_CTS		(7 << 4)
+#define UART_CR_CMD_RESET_STALE_INT	(8 << 4)
 #define UART_CR_CMD_PACKET_MODE		(9 << 4)
 #define UART_CR_CMD_MODE_RESET		(12 << 4)
 #define UART_CR_CMD_SET_RFR		(13 << 4)
 #define UART_CR_CMD_RESET_RFR		(14 << 4)
+#define UART_CR_CMD_PROTECTION_EN	(16 << 4)
+#define UART_CR_CMD_STALE_EVENT_ENABLE	(80 << 4)
 #define UART_CR_TX_DISABLE		(1 << 3)
-#define UART_CR_TX_ENABLE		(1 << 3)
-#define UART_CR_RX_DISABLE		(1 << 3)
-#define UART_CR_RX_ENABLE		(1 << 3)
+#define UART_CR_TX_ENABLE		(1 << 2)
+#define UART_CR_RX_DISABLE		(1 << 1)
+#define UART_CR_RX_ENABLE		(1 << 0)

 #define UART_IMR		0x0014
 #define UART_IMR_TXLEV		(1 << 0)
@@ -110,9 +115,20 @@
 #define UART_SR_RX_FULL		(1 << 1)
 #define UART_SR_RX_READY	(1 << 0)

-#define UART_RF		0x000C
-#define UART_MISR	0x0010
-#define UART_ISR	0x0014
+#define UART_RF			0x000C
+#define UARTDM_RF		0x0070
+#define UART_MISR		0x0010
+#define UART_ISR		0x0014
+#define UART_ISR_TX_READY	(1 << 7)
+
+#define GSBI_CONTROL		0x0
+#define GSBI_PROTOCOL_CODE	0x30
+#define GSBI_PROTOCOL_UART	0x40
+#define GSBI_PROTOCOL_IDLE	0x0
+
+#define UARTDM_DMRX		0x34
+#define UARTDM_NCF_TX		0x40
+#define UARTDM_RX_TOTAL_SNAP	0x38

 #define UART_TO_MSM(uart_port)	((struct msm_port *) uart_port)

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


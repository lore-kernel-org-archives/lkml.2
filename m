Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab0KHA7E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 19:59:04 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46882 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0KHA7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 19:59:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cqJDVg8mKpzlkTiBrYwpCkHTA5E4mf2Fd6RGW/7CgbubmCeDSnqbXELDUhva9NuHoB
         Dk0BdEI9u4Naszg/mg/j+odc/bf3wKqmxJSclmiQLYLwDqdQvp75gKWhyyUD61ED6d/Q
         K7Y00Anl58QY9bCytKACEiA4KB3dmcGzjQFAw=
Date: Mon, 8 Nov 2010 03:58:53 +0300
From: Alexey Charkov <alchark@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Alexey Charkov <alchark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Greg Kroah-Hartman <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Feng Tang <feng.tang@intel.com>,
        Tobias Klauser <tklauser@distanz.ch>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6 v3] serial: Add support for UART on VIA VT8500 and
 compatibles
Message-ID: <20101108005853.GA21872@alchark-u3s.lan>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com>
 <1289147348-31969-2-git-send-email-alchark@gmail.com>
 <20101107230801.5214f353@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107230801.5214f353@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a driver for the serial ports found in VIA and WonderMedia
Systems-on-Chip. Interrupt-driven FIFO operation is implemented.
The hardware also supports pure register-based operation (which is
slower) and DMA-based FIFO operation. As the FIFOs are only 16 bytes
long, DMA operation is probably not worth the hassle.

Signed-off-by: Alexey Charkov <alchark@gmail.com>
---

Thanks for the comments, Alan! Hopefully, I've fixed the issues in a right
way.

Best regards,
Alexey

 drivers/serial/Kconfig         |   10 +
 drivers/serial/Makefile        |    1 +
 drivers/serial/vt8500_serial.c |  647 ++++++++++++++++++++++++++++++++++++++++
 include/linux/serial_core.h    |    3 +
 4 files changed, 661 insertions(+), 0 deletions(-)
 create mode 100644 drivers/serial/vt8500_serial.c

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index aff9dcd..6e76a59 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -1381,6 +1381,16 @@ config SERIAL_MSM_CONSOLE
 	depends on SERIAL_MSM=y
 	select SERIAL_CORE_CONSOLE
 
+config SERIAL_VT8500
+	bool "VIA VT8500 on-chip serial port support"
+	depends on ARM && ARCH_VT8500
+	select SERIAL_CORE
+
+config SERIAL_VT8500_CONSOLE
+	bool "VIA VT8500 serial console support"
+	depends on SERIAL_VT8500=y
+	select SERIAL_CORE_CONSOLE
+
 config SERIAL_NETX
 	tristate "NetX serial port support"
 	depends on ARM && ARCH_NETX
diff --git a/drivers/serial/Makefile b/drivers/serial/Makefile
index c570576..86b8587 100644
--- a/drivers/serial/Makefile
+++ b/drivers/serial/Makefile
@@ -86,6 +86,7 @@ obj-$(CONFIG_SERIAL_TIMBERDALE)	+= timbuart.o
 obj-$(CONFIG_SERIAL_GRLIB_GAISLER_APBUART) += apbuart.o
 obj-$(CONFIG_SERIAL_ALTERA_JTAGUART) += altera_jtaguart.o
 obj-$(CONFIG_SERIAL_ALTERA_UART) += altera_uart.o
+obj-$(CONFIG_SERIAL_VT8500) += vt8500_serial.o
 obj-$(CONFIG_SERIAL_MRST_MAX3110)	+= mrst_max3110.o
 obj-$(CONFIG_SERIAL_MFD_HSU)	+= mfd.o
 obj-$(CONFIG_SERIAL_OMAP) += omap-serial.o
diff --git a/drivers/serial/vt8500_serial.c b/drivers/serial/vt8500_serial.c
new file mode 100644
index 0000000..9eaf36e
--- /dev/null
+++ b/drivers/serial/vt8500_serial.c
@@ -0,0 +1,647 @@
+/*
+ * drivers/serial/vt8500_serial.c
+ *
+ * Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
+ *
+ * Based on msm_serial.c, which is:
+ * Copyright (C) 2007 Google, Inc.
+ * Author: Robert Love <rlove@google.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#if defined(CONFIG_SERIAL_VT8500_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
+# define SUPPORT_SYSRQ
+#endif
+
+#include <linux/hrtimer.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/irq.h>
+#include <linux/init.h>
+#include <linux/console.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
+#include <linux/serial_core.h>
+#include <linux/serial.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/platform_device.h>
+
+/*
+ * UART Register offsets
+ */
+
+#define VT8500_URTDR		0x0000	/* Transmit data */
+#define VT8500_URRDR		0x0004	/* Receive data */
+#define VT8500_URDIV		0x0008	/* Clock/Baud rate divisor */
+#define VT8500_URLCR		0x000C	/* Line control */
+#define VT8500_URICR		0x0010	/* IrDA control */
+#define VT8500_URIER		0x0014	/* Interrupt enable */
+#define VT8500_URISR		0x0018	/* Interrupt status */
+#define VT8500_URUSR		0x001c	/* UART status */
+#define VT8500_URFCR		0x0020	/* FIFO control */
+#define VT8500_URFIDX		0x0024	/* FIFO index */
+#define VT8500_URBKR		0x0028	/* Break signal count */
+#define VT8500_URTOD		0x002c	/* Time out divisor */
+#define VT8500_TXFIFO		0x1000	/* Transmit FIFO (16x8) */
+#define VT8500_RXFIFO		0x1020	/* Receive FIFO (16x10) */
+
+/*
+ * Interrupt enable and status bits
+ */
+
+#define TXDE	(1 << 0)	/* Tx Data empty */
+#define RXDF	(1 << 1)	/* Rx Data full */
+#define TXFAE	(1 << 2)	/* Tx FIFO almost empty */
+#define TXFE	(1 << 3)	/* Tx FIFO empty */
+#define RXFAF	(1 << 4)	/* Rx FIFO almost full */
+#define RXFF	(1 << 5)	/* Rx FIFO full */
+#define TXUDR	(1 << 6)	/* Tx underrun */
+#define RXOVER	(1 << 7)	/* Rx overrun */
+#define PER	(1 << 8)	/* Parity error */
+#define FER	(1 << 9)	/* Frame error */
+#define TCTS	(1 << 10)	/* Toggle of CTS */
+#define RXTOUT	(1 << 11)	/* Rx timeout */
+#define BKDONE	(1 << 12)	/* Break signal done */
+#define ERR	(1 << 13)	/* AHB error response */
+
+#define RX_FIFO_INTS	(RXFAF | RXFF | RXOVER | PER | FER | RXTOUT)
+#define TX_FIFO_INTS	(TXFAE | TXFE | TXUDR)
+
+struct vt8500_port {
+	struct uart_port	uart;
+	char			name[16];
+	struct clk		*clk;
+	unsigned int		ier;
+};
+
+static inline void vt8500_write(struct uart_port *port, unsigned int val,
+			     unsigned int off)
+{
+	writel(val, port->membase + off);
+}
+
+static inline unsigned int vt8500_read(struct uart_port *port, unsigned int off)
+{
+	return readl(port->membase + off);
+}
+
+static void vt8500_stop_tx(struct uart_port *port)
+{
+	struct vt8500_port *vt8500_port = container_of(port,
+						       struct vt8500_port,
+						       uart);
+
+	vt8500_port->ier &= ~TX_FIFO_INTS;
+	vt8500_write(port, vt8500_port->ier, VT8500_URIER);
+}
+
+static void vt8500_stop_rx(struct uart_port *port)
+{
+	struct vt8500_port *vt8500_port = container_of(port,
+						       struct vt8500_port,
+						       uart);
+
+	vt8500_port->ier &= ~RX_FIFO_INTS;
+	vt8500_write(port, vt8500_port->ier, VT8500_URIER);
+}
+
+static void vt8500_enable_ms(struct uart_port *port)
+{
+	struct vt8500_port *vt8500_port = container_of(port,
+						       struct vt8500_port,
+						       uart);
+
+	vt8500_port->ier |= TCTS;
+	vt8500_write(port, vt8500_port->ier, VT8500_URIER);
+}
+
+static void handle_rx(struct uart_port *port)
+{
+	struct tty_struct *tty = tty_port_tty_get(&port->state->port);
+	if (!tty) {
+		/* Discard data: no tty available */
+		int count = (vt8500_read(port, VT8500_URFIDX) & 0x1f00) >> 8;
+		u16 ch;
+		while (count--)
+			ch = readw(port->membase + VT8500_RXFIFO);
+		return;
+	}
+
+	/*
+	 * Handle overrun
+	 */
+	if ((vt8500_read(port, VT8500_URISR) & RXOVER)) {
+		port->icount.overrun++;
+		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+	}
+
+	/* and now the main RX loop */
+	while (vt8500_read(port, VT8500_URFIDX) & 0x1f00) {
+		unsigned int c;
+		char flag = TTY_NORMAL;
+
+		c = readw(port->membase + VT8500_RXFIFO) & 0x3ff;
+
+		/* Mask conditions we're ignorning. */
+		c &= ~port->read_status_mask;
+
+		if (c & FER) {
+			port->icount.frame++;
+			flag = TTY_FRAME;
+		} else if (c & PER) {
+			port->icount.parity++;
+			flag = TTY_PARITY;
+		}
+		port->icount.rx++;
+
+		if (!uart_handle_sysrq_char(port, c))
+			tty_insert_flip_char(tty, c, flag);
+	}
+
+	tty_flip_buffer_push(tty);
+	tty_kref_put(tty);
+}
+
+static void handle_tx(struct uart_port *port)
+{
+	struct circ_buf *xmit = &port->state->xmit;
+
+	if (port->x_char) {
+		writeb(port->x_char, port->membase + VT8500_TXFIFO);
+		port->icount.tx++;
+		port->x_char = 0;
+	}
+	if (uart_circ_empty(xmit) || uart_tx_stopped(port)) {
+		vt8500_stop_tx(port);
+		return;
+	}
+
+	while ((vt8500_read(port, VT8500_URFIDX) & 0x1f) < 16) {
+		if (uart_circ_empty(xmit))
+			break;
+
+		writeb(xmit->buf[xmit->tail], port->membase + VT8500_TXFIFO);
+
+		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
+		port->icount.tx++;
+	}
+
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
+		uart_write_wakeup(port);
+
+	if (uart_circ_empty(xmit))
+		vt8500_stop_tx(port);
+}
+
+static void vt8500_start_tx(struct uart_port *port)
+{
+	struct vt8500_port *vt8500_port = container_of(port,
+						       struct vt8500_port,
+						       uart);
+
+	vt8500_port->ier &= ~TX_FIFO_INTS;
+	vt8500_write(port, vt8500_port->ier, VT8500_URIER);
+	handle_tx(port);
+	vt8500_port->ier |= TX_FIFO_INTS;
+	vt8500_write(port, vt8500_port->ier, VT8500_URIER);
+}
+
+static void handle_delta_cts(struct uart_port *port)
+{
+	port->icount.cts++;
+	wake_up_interruptible(&port->state->port.delta_msr_wait);
+}
+
+static irqreturn_t vt8500_irq(int irq, void *dev_id)
+{
+	struct uart_port *port = dev_id;
+	unsigned long isr;
+
+	spin_lock(&port->lock);
+	isr = vt8500_read(port, VT8500_URISR);
+
+	/* Acknowledge active status bits */
+	vt8500_write(port, isr, VT8500_URISR);
+
+	if (isr & RX_FIFO_INTS)
+		handle_rx(port);
+	if (isr & TX_FIFO_INTS)
+		handle_tx(port);
+	if (isr & TCTS)
+		handle_delta_cts(port);
+
+	spin_unlock(&port->lock);
+
+	return IRQ_HANDLED;
+}
+
+static unsigned int vt8500_tx_empty(struct uart_port *port)
+{
+	return (vt8500_read(port, VT8500_URFIDX) & 0x1f) < 16 ?
+						TIOCSER_TEMT : 0;
+}
+
+static unsigned int vt8500_get_mctrl(struct uart_port *port)
+{
+	unsigned int usr;
+
+	usr = vt8500_read(port, VT8500_URUSR);
+	if (usr & (1 << 4))
+		return TIOCM_CTS;
+	else
+		return 0;
+}
+
+static void vt8500_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+}
+
+static void vt8500_break_ctl(struct uart_port *port, int break_ctl)
+{
+	if (break_ctl)
+		vt8500_write(port, vt8500_read(port, VT8500_URLCR) | (1 << 9),
+			     VT8500_URLCR);
+}
+
+static int vt8500_set_baud_rate(struct uart_port *port, unsigned int baud)
+{
+	unsigned long div;
+	unsigned int loops = 1000;
+
+	div = vt8500_read(port, VT8500_URDIV) & ~(0x3ff);
+
+	if (unlikely((baud < 900) || (baud > 921600)))
+		div |= 7;
+	else
+		div |= (921600 / baud) - 1;
+
+	while ((vt8500_read(port, VT8500_URUSR) & (1 << 5)) && --loops)
+		cpu_relax();
+	vt8500_write(port, div, VT8500_URDIV);
+
+	return baud;
+}
+
+static int vt8500_startup(struct uart_port *port)
+{
+	struct vt8500_port *vt8500_port =
+			container_of(port, struct vt8500_port, uart);
+	int ret;
+
+	snprintf(vt8500_port->name, sizeof(vt8500_port->name),
+		 "vt8500_serial%d", port->line);
+
+	ret = request_irq(port->irq, vt8500_irq, IRQF_TRIGGER_HIGH,
+			  vt8500_port->name, port);
+	if (unlikely(ret))
+		return ret;
+
+	vt8500_write(port, 0x03, VT8500_URLCR);	/* enable TX & RX */
+
+	return 0;
+}
+
+static void vt8500_shutdown(struct uart_port *port)
+{
+	struct vt8500_port *vt8500_port =
+			container_of(port, struct vt8500_port, uart);
+
+	vt8500_port->ier = 0;
+
+	/* disable interrupts and FIFOs */
+	vt8500_write(&vt8500_port->uart, 0, VT8500_URIER);
+	vt8500_write(&vt8500_port->uart, 0x880, VT8500_URFCR);
+	free_irq(port->irq, port);
+}
+
+static void vt8500_set_termios(struct uart_port *port,
+			       struct ktermios *termios,
+			       struct ktermios *old)
+{
+	struct vt8500_port *vt8500_port =
+			container_of(port, struct vt8500_port, uart);
+	unsigned long flags;
+	unsigned int baud, lcr;
+	unsigned int loops = 1000;
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	/* calculate and set baud rate */
+	baud = uart_get_baud_rate(port, termios, old, 900, 921600);
+	baud = vt8500_set_baud_rate(port, baud);
+	if (tty_termios_baud_rate(termios))
+		tty_termios_encode_baud_rate(termios, baud, baud);
+
+	/* calculate parity */
+	lcr = vt8500_read(&vt8500_port->uart, VT8500_URLCR);
+	lcr &= ~((1 << 5) | (1 << 4));
+	if (termios->c_cflag & PARENB) {
+		lcr |= (1 << 4);
+		termios->c_cflag &= ~CMSPAR;
+		if (termios->c_cflag & PARODD)
+			lcr |= (1 << 5);
+	}
+
+	/* calculate bits per char */
+	lcr &= ~(1 << 2);
+	switch (termios->c_cflag & CSIZE) {
+	case CS7:
+		break;
+	case CS8:
+	default:
+		lcr |= (1 << 2);
+		termios->c_cflag &= ~CSIZE;
+		termios->c_cflag |= CS8;
+		break;
+	}
+
+	/* calculate stop bits */
+	lcr &= ~(1 << 3);
+	if (termios->c_cflag & CSTOPB)
+		lcr |= (1 << 3);
+
+	/* set parity, bits per char, and stop bit */
+	vt8500_write(&vt8500_port->uart, lcr, VT8500_URLCR);
+
+	/* Configure status bits to ignore based on termio flags. */
+	port->read_status_mask = 0;
+	if (termios->c_iflag & IGNPAR)
+		port->read_status_mask = FER | PER;
+
+	uart_update_timeout(port, termios->c_cflag, baud);
+
+	/* Reset FIFOs */
+	vt8500_write(&vt8500_port->uart, 0x88c, VT8500_URFCR);
+	while ((vt8500_read(&vt8500_port->uart, VT8500_URFCR) & 0xc)
+							&& --loops)
+		cpu_relax();
+
+	/* Every possible FIFO-related interrupt */
+	vt8500_port->ier = RX_FIFO_INTS | TX_FIFO_INTS;
+
+	/*
+	 * CTS flow control
+	 */
+	if (UART_ENABLE_MS(&vt8500_port->uart, termios->c_cflag))
+		vt8500_port->ier |= TCTS;
+
+	vt8500_write(&vt8500_port->uart, 0x881, VT8500_URFCR);
+	vt8500_write(&vt8500_port->uart, vt8500_port->ier, VT8500_URIER);
+
+	spin_unlock_irqrestore(&port->lock, flags);
+}
+
+static const char *vt8500_type(struct uart_port *port)
+{
+	struct vt8500_port *vt8500_port =
+			container_of(port, struct vt8500_port, uart);
+	return vt8500_port->name;
+}
+
+static void vt8500_release_port(struct uart_port *port)
+{
+}
+
+static int vt8500_request_port(struct uart_port *port)
+{
+	return 0;
+}
+
+static void vt8500_config_port(struct uart_port *port, int flags)
+{
+	port->type = PORT_VT8500;
+}
+
+static int vt8500_verify_port(struct uart_port *port,
+			      struct serial_struct *ser)
+{
+	if (unlikely(ser->type != PORT_UNKNOWN && ser->type != PORT_VT8500))
+		return -EINVAL;
+	if (unlikely(port->irq != ser->irq))
+		return -EINVAL;
+	return 0;
+}
+
+static struct vt8500_port *vt8500_uart_ports[4];
+static struct uart_driver vt8500_uart_driver;
+
+#ifdef CONFIG_SERIAL_VT8500_CONSOLE
+
+static inline void wait_for_xmitr(struct uart_port *port)
+{
+	unsigned int status, tmout = 10000;
+
+	/* Wait up to 10ms for the character(s) to be sent. */
+	do {
+		status = vt8500_read(port, VT8500_URFIDX);
+
+		if (--tmout == 0)
+			break;
+		udelay(1);
+	} while (status & 0x10);
+}
+
+static void vt8500_console_putchar(struct uart_port *port, int c)
+{
+	wait_for_xmitr(port);
+	writeb(c, port->membase + VT8500_TXFIFO);
+}
+
+static void vt8500_console_write(struct console *co, const char *s,
+			      unsigned int count)
+{
+	struct vt8500_port *vt8500_port = vt8500_uart_ports[co->index];
+	unsigned long ier;
+
+	BUG_ON(co->index < 0 || co->index >= vt8500_uart_driver.nr);
+
+	ier = vt8500_read(&vt8500_port->uart, VT8500_URIER);
+	vt8500_write(&vt8500_port->uart, VT8500_URIER, 0);
+
+	uart_console_write(&vt8500_port->uart, s, count,
+			   vt8500_console_putchar);
+
+	/*
+	 *	Finally, wait for transmitter to become empty
+	 *	and switch back to FIFO
+	 */
+	wait_for_xmitr(&vt8500_port->uart);
+	vt8500_write(&vt8500_port->uart, VT8500_URIER, ier);
+}
+
+static int __init vt8500_console_setup(struct console *co, char *options)
+{
+	struct vt8500_port *vt8500_port;
+	int baud = 9600;
+	int bits = 8;
+	int parity = 'n';
+	int flow = 'n';
+
+	if (unlikely(co->index >= vt8500_uart_driver.nr || co->index < 0))
+		return -ENXIO;
+
+	vt8500_port = vt8500_uart_ports[co->index];
+
+	if (!vt8500_port)
+		return -ENODEV;
+
+	if (options)
+		uart_parse_options(options, &baud, &parity, &bits, &flow);
+
+	return uart_set_options(&vt8500_port->uart,
+				 co, baud, parity, bits, flow);
+}
+
+static struct console vt8500_console = {
+	.name = "ttyS",
+	.write = vt8500_console_write,
+	.device = uart_console_device,
+	.setup = vt8500_console_setup,
+	.flags = CON_PRINTBUFFER,
+	.index = -1,
+	.data = &vt8500_uart_driver,
+};
+
+#define VT8500_CONSOLE	(&vt8500_console)
+
+#else
+#define VT8500_CONSOLE	NULL
+#endif
+
+static struct uart_ops vt8500_uart_pops = {
+	.tx_empty	= vt8500_tx_empty,
+	.set_mctrl	= vt8500_set_mctrl,
+	.get_mctrl	= vt8500_get_mctrl,
+	.stop_tx	= vt8500_stop_tx,
+	.start_tx	= vt8500_start_tx,
+	.stop_rx	= vt8500_stop_rx,
+	.enable_ms	= vt8500_enable_ms,
+	.break_ctl	= vt8500_break_ctl,
+	.startup	= vt8500_startup,
+	.shutdown	= vt8500_shutdown,
+	.set_termios	= vt8500_set_termios,
+	.type		= vt8500_type,
+	.release_port	= vt8500_release_port,
+	.request_port	= vt8500_request_port,
+	.config_port	= vt8500_config_port,
+	.verify_port	= vt8500_verify_port,
+};
+
+static struct uart_driver vt8500_uart_driver = {
+	.owner		= THIS_MODULE,
+	.driver_name	= "vt8500_serial",
+	.dev_name	= "ttyWMT",
+	.cons		= VT8500_CONSOLE,
+};
+
+static int __init vt8500_serial_probe(struct platform_device *pdev)
+{
+	struct vt8500_port *vt8500_port;
+	struct resource *mmres, *irqres;
+	int ret;
+
+	mmres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	irqres = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!mmres || !irqres)
+		return -ENODEV;
+
+	vt8500_port = kzalloc(sizeof(struct vt8500_port), GFP_KERNEL);
+	if (!vt8500_port)
+		return -ENOMEM;
+
+	vt8500_port->uart.type = PORT_VT8500;
+	vt8500_port->uart.iotype = UPIO_MEM;
+	vt8500_port->uart.mapbase = mmres->start;
+	vt8500_port->uart.irq = irqres->start;
+	vt8500_port->uart.fifosize = 16;
+	vt8500_port->uart.ops = &vt8500_uart_pops;
+	vt8500_port->uart.line = pdev->id;
+	vt8500_port->uart.dev = &pdev->dev;
+	vt8500_port->uart.flags = UPF_IOREMAP | UPF_BOOT_AUTOCONF;
+	vt8500_port->uart.uartclk = 24000000;
+
+	snprintf(vt8500_port->name, sizeof(vt8500_port->name),
+		 "VT8500 UART%d", pdev->id);
+
+	vt8500_port->uart.membase = ioremap(mmres->start,
+					    mmres->end - mmres->start + 1);
+	if (!vt8500_port->uart.membase) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	vt8500_uart_ports[pdev->id] = vt8500_port;
+
+	uart_add_one_port(&vt8500_uart_driver, &vt8500_port->uart);
+
+	platform_set_drvdata(pdev, vt8500_port);
+
+	return 0;
+
+err:
+	kfree(vt8500_port);
+	return ret;
+}
+
+static int __devexit vt8500_serial_remove(struct platform_device *pdev)
+{
+	struct vt8500_port *vt8500_port = platform_get_drvdata(pdev);
+
+	platform_set_drvdata(pdev, NULL);
+	uart_remove_one_port(&vt8500_uart_driver, &vt8500_port->uart);
+	kfree(vt8500_port);
+
+	return 0;
+}
+
+static struct platform_driver vt8500_platform_driver = {
+	.probe  = vt8500_serial_probe,
+	.remove = vt8500_serial_remove,
+	.driver = {
+		.name = "vt8500_serial",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init vt8500_serial_init(void)
+{
+	int ret;
+
+	ret = uart_register_driver(&vt8500_uart_driver);
+	if (unlikely(ret))
+		return ret;
+
+	ret = platform_driver_register(&vt8500_platform_driver);
+
+	if (unlikely(ret))
+		uart_unregister_driver(&vt8500_uart_driver);
+
+	return ret;
+}
+
+static void __exit vt8500_serial_exit(void)
+{
+#ifdef CONFIG_SERIAL_VT8500_CONSOLE
+	unregister_console(&vt8500_console);
+#endif
+	platform_driver_unregister(&vt8500_platform_driver);
+	uart_unregister_driver(&vt8500_uart_driver);
+}
+
+module_init(vt8500_serial_init);
+module_exit(vt8500_serial_exit);
+
+MODULE_AUTHOR("Alexey Charkov <alchark@gmail.com>");
+MODULE_DESCRIPTION("Driver for vt8500 serial device");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 212eb4c..41603d6 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -199,6 +199,9 @@
 /* TI OMAP-UART */
 #define PORT_OMAP	96
 
+/* VIA VT8500 SoC */
+#define PORT_VT8500	97
+
 #ifdef __KERNEL__
 
 #include <linux/compiler.h>
-- 
1.7.3.2


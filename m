Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab1J1D2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 23:28:51 -0400
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:34471 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab1J1D2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 23:28:47 -0400
From: Barry Song <Barry.Song@csr.com>
To: <torvalds@linux-foundation.org>
CC: <alan@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-serial@vger.kernel.org>,
        <workgroup.linux@csr.com>, Rong Wang <Rong.Wang@csr.com>,
        Linus Walleij <linus.walleij@linaro.org>, Bin Shi <Bin.Shi@csr.com>,
        Barry Song <Baohua.Song@csr.com>
Subject: [PATCH] UART: add CSR SiRFprimaII SoC on-chip uart drivers
Date: Thu, 27 Oct 2011 20:27:33 -0700
Message-ID: <1319772453-1275-1-git-send-email-Barry.Song@csr.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.125.36.58]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rong Wang <Rong.Wang@csr.com>

SiRFprimaII is the latest generation application processor from CSR’s
multi-function SoC product family.
The SoC support codes are in arch/arm/mach-prima2 from Linux mainline
3.0.

There are three dedicated UARTs in system. This patch adds basic driver
support for them.

It has used the newest pinmux subsystem from Linus Walleij.

Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Rong Wang <Rong.Wang@csr.com>
Signed-off-by: Bin Shi <Bin.Shi@csr.com>
Signed-off-by: Barry Song <Baohua.Song@csr.com>
Acked-by: Alan Cox <alan@linux.intel.com>
---
 note:
 this patch depends on Linus W's newest pinctrl subsystem, so it was not
 gone through tty tree. Linus W suggested me to send the patch to you
 directly.

 drivers/tty/serial/Kconfig        |   21 +
 drivers/tty/serial/Makefile       |    1 +
 drivers/tty/serial/sirfsoc_uart.c |  783 +++++++++++++++++++++++++++++++++++++
 drivers/tty/serial/sirfsoc_uart.h |  185 +++++++++
 4 files changed, 990 insertions(+), 0 deletions(-)
 create mode 100644 drivers/tty/serial/sirfsoc_uart.c
 create mode 100644 drivers/tty/serial/sirfsoc_uart.h

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 5f479da..c1e4d09 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -535,6 +535,27 @@ config SERIAL_S5PV210
 	help
 	  Serial port support for Samsung's S5P Family of SoC's
 
+config SERIAL_SIRFSOC
+        tristate "SiRF SoC Platform Serial port support"
+        depends on ARM && ARCH_PRIMA2
+        select SERIAL_CORE
+        help
+          Support for the on-chip UART on the CSR SiRFprimaII series,
+          providing /dev/ttyS0, 1 and 2 (note, some machines may not
+          provide all of these ports, depending on how the serial port
+          pins are configured.
+
+config SERIAL_SIRFSOC_CONSOLE
+        bool "Support for console on SiRF SoC serial port"
+        depends on SERIAL_SIRFSOC=y
+        select SERIAL_CORE_CONSOLE
+        help
+          Even if you say Y here, the currently visible virtual console
+          (/dev/tty0) will still be used as the system console by default, but
+          you can alter that using a kernel command line option such as
+          "console=ttySiRFx". (Try "man bootparam" or see the documentation of
+          your boot loader about how to pass options to the kernel at
+          boot time.)
 
 config SERIAL_MAX3100
 	tristate "MAX3100 support"
diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
index e10cf5b..af57089 100644
--- a/drivers/tty/serial/Makefile
+++ b/drivers/tty/serial/Makefile
@@ -94,3 +94,4 @@ obj-$(CONFIG_SERIAL_MSM_SMD)	+= msm_smd_tty.o
 obj-$(CONFIG_SERIAL_MXS_AUART) += mxs-auart.o
 obj-$(CONFIG_SERIAL_LANTIQ)	+= lantiq.o
 obj-$(CONFIG_SERIAL_XILINX_PS_UART) += xilinx_uartps.o
+obj-$(CONFIG_SERIAL_SIRFSOC) += sirfsoc_uart.o
diff --git a/drivers/tty/serial/sirfsoc_uart.c b/drivers/tty/serial/sirfsoc_uart.c
new file mode 100644
index 0000000..a60523f
--- /dev/null
+++ b/drivers/tty/serial/sirfsoc_uart.c
@@ -0,0 +1,783 @@
+/*
+ * Driver for CSR SiRFprimaII onboard UARTs.
+ *
+ * Copyright (c) 2011 Cambridge Silicon Radio Limited, a CSR plc group company.
+ *
+ * Licensed under GPLv2 or later.
+ */
+
+#include <linux/module.h>
+#include <linux/ioport.h>
+#include <linux/platform_device.h>
+#include <linux/init.h>
+#include <linux/sysrq.h>
+#include <linux/console.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
+#include <linux/serial_core.h>
+#include <linux/serial.h>
+#include <linux/clk.h>
+#include <linux/of.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <asm/irq.h>
+#include <asm/mach/irq.h>
+#include <linux/pinctrl/pinmux.h>
+
+#include "sirfsoc_uart.h"
+
+static unsigned int
+sirfsoc_uart_pio_tx_chars(struct sirfsoc_uart_port *sirfport, int count);
+static unsigned int
+sirfsoc_uart_pio_rx_chars(struct uart_port *port, unsigned int max_rx_count);
+static struct uart_driver sirfsoc_uart_drv;
+
+static const struct sirfsoc_baudrate_to_regv baudrate_to_regv[] = {
+	{4000000, 2359296},
+	{3500000, 1310721},
+	{3000000, 1572865},
+	{2500000, 1245186},
+	{2000000, 1572866},
+	{1500000, 1245188},
+	{1152000, 1638404},
+	{1000000, 1572869},
+	{921600, 1114120},
+	{576000, 1245196},
+	{500000, 1245198},
+	{460800, 1572876},
+	{230400, 1310750},
+	{115200, 1310781},
+	{57600, 1310843},
+	{38400, 1114328},
+	{19200, 1114545},
+	{9600, 1114979},
+};
+
+static struct sirfsoc_uart_port sirfsoc_uart_ports[SIRFSOC_UART_NR] = {
+	[0] = {
+		.port = {
+			.iotype		= UPIO_MEM,
+			.flags		= UPF_BOOT_AUTOCONF,
+			.line		= 0,
+		},
+	},
+	[1] = {
+		.port = {
+			.iotype		= UPIO_MEM,
+			.flags		= UPF_BOOT_AUTOCONF,
+			.line		= 1,
+		},
+	},
+	[2] = {
+		.port = {
+			.iotype		= UPIO_MEM,
+			.flags		= UPF_BOOT_AUTOCONF,
+			.line		= 2,
+		},
+	},
+};
+
+static inline struct sirfsoc_uart_port *to_sirfport(struct uart_port *port)
+{
+	return container_of(port, struct sirfsoc_uart_port, port);
+}
+
+static inline unsigned int sirfsoc_uart_tx_empty(struct uart_port *port)
+{
+	unsigned long reg;
+	reg = rd_regl(port, SIRFUART_TX_FIFO_STATUS);
+	if (reg & SIRFUART_FIFOEMPTY_MASK(port))
+		return TIOCSER_TEMT;
+	else
+		return 0;
+}
+
+static unsigned int sirfsoc_uart_get_mctrl(struct uart_port *port)
+{
+	struct sirfsoc_uart_port *sirfport = to_sirfport(port);
+	if (!(sirfport->ms_enabled)) {
+		goto cts_asserted;
+	} else if (sirfport->hw_flow_ctrl) {
+		if (!(rd_regl(port, SIRFUART_AFC_CTRL) &
+						SIRFUART_CTS_IN_STATUS))
+			goto cts_asserted;
+		else
+			goto cts_deasserted;
+	}
+cts_deasserted:
+	return TIOCM_CAR | TIOCM_DSR;
+cts_asserted:
+	return TIOCM_CAR | TIOCM_DSR | TIOCM_CTS;
+}
+
+static void sirfsoc_uart_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+	struct sirfsoc_uart_port *sirfport = to_sirfport(port);
+	unsigned int assert = mctrl & TIOCM_RTS;
+	unsigned int val = assert ? SIRFUART_AFC_CTRL_RX_THD : 0x0;
+	unsigned int current_val;
+	if (sirfport->hw_flow_ctrl) {
+		current_val = rd_regl(port, SIRFUART_AFC_CTRL) & ~0xFF;
+		val |= current_val;
+		wr_regl(port, SIRFUART_AFC_CTRL, val);
+	}
+}
+
+static void sirfsoc_uart_stop_tx(struct uart_port *port)
+{
+	unsigned int regv;
+	regv = rd_regl(port, SIRFUART_INT_EN);
+	wr_regl(port, SIRFUART_INT_EN, regv & ~SIRFUART_TX_INT_EN);
+}
+
+void sirfsoc_uart_start_tx(struct uart_port *port)
+{
+	struct sirfsoc_uart_port *sirfport = to_sirfport(port);
+	unsigned long regv;
+	sirfsoc_uart_pio_tx_chars(sirfport, 1);
+	wr_regl(port, SIRFUART_TX_FIFO_OP, SIRFUART_TX_FIFO_START);
+	regv = rd_regl(port, SIRFUART_INT_EN);
+	wr_regl(port, SIRFUART_INT_EN, regv | SIRFUART_TX_INT_EN);
+}
+
+static void sirfsoc_uart_stop_rx(struct uart_port *port)
+{
+	unsigned long regv;
+	wr_regl(port, SIRFUART_RX_FIFO_OP, 0);
+	regv = rd_regl(port, SIRFUART_INT_EN);
+	wr_regl(port, SIRFUART_INT_EN, regv & ~SIRFUART_RX_IO_INT_EN);
+}
+
+static void sirfsoc_uart_disable_ms(struct uart_port *port)
+{
+	struct sirfsoc_uart_port *sirfport = to_sirfport(port);
+	unsigned long reg;
+	sirfport->ms_enabled = 0;
+	if (!sirfport->hw_flow_ctrl)
+		return;
+	reg = rd_regl(port, SIRFUART_AFC_CTRL);
+	wr_regl(port, SIRFUART_AFC_CTRL, reg & ~0x3FF);
+	reg = rd_regl(port, SIRFUART_INT_EN);
+	wr_regl(port, SIRFUART_INT_EN, reg & ~SIRFUART_CTS_INT_EN);
+}
+
+static void sirfsoc_uart_enable_ms(struct uart_port *port)
+{
+	struct sirfsoc_uart_port *sirfport = to_sirfport(port);
+	unsigned long reg;
+	unsigned long flg;
+	if (!sirfport->hw_flow_ctrl)
+		return;
+	flg = SIRFUART_AFC_RX_EN | SIRFUART_AFC_TX_EN;
+	reg = rd_regl(port, SIRFUART_AFC_CTRL);
+	wr_regl(port, SIRFUART_AFC_CTRL, reg | flg);
+	reg = rd_regl(port, SIRFUART_INT_EN);
+	wr_regl(port, SIRFUART_INT_EN, reg | SIRFUART_CTS_INT_EN);
+	uart_handle_cts_change(port,
+		!(rd_regl(port, SIRFUART_AFC_CTRL) & SIRFUART_CTS_IN_STATUS));
+	sirfport->ms_enabled = 1;
+}
+
+static void sirfsoc_uart_break_ctl(struct uart_port *port, int break_state)
+{
+	unsigned long ulcon = rd_regl(port, SIRFUART_LINE_CTRL);
+	if (break_state)
+		ulcon |= SIRFUART_SET_BREAK;
+	else
+		ulcon &= ~SIRFUART_SET_BREAK;
+	wr_regl(port, SIRFUART_LINE_CTRL, ulcon);
+}
+
+static unsigned int
+sirfsoc_uart_pio_rx_chars(struct uart_port *port, unsigned int max_rx_count)
+{
+	unsigned int ch, rx_count = 0;
+	struct tty_struct *tty;
+
+	tty = tty_port_tty_get(&port->state->port);
+	if (!tty)
+		return -ENODEV;
+
+	while (!(rd_regl(port, SIRFUART_RX_FIFO_STATUS) &
+					SIRFUART_FIFOEMPTY_MASK(port))) {
+		ch = rd_regl(port, SIRFUART_RX_FIFO_DATA) | SIRFUART_DUMMY_READ;
+		if (unlikely(uart_handle_sysrq_char(port, ch)))
+			continue;
+		uart_insert_char(port, 0, 0, ch, TTY_NORMAL);
+		rx_count++;
+		if (rx_count >= max_rx_count)
+			break;
+	}
+
+	port->icount.rx += rx_count;
+	tty_flip_buffer_push(tty);
+	tty_kref_put(tty);
+
+	return rx_count;
+}
+
+static unsigned int
+sirfsoc_uart_pio_tx_chars(struct sirfsoc_uart_port *sirfport, int count)
+{
+	struct uart_port *port = &sirfport->port;
+	struct circ_buf *xmit = &port->state->xmit;
+	unsigned int num_tx = 0;
+	while (!uart_circ_empty(xmit) &&
+		!(rd_regl(port, SIRFUART_TX_FIFO_STATUS) &
+					SIRFUART_FIFOFULL_MASK(port)) &&
+		count--) {
+		wr_regl(port, SIRFUART_TX_FIFO_DATA, xmit->buf[xmit->tail]);
+		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
+		port->icount.tx++;
+		num_tx++;
+	}
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
+		uart_write_wakeup(port);
+	return num_tx;
+}
+
+static irqreturn_t sirfsoc_uart_isr(int irq, void *dev_id)
+{
+	unsigned long intr_status;
+	unsigned long cts_status;
+	unsigned long flag = TTY_NORMAL;
+	struct sirfsoc_uart_port *sirfport = (struct sirfsoc_uart_port *)dev_id;
+	struct uart_port *port = &sirfport->port;
+	struct uart_state *state = port->state;
+	struct circ_buf *xmit = &port->state->xmit;
+	intr_status = rd_regl(port, SIRFUART_INT_STATUS);
+	wr_regl(port, SIRFUART_INT_STATUS, intr_status);
+	intr_status &= rd_regl(port, SIRFUART_INT_EN);
+	if (unlikely(intr_status & (SIRFUART_ERR_INT_STAT))) {
+		if (intr_status & SIRFUART_RXD_BREAK) {
+			if (uart_handle_break(port))
+				goto recv_char;
+			uart_insert_char(port, intr_status,
+					SIRFUART_RX_OFLOW, 0, TTY_BREAK);
+			return IRQ_HANDLED;
+		}
+		if (intr_status & SIRFUART_RX_OFLOW)
+			port->icount.overrun++;
+		if (intr_status & SIRFUART_FRM_ERR) {
+			port->icount.frame++;
+			flag = TTY_FRAME;
+		}
+		if (intr_status & SIRFUART_PARITY_ERR)
+			flag = TTY_PARITY;
+		wr_regl(port, SIRFUART_RX_FIFO_OP, SIRFUART_RX_FIFO_RESET);
+		wr_regl(port, SIRFUART_RX_FIFO_OP, 0);
+		wr_regl(port, SIRFUART_RX_FIFO_OP, SIRFUART_RX_FIFO_START);
+		intr_status &= port->read_status_mask;
+		uart_insert_char(port, intr_status,
+					SIRFUART_RX_OFLOW_INT, 0, flag);
+	}
+recv_char:
+	if (intr_status & SIRFUART_CTS_INT_EN) {
+		cts_status = !(rd_regl(port, SIRFUART_AFC_CTRL) &
+							SIRFUART_CTS_IN_STATUS);
+		if (cts_status != 0) {
+			uart_handle_cts_change(port, 1);
+		} else {
+			uart_handle_cts_change(port, 0);
+			wake_up_interruptible(&state->port.delta_msr_wait);
+		}
+	}
+	if (intr_status & SIRFUART_RX_IO_INT_EN)
+		sirfsoc_uart_pio_rx_chars(port, SIRFSOC_UART_IO_RX_MAX_CNT);
+	if (intr_status & SIRFUART_TX_INT_EN) {
+		if (uart_circ_empty(xmit) || uart_tx_stopped(port)) {
+			return IRQ_HANDLED;
+		} else {
+			sirfsoc_uart_pio_tx_chars(sirfport,
+					SIRFSOC_UART_IO_TX_REASONABLE_CNT);
+			if ((uart_circ_empty(xmit)) &&
+				(rd_regl(port, SIRFUART_TX_FIFO_STATUS) &
+						SIRFUART_FIFOEMPTY_MASK(port)))
+				sirfsoc_uart_stop_tx(port);
+		}
+	}
+	return IRQ_HANDLED;
+}
+
+static void sirfsoc_uart_start_rx(struct uart_port *port)
+{
+	unsigned long regv;
+	regv = rd_regl(port, SIRFUART_INT_EN);
+	wr_regl(port, SIRFUART_INT_EN, regv | SIRFUART_RX_IO_INT_EN);
+	wr_regl(port, SIRFUART_RX_FIFO_OP, SIRFUART_RX_FIFO_RESET);
+	wr_regl(port, SIRFUART_RX_FIFO_OP, 0);
+	wr_regl(port, SIRFUART_RX_FIFO_OP, SIRFUART_RX_FIFO_START);
+}
+
+static unsigned int
+sirfsoc_calc_sample_div(unsigned long baud_rate,
+			unsigned long ioclk_rate, unsigned long *setted_baud)
+{
+	unsigned long min_delta = ~0UL;
+	unsigned short sample_div;
+	unsigned int regv = 0;
+	unsigned long ioclk_div;
+	unsigned long baud_tmp;
+	int temp_delta;
+
+	for (sample_div = SIRF_MIN_SAMPLE_DIV;
+			sample_div <= SIRF_MAX_SAMPLE_DIV; sample_div++) {
+		ioclk_div = (ioclk_rate / (baud_rate * (sample_div + 1))) - 1;
+		if (ioclk_div > SIRF_IOCLK_DIV_MAX)
+			continue;
+		baud_tmp = ioclk_rate / ((ioclk_div + 1) * (sample_div + 1));
+		temp_delta = baud_tmp - baud_rate;
+		temp_delta = (temp_delta > 0) ? temp_delta : -temp_delta;
+		if (temp_delta < min_delta) {
+			regv = regv & (~SIRF_IOCLK_DIV_MASK);
+			regv = regv | ioclk_div;
+			regv = regv & (~SIRF_SAMPLE_DIV_MASK);
+			regv = regv | (sample_div << SIRF_SAMPLE_DIV_SHIFT);
+			min_delta = temp_delta;
+			*setted_baud = baud_tmp;
+		}
+	}
+	return regv;
+}
+
+static void sirfsoc_uart_set_termios(struct uart_port *port,
+				       struct ktermios *termios,
+				       struct ktermios *old)
+{
+	struct sirfsoc_uart_port *sirfport = to_sirfport(port);
+	unsigned long	ioclk_rate;
+	unsigned long	config_reg = 0;
+	unsigned long	baud_rate;
+	unsigned long	setted_baud;
+	unsigned long	flags;
+	unsigned long	ic;
+	unsigned int	clk_div_reg = 0;
+	unsigned long	temp_reg_val;
+	unsigned long	rx_time_out;
+	int		threshold_div;
+	int		temp;
+
+	ioclk_rate = 150000000;
+	switch (termios->c_cflag & CSIZE) {
+	default:
+	case CS8:
+		config_reg |= SIRFUART_DATA_BIT_LEN_8;
+		break;
+	case CS7:
+		config_reg |= SIRFUART_DATA_BIT_LEN_7;
+		break;
+	case CS6:
+		config_reg |= SIRFUART_DATA_BIT_LEN_6;
+		break;
+	case CS5:
+		config_reg |= SIRFUART_DATA_BIT_LEN_5;
+		break;
+	}
+	if (termios->c_cflag & CSTOPB)
+		config_reg |= SIRFUART_STOP_BIT_LEN_2;
+	baud_rate = uart_get_baud_rate(port, termios, old, 0, 4000000);
+	spin_lock_irqsave(&port->lock, flags);
+	port->read_status_mask = SIRFUART_RX_OFLOW_INT;
+	port->ignore_status_mask = 0;
+	/* read flags */
+	if (termios->c_iflag & INPCK)
+		port->read_status_mask |=
+			SIRFUART_FRM_ERR_INT | SIRFUART_PARITY_ERR_INT;
+	if (termios->c_iflag & (BRKINT | PARMRK))
+		port->read_status_mask |= SIRFUART_RXD_BREAK_INT;
+	/* ignore flags */
+	if (termios->c_iflag & IGNPAR)
+		port->ignore_status_mask |=
+			SIRFUART_FRM_ERR_INT | SIRFUART_PARITY_ERR_INT;
+	if ((termios->c_cflag & CREAD) == 0)
+		port->ignore_status_mask |= SIRFUART_DUMMY_READ;
+	/* enable parity if PARENB is set*/
+	if (termios->c_cflag & PARENB) {
+		if (termios->c_cflag & CMSPAR) {
+			if (termios->c_cflag & PARODD)
+				config_reg |= SIRFUART_STICK_BIT_MARK;
+			else
+				config_reg |= SIRFUART_STICK_BIT_SPACE;
+		} else if (termios->c_cflag & PARODD) {
+			config_reg |= SIRFUART_STICK_BIT_ODD;
+		} else {
+			config_reg |= SIRFUART_STICK_BIT_EVEN;
+		}
+	}
+	/* Hardware Flow Control Settings */
+	if (UART_ENABLE_MS(port, termios->c_cflag)) {
+		if (!sirfport->ms_enabled)
+			sirfsoc_uart_enable_ms(port);
+	} else {
+		if (sirfport->ms_enabled)
+			sirfsoc_uart_disable_ms(port);
+	}
+
+	/* common rate: fast calculation */
+	for (ic = 0; ic < SIRF_BAUD_RATE_SUPPORT_NR; ic++)
+		if (baud_rate == baudrate_to_regv[ic].baud_rate)
+			clk_div_reg = baudrate_to_regv[ic].reg_val;
+	setted_baud = baud_rate;
+	/* arbitary rate setting */
+	if (unlikely(clk_div_reg == 0))
+		clk_div_reg = sirfsoc_calc_sample_div(baud_rate, ioclk_rate,
+								&setted_baud);
+	wr_regl(port, SIRFUART_DIVISOR, clk_div_reg);
+
+	if (tty_termios_baud_rate(termios))
+		tty_termios_encode_baud_rate(termios, setted_baud, setted_baud);
+
+	/* set receive timeout */
+	rx_time_out = SIRFSOC_UART_RX_TIMEOUT(baud_rate, 20000);
+	rx_time_out = (rx_time_out > 0xFFFF) ? 0xFFFF : rx_time_out;
+	config_reg |= SIRFUART_RECV_TIMEOUT(rx_time_out);
+	temp_reg_val = rd_regl(port, SIRFUART_TX_FIFO_OP);
+	wr_regl(port, SIRFUART_RX_FIFO_OP, 0);
+	wr_regl(port, SIRFUART_TX_FIFO_OP,
+				temp_reg_val & ~SIRFUART_TX_FIFO_START);
+	wr_regl(port, SIRFUART_TX_DMA_IO_CTRL, SIRFUART_TX_MODE_IO);
+	wr_regl(port, SIRFUART_RX_DMA_IO_CTRL, SIRFUART_RX_MODE_IO);
+	wr_regl(port, SIRFUART_LINE_CTRL, config_reg);
+
+	/* Reset Rx/Tx FIFO Threshold level for proper baudrate */
+	if (baud_rate < 1000000)
+		threshold_div = 1;
+	else
+		threshold_div = 2;
+	temp = port->line == 1 ? 16 : 64;
+	wr_regl(port, SIRFUART_TX_FIFO_CTRL, temp / threshold_div);
+	wr_regl(port, SIRFUART_RX_FIFO_CTRL, temp / threshold_div);
+	temp_reg_val |= SIRFUART_TX_FIFO_START;
+	wr_regl(port, SIRFUART_TX_FIFO_OP, temp_reg_val);
+	uart_update_timeout(port, termios->c_cflag, baud_rate);
+	sirfsoc_uart_start_rx(port);
+	wr_regl(port, SIRFUART_TX_RX_EN, SIRFUART_TX_EN | SIRFUART_RX_EN);
+	spin_unlock_irqrestore(&port->lock, flags);
+}
+
+static void startup_uart_controller(struct uart_port *port)
+{
+	unsigned long temp_regv;
+	int temp;
+	temp_regv = rd_regl(port, SIRFUART_TX_DMA_IO_CTRL);
+	wr_regl(port, SIRFUART_TX_DMA_IO_CTRL, temp_regv | SIRFUART_TX_MODE_IO);
+	temp_regv = rd_regl(port, SIRFUART_RX_DMA_IO_CTRL);
+	wr_regl(port, SIRFUART_RX_DMA_IO_CTRL, temp_regv | SIRFUART_RX_MODE_IO);
+	wr_regl(port, SIRFUART_TX_DMA_IO_LEN, 0);
+	wr_regl(port, SIRFUART_RX_DMA_IO_LEN, 0);
+	wr_regl(port, SIRFUART_TX_RX_EN, SIRFUART_RX_EN | SIRFUART_TX_EN);
+	wr_regl(port, SIRFUART_TX_FIFO_OP, SIRFUART_TX_FIFO_RESET);
+	wr_regl(port, SIRFUART_TX_FIFO_OP, 0);
+	wr_regl(port, SIRFUART_RX_FIFO_OP, SIRFUART_RX_FIFO_RESET);
+	wr_regl(port, SIRFUART_RX_FIFO_OP, 0);
+	temp = port->line == 1 ? 16 : 64;
+	wr_regl(port, SIRFUART_TX_FIFO_CTRL, temp);
+	wr_regl(port, SIRFUART_RX_FIFO_CTRL, temp);
+}
+
+static int sirfsoc_uart_startup(struct uart_port *port)
+{
+	struct sirfsoc_uart_port *sirfport	= to_sirfport(port);
+	unsigned int index			= port->line;
+	int ret;
+	set_irq_flags(port->irq, IRQF_VALID | IRQF_NOAUTOEN);
+	ret = request_irq(port->irq,
+				sirfsoc_uart_isr,
+				0,
+				SIRFUART_PORT_NAME,
+				sirfport);
+	if (ret != 0) {
+		dev_err(port->dev, "UART%d request IRQ line (%d) failed.\n",
+							index, port->irq);
+		goto irq_err;
+	}
+	startup_uart_controller(port);
+	enable_irq(port->irq);
+irq_err:
+	return ret;
+}
+
+static void sirfsoc_uart_shutdown(struct uart_port *port)
+{
+	struct sirfsoc_uart_port *sirfport = to_sirfport(port);
+	wr_regl(port, SIRFUART_INT_EN, 0);
+	free_irq(port->irq, sirfport);
+	if (sirfport->ms_enabled) {
+		sirfsoc_uart_disable_ms(port);
+		sirfport->ms_enabled = 0;
+	}
+}
+
+static const char *sirfsoc_uart_type(struct uart_port *port)
+{
+	return port->type == SIRFSOC_PORT_TYPE ? SIRFUART_PORT_NAME : NULL;
+}
+
+static int sirfsoc_uart_request_port(struct uart_port *port)
+{
+	void *ret;
+	ret = request_mem_region(port->mapbase,
+				SIRFUART_MAP_SIZE, SIRFUART_PORT_NAME);
+	return ret ? 0 : -EBUSY;
+}
+
+static void sirfsoc_uart_release_port(struct uart_port *port)
+{
+	release_mem_region(port->mapbase, SIRFUART_MAP_SIZE);
+}
+
+static void sirfsoc_uart_config_port(struct uart_port *port, int flags)
+{
+	if (flags & UART_CONFIG_TYPE) {
+		port->type = SIRFSOC_PORT_TYPE;
+		sirfsoc_uart_request_port(port);
+	}
+}
+
+static struct uart_ops sirfsoc_uart_ops = {
+	.tx_empty	= sirfsoc_uart_tx_empty,
+	.get_mctrl	= sirfsoc_uart_get_mctrl,
+	.set_mctrl	= sirfsoc_uart_set_mctrl,
+	.stop_tx	= sirfsoc_uart_stop_tx,
+	.start_tx	= sirfsoc_uart_start_tx,
+	.stop_rx	= sirfsoc_uart_stop_rx,
+	.enable_ms	= sirfsoc_uart_enable_ms,
+	.break_ctl	= sirfsoc_uart_break_ctl,
+	.startup	= sirfsoc_uart_startup,
+	.shutdown	= sirfsoc_uart_shutdown,
+	.set_termios	= sirfsoc_uart_set_termios,
+	.type		= sirfsoc_uart_type,
+	.release_port	= sirfsoc_uart_release_port,
+	.request_port	= sirfsoc_uart_request_port,
+	.config_port	= sirfsoc_uart_config_port,
+};
+
+#ifdef CONFIG_SERIAL_SIRFSOC_CONSOLE
+static int __init sirfsoc_uart_console_setup(struct console *co, char *options)
+{
+	unsigned int baud = 115200;
+	unsigned int bits = 8;
+	unsigned int parity = 'n';
+	unsigned int flow = 'n';
+	struct uart_port *port = &sirfsoc_uart_ports[co->index].port;
+
+	if (co->index < 0 || co->index >= SIRFSOC_UART_NR)
+		return -EINVAL;
+
+	if (!port->mapbase)
+		return -ENODEV;
+
+	if (options)
+		uart_parse_options(options, &baud, &parity, &bits, &flow);
+	port->cons = co;
+	return uart_set_options(port, co, baud, parity, bits, flow);
+}
+
+static void sirfsoc_uart_console_putchar(struct uart_port *port, int ch)
+{
+	while (rd_regl(port,
+		SIRFUART_TX_FIFO_STATUS) & SIRFUART_FIFOFULL_MASK(port))
+		cpu_relax();
+	wr_regb(port, SIRFUART_TX_FIFO_DATA, ch);
+}
+
+static void sirfsoc_uart_console_write(struct console *co, const char *s,
+							unsigned int count)
+{
+	struct uart_port *port = &sirfsoc_uart_ports[co->index].port;
+	uart_console_write(port, s, count, sirfsoc_uart_console_putchar);
+}
+
+static struct console sirfsoc_uart_console = {
+	.name		= SIRFSOC_UART_NAME,
+	.device		= uart_console_device,
+	.flags		= CON_PRINTBUFFER,
+	.index		= -1,
+	.write		= sirfsoc_uart_console_write,
+	.setup		= sirfsoc_uart_console_setup,
+	.data           = &sirfsoc_uart_drv,
+};
+
+static int __init sirfsoc_uart_console_init(void)
+{
+	register_console(&sirfsoc_uart_console);
+	return 0;
+}
+console_initcall(sirfsoc_uart_console_init);
+#endif
+
+static struct uart_driver sirfsoc_uart_drv = {
+	.owner		= THIS_MODULE,
+	.driver_name	= SIRFUART_PORT_NAME,
+	.nr		= SIRFSOC_UART_NR,
+	.dev_name	= SIRFSOC_UART_NAME,
+	.major		= SIRFSOC_UART_MAJOR,
+	.minor		= SIRFSOC_UART_MINOR,
+#ifdef CONFIG_SERIAL_SIRFSOC_CONSOLE
+	.cons			= &sirfsoc_uart_console,
+#else
+	.cons			= NULL,
+#endif
+};
+
+int sirfsoc_uart_probe(struct platform_device *pdev)
+{
+	struct sirfsoc_uart_port *sirfport;
+	struct uart_port *port;
+	struct resource *res;
+	int ret;
+
+	if (of_property_read_u32(pdev->dev.of_node, "cell-index", &pdev->id)) {
+		dev_err(&pdev->dev,
+			"Unable to find cell-index in uart node.\n");
+		ret = -EFAULT;
+		goto err;
+	}
+
+	sirfport = &sirfsoc_uart_ports[pdev->id];
+	port = &sirfport->port;
+	port->dev = &pdev->dev;
+	port->private_data = sirfport;
+
+	if (of_find_property(pdev->dev.of_node, "hw_flow_ctrl", NULL))
+		sirfport->hw_flow_ctrl = 1;
+
+	if (of_property_read_u32(pdev->dev.of_node,
+			"fifosize",
+			&port->fifosize)) {
+		dev_err(&pdev->dev,
+			"Unable to find fifosize in uart node.\n");
+		ret = -EFAULT;
+		goto err;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "Insufficient resources.\n");
+		ret = -EFAULT;
+		goto err;
+	}
+	port->mapbase = res->start;
+	port->membase = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	if (!port->membase) {
+		dev_err(&pdev->dev, "Cannot remap resource.\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "Insufficient resources.\n");
+		ret = -EFAULT;
+		goto irq_err;
+	}
+	port->irq = res->start;
+
+	if (sirfport->hw_flow_ctrl) {
+		sirfport->pmx = pinmux_get(&pdev->dev, NULL);
+		ret = IS_ERR(sirfport->pmx);
+		if (ret)
+			goto pmx_err;
+
+		pinmux_enable(sirfport->pmx);
+	}
+
+	port->ops = &sirfsoc_uart_ops;
+	spin_lock_init(&port->lock);
+
+	platform_set_drvdata(pdev, sirfport);
+	ret = uart_add_one_port(&sirfsoc_uart_drv, port);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "Cannot add UART port(%d).\n", pdev->id);
+		goto port_err;
+	}
+
+	return 0;
+
+port_err:
+	platform_set_drvdata(pdev, NULL);
+	if (sirfport->hw_flow_ctrl) {
+		pinmux_disable(sirfport->pmx);
+		pinmux_put(sirfport->pmx);
+	}
+pmx_err:
+irq_err:
+	devm_iounmap(&pdev->dev, port->membase);
+err:
+	return ret;
+}
+
+static int sirfsoc_uart_remove(struct platform_device *pdev)
+{
+	struct sirfsoc_uart_port *sirfport = platform_get_drvdata(pdev);
+	struct uart_port *port = &sirfport->port;
+	platform_set_drvdata(pdev, NULL);
+	if (sirfport->hw_flow_ctrl) {
+		pinmux_disable(sirfport->pmx);
+		pinmux_put(sirfport->pmx);
+	}
+	devm_iounmap(&pdev->dev, port->membase);
+	uart_remove_one_port(&sirfsoc_uart_drv, port);
+	return 0;
+}
+
+static int
+sirfsoc_uart_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct sirfsoc_uart_port *sirfport = platform_get_drvdata(pdev);
+	struct uart_port *port = &sirfport->port;
+	uart_suspend_port(&sirfsoc_uart_drv, port);
+	return 0;
+}
+
+static int sirfsoc_uart_resume(struct platform_device *pdev)
+{
+	struct sirfsoc_uart_port *sirfport = platform_get_drvdata(pdev);
+	struct uart_port *port = &sirfport->port;
+	uart_resume_port(&sirfsoc_uart_drv, port);
+	return 0;
+}
+
+static struct of_device_id sirfsoc_uart_ids[] __devinitdata = {
+	{ .compatible = "sirf,prima2-uart", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, sirfsoc_serial_of_match);
+
+static struct platform_driver sirfsoc_uart_driver = {
+	.probe		= sirfsoc_uart_probe,
+	.remove		= __devexit_p(sirfsoc_uart_remove),
+	.suspend	= sirfsoc_uart_suspend,
+	.resume		= sirfsoc_uart_resume,
+	.driver		= {
+		.name	= SIRFUART_PORT_NAME,
+		.owner	= THIS_MODULE,
+		.of_match_table = sirfsoc_uart_ids,
+	},
+};
+
+static int __init sirfsoc_uart_init(void)
+{
+	int ret = 0;
+
+	ret = uart_register_driver(&sirfsoc_uart_drv);
+	if (ret)
+		goto out;
+
+	ret = platform_driver_register(&sirfsoc_uart_driver);
+	if (ret)
+		uart_unregister_driver(&sirfsoc_uart_drv);
+out:
+	return ret;
+}
+module_init(sirfsoc_uart_init);
+
+static void __exit sirfsoc_uart_exit(void)
+{
+	platform_driver_unregister(&sirfsoc_uart_driver);
+	uart_unregister_driver(&sirfsoc_uart_drv);
+}
+module_exit(sirfsoc_uart_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Bin Shi <Bin.Shi@csr.com>, Rong Wang<Rong.Wang@csr.com>");
+MODULE_DESCRIPTION("CSR SiRFprimaII Uart Driver");
diff --git a/drivers/tty/serial/sirfsoc_uart.h b/drivers/tty/serial/sirfsoc_uart.h
new file mode 100644
index 0000000..fc64260
--- /dev/null
+++ b/drivers/tty/serial/sirfsoc_uart.h
@@ -0,0 +1,185 @@
+/*
+ * Drivers for CSR SiRFprimaII onboard UARTs.
+ *
+ * Copyright (c) 2011 Cambridge Silicon Radio Limited, a CSR plc group company.
+ *
+ * Licensed under GPLv2 or later.
+ */
+#include <linux/bitops.h>
+
+/* UART Register Offset Define */
+#define SIRFUART_LINE_CTRL			0x0040
+#define SIRFUART_TX_RX_EN			0x004c
+#define SIRFUART_DIVISOR			0x0050
+#define SIRFUART_INT_EN				0x0054
+#define SIRFUART_INT_STATUS			0x0058
+#define SIRFUART_TX_DMA_IO_CTRL			0x0100
+#define SIRFUART_TX_DMA_IO_LEN			0x0104
+#define SIRFUART_TX_FIFO_CTRL			0x0108
+#define SIRFUART_TX_FIFO_LEVEL_CHK		0x010C
+#define SIRFUART_TX_FIFO_OP			0x0110
+#define SIRFUART_TX_FIFO_STATUS			0x0114
+#define SIRFUART_TX_FIFO_DATA			0x0118
+#define SIRFUART_RX_DMA_IO_CTRL			0x0120
+#define SIRFUART_RX_DMA_IO_LEN			0x0124
+#define SIRFUART_RX_FIFO_CTRL			0x0128
+#define SIRFUART_RX_FIFO_LEVEL_CHK		0x012C
+#define SIRFUART_RX_FIFO_OP			0x0130
+#define SIRFUART_RX_FIFO_STATUS			0x0134
+#define SIRFUART_RX_FIFO_DATA			0x0138
+#define SIRFUART_AFC_CTRL			0x0140
+#define SIRFUART_SWH_DMA_IO			0x0148
+
+/* UART Line Control Register */
+#define SIRFUART_DATA_BIT_LEN_MASK		0x3
+#define SIRFUART_DATA_BIT_LEN_5			BIT(0)
+#define SIRFUART_DATA_BIT_LEN_6			1
+#define SIRFUART_DATA_BIT_LEN_7			2
+#define SIRFUART_DATA_BIT_LEN_8			3
+#define SIRFUART_STOP_BIT_LEN_1			0
+#define SIRFUART_STOP_BIT_LEN_2			BIT(2)
+#define SIRFUART_PARITY_EN			BIT(3)
+#define SIRFUART_EVEN_BIT			BIT(4)
+#define SIRFUART_STICK_BIT_MASK			(7 << 3)
+#define SIRFUART_STICK_BIT_NONE			(0 << 3)
+#define SIRFUART_STICK_BIT_EVEN			BIT(3)
+#define SIRFUART_STICK_BIT_ODD			(3 << 3)
+#define SIRFUART_STICK_BIT_MARK			(5 << 3)
+#define SIRFUART_STICK_BIT_SPACE		(7 << 3)
+#define SIRFUART_SET_BREAK			BIT(6)
+#define SIRFUART_LOOP_BACK			BIT(7)
+#define SIRFUART_PARITY_MASK			(7 << 3)
+#define SIRFUART_DUMMY_READ			BIT(16)
+
+#define SIRFSOC_UART_RX_TIMEOUT(br, to)	(((br) * (((to) + 999) / 1000)) / 1000)
+#define SIRFUART_RECV_TIMEOUT_MASK	(0xFFFF << 16)
+#define SIRFUART_RECV_TIMEOUT(x)	(((x) & 0xFFFF) << 16)
+
+/* UART Auto Flow Control */
+#define SIRFUART_AFC_RX_THD_MASK		0x000000FF
+#define SIRFUART_AFC_RX_EN			BIT(8)
+#define SIRFUART_AFC_TX_EN			BIT(9)
+#define SIRFUART_CTS_CTRL			BIT(10)
+#define SIRFUART_RTS_CTRL			BIT(11)
+#define SIRFUART_CTS_IN_STATUS			BIT(12)
+#define SIRFUART_RTS_OUT_STATUS			BIT(13)
+
+/* UART Interrupt Enable Register */
+#define SIRFUART_RX_DONE_INT			BIT(0)
+#define SIRFUART_TX_DONE_INT			BIT(1)
+#define SIRFUART_RX_OFLOW_INT			BIT(2)
+#define SIRFUART_TX_ALLOUT_INT			BIT(3)
+#define SIRFUART_RX_IO_DMA_INT			BIT(4)
+#define SIRFUART_TX_IO_DMA_INT			BIT(5)
+#define SIRFUART_RXFIFO_FULL_INT		BIT(6)
+#define SIRFUART_TXFIFO_EMPTY_INT		BIT(7)
+#define SIRFUART_RXFIFO_THD_INT			BIT(8)
+#define SIRFUART_TXFIFO_THD_INT			BIT(9)
+#define SIRFUART_FRM_ERR_INT			BIT(10)
+#define SIRFUART_RXD_BREAK_INT			BIT(11)
+#define SIRFUART_RX_TIMEOUT_INT			BIT(12)
+#define SIRFUART_PARITY_ERR_INT			BIT(13)
+#define SIRFUART_CTS_INT_EN			BIT(14)
+#define SIRFUART_RTS_INT_EN			BIT(15)
+
+/* UART Interrupt Status Register */
+#define SIRFUART_RX_DONE			BIT(0)
+#define SIRFUART_TX_DONE			BIT(1)
+#define SIRFUART_RX_OFLOW			BIT(2)
+#define SIRFUART_TX_ALL_EMPTY			BIT(3)
+#define SIRFUART_DMA_IO_RX_DONE			BIT(4)
+#define SIRFUART_DMA_IO_TX_DONE			BIT(5)
+#define SIRFUART_RXFIFO_FULL			BIT(6)
+#define SIRFUART_TXFIFO_EMPTY			BIT(7)
+#define SIRFUART_RXFIFO_THD_REACH		BIT(8)
+#define SIRFUART_TXFIFO_THD_REACH		BIT(9)
+#define SIRFUART_FRM_ERR			BIT(10)
+#define SIRFUART_RXD_BREAK			BIT(11)
+#define SIRFUART_RX_TIMEOUT			BIT(12)
+#define SIRFUART_PARITY_ERR			BIT(13)
+#define SIRFUART_CTS_CHANGE			BIT(14)
+#define SIRFUART_RTS_CHANGE			BIT(15)
+#define SIRFUART_PLUG_IN			BIT(16)
+
+#define SIRFUART_ERR_INT_STAT					\
+				(SIRFUART_RX_OFLOW |		\
+				SIRFUART_FRM_ERR |		\
+				SIRFUART_RXD_BREAK |		\
+				SIRFUART_PARITY_ERR)
+#define SIRFUART_ERR_INT_EN					\
+				(SIRFUART_RX_OFLOW_INT |	\
+				SIRFUART_FRM_ERR_INT |		\
+				SIRFUART_RXD_BREAK_INT |	\
+				SIRFUART_PARITY_ERR_INT)
+#define SIRFUART_TX_INT_EN	SIRFUART_TXFIFO_EMPTY_INT
+#define SIRFUART_RX_IO_INT_EN					\
+				(SIRFUART_RX_TIMEOUT_INT |	\
+				SIRFUART_RXFIFO_THD_INT |	\
+				SIRFUART_RXFIFO_FULL_INT |	\
+				SIRFUART_ERR_INT_EN)
+
+/* UART FIFO Register */
+#define SIRFUART_TX_FIFO_STOP			0x0
+#define SIRFUART_TX_FIFO_RESET			0x1
+#define SIRFUART_TX_FIFO_START			0x2
+#define SIRFUART_RX_FIFO_STOP			0x0
+#define SIRFUART_RX_FIFO_RESET			0x1
+#define SIRFUART_RX_FIFO_START			0x2
+#define SIRFUART_TX_MODE_DMA			0
+#define SIRFUART_TX_MODE_IO			1
+#define SIRFUART_RX_MODE_DMA			0
+#define SIRFUART_RX_MODE_IO			1
+
+#define SIRFUART_RX_EN				0x1
+#define SIRFUART_TX_EN				0x2
+
+/* Generic Definitions */
+#define SIRFSOC_UART_NAME			"ttySiRF"
+#define SIRFSOC_UART_MAJOR			0
+#define SIRFSOC_UART_MINOR			0
+#define SIRFUART_PORT_NAME			"sirfsoc-uart"
+#define SIRFUART_MAP_SIZE			0x200
+#define SIRFSOC_UART_NR				3
+#define SIRFSOC_PORT_TYPE			0xa5
+
+/* Baud Rate Calculation */
+#define SIRF_MIN_SAMPLE_DIV			0xf
+#define SIRF_MAX_SAMPLE_DIV			0x3f
+#define SIRF_IOCLK_DIV_MAX			0xffff
+#define SIRF_SAMPLE_DIV_SHIFT			16
+#define SIRF_IOCLK_DIV_MASK			0xffff
+#define SIRF_SAMPLE_DIV_MASK			0x3f0000
+#define SIRF_BAUD_RATE_SUPPORT_NR		18
+
+/* For Fast Baud Rate Calculation */
+struct sirfsoc_baudrate_to_regv {
+	unsigned int baud_rate;
+	unsigned int reg_val;
+};
+
+struct sirfsoc_uart_port {
+	unsigned char			hw_flow_ctrl;
+	unsigned char			ms_enabled;
+
+	struct uart_port		port;
+	struct pinmux			*pmx;
+};
+
+/* Hardware Flow Control */
+#define SIRFUART_AFC_CTRL_RX_THD	0x70
+
+/* Register Access Control */
+#define portaddr(port, reg)		((port)->membase + (reg))
+#define rd_regb(port, reg)		(__raw_readb(portaddr(port, reg)))
+#define rd_regl(port, reg)		(__raw_readl(portaddr(port, reg)))
+#define wr_regb(port, reg, val)		__raw_writeb(val, portaddr(port, reg))
+#define wr_regl(port, reg, val)		__raw_writel(val, portaddr(port, reg))
+
+/* UART Port Mask */
+#define SIRFUART_FIFOLEVEL_MASK(port)	((port->line == 1) ? (0x1f) : (0x7f))
+#define SIRFUART_FIFOFULL_MASK(port)	((port->line == 1) ? (0x20) : (0x80))
+#define SIRFUART_FIFOEMPTY_MASK(port)	((port->line == 1) ? (0x40) : (0x100))
+
+/* I/O Mode */
+#define SIRFSOC_UART_IO_RX_MAX_CNT		256
+#define SIRFSOC_UART_IO_TX_REASONABLE_CNT	6
-- 
1.7.1



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog

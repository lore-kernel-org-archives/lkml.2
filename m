Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab2AIQod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 11:44:33 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44993 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab2AIQob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 11:44:31 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Cc: kernel@pengutronix.de, devicetree-discuss@lists.ozlabs.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org
Subject: [PATCH v3] serial/efm32: add new driver
Date: Mon,  9 Jan 2012 17:44:07 +0100
Message-Id: <1326127447-20284-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1324561092-1945-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1324561092-1945-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

changes since v2:
- use {read,write}l_relaxed
- rename driver to efm32-uart as USARTs and UARTs can be handled both
  with it
- disable TX in .stop_tx (which needs some changes related to
  USARTn_IF_TXC)

Best regards
Uwe

 .../devicetree/bindings/tty/serial/efm32-uart.txt  |   14 +
 arch/arm/boot/dts/efm32gg-dk3750.dts               |    2 +-
 arch/arm/mach-efm32/devices/pdev-efm32-usart.c     |    6 +-
 drivers/tty/serial/Kconfig                         |   13 +
 drivers/tty/serial/Makefile                        |    1 +
 drivers/tty/serial/efm32-uart.c                    |  761 ++++++++++++++++++++
 include/linux/serial_core.h                        |    2 +
 7 files changed, 795 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/tty/serial/efm32-uart.txt
 create mode 100644 drivers/tty/serial/efm32-uart.c

diff --git a/Documentation/devicetree/bindings/tty/serial/efm32-uart.txt b/Documentation/devicetree/bindings/tty/serial/efm32-uart.txt
new file mode 100644
index 0000000..6588b69
--- /dev/null
+++ b/Documentation/devicetree/bindings/tty/serial/efm32-uart.txt
@@ -0,0 +1,14 @@
+* Energymicro efm32 UART
+
+Required properties:
+- compatible : Should be "efm32,uart"
+- reg : Address and length of the register set
+- interrupts : Should contain uart interrupt
+
+Example:
+
+uart@0x4000c400 {
+	compatible = "efm32,uart";
+	reg = <0x4000c400 0x400>;
+	interrupts = <15>;
+};
diff --git a/arch/arm/boot/dts/efm32gg-dk3750.dts b/arch/arm/boot/dts/efm32gg-dk3750.dts
index a4aa4f3..2a28b0f 100644
--- a/arch/arm/boot/dts/efm32gg-dk3750.dts
+++ b/arch/arm/boot/dts/efm32gg-dk3750.dts
@@ -32,7 +32,7 @@
 		ranges;
 
 		uart1: uart@0x4000c400 { /* USART1 */
-			compatible = "efm32,usart";
+			compatible = "efm32,uart";
 			reg = <0x4000c400 0x400>;
 			interrupts = <15>;
 			status = "ok";
diff --git a/arch/arm/mach-efm32/devices/pdev-efm32-usart.c b/arch/arm/mach-efm32/devices/pdev-efm32-usart.c
index 03ff343..c7d91e1 100644
--- a/arch/arm/mach-efm32/devices/pdev-efm32-usart.c
+++ b/arch/arm/mach-efm32/devices/pdev-efm32-usart.c
@@ -20,19 +20,19 @@ static const struct resource efm32_usart2_resources[] __initconst = {
 
 const struct platform_device_info efm32_usart_devinfo[] __initconst = {
 	[0] = {
-		.name = "efm32-usart",
+		.name = "efm32-uart",
 		.id = 0,
 		.res = efm32_usart0_resources,
 		.num_res = ARRAY_SIZE(efm32_usart0_resources),
 	},
 	[1] = {
-		.name = "efm32-usart",
+		.name = "efm32-uart",
 		.id = 1,
 		.res = efm32_usart1_resources,
 		.num_res = ARRAY_SIZE(efm32_usart1_resources),
 	},
 	[2] = {
-		.name = "efm32-usart",
+		.name = "efm32-uart",
 		.id = 2,
 		.res = efm32_usart2_resources,
 		.num_res = ARRAY_SIZE(efm32_usart2_resources),
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 925a1e5..b91974a 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1610,4 +1610,17 @@ config SERIAL_XILINX_PS_UART_CONSOLE
 	help
 	  Enable a Xilinx PS UART port to be the system console.
 
+config SERIAL_EFM32_UART
+	tristate "EFM32 UART/USART port."
+	depends on ARCH_EFM32
+	select SERIAL_CORE
+	help
+	  This driver support the USART and UART ports on
+	  Energy Micro's efm32 SoCs.
+
+config SERIAL_EFM32_UART_CONSOLE
+	bool "EFM32 UART/USART console support"
+	depends on SERIAL_EFM32_UART=y
+	select SERIAL_CORE_CONSOLE
+
 endmenu
diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
index e10cf5b..7814122 100644
--- a/drivers/tty/serial/Makefile
+++ b/drivers/tty/serial/Makefile
@@ -94,3 +94,4 @@ obj-$(CONFIG_SERIAL_MSM_SMD)	+= msm_smd_tty.o
 obj-$(CONFIG_SERIAL_MXS_AUART) += mxs-auart.o
 obj-$(CONFIG_SERIAL_LANTIQ)	+= lantiq.o
 obj-$(CONFIG_SERIAL_XILINX_PS_UART) += xilinx_uartps.o
+obj-$(CONFIG_SERIAL_EFM32_UART) += efm32-uart.o
diff --git a/drivers/tty/serial/efm32-uart.c b/drivers/tty/serial/efm32-uart.c
new file mode 100644
index 0000000..ed0bc0d
--- /dev/null
+++ b/drivers/tty/serial/efm32-uart.c
@@ -0,0 +1,761 @@
+#include <linux/kernel.h>
+#include <linux/serial_core.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/console.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+
+#define DRIVER_NAME "efm32-uart"
+#define DEV_NAME "ttyefm"
+
+#define UARTn_CTRL		0x00
+#define UARTn_CTRL_SYNC		0x0001
+#define UARTn_CTRL_TXBIL		0x1000
+
+#define UARTn_FRAME		0x04
+#define UARTn_FRAME_DATABITS__MASK	0x000f
+#define UARTn_FRAME_DATABITS(n)	((n) - 3)
+#define UARTn_FRAME_PARITY_NONE	0x0000
+#define UARTn_FRAME_PARITY_EVEN	0x0200
+#define UARTn_FRAME_PARITY_ODD		0x0300
+#define UARTn_FRAME_STOPBITS_HALF	0x0000
+#define UARTn_FRAME_STOPBITS_ONE	0x1000
+#define UARTn_FRAME_STOPBITS_TWO	0x3000
+
+#define UARTn_CMD		0x0c
+#define UARTn_CMD_RXEN			0x0001
+#define UARTn_CMD_RXDIS		0x0002
+#define UARTn_CMD_TXEN			0x0004
+#define UARTn_CMD_TXDIS		0x0008
+
+#define UARTn_STATUS		0x10
+#define UARTn_STATUS_TXENS		0x0002
+#define UARTn_STATUS_TXC		0x0020
+#define UARTn_STATUS_TXBL		0x0040
+#define UARTn_STATUS_RXDATAV		0x0080
+
+#define UARTn_CLKDIV		0x14
+
+#define UARTn_RXDATAX		0x18
+#define UARTn_RXDATAX_PERR		0x4000
+#define UARTn_RXDATAX_FERR		0x8000
+
+#define UARTn_TXDATA		0x34
+
+#define UARTn_IF		0x40
+#define UARTn_IF_TXC			0x0001
+#define UARTn_IF_TXBL			0x0002
+#define UARTn_IF_RXDATAV		0x0004
+
+#define UARTn_IFS		0x44
+#define UARTn_IFC		0x48
+#define UARTn_IEN		0x4c
+
+#define UARTn_ROUTE		0x54
+#define UARTn_ROUTE_RXPEN		0x0001
+#define UARTn_ROUTE_TXPEN		0x0002
+
+struct efm32_uart_port {
+	struct uart_port port;
+	unsigned int txirq;
+	struct clk *clk;
+};
+#define to_efm_port(_port) container_of(_port, struct efm32_uart_port, port)
+#define efm_debug(efm_port, format, arg...)			\
+	dev_dbg(efm_port->port.dev, format, ##arg)
+
+static void efm32_uart_write32(struct efm32_uart_port *efm_port,
+		u32 value, unsigned offset)
+{
+	writel_relaxed(value, efm_port->port.membase + offset);
+}
+
+static u32 efm32_uart_read32(struct efm32_uart_port *efm_port,
+		unsigned offset)
+{
+	return readl_relaxed(efm_port->port.membase + offset);
+}
+
+static unsigned int efm32_uart_tx_empty(struct uart_port *port)
+{
+	struct efm32_uart_port *efm_port = to_efm_port(port);
+	u32 status = efm32_uart_read32(efm_port, UARTn_STATUS);
+
+	/* XXX: does TXBL also mean that the shifter is done? */
+	if (status & UARTn_STATUS_TXBL)
+		return TIOCSER_TEMT;
+	else
+		return 0;
+}
+
+static void efm32_uart_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+	/* sorry, neither handshaking lines nor loop functionallity */
+}
+
+static unsigned int efm32_uart_get_mctrl(struct uart_port *port)
+{
+	/* sorry, no handshaking lines available */
+	return TIOCM_CAR | TIOCM_CTS | TIOCM_DSR;
+}
+
+static void efm32_uart_stop_tx(struct uart_port *port)
+{
+	struct efm32_uart_port *efm_port = to_efm_port(port);
+	u32 ien = efm32_uart_read32(efm_port,  UARTn_IEN);
+
+	efm32_uart_write32(efm_port, UARTn_CMD_TXDIS, UARTn_CMD);
+	efm32_uart_write32(efm_port,
+			ien & ~(UARTn_IF_TXC | UARTn_IF_TXBL), UARTn_IEN);
+}
+
+static void efm32_uart_tx_chars(struct efm32_uart_port *efm_port)
+{
+	struct uart_port *port = &efm_port->port;
+	struct circ_buf *xmit = &port->state->xmit;
+
+	while (efm32_uart_read32(efm_port, UARTn_STATUS) &
+			UARTn_STATUS_TXBL) {
+		if (port->x_char) {
+			port->icount.tx++;
+			efm32_uart_write32(efm_port, port->x_char,
+					UARTn_TXDATA);
+			port->x_char = 0;
+			continue;
+		}
+		if (!uart_circ_empty(xmit) && !uart_tx_stopped(port)) {
+			port->icount.tx++;
+			efm32_uart_write32(efm_port, xmit->buf[xmit->tail],
+					UARTn_TXDATA);
+			xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
+		} else
+			break;
+	}
+
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
+		uart_write_wakeup(port);
+
+	if (!port->x_char && uart_circ_empty(xmit) &&
+			efm32_uart_read32(efm_port, UARTn_STATUS) &
+				UARTn_STATUS_TXC)
+		efm32_uart_stop_tx(port);
+}
+
+static void efm32_uart_start_tx(struct uart_port *port)
+{
+	struct efm32_uart_port *efm_port = to_efm_port(port);
+	u32 ien;
+
+	efm32_uart_write32(efm_port,
+			UARTn_IF_TXBL | UARTn_IF_TXC, UARTn_IFC);
+	ien = efm32_uart_read32(efm_port,  UARTn_IEN);
+	efm32_uart_write32(efm_port,
+			ien | UARTn_IF_TXBL | UARTn_IF_TXC, UARTn_IEN);
+	efm32_uart_write32(efm_port, UARTn_CMD_TXEN, UARTn_CMD);
+
+	efm32_uart_tx_chars(efm_port);
+}
+
+static void efm32_uart_stop_rx(struct uart_port *port)
+{
+	struct efm32_uart_port *efm_port = to_efm_port(port);
+
+	efm32_uart_write32(efm_port, UARTn_CMD_RXDIS, UARTn_CMD);
+}
+
+static void efm32_uart_enable_ms(struct uart_port *port)
+{
+	/* no handshake lines, no modem status interrupts */
+}
+
+static void efm32_uart_break_ctl(struct uart_port *port, int ctl)
+{
+	/* not possible without fiddling with gpios */
+}
+
+static void efm32_uart_rx_chars(struct efm32_uart_port *efm_port)
+{
+	struct uart_port *port = &efm_port->port;
+	struct tty_struct *tty = tty_port_tty_get(&port->state->port);
+
+	spin_lock(&port->lock);
+
+	while (efm32_uart_read32(efm_port, UARTn_STATUS) &
+			UARTn_STATUS_RXDATAV) {
+		u32 rxdata = efm32_uart_read32(efm_port, UARTn_RXDATAX);
+		int flag = 0;
+
+		port->icount.rx++;
+
+		/* XXX detect BREAK and overrun */
+
+		if (rxdata & UARTn_RXDATAX_PERR) {
+			port->icount.parity++;
+			if (port->read_status_mask & UARTn_RXDATAX_PERR)
+				flag = TTY_PARITY;
+		} else if (rxdata & UARTn_RXDATAX_FERR) {
+			port->icount.frame++;
+			if (port->read_status_mask & UARTn_RXDATAX_FERR)
+				flag = TTY_FRAME;
+		}
+
+		if (rxdata & port->ignore_status_mask)
+			continue;
+
+		if (tty)
+			tty_insert_flip_char(tty, rxdata, flag);
+	}
+	spin_unlock(&port->lock);
+
+	if (tty) {
+		tty_flip_buffer_push(tty);
+		tty_kref_put(tty);
+	}
+}
+
+static irqreturn_t efm32_uart_rxirq(int irq, void *data)
+{
+	struct efm32_uart_port *efm_port = data;
+	u32 irqflag = efm32_uart_read32(efm_port, UARTn_IF);
+
+	if (irqflag & UARTn_IF_RXDATAV) {
+		efm32_uart_write32(efm_port, UARTn_IF_RXDATAV, UARTn_IFC);
+		efm32_uart_rx_chars(efm_port);
+
+		return IRQ_HANDLED;
+	} else
+		return IRQ_NONE;
+}
+
+static irqreturn_t efm32_uart_txirq(int irq, void *data)
+{
+	struct efm32_uart_port *efm_port = data;
+	u32 irqflag = efm32_uart_read32(efm_port, UARTn_IF);
+
+	/* TXBL doesn't need to be cleared */
+	if (irqflag & UARTn_IF_TXC)
+		efm32_uart_write32(efm_port, UARTn_IF_TXC, UARTn_IFC);
+
+	if (irqflag & (UARTn_IF_TXC | UARTn_IF_TXBL)) {
+		efm32_uart_tx_chars(efm_port);
+		return IRQ_HANDLED;
+	} else
+		return IRQ_NONE;
+}
+
+static int efm32_uart_startup(struct uart_port *port)
+{
+	struct efm32_uart_port *efm_port = to_efm_port(port);
+	int ret;
+
+	ret = clk_enable(efm_port->clk);
+	if (ret) {
+		efm_debug(efm_port, "failed to enable clk\n");
+		goto err_clk_enable;
+	}
+	port->uartclk = clk_get_rate(efm_port->clk);
+
+	/* Enable pins at default location */
+	efm32_uart_write32(efm_port, UARTn_ROUTE_RXPEN | UARTn_ROUTE_TXPEN,
+			UARTn_ROUTE);
+
+	ret = request_irq(port->irq, efm32_uart_rxirq, 0,
+			DRIVER_NAME, efm_port);
+	if (ret) {
+		efm_debug(efm_port, "failed to register rxirq\n");
+		goto err_request_irq_rx;
+	}
+
+	/* disable all irqs */
+	efm32_uart_write32(efm_port, 0, UARTn_IEN);
+
+	ret = request_irq(efm_port->txirq, efm32_uart_txirq, 0,
+			DRIVER_NAME, efm_port);
+	if (ret) {
+		efm_debug(efm_port, "failed to register txirq\n");
+		free_irq(port->irq, efm_port);
+err_request_irq_rx:
+
+		clk_disable(efm_port->clk);
+	} else {
+		efm32_uart_write32(efm_port, UARTn_IF_RXDATAV, UARTn_IEN);
+		efm32_uart_write32(efm_port, UARTn_CMD_RXEN, UARTn_CMD);
+	}
+
+err_clk_enable:
+	return ret;
+}
+
+static void efm32_uart_shutdown(struct uart_port *port)
+{
+	struct efm32_uart_port *efm_port = to_efm_port(port);
+
+	efm32_uart_write32(efm_port, 0, UARTn_IEN);
+	free_irq(port->irq, efm_port);
+
+	clk_disable(efm_port->clk);
+}
+
+static void efm32_uart_set_termios(struct uart_port *port,
+		struct ktermios *new, struct ktermios *old)
+{
+	struct efm32_uart_port *efm_port = to_efm_port(port);
+	unsigned long flags;
+	unsigned baud;
+	u32 clkdiv;
+	u32 frame = 0;
+
+	/* no modem control lines */
+	new->c_cflag &= ~(CRTSCTS | CMSPAR);
+
+	baud = uart_get_baud_rate(port, new, old,
+			DIV_ROUND_CLOSEST(port->uartclk, 16 * 8192),
+			DIV_ROUND_CLOSEST(port->uartclk, 16));
+
+	switch (new->c_cflag & CSIZE) {
+	case CS5:
+		frame |= UARTn_FRAME_DATABITS(5);
+		break;
+	case CS6:
+		frame |= UARTn_FRAME_DATABITS(6);
+		break;
+	case CS7:
+		frame |= UARTn_FRAME_DATABITS(7);
+		break;
+	case CS8:
+		frame |= UARTn_FRAME_DATABITS(8);
+		break;
+	}
+
+	/* tx only supports a "half" stop bit */
+	new->c_cflag |= CSTOPB;
+	frame |= UARTn_FRAME_STOPBITS_ONE;
+
+	if (new->c_cflag & PARENB) {
+		if (new->c_cflag & PARODD)
+			frame |= UARTn_FRAME_PARITY_ODD;
+		else
+			frame |= UARTn_FRAME_PARITY_EVEN;
+	} else
+		frame |= UARTn_FRAME_PARITY_NONE;
+
+	/*
+	 * the 6 lowest bits of CLKDIV are dc, bit 6 has value 0.25.
+	 * port->uartclk <= 14e6, so 4 * port->uartclk doesn't overflow.
+	 */
+	clkdiv = (DIV_ROUND_CLOSEST(4 * port->uartclk, 16 * baud) - 4) << 6;
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	efm32_uart_write32(efm_port,
+			UARTn_CMD_TXDIS | UARTn_CMD_RXDIS, UARTn_CMD);
+
+	port->read_status_mask = 0;
+	port->ignore_status_mask = 0;
+
+	uart_update_timeout(port, new->c_cflag, baud);
+
+	efm32_uart_write32(efm_port, UARTn_CTRL_TXBIL, UARTn_CTRL);
+	efm32_uart_write32(efm_port, frame, UARTn_FRAME);
+	efm32_uart_write32(efm_port, clkdiv, UARTn_CLKDIV);
+
+	efm32_uart_write32(efm_port, UARTn_CMD_TXEN | UARTn_CMD_RXEN,
+			UARTn_CMD);
+
+	spin_unlock_irqrestore(&port->lock, flags);
+}
+
+static const char *efm32_uart_type(struct uart_port *port)
+{
+	return port->type == PORT_EFMUART ? "efm32-uart" : NULL;
+}
+
+static void efm32_uart_release_port(struct uart_port *port)
+{
+	struct efm32_uart_port *efm_port = to_efm_port(port);
+
+	clk_unprepare(efm_port->clk);
+	clk_put(efm_port->clk);
+	iounmap(port->membase);
+}
+
+static int efm32_uart_request_port(struct uart_port *port)
+{
+	struct efm32_uart_port *efm_port = to_efm_port(port);
+	int ret;
+
+	port->membase = ioremap(port->mapbase, 60);
+	if (!efm_port->port.membase) {
+		ret = -ENOMEM;
+		efm_debug(efm_port, "failed to remap\n");
+		goto err_ioremap;
+	}
+
+	efm_port->clk = clk_get(port->dev, NULL);
+	if (IS_ERR(efm_port->clk)) {
+		ret = PTR_ERR(efm_port->clk);
+		efm_debug(efm_port, "failed to get clock\n");
+		goto err_clk_get;
+	}
+
+	ret = clk_prepare(efm_port->clk);
+	if (ret) {
+		clk_put(efm_port->clk);
+err_clk_get:
+
+		iounmap(port->membase);
+err_ioremap:
+		return ret;
+	}
+	return 0;
+}
+
+static void efm32_uart_config_port(struct uart_port *port, int type)
+{
+	if (type & UART_CONFIG_TYPE &&
+			!efm32_uart_request_port(port))
+		port->type = PORT_EFMUART;
+}
+
+static int efm32_uart_verify_port(struct uart_port *port,
+		struct serial_struct *serinfo)
+{
+	int ret = 0;
+
+	if (serinfo->type != PORT_UNKNOWN && serinfo->type != PORT_EFMUART)
+		ret = -EINVAL;
+
+	return ret;
+}
+
+static struct uart_ops efm32_uart_pops = {
+	.tx_empty = efm32_uart_tx_empty,
+	.set_mctrl = efm32_uart_set_mctrl,
+	.get_mctrl = efm32_uart_get_mctrl,
+	.stop_tx = efm32_uart_stop_tx,
+	.start_tx = efm32_uart_start_tx,
+	.stop_rx = efm32_uart_stop_rx,
+	.enable_ms = efm32_uart_enable_ms,
+	.break_ctl = efm32_uart_break_ctl,
+	.startup = efm32_uart_startup,
+	.shutdown = efm32_uart_shutdown,
+	.set_termios = efm32_uart_set_termios,
+	.type = efm32_uart_type,
+	.release_port = efm32_uart_release_port,
+	.request_port = efm32_uart_request_port,
+	.config_port = efm32_uart_config_port,
+	.verify_port = efm32_uart_verify_port,
+};
+
+static struct efm32_uart_port *efm32_uart_ports[3];
+
+#ifdef CONFIG_SERIAL_EFM32_UART_CONSOLE
+static void efm32_uart_console_putchar(struct uart_port *port, int ch)
+{
+	struct efm32_uart_port *efm_port = to_efm_port(port);
+	unsigned int timeout = 0x400;
+	u32 status;
+
+	while (1) {
+		status = efm32_uart_read32(efm_port, UARTn_STATUS);
+
+		if (status & UARTn_STATUS_TXBL)
+			break;
+		if (!timeout--)
+			return;
+	}
+	efm32_uart_write32(efm_port, ch, UARTn_TXDATA);
+}
+
+static void efm32_uart_console_write(struct console *co, const char *s,
+		unsigned int count)
+{
+	struct efm32_uart_port *efm_port = efm32_uart_ports[co->index];
+	u32 status = efm32_uart_read32(efm_port, UARTn_STATUS);
+	unsigned int timeout = 0x400;
+
+	if (!(status & UARTn_STATUS_TXENS))
+		efm32_uart_write32(efm_port, UARTn_CMD_TXEN, UARTn_CMD);
+
+	uart_console_write(&efm_port->port, s, count,
+			efm32_uart_console_putchar);
+
+	/* Wait for the transmitter to become empty */
+	while (1) {
+		u32 status = efm32_uart_read32(efm_port, UARTn_STATUS);
+		if (status & UARTn_STATUS_TXC)
+			break;
+		if (!timeout--)
+			break;
+	}
+
+	if (!(status & UARTn_STATUS_TXENS))
+		efm32_uart_write32(efm_port, UARTn_CMD_TXDIS, UARTn_CMD);
+}
+
+static void efm32_uart_console_get_options(struct efm32_uart_port *efm_port,
+		int *baud, int *parity, int *bits)
+{
+	u32 ctrl = efm32_uart_read32(efm_port, UARTn_CTRL);
+	u32 route, clkdiv, frame;
+
+	if (ctrl & UARTn_CTRL_SYNC)
+		/* not operating in async mode */
+		return;
+
+	route = efm32_uart_read32(efm_port, UARTn_ROUTE);
+	if (!(route & UARTn_ROUTE_TXPEN))
+		/* tx pin not routed */
+		return;
+
+	clkdiv = efm32_uart_read32(efm_port, UARTn_CLKDIV);
+
+	*baud = DIV_ROUND_CLOSEST(4 * efm_port->port.uartclk,
+			16 * (4 + (clkdiv >> 6)));
+
+	frame = efm32_uart_read32(efm_port, UARTn_FRAME);
+	if (frame & UARTn_FRAME_PARITY_ODD)
+		*parity = 'o';
+	else if (frame & UARTn_FRAME_PARITY_EVEN)
+		*parity = 'e';
+	else
+		*parity = 'n';
+
+	*bits = (frame & UARTn_FRAME_DATABITS__MASK) -
+			UARTn_FRAME_DATABITS(4) + 4;
+
+	efm_debug(efm_port, "get_opts: options=%d%c%d\n",
+			*baud, *parity, *bits);
+}
+
+static int efm32_uart_console_setup(struct console *co, char *options)
+{
+	struct efm32_uart_port *efm_port;
+	int baud = 115200;
+	int bits = 8;
+	int parity = 'n';
+	int flow = 'n';
+	int ret;
+
+	if (co->index < 0 || co->index >= ARRAY_SIZE(efm32_uart_ports)) {
+		unsigned i;
+		for (i = 0; i < ARRAY_SIZE(efm32_uart_ports); ++i) {
+			if (efm32_uart_ports[i]) {
+				pr_warn("efm32-console: fall back to console index %u (from %hhi)\n",
+						i, co->index);
+				co->index = i;
+				break;
+			}
+		}
+	}
+
+	efm_port = efm32_uart_ports[co->index];
+	if (!efm_port) {
+		pr_warn("efm32-console: No port at %d\n", co->index);
+		return -ENODEV;
+	}
+
+	ret = clk_prepare(efm_port->clk);
+	if (ret) {
+		dev_warn(efm_port->port.dev,
+				"console: clk_prepare failed: %d\n", ret);
+		return ret;
+	}
+
+	efm_port->port.uartclk = clk_get_rate(efm_port->clk);
+
+	if (options)
+		uart_parse_options(options, &baud, &parity, &bits, &flow);
+	else
+		efm32_uart_console_get_options(efm_port,
+				&baud, &parity, &bits);
+
+	return uart_set_options(&efm_port->port, co, baud, parity, bits, flow);
+}
+
+static struct uart_driver efm32_uart_reg;
+
+static struct console efm32_uart_console = {
+	.name = DEV_NAME,
+	.write = efm32_uart_console_write,
+	.device = uart_console_device,
+	.setup = efm32_uart_console_setup,
+	.flags = CON_PRINTBUFFER,
+	.index = -1,
+	.data = &efm32_uart_reg,
+};
+
+#else
+#define efm32_uart_console (*(struct console *)NULL)
+#endif /* ifdef CONFIG_SERIAL_EFM32_UART_CONSOLE / else */
+
+static struct uart_driver efm32_uart_reg = {
+	.owner = THIS_MODULE,
+	.driver_name = DRIVER_NAME,
+	.dev_name = DEV_NAME,
+	.nr = ARRAY_SIZE(efm32_uart_ports),
+	.cons = &efm32_uart_console,
+};
+
+static int efm32_uart_probe_dt(struct platform_device *pdev,
+		struct efm32_uart_port *efm_port)
+{
+	struct device_node *np = pdev->dev.of_node;
+	int ret;
+
+	if (!np)
+		return 1;
+
+	ret = of_alias_get_id(np, "serial");
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to get alias id: %d\n", ret);
+		return ret;
+	} else {
+		efm_port->port.line = ret;
+		return 0;
+	}
+
+}
+
+static int __devinit efm32_uart_probe(struct platform_device *pdev)
+{
+	struct efm32_uart_port *efm_port;
+	struct resource *res;
+	int ret;
+
+	efm_port = kzalloc(sizeof(*efm_port), GFP_KERNEL);
+	if (!efm_port) {
+		dev_dbg(&pdev->dev, "failed to allocate private data\n");
+		return -ENOMEM;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		ret = -ENODEV;
+		dev_dbg(&pdev->dev, "failed to determine base address\n");
+		goto err_get_base;
+	}
+
+	if (resource_size(res) < 60) {
+		ret = -EINVAL;
+		dev_dbg(&pdev->dev, "memory resource too small\n");
+		goto err_too_small;
+	}
+
+	ret = platform_get_irq(pdev, 0);
+	if (ret <= 0) {
+		dev_dbg(&pdev->dev, "failed to get rx irq\n");
+		goto err_get_rxirq;
+	}
+
+	efm_port->port.irq = ret;
+
+	ret = platform_get_irq(pdev, 1);
+	if (ret <= 0)
+		ret = efm_port->port.irq + 1;
+
+	efm_port->txirq = ret;
+
+	efm_port->port.dev = &pdev->dev;
+	efm_port->port.mapbase = res->start;
+	efm_port->port.type = PORT_EFMUART;
+	efm_port->port.iotype = UPIO_MEM32;
+	efm_port->port.fifosize = 2;
+	efm_port->port.ops = &efm32_uart_pops;
+	efm_port->port.flags = UPF_BOOT_AUTOCONF;
+
+	ret = efm32_uart_probe_dt(pdev, efm_port);
+	if (ret > 0)
+		/* not created by device tree */
+		efm_port->port.line = pdev->id;
+
+	if (efm_port->port.line >= 0 &&
+			efm_port->port.line < ARRAY_SIZE(efm32_uart_ports))
+		efm32_uart_ports[efm_port->port.line] = efm_port;
+
+	ret = uart_add_one_port(&efm32_uart_reg, &efm_port->port);
+	if (ret) {
+		dev_dbg(&pdev->dev, "failed to add port: %d\n", ret);
+
+		if (pdev->id >= 0 && pdev->id < ARRAY_SIZE(efm32_uart_ports))
+			efm32_uart_ports[pdev->id] = NULL;
+err_get_rxirq:
+err_too_small:
+err_get_base:
+		kfree(efm_port);
+	} else {
+		platform_set_drvdata(pdev, efm_port);
+		dev_dbg(&pdev->dev, "\\o/\n");
+	}
+
+	return ret;
+}
+
+static int __devexit efm32_uart_remove(struct platform_device *pdev)
+{
+	struct efm32_uart_port *efm_port = platform_get_drvdata(pdev);
+
+	platform_set_drvdata(pdev, NULL);
+
+	uart_remove_one_port(&efm32_uart_reg, &efm_port->port);
+
+	if (pdev->id >= 0 && pdev->id < ARRAY_SIZE(efm32_uart_ports))
+		efm32_uart_ports[pdev->id] = NULL;
+
+	kfree(efm_port);
+
+	return 0;
+}
+
+static struct of_device_id efm32_uart_dt_ids[] = {
+	{
+		.compatible = "efm32,uart",
+	}, {
+		/* sentinel */
+	}
+};
+MODULE_DEVICE_TABLE(of, efm32_uart_dt_ids);
+
+static struct platform_driver efm32_uart_driver = {
+	.probe = efm32_uart_probe,
+	.remove = __devexit_p(efm32_uart_remove),
+
+	.driver = {
+		.name = DRIVER_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = efm32_uart_dt_ids,
+	},
+};
+
+static int __init efm32_uart_init(void)
+{
+	int ret;
+
+	ret = uart_register_driver(&efm32_uart_reg);
+	if (ret)
+		return ret;
+
+	ret = platform_driver_register(&efm32_uart_driver);
+	if (ret)
+		uart_unregister_driver(&efm32_uart_reg);
+
+	pr_info("EFM32 UART/USART driver\n");
+
+	return ret;
+}
+module_init(efm32_uart_init);
+
+static void __exit efm32_uart_exit(void)
+{
+	platform_driver_unregister(&efm32_uart_driver);
+	uart_unregister_driver(&efm32_uart_reg);
+}
+
+MODULE_AUTHOR("Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>");
+MODULE_DESCRIPTION("EFM32 UART/USART driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRIVER_NAME);
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index eadf33d..d3999ef 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -207,6 +207,8 @@
 /* Xilinx PSS UART */
 #define PORT_XUARTPS	98
 
+#define PORT_EFMUART   99
+
 #ifdef __KERNEL__
 
 #include <linux/compiler.h>
-- 
1.7.7.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab0GEJGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 05:06:36 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:37768 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751797Ab0GEJGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 05:06:34 -0400
X-Greylist: delayed 1112 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jul 2010 05:06:32 EDT
From: Philippe Langlais <philippe.langlais@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: <ludovic.barre@stericsson.com>,
       Philippe Langlais <philippe.langlais@stericsson.com>
Subject: [PATCH] U6715 8250 serial like driver
Date: Mon, 5 Jul 2010 10:46:45 +0200
Message-ID: <1278319605-12115-1-git-send-email-philippe.langlais@stericsson.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some modifications in 16550A/8250 serial driver
and clock management specificity

Signed-off-by: Philippe Langlais <philippe.langlais@stericsson.com>
---
 drivers/serial/8250.c       |   26 ++++++-
 drivers/serial/8250_u6.c    |  179 +++++++++++++++++++++++++++++++++++++++++++
 drivers/serial/Kconfig      |   19 +++++
 drivers/serial/Makefile     |    1 +
 include/linux/serial_8250.h |    8 ++
 5 files changed, 232 insertions(+), 1 deletions(-)
 create mode 100644 drivers/serial/8250_u6.c

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 607ed7f..269950f 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -199,10 +199,16 @@ static const struct serial8250_config uart_config[] = {
 	},
 	[PORT_16550A] = {
 		.name		= "16550A",
+#if defined(CONFIG_SERIAL_8250_U6XXX)
+		.fifo_size	= 64,
+		.tx_loadsz	= 64,
+		.flags		= UART_CAP_FIFO | UART_CAP_AFE,
+#else
 		.fifo_size	= 16,
 		.tx_loadsz	= 16,
-		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
 		.flags		= UART_CAP_FIFO,
+#endif
+		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
 	},
 	[PORT_CIRRUS] = {
 		.name		= "Cirrus",
@@ -2268,6 +2274,13 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
 	/*
 	 * Ask the core to calculate the divisor for us.
 	 */
+#ifdef CONFIG_SERIAL_8250_CUSTOM_CLOCK
+	baud = uart_get_baud_rate(port, termios, old, 0,
+			CONFIG_SERIAL_8250_CUSTOM_MAX_BAUDRATE);
+	/* Calculate the new uart clock frequency if it is tunable */
+	port->uartclk = serial8250_get_custom_clock(port, baud);
+#endif
+
 	baud = uart_get_baud_rate(port, termios, old,
 				  port->uartclk / 16 / 0xffff,
 				  port->uartclk / 16);
@@ -2298,6 +2311,13 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
 		up->mcr &= ~UART_MCR_AFE;
 		if (termios->c_cflag & CRTSCTS)
 			up->mcr |= UART_MCR_AFE;
+#if defined(CONFIG_SERIAL_8250_U6XXX)
+		/**
+		 * When AFE is active, let the HW handle the stop/restart TX
+		 * upon CTS change. It reacts much quicker than the SW driver.
+		 */
+		port->flags &= ~ASYNC_CTS_FLOW;
+#endif
 	}
 
 	/*
@@ -2383,6 +2403,10 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
 		serial_outp(up, UART_LCR, cval | UART_LCR_DLAB);/* set DLAB */
 	}
 
+#ifdef CONFIG_SERIAL_8250_CUSTOM_CLOCK
+	/* set the new uart clock frequency if it is tunable */
+	serial8250_set_custom_clock(port);
+#endif
 	serial_dl_write(up, quot);
 
 	/*
diff --git a/drivers/serial/8250_u6.c b/drivers/serial/8250_u6.c
new file mode 100644
index 0000000..bcc0f98
--- /dev/null
+++ b/drivers/serial/8250_u6.c
@@ -0,0 +1,179 @@
+/*
+ * linux/drivers/serial/8250_pnx.c
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Ludovic Barre <ludovic.barre@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/serial_core.h>
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+
+#include <mach/serial.h>
+#include <mach/hardware.h>
+#include <mach/clock.h>
+
+/* Register description for FDIV_CTRL */
+/* UART FDIV_CTRL Register (8 bits) */
+#define UARTX_FDIV_CTRL_OFFSET         0xC00
+/* UART FDIV_M Register (16 bits) */
+#define UARTX_FDIV_M_OFFSET            0xC04
+/* UART FDIV_N Register (16 bits) */
+#define UARTX_FDIV_N_OFFSET            0xC08
+
+/* Bits definition for register UARTX_FDIV_CTRL */
+#define UARTX_FDIV_ENABLE_SHIFT  7
+#define UARTX_FDIV_ENABLE_FIELD  (0xFFFFFFFF - (0x1UL<<UARTX_FDIV_ENABLE_SHIFT))
+#define UARTX_FDIV_ENABLE_OFF    (0x0UL<<UARTX_FDIV_ENABLE_SHIFT)
+#define UARTX_FDIV_ENABLE_ON     (0x1UL<<UARTX_FDIV_ENABLE_SHIFT)
+#define UARTX_FDIV_ENABLE        (0x1UL<<UARTX_FDIV_ENABLE_SHIFT)
+#define UARTX_CLKSEL_SHIFT       0
+#define UARTX_CLKSEL_FIELD       (0xFFFFFFFF - (0x3UL<<UARTX_CLKSEL_SHIFT))
+#define UARTX_CLKSEL_PCLK        (0x0UL<<UARTX_CLKSEL_SHIFT)
+#define UARTX_CLKSEL_13M         (0x1UL<<UARTX_CLKSEL_SHIFT)
+#define UARTX_CLKSEL_26M         (0x2UL<<UARTX_CLKSEL_SHIFT)
+#define UARTX_CLKSEL_3           (0x3UL<<UARTX_CLKSEL_SHIFT)
+
+/*
+ * console and pctools has needed to start before serial_init
+ * (with cgu interface)
+ */
+static int uart_enable_clock(struct uart_port *port)
+{
+	u32 v;
+	v = readl(CGU_GATESC1_REG);
+
+	if (port->irq == IRQ_UART1)
+		v |= CGU_UART1EN_1;
+	else if (port->irq == IRQ_UART2)
+		v |= CGU_UART2EN_1;
+
+	writel(v, CGU_GATESC1_REG);
+
+	return 0;
+}
+
+static int uart_disable_clock(struct uart_port *port)
+{
+	u32 v;
+	v = readl(CGU_GATESC1_REG);
+
+	if (port->irq == IRQ_UART1)
+		v &= ~CGU_UART1EN_0;
+	else if (port->irq == IRQ_UART2)
+		v &= ~CGU_UART2EN_0;
+
+	writel(v, CGU_GATESC1_REG);
+
+	return 0;
+}
+
+unsigned int serial8250_enable_clock(struct uart_port *port)
+{
+	struct u6_uart *uart_u6 = port->private_data;
+
+	if (!uart_u6)
+		return uart_enable_clock(port);
+
+	if (IS_ERR(uart_u6->uartClk)) {
+		printk(KERN_WARNING "%s - uart clock failed error:%ld\n",
+		       __func__, PTR_ERR(uart_u6->uartClk));
+		return PTR_ERR(uart_u6->uartClk);
+	}
+
+	if (clk_get_usecount(uart_u6->uartClk) == 0)
+		clk_enable(uart_u6->uartClk);
+	return 0;
+}
+
+unsigned int serial8250_disable_clock(struct uart_port *port)
+{
+	struct u6_uart *uart_u6 = port->private_data;
+
+	if (!uart_u6)
+		return uart_disable_clock(port);
+
+	if (IS_ERR(uart_u6->uartClk)) {
+		printk(KERN_WARNING "%s - uart clk error :%ld\n", __func__,
+		       PTR_ERR(uart_u6->uartClk));
+		return PTR_ERR(uart_u6->uartClk);
+	}
+	if (clk_get_usecount(uart_u6->uartClk) >= 1)
+		clk_disable(uart_u6->uartClk);
+
+	return 0;
+}
+
+unsigned int serial8250_get_custom_clock(struct uart_port *port,
+					 unsigned int baud)
+{
+	switch (baud) {
+	case 3250000:
+		return 52000000;
+	case 2000000:
+		return 32000000;
+	case 1843200:
+		return 29491200;
+	case 921600:
+		return 14745600;
+	default:
+		return 7372800;
+	}
+}
+
+void serial8250_set_custom_clock(struct uart_port *port)
+{
+	u32 fdiv_m = 0x5F37;
+	u32 fdiv_n = 0x3600;
+	u32 fdiv_ctrl = UARTX_FDIV_ENABLE_ON;
+	struct u6_uart *uart_u6 = port->private_data;
+
+	switch (port->uartclk) {
+	case 7372800: /* clk=13MHz */
+		fdiv_ctrl |= UARTX_CLKSEL_13M;
+		break;
+	case 14745600: /* clk=26MHz */
+		fdiv_ctrl |= UARTX_CLKSEL_26M;
+		break;
+	case 29491200: /* clk=pclk */
+		fdiv_ctrl |= UARTX_CLKSEL_PCLK;
+		break;
+	case 32000000: /* clk=pclk */
+		fdiv_n = 0x3A98;
+		fdiv_ctrl |= UARTX_CLKSEL_PCLK;
+		break;
+	case 52000000: /* clk=pclk */
+		fdiv_n = 0x5F37;
+		fdiv_ctrl |= UARTX_CLKSEL_PCLK;
+		break;
+	}
+
+	if (uart_u6 != NULL && !IS_ERR(uart_u6->uartClk)) {
+		/* if cgu interface is ready and u6_serial_init */
+		struct clk *parentClk;
+
+		if (fdiv_ctrl & UARTX_CLKSEL_26M)
+			parentClk = clk_get(NULL, "clk26m_ck");
+		else if (fdiv_ctrl & UARTX_CLKSEL_PCLK)
+			parentClk = clk_get(NULL, "pclk2_ck");
+		else
+			parentClk = clk_get(NULL, "clk13m_ck");
+
+		if (!IS_ERR(parentClk)) {
+			serial8250_disable_clock(port);
+
+			if (clk_set_parent(uart_u6->uartClk, parentClk) != 0)
+				printk(KERN_WARNING "%s: set parent failed\n", __func__);
+
+			serial8250_enable_clock(port);
+			clk_put(parentClk);
+		}
+	}
+
+	writel(fdiv_m, port->membase + UARTX_FDIV_M_OFFSET);
+	writel(fdiv_n, port->membase + UARTX_FDIV_N_OFFSET);
+	writel(fdiv_ctrl, port->membase + UARTX_FDIV_CTRL_OFFSET);
+}
diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 45ad290..ce93eae 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -163,6 +163,25 @@ config SERIAL_8250_MANY_PORTS
 	  say N here to save some memory. You can also say Y if you have an
 	  "intelligent" multiport card such as Cyclades, Digiboards, etc.
 
+config SERIAL_8250_U6XXX
+	bool
+	depends on SERIAL_8250_EXTENDED && PLAT_U6XXX
+	default y
+
+config SERIAL_8250_CUSTOM_CLOCK
+	bool "Support serial ports with tunable input clock frequency"
+	depends on SERIAL_8250_EXTENDED && SERIAL_8250_U6XXX
+	default y
+	help
+	  Say Y here if your platform has specific registers to change UART clock frequency.
+
+config SERIAL_8250_CUSTOM_MAX_BAUDRATE
+	int "Maximal reachable baudrate"
+	depends on SERIAL_8250_CUSTOM_CLOCK
+	default "3250000"
+	help
+	  The value of the maximal reachable baudrate when tuning UART clock frequency (default value: 3.25MBds).
+
 #
 # Multi-port serial cards
 #
diff --git a/drivers/serial/Makefile b/drivers/serial/Makefile
index a5edb49..dca7c9a 100644
--- a/drivers/serial/Makefile
+++ b/drivers/serial/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_SERIAL_8250_BOCA) += 8250_boca.o
 obj-$(CONFIG_SERIAL_8250_EXAR_ST16C554) += 8250_exar_st16c554.o
 obj-$(CONFIG_SERIAL_8250_HUB6) += 8250_hub6.o
 obj-$(CONFIG_SERIAL_8250_MCA) += 8250_mca.o
+obj-$(CONFIG_SERIAL_8250_U6XXX) += 8250_u6.o
 obj-$(CONFIG_SERIAL_AMBA_PL010) += amba-pl010.o
 obj-$(CONFIG_SERIAL_AMBA_PL011) += amba-pl011.o
 obj-$(CONFIG_SERIAL_CLPS711X) += clps711x.o
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index fb46aba..3e86ceb 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -72,4 +72,12 @@ extern int serial8250_find_port(struct uart_port *p);
 extern int serial8250_find_port_for_earlycon(void);
 extern int setup_early_serial8250_console(char *cmdline);
 
+#ifdef CONFIG_SERIAL_8250_CUSTOM_CLOCK
+unsigned int serial8250_enable_clock(struct uart_port *port);
+unsigned int serial8250_disable_clock(struct uart_port *port);
+unsigned int serial8250_get_custom_clock(struct uart_port *port,
+		unsigned int baud);
+void serial8250_set_custom_clock(struct uart_port *port);
+#endif
+
 #endif
-- 
1.7.1


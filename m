Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760318Ab0HENBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 09:01:16 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:41708 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759214Ab0HENBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 09:01:14 -0400
From: Philippe Langlais <philippe.langlais@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: Philippe Langlais <philippe.langlais@stericsson.com>
Subject: [PATCH 4/5] U6715 platform serial driver It's a generic driver for all U6 platform
Date: Thu, 5 Aug 2010 14:58:25 +0200
Message-ID: <1281013106-26119-4-git-send-email-philippe.langlais@stericsson.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1281013106-26119-3-git-send-email-philippe.langlais@stericsson.com>
References: <1281013106-26119-3-git-send-email-philippe.langlais@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clock specificity:
  It's parent clock depend on baud rate.
  The UART port can be used before u6xxx clock framework initialization

Signed-off-by: Philippe Langlais <philippe.langlais@stericsson.com>
---
 arch/arm/plat-u6xxx/Makefile              |    2 +-
 arch/arm/plat-u6xxx/include/mach/serial.h |   23 +++
 arch/arm/plat-u6xxx/serial.c              |  268 +++++++++++++++++++++++++++++
 3 files changed, 292 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/plat-u6xxx/include/mach/serial.h
 create mode 100644 arch/arm/plat-u6xxx/serial.c

diff --git a/arch/arm/plat-u6xxx/Makefile b/arch/arm/plat-u6xxx/Makefile
index 3d6898e..f12068c 100644
--- a/arch/arm/plat-u6xxx/Makefile
+++ b/arch/arm/plat-u6xxx/Makefile
@@ -3,6 +3,6 @@
 #
 
 # Common support
-obj-y := io.o irq.o clock.o gpio.o
+obj-y := io.o irq.o clock.o gpio.o serial.o
 
 obj-$(CONFIG_U6_MTU_TIMER) += timer.o
diff --git a/arch/arm/plat-u6xxx/include/mach/serial.h b/arch/arm/plat-u6xxx/include/mach/serial.h
new file mode 100644
index 0000000..321e406
--- /dev/null
+++ b/arch/arm/plat-u6xxx/include/mach/serial.h
@@ -0,0 +1,23 @@
+/*
+ * linux/arch/arm/plat-u6xxx/include/mach/serial.h
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Ludovic Barre <ludovic.barre@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+
+#ifndef __SERIAL_H
+#define __SERIAL_H
+
+#include <linux/clk.h>
+
+struct u6_uart {
+	struct clk *uartClk;
+	char   uart_name[7];
+};
+
+extern unsigned int u6_serial8250_enable_clock(struct uart_port *port);
+extern unsigned int u6_serial8250_disable_clock(struct uart_port *port);
+
+#endif   /* __SERIAL_H */
diff --git a/arch/arm/plat-u6xxx/serial.c b/arch/arm/plat-u6xxx/serial.c
new file mode 100644
index 0000000..85dbbb6
--- /dev/null
+++ b/arch/arm/plat-u6xxx/serial.c
@@ -0,0 +1,268 @@
+/*
+ * linux/arch/arm/plat-u6xxx/serial.c
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors: Ludovic Barre <ludovic.barre@stericsson.com> for ST-Ericsson.
+ *         Philippe Langlais <philippe.langlais@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ * U6 cpu type detection
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/serial_8250.h>
+#include <linux/slab.h>
+
+#include <mach/hardware.h>
+#include <mach/serial.h>
+#include <mach/clock.h>
+
+#define U6_MAX_BAUDRATE 3250000  /* 3.25MBds is the maximum baudrate supported */
+#define BASE_BAUD	7372800
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
+ * (without cgu interface)
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
+unsigned int u6_serial8250_enable_clock(struct uart_port *port)
+{
+	struct u6_uart *uart_u6 = port->private_data;
+
+	if (!uart_u6)
+		return uart_enable_clock(port);
+
+	if (IS_ERR(uart_u6->uartClk)) {
+		pr_warning("%s - uart clock failed error:%ld\n",
+		       __func__, PTR_ERR(uart_u6->uartClk));
+		return PTR_ERR(uart_u6->uartClk);
+	}
+
+	clk_enable(uart_u6->uartClk);
+
+	return 0;
+}
+
+unsigned int u6_serial8250_disable_clock(struct uart_port *port)
+{
+	struct u6_uart *uart_u6 = port->private_data;
+
+	if (!uart_u6)
+		return uart_disable_clock(port);
+
+	if (IS_ERR(uart_u6->uartClk)) {
+		pr_warning("%s - uart clk error :%ld\n", __func__,
+		       PTR_ERR(uart_u6->uartClk));
+		return PTR_ERR(uart_u6->uartClk);
+	}
+	clk_disable(uart_u6->uartClk);
+
+	return 0;
+}
+
+static unsigned int u6_get_setdiv_clock(struct uart_port *port,
+					 unsigned int baud)
+{
+	unsigned int uartclk;
+	u32 fdiv_m = 0x5F37;
+	u32 fdiv_n = 0x3600;
+	u32 fdiv_ctrl = UARTX_FDIV_ENABLE_ON;
+	struct u6_uart *uart_u6 = port->private_data;
+
+	/*  Compute uart clock from baudrate */
+	if (baud > 2000000)
+		uartclk = 52000000;
+	else if (baud > 1843200)
+		uartclk = 32000000;
+	else if (baud > 921600)
+		uartclk = 29491200;
+	else if (baud > 460800)
+		uartclk = 14745600;
+	else
+		uartclk = 7372800;
+
+	/* Set divisors & parent clock accordingly */
+	switch (uartclk) {
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
+		/* if clock interface is ready and u6_serial_init */
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
+			u6_serial8250_disable_clock(port);
+
+			if (clk_set_parent(uart_u6->uartClk, parentClk) != 0)
+				pr_warning("%s: set parent failed\n", __func__);
+
+			u6_serial8250_enable_clock(port);
+			clk_put(parentClk);
+		}
+	}
+
+	writel(fdiv_m, port->membase + UARTX_FDIV_M_OFFSET);
+	writel(fdiv_n, port->membase + UARTX_FDIV_N_OFFSET);
+	writel(fdiv_ctrl, port->membase + UARTX_FDIV_CTRL_OFFSET);
+	return uartclk;
+}
+
+static void u6_set_termios(struct uart_port *port,
+		struct ktermios *termios, struct ktermios *old)
+{
+	unsigned int baud;
+
+	baud = uart_get_baud_rate(port, termios, old, 0, U6_MAX_BAUDRATE);
+	/* Calculate the new uart clock frequency & set divisors */
+	port->uartclk = u6_get_setdiv_clock(port, baud);
+	/* Call standard 8250 set_termios() */
+	serial8250_do_set_termios(port, termios, old);
+}
+
+/*
+ * Internal UARTs need to be initialized for the 8250 autoconfig to work
+ * properly.
+ */
+static struct plat_serial8250_port serial_platform_data[] = {
+	{
+		.membase	= U6_IO_ADDRESS(UART1_BASE),
+		.mapbase	= UART1_BASE,
+		.irq		= IRQ_UART1,
+		.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,
+		.iotype		= UPIO_MEM,
+		.regshift	= 2,
+		.uartclk	= BASE_BAUD,
+		.set_termios	= u6_set_termios,
+	},
+	{
+		.membase	= U6_IO_ADDRESS(UART2_BASE),
+		.mapbase	= UART2_BASE,
+		.irq		= IRQ_UART2,
+		.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,
+		.iotype		= UPIO_MEM,
+		.regshift	= 2,
+		.uartclk	= BASE_BAUD,
+		.set_termios	= u6_set_termios,
+	},
+	/* void declaration needed by serial core */
+	{
+		.flags		= 0
+	},
+};
+
+static struct platform_device serial_device = {
+	.name = "serial8250",
+	.id = 0,
+	.dev = {.platform_data = serial_platform_data,},
+};
+
+static int __init u6_serial_init(void)
+{
+	int i;
+	struct u6_uart *uart_u6;
+
+	/* supress void element from loop */
+	for (i = 0; i < (ARRAY_SIZE(serial_platform_data) - 1); i++) {
+		struct clk *uartClk = NULL;
+
+		/* Allocation of u6 struct on uart X */
+		uart_u6 = kzalloc(sizeof(*uart_u6), GFP_KERNEL);
+		if (!uart_u6)
+			continue;
+
+		if (serial_platform_data[i].irq == IRQ_UART1) {
+			uartClk = clk_get(NULL, "UART1");
+			strcpy(uart_u6->uart_name, "UART1");
+		} else if (serial_platform_data[i].irq == IRQ_UART2) {
+			uartClk = clk_get(NULL, "UART2");
+			strcpy(uart_u6->uart_name, "UART2");
+		}
+		if (!IS_ERR(uartClk) && uartClk != NULL) {
+			uart_u6->uartClk = uartClk;
+			serial_platform_data[i].private_data = uart_u6;
+			/*  Clock Uart for autoconfigure detection */
+			clk_enable(uartClk);
+		} else {
+			pr_warning("%s - get uart clock failed error:%ld\n",
+			       __func__, PTR_ERR(uartClk));
+			kfree(uart_u6);
+			continue;
+		}
+	}
+	return platform_device_register(&serial_device);
+}
+
+arch_initcall(u6_serial_init);
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab1FIO7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 10:59:16 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:42531 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab1FIO7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 10:59:13 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH RFC] pch_uart: Add console support
Date: Thu,  9 Jun 2011 16:59:07 +0200
Message-Id: <1307631547-31884-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add console support to pch_uart. To enable append e.g.
console=ttyPCH0,115200 to your kernel command line.

Expected issues:
* Should not work on CM-iTC boards due to different clock.

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
 drivers/tty/serial/Kconfig    |    9 +++
 drivers/tty/serial/pch_uart.c |  159 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 167 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 636144c..69115fe 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1600,6 +1600,15 @@ config SERIAL_PCH_UART
 	  ML7213/ML7223 is companion chip for Intel Atom E6xx series.
 	  ML7213/ML7223 is completely compatible for Intel EG20T PCH.
 
+config SERIAL_PCH_UART_CONSOLE
+	bool "Support for console on Intel EG20T PCH UART/OKI SEMICONDUCTOR ML7213 IOH"
+	depends on SERIAL_PCH_UART=y
+	select SERIAL_CORE_CONSOLE
+	help
+	  Say Y here if you wish to use the PCH UART as the system console
+	  (the system  console is the device which receives all kernel messages and
+	  warnings and which allows logins in single user mode).
+
 config SERIAL_MSM_SMD
 	bool "Enable tty device interface for some SMD ports"
 	default n
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index e3e6d6b..a3d0c9e 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -22,6 +22,9 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/dmi.h>
+#include <linux/console.h>
+#include <linux/nmi.h>
+#include <linux/delay.h>
 
 #include <linux/dmaengine.h>
 #include <linux/pch_dma.h>
@@ -197,6 +200,10 @@ enum {
 
 #define PCI_VENDOR_ID_ROHM		0x10DB
 
+#define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
+
+#define DEFAULT_BAUD_RATE 1843200 /* 1.8432MHz */
+
 struct pch_uart_buffer {
 	unsigned char *buf;
 	int size;
@@ -271,6 +278,9 @@ static struct pch_uart_driver_data drv_dat[] = {
 	[pch_ml7223_uart1] = {PCH_UART_2LINE, 1},
 };
 
+#ifdef CONFIG_SERIAL_PCH_UART_CONSOLE
+static struct eg20t_port *pch_uart_ports[PCH_UART_NR];
+#endif
 static unsigned int default_baud = 9600;
 static const int trigger_level_256[4] = { 1, 64, 128, 224 };
 static const int trigger_level_64[4] = { 1, 16, 32, 56 };
@@ -1378,6 +1388,143 @@ static struct uart_ops pch_uart_ops = {
 	.verify_port = pch_uart_verify_port
 };
 
+#ifdef CONFIG_SERIAL_PCH_UART_CONSOLE
+
+/*
+ *	Wait for transmitter & holding register to empty
+ */
+static void wait_for_xmitr(struct eg20t_port *up, int bits)
+{
+	unsigned int status, tmout = 10000;
+
+	/* Wait up to 10ms for the character(s) to be sent. */
+	for (;;) {
+		status = ioread8(up->membase + UART_LSR);
+
+		if ((status & bits) == bits)
+			break;
+		if (--tmout == 0)
+			break;
+		udelay(1);
+	}
+
+	/* Wait up to 1s for flow control if necessary */
+	if (up->port.flags & UPF_CONS_FLOW) {
+		unsigned int tmout;
+		for (tmout = 1000000; tmout; tmout--) {
+			unsigned int msr = ioread8(up->membase + UART_MSR);
+			if (msr & UART_MSR_CTS)
+				break;
+			udelay(1);
+			touch_nmi_watchdog();
+		}
+	}
+}
+
+static void pch_console_putchar(struct uart_port *port, int ch)
+{
+	struct eg20t_port *priv =
+		container_of(port, struct eg20t_port, port);
+
+	wait_for_xmitr(priv, UART_LSR_THRE);
+	iowrite8(ch, priv->membase + PCH_UART_THR);
+}
+
+/*
+ *	Print a string to the serial port trying not to disturb
+ *	any possible real use of the port...
+ *
+ *	The console_lock must be held when we get here.
+ */
+static void
+pch_console_write(struct console *co, const char *s, unsigned int count)
+{
+	struct eg20t_port *priv;
+
+	unsigned long flags;
+	u8 ier;
+	int locked = 1;
+
+	priv = pch_uart_ports[co->index];
+
+	touch_nmi_watchdog();
+
+	local_irq_save(flags);
+	if (priv->port.sysrq) {
+		/* serial8250_handle_port() already took the lock */
+		locked = 0;
+	} else if (oops_in_progress) {
+		locked = spin_trylock(&priv->port.lock);
+	} else
+		spin_lock(&priv->port.lock);
+
+	/*
+	 *	First save the IER then disable the interrupts
+	 */
+	ier = ioread8(priv->membase + UART_IER);
+
+	pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_ALL_INT);
+
+	uart_console_write(&priv->port, s, count, pch_console_putchar);
+
+	/*
+	 *	Finally, wait for transmitter to become empty
+	 *	and restore the IER
+	 */
+	wait_for_xmitr(priv, BOTH_EMPTY);
+	iowrite8(ier, priv->membase + UART_IER);
+
+	if (locked)
+		spin_unlock(&priv->port.lock);
+	local_irq_restore(flags);
+}
+
+static int __init pch_console_setup(struct console *co, char *options)
+{
+	struct uart_port *port;
+	int baud = 9600;
+	int bits = 8;
+	int parity = 'n';
+	int flow = 'n';
+
+	/*
+	 * Check whether an invalid uart number has been specified, and
+	 * if so, search for the first available port that does have
+	 * console support.
+	 */
+	if (co->index >= PCH_UART_NR)
+		co->index = 0;
+	port = &pch_uart_ports[co->index]->port;
+
+	if (!port || (!port->iobase && !port->membase))
+		return -ENODEV;
+
+	/* setup uartclock */
+	port->uartclk = DEFAULT_BAUD_RATE;
+
+	if (options)
+		uart_parse_options(options, &baud, &parity, &bits, &flow);
+
+	return uart_set_options(port, co, baud, parity, bits, flow);
+}
+
+static struct uart_driver pch_uart_driver;
+
+static struct console pch_console = {
+	.name		= PCH_UART_DRIVER_DEVICE,
+	.write		= pch_console_write,
+	.device		= uart_console_device,
+	.setup		= pch_console_setup,
+	.flags		= CON_PRINTBUFFER | CON_ANYTIME,
+	.index		= -1,
+	.data		= &pch_uart_driver,
+};
+
+#define PCH_CONSOLE	&pch_console
+#else
+#define PCH_CONSOLE	NULL
+#endif
+
 static struct uart_driver pch_uart_driver = {
 	.owner = THIS_MODULE,
 	.driver_name = KBUILD_MODNAME,
@@ -1385,6 +1532,7 @@ static struct uart_driver pch_uart_driver = {
 	.major = 0,
 	.minor = 0,
 	.nr = PCH_UART_NR,
+	.cons = PCH_CONSOLE,
 };
 
 static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
@@ -1411,7 +1559,7 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	if (!rxbuf)
 		goto init_port_free_txbuf;
 
-	base_baud = 1843200; /* 1.8432MHz */
+	base_baud = DEFAULT_BAUD_RATE;
 
 	/* quirk for CM-iTC board */
 	board_name = dmi_get_system_info(DMI_BOARD_NAME);
@@ -1459,6 +1607,9 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	pci_set_drvdata(pdev, priv);
 	pch_uart_hal_request(pdev, fifosize, base_baud);
 
+#ifdef CONFIG_SERIAL_PCH_UART_CONSOLE
+	pch_uart_ports[board->line_no] = priv;
+#endif
 	ret = uart_add_one_port(&pch_uart_driver, &priv->port);
 	if (ret < 0)
 		goto init_port_hal_free;
@@ -1466,6 +1617,9 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	return priv;
 
 init_port_hal_free:
+#ifdef CONFIG_SERIAL_PCH_UART_CONSOLE
+	pch_uart_ports[board->line_no] = NULL;
+#endif
 	free_page((unsigned long)rxbuf);
 init_port_free_txbuf:
 	kfree(priv);
@@ -1486,6 +1640,9 @@ static void pch_uart_pci_remove(struct pci_dev *pdev)
 	struct eg20t_port *priv;
 
 	priv = (struct eg20t_port *)pci_get_drvdata(pdev);
+#ifdef CONFIG_SERIAL_PCH_UART_CONSOLE
+	pch_uart_ports[priv->port.line] = NULL;
+#endif
 	pch_uart_exit_port(priv);
 	pci_disable_device(pdev);
 	kfree(priv);
-- 
1.7.3.4


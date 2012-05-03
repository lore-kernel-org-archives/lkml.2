Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab2ECMM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:12:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46544 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab2ECMMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:12:22 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-serial@vger.kernel.org
Cc: horms@verge.net.au, arnd@arndb.de, linux-sh@vger.kernel.org,
        gregkh@linuxfoundation.org, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl,
        paul.gortmaker@windriver.com, lethal@linux-sh.org, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>, dan.j.williams@intel.com,
        alan@linux.intel.com
Date: Thu, 03 May 2012 21:13:09 +0900
Message-Id: <20120503121309.27489.92409.sendpatchset@w520>
Subject: [PATCH] serial8250-em: Emma Mobile UART driver V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This is V2 of the Emma Mobile 8250 platform driver.

The hardware itself has according to the data sheet
up to 64 byte FIFOs but at this point we only make
use of the 16550 compatible mode.

To support this piece of hardware the common UART
registers need to be remapped, and the access size
differences need to be handled.

The DLL and DLM registers can due to offset collision
not be remapped easily, and because of that this
driver makes use of ->dl_read() and ->dl_write()
callbacks. This in turn requires a registration
function that takes 8250-specific paramenters.

Future potential enhancements include DT support,
early platform driver console and fine grained PM.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Developed for the UARTs in Emma Mobile EV2, but should
 in theory also support other SoCs in the Emma Mobile line.

 Changes since V1:
 - Depend on ARM && HAVE_CLK - thanks Paul, Greg and Arnd!
 - Always use UPF_IOREMAP to support a wider range of hardware.

 V1 got feedback from the following people, thanks!
 - Acked-by: Alan Cox <alan@linux.intel.com>
 - Acked-by: Arnd Bergmann <arnd@arndb.de>

 Depends on the first 5 patches in the following series:
 "[PATCH 00/06] serial8250: DLL/DLM rework, Emma Mobile UART driver"

 drivers/tty/serial/8250/8250_em.c |  178 +++++++++++++++++++++++++++++++++++++
 drivers/tty/serial/8250/Kconfig   |    8 +
 drivers/tty/serial/8250/Makefile  |    1 
 3 files changed, 187 insertions(+)

--- /dev/null
+++ work/drivers/tty/serial/8250/8250_em.c	2012-05-03 18:12:18.000000000 +0900
@@ -0,0 +1,178 @@
+/*
+ * Renesas Emma Mobile 8250 driver
+ *
+ *  Copyright (C) 2012 Magnus Damm
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/serial_8250.h>
+#include <linux/serial_core.h>
+#include <linux/serial_reg.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/slab.h>
+
+#include "8250.h"
+
+#define UART_DLL_EM 9
+#define UART_DLM_EM 10
+
+struct serial8250_em_priv {
+	struct clk *sclk;
+	int line;
+};
+
+static void serial8250_em_serial_out(struct uart_port *p, int offset, int value)
+{
+	switch (offset) {
+	case UART_TX: /* TX @ 0x00 */
+		writeb(value, p->membase);
+		break;
+	case UART_FCR: /* FCR @ 0x0c (+1) */
+	case UART_LCR: /* LCR @ 0x10 (+1) */
+	case UART_MCR: /* MCR @ 0x14 (+1) */
+	case UART_SCR: /* SCR @ 0x20 (+1) */
+		writel(value, p->membase + ((offset + 1) << 2));
+		break;
+	case UART_IER: /* IER @ 0x04 */
+		value &= 0x0f; /* only 4 valid bits - not Xscale */
+		/* fall-through */
+	case UART_DLL_EM: /* DLL @ 0x24 (+9) */
+	case UART_DLM_EM: /* DLM @ 0x28 (+9) */
+		writel(value, p->membase + (offset << 2));
+	}
+}
+
+static unsigned int serial8250_em_serial_in(struct uart_port *p, int offset)
+{
+	switch (offset) {
+	case UART_RX: /* RX @ 0x00 */
+		return readb(p->membase);
+	case UART_MCR: /* MCR @ 0x14 (+1) */
+	case UART_LSR: /* LSR @ 0x18 (+1) */
+	case UART_MSR: /* MSR @ 0x1c (+1) */
+	case UART_SCR: /* SCR @ 0x20 (+1) */
+		return readl(p->membase + ((offset + 1) << 2));
+	case UART_IER: /* IER @ 0x04 */
+	case UART_IIR: /* IIR @ 0x08 */
+	case UART_DLL_EM: /* DLL @ 0x24 (+9) */
+	case UART_DLM_EM: /* DLM @ 0x28 (+9) */
+		return readl(p->membase + (offset << 2));
+	}
+	return 0;
+}
+
+static int serial8250_em_serial_dl_read(struct uart_8250_port *up)
+{
+	return serial_in(up, UART_DLL_EM) | serial_in(up, UART_DLM_EM) << 8;
+}
+
+static void serial8250_em_serial_dl_write(struct uart_8250_port *up, int value)
+{
+	serial_out(up, UART_DLL_EM, value & 0xff);
+	serial_out(up, UART_DLM_EM, value >> 8 & 0xff);
+}
+
+static int __devinit serial8250_em_probe(struct platform_device *pdev)
+{
+	struct resource *regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	struct resource *irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	struct serial8250_em_priv *priv;
+	struct uart_8250_port up;
+	int ret = -EINVAL;
+
+	if (!regs || !irq) {
+		dev_err(&pdev->dev, "missing registers or irq\n");
+		goto err0;
+	}
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		dev_err(&pdev->dev, "unable to allocate private data\n");
+		ret = -ENOMEM;
+		goto err0;
+	}
+
+	priv->sclk = clk_get(&pdev->dev, "sclk");
+	if (!priv->sclk) {
+		dev_err(&pdev->dev, "unable to get clock\n");
+		goto err1;
+	}
+
+	memset(&up, 0, sizeof(up));
+	up.port.mapbase = regs->start;
+	up.port.irq = irq->start;
+	up.port.type = PORT_UNKNOWN;
+	up.port.flags = UPF_BOOT_AUTOCONF | UPF_FIXED_PORT | UPF_IOREMAP;
+	up.port.dev = &pdev->dev;
+	up.port.private_data = priv;
+
+	clk_enable(priv->sclk);
+	up.port.uartclk = clk_get_rate(priv->sclk);
+
+	up.port.iotype = UPIO_MEM32;
+	up.port.serial_in = serial8250_em_serial_in;
+	up.port.serial_out = serial8250_em_serial_out;
+	up.dl_read = serial8250_em_serial_dl_read;
+	up.dl_write = serial8250_em_serial_dl_write;
+
+	ret = serial8250_register_8250_port(&up);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "unable to register 8250 port\n");
+		goto err2;
+	}
+
+	priv->line = ret;
+	platform_set_drvdata(pdev, priv);
+	return 0;
+
+ err2:
+	clk_disable(priv->sclk);
+	clk_put(priv->sclk);
+ err1:
+	kfree(priv);
+ err0:
+	return ret;
+}
+
+static int __devexit serial8250_em_remove(struct platform_device *pdev)
+{
+	struct serial8250_em_priv *priv = platform_get_drvdata(pdev);
+
+	serial8250_unregister_port(priv->line);
+	clk_disable(priv->sclk);
+	clk_put(priv->sclk);
+	kfree(priv);
+	return 0;
+}
+
+static struct platform_driver serial8250_em_platform_driver = {
+	.driver = {
+		.name		= "serial8250-em",
+		.owner		= THIS_MODULE,
+	},
+	.probe			= serial8250_em_probe,
+	.remove			= __devexit_p(serial8250_em_remove),
+};
+
+module_platform_driver(serial8250_em_platform_driver);
+
+MODULE_AUTHOR("Magnus Damm");
+MODULE_DESCRIPTION("Renesas Emma Mobile 8250 Driver");
+MODULE_LICENSE("GPL v2");
--- 0001/drivers/tty/serial/8250/Kconfig
+++ work/drivers/tty/serial/8250/Kconfig	2012-05-03 15:19:23.000000000 +0900
@@ -278,3 +278,11 @@ config SERIAL_8250_DW
 	help
 	  Selecting this option will enable handling of the extra features
 	  present in the Synopsys DesignWare APB UART.
+
+config SERIAL_8250_EM
+	tristate "Support for Emma Mobile intergrated serial port"
+	depends on SERIAL_8250 && ARM && HAVE_CLK
+	help
+	  Selecting this option will add support for the integrated serial
+	  port hardware found on the Emma Mobile line of processors.
+	  If unsure, say N.
--- 0001/drivers/tty/serial/8250/Makefile
+++ work/drivers/tty/serial/8250/Makefile	2012-05-03 15:19:23.000000000 +0900
@@ -18,3 +18,4 @@ obj-$(CONFIG_SERIAL_8250_HUB6)		+= 8250_
 obj-$(CONFIG_SERIAL_8250_MCA)		+= 8250_mca.o
 obj-$(CONFIG_SERIAL_8250_FSL)		+= 8250_fsl.o
 obj-$(CONFIG_SERIAL_8250_DW)		+= 8250_dw.o
+obj-$(CONFIG_SERIAL_8250_EM)		+= 8250_em.o

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540Ab2HUUtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 16:49:15 -0400
Received: from mta06.xtra.co.nz ([210.54.141.249]:47516 "EHLO mta03.xtra.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758049Ab2HUUsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 16:48:12 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: vt8500-wm8505-linux-kernel@googlegroup.com
Cc: Tony Prisk <linux@prisktech.co.nz>, Russell King <linux@arm.linux.org.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mike Turquette <mturquette@ti.com>,
        Stephen Warren <swarren@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-serial@vger.kernel.org, rtc-linux@googlegroups.com,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCHv3 3/9] serial: vt8500: Add devicetree support for vt8500-serial
Date: Wed, 22 Aug 2012 08:47:32 +1200
Message-Id: <1345582058-2291-4-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345582058-2291-1-git-send-email-linux@prisktech.co.nz>
References: <1345582058-2291-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/tty/serial/vt8500_serial.c |   37 ++++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/vt8500_serial.c b/drivers/tty/serial/vt8500_serial.c
index 2be006f..72e32db 100644
--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -34,6 +34,7 @@
 #include <linux/slab.h>
 #include <linux/clk.h>
 #include <linux/platform_device.h>
+#include <linux/of.h>
 
 /*
  * UART Register offsets
@@ -76,6 +77,8 @@
 #define RX_FIFO_INTS	(RXFAF | RXFF | RXOVER | PER | FER | RXTOUT)
 #define TX_FIFO_INTS	(TXFAE | TXFE | TXUDR)
 
+#define VT8500_MAX_PORTS	6
+
 struct vt8500_port {
 	struct uart_port	uart;
 	char			name[16];
@@ -83,6 +86,13 @@ struct vt8500_port {
 	unsigned int		ier;
 };
 
+/*
+ * we use this variable to keep track of which ports
+ * have been allocated as we can't use pdev->id in
+ * devicetree
+ */
+static unsigned long vt8500_ports_in_use;
+
 static inline void vt8500_write(struct uart_port *port, unsigned int val,
 			     unsigned int off)
 {
@@ -431,7 +441,7 @@ static int vt8500_verify_port(struct uart_port *port,
 	return 0;
 }
 
-static struct vt8500_port *vt8500_uart_ports[4];
+static struct vt8500_port *vt8500_uart_ports[VT8500_MAX_PORTS];
 static struct uart_driver vt8500_uart_driver;
 
 #ifdef CONFIG_SERIAL_VT8500_CONSOLE
@@ -549,6 +559,7 @@ static int __devinit vt8500_serial_probe(struct platform_device *pdev)
 	struct vt8500_port *vt8500_port;
 	struct resource *mmres, *irqres;
 	int ret;
+	int port;
 
 	mmres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irqres = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
@@ -559,13 +570,25 @@ static int __devinit vt8500_serial_probe(struct platform_device *pdev)
 	if (!vt8500_port)
 		return -ENOMEM;
 
+	/* calculate the port id */
+	port = find_first_zero_bit(&vt8500_ports_in_use,
+				sizeof(vt8500_ports_in_use));
+	if (port > VT8500_MAX_PORTS)
+		return -ENODEV;
+
+	/* reserve the port id */
+	if (test_and_set_bit(port, &vt8500_ports_in_use)) {
+		/* port already in use - shouldn't really happen */
+		return -EBUSY;
+	}
+
 	vt8500_port->uart.type = PORT_VT8500;
 	vt8500_port->uart.iotype = UPIO_MEM;
 	vt8500_port->uart.mapbase = mmres->start;
 	vt8500_port->uart.irq = irqres->start;
 	vt8500_port->uart.fifosize = 16;
 	vt8500_port->uart.ops = &vt8500_uart_pops;
-	vt8500_port->uart.line = pdev->id;
+	vt8500_port->uart.line = port;
 	vt8500_port->uart.dev = &pdev->dev;
 	vt8500_port->uart.flags = UPF_IOREMAP | UPF_BOOT_AUTOCONF;
 	vt8500_port->uart.uartclk = 24000000;
@@ -579,7 +602,7 @@ static int __devinit vt8500_serial_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	vt8500_uart_ports[pdev->id] = vt8500_port;
+	vt8500_uart_ports[port] = vt8500_port;
 
 	uart_add_one_port(&vt8500_uart_driver, &vt8500_port->uart);
 
@@ -603,12 +626,18 @@ static int __devexit vt8500_serial_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id wmt_dt_ids[] = {
+	{ .compatible = "via,vt8500-uart", },
+	{}
+};
+
 static struct platform_driver vt8500_platform_driver = {
 	.probe  = vt8500_serial_probe,
 	.remove = __devexit_p(vt8500_serial_remove),
 	.driver = {
 		.name = "vt8500_serial",
 		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(wmt_dt_ids),
 	},
 };
 
@@ -642,4 +671,4 @@ module_exit(vt8500_serial_exit);
 
 MODULE_AUTHOR("Alexey Charkov <alchark@gmail.com>");
 MODULE_DESCRIPTION("Driver for vt8500 serial device");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5


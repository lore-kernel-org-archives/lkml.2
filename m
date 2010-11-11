Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab0KKVYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 16:24:10 -0500
Received: from atlantis.8hz.com ([212.129.237.78]:60489 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756779Ab0KKVYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 16:24:08 -0500
Date: Thu, 11 Nov 2010 21:24:07 +0000
From: Sean Young <sean@mess.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, jesse.barnes@intel.com,
        David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Subject: [PATCH v2] Fix Winbond CIR and nsc-ircc driver initialisation
Message-ID: <20101111212407.GA96337@atlantis.8hz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Booting a vanilla kernel results in:

[    4.771256] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.771365] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.771452] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
[    4.771674] 00:03: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A

Which prevents the winbond-cir driver from initialising since ttyS1 is
a bastardised serial port, which can only be used for IR using the
winbond-cir driver.

[   13.947470] Winbond CIR 00:03: Region 0x2f8-0x2ff already in use!
[   13.947741] Winbond CIR 00:03: disabled
[   13.947746] Winbond CIR: probe of 00:03 failed with error -16

A workaround is to boot with argument 8250.nr_uarts=1. This is not really
desirable, so this patch makes ttyS1 go away when it's not a real
serial port.

The nsc-ircc suffers from the same problem.

Signed-off-by: Sean Young <sean@mess.org>
---
diff --git a/drivers/input/misc/winbond-cir.c b/drivers/input/misc/winbond-cir.c
index 64f1de7..fa4e9e8 100644
--- a/drivers/input/misc/winbond-cir.c
+++ b/drivers/input/misc/winbond-cir.c
@@ -57,6 +57,7 @@
 #include <linux/bitrev.h>
 #include <linux/bitops.h>
 #include <linux/slab.h>
+#include <linux/serial_8250.h>
 
 #define DRVNAME "winbond-cir"
 
@@ -1392,10 +1393,23 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	}
 
 	if (!request_region(data->sbase, SP_IOMEM_LEN, DRVNAME)) {
-		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
-			data->sbase, data->sbase + SP_IOMEM_LEN - 1);
-		err = -EBUSY;
-		goto exit_release_ebase;
+		bool ok = false;
+#ifdef CONFIG_SERIAL_8250
+		/*
+		 * This device is a hacked serial port which will be
+		 * detected by the serial 8250 driver.
+		 */
+		if (serial8250_port_non_uart(PORT_NS16550A, data->sbase,
+								data->irq)) {
+			ok = request_region(data->sbase, SP_IOMEM_LEN, DRVNAME);
+		}
+#endif
+		if (!ok) {
+			dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
+				data->sbase, data->sbase + SP_IOMEM_LEN - 1);
+			err = -EBUSY;
+			goto exit_release_ebase;
+		}
 	}
 
 	err = request_irq(data->irq, wbcir_irq_handler,
diff --git a/drivers/net/irda/nsc-ircc.c b/drivers/net/irda/nsc-ircc.c
index 559fe85..ccfdfd5 100644
--- a/drivers/net/irda/nsc-ircc.c
+++ b/drivers/net/irda/nsc-ircc.c
@@ -56,6 +56,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/pnp.h>
 #include <linux/platform_device.h>
+#include <linux/serial_8250.h>
 
 #include <asm/io.h>
 #include <asm/dma.h>
@@ -406,6 +407,13 @@ static int __init nsc_ircc_open(chipio_t *info)
 	
 	/* Reserve the ioports that we need */
 	ret = request_region(self->io.fir_base, self->io.fir_ext, driver_name);
+#ifdef CONFIG_SERIAL_8250
+	if (!ret && serial8250_port_non_uart(PORT_NS16550A, self->io.fir_base,
+								self->io.irq)) {
+		ret = request_region(self->io.fir_base,
+						self->io.fir_ext, driver_name);
+	}
+#endif
 	if (!ret) {
 		IRDA_WARNING("%s(), can't get iobase of 0x%03x\n",
 			     __func__, self->io.fir_base);
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 4d8e14b..6a30e05 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -3231,6 +3231,25 @@ void serial8250_unregister_port(int line)
 }
 EXPORT_SYMBOL(serial8250_unregister_port);
 
+bool serial8250_port_non_uart(uint type, uint iobase, uint irq)
+{
+	int i;
+
+	for (i = 0; i < UART_NR; i++) {
+		struct uart_port *p = &serial8250_ports[i].port;
+
+		if (p->iobase == iobase && p->irq == irq && p->type == type) {
+			printk(KERN_INFO "ttyS%d: not in uart mode\n",
+							serial_index(p));
+			serial8250_unregister_port(i);
+			return true;
+		}
+	}
+
+	return false;
+}
+EXPORT_SYMBOL(serial8250_port_non_uart);
+
 static int __init serial8250_init(void)
 {
 	int ret;
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index 97f5b45..30cf6df 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -70,6 +70,7 @@ int serial8250_register_port(struct uart_port *);
 void serial8250_unregister_port(int line);
 void serial8250_suspend_port(int line);
 void serial8250_resume_port(int line);
+bool serial8250_port_non_uart(uint type, uint iobase, uint irq);
 
 extern int early_serial_setup(struct uart_port *port);
 

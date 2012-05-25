Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964850Ab2EYPtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 11:49:22 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:51510 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932558Ab2EYPtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 11:49:15 -0400
Date: Fri, 25 May 2012 17:48:57 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, Russell King <linux@arm.linux.org.uk>,
        x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 6/6] serial: add amba-pl011-pci
Message-ID: <b166cb0fce2a67b24da5808604553b4196258f45.1337959750.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1337959750.git.rubini@gnudd.com>
In-Reply-To: <cover.1337959750.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a simple PCI driver that registers an amba device
in its probe function. It successfully drives the 4 serial
ports of the sta2x11 I/O Hub.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/Kconfig          |   10 +++-
 drivers/tty/serial/Makefile         |    1 +
 drivers/tty/serial/amba-pl011-pci.c |  101 +++++++++++++++++++++++++++++++++++
 3 files changed, 111 insertions(+), 1 deletions(-)
 create mode 100644 drivers/tty/serial/amba-pl011-pci.c

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 070b442..e5e5ef6 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -39,14 +39,22 @@ config SERIAL_AMBA_PL010_CONSOLE
 config SERIAL_AMBA_PL011
 	tristate "ARM AMBA PL011 serial port support"
 	depends on ARM_AMBA
+	default y if STA2X11
 	select SERIAL_CORE
 	help
 	  This selects the ARM(R) AMBA(R) PrimeCell PL011 UART.  If you have
 	  an Integrator/PP2, Integrator/CP or Versatile platform, say Y or M
-	  here.
+	  here. This is also needed to use the sta2x11 I/O Hub for Atom.
 
 	  If unsure, say N.
 
+config SERIAL_AMBA_PL011_PCI
+	tristate "ARM AMBA PL011 behind a PCI-to-AMBA bridge"
+	depends on SERIAL_AMBA_PL011 && PCI
+	default y if STA2X11
+	help
+	  Say Y if your AMBA bus is behind a PCI bridge (e.g.: sta2x11)
+
 config SERIAL_AMBA_PL011_CONSOLE
 	bool "Support for console on AMBA serial port"
 	depends on SERIAL_AMBA_PL011=y
diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
index 7257c5d..b8cd14b 100644
--- a/drivers/tty/serial/Makefile
+++ b/drivers/tty/serial/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_SERIAL_8250) += 8250/
 
 obj-$(CONFIG_SERIAL_AMBA_PL010) += amba-pl010.o
 obj-$(CONFIG_SERIAL_AMBA_PL011) += amba-pl011.o
+obj-$(CONFIG_SERIAL_AMBA_PL011_PCI) += amba-pl011-pci.o
 obj-$(CONFIG_SERIAL_CLPS711X) += clps711x.o
 obj-$(CONFIG_SERIAL_PXA) += pxa.o
 obj-$(CONFIG_SERIAL_PNX8XXX) += pnx8xxx_uart.o
diff --git a/drivers/tty/serial/amba-pl011-pci.c b/drivers/tty/serial/amba-pl011-pci.c
new file mode 100644
index 0000000..b3aa0f1
--- /dev/null
+++ b/drivers/tty/serial/amba-pl011-pci.c
@@ -0,0 +1,101 @@
+/*
+ * Support for AMBA pl011 uart behind a PCI bridge
+ * Copyright 2012 ST Microelectronics (Alessandro Rubini)
+ * GNU GPL version 2.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/amba/bus.h>
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+#include <linux/slab.h>
+#include <linux/irq.h>
+#include <linux/sizes.h>
+#include <linux/amba/serial.h>
+
+/* This is a template, copied every time a new pci device appears */
+static AMBA_APB_DEVICE(pl011_pci_template, "pl011-pci", 0,
+		       0 /* base */, {0} /* irqs */, NULL /* data */);
+
+static int __devinit pl011_pci_probe(struct pci_dev *pdev,
+				     const struct pci_device_id *id)
+{
+	struct amba_device *adev;
+	struct amba_pl011_data *data;
+	int ret;
+
+	/* Simply build an amba device and register it */
+	adev = kmemdup(&pl011_pci_template_device,
+			 sizeof(pl011_pci_template_device), GFP_KERNEL);
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!adev || !data) {
+		kfree(adev);
+		kfree(data);
+		return -ENOMEM;
+	}
+	pci_set_master(pdev);
+	pci_enable_msi(pdev);
+	adev->irq[0] = pdev->irq;
+	if (pdev->vendor == PCI_VENDOR_ID_STMICRO) {
+		/* Under sta2x11, DMA is there but limited to 512M */
+		adev->dma_mask = SZ_512M - 1;
+		adev->dev.coherent_dma_mask = SZ_512M - 1;
+	}
+
+	/* Link the pci to amba and the amba to pci */
+	adev->dev.platform_data = data;
+	//data->pdev = pdev;
+	pci_set_drvdata(pdev, adev);
+
+	/* Create a new resource, to be registered as child of the PCI one */
+	adev->res.flags = pdev->resource[0].flags;
+	adev->res.start = pdev->resource[0].start;
+	adev->res.end = adev->res.start + SZ_4K - 1;
+
+	/* change name */
+	adev->dev.init_name = kasprintf(GFP_ATOMIC, "pl011-pci-%02x:%04x",
+				       pdev->bus->number, pdev->devfn);
+
+	printk(KERN_INFO "%s %i\n", __func__, __LINE__);
+	if ((ret = amba_device_register(adev, &pdev->resource[0])) < 0) {
+		kfree(adev);
+		return ret;
+	}
+	return 0;
+};
+
+static void __devexit pl011_pci_remove(struct pci_dev *pdev)
+{
+	struct amba_device *adev = pci_get_drvdata(pdev);
+	amba_device_unregister(adev);
+	kfree(adev->dev.platform_data);
+	kfree(adev);
+}
+
+static DEFINE_PCI_DEVICE_TABLE(pl011_pci_table) = {
+	{PCI_VDEVICE(STMICRO, PCI_DEVICE_ID_STMICRO_UART_HWFC)},
+	{PCI_VDEVICE(STMICRO, PCI_DEVICE_ID_STMICRO_UART_NO_HWFC)},
+	{0,}
+};
+
+static struct pci_driver pl011_pci_driver = {
+	.name		= "pl011-pci",
+	.id_table	= pl011_pci_table,
+	.probe		= pl011_pci_probe,
+	.remove		= __devexit_p(pl011_pci_remove),
+};
+
+static int __init pl011_pci_init(void)
+{
+	return pci_register_driver(&pl011_pci_driver);
+}
+
+static void __exit pl011_pci_exit(void)
+{
+	pci_unregister_driver(&pl011_pci_driver);
+}
+
+module_init(pl011_pci_init);
+module_exit(pl011_pci_exit);
+
-- 
1.7.7.2

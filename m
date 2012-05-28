Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab2E1Qia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 12:38:30 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:43128 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941Ab2E1Qi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 12:38:27 -0400
Date: Mon, 28 May 2012 18:38:10 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, Russell King <linux@arm.linux.org.uk>,
        x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH V2 6/6] drivers/amba: add support for a PCI bridge
Message-ID: <178c7274ce197292f94bfec53e181d77be578f54.1338222461.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1338222460.git.rubini@gnudd.com>
In-Reply-To: <cover.1338222460.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a PCI driver that registers AMBA devices for the range of
supported devices.  It is currently used by STA2X11, which exports
AMBA peripherals under PCIe.  The original AMBA drivers work with no
changes or minimal ones.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/Kconfig         |    2 +
 drivers/amba/Kconfig    |   10 +++++
 drivers/amba/Makefile   |    1 +
 drivers/amba/pci-amba.c |   95 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 108 insertions(+), 0 deletions(-)
 create mode 100644 drivers/amba/Kconfig
 create mode 100644 drivers/amba/pci-amba.c

diff --git a/drivers/Kconfig b/drivers/Kconfig
index c2b0cd2..72d5145 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -150,4 +150,6 @@ source "drivers/vme/Kconfig"
 
 source "drivers/modem_shm/Kconfig"
 
+source "drivers/amba/Kconfig"
+
 endmenu
diff --git a/drivers/amba/Kconfig b/drivers/amba/Kconfig
new file mode 100644
index 0000000..b5b5aca
--- /dev/null
+++ b/drivers/amba/Kconfig
@@ -0,0 +1,10 @@
+
+config PCI_AMBA
+	tristate "PCI-to-AMBA bridge"
+	depends on ARM_AMBA && PCI
+	---help---
+	  This compiles a PCI driver that registers AMBA devices, so
+	  the respective AMBA driver can be used unchanged if you have
+	  a PCI to amba bridge. This is required for STA2X11 support.
+
+	  If uncertain, choose N.
diff --git a/drivers/amba/Makefile b/drivers/amba/Makefile
index 66e81c2..d30e947 100644
--- a/drivers/amba/Makefile
+++ b/drivers/amba/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_ARM_AMBA)		+= bus.o
+obj-$(CONFIG_PCI_AMBA)		+= pci-amba.o
 obj-$(CONFIG_TEGRA_AHB)		+= tegra-ahb.o
diff --git a/drivers/amba/pci-amba.c b/drivers/amba/pci-amba.c
new file mode 100644
index 0000000..12e7a7e
--- /dev/null
+++ b/drivers/amba/pci-amba.c
@@ -0,0 +1,95 @@
+/*
+ * Support for AMBA devices (both APB and AHB) behind a PCI bridge
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
+
+static int __devinit pci_amba_probe(struct pci_dev *pdev,
+				     const struct pci_device_id *id)
+{
+	struct amba_device *adev;
+	char *name;
+	int ret;
+
+	pci_enable_msi(pdev);
+	ret = pci_enable_device(pdev);
+	if (ret)
+		return ret;
+
+	/* Create a name: each of them must be different */
+	name = devm_kzalloc(&pdev->dev, strlen(dev_name(&pdev->dev)) + 6,
+		GFP_KERNEL);
+	sprintf(name, "amba-%s", dev_name(&pdev->dev));
+
+	/* Simply build an amba device and register it */
+	adev = amba_device_alloc(name,  pdev->resource[0].start, SZ_4K);
+	if (!adev)
+		return -ENOMEM;
+	adev->irq[0] = pdev->irq;
+
+	/* This bridge can host both APB and AHB devices, so set master */
+	pci_set_master(pdev);
+	if (pdev->vendor == PCI_VENDOR_ID_STMICRO) {
+		/* Under sta2x11, DMA is there but limited to 512M */
+		adev->dma_mask = SZ_512M - 1;
+		adev->dev.coherent_dma_mask = SZ_512M - 1;
+	}
+
+	adev->dev.platform_data = pdev->dev.platform_data;
+	pci_set_drvdata(pdev, adev);
+
+	if ((ret = amba_device_add(adev, &pdev->resource[0])) < 0)
+		return ret;
+	return 0;
+};
+
+static void __devexit pci_amba_remove(struct pci_dev *pdev)
+{
+	struct amba_device *adev = pci_get_drvdata(pdev);
+	amba_device_unregister(adev);
+	pci_disable_msi(pdev);
+}
+
+static DEFINE_PCI_DEVICE_TABLE(pci_amba_table) = {
+	{PCI_VDEVICE(STMICRO, PCI_DEVICE_ID_STMICRO_UART_HWFC)},
+	{PCI_VDEVICE(STMICRO, PCI_DEVICE_ID_STMICRO_UART_NO_HWFC)},
+	{PCI_VDEVICE(STMICRO, PCI_DEVICE_ID_STMICRO_SOC_DMA)},
+	{PCI_VDEVICE(STMICRO, PCI_DEVICE_ID_STMICRO_I2C)},
+	{PCI_VDEVICE(STMICRO, PCI_DEVICE_ID_STMICRO_SPI_HS)},
+	{PCI_VDEVICE(STMICRO, PCI_DEVICE_ID_STMICRO_SDIO_EMMC)},
+	{PCI_VDEVICE(STMICRO, PCI_DEVICE_ID_STMICRO_SDIO)},
+	{PCI_VDEVICE(STMICRO, PCI_DEVICE_ID_STMICRO_AUDIO_ROUTER_DMA)},
+	{PCI_VDEVICE(STMICRO, PCI_DEVICE_ID_STMICRO_AUDIO_ROUTER_MSPS)},
+	{0,}
+};
+
+static struct pci_driver pci_amba_driver = {
+	.name		= "pci-amba",
+	.id_table	= pci_amba_table,
+	.probe		= pci_amba_probe,
+	.remove		= __devexit_p(pci_amba_remove),
+};
+
+static int __init pci_amba_init(void)
+{
+	return pci_register_driver(&pci_amba_driver);
+}
+
+static void __exit pci_amba_exit(void)
+{
+	pci_unregister_driver(&pci_amba_driver);
+}
+
+module_init(pci_amba_init);
+module_exit(pci_amba_exit);
+
+MODULE_LICENSE("GPL");
-- 
1.7.7.2

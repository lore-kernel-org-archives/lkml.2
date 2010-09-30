Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab0I3Uzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 16:55:46 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:10853 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756500Ab0I3Uzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:55:45 -0400
From: Daniel Drake <dsd@laptop.org>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Cc: laforge@gnumonks.org
Subject: [PATCH 2/3] Add VIA VX855 multi-function device support
Message-Id: <20100930205541.4ABE49D401C@zog.reactivated.net>
Date: Thu, 30 Sep 2010 21:55:41 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=3ENABmdyEd/Fm7fR7+mZIuMDn6+IErAeEhlfWBImZFk= c=1 sm=0 a=tQHkkPIY0HgA:10 a=Op-mwl0xAAAA:8 a=OA8392kgAAAA:8 a=YiP-QRcuIlXnpoY0ZL4A:9 a=A8jQw4nmz3lcgRKkWO8A:7 a=vPYGQqLaTBr9DG695DrqnQUBby0A:4 a=d4CUUju0HPYA:10 a=GTw93z-ti4wA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This device has GPIO, SPI and I2C capabilities.

The hardware can be found in the OLPC XO-1.5 laptop.

Based on earlier work by Harald Welte.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/mfd/Kconfig  |    9 +++
 drivers/mfd/Makefile |    1 +
 drivers/mfd/vx855.c  |  147 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 157 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/vx855.c

Switched to the mfd cells design to allow the individual functions to be
registered as platform devices.

I've dropped the SPI driver from the submission.
It presented a headache with the resource system, the commit message in
the original version suggests that it might not be complete, and I have
no way of testing it. It could be cleanly added later if someone needs it
and can finish the work.

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 256fabd..9735f58 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -576,6 +576,15 @@ config MFD_TPS6586X
 	  This driver can also be built as a module.  If so, the module
 	  will be called tps6586x.
 
+config MFD_VX855
+	tristate "Support for VIA VX855/VX875 integrated south bridge"
+	depends on PCI
+	select MFD_CORE
+	help
+	  Say yes here to enable support for various functions of the
+	  VIA VX855/VX875 south bridge. You will need to enable the vx855_spi
+	  and/or vx855_gpio drivers for this to do anything useful.
+
 endif # MFD_SUPPORT
 
 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index d5968cd..d18a6ab 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -78,3 +78,4 @@ obj-$(CONFIG_MFD_RDC321X)	+= rdc321x-southbridge.o
 obj-$(CONFIG_MFD_JANZ_CMODIO)	+= janz-cmodio.o
 obj-$(CONFIG_MFD_JZ4740_ADC)	+= jz4740-adc.o
 obj-$(CONFIG_MFD_TPS6586X)	+= tps6586x.o
+obj-$(CONFIG_MFD_VX855)		+= vx855.o
diff --git a/drivers/mfd/vx855.c b/drivers/mfd/vx855.c
new file mode 100644
index 0000000..ebb0597
--- /dev/null
+++ b/drivers/mfd/vx855.c
@@ -0,0 +1,147 @@
+/*
+ * Linux multi-function-device driver (MFD) for the integrated peripherals
+ * of the VIA VX855 chipset
+ *
+ * Copyright (C) 2009 VIA Technologies, Inc.
+ * Copyright (C) 2010 One Laptop per Child
+ * Author: Harald Welte <HaraldWelte@viatech.com>
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/pci.h>
+#include <linux/mfd/core.h>
+
+/* offset into pci config space indicating the 16bit register containing
+ * the power management IO space base */
+#define VX855_CFG_PMIO_OFFSET	0x88
+
+/* ACPI I/O Space registers */
+#define VX855_PMIO_ACPI		0x00
+#define VX855_PMIO_ACPI_LEN	0x0b
+
+/* Processor Power Management */
+#define VX855_PMIO_PPM		0x10
+#define VX855_PMIO_PPM_LEN	0x08
+
+/* General Purpose Power Management */
+#define VX855_PMIO_GPPM		0x20
+#define VX855_PMIO_R_GPI	0x48
+#define VX855_PMIO_R_GPO	0x4c
+#define VX855_PMIO_GPPM_LEN	0x33
+
+#define VSPIC_MMIO_SIZE	0x1000
+
+static struct resource vx855_gpio_resources[] = {
+	{
+		.flags = IORESOURCE_IO,
+	},
+	{
+		.flags = IORESOURCE_IO,
+	},
+};
+
+static struct mfd_cell vx855_cells[] = {
+	{
+		.name = "vx855_gpio",
+		.num_resources = ARRAY_SIZE(vx855_gpio_resources),
+		.resources = vx855_gpio_resources,
+
+		/* we must ignore resource conflicts, for reasons outlined in
+		 * the vx855_gpio driver */
+		.ignore_resource_conflicts = true,
+	},
+};
+
+static __devinit int vx855_probe(struct pci_dev *pdev,
+				 const struct pci_device_id *id)
+{
+	int ret;
+	u16 gpio_io_offset;
+
+	ret = pci_enable_device(pdev);
+	if (ret)
+		return -ENODEV;
+
+	pci_read_config_word(pdev, VX855_CFG_PMIO_OFFSET, &gpio_io_offset);
+	if (!gpio_io_offset) {
+		dev_warn(&pdev->dev,
+			"BIOS did not assign PMIO base offset?!?\n");
+		ret = -ENODEV;
+		goto out;
+	}
+
+	/* mask out the lowest seven bits, as they are always zero, but
+	 * hardware returns them as 0x01 */
+	gpio_io_offset &= 0xff80;
+
+	/* As the region identified here includes many non-GPIO things, we
+	 * only work with the specific registers that concern us. */
+	vx855_gpio_resources[0].start = gpio_io_offset + VX855_PMIO_R_GPI;
+	vx855_gpio_resources[0].end = vx855_gpio_resources[0].start + 3;
+	vx855_gpio_resources[1].start = gpio_io_offset + VX855_PMIO_R_GPO;
+	vx855_gpio_resources[1].end = vx855_gpio_resources[1].start + 3;
+
+	ret = mfd_add_devices(&pdev->dev, -1, vx855_cells, ARRAY_SIZE(vx855_cells),
+			NULL, 0);
+
+	/* we always return -ENODEV here in order to enable other
+	 * drivers like old, not-yet-platform_device ported i2c-viapro */
+	return -ENODEV;
+out:
+	pci_disable_device(pdev);
+	return ret;
+}
+
+static void vx855_remove(struct pci_dev *pdev)
+{
+	mfd_remove_devices(&pdev->dev);
+	pci_disable_device(pdev);
+}
+
+static struct pci_device_id vx855_pci_tbl[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VX855) },
+	{ 0, }
+};
+
+static struct pci_driver vx855_pci_driver = {
+	.name		= "vx855",
+	.id_table	= vx855_pci_tbl,
+	.probe		= vx855_probe,
+	.remove		= __devexit_p(vx855_remove),
+};
+
+static int vx855_init(void)
+{
+	return pci_register_driver(&vx855_pci_driver);
+}
+module_init(vx855_init);
+
+static void vx855_exit(void)
+{
+	pci_unregister_driver(&vx855_pci_driver);
+}
+module_exit(vx855_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Harald Welte <HaraldWelte@viatech.com>");
+MODULE_DESCRIPTION("Driver for the VIA VX855 chipset");
-- 
1.7.2.3


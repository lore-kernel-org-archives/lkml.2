Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab0JJJkj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 05:40:39 -0400
Received: from mtain06-winn.ispmail.ntl.com ([81.103.221.46]:40576 "EHLO
	mtain06-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754304Ab0JJJkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 05:40:37 -0400
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de
To: mingo@redhat.com
To: hpa@zytor.com
To: x86@kernel.org
Cc: dilinger@queued.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] OLPC: Add XO-1 poweroff support
Message-Id: <20101010094032.9AE669D401B@zog.reactivated.net>
Date: Sun, 10 Oct 2010 10:40:32 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=8Hp5I+AtFClKBjQt1Gfw2Dt1oiMhBuoDKuCBs6XzLoA= c=1 sm=0 a=g40CLz2o24UA:10 a=Op-mwl0xAAAA:8 a=bWWulpxaf0b5AOj7xfIA:9 a=zyI_IiCYRGCKcj0jfaoA:7 a=Caj6kGmmsQrZE1-dF9t6N6HhDtMA:4 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a pm_power_off handler for the OLPC XO-1 laptop.

The driver can be built modular and follows the behaviour of the
APM driver, setting pm_power_off to NULL on unload. However, the
ability to unload the module will probably be removed (with a simple
__module_get(THIS_MODULE)) if/when XO-1 suspend/resume support is
added to this file at a later date.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 arch/x86/Kconfig           |    6 ++
 arch/x86/kernel/Makefile   |    1 +
 arch/x86/kernel/olpc-xo1.c |  140 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 147 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/olpc-xo1.c

v2: can now be built modular, which will be more appropriate for distros

The plan is for arch/x86/kernel/olpc.c to register the platform device
when XO-1 is detected. A patch to add such machinery (for rfkill) is
still pending review. I plan to add probing of this new platform device
once the xo1-rfkill review is complete.

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 065c188..08fa0d7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2017,6 +2017,12 @@ config OLPC
 	  Add support for detecting the unique features of the OLPC
 	  XO hardware.
 
+config OLPC_XO1
+	tristate "OLPC XO-1 support"
+	depends on OLPC
+	---help---
+	  Add support for non-essential features of the OLPC XO-1 laptop.
+
 config OLPC_OPENFIRMWARE
 	bool "Support for OLPC's Open Firmware"
 	depends on !X86_64 && !X86_PAE
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index c0cc701..4983b61 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -106,6 +106,7 @@ obj-$(CONFIG_SCx200)		+= scx200.o
 scx200-y			+= scx200_32.o
 
 obj-$(CONFIG_OLPC)		+= olpc.o
+obj-$(CONFIG_OLPC_XO1)		+= olpc-xo1.o
 obj-$(CONFIG_OLPC_OPENFIRMWARE)	+= olpc_ofw.o
 obj-$(CONFIG_X86_MRST)		+= mrst.o
 
diff --git a/arch/x86/kernel/olpc-xo1.c b/arch/x86/kernel/olpc-xo1.c
new file mode 100644
index 0000000..f5442c0
--- /dev/null
+++ b/arch/x86/kernel/olpc-xo1.c
@@ -0,0 +1,140 @@
+/*
+ * Support for features of the OLPC XO-1 laptop
+ *
+ * Copyright (C) 2010 One Laptop per Child
+ * Copyright (C) 2006 Red Hat, Inc.
+ * Copyright (C) 2006 Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+#include <linux/platform_device.h>
+#include <linux/pm.h>
+
+#include <asm/io.h>
+#include <asm/olpc.h>
+
+#define DRV_NAME "olpc-xo1"
+
+#define PMS_BAR		4
+#define ACPI_BAR	5
+
+/* PMC registers (PMS block) */
+#define PM_SCLK		0x10
+#define PM_IN_SLPCTL	0x20
+#define PM_WKXD		0x34
+#define PM_WKD		0x30
+#define PM_SSC		0x54
+
+/* PM registers (ACPI block) */
+#define PM1_CNT		0x08
+#define PM_GPE0_STS	0x18
+
+static unsigned long acpi_base;
+static unsigned long pms_base;
+
+static void xo1_power_off(void)
+{
+	printk(KERN_INFO "OLPC XO-1 power off sequence...\n");
+
+	/* Enable all of these controls with 0 delay */
+	outl(0x40000000, pms_base + PM_SCLK);
+	outl(0x40000000, pms_base + PM_IN_SLPCTL);
+	outl(0x40000000, pms_base + PM_WKXD);
+	outl(0x40000000, pms_base + PM_WKD);
+
+	/* Clear status bits (possibly unnecessary) */
+	outl(0x0002ffff, pms_base  + PM_SSC);
+	outl(0xffffffff, acpi_base + PM_GPE0_STS);
+
+	/* Write SLP_EN bit to start the machinery */
+	outl(0x00002000, acpi_base + PM1_CNT);
+}
+
+/* Read the base addresses from the PCI BAR info */
+static int __devinit setup_bases(struct pci_dev *pdev)
+{
+	int r;
+
+	r = pci_enable_device_io(pdev);
+	if (r) {
+		dev_err(&pdev->dev, "can't enable device IO\n");
+		return r;
+	}
+
+	r = pci_request_region(pdev, ACPI_BAR, DRV_NAME);
+	if (r) {
+		dev_err(&pdev->dev, "can't alloc PCI BAR #%d\n", ACPI_BAR);
+		return r;
+	}
+
+	r = pci_request_region(pdev, PMS_BAR, DRV_NAME);
+	if (r) {
+		dev_err(&pdev->dev, "can't alloc PCI BAR #%d\n", PMS_BAR);
+		pci_release_region(pdev, ACPI_BAR);
+		return r;
+	}
+
+	acpi_base = pci_resource_start(pdev, ACPI_BAR);
+	pms_base = pci_resource_start(pdev, PMS_BAR);
+
+	return 0;
+}
+
+static int __devinit olpc_xo1_probe(struct platform_device *pdev)
+{
+	struct pci_dev *pcidev;
+	int r;
+
+	pcidev = pci_get_device(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA,
+				NULL);
+	if (!pdev)
+		return -ENODEV;
+
+	r = setup_bases(pcidev);
+	if (r)
+		return r;
+
+	pm_power_off = xo1_power_off;
+
+	printk(KERN_INFO "OLPC XO-1 support registered\n");
+	return 0;
+}
+
+static int __devexit olpc_xo1_remove(struct platform_device *pdev)
+{
+	pm_power_off = NULL;
+	return 0;
+}
+
+static struct platform_driver olpc_xo1_driver = {
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+	},
+	.probe = olpc_xo1_probe,
+	.remove = __devexit_p(olpc_xo1_remove),
+};
+
+static int __init olpc_xo1_init(void)
+{
+	return platform_driver_register(&olpc_xo1_driver);
+}
+
+static void __exit olpc_xo1_exit(void)
+{
+	platform_driver_unregister(&olpc_xo1_driver);
+}
+
+MODULE_AUTHOR("Daniel Drake <dsd@laptop.org>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:olpc-xo1");
+
+module_init(olpc_xo1_init);
+module_exit(olpc_xo1_exit);
-- 
1.7.2.3


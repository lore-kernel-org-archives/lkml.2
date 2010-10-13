Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab0JMBig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 21:38:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:37004 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab0JMBif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 21:38:35 -0400
Date: Wed, 13 Oct 2010 01:38:15 GMT
From: tip-bot for Daniel Drake <dsd@laptop.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dsd@laptop.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dsd@laptop.org, tglx@linutronix.de
In-Reply-To: <20101010094032.9AE669D401B@zog.reactivated.net>
References: <20101010094032.9AE669D401B@zog.reactivated.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/olpc] x86, olpc: Add XO-1 poweroff support
Message-ID: <tip-bf1ebf007911d70a89de9a4a1b36d403e8eb064b@git.kernel.org>
Git-Commit-ID: bf1ebf007911d70a89de9a4a1b36d403e8eb064b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Oct 2010 01:38:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf1ebf007911d70a89de9a4a1b36d403e8eb064b
Gitweb:     http://git.kernel.org/tip/bf1ebf007911d70a89de9a4a1b36d403e8eb064b
Author:     Daniel Drake <dsd@laptop.org>
AuthorDate: Sun, 10 Oct 2010 10:40:32 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 12 Oct 2010 17:31:15 -0700

x86, olpc: Add XO-1 poweroff support

Add a pm_power_off handler for the OLPC XO-1 laptop.

The driver can be built modular and follows the behaviour of the
APM driver, setting pm_power_off to NULL on unload. However, the
ability to unload the module will probably be removed (with a simple
__module_get(THIS_MODULE)) if/when XO-1 suspend/resume support is
added to this file at a later date.

Signed-off-by: Daniel Drake <dsd@laptop.org>
LKML-Reference: <20101010094032.9AE669D401B@zog.reactivated.net>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/Kconfig           |    6 ++
 arch/x86/kernel/Makefile   |    1 +
 arch/x86/kernel/olpc-xo1.c |  140 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 147 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c255255..0bcb876 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2066,6 +2066,12 @@ config OLPC
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
index 0925676..e977779 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -104,6 +104,7 @@ obj-$(CONFIG_SCx200)		+= scx200.o
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

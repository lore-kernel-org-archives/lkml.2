Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab0JGTAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 15:00:04 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:51128 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752893Ab0JGTAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 15:00:01 -0400
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de
To: mingo@redhat.com
To: hpa@zytor.com
To: x86@kernel.org
Cc: dilinger@queued.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] OLPC: Add XO-1 poweroff support
Message-Id: <20101007185952.A36859D401B@zog.reactivated.net>
Date: Thu,  7 Oct 2010 19:59:52 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=DhNl2YeytwJssBBGe49HJX82LNDFEEVkpVB34RXKaPo= c=1 sm=0 a=AvS0RrwksfwA:10 a=Op-mwl0xAAAA:8 a=DxYcp4CUANubbBQo6-UA:9 a=RttQKB1h_DY9XDJk-_0A:7 a=5WY7vSb3EMVE5fRsxjAtkm_bTUsA:4 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a pm_power_off handler for the OLPC XO-1 laptop.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 arch/x86/Kconfig           |    6 ++
 arch/x86/kernel/Makefile   |    1 +
 arch/x86/kernel/olpc-xo1.c |  112 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 119 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/olpc-xo1.c

The new olpc-xo1.c file will also be used for further functionality
(suspend/resume, lid switch device, etc); patches to be submitted shortly
after the review/merge of this one.

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cea0cd9..19e6439 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2065,6 +2065,12 @@ config OLPC
 	  Add support for detecting the unique features of the OLPC
 	  XO hardware.
 
+config OLPC_XO1
+	bool "OLPC XO-1 support"
+	depends on OLPC
+	---help---
+	  Add support for non-essential features of the OLPC XO-1 laptop.
+
 config OLPC_OPENFIRMWARE
 	bool "Support for OLPC's Open Firmware"
 	depends on !X86_64 && !X86_PAE
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index fedf32a..247588f 100644
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
index 0000000..ee840de
--- /dev/null
+++ b/arch/x86/kernel/olpc-xo1.c
@@ -0,0 +1,112 @@
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
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
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
+static int __init setup_bases(struct pci_dev *pdev)
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
+static int __init olpc_xo1_init(void)
+{
+	struct pci_dev *pdev;
+	int r;
+
+	if (olpc_board_at_least(olpc_board_pre(0xd0))) /* XO-1 only */
+		return 0;
+
+	pdev = pci_get_device(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA,
+			      NULL);
+	if (!pdev)
+		return -ENODEV;
+
+	r = setup_bases(pdev);
+	if (r)
+		return r;
+
+	pm_power_off = xo1_power_off;
+
+	printk(KERN_INFO "OLPC XO-1 support registered\n");
+	return 0;
+}
+device_initcall(olpc_xo1_init);
+
-- 
1.7.2.3


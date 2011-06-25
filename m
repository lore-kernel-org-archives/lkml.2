Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab1FYQwB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 12:52:01 -0400
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:32939 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751412Ab1FYQvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 12:51:37 -0400
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dilinger@queued.net, bigeasy@linutronix.de,
        Daniel Drake <dsd@laptop.org>
Subject: [PATCH v3 05/11] x86, olpc: Add XO-1 SCI driver and power button control
Date: Sat, 25 Jun 2011 17:34:12 +0100
Message-Id: <1309019658-1712-6-git-send-email-dsd@laptop.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309019658-1712-1-git-send-email-dsd@laptop.org>
References: <1309019658-1712-1-git-send-email-dsd@laptop.org>
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=DQVW9fZHeyQA:10 a=vJ1w_8FsMGIA:10 a=Op-mwl0xAAAA:8 a=In_Hgl4hAAAA:8 a=Fsvmf774rkHnr_f-GgQA:9 a=74Koy83CalRfvzNy5V0A:7 a=d4CUUju0HPYA:10 a=ro211Ng2IWAA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The System Control Interrupt is used in the OLPC XO-1 to control various
features of the laptop. Add the driver base and the power button
functionality.

This driver can't be built as a module, because functionality added in
future patches means that some drivers need to know at boot-time whether
SCI-based functionality is available.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/Kconfig                      |    9 ++
 arch/x86/platform/olpc/Makefile       |    1 +
 arch/x86/platform/olpc/olpc-xo1-sci.c |  191 +++++++++++++++++++++++++++++++++
 include/linux/cs5535.h                |    8 ++
 4 files changed, 209 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/platform/olpc/olpc-xo1-sci.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a9953bf..b2fb1e4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2082,6 +2082,15 @@ config OLPC_XO1_PM
 	---help---
 	  Add support for poweroff and suspend of the OLPC XO-1 laptop.
 
+config OLPC_XO1_SCI
+	bool "OLPC XO-1 SCI extras"
+	depends on OLPC && OLPC_XO1_PM
+	select GPIO_CS5535
+	select MFD_CORE
+	---help---
+	  Add support for SCI-based features of the OLPC XO-1 laptop:
+	   - Power button
+
 endif # X86_32
 
 config AMD_NB
diff --git a/arch/x86/platform/olpc/Makefile b/arch/x86/platform/olpc/Makefile
index 1ae7bed..1ec5ade 100644
--- a/arch/x86/platform/olpc/Makefile
+++ b/arch/x86/platform/olpc/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_OLPC)		+= olpc.o olpc_ofw.o olpc_dt.o
 obj-$(CONFIG_OLPC_XO1_PM)		+= olpc-xo1-pm.o xo1-wakeup.o
+obj-$(CONFIG_OLPC_XO1_SCI)	+= olpc-xo1-sci.o
diff --git a/arch/x86/platform/olpc/olpc-xo1-sci.c b/arch/x86/platform/olpc/olpc-xo1-sci.c
new file mode 100644
index 0000000..8fbf961
--- /dev/null
+++ b/arch/x86/platform/olpc/olpc-xo1-sci.c
@@ -0,0 +1,191 @@
+/*
+ * Support for OLPC XO-1 System Control Interrupts (SCI)
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
+#include <linux/cs5535.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/pm.h>
+#include <linux/mfd/core.h>
+#include <linux/suspend.h>
+
+#include <asm/io.h>
+#include <asm/msr.h>
+#include <asm/olpc.h>
+
+#define DRV_NAME	"olpc-xo1-sci"
+#define PFX		DRV_NAME ": "
+
+static unsigned long acpi_base;
+static struct input_dev *power_button_idev;
+static int sci_irq;
+
+static irqreturn_t xo1_sci_intr(int irq, void *dev_id)
+{
+	struct platform_device *pdev = dev_id;
+	u32 sts;
+	u32 gpe;
+
+	sts = inl(acpi_base + CS5536_PM1_STS);
+	outl(sts | 0xffff, acpi_base + CS5536_PM1_STS);
+
+	gpe = inl(acpi_base + CS5536_PM_GPE0_STS);
+	outl(0xffffffff, acpi_base + CS5536_PM_GPE0_STS);
+
+	dev_dbg(&pdev->dev, "sts %x gpe %x\n", sts, gpe);
+
+	if (sts & CS5536_PWRBTN_FLAG && !(sts & CS5536_WAK_FLAG)) {
+		input_report_key(power_button_idev, KEY_POWER, 1);
+		input_sync(power_button_idev);
+		input_report_key(power_button_idev, KEY_POWER, 0);
+		input_sync(power_button_idev);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int xo1_sci_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	if (device_may_wakeup(&power_button_idev->dev))
+		olpc_xo1_pm_wakeup_set(CS5536_PM_PWRBTN);
+	else
+		olpc_xo1_pm_wakeup_clear(CS5536_PM_PWRBTN);
+	return 0;
+}
+
+static int __devinit setup_sci_interrupt(struct platform_device *pdev)
+{
+	u32 lo, hi;
+	u32 sts;
+	int r;
+
+	rdmsr(0x51400020, lo, hi);
+	sci_irq = (lo >> 20) & 15;
+
+	if (sci_irq) {
+		dev_info(&pdev->dev, "SCI is mapped to IRQ %d\n", sci_irq);
+	} else {
+		/* Zero means masked */
+		dev_info(&pdev->dev, "SCI unmapped. Mapping to IRQ 3\n");
+		sci_irq = 3;
+		lo |= 0x00300000;
+		wrmsrl(0x51400020, lo);
+	}
+
+	/* Select level triggered in PIC */
+	if (sci_irq < 8) {
+		lo = inb(CS5536_PIC_INT_SEL1);
+		lo |= 1 << sci_irq;
+		outb(lo, CS5536_PIC_INT_SEL1);
+	} else {
+		lo = inb(CS5536_PIC_INT_SEL2);
+		lo |= 1 << (sci_irq - 8);
+		outb(lo, CS5536_PIC_INT_SEL2);
+	}
+
+	/* Enable SCI from power button, and clear pending interrupts */
+	sts = inl(acpi_base + CS5536_PM1_STS);
+	outl((CS5536_PM_PWRBTN << 16) | 0xffff, acpi_base + CS5536_PM1_STS);
+
+	r = request_irq(sci_irq, xo1_sci_intr, 0, DRV_NAME, pdev);
+	if (r)
+		dev_err(&pdev->dev, "can't request interrupt\n");
+
+	return r;
+}
+
+static int __devinit setup_power_button(struct platform_device *pdev)
+{
+	int r;
+
+	power_button_idev = input_allocate_device();
+	if (!power_button_idev)
+		return -ENOMEM;
+
+	power_button_idev->name = "Power Button";
+	power_button_idev->phys = DRV_NAME "/input0";
+	set_bit(EV_KEY, power_button_idev->evbit);
+	set_bit(KEY_POWER, power_button_idev->keybit);
+
+	power_button_idev->dev.parent = &pdev->dev;
+	device_init_wakeup(&power_button_idev->dev, 1);
+
+	r = input_register_device(power_button_idev);
+	if (r) {
+		dev_err(&pdev->dev, "failed to register power button: %d\n", r);
+		input_free_device(power_button_idev);
+	}
+
+	return r;
+}
+
+static void free_power_button(void)
+{
+	input_unregister_device(power_button_idev);
+	input_free_device(power_button_idev);
+}
+
+static int __devinit xo1_sci_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	int r;
+
+	/* don't run on non-XOs */
+	if (!machine_is_olpc())
+		return -ENODEV;
+
+	r = mfd_cell_enable(pdev);
+	if (r)
+		return r;
+
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "can't fetch device resource info\n");
+		return -EIO;
+	}
+	acpi_base = res->start;
+
+	r = setup_power_button(pdev);
+	if (r)
+		return r;
+
+	r = setup_sci_interrupt(pdev);
+	if (r)
+		free_power_button();
+
+	return r;
+}
+
+static int __devexit xo1_sci_remove(struct platform_device *pdev)
+{
+	mfd_cell_disable(pdev);
+	free_irq(sci_irq, pdev);
+	free_power_button();
+	acpi_base = 0;
+	return 0;
+}
+
+static struct platform_driver xo1_sci_driver = {
+	.driver = {
+		.name = "olpc-xo1-sci-acpi",
+	},
+	.probe = xo1_sci_probe,
+	.remove = __devexit_p(xo1_sci_remove),
+	.suspend = xo1_sci_suspend,
+};
+
+static int __init xo1_sci_init(void)
+{
+	return platform_driver_register(&xo1_sci_driver);
+}
+arch_initcall(xo1_sci_init);
diff --git a/include/linux/cs5535.h b/include/linux/cs5535.h
index 2facf16..6f78235 100644
--- a/include/linux/cs5535.h
+++ b/include/linux/cs5535.h
@@ -43,6 +43,10 @@
 #define MSR_GX_GLD_MSR_CONFIG	0xC0002001
 #define MSR_GX_MSR_PADSEL	0xC0002011
 
+/* PIC registers */
+#define CS5536_PIC_INT_SEL1	0x4d0
+#define CS5536_PIC_INT_SEL2	0x4d1
+
 /* resource sizes */
 #define LBAR_GPIO_SIZE		0xFF
 #define LBAR_MFGPT_SIZE		0x40
@@ -70,6 +74,10 @@
 #define CS5536_PM1_CNT		0x08
 #define CS5536_PM_GPE0_STS	0x18
 
+/* CS5536_PM1_STS bits */
+#define CS5536_WAK_FLAG		(1 << 15)
+#define CS5536_PWRBTN_FLAG	(1 << 8)
+
 /* CS5536_PM1_EN bits */
 #define CS5536_PM_PWRBTN	(1 << 8)
 
-- 
1.7.5.4


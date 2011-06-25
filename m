Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab1FYRnZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 13:43:25 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:61867 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752050Ab1FYRm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 13:42:59 -0400
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dilinger@queued.net, bigeasy@linutronix.de,
        Daniel Drake <dsd@laptop.org>
Subject: [PATCH v3 11/11] x86, olpc: Add XO-1.5 SCI driver
Date: Sat, 25 Jun 2011 17:34:18 +0100
Message-Id: <1309019658-1712-12-git-send-email-dsd@laptop.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309019658-1712-1-git-send-email-dsd@laptop.org>
References: <1309019658-1712-1-git-send-email-dsd@laptop.org>
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=i5bpajMd5FwA:10 a=vJ1w_8FsMGIA:10 a=Op-mwl0xAAAA:8 a=In_Hgl4hAAAA:8 a=YmEKrBQnXbTnUyvlkEEA:9 a=V3UE25fxpKVRchcYZzsA:7 a=d4CUUju0HPYA:10 a=ro211Ng2IWAA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver for the ACPI-based EC event interface found on the
OLPC XO-1.5 laptop. This enables notification of battery/AC power events,
and enables various devices to be used as wakeup sources through regular
ACPI mechanisms.

This driver can't be built as a module, because some drivers need to know
at boot-time if SCI-based functionality is available via
olpc_ec_wakeup_available().

Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/Kconfig                       |    9 ++
 arch/x86/platform/olpc/Makefile        |    1 +
 arch/x86/platform/olpc/olpc-xo15-sci.c |  168 ++++++++++++++++++++++++++++++++
 arch/x86/platform/olpc/olpc.c          |    9 ++
 4 files changed, 187 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/platform/olpc/olpc-xo15-sci.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index de81496..1ed7d32 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2103,6 +2103,15 @@ config OLPC_XO1_SCI
 	   - AC adapter status updates
 	   - Battery status updates
 
+config OLPC_XO15_SCI
+	bool "OLPC XO-1.5 SCI extras"
+	depends on OLPC && ACPI && POWER_SUPPLY
+	---help---
+	  Add support for SCI-based features of the OLPC XO-1.5 laptop:
+	   - EC-driven system wakeups
+	   - AC adapter status updates
+	   - Battery status updates
+
 endif # X86_32
 
 config AMD_NB
diff --git a/arch/x86/platform/olpc/Makefile b/arch/x86/platform/olpc/Makefile
index 8922b9b..fd332c5 100644
--- a/arch/x86/platform/olpc/Makefile
+++ b/arch/x86/platform/olpc/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_OLPC)		+= olpc.o olpc_ofw.o olpc_dt.o
 obj-$(CONFIG_OLPC_XO1_PM)		+= olpc-xo1-pm.o xo1-wakeup.o
 obj-$(CONFIG_OLPC_XO1_RTC)	+= olpc-xo1-rtc.o
 obj-$(CONFIG_OLPC_XO1_SCI)	+= olpc-xo1-sci.o
+obj-$(CONFIG_OLPC_XO15_SCI)	+= olpc-xo15-sci.o
diff --git a/arch/x86/platform/olpc/olpc-xo15-sci.c b/arch/x86/platform/olpc/olpc-xo15-sci.c
new file mode 100644
index 0000000..a5990eb
--- /dev/null
+++ b/arch/x86/platform/olpc/olpc-xo15-sci.c
@@ -0,0 +1,168 @@
+/*
+ * Support for OLPC XO-1.5 System Control Interrupts (SCI)
+ *
+ * Copyright (C) 2009-2010 One Laptop per Child
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+#include <linux/power_supply.h>
+
+#include <acpi/acpi_bus.h>
+#include <acpi/acpi_drivers.h>
+#include <asm/olpc.h>
+
+#define DRV_NAME			"olpc-xo15-sci"
+#define PFX				DRV_NAME ": "
+#define XO15_SCI_CLASS			DRV_NAME
+#define XO15_SCI_DEVICE_NAME		"OLPC XO-1.5 SCI"
+
+static unsigned long xo15_sci_gpe;
+
+static void battery_status_changed(void)
+{
+	struct power_supply *psy = power_supply_get_by_name("olpc-battery");
+
+	if (psy) {
+		power_supply_changed(psy);
+		put_device(psy->dev);
+	}
+}
+
+static void ac_status_changed(void)
+{
+	struct power_supply *psy = power_supply_get_by_name("olpc-ac");
+
+	if (psy) {
+		power_supply_changed(psy);
+		put_device(psy->dev);
+	}
+}
+
+static void process_sci_queue(void)
+{
+	u16 data;
+	int r;
+
+	do {
+		r = olpc_ec_sci_query(&data);
+		if (r || !data)
+			break;
+
+		pr_debug(PFX "SCI 0x%x received\n", data);
+
+		switch (data) {
+		case EC_SCI_SRC_BATERR:
+		case EC_SCI_SRC_BATSOC:
+		case EC_SCI_SRC_BATTERY:
+		case EC_SCI_SRC_BATCRIT:
+			battery_status_changed();
+			break;
+		case EC_SCI_SRC_ACPWR:
+			ac_status_changed();
+			break;
+		}
+	} while (data);
+
+	if (r)
+		pr_err(PFX "Failed to clear SCI queue");
+}
+
+static void process_sci_queue_work(struct work_struct *work)
+{
+	process_sci_queue();
+}
+
+static DECLARE_WORK(sci_work, process_sci_queue_work);
+
+static u32 xo15_sci_gpe_handler(acpi_handle gpe_device, u32 gpe, void *context)
+{
+	schedule_work(&sci_work);
+	return ACPI_INTERRUPT_HANDLED | ACPI_REENABLE_GPE;
+}
+
+static int xo15_sci_add(struct acpi_device *device)
+{
+	unsigned long long tmp;
+	acpi_status status;
+
+	if (!device)
+		return -EINVAL;
+
+	strcpy(acpi_device_name(device), XO15_SCI_DEVICE_NAME);
+	strcpy(acpi_device_class(device), XO15_SCI_CLASS);
+
+	/* Get GPE bit assignment (EC events). */
+	status = acpi_evaluate_integer(device->handle, "_GPE", NULL, &tmp);
+	if (ACPI_FAILURE(status))
+		return -EINVAL;
+
+	xo15_sci_gpe = tmp;
+	status = acpi_install_gpe_handler(NULL, xo15_sci_gpe,
+					  ACPI_GPE_EDGE_TRIGGERED,
+					  xo15_sci_gpe_handler, device);
+	if (ACPI_FAILURE(status))
+		return -ENODEV;
+
+	dev_info(&device->dev, "Initialized, GPE = 0x%lx\n", xo15_sci_gpe);
+
+	/* Flush queue, and enable all SCI events */
+	process_sci_queue();
+	olpc_ec_mask_write(EC_SCI_SRC_ALL);
+
+	acpi_enable_gpe(NULL, xo15_sci_gpe);
+
+	/* Enable wake-on-EC */
+	if (device->wakeup.flags.valid)
+		device_set_wakeup_enable(&device->dev, true);
+
+	return 0;
+}
+
+static int xo15_sci_remove(struct acpi_device *device, int type)
+{
+	acpi_disable_gpe(NULL, xo15_sci_gpe);
+	acpi_remove_gpe_handler(NULL, xo15_sci_gpe, xo15_sci_gpe_handler);
+	cancel_work_sync(&sci_work);
+	return 0;
+}
+
+static int xo15_sci_resume(struct acpi_device *device)
+{
+	/* Enable all EC events */
+	olpc_ec_mask_write(EC_SCI_SRC_ALL);
+
+	/* Power/battery status might have changed */
+	battery_status_changed();
+	ac_status_changed();
+
+	return 0;
+}
+
+static const struct acpi_device_id xo15_sci_device_ids[] = {
+	{"XO15EC", 0},
+	{"", 0},
+};
+
+static struct acpi_driver xo15_sci_drv = {
+	.name = DRV_NAME,
+	.class = XO15_SCI_CLASS,
+	.ids = xo15_sci_device_ids,
+	.ops = {
+		.add = xo15_sci_add,
+		.remove = xo15_sci_remove,
+		.resume = xo15_sci_resume,
+	},
+};
+
+static int __init xo15_sci_init(void)
+{
+	return acpi_bus_register_driver(&xo15_sci_drv);
+}
+device_initcall(xo15_sci_init);
diff --git a/arch/x86/platform/olpc/olpc.c b/arch/x86/platform/olpc/olpc.c
index 72fd041..8b9940e 100644
--- a/arch/x86/platform/olpc/olpc.c
+++ b/arch/x86/platform/olpc/olpc.c
@@ -222,6 +222,15 @@ bool olpc_ec_wakeup_available(void)
 		return true;
 #endif
 
+	/*
+	 * XO-1.5 EC wakeups are available when olpc-xo15-sci driver is
+	 * compiled in
+	 */
+#ifdef CONFIG_OLPC_XO15_SCI
+	if (olpc_platform_info.boardrev >= olpc_board_pre(0xd0)) /* XO-1.5 */
+		return true;
+#endif
+
 	return false;
 }
 EXPORT_SYMBOL_GPL(olpc_ec_wakeup_available);
-- 
1.7.5.4


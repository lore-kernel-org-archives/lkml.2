Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab2G1Lp0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 07:45:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38228 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab2G1LpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 07:45:23 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Len Brown <lenb@kernel.org>, Tony Luck <tony.luch@intel.com>,
        Bob Moore <robert.moore@intel.com>, Huang Ying <ying.huang@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Hanjun Guo <guohanjun@huawei.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        Gaohuai Han <hangaohuai@huawei.com>, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH 3/3] ACPIHP: detect ACPI hotplug slots by checking ACPI _EJ0 method
Date: Sat, 28 Jul 2012 19:42:52 +0800
Message-Id: <1343475772-21345-4-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343475772-21345-1-git-send-email-jiang.liu@huawei.com>
References: <1343475772-21345-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a default mechanism to detect and manage ACPI system
device hotplug slots based on standard ACPI interfaces.
1) Detech hotplug slot by checking existence of _EJ0 and _STA methods.
2) Power off a slot by excuting _EJ0 method.

It's the default hotplug slot enumerating mechanism, platform specifc drivers
may provide advanced implementation to override the default implementation.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Gaohuai Han <hangaohuai@huawei.com>
Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/acpi/Kconfig                 |   10 +++
 drivers/acpi/hotplug/Makefile        |    1 +
 drivers/acpi/hotplug/slot_enum.c     |    3 +
 drivers/acpi/hotplug/slot_enum_ej0.c |  113 ++++++++++++++++++++++++++++++++++
 4 files changed, 127 insertions(+)
 create mode 100644 drivers/acpi/hotplug/slot_enum_ej0.c

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 711e18e..c9f7918 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -344,6 +344,16 @@ config ACPI_HOTPLUG_ENUM
 	  To compile this driver as a module, choose M here:
 	  the module will be called acpihp_enum.
 
+config ACPI_HOTPLUG_ENUM_EJ0
+	bool "Detecting ACPI Hotplug Slot by Checking _EJ0 Method"
+	depends on ACPI_HOTPLUG_ENUM
+	default y
+	help
+	  Enable detecting ACPI hotplug slots by checking ACPI _EJ0 method
+	  under ACPI device objects.
+
+	  It's the default method to detect ACPI hotplug slots.
+
 config ACPI_CONTAINER
 	tristate "Container and Module Devices (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
diff --git a/drivers/acpi/hotplug/Makefile b/drivers/acpi/hotplug/Makefile
index 41c0da9..23dfa93 100644
--- a/drivers/acpi/hotplug/Makefile
+++ b/drivers/acpi/hotplug/Makefile
@@ -7,3 +7,4 @@ acpihp-y					= core.o
 
 obj-$(CONFIG_ACPI_HOTPLUG_ENUM)			+= acpihp_enum.o
 acpihp_enum-y					= slot_enum.o
+acpihp_enum-y					+= slot_enum_ej0.o
diff --git a/drivers/acpi/hotplug/slot_enum.c b/drivers/acpi/hotplug/slot_enum.c
index 80396a3..a251ecf 100644
--- a/drivers/acpi/hotplug/slot_enum.c
+++ b/drivers/acpi/hotplug/slot_enum.c
@@ -40,11 +40,14 @@ struct acpihp_slot_id {
 
 static struct acpihp_slot_ops *slot_ops_curr;
 
+extern struct acpihp_slot_ops acpihp_enum_ej0;
+
 /*
  * Array of platform specific enumeration methods.
  * Entries in the array should be sorted by descending priority order.
  */
 static struct acpihp_slot_ops *slot_ops_array[] = {
+	&acpihp_enum_ej0,
 	NULL
 };
 
diff --git a/drivers/acpi/hotplug/slot_enum_ej0.c b/drivers/acpi/hotplug/slot_enum_ej0.c
new file mode 100644
index 0000000..2788860
--- /dev/null
+++ b/drivers/acpi/hotplug/slot_enum_ej0.c
@@ -0,0 +1,113 @@
+/*
+ * Copyright (C) 2011 Huawei Tech. Co., Ltd.
+ * Copyright (C) 2011 Gaohuai Han <hangaohuai@huawei.com>
+ * Copyright (C) 2011 Jiang Liu <jiang.liu@huawei.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or (at
+ *  your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+#include <linux/acpi.h>
+#include <acpi/acpi.h>
+#include <acpi/acpi_hotplug.h>
+
+static acpi_status acpihp_enum_ej0_init(void)
+{
+	return AE_OK;
+}
+
+static void acpihp_enum_ej0_fini(void)
+{
+}
+
+static acpi_status acpihp_enum_ej0_check(acpi_handle handle)
+{
+	acpi_handle tmp;
+
+	/* Assume a device object with _EJ0 and _STA has a hotplug slot. */
+	if (ACPI_FAILURE(acpi_get_handle(handle, "_EJ0", &tmp)))
+		return AE_ERROR;
+	if (ACPI_FAILURE(acpi_get_handle(handle, METHOD_NAME__STA, &tmp)))
+		return AE_ERROR;
+
+	return AE_OK;
+}
+
+static acpi_status
+acpihp_enum_ej0_get_capabilities(acpi_handle handle, u32 *capability)
+{
+	/*
+	 * Assume device objects with _EJ0 are capable of:
+	 * ONLINE, OFFLINE, POWEROFF, HOTPLUG
+	 */
+	*capability = ACPIHP_SLOT_CAP_ONLINE | ACPIHP_SLOT_CAP_OFFLINE |
+		      ACPIHP_SLOT_CAP_POWEROFF | ACPIHP_SLOT_CAP_HOTPLUG;
+
+	return AE_OK;
+}
+
+static acpi_status acpihp_enum_ej0_poweron(acpi_handle handle)
+{
+	return AE_SUPPORT;
+}
+
+static acpi_status acpihp_enum_ej0_poweroff(acpi_handle handle)
+{
+	acpi_status status;
+	unsigned long long sta;
+	union acpi_object arg;
+	struct acpi_object_list arg_list;
+
+	if (!handle)
+		return AE_BAD_PARAMETER;
+
+	arg_list.count = 1;
+	arg_list.pointer = &arg;
+	arg.type = ACPI_TYPE_INTEGER;
+	arg.integer.value = 1;
+	status = acpi_evaluate_object(handle, "_EJ0", &arg_list, NULL);
+	if (ACPI_FAILURE(status)) {
+		ACPIHP_WARN("fails to power off object %p.\n", handle);
+		return status;
+	}
+
+	status = acpi_evaluate_integer(handle, METHOD_NAME__STA, NULL, &sta);
+	if (ACPI_FAILURE(status)) {
+		ACPIHP_WARN("fails to evaluate _STA method of object %p\n",
+			    handle);
+		return status;
+	}
+
+	if (sta & (ACPI_STA_DEVICE_FUNCTIONING | ACPI_STA_DEVICE_ENABLED)) {
+		ACPIHP_WARN("object %p is still active after executing _EJ0.\n",
+			    handle);
+		return AE_ERROR;
+	}
+
+	return AE_OK;
+}
+
+struct acpihp_slot_ops acpihp_enum_ej0 = {
+	.init = acpihp_enum_ej0_init,
+	.fini = acpihp_enum_ej0_fini,
+	.check = acpihp_enum_ej0_check,
+	.get_capabilities = acpihp_enum_ej0_get_capabilities,
+	.poweron = acpihp_enum_ej0_poweron,
+	.poweroff = acpihp_enum_ej0_poweroff,
+	.owner = THIS_MODULE,
+	.desc = "ACPI _EJ0 Based Hotplug Slot Enumerator"
+};
-- 
1.7.9.5


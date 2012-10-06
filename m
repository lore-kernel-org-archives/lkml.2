Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab2JFPaU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 11:30:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63060 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab2JFPaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 11:30:13 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Hanjun Guo <guohanjun@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        Gong Chen <gong.chen@linux.intel.com>,
        Jiang Liu <jiang.liu@huawei.com>, Tony Luck <tony.luck@intel.com>,
        Huang Ying <ying.huang@intel.com>, Bob Moore <robert.moore@intel.com>,
        Len Brown <lenb@kernel.org>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [RFC PATCH v3 04/28] ACPIHP: implement a fake ACPI system device hotplug slot enumerator
Date: Sat,  6 Oct 2012 23:27:12 +0800
Message-Id: <1349537256-21670-5-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
References: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a fake ACPI system device hotplug slot enumerator,
which could be used to test and verify hotplug logic on platforms with
hardware hotplug capabilities.

The fake slot enumerator will be enabled by passing module parameter
"fake_slot=value". The encoding of "value" is:
0x1: fake ACPI CONTAINER device as hotplug slot
0x2: fake ACPI memory device as hotplug slot
0x4: fake ACPI Processor object or Processor device as hotplug slot
0x8: fake ACPI PCI host bridge device as hotplug slot.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/acpi/Kconfig             |    9 ++
 drivers/acpi/hotplug/Makefile    |    1 +
 drivers/acpi/hotplug/acpihp.h    |    3 +
 drivers/acpi/hotplug/slot.c      |    3 +
 drivers/acpi/hotplug/slot_fake.c |  177 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 193 insertions(+)
 create mode 100644 drivers/acpi/hotplug/slot_fake.c

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 915a25e..5a5a3e5 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -348,6 +348,15 @@ config ACPI_HOTPLUG_SLOT
 	  To compile this driver as a module, choose M here:
 	  the module will be called acpihp_slot.
 
+config ACPI_HOTPLUG_SLOT_FAKE
+	bool "Fake Hotplug Slot Enumerator"
+	depends on ACPI_HOTPLUG_SLOT
+	default y
+	help
+	  Enable the fake ACPI system device hotplug slot enumerator, which
+	  could be used to test hotplug functionalities on hardware platforms
+	  with out system device hotplug capabilities.
+
 config ACPI_CONTAINER
 	tristate "Container and Module Devices (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
diff --git a/drivers/acpi/hotplug/Makefile b/drivers/acpi/hotplug/Makefile
index 5420ae7..c19b350 100644
--- a/drivers/acpi/hotplug/Makefile
+++ b/drivers/acpi/hotplug/Makefile
@@ -8,3 +8,4 @@ acpihp-y					= core.o
 obj-$(CONFIG_ACPI_HOTPLUG_SLOT)			+= acpihp_slot.o
 acpihp_slot-y					= slot.o
 acpihp_slot-y					+= slot_ej0.o
+acpihp_slot-$(CONFIG_ACPI_HOTPLUG_SLOT_FAKE)	+= slot_fake.o
diff --git a/drivers/acpi/hotplug/acpihp.h b/drivers/acpi/hotplug/acpihp.h
index 278c8c2..7c49eab 100644
--- a/drivers/acpi/hotplug/acpihp.h
+++ b/drivers/acpi/hotplug/acpihp.h
@@ -29,5 +29,8 @@
 
 extern struct acpi_device *acpi_root;
 extern struct acpihp_slot_ops acpihp_slot_ej0;
+#ifdef	CONFIG_ACPI_HOTPLUG_SLOT_FAKE
+extern struct acpihp_slot_ops acpihp_slot_fake;
+#endif
 
 #endif
diff --git a/drivers/acpi/hotplug/slot.c b/drivers/acpi/hotplug/slot.c
index 8fdae61..38f39dc 100644
--- a/drivers/acpi/hotplug/slot.c
+++ b/drivers/acpi/hotplug/slot.c
@@ -44,6 +44,9 @@ static struct acpihp_slot_ops *slot_ops_curr;
  */
 static struct acpihp_slot_ops *slot_ops_array[] = {
 	&acpihp_slot_ej0,
+#ifdef	CONFIG_ACPI_HOTPLUG_SLOT_FAKE
+	&acpihp_slot_fake,
+#endif
 	NULL
 };
 
diff --git a/drivers/acpi/hotplug/slot_fake.c b/drivers/acpi/hotplug/slot_fake.c
new file mode 100644
index 0000000..512e09b
--- /dev/null
+++ b/drivers/acpi/hotplug/slot_fake.c
@@ -0,0 +1,177 @@
+/*
+ * Copyright (C) 2012 Huawei Tech. Co., Ltd.
+ * Copyright (C) 2012 Jiang Liu <jiang.liu@huawei.com>
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
+#include "acpihp.h"
+
+struct acpihp_slot_fake_data {
+	bool enabled;
+};
+
+/*
+ * Encoding of the fake_slot parameter:
+ * 0x1: fake ACPI CONTAINER device as hotplug slot
+ * 0x2: fake ACPI memory device as hotplug slot
+ * 0x4: fake ACPI Processor object or Processor device as hotplug slot
+ * 0x8: fake ACPI PCI host bridge device as hotplug slot.
+ * The above encoding must be kept in consistence with definition of
+ * 'enum acpihp_dev_type'.
+ */
+int acpihp_fake_slot;
+module_param_named(fake_slot, acpihp_fake_slot, int, S_IRUGO);
+MODULE_PARM_DESC(fake_slot, "fake ACPI hotplug slots, 0x1 for CONTAINER, 0x2 for memory, 0x4 for CPU, 0x8 for PCI host bridge.");
+
+static acpi_status acpihp_slot_fake_init(void)
+{
+	return acpihp_fake_slot ? AE_OK : AE_ERROR;
+}
+
+static acpi_status
+acpihp_slot_fake_check(acpi_handle handle, u32 lvl, void *context, void **rv)
+{
+	int *valid = (int *)rv;
+	enum acpihp_dev_type type;
+
+	if (!acpihp_dev_get_type(handle, &type)) {
+		switch (type) {
+		case ACPIHP_DEV_TYPE_CPU:
+		case ACPIHP_DEV_TYPE_MEM:
+		case ACPIHP_DEV_TYPE_HOST_BRIDGE:
+			*valid = 1;
+			return AE_CTRL_TERMINATE;
+		default:
+			break;
+		}
+	}
+
+	return AE_OK;
+}
+
+static acpi_status acpihp_slot_fake_capable(acpi_handle handle)
+{
+	int valid = 0;
+	acpi_status rc;
+	unsigned long long sta;
+	enum acpihp_dev_type type;
+
+	/* Only care about CPU, memory, PCI host bridge and CONTAINER */
+	if (acpihp_dev_get_type(handle, &type))
+		return AE_ERROR;
+	if (type == ACPIHP_DEV_TYPE_CPU || type == ACPIHP_DEV_TYPE_MEM ||
+	    type == ACPIHP_DEV_TYPE_HOST_BRIDGE) {
+		if (acpihp_fake_slot & (1 << (type - 1)))
+			valid = 1;
+	} else if (type == ACPIHP_DEV_TYPE_CONTAINER &&
+		   acpihp_fake_slot & (1 << (type - 1))) {
+		acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
+				ACPI_UINT32_MAX, acpihp_slot_fake_check,
+				NULL, NULL, (void **)&valid);
+		acpi_walk_namespace(ACPI_TYPE_PROCESSOR, handle,
+				ACPI_UINT32_MAX, acpihp_slot_fake_check,
+				NULL, NULL, (void **)&valid);
+	}
+	if (valid == 0)
+		return AE_ERROR;
+
+	/* Check whether device is present and enabled. */
+	rc = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
+	if (rc == AE_NOT_FOUND)
+		sta = ACPI_STA_DEVICE_PRESENT | ACPI_STA_DEVICE_ENABLED;
+	else if (ACPI_FAILURE(rc))
+		sta = 0;
+	else if (sta & ACPI_STA_DEVICE_FUNCTIONING)
+		sta |= ACPI_STA_DEVICE_ENABLED;
+	if (!(sta & ACPI_STA_DEVICE_PRESENT) ||
+	    !(sta & ACPI_STA_DEVICE_ENABLED))
+		return AE_ERROR;
+
+	return AE_OK;
+}
+
+static acpi_status acpihp_slot_fake_create(struct acpihp_slot *slot)
+{
+	struct acpihp_slot_fake_data *data;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return AE_ERROR;
+
+	data->enabled = true;
+	slot->slot_data = data;
+	slot->capabilities = ACPIHP_SLOT_CAP_ONLINE | ACPIHP_SLOT_CAP_OFFLINE;
+
+	return AE_OK;
+}
+
+static void acpihp_slot_fake_destroy(struct acpihp_slot *slot)
+{
+	struct acpihp_slot_fake_data *data = slot->slot_data;
+
+	slot->slot_data = NULL;
+	kfree(data);
+}
+
+static acpi_status
+acpihp_slot_fake_get_status(struct acpihp_slot *slot, u64 *status)
+{
+	struct acpihp_slot_fake_data *data = slot->slot_data;
+
+	if (data->enabled)
+		*status = ACPI_STA_DEVICE_PRESENT | ACPI_STA_DEVICE_ENABLED |
+			  ACPI_STA_DEVICE_FUNCTIONING;
+	else
+		*status = ACPI_STA_DEVICE_PRESENT;
+
+	return AE_OK;
+}
+
+static acpi_status acpihp_slot_fake_poweron(struct acpihp_slot *slot)
+{
+	struct acpihp_slot_fake_data *data = slot->slot_data;
+
+	data->enabled = true;
+
+	return AE_OK;
+}
+
+static acpi_status acpihp_slot_fake_poweroff(struct acpihp_slot *slot)
+{
+	struct acpihp_slot_fake_data *data = slot->slot_data;
+
+	data->enabled = false;
+
+	return AE_OK;
+}
+
+struct acpihp_slot_ops acpihp_slot_fake = {
+	.owner = THIS_MODULE,
+	.desc = "Fake ACPI System Device Hotplug Slots for Testing",
+	.init = acpihp_slot_fake_init,
+	.check = acpihp_slot_fake_capable,
+	.create = acpihp_slot_fake_create,
+	.destroy = acpihp_slot_fake_destroy,
+	.poweron = acpihp_slot_fake_poweron,
+	.poweroff = acpihp_slot_fake_poweroff,
+	.get_status = acpihp_slot_fake_get_status,
+};
-- 
1.7.9.5


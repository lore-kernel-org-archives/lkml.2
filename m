Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab2JFP3e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 11:29:34 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60149 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab2JFP3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 11:29:30 -0400
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
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        Gaohuai Han <hangaohuai@huawei.com>
Subject: [RFC PATCH v3 01/28] ACPIHP: introduce a framework for ACPI based system device hotplug
Date: Sat,  6 Oct 2012 23:27:09 +0800
Message-Id: <1349537256-21670-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
References: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modern high-end server may support advanced hotplug features for system
devices, including physical processor, memory board, IO extension
board/box and/or computer node. The ACPI specifications have provided
standard interfaces between firmware and OS to support device hotplug
at runtime. This patch series provide an ACPI based hotplug framework
to support system device hotplug at runtime, which will replace current
existing ACPI device driver based CPU/memory/CONTAINER hotplug mechanism.

An ACPI hotplug slot is an abstraction of receptacles, where a group of
system devices could be connected to. The ACPI system device hotplug
framework includes two main components to manage hotplug slots:
1) A system device hotplug slot enumerator driver, which enumerates all
   hotplug slots in the system and provides platform specific methods
   to control those slots.
2) A system device hotplug driver, which is a platform independent
   driver to manage all hotplug slots created by the slot enumerator.
   The hotplug driver implements a state machine for hotplug slots and
   provides user interfaces to manage hotplug slots.

To get rid of dependengcy between enumerator and hotplug driver, common
code shared by them will be built into kernel. The common code provides
some helper routines and a device class named acpihp_slot_class. Class
acpihp_slot_class provides following default sysfs class properties:
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Gaohuai Han <hangaohuai@huawei.com>
---
 drivers/acpi/Kconfig          |   13 +
 drivers/acpi/Makefile         |    2 +
 drivers/acpi/hotplug/Makefile |    6 +
 drivers/acpi/hotplug/acpihp.h |   32 +++
 drivers/acpi/hotplug/core.c   |  562 +++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_hotplug.h   |  200 +++++++++++++++
 6 files changed, 815 insertions(+)
 create mode 100644 drivers/acpi/hotplug/Makefile
 create mode 100644 drivers/acpi/hotplug/acpihp.h
 create mode 100644 drivers/acpi/hotplug/core.c
 create mode 100644 include/acpi/acpi_hotplug.h

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 119d58d..01b87c7 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -321,6 +321,19 @@ config X86_PM_TIMER
 	  You should nearly always say Y here because many modern
 	  systems require this timer. 
 
+menuconfig ACPI_HOTPLUG
+	bool "ACPI Based System Device Hotplug (EXPERIMENTAL)"
+	depends on (X86 || IA64) && SYSFS && EXPERIMENTAL
+	default n
+	help
+	  System devices, including processor, memory and PCI host bridge etc,
+	  could be dynamically reconfigured at runtime through ACPI device
+	  configuration interfaces. This option enables a framework to
+	  dynamically reconfiguring system devices based ACPI specifications.
+
+	  If your hardware and firmware do not support dynamic reconfiguration
+	  of system devices at runtime, you need not to enable this option.
+
 config ACPI_CONTAINER
 	tristate "Container and Module Devices (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 47199e2..17bea6c 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -73,3 +73,5 @@ obj-$(CONFIG_ACPI_PROCESSOR_AGGREGATOR) += acpi_pad.o
 obj-$(CONFIG_ACPI_IPMI)		+= acpi_ipmi.o
 
 obj-$(CONFIG_ACPI_APEI)		+= apei/
+
+obj-$(CONFIG_ACPI_HOTPLUG)	+= hotplug/
diff --git a/drivers/acpi/hotplug/Makefile b/drivers/acpi/hotplug/Makefile
new file mode 100644
index 0000000..5e7790f
--- /dev/null
+++ b/drivers/acpi/hotplug/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for ACPI based system device hotplug drivers
+#
+
+obj-$(CONFIG_ACPI_HOTPLUG)			+= acpihp.o
+acpihp-y					= core.o
diff --git a/drivers/acpi/hotplug/acpihp.h b/drivers/acpi/hotplug/acpihp.h
new file mode 100644
index 0000000..7467895
--- /dev/null
+++ b/drivers/acpi/hotplug/acpihp.h
@@ -0,0 +1,32 @@
+/*
+ * Copyright (C) 2012 Huawei Tech. Co., Ltd.
+ * Copyright (C) 2012 Jiang Liu <jiang.liu@huawei.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+#ifndef	ACPIHP_INTERNAL_H
+#define	ACPIHP_INTERNAL_H
+#include <acpi/acpi.h>
+#include <acpi/acpi_bus.h>
+#include <acpi/acpi_hotplug.h>
+
+extern struct acpi_device *acpi_root;
+
+#endif
diff --git a/drivers/acpi/hotplug/core.c b/drivers/acpi/hotplug/core.c
new file mode 100644
index 0000000..086f4e5
--- /dev/null
+++ b/drivers/acpi/hotplug/core.c
@@ -0,0 +1,562 @@
+/*
+ * Copyright (C) 2012 Huawei Tech. Co., Ltd.
+ * Copyright (C) 2012 Jiang Liu <jiang.liu@huawei.com>
+ * Copyright (C) 2012 Gaohuai Han <hangaohuai@huawei.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/acpi.h>
+#include <linux/bug.h>
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <linux/sem.h>
+#include <linux/version.h>
+#include <acpi/acpi.h>
+#include <acpi/acpi_bus.h>
+#include <acpi/acpi_hotplug.h>
+#include "acpihp.h"
+
+#define to_acpihp_slot(d) container_of(d, struct acpihp_slot, dev)
+
+static DEFINE_MUTEX(acpihp_mutex);
+static int acpihp_class_count;
+static struct kset *acpihp_slot_kset;
+
+static char *acpihp_slot_names[ACPIHP_SLOT_TYPE_MAX] = {
+	[ACPIHP_SLOT_TYPE_UNKNOWN]	= "UNKNOWN",
+	[ACPIHP_SLOT_TYPE_COMMON]	= "SLOT",
+	[ACPIHP_SLOT_TYPE_NODE]		= "NODE",
+	[ACPIHP_SLOT_TYPE_SYSTEM_BOARD]	= "SB",
+	[ACPIHP_SLOT_TYPE_CPU]		= "CPU",
+	[ACPIHP_SLOT_TYPE_MEM]		= "MEM",
+	[ACPIHP_SLOT_TYPE_IOX]		= "IOX",
+};
+
+static char *acpihp_slot_descriptions[ACPIHP_SLOT_TYPE_MAX] = {
+	[ACPIHP_SLOT_TYPE_UNKNOWN]	= "unknown ACPI hotplug slot",
+	[ACPIHP_SLOT_TYPE_COMMON]	= "generic ACPI hotplug slot",
+	[ACPIHP_SLOT_TYPE_NODE]		= "ACPI hotplug slot for computer node",
+	[ACPIHP_SLOT_TYPE_SYSTEM_BOARD]	= "ACPI hotplug slot for system board",
+	[ACPIHP_SLOT_TYPE_CPU]		= "ACPI hotplug slot for processor",
+	[ACPIHP_SLOT_TYPE_MEM]		= "ACPI hotplug slot for memory",
+	[ACPIHP_SLOT_TYPE_IOX]		= "ACPI hotplug slot for IO extension",
+};
+
+static char *acpihp_slot_states[] = {
+	[ACPIHP_SLOT_STATE_UNKNOWN]		= "unknown",
+	[ACPIHP_SLOT_STATE_ABSENT]		= "absent",
+	[ACPIHP_SLOT_STATE_PRESENT]		= "present",
+	[ACPIHP_SLOT_STATE_POWERED]		= "powered",
+	[ACPIHP_SLOT_STATE_CONNECTED]		= "connected",
+	[ACPIHP_SLOT_STATE_CONFIGURED]		= "configured",
+	[ACPIHP_SLOT_STATE_POWERING_ON]		= "powering on",
+	[ACPIHP_SLOT_STATE_POWERING_OFF]	= "powering off",
+	[ACPIHP_SLOT_STATE_CONNECTING]		= "connecting",
+	[ACPIHP_SLOT_STATE_DISCONNECTING]	= "disconneting",
+	[ACPIHP_SLOT_STATE_CONFIGURING]		= "configuring",
+	[ACPIHP_SLOT_STATE_UNCONFIGURING]	= "unconfiguring",
+};
+
+static char *acpihp_slot_status[] = {
+	"ok",
+	"irremovable",
+	"fault",
+	"irremovable, fault",
+};
+
+static char *acpihp_dev_container_ids[] = {
+	"ACPI0004",
+	"PNP0A05",
+	"PNP0A06",
+	NULL
+};
+
+static char *acpihp_dev_cpu_ids[] = {
+	"ACPI0007",
+	"LNXCPU",
+	NULL
+};
+
+static char *acpihp_dev_mem_ids[] = {
+	"PNP0C80",
+	NULL
+};
+
+static char *acpihp_dev_pcihb_ids[] = {
+	"PNP0A03",
+	"PNP0A08",
+	NULL
+};
+
+static char *acpihp_dev_ioapic_ids[] = {
+	"ACPI0009",
+	"ACPI000A",
+	"ACPI000B",
+	NULL
+};
+
+static void acpihp_slot_release(struct device *dev)
+{
+	struct acpihp_slot *slot = to_acpihp_slot(dev);
+
+	kfree(slot);
+}
+
+struct acpihp_slot *acpihp_create_slot(acpi_handle handle, char *name)
+{
+	struct acpihp_slot *slot;
+
+	if (name && strlen(name) >= ACPIHP_SLOT_NAME_MAX_SIZE) {
+		ACPIHP_DEBUG("slot name '%s' is too big.\n", name);
+		return NULL;
+	}
+
+	slot = kzalloc(sizeof(*slot), GFP_KERNEL);
+	if (slot == NULL) {
+		ACPIHP_DEBUG("fails to allocate memory for slot device.\n");
+		return NULL;
+	}
+
+	slot->handle = handle;
+	INIT_LIST_HEAD(&slot->slot_list);
+	INIT_LIST_HEAD(&slot->drvdata_list);
+	if (name)
+		strncpy(slot->name, name, sizeof(slot->name) - 1);
+	mutex_init(&slot->slot_mutex);
+
+	slot->dev.class = &acpihp_slot_class;
+	device_initialize(&slot->dev);
+
+	return slot;
+}
+EXPORT_SYMBOL_GPL(acpihp_create_slot);
+
+int acpihp_register_slot(struct acpihp_slot *slot)
+{
+	int ret;
+
+	if (!slot || !slot->slot_ops)
+		return -EINVAL;
+
+	/* Use ACPI root device to host top level hotplug slots */
+	if (slot->parent)
+		slot->dev.parent = &slot->parent->dev;
+	else
+		slot->dev.parent = &acpi_root->dev;
+
+	ret = device_add(&slot->dev);
+	if (!ret) {
+		slot->flags |= ACPIHP_SLOT_FLAG_REGISTERED;
+		if (sysfs_create_link(&acpihp_slot_kset->kobj, &slot->dev.kobj,
+				      slot->name))
+			dev_warn(&slot->dev, "fails to create symlink.\n");
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(acpihp_register_slot);
+
+void acpihp_unregister_slot(struct acpihp_slot *slot)
+{
+	if (slot && (slot->flags & ACPIHP_SLOT_FLAG_REGISTERED)) {
+		sysfs_remove_link(&acpihp_slot_kset->kobj, slot->name);
+		device_del(&slot->dev);
+	}
+}
+EXPORT_SYMBOL_GPL(acpihp_unregister_slot);
+
+struct acpihp_slot *acpihp_slot_get(struct acpihp_slot *slot)
+{
+	if (slot)
+		get_device(&slot->dev);
+
+	return slot;
+}
+EXPORT_SYMBOL_GPL(acpihp_slot_get);
+
+void acpihp_slot_put(struct acpihp_slot *slot)
+{
+	if (slot)
+		put_device(&slot->dev);
+}
+EXPORT_SYMBOL_GPL(acpihp_slot_put);
+
+static void acpihp_slot_data_handler(acpi_handle handle, void *context)
+{
+	return;
+}
+
+acpi_status acpihp_mark_slot(acpi_handle handle, struct acpihp_slot *slot)
+{
+	acpi_status status;
+
+	mutex_lock(&acpihp_mutex);
+	status = acpi_attach_data(handle, &acpihp_slot_data_handler, slot);
+	mutex_unlock(&acpihp_mutex);
+
+	return status;
+}
+EXPORT_SYMBOL_GPL(acpihp_mark_slot);
+
+acpi_status acpihp_unmark_slot(acpi_handle handle)
+{
+	acpi_status result;
+
+	mutex_lock(&acpihp_mutex);
+	result = acpi_detach_data(handle, &acpihp_slot_data_handler);
+	if (result == AE_NOT_FOUND)
+		result = AE_OK;
+	BUG_ON(result != AE_OK);
+	mutex_unlock(&acpihp_mutex);
+
+	return result;
+}
+EXPORT_SYMBOL_GPL(acpihp_unmark_slot);
+
+bool acpihp_is_slot(acpi_handle handle)
+{
+	acpi_status result;
+	void *data = NULL;
+
+	result = acpi_get_data(handle, &acpihp_slot_data_handler, &data);
+	BUG_ON(result != AE_OK && result != AE_NOT_FOUND);
+
+	return (result == AE_OK);
+}
+EXPORT_SYMBOL_GPL(acpihp_is_slot);
+
+bool acpihp_get_slot(acpi_handle handle, struct acpihp_slot **slot)
+{
+	acpi_status result;
+	void *data = NULL;
+
+	mutex_lock(&acpihp_mutex);
+	result = acpi_get_data(handle, &acpihp_slot_data_handler, &data);
+	if (slot) {
+		if (result == AE_OK) {
+			*slot = data;
+			acpihp_slot_get(*slot);
+		} else
+			*slot = NULL;
+	}
+	mutex_unlock(&acpihp_mutex);
+
+	return (result == AE_OK);
+}
+EXPORT_SYMBOL_GPL(acpihp_get_slot);
+
+bool acpihp_dev_match_ids(struct acpi_device_info *infop, char **ids)
+{
+	int i, j;
+	struct acpica_device_id_list *cid_list;
+
+	if (infop == NULL || ids == NULL) {
+		ACPIHP_DEBUG("invalid parameters.\n");
+		return false;
+	}
+
+	if (infop->valid & ACPI_VALID_HID) {
+		for (i = 0; ids[i]; i++) {
+			if (strncmp(ids[i], infop->hardware_id.string,
+				    infop->hardware_id.length) == 0) {
+				return true;
+			}
+		}
+	}
+
+	if (!(infop->valid & ACPI_VALID_CID)) {
+		for (i = 0; ids[i]; i++) {
+			cid_list = &infop->compatible_id_list;
+			for (j = 0; j < cid_list->count; j++) {
+				if (strncmp(ids[i],
+					    cid_list->ids[j].string,
+					    cid_list->ids[j].length) == 0) {
+						return true;
+				}
+			}
+		}
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(acpihp_dev_match_ids);
+
+int acpihp_dev_get_type(acpi_handle handle, enum acpihp_dev_type *type)
+{
+	struct acpi_device_info *infop = NULL;
+
+	if (handle == NULL || type == NULL) {
+		ACPIHP_DEBUG("invalid parameters.\n");
+		return -EINVAL;
+	}
+	if (ACPI_FAILURE(acpi_get_object_info(handle, &infop)))
+		return -ENODEV;
+
+	*type = ACPIHP_DEV_TYPE_UNKNOWN;
+	if (infop->type == ACPI_TYPE_PROCESSOR) {
+		*type = ACPIHP_DEV_TYPE_CPU;
+	} else if (infop->type == ACPI_TYPE_DEVICE) {
+		if (acpihp_dev_match_ids(infop, acpihp_dev_container_ids))
+			*type = ACPIHP_DEV_TYPE_CONTAINER;
+		else if (acpihp_dev_match_ids(infop, acpihp_dev_cpu_ids))
+			*type = ACPIHP_DEV_TYPE_CPU;
+		else if (acpihp_dev_match_ids(infop, acpihp_dev_mem_ids))
+			*type = ACPIHP_DEV_TYPE_MEM;
+		else if (acpihp_dev_match_ids(infop, acpihp_dev_pcihb_ids))
+			*type = ACPIHP_DEV_TYPE_HOST_BRIDGE;
+		else if (acpihp_dev_match_ids(infop, acpihp_dev_ioapic_ids))
+			*type = ACPIHP_DEV_TYPE_IOAPIC;
+		else if ((infop->valid & (ACPI_VALID_ADR | ACPI_VALID_HID |
+			 ACPI_VALID_CID)) == ACPI_VALID_ADR)
+			*type = ACPIHP_DEV_TYPE_MAX;
+	}
+	kfree(infop);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(acpihp_dev_get_type);
+
+char *acpihp_get_slot_type_name(enum acpihp_slot_type type)
+{
+	if (type < 0 || type >= ACPIHP_SLOT_TYPE_MAX) {
+		ACPIHP_DEBUG("invalid parameters.\n");
+		return "UNKNOWN";
+	} else {
+		return acpihp_slot_names[type];
+	}
+}
+EXPORT_SYMBOL_GPL(acpihp_get_slot_type_name);
+
+/*
+ * slot_ops should be valid during the life cycle of a slot, so no protection.
+ */
+acpi_status acpihp_slot_get_status(struct acpihp_slot *slot, u64 *status)
+{
+	acpi_status rc;
+
+	if (slot == NULL || status == NULL) {
+		ACPIHP_DEBUG("invalid parameters.\n");
+		return AE_BAD_PARAMETER;
+	} else if (slot->slot_ops == NULL) {
+		ACPIHP_SLOT_DEBUG(slot, "operation not supported.\n");
+		return AE_SUPPORT;
+	} else if (slot->slot_ops->get_status)
+		return slot->slot_ops->get_status(slot->handle, status);
+
+	rc = acpi_evaluate_integer(slot->handle, METHOD_NAME__UID,
+				   NULL, status);
+	if (rc == AE_NOT_FOUND) {
+		*status = ACPI_STA_DEVICE_PRESENT | ACPI_STA_DEVICE_ENABLED |
+			  ACPI_STA_DEVICE_FUNCTIONING;
+		rc = AE_OK;
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(acpihp_slot_get_status);
+
+acpi_status acpihp_slot_poweron(struct acpihp_slot *slot)
+{
+	if (slot == NULL) {
+		ACPIHP_DEBUG("invalid parameter.\n");
+		return AE_BAD_PARAMETER;
+	} else if (slot->slot_ops == NULL || slot->slot_ops->poweron == NULL) {
+		ACPIHP_SLOT_DEBUG(slot, "operation not supported.\n");
+		return AE_SUPPORT;
+	}
+
+	return slot->slot_ops->poweron(slot->handle);
+}
+EXPORT_SYMBOL_GPL(acpihp_slot_poweron);
+
+acpi_status acpihp_slot_poweroff(struct acpihp_slot *slot)
+{
+	if (slot == NULL) {
+		ACPIHP_DEBUG("invalid parameter.\n");
+		return AE_BAD_PARAMETER;
+	} else if (slot->slot_ops == NULL || slot->slot_ops->poweroff == NULL) {
+		ACPIHP_SLOT_DEBUG(slot, "operation not supported.\n");
+		return AE_SUPPORT;
+	}
+
+	return slot->slot_ops->poweroff(slot->handle);
+}
+EXPORT_SYMBOL_GPL(acpihp_slot_poweroff);
+
+/* SYSFS interfaces */
+static ssize_t acpihp_slot_object_show(struct device *d,
+		struct device_attribute *attr, char *buf)
+{
+	ssize_t sz;
+	struct acpihp_slot *slot = to_acpihp_slot(d);
+	struct acpi_buffer path = {ACPI_ALLOCATE_BUFFER, NULL};
+
+	sz = acpi_get_name(slot->handle, ACPI_FULL_PATHNAME, &path);
+	if (sz)
+		goto end;
+
+	sz = sprintf(buf, "%s\n", (char *)path.pointer);
+	kfree(path.pointer);
+end:
+	return sz;
+}
+
+static ssize_t acpihp_slot_type_show(struct device *d,
+		struct device_attribute *attr, char *buf)
+{
+	enum acpihp_slot_type type;
+	struct acpihp_slot *slot = to_acpihp_slot(d);
+
+	type = slot->type < 0 || slot->type >= ACPIHP_SLOT_TYPE_MAX ?
+		ACPIHP_SLOT_TYPE_UNKNOWN : slot->type;
+
+	return snprintf(buf, PAGE_SIZE, "%s: %s\n",
+			acpihp_get_slot_type_name(type),
+			acpihp_slot_descriptions[type]);
+}
+
+static ssize_t acpihp_slot_state_show(struct device *d,
+		struct device_attribute *attr, char *buf)
+{
+	enum acpihp_slot_state state;
+	acpi_status status;
+	unsigned long long sta;
+	struct acpihp_slot *slot = to_acpihp_slot(d);
+
+	state = slot->state < 0 || slot->state >= ACPIHP_SLOT_STATE_MAX ?
+		ACPIHP_SLOT_STATE_UNKNOWN : slot->state;
+
+	if ((ACPIHP_SLOT_STATE_ABSENT == state) ||
+	     (ACPIHP_SLOT_STATE_PRESENT == state)) {
+		status = acpihp_slot_get_status(slot, &sta);
+		if (ACPI_SUCCESS(status)) {
+			if ((sta & ACPI_STA_DEVICE_PRESENT) ==
+				ACPI_STA_DEVICE_PRESENT)
+				state = ACPIHP_SLOT_STATE_PRESENT;
+			else
+				state = ACPIHP_SLOT_STATE_ABSENT;
+		}
+	}
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", acpihp_slot_states[state]);
+}
+
+static ssize_t acpihp_slot_status_show(struct device *d,
+		struct device_attribute *attr, char *buf)
+{
+	struct acpihp_slot *slot = to_acpihp_slot(d);
+	u32 status = slot->flags & ACPIHP_SLOT_STATUS_MASK;
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", acpihp_slot_status[status]);
+}
+
+static ssize_t acpihp_slot_capabilities_show(struct device *d,
+		struct device_attribute *attr, char *buf)
+{
+	ssize_t sz;
+	struct acpihp_slot *slot = to_acpihp_slot(d);
+	u32 cap = slot->capabilities;
+
+	sz = snprintf(buf, PAGE_SIZE, "%s%s%s%s%s%s",
+		(cap & ACPIHP_SLOT_CAP_ONLINE) ? "online," : "",
+		(cap & ACPIHP_SLOT_CAP_OFFLINE) ? "offline," : "",
+		(cap & ACPIHP_SLOT_CAP_POWERON) ? "poweron," : "",
+		(cap & ACPIHP_SLOT_CAP_POWEROFF) ? "poweroff," : "",
+		(cap & ACPIHP_SLOT_CAP_HOTPLUG) ? "hotplug," : "",
+		(cap & ACPIHP_SLOT_CAP_MIGRATE) ? "migrate," : "");
+	BUG_ON(sz == 0);
+	if (sz)
+		buf[--sz] = '\n';
+
+	return sz + 1;
+}
+
+struct device_attribute acpihp_slot_dev_attrs[] = {
+	__ATTR(object, S_IRUGO, acpihp_slot_object_show, NULL),
+	__ATTR(type, S_IRUGO, acpihp_slot_type_show, NULL),
+	__ATTR(state, S_IRUGO, acpihp_slot_state_show, NULL),
+	__ATTR(status, S_IRUGO, acpihp_slot_status_show, NULL),
+	__ATTR(capabilities, S_IRUGO, acpihp_slot_capabilities_show, NULL),
+	__ATTR_NULL
+};
+
+/* The device class to support ACPI hotplug slots. */
+struct class acpihp_slot_class = {
+	.name		= "acpihp",
+	.dev_release	= &acpihp_slot_release,
+	.dev_attrs	= acpihp_slot_dev_attrs,
+};
+EXPORT_SYMBOL_GPL(acpihp_slot_class);
+
+int acpihp_register_class(void)
+{
+	int retval = 0;
+	struct kset *acpi_bus_kset;
+
+	mutex_lock(&acpihp_mutex);
+	BUG_ON(acpihp_class_count < 0);
+	if (acpihp_class_count == 0) {
+		acpi_bus_kset = bus_get_kset(&acpi_bus_type);
+		acpihp_slot_kset = kset_create_and_add("acpihp", NULL,
+						       &acpi_bus_kset->kobj);
+		if (!acpihp_slot_kset) {
+			ACPIHP_DEBUG("fails to create kset.\n");
+			retval = -ENOMEM;
+			goto out_unlock;
+		}
+
+		retval = class_register(&acpihp_slot_class);
+		if (retval) {
+			ACPIHP_DEBUG("fails to register acpihp_slot_class.\n");
+			kset_unregister(acpihp_slot_kset);
+			goto out_unlock;
+		}
+	}
+	acpihp_class_count++;
+out_unlock:
+	mutex_unlock(&acpihp_mutex);
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(acpihp_register_class);
+
+void acpihp_unregister_class(void)
+{
+	mutex_lock(&acpihp_mutex);
+	BUG_ON(acpihp_class_count <= 0);
+	--acpihp_class_count;
+	if (acpihp_class_count == 0) {
+		class_unregister(&acpihp_slot_class);
+		kset_unregister(acpihp_slot_kset);
+		acpihp_slot_kset = NULL;
+	}
+	mutex_unlock(&acpihp_mutex);
+}
+EXPORT_SYMBOL_GPL(acpihp_unregister_class);
+
+#ifdef	DEBUG
+int acpihp_debug = 1;
+#else
+int acpihp_debug;
+#endif
+EXPORT_SYMBOL_GPL(acpihp_debug);
+module_param_named(debug, acpihp_debug, int, S_IRUGO | S_IWUSR);
diff --git a/include/acpi/acpi_hotplug.h b/include/acpi/acpi_hotplug.h
new file mode 100644
index 0000000..0b61a10
--- /dev/null
+++ b/include/acpi/acpi_hotplug.h
@@ -0,0 +1,200 @@
+/*
+ * Copyright (C) 2012 Huawei Tech. Co., Ltd.
+ * Copyright (C) 2012 Jiang Liu <jiang.liu@huawei.com>
+ * Copyright (C) 2012 Gaohuai Han <hangaohuai@huawei.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+#ifndef	__ACPI_HOTPLUG_H__
+#define	__ACPI_HOTPLUG_H__
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/klist.h>
+#include <acpi/acpi.h>
+#include <acpi/acpi_drivers.h>
+
+#ifdef	CONFIG_ACPI_HOTPLUG
+
+#define	ACPIHP_SLOT_NAME_MAX_SIZE		16
+
+/* Types of system devices supported by the ACPI hotplug framework. */
+enum acpihp_dev_type {
+	ACPIHP_DEV_TYPE_UNKNOWN = 0,	/* Unknown device type */
+	ACPIHP_DEV_TYPE_CONTAINER,	/* ACPI container device */
+	ACPIHP_DEV_TYPE_MEM,		/* Memory device */
+	ACPIHP_DEV_TYPE_CPU,		/* Logical CPU device */
+	ACPIHP_DEV_TYPE_HOST_BRIDGE,	/* PCI/PCIe host bridge */
+	ACPIHP_DEV_TYPE_IOAPIC,		/* IOAPIC/IOxAPIC/IOSAPIC */
+	ACPIHP_DEV_TYPE_MAX
+};
+
+/*
+ * ACPI hotplug slot is an abstraction of receptacles where a group of
+ * system devices could be attached, just like PCI slot in PCI hotplug.
+ */
+enum acpihp_slot_type {
+	ACPIHP_SLOT_TYPE_UNKNOWN = 0,	/* Unknown slot type */
+	ACPIHP_SLOT_TYPE_COMMON,	/* Generic hotplug slot */
+	ACPIHP_SLOT_TYPE_NODE,		/* Node hosts CPU, MEM & IO devices */
+	ACPIHP_SLOT_TYPE_SYSTEM_BOARD,	/* System board hosts CPU & MEM */
+	ACPIHP_SLOT_TYPE_CPU,		/* CPU board */
+	ACPIHP_SLOT_TYPE_MEM,		/* Memory board */
+	ACPIHP_SLOT_TYPE_IOX,		/* IO eXtension board */
+	ACPIHP_SLOT_TYPE_MAX
+};
+
+/*
+ * States of ACPI hotplug slot:
+ *                     (POWERON)      (CONNECT)      (CONFIGURE)
+ * [ABSENT] <-> [PRESENT] <-> [POWERED] <-> [CONNECTED] <-> [CONFIGURED]
+ *                     (POWEROFF)    (DISCONNECT)   (UNCONFIGURE)
+ */
+enum acpihp_slot_state {
+	ACPIHP_SLOT_STATE_UNKNOWN = 0,
+	ACPIHP_SLOT_STATE_ABSENT,	/* slot is empty. */
+	ACPIHP_SLOT_STATE_PRESENT,	/* slot is populated. */
+	ACPIHP_SLOT_STATE_POWERED,	/* attached devices are powered. */
+	ACPIHP_SLOT_STATE_CONNECTED,	/* ACPI device nodes created. */
+	ACPIHP_SLOT_STATE_CONFIGURED,	/* attached devices are configured. */
+	ACPIHP_SLOT_STATE_POWERING_ON,	/* powering devices on */
+	ACPIHP_SLOT_STATE_POWERING_OFF,	/* powering devices off */
+	ACPIHP_SLOT_STATE_CONNECTING,	/* creating ACPI device nodes */
+	ACPIHP_SLOT_STATE_DISCONNECTING,/* destroying ACPI device nodes */
+	ACPIHP_SLOT_STATE_CONFIGURING,	/* configuring devices */
+	ACPIHP_SLOT_STATE_UNCONFIGURING,/* unconfigure devices */
+	ACPIHP_SLOT_STATE_MAX
+};
+
+/* Devices attached to the slot can't be hot-removed. */
+#define	ACPIHP_SLOT_FLAG_IRREMOVABLE	0x1
+/* Devices attached to the slot have encountered serious problems. */
+#define	ACPIHP_SLOT_FLAG_FAULT		0x2
+#define	ACPIHP_SLOT_STATUS_MASK		0x3
+/* Devices attached to the slot have been registered. */
+#define	ACPIHP_SLOT_FLAG_REGISTERED	0x80000000
+
+/* ACPI hotplug slot capabilities. */
+#define	ACPIHP_SLOT_CAP_ONLINE		0x1  /* Logical online */
+#define	ACPIHP_SLOT_CAP_OFFLINE		0x2  /* Logical offline */
+#define	ACPIHP_SLOT_CAP_POWERON		0x4  /* Physical power on */
+#define	ACPIHP_SLOT_CAP_POWEROFF	0x8  /* Physical power off */
+#define	ACPIHP_SLOT_CAP_HOTPLUG		0x10 /* Physical hotplug */
+#define	ACPIHP_SLOT_CAP_MIGRATE		0x20 /* Device migration */
+
+struct acpihp_slot;
+
+/*
+ * Callbacks provided by the platform dependent hotplug slot driver, which
+ * will be used by the platform independent ACPI hotplug framework to manage
+ * ACPI hotplug slots.
+ */
+struct acpihp_slot_ops {
+	struct module *owner;
+	char *desc;
+	acpi_status (*init)(void);
+	void (*fini)(void);					/* optional */
+	acpi_status (*check)(acpi_handle handle);
+	acpi_status (*create)(struct acpihp_slot *slot);
+	void (*destroy)(struct acpihp_slot *slot);		/* optional */
+	acpi_status (*poweron)(struct acpihp_slot *slot);	/* optional */
+	acpi_status (*poweroff)(struct acpihp_slot *slot);	/* optional */
+	acpi_status (*get_status)(struct acpihp_slot *slot,
+				  u64 *status);			/* optional */
+};
+
+/* Device structure for ACPI hotplug slots. */
+struct acpihp_slot {
+	struct device			dev;
+	acpi_handle			handle;
+	u32				capabilities;
+	u32				flags;
+	enum acpihp_slot_type		type;
+	enum acpihp_slot_state		state;
+	struct acpihp_slot		*parent;
+	struct acpihp_slot_ops		*slot_ops;
+	void				*slot_data;
+	struct mutex			slot_mutex;
+	struct list_head		slot_list;
+	struct list_head		drvdata_list;
+	struct klist			dev_lists[ACPIHP_DEV_TYPE_MAX];
+	char				name[ACPIHP_SLOT_NAME_MAX_SIZE];
+};
+
+/* Device class for ACPI hotplug slots */
+extern struct class acpihp_slot_class;
+
+/* Register the ACPI hotplug slot class driver */
+extern int acpihp_register_class(void);
+
+/* Unregister the ACPI hotplug slot class driver */
+extern void acpihp_unregister_class(void);
+
+/* Utility routines */
+extern int acpihp_dev_get_type(acpi_handle handle, enum acpihp_dev_type *type);
+extern bool acpihp_dev_match_ids(struct acpi_device_info *infop, char **ids);
+extern char *acpihp_get_slot_type_name(enum acpihp_slot_type type);
+
+/* Mark/unmark an ACPI object as an ACPI hotplug slot. */
+extern acpi_status acpihp_mark_slot(acpi_handle handle,
+				    struct acpihp_slot *slot);
+extern acpi_status acpihp_unmark_slot(acpi_handle handle);
+
+/* Check whether the ACPI object is a hotplug slot. */
+extern bool acpihp_is_slot(acpi_handle handle);
+
+/* Interfaces to manage ACPI hotplug slots */
+extern struct acpihp_slot *acpihp_create_slot(acpi_handle handle, char *name);
+extern int acpihp_register_slot(struct acpihp_slot *slot);
+extern void acpihp_unregister_slot(struct acpihp_slot *slot);
+extern struct acpihp_slot *acpihp_slot_get(struct acpihp_slot *slot);
+extern void acpihp_slot_put(struct acpihp_slot *slot);
+extern bool acpihp_get_slot(acpi_handle handle, struct acpihp_slot **slot);
+
+/* Platform dependent hotplug hooks */
+extern acpi_status acpihp_slot_get_status(struct acpihp_slot *slot,
+					  u64 *status);
+extern acpi_status acpihp_slot_poweron(struct acpihp_slot *slot);
+extern acpi_status acpihp_slot_poweroff(struct acpihp_slot *slot);
+
+extern int acpihp_debug;
+
+#define ACPIHP_WARN(fmt, ...) \
+	pr_warn("acpihp@%s: " fmt,  __func__, ##__VA_ARGS__)
+
+#define ACPIHP_DEBUG(fmt, ...) \
+	do { \
+		if (acpihp_debug & 0x01) \
+			pr_warn("acpihp@%s: " fmt,  __func__, ##__VA_ARGS__); \
+	} while (0)
+
+#define	ACPIHP_SLOT_DEBUG(slot, fmt, ...) \
+	do { \
+		if (acpihp_debug & 0x01) \
+			dev_warn(&(slot)->dev, fmt, ##__VA_ARGS__); \
+	} while (0)
+
+#define	ACPIHP_SLOT_WARN(slot, fmt, ...) \
+	dev_warn(&(slot)->dev, fmt, ##__VA_ARGS__)
+
+#endif	/* CONFIG_ACPI_HOTPLUG */
+
+#endif	/* __ACPI_HOTPLUG_H__ */
-- 
1.7.9.5


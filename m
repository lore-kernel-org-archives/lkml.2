Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab2JFPds (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 11:33:48 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:50017 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab2JFPdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 11:33:43 -0400
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
Subject: [RFC PATCH v3 16/28] ACPIHP: implement sysfs interfaces for ACPI system device hotplug
Date: Sat,  6 Oct 2012 23:27:24 +0800
Message-Id: <1349537256-21670-17-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
References: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements following sysfs interfaces for ACPI system device
hotplug.

SLOT/enable: (It should be named 'power', but that causes name conflicts.)
power on the hotplug slot:
	echo 1 > enable
power off the hotplug slot:
	echo 0 > enable:

SLOT/connect:
create ACPI devices for system devices connecting to a slot:
	echo 1 > connect
remove ACPI devices for system devices connecting to a slot:
	echo 0 > connect

SLOT/configure:
add system devices into running system:
	echo 1 > configure
remove system devices from running system:
	echo 0 > configure

SLOT/dependency:
show dependencies among hotplug slots:
	cat dependency

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
---
 drivers/acpi/hotplug/Makefile     |    1 +
 drivers/acpi/hotplug/acpihp_drv.h |    3 +
 drivers/acpi/hotplug/drv_main.c   |    5 +
 drivers/acpi/hotplug/sysfs.c      |  245 +++++++++++++++++++++++++++++++++++++
 4 files changed, 254 insertions(+)
 create mode 100644 drivers/acpi/hotplug/sysfs.c

diff --git a/drivers/acpi/hotplug/Makefile b/drivers/acpi/hotplug/Makefile
index 0f43933..57e348a 100644
--- a/drivers/acpi/hotplug/Makefile
+++ b/drivers/acpi/hotplug/Makefile
@@ -16,3 +16,4 @@ acpihp_drv-y					+= dependency.o
 acpihp_drv-y					+= cancel.o
 acpihp_drv-y					+= configure.o
 acpihp_drv-y					+= state_machine.o
+acpihp_drv-y					+= sysfs.o
diff --git a/drivers/acpi/hotplug/acpihp_drv.h b/drivers/acpi/hotplug/acpihp_drv.h
index fd94a1d..dcfa9ac 100644
--- a/drivers/acpi/hotplug/acpihp_drv.h
+++ b/drivers/acpi/hotplug/acpihp_drv.h
@@ -101,4 +101,7 @@ int acpihp_drv_unconfigure(struct list_head *list);
 /* The heart of the ACPI system device hotplug driver */
 int acpihp_drv_change_state(struct acpihp_slot *slot, enum acpihp_drv_cmd cmd);
 
+int acpihp_drv_create_sysfs(struct acpihp_slot *slot);
+void acpihp_drv_remove_sysfs(struct acpihp_slot *slot);
+
 #endif	/* __ACPIHP_DRV_H__ */
diff --git a/drivers/acpi/hotplug/drv_main.c b/drivers/acpi/hotplug/drv_main.c
index 3e2a52a..c474546 100644
--- a/drivers/acpi/hotplug/drv_main.c
+++ b/drivers/acpi/hotplug/drv_main.c
@@ -284,6 +284,10 @@ static int acpihp_drv_slot_add(struct device *dev, struct class_interface *intf)
 		return -ENOMEM;
 	}
 
+	if (acpihp_drv_create_sysfs(slot))
+		ACPIHP_SLOT_DEBUG(slot,
+			"fails to create sysfs interfaces, some functions will not be available to user.\n");
+
 	return 0;
 }
 
@@ -294,6 +298,7 @@ static void acpihp_drv_intf_remove(struct device *dev,
 	struct acpihp_slot *slot =
 			container_of(dev, struct acpihp_slot, dev);
 
+	acpihp_drv_remove_sysfs(slot);
 	acpihp_drv_uninstall_handler(slot);
 	acpihp_drv_remove_devices(slot);
 	acpihp_slot_detach_drv_data(slot, intf, (void **)&drv_data);
diff --git a/drivers/acpi/hotplug/sysfs.c b/drivers/acpi/hotplug/sysfs.c
new file mode 100644
index 0000000..fd8819b
--- /dev/null
+++ b/drivers/acpi/hotplug/sysfs.c
@@ -0,0 +1,245 @@
+/*
+ * Copyright (C) 2012 Huawei Tech. Co., Ltd.
+ * Copyright (C) 2012 Jiang Liu <jiang.liu@huawei.com>
+ * Copyright (C) 2012 Hanjun Guo <guohanjun@huawei.com>
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
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <acpi/acpi_hotplug.h>
+#include "acpihp_drv.h"
+
+static ssize_t acpihp_drv_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count,
+		enum acpihp_drv_cmd op_set, enum acpihp_drv_cmd op_clr)
+{
+	unsigned long val;
+	ssize_t result = kstrtoul(buf, 0, &val);
+	struct acpihp_slot *slot = container_of(dev, struct acpihp_slot, dev);
+
+	if (result < 0)
+		return result;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (val)
+		result = acpihp_drv_change_state(slot, op_set);
+	else
+		result = acpihp_drv_change_state(slot, op_clr);
+
+	return result < 0 ? result : count;
+}
+
+static inline ssize_t acpihp_drv_print_bool(char *page, bool flag)
+{
+	return snprintf(page, PAGE_SIZE, flag ? "1\n" : "0\n");
+}
+
+static ssize_t acpihp_drv_power_show(struct device *dev,
+		struct device_attribute *attr, char *page)
+{
+	bool flag;
+	struct acpihp_slot *slot = container_of(dev, struct acpihp_slot, dev);
+
+	acpihp_drv_update_slot_state(slot);
+	mutex_lock(&slot->slot_mutex);
+	switch (slot->state) {
+	case ACPIHP_SLOT_STATE_POWERED:
+	case ACPIHP_SLOT_STATE_CONNECTED:
+	case ACPIHP_SLOT_STATE_CONFIGURED:
+	case ACPIHP_SLOT_STATE_POWERING_ON:
+	case ACPIHP_SLOT_STATE_POWERING_OFF:
+	case ACPIHP_SLOT_STATE_CONNECTING:
+	case ACPIHP_SLOT_STATE_DISCONNECTING:
+	case ACPIHP_SLOT_STATE_CONFIGURING:
+	case ACPIHP_SLOT_STATE_UNCONFIGURING:
+		flag = true;
+		break;
+	default:
+		flag = false;
+		break;
+	}
+	mutex_unlock(&slot->slot_mutex);
+
+	return acpihp_drv_print_bool(page, flag);
+}
+
+static ssize_t acpihp_drv_power_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	return acpihp_drv_store(dev, attr, buf, count,
+			ACPIHP_DRV_CMD_POWERON, ACPIHP_DRV_CMD_POWEROFF);
+}
+
+/* It should be named as 'power', but that will cause name conflics. */
+DEVICE_ATTR(enable, S_IRUSR | S_IWUSR,
+	    &acpihp_drv_power_show, &acpihp_drv_power_store);
+
+static ssize_t acpihp_drv_connect_show(struct device *dev,
+		struct device_attribute *attr, char *page)
+{
+	bool flag;
+	struct acpihp_slot *slot = container_of(dev, struct acpihp_slot, dev);
+
+	acpihp_drv_update_slot_state(slot);
+	mutex_lock(&slot->slot_mutex);
+	switch (slot->state) {
+	case ACPIHP_SLOT_STATE_CONNECTED:
+	case ACPIHP_SLOT_STATE_CONFIGURED:
+	case ACPIHP_SLOT_STATE_CONNECTING:
+	case ACPIHP_SLOT_STATE_DISCONNECTING:
+	case ACPIHP_SLOT_STATE_CONFIGURING:
+	case ACPIHP_SLOT_STATE_UNCONFIGURING:
+		flag = true;
+		break;
+	default:
+		flag = false;
+		break;
+	}
+	mutex_unlock(&slot->slot_mutex);
+
+	return acpihp_drv_print_bool(page, flag);
+}
+
+static ssize_t acpihp_drv_connect_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	return acpihp_drv_store(dev, attr, buf, count,
+			ACPIHP_DRV_CMD_CONNECT, ACPIHP_DRV_CMD_DISCONNECT);
+}
+
+DEVICE_ATTR(connect, S_IRUSR | S_IWUSR,
+	    &acpihp_drv_connect_show, &acpihp_drv_connect_store);
+
+static ssize_t acpihp_drv_configure_show(struct device *dev,
+		struct device_attribute *attr, char *page)
+{
+	bool flag;
+	struct acpihp_slot *slot = container_of(dev, struct acpihp_slot, dev);
+
+	acpihp_drv_update_slot_state(slot);
+	mutex_lock(&slot->slot_mutex);
+	switch (slot->state) {
+	case ACPIHP_SLOT_STATE_CONFIGURED:
+	case ACPIHP_SLOT_STATE_CONFIGURING:
+	case ACPIHP_SLOT_STATE_UNCONFIGURING:
+		flag = true;
+		break;
+	default:
+		flag = false;
+		break;
+	}
+	mutex_unlock(&slot->slot_mutex);
+
+	return acpihp_drv_print_bool(page, flag);
+}
+
+static ssize_t acpihp_drv_configure_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	return acpihp_drv_store(dev, attr, buf, count,
+			ACPIHP_DRV_CMD_CONFIGURE, ACPIHP_DRV_CMD_UNCONFIGURE);
+}
+
+DEVICE_ATTR(configure, S_IRUSR | S_IWUSR,
+	    &acpihp_drv_configure_show, &acpihp_drv_configure_store);
+
+static ssize_t acpihp_drv_dependency_show(struct device *dev,
+		struct device_attribute *attr, char *page)
+{
+	int ret;
+	char *p, *end;
+	struct list_head list;
+	enum acpihp_drv_cmd cmd;
+	struct acpihp_slot_dependency *dep;
+	struct acpihp_slot *slot = container_of(dev, struct acpihp_slot, dev);
+
+	INIT_LIST_HEAD(&list);
+	mutex_lock(&state_machine_mutex);
+	cmd = acpihp_slot_powered(slot) ? ACPIHP_DRV_CMD_POWEROFF :
+					  ACPIHP_DRV_CMD_POWERON;
+	ret = acpihp_drv_generate_dependency_list(slot, &list, cmd);
+	if (ret) {
+		ret = -ENXIO;
+	} else {
+		p = page;
+		end = page + PAGE_SIZE;
+
+		list_for_each_entry(dep, &list, node) {
+			if (dep->slot == slot)
+				continue;
+			if (p + strlen(dep->slot->name) + 2 >= end)
+				break;
+			p += snprintf(p, end - p, "%s\n", dep->slot->name);
+		}
+
+		acpihp_drv_destroy_dependency_list(&list);
+		ret = p - page;
+	}
+	mutex_unlock(&state_machine_mutex);
+
+	return ret;
+}
+
+static DEVICE_ATTR(dependency, S_IRUSR | S_IWUSR,
+		   &acpihp_drv_dependency_show, NULL);
+
+int acpihp_drv_create_sysfs(struct acpihp_slot *slot)
+{
+	int retval;
+	struct device *dev = &slot->dev;
+
+	retval = device_create_file(dev, &dev_attr_enable);
+	if (retval)
+		goto out;
+	retval = device_create_file(dev, &dev_attr_connect);
+	if (retval)
+		goto out1;
+	retval = device_create_file(dev, &dev_attr_configure);
+	if (retval)
+		goto out2;
+	retval = device_create_file(dev, &dev_attr_dependency);
+	if (retval)
+		goto out3;
+
+	return 0;
+
+out3:
+	device_remove_file(dev, &dev_attr_configure);
+out2:
+	device_remove_file(dev, &dev_attr_connect);
+out1:
+	device_remove_file(dev, &dev_attr_enable);
+out:
+	ACPIHP_SLOT_DEBUG(slot, "fails to create sysfs interfaces for slot.\n");
+	return retval;
+}
+
+void acpihp_drv_remove_sysfs(struct acpihp_slot *slot)
+{
+	struct device *dev = &slot->dev;
+
+	device_remove_file(dev, &dev_attr_dependency);
+	device_remove_file(dev, &dev_attr_configure);
+	device_remove_file(dev, &dev_attr_connect);
+	device_remove_file(dev, &dev_attr_enable);
+}
-- 
1.7.9.5


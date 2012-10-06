Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab2JFPbb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 11:31:31 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33589 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab2JFPb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 11:31:28 -0400
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
Subject: [RFC PATCH v3 07/28] ACPIHP: use klist to manage ACPI devices connecting to a slot
Date: Sat,  6 Oct 2012 23:27:15 +0800
Message-Id: <1349537256-21670-8-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
References: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI devices connecting to an ACPI hotplug slot are divided into groups
according to device types. Those devices will be configured/unconfigured
in order of device types when hot-adding/hot-removing system devices.

For example, when hot-adding a computer node with CPUs, memory, PCI host
bridges, IOAPICs, the order optimized for performance should be:
memory -> CPU -> IOAPIC -> PCI host bridge.

It relies on klist to manage and protect ACPI devices connecting to
an ACPI hotplug slot.

Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/acpi/hotplug/core.c |  115 +++++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_hotplug.h |   27 ++++++++++
 2 files changed, 142 insertions(+)

diff --git a/drivers/acpi/hotplug/core.c b/drivers/acpi/hotplug/core.c
index 081b27f..1e6dbc8 100644
--- a/drivers/acpi/hotplug/core.c
+++ b/drivers/acpi/hotplug/core.c
@@ -114,6 +114,23 @@ static char *acpihp_dev_ioapic_ids[] = {
 	NULL
 };
 
+static void acpihp_dev_node_get(struct klist_node *lp)
+{
+	struct acpihp_dev_node *dp;
+
+	dp = container_of(lp, struct acpihp_dev_node, node);
+	get_device(dp->dev);
+}
+
+static void acpihp_dev_node_put(struct klist_node *lp)
+{
+	struct acpihp_dev_node *dp;
+
+	dp = container_of(lp, struct acpihp_dev_node, node);
+	put_device(dp->dev);
+	kfree(dp);
+}
+
 static void acpihp_slot_release(struct device *dev)
 {
 	struct acpihp_slot *slot = to_acpihp_slot(dev);
@@ -123,6 +140,7 @@ static void acpihp_slot_release(struct device *dev)
 
 struct acpihp_slot *acpihp_create_slot(acpi_handle handle, char *name)
 {
+	int i;
 	struct acpihp_slot *slot;
 
 	if (name && strlen(name) >= ACPIHP_SLOT_NAME_MAX_SIZE) {
@@ -139,6 +157,9 @@ struct acpihp_slot *acpihp_create_slot(acpi_handle handle, char *name)
 	slot->handle = handle;
 	INIT_LIST_HEAD(&slot->slot_list);
 	INIT_LIST_HEAD(&slot->drvdata_list);
+	for (i = ACPIHP_DEV_TYPE_UNKNOWN; i < ACPIHP_DEV_TYPE_MAX; i++)
+		klist_init(&slot->dev_lists[i],
+			   &acpihp_dev_node_get, &acpihp_dev_node_put);
 	if (name)
 		strncpy(slot->name, name, sizeof(slot->name) - 1);
 	mutex_init(&slot->slot_mutex);
@@ -402,6 +423,100 @@ acpi_status acpihp_slot_poweroff(struct acpihp_slot *slot)
 }
 EXPORT_SYMBOL_GPL(acpihp_slot_poweroff);
 
+/* Insert an ACPI device onto a hotplug slot's device list. */
+int acpihp_slot_add_device(struct acpihp_slot *slot, enum acpihp_dev_type type,
+			   enum acpihp_dev_state state, struct device *dev)
+{
+	struct acpihp_dev_node *np;
+
+	if (type < ACPIHP_DEV_TYPE_UNKNOWN || type >= ACPIHP_DEV_TYPE_MAX) {
+		ACPIHP_DEBUG("device type %d is invalid.\n", type);
+		return -EINVAL;
+	} else if (slot == NULL) {
+		ACPIHP_DEBUG("invalid parameter, slot is NULL.\n");
+		return -EINVAL;
+	} else if (dev == NULL) {
+		ACPIHP_SLOT_DEBUG(slot, "invalid parameter, dev is NULL.\n");
+		return -EINVAL;
+	}
+
+	np = kzalloc(sizeof(*np), GFP_KERNEL);
+	if (np == NULL) {
+		ACPIHP_SLOT_WARN(slot, "fails to allocate memory.\n");
+		return -ENOMEM;
+	}
+
+	np->dev = dev;
+	np->state = state;
+	mutex_init(&np->lock);
+	klist_add_tail(&np->node, &slot->dev_lists[type]);
+	ACPIHP_SLOT_DEBUG(slot, "add device %s to klist.\n", dev_name(dev));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(acpihp_slot_add_device);
+
+/* Remove an ACPI device from a hotplug slot's device list. */
+int acpihp_slot_remove_device(struct acpihp_slot *slot,
+			      enum acpihp_dev_type type, struct device *dev)
+{
+	int ret = -ENOENT;
+	struct klist_iter iter;
+	struct klist_node *ip;
+	struct acpihp_dev_node *np;
+
+	if (type < ACPIHP_DEV_TYPE_UNKNOWN || type >= ACPIHP_DEV_TYPE_MAX) {
+		ACPIHP_DEBUG("device type %d is invalid.\n", type);
+		return -EINVAL;
+	} else if (slot == NULL) {
+		ACPIHP_DEBUG("invalid parameter, slot is NULL.\n");
+		return -EINVAL;
+	} else if (dev == NULL) {
+		ACPIHP_SLOT_DEBUG(slot, "invalid parameter, dev is NULL.\n");
+		return -EINVAL;
+	}
+
+	klist_iter_init(&slot->dev_lists[type], &iter);
+	while ((ip = klist_next(&iter)) != NULL) {
+		np = container_of(ip, struct acpihp_dev_node, node);
+		if (np->dev == dev) {
+			ACPIHP_SLOT_DEBUG(slot,
+					  "remove device %s from klist.\n",
+					  dev_name(dev));
+			klist_del(&np->node);
+			ret = 0;
+			break;
+		}
+	}
+	klist_iter_exit(&iter);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(acpihp_slot_remove_device);
+
+/* Remove all ACPI devices from the list */
+int acpihp_remove_device_list(struct klist *dev_list)
+{
+	struct klist_iter iter;
+	struct klist_node *ip;
+	struct acpihp_dev_node *np;
+
+	if (dev_list == NULL) {
+		ACPIHP_DEBUG("invalid parameter, dev_list is NULL.\n");
+		return -EINVAL;
+	}
+
+	klist_iter_init(dev_list, &iter);
+	while ((ip = klist_next(&iter)) != NULL) {
+		np = container_of(ip, struct acpihp_dev_node, node);
+		klist_del(&np->node);
+	}
+	klist_iter_exit(&iter);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(acpihp_remove_device_list);
+
 /* SYSFS interfaces */
 static ssize_t acpihp_slot_object_show(struct device *d,
 		struct device_attribute *attr, char *buf)
diff --git a/include/acpi/acpi_hotplug.h b/include/acpi/acpi_hotplug.h
index 5025a16..2e7011e 100644
--- a/include/acpi/acpi_hotplug.h
+++ b/include/acpi/acpi_hotplug.h
@@ -47,6 +47,24 @@ enum acpihp_dev_type {
 	ACPIHP_DEV_TYPE_MAX
 };
 
+enum acpihp_dev_state {
+	DEVICE_STATE_UNKOWN = 0x00,
+	DEVICE_STATE_CONNECTED,
+	DEVICE_STATE_PRE_CONFIGURE,
+	DEVICE_STATE_CONFIGURED,
+	DEVICE_STATE_PRE_RELEASE,
+	DEVICE_STATE_RELEASED,
+	DEVICE_STATE_PRE_UNCONFIGURE,
+	DEVICE_STATE_MAX
+};
+
+struct acpihp_dev_node {
+	struct device		*dev;
+	enum acpihp_dev_state	state;
+	struct mutex		lock;
+	struct klist_node	node;
+};
+
 /*
  * ACPI hotplug slot is an abstraction of receptacles where a group of
  * system devices could be attached, just like PCI slot in PCI hotplug.
@@ -190,6 +208,15 @@ typedef acpi_status (*acpihp_walk_device_cb)(struct acpi_device *acpi_device,
 extern int acpihp_walk_devices(acpi_handle handle, acpihp_walk_device_cb cb,
 			       void *argp);
 
+extern int acpihp_slot_add_device(struct acpihp_slot *slot,
+				  enum acpihp_dev_type type,
+				  enum acpihp_dev_state state,
+				  struct device *dev);
+extern int acpihp_slot_remove_device(struct acpihp_slot *slot,
+				     enum acpihp_dev_type type,
+				     struct device *dev);
+extern int acpihp_remove_device_list(struct klist *dev_list);
+
 extern int acpihp_debug;
 
 #define ACPIHP_WARN(fmt, ...) \
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab2JFPdT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 11:33:19 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:50017 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab2JFPdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 11:33:14 -0400
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
Subject: [RFC PATCH v3 14/28] ACPIHP: configure/unconfigure system devices connecting to a hotplug slot
Date: Sat,  6 Oct 2012 23:27:22 +0800
Message-Id: <1349537256-21670-15-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
References: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements functions to configure/unconfigure system devices
connecting to a hotplug slot.

To support better error recover and cancellation, configuration operations are
splitted into three steps and unconfiguration operations are splitted into six
steps as below:
CONFIGURE
 1) pre_configure(): allocate required resources
 2) configure(): add devices into system
 3) pos_configure(): rollback if cancelled or failed to add devices
UNCONFIGURE
 1) pre_release(): optional
 2) release(): reclaim devices from system
 3) post_release(): rollback if cancelled or failed to reclaim devices
 4) pre_unconfigure(): optional
 5) unconfigure(): remove devices from system
 6) post_unconfigure(): free resources used by devices

And all devices are unconfigured in reverse order to solve failures caused
by dependencies.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/acpi/hotplug/Makefile     |    1 +
 drivers/acpi/hotplug/acpihp_drv.h |    3 +
 drivers/acpi/hotplug/configure.c  |  340 +++++++++++++++++++++++++++++++++++++
 3 files changed, 344 insertions(+)
 create mode 100644 drivers/acpi/hotplug/configure.c

diff --git a/drivers/acpi/hotplug/Makefile b/drivers/acpi/hotplug/Makefile
index f72f2c3..6cb6aa1 100644
--- a/drivers/acpi/hotplug/Makefile
+++ b/drivers/acpi/hotplug/Makefile
@@ -14,3 +14,4 @@ obj-$(CONFIG_ACPI_HOTPLUG_DRIVER)		+= acpihp_drv.o
 acpihp_drv-y					= drv_main.o
 acpihp_drv-y					+= dependency.o
 acpihp_drv-y					+= cancel.o
+acpihp_drv-y					+= configure.o
diff --git a/drivers/acpi/hotplug/acpihp_drv.h b/drivers/acpi/hotplug/acpihp_drv.h
index 1661e52..8fa37be 100644
--- a/drivers/acpi/hotplug/acpihp_drv.h
+++ b/drivers/acpi/hotplug/acpihp_drv.h
@@ -89,4 +89,7 @@ void acpihp_drv_cancel_fini(struct list_head *list);
 int acpihp_drv_cancel_start(struct list_head *list);
 int acpihp_drv_cancel_wait(struct list_head *list);
 
+int acpihp_drv_configure(struct list_head *list);
+int acpihp_drv_unconfigure(struct list_head *list);
+
 #endif	/* __ACPIHP_DRV_H__ */
diff --git a/drivers/acpi/hotplug/configure.c b/drivers/acpi/hotplug/configure.c
new file mode 100644
index 0000000..346b976
--- /dev/null
+++ b/drivers/acpi/hotplug/configure.c
@@ -0,0 +1,340 @@
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
+#include <linux/acpi.h>
+#include <linux/device.h>
+#include <acpi/acpi_bus.h>
+#include <acpi/acpi_hotplug.h>
+#include "acpihp_drv.h"
+
+enum config_op_code {
+	DRV_OP_PRE_CONFIGURE = 0xAC91,
+	DRV_OP_CONFIGURE,
+	DRV_OP_POST_CONFIGURE,
+	DRV_OP_PRE_RELEASE,
+	DRV_OP_RELEASE,
+	DRV_OP_POST_RELEASE,
+	DRV_OP_PRE_UNCONFIGURE,
+	DRV_OP_UNCONFIGURE,
+	DRV_OP_POST_UNCONFIGURE
+};
+
+/* All devices will be configured in following order. */
+static enum acpihp_dev_type acpihp_drv_dev_types[] = {
+	ACPIHP_DEV_TYPE_CONTAINER,
+	ACPIHP_DEV_TYPE_MEM,
+	ACPIHP_DEV_TYPE_CPU,
+	ACPIHP_DEV_TYPE_IOAPIC,
+	ACPIHP_DEV_TYPE_HOST_BRIDGE,
+};
+
+/* All devices will be unconfigured in following order. */
+static enum acpihp_dev_type acpihp_drv_dev_types_reverse[] = {
+	ACPIHP_DEV_TYPE_HOST_BRIDGE,
+	ACPIHP_DEV_TYPE_IOAPIC,
+	ACPIHP_DEV_TYPE_CPU,
+	ACPIHP_DEV_TYPE_MEM,
+	ACPIHP_DEV_TYPE_CONTAINER,
+};
+
+static void acpihp_drv_update_dev_state(struct acpihp_dev_node *dev,
+					enum acpihp_dev_state state)
+{
+	BUG_ON(state <= DEVICE_STATE_UNKOWN || state >= DEVICE_STATE_MAX);
+	mutex_lock(&dev->lock);
+	dev->state = state;
+	mutex_unlock(&dev->lock);
+}
+
+static int acpihp_drv_invoke_method(enum config_op_code  opcode,
+				    struct acpihp_slot *slot,
+				    struct acpi_device *dev, int post)
+{
+	struct acpihp_slot_drv *drv_data;
+
+	acpihp_drv_get_data(slot, &drv_data);
+
+	switch (opcode) {
+	case DRV_OP_PRE_CONFIGURE:
+		if (drv_data->cancel_ctx.check_cancel(&drv_data->cancel_ctx))
+			return -ECANCELED;
+		return acpihp_dev_pre_configure(dev, &drv_data->cancel_ctx);
+	case DRV_OP_CONFIGURE:
+		if (drv_data->cancel_ctx.check_cancel(&drv_data->cancel_ctx))
+			return -ECANCELED;
+		return acpihp_dev_configure(dev, &drv_data->cancel_ctx);
+	case DRV_OP_POST_CONFIGURE:
+		return acpihp_dev_post_configure(dev, post);
+	case DRV_OP_PRE_RELEASE:
+		if (drv_data->cancel_ctx.check_cancel(&drv_data->cancel_ctx))
+			return -ECANCELED;
+		return acpihp_dev_pre_release(dev, &drv_data->cancel_ctx);
+	case DRV_OP_RELEASE:
+		if (drv_data->cancel_ctx.check_cancel(&drv_data->cancel_ctx))
+			return -ECANCELED;
+		return acpihp_dev_release(dev, &drv_data->cancel_ctx);
+	case DRV_OP_POST_RELEASE:
+		return acpihp_dev_post_release(dev, post);
+	case DRV_OP_PRE_UNCONFIGURE:
+		return acpihp_dev_pre_unconfigure(dev);
+	case DRV_OP_UNCONFIGURE:
+		return acpihp_dev_unconfigure(dev);
+	case DRV_OP_POST_UNCONFIGURE:
+		return acpihp_dev_post_unconfigure(dev);
+	default:
+		BUG_ON(opcode);
+		return -ENOSYS;
+	}
+}
+
+static int acpihp_drv_call_method(enum config_op_code opcode,
+				  struct acpihp_slot *slot,
+				  enum acpihp_dev_type type,
+				  enum acpihp_dev_state state)
+{
+	int result = 0;
+	struct klist_iter iter;
+	struct klist_node *ip;
+	struct acpihp_dev_node *np;
+	struct acpi_device *acpi_dev;
+
+	klist_iter_init(&slot->dev_lists[type], &iter);
+	while ((ip = klist_next(&iter)) != NULL) {
+		np = container_of(ip, struct acpihp_dev_node, node);
+		acpi_dev = container_of(np->dev, struct acpi_device, dev);
+		result = acpihp_drv_invoke_method(opcode, slot, acpi_dev, 0);
+		if (result)
+			break;
+		acpihp_drv_update_dev_state(np, state);
+	}
+	klist_iter_exit(&iter);
+
+	return result;
+}
+
+static int acpihp_drv_call_method_post(enum config_op_code opcode,
+				       struct acpihp_slot *slot,
+				       enum acpihp_dev_type type,
+				       enum acpihp_dev_state state,
+				       enum acpihp_dev_post_cmd post)
+{
+	int retval = 0;
+	int result;
+	struct klist_iter iter;
+	struct klist_node *ip;
+	struct acpihp_dev_node *np;
+	struct acpi_device *acpi_dev;
+
+	klist_iter_init(&slot->dev_lists[type], &iter);
+	while ((ip = klist_next(&iter)) != NULL) {
+		np = container_of(ip, struct acpihp_dev_node, node);
+		acpi_dev = container_of(np->dev, struct acpi_device, dev);
+		if (np->state == state && post == ACPIHP_DEV_POST_CMD_ROLLBACK)
+			continue;
+
+		result = acpihp_drv_invoke_method(opcode, slot, acpi_dev, post);
+		if (result)
+			retval = -EIO;
+		else if (post == ACPIHP_DEV_POST_CMD_ROLLBACK)
+			acpihp_drv_update_dev_state(np, state);
+	}
+	klist_iter_exit(&iter);
+
+	return retval;
+}
+
+static int acpihp_drv_walk_devs(struct list_head *slot_list,
+				enum config_op_code opcode,
+				enum acpihp_dev_state state,
+				bool reverse)
+{
+	int i, retval = 0;
+	enum acpihp_dev_type *tp;
+	struct acpihp_slot_dependency *dep;
+	int count = ARRAY_SIZE(acpihp_drv_dev_types);
+
+	tp = reverse ? acpihp_drv_dev_types_reverse : acpihp_drv_dev_types;
+	for (i = 0; i < count; i++)
+		list_for_each_entry(dep, slot_list, node) {
+			retval = acpihp_drv_call_method(opcode, dep->slot,
+							tp[i], state);
+			if (retval)
+				return retval;
+		}
+
+	return 0;
+}
+
+static void acpihp_drv_walk_devs_post(struct list_head *slot_list,
+				      enum config_op_code opcode,
+				      enum acpihp_dev_state state,
+				      enum acpihp_dev_post_cmd post,
+				      bool reverse)
+{
+	int i;
+	enum acpihp_dev_type *tp;
+	struct acpihp_slot_dependency *dep;
+	int count = ARRAY_SIZE(acpihp_drv_dev_types);
+
+	tp = reverse ? acpihp_drv_dev_types_reverse : acpihp_drv_dev_types;
+	for (i = 0; i < count; i++)
+		list_for_each_entry(dep, slot_list, node)
+			if (acpihp_drv_call_method_post(opcode, dep->slot,
+							tp[i], state, post))
+				ACPIHP_SLOT_WARN(dep->slot,
+					"fails to commit or rollback.\n");
+}
+
+static void acpihp_drv_sync_cancel(struct list_head *list, int result)
+{
+	int cancel;
+	struct acpihp_slot_dependency *dep;
+
+	if (!result)
+		cancel = ACPIHP_DRV_CANCEL_MISSED;
+	else if (result == -ECANCELED)
+		cancel = ACPIHP_DRV_CANCEL_OK;
+	else
+		cancel = ACPIHP_DRV_CANCEL_FAILED;
+	list_for_each_entry(dep, list, node) {
+		acpihp_drv_cancel_notify(dep->slot, cancel);
+		acpihp_drv_update_slot_state(dep->slot);
+	}
+}
+
+/*
+ * To support better error recover and cancellation, configure operations
+ * are splitted into three steps:
+ * 1) pre_configure(): allocate required resources
+ * 2) configure(): add devices into system
+ * 3) post_configure(): rollback if cancelled or failed to add devices
+ */
+int acpihp_drv_configure(struct list_head *list)
+{
+	int result;
+	struct list_head head;
+	struct acpihp_slot_dependency *dep;
+	enum acpihp_dev_post_cmd post = ACPIHP_DEV_POST_CMD_COMMIT;
+
+	result = acpihp_drv_filter_dependency_list(list, &head,
+						   ACPIHP_DRV_CMD_CONFIGURE);
+	if (result) {
+		ACPIHP_DEBUG("fails to filter dependency list.\n");
+		return -ENOMEM;
+	}
+
+	list_for_each_entry(dep, &head, node)
+		acpihp_slot_change_state(dep->slot,
+					 ACPIHP_SLOT_STATE_CONFIGURING);
+
+	result = acpihp_drv_walk_devs(&head, DRV_OP_PRE_CONFIGURE,
+				      DEVICE_STATE_PRE_CONFIGURE, false);
+	if (!result)
+		result = acpihp_drv_walk_devs(&head, DRV_OP_CONFIGURE,
+					      DEVICE_STATE_CONFIGURED, false);
+	if (result)
+		post = ACPIHP_DEV_POST_CMD_ROLLBACK;
+	acpihp_drv_walk_devs_post(&head, DRV_OP_POST_CONFIGURE,
+				  DEVICE_STATE_CONNECTED, post, false);
+
+	list_for_each_entry(dep, &head, node)
+		acpihp_drv_update_slot_state(dep->slot);
+	acpihp_drv_sync_cancel(&head, result);
+	acpihp_drv_destroy_dependency_list(&head);
+
+	return result;
+}
+
+static int acpihp_drv_release(struct list_head *list)
+{
+	int result;
+	enum acpihp_dev_post_cmd post = ACPIHP_DEV_POST_CMD_COMMIT;
+
+	result = acpihp_drv_walk_devs(list, DRV_OP_PRE_RELEASE,
+				      DEVICE_STATE_PRE_RELEASE, true);
+	if (!result)
+		result = acpihp_drv_walk_devs(list, DRV_OP_RELEASE,
+					      DEVICE_STATE_RELEASED, true);
+	if (result)
+		post = ACPIHP_DEV_POST_CMD_ROLLBACK;
+	acpihp_drv_walk_devs_post(list, DRV_OP_POST_RELEASE,
+				  DEVICE_STATE_CONFIGURED, post, true);
+	acpihp_drv_sync_cancel(list, result);
+
+	return result;
+}
+
+static void __acpihp_drv_unconfigure(struct list_head *list)
+{
+	int result;
+
+	result = acpihp_drv_walk_devs(list, DRV_OP_PRE_UNCONFIGURE,
+				      DEVICE_STATE_PRE_UNCONFIGURE, true);
+	BUG_ON(result);
+	result = acpihp_drv_walk_devs(list, DRV_OP_UNCONFIGURE,
+				      DEVICE_STATE_CONNECTED, true);
+	BUG_ON(result);
+	result = acpihp_drv_walk_devs(list, DRV_OP_POST_UNCONFIGURE,
+				      DEVICE_STATE_CONNECTED, true);
+	BUG_ON(result);
+}
+
+/*
+ * To support better error recover and cancellation, unconfigure operations
+ * are splitted into three steps:
+ * 1) pre_release(): optional
+ * 2) release(): reclaim devices from system
+ * 3) post_release(): rollback if cancelled or failed to reclaim devices
+ * 4) pre_unconfigure(): optional
+ * 5) unconfigure(): remove devices from system
+ * 6) post_unconfigure(): free resources used by devices
+ */
+int acpihp_drv_unconfigure(struct list_head *list)
+{
+	int result;
+	struct list_head head;
+	struct acpihp_slot_dependency *dep;
+
+	result = acpihp_drv_filter_dependency_list(list, &head,
+						   ACPIHP_DRV_CMD_UNCONFIGURE);
+	if (result) {
+		ACPIHP_DEBUG("fails to filter dependency list.\n");
+		return -ENOMEM;
+	}
+
+	list_for_each_entry(dep, &head, node)
+		acpihp_slot_change_state(dep->slot,
+					 ACPIHP_SLOT_STATE_UNCONFIGURING);
+
+	result = acpihp_drv_release(&head);
+	if (!result)
+		__acpihp_drv_unconfigure(&head);
+
+	list_for_each_entry(dep, &head, node)
+		acpihp_drv_update_slot_state(dep->slot);
+
+	acpihp_drv_destroy_dependency_list(&head);
+
+	return result;
+}
-- 
1.7.9.5

